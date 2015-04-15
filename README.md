# Occupancy Model Power Analysis

Occupancy power analysis code from [Guillera-Arroita and Lahoz-Monfort, Methods in Ecology and Evolution, 2012](http://onlinelibrary.wiley.com/doi/10.1111/j.2041-210X.2012.00225.x/abstract). 

##  Instructions
To see an example analysis go into the Code folder of this repository and copy and paste the [Example_Analysis.R](https://raw.githubusercontent.com/Huh/Occ_Power/master/Code/Example_Analysis.R) script into your favorite text editor.  

The [Example_Analysis.R](https://raw.githubusercontent.com/Huh/Occ_Power/master/Code/Example_Analysis.R) script is designed to serve as a template for your to create your own scripts and analyses.  Functionally the script does very little beyond the original code except that it sources the required functions from the internet to ease implementation on different machines.  As I mentioned the functions required to run the analysis live on GitHub, so we download these functions using the `source_url` function from the devtools package.  The code looks like this:

````R
require(devtools)
source_url("https://raw.githubusercontent.com/Huh/Occ_Power/master/Code/PAfuncts.R")
````

I would suggest trying the [Example_Analysis.R](https://raw.githubusercontent.com/Huh/Occ_Power/master/Code/Example_Analysis.R) script first so you can get a feel for how it works and then you can design your own study.

Enjoy!
