module AssetFixtureHelper
  def self.open(filename)
    File.new(self.path(filename))
  end

  def self.path(filename)
    File.join("#{Rails.root}", 'spec', 'fixtures', 'assets', filename)
  end

  def self.reset!
    FileUtils.rm_rf(File.join("#{Rails.root}", 'spec', 'tmp'))
    FileUtils.mkdir(File.join("#{Rails.root}", 'spec', 'tmp'))
  end
end