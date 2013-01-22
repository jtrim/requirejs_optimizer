require 'spec_helper'

module RequirejsOptimizer

  module Step

    describe Optimize do

      describe "#perform" do

        before { subject.stub(:node_exists).and_return(true) }

        it "raises an error if no javascript runtime is available" do
          subject.stub(:node_exists?).and_return(false)
          subject.stub(:java_exists?).and_return(false)
          expect {
            subject.perform
          }.to raise_error RequirejsOptimizer::Errors::JavaScriptRuntimeUnavailable
        end


        it "defaults to node if node is avilable" do
          subject.stub(:node_exists?).and_return(true)
          subject.stub(:java_exists?).and_return(true)

          subject.should_receive(:system).with(/^node/).and_return(true)
          subject.perform
        end

        it "uses rhino if rhino if available and node is not" do
          subject.stub(:node_exists?).and_return(false)
          subject.stub(:java_exists?).and_return(true)

          subject.should_receive(:system).with(/^java/).and_return(true)
          subject.perform
        end

        it "uses node if configured to do so" do
          Rails.configuration.stub(:requirejs_optimizer_runtime).and_return(:node)
          subject.should_receive(:system).with(/^node/).and_return(true)

          subject.perform
        end

        it "uses rhino if configured to do so" do
          Rails.configuration.stub(:requirejs_optimizer_runtime).and_return(:rhino)
          subject.should_receive(:system).with(/^java/).and_return(true)

          subject.perform
        end

        it "uses java opts if given and we're using rhino" do
          Rails.configuration.stub(:requirejs_optimizer_runtime).and_return(:rhino)
          Rails.configuration.stub(:requirejs_optimizer_java_opts).and_return('-Xmx1024m')

          subject.should_receive(:system).with(/^java -Xmx1024m/).and_return(true)

          subject.perform
        end


        it "raises an error if misconfigured" do
          Rails.configuration.stub(:requirejs_optimizer_runtime).and_return(:asdfasdf)

          expect {
            subject.perform
          }.to raise_error RequirejsOptimizer::Errors::UnknownJavaScriptRuntime
        end

        describe "optimization" do

          context "when unsuccessful" do

            before { subject.stub(:optimize).and_return(false) }

            it "raises an error" do
              expect {
                subject.perform
              }.to raise_error RequirejsOptimizer::Errors::RjsOptimizationFailed
            end

          end

        end

      end

    end

  end

end
