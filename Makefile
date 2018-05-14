all: deploybasic deployorg deploydocs

.PHONY: all deploybasic deployorg deploydocs deploysas

deploybasic:
	rsync -avh --chmod=0444 extracts/epi_cpsbasic*.dta.zip maynard:/data/cps/basic/epiextracts/

deployorg:
	rsync -avh --chmod=0444 extracts/epi_cpsorg*.dta.zip maynard:/data/cps/org/epiextracts/

deploydocs:
	rsync -rvh docs/_build/html/ maynard:/var/www/html/epiextracts_docs/ --delete

deploysas:
	Rscript code/dtaextracts_to_sas7bdat.R
