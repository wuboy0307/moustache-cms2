require 'spec_helper'

describe Admin::MetaTagsController do

  before(:each) do
    login_admin
    @page = mock_model("Page", :site_id => @site.id).as_null_object 
    @meta_tag = mock_model("MetaTag", :name => "DC.author", :_parent => @page) 
    @meta_tags = [@meta_tag]

    Page.stub(:find).and_return(@page)
  end

  # -- Get New ----
  describe "GET /new" do

    before(:each) do
      @meta_tag.as_new_record
      @page.stub(:meta_tags).and_return(@meta_tags)
      @meta_tags.stub(:new).and_return(@meta_tag)
    end

    def do_get
      get :new, :page_id => @page.id
    end

    it "should receive create a new hash" do
      @meta_tags.should_receive(:new).and_return(@meta_tag)
      do_get
    end

    it "should assign the meta tag" do
      do_get
      assigns(:meta_tag).should == @meta_tag
    end

    it "should render the new template" do
      do_get
      response.should render_template("admin/meta_tags/new")
    end
  end

  # -- Get Edit
  describe "GET /EDIT" do

    before(:each) do
      @page.stub_chain(:meta_tags, :find).and_return(@meta_tag)
    end 

    def do_get
      get :edit, :page_id => @page.id, :id => @meta_tag.id
    end

    it "should assign the meta_tag" do
      do_get
      assigns(:meta_tag).should == @meta_tag
    end

    it "should render the template admin/meta_tags/edit" do
      do_get
      response.should render_template("admin/meta_tags/edit")
    end

  end

  # -- Post Create ----
  describe "POST /create" do

    let(:params) { {"name" => "DC.author", "content" => "Foobar Baz"} }

    before(:each) do
      @page.stub(:meta_tags).and_return(@meta_tags)
      @meta_tags.stub(:new).and_return(@meta_tag)
      @meta_tag.stub(:save).and_return(true)
    end

    def do_post(post_params=params)
      post :create, :page_id => @page.id, :meta_tag => post_params 
    end

    it "should create a new meta_tag from the params" do
      @meta_tags.should_receive(:new).with(params).and_return(@meta_tag)
      do_post
    end

    context "with valid params" do
      before(:each) do
        @page.stub_chain(:meta_tags, :push).and_return(@meta_tag)
      end

      it "should assign a flash message that the meta_tag was created" do
        do_post
        flash[:notice].should == "Successfully created the meta tag #{@meta_tag.name}"
      end

      it "should redirect to the page the meta tags were created for" do
        do_post
        response.should redirect_to([:edit, :admin, @page])
      end
    end

    context "with invalid params" do
      before(:each) do
        @meta_tag.stub(:save).and_return(false)
        @meta_tag.stub(:errors => { :meta_tag => "meta_tag errors" })
      end

      it "should render the new template when creating the meta_tag fails" do
        do_post
        response.should render_template("admin/meta_tags/new")
      end
    end
  end


  # -- Put Update ---
  describe "PUT /update" do

    let(:params) { {:page_id => @page.id, :id => @meta_tag.id, :meta_tag => {"name" => "DC.author", "content" => "Foo Bar"}} }

    before(:each) do
      @page.stub_chain(:meta_tags, :find).and_return(@meta_tag)
      @meta_tag.stub(:update_attributes).and_return(true)
    end

    def do_put(put_params=params)
      put :update, put_params
    end

    it "should assign @meta_tag for the view" do
      do_put
      assigns(:meta_tag).should == @meta_tag
    end

    context "with valid params" do
      
      it "should receive update_attributes successfully" do
        @meta_tag.should_receive(:update_attributes).with(params[:meta_tag]).and_return(true)
        do_put
      end

      it "should redirect back to the page" do
        do_put
        response.should redirect_to([:edit, :admin, @page])
      end

      it "should set the the flash notice message" do
        do_put
        flash[:notice].should == "Successfully updated the meta tag #{@meta_tag.name}"
      end
    end

    context "with invalid params" do
      before(:each) do
        @meta_tag.should_receive(:update_attributes).and_return(false)
        @meta_tag.stub(:errors => { :meta_tag => "meta_tag errors" })
      end

      it "should render the meta_tag edit view" do
        do_put
        response.should render_template("admin/meta_tags/edit")
      end
    end
  end

  # -- Delete Destroy --- 
  describe "DELETE /destroy" do

    let(:params) { {:page_id => @page.id, :id => @meta_tag.id} }

    before(:each) do
      @page.stub_chain(:meta_tags, :find).and_return(@meta_tag)
      @meta_tag.stub(:destroy).and_return(true)
      @meta_tag.stub(:persisted?).and_return(false)
    end

    def do_delete(destroy_params=params)
      delete :destroy, destroy_params
    end

    context "with valid params" do
      it "should destroy the meta_tag" do
        @meta_tag.should_receive(:destroy).and_return(true)
        do_delete
      end

      it "should set the the flash notice message" do
        do_delete
        flash[:notice].should == "Successfully deleted the meta tag #{@meta_tag.name}"
      end

      it "should redirect to the page" do
        do_delete
        response.should redirect_to([:edit, :admin, @page])
      end
    end
  end
end
