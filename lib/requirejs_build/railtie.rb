require 'requirejs_build'
require 'pathname'

class RequirejsBuildRailtie < Rails::Railtie

  config.after_initialize do
    javascripts_root_path = Rails.root.join(*%w(app/assets/javascripts/))
    modules_path          = javascripts_root_path.join("modules", '**', '*.{coffee,js}')

    modules = Dir[modules_path].reject { |f| f =~ /require\.build\.js$/ }.map do |path_with_filename|
      filename = path_with_filename.gsub(/^#{javascripts_root_path}\/?/, '').gsub(/\.coffee$/, '')
      filename = "#{filename}.js" unless File.extname(filename) == "js"
      filename
    end

    Rails.application.config.assets.precompile += modules
  end

  config.before_initialize do
    Rails.application.config.assets.compress = false
  end

  rake_tasks do
    RequirejsBuild::Rake::Task.new.define_tasks
  end

end
