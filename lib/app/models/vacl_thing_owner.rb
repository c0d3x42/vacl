class VaclThingOwner < ActiveRecord::Base
  belongs_to :vacl
  belongs_to :creator, :class_name => "VaclUser"
  belongs_to :ownable, :polymorphic => true

  after_create :set_default_acl

  def set_default_acl()
#    self.acl = creator.default_acl
    self.acl = creator.my_default_acl
    self.save
  end

    named_scope :not_owner, lambda{ |*args| { :conditions => [ "thing_owner != ?", (args.first || -1 ) ] } }

end

