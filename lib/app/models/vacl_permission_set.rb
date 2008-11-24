class VaclPermissionSet < ActiveRecord::Base
  has_many :vacl_permission_collections
  has_many :vacl_permissions, :through => :vacl_permission_collections
  has_many :vacl_grants
  has_many :vacls, :through => :vacl_grants
  has_many :vacl_groups, :through => :vacl_grants
  belongs_to :owner, :class_name => "VaclUser"

end

