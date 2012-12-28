module Crystal
  module ControllerExtensions
    def self.included(base)
      base.before_filter :_set_meta
      base.helper_method :meta
    end

    def meta(options = {})
      options.present? && @_meta.store(options)
      @_meta
    end

    protected

    def _set_meta
      @_meta = Meta.new(OptionsForController.new(self).options)
    end
  end
end
