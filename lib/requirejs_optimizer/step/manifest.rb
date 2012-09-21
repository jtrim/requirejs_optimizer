module RequirejsOptimizer

  module Step

    class Manifest < Base

      def perform(*)
        manifest_entries = RequirejsOptimizer.target_files.map do |f|
          file_is_digestified = f =~ /-[0-9a-f]{32}\./
          manifest_entry_for f if file_is_digestified
        end
        write_manifest manifest_entries.compact.join("\n")
      end

      private

      def manifest_entry_for(file_at_path)
        path_to_remove = RequirejsOptimizer.target_dir.to_s.gsub(/(\/)?$/) { $1 || '/' }
        nondigest, digest = file_at_path.gsub(/-[0-9a-f]{32}\./, '.').gsub(/^#{path_to_remove}/, ''), file_at_path.gsub(/^#{path_to_remove}/, '')
        "#{nondigest}: #{digest}"
      end

      def write_manifest(contents)
        open("#{RequirejsOptimizer.target_dir.to_s}/manifest.yml", "w") { |f| f.write contents }
      end

    end

  end

end
