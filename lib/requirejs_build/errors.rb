module RequirejsBuild

  module Errors

    # Raised if the node.js executable is unavailable
    #
    class NodeUnavailable < RuntimeError
      def message
        "Node wasn't found. Make sure the node executable is available somewhere in PATH"
      end
    end

    class RjsOptimizationFailed < RuntimeError
      def message
        "R.js optimization failed. See STDOUT for details"
      end
    end

  end

end
