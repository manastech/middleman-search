require 'middleman-core'
require 'middleman-search/search-index-resource'

module Middleman
  class SearchExtension < Middleman::Extension
    option :resources, [], 'Paths of resources to index'
    option :fields, {}, 'Fields to index, with their options'

    def manipulate_resource_list(resources)
      index_file_path = 'index.json'
      resources.push Middleman::Sitemap::SearchIndexResource.new(@app.sitemap, index_file_path, @options)
      resources
    end
  end
end
