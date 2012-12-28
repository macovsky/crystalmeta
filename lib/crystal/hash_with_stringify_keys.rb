module Crystal
  class HashWithStringifyKeys < Hash
    def initialize(constructor = {})
      if constructor.is_a?(Hash)
        super()
        update(constructor).stringify_keys!
      else
        super(constructor)
      end
    end

    # https://github.com/intridea/hashie/blob/master/lib/hashie/extensions/key_conversion.rb

    # Convert all keys in the hash to strings.
    # @example
    #   test = {:abc => 'def'}
    #   test.stringify_keys!
    #   test # => {'abc' => 'def'}
    def stringify_keys!
      keys.each do |k|
        stringify_keys_recursively!(self[k])
        self[k.to_s] = self.delete(k)
      end
      self
    end

    # Return a new hash with all keys converted
    # to strings.
    def stringify_keys
      dup.stringify_keys!
    end

    protected

    # Stringify all keys recursively within nested
    # hashes and arrays.
    def stringify_keys_recursively!(object)
      if self.class === object
        object.stringify_keys!
      elsif ::Array === object
        object.each do |i|
          stringify_keys_recursively!(i)
        end
        object
      elsif object.respond_to?(:stringify_keys!)
        object.stringify_keys!
      else
        object
      end
    end
  end
end
