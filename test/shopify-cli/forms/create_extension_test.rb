# frozen_string_literal: true
require 'test_helper'

module ShopifyCli
  module Forms
    class CreateAppTest < MiniTest::Test
      include TestHelpers::Partners

      def test_accepts_the_extension_name_as_positional_argument
        stub_query_request
        orgs = Helpers::Organizations.fetch_with_app(@context)
        form = CreateExtension.ask(@context, ['test-extension'], type: 'product-details', app: orgs.first['apps'])
        assert_equal form.name, 'test-extension'
      end

      def test_accepts_product_details_as_type
        stub_query_request
        orgs = Helpers::Organizations.fetch_with_app(@context)
        form = CreateExtension.ask(@context, ['test-extension'], type: 'product-details', app: orgs.first['apps'])
        assert_equal form.type, 'product-details'
      end

      def test_accepts_customer_details_as_type
        stub_query_request
        orgs = Helpers::Organizations.fetch_with_app(@context)
        form = CreateExtension.ask(@context, ['test-extension'], type: 'customer-details', app: orgs.first['apps'])
        assert_equal form.type, 'customer-details'
      end

      def test_prompts_the_user_to_choose_a_type_if_an_unknown_type_was_provided_as_flag
        stub_query_request
        orgs = Helpers::Organizations.fetch_with_app(@context)
        CLI::UI::Prompt.expects(:ask).with('What type of extension would you like to create?')
        
        io = capture_io do
          CreateExtension.ask(@context, ['test-extension'], type: 'unknown-type', app: orgs.first['apps'])
        end 

        assert_match('Invalid Extension Type.', io.join)
      end

      def test_prompts_the_user_to_choose_a_type_if_an_no_type_was_provided
        stub_query_request
        orgs = Helpers::Organizations.fetch_with_app(@context)
        CLI::UI::Prompt.expects(:ask).with('What type of extension would you like to create?')
        
        capture_io do
          CreateExtension.ask(@context, ['test-extension'], type: nil, app: orgs.first['apps'])
        end 
      end

      def test_prompts_the_user_to_choose_an_app_to_associate_with_extension
        stub_query_request
        orgs = Helpers::Organizations.fetch_with_app(@context)
        form = CreateExtension.ask(@context, ['test-extension'], type: 'product-details', app: orgs.first['apps'])
        assert_equal form.app.first["id"], orgs.first['apps'].first['id']
      end
      
      def test_prompts_the_user_to_choose_an_app_to_associate_with_extension_if_no_app_is_provided
        stub_query_request
        CLI::UI::Prompt.expects(:ask).with('Which app will you like to associate with the extension?')

        capture_io do
          CreateExtension.ask(@context, ['test-extension'], type: 'product-details')
        end
      end
      
      private 

      def stub_query_request
        stub_partner_req(
          'all_orgs_with_apps',
          resp: {
            data: {
              organizations: {
                nodes: [
                  {
                    'id': 421,
                    'businessName': "one",
                    'stores': {
                      'nodes': [
                        { 'shopDomain': 'store.myshopify.com' },
                      ],
                    },
                    'apps': {
                      nodes: [{
                        id: 123,
                        title: 'app',
                        apiKey: 1234,
                        apiSecretKeys: [{
                          secret: 1233,
                        }],
                      }],
                    },
                  },
                ],
              },
            },
          },
        )
      end
    end
  end
end
