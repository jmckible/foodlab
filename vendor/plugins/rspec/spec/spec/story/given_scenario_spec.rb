require File.dirname(__FILE__) + '/story_helper'

module Spec
  module Story
    describe GivenScenario do
      it 'should execute a scenario from the current story in its world' do
        # given
        class MyWorld
          attr :scenario_ran
        end
        instance = MyWorld.new
        scenario = ScenarioBuilder.new.to_scenario do
          @scenario_ran = true
        end
        Runner::StoryRunner.should_receive(:scenario_from_current_story).with('scenario name').and_return(scenario)
        
        step = GivenScenario.new 'scenario name'
        
        # when
        step.perform(instance, nil)
        
        # then
        ensure_that instance.scenario_ran, is(true)
      end
    end
  end
end
