require 'shopify_cli'
require 'uri'

module ShopifyCli
  module Forms
    class CreateExtension < Form
      positional_arguments :name
      flag_arguments :type, :app

      ExtensionType = Struct.new(:identifier, :description, keyword_init: true) do
        def ==(extensionType)
          case extensionType
          when String
            self.identifier == extensionType
          else
            super(extensionType)
          end
        end
      end

      EXTENSION_TYPES = [
        ExtensionType.new(identifier: 'product-details', description: 'Product extension'),
        ExtensionType.new(identifier: 'customer-details', description: 'Customer extension')
      ]

      def ask
        self.type = ask_type
        self.app = ask_app
      end

      private

      def ask_type
        return type if EXTENSION_TYPES.include?(type)
        ctx.puts('Invalid Extension Type.') unless type.nil?
        CLI::UI::Prompt.ask('What type of extension would you like to create?') do |handler|
          EXTENSION_TYPES.each do |type|
            handler.option(type.description) { type.identifier }
          end
        end
      end

      def ask_app
        resp = Helpers::Organizations.fetch_with_app(@ctx)
        return @ctx.puts('There is no registered app. Create an app and try again.') if resp.empty?
        # the following line of code will be expanded to validate the provided app will be done in the next iteration.
        return app if !app.nil?
        CLI::UI::Prompt.ask('Which app will you like to associate with the extension?') do |handler|
          resp.each do |org|
            org['apps'].each do |app|
              handler.option(app['title'] + " by #{org['businessName'].to_s}") { app }
            end
          end 
        end
      end
    end
  end
end
