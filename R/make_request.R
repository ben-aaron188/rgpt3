#' Make a test request to the GPT-3 API
#'
#' @description
#' `gpt3.test_request()` sends a basic [completion request](https://beta.openai.com/docs/api-reference/completions) to the Open AI GPT-3 API.
#' @param verbose (boolean) if TRUE prints the actual prompt and GPT-3 completion of the test request (default: FALSE).
#' @return A message of success or failure of the connection.
#' @examples
#' gpt3.test_request()
#' @export
gpt3.make_request = function(prompt_
                             , model_ = 'text-davinci-002'
                             , output_type_ = 'string_only'
                             , suffix_ = NULL
                             , max_tokens_ = 256
                             , temperature_ = 0.9
                             , top_p_ = 1
                             , n_ = 1
                             , stream_ = F
                             , logprobs_ = NULL
                             , echo_ = F
                             , stop_ = NULL
                             , presence_penalty_ = 0
                             , frequency_penalty_ = 0
                             , best_of_ = 1
                             , logit_bias_ = NULL
)
{

  parameter_list = list(prompt = prompt_
                        , model = model_
                        , suffix = suffix_
                        , max_tokens = max_tokens_
                        , temperature = temperature_
                        , top_p = top_p_
                        , n = n_
                        , stream = stream_
                        , logprobs = logprobs_
                        , echo = echo_
                        , stop = stop_
                        , presence_penalty = presence_penalty_
                        , frequency_penalty = frequency_penalty_
                        , best_of = best_of_
                        , logit_bias = logit_bias_
  )

  request_base = httr::POST(url = url.completions
                      , body = parameter_list
                      , httr::add_headers(Authorization = paste("Bearer", api_key))
                      , encode = "json")


  if(output_type_ == 'string_only'){
    output = httr::content(request_base)$choices[[1]]$text
  } else {
    output = httr::content(request_base)
  }

  return(output)

}
