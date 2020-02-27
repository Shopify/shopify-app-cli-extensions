require 'shopify_cli'

module ShopifyCli
  module Forms
    class Form
      class << self
        def ask(ctx, args, flags)
          attrs = {}
          @positional_arguments.each { |name| attrs[name] = args.shift }
          return nil if attrs.any? { |_k, v| v.nil? }
          @flag_arguments.each { |arg| attrs[arg] = flags[arg] }
          form = new(ctx, args, attrs)
          begin
            form.ask
            form
          rescue ShopifyCli::Abort => err
            ctx.puts(err.message)
            nil
          end
        end

        def positional_arguments(*args)
          @positional_arguments = args
          attr_accessor(*args)
        end

        def flag_arguments(*args)
          @flag_arguments = args
          attr_accessor(*args)
        end
      end

      attr_accessor :ctx, :xargs

      def initialize(ctx, xargs, attributes)
        @ctx = ctx
        @xargs = xargs
        attributes.each { |k, v| send("#{k}=", v) unless v.nil? }
      end
    end

    autoload :CreateApp, 'shopify-cli/forms/create_app'
    autoload :CreateExtension, 'shopify-cli/forms/create_extension'
  end
end
