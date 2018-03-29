# frozen_string_literal: true

require 'rack/proxy'

module Packer
  class DevServerProxy < Rack::Proxy
    def rewrite_response(response)
      _status, headers, _body = response
      headers.delete 'transfer-encoding'
      headers.delete 'content-length' if Packer.dev_server.running?
      response
    end

    def perform_request(env)
      if env['PATH_INFO'].start_with?("/#{public_output_uri_path}") && Packer.dev_server.running?
        env['HTTP_HOST'] = env['HTTP_X_FORWARDED_HOST'] \
                         = env['HTTP_X_FORWARDED_SERVER'] \
                         = Packer.dev_server.host_with_port
        env['SCRIPT_NAME'] = ''

        super(env)
      else
        @app.call(env)
      end
    end

    private

    def public_output_uri_path
      Packer.config.public_output_path.relative_path_from(Packer.config.public_path)
    end
  end
end
