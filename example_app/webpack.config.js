const path = require('path')
const fs = require('fs')
const yaml = require('js-yaml')
const ManifestPlugin = require('webpack-manifest-plugin')
const CompressionPlugin = require('compression-webpack-plugin')

let environment = 'development'
let configPath = process.env.PACKER_CONFIG_PATH || path.resolve('config', 'packer.yml')
let config = yaml.safeLoad(fs.readFileSync(configPath))[environment]
let dev = config.mode === 'development'

module.exports = {
  context: path.join(__dirname, config.source_path),
  mode: dev ? 'development' : 'production',
  devtool: dev ? 'cheap-eval-source-map' : 'source-map',
  entry: {
    app: './packs/app.js'
  },
  output: {
    path: path.join(__dirname, config.public_path, config.public_output_path),
    publicPath: `/${config.public_output_path}/`,
    filename: dev ? '[name].js' : '[name]-[chunkhash].js',
    chunkFilename: dev ? '[name].chunk.js' : '[name]-[chunkhash].chunk.js'
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /\/node_modules\//,
        loader: 'babel-loader'
      },
      {
        test: /\.(jpe?g|gif|png|svg)$/,
        loader: 'file-loader',
        options: {
          name: dev ? '[path][name].[ext]' : '[path][name]-[hash].[ext]'
        }
      }
    ]
  },
  devServer: {
    port: 3035
  },
  resolve: {
    extensions: ['.js', '.jsx', '.json']
  },
  plugins: [
    new ManifestPlugin({ writeToFileEmit: true }),
    new CompressionPlugin({
      test: /\.(js|css|svg)$/
    })
  ]
}
