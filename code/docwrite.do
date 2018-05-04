webdoc init ${variabledesc}`1', replace
* some webdoc options to deal with formatting
webdoc set stlog
webdoc set _stlog

* grab variable label
local label: variable label `1'

webdoc put # `1': `label'

webdoc put ## Description
webdoc append ${variabledesc}`1'_variabledesc.log

webdoc put ## Variable notes
webdoc put ```eval_rst
webdoc stlog, cmdstrip raw
notes `1'
webdoc stlog close
webdoc put ```

* conditionally, list value labels
if "`2'" == "displayvalues" {
	webdoc put ## Values
	webdoc put ```none
	webdoc stlog, cmdstrip raw
	lab li `1'
	webdoc stlog close
	webdoc put ```
}
