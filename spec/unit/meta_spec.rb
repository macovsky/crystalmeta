require 'spec_helper'

describe Crystal::Meta do
  def options
    subject.send(:options)
  end

  context '#store' do
    it 'stringifies keys' do
      subject.store :title => 'something'
      subject.store :head => 'something else'
      options.should == {'title' => 'something', 'head' => 'something else'}
    end

    it 'merges options deeply' do
      subject.store({
        :og => {
          :title => 'og title',
          :site_name => 'site name'
        }
      })

      subject.store({
        'og' => {
          'site_name' => 'site name 2',
          'url' => 'something',
        },
        :"fb:admins" => '322132'
      })

      options.should == {
        'og' => {
          'title' => 'og title',
          'site_name' => 'site name 2',
          'url' => 'something',
        },
        'fb:admins' => '322132'
      }
    end
  end
end
