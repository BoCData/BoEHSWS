require 'csv'

namespace :import do
  desc "Import data variables"
  task :data_variables => :environment do
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
          if column
          dv = DataVariable.create!(:name => var_name, :description => var_desc, :notes => var_notes)
          var_vals.each do |val|
            if !val.nil?
              DataVariableValue.create!(:data_variable => dv, :value => val)
            end
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
  end

  desc "Import data values"
  task :data_values => :environment do
    
    body = File.read('./db/values_2011.csv')
    CSV::Converters[:blank_to_nil] = lambda do |field|
      field && field.empty? ? nil : field
    end


    csv = CSV.new(body, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
    csv.each do |row|
      
      columns = ["weight","soc","age","age_grp","region","sex","tenure","pubsecty","mastat","educ","huresp","fihhyr2","fihhyr2_m","dfihhyr","dfihhyr_m","dfihhyrchg","saveamount","saveamount_m","nvesttot"]
      #Get the row and save the user id
      user_id = row[:subsid]
        
      #Save every field for the user
      row.each do |index, value|
        if columns.include?(index)
 
          dvv = DataVariableValue.find_by_name(index)
          puts dvv
        
          # ud = UserDatum.new(:data_variable_value => dvv, :user_id => user_id, :value => value)
          # puts ud
        end
      end
    end
  end
  
  desc "Import data variables and values"
  task :all => [:data_variables, :data_values] do
  end
  
end