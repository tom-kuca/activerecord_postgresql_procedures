
require 'config'
require 'active_record'
require 'support/config'
require 'support/connection'

# Connect to the database
ARPPTest.connect


def load_schema
	# silence verbose schema loading
	original_stdout = $stdout
	$stdout = StringIO.new
	load SCHEMA_PATH
ensure
	$stdout = original_stdout
end

load_schema