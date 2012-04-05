def find_asset_collection(c_name)
  AssetCollection.where(:name => c_name).first
end

def find_site_asset(collection, site_asset_name)
  collection.site_assets.where(:name => site_asset_name).first
end

Given /^these site assets exist in the collection "([^\"]*)" in the site "([^\"]*)" created by user "([^\"]*)"$/ do |c_name, site, username, table|
  user = User.find_by_username(username)
  site = Site.match_domain(site).first
  @collection = find_asset_collection(c_name)
  table.hashes.each do |hash|
    @collection.site_assets << Factory.build(:site_asset, :name => hash[:name], :creator_id => user.id, :updator_id => user.id, :asset => AssetFixtureHelper.open("rails.png"))
  end
  @collection.save
end

Given /^"([^"]*)" has created the site asset "([^"]*)" in the collection "([^"]*)"$/ do |username, asset_name, c_name|
  user = User.find_by_username(username)
  @collection = find_asset_collection(c_name)
  When %{I go to the new admin asset collection site asset page for "#{@collection.to_param}"}
  Given %{I fill in "site_asset_name" with "#{asset_name}"} 
  Given %{I attach the file "spec/fixtures/assets/rails.png" to "site_asset_asset"}
  Given %{I press "Save Asset"} 
  @collection = find_asset_collection(c_name)
end

When /^I view the collection "([^\"]*)" admin asset collection site assets page$/ do |c_name|
  collection = find_asset_collection(c_name)
  When %{I go to the admin asset collection site assets page for "#{collection.to_param}"}
end

Then /^navigate to the admin asset collection site assets page for "([^\"]*)"$/ do |c_name|
  collection = find_asset_collection(c_name)
  Then %{I should be on the admin asset collection site assets page for "#{collection.to_param}"}
end

Then /^I should view the collection "([^"]*)" admin asset collection site assets page$/ do |c_name|
  collection = find_asset_collection(c_name)
  Then %{I should be on the admin asset collection site assets page for "#{collection.to_param}"}
end

Then /^I should now be editing the site asset "([^"]*)" in the collection "([^"]*)"$/ do |site_asset_name, c_name|
  collection = find_asset_collection(c_name)
  @site_asset = find_site_asset(collection, site_asset_name)
  Then %{I should be on the edit admin asset collection "#{collection.to_param}" site asset page for "#{@site_asset.to_param}"} 
end

Then /^I should see the filename of the site asset$/ do
  site_asset = find_site_asset(@collection, @site_asset.name)
  page.should have_selector("img[src$='#{@site_asset.asset.url}']")
end