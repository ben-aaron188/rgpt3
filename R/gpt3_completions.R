#'Makes bunch completion requests to the GPT-3 API
#'
#'@description `gpt3_completions()` is the package's main function for rquests
#'  and takes as input a vector of prompts and processes each prompt as per the
#'  defined parameters. It extends the `gpt3_single_completion()` function to
#'  allow for bunch processing of requests to the Open AI GPT-3 API.
#'@details The easiest (and intended) use case for this function is to create a
#'  data.frame or data.table with variables that contain the prompts to be
#'  requested from GPT-3 and a prompt id (see examples below). For a general
#'  guide on the completion requests, see
#'  [https://beta.openai.com/docs/guides/completion](https://beta.openai.com/docs/guides/completion).
#'   This function provides you with an R wrapper to send requests with the full
#'  range of request parameters as detailed on
#'  [https://beta.openai.com/docs/api-reference/completions](https://beta.openai.com/docs/api-reference/completions)
#'   and reproduced below.
#'
#'  For the `best_of` parameter: The `gpt3_single_completion()` (which is used
#'  here in a vectorised manner) handles the issue that best_of must be greater
#'  than n by setting `if(best_of <= n){ best_of = n}`.
#'
#'  If `id_var` is not provided, the function will use `prompt_1` ... `prompt_n`
#'  as id variable.
#'
#'  Parameters not included/supported: - `logit_bias`:
#'  [https://beta.openai.com/docs/api-reference/completions/create#completions/create-logit_bias](https://beta.openai.com/docs/api-reference/completions/create#completions/create-logit_bias)
#'   - `echo`:
#'  [https://beta.openai.com/docs/api-reference/completions/create#completions/create-echo](https://beta.openai.com/docs/api-reference/completions/create#completions/create-echo)
#'   - `stream`:
#'  [https://beta.openai.com/docs/api-reference/completions/create#completions/create-stream](https://beta.openai.com/docs/api-reference/completions/create#completions/create-stream)
#'
#'
#'
#'
#'
#'@param prompt_var character vector that contains the prompts to the GPT-3
#'  request
#'@param id_var (optional) character vector that contains the user-defined ids
#'  of the prompts. See details.
#'@param param_model a character vector that indicates the
#'  [model](https://beta.openai.com/docs/models/gpt-3) to use; one of
#'  "text-davinci-003" (default), "text-davinci-002", "text-davinci-001",
#'  "text-curie-001", "text-babbage-001" or "text-ada-001"
#'@param param_output_type character determining the output provided: "complete"
#'  (default), "text" or "meta"
#'@param param_suffix character (default: NULL) (from the official API
#'  documentation: _The suffix that comes after a completion of inserted text_)
#'@param param_max_tokens numeric (default: 100) indicating the maximum number
#'  of tokens that the completion request should return (from the official API
#'  documentation: _The maximum number of tokens to generate in the completion.
#'  The token count of your prompt plus max_tokens cannot exceed the model's
#'  context length. Most models have a context length of 2048 tokens (except for
#'  the newest models, which support 4096)_)
#'@param param_temperature numeric (default: 0.9) specifying the sampling
#'  strategy of the possible completions (from the official API documentation:
#'  _What sampling temperature to use. Higher values means the model will take
#'  more risks. Try 0.9 for more creative applications, and 0 (argmax sampling)
#'  for ones with a well-defined answer. We generally recommend altering this or
#'  top_p but not both._)
#'@param param_top_p numeric (default: 1) specifying sampling strategy as an
#'  alternative to the temperature sampling (from the official API
#'  documentation: _An alternative to sampling with temperature, called nucleus
#'  sampling, where the model considers the results of the tokens with top_p
#'  probability mass. So 0.1 means only the tokens comprising the top 10%
#'  probability mass are considered. We generally recommend altering this or
#'  temperature but not both._)
#'@param param_n numeric (default: 1) specifying the number of completions per
#'  request (from the official API documentation: _How many completions to
#'  generate for each prompt. **Note: Because this parameter generates many
#'  completions, it can quickly consume your token quota.** Use carefully and
#'  ensure that you have reasonable settings for max_tokens and stop._)
#'@param param_logprobs numeric (default: NULL) (from the official API
#'  documentation: _Include the log probabilities on the logprobs most likely
#'  tokens, as well the chosen tokens. For example, if logprobs is 5, the API
#'  will return a list of the 5 most likely tokens. The API will always return
#'  the logprob of the sampled token, so there may be up to logprobs+1 elements
#'  in the response. The maximum value for logprobs is 5. If you need more than
#'  this, please go to
#'  [https://help.openai.com/en/](https://help.openai.com/en/) and describe your
#'  use case._)
#'@param param_stop character or character vector (default: NULL) that specifies
#'  after which character value when the completion should end (from the
#'  official API documentation: _Up to 4 sequences where the API will stop
#'  generating further tokens. The returned text will not contain the stop
#'  sequence._)
#'@param param_presence_penalty numeric (default: 0) between -2.00  and +2.00 to
#'  determine the penalisation of repetitiveness if a token already exists (from
#'  the official API documentation: _Number between -2.0 and 2.0. Positive
#'  values penalize new tokens based on whether they appear in the text so far,
#'  increasing the model's likelihood to talk about new topics._). See also:
#'  [https://beta.openai.com/docs/api-reference/parameter-details](https://beta.openai.com/docs/api-reference/parameter-details)
#'
#'
#'
#'
#'
#'@param param_frequency_penalty numeric (default: 0) between -2.00  and +2.00
#'  to determine the penalisation of repetitiveness based on the frequency of a
#'  token in the text already (from the official API documentation: _Number
#'  between -2.0 and 2.0. Positive values penalize new tokens based on their
#'  existing frequency in the text so far, decreasing the model's likelihood to
#'  repeat the same line verbatim._). See also:
#'  [https://beta.openai.com/docs/api-reference/parameter-details](https://beta.openai.com/docs/api-reference/parameter-details)
#'
#'
#'
#'
#'
#'@param param_best_of numeric (default: 1) that determines the space of
#'  possibilities from which to select the completion with the highest
#'  probability (from the official API documentation: _Generates `best_of`
#'  completions server-side and returns the "best" (the one with the highest log
#'  probability per token)_). See details.
#'
#'@return A list with two data tables (if `param_output_type` is the default
#'  "complete"): `[[1]]` contains the data table with the columns `n` (= the mo.
#'  of `n` responses requested), `prompt` (= the prompt that was sent), `gpt3`
#'  (= the completion as returned from the GPT-3 model) and `id` (= the provided
#'  `id_var` or its default alternative). `[[2]]` contains the meta information
#'  of the request, including the request id, the parameters of the request and
#'  the token usage of the prompt (`tok_usage_prompt`), the completion
#'  (`tok_usage_completion`), the total usage (`tok_usage_total`), and the `id`
#'  (= the provided `id_var` or its default alternative).
#'
#'  If `output_type` is "text", only the data table in slot `[[1]]` is returned.
#'
#'  If `output_type` is "meta", only the data table in slot `[[2]]` is returned.
#' @examples
#' # First authenticate with your API key via `gpt3_authenticate('pathtokey')`
#'
#' # Once authenticated:
#' # Assuming you have a data.table with 3 different prompts:
#' dt_prompts = data.table::data.table('prompts' =
#' c('What is the meaning if life?', 'Write a tweet about London:',
#' 'Write a research proposal for using AI to fight fake news:'),
#' 'prompt_id' = c(LETTERS[1:3]))
#'gpt3_completions(prompt_var = dt_prompts$prompts
#'    , id_var = dt_prompts$prompt_id)
#'
#' ## With more controls
#'gpt3_completions(prompt_var = dt_prompts$prompts
#'    , id_var = dt_prompts$prompt_id
#'    , param_max_tokens = 50
#'    , param_temperature = 0.5
#'    , param_n = 5)
#'
#' ## Reproducible example (deterministic approach)
#'gpt3_completions(prompt_var = dt_prompts$prompts
#'    , id_var = dt_prompts$prompt_id
#'    , param_max_tokens = 50
#'    , param_temperature = 0.0)
#'
#' ## Changing the GPT-3 model
#'gpt3_completions(prompt_var = dt_prompts$prompts
#'    , id_var = dt_prompts$prompt_id
#'    , param_model = 'text-babbage-001'
#'    , param_max_tokens = 50
#'    , param_temperature = 0.4)
#'@export
gpt3_completions = function(prompt_var
                              , id_var
                              , param_output_type = 'complete'
                              , param_model = 'text-davinci-003'
                              , param_suffix = NULL
                              , param_max_tokens = 100
                              , param_temperature = 0.9
                              , param_top_p = 1
                              , param_n = 1
                              , param_logprobs = NULL
                              , param_stop = NULL
                              , param_presence_penalty = 0
                              , param_frequency_penalty = 0
                              , param_best_of = 1){

  data_length = length(prompt_var)
  if(missing(id_var)){
    data_id = paste0('prompt_', 1:data_length)
  } else {
    data_id = id_var
  }

  empty_list = list()
  meta_list = list()

  for(i in 1:data_length){

    print(paste0('Request: ', i, '/', data_length))

    row_outcome = gpt3_single_completion(prompt_input = prompt_var[i]
                                      , model = param_model
                                      , output_type = 'complete'
                                      , suffix = param_suffix
                                      , max_tokens = param_max_tokens
                                      , temperature = param_temperature
                                      , top_p = param_top_p
                                      , n = param_n
                                      , logprobs = param_logprobs
                                      , stop = param_stop
                                      , presence_penalty = param_presence_penalty
                                      , frequency_penalty = param_frequency_penalty
                                      , best_of = param_best_of)

    row_outcome[[1]]$id = data_id[i]
    row_outcome[[2]]$id = data_id[i]

    empty_list[[i]] = row_outcome[[1]]
    meta_list[[i]] = row_outcome[[2]]

  }


  bunch_core_output = try(data.table::rbindlist(empty_list), silent = TRUE)
  if("try-error" %in% class(bunch_core_output)){
    bunch_core_output = data.table::rbindlist(empty_list, fill = TRUE)
  }
  bunch_meta_output = try(data.table::rbindlist(meta_list), silent = TRUE)
  if("try-error" %in% class(bunch_meta_output)){
    bunch_meta_output = data.table::rbindlist(meta_list, fill = TRUE)
  }

  if(param_output_type == 'complete'){
    output = list(bunch_core_output
                  , bunch_meta_output)
  } else if(param_output_type == 'meta'){
    output = bunch_meta_output
  } else if(param_output_type == 'text'){
    output = bunch_core_output
  }

  return(output)
}
