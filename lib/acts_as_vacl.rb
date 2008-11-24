require 'vacl/common'

require 'vacl/acts_as_vacl_participant'
ActiveRecord::Base.send :extend, ActsAsVaclParticipant::ActsAsMethods

require 'vacl/model_registry'

require 'vacl/acts_as_vacled'
ActiveRecord::Base.send :extend, ActsAsVacled::ActsAsMethods

