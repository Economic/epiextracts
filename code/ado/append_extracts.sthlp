{smcl}
{vieweralsosee "append_rawdata" "help append_rawdata"}{...}
{vieweralsosee "merge_rawextracts" "help merge_rawextracts"}{...}
{vieweralsosee "keepifexist" "help keepifexist"}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{phang}
{bf:append_extracts} {hline 2} Load EPI extracts into memory


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:append_extracts}{cmd:,}
{opt begin(datestring)} {opt end(datestring)} {opt sample(samplename)} [{it:options}]

{pstd}where {it:datestring} is a monthly date of the form 1990m1, 2008m8, etc.,
and {it:samplename} is either Basic, May, or ORG.

{synoptset 25 tabbed}{...}
{marker table_options}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt keep(varlist)}}limit the data to a selection of variables{p_end}
{synopt:{opt sourcedir(filepath)}}designate the source directory for the EPI extracts{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:append_extracts} loads EPI extracts into memory.

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt keep(varlist)} restricts the data loaded to those variables specified.
In addition to those variables, some other useful variables
(like year, month, and certain weights)
are also kept in memory.
The default is {cmd: keep(_all)}.

{phang}
{opt sourcedir(filepath)} is the directory from which the extracts will be loaded into memory. The default is the default directories on EPI's server maynard.

{marker remarks}{...}
{title:Remarks}

{pstd}
This command clears any existing data in memory.

{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Load all of the 2016-2017 EPI CPS Basic monthly extracts{p_end}
{phang2}{cmd:. append_extracts, begin(2016m1) end(2017m12) sample(basic) sourcedir(/data/cps/basic/epi/)}

{pstd}Load certain variables from the 1990m7-2018m6 EPI CPS ORG{p_end}
{phang2}{cmd:. append_extracts, begin(1990m7) end(2018m6) sample(org) keep(age lfstat union) sourcedir(/data/cps/org/epi/)}
