module RequirejsOptimizer

  module Step

    class Base

      def perform(*)
        raise NotImplementedError
      end

      def to_proc
        self.method(:perform).to_proc
      end

    end

  end

end
