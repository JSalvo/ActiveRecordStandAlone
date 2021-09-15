# https://makandracards.com/makandra/32401-activerecord-how-to-use-activerecord-standalone-within-a-ruby-script
# Based on http://www.jonathanleighton.com/articles/2011/awesome-active-record-bug-reports/ 

# Run this script with `$ ruby my_script.rb`
require 'sqlite3'
require 'active_record'

# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'

# Connect to an in-memory sqlite3 database
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# Define a minimal database schema
ActiveRecord::Schema.define do
  create_table :shows, force: true do |t|
    t.string :name
  end

  create_table :episodes, force: true do |t|
    t.string :name
    t.belongs_to :show, index: true
  end
end

# Define the models
class Show < ActiveRecord::Base
  has_many :episodes, inverse_of: :show
end

class Episode < ActiveRecord::Base
  belongs_to :show, inverse_of: :episodes, required: true
end

# Create a few records...
show = Show.create!(name: 'Big Bang Theory')

first_episode = show.episodes.create!(name: 'Pilot')
second_episode = show.episodes.create!(name: 'The Big Bran Hypothesis')

episode_names = show.episodes.pluck(:name)

puts "#{show.name} has #{show.episodes.size} episodes named #{episode_names.join(', ')}."
