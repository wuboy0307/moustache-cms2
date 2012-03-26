module Create
  def create_site(site='foobar', domain='example.com')
    @site = Factory.build(:site, :name => site, :subdomain => site, :default_domain => domain)
    @site.add_domain '127.0.0.1'
    @site.save
  end

  def create_layout(name='foobar')
    @layout = Factory(:layout, :name => name, :site => @site, :created_by => @user, :updated_by => @user)
  end  

  def create_page(title, status)
    Factory(:page, :site => @site,
                     :parent_id => @parent.id,
                     :layout => @layout,
                     :created_by => @user,
                     :updated_by => @user,
                     :editors => [@user],
                     :title => title,
                     :current_state => Factory.build(:current_state, :name => status),
                     :page_parts => [Factory.build(:page_part, :name => 'foobar')])

  end

  def create_child_page(title, status, parent)
    Factory(:page, :site => @site,
                     :parent_id => parent.id,
                     :layout => @layout,
                     :created_by => @user,
                     :updated_by => @user,
                     :editors => [@user],
                     :title => title,
                     :current_state => Factory.build(:current_state, :name => status),
                     :page_parts => [Factory.build(:page_part, :name => 'foobar')])

  end

  def create_homepage
    @parent = Factory(:page, :title => 'Homepage', :site => @site, :layout => @layout, :created_by => @user, :updated_by => @user)
  end

  def create_snippet(name)
    @snippet = Factory(:snippet, :name => name, :site => @site)
  end

end
World(Create)
