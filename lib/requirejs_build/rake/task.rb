require 'zlib'
require 'rake/tasklib'

module RequirejsBuild
  class Rake::Task < ::Rake::TaskLib
    include ::Rake::DSL
    include ::RequirejsBuild::Rake::Utils

    attr_accessor :name

    def initialize(name="requirejs")
      @name = name
    end

    def define_tasks
      define_task_deeply(name, "Optimize assets using the r.js optimization tool") { default_build.run }
      define_task_deeply "#{name}:clean", "Remove the temp build directory (tmp/assets by default)", &Step::Clean.new
      define_task_deeply("assets:precompile:nondigest") { invoke_or_reboot_rake_task @name }
    end

    private

    def default_build
      RequirejsBuild::Build.new \
        RequirejsBuild::Step::Clean,
        RequirejsBuild::Step::Prepare,
        RequirejsBuild::Step::Optimize,
        RequirejsBuild::Step::Digestify,
        RequirejsBuild::Step::Compress,
        RequirejsBuild::Step::Manifest,
        RequirejsBuild::Step::Finalize
    end

  end

end
