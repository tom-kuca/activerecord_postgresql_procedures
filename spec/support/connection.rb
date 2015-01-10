module ARPPTest
  def self.connection_name
    ENV['ARCONN'] || config['default_connection']
  end

  def self.connection_config
    config['connections']
  end

  def self.connect
    puts "Using #{connection_name}"
    ActiveRecord::Base.configurations = connection_config
    ActiveRecord::Base.establish_connection connection_name.to_sym
  end
end
