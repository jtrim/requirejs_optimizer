require 'zlib'
require 'rake/tasklib'

module RequirejsOptimizer
  class Rake::Task < ::Rake::TaskLib
    include ::Rake::DSL
    include ::RequirejsOptimizer::Rake::Utils

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
      RequirejsOptimizer::Build.new \
        RequirejsOptimizer::Step::Clean,
        RequirejsOptimizer::Step::Prepare,
        RequirejsOptimizer::Step::Optimize,
        RequirejsOptimizer::Step::Digestify,
        RequirejsOptimizer::Step::Compress,
        RequirejsOptimizer::Step::Manifest,
        RequirejsOptimizer::Step::Finalize
    end

  end

end
