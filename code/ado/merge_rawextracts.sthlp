{smcl}
{vieweralsosee "append_extracts" "help append_extracts"}{...}
{vieweralsosee "append_rawdata" "help append_rawdata"}{...}
{vieweralsosee "keepifexist" "help keepifexist"}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{phang}
{bf:merge_rawextracts} {hline 2} Merge the EPI CPS extracts and raw CPS data.


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:merge_rawextracts}{cmd:,}
{opt begin(datestring)} {opt end(datestring)} {it:required_options}

{pstd}where {it:datestring} is a monthly date of the form 1990m1, 2008m8, etc.

{synoptset 30 tabbed}{...}
{marker table_options}{...}
{synopthdr:required_options}
{synoptline}
{syntab:Main}
{synopt:{opt sample(str)}}select the sample: Basic, May, or ORG{p_end}
{synopt:{opt keepvarextracts(varlist)}}limit extracts to selected variables{p_end}
{synopt:{opt keepvarraw(varlist)}}limit raw data to selected variables{p_end}
{synoptline}

{marker description}{...}
{title:Description}

{pstd}
{cmd:merge_rawextracts} loads into a memory a merged copy of the EPI CPS extracts
and the raw CPS data.

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt sample(str)} selects the sample: valid entries for {it:str} are
Basic, May, or ORG (not case-sensitive).

{phang}
{opt keepvarextracts(varlist)}}
selects the variables from the EPI CPS extracts.

{phang}
{opt keepvarextracts(varlist)}}
selects the variables from the raw CPS data.
From 1994-present, these are the raw Census data.
Prior to 1994, these are the Unicon data.


{marker remarks}{...}
{title:Remarks}

{pstd}
This command clears any existing data in memory.

{pstd}
The variables specified in {cmd:keepvarextracts(varlist)} or {cmd:keepvarraw(varlist)}
must exist in every selected time period in the EPI extracts or raw data, respectively.

{pstd}
When the raw data is merged to the EPI extracts, all observations from the EPI extracts
are kept and matched to the raw data. Some observations from the raw data are dropped to match the universe of the
EPI extracts, which depends on the sample:

	Basic monthly sample: age of respondent must be nonnegative and nonmissing

	ORG sample: outgoing rotation month, earnings weight must be positive, ages 16+

{marker examples}{...}
{title:Examples}

    {hline}
{phang2}{cmd:. merge_rawextracts, begin(1994m1) end(1995m12) sample(org) keepvarraw(peernlab) keepvarextracts(age selfemp lfstat orgwgt)}
