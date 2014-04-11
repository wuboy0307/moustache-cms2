class ThemeCollection 
  include Mongoid::Document
  include Mongoid::Timestamps

  include MoustacheCms::Siteable
  include MoustacheCms::CreatedUpdatedBy
  # -- Callbacks ---
  # before_destroy :remove_folder 
  
  created_updated(:theme_collections)
  
  attr_accessible :name

  # -- Fields ---
  field :name

  # -- Associations ----------
  has_many :theme_assets

  # -- Initialize assets ---
  
  def load_assets
    if self.persisted?
      self.theme_assets.delete_all
      base_dir = Rails.env == 'development' ? 'vendor' : 'public'
      files = Dir.glob("#{Rails.root}/#{base_dir}/assets/*/#{self.name}/*")
      files.each do |file|
        unless File.basename(file) =~ /^_.*/ || File.directory?(file) # don't load partials or sub directories
          self.theme_assets << ThemeAsset.new(asset_path: file, asset_collection_name: self.name)
        end
      end
      self.save
    end
  end
  
end
