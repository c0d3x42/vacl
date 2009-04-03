class Vacl < ActiveRecord::Base
  has_many :vacl_grants
  has_many :vacl_permission_sets, :through => :vacl_grants
  has_many :vacl_groups, :through => :vacl_grants
  belongs_to :creator, :class_name => "<%=user_class_name%>"

  has_many :vacl_grants_add, :foreign_key => :vacl_id, :class_name => "VaclGrant", :conditions => { :direction => "add" }
  has_many :groups_added, :through => :vacl_grants_add, :source => :vacl_group
  has_many :positive_permission_sets, :through => :vacl_grants_add, :source => :vacl_permission_set

  has_many :vacl_grants_subtract, :foreign_key => :vacl_id, :class_name => "VaclGrant", :conditions => { :direction => "subtract" }
  has_many :groups_subtracted, :through => :vacl_grants_subtracted, :source => :vacl_group
  has_many :negative_permission_sets, :through => :vacl_grants_subtract, :source => :vacl_permission_set


  validates_uniqueness_of :name, :scope => :creator_id, :message => "Acl names must be unique"
  validates_uniqueness_of :default_vacl, :scope => :creator_id, :message => "Can have only one default acl"

  def find_users( perm )
    VaclUser.find :all, :joins => { :vacl_group_memberships => { :vacl_group => { :vacl_grants => :vacl_permission } } }, :conditions => "vacl_grants.acl_id = #{id} AND vacl_permissions.name = '#{perm}'"
  end

  def find_users_new( perm )
    VaclUser.find :all, :joins =>
    { 
      :vacl_group_memberships =>
      { 
        :vacl_group =>
        [ 
          [ :vacl_grants_add, :permissions ],
          [ :vacl_grants_subtract, :permissions ]
        ]
      }
    }
  #, :conditions => "acl_grants.acl_id = #{id} AND permissions.name = '#{perm}'"
  end


  def find_perms( user )
    Permission.find :all, :joins => {  :vacl_grants => { :vacl_group => { :vacl_group_memberships => :vacl_user } } }, :conditions => "vacl_grants.id = #{id} AND vacl_users.login = '#{user}'"
  end

  def find_perms2( user )
    if user.is_a?(String)
      user = VaclUser.find_by_login( user )
    end
    VaclPermission.find :all, :joins => { :vacl_permission_sets => [ :vacls, { :vacl_groups => :vacl_users } ] }, :conditions => "vacl_users.login='#{user.login}' AND vacls.id=#{self.id}"
  end

  def user_has_perm?( user, perm )
    if perm.is_a?( String )
      perm = VaclPermission.find_by_name( perm )
    end
    perms = find_perms2( user )
    perms.member?( perm )
  end

  def find_users_with_perm( p )
    VaclUser.find :all, :joins => { :vacl_group_memberships => { :vacl_permission_sets => :vacl_permissions } }, :conditions => "vacl_grants.vacl_id = #{self.id} AND vacl_permissions.id = #{p.id}"
  end

  def find_user_with_perm( user, perm )
    if user.is_a?(String)
      user = VaclUser.find_by_login( user )
    end
    if perm.is_a?(String)
      perm = VaclPermission.find_by_name(perm)
    end
    VaclUser.find :all, :joins => { :vacl_group_memberships => { :vacl_permission_sets => :vacl_permissions } }, :conditions => "vacl_group_memberships.user_id=#{user.id} AND vacl_permissions.id = #{perm.id} AND vacl_grants.vacl_id = #{self.id}"
  end

  named_scope :scope_default, :conditions => { :default_vacl => true }
  named_scope :joins_with_memberships, lambda{ { :joins => { :vacl_groups => :vacl_group_memberships } } }
  named_scope :includes_user, lambda{ |u| { :joins => { :vacl_groups => :vacl_group_memberships }, :conditions => [ 'vacl_group_memberships.user_id = ?', u.id ] } }
  named_scope :includes_user_and_perm, lambda{ |u,p| { :joins => { :vacl_permission_sets => :vacl_permissions, :vacl_groups => :vacl_group_memberships }, :conditions => [ 'vacl_group_memberships.user_id = ? AND vacl_permissions.id = ?', u.id, p.id ] } }
  named_scope :joins_with_permissions, lambda{ { :joins => { :vacl_permission_sets => :vacl_permissions } } }
  perms_plus_user = joins_with_memberships + joins_with_permissions



#  has_finder :defacls, :conditions => { :default => true }
end

