##################################################################
# Power analysis for occupancy studies under imperfect detection
# Functions
# Authors Gurutzeta Guillera-Arroita & Jose J. Lahoz-Monfort
##################################################################

## Simulate a detection/non-detection history
simhist <- function(S,K,psi,p){
  h <- matrix(NA,S,K)
  z <- rbinom(S,1,psi)
  for (ii in 1:S){
    h[ii,] <- rbinom(K,1,p*z[ii])
  }
  return(h)
}

## Log-likelihood function for the occupancy model
loglik <- function(param, h){
  s <- dim(h)[1] # nr sites
  k <- dim(h)[2] # nr sampling occasions
  psi <- 1/(1+exp(-param[1]))  # to probabilities
  p <- 1/(1+exp(-param[2]))
  d <- sum(sum(h)) # summary statistics
  Sd <- sum(rowSums(h)>0)
  loglik <- -(Sd*log(psi)+d*log(p)+(k*Sd-d)*log(1-p)+(s-Sd)*log((1-psi)+psi*(1-p)^k))
  return(loglik)
}

## Analyze two datasets with different psi and different p  
fitmA <-function(h1,h2){
  fm1 <- optim(par=runif(2), fn=loglik, h=h1, hessian=T)
  fm2 <- optim(par=runif(2), fn=loglik, h=h2, hessian=T)
  VC1 <- try(solve(fm1$hessian),silent = TRUE)
  VC2 <- try(solve(fm2$hessian),silent = TRUE)  
  pars <- 1/(1+exp(-c(fm1$par,fm2$par)))    # to probabilities
  if ((class(VC1)=="try-error")||(class(VC2)=="try-error")){
    SEs <- rep(NA,4)
  }else{
    SEs <- c(sqrt(diag(VC1))*pars[1:2]*(1-pars[1:2]),sqrt(diag(VC2))*pars[3:4]*(1-pars[3:4]))
  }
  psi1 <- list(est = pars[1], se = SEs[1]) # arrange output
  p1 <- list(est = pars[2], se = SEs[2])
  psi2 <- list(est = pars[3], se = SEs[3])
  p2 <- list(est = pars[4], se = SEs[4])
  myres <- list(psi1 = psi1, p1 = p1, psi2 = psi2, p2 = p2,L = fm1$value + fm2$value)	
  return(myres)
}

## Run one simulation and do Wald test on probability scale
run1PAsim <- function(S1,S2,K1,K2,p1,p2,psi1,R,alpha){
  # simulate detection histories
  h1<-simhist(S=S1,K=K1,psi=psi1,p=p1)
  h2<-simhist(S=S2,K=K2,psi=psi1*(1-R),p=p2)
  # fit model
  fmA <-fitmA(h1,h2)
  # test for significance	
  Wald <- abs(fmA$psi1$est - fmA$psi2$est )/sqrt(fmA$psi1$se^2 + fmA$psi2$se^2)>qnorm(1-alpha/2)
  return(Wald)
}

## Run power analysis simulations 
runPowerSims <- function(S1,S2,K1,K2,p1,p2,psi1,R,alpha,nsims){
  powcnt <- 0
  okcnt <- 0
  t1 <- proc.time()
  for (ii in 1:nsims){
    cat('\r',ii); flush.console()
    res <- run1PAsim(S1=S1,S2=S2,K1=K1,K2=K2,p1=p1,p2=p2,psi1=psi1,R=R,alpha=alpha)
    if (is.finite(res)){
	    powcnt <- powcnt + res
	    okcnt <- okcnt + 1
    }
  }
  power <- powcnt/okcnt
  tdiff <- proc.time()-t1
  cat("\r","power (Wald test) = ", power[1],"\n")
  if (okcnt!=nsims){ 
	cat(nsims-okcnt, "simulations discarded (due to failed VC calculation)","\n")
  }  
  cat("elapsed time = ", tdiff[3] , " seconds\n\n\n") 
  return(c(power,okcnt))
}

## Calculate the power of a design using the formula in ms
calcPowerFormula <- function(S1,S2,K1,K2,p1,p2,psi1,R,alpha){
  psi2 <- psi1*(1-R)
  pp1 <- 1-(1-p1)^K1
  pp2 <- 1-(1-p2)^K2
  F1 <- (1-pp1)/(pp1-K1*p1*(1-p1)^(K1-1))
  F2 <- (1-pp2)/(pp2-K2*p2*(1-p2)^(K2-1))
  var1 <- psi1*(1-psi1+F1)/S1
  var2 <- psi2*(1-psi2+F2)/S2
  limL <- (+qnorm(1-alpha/2)*(sqrt(var1+var2))-(psi1-psi2))/sqrt(var1+var2)
  limU <- (-qnorm(1-alpha/2)*(sqrt(var1+var2))-(psi1-psi2))/sqrt(var1+var2)
  G <- 1 - pnorm(limL) + pnorm(limU)
  return(G)
}

## Determine the required sample size using the formula in ms
calcSFormula <- function(K1,K2,p1,p2,psi1,R,alpha,pow){
  psi2 <- psi1*(1-R)
  pp1 <- 1-(1-p1)^K1
  pp2 <- 1-(1-p2)^K2
  F1 <- (1-pp1)/(pp1-K1*p1*(1-p1)^(K1-1))
  F2 <- (1-pp2)/(pp2-K2*p2*(1-p2)^(K2-1))
  f1 <- psi1*(1-psi1+F1)
  f2 <- psi2*(1-psi2+F2)
  S <- (f1+f2)*((qnorm(1-alpha/2)+qnorm(pow))/(psi1-psi2))^2
  return(ceiling(S))
}


