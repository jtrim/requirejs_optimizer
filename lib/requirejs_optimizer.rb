require 'sprockets'
require 'fileutils'

require "requirejs_optimizer/errors"
require "requirejs_optimizer/step/base"
require "requirejs_optimizer/step/clean"
require "requirejs_optimizer/step/compress"
require "requirejs_optimizer/step/digestify"
require "requirejs_optimizer/step/finalize"
require "requirejs_optimizer/step/manifest"
require "requirejs_optimizer/step/optimize"
require "requirejs_optimizer/step/prepare"

require "requirejs_optimizer/build"
require "requirejs_optimizer/rake/utils"
require "requirejs_optimizer/rake/task"

require "requirejs_optimizer/version"

module RequirejsOptimizer

  # The gem root
  #
  def self.root
    Pathname.new(File.expand_path("../..", __FILE__))
  end

  # Set the build dir to something other than tmp/assets
  #
  def self.build_dir=(value)
    @build_dir = value
  end

  def self.build_dir
    Rails.root.join(@build_dir || "tmp/assets")
  end

  # Returns the "build" directory inside `::build_dir`
  #
  def self.target_dir
    build_dir.join("build")
  end

  # Returns the result of a Dir glob of the `::build_dir`
  #
  def self.build_files(file_glob="*.*")
    Dir.glob(RequirejsOptimizer.build_dir.join('**', file_glob).to_s).reject { |f| f =~ /manifest\.yml$|build\.txt$/ }
  end

  # Returns the result of a Dir glob of the `::target_dir`
  #
  def self.target_files(file_glob="*.*")
    Dir.glob(RequirejsOptimizer.target_dir.join('**', file_glob).to_s).reject { |f| f =~ /manifest\.yml$|build\.txt$/ }
  end

end

require "requirejs_optimizer/railtie" if defined?(Rails)
