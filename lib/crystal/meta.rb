module Crystal
  class Meta
    def initialize(options = {})
      @options = HashWithStringifyKeys.new(options)
    end

    def store(new_options)
      options.deep_merge!(HashWithStringifyKeys.new(new_options))
    end

    def tag_by_name(name)
      tags.find_by_name(name)
    end

    def tags_by_pattern(pattern = //)
      tags.filter(pattern)
    end

    private

    def options
      @options
    end

    def tags
      @tags ||= Tags.new(options)
    end
  end
end
