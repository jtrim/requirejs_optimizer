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

  mattr_accessor :base_folder
  self.base_folder = "modules"

  def self.root
    Pathname.new(File.expand_path("../..", __FILE__))
  end

  def self.build_dir=(value)
    @build_dir = value
  end

  def self.build_dir
    Rails.root.join(@build_dir || "tmp/assets")
  end

  def self.target_dir
    build_dir.join("build")
  end

  def self.build_files(file_glob="*.*")
    Dir.glob(RequirejsOptimizer.build_dir.join('**', file_glob).to_s).reject { |f| f =~ /manifest\.yml$|build\.txt$/ }
  end

  def self.target_files(file_glob="*.*")
    Dir.glob(RequirejsOptimizer.target_dir.join('**', file_glob).to_s).reject { |f| f =~ /manifest\.yml$|build\.txt$/ }
  end

end

require "requirejs_optimizer/railtie" if defined?(Rails)
