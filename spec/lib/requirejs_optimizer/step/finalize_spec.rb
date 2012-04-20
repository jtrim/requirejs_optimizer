require 'spec_helper'

module RequirejsOptimizer

  module Step

    describe Finalize do

      before do
        # disconnect file system modifications
        FileUtils.stub(:rm_r)
        FileUtils.stub(:cp_r)
      end

      describe '#perform' do

        it "removes the current public/assets directory" do
          FileUtils.should_receive(:rm_r).with(Rails.root.join("public/assets"))
          subject.perform
        end

        it "copies the build target to public/assets" do
          FileUtils.should_receive(:cp_r).with(RequirejsOptimizer.target_dir.to_s, Rails.root.join("public", "assets"))
          subject.perform
        end

      end

    end

  end

end
