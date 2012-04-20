module RequirejsBuild

  module Step

    class Compress < Base

      def perform(*)
        RequirejsBuild.target_files("*.{js,css}").each do |f|
          gzip_file f
        end
      end

      def gzip_file(path)
        Zlib::GzipWriter.open("#{path}.gz") { |gz| gz.write(File.read(path)) }
      end

    end

  end

end
