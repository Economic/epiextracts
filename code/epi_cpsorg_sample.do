local date = `1'

**************************
* ORG SAMPLE RESTRICTION *
**************************
keep if minsamp == 4 | minsamp == 8

* also restrict to positive earnings weight
keep if orgwgt > 0 & orgwgt ~= .
