module RequirejsOptimizer

  module Step

    class Digestify < Base

      def initialize
        Rails.application.initialize!(:assets) unless Rails.application.assets.present?
      end

      def perform(*)
        RequirejsOptimizer.target_files.each do |f|
          digestify_file f
        end
      end

      def digestify_file(path)
        digest = Rails.application.assets.file_digest(path).hexdigest
        new_path = path.gsub(/\.([^\.]*)$/) { "-#{digest}.#{$1}" }
        FileUtils.cp(path, new_path)
      end

    end

  end

end
