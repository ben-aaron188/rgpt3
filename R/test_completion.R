#' Make a test request to the GPT-3 API
#'
#' @description `gpt3_test_completion()` sends a basic [completion
#'   request](https://beta.openai.com/docs/api-reference/completions) to the
#'   Open AI GPT-3 API.
#' @param verbose (boolean) if TRUE prints the actual prompt and GPT-3
#'   completion of the test request (default: TRUE).
#' @return A message of success or failure of the connection.
#' @examples
#' gpt3_test_completion()
#' @export
gpt3_test_completion = function(verbose=T){

  check_apikey_form()

  test_prompt = 'Write a story about R Studio: '
  test_output = gpt3_single_completion(prompt_ = test_prompt
                                  , max_tokens = 100)
  print(paste0('.. test successful ..'))

  if(verbose==T){
    # print(paste0('Requested completion for this prompt --> ', test_prompt))
    # print(paste0('GPT-3 completed --> ', test_output))
    test_output
  }

}
