class VaclGrant < ActiveRecord::Base
  belongs_to :vacl
  belongs_to :vacl_group
  belongs_to :vacl_permission_set

  named_scope :additive, :conditions => { :direction => "add" }
  named_scope :subtractive, :conditions => { :direction => "add" }
end

