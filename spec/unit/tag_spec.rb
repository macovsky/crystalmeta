require 'spec_helper'

RSpec.describe Crystal::Tag do
  context 'for OpenGraph' do
    let(:og_tag) { tag('og:title', 'Caesar must die') }

    it 'has a name of og:title' do
      expect(og_tag.name).to eq 'og:title'
    end

    it 'has a value of ‘Caesar must die’' do
      expect(og_tag.value).to eq 'Caesar must die'
    end

    it 'has a name_key of :property' do
      expect(og_tag.name_key).to eq :property
    end
  end

  context 'for Twitter' do
    it 'has a name_key of :name' do
      expect(tag('twitter:title', 'Caesar must die').name_key).to eq :name
    end
  end

  describe '#value_for_context' do
    let(:context) { double }

    it 'returns asset path if asset' do
      image = '1.png'
      asset_path = "/assets/#{image}"
      allow(context).to receive('image_path').with(image).and_return(asset_path)
      expect(tag('og:image', image).value_for_context(context)).to eq asset_path
    end

    it 'returns iso8601 for date' do
      expect(tag('date', Date.parse('1979-12-09')).value_for_context(context)).to eq '1979-12-09'
    end

    it 'returns iso8601 for time' do
      expect(tag('date', DateTime.parse('1979-12-09 13:09')).value_for_context(context)).to eq '1979-12-09T13:09:00+00:00'
    end

    it 'returns original value otherwise' do
      expect(tag('og:image:width', 100).value_for_context(context)).to eq 100
      expect(tag('published', true).value_for_context(context)).to be true
    end
  end
end
