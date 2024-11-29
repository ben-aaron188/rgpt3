#' Obtains text embeddings for a single character (string) from OpenAI's GPT API
#'
#' @description
#' `rgpt_single_embedding()` sends a single [embedding request](https://beta.openai.com/docs/guides/embeddings) to the Open AI GPT API.
#' @details The returned data.table contains the column `id` which indicates the text id (or its generic alternative if not specified) and the columns `dim_1` ... `dim_{max}`, where `max` is the length of the text embeddings vector that the different models (see below) return. For the default "Embedding V3 large" model, these are 3072 dimensions (i.e., `dim_1`... `dim_3072`).
#'
#' The function supports the text similarity embeddings for the [three GPT embeddings models](https://platform.openai.com/docs/models/embeddings) as specified in the parameter list.
#'   - Embedding V3 large `text-embedding-3-large` (3072 dimensions)
#'   - Embedding V3 small `text-embedding-3-small` (1536 dimensions)
#'   - Ada 2nd generation `text-embedding-ada-002` (1536 dimensions)
#'
#' Note that the dimension size (= vector length), speed and [associated costs](https://openai.com/api/pricing/) differ considerably.
#'
#' These vectors can be used for downstream tasks such as (vector) similarity calculations.
#' @param input character that contains the text for which you want to obtain text embeddings from the specified GPT model
#' @param model a character vector that indicates the [embedding model](https://beta.openai.com/docs/guides/embeddings/embedding-models); one of "text-embedding-3-large" (default), "text-embedding-3-small", "text-embedding-ada-002"
#' @param dimensions a numeric value (default: 256) to indicate the number of dimensions to shorten the embeddings size (see: https://platform.openai.com/docs/guides/embeddings). This parameter only works for the `text-embedding-3-large` model. For all embeddings dimensions, set the parameter to 3072.
#' @return A numeric vector (= the embedding vector)
#' @examples
#' # First authenticate with your API key via `rgpt_authenticate('pathtokey')`
#'
#' # Once authenticated:
#'
#' ## Simple request with defaults:
#' sample_string = "London is one of the most liveable cities in the world. The city is always full of energy and people. It's always a great place to explore and have fun."
#' rgpt_single_embedding(input = sample_string)
#'
#' ## Change the model:
#' rgpt_single_embedding(input = sample_string
#'   , model = 'text-embedding-ada-002')
#' @export
rgpt_single_embedding = function(input
                               , model = 'text-embedding-3-large'
                               , dimensions = 256
                               ){

  if (model == 'text-embedding-3-large') {
    parameter_list = list(model = model
                          , input = input
                          , dimensions = dimensions)
  } else {
    parameter_list = list(model = model
                          , input = input)
  }


  request_base = httr::POST(url = url.embeddings
                            , body = parameter_list
                            , httr::add_headers(Authorization = paste("Bearer", api_key))
                            , encode = "json")

  if(request_base$status_code != 200){
    warning(paste0("Request completed with error. Code: ", request_base$status_code
                   , ", message: ", request_content$error$message))
  }

  output_base = httr::content(request_base)

  embedding_raw = to_numeric(unlist(output_base$data[[1]]$embedding))

  return(embedding_raw)

}
