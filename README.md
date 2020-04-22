# Project 4: Algorithm implementation and evaluation: Collaborative Filtering

### [Project Description](doc/project4_desc.md)

Term: Spring 2020

+ Team 9
+ Project title: Performance Analysis of KNN and KRR Based on ALS Model with Penalty of Magnitudes
+ Team members
	+ Liu, Jiawei | jl5560@columbia.edu
	+ Ni, Jiayun | jn2722@columbia.edu
	+ Petkun, Michael | mjp2262@columbia.edu
	+ Wolansky, Ivan | iaw2110@columbia.edu
	+ Yang, Wenjun | wy2347@columbia.edu

**Project summary**:  This project consists of building a collaborative filtering method for the recommendation system, using Alternating Least Squares algorithm (ALS). Penalty of Magnitudes is used for regularization and both K-Nearest Neighbors algorithm (KNN) and Kernel Ridge Regression algorithm (KRR) are used in post-processing.
Our goal is to see the difference between the two models:
+ ALS with penalty of magnitudes and post-processing with KNN
+ ALS with penalty of magnitudes and post-processing with KRR

Namely, to compare the performance of KNN and KRR based on ALS model with penalty of magnitudes.

**Conclusion**: Given matrix factorization based on Alternating Least Squares with Penalty of Magnitudes, the KNN model outperforms kernel ridge regression for post-processing (regardless of the choice of Gaussian vs. linear kernel). The KNN model has a test RMSE of 0.8980, while the Gaussian and linear kernel ridge regressions have test RMSE of 1.4146 and 0.9477, respectively.

The KNN model does take more computation time, however, including over 16 minutes for measuring similarities between movies and between 2-3 minutes for making predictions. The kernel ridge regression models, on the other hand, each take less than half a minute to train the model and make predictions.

Method | KNN | Linear Kernel | Guassian Kernel 
--- | --- | --- | --- 
RMSE | 0.898 | 0.9477 | 1.4146 
Total Time | 1116.56s | 12.27s | 13.14s


**Contribution statement**: All team members approve our work presented in this GitHub repository including this contributions statement.
+ Team members
	+ Liu, Jiawei:
	+ Ni, Jiayun: Responsible for the post-processing part of KNN method. Debugged and test the models. Prepare for the presentation for the project. Update the README file on github.
	+ Petkun, Michael: Made major contributions to the matrix factorization & regularization models, as well as the kernel ridge regression model. Combined the team's code into the Main.Rmd file.
	+ Wolansky, Ivan: Made some contribution to the matrix factorization & regularization models. Also, experimented with different methods of dealing with the cold-start problem. Additionally, helped prepare the presentation for the project, while making some edits to the README.
	+ Yang, Wenjun: Wrote the preliminary version of KNN and KRR, and update the README file on github.

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.
s
```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.

