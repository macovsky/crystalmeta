require 'spec_helper'

describe Crystal::Tag do
  subject { Crystal::Tag.new('og:title', 'Caesar must die') }
  its(:name) {should == 'og:title'}
  its(:value) {should == 'Caesar must die'}
  its(:name_key) { should == :property }

  context 'for twitter' do
    subject { Crystal::Tag.new('twitter:title', 'Caesar must die') }
    its(:name_key) { should == :name  }
  end

  describe '#value_for_context' do
    let(:context) { double }

    it 'returns asset path if asset' do
      image = '1.png'
      asset_path = "/assets/#{image}"
      context.should_receive('image_path').with(image).and_return(asset_path)
      tag('og:image', image).value_for_context(context).should == asset_path
    end

    it 'returns iso8601 for date' do
      tag('date', Date.parse('1979-12-09')).value_for_context(context).should == '1979-12-09'
    end

    it 'returns iso8601 for time' do
      tag('date', DateTime.parse('1979-12-09 13:09')).value_for_context(context).should == '1979-12-09T13:09:00+00:00'
    end

    it 'returns original value otherwise' do
      tag('og:image:width', 100).value_for_context(context).should == 100
      tag('published', true).value_for_context(context).should be_true
    end
  end
end
