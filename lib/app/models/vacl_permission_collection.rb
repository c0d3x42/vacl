class VaclPermissionCollection < ActiveRecord::Base
  belongs_to :vacl_permission
  belongs_to :vacl_permission_set
end

