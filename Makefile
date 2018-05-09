deploydata:
	rsync -avh --chmod=0444 extracts/epi*.dta.zip maynard:/data/cps/basic/epiextracts/

deploydocs:
	rsync -rvh docs/_build/html/ maynard:/var/www/html/epiextracts_docs/ --delete
