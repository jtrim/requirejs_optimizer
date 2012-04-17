require "requirejs_build/build_task"
require "requirejs_build/version"

module RequirejsBuild

  def self.root
    Pathname.new(File.expand_path("../..", __FILE__))
  end

end

require "requirejs_build/railtie" if defined?(Rails)
