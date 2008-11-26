class CreateInitialRows < ActiveRecord::Migration
  def self.up
    %w{ read write exec update }.each{ |p| VaclPermission.create :name => p }
  end

  def self.down
    %w{ read write exec update }.each{ |p| VaclPermission.create :name => p }
  end
end
