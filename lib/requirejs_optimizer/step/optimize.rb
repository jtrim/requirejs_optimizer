module RequirejsOptimizer

  module Step

    class Optimize < Base

      def perform(*)
        raise RequirejsOptimizer::Errors::RjsOptimizationFailed unless optimize
      end

      private

      def optimize
        optimize_command = "#{runtime_cmdline} #{RequirejsOptimizer.root.join 'bin', 'r.js'} -o app/assets/javascripts/modules/require.build.js"
        puts optimize_command
        puts "\n"
        system(optimize_command)
      end

      def runtime_cmdline
        runtime = rails_runtime if defined? Rails

        if runtime.nil?
          if node_exists?
            runtime = :node
          elsif java_exists?
            runtime = :rhino
          else
            raise RequirejsOptimizer::Errors::JavaScriptRuntimeUnavailable
          end
        end

        puts "\nOptimizing with #{runtime} using:"

        if runtime == :node
          "node"
        else
          js = RequirejsOptimizer.root.join 'lib', 'rhino', 'js.jar'
          compiler = RequirejsOptimizer.root.join 'lib', 'closure', 'compiler.jar'

          "java -classpath #{js}:#{compiler} org.mozilla.javascript.tools.shell.Main"
        end

      end

      def node_exists?
        system("which node 2>&1 > /dev/null")
      end

      def java_exists?
        system("which java 2>&1 > /dev/null")
      end

      def rails_runtime
        if Rails.configuration.respond_to? :requirejs_optimizer_runtime
          runtime = Rails.configuration.requirejs_optimizer_runtime.to_sym

          if ([:rhino, :node] & [runtime]).none?
            raise RequirejsOptimizer::Errors::UnknownJavaScriptRuntime.new runtime
          end
        end

        runtime
      end

    end

  end

end
