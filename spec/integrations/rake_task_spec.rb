require 'spec_helper'

describe "Output from `rake -T`" do

  def rake_t_output
    `cd spec/rails_app && rake -T`
  end

  it "should include the default requirejs task" do
    rake_t_output.should =~ /requirejs\s/
  end

  it "should include the clean task" do
    rake_t_output.should =~ /requirejs:clean\s/
  end

end

describe "the environment post-asset precompilation" do

  it "has a public/assets directory that's identical in contents and structure to tmp/assets/build" do
    result = `cd spec/rails_app && RAILS_ENV=production rake assets:clean assets:precompile --trace 2>&1`
    $?.exitstatus.should == 0

    public_files = Dir[Rails.root.join("public/assets/**/*").to_s].map { |f| f.gsub /^#{Rails.root.join("public/assets")}/, '' }
    build_files = Dir[RequirejsOptimizer.target_dir.join("**/*").to_s].map { |f| f.gsub /^#{RequirejsOptimizer.target_dir}/, '' }

    public_files.should =~ build_files
  end

end
