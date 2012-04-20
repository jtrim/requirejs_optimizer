require 'spec_helper'

describe RequirejsBuild do

  describe 'module attributes' do

    before do
      RequirejsBuild.build_dir = "tmp/foo"
    end

    its(:build_dir) { should == Rails.root.join("tmp/foo") }

    describe "build_dir" do

      it "should be `tmp/assets` by default" do
        RequirejsBuild.build_dir = nil
        RequirejsBuild.build_dir.should == Rails.root.join("tmp/assets")
      end

    end

  end

end
