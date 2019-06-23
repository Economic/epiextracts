all: deploydata createdocs deploywebdocs deploywebcode

.PHONY: all deploydata createdocs deploywebdocs deploywebcode deploywebdata convertsas deploywindata deployado

deploydata:
	rsync -avh --chmod=0444 extracts/epi_cpsbasic*.dta.zip /data/cps/basic/epi/
	rsync -avh --chmod=0444 extracts/epi_cpsmarch*.dta.zip /data/cps/march/epi/
	rsync -avh --chmod=0444 extracts/epi_cpsmay*.dta.zip /data/cps/may/epi/
	rsync -avh --chmod=0444 extracts/epi_cpsorg*.dta.zip /data/cps/org/epi/

createdocs:
	cd docs && $(MAKE) clean html

deploywebdocs:
	aws s3 sync docs/_build/html/ s3://microdata.epi.org/

deploywebcode:
	cp code/ado/keepifexist.ado packages/stata
	cp code/ado/keepifexist.sthlp packages/stata
	cp code/ado/load_epiextracts.ado packages/stata/
	cp code/ado/load_epiextracts.sthlp packages/stata/
	cp code/ado/load_epiextracts.pkg packages/stata/
	cp code/ado/stata.toc packages/stata/
	aws s3 sync packages/stata/ s3://microdata.epi.org/stata --exclude ".gitignore*" --delete

deploywebdata:
	zip -j epi_cpsbasic_1976_1999.zip extracts/epi_cpsbasic_19*.dta.zip
	zip -j epi_cpsbasic_2000_2019.zip extracts/epi_cpsbasic_20*.dta.zip
	zip -j epi_cpsmarch_1962_2018.zip extracts/epi_cpsmarch_*.dta.zip
	zip -j epi_cpsmay_1973_1981.zip extracts/epi_cpsmay_*.dta.zip
	zip -j epi_cpsorg_1979_2019.zip extracts/epi_cpsorg_*.dta.zip
	aws s3 sync . s3://microdata.epi.org/ --exclude "*" --include "epi_cps*.zip" --delete
	rm epi_cps*.zip

convertsas:
	Rscript code/dtaextracts_to_sas7bdat.R

deploywindata:
	rsync -avPh /data/cps/basic/epi/epi_cpsbasic_*.dta.zip ~/mount/data/cps/basic/epi/
	rsync -avPh /data/cps/march/epi/epi_cpsmarch_*.dta.zip ~/mount/data/cps/march/epi/
	rsync -avPh /data/cps/may/epi/epi_cpsmay_*.dta.zip ~/mount/data/cps/may/epi/
	rsync -avPh /data/cps/org/epi/epi_cpsorg_*.dta.zip ~/mount/data/cps/org/epi/

deployado:
	cp code/ado/append_rawdata.ado /usr/local/ado/
	cp code/ado/append_rawdata.sthlp /usr/local/ado/
	cp code/ado/load_epiextracts.ado /usr/local/ado/
	cp code/ado/load_epiextracts.sthlp /usr/local/ado/
	cp code/ado/merge_rawextracts.ado /usr/local/ado/
	cp code/ado/merge_rawextracts.sthlp /usr/local/ado/
	cp code/ado/keepifexist.ado /usr/local/ado/
	cp code/ado/keepifexist.sthlp /usr/local/ado/
