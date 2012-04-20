require 'spec_helper'

module RequirejsBuild

  module Step

    describe Optimize do

      describe "#perform" do

        before { subject.stub(:node_exists).and_return(true) }

        it "raises an error if node is missing" do
          subject.stub(:node_exists?).and_return(false)
          expect {
            subject.perform
          }.to raise_error RequirejsBuild::Errors::NodeUnavailable
        end

        describe "optimization" do

          context "when unsuccessful" do

            before { subject.stub(:optimize).and_return(false) }

            it "raises an error" do
              expect {
                subject.perform
              }.to raise_error RequirejsBuild::Errors::RjsOptimizationFailed
            end

          end

        end

      end

    end

  end

end
