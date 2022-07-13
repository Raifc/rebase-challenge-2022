directories(%w[config spec] \
 .select { |d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist") })

guard "rspec", cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)
  watch('config/my_database_connector.rb') { 'spec/config/my_database_connector_spec.rb' }

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)
end
