module RequirejsOptimizer

  module Rake

    module Utils

      def define_task_deeply(name, taskdesc="", work_to_do=nil, &block)
        current, *rest = *name.split(":")

        if rest.any?
          namespace(current) { define_task_deeply rest.join(":"), taskdesc, work_to_do || block }
        else
          desc taskdesc
          task current, &(work_to_do || block)
        end
      end

      # Not sure if we actually need this or not.
      #
      def invoke_or_reboot_rake_task(task)
        if ENV['RAILS_GROUPS'].to_s.empty? || ENV['RAILS_ENV'].to_s.empty?
          ruby_rake_task task
        else
          ::Rake::Task[task].invoke
        end
      end

    end

  end

end
