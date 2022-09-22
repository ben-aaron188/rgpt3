# `rgpt3` 

**Making requests from R to the GPT-3 API**




## Getting started

You can follow these steps to get started with making requests and retrieving embeddings from the Open AI GPT-3 language model.

_If you already have an Open AI API key, you can skip step 1._

1. Obtain your API key

Go to [https://openai.com/api/](https://openai.com/api/), register for a free account and obtain your API key located at [https://beta.openai.com/account/api-keys](https://beta.openai.com/account/api-keys).

Note that Open AI may rotate your key from time to time (but you should receive an email on your registered account if they do so).

2. Set up the `access_key.txt` file

Your access workflow for this package retrieves your API key from a local file. That file is easiest called `access_key.txt` (but any other file name would do). Important is that you use a `.txt` file with just the API key in there (i.e. no string quotation marks).

The path to that file (e.g. `/Users/me/directory1/access_key.txt`) is needed for the `gpt3_authenticate()` function (see below).


3. Install the `rgpt3` package

The easiest way to use the package (before its CRAN release) is:

```{r}
devtools::install_github("ben-aaron188/rgpt3")
```

4. Run the test workflow

Once the package is installed, you will typically run this work flow:

**Authentication:**

Get the path to your access key file and run the authentication with: `gpt3_authenticate("PATHTO/access_key.txt")`

**Make the test request:**

You can run the test function below, which sends a simple request (here: the instruction to "Write a story about R Studio:") to the API and returns the output in the format used in this package (i.e., `list[[1]]` --> prompt and output, `list[[2]]` = meta information).

```{r}
gpt3_test_request()
```


## Core functions

`rgpt3` currently is structured into the following functions:

- Making requests (i.e. prompting the model)
    - single requests: `gpt3_single_request()`
    - make multiple prompt-based requests from a source data.frame or data.table: `gpt3_requests()`
- Obtain embeddings
    - obtain embeddings for a single text input: `gpt3_single_embedding`
    - obtain embeddings for multiple texts from a source data.frame or data.table: `gpt3_embeddings()`

The basic principle is that you can (and should) best use the more extensible `gpt3_requests()` and `gpt3_embeddings()` functions as these allow you to make use of R's vectorisation. These do work even if you have only one prompt or text as input (see below). The difference between the extensible functions and their "single" counterparts is the input format.

## Examples

The examples below illustrate all functions of the package.

Note that due to the [sampling temperature parameter](https://beta.openai.com/docs/api-reference/completions/create#completions/create-temperature) of the requests - unless set to `0.0` - the results may vary (as the model is not deterministic then).

### Making requests

The basic form of the GPT-3 API connector is via requests. These requests can be of various kinds including questions ("What is the meaning of life?"), text summarisation tasks, text generation tasks and many more. A whole list of examples is on the [Open AI examples page](https://beta.openai.com/examples).

Think of requests as instructions you give the to model. You may also hear the instructions being referred to as _prompts_ and the task that GPT-3 then fulfills as _completions_ (have a look at the API guide on [prompt design](https://beta.openai.com/docs/guides/completion/prompt-design)).

**Example 1: making a single completion request**

This request "tells" GPT-3 to write a cynical text about human nature (five times) with a sampling temperature of 0.9, a maximium length of 100 tokens.

```{r}
example_1 = gpt3_single_request(prompt_input = 'Write a cynical text about human nature:'
                    , temperature = 0.9
                    , max_tokens = 100
                    , n = 5)
```

The returned list contains the actual instruction + output in `example_1[[1]]` and meta information about your request in `example_1[[2]]`.


**Example 2: multiple prompts**

We can extend the example and make multiple requests by using a data.frame / data.table as input for the `gpt3_requests()` function:

```{r}
my_prompts = data.frame('prompts' = 
                          c('Complete this sentence: universities are'
                            , 'Write a poem about music:'
                            , 'Which colour is better and why? Red or blue?')
                        ,'prompt_id' = c(LETTERS[1:3]))

example_2 = gpt3_requests(prompt_var = my_prompts$prompts
              , id_var = my_prompts$prompt_id
              , param_model = 'text-curie-001'
              , param_max_tokens = 100
              , param_n = 5
              , param_temperature = 0.4)
```




### Embeddings

Here we load the data that comes with the package:

```{r}
data("travel_blog_data")
```

The dataset is now available in your environment as `travel_blog_data`. The column (`travel_blog_data$gpt3`) contains ten texts written by GPT-3 (instructed to: "Write a travel blog about a dog's journey through the UK:").


**Example 1: get embeddings for a single text**

We can ask the model to retrieve embeddings for [text similarity](https://beta.openai.com/docs/guides/embeddings/similarity-embeddings) for a single text as follows:

```{r}
# we just take the first text here as a single text example
my_text = travel_blog_data$gpt3[1]
my_embeddings = gpt3_embeddings(input_var = my_text)
length(my_embeddings)
# 1024 (since the default model uses the 1024-dimensional Ada embeddings model)

```


**Example 2: get embeddings from text data in a data.frame / data.table**

Now we can do the same example with the full `travel_blog_data` dataset:


```{r}
multiple_embeddings = gpt3_embeddings(input_var = travel_blog_data$gpt3
                                      , id_var = travel_blog_data$n)
dim(multiple_embeddings)

# [1]    10 1025 # because we have ten rows of 1025 columns each (by default 1024 embeddings elements and 1 id variable)
```



## Cautionary note

**Read this:** using GPT-3 is not free, so any interaction with the GPT-3 model(s) is counted towards you token quota. You can find details about Open AI's pricing model at [https://openai.com/api/pricing/](https://openai.com/api/pricing/).

You receive a reasonable credit for free and do not need to provide any payment information for the first interactions with the model. Once you token quota nears its end, Open AI will let you know. Your usage is tracable in your Open AI account dashboard.


## Support and contributions

If you have questions or problems, please raise an issue on GitHub.

You are free to make contributions to the package via pull requests. If you do so, you agree that your contributions will be licensed under the [GNU General Public License v3.0](https://github.com/ben-aaron188/rgpt3/blob/main/LICENSE.md).


## Citation

(tbd)
