#' Makes a single chat completion request to the GPT API for all chat models
#'
#' @description
#' `rgpt_single()` sends a single [chat completion request](https://platform.openai.com/docs/guides/chat) to the Open AI GPT API. This function allows you to specify the role and content for your API call.
#' @details For a general guide on the completion requests, see [https://platform.openai.com/docs/api-reference/chat](https://platform.openai.com/docs/api-reference/chat). This function provides you with an R wrapper to send requests with the full range of request parameters as detailed on [https://beta.openai.com/docs/api-reference/completions](https://beta.openai.com/docs/api-reference/completions) and reproduced below.
#'
#' Parameters not included/supported:
#'   - `logit_bias`: [https://platform.openai.com/docs/api-reference/chat/create#chat/create-logit_bias](https://platform.openai.com/docs/api-reference/chat/create#chat/create-logit_bias)
#'   - `stream`: [https://platform.openai.com/docs/api-reference/chat/create#chat/create-stream](https://platform.openai.com/docs/api-reference/chat/create#chat/create-stream)
#'
#'
#' @param prompt_role character (default: 'user') that contains the role for the prompt message in the GPT (chat) message format. Must be one of 'system', 'assistant', 'user' (default), see [https://platform.openai.com/docs/guides/chat](https://platform.openai.com/docs/guides/chat)
#' @param prompt_content character that contains the content for the prompt message in the GPT (chat) message format, see [https://platform.openai.com/docs/guides/chat](https://platform.openai.com/docs/guides/chat). This is the key instruction that the GPT model receives.
#' @param seed numeric (optional) the seed to control reproducibility of the completions. If NULL, no seed will be used and results may differ at each completion. See: [https://platform.openai.com/docs/api-reference/chat/create#chat-create-seed](https://platform.openai.com/docs/api-reference/chat/create#chat-create-seed)
#' @param model a character vector that indicates the [GPT model](https://platform.openai.com/docs/models/gpt-4-and-gpt-4-turbo) to use; currently supported are: 'gpt-3.5-turbo-0125', 'gpt-3.5-turbo', 'gpt-3.5-turbo-1106', 'gpt-3.5-turbo-16k', 'gpt-3.5-turbo-0613', 'gpt-3.5-turbo-16k-0613', 'gpt-4', 'gpt-4-0125-preview', 'gpt-4-turbo-preview', 'gpt-4-turbo-2024-04-09', 'gpt-4-turbo', 'gpt-4o' (default)
#' @param output_type character determining the output provided: "complete" (default), "text" or "meta"
#' @param max_tokens numeric (default: 100) indicating the maximum number of tokens that the completion request should return (from the official API documentation: _The maximum number of tokens allowed for the generated answer. By default, the number of tokens the model can return will be (4096 - prompt tokens)._)
#' @param temperature numeric (default: 1.0) specifying the sampling strategy of the possible completions (from the official API documentation: _What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or `top_p` but not both._)
#' @param top_p numeric (default: 1) specifying sampling strategy as an alternative to the temperature sampling (from the official API documentation: _An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or `temperature` but not both._)
#' @param n numeric (default: 1) specifying the number of completions per request (from the official API documentation: _How many chat completion choices to generate for each input message. **Note: Because this parameter generates many completions, it can quickly consume your token quota.** Use carefully and ensure that you have reasonable settings for max_tokens and stop._)
#' @param stop character or character vector (default: NULL) that specifies after which character value when the completion should end (from the official API documentation: _Up to 4 sequences where the API will stop generating further tokens._)
#' @param presence_penalty numeric (default: 0) between -2.00  and +2.00 to determine the penalisation of repetitiveness if a token already exists (from the official API documentation: _Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics._). See also: [https://beta.openai.com/docs/api-reference/parameter-details](https://beta.openai.com/docs/api-reference/parameter-details)
#' @param frequency_penalty numeric (default: 0) between -2.00  and +2.00 to determine the penalisation of repetitiveness based on the frequency of a token in the text already (from the official API documentation: _Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim._). See also: [https://beta.openai.com/docs/api-reference/parameter-details](https://beta.openai.com/docs/api-reference/parameter-details)
#' @param logprobs boolean (default: TRUE) from the official API documentation: : _whether to return log probabilities of the output tokens or not. If true, returns the log probabilities of each output token returned in the content of message._ Will be returned in the output list at slot 3.
#'
#' @return A list with three data tables (if `output_type` is the default "complete"): [[1]] contains the data table with the columns `n` (= the mo. of `n` responses requested), `prompt_role` (= the role that was set for the prompt), `prompt_content` (= the content that was set for the prompt), `rgpt_role` (= the role that the GPT model assumed in the chat completion) and `rgpt_content` (= the content that the GPT model provided with its assumed role in the chat completion). [[2]] contains the meta information of the request, including the request id, the parameters of the request and the token usage of the prompt (`tok_usage_prompt`), the completion (`tok_usage_completion`), the total usage (`tok_usage_total`), and the system fingerprint (`system_fingerprint`) (for reproducibility related to the seed). [[3]] contains the tokens of the completion (per n requests if applicable) and the corresponding log probabilities.
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
#'
#' ## Simple request with defaults:
#' rgpt_single(prompt_content = 'You are a teacher: explain to me what science is')
#'
#' ## Instruct a GPT model to write ten research ideas of max. 150 tokens with some controls:
#' rgpt_single(prompt_role = 'user', prompt_content = 'Write a research idea about using text data to understand human behaviour:'
#'    , temperature = 0.8
#'    , n = 10
#'    , max_tokens = 150)
#'
#' ## For fully reproducible results, we need to set a seed, e.g., `seed = 42`, e.g.:
#' rgpt_single(prompt_content = 'Finish this sentence:/n There is no easier way to learn R than'
#'     , temperature = 0.7
#'     , seed = 42
#'     , max_tokens = 50)
#'
#' @export
rgpt_single = function(prompt_role = 'user'
                          , prompt_content
                          , seed = NULL
                          , model = 'gpt-4o'
                          , output_type = 'complete'
                          , max_tokens = 100
                          , temperature = 1.0
                          , top_p = 1
                          , n = 1
                          , stop = NULL
                          , presence_penalty = 0
                          , frequency_penalty = 0
                          , logprobs = T
){

  models = c('gpt-3.5-turbo-0125'
             , 'gpt-3.5-turbo'
             , 'gpt-3.5-turbo-1106'
             , 'gpt-3.5-turbo-16k'
             , 'gpt-4'
             , 'gpt-4-0125-preview'
             , 'gpt-4-turbo-preview'
             , 'gpt-4-turbo-2024-04-09'
             , 'gpt-4-turbo'
             , 'gpt-4o'
             , 'gpt-4o-mini')

  if(!model %in% models){
    message(paste0('The `model` is not on the list of supported models or contains a typo. For current models, have a look at: https://platform.openai.com/docs/models.\n However, your model may still work as the package supports newer releases.'))
  }


  if(temperature == 0 & n > 1){
    n = 1
    message('You are running the deterministic model, so `n` was set to 1 to avoid unnecessary token quota usage.')
  }

  if(is.numeric(seed)){
    seed = seed
    seed_info = seed
  } else {
    seed = NULL
    seed_info = NA
  }


  messages = c = data.frame(role = prompt_role
                            , content = prompt_content)

  parameter_list = list(messages = messages
                        , model = model
                        , seed = seed
                        , max_tokens = max_tokens
                        , temperature = temperature
                        , top_p = top_p
                        , n = n
                        , stop = stop
                        , presence_penalty = presence_penalty
                        , frequency_penalty = frequency_penalty
                        , logprobs = logprobs
  )

  request_base = httr::POST(url = url.chat_completions
                            , body = parameter_list
                            , httr::add_headers(Authorization = paste("Bearer", api_key))
                            , encode = "json")

  request_content = httr::content(request_base)

  if(request_base$status_code != 200){
    warning(paste0("Request completed with error. Code: ", request_base$status_code
                   , ", message: ", request_content$error$message))
  }

  if(n == 1){

    core_output = data.table::data.table('n' = 1
                                         , 'prompt_role' = prompt_role
                                         , 'prompt_content' = prompt_content
                                         , 'gpt_role' = request_content$choices[[1]]$message$role
                                         , 'gpt_content' = request_content$choices[[1]]$message$content)


    if(logprobs == T){
      data_logprobs = request_content$choices[[1]]$logprobs[[1]]
      logprobs_output = data.table::data.table('token' = rep("", length(data_logprobs))
                                               , 'logprob' = rep(0, length(data_logprobs)))

      for(i in 1:length(data_logprobs)){
        logprobs_output$token[i] = data_logprobs[[i]]$token
        logprobs_output$logprob[i] = data_logprobs[[i]]$logprob
      }
    }

  } else if(n > 1){

    core_output = data.table::data.table('n' = 1:n
                                         , 'prompt_role' = rep(prompt_role, n)
                                         , 'prompt_content' = rep(prompt_content, n)
                                         , 'gpt_role' = rep("", n)
                                         , 'gpt_content' = rep("", n))

    logprobs_output_list = list()

    for(i in 1:n){
      core_output$gpt_role[i] = request_content$choices[[i]]$message$role
      core_output$gpt_content[i] = request_content$choices[[i]]$message$content


      if(logprobs == T){
        data_logprobs = request_content$choices[[i]]$logprobs[[1]]

        logprobs_output = data.table::data.table('n' = i
                                                 , 'token' = rep("", length(data_logprobs))
                                                 , 'logprob' = rep(0, length(data_logprobs)))

        for(j in 1:length(data_logprobs)){
          logprobs_output$token[j] = data_logprobs[[j]]$token
          logprobs_output$logprob[j] = data_logprobs[[j]]$logprob
        }

        logprobs_output_list[[i]] = logprobs_output
      }



    }

    if(logprobs == T){
      logprobs_output = data.table::rbindlist(logprobs_output_list)
    } else {
      logprobs_output = 'no logprobs requested'
    }


  }

  meta_output = data.table::data.table('request_id' = request_content$id
                                       , 'object' = request_content$object
                                       , 'model' = request_content$model
                                       , 'param_prompt_role' = prompt_role
                                       , 'param_prompt_content' = prompt_content
                                       , 'param_seed' = seed_info
                                       , 'param_model' = model
                                       , 'param_max_tokens' = max_tokens
                                       , 'param_temperature' = temperature
                                       , 'param_top_p' = top_p
                                       , 'param_n' = n
                                       , 'param_stop' = stop
                                       , 'param_logprobs' = logprobs
                                       , 'param_presence_penalty' = presence_penalty
                                       , 'param_frequency_penalty' = frequency_penalty
                                       , 'tok_usage_prompt' = request_content$usage$prompt_tokens
                                       , 'tok_usage_completion' = request_content$usage$completion_tokens
                                       , 'tok_usage_total' = request_content$usage$total_tokens
                                       , 'system_fingerprint' = request_content$system_fingerprint)


  if(output_type == 'complete'){
    output = list(core_output
                  , meta_output
                  , logprobs_output)
  } else if(output_type == 'meta'){
    output = meta_output
  } else if(output_type == 'text'){
    output = core_output
  } else if(output_type == 'logprobs'){
    output = logprobs_output
  }

  return(output)

}
