module RequirejsOptimizer

  module Step

    class Clean < Base

      def perform(*)
        FileUtils.rm_rf RequirejsOptimizer.build_dir
      end

    end

  end

end
