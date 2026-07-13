
library(foreach)

Nsims<-20
ToP<-10^7
b<-Sys.time()

z<-rep(0.5,Nsims)
for(i in 1:Nsims) {
x <- runif(ToP , 0 , 1)
z[i] <- mean(x)
}
print(Sys.time() - b)


library(foreach)
library(doMC)
registerDoMC()
b<-Sys.time()

z<-rep(0.5,Nsims)
foreach(i=1:Nsims) %dopar% {
x <- runif(ToP , 0 , 1)
z[i] <- mean(x)
}
print(Sys.time() - b)
