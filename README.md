[![DOI](https://zenodo.org/badge/533971880.svg)](https://zenodo.org/badge/latestdoi/533971880)

# `rgpt3` 

**Making requests from R to the GPT models**

_Note: this is a "community-maintained” package (i.e., not the official one). For the official OpenAI libraries (python and node.js endpoints), go to [https://beta.openai.com/docs/libraries/python-bindings](https://beta.openai.com/docs/libraries/python-bindings)_

## Updated package version 

_Read this if you used this package previously_

With the latest release, the model has been re-designed to accommodate and reflect changes in OpenAI's completion structure.

Previously, there was a difference between text completions and chat completions. This is no longer the case. Similarly, with more models having been released, the naming of the functions as `gpt3...(...)` was misleading as it suggested the requests would necessarily go via the GPT-3 model.

To make interaction easier and less confusing, this R package now **wraps all functions into a general `rgpt(...)` function** which can deal with all GPT models and allows you to make requests to more models than before.

In short: with the new package structure all GPT models can be used in one common wrapper and easier to adapt for future releases from OpenAI.


## Getting started

You can follow these steps to get started with making requests and retrieving embeddings from the Open AI GPT language models.

_If you already have an Open AI API key, you can skip step 1._

1. Obtain your API key

Go to [https://openai.com/api/](https://openai.com/api/), register for a free account and obtain your API key located at [https://beta.openai.com/account/api-keys](https://beta.openai.com/account/api-keys).

Note that Open AI may rotate your key from time to time (but you should receive an email on your registered account if they do so).

2. Set up the `access_key.txt` file

Your access workflow for this package retrieves your API key from a local file. That file is easiest called `access_key.txt` (but any other file name would do). Important is that you use a `.txt` file with just the API key in there (i.e. no string quotation marks).

The path to that file (e.g. `/Users/me/directory1/access_key.txt`) is needed for the `rgpt_authenticate()` function (see below).

When using a version control workflow, make sure `access_key.txt` is in the `.gitignore` file (i.e., so your access code is not visible on a GitHub repo). If you use the package without any version control, you do not need to set a `.gitignore` file.

3. Install the `rgpt3` package

The easiest way to use the package (before its CRAN release) is:

```{r}
devtools::install_github("ben-aaron188/rgpt3")
library(rgpt3)
```

4. Run the test workflow

Once the package is installed, you will typically run this work flow:

**Authentication:**

Get the path to your access key file and run the authentication with: `rgpt_authenticate("PATHTO/access_key.txt")`

**Make the test request:**

You can run the test function below, which sends a simple request (here: the instruction to "Write a story about R Studio:") to the API and returns the output in the format used in this package (i.e., `list[[1]]` --> prompt and output, `list[[2]]` = meta information).

```{r}
rgpt_test_completion()
```

## Known issues and fixes

### API model access privileges

For some of the most recent models (e.g., the GPT-4 models), you may need to check if you have access to them via the API. This used to be limited to paid accounts. If you do not have access to a model and run a request via this R package, you will encounter an error. In that case, best try other (older) models to identify if that was the issue.

### API call error

Error: `Error in core_output$gpt_content[i] ... replacement has length zero`

This error is telling you that the call made to the API was not successful. This should already fail when you run the `rgpt_test_completion()` function. There are several things that can cause this, so best check the below if you get this error (in that order):

1. Did you run the authentication properly to your API key with `rgpt_authenticate("/Users/.../access_key.txt")` (the path can take any form as long as you point it to a file (here called: `access_key.txt`) where your API key is located
1. Does the file with your API key (e.g., `access_key.txt`) contain a newline after the API? It should contain a newline, so add one if this is missing.
1. Is your free API limit from OpenAI still within the valid period (this is usually one month)?
1. Are you still within the actual API limit (whether you use a free account or a paid one)?
1. Does your API key have access to the model that you seek to use?

If you can answer "yes" to all of the above and the error persists, then please [open an issue](https://github.com/ben-aaron188/rgpt3/issues) so this can be looked into.



## Core functions

Supported models as per 21 May 2024 (see [https://platform.openai.com/docs/models/gpt-4-and-gpt-4-turbo](https://platform.openai.com/docs/models/gpt-4-and-gpt-4-turbo):

```{r}
models = c('gpt-3.5-turbo-0125'
           , 'gpt-3.5-turbo'
           , 'gpt-3.5-turbo-1106'
           , 'gpt-3.5-turbo-16k'
           , 'gpt-3.5-turbo-0613'
           , 'gpt-3.5-turbo-16k-0613'
           , 'gpt-4'
           , 'gpt-4-0613'
           , 'gpt-4-0125-preview'
           , 'gpt-4o')
```



Since v1.0 `rgpt3` is structured into the following functions:

- Making _standard_ requests (i.e. prompting the GPT models)
    - single requests: `rgpt_single()`
    - make multiple prompt-based requests from a source data.frame or data.table: `rgpt()`
- Obtain embeddings
    - obtain embeddings for a single text input: `rgpt_single_embedding`
    - obtain embeddings for multiple texts from a source data.frame or data.table: `rgpt_embeddings()`


_A previous version of the package focused on the GPT-3 model only and used a now deprecated request structure for text completions._

The basic principle is that you can (and should) best use the more extensible `rgpt()` and `rgpt_embeddings()` functions as these allow you to make use of R's vectorisation. These do work even if you have only one prompt or text as input (see below). The difference between the extensible functions and their "single" counterparts is the input format.

This R package gives you full control over the parameters that the API contains. You can find these in detail in the package documentation and help files (e.g., `?rgpt`) on the Open AI website for [completion requests](https://beta.openai.com/docs/api-reference/completions/create) and [embeddings](https://beta.openai.com/docs/api-reference/embeddings/create).

Note: this package enables you to use the core functionality of all current GPT models. This includes ChatGPT: all model requests are run through the chat completions now with recent updates on OpenAI's side. There is no need to differentiate between "classic" text completion and the more recent approach of using chat completions.

There are additional functionalities in the core API such as fine-tuning models (i.e., providing labelled data to update/retrain the existing model) and asking a GPT model to make edits to text input. These are not (yet) part of this package.


## Examples

The examples below illustrate all functions of the package.

Note that due to the [sampling temperature parameter](https://beta.openai.com/docs/api-reference/completions/create#completions/create-temperature) of the requests - unless set to `0.0` - the results may vary (as the model is not deterministic then).

The new [seed](https://platform.openai.com/docs/api-reference/chat/create#chat-create-seed) functionality seeks to make completions reproducible. Note that OpenAI says that even with this new parameter "[d]eterminism is not guaranteed, and you should refer to the `system_fingerprint` response parameter to monitor changes in the backend.". The `system_fingerprint` is provided in the `rgpt()` responses in the meta element.

### Making requests

The basic form of the GPT API connector is via chat completion requests. These requests can be of various kinds including questions ("What is the meaning of life?"), text summarisation tasks, text generation tasks and many more. A whole list of examples is on the [Open AI examples page](https://beta.openai.com/examples).

Think of requests as instructions you give the to model. You may also hear the instructions being referred to as _prompts_ and the task that a GPT model then fulfills as _completions_ (have a look at the API guide on [prompt design](https://beta.openai.com/docs/guides/completion/prompt-design)).

Compared to the earlier models (e.g., GPT-3), we send the requests with a **role** and **content** of the prompts. The role must be one of 'user', 'system' or 'assistant' and you essentially tell the model (all models are now essentially chat models) in which role the content you send is to be interpreted. The content is analogous to the standard prompts. The reason why the role is necessary is that it allows you provide a full back-and-forth conversational flow (e.g., [https://platform.openai.com/docs/guides/chat/introduction](https://platform.openai.com/docs/guides/chat/introduction)).

**Example 1: making a single completion request**

This request "tells" the GPT-4 model (because: `model = 'gpt-4'`) to write a cynical text about human nature (five times) from the perspective of an old, male writer with a sampling temperature of 1.5 and a maximium length of 100 tokens.

```{r}
example_1 = rgpt_single(prompt_role = 'user'
                        , prompt_content = 'You are a cynical, old male writer. Write a cynical text about human nature:'
                        , temperature = 1.5
                        , max_tokens = 100
                        , n = 5)
```

The returned list contains the actual instruction + output in `example_1[[1]]` and meta information about your request in `example_1[[2]]`.

A verbatim excerpt of the produced output (from the `example_1[[1]]$gpt_content` column) here is: 

> Ah, human nature, our ceaseless Achilles' heel, draped cunningly in the tinsel of rational calling and yet hilariously predictable! Ever ponder why history's forefront is marked, not with lessons thoroughly learned, but with Fata Morganas of enlightenment decked so tantalizingly on the horizon we half believe our betterment might be just a few paces ahead? Indulge older veins, dictated rather by life's foul turns than any whip of hopefurled saplings believing in [...]


**Example 2: multiple prompts**

We can extend the example and make multiple requests by using a data.frame / data.table as input for the main function of this package, the `rgpt()` function:

```{r}
my_prompts = data.frame('prompts_roles' = rep('user', 3)
                          , 'prompts_contents' =
                            c('You are a bureacrat. Complete this sentence: universities are'
                              , 'You are an award-winning poet. Write a poem about music:'
                              , 'Which colour is better and why? Red or blue?')
                        ,'prompt_id' = c(LETTERS[1:3]))

example_2 = rgpt(prompt_role_var = my_prompts$prompts_roles
                            , prompt_content_var = my_prompts$prompts_contents
                             , id_var = my_prompts$prompt_id
                             , param_max_tokens = 100
                             , param_n = 5
                             , param_temperature = 0.4)
```

Note that this completion request produced 5 (`param_n = 5`) completions for each of the three prompts, so a total of 15 completions.

You can make these examples reproducible by setting the seed parameter (see function documentation).

The output will show the actual completions in `example_2[[1]]`, the meta information in `example_2[[2]]` and the logprobs in `example_2[[3]]`. The latter looks as follows:

```{r}
[[3]]
          n         token       logprob     id
      <int>        <char>         <num> <char>
   1:     1            un -7.207926e-01      A
   2:     1         ivers -3.650519e-06      A
   3:     1         ities -1.545168e-05      A
   4:     1           are -9.968313e-06      A
   5:     1  institutions -2.104391e-01      A
  ---                                         
1213:     5            in -4.751859e-02      C
1214:     5     different -2.318888e-01      C
1215:     5      cultures -8.649706e-05      C
1216:     5             . -1.692448e-02      C
1217:     5           For -4.265508e-02      C
```



### Embeddings

Here we load the data that comes with the package:

```{r}
data("travel_blog_data")
```

The dataset is now available in your environment as `travel_blog_data`. The column (`travel_blog_data$gpt_content`) contains ten texts written by GPT-4 (instructed to: "Write a travel blog about a dog's journey through the UK:").


**Example 1: get embeddings for a single text**

We can ask the model to retrieve embeddings for [text similarity](https://beta.openai.com/docs/guides/embeddings/similarity-embeddings) for a single text as follows:

```{r}
# we just take the first text here as a single text example
my_text = travel_blog_data$gpt_content[1]
my_embeddings = rgpt_single_embedding(input = my_text)
length(my_embeddings)
# 3072 (since the default model uses the 3072-dimensional V3 (large) embeddings model)

```


**Example 2: get embeddings from text data in a data.frame / data.table**

Now we can do the same example with the full `travel_blog_data` dataset:


```{r}
multiple_embeddings = rgpt_embeddings(input_var = travel_blog_data$gpt_content
                                      , id_var = travel_blog_data$n)
dim(multiple_embeddings)

# [1]    10 3073 # because we have ten rows of 3072 columns each (by default 3072 embeddings elements plus 1 id variable)
```



## Cautionary note

**Read this:** using any of the GPT models is not free, so any interaction with the model(s) is counted towards your token quota. You can find details about Open AI's pricing model at [https://openai.com/api/pricing/](https://openai.com/api/pricing/).

You receive a reasonable credit for free and do not need to provide any payment information for the first interactions with the model(s). Once your token quota nears its end, Open AI will let you know. Your usage is traceable in your Open AI account dashboard.


## Support and contributions

If you have questions or problems, please raise an issue on GitHub.

You are free to make contributions to the package via pull requests. If you do so, you agree that your contributions will be licensed under the [GNU General Public License v3.0](https://github.com/ben-aaron188/rgpt3/blob/main/LICENSE.md).

## Changelog/updates

- [update] 21 May 2024: The new `gpt-4o` model is supported and is now the **default model** for chat completion requests
- [minor fix] 18 Apr 2024: updated model list, fixed default model in test completion function to 'gpt-3.5-turbo-0125'
- [update] 8 Feb 2024: the output now returns the selected tokens and log probabilities in a new (third) output slot.
- [new major release] 7 Feb 2024: general wrapper function for recent GPT models (i.e., 3.5 and 4) with new function `rgpt(...)`; seed control for reproducibility; updated embeddings function with `rgpt_embeddings(...)`
- [small change] 24 Mar 2023: included error handling for httr requests as per [https://github.com/ben-aaron188/rgpt3/pull/7](https://github.com/ben-aaron188/rgpt3/pull/7)
- [new release] 5 Mar 2023: the package now supports ChatGPT 
- [update] 30 Jan 2023: added error shooting for API call errors
- [update] 23 Dec 2022: the embeddings functions now default to the second generation embeddings "text-embedding-ada-002".
- [minor fix] 3 Dec 2022: included handling for encoding issues so that `rbindlist` uses `fill=T` (in `gpt3_completions(...)`)
- [update] 29 Nov 2022: the just released [davinci-003 model](https://beta.openai.com/docs/models/gpt-3) for text completions is now the default model for the text completion functions.

## Citation

```
@software{Kleinberg_rgpt3_Making_requests_2022,
    author = {Kleinberg, Bennett},
    doi = {10.5281/zenodo.7327667},
    month = {5},
    title = {{rgpt3: Making requests from R to the GPT API}},
    url = {https://github.com/ben-aaron188/rgpt3},
    version = {1.0},
    year = {2024}
}
```

See also "Cite this repository" on the right-hand side.
