=====================
Wage gaps
=====================

Female-male wage gap
=====================
::

	use epi_org_2017, clear
	keep if age >= 16 & age <= 64
	gen logwage4 = log(wage4)
	gen age2 = age^2

	reg logwage4 female [aw=orgwgt]

	reg logwage4 female age age2 i.state i.ms i.educ i.wbho [aw=orgwgt]
