module Jekyll
  class IssuePage < Page
    def initialize(site, base, dir, issue)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'issue_index.html')
      self.data['issue'] = issue
      puts issue
      if issue['pieces']
        self.data['pieces'] = issue['pieces'].map{|p| site.data['post_hash'][p['link']]}
      else
        self.data['pieces'] = []
      end
      self.data['title'] = "#{issue['title']}"
    end
  end

  class IssuePageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'issue_index'
        dir = "issue"
        site.data['post_hash'] = {}
        site.posts.each do |post|
          site.data['post_hash'][post.name] = post
        end
        site.data['issues'].each do |issue|
          site.pages << IssuePage.new(site, site.source, File.join(dir, issue['number'].to_s), issue)
        end
      end
    end

  end
end
