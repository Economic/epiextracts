rm(list = ls())

library(tidyverse)
library(haven)
library(foreach)
library(iterators)
library(data.table)
library(doMC)

# Set number of cores to use
registerDoMC(cores=8)

# multicore options
mcoptions <- list(preschedule=FALSE)

filelist <- Sys.glob("epiextracts_basicorg/extracts/*.zip") %>% 
  basename() %>% 
  sub("^([^.]*).*", "\\1", .)

origpath <- file.path("epiextracts_basicorg/extracts")

mygrid <- expand.grid(filename=filelist,n=1)

myfunction <- function(x) {
  filename <- x$filename

  origfilename <- paste0(filename,".dta.zip")
  dtafilename <- paste0(filename,".dta")
  sasfilename <- paste0(filename,".sas7bdat")
  finalfilename <- paste0(sasfilename,".zip")
  rawdest <- file.path(origpath,origfilename)
  
  system(paste("echo","Processing",rawdest))
  
  system(paste("pigz -dc",rawdest,">",dtafilename))
  write_sas(read_dta(dtafilename,encoding="latin1"),sasfilename)
  system(paste("pigz -Kf",sasfilename))
  file.remove(dtafilename)
}

foreach(i=iter(mygrid, by="row"), .options.multicore=mcoptions) %dopar% myfunction(i)

# add lines here to move sas7bdat files to appropriate org and basic directories
# where perhaps arguments to R script (from makefile) are the final destination directories
# should really be using temp files or temp directories for all of this
system("mv epi_cpsbasic_*.sas7bdat.zip /data/cps/basic/epiextracts/")
system("chmod 0444 /data/cps/basic/epiextracts/*.sas7bdat.zip")
system("mv epi_cpsorg_*.sas7bdat.zip /data/cps/org/epiextracts/")
system("chmod 0444 /data/cps/org/epiextracts/*.sas7bdat.zip")


