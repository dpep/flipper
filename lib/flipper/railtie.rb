module Flipper
  class Railtie < Rails::Railtie
    config.before_configuration do
      config.flipper = ActiveSupport::OrderedOptions.new
      config.flipper.memoizer = ActiveSupport::OrderedOptions.new
      config.flipper.memoizer.preload_all = true
    end

    initializer "flipper.memoizer" do |app|
      if config.flipper.memoizer
        app.middleware.use Flipper::Middleware::Memoizer, config.flipper.memoizer
      end
    end

    initializer "flipper.identifier" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.include Flipper::Identifier
      end
    end
  end
end