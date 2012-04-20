module RequirejsOptimizer

  module Step

    class Clean < Base

      def perform(*)
        FileUtils.rm_r RequirejsOptimizer.build_dir
      end

    end

  end

end
