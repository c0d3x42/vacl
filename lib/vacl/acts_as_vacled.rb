module ActsAsVacled
  def self.included( base_class )
    base_class.extend ActsAsMethods
  end

  module ActsAsMethods
    def acts_as_vacled( options = {} )
      ActsAsVacl::ModelRegistry.instance.register_vacled_class(self, options )
      nil
    end
  end #module ActsAsMethods

  def self.extend_vacled_class( klass, options )
    user_class = VaclCommon::OPTIONS[:user_class].constantize

    RAILS_DEFAULT_LOGGER.info "Extending klass: #{klass}"

    klass.class_eval do
        has_one :vacl_thing_owner, :as => :ownable
        has_one :vacl, :through => :vacl_thing_owner
        has_one :creator, :through => :vacl_thing_owner

        delegate :login, :to => :creator, :prefix => true



        #named_scope :acld, :joins => { :acl => [ { :groups => :memberships }, { :permission_sets => :permissions } ] }
        named_scope :vacld, :joins => { :vacl => [ { :vacl_groups => :vacl_group_memberships }, { :vacl_permission_sets => :vacl_permission_collections } ] }

#        named_scope :has_perm, lambda{ |pid| { :conditions => [ 'vacl_permissions.id = ?', pid ] } }
        named_scope :has_perm, lambda{ |pid| { :conditions => { :vacl_permission_collections => { :vacl_permission_id => pid } } } }
#        named_scope :has_read_perm, { :conditions => [ 'vacl_permission_collections.permission_id = ?', VaclPermission.find_by_name('read').id ] }
        #named_scope :by_user, lambda{ |uid| { :conditions => [ 'vacl_group_memberships.user_id = ?', uid ] } }
        named_scope :by_user, lambda{ |uid| { :conditions => { :vacl_group_memberships => { :user_id => uid } } } }
        named_scope :not_owned_by, lambda{ |uid| { :joins => :vacl, :conditions => [ "vacl_thing_owners.creator_id != ?", uid ] } }
    end

    #
    # now go over the all the Permisisons and create named scopes for them
    #
    perms = VaclPermission.find( :all ).uniq
    perms.each{ |p|
      #
      # this creates things like:
      # Question.acldt.has_exec_perm
      #
      perm_name = p.name.to_s.downcase

      scope_perm = "has_" + perm_name + "_perm"
      scope_perm = scope_perm.to_sym
      klass.class_eval do
        named_scope scope_perm, { :conditions => [ "vacl_permission_collections.permission_id = #{p.id}" ] }
      end
    }

    #
    # now to setup the reverse associations going from the user class to the thing being acld
    #
    m = "owned_" << klass.to_s.downcase.pluralize
    RAILS_DEFAULT_LOGGER.info "creating thing on user: #{m}"

    f = "findable2_" << klass.to_s.downcase.pluralize
    fsym = f.to_sym
    RAILS_DEFAULT_LOGGER.info "making f: #{f} / #{fsym} on users klass: #{user_class}"

    cf = klass
    user_class.class_eval do
      has_many m.to_sym, :through => :vacl_thing_owners, :source => :ownable, :source_type => klass.to_s
      named_scope fsym, { :joins => :vacl_thing_owners }

      def findable_thing(*args)
        cf.acld.by_user(self.id).find args
      end
    end

    perms.each{ |p|
      perm_name = p.name.to_s.downcase.singularize
      f = perm_name << "able_" << klass.to_s.downcase.pluralize
      RAILS_DEFAULT_LOGGER.info "adding #{f} to user klass: #{user_class} from #{klass}"
      user_class.class_eval do
        has_many f.to_sym 
      end
    }
  end

end #module ActsAsVacled
