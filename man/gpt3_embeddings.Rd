% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gpt3_embeddings.R
\name{gpt3_embeddings}
\alias{gpt3_embeddings}
\title{Retrieves text embeddings for character input from a vector from the GPT-3 API}
\usage{
gpt3_embeddings(input_var, id_var, param_model = "text-embedding-ada-002")
}
\arguments{
\item{input_var}{character vector that contains the texts for which you want to obtain text embeddings from the GPT-3 model
#' @param id_var (optional) character vector that contains the user-defined ids of the prompts. See details.}

\item{param_model}{a character vector that indicates the \href{https://beta.openai.com/docs/guides/embeddings/embedding-models}{embedding model}; one of "text-embedding-ada-002" (default), "text-similarity-ada-001", "text-similarity-curie-001", "text-similarity-babbage-001", "text-similarity-davinci-001"}
}
\value{
A data.table with the embeddings as separate columns; one row represents one input text. See details.
}
\description{
\code{gpt3_embeddings()} extends the single embeddings function \code{gpt3_single_embedding()} to allow for the processing of a whole vector
}
\details{
The returned data.table contains the column \code{id} which indicates the text id (or its generic alternative if not specified) and the columns \code{dim_1} ... \verb{dim_\{max\}}, where \code{max} is the length of the text embeddings vector that the different models (see below) return. For the default "Ada 2nd gen." model, these are 1536 dimensions (i.e., \code{dim_1}... \code{dim_1536}).

The function supports the text similarity embeddings for the \href{https://beta.openai.com/docs/guides/embeddings/embedding-models}{five GPT-3 embeddings models} as specified in the parameter list. It is strongly advised to use the second generation model "text-embedding-ada-002". The main difference between the five models is the size of the embedding representation as indicated by the vector embedding size and the pricing. The newest model (default) is the fastest, cheapest and highest quality one.
\itemize{
\item Ada 2nd generation \code{text-embedding-ada-002} (1536 dimensions)
\item Ada (1024 dimensions)
\item Babbage (2048 dimensions)
\item Curie (4096 dimensions)
\item Davinci (12288 dimensions)
}

Note that the dimension size (= vector length), speed and \href{https://openai.com/api/pricing/}{associated costs} differ considerably.

These vectors can be used for downstream tasks such as (vector) similarity calculations.
}
\examples{
# First authenticate with your API key via `gpt3_authenticate('pathtokey')`

# Use example data:
## The data below were generated with the `gpt3_single_request()` function as follows:
##### DO NOT RUN #####
# travel_blog_data = gpt3_single_request(prompt_input = "Write a travel blog about a dog's journey through the UK:", temperature = 0.8, n = 10, max_tokens = 200)[[1]]
##### END DO NOT RUN #####

# You can load these data with:
data("travel_blog_data") # the dataset contains 10 completions for the above request

## Obtain text embeddings for the completion texts:
emb_travelblogs = gpt3_embeddings(input_var = travel_blog_data$gpt3)
dim(emb_travelblogs)
}
