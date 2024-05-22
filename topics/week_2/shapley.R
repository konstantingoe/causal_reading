# Outlier Shapley Value (Janzig) - https://arxiv.org/abs/1912.02724

IT <- function(x, X, i, parents = NULL) {
  # we ignore removing the i-th observation
  abs(x[i] - mean(X[, i])) / sd(X[, i])
}


cond_IT <- function(x, X, i, parents) {
  if (is.null(parents[[i]])) {return(IT(x, X, i, parents))}
  model <- lm(X[, i] ~ X[, parents[[i]]])
  abs(x[i] - mean(model[["fitted.values"]])) / sd(model[["residuals"]])
}


convolution <- function(score, x, X, parents) {
  s <- sapply(1:length(x), function(i) score(x, X, i, parents))
  s[which(is.nan(s))] <- 0
  s[s > 1000] <- 0 # solve 1 / (near0) problems
  s_sum <- 1
  for (j in 1:(length(s)-1)) {
    s_sum <- s_sum + sum(s)**i / factorial(i)
  }
  sum(s) - log(s_sum)
}


contribution <- function(x, noise, k, U, score, n_MC, parents) {
  cond_prob <- function(x, noise, cond, score, n_MC = 1000) {
    if (counter > 0) {
    logical_lookup <- sapply(lookup_names, function(x) setequal(x, cond))
    if (sum(logical_lookup) == 1) {
      return(lookup_values[[which(logical_lookup)]])
    }}
    if (length(cond) == 0) { 
      X_n <- gen_data(n_MC, NULL, NULL)
    } else {
      X_n <- gen_data(n_MC, cond, noise[cond])
    }
    reference_score <- convolution(score, x, X_n, parents)
    generated_score <- sapply(1:n_MC, function(i) convolution(score, X_n[i, ], X_n, parents))
    c_prob <- sum(generated_score >= reference_score) / length(generated_score)
    lookup_values[[counter + 1]] <<- c_prob
    lookup_names[[counter + 1]] <<- cond
    counter <<- counter + 1
    return(c_prob)
  }
  log(cond_prob(x, noise, c(k, U), score, n_MC)) - 
    log(cond_prob(x, noise, c(U), score, n_MC))
}


shapley <- function(x, noise, score, n_MC, parents) {
  shap_i <- function(x, noise, i, score, n_MC, parents) {
    l <- length(x)
    value <- contribution(x, noise, i, NULL, score, n_MC, parents) / l
    for (j in 1:(l - 1)) {
      sets <- combn((1:l)[-i], j)
      for (jj in 1:ncol(sets)) {
        value <- contribution(x, noise, i, sets[, jj], score, n_MC, parents) / l / choose(l - 1, j)
      }
    }
    value
  }
  sapply(1:length(x), function(i) shap_i(x, noise, i, score, n_MC, parents))
}


gen_data <- function(n, cond, noise) {
  epsilon <- mvtnorm::rmvnorm(n, mean = rep(0, 4), sigma = diag(c(1,2,2,3)))
  if (!is.null(cond)) {
    epsilon[, cond] <- matrix(rep(noise, n), nrow = n, byrow = T)
  }
  X1 <- epsilon[, 1]
  X2 <- 1.5 * X1 + epsilon[, 2]
  X3 <- -0.5 * X1 + epsilon[, 3]
  X4 <- X2 + 2 * X3 + epsilon[, 4]
  cbind(X1, X2, X3, X4)
}


parents <- list(c(), c(1), c(1), c(2,3))


set.seed(1234)
outlier <- c(1, 1.5, -1, -3)
noise <- c(outlier[1], 
           outlier[2] - 1.5 * outlier[1], 
           outlier[3] + 0.5 * outlier[1], 
           outlier[4] - outlier[2] - 2 * outlier[3] )

lookup_names <- list(); lookup_values <- list(); counter <- 0
shapley(outlier, noise, IT, 100, parents)

lookup_names <- list(); lookup_values <- list(); counter <- 0
shapley(outlier, noise, cond_IT, 100, parents)


#######################################################################
# TODO:
# * IT/cond_IT: The i-th observation is used in the computation for the
#     mean and standard deviation
# * cond_prob: New datasets are created for every shapley contribution.
#     If, however, only a single dataset is available, manipulate this 
#     dataset to satisfy the conditional probability constraint. This 
#     is also the reason why the shapley value does not add up to the 
#     convolution score.
#######################################################################
