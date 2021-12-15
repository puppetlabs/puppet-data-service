if App.environment == :development
  PDS::DataAdapter::PostgreSQL::User.destroy_all
  PDS::DataAdapter::PostgreSQL::Node.destroy_all
  PDS::DataAdapter::PostgreSQL::HieraData.destroy_all
  PDS::DataAdapter::PostgreSQL::Changelog.destroy_all

  business_domain_name = 'acme.com'
  users = ['bob', 'alice', 'mary', 'jon', 'carlos']
    
  users.each do |user|
    puts "Creating user #{user.capitalize} ... \n"
    PDS::DataAdapter::PostgreSQL::User.create!(
      username: user.capitalize,
      email: "#{user}@#{business_domain_name}",
      role: 'operator'
    )
  end
else
  puts 'Error: db:seeds can only run in development' 
end

