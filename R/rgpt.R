#' Makes bunch chat completion requests to the OpenAI API for all chat models
#'
#' @description
#' `rgpt()` is the package's (new) main function for all chat completion functionality and takes as input a vector of prompts and processes each prompt as per the defined parameters. It extends the `rgpt_single()` function to allow for bunch processing of requests to the Open AI GPT API.
#' @details
#' The easiest (and intended) use case for this function is to create a data.frame or data.table with variables that contain the prompts to be requested from the GPT models and a prompt id (see examples below).
#' For a general guide on the chat completion requests, see [https://platform.openai.com/docs/guides/chat/chat-completions-beta](https://platform.openai.com/docs/guides/chat/chat-completions-beta). This function provides you with a general R wrapper to send requests with the full range of request parameters as detailed on [https://platform.openai.com/docs/api-reference/chat/create](https://platform.openai.com/docs/api-reference/chat/create) and reproduced below.
#'
#'
#' If `id_var` is not provided, the function will use `prompt_1` ... `prompt_n` as id variable.
#'
#' Parameters not included/supported:
#'   - `logit_bias`: [https://platform.openai.com/docs/api-reference/chat/create#chat/create-logit_bias](https://platform.openai.com/docs/api-reference/chat/create#chat/create-logit_bias)
#'   - `stream`: [https://platform.openai.com/docs/api-reference/chat/create#chat/create-stream](https://platform.openai.com/docs/api-reference/chat/create#chat/create-stream)
#'
#' @param prompt_role_var character vector that contains the role prompts to the GPT request. Must be one of 'system', 'assistant', 'user' (default), see [https://platform.openai.com/docs/guides/chat](https://platform.openai.com/docs/guides/chat)
#' @param prompt_content_var character vector that contains the content prompts to the GPT request. This is the key instruction that the GPT model receives.
#' @param seed numeric (optional) the seed to control reproducibility of the completions. If NULL, no seed will be used and results may differ at each completion. See: [https://platform.openai.com/docs/api-reference/chat/create#chat-create-seed](https://platform.openai.com/docs/api-reference/chat/create#chat-create-seed)
#' @param id_var (optional) character vector that contains the user-defined ids of the prompts. See details.
#' @param param_model a character vector that indicates the [GPT model](https://platform.openai.com/docs/models/gpt-4-and-gpt-4-turbo) to use; currently supported are: 'gpt-3.5-turbo-0125', 'gpt-3.5-turbo', 'gpt-3.5-turbo-1106', 'gpt-3.5-turbo-16k', 'gpt-3.5-turbo-0613', 'gpt-3.5-turbo-16k-0613', 'gpt-4', 'gpt-4-0613', 'gpt-4-0125-preview' (default, = GPT-4 Turbo)
#' @param param_output_type character determining the output provided: "complete" (default), "text" or "meta"
#' @param param_max_tokens numeric (default: 100) indicating the maximum number of tokens that the completion request should return (from the official API documentation: _The maximum number of tokens allowed for the generated answer. By default, the number of tokens the model can return will be (4096 - prompt tokens)._)
#' @param param_temperature numeric (default: 1.0) specifying the sampling strategy of the possible completions (from the official API documentation: _What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or `top_p` but not both._)
#' @param param_top_p numeric (default: 1) specifying sampling strategy as an alternative to the temperature sampling (from the official API documentation: _An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or `temperature` but not both._)
#' @param param_n numeric (default: 1) specifying the number of completions per request (from the official API documentation: _How many chat completion choices to generate for each input message. **Note: Because this parameter generates many completions, it can quickly consume your token quota.** Use carefully and ensure that you have reasonable settings for max_tokens and stop._)
#' @param param_stop character or character vector (default: NULL) that specifies after which character value when the completion should end (from the official API documentation: _Up to 4 sequences where the API will stop generating further tokens._)
#' @param param_presence_penalty numeric (default: 0) between -2.00  and +2.00 to determine the penalisation of repetitiveness if a token already exists (from the official API documentation: _Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics._). See also: [https://beta.openai.com/docs/api-reference/parameter-details](https://beta.openai.com/docs/api-reference/parameter-details)
#' @param param_frequency_penalty numeric (default: 0) between -2.00  and +2.00 to determine the penalisation of repetitiveness based on the frequency of a token in the text already (from the official API documentation: _Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim._). See also: [https://beta.openai.com/docs/api-reference/parameter-details](https://beta.openai.com/docs/api-reference/parameter-details)
#' #' @param param_logprobs boolean (default: TRUE) from the official API documentation: : _whether to return log probabilities of the output tokens or not. If true, returns the log probabilities of each output token returned in the content of message._ Will be returned in the output list at slot 3.
#'
#' @return A list with two data tables (if `output_type` is the default "complete"): [[1]] contains the data table with the columns `n` (= the mo. of `n` responses requested), `prompt_role` (= the role that was set for the prompt), `prompt_content` (= the content that was set for the prompt), `gpt_role` (= the role that the GPT assumed in the chat completion) and `gpt_content` (= the content that the GPT model provided with its assumed role in the chat completion). [[2]] contains the meta information of the request, including the request id, the parameters of the request and the token usage of the prompt (`tok_usage_prompt`), the completion (`tok_usage_completion`), the total usage (`tok_usage_total`), the `id` (= the provided `id_var` or its default alternative), and the system fingerprint (`system_fingerprint`) (for reproducibility related to the seed). [[3]] contains the tokens of the completion (per n requests if applicable) and the corresponding log probabilities.
#'
#' If `output_type` is "text", only the data table in slot [[1]] is returned.
#'
#' If `output_type` is "meta", only the data table in slot [[2]] is returned.
#'
#' If `output_type` is "logprobs", only the data table in slot [[3]] is returned.
#' @examples
#' # First authenticate with your API key via `rgpt_authenticate('pathtokey')`
#'
#' # Once authenticated:
#' # Assuming you have a data.table with 3 different prompts:
#' dt_prompts = data.table::data.table('prompts_content' = c('What is the meaning if life?', 'Write a tweet about London:', 'Write a research proposal for using AI to fight fake news:', 'You are a twelve-year old girl going to high school. Write a diary entry of typical day.')
#'     , 'prompts_role' = rep('user', 4)
#'     , 'prompt_id' = c(LETTERS[1:4]))
#'rgpt(prompt_role_var = dt_prompts$prompts_role
#'    , prompt_content_var = dt_prompts$prompts_content
#'    , id_var = dt_prompts$prompt_id)
#'
#' ## With more controls
#' rgpt(prompt_role_var = dt_prompts$prompts_role
#'     , prompt_content_var = dt_prompts$prompts_content
#'     , id_var = dt_prompts$prompt_id
#'     , param_max_tokens = 50
#'     , param_temperature = 0.5
#'     , param_n = 5)
#'
#' ## Reproducible example (with seed)
#' rgpt(prompt_role_var = dt_prompts$prompts_role
#'     , prompt_content_var = dt_prompts$prompts_content
#'     , param_seed = 42
#'     , id_var = dt_prompts$prompt_id
#'     , param_max_tokens = 50
#'     , param_temperature = 0
#'     , param_n = 3)
#'
#' @export
rgpt = function(prompt_role_var
                , prompt_content_var
                , param_seed = NULL
                , id_var
                , param_output_type = 'complete'
                , param_model = 'gpt-4-0125-preview'
                , param_max_tokens = 100
                , param_temperature = 1.0
                , param_top_p = 1
                , param_n = 1
                , param_stop = NULL
                , param_presence_penalty = 0
                , param_frequency_penalty = 0
                , param_logprobs = T){

  data_length = length(prompt_role_var)
  if(missing(id_var)){
    data_id = paste0('prompt_', 1:data_length)
  } else {
    data_id = id_var
  }

  if(is.numeric(param_seed)){
    param_seed = param_seed
  } else {
    param_seed = NULL
  }

  empty_list = list()
  meta_list = list()
  logprobs_list = list()

  for(i in 1:data_length){

    print(paste0('Request: ', i, '/', data_length))

    row_outcome = rgpt_single(prompt_role = prompt_role_var[i]
                              , prompt_content = prompt_content_var[i]
                              , seed = param_seed
                              , model = param_model
                              , output_type = param_output_type
                              , max_tokens = param_max_tokens
                              , temperature = param_temperature
                              , top_p = param_top_p
                              , n = param_n
                              , stop = param_stop
                              , presence_penalty = param_presence_penalty
                              , frequency_penalty = param_frequency_penalty
                              , logprobs = param_logprobs)

    row_outcome[[1]]$id = data_id[i]
    row_outcome[[2]]$id = data_id[i]

    row_outcome[[3]]$id = data_id[i]

    empty_list[[i]] = row_outcome[[1]]
    meta_list[[i]] = row_outcome[[2]]
    logprobs_list[[i]] = row_outcome[[3]]

  }


  bunch_core_output = try(data.table::rbindlist(empty_list), silent = T)
  if("try-error" %in% class(bunch_core_output)){
    bunch_core_output = data.table::rbindlist(empty_list, fill = T)
  }
  bunch_meta_output = try(data.table::rbindlist(meta_list), silent = T)
  if("try-error" %in% class(bunch_meta_output)){
    bunch_meta_output = data.table::rbindlist(meta_list, fill = T)
  }
  bunch_logprobs_output = try(data.table::rbindlist(logprobs_list), silent = T)
  if("try-error" %in% class(bunch_logprobs_output)){
    bunch_logprobs_output = data.table::rbindlist(logprobs_list, fill = T)
  }

  if(param_output_type == 'complete'){
    output = list(bunch_core_output
                  , bunch_meta_output
                  , bunch_logprobs_output)
  } else if(param_output_type == 'meta'){
    output = bunch_meta_output
  } else if(param_output_type == 'text'){
    output = bunch_core_output
  } else if(param_output_type == 'logprobs'){
    output = bunch_logprobs_output
  }

  return(output)
}
