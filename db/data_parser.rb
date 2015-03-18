require 'csv'    

body = File.read('./db/variables.csv')
CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end

var_name = ''
var_desc = ''
var_notes = ''
var_vals = ''

csv = CSV.new(body, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
csv.each do |row|
  
  #Get the new stuff from the row
  new_var_num = row[:variable_number].nil? ? nil : row[:variable_number]
  new_var_name = row[:variable_name].nil? ? '' : row[:variable_name]
  new_var_desc = row[:description].nil? ? '' : row[:description]
  new_var_notes = row[:notes].nil? ? '' : row[:notes]
  new_var_vals = row[:values].nil? ? '' : row[:values]
  
  #If it's a new number and not empty
  if !new_var_num.nil?
    
    #If it's greater than 1
    if new_var_num > 1
      dv = DataVariable.new(:name => var_name, :description => var_desc, :notes => var_notes)
      var_vals.each do |key,val|
        puts dv
        puts val
        # DataVariableValue.create!(:data_variable => dv, :value => val)
      end    
    end
    var_name = new_var_name
    var_desc = new_var_desc
    var_notes = new_var_notes
    var_vals = Array.new
    var_vals << new_var_vals
  else
    var_name << new_var_name
    var_desc << new_var_desc
    var_notes << new_var_notes
    var_vals << new_var_vals
  end
end

