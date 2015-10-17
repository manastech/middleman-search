module Middleman
  module Sitemap
    class SearchIndexResource < ::Middleman::Sitemap::Resource
      def initialize(store, path, options)
        @resources_to_index = options[:resources]
        @fields = options[:fields]
        super(store, path)
      end

      def template?
        false
      end

      def get_source_file
        path
      end

      def render
        # FIXME: add lunr.min.js as a resource
        lunr_source = File.expand_path('../../../vendor/lunr.min.js', __FILE__)

        cxt = V8::Context.new
        cxt.load(lunr_source)
        # add new method to lunr index
        cxt.eval('lunr.Index.prototype.indexJson = function () {return JSON.stringify(this);}')
        #Get the lunjs object
        val = cxt.eval('lunr')
        lunr_conf = proc do |this|
          this.ref('id')
          @fields.each do |field, opts|
            next if opts[:index] == false
            this.field(field, {:boost => opts[:boost]})
          end
        end

        idx = val.call(lunr_conf)
        map = Hash.new

        @app.sitemap.resources.each_with_index do |resource, index|
          next if resource.data['index'] == false
          next unless @resources_to_index.any? {|whitelisted| resource.path.start_with? whitelisted }

          # FIXME: Use config to determine required fields
          title = resource.data.title || resource.metadata[:options][:title] rescue nil
          next if title.blank?

          content = resource.render(layout: false)
          text = Nokogiri::HTML(content).xpath("//text()").text
          url = resource.url
          description = resource.data.description || resource.metadata[:options][:description] rescue nil
          tags = Array(resource.data.tags || []).join(", ")

          # FIXME: Use config to determine what fields are indexed and stored
          idx.add({title: title, body: text, description: description, tags: tags, id: index})
          map[index] = { title: title, url: url }
        end

        "{\"index\": #{idx.indexJson()}, \"map\": #{map.to_json}}"
      end

      def binary?
        false
      end

      def ignored?
        false
      end
    end
  end
end
