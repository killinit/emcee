require "emcee/version"

require "emcee/helpers/action_view/action_view"
require "emcee/helpers/sprockets/sprockets_view"
require "emcee/helpers/sprockets/sprockets_compressing"

require "emcee/railtie"

module ActionView
  module Helpers
    module AssetUrlHelper
      include Emcee::Helpers::ActionView::AssetUrlHelper

      # Modify ActionView to recognize html files and the '/elements' path.
      ASSET_EXTENSIONS.merge!({ html: '.html' })
      ASSET_PUBLIC_DIRECTORIES.merge!({ html: '/elements' })
    end

    module AssetTagHelper
      include Emcee::Helpers::ActionView::AssetTagHelper
    end
  end
end

module Sprockets
  module Rails
    module Helper
      include Emcee::Helpers::Sprockets::View
    end
  end

  module Compressing
    include Emcee::Helpers::Sprockets::Compressing
  end
end
