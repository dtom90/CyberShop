ActiveAdmin.register_page 'Scoring' do
  
  controller do
    
    def score
      
      deployment = Deployment.find(params[:deployment_id])
      
      # get a mapping of input schema param name to type
      schema_params = deployment.get_input_schema.map do |param|
        [param['name'], param['metadata']['columnInfo']['columnTypeName']]
      end.to_h
      
      # extract the valid parameters using the keys of this mapping
      valid_params = scoring_params(schema_params.keys)
      
      # convert integer type params to integers
      cleansed_values = {}
      valid_params.each do |name, val|
        cleansed_values[name] = case schema_params[name]
          when 'integer'
            val.to_i
          when 'decimal'
            val.to_f
          else
            val
        end
      end

      # get the score
      score = deployment.score cleansed_values
      
      @input = valid_params.to_h
      @input.transform_keys! do |key|
        rec = MlScoringParam.find_by_name(key)
        rec&.alias ? rec.alias : key
      end
      @output = score.except(*@input.keys)
      @delay  = @output['values'][0].last
      
      @color = case
                 when @delay < 1 then
                   'green'
                 when @delay < 2 then
                   'gold'
                 else
                   'red'
               end
    
    end
    
    def scoring_params schema_params
      params.permit(schema_params)
    end
  
  end

end
