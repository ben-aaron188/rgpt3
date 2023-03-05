#' Makes a single chat completion request to the ChatGPT API
#'
#' @description
#' `chatgpt_single()` sends a single [chat completion request](https://platform.openai.com/docs/guides/chat) to the Open AI GPT API. Doing so, makes this equivalent to the sending single completion requests with `gpt3_single_completion()`. You can see the notes on chat vs completion requests here: [https://platform.openai.com/docs/guides/chat/chat-vs-completions](https://platform.openai.com/docs/guides/chat/chat-vs-completions). This function allows you to specify the role and content for your API call.
#' @details For a general guide on the completion requests, see [https://platform.openai.com/docs/api-reference/chat](https://platform.openai.com/docs/api-reference/chat). This function provides you with an R wrapper to send requests with the full range of request parameters as detailed on [https://beta.openai.com/docs/api-reference/completions](https://beta.openai.com/docs/api-reference/completions) and reproduced below.
#'
#' Parameters not included/supported:
#'   - `logit_bias`: [https://platform.openai.com/docs/api-reference/chat/create#chat/create-logit_bias](https://platform.openai.com/docs/api-reference/chat/create#chat/create-logit_bias)
#'   - `stream`: [https://platform.openai.com/docs/api-reference/chat/create#chat/create-stream](https://platform.openai.com/docs/api-reference/chat/create#chat/create-stream)
#'
#'
#' @param prompt_role character (default: 'user') that contains the role for the prompt message in the ChatGPT message format. Must be one of 'system', 'assistant', 'user' (default), see [https://platform.openai.com/docs/guides/chat](https://platform.openai.com/docs/guides/chat)
#' @param prompt_content character that contains the content for the prompt message in the ChatGPT message format, see [https://platform.openai.com/docs/guides/chat](https://platform.openai.com/docs/guides/chat). This is the key instruction that ChatGPT receives.
#' @param model a character vector that indicates the [ChatGPT model](https://platform.openai.com/docs/api-reference/chat/create#chat/create-model) to use; one of "gpt-3.5-turbo" (default), "gpt-3.5-turbo-0301"
#' @param output_type character determining the output provided: "complete" (default), "text" or "meta"
#' @param max_tokens numeric (default: 100) indicating the maximum number of tokens that the completion request should return (from the official API documentation: _The maximum number of tokens allowed for the generated answer. By default, the number of tokens the model can return will be (4096 - prompt tokens)._)
#' @param temperature numeric (default: 1.0) specifying the sampling strategy of the possible completions (from the official API documentation: _What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or `top_p` but not both._)
#' @param top_p numeric (default: 1) specifying sampling strategy as an alternative to the temperature sampling (from the official API documentation: _An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered. We generally recommend altering this or `temperature` but not both._)
#' @param n numeric (default: 1) specifying the number of completions per request (from the official API documentation: _How many chat completion choices to generate for each input message. **Note: Because this parameter generates many completions, it can quickly consume your token quota.** Use carefully and ensure that you have reasonable settings for max_tokens and stop._)
#' @param stop character or character vector (default: NULL) that specifies after which character value when the completion should end (from the official API documentation: _Up to 4 sequences where the API will stop generating further tokens._)
#' @param presence_penalty numeric (default: 0) between -2.00  and +2.00 to determine the penalisation of repetitiveness if a token already exists (from the official API documentation: _Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics._). See also: [https://beta.openai.com/docs/api-reference/parameter-details](https://beta.openai.com/docs/api-reference/parameter-details)
#' @param frequency_penalty numeric (default: 0) between -2.00  and +2.00 to determine the penalisation of repetitiveness based on the frequency of a token in the text already (from the official API documentation: _Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim._). See also: [https://beta.openai.com/docs/api-reference/parameter-details](https://beta.openai.com/docs/api-reference/parameter-details)
#'
#' @return A list with two data tables (if `output_type` is the default "complete"): [[1]] contains the data table with the columns `n` (= the mo. of `n` responses requested), `prompt_role` (= the role that was set for the prompt), `prompt_content` (= the content that was set for the prompt), `chatgpt_role` (= the role that ChatGPT assumed in the chat completion) and `chatgpt_content` (= the content that ChatGPT provided with its assumed role in the chat completion). [[2]] contains the meta information of the request, including the request id, the parameters of the request and the token usage of the prompt (`tok_usage_prompt`), the completion (`tok_usage_completion`) and the total usage (`tok_usage_total`).
#'
#' If `output_type` is "text", only the data table in slot [[1]] is returned.
#'
#' If `output_type` is "meta", only the data table in slot [[2]] is returned.
#' @examples
#' # First authenticate with your API key via `gpt3_authenticate('pathtokey')`
#'
#' # Once authenticated:
#'
#' ## Simple request with defaults:
#' chatgpt_single(prompt_content = 'You are a teacher: explain to me what science is')
#'
#' ## Instruct ChatGPT to write ten research ideas of max. 150 tokens with some controls:
#' chatgpt_single(prompt_role = 'user', prompt_content = 'Write a research idea about using text data to understand human behaviour:'
#'    , temperature = 0.8
#'    , n = 10
#'    , max_tokens = 150)
#'
#' ## For fully reproducible results, we need `temperature = 0`, e.g.:
#' chatgpt_single(prompt_content = 'Finish this sentence:/n There is no easier way to learn R than'
#'     , temperature = 0.0
#'     , max_tokens = 50)
#'
#' @export
chatgpt_single = function(prompt_role = 'user'
                          , prompt_content
                          , model = 'gpt-3.5-turbo'
                          , output_type = 'complete'
                          , max_tokens = 100
                          , temperature = 1.0
                          , top_p = 1
                          , n = 1
                          , stop = NULL
                          , presence_penalty = 0
                          , frequency_penalty = 0
                          ){

  #check for request issues with `n` and `best_of`

  if(temperature == 0 & n > 1){
    n = 1
    message('You are running the deterministic model, so `n` was set to 1 to avoid unnecessary token quota usage.')
  }

  messages = c = data.frame(role = prompt_role
                            , content = prompt_content)

  parameter_list = list(messages = messages
                        , model = model
                        , max_tokens = max_tokens
                        , temperature = temperature
                        , top_p = top_p
                        , n = n
                        , stop = stop
                        , presence_penalty = presence_penalty
                        , frequency_penalty = frequency_penalty
                        )

  request_base = httr::POST(url = url.chat_completions
                            , body = parameter_list
                            , httr::add_headers(Authorization = paste("Bearer", api_key))
                            , encode = "json")

  request_content = httr::content(request_base)

  if(n == 1){
    core_output = data.table::data.table('n' = 1
                                         , 'prompt_role' = prompt_role
                                         , 'prompt_content' = prompt_content
                                         , 'chatgpt_role' = request_content$choices[[1]]$message$role
                                         , 'chatgpt_content' = request_content$choices[[1]]$message$content)
  } else if(n > 1){

    core_output = data.table::data.table('n' = 1:n
                                         , 'prompt_role' = rep(prompt_role, n)
                                         , 'prompt_content' = rep(prompt_content, n)
                                         , 'chatgpt_role' = rep("", n)
                                         , 'chatgpt_content' = rep("", n))

    for(i in 1:n){
      core_output$chatgpt_role[i] = request_content$choices[[i]]$message$role
      core_output$chatgpt_content[i] = request_content$choices[[i]]$message$content
    }

  }


  meta_output = data.table::data.table('request_id' = request_content$id
                                       , 'object' = request_content$object
                                       , 'model' = request_content$model
                                       , 'param_prompt_role' = prompt_role
                                       , 'param_prompt_content' = prompt_content
                                       , 'param_model' = model
                                       , 'param_max_tokens' = max_tokens
                                       , 'param_temperature' = temperature
                                       , 'param_top_p' = top_p
                                       , 'param_n' = n
                                       , 'param_stop' = stop
                                       , 'param_presence_penalty' = presence_penalty
                                       , 'param_frequency_penalty' = frequency_penalty
                                       , 'tok_usage_prompt' = request_content$usage$prompt_tokens
                                       , 'tok_usage_completion' = request_content$usage$completion_tokens
                                       , 'tok_usage_total' = request_content$usage$total_tokens)


  if(output_type == 'complete'){
    output = list(core_output
                  , meta_output)
  } else if(output_type == 'meta'){
    output = meta_output
  } else if(output_type == 'text'){
    output = core_output
  }

  return(output)

}
