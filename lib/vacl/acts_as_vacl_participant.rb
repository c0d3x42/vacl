module ActsAsVaclParticipant
  def self.included(base_class )
    base_class.extend ActsAsMethods
  end

  module ActsAsMethods
    def acts_as_vacl_participant
      ActsAsVacl::ModelRegistry.instance.register_user_class(self)
      nil
    end
  end #module ActsAsMethods

  def self.extend_user_class(klass, options)
    RAILS_DEFAULT_LOGGER.info "Extending '#{klass}' with stuff"

    klass.class_eval do
      has_many :vacl_group_memberships
      has_many :group_memberships, :through => :vacl_group_memberships, :source => :vacl_group

      has_many :owned_groups, :foreign_key => :owner_id, :class_name => "VaclGroup"
      has_many :owned_permission_sets, :foreign_key => :owner_id, :class_name => "VaclPermissionSet"


      has_many :vacls, :foreign_key => :creator_id
      has_one :my_default_acl, :foreign_key => :creator_id, :class_name => "Vacl", :conditions => { :default_vacl => true }

      has_many :vacl_thing_owners, :foreign_key => :creator_id

      def default_acl()
        Acl.scope_default.find :first, :conditions => { :creator_id => self.id }
      end

      def fetch_my_perms_for_thing( thing )
        thing.acl.find_perms2( self )
      end


      #
      # class level things
      #
      named_scope :users_permissions, :joins => { :owned_permission_sets => :permissions }
      

    end
  end
end #module ActsAsVaclParticipant
