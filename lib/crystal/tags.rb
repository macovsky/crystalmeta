module Crystal
  class TagNotFound < StandardError
  end

  class Tags
    attr_reader :tags
    delegate :each, :to => :tags

    def initialize(options)
      @tags = []
      add_hash(options)
      InterpolatesTags.new(self).interpolate!
    end

    def find_by_name(name)
      name = name.to_s
      tags.find{|tag| tag.name == name} || raise(TagNotFound, %|can't find meta tag "#{name}"|)
    end

    def filter(pattern = //)
      tags.select{|tag| pattern === tag.name}
    end

    private

    def add_hash(hash, prefix = nil)
      sort_keys(hash.keys).each{|k| add(k, hash[k], prefix)}
    end

    # Sorts keys alphabetically and also bubble url to the top
    def sort_keys(keys)
      keys = keys.sort
      if index = keys.index('url')
        keys.unshift(keys.delete_at(index))
      else
        keys
      end
    end

    def add(name, value, prefix = nil)
      name = [prefix, name].reject(&:blank?).join(":")
      case value
      when Hash
        add_hash(value, name)
      when Array
        value.each{|v| add(name, v)}
      else
        tags << Tag.new(name, value)
      end
    end
  end
end
