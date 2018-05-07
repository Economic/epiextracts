webdoc init ${variabledocs}`1', replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

/***
```eval_rst
.. This page is generated by createdocs.do. Do not manually edit this page.
```
***/
* grab variable label
local label: variable label `1'

webdoc put # `1': `label'

if "`4'" == "titleimage" {
	webdoc put ```eval_rst
	webdoc put .. image:: analysis/`1'_titleimage.svg
	webdoc put ```
}

webdoc put ## Description
webdoc append ${variabledesc}`1'_shortdesc.md

* conditionally, list value labels
if "`2'" == "displayvalues" {
	webdoc put ## Values
	webdoc put ```eval_rst
	webdoc put .. csv-table::
	webdoc put    :file: docs/variables/levels/`1'.csv
	webdoc put ```
}

webdoc put ## Variable notes
webdoc put ```eval_rst
webdoc stlog, cmdstrip raw
notes `1'
webdoc stlog close
webdoc put ```

if "`3'" == "details" {
	webdoc put ## Detailed analysis
	webdoc append ${variableanalysis}`1'_detailed.md
}
