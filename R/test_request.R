#' Make a test request to the GPT-3 API
#'
#' @description
#' `gpt3_test_request()` sends a basic [completion request](https://beta.openai.com/docs/api-reference/completions) to the Open AI GPT-3 API.
#' @param verbose (boolean) if TRUE prints the actual prompt and GPT-3 completion of the test request (default: FALSE).
#' @return A message of success or failure of the connection.
#' @examples
#' gpt3_test_request()
#' @export
gpt3_test_request = function(verbose=F){

  check_apikey_form()

  test_prompt = 'Write a story about R Studio:'
  test_outout = gpt3_make_request(prompt_ = test_prompt
                                  , max_tokens = 100)
  print(paste0('.. test successful ..'))

  if(verbose==T){
    print(paste0('Requested completion for this prompt --> ', test_prompt))
    print(paste0('GPT-3 completed --> ', test_outout))
  }

}
