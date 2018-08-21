**************************
* ORG SAMPLE RESTRICTION *
**************************
* restrict to outgoing months
keep if minsamp == 4 | minsamp == 8

* restrict to positive earnings weight
keep if orgwgt > 0 & orgwgt ~= .

* restrict ORG sample to 16 and above
keep if age >= 16 & age ~= .
