all: deploydata createdocs deploydocs

.PHONY: all deploydata createdocs deploydocs deploysas deployado

deploydata:
	rsync -avh --chmod=0444 extracts/epi_cpsbasic*.dta.zip maynard:/data/cps/basic/epiextracts/
	rsync -avh --chmod=0444 extracts/epi_cpsorg*.dta.zip maynard:/data/cps/org/epiextracts/
	rsync -avh --chmod=0444 extracts/epi_cpsmay*.dta.zip maynard:/data/cps/may/epiextracts/

createdocs:
	cd docs && $(MAKE) clean html

deploydocs:
	rsync -rvh docs/_build/html/ maynard:/var/www/html/epiextracts_docs/ --delete

deploysas:
	Rscript code/dtaextracts_to_sas7bdat.R

deployado:
	cp code/ado/append_rawdata.ado /usr/local/ado/
	cp code/ado/append_extracts.ado /usr/local/ado/
	cp code/ado/merge_rawextracts.ado /usr/local/ado/
	cp code/ado/keepifexist.ado /usr/local/ado/
