module Crystal
  class InterpolatesTags < Struct.new(:tags)
    def interpolate!
      tags.each{|tag| interpolate_tag!(tag)}
    end

    private

    def interpolate_tag!(tag)
      if tag.value.respond_to?(:gsub)
        tag.value = tag.value.gsub(/%\{([\w:-]+)\}/) do |match|
          interpolate_tag!(tags.find_by_name($1))
        end
      end

      tag.value
    end
  end
end
