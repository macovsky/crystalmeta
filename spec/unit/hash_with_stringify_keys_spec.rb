require 'spec_helper'

describe Crystal::HashWithStringifyKeys do
  def new(*args)
    Crystal::HashWithStringifyKeys.new(*args)
  end

  context '.new' do
    it 'stringifies keys when hash is passed' do
      new(:key => {:key2 => 1}).should == {'key' => {'key2' => 1}}
    end

    it 'keeps a default value if one argument has been passed' do
      new(1)['unknown'].should == 1
    end

    it 'returns an empty hash when no args have been passed' do
      new.should be_empty
      new['unknown'].should be_nil
    end
  end

  context '#deep_merge with the same tag' do
    it 'returns a hash with stringified keys' do
      hash = new(:key => {:key2 => 1})
      merge = hash.deep_merge!(new(:key => {:key2 => 2}))
      merge.should == {'key' => {'key2' => 2}}
      merge.should be_kind_of(Crystal::HashWithStringifyKeys)
    end
  end
end
