/* generate artificial data as test case */
/* in future we will just use EPI data, once we add labels and notes*/
/* for now, use example CEPR data variable/value labels and notes */
clear
gen educ = .
lab var educ "Education level"
#delimit ;
lab define educ
1 "LTHS"
2 "HS"
3 "Some college"
4 "College"
5 "Advanced"
;
#delimit cr
lab val educ educ
notes educ: Follows Jaeger (1997) classifications
notes educ: CPS: derived from a-hga, a-hgc, peeduca

gen wbho = .
lab var wbho "Race"
#delimit ;
lab define wbho
1 "White"
2 "Black"
3 "Hispanic"
4 "Other";
#delimit cr
lab val wbho wbho
notes wbho: Racial and ethnic categories are mutually exclusive
notes wbho: Major recoding of race variable in 2003
notes wbho: From 2003, black includes all respondents listing black; other /*
*/ includes all respondents listing non-white or non-black races, except /*
*/ those also listing black
notes wbho: CPS: derived from perace, prdtrace, ptdtrace, prorigin, prdthsp

gen wage4 = .
lab var wage4 "Hourly wage"
notes wage4: Dollars per hour
notes wage4: For hourly and nonhourly workers
notes wage4: Includes overtime, tips, commissions for nonhourly and hourly
notes wage4: Covers only hourly workers who report hourly rate of pay
notes wage4: No adjustments for top-coding
notes wage4: No trimming of outliers
notes wage4: Excludes nonhourly workers whose usual hours vary
notes wage4: Consistent 1994-2016, experimental 1979-1993

gen cmsacode14=.

#delimit ;
lab define cmsacode14
104 "Albany-Schenectady, NY"
106 "Albuquerque-Santa Fe-Las Vegas, NM"
118 "Appleton-Oshkosh-Neenah, WI"
122 "Atlanta--Athens-Clarke Countyâ€”Sandy Springs, GA"
148 "Boston-Worcester-Providence, MA-RI-NH-CT"
162 "Cape Coral-Fort Myers-Naples, FL"
168 "Cedar Rapids-Iowa City, IA"
170 "Charleston-Huntington-Ashland, WV-OH-KY"
174 "Chattanooga-Cleveland-Dalton, TN-GA"
176 "Chicago-Naperville-Michigan City, IL-IN-WI"
184 "Cleveland-Akron-Canton, OH (part)"
194 "Columbus-Auburn-Opelika, GA-AL"
206 "Dallas-Fort Worth, TX-OK"
212 "Dayton-Springfield, OH"
216 "Denver-Aurora, CO"
220 "Detroit-Warren-Ann Arbor, MI"
238 "El Paso-Las Cruses, TX-NM"
260 "Fresno-Madera, CA"
266 "Grand Rapids-Wyoming-Muskegon, MI"
268 "Greensboro--Winston-Salemâ€“High Point, NC"
272 "Greenville-Anderson-Seneca, SC"
273 "Greenville-Spartanburg-Anderson, SC"
276 "Harrisburg-York-Lebanon, PA"
278 "Hartford-West Hartford, CT"
290 "Huntsville-Decatur, AL"
294 "Indianapolis-Anderson-Columbus, IN"
304 "Johnson City-Kingsport-Bristol, TN-VA (part)"
310 "Kalamazoo-Battle Creek-Portage, MI"
340 "Little Rock-North Little Rock, AR"
348 "Los Angeles-Long Beach-Riverside, CA"
356 "Macon-Warner Robins-Fort Valley, GA"
357 "Madison-Janesville-Beloit, WI"
370 "Miami-Fort Lauderdale-Port St. Lucie, FL"
376 "Milwaukee-Racine-Waukesha, WI"
378 "Minneapolis-St. Paul-St. Cloud, MN"
380 "Mobile-Daphne-Fairhope, AL"
408 "New York-Newark-Bridgeport, NY-NJ-CT-PA (part)"
422 "Orlando-Deltona-Daytona Beach, FL"
428 "Philadelphia-Reading-Camden, PA-NJ-DE-MD"
438 "Portland-Lewiston-South Portland, ME"
440 "Portland-Vancouver-Salem, OR-WA"
450 "Raleigh-Durham-Cary, NC"
482 "Salt Lake City-Provo-Orem, UT"
488 "San Jose-San Francisco-Oakland, CA"
500 "Seattle-Tacoma-Olympia, WA"
515 "South Bend-Elkhart-Mishawaka, IN-MI"
518 "Spokane-Spokane Valley-Coeur dâ€™Alene, WA-ID"
546 "Visalia-Porterville-Hanford, CA"
548 "Washington-Baltimore-Arlington, DC-MD-VA-WV-PA"
715 "Boston-Worcester-Manchester, MA-NH-CT-ME"
720 "Bridgeport-New Haven-Stamford, CT"
;
#delimit cr

lab var cmsacode14 "CSA Code"
lab val cmsacode14 cmsacode14
notes cmsacode14: CPS: gtcsa
notes cmsacode14: Consistent from May 2014-on
