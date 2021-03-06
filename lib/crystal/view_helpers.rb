module Crystal
  module ViewHelpers
    def meta_tag(name)
      meta.tag_by_name(name).value_for_context(self)
    end

    def meta_tags(pattern = //)
      meta.tags_by_pattern(pattern).map{|t|
        tag(:meta, t.name_key => t.name, :content => t.value_for_context(self))
      }.join("\n").html_safe
    end
  end
end
