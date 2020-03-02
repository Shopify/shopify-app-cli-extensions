require 'test_helper'

module ShopifyCli
  module Tasks
    class JsDepsTest < MiniTest::Test
      def test_installs_with_npm
        project_context('app_types', 'node')
        expect_installation_through_npm

        io = capture_io do
          ShopifyCli::Tasks::JsDeps.call(@context)
        end

        assert_match('Installing dependencies with npm...', io.join)
      end

      def test_installs_minimal_node_project_without_any_dependencies_with_npm
        project_context('app_types', 'node_without_dependencies')
        expect_installation_through_npm

        io = capture_io do
          ShopifyCli::Tasks::JsDeps.call(@context)
        end

        assert_match('Installing dependencies with npm...', io.join)
      end

      def test_installs_with_yarn
        project_context('app_types', 'node')
        expect_installation_through_yarn

        io = capture_io do
          ShopifyCli::Tasks::JsDeps.call(@context)
        end

        assert_match('Installing dependencies with yarn...', io.join)
      end

      def test_installs_minimal_node_project_without_any_dependencies_with_yarn
        project_context('app_types', 'node_without_dependencies')
        expect_installation_through_yarn

        io = capture_io do
          ShopifyCli::Tasks::JsDeps.call(@context)
        end

        assert_match('Installing dependencies with yarn...', io.join)
      end

      private

      def expect_installation_through_yarn
        stub_installer(:yarn)

        CLI::Kit::System.expects(:system).with(
          'yarn', 'install', '--silent',
          chdir: @context.root
        ).returns(mock(success?: true))
      end

      def expect_installation_through_npm
        stub_installer(:npm)

        CLI::Kit::System.expects(:system).with(
          'npm', 'install', '--no-audit', '--no-optional', '--silent',
          chdir: @context.root,
        )
      end

      def stub_installer(installer)
        ShopifyCli::Tasks::JsDeps.any_instance.stubs(:installer).returns(installer)
      end
    end
  end
end
