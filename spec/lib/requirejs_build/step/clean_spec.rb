require 'spec_helper'

module RequirejsBuild

  module Step

    describe Clean do

      describe '#perform' do

        it 'removes the temporary build directory' do
          RequirejsBuild.stub(:build_dir).and_return("foo")
          FileUtils.should_receive(:rm_r).with('foo')
          Clean.new.perform
        end

      end

    end

  end

end
