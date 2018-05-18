const path = require('path')
const { readFileSync } = require('fs')
const yaml = require('js-yaml')
const ManifestPlugin = require('webpack-manifest-plugin')

let environment = process.env.NODE_ENV || process.env.RACK_ENV || process.env.RAILS_ENV || 'development'
let configPath = process.env.PACKER_CONFIG_PATH
if (!configPath) {
  console.warn('PACKER_CONFIG path not set, defaulting to config/packer.yml')
  configPath = path.resolve('config', 'packer.yml')
}
let config = yaml.safeLoad(readFileSync(configPath))[environment]

module.exports = {
  context: path.join(__dirname, config.source_path),
  entry: {
    app: './packs/app.js'
  },
  output: {
    path: path.join(__dirname, config.public_path, config.public_output_path),
    publicPath: `/${config.public_output_path}/`
  },
  plugins: [
    new ManifestPlugin({ writeToFileEmit: true })
  ]
}
