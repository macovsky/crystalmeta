require 'spec_helper'

describe Crystal::HashWithStringifyKeys do
  def new(*args)
    Crystal::HashWithStringifyKeys.new(*args)
  end

  context '.new' do
    it 'stringifies keys when hash is passed' do
      expect(new(key: {key2: 1})).to eq Hash['key' => {'key2' => 1}]
    end

    it 'keeps a default value if one argument has been passed' do
      expect(new(1)['unknown']).to eq 1
    end

    it 'returns an empty hash when no args have been passed' do
      expect(new).to be_empty
      expect(new['unknown']).to be_nil
    end
  end

  context '#deep_merge with the same tag' do
    it 'returns a hash with stringified keys' do
      hash = new(:key => {:key2 => 1})
      merge = hash.deep_merge!(new(:key => {:key2 => 2}))
      expect(merge).to eq Hash['key' => {'key2' => 2}]
      expect(merge).to be_kind_of(Crystal::HashWithStringifyKeys)
    end
  end
end
