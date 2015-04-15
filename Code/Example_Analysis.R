		#  Script to run occupancy model power analyses.
		#  04/2015
		#  Josh Nowak
#################################################################################
		#  Load packages
		#  Install if needed
		if(!"devtools" %in% rownames(installed.packages())){
			install.packages("devtools")
		}
		require(devtools)
#################################################################################
		#  Source functions to run simulation
		source_url("https://raw.githubusercontent.com/Huh/Occ_Power/master/Code/PAfuncts.R")
#################################################################################
		#  Now you can run analyses, if designing a custom script to track your 
		#  workflow delete everything below this point and using the examples
		#  as a template construct your own script.
		
		#  Example A: use function 'calcPowerFormula' to calculate the 
		#  power of a design using the formula (as in Figure 1)
		#  Change these parameters to meet your needs, most of these params are
		#  used by all functions
		
		S <- 50		# number of sites
		K <- 3		# number of replicates
		R <- 0.5	# proportional change in occupancy
		psi1 <- 0.3       # initial occupancy probability
		p <- 0.6		# detection probability
		alpha <-0.05	# significance level

#################################################################################
		#  Actual work done here for Example A.  The parentheses print the result
		#  to the R gui...i.e. your screen
		(powerF <- calcPowerFormula(S1 = S,
									S2 = S,
									K1 = K,
									K2 = K,
									p1 = p,
									p2 = p,
									psi1,
									R,
									alpha))
									
#################################################################################
		#  Example B: use function 'calcSFormula' to calculate the 
		#  number of sites needed to achieve a given power (thick lines Figure 3)
		#  Change pow to meet your needs
		pow <- 0.8		# target power level
		
		#  Work done here
		(SS <- calcSFormula(K1 = K,
							K2 = K,
							p1 = p,
							p2 = p,
							psi1,
							R,
							alpha,
							pow))
							
#################################################################################
		# Example C: use function runPowerSims to assess the actual power 
		# using simulations (Wald test on probability scale, red lines in Figure 3) 

		#  Change nsims to meet your needs
		nsims<-5000		# number of simulations to run
		
		#  Work done here
		powerR <- runPowerSims(S1 = SS,
								S2 = SS,
								K1 = K,
								K2 = K,
								p1 = p,
								p2 = p,
								psi1,
								R,
								alpha,
								nsims)
#################################################################################
		#  End 
		

		