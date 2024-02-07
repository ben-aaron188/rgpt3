#' Set up the authentication with your API key
#'
#' @description
#' Access to GPT's functions requires an API key that you obtain from [https://openai.com/api/](https://openai.com/api/). `rgpt_authenticate()` looks for your API key in a file that you provide the path to and ensures you can connect to the models. `rgpt_endsession()` overwrites your API key _for this session_ (it is recommended that you run this when you are done). `check_apikey_form()` is a simple check if any information has been provided at all.
#' @param path The file path to the API key
#' @return A confirmation message
#' @details The easiest way to store you API key is in a `.txt` file with _only_ the API key in it (without quotation marks or other common string indicators). `rgpt_authenticate()` reads the single file you point it to and retrieves the content as authentication key for all requests.
#' @examples
#' # Starting a session:
#' rgpt_authenticate(path = './YOURPATH/access_key.txt')
# '
#' # After you are finished:
#' rgpt_endsession()
#' @export
rgpt_authenticate = function(path){
  apikey_ = readLines(path)
  api_key <<- apikey_
  print(paste0("Will use --> ", api_key, " for authentication."))
}

rgpt_endsession = function(){
  api_key = "---"
  rm(api_key)
  print('-- session ended: you need to re-authenticate again next time.')
}

check_apikey_form = function(){

  if(exists(x = 'api_key') == F){
    warning("Use rgpt_authenticate() to set your API key")
  } else if(nchar(api_key) < 10){

    warning("Use rgpt_authenticate() to set your API key")

  }
}
