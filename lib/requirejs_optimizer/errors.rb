module RequirejsOptimizer

  module Errors

    # Raised if the node.js executable is unavailable
    #
    class JavaScriptRuntimeUnavailable < RuntimeError
      def message
        "Node or Java wasn't found. Make sure the node or java executable is available somewhere in PATH"
      end
    end

    class UnknownJavaScriptRuntime < RuntimeError
      def initialize(runtime)
        @runtime = runtime
      end

      def message
        "Unknown runtime: #{@runtime}.  Available runtimes: 'node' or 'rhino'"
      end
    end

    class RjsOptimizationFailed < RuntimeError
      def message
        "R.js optimization failed. See STDOUT for details"
      end
    end

  end

end
