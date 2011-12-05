require 'spec_helper'

describe "ArticleCollection" do
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user) }
  let(:article) { Factory.build(:article, :site => site, :created_by => user, :updated_by => user) }

  before(:each) do
    @article_collection = Factory(:article_collection, :articles => [article], :site => site, :created_by => user, :updated_by => user)           
  end

  # --  Associations ---- 
  describe "associations" do
    it "should belong_to a site" do
      @article_collection.should belong_to(:site)
    end

    it "should belong_to a user with created_by" do
      @article_collection.should belong_to(:created_by).of_type(User)
    end

    it "should belong_to a user with updated_by" do
      @article_collection.should belong_to(:updated_by).of_type(User)
    end

    it "should embed many articles" do
      @article_collection.should embed_many :articles
    end
    
  end
end
