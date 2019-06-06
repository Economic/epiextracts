********************************************************************************
* Usually receive overtime, tips, commissions 1994-; hourly only
********************************************************************************
* it looks possible to extend the overtime definitions past hourly workers
gen byte otcrec = .

if $monthlycps == 1 | $maycps == 1 {
	if $earnerinfo == 1 {
		if tm(1994m1) <= $date  {
			replace otcrec = 0 if paidhre == 1 & peernuot == 2
			replace otcrec = 1 if paidhre == 1 & peernuot == 1
		}
	}
}

lab var otcrec "Usually receive overtime, tips, commissions"
notes otcrec: Hourly workers only
notes otcrec: 1994-present CPS: derived from peernuot & paidhre
