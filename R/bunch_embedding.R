#' Retrieves text embeddings for character input from a vector from the GPT-3 API
#'
#' @description
#' `gpt3_bunch_embedding()` extends the single embeddings function `gpt3_make_embedding()` to allow for the processing of a whole vector
#' @details The returned data.table contains the column `id` which indicates the text id (or its generic alternative if not specified) and the columns `dim_1` ... `dim_{max}`, where `max` is the length of the text embeddings vector that the four different models return. For the default "Ada" model, these are 1024 dimensions (i.e., `dim_1`... `dim_1024`).
#'
#' The function supports the text similarity embeddings for the four GPT-3 models as specified in the parameter list. The main difference between the four models is the sophistication of the embedding representation as indicated by the vector embedding size.
#'   - Ada (1024 dimensions)
#'   - Babbage (2048 dimensions)
#'   - Curie (4096 dimensions)
#'   - Davinci (12288 dimensions)
#'
#' Note that the dimension size (= vector length), speed and [associated costs](https://openai.com/api/pricing/) differ considerably.
#'
#' These vectors can be used for downstream tasks such as (vector) similarity calculations.
#' @param input_var character vector that contains the texts for which you want to obtain text embeddings from the GPT-3 model
#' #' @param id_var (optional) character vector that contains the user-defined ids of the prompts. See details.
#' @param param_model a character vector that indicates the [similarity embedding model](https://beta.openai.com/docs/guides/embeddings/similarity-embeddings); one of "text-similarity-ada-001" (default), "text-similarity-curie-001", "text-similarity-babbage-001", "text-similarity-davinci-001"
#' @return A data.table with the embeddings as separate columns; one row represents one input text. See details.
#' @examples
#' # First authenticate with your API key via `gpt3_authenticate('pathtokey')`
#'
#' # Use example data:
#' ## The data below were generated with the `gpt3_make_request()` function as follows:
#' ##### DO NOT RUN #####
#' # travel_blog_data = gpt3_make_request(prompt_input = "Write a travel blog about a dog's journey through the UK:", temperature = 0.8, n = 10, max_tokens = 200)[[1]]
#' ##### END DO NOT RUN #####
#'
#' # You can load these data with:
#' data("travel_blog_data") # the dataset contains 10 completions for the above request
#'
#' ## Obtain text embeddings for the completion texts:
#' emb_travelblogs = gpt3_bunch_embedding(input_var = travel_blog_data$gpt3)
#' dim(emb_travelblogs)
#' @export
gpt3_bunch_embedding = function(input_var
                                , id_var
                                , param_model = 'text-similarity-ada-001'){

  data_length = length(input_var)
  if(missing(id_var)){
    data_id = paste0('prompt_', 1:data_length)
  } else {
    data_id = id_var
  }

  empty_list = list()

  for(i in 1:data_length){

    print(paste0('Embedding: ', i, '/', data_length))

    row_outcome = gpt3_make_embedding(model = param_model
                                      , input = input_var[i])

    empty_df = data.frame(t(row_outcome))
    names(empty_df) = paste0('dim_', 1:length(row_outcome))
    empty_df$id = data_id[i]

    empty_list[[i]] = empty_df


  }

  output_data = rbindlist(empty_list)

  return(output_data)

}
