#' Obtains text embeddings for a single character (string) from the GPT-3 API
#'
#' @description `gpt3_single_embedding()` sends a single [embedding
#'   request](https://beta.openai.com/docs/guides/embeddings) to the Open AI
#'   GPT-3 API.
#' @details The function supports the text similarity embeddings for the four
#'   GPT-3 models as specified in the parameter list. The main difference
#'   between the four models is the sophistication of the embedding
#'   representation as indicated by the vector embedding size. -
#'   Second-generation embeddings model `text-embedding-ada-002` (1536
#'   dimensions) - Ada (1024 dimensions) - Babbage (2048 dimensions) - Curie
#'   (4096 dimensions) - Davinci (12288 dimensions)
#'
#'   Note that the dimension size (= vector length), speed and [associated
#'   costs](https://openai.com/api/pricing/) differ considerably.
#'
#'   These vectors can be used for downstream tasks such as (vector) similarity
#'   calculations.
#' @param input character that contains the text for which you want to obtain
#'   text embeddings from the GPT-3 model
#' @param model a character vector that indicates the [similarity embedding
#'   model](https://beta.openai.com/docs/guides/embeddings/similarity-embeddings);
#'    one of "text-embedding-ada-002" (default), "text-similarity-ada-001",
#'   "text-similarity-curie-001", "text-similarity-babbage-001",
#'   "text-similarity-davinci-001". Note: it is strongly recommend to use the
#'   faster, cheaper and higher quality second generation embeddings model
#'   "text-embedding-ada-002".
#' @return A numeric vector (= the embedding vector)
#' @examples
#' # First authenticate with your API key via `gpt3_authenticate('pathtokey')`
#'
#' # Once authenticated:
#'
#' ## Simple request with defaults:
#' sample_string = "London is one of the most liveable cities in the world.
#' The city is always full of energy and people. It's always a great place
#' to explore and have fun."
#' gpt3_single_embedding(input = sample_string)
#'
#' ## Change the model:
#' gpt3_single_embedding(input = sample_string
#'   , model = 'text-similarity-curie-001')
#' @export
gpt3_single_embedding = function(input
                               , model = 'text-embedding-ada-002'
                               ){

  parameter_list = list(model = model
                        , input = input)

  request_base = httr::POST(url = url.embeddings
                            , body = parameter_list
                            , httr::add_headers(Authorization = paste("Bearer", pkg.env$api_key))
                            , encode = "json")


  output_base = httr::content(request_base)

  embedding_raw = to_numeric(unlist(output_base$data[[1]]$embedding))

  return(embedding_raw)

}
