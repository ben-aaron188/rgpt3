#' Retrieves text embeddings for character input from a vector from OpenAI's GPT API
#'
#' @description
#' `rgpt_embeddings()` extends the single embeddings function `rgpt_single_embedding()` to allow for the processing of a whole vector
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
#' @param input_var character vector that contains the texts for which you want to obtain text embeddings from the specified GPT model
#' @param id_var (optional) character vector that contains the user-defined ids of the prompts. See details.
#' @param param_model a character vector that indicates the [embedding model](https://beta.openai.com/docs/guides/embeddings/embedding-models); one of "text-embedding-3-large" (default), "text-embedding-3-small", "text-embedding-ada-002"
#' @return A data.table with the embeddings as separate columns; one row represents one input text. See details.
#' @examples
#' # First authenticate with your API key via `rgpt_authenticate('pathtokey')`
#'
#' # Use example data:
#' ## The data below were generated with the `rgpt_single()` function as follows:
#' ##### DO NOT RUN #####
#' # travel_blog_data = rgpt_single(prompt_content = "Write a travel blog about a dog's journey through the UK:", temperature = 0.8, n = 10, max_tokens = 200, seed = 36)[[1]]
#' ##### END DO NOT RUN #####
#'
#' # You can load these data with:
#' data("travel_blog_data") # the dataset contains 10 completions for the above request
#'
#' ## Obtain text embeddings for the completion texts:
#' emb_travelblogs = rgpt_embeddings(input_var = travel_blog_data$gpt_content)
#' dim(emb_travelblogs)
#'@export
rgpt_embeddings = function(input_var
                                , id_var
                                , param_model = 'text-embedding-3-large'){

  data_length = length(input_var)
  if(missing(id_var)){
    data_id = paste0('prompt_', 1:data_length)
  } else {
    data_id = id_var
  }

  empty_list = list()

  for(i in 1:data_length){

    print(paste0('Embedding: ', i, '/', data_length))

    row_outcome = rgpt_single_embedding(model = param_model
                                      , input = input_var[i])

    empty_df = data.frame(t(row_outcome))
    names(empty_df) = paste0('dim_', 1:length(row_outcome))
    empty_df$id = data_id[i]

    empty_list[[i]] = empty_df


  }

  output_data = data.table::rbindlist(empty_list)

  return(output_data)

}
