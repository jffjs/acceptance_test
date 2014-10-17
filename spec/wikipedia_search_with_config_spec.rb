require 'yaml'
require 'active_support/core_ext/hash'
require 'acceptance_test'

config_name = File.expand_path("spec/acceptance_config.yml")
config = config_name ? HashWithIndifferentAccess.new(YAML.load_file(config_name)) : {}

AcceptanceTest.instance.configure(config)

puts "Application URL   : #{config[:webapp_url]}"  if config[:webapp_url]
puts "Selenium URL      : #{config[:selenium_url]}" if config[:selenium_url]
puts "Default Wait Time : #{Capybara.default_wait_time}"
puts "Browser           : #{config[:browser]}"  if config[:browser]

RSpec.describe 'Wikipedia Search' do
  AcceptanceTest.instance.add_expectations(self)

  before do
    AcceptanceTest.instance.setup
    puts "Capybara current driver: #{Capybara.current_driver}"
  end

  after do
    AcceptanceTest.instance.teardown
  end

  it "uses selenium driver" do
    visit('/')

    fill_in "searchInput", :with => "Capybara"

    find(".formBtn", match: :first).click

    expect(page).to have_content "Hydrochoerus hydrochaeris"
  end
end