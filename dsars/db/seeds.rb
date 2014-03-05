# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

module Dsars
  str = ""
  File.open("#{Engine.root}/db/seeds/dosr_reference.csv", "r"){|f| str = f.read}
  str = str.encode('UTF-8', :invalid => :replace, :undef => :replace)
  csv = CSV.parse str
  LineDescription.where(report_type: 'dosr').delete_all
  rows = csv.each_with_index.map do |row, idx|
    LineDescription.new report_type: 'dosr', line_number: row[0], name: row[1], description: row[2]
  end
  LineDescription.import rows

  csv = CSV.read "#{Engine.root}/db/seeds/5266_reference.csv", "r"
  LineDescription.where(report_type: '5266').delete_all
  rows = csv.each_with_index.map do |row, idx|
    LineDescription.new report_type: '5266', report_version: row[0], line_number: row[1], name: row[2], description: row[3], has_period: row[4]!='f', has_total: row[5]!='f', format: row[6]
  end
  LineDescription.import rows
end