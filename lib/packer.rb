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

  delegate :logger, :logger=, :env, to: :instance
  delegate :compile, :compiler, :manifest, :config, :dev_server, to: :instance
end

require 'packer/version'
require 'packer/compiler'
require 'packer/configuration'
require 'packer/helper'
require 'packer/instance'
require 'packer/manifest'
require 'packer/dev_server'
