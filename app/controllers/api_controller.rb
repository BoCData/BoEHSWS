class ApiController < ApplicationController
  
  def lorenz_curve
    variable_name = params[:variable]
    year = params[:year]
    
    @data_variable = DataVariable.find_by_name(variable_name)
    
    @lorenz_data = LorenzDatum.joins(:data_variable).where(data_variables: {name: variable_name}, year: year).order(x_value: :asc)
    
    @data = {:variable => @data_variable, :data => @lorenz_data}
    
    render json: @data
  end
  
end