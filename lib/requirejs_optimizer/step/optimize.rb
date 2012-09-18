module RequirejsOptimizer

  module Step

    class Optimize < Base

      def perform(*)
        raise RequirejsOptimizer::Errors::RjsOptimizationFailed unless optimize
      end

      private

      def optimize
        system("#{runtime_cmdline} #{RequirejsOptimizer.root.join 'bin', 'r.js'} -o app/assets/javascripts/modules/require.build.js")
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

        if runtime == :node
          "node"
        else
          "java -classpath #{RequirejsOptimizer.root.join 'lib', 'js-14.jar'}:#{RequirejsOptimizer.root.join 'lib', 'compiler.jar'} org.mozilla.javascript.tools.shell.Main"
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
