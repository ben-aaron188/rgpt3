#' Convert character vector of numeric values into a numeric vector
#'
#' @description
#' Converts a character vector of numeric values into a numeric vector
#' @param x a character vector of numeric values
#'
#' @return A numeric vector
#' @examples
#' to_numeric('12312')
#' @export
to_numeric = function(x){
  proxy = as.numeric(as.character(x))
  return(proxy)
}
