# frozen_string_literal: true

module Extension
  class Project < ShopifyCli::ProjectType
    hidden_project_type
    creator 'App Extension', 'Extension::Commands::Create'

    register_command('Extension::Commands::Build', "build")
    register_command('Extension::Commands::Register', "register")
    register_command('Extension::Commands::Push', "push")
    register_command('Extension::Commands::Serve', "serve")
    register_command('Extension::Commands::Tunnel', "tunnel")

    require Project.project_filepath('messages/messages')
    require Project.project_filepath('messages/message_loading')
    require Project.project_filepath('extension_project_keys')
    register_messages(Extension::Messages::MessageLoading.load)
  end

  module Commands
    autoload :ExtensionCommand, Project.project_filepath('commands/extension_command')
    autoload :Create, Project.project_filepath('commands/create')
    autoload :Register, Project.project_filepath('commands/register')
    autoload :Build, Project.project_filepath('commands/build')
    autoload :Serve, Project.project_filepath('commands/serve')
    autoload :Push, Project.project_filepath('commands/push')
    autoload :Tunnel, Project.project_filepath('commands/tunnel')
  end

  module Tasks
    autoload :UserErrors, Project.project_filepath('tasks/user_errors')
    autoload :GetApps, Project.project_filepath('tasks/get_apps')
    autoload :CreateExtension, Project.project_filepath('tasks/create_extension')
    autoload :UpdateDraft, Project.project_filepath('tasks/update_draft')

    module Converters
      autoload :RegistrationConverter, Project.project_filepath('tasks/converters/registration_converter')
      autoload :VersionConverter, Project.project_filepath('tasks/converters/version_converter')
      autoload :ValidationErrorConverter, Project.project_filepath('tasks/converters/validation_error_converter')
    end
  end

  module Forms
    autoload :Create, Project.project_filepath('forms/create')
    autoload :Register, Project.project_filepath('forms/register')
  end

  module Features
    autoload :Argo, Project.project_filepath('features/argo')
    autoload :ArgoDependencies, Project.project_filepath('features/argo_dependencies')
  end

  module Models
    autoload :App, Project.project_filepath('models/app')
    autoload :Registration, Project.project_filepath('models/registration')
    autoload :Version, Project.project_filepath('models/version')
    autoload :Type, Project.project_filepath('models/type')
    autoload :ValidationError, Project.project_filepath('models/validation_error')

    class << self
      Models::Type.load_all
    end
  end

  autoload :ExtensionProjectKeys, Project.project_filepath('extension_project_keys')
  autoload :ExtensionProject, Project.project_filepath('extension_project')
end
