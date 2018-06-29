all: deploydata createdocs deploydocs

.PHONY: all deploydata deploysas createdocs deploydocs

deploydata:
	rsync -avh --chmod=0444 extracts/epi_cpsbasic*.dta.zip maynard:/data/cps/basic/epiextracts/
	rsync -avh --chmod=0444 extracts/epi_cpsorg*.dta.zip maynard:/data/cps/org/epiextracts/
	rsync -avh --chmod=0444 extracts/epi_cpsmay*.dta.zip maynard:/data/cps/may/epiextracts/

deploysas:
	Rscript code/dtaextracts_to_sas7bdat.R

createdocs:
	cd docs && $(MAKE) clean html

deploydocs:
	rsync -rvh docs/_build/html/ maynard:/var/www/html/epiextracts_docs/ --delete
