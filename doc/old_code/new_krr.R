##################################################################################
### copy the following code right below main code after global bias correction ###
##################################################################################

#### Step 3.3 P3 Postprocessing SVD with kernel ridge regression

```{r}
# frequent movie
library(tidyverse)
topnum=500
top=data%>%
  mutate(movieId=as.character(movieId))%>%
  count(movieId)%>%
  arrange(desc(n))%>%
  head(topnum)%>%
  select(movieId)%>%
  pull(movieId)
top

## # of movies rated by each user in train dataset

num_of_rated=data_train%>%
  count(userId)%>%
  pull(n)


select_movie=function(i){
  if (num_of_rated[i]<topnum) {
    movie=data_train%>%
      filter(userId==i)%>%
      pull(movieId)
    movie_in_top=movie[movie %in% top]
    addition=top[!top %in% movie_in_top][1:(topnum-length(movie))]
    
    sel_list=c(movie,addition)
  }
  else
  {
    movie=data_train%>%
      filter(userId==i)%>%
      pull(movieId)
    sel_list=movie[1:topnum]
  }
  return(as.character(sel_list))
}


```



```{r}
krr.start=proc.time()

X=scale(result$q,center=F)
X=t(X)
lambda=1 #tuning parameter
user=as.character(1:U)
KRR_pred=matrix(0,length(unique(data$movieId)),length(user))
#str(KRR_pred) # 9724* 610

for (i in 1:length(user)){
  topmovie=select_movie(i)
  y=pred_rating[top,user[i]] # y--topnum*1 user i's rating for top topnum movie
  # X-- factors for top topnum movies topnum*10
  Xtop=X[topmovie,]
  K=exp(2*(Xtop%*%t(Xtop)-1)) # topnum*topnum
  left=exp(2*(X%*%t(Xtop)-1))
  b=solve(K+lambda*diag(nrow(K)))
  a=b%*%y #topnum*1
  # str(beta)
  # str(t(Xtop))
  KRR_pred[,i]=left%*%a
  
}

rownames(KRR_pred)=levels(as.factor(data$movieId))
colnames(KRR_pred)=as.character(1:U)
KRR_test <- apply(data_test, 1, extract_pred_rating, KRR_pred)
data_test$KRR <- KRR_test

rmse_KRR <- sqrt(mean((data_test$rating - data_test$KRR)^2))
rmse_KRR

krr.stop=proc.time()
timeused=krr.stop-krr.start
timeused
```