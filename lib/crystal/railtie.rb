require 'rails/railtie'

module Crystal
  class Railtie < Rails::Railtie
    initializer 'crystalmeta.setup_action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        Crystal.setup_action_controller self
      end
    end

    initializer 'crystalmeta.setup_action_view' do |app|
      ActiveSupport.on_load :action_view do
        Crystal.setup_action_view self
      end
    end
  end
end
