ENV["RAILS_ENV"] = "test"

$:.unshift File.dirname(__FILE__)
require "rails_app/config/environment"

def build_path_for(*files)
  RequirejsOptimizer.build_dir.join(*files).to_s
end

def target_path_for(*files)
  RequirejsOptimizer.target_dir.join(*files).to_s
end
