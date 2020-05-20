# frozen_string_literal: true
require 'shopify_cli'

module Extension
  module Messages
    MESSAGES = {
      create: {
        ask_name: 'Extension name',
        invalid_name: 'Extension name must be under %s characters',
        ask_type: 'What type of extension would you like to create?',
        invalid_type: 'Invalid extension type.',
        setup_project_frame_title: 'Initializing Project',
        ready_to_start: '{{*}} You\'re ready to start building %s! Try running `shopify serve` to start a local server.',
        learn_more: '{{*}} Learn more about building %s extensions at <shopify.dev>',
      },
      build: {
        frame_title: 'Packing extension with: %s...',
        build_failure_message: 'Failed to pack extension code for deployment.',
      },
      register: {
        frame_title: 'Registering Extension',
        waiting_text: 'Registering with Shopify...',
        already_registered: 'Extension is already registered.',
        loading_apps: 'Loading your apps...',
        ask_app: 'Which app would you like to associate with the extension?',
        no_apps: '{{x}} You don’t have any apps.',
        learn_about_apps: '{{*}} Learn more about building apps at <https://shopify.dev/concepts/apps>, or try creating a new app using {{command: shopify create app.}}',
        invalid_api_key: 'The API key %s does not match any of your apps.',
        confirm_info: 'You can only create one %s extension per app, which can’t be undone.',
        confirm_question: 'Would you like to connect this extension? (y/n)',
        confirm_abort: 'Extension was not created.',
        success: '{{v}} Connected %s.',
        success_info: '{{*}} Run {{command: shopify push}} to push your extension to Shopify.',
      },
      push: {
        frame_title: 'Pushing your extension to Shopify',
        waiting_text: 'Pushing to Shopify...',
        success_confirmation: '{{v}} Pushed %s to a draft at %s.',
        success_info: '{{*}} Visit the Partner\'s Dashboard to create and publish versions.',
      },
      serve: {
        frame_title: 'Serving extension...',
        serve_failure_message: 'Failed to run extension code for testing.',
      },
      features: {
        argo: {
          missing_file_error: 'Could not find built extension file.',
          script_prepare_error: 'An error occurred while attempting to prepare your script.',
        },
      },
    }
  end
end
