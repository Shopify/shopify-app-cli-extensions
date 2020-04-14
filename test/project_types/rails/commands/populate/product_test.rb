require 'test_helper'

module Rails
  module Commands
    module PopulateTests
      class ProductTest < MiniTest::Test
        include TestHelpers::Schema

        def setup
          super
          ShopifyCli::ProjectType.load_type(:rails)
          ShopifyCli::Helpers::AccessToken.stubs(:read).returns('myaccesstoken')
        end

        def test_populate_calls_api_with_mutation
          ShopifyCli::Helpers::Haikunator.expects(:title).returns('fake product')
          ShopifyCli::Helpers::Haikunator.expects(:title).returns('fake producttwo')
          ShopifyCli::AdminAPI::PopulateResourceCommand.any_instance.stubs(:price).returns('1.00')
          return_data = JSON.parse(File.read(File.join(FIXTURE_DIR, 'populate/product_data.json')))
          ShopifyCli::AdminAPI.expects(:query)
            .with(@context, 'create_product', input: {
              'title': 'fake product',
              variants: [{ price: '1.00' }],
            })
            .returns(return_data)
          ShopifyCli::AdminAPI.expects(:query)
            .with(@context, 'create_product', input: {
              'title': 'fake producttwo',
              variants: [{ price: '1.00' }],
            })
            .returns(return_data)
          ShopifyCli::API.expects(:gid_to_id).returns(12345678).twice
          @context.expects(:done).with(
            "fake product added to {{green:my-test-shop.myshopify.com}} at" \
            " {{underline:https://my-test-shop.myshopify.com/admin/products/12345678}}"
          ).twice
          run_cmd('populate products -c 2')
        end
      end
    end
  end
end
