require 'securerandom'

if App.environment == :development
  puts "Removing existing data ... \n \n"
  PDS::DataAdapter::PostgreSQL::User.destroy_all
  PDS::DataAdapter::PostgreSQL::Node.destroy_all
  PDS::DataAdapter::PostgreSQL::HieraDatum.destroy_all
  PDS::DataAdapter::PostgreSQL::Changelog.destroy_all

  business_domain_name = 'acme.com'
  users = ['bob', 'alice', 'mary', 'jon', 'carlos']
  nodes = [
    {
      name: "ip-100.#{business_domain_name}",
      code_environment: 'development',
      classes: ['policy::base'],
      data: {},
    },
    {
      name: "ip-101.#{business_domain_name}",
      code_environment: 'development',
      classes: ['policy::base'],
      data: {},
    },
    {
      name: "ip-102.#{business_domain_name}",
      code_environment: 'production',
      classes: ['policy::base', 'policy::tier1'],
      data: {},
    },
  ]

  hiera_data = [
    { level: 'common', key: 'pds::nothing', value: nil },
    { level: 'common', key: 'pds::color', value: 'red' },
    { level: 'priority', key: 'pds::color', value: 'blue' },
    { level: 'common', key: 'pds::distance', value: '10k' },
    { level: 'priority', key: 'pds::distance', value: '42k' },
    { level: 'amer', key: 'pds::weight', value: {'lbs' => 8, 'oz' => 13.1 }},
    { level: 'emea', key: 'pds::weight', value: {'kg' => 4}},
  ]

  puts "Inserting fresh seed data ... \n"

  users.each do |user|
    puts "Creating user #{user.capitalize} ... \n"
    PDS::DataAdapter::PostgreSQL::User.create!(
      username: user,
      email: "#{user}@#{business_domain_name}",
      role: 'operator',
      status: 'active',
      temp_token: SecureRandom.uuid.upcase
    )
  end

  nodes.each do |node_data|
    puts "Creating node #{node_data[:name]} ... \n"
    PDS::DataAdapter::PostgreSQL::Node.create!(node_data)
  end

  hiera_data.each do |data|
    puts "Creating hiera data #{data[:level]}/#{data[:key]} ... \n"
    PDS::DataAdapter::PostgreSQL::HieraDatum.create!(data)
  end
else
  puts 'Error: db:seeds can only run in development'
end

