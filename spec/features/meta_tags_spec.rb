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
      value_for('og:title').should == 'The Rock (1996)'
    end

    it 'include og:image from locale' do
      value_for('og:image').should == '/images/rock.jpg'
    end

    it 'include og:image from locale' do
      value_for('twitter:card').should == 'summary'
    end

    it 'include og:type from controller defaults' do
      value_for('og:type').should == 'video.movie'
    end

    it 'include title with interpolation' do
      title.should == 'The Rock (1996) - IMDb'
    end
  end

  context 'on movies page' do
    before do
      visit movies_path
    end

    it 'include og:title & og:type from views' do
      value_for('og:title').should == 'Movies'
      value_for('og:type').should == 'article'
    end

    it 'include default title' do
      title.should == 'Movies on IMDb'
    end
  end
end
