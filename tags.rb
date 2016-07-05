module Jekyll
  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'
      self.process(name)

      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['title'] = "Tag:#{tag}"
      self.data['posts'] = site.tags[tag]
      self.data['title_detail'] = 'タグ「' + tag + '」' + 'がつけられた記事'
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      site.tags.each_key do |tag|
        site.pages << TagPage.new(site, site.source, File.join('tags', tag), tag)
      end
    end
  end

  class TagCloud < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      tag_array = Array.new(0)
      site = context.registers[:site]
      site.tags.each do |tag, tag_pages|
        tag_array << {:title => tag, :count => tag_pages.count}
      end
      tag_array.sort_by!{|item| -item[:count]}

      tagcloud = "<ul>"
      tag_array.each do |tag|
        tagcloud << "<li><a href='#{site.baseurl}/tags/#{tag[:title]}/index.html'>#{tag[:title]} (#{tag[:count]})</a></li>"
      end
      tagcloud << "</ul>"
      "#{tagcloud}"
    end
  end

  class TagCloudPage < Page
    def initialize(site, base, dir)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'
      self.process(name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_list.html')
      self.data['title'] = "タグ一覧"
      self.data['posts'] = site.documents
    end
  end

  class TagCloudPageGenerator < Generator
    safe true
    def generate(site)
      site.pages << TagCloudPage.new(site, site.source, 'tag_list')
    end
  end
end

Liquid::Template.register_tag('tag_cloud', Jekyll::TagCloud)
