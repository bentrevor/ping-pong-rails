# Load the Rails application.
require File.expand_path('../application', __FILE__)

# add root directory to load path
$: << Dir.pwd

# Initialize the Rails application.
PingPong::Application.initialize!
