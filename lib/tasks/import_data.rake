require 'csv'

namespace :import do
  
  desc "Import data variables"
  task :data_variables => :environment do
    
    #Read in the variables file
    body = File.read('./db/variables.csv')
    
    #Convert the blanks to nil in file
    CSV::Converters[:blank_to_nil] = lambda do |field|
      field && field.empty? ? nil : field
    end
    
    #Set the columns from the file that we want to read into the tables
    columns = ["soc","age_grp","region","sex","tenure","mastat","educ","dfihhyr","saveamount"]
   
    #Initiate the variables 
    var_name = ''
    var_desc = ''
    var_notes = ''
    var_vals = ''

    #Get the csv data from the file and turn the headers into symbols as we go
    csv = CSV.new(body, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
    
    #Loop through all of the rows of the CSV
    csv.each do |row|
  
      #Get the new stuff from the row and set it to nil if it doesn't exist
      new_var_num = row[:variable_number] || nil
      new_var_name = row[:variable_name] || ''
      new_var_desc = row[:description] || ''
      new_var_notes = row[:notes] || ''
      new_var_vals = row[:values] || ''
  
      #If it's a new number and not empty
      if !new_var_num.nil?
    
        #If it's greater than 1 and exists in the columns array then create records
        if new_var_num > 1 && columns.include?(var_name)
          #Create a data variable record
          dv = DataVariable.create!(
                :name => var_name, #the name of the variable
                :description => var_desc,  #the description of the variable
                :notes => var_notes #any notes on the variable
              )
          
          #Loop through each of the potential values for the data variable record
          var_vals.each do |val|
            
            #Check if the value is nil
            if !val.nil?
              
              #Create a data variable value record (each possible valid response goes here for informational purposes)
              DataVariableValue.create!(
                :data_variable => dv, #references the data variable record
                :value => val, #the potential value
              )
            end
          end    
        end
        #this is a new record start so initialize the variables (because new_var_num contains a value)
        var_name = new_var_name
        var_desc = new_var_desc
        var_notes = new_var_notes
        var_vals = Array.new
        var_vals << new_var_vals
      else
        #this is a continuing record so append values to the variables (because new_var_num does not contain a value)
        var_name << new_var_name
        var_desc << new_var_desc
        var_notes << new_var_notes
        var_vals << new_var_vals
      end
    end
  end

  desc "Import data values"
  task :data_values, [:years] => [:environment] do |t, args|
    #All of the years the correspond to csv files to read in
    years = args[:years].split ' '
    
    #Set the columns from the file that we want to read into the tables
    columns = ["soc","age_grp","region","sex","tenure","mastat","educ","dfihhyr","saveamount"]

    #Manually created the data for this because it was the easiest way to do it          
    saveamount = {"£1-£24" => {:value_number_low => 1, :value_number_high => 24, :value_number_mid => 12.5, :error => 11.5, :error_percent => 92, :unit => '£'},
                "£25-£49" => {:value_number_low => 25, :value_number_high => 49, :value_number_mid => 37, :error => 12, :error_percent => 32.4, :unit => '£'},
                "£50-£99" => {:value_number_low => 50, :value_number_high => 99, :value_number_mid => 74.5, :error => 24.5, :error_percent => 32.9, :unit => '£'},
                "£100-£149" => {:value_number_low => 100, :value_number_high => 149, :value_number_mid => 124.5, :error => 24.5, :error_percent => 19.7, :unit => '£'},
                "£150-£199" => {:value_number_low => 150, :value_number_high => 199, :value_number_mid => 174.5, :error => 24.5, :error_percent => 14.0, :unit => '£'},
                "£200 - £249" => {:value_number_low => 200, :value_number_high => 249, :value_number_mid => 224.5, :error => 24.5, :error_percent => 10.9, :unit => '£'},
                "£250 - £299" => {:value_number_low => 250, :value_number_high => 299, :value_number_mid => 274.5, :error => 24.5, :error_percent => 8.93, :unit => '£'},
                "£300 - £349" => {:value_number_low => 300, :value_number_high => 349, :value_number_mid => 324.5, :error => 24.5, :error_percent => 7.55, :unit => '£'},
                "£350 - £399" => {:value_number_low => 350, :value_number_high => 399, :value_number_mid => 374.5, :error => 24.5, :error_percent => 6.54, :unit => '£'},
                "£400 - £449" => {:value_number_low => 400, :value_number_high => 449, :value_number_mid => 424.5, :error => 24.5, :error_percent => 5.77, :unit => '£'},
                "£450 - £499" => {:value_number_low => 450, :value_number_high => 499, :value_number_mid => 474.5, :error => 24.5, :error_percent => 5.16, :unit => '£'},
                "£500 - £599" => {:value_number_low => 500, :value_number_high => 599, :value_number_mid => 549.5, :error => 49.5, :error_percent => 9.01, :unit => '£'},
                "£600 - £699" => {:value_number_low => 600, :value_number_high => 699, :value_number_mid => 649.5, :error => 49.5, :error_percent => 7.62, :unit => '£'},
                "£700 - £799" => {:value_number_low => 700, :value_number_high => 799, :value_number_mid => 749.5, :error => 49.5, :error_percent => 6.60, :unit => '£'},
                "£800 - £899" => {:value_number_low => 800, :value_number_high => 899, :value_number_mid => 849.5, :error => 49.5, :error_percent => 5.83, :unit => '£'},
                "£900 - £999" => {:value_number_low => 900, :value_number_high => 999, :value_number_mid => 949.5, :error => 49.5, :error_percent => 5.21, :unit => '£'},
                "£1,000 - £1,499" => {:value_number_low => 1000, :value_number_high => 1499, :value_number_mid => 1249.5, :error => 249.5, :error_percent => 20.0, :unit => '£'},
                "£1,500 - £1,999" => {:value_number_low => 1500, :value_number_high => 1999, :value_number_mid => 1749.5, :error => 249.5, :error_percent => 14.3, :unit => '£'},
                "£2,000 or more" => {:value_number_low => 2000, :value_number_high => 10000, :value_number_mid => 6000, :error => nil, :error_percent => nil, :unit => '£'}
              }
              
    #TODO move into a file of it's own for constants
    #Manually created the data for this because it was the easiest way to do it
    dfihhyr = {"<£200" => {:value_number_low => 0, :value_number_high => 200,:value_number_mid => 100, :error => 50, :error_percent => 50, :unit => '£'},
                "£200-£299" => {:value_number_low => 200, :value_number_high => 299, :value_number_mid => 249.5, :error => 49.5, :error_percent => 19.8, :unit => '£'},
                "£300-£399" => {:value_number_low => 300, :value_number_high => 399, :value_number_mid => 349.5, :error => 49.5, :error_percent => 14.2, :unit => '£'},
                "£400-£499" => {:value_number_low => 400, :value_number_high => 499, :value_number_mid => 449.5, :error => 49.5, :error_percent => 11.0, :unit => '£'},
                "£500-£599" => {:value_number_low => 500, :value_number_high => 599, :value_number_mid => 549.5, :error => 49.5, :error_percent => 9.00, :unit => '£'},
                "£600-£699" => {:value_number_low => 600, :value_number_high => 699, :value_number_mid => 649.5, :error => 49.5, :error_percent => 7.62, :unit => '£'},
                "£700-£799" => {:value_number_low => 700, :value_number_high => 799, :value_number_mid => 749.5, :error => 49.5, :error_percent => 6.60, :unit => '£'},
                "£800-£899" => {:value_number_low => 800, :value_number_high => 899, :value_number_mid => 849.5, :error => 49.5, :error_percent => 5.83, :unit => '£'},
                "£900-£999" => {:value_number_low => 900, :value_number_high => 999, :value_number_mid => 949.5, :error => 49.5, :error_percent => 5.21, :unit => '£'},
                "£1000-£1199" => {:value_number_low => 1000, :value_number_high => 1199, :value_number_mid => 1099.5, :error => 99.5, :error_percent => 9.05, :unit => '£'},
                "£1200-£1399" => {:value_number_low => 1200, :value_number_high => 1399, :value_number_mid => 1299.5, :error => 99.5, :error_percent => 7.66, :unit => '£'},
                "£1400-£1599" => {:value_number_low => 1400, :value_number_high => 1599, :value_number_mid => 1499.5, :error => 99.5, :error_percent => 6.64, :unit => '£'},
                "£1600-£1799" => {:value_number_low => 1600, :value_number_high => 1799, :value_number_mid => 1699.5, :error => 99.5, :error_percent => 5.85, :unit => '£'},
                "£1800-£1999" => {:value_number_low => 1800, :value_number_high => 1999, :value_number_mid => 1899.5, :error => 99.5, :error_percent => 5.24, :unit => '£'},
                "£2000-£2999" => {:value_number_low => 2000, :value_number_high => 2999, :value_number_mid => 2499.5, :error => 499.5, :error_percent => 20.0, :unit => '£'},
                "£3000-£3999" => {:value_number_low => 3000, :value_number_high => 3999, :value_number_mid => 3499.5, :error => 499.5, :error_percent => 14.3, :unit => '£'},
                "£4000-£4999" => {:value_number_low => 4000, :value_number_high => 4999 , :value_number_mid => 4499.5, :error => 499.5, :error_percent => 11.1, :unit => '£'},
                ">=£5000" => {:value_number_low => 5000, :value_number_high => 10000,:value_number_mid => 7500, :error => nil, :error_percent => nil, :unit => '£'}
              }
    
    #Initialize user data to insert
    user_data = Array.new
    
    #Loop through all of the years in the above array
    years.each do |year|
      
      #Read in the file based on the given year in the array
      body = File.read('./db/values_' + year.to_s + '.csv')
      
      #Convert blank fields to nil
      CSV::Converters[:blank_to_nil] = lambda do |field|
        field && field.empty? ? nil : field
      end
    
      #Get the csv data from the file and turn the headers into symbols as we go
      csv = CSV.new(body, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
      
      #Loop through all of the rows of the CSV
      csv.each do |row|
        #Get the row and save the user id
        user_id = row[:subsid]
        
        #Save every field for the user
        row.each do |index, value|
          index = index.to_s
          if columns.include? index
            #Find the related data variable by the column name
            dv = DataVariable.find_by(name: index)    
          
            #Initialize the default params
            params = {:data_variable => dv, :user_id => user_id, :year => year, :value_string => value}
            # puts params
          
            #Check if the index is either saveamount of dfihhyr
            if index == "saveamount"
              numbers = saveamount[value] || nil #set it to null by default
              #Check if we got any params based on the index
              if !numbers.nil?
                #Merge them into default params if so
                params.merge!(numbers)
                user_data << params
              end
            elsif index == "dfihhyr"    
              numbers = dfihhyr[value] || nil #set it to null by default
              #Check if we got any params based on the index 
              if !numbers.nil?
                #Merge them into default params if so
                params.merge!(numbers)
                user_data << params
              end                        
            elsif !dv.nil? && !user_id.nil?
              #Create a record for the user data based on the merged params above
              user_data << params
            end
          end
        end
      
      end
      
      UserDatum.create!(user_data)
    end
  end
  
  desc "Generate Lorenz Curve Data"
  task :generate_curves, [:years] => [:environment] do |t, args|
    
    #All of the years the correspond to csv files to read in
    years = args[:years].split ' '
    
    years.each do |year|
      #Initialize the desired group size (this can be changed, but not recommended)
      group_size = 20.0
      #Initialize the desired range for the x_axis
      range = 1.0
      
      insert_lorenz_curve("dfihhyr", group_size, range, year)
      
      insert_lorenz_curve("saveamount", group_size, range, year)
      
    end
  end
  
  desc "Import Data and Generate Curves"
  task :all, [:years] => [:environment] do |t, args|
    years = args[:years]
    puts "Importing Data Variables..."
    Rake::Task["import:data_variables"].invoke
    puts "Importing Data Values..."
    Rake::Task["import:data_values"].invoke(args[:years])
    puts "Generating Curves..."
    Rake::Task["import:generate_curves"].invoke(args[:years])
  end
  
  def insert_lorenz_curve(variable_name, group_size, range, year)
    #Calculate the x-axis interval size
    x_interval = range / group_size
    
    #Get the user data ordered lowest to highest for one variable in one year
    user_data = UserDatum.joins(:data_variable).where(data_variables: {name: variable_name}, year: year).order(value_number_mid: :asc) 
    
    #Calculate the number of total records
    record_count = user_data.count
    
    #Calculate the minimum number of records per grouping 
    records_per_group = (record_count / group_size).floor
    
    #Calculate how many groups will need one extra record added them
    groups_with_extra_record = (record_count % group_size).floor
    
    data = calculate_lorenz_curve(user_data, records_per_group, x_interval, groups_with_extra_record)
    
    LorenzDatum.create!(data)

  end
  
  def calculate_lorenz_curve(user_data, records_per_group, x_interval, groups_with_extra_record)

    data = calculate_group_sums(user_data, records_per_group, x_interval, groups_with_extra_record)

    data = calculate_group_percent(data[:data_points], data[:total_sum], data[:total_sum_error])
    
    data = calculate_cumulative_group_percent(data)
    
    return data
    
  end
  
  def calculate_group_sums(user_data, records_per_group, x_interval, groups_with_extra_record)
    #Initialize all variables
    data_points = Array.new #store the end values here
    count = records_per_group #num of records per group (there are 20)
    group_size = records_per_group
    sum = 0 #sum for the current div
    total_sum = 0 #sum of all of the data points
    error = 0 #error added for the current div
    total_sum_error = 0 #error added for all of the records
    x_value = x_interval #x value for the current div
    
    #Loop through all of the user data
    user_data.each do |user_datum|
      #increment the sum with the new user data
      sum += user_datum.value_number_mid
      
      #increment the total sum with the new sum
      total_sum += user_datum.value_number_mid
      
      #increment the error with the square of the new user data error
      error += user_datum.error * user_datum.error
      
      #increment the total sum error with the new error
      total_sum_error += error
      
      #decrement the count
      count -= 1
      
      #check if the count equals zero and if we need to add 1 extra record to this column (for even distribution)
      if groups_with_extra_record > 0 && !(group_size > records_per_group)
        #Add one back to the count
        count += 1
        
        #Decrement the number of columns requiring an extra record
        groups_with_extra_record -= 1
        
        #Increment the group size for the data point
        group_size = records_per_group + 1
        
        #Go to the next iteration
        next
      
      #check if we are at the last record in the group
      elsif count == 0
        #Calculate square root of the summed errors for the group
        error = Math.sqrt(error)
        
        #Add all of the values to the data point array
        data_points << {:data_variable => user_datum.data_variable, :x_value => x_value, :y_value => sum, :st_dev => error, :year => user_datum.year, :group_size => group_size}
        puts data_points
        
        #Reset the count for the records in the group
        count = records_per_group
        
        #Reset the group size
        group_size = records_per_group
        
        #Increment the x value by the interval size
        x_value += x_interval
        
        #Reset the sum, error, and extra record flag
        sum = 0
        error = 0
      end
    end
    
    #Calculate square root of the total summed errors
    total_sum_error = Math.sqrt(total_sum_error)
    
    #Create data to return
    data =  {:data_points => data_points, :total_sum => total_sum, :total_sum_error => total_sum_error}

    return data
    
  end
  
  def calculate_group_percent(data, total_sum, total_sum_error)
    #Loop through all data points
    data.each do |datum|
      #Calculate the new error based on the data being divided by the total sum
      datum[:st_dev] = Math.sqrt((datum[:st_dev] / datum[:y_value]) * (datum[:st_dev] / datum[:y_value]) + (total_sum_error / total_sum) * (total_sum_error / total_sum))
      
      #Calculate the new y value by dividing value by the total sum
      datum[:y_value] = datum[:y_value] / total_sum
    end
    
    return data
    
  end
  
  def calculate_cumulative_group_percent(data)
    #Initialize error and previous y value
    error = 0
    prev_y_value = 0
    
    #Loop through all data points
    data.each do |datum|
      #Calculate the new error based on the data being added to the previous amount
      error += (datum[:st_dev] * datum[:st_dev])
      datum[:st_dev] = Math.sqrt(error)
      
      #Calculate the new y value by adding the previous value
      datum[:y_value] += prev_y_value
      prev_y_value = datum[:y_value]
      
    end  

    return data
    
  end
  
end