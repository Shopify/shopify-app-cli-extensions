# frozen_string_literal: true
module Node
  module Commands
    class Serve < ShopifyCli::Command
      prerequisite_task :ensure_env, :ensure_test_shop

      options do |parser, flags|
        parser.on('--host=HOST') do |h|
          flags[:host] = h.gsub('"', '')
        end
      end

      def call(*)
        project = ShopifyCli::Project.current
        url = options.flags[:host] || ShopifyCli::Tasks::Tunnel.call(@ctx)
        project.env.update(@ctx, :host, url)
        ShopifyCli::Tasks::UpdateDashboardURLS.call(
          @ctx,
          url: url,
          callback_url: "/auth/callback",
        )
        if @ctx.mac? && project.env.shop
          @ctx.puts("{{*}} Press {{yellow: Control-T}} to open this project in {{green:#{project.env.shop}}} ")
          @ctx.on_siginfo do
            @ctx.open_url!("#{project.env.host}/auth?shop=#{project.env.shop}")
          end
        end
        CLI::UI::Frame.open('Running server...') do
          env = project.env.to_h
          env['PORT'] = ShopifyCli::Tasks::Tunnel::PORT.to_s
          @ctx.system('npm run dev', env: env)
        end
      end

      def self.help
        <<~HELP
          Start a local development node server for your project, as well as a public ngrok tunnel to your localhost.
            Usage: {{command:#{ShopifyCli::TOOL_NAME} serve}}
        HELP
      end

      def self.extended_help
        <<~HELP
          {{bold:Options:}}
            {{cyan:--host=HOST}}: Must be HTTPS url. Bypass running tunnel and use custom host.
        HELP
      end
    end
  end
end
