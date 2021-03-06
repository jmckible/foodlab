module Spec
  module DSL
    class Example < ::Test::Unit::TestCase
      remove_method :default_test if respond_to?(:default_test)

      class << self
        include Behaviour
        def inherited(klass)
          super
          unless klass.name.to_s == ""
            klass.describe(klass.name)
            klass.register
          end
        end

        def suite
          description = description ? description.description : "Rspec Description Suite"
          include_example_modules
          suite = ExampleSuite.new(description, self)
          ordered_example_definitions.each do |example_definition|
            suite << new(example_definition)
          end
          instance_methods.each do |method_name|
            if method_name =~ /^test./ && (
              instance_method(method_name).arity == 0 ||
              instance_method(method_name).arity == -1
            )
              example_definition = ExampleDefinition.new(method_name) do
                __send__ method_name
              end
              suite << new(example_definition)
            end
          end
          suite
        end

        # Sets the #number on each ExampleDefinition and returns the next number
        def set_sequence_numbers(number) #:nodoc:
          ordered_example_definitions.each do |example_definition|
            example_definition.number = number
            number += 1
          end
          number
        end

        def register
          rspec_options.add_behaviour self
        end

        protected

        def ordered_example_definitions
          rspec_options.reverse ? example_definitions.reverse : example_definitions
        end

        def plugin_mock_framework
          case mock_framework = Spec::Runner.configuration.mock_framework
          when Module
            include mock_framework
          else
            require Spec::Runner.configuration.mock_framework
            include Spec::Plugins::MockFramework
          end
        end

        def include_example_modules
          Spec::Runner.configuration.modules_for(behaviour_type).each do |mod|
            include mod
          end
        end

        def define_predicate_matchers(definitions) # :nodoc:
          definitions.each_pair do |matcher_method, method_on_object|
            define_method matcher_method do |*args|
              eval("be_#{method_on_object.to_s.gsub('?','')}(*args)")
            end
          end
        end
      end

      include ::Spec::Matchers
      include ::Spec::DSL::Pending

      attr_reader :rspec_behaviour, :rspec_definition
      alias_method :behaviour, :rspec_behaviour
      alias_method :definition, :rspec_definition

      def initialize(definition) #:nodoc:
        @rspec_behaviour = self.class
        @rspec_definition = definition
        @_result = ::Test::Unit::TestResult.new

        behaviour_type = behaviour_type
        predicate_matchers = @rspec_behaviour.predicate_matchers
        (class << self; self; end).class_eval do
          plugin_mock_framework
          define_predicate_matchers predicate_matchers
          define_predicate_matchers(Spec::Runner.configuration.predicate_matchers)
        end
      end

      def violated(message="")
        raise Spec::Expectations::ExpectationNotMetError.new(message)
      end

      def copy_instance_variables_from(obj)
        super(obj, [:@rspec_definition, :@rspec_behaviour, :@_result])
      end

      def before_each
        run_before_parts Example.before_each_parts
        if behaviour_type
          run_before_parts BehaviourFactory.get!(behaviour_type).before_each_parts
        end
        run_before_parts rspec_behaviour.before_each_parts
      end

      def before_all
        run_before_parts Example.before_all_parts
        if behaviour_type
          run_before_parts BehaviourFactory.get!(behaviour_type).before_all_parts
        end
        run_before_parts rspec_behaviour.before_all_parts
      end

      def after_all
        exception = nil
        exception = run_after_parts(exception, rspec_behaviour.after_all_parts)
        if behaviour_type
          exception = run_after_parts(exception, BehaviourFactory.get!(behaviour_type).after_all_parts)
        end
        exception = run_after_parts(exception, Example.after_all_parts)
        raise exception if exception
      end

      def after_each
        exception = nil
        exception = run_after_parts(exception, rspec_behaviour.after_each_parts)
        if behaviour_type
          exception = run_after_parts(exception, BehaviourFactory.get!(behaviour_type).after_each_parts)
        end
        exception = run_after_parts(exception, Example.after_each_parts)
        raise exception if exception
      end

      def run_example
        self.instance_eval(&rspec_definition.example_block)
      end

      protected
      def run_before_parts(parts)
        parts.each do |part|
          self.instance_eval(&part)
        end
      end

      def run_after_parts(original_exception, parts)
        new_exception = nil
        parts.each do |part|
          begin
            self.instance_eval(&part)
          rescue Exception => e
            new_exception ||= e
          end
        end
        return original_exception || new_exception
      end

      def behaviour_type
        @rspec_behaviour.behaviour_type
      end
    end
  end
end
