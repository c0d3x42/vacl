class VaclPermission < ActiveRecord::Base
  has_many :vacl_permission_collections
  has_many :vacl_permission_sets, :through => :vacl_permission_collections
end

