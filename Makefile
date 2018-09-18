all: deploydata createdocs deploywebdocs

LATEST=2018m7

.PHONY: all deploydata createdocs deploydocs convertsas deploysas

deploydata:
	rsync -avh --chmod=0444 extracts/epi_cpsbasic*.dta.zip maynard:/data/cps/basic/epiextracts/
	rsync -avh --chmod=0444 extracts/epi_cpsorg*.dta.zip maynard:/data/cps/org/epiextracts/
	rsync -avh --chmod=0444 extracts/epi_cpsmay*.dta.zip maynard:/data/cps/may/epiextracts/

createdocs:
	cd docs && $(MAKE) clean html

deploywebdocs:
	rsync -rvh docs/_build/html/ maynard:/var/www/html/epiextracts_docs/ --delete

deploywebdata:
	zip -j epi_cpsorg_1979_$(LATEST).zip extracts/epi_cpsorg_*.dta.zip
	zip -j epi_cpsbasic_2000_$(LATEST).zip extracts/epi_cpsbasic_20*.dta.zip
	zip -j epi_cpsbasic_1976_1999.zip extracts/epi_cpsbasic_19*.dta.zip
	zip -j epi_cpsmay_1973_1981.zip extracts/epi_cpsmay_*.dta.zip
	rsync -rvh epi_cps*.zip maynard:/var/www/html/epiextracts_docs/
	rm epi_cps*.zip

convertsas:
	Rscript code/dtaextracts_to_sas7bdat.R

deploysas:
	rsync -avPzh /data/cps/basic/epiextracts/sas/epi_cpsbasic_*.sas7bdat.zip /home/bzipperer/mount/epiextracts/cps/basic/
	rsync -avPzh /data/cps/org/epiextracts/sas/epi_cpsorg_*.sas7bdat.zip /home/bzipperer/mount/epiextracts/cps/org/
	rsync -avPzh /data/cps/may/epiextracts/sas/epi_cpsmay_*.sas7bdat.zip /home/bzipperer/mount/epiextracts/cps/may/

deployado:
	cp code/ado/append_rawdata.ado /usr/local/ado/
	cp code/ado/append_rawdata.sthlp /usr/local/ado/
	cp code/ado/append_extracts.ado /usr/local/ado/
	cp code/ado/append_extracts.sthlp /usr/local/ado/
	cp code/ado/merge_rawextracts.ado /usr/local/ado/
	cp code/ado/merge_rawextracts.sthlp /usr/local/ado/
	cp code/ado/keepifexist.ado /usr/local/ado/
	cp code/ado/keepifexist.sthlp /usr/local/ado/
