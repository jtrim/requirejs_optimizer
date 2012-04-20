module RequirejsBuild

  module Step

    class Optimize < Base

      def perform(*)
        raise RequirejsBuild::Errors::NodeUnavailable unless node_exists?
        raise RequirejsBuild::Errors::RjsOptimizationFailed unless optimize
      end

      private

      def optimize
        system("node #{RequirejsBuild.root.join 'bin', 'r.js'} -o app/assets/javascripts/modules/require.build.js")
      end

      def node_exists?
        system("which node 2>&1 > /dev/null")
      end

    end

  end

end
