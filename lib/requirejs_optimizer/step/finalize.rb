module RequirejsOptimizer

  module Step

    class Finalize < Base

      def perform(*)
        FileUtils.rm_r(Rails.root.join("public/assets"))
        FileUtils.cp_r(RequirejsOptimizer.target_dir.to_s, Rails.root.join("public/assets"))
      end

    end

  end

end
