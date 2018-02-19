module Crystal
  class Tag < Struct.new(:name, :value)
    def name_key
      name.starts_with?('og:') ? :property : :name
    end

    def value_for_context(context)
      case
      when asset?
        context.send(asset_path_method, value)
      when value.acts_like?(:time)
        value.iso8601
      when value.acts_like?(:date)
        value.strftime('%Y-%m-%d')
      else
        value
      end
    end

    private

    def asset?
      %w{image audio video}.find{|type| name =~ /\b#{type}(:url)?$/}
    end

    def asset_path_method
      "#{asset?}_url"
    end
  end
end
