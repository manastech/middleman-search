require 'middleman-core'
require 'middleman-search/search-index-resource'

module Middleman
  class SearchExtension < Middleman::Extension
    option :resources, [], 'Paths of resources to index'
    option :fields, {}, 'Fields to index, with their options'
    option :index_path, 'search.json', 'Index file path'

    def manipulate_resource_list(resources)
      resources.push Middleman::Sitemap::SearchIndexResource.new(@app.sitemap, @options[:index_path], @options)
      resources
    end
  end
end
