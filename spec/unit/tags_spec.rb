require 'spec_helper'

describe Crystal::Tags do
  def new(options)
    Crystal::Tags.new(options)
  end

  context '#tags' do
    it 'folds hashes' do
      new({
        'og' => {
          'title' => 'Caesar must die'
        }
      }).tags.should == [
        tag('og:title', 'Caesar must die')
      ]
    end

    it 'sorts keys in hashes alphabetically' do
      new({
        'og' => {
          'type' => 'book',
          'title' => 'One day of Ivan Denisovich'
        }
      }).tags.should == [
        tag('og:title', 'One day of Ivan Denisovich'),
        tag('og:type', 'book')
      ]
    end

    it 'moves url key to the top' do
      new({
        'og' => {
          'image' => [
            {
              'url' => '1.png',
              'width' => 200,
              'height' => 300,
            },
            {
              'url' => '2.png',
              'width' => 400,
              'height' => 500,
            },
          ]
        }
      }).tags.should == [
        tag('og:image:url', '1.png'),
        tag('og:image:height', 300),
        tag('og:image:width', 200),
        tag('og:image:url', '2.png'),
        tag('og:image:height', 500),
        tag('og:image:width', 400),
      ]
    end

    it 'duplicates tags for arrays' do
      new('og:image' => ['1.png', '2.png']).tags.should == [
        tag('og:image', '1.png'),
        tag('og:image', '2.png')
      ]
    end

    it 'interpolates values' do
      new({
        :og => {
          :title     => 'The Rock (%{year})',
          :site_name => 'IMDb'
        },
        :year => 1996,
        :head => '%{og:title} - %{og:site_name}'
      }).tags.should == [
        tag('head', 'The Rock (1996) - IMDb'),
        tag('og:site_name', 'IMDb'),
        tag('og:title', 'The Rock (1996)'),
        tag('year', 1996)
      ]
    end
  end

  context '#find_by_name' do
    it 'returns first tag' do
      new('og' => {'image' => %w{1.png 2.png}}).find_by_name(:"og:image").value.should == '1.png'
    end

    it 'raises an error if tag was not found' do
      expect { new({}).find_by_name('og:image') }.to raise_error(Crystal::TagNotFound)
    end
  end

  context '#filter' do
    subject {
      new({
        'og' => {
          'image' => %w{1.png 2.png},
          'title' => 'Title'
        },
        'fb:admins' => '322132'
      })
    }

    context 'without pattern' do
      it 'returns all tags' do
        subject.filter.should == [
          tag('fb:admins', '322132'),
          tag('og:image',  '1.png'),
          tag('og:image',  '2.png'),
          tag('og:title',  'Title')
        ]
      end
    end

    context 'with string' do
      it 'returns tags with this name' do
        subject.filter('og:image').should == [
          tag('og:image', '1.png'),
          tag('og:image', '2.png')
        ]
      end
    end

    context 'with regexp' do
      it 'returns tags with names matched regexp' do
        subject.filter(/og/).should == [
          tag('og:image', '1.png'),
          tag('og:image', '2.png'),
          tag('og:title', 'Title')
        ]
      end
    end
  end
end
