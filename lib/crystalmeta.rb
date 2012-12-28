require 'crystal/version'
require 'crystal/meta'
require 'crystal/options_for_controller'
require 'crystal/tags'
require 'crystal/interpolates_tags'
require 'crystal/tag'
require 'crystal/hash_with_stringify_keys'
require 'crystal/view_helpers'
require 'crystal/controller_extensions'
require 'crystal/railtie' if defined?(Rails)

module Crystal
  def self.setup_action_controller(base)
    base.class_eval do
      include Crystal::ControllerExtensions
    end
  end

  def self.setup_action_view(base)
    base.class_eval do
      include Crystal::ViewHelpers
    end
  end
end
