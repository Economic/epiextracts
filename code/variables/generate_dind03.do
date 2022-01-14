********************************************************************************
* dind03: Detailed industry recode, 2003-present
********************************************************************************
gen byte dind03 = .

if $monthlycps == 1 {
	if tm(2003m1) <= $date {
		replace dind03 = prdtind1
	}
	replace dind03 = . if dind03 < 0
}

if $marchcps == 1 {
	if tm(2003m1) <= $date {
		replace dind03 = a_dtind
	}
	replace dind03 = . if dind03 < 0
}

#delimit ;
label define dind03
1	 "Agriculture"
2  "Forestry, logging, fishing, hunting, and trapping"
3	 "Mining"
4	 "Construction"
5	 "Nonmetallic mineral product manufacturing"
6	 "Primary metals and fabricated metal products"
7	 "Machinery manufacturing"
8	 "Computer and electronic product manufacturing"
9	 "Electrical equipment, appliance manufacturing"
10 "Transportation equipment manufacturing"
11 "Wood products"
12 "Furniture and fixtures manufacturing"
13 "Miscellaneous and not specified manufacturing"
14 "Food manufacturing"
15 "Beverage and tobacco products"
16 "Textile, apparel, and leather manufacturing"
17 "Paper and printing"
18 "Petroleum and coal products manufacturing"
19 "Chemical manufacturing"
20 "Plastics and rubber products"
21 "Wholesale trade"
22 "Retail trade"
23 "Transportation and warehousing"
24 "Utilities"
25 "Publishing industries (except internet)"
26 "Motion picture and sound recording industries"
27 "Broadcasting (except internet)"
28 "Internet publishing and broadcasting"
29 "Telecommunications"
30 "Internet service providers and data processing services"
31 "Other information services"
32 "Finance"
33 "Insurance"
34 "Real estate"
35 "Rental and leasing services"
36 "Professional and technical services"
37 "Management of companies and enterprises"
38 "Administrative and support services"
39 "Waste management and remediation services"
40 "Educational services"
41 "Hospitals"
42 "Health care services, except hospitals"
43 "Social assistance"
44 "Arts, entertainment, and recreation"
45 "Accommodation"
46 "Food services and drinking places"
47 "Repair and maintenance"
48 "Personal and laundry services"
49 "Membership associations and organizations"
50 "Private households"
51 "Public administration"
52 "Armed forces"
;
label values dind03 dind03;
#delimit cr ;

label var dind03 "Detailed industry recode, 2003-present"
notes dind03: Detailed industry recode by Census, consistent for 2003-present
notes dind03: Industry codes from primary job
notes dind03: 2003-present CPS basic: prdtind1
notes dind03: 2003-present CPS march: a_dtind
