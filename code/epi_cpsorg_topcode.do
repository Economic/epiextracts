local year = `1'
/*
gen weekpay_p80 = .

if $earnerinfo == 1 {
  preserve
  keep if weekpay > 0 & weekpay ~= .
  if `year' >= 1979 gen wgt = orgwgt
  if `year' <= 1978 gen wgt = basicwgt

  restore

if $basicfile == 1 {
  gen id = _n
  preserve
  keep if minsamp == 4 | minsamp == 8
  restore
}
if ${basicfile} == 0 {

}
}
*/
