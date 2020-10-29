all: createdocs deploywebdocs createfeather deploydata deploywebcode deploywebdata

.PHONY: all deploydata createdocs deploywebdocs deploywebcode deploywebdata deploywindata deployado

createfeather:
	Rscript extracts_to_feather.R

deploydata:
	rsync -avh --chmod=0444 extracts/epi_cpsbasic* /data/cps/basic/epi/
	rsync -avh --chmod=0444 extracts/epi_cpsmarch* /data/cps/march/epi/
	rsync -avh --chmod=0444 extracts/epi_cpsmay* /data/cps/may/epi/
	rsync -avh --chmod=0444 extracts/epi_cpsorg* /data/cps/org/epi/

createdocs:
	cd documentation && mkdocs build 

deploywebdocs:
	aws s3 sync documentation/site/ s3://microdata.epi.org/

deploywebcode:
	cp code/ado/keepifexist.ado packages/stata
	cp code/ado/keepifexist.sthlp packages/stata
	cp code/ado/load_epiextracts.ado packages/stata/
	cp code/ado/load_epiextracts.sthlp packages/stata/
	cp code/ado/load_epiextracts.pkg packages/stata/
	cp code/ado/stata.toc packages/stata/
	aws s3 sync packages/stata/ s3://microdata.epi.org/stata --exclude ".gitignore*" --delete

deploywebdata:
	cd extracts && zip epi_cpsbasic_1976_1999.zip epi_cpsbasic_19*.dta
	cd extracts && zip epi_cpsbasic_2000_2020.zip epi_cpsbasic_20*.dta
	cd extracts && zip epi_cpsmarch_1962_2018.zip epi_cpsmarch_*.dta
	cd extracts && zip epi_cpsmay_1973_1981.zip epi_cpsmay_*.dta
	cd extracts && zip epi_cpsorg_1979_2020.zip epi_cpsorg_*.dta
	cd extracts && aws s3 sync . s3://microdata.epi.org/ --exclude "*" --include "epi_cps*.zip" --delete
	rm extracts/epi_cps*.zip

	cd extracts && tar cf - epi_cpsbasic_*.feather | pigz > epi_cpsbasic.tar.gz
	cd extracts && tar cf - epi_cpsmarch_*.feather | pigz > epi_cpsmarch.tar.gz
	cd extracts && tar cf - epi_cpsmay_*.feather | pigz > epi_cpsmay.tar.gz
	cd extracts && tar cf - epi_cpsorg_*.feather | pigz > epi_cpsorg.tar.gz
	cd extracts && aws s3 sync . s3://microdata.epi.org/ --exclude "*" --include "epi_cps*.tar.gz" --delete
	rm extracts/epi_cps*.tar.gz

deploywindata:
	rsync -avPh /data/cps/basic/epi/epi_cpsbasic_*.dta ~/mount/data/cps/basic/epi/
	rsync -avPh /data/cps/march/epi/epi_cpsmarch_*.dta ~/mount/data/cps/march/epi/
	rsync -avPh /data/cps/may/epi/epi_cpsmay_*.dta ~/mount/data/cps/may/epi/
	rsync -avPh /data/cps/org/epi/epi_cpsorg_*.dta ~/mount/data/cps/org/epi/

deployado:
	cp code/ado/load_rawcps.ado /usr/local/ado/
	cp code/ado/load_rawcps.sthlp /usr/local/ado/
	cp code/ado/load_epiextracts.ado /usr/local/ado/
	cp code/ado/load_epiextracts.sthlp /usr/local/ado/
	cp code/ado/merge_rawextracts.ado /usr/local/ado/
	cp code/ado/merge_rawextracts.sthlp /usr/local/ado/
	cp code/ado/keepifexist.ado /usr/local/ado/
	cp code/ado/keepifexist.sthlp /usr/local/ado/
