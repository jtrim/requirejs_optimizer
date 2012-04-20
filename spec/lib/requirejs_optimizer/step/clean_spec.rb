require 'spec_helper'

module RequirejsOptimizer

  module Step

    describe Clean do

      describe '#perform' do

        it 'removes the temporary build directory' do
          RequirejsOptimizer.stub(:build_dir).and_return("foo")
          FileUtils.should_receive(:rm_rf).with('foo')
          Clean.new.perform
        end

      end

    end

  end

end
