# RequirejsOptimizer

## This library is no longer maintained.

[![Build Status](https://secure.travis-ci.org/jtrim/requirejs_optimizer.png?branch=master)](http://travis-ci.org/jtrim/requirejs_optimizer)

R.js optimization to go with your require.js modules, all under the asset
pipeline.

This lib is an extention to the functionality already provided by the asset pipeline. It takes the result of a full `assets:precompile` and applies the peformance benefits of optimization through R.js.

## Installation

Add this line to your application's Gemfile:

    gem 'requirejs_optimizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install requirejs_optimizer

Once the gem is installed, run the install generator:

    $ rails g requirejs_optimizer:install

It'll ask you what your main module name should be, but will default to `main` if left blank.
This is referring to the file that will be the main entry point for doing your initial requires.

Once you've ran the install generator, you'll have the following directory/file additions:

    app
    ↳ assets
       ↳ javascripts
          ↳ modules             # new
             ↳ README           # new
             ↳ main.js.coffee   # new
             ↳ require.build.js # new

`require.build.js` is the require.js project build file used by r.js.  Read more about this [here](http://requirejs.org/docs/optimization.html#wholeproject).

For an example build file that contains all available options, check [this](https://github.com/jrburke/r.js/blob/master/build/example.build.js) out.

## Usage

Note::This gem does *not* provide `require.js` for use in your app - you can get that [here](http://requirejs.org/docs/download.html#requirejs).

    rake assets:precompile

This runs the normal rails `assets:precompile` cycle, then:

- Copies `public/assets` to `tmp/assets`
- Removes all existing digestified and gzipped files
- Runs the `r.js` optimization tool with the build file in `app/assets/javascripts/modules/require.build.js`
- Re-digests all files
- Re-gzips all js/css files
- Writes a new `manifest.yml` file
- Copies the resulting build back to `pubilc/assets`

#### Quick rundown on require.js, require.build.js and folder structure

Given the following build file that lives under
`app/assets/javascripts/modules/require.build.js`:

    ({
        appDir:    "../../../../tmp/assets"
        , baseUrl: "./modules"
        , dir:     "../../../../tmp/assets/build"
        , name:    "main"
    })

You should have your main require.js module live in `app/assets/javascripts/modules/main.js(.coffee)`.

Given the following contents in `main.js.coffee`:

    require ["one/foo", "two/bar"], (foo, bar) -> # ...

You should have two modules:

- `app/assets/javascripts/modules/one/foo.js.coffee`
- `app/assets/javascripts/modules/two/bar.js.coffee`

After running `rake assets:precompile`, modules `foo` and `bar` will be compiled into `main.js`

#### Javascript runtime

The rake task will use either node or rhino during optimization.  By default, node will be used if found followed by rhino if java is available.

If you have a preference, set `Rails.configuration.requirejs_optimizer_runtime` to either `:node` or `:rhino`

If you're using rhino, you may use the configuration parameter `Rails.configuration.requirejs_optimizer_java_opts` to include java opts (like `-Xmx`) when invoking rhino.


## Overriding the base folder name (by default called "modules")

    RequirejsOptimizer.base_folder = "some_other_name"

You could place the above line into an initializer file called

    config/initializers/requirejs_optimizer.rb

Then "some_other_name" is used in place of "modules" in all the above paths.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes *with* tests (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

---

<a name="details"></a>
## Detailed topics

#### How it's modifying the environment

This lib does a few things to the environment on initialize:

- It adds *all* files under `app/assets/javascripts/modules` to
  `config.assets.precompile`. The result is each file under this
  directory is compiled individually. This is done because R.js
  needs these files for dependency tracing on build layers.
- It turns off Sprockets' js and css compression via
  `config.assets.compress = false` in favor of letting R.js run
  the assets through the compression mechanism defined in your
  build file (uglify by default, see
  [here](https://github.com/jrburke/r.js/blob/master/build/example.build.js))
- It makes available a few rake tasks:

        rake requirejs         # copy `public/assets` to `tmp` and perform the build,
                               # then copy the build result back to `public/assets`

        rake requirejs:clean   # remove the `tmp` build directory (`tmp/assets` by default)

        rake requirejs:nocopy  # runs `requirejs`, just without the final
                               # => `public/assets` step

- It extends `assets:precompile` by appending the actions of the
  `requirejs` rake task to `assets:precompile:nondigest`.

  **Details...**

  Overriding `assets:precompile:nondigest` in stead of `assets:precompile`
  allows asset precompilation to happen on Heroku. It's not entirely
  clear why the former works and the latter doesn't.

  Also, if you want to run the vanilla `assets:precompile` without R.js
  optimization, this should do the trick:

        NO_RJS=true rake assets:precompile

Thanks to [hawknewton](https://github.com/hawknewton) and [leachryanb](https://github.com/leachryanb) for adding Rhino support for optimizing
with R.js
