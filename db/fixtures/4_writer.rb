seed_writer = SeedFu::Writer::SeedMany.new(
  :seed_file  => "/Users/npisenti/Desktop/CalculusComponents-out.rb",
  :seed_model => 'Component',
  :seed_by    => [ :id ]
)

FasterCSV.foreach( "/Users/npisenti/Desktop/CalculusComponents.csv", :return_headers => false, :headers => :first_row) do |row|

  Component.seed(:id) do |s|
    s.id = component_id 
    s.course_id = 2
    s.name = data[3]
    s.description = data[4]
  end

  seed_writer.add_seed({
    :id => row['DB_id'],
    :course_id => 2,
    :name => row['name'],
    :description => row['description']
  })

end

seed_writer.finish


#!/usr/bin/env ruby
#
# This is: script/generate_cities_seed_from_csv
#
require 'rubygems'
require 'fastercsv'
require File.join( File.dirname(__FILE__), '..', 'vendor/plugins/seed-fu/lib/seed-fu/writer' )

# Maybe SEEF_FILE could be $stdout, hm.
#
CALC_COMPONENTS = "/Users/npisenti/Desktop/CalculusComponents.csv"
# CALC_COMPONENTS = File.join( File.dirname(__FILE__), '..', 'CalculusComponents.csv' )
# SEED_FILE = File.join( File.dirname(__FILE__), '..', 'db', 'fixtures', 'test.rb' )
SEED_FILE = "/Users/npisenti/Desktop/CalculusComponents-out.rb"


# Create a seed_writer, walk the CSV, add to the file.
#

seed_writer = SeedFu::Writer::SeedMany.new(
  :seed_file  => SEED_FILE,
  :seed_model => 'Component',
  :seed_by    => [ :id ]
)

FasterCSV.foreach( CALC_COMPONENTS, 
                  :return_headers => false, :headers => :first_row) do |row|

  # Skip all but the US
  #
  #next unless row['country_code'] == 'US'

  # unless us_state
  #   puts "No State Match for #{row['region_name']}"
  #   next
  # end

  # Write the seed
  #
  seed_writer.add_seed({
    :id => row['DB_id'],
    :course_id => 2,
    :name => row['name'],
    :description => row['description']
  })

                  end

seed_writer.finish

