require 'singleton'

module ActsAsVacl
  class ModelRegistry
    include Singleton

    def initialize
       @user_class_info = nil
       #
       # vacl_class_info probably should be an array...
       #
       @vacl_class_info = nil

       @vacl_class_options = {}
    end

    def register_user_class(klass)
       raise ArgumentError, "#{klass} is not a descendant of ActiveRecord::Base!" unless ActiveRecord::Base > klass
       RAILS_DEFAULT_LOGGER.info "registering user class '#{klass}'"

       if not @user_class_info.nil? and klass == @user_class_info[:class] then
          logger.debug "Ignoring registration of user class '#{klass}' since it is already registered."
          return
       end

       logger.debug "Unregistering previous user class '#{@user_class_info[:class]}'." if not @user_class_info.nil?
       logger.debug "Registering class '#{klass}' as new user class."

       @user_class_info = { :class => klass }

       update_classes(:user)
    end

    def register_vacled_class(klass, options = {} )
       raise ArgumentError, "#{klass} is not a descendant of ActiveRecord::Base!" unless ActiveRecord::Base > klass
       RAILS_DEFAULT_LOGGER.info "registering vacled class '#{klass}"

       if not @vacl_class_info.nil? and klass == @vacl_class_info[:class] then
          logger.debug "Ignoring registration of vacl class '#{klass}' since it is already registered."
          return
       end

       logger.debug "Unregistering previous user class '#{@vacl_class_info[:class]}'." if not @vacl_class_info.nil?
       logger.debug "Registering class '#{klass}' as new vacl class."

       @vacl_class_info = { :class => klass }
       @vacl_class_options[ klass.to_s.downcase.singularize.to_sym ] = options

       update_vacled_classes( klass )
    end

    protected

    def update_classes(last_changed=nil)
       if (not @user_class_info.nil?) then
          update_user_class
       end
    end

    def update_user_class
       ActsAsVaclParticipant.extend_user_class(@user_class_info[:class], {} )
    end

    def update_vacled_classes(klass)
       if( not @vacl_class_info.nil? ) then
          #ActsAsVacled.extend_vacled_class( @vacl_class_info[:class], {} )
          ActsAsVacled.extend_vacled_class( @vacl_class_info[:class], @vacl_class_options[ klass.to_s.downcase.singularize.to_sym ] )
       end
    end

    def logger
       RAILS_DEFAULT_LOGGER
    end
  end
end

