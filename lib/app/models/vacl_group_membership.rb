class VaclGroupMembership < ActiveRecord::Base
  belongs_to :vacl_group
  belongs_to :vacl_user
end

