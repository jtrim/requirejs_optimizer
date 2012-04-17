require 'requirejs_build'
require 'pathname'

class RequirejsBuildRailtie < Rails::Railtie
  rake_tasks do
    RequirejsBuild::BuildTask.new.define_task
  end
end
