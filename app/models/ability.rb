class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new

    if user.role? :editor
      can :read, User, :site_id => user.site_id
      can [:update, :destroy], User, :username => user.username, :site_id => user.site_id
      can :change_password, User, :id => user.id, :site_id => user.site_id

      can [:read, :update, :destroy], Page do |page|
        page.editors.include?(user) && page.site_id == user.site_id
      end
      
      can :read, ArticleCollection, :site_id => user.site_id
      can :manage, Article, do |article|
        article._parent.editors.include?(user) && article.site_id == user.site_id
      end

      can :read, AssetCollection, :site_id => user.site_id   
      can :manage, SiteAsset, do |site_asset|
        site_asset._parent.site_id == user.site_id
      end

      can :manage, PagePart, do |page_part|
        page_part._parent.site_id == user.site_id
      end

      can :manage, MetaTag, do |meta_tag|
        if meta_tag._parent.class.name == "Site"
          meta_tag._parent.id == user.site_id
        else
          meta_tag._parent.site_id == user.site_id
        end
      end
      cannot :manage, [Site, Layout, ThemeAsset, Snippet]
    end

    if user.role? :designer
      can :manage, [Layout, Page, ArticleCollection, AssetCollection, ThemeAsset, Snippet], :site_id => user.site_id  
    end

    if user.role? :admin
      can :manage, Site, :id => user.site_id

      can :manage, User, :site_id => user.site_id
      cannot :change_password, User do |u|
        u.id != user.id
      end
    end

  end
end
