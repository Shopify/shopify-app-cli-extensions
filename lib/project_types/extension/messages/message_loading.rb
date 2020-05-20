# frozen_string_literal: true
module Extension
  module Messages
    module MessageLoading
      def self.load
        type_specific_messages = load_current_type_messages
        return Messages::MESSAGES if type_specific_messages.nil?

        override_messages = type_specific_messages.delete(:overrides)

        messages_with_type = Messages::MESSAGES.merge(type: type_specific_messages)
        override_messages.nil? ? messages_with_type : messages_with_type.merge(override_messages)
      end

      def self.load_current_type_messages
        return unless ShopifyCli::Project.has_current?
        messages_for_type(ShopifyCli::Project.current.config['EXTENSION_TYPE'])
      end

      def self.messages_for_type(type_identifier)
        return if type_identifier.nil?

        filepath = File.join(ShopifyCli::PROJECT_TYPES_DIR, 'extension','messages', 'types', "#{type_identifier.downcase}.rb")
        return unless File.exists?(filepath)

        Module.new.module_eval(File.read(filepath))
      end
    end
  end
end
