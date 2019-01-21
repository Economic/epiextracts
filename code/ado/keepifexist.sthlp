{smcl}
{vieweralsosee "load_epiextracts" "help load_epiextracts"}{...}
{vieweralsosee "append_rawdata" "help append_rawdata"}{...}
{vieweralsosee "merge_rawextracts" "help merge_rawextracts"}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{phang}
{bf:keepifexist} {hline 2} Keep a list of variables, if they exist.


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:keepifexist}
{it:anything}

{pstd}where {it:anything} is a list of potential variable names, at least one of which exists in the data.

{marker description}{...}
{title:Description}

{pstd}
{cmd:keepifexist} is exactly like the Stata command {cmd:keep},
except whereas {cmd:keep} requires a {it:varlist} of variables, which must
exist in the current data in memory, {cmd:keepifexist} only requires that at least
one of the variables exists.

{marker examples}{...}
{title:Examples}

    {hline}
{phang2}{cmd:. sysuse auto}
{phang2}{cmd:. keepifexist m* price nonsense}
