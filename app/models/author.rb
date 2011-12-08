class Author
  include Mongoid::Document 
  include Mongoid::Timestamps

  attr_accessible :prefix,
                  :firstname,
                  :middlename,
                  :lastname,
                  :profile

  # -- Fields ------
  field :prefix
  field :firstname
  field :middlename
  field :lastname
  field :profile

  # -- Associations
  belongs_to :site
  belongs_to :created_by, :class_name => "User"
  belongs_to :updated_by, :class_name => "User"
end
