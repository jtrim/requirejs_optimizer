module RequirejsBuild

  module Step

    class Manifest < Base

      def perform(*)
        manifest_entries = RequirejsBuild.target_files.map do |f|
          file_is_digestified = f =~ /-[0-9a-f]{32}\./
          manifest_entry_for f if file_is_digestified
        end
        write_manifest manifest_entries.compact.join("\n")
      end

      private

      def manifest_entry_for(file_at_path)
        path_to_remove = RequirejsBuild.target_dir.to_s.gsub(/(\/)?$/) { $1 || '/' }
        nondigest, digest = file_at_path.gsub(/-[0-9a-f]{32}\./, '.').gsub(/^#{path_to_remove}/, ''), file_at_path.gsub(/^#{path_to_remove}/, '')
        "#{nondigest}: #{digest}"
      end

      def write_manifest(contents)
        IO.write(RequirejsBuild.target_dir.join("manifest.yml"), contents)
      end

    end

  end

end
