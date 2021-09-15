require 'sqlite3'                  # sqlite3 
require 'active_record'            # Active Record
require 'active_support/core_ext'  # Dates, Times and some tricks (ie 1.month, "1979-04-05".to_date)
require 'pry'                      # Debug

# Connect to an in-memory sqlite3 database
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# Define a minimal database schema
ActiveRecord::Schema.define do
  create_table :people, force: true do |t|
    t.string :firstname
    t.string :lastname
    t.date   :birthday
  end
end

# Define the models
class Person < ActiveRecord::Base
    scope :adults, -> { where("people.birthday < ?", Date.today - 18.year) }
end

# Create two Person

# Gimmi father
gimmi = Person.create(
    firstname: "Gimmi", 
    lastname: "Page", 
    birthday: "1979-04-05"
)

# Gimmi son
gimmi_son = Person.create(
    firstname: "Gimmi Jr.", 
    lastname: "Page", 
    birthday: "2010-09-15"
)

# Enable debugging from here on out
ActiveRecord::Base.logger = Logger.new(STDOUT)
# ...and if you like nagging debugging...
#ActiveRecord::Base.verbose_query_logs = true

# Show all people
p Person.all

# Show only the adults
p Person.adults
