# NOTE!!!!

This gem is a current work-in-progress. It is non-functional, so it's not ready
to use yet.

# API Thoughts

    module RequirejsBuild
      class Clean
        def perform
          # Remove any stale build files
        end
      end

      class Prepare
        def perform
          # Remove any gzipped / digestified files from public/assets
          # Prepare the build dir by copying public/assets into tmp
        end
      end

      class Optimize
        def perform
          # Calls node to run r.js against sprockets-precompiled assets
        end
      end

      class Digestify
        def perform
          # Makes digest versions of all js/css files
        end

        def as_manifest
          # Returns a hash of filename / digestified filename pairs for
          #   writing the manifest file
        end
      end

      class Compress
        def perform
          # Compresses digestified files into .gz versions
        end
      end

      class Finalize
        def perform
          # Write the manifest file
          # Overwrite public/assets with the build directory
        end
      end
    end

    # Inside RequirejsBuildTask

    # ...

    def perform_requirejs_build
      %w(Clean Prepare Optimize Digestify Compress Finalize).each { |step| step.constantize.new.perform }
      # There's a catch - if Finalize is responsible for writing the manifest,
      # how the f*ck is it supposed to know about Digestify's `as_manifest`
      # result?
      #
      # 1. Make the current manifest an attr_accessor on the singleton: meh
      #      Breaks LoD. Finalize shouldn't need to know anything about
      #      Digestify to do its job.
      #
      # 2. Add an api to each class that returns "job data": meh
      #     Not much better than number 1. Not every step needs to return data
      #     (in fact, it's only Digestify currently), so this is kind of silly.
      #
      # 3. Do things in a finalize block
      #     Felt gross just typing that. That's a no - the api becomes
      #     inconsistent.
      #
      # 4. Make Finalize do all the things
      #     I don't like this because then it makes Finalize responsible for
      #     too many things == too many reasons to fail.
      #
      # 5. Make a ManifestWriter (gross name) class that doesn't conform to the
      #    'perform' api, but takes an object that responds to 'as_manifest'
      #    and writes it out: best so far.
      #      This approach makes a specialized object for writing out the
      #      manifest and knowing about the `as_manifest` api. ManifestWriter
      #      isn't a step, so the fact that it doesn't conform to 'perform'
      #      seems ok. But that means now we're back to the beginning...where
      #      do we do this? In its current form, the perform loop isn't built
      #      for handing a digestify instance off to Finalize...hmm.
    end

    # ...


# RequirejsBuild

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'requirejs_build'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install requirejs_build

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
