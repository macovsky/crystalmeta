module Crystal
  class OptionsForController
    attr_reader :controller

    def initialize(controller)
      @controller = controller
    end

    def options
      paths.inject(default_options){|memo, path| memo.deep_merge!(I18n.t(path, :scope => scope, :default => {}))}
    end

    private

    def paths
      %W{
        _defaults
        #{controller_path}._defaults
        #{controller_path}.#{alias_action}
        #{controller_path}.#{action}
      }.uniq
    end

    def scope
      'meta'
    end

    def default_options
      HashWithStringifyKeys.new(:'og:url' => url)
    end

    def url
      controller.request.url
    end

    def controller_path
      @controller_path ||= controller.controller_path.gsub(%r{/}, '.')
    end

    def action
      controller.action_name
    end

    def alias_action
      aliases[action] || action
    end

    def aliases
      {'update' => 'edit', 'create' => 'new'}
    end
  end
end
