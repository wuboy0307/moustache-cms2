module Admin::MetaTagsHelper

  def add_meta_tag(message, object)
    if object.new_record?
      content_tag :p do
        content_tag :i, message
      end
    else
      link_to "Add Meta Tag", [:new, :admin, object, :meta_tag], :remote => :true
    end
  end

end
