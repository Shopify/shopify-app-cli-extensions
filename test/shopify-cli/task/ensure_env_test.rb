require 'test_helper'

module ShopifyCli
  module Tasks
    class EnsureEnvTest < MiniTest::Test
      include TestHelpers::FakeUI

      def setup
        super
        root = Dir.mktmpdir
        @context = TestHelpers::FakeContext.new(root: root)
        Project.write(@context, project_type: :fake, organization_id: 42)
        FileUtils.cd(@context.root)
        ShopifyCli::Tunnel.stubs(:start)
      end

      def test_ask_strips_out_https_from_shop
        CLI::UI.expects(:ask).times(3)
          .returns('apikey', 'apisecret', 'https://test-shop.myshopify.com')
        @task = EnsureEnv.call(@context)
        assert_equal('test-shop.myshopify.com', Project.current.env.shop)
      end

      def test_writes_env_if_no_env
        CLI::UI.expects(:ask).times(3)
          .returns('apikey', 'apisecret', 'https://test-shop.myshopify.com')
        @task = EnsureEnv.call(@context)
        assert_equal('apikey', Project.current.env.api_key)
      end
    end
  end
end
