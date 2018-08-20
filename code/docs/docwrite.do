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
	webdoc put .. image:: images/`1'_titleimage.svg
	webdoc put ```
}

webdoc put ## Description
webdoc append ${variableshortdesc}`1'_shortdesc.md

* conditionally, list value labels
if "`2'" == "displayvalues" {
	webdoc put ## Values
	webdoc put ```eval_rst
	webdoc put .. csv-table::
	webdoc put    :file: ${variablelevels}`1'.csv
	webdoc put ```
}

if "`3'" == "details" {
	webdoc put ## Detailed comments
	webdoc append ${variablelongdesc}`1'_longdesc.md
}

if "`1'" == "age" {
	webdoc put ## Code
	webdoc put ```eval_rst
	webdoc put .. toggle-header::
	webdoc put    :header: Variable creation (**show/hide code**)
	webdoc put
	webdoc put    .. literalinclude:: code/generate_`1'.do
	webdoc put
	webdoc put    See this code on Github
	if "`4'" == "titleimage" {
		webdoc put .. toggle-header::
		webdoc put    :header: Figure above (**show/hide code**)
		webdoc put
		webdoc put    .. literalinclude:: code/`1'_analysis.do
	}
	webdoc put
	webdoc put ```
}



webdoc put ## Variable notes
webdoc put ```eval_rst
webdoc stlog, cmdstrip raw
notes `1'
webdoc stlog close
webdoc put ```
