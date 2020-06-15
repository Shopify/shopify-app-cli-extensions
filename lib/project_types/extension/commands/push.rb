# frozen_string_literal: true
require 'shopify_cli'

module Extension
  module Commands
    class Push < ExtensionCommand
      TIME_DISPLAY_FORMAT = "%B %d, %Y %H:%M:%S %Z"

      def call(args, name)
        Commands::Register.new(@ctx).call(args, name) unless project.registered?
        Commands::Build.new(@ctx).call(args, name)

        CLI::UI::Frame.open(@ctx.message('push.frame_title')) do
          updated_draft_version = update_draft
          show_message(updated_draft_version)
        end
      end

      def self.help
        <<~HELP
          Push the current extension to Shopify.
            Usage: {{command:#{ShopifyCli::TOOL_NAME} push}}
        HELP
      end

      private

      def show_message(draft)
        draft.validation_errors.empty? ? output_success_messages(draft) : output_validation_errors(draft)
      end

      def output_success_messages(draft)
        @ctx.puts(@ctx.message('push.success_confirmation', project.title, format_time(draft.last_user_interaction_at)))
        @ctx.puts(@ctx.message('push.success_info', draft.location))
      end

      def output_validation_errors(draft)
        @ctx.puts(@ctx.message('push.pushed_with_errors', format_time(draft.last_user_interaction_at)))

        draft.validation_errors.each do |error|
          @ctx.puts('{{x}} %s: %s' % [error.field.last, error.message])
        end

        @ctx.puts(@ctx.message('push.push_with_errors_info'))
      end

      def format_time(time)
        time.utc.strftime(TIME_DISPLAY_FORMAT)
      end

      def with_waiting_text
        @ctx.puts(@ctx.message('push.waiting_text'))
        yield
      end

      def update_draft
        with_waiting_text do
          Tasks::UpdateDraft.call(
            context: @ctx,
            api_key: project.app.api_key,
            registration_id: project.registration_id,
            config: extension_type.config(@ctx),
            extension_context: extension_type.extension_context(@ctx)
          )
        end
      end
    end
  end
end
