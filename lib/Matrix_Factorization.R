#Define a function to calculate RMSE
RMSE <- function(rating, est_rating){
  sqr_err <- function(obs){
    sqr_error <- (obs[3] - est_rating[as.character(obs[2]), as.character(obs[1])])^2
    return(sqr_error)
  }
  return(sqrt(mean(apply(rating, 1, sqr_err))))  
}

#Stochastic Gradient Descent
# a function returns a list containing factorized matrices p and q, training and testing RMSEs.
gradesc <- function(f = 10, 
                    lambda = 0.3,lrate = 0.01, max.iter, stopping.deriv = 0.01,
                    data, train, test){
  set.seed(0)
  #random assign value to matrix p and q
  p <- matrix(runif(f*U, -1, 1), ncol = U) 
  colnames(p) <- as.character(1:U)
  q <- matrix(runif(f*I, -1, 1), ncol = I)
  colnames(q) <- levels(as.factor(data$movieId))
  
  train_RMSE <- c()
  test_RMSE <- c()
  
  for(l in 1:max.iter){
    sample_idx <- sample(1:nrow(train), nrow(train))
    #loop through each training case and perform update
    for (s in sample_idx){
      
      u <- as.character(train[s,1])
      
      i <- as.character(train[s,2])
      
      r_ui <- train[s,3]
      
      e_ui <- r_ui - t(q[,i]) %*% p[,u]
      
      grad_q <- e_ui %*% p[,u] - lambda * q[,i]
      
      if (all(abs(grad_q) > stopping.deriv, na.rm = T)){
        q[,i] <- q[,i] + lrate * grad_q
      }
      grad_p <- e_ui %*% q[,i] - lambda * p[,u]
      
      if (all(abs(grad_p) > stopping.deriv, na.rm = T)){
        p[,u] <- p[,u] + lrate * grad_p
      }
    }
    #print the values of training and testing RMSE
    if (l %% 10 == 0){
      cat("epoch:", l, "\t")
      est_rating <- t(q) %*% p
      rownames(est_rating) <- levels(as.factor(data$movieId))
      
      train_RMSE_cur <- RMSE(train, est_rating)
      cat("training RMSE:", train_RMSE_cur, "\t")
      train_RMSE <- c(train_RMSE, train_RMSE_cur)
      
      test_RMSE_cur <- RMSE(test, est_rating)
      cat("test RMSE:",test_RMSE_cur, "\n")
      test_RMSE <- c(test_RMSE, test_RMSE_cur)
    } 
  }
  
  return(list(p = p, q = q, train_RMSE = train_RMSE, test_RMSE = test_RMSE))
}

als <- function(f = 10, lambda = 0.3, max.iter = 100, stopping.thres = 0.001, data, train, test) {
  set.seed(0)
  #random assign value to matrix p and q, then initialize q with average ratings in the first row
  p <- matrix(runif(f*U, -1, 1), ncol = U) 
  colnames(p) <- as.character(1:U)
  q <- matrix(runif(f*I, -1, 1), ncol = I)
  colnames(q) <- levels(as.factor(aggregate(data$rating, list(data$movieId), mean)[, 1]))
  q[1, ] <- t(aggregate(data$rating, list(data$movieId), mean)[2])
  
  users_in_train <- levels(as.factor(train$userId))
  users_not_in_train <- colnames(p)[!colnames(p) %in% users_in_train]
  movies_in_train <- levels(as.factor(train$movieId))
  movies_not_in_train <- colnames(q)[!colnames(q) %in% movies_in_train]
  
  train_RMSE <- rep(NA, 100)
  test_RMSE <- rep(NA, 100)
  
  stop <- FALSE
  l <- 1
  
  while((stop==FALSE) & (l < max.iter)) {
    
    #loop through each column of p, minimizing the objective function given q
    for (i in users_in_train){
      
      Ii <- as.character(train[as.character(train$userId)==i, 'movieId'])
      nui <- length(Ii)
      qIi <- q[, Ii, drop=FALSE]
      Ai <- qIi %*% t(qIi) + lambda * nui * diag(f)
      Ri <- train[as.character(train$userId)==i, 'rating']
      Vi <- qIi %*% Ri
      
      p[, i] <- solve(Ai) %*% Vi
      
    }
    
    #For users not in the training set, take the average of users in the training set
    p[, users_not_in_train] <- rowMeans(p[, users_in_train])
    
    #loop through each column of q, minimizing the objective function given p
    for (j in movies_in_train){
      
      Ij <- as.character(train[as.character(train$movieId)==j, 'userId'])
      nmj <- length(Ij)
      pIj <- p[, Ij, drop=FALSE]
      Aj <- pIj %*% t(pIj) + lambda * nmj * diag(f)
      Rj <- train[as.character(train$movieId)==j, 'rating']
      Vj <- pIj %*% Rj
      
      q[, j] <- solve(Aj) %*% Vj
      
    }
    
    #For movies not in the training set, take the average of movies in the training set
    q[, movies_not_in_train] <- rowMeans(q[, movies_in_train])
    
    #print the values of training and testing RMSE
    cat("epoch:", l, "\t")
    est_rating <- t(q) %*% p
    
    #Stop if RMSE changed by less than the threshold
    train_RMSE_cur <- RMSE(train, est_rating)
    cat("training RMSE:", train_RMSE_cur, "\t")
    if (l > 1) {
      if (abs(train_RMSE_cur - train_RMSE[l-1]) < stopping.thres) {
        stop <- TRUE
      }
    }
    train_RMSE[l] <- train_RMSE_cur
    
    test_RMSE_cur <- RMSE(test, est_rating)
    cat("test RMSE:",test_RMSE_cur, "\n")
    test_RMSE[l] <- test_RMSE_cur
    
    l <- l + 1
  }
  
  return(list(p = p, q = q, train_RMSE = train_RMSE, test_RMSE = test_RMSE))
}
