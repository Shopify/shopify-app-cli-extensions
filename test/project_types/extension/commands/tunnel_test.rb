# frozen_string_literal: true
require 'test_helper'
require 'project_types/extension/extension_test_helpers'

module Extension
  module Commands
    class TunnelTest < MiniTest::Test
      include TestHelpers::FakeUI
      include ExtensionTestHelpers::Messages

      def setup
        super
        ShopifyCli::ProjectType.load_type(:extension)
      end

      def test_prints_help
        @context.expects(:puts).with(Tunnel.help)
        run_tunnel('help')
      end

      def test_auth_errors_if_no_token_is_provided
        io = capture_io { run_tunnel(Tunnel::AUTH_SUBCOMMAND) }

        assert_message_output(io: io, expected_content: [
          @context.message('tunnel.missing_token'),
          Tunnel::help,
          Tunnel::extended_help
        ])
      end

      def test_auth_runs_the_core_cli_tunnel_auth_if_token_is_present
        fake_token = 'FAKE_TOKEN'
        ShopifyCli::Tunnel.expects(:auth).with(@context, fake_token).once

        capture_io { run_tunnel(Tunnel::AUTH_SUBCOMMAND, fake_token) }
      end

      def test_start_runs_with_the_default_port_if_no_port_provided
        ShopifyCli::Tunnel.expects(:start).with(@context, port: Tunnel::DEFAULT_PORT).once

        capture_io { run_tunnel(Tunnel::START_SUBCOMMAND) }
      end

      def test_start_runs_with_the_requested_port_if_provided
        ShopifyCli::Tunnel.expects(:start).with(@context, port: Tunnel::DEFAULT_PORT).once

        capture_io { run_tunnel(Tunnel::START_SUBCOMMAND) }
      end

      def test_start_aborts_if_an_invalid_port_is_provided
        invalid_port = 'NOT_PORT'

        ShopifyCli::Tunnel.expects(:start).never

        io = capture_io_and_assert_raises(ShopifyCli::Abort) do
          run_tunnel(Tunnel::START_SUBCOMMAND, "--port=#{invalid_port}")
        end

        assert_message_output(io: io, expected_content: [
          @context.message('tunnel.invalid_port', invalid_port)
        ])
      end

      def test_stop_runs_the_core_cli_tunnel_stop
        ShopifyCli::Tunnel.expects(:stop).with(@context).once

        capture_io { run_tunnel(Tunnel::STOP_SUBCOMMAND) }
      end

      def test_status_outputs_no_tunnel_running_if_tunnel_url_returns_nil
        Features::TunnelUrl.expects(:fetch).returns(nil).once

        io = capture_io { run_tunnel(Tunnel::STATUS_SUBCOMMAND) }

        assert_message_output(io: io, expected_content: @context.message('tunnel.no_tunnel_running'))
      end

      def test_status_outputs_the_running_tunnel_url_if_returned_by_tunnel_url
        fake_url = 'http://12345.ngrok.io'
        Features::TunnelUrl.expects(:fetch).returns(fake_url).once

        io = capture_io { run_tunnel(Tunnel::STATUS_SUBCOMMAND) }

        assert_message_output(io: io, expected_content: @context.message('tunnel.tunnel_running_at', fake_url))
      end

      private

      def run_tunnel(*args)
        Tunnel.ctx = @context
        Tunnel.call(args, 'tunnel')
      end
    end
  end
end
