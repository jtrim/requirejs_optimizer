# RequirejsOptimizer

R.js optimization to go with your require.js modules, all under the asset
pipeline.

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
             ↳ require.build.js # new

`require.build.js` is the require.js project build file.  Read more about this [here](http://requirejs.org/docs/optimization.html#wholeproject).

For an example build file that contains all available options, check [this](https://github.com/jrburke/r.js/blob/master/build/example.build.js) out.

## Usage

Put any modules you want to be available for builds into `app/assets/javascripts/modules`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
