gpt3.bunch_embedding = function(data
                                , text_var
                                , id_var
                                , param_model = 'text-similarity-ada-001'){

  data_ = data

  data_length = data_[, .N]

  empty_list = list()

  for(i in 1:data_length){

    print(paste0('Embedding: ', i, '/', data_length))

    row_outcome = gpt3.make_embedding(model_ = param_model
                                      , input_ = as.character(unname(data_[i, ..text_var])))

    empty_df = data.frame(t(row_outcome))
    names(empty_df) = paste0('dim_', 1:length(row_outcome))
    empty_df$id_full = as.character(unname(data_[i, ..id_var]))

    empty_list[[i]] = empty_df


  }

  output_data = rbindlist(empty_list)

  return(output_data)

}
