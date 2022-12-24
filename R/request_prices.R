#' Contains the pricing for completion requests (see: [https://openai.com/api/pricing/#faq-completions-pricing](https://openai.com/api/pricing/#faq-completions-pricing))
#'
#' @description
#' These are the prices listed for 1k tokens of requests for the various models. These are needed for the `rgpt3_cost_estimate(...)` function.
#' @export
price_base_davinci = 0.02
price_base_curie = 0.002
price_base_babbage = 0.0005
price_base_ada = 0.0004
