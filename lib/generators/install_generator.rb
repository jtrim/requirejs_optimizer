module RequirejsOptimizer

  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc 'Set up for optimizing require.js modules'

    def install
      @main_name = ask("What is the name of your main module without the extension? (Leave blank for \"main\"):").tap { |s| s.replace "main" if s.blank? }
      template "require.build.js", "app/assets/javascripts/modules/require.build.js"
      copy_file "main.js.coffee", "app/assets/javascripts/modules/#{@main_name}.js.coffee"
      copy_file "README", "app/assets/javascripts/modules/README"
    end

  end

end
