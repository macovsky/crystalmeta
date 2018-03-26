require 'spec_helper'

RSpec.describe 'meta tags', type: :feature do
  def meta_tags(pattern = //)
    all(:css, 'meta', visible: :hidden).select{|meta| pattern === meta[:property] || pattern === meta[:name] }
  end

  def value_for(pattern = //)
    meta_tags(pattern).first[:content]
  end

  def title
    page.html.match(%r{<title>(.*?)</title>})[1]
  end

  context 'on movie page' do
    before do
      visit movie_path('rock')
    end

    it 'include og:title from controller' do
      expect(value_for('og:title')).to eq 'The Rock (1996)'
    end

    it 'include og:image from locale' do
      expect(value_for('og:image')).to eq 'http://www.example.com/images/rock.jpg'
    end

    it 'include og:image from locale' do
      expect(value_for('twitter:card')).to eq 'summary'
    end

    it 'include og:type from controller defaults' do
      expect(value_for('og:type')).to eq 'video.movie'
    end

    it 'include title expect(with interpolation' do
      expect(title).to eq 'The Rock (1996) - IMDb'
    end
  end

  context 'on movies page' do
    before do
      visit movies_path
    end

    it 'include og:title & og:type from views' do
      expect(value_for('og:title')).to eq 'Movies'
      expect(value_for('og:type')).to eq 'article'
    end

    it 'include default title' do
      expect(title).to eq 'Movies on IMDb'
    end
  end
end
