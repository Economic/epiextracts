*******************************************************************************
* Health insurance coverage last year, categorical
*******************************************************************************
gen byte hicovlyi = .

if $marchcps == 1 {
	if tm(1988m1) <= $date & $date <= tm(1994m12) {
		replace hicovlyi = 1 if mcaid == 1 /* medicaid coverage */
		replace hicovlyi = 1 if chmc == 1 /* child medicaid coverage */
		replace hicovlyi = 2 if mcare == 1 /* medicare coverage */
		replace hicovlyi = 3 if covhi == 1 /* private health insurace */
		replace hicovlyi = 3 if chhi == 1 /* child private health insurance in HH */
		replace hicovlyi = 3 if chhi == 2 /* child private health insurance outside HH */
		replace hicovlyi = 4 if champ == 1 /* military/veteran health insurance */

	}
	if tm(1995m1) <= $date & $date <= tm(1997m12) {
		replace hicovlyi = 1 if mcaid == 1 /* medicaid coverage */
		replace hicovlyi = 2 if mcare == 1 /* medicare coverage */
		replace hicovlyi = 3 if covhi == 1 /* private health insurace */
		replace hicovlyi = 4 if oth == 1 /* other types of government coverage */
		replace hicovlyi = 4 if othstper == 1 /* other types of government coverage*/
	}
	if tm(1998m1) <= $date & $date <= tm(2018m12) {
		replace hicovlyi = 1 if mcaid == 1 /* medicaid coverage */
		replace hicovlyi = 2 if mcare == 1 /* medicare coverage */
		replace hicovlyi = 3 if cov_hi == 1 /* private health insurace */
		replace hicovlyi = 4 if oth == 1 /* other types of government coverage */
		replace hicovlyi = 4 if othstper == 1 /* other types of government coverage */
	}    
	if tm(2019m1) <= $date {
		replace hicovlyi = 1 if mcaid == 1 /* medicaid/CHIP coverage */
		replace hicovlyi = 2 if mcare == 1 /* medicare coverage */
		replace hicovlyi = 3 if priv == 1 /* private health insurace */
		replace hicovlyi = 4 if ihsflg == 1 /* Indian health services coverage */
		replace hicovlyi = 4 if mil == 1 /* active duty VA/TRICARE coverage */
		replace hicovlyi = 4 if champva == 1 /* civilian VA coverage */
		replace hicovlyi = 4 if vacare == 1 /* veteran VA coverage */
	}
}

lab var hicovlyi "Health insurance coverage last year, categorical"
lab def hicovlyi 1 "Medicaid" 2 "Medicare" 3 "Private" 4 "Other government"
lab val hicovlyi hicovlyi
notes hicovlyi: Available 1988-present
notes hicovlyi: 1988-present universe: All persons (not infants born after calendar year)
notes hicovlyi: 1988-1994 Unicon: mcaid, chmc, mcare, covhi, chhhi, champ
notes hicovlyi: 1995-1997 Unicon: mcaid, mcare, covhi, oth, othstper
notes hicovlyi: 1998-2018 CPS: mcaid, mcare, cov_hi, oth, othstper
notes hicovlyi: 2019-present CPS: mcaid, mcare, priv, ihsflg, mil, champva, vacare
