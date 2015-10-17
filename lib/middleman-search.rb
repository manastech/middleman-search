require 'middleman-core'
require "middleman-search/version"

::Middleman::Extensions.register(:search) do
  require 'middleman-search/extension'
  ::Middleman::SearchExtension
end
