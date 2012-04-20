require 'spec_helper'

module RequirejsOptimizer

  module Step

    describe Compress do

      describe "#perform" do

        it "creates gzipped files for all js/css files" do
          Dir.should_receive(:glob).with(target_path_for("**", "*.{js,css}")).and_return(%w(file.css file-0123456789abcdef0123456789abcdef.css img.png))
          subject.should_receive(:gzip_file).with('file-0123456789abcdef0123456789abcdef.css')
          subject.should_receive(:gzip_file).with('file.css')
          subject.should_receive(:gzip_file).with('img.png')

          subject.perform
        end

      end

    end

  end

end
