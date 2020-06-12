# frozen_string_literal: true
require 'shopify_cli'

module Extension
  module Commands
    class Tunnel < ExtensionCommand
      options do |parser, flags|
        parser.on('--port=PORT') { |port| flags[:port] = port }
      end

      AUTH_SUBCOMMAND = 'auth'
      START_SUBCOMMAND = 'start'
      STOP_SUBCOMMAND = 'stop'
      STATUS_SUBCOMMAND = 'status'
      DEFAULT_PORT = 39351

      def call(args, _name)
        subcommand = args.shift

        case subcommand
        when AUTH_SUBCOMMAND then authorize(args)
        when START_SUBCOMMAND then ShopifyCli::Tunnel.start(@ctx, port: port)
        when STOP_SUBCOMMAND then ShopifyCli::Tunnel.stop(@ctx)
        when STATUS_SUBCOMMAND then status
        else @ctx.puts(self.class.help)
        end
      end

      private

      def self.help
        ShopifyCli::Context.message('tunnel.help', ShopifyCli::TOOL_NAME)
      end

      def self.extended_help
        ShopifyCli::Context.message('tunnel.extended_help', ShopifyCli::TOOL_NAME, DEFAULT_PORT)
      end

      def status
        tunnel_url = Features::TunnelUrl.fetch

        if tunnel_url.nil?
          @ctx.puts(@ctx.message('tunnel.no_tunnel_running'))
        else
          @ctx.puts(@ctx.message('tunnel.tunnel_running_at', tunnel_url))
        end
      end

      def port
        return DEFAULT_PORT unless options.flags.key?(:port)

        port = options.flags[:port].to_i
        @ctx.abort(@ctx.message('tunnel.invalid_port', options.flags[:port])) unless port > 0
        port
      end

      def authorize(args)
        token = args.shift

        if token.nil?
          @ctx.puts(@ctx.message('tunnel.missing_token'))
          @ctx.puts("#{self.class.help}\n#{self.class.extended_help}")
        else
          ShopifyCli::Tunnel.auth(@ctx, token)
        end
      end
    end
  end
end
