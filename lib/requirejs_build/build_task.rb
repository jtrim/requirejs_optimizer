require 'fileutils'
require 'zlib'
require 'sprockets'
require 'rake/tasklib'

module RequirejsBuild

  class BuildTask < ::Rake::TaskLib
    include ::Rake::DSL

    def initialize(name="requirejs")
      @name = name
    end

    def define_task
      define_task_deply

      namespace :assets do
        namespace :precompile do
          task :nondigest do
            invoke_or_reboot_rake_task @name
          end
        end
      end
    end

    private

    def invoke_or_reboot_rake_task(task)
      if ENV['RAILS_GROUPS'].to_s.empty? || ENV['RAILS_ENV'].to_s.empty?
        ruby_rake_task task
      else
        Rake::Task[task].invoke
      end
    end

    def define_task_deply(current_name=@name)
      current, *rest = *current_name.split(":")

      if rest.any?
        namespace(current) { define_task_deply rest.join(":") }
      else
        desc "Make a require.js build using the r.js optimization tool"
        task(current) { perform_requirejs_build }
      end

    end

    def perform_requirejs_build
      config = Rails.application.config
      assets = Rails.application.assets

      # clean
      FileUtils.rm_rf Rails.root.join('tmp', 'assets')

      # prepare
      FileUtils.cp_r File.join(Rails.public_path, config.assets.prefix), Rails.root.join('tmp')
      # should remove digested and gzipped files here

      # build
      result = system("node bin/r.js -o config/require.build.js")

      if result
        build_dir = Rails.root.join('tmp', 'assets', 'build')

        # Remove all gzipped files (prepare)
        Dir[build_dir.join('**', '*.gz')].each { |gzf| FileUtils.rm gzf }

        files = Dir[build_dir.join('**', '*.{js,css}')]

        # manifest
        open build_dir.join("manifest.yml"), "w" do |manifest|
          files.each do |f|
            file_is_digest = f =~ /-[0-9a-f]{32}/

              if file_is_digest
                # should do this in prepare
                FileUtils.rm f
              else

                # write digest
                # Surely sprockets has some built-in facility for this.
                d = Digest::MD5.new
                d.update(Sprockets::VERSION)
                d.update(Rails.application.config.assets.version)

                digest = d.dup.update(IO.read(f)).hexdigest
                new_f = f.gsub(/\.(js|css)$/) { "-#{digest}.#{$1}" }
                FileUtils.cp f, new_f

                # write gzip
                Zlib::GzipWriter.open("#{new_f}.gz") { |gz| gz.write(File.read(new_f)) }

                # write manifest entry
                manifest_entry = ""
                manifest_entry << f.gsub(/#{build_dir}\/?/, '')
                  manifest_entry << ": "
                manifest_entry << new_f.gsub(/#{build_dir}\/?/, '')
                  manifest.puts manifest_entry
              end
          end
        end

        puts "Copying compiled assets into place"
        public_assets_path = Rails.root.join 'public', config.assets.prefix.gsub(/^\//, '')
        FileUtils.rm_rf public_assets_path
        FileUtils.cp_r Rails.root.join('tmp', 'assets', 'build'), public_assets_path
      end

    end

  end

end
