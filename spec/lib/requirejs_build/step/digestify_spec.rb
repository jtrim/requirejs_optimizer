require 'spec_helper'

module RequirejsBuild

  module Step

    describe Digestify do

      before do
        # Disconnect fileutils
        FileUtils.stub(:cp)
        Rails.application.assets.stub(:file_digest).and_return(stub(hexdigest: 'abcdefg'))
      end

      describe "#initialize" do

        subject { Digestify }

        context "when assets have already been initialized" do
          before { Rails.application.stub(:assets).and_return("present") }

          it "doesn't re-initialize assets" do
            Rails.application.should_not_receive(:initialize!)
            subject.new
          end
        end

        context "when assets haven't yet been initialized" do
          before { Rails.application.stub(:assets).and_return(nil) }

          it "initializes assets" do
            Rails.application.should_receive(:initialize!).with(:assets)
            subject.new
          end
        end

      end

      describe '#perform' do

        it "makes digestified versions of all js and css files" do
          Dir.should_receive(:glob).with(target_path_for("**", "*.*")).and_return(%w(file.css file.js file.png))
          subject.should_receive(:digestify_file).once.with("file.css")
          subject.should_receive(:digestify_file).once.with("file.js")
          subject.should_receive(:digestify_file).once.with("file.png")
          subject.perform
        end

      end

      describe '#digestify_file' do

        it "copies a digested file into place" do
          FileUtils.should_receive(:cp).with("foo.css", "foo-abcdefg.css")
          subject.digestify_file("foo.css")

          FileUtils.should_receive(:cp).with("foo.js", "foo-abcdefg.js")
          subject.digestify_file("foo.js")

          FileUtils.should_receive(:cp).with("foo.png", "foo-abcdefg.png")
          subject.digestify_file("foo.png")
        end

      end

    end

  end

end
