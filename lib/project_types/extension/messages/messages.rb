# frozen_string_literal: true
require 'shopify_cli'

module Extension
  module Messages
    MESSAGES = {
      create: {
        ask_name: 'Extension name',
        invalid_name: 'Extension name must be under %s characters',
        ask_type: 'What type of extension are you creating?',
        invalid_type: 'Extension type is invalid.',
        setup_project_frame_title: 'Initializing project',
        ready_to_start: <<~MESSAGE,
        {{v}} A new folder was generated at {{green:./%s}}.
        {{*}} You’re ready to start building {{green:%s}}!
        Navigate to the new folder, then run {{command:shopify serve}} to start a local server.
        MESSAGE
        learn_more: <<~MESSAGE,
        {{*}} Once you're ready to version and publish your extension,
        run {{command:shopify register}} to register this extension with one of your apps.
        MESSAGE
        try_again: '{{*}} Fix the errors and run {{command:shopify create extension}} again.',
      },
      build: {
        frame_title: 'Building extension with: %s...',
        build_failure_message: 'Failed to build extension code.',
      },
      register: {
        frame_title: 'Registering Extension',
        waiting_text: 'Registering with Shopify...',
        already_registered: 'Extension is already registered.',
        loading_apps: 'Loading your apps...',
        ask_app: 'Which app would you like to register this extension with?',
        no_apps: '{{x}} You don’t have any apps.',
        learn_about_apps: '{{*}} Learn more about building apps at <https://shopify.dev/concepts/apps>, or try creating a new app using {{command:shopify create}}.',
        invalid_api_key: 'The API key %s does not match any of your apps.',
        confirm_info: 'This will create a new extension registration for %s, which can’t be undone.',
        confirm_question: 'Would you like to register this extension with {{green:%s}}? (y/n)',
        confirm_abort: 'Extension was not registered.',
        success: '{{v}} Registered {{green:%s}} with {{green:%s}}.',
        success_info: '{{*}} Run {{command:shopify push}} to push your extension to Shopify.',
      },
      push: {
        frame_title: 'Pushing your extension to Shopify',
        waiting_text: 'Pushing code to Shopify...',
        pushed_with_errors: '{{x}} Code pushed to Shopify with errors on %s.',
        push_with_errors_info: '{{*}} Fix these errors and run {{command:shopify push}} to revalidate your extension.',
        success_confirmation: '{{v}} Pushed {{green:%s}} to a draft on %s.',
        success_info: '{{*}} Visit %s to version and publish your extension.',
      },
      serve: {
        frame_title: 'Serving extension...',
        serve_failure_message: 'Failed to run extension code.',
      },
      tunnel: {
        missing_token: '{{x}} {{red:auth requires a token argument}}. Find it on your ngrok dashboard: {{underline:https://dashboard.ngrok.com/auth/your-authtoken}}.',
        invalid_port: '%s is not a valid port.',
        no_tunnel_running: 'No tunnel running.',
        tunnel_running_at: 'Tunnel running at: {{underline:%s}}',
        help: <<~HELP,
          Start or stop an http tunnel to your local development extension using ngrok.
            Usage: {{command:%s tunnel [ auth | start | stop | status ]}}
        HELP
        extended_help: <<~HELP,
          {{bold:Subcommands:}}

            {{cyan:auth}}: Writes an ngrok auth token to ~/.ngrok2/ngrok.yml to connect with an ngrok account. Visit https://dashboard.ngrok.com/signup to sign up.
              Usage: {{command:%1$s tunnel auth <token>}}

            {{cyan:start}}: Starts an ngrok tunnel, will print the URL for an existing tunnel if already running.
              Usage: {{command:%1$s tunnel start}}
              Options:
              {{command:--port=PORT}} Forward the ngrok subdomain to local port PORT. Defaults to %2$s.

            {{cyan:stop}}: Stops the ngrok tunnel.
              Usage: {{command:%1$s tunnel stop}}

            {{cyan:status}}: Output the current status of the ngrok tunnel.
              Usage: {{command:%1$s tunnel status}}
        HELP
      },
      features: {
        argo: {
          missing_file_error: 'Could not find built extension file.',
          script_prepare_error: 'An error occurred while attempting to prepare your script.',
          initialization_error: '{{x}} There was an error while initializing the project.',
          dependencies: {
            node: {
              node_not_installed: 'Node must be installed to create this extension.',
              version_too_low: 'Your node version %s does not meet the minimum required version %s',
            }
          }
        },
      },
      tasks: {
        errors: {
          parse_error: 'Unable to parse response from Partners Dashboard.'
        }
      },
      errors: {
        unknown_type: 'Unknown extension type %s'
      }
    }

    TYPES = {
      subscription_management: {
        name: 'Subscription Management',
        tagline: '(limit 1 per app)',
        overrides: {
          register: {
            confirm_info: 'You can only create one %s extension per app, which can’t be undone.',
          }
        }
      },
      checkout_post_purchase: {
        name: 'Checkout Post Purchase',
      }
    }
  end
end
