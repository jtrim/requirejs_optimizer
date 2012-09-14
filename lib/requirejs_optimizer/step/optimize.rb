module RequirejsOptimizer

  module Step

    class Optimize < Base

      def perform(*)
        raise RequirejsOptimizer::Errors::RjsOptimizationFailed unless optimize
      end

      private

      def optimize
        if node_exists?
          system("node #{RequirejsOptimizer.root.join 'bin', 'r.js'} -o app/assets/javascripts/modules/require.build.js")
        elsif java_exists?
          system("java -classpath #{RequirejsOptimizer.root.join 'lib', 'js-14.jar'}:#{RequirejsOptimizer.root.join 'lib', 'compiler.jar'} org.mozilla.javascript.tools.shell.Main #{RequirejsOptimizer.root.join 'bin', 'r.js'} -o app/assets/javascripts/modules/require.build.js")
        else
          raise RequirejsOptimizer::Errors::JavaScriptRuntimeUnavailable
        end
      end

      def node_exists?
        system("which node 2>&1 > /dev/null")
      end

      def java_exists?
        system("which java 2>&1 > /dev/null")
      end

    end

  end

end
