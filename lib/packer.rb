# frozen_string_literal: true

require 'active_support/core_ext/module'
require 'active_support/logger'
require 'active_support/tagged_logging'

module Packer
  extend self # rubocop:disable Style/ModuleFunction

  def instance=(instance)
    @instance = instance
  end

  def instance
    @instance ||= Packer::Instance.new
  end

  def rails?
    defined? ::Rails
  end

  def sinatra?
    defined? ::Sinatra
  end

  def with_node_env(env)
    original = ENV["NODE_ENV"]
    ENV["NODE_ENV"] = env
    yield
  ensure
    ENV["NODE_ENV"] = original
  end

  delegate :logger, :logger=, :env, to: :instance
  delegate :compile, :compiler, :manifest, :commands, :config, :dev_server, to: :instance
  delegate :bootstrap, :clobber, :compile, to: :commands
end

require 'packer/version'
require 'packer/env'
require 'packer/commands'
require 'packer/compiler'
require 'packer/configuration'
require 'packer/helper'
require 'packer/instance'
require 'packer/manifest'
require 'packer/dev_server'

require 'packer/railtie' if defined?(::Rails)
