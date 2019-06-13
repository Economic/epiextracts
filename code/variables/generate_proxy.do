********************************************************************************
* proxy: report by self or proxy
********************************************************************************
gen byte proxy = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace proxy = puslfprx if 1 <= puslfprx & puslfprx <= 3
	}
}

lab var proxy "Self or proxy response"
lab define proxy 1 "Self" 2 "Proxy" 3 "Proxy and Self"
lab val proxy proxy
notes proxy: Labor force information collected by self or proxy
notes proxy: Only available 1994 - present
notes proxy: 1994-present CPS: puslfprx
