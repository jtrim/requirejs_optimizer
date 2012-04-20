module RequirejsBuild

  module Step

    class Clean < Base

      def perform(*)
        FileUtils.rm_r RequirejsBuild.build_dir
      end

    end

  end

end
