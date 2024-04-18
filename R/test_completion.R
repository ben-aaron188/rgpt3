#' Make a test request to the GPT API
#'
#' @description
#' `rgpt_test_completion()` sends a basic [completion request](https://beta.openai.com/docs/api-reference/completions) to the Open AI GPT API.
#' @param verbose (boolean) if TRUE prints the actual prompt and GPT completion of the test request (default: TRUE).
#' @return A message of success or failure of the connection.
#' @examples
#' rgpt_test_completion()
#' @export
rgpt_test_completion = function(verbose=T){

  check_apikey_form()

  test_prompt = 'Write a story about R Studio: '
  test_output = rgpt_single(prompt_content = test_prompt
                            , max_tokens = 100
                            , model = 'gpt-3.5-turbo-0125')
  print(paste0('.. test successful ..'))

  if(verbose==T){
    test_output
  }

}
