class ThemeAsset
  include Mongoid::Document
  
  attr_accessible :name, :description, :content_type, :width, :height, :file_size, :source
  
  # -- Fields --------------- 
  field :name
  field :description
  field :content_type
  field :width, :type => Integer
  field :height, :type => Integer
  field :file_size, :type => Integer
  mount_uploader :source, SiteAssetUploader
  
  
  # -- Associations ----------
  belongs_to :site
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
  
end