require 'pathname'

# This will fail when initializing assets, but we don't need
# generators for asset initialization anyway. Let it fail
# silently
#
begin; require "generators/install_generator"
rescue NameError => e; end

class RequirejsOptimizerRailtie < Rails::Railtie

  config.before_initialize do
    Rails.application.config.assets.compress = false
  end

  config.after_initialize do
    javascripts_root_path = Rails.root.join(*%w(app/assets/javascripts/))
    modules_path          = javascripts_root_path.join(RequirejsOptimizer.base_folder, '**', '*.{coffee,js}')

    modules = Dir[modules_path].reject { |f| f =~ /require\.build\.js$/ }.map do |path_with_filename|
      filename = path_with_filename.gsub(/^#{javascripts_root_path}\/?/, '').gsub(/\.coffee$/, '')
      filename = "#{filename}.js" unless File.extname(filename) == ".js"
      filename
    end

    Rails.application.config.assets.precompile += modules
  end

  rake_tasks do
    raketask = RequirejsOptimizer::Rake::Task.new
    raketask.define_tasks
    raketask.extend_default_precompile unless ENV['NO_RJS']
  end

end
