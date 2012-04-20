require 'spec_helper'

module RequirejsBuild

  module Rake

    describe Utils do

      describe "#define_task_deeply" do

        # Since #define_task_deeply recurses to do work, we can't test it with mocks
        # so here we're creating a clean-room scenario with a class that responds
        # to the part of the rake api that #define_task_deeply uses, but
        # implements it differently so we can inspect what it's doing internally.
        #
        # Not the best approach, and definitely not what I consider a unit test,
        # but it gets the job done. Any help here would be appreciated.
        #
        def klass
          Class.new do

            ####################
            # What we're testing
            include Utils
            ####################

            # Task assign's it's block to this for inspection
            attr_accessor :task_block

            # Adds the name it was called with to an array to track
            # namespace calls.
            #
            def namespace(name)
              @names ||= []
              @names << name
              yield if block_given?
            end

            # Calls #namespace to track the name, then stores the block
            # it was given so we can inspect it from the test
            #
            def task(name, &block)
              namespace(name)
              self.task_block = block
            end

            # Joins the names we were given on : so we can verify things are
            # recursing correclty.
            #
            def names
              @names.join(":")
            end

          end
        end

        subject do
          klass.new.tap { |k| k.stub(:desc) }
        end

        it "defines namespaces and tasks appropriately" do
          subject.define_task_deeply("foo:bar:baz")
          subject.names.should == "foo:bar:baz"
        end

        it "passes the given block to :task" do
          expected_block = proc { called! }
          subject.define_task_deeply "foo", &expected_block
          subject.task_block.should == expected_block
        end

      end

    end

  end

end
