require 'test_helper'
require 'rails/performance_test_help'

class JsonRenderingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
  #                          output: 'tmp/performance', formats: [:flat] }
  
  self.profile_options = {runs: 1}

  def test_jbuilder_performance
    Benchmark.bmbm do |bm|
      bm.report("Testing jBuilder: ") do
        100.times do
          get '/api/lorenz_curve/saveamount/2011'
        end
      end
      
      bm.report("Testing to_json: ") do
        100.times do
          variable_name = 'saveamount'
          year = '2011'
          
          @data_variable = DataVariable.find_by_name(variable_name)
    
          @lorenz_data = LorenzDatum.joins(:data_variable).where(data_variables: {name: variable_name}, year: year).order(x_value: :asc)
          
          @data = {:variable => @data_variable, :data => @lorenz_data}
    
          @data.to_json
        end
      end
    end
  end
  
  # test "jbuilder" do
  #   get '/api/lorenz_curve/saveamount/2011'
  # end
  #
  # test "original_json" do
  #   get '/api/lorenz_curve_old/saveamount/2011'
  # end
  
  
  # test "homepage" do
  #   get 'api/lorenz_curve_new/:variable/:year'
  # end

end
