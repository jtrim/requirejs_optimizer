module RequirejsBuild

  module Step

    class Prepare < Base

      def perform(*)
        # Copy build directory into place
        FileUtils.cp_r Rails.root.join('public', 'assets').to_s, RequirejsBuild.build_dir.to_s

        remove_gzipped_files
        remove_digestified_files
      end

      private

      def remove_gzipped_files
        FileUtils.rm RequirejsBuild.build_files("*.gz")
      end

      def remove_digestified_files
        RequirejsBuild.build_files.each do |f|
          file_is_digestified = f =~ /-[0-9a-f]{32}\./
          FileUtils.rm(f) if file_is_digestified
        end
      end

    end

  end

end
