require 'csv'    

body = File.read('./db/variables.csv')
CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end

csv = CSV.new(body, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
csv.each do |row|
  
  #Get the new variable number
  var_num = row[:variable_number]
  
  #If new number, save stuff and start a new record
  if !var_num.nil?
    if var_num > 1
      # index = DataVariable.create!(:name => var_name, :desc => var_desc, :notes => var_notes)
      
      puts var_num
      # var_vals.each do |key,val|
      #   DataVariableValue.create!(:data_variable_id => index, :value => val)
      # end    
    end
    var_name = row[:variable_name]
    var_desc = row[:description]
    var_notes = row[:notes]
    var_vals = Array.new
    var_vals << row[:values]
  else
    var_name = var_name.nil? ? '' : var_name << row[:variable_name]
    var_desc = var_desc.nil? ? '' : var_desc << row[:description]
    var_notes = var_notes.nil? ? '' : var_notes << row[:notes]
    var_vals = var_vals.nil? ? Array.new : var_vals << row[:values]
  end

