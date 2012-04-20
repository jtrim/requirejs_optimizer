require 'spec_helper'

module RequirejsOptimizer

  module Step

    describe Prepare do

      describe '#perform' do

        before do
          # Disconnect all the fileutils stuff
          FileUtils.stub(:cp_r)
          FileUtils.stub(:rm)
        end

        describe "build directory preparation" do

          before do
            RequirejsOptimizer.stub(:build_dir).and_return(Pathname.new("foo"))
            Rails.stub(:root).and_return Pathname.new("root")
          end

          it "copies public/assets to the build dir" do
            FileUtils.should_receive(:cp_r).with("root/public/assets", "foo")
            subject.perform
          end

        end

        it "removes digestified js and css files" do
          subject.stub(:remove_gzipped_files)

          Dir.should_receive(:glob).with(build_path_for("**", "*.*")).and_return(%w(file.css file-0123456789abcdef0123456789abcdef.css))
          FileUtils.should_receive(:rm).with "file-0123456789abcdef0123456789abcdef.css"
          subject.perform
        end

        it "removes gzipped files" do
          subject.stub(:remove_digestified_files)

          Dir.stub(:glob).with(build_path_for("**", "*.gz")).and_return ["thing"]
          FileUtils.should_receive(:rm).with ["thing"]
          subject.perform
        end

      end

    end

  end

end
