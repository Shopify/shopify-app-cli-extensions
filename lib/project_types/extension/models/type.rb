# frozen_string_literal: true

module Extension
  module Models
    class Type
      TYPES_PATH = %w(lib project_types extension models types *.rb)

      class << self
        def load_all
          return unless @all_extension_types.nil? || @all_extension_types.empty?
          Dir.glob(File.join(ShopifyCli::ROOT, TYPES_PATH)).map { |file_path| load(file_path) }
        end

        def inherited(klass)
          @all_extension_types ||= []
          @all_extension_types << klass
        end

        def valid?(identifier)
          repository.key?(identifier)
        end

        def repository
          load_all if @all_extension_types.empty?

          @repository ||= @all_extension_types.map(&:new).each_with_object({}) do |type, hash|
            hash[type.identifier] = type
          end
        end

        def load_type(identifier)
          repository[identifier]
        end
      end

      def identifier
        self.class::IDENTIFIER
      end

      def name
        message('name')
      end

      def tagline
        message('tagline') || ""
      end

      def config(_context)
        raise NotImplementedError, "'#{__method__}' must be implemented for #{self.class}"
      end

      def create(_directory_name, _context)
        raise NotImplementedError, "'#{__method__}' must be implemented for #{self.class}"
      end

      def extension_context(_context)
        nil
      end

      def valid_extension_contexts
        []
      end

      private

      def message(key, *params)
        return unless messages.has_key?(key.to_sym)
        messages[key.to_sym] % params
      end

      def messages
        @messages ||= Messages::TYPES[identifier.downcase.to_sym] || {}
      end
    end
  end
end
