all: deploydata createdocs deploywebdocs deploywebcode

.PHONY: all deploydata createdocs deploywebdocs deploywebcode deploywebdata convertsas deploysas deployado

deploydata:
	rsync -avh --chmod=0444 extracts/epi_cpsbasic*.dta.zip maynard:/data/cps/basic/epi/
	rsync -avh --chmod=0444 extracts/epi_cpsorg*.dta.zip maynard:/data/cps/org/epi/
	rsync -avh --chmod=0444 extracts/epi_cpsmay*.dta.zip maynard:/data/cps/may/epi/

createdocs:
	cd docs && $(MAKE) clean html

deploywebdocs:
	aws s3 sync docs/_build/html/ s3://microdata.epi.org/ --delete

deploywebcode:
	cp code/ado/append_extracts.ado packages/stata/
	cp code/ado/append_extracts.sthlp packages/stata/
	cp code/ado/append_extracts.pkg packages/stata/
	cp code/ado/stata.toc packages/stata/
	aws s3 sync packages/stata/ s3://microdata.epi.org/stata --exclude ".gitignore*" --delete

deploywebdata:
	zip -j epi_cpsorg_1979_2018.zip extracts/epi_cpsorg_*.dta.zip
	zip -j epi_cpsbasic_2000_2018.zip extracts/epi_cpsbasic_20*.dta.zip
	zip -j epi_cpsbasic_1976_1999.zip extracts/epi_cpsbasic_19*.dta.zip
	zip -j epi_cpsmay_1973_1981.zip extracts/epi_cpsmay_*.dta.zip
	aws s3 sync . s3://microdata.epi.org/ --exclude "*" --include "epi_cps*.zip"
	rm epi_cps*.zip

convertsas:
	Rscript code/dtaextracts_to_sas7bdat.R

deploysas:
	rsync -avPzh /data/cps/basic/epi/sas/epi_cpsbasic_*.sas7bdat.zip /home/bzipperer/mount/epiextracts/cps/basic/
	rsync -avPzh /data/cps/org/epi/sas/epi_cpsorg_*.sas7bdat.zip /home/bzipperer/mount/epiextracts/cps/org/
	rsync -avPzh /data/cps/may/epi/sas/epi_cpsmay_*.sas7bdat.zip /home/bzipperer/mount/epiextracts/cps/may/

deployado:
	cp code/ado/append_rawdata.ado /usr/local/ado/
	cp code/ado/append_rawdata.sthlp /usr/local/ado/
	cp code/ado/append_extracts.ado /usr/local/ado/
	cp code/ado/append_extracts.sthlp /usr/local/ado/
	cp code/ado/merge_rawextracts.ado /usr/local/ado/
	cp code/ado/merge_rawextracts.sthlp /usr/local/ado/
	cp code/ado/keepifexist.ado /usr/local/ado/
	cp code/ado/keepifexist.sthlp /usr/local/ado/
