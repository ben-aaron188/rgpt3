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


**Interact with GPT-3 via requests:**

The basic form of the GPT-3 API connector is via requests. These requests can be of various kinds including questions ("What is the meaning of life?"), text summarisation tasks, text generation tasks and many more. A whole list of examples is on the [Open AI examples page](https://beta.openai.com/examples).

Think of requests as instructions you give the model, for example:

```{r}
# This request "tells" GPT-3 to write a cynical text about human nature (five times) with a sampling temperature of 0.9, a maximium length of 100 tokens.
test_output = gpt3_single_request(prompt_input = 'Write a cynical text about human nature:'
                    , temperature = 0.9
                    , max_tokens = 100
                    , n = 5)
```

The returned list contains the actual instruction + output in `test_output[[1]]` and meta information about your request in `test_output[[2]]`.




## Core functions


## Examples




## Cautionary note



## Contributing


## Support


## Citation


