*relabel data
set more off
/*
foreach year of numlist 1973/1981 {
    use extracts/epi_cpsmay_`year'.dta, clear
    notes replace _dta in 1: EPI CPS May Extracts, Version 2026.6.10
    label data "EPI CPS May Extracts, Version 2026.6.10"
    saveold extracts/epi_cpsmay_`year'.dta, replace version(13)
}

foreach year of numlist  1962/2018 {
    use extracts/epi_cpsmarch_`year'.dta, clear
    notes replace _dta in 1: EPI CPS March Extracts, Version 2026.6.10
    label data "EPI CPS March Extracts, Version 2026.6.10"
    saveold extracts/epi_cpsmarch_`year'.dta, replace version(13)
}
*/


foreach year of numlist  2023/2025 {
    use extracts/epi_cpsorg_`year'.dta, clear
    notes replace _dta in 1: EPI CPS ORG Extracts, Version 2026.6.10
    label data "EPI CPS ORG Extracts, Version 2026.6.10"
    saveold extracts/epi_cpsorg_`year'.dta, replace version(13)
}

foreach year of numlist  2023/2025 {
    use extracts/epi_cpsbasic_`year'.dta, clear
    notes replace _dta in 1: EPI CPS Basic Monthly Extracts, Version 2026.6.10
    label data "EPI CPS Basic Monthly Extracts, Version 2026.6.10"
    saveold extracts/epi_cpsbasic_`year'.dta, replace version(13)
}
