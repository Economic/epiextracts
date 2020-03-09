{smcl}
{vieweralsosee "load_epiextracts" "help load_epiextracts"}{...}
{vieweralsosee "merge_rawextracts" "help merge_rawextracts"}{...}
{vieweralsosee "keepifexist" "help keepifexist"}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{phang}
{bf:load_rawcps} {hline 2} Load raw CPS data into memory


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:load_rawcps}{cmd:,}
{opt begin(year)} {opt end(year)} {opt sample(samplename)} [{it:options}]

{pstd}where {it:year} is a year like 1973, 1990, 2018, etc.
and {it:samplename} is either Basic, May, or ORG.

{synoptset 20 tabbed}{...}
{marker table_options}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt keep(varlist)}}limit the data to a selection of variables{p_end}
{synoptline}

{marker description}{...}
{title:Description}

{pstd}
{cmd:load_rawcps} loads raw CPS data into memory.
From 1994-present, these are the raw data downloaded from the Census.
Prior to 1994, these are the Unicon extracts.

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt keep(varlist)} restricts the data loaded to those variables specified.
In addition to those variables, the variables year and month are created.
The default is {opt keep(_all)}. At least one of the specified variables must
exist in each year of data.

{marker remarks}{...}
{title:Remarks}

{pstd}
This command clears any existing data in memory.

{pstd}
If {cmd: sample(org)} is selected, it will limit the raw data to those in outgoing
rotation months with positive earnings weights.

{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Load all of the 2017 raw CPS basic monthly files{p_end}
{phang2}{cmd:. load_rawcps, begin(2017) end(2017) sample(basic)}

{pstd}Load certain variables from the 2010-2013 raw CPS ORG data{p_end}
{phang2}{cmd:. load_rawcps, begin(2010) end(2013) sample(org) keep(peage prtage)}
