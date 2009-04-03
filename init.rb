# Include hook code here
require 'acts_as_vacl'

ApplicationController.prepend_view_path( File.join( File.dirname( __FILE__ ), 'app', 'views' ) )

model_path = File.join( directory, 'lib', 'app', 'models' )
$LOAD_PATH << model_path
ActiveSupport::Dependencies.load_paths << model_path
