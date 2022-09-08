gpt3.make_embedding = function(model_ = 'text-similarity-ada-001'
                               , input_){

  parameter_list = list(model = model_
                        , input = input_)

  request_base = httr::POST(url = url.embeddings
                            , body = parameter_list
                            , httr::add_headers(Authorization = paste("Bearer", api_key))
                            , encode = "json")


  output_base = httr::content(request_base)

  embedding_raw = toNumeric(unlist(output_base$data[[1]]$embedding))

  return(embedding_raw)

}
