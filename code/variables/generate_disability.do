********************************************************************************
* Presence of disability
********************************************************************************
gen byte disability = .

if $monthlycps == 1 {
	if tm(1994m1) <= $date {
		replace disability = 0 if pudis == 3
		replace disability = 1 if puwk == 4 /* reports disability */
		* pudis == 1 ~ definitely DO have disability (now and into the future, that prevents work)
		* pudis == 2 ~ don't have a disability that limits work, but still have disability - unclear language
		* pudis == 3 ~ definitely DON'T have disability
		* had disability last month, will your disability prevents work in next six months
		*note: pudis1/pudis2 != 1
		replace disability = 1 if pudis == 1 
		* have disability this month, does it prevent work? -- pudis/pudis2 != 1 
		* does pudis1 == 2 mean respondent has disability (based on the question phrasing)
		replace disability = 1 if pudis1 == 1 | pudis1 == 2 /* reports disability */
		* pudis/pudis1 != 1
		replace disability = 1 if pudis2 == 1 /* reports disability that prevents work */
	}
}

label var disability "Disability"
lab def disability 0 "Doesn't have disability" 1 "Has disability" 
lab val disability disability
notes disability: 1994-present Basic: pudis
