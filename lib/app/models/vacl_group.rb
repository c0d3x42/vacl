class VaclGroup < ActiveRecord::Base
  has_many :vacl_group_memberships
  has_many :vacl_users, :through => :vacl_group_memberships

  has_many :vacl_grants
  has_many :vacl_grants_add, :class_name => "VaclGrant", :foreign_key => :vacl_group_id, :conditions => { :direction => "add" }
  has_many :vacl_grants_subtract, :class_name => "VaclGrant", :foreign_key => :vacl_group_id, :conditions => { :direction => "subtract" }

  has_many :vacls, :through => :vacl_grants
  has_many :vacl_permission_sets, :through => :vacl_grants

  belongs_to :owner, :class_name => "<%=user_class_name%>"
  named_scope :group_name, lambda{ |arg| { :conditions => [ "name like ?",  arg ] } }
  named_scope :recent, lambda{ |*args| { :conditions => [ "created_at <= ?", ( args.first || 2.weeks.ago ) ] } }
  named_scope :member_name, lambda{ |arg| { :joins => :vacl_users, :conditions => [ "vacl_users.login = ?",  arg ] } }
  #
  # means we can do:
  # u = User.find 1
  # u.owned_groups.recent( 2.weeks.ago )
  # u.owned_groups.recent
  # u.owned_groups.member_name('vince').group_name('lop')
  #


end

