require 'middleman-core'
require 'middleman-search/search-index-resource'

module Middleman
  class SearchExtension < Middleman::Extension
    option :resources, [], 'Paths of resources to index'
    option :fields, {}, 'Fields to index, with their options'
    option :before_index, nil, 'Callback to execute before indexing a document'
    option :index_path, 'search.json', 'Index file path'
    option :pipeline, {}, 'Javascript pipeline functions to use in lunr index'
    option :cache, false, 'Avoid the cache to be rebuilt on every request in development mode'
    option :language, 'en', 'Language code ("es", "fr") to use when indexing site\'s content'
    option :lunr_dirs, [], 'Directories in which to look for custom lunr.js files'

    def manipulate_resource_list(resources)
      resources.push Middleman::Sitemap::SearchIndexResource.new(@app.sitemap, @options[:index_path], @options)
      resources
    end

    helpers do
      def search_lunr_js_pipeline
        # Thanks http://stackoverflow.com/a/20187415/12791
        extensions[:search].options[:pipeline].map do |name, function|
          "lunr.Pipeline.registerFunction(#{function}, '#{name}');"
        end.join("\n")
      end

      def search_index_path
        (config || app.config)[:http_prefix] + sitemap.find_resource_by_path(extensions[:search].options[:index_path]).destination_path
      end
    end
  end
end
