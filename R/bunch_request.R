gpt3.bunch_request = function(data
                              , prompt_var
                              , completion_var_name = 'gpt3_completion'
                              , param_model = 'text-davinci-002'
                              , param_suffix = NULL
                              , param_max_tokens = 256
                              , param_temperature = 0.9
                              , param_top_p = 1
                              , param_n = 1
                              , param_stream = F
                              , param_logprobs = NULL
                              , param_echo = F
                              , param_stop = NULL
                              , param_presence_penalty = 0
                              , param_frequency_penalty = 0
                              , param_best_of = 1
                              , param_logit_bias = NULL){


  data_ = data

  data_length = data_[, .N]

  data_[, completion_name := '']


  for(i in 1:data_length){

    print(paste0('Request: ', i, '/', data_length))

    row_outcome = gpt3.make_request(prompt = as.character(unname(data_[i, ..prompt_var]))
                                    , model = param_model
                                    , output_type = 'detail'
                                    , suffix = param_suffix
                                    , max_tokens = param_max_tokens
                                    , temperature = param_temperature
                                    , top_p = param_top_p
                                    , n = param_n
                                    , stream = param_stream
                                    , logprobs = param_logprobs
                                    , echo = param_echo
                                    , stop = param_stop
                                    , presence_penalty = param_presence_penalty
                                    , frequency_penalty = param_frequency_penalty
                                    , best_of = param_best_of
                                    , logit_bias = param_logit_bias)


    data_$completion_name[i] = row_outcome$choices[[1]]$text


  }

  data_cols = ncol(data_)
  names(data_)[data_cols] = completion_var_name

  return(data_)
}
