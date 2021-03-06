module Spec
  module Story
    module Runner

      class StoryMediator
        def initialize(matchers, runner)
          @matchers = matchers
          @story_parts = []
          @runner = runner
        end
        
        def stories
          @story_parts.collect { |p| p.to_proc }
        end
        
        def create_story(title, narrative)
          @story_parts << StoryPart.new(title, narrative, @matchers)
        end
        
        def create_scenario(title)
          current_story_part.add_scenario ScenarioPart.new(title)
        end
        
        def create_given(name)
          current_scenario_part.add_step StepPart.new(:given, name, @matchers)
        end
        
        def create_when(name)
          current_scenario_part.add_step StepPart.new(:when, name, @matchers)
        end
        
        def create_then(name)
          current_scenario_part.add_step StepPart.new(:then, name, @matchers)
        end
        
        def run_stories
          stories.each { |story| @runner.instance_eval(&story) }
        end
        
        private
        def current_story_part
          @story_parts.last
        end
        
        def current_scenario_part
          current_story_part.current_scenario_part
        end
        
        class StoryPart
          def initialize(title, narrative, matchers)
            @title = title
            @narrative = narrative
            @scenarios = []
            @matchers = matchers
          end
          
          def to_proc
            title = @title
            narrative = @narrative
            scenarios = @scenarios.collect { |scenario| scenario.to_proc }
            matchers = @matchers
            lambda do
              Story title, narrative, :step_matchers => matchers do
                scenarios.each { |scenario| instance_eval(&scenario) }
              end
            end
          end
          
          def add_scenario(scenario)
            @scenarios << scenario
          end
          
          def current_scenario_part
            @scenarios.last
          end
        end
        
        class ScenarioPart
          def initialize(name)
            @name = name
            @steps = []
          end
          
          def to_proc
            name = @name
            steps = @steps.collect { |s| s.to_proc }
            lambda do
              Scenario name do
                steps.each { |s| instance_eval(&s) }
              end
            end
          end
          
          def add_step(s)
            @steps << s
          end
        end
        
        class StepPart
          def initialize(type, name, matchers)
            @type = type
            @name = name
            @matchers = matchers
          end
          
          def to_proc
            type = @type.to_s.capitalize
            name = @name
            lambda do
              send(type, name)
            end
          end
        end
      end
      
    end
  end
end
