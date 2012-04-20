require 'spec_helper'

describe RequirejsOptimizer do

  describe 'module attributes' do

    before do
      RequirejsOptimizer.build_dir = "tmp/foo"
    end

    its(:build_dir) { should == Rails.root.join("tmp/foo") }

    describe "build_dir" do

      it "should be `tmp/assets` by default" do
        RequirejsOptimizer.build_dir = nil
        RequirejsOptimizer.build_dir.should == Rails.root.join("tmp/assets")
      end

    end

  end

end
