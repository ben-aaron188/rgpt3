#' Set up the authentication with your API key
#'
#' @description
#' Access to GPT-3's functions requires an API key that you obtain from [https://openai.com/api/](https://openai.com/api/). `gpt3.authenticate()` accepts your API key and ensures that you can connect to the models. `gpt3.endsession()` overwrites your API key _for this session_ (it is recommended that you run this when you are done). `check_apikey_form()` is a simple check if any information has been provided at all.
#' @param apikey A character vector that is your personal API key
#' @return A confirmation message
#' @examples
#' # Starting a session:
#' gpt3.authenticate(apikey = 'REPLACE_THIS_WITH_YOUR_KEY')
# '
#' # After you are finished:
#' gpt3.endsession()
#' @export
gpt3.authenticate = function(apikey){
  api_key <<- apikey
  print(paste0("Will use --> ", api_key, " for authentication."))
}

gpt3.endsession = function(){
  api_key = "---"
  print('-- session ended: you need to re-authenticate again next time.')
}

check_apikey_form = function(){

  if(exists(x = 'api_key') == F){
    warning("Use gpt3.authenticate() to set your API key")
  } else if(nchar(api_key) < 10){

    warning("Use gpt3.authenticate() to set your API key")

  }
}
