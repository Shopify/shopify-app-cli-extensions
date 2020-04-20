# frozen_string_literal: true
require 'shopify_cli'

module Extension
  module Tasks
    class GetApps < ShopifyCli::Task
      def call(context:)
        organizations = ShopifyCli::Helpers::Organizations.fetch_with_app(context)
        apps_from_organizations(organizations)
      end

      private

      def apps_from_organizations(organizations)
        organizations.flat_map do |organization|
          return [] unless organization.key?('apps') && organization['apps'].any?
          apps_owned_by_organization(organization)
        end
      end

      def apps_owned_by_organization(organization)
        organization['apps'].map do |app|
          Models::App.new(
            api_key: app['apiKey'],
            secret: app["apiSecretKeys"].first["secret"],
            title: app['title'],
            business_name: organization['businessName']
          )
        end
      end
    end
  end
end
