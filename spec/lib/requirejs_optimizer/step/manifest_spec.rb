require 'spec_helper'

module RequirejsOptimizer

  module Step

    describe Manifest do

      before do
        # disconnect IO
        subject.stub(:write_manifest)
      end

      describe '#perform' do

        before do
          Dir.should_receive(:glob).with(target_path_for("**", "*.*")).and_return(%w(file.css file-0123456789abcdef0123456789abcdef.css other/file.js other/file-0123456789abcdef0123456789abcdef.js))
        end

        it "properly generates manifest entries" do
          subject.should_receive(:manifest_entry_for).once.with('file-0123456789abcdef0123456789abcdef.css')
          subject.should_receive(:manifest_entry_for).once.with('other/file-0123456789abcdef0123456789abcdef.js')
          subject.perform
        end

        it "writes the manifest file to the appropriate place" do
          subject.should_receive(:write_manifest).with("file.css: file-0123456789abcdef0123456789abcdef.css\nother/file.js: other/file-0123456789abcdef0123456789abcdef.js")
          subject.perform
        end

      end

    end

  end

end
