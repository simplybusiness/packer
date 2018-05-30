# Packer

Gem to provide the glue between any Rack application and Webpack. It handles recompiling the assets when necessary, without requiring a separate process, and mapping original filenames to hashed filenames in a production environment.

Based primarily on code from https://github.com/rails/webpacker/.

The webpack configuration itself is provided by the application, and must provide at least the following:

1. Use [`webpack-manifest-plugin`](https://github.com/danethurber/webpack-manifest-plugin) to produce an asset manifest. If assets are required to be accessible from outside Webpack (e.g. in `<img>` tags) you must use the `writeToFileEmit` option, to ensure that the manifest is available even when using `webpack-dev-server`.
2. Read the `packer.yml` file to determine input/output file paths. An example configuration can be found in [example_app/config/packer.yml](example_app/config/packer.yml) and some example code to read it is in [example_app/webpack.config.js](example_app/webpack.config.js).
