module VaclCommon
   USER_CLASS = "VaclUser"


   unless const_defined?('OPTIONS')
      OPTIONS = {}
   end

   DEFAULT_OPTIONS = {
      :user_class => USER_CLASS
    }

   OPTIONS.replace DEFAULT_OPTIONS.merge(OPTIONS)
      
   def user_class_is
      uc = OPTIONS[:user_class]
      uc.constantize
   end
end

