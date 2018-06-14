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

filelistorg <- Sys.glob("extracts/epi_cpsorg_*.dta.zip") %>%
  basename() %>%
  sub("^([^.]*).*", "\\1", .) %>%
  expand.grid(filename=.) %>%
  mutate(id="org")

filelistbasic <- Sys.glob("extracts/epi_cpsbasic_*.dta.zip") %>%
  basename() %>%
  sub("^([^.]*).*", "\\1", .) %>%
  expand.grid(filename=.) %>%
  mutate(id="basic")

filelist <- bind_rows(filelistorg,filelistbasic)

origpath <- file.path("extracts")

myfunction <- function(x) {
  filename <- x$filename
  datasource <- x$id

  origfilename <- paste0(filename,".dta.zip")
  dtafilename <- paste0(filename,".dta")
  sasfilename <- paste0(filename,".sas7bdat")
  finalfilename <- paste0(sasfilename,".zip")
  rawdest <- file.path(origpath,origfilename)
  finaldest <- file.path("/data/cps",datasource,"epiextracts",finalfilename)

  #system(paste("pigz -dc",rawdest,">",dtafilename))
  system(paste("unzip",rawdest))
  write_sas(read_dta(dtafilename,encoding="latin1"),sasfilename)
	system(paste("chmod 0444",sasfilename))
  system(paste("pigz -Kf",sasfilename))
	system(paste("chmod 0444",finalfilename))
  system(paste("mv -f",finalfilename,finaldest))
  file.remove(dtafilename)
}

foreach(i=iter(filelist, by="row"), .options.multicore=mcoptions) %dopar% myfunction(i)
