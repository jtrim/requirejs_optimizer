require 'sprockets'
require 'fileutils'

require "requirejs_build/errors"
require "requirejs_build/step/base"
require "requirejs_build/step/clean"
require "requirejs_build/step/compress"
require "requirejs_build/step/digestify"
require "requirejs_build/step/finalize"
require "requirejs_build/step/manifest"
require "requirejs_build/step/optimize"
require "requirejs_build/step/prepare"

require "requirejs_build/build"
require "requirejs_build/rake/utils"
require "requirejs_build/rake/task"

require "requirejs_build/version"


module RequirejsBuild

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
    Dir.glob(RequirejsBuild.build_dir.join('**', file_glob).to_s).reject { |f| f =~ /manifest\.yml$|build\.txt$/ }
  end

  def self.target_files(file_glob="*.*")
    Dir.glob(RequirejsBuild.target_dir.join('**', file_glob).to_s).reject { |f| f =~ /manifest\.yml$|build\.txt$/ }
  end

end

require "requirejs_build/railtie" if defined?(Rails)
