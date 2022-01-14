********************************************************************************
* Occupation: 1970 classification
****************************************************************
* for coding ease, first create occupation code for all dates
*gen int occcode = .
*capture drop occ70
gen occ70 = .

if $monthlycps == 1 | $maycps == 1 | $marchcps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1982m12) {
		replace occ70 = occcode
	}
}

#delimit ;
lab def occ70
001 "Accountants and auditors"
002 "Architects"
003 "Computer programmers"
004 "Computer system analysts"
005 "Computer specialists, n.e.c."
006 "Engineers, aeronautical"
010 "Engineers, chemical"
011 "Engineers, civil"
012 "Engineers, electrical"
013 "Engineers, industrial"
014 "Engineers, mechanical"
015 "Engineers, metallurgical, metallurgists"
020 "Engineers, mining"
021 "Engineers, petroleum"
022 "Engineer sales"
023 "Engineers (n.e.c)"
024 "Farm and home management advisors"
025 "Foresters and conservationists"
026 "Home management advisors"
030 "Judges"
031 "Lawyers"
032 "Librarians"
033 "Archivists and curators"
034 "Actuaries"
035 "Mathematicians"
036 "Statisticians"
042 "Agricultural scientists"
043 "Atomic and space scientists"
044 "Biological scientists"
045 "Chemists"
051 "Geologists"
052 "Marine Scientists"
053 "Physicists and Astronomers"
054 "Miscellaneous natural scientists"
055 "Operations and system researchers"
056 "Personnel and labor relations workers"
061 "Chiropractors"
062 "Dentists"
063 "Optometrists"
064 "Pharmacists"
065 "Physicians and surgeons"
071 "Podiatrists"
072 "Veterinarians"
073 "Health practitioners, n.e.c."
074 "Dieticians and nutritionists"
075 "Registered nurses"
076 "Therapists"
080 "Clinical laboratory, technologists"
081 "Dental hygienists"
082 "Health record technicians"
083 "Radiologist technicians"
084 "Therapy assistants"
085 "Health technologists, technicians, n.e.c"
086 "Clergy"
090 "Religious workers"
091 "Economists"
092 "Political Scientists"
093 "Psychologists"
094 "Sociologists"
095 "Urban and regional planners"
096 "Social scientists, n.e.c."
100 "Social and welfare workers, except group"
101 "Recreation and group workers"
102 "Professors and instructors, agricultural sciences"
103 "Atmosphere, earth, marine teachers"
104 "Professors and instructors, biological sciences"
105 "Professors and instructors, chemistry"
110 "Professors and instructors, physics"
111 "Professors and instructors, engineering"
112 "Professors and instructors, mathematics"
113 "Health specialists, teachers"
114 "Professors and instructors, psychology"
115 "Business and commerce teachers"
116 "Professors and instructors, economics"
120 "History teachers"
121 "Sociology teachers"
122 "Professors and instructors, social sciences (n.e.c)"
123 "Art, drama and music teachers"
124 "Coaches and physical education trainers"
125 "Education teachers"
126 "English teachers"
130 "Foreign language teachers"
131 "Home economics teachers"
132 "Law teachers"
133 "Theology teachers"
134 "Trade, industrial and technical teachers"
135 "Misc. teachers, college and university"
140 "Professors and instructors, subject not specified"
141 "Adult education teachers"
142 "Teachers, elementary schools"
143 "Prekindergarten and kindergarten teachers"
144 "Teachers, secondary schools"
145 "Teachers except college and university, n.e.c."
150 "Agriculture and biological technicians except health"
151 "Chemical technicians"
152 "Draftsmen"
153 "Electrical and electrical engineering technicians"
154 "Industrial engineering technicians"
155 "Mechanical engineering technicians"
156 "Mathematical technicians"
161 "Surveyors"
162 "Engineering and science technicians, n.e.c."
163 "Airplane pilots and navigators"
164 "Air traffic controllers"
165 "Embalmers"
170 "Mechanics and repairmen, airplane"
171 "Radio operators"
172 "Tool programmers"
173 "Technicians, n.e.c."
174 "Vocational and educational counselors"
175 "Actors and actresses"
180 "Athletes and kindred workers"
181 "Authors"
182 "Dancers and dancing teachers"
183 "Designers"
184 "Editors and reporters"
185 "Musicians and composers"
190 "Painters and sculptors"
191 "Photographers"
192 "Public relation specialists and publicity writers"
193 "Radio and television announcers"
194 "Entertainers (n.e.c)"
195 "Research workers"
196 "Professional, technicians, allocated"
201 "Assessors, controllers"
202 "Rent officers"
203 "Buyers and shippers--farm products"
205 "Buyers, wholesale and retail trade"
210 "Credit and collection managers"
211 "Funeral directors"
212 "Health administrators"
213 "Construction inspectors"
215 "Inspectors except construction"
216 "Managers and superintendents buildings"
220 "Office managers, n.e.c."
221 "Officers pilots--ships"
222 "Officials and administrators, public administration, n.e.c."
223 "Officials, lodge, society, union, etc."
224 "Postmasters"
225 "Purchasing agents and buyers (n.e.c)"
226 "Railroad Conductors"
230 "Restaurant, cafeteria"
231 "Sales managers and dept. heads"
233 "Sales managers except retail trade"
235 "School administrators, college"
240 "School administrators"
245 "Managers and administrators, n.e.c."
246 "Managers and administrators, except farm--allocated"
260 "Advertising agents and salesmen"
261 "Auctioneers"
262 "Demonstrators"
264 "Hucksters and peddlers"
265 "Insurance agents and brokers"
266 "Newsboys"
270 "Real estate agents and brokers"
271 "Stock and bond salesmen"
280 "Sales workers and clerks, n.e.c."
281 "Sales representatives, manufacturing"
282 "Sales representatives, wholesale trade"
283 "Sales clerks. retail trade"
284 "Sales workers , n.e.c., retail trade"
285 "Sales worker-services, construction"
296 "Sales workers--allocated"
301 "Bank tellers"
303 "Billing clerks"
305 "Bookkeepers"
310 "Cashiers"
311 "Clerical assistants"
312 "Clerical supervisors"
313 "Collectors, bill and account"
314 "Counter clerks"
315 "Dispatchers and starters, vehicle"
320 "Enumerators, interviewers"
321 "Estimators and investigators"
323 "Expeditors, production controllers"
325 "File clerks"
326 "Insurance adjusters, examiners, investigators"
330 "Library attendants"
331 "Mail carriers"
332 "Mail handlers"
333 "Messengers and office boys"
334 "Meter readers"
341 "Bookkeeping and billing"
342 "Calculating machine operators"
343 "Computer workers"
344 "Duplication machine operators"
345 "Key punch operators"
350 "Tabulating machine operators"
355 "Office machine operators, n.e.c."
360 "Payroll, and time keeping clerks"
361 "Postal clerks"
362 "Proofreaders"
363 "Real estate appraisers"
364 "Receptionists"
370 "Secretaries, Legal"
371 "Secretaries, Medical"
372 "Secretaries, n.e.c."
374 "Shipping and receiving clerks"
375 "Statistical clerks"
376 "Stenographers"
381 "Stock clerks and storekeepers"
382 "Teachers aids"
383 "Telegraph messengers"
384 "Telegraph operators"
385 "Telephone operators"
390 "Ticket, station, and express agents"
391 "Typists"
392 "Weighters"
394 "Misc. electrical workers"
395 "Unspecified clerical workers"
396 "Clerical and kindred workers--allocated"
401 "Automotive accessories installers"
402 "Bakers"
403 "Blacksmiths"
404 "Boilermakers"
405 "Bookbinders"
410 "Brick masons, stonemasons, and tile setters"
411 "Apprentice bricklayers and masons"
412 "Bulldozer operators"
413 "Cabinetmakers"
415 "Carpenters"
416 "Apprentice carpenters"
420 "Carpet installers"
421 "Cement and concrete finishers"
422 "Compositors and type setters"
423 "Apprentices, printing trades"
424 "Crane men, derrick men, and hoist men"
425 "Decorators and window dressers"
426 "Dental laboratory technicians"
430 "Electricians"
431 "Apprentice electricians"
433 "Electric power line and cable operators"
434 "Electrotypers and stereotypes"
435 "Engravers, except photo engravers"
436 "Excavating"
440 "Floor layers"
441 "Blue collar workers"
442 "Foremen and hammer men"
443 "Furniture and wood finishers"
444 "Furriers"
445 "Glaziers"
446 "Heat treaters, annealers, temperers"
450 "Inspectors, scalers, and graders, log and lumber"
452 "Inspectors (n.e.c)"
453 "Jewelers, watchmakers, goldsmiths, and silversmiths"
454 "Job setters, metal"
455 "Locomotive engineers"
456 "Locomotive firemen"
461 "Machinists"
462 "Machinist apprentices"
470 "Air conditioning, heating, refrigeration"
471 "Aircraft"
472 "Automotive body repairs"
473 "Automotive mechanics"
474 "Apprentice auto mechanics"
475 "Data processing"
480 "Farm implement"
481 "Heavy equipment mechanics"
482 "Household appliance mechanics"
483 "Loom fixers"
484 "Office machine"
485 "Radio and television"
486 "Mechanics and repairmen, railroad and car shop"
491 "Apprentice mechanics, except auto"
492 "Misc. mechanics"
495 "Mechanics and repairmen, n.e.c."
501 "Millers, grain, flour, feed, etc."
502 "Millwrights"
503 "Molders, metal"
504 "Molder apprentices"
505 "Motion picture projectionists"
506 "Opticians and lens grinder and polishers"
510 "Painters, construction and maintenance"
511 "Painter apprentices"
512 "Paperhangers"
514 "Pattern and model makers, except paper"
515 "Photoengravers and lithographers"
516 "Piano and organ tuners and repairmen"
520 "Plasterers"
521 "Plaster apprentices"
522 "Plumbers and pipe fitters"
523 "Apprentice plumbers and pipe fitters"
525 "Power station operators"
530 "Pressmen and plate printers, printing"
531 "Printing press apprentices"
533 "Rollers and roll hands, metal"
534 "Roofers and slaters"
535 "Sheet metal workers, tinsmiths"
536 "Sheet metal apprentices"
540 "Ship fitters"
542 "Shoe repairers"
543 "Sign painters, letterers"
545 "Stationery engineers"
546 "Stone cutters and stone carvers"
550 "Structural metal workers"
551 "Tailors"
552 "Telephone line installers and repairers"
554 "Telephone linemen and splicers"
560 "Tile setters"
561 "Tool makers, and die makers and setters"
562 "Toolmakers and repairmen"
563 "Upholsterers"
571 "Specified craft apprentices"
572 "Unspecified apprentices"
575 "Craftsmen and kindred workers (n.e.c)"
580 "Former members of armed forces"
586 "Craftsmen and kindred workers--allocated"
601 "Asbestos and insulation workers"
602 "Assemblers"
603 "Blasters and powder men"
604 "Bottlers and can operatives"
605 "Chainmen, rodmen, and axmen, surveying"
610 "Checkers, examiners--manufacturing"
611 "Clothiers, ironers, pressers"
612 "Cutting operatives"
613 "Dressmakers and seamstresses, except factory"
614 "Drillers, earth"
615 "Dry wall installers"
620 "Dyers"
621 "Filers, grinders, and polishers, metal"
622 "Furnace men, smelter men, and pourers"
623 "Garage workers and gas station attendants"
624 "Graders, sorters--manufacturing"
625 "Fruit, nut and vegetable graders, and packers, except factory"
626 "Heaters, metal"
630 "Laundry and dry cleaning operatives"
631 "Meat cutters, except slaughter and packing and packing houses"
633 "Meat cutters and butchers"
634 "Meat wrappers--retail trade"
635 "Metal platters"
636 "Milliners"
640 "Mine operatives, n.e.c."
641 "Mixing operatives"
642 "Oilers, and greasers"
643 "Packers and wrappers"
644 "Painters, manufactured articles"
645 "Photographic process workers"
650 "Drill press operatives"
651 "Grinding machine operatives"
652 "Lathe and milling machine operatives"
653 "Precision machine operatives"
656 "Punch and stamping machine operatives"
660 "Riveters and fasteners"
661 "Sailors and deck hands"
662 "Sawyers"
663 "Sewers and stitchers"
664 "Shoemaker machine operatives"
665 "Solderers"
666 "Furnace tenders"
670 "Combing operatives"
671 "Knitters, loopers, trappers"
672 "Spinners, twisters and winders"
673 "Weavers, textile"
674 "Textile operatives"
680 "Welders and flame cutters"
681 "Winding operatives"
690 "Machine operatives"
692 "Machine operatives, n.s."
694 "Misc. operatives"
695 "N.S. operatives"
696 "Operatives, except transport--allocated"
701 "Boatmen, canal men, and lock keepers"
703 "Bus drivers"
704 "Conductors, bus and street railway"
705 "Deliverymen and route men"
706 "Fork lift operatives"
710 "Motormen, mine, factory, logging camp, etc."
711 "Parking attendants"
712 "Brakemen, railroad"
713 "Switchmen, railroad"
714 "Taxicab drivers and chauffeurs"
715 "Truck and tractor drivers"
726 "Transport equipment operatives-allocated"
740 "Animal caretakers--except farm"
750 "Carpenters helpers"
751 "Const. Laborers"
752 "Fishermen and oystermen"
753 "Freight and material handlers"
754 "Garbage collectors"
755 "Garage laborers and car washers and greasers"
760 "Gardeners, except farm and groundskeepers"
761 "Timber cutting and logging workers"
762 "Stock handlers"
763 "Teamsters"
764 "Vehicle washers"
770 "Warehouse laborers, n.e.c."
780 "Misc. laborers"
785 "Laborers, n.s."
796 "Laborers, except farm-allocated"
801 "Farmers"
802 "Farm managers"
806 "Farm managers--allocated"
821 "Farm supervisors"
822 "Farm laborers"
823 "Farm laborers, unpaid family workers"
824 "Farm service laborers, self-employed"
846 "Farm laborers and supervisors--allocated"
901 "Lodging quarter cleaners"
902 "Charwomen and cleaners"
903 "Janitors and sextons"
910 "Bartenders"
911 "Waiters assistants"
912 "Cooks, except private household"
913 "Dishwashers"
914 "Counter and fountain workers"
915 "Waiters and waitresses"
916 "Food service workers"
921 "Dental assistants"
922 "Health aides"
923 "Nurses, student professional"
924 "Midwives"
925 "Nursing aides"
926 "Practical nurses"
931 "Flight attendants"
932 "Attendants, recreation and amusement"
933 "Attendants, personal servives, n.e.c."
934 "Porters"
935 "Barbers"
940 "Boarding and lodging house keepers"
941 "Bootblacks"
942 "Child care workers"
943 "Elevator operators"
944 "Hairdressers and cosmetologists"
945 "Personal service apprentices"
950 "Housekeepers, except private household"
952 "School monitors"
953 "Ushers, recreation and amusement"
954 "Welfare service aides"
960 "Watchmen (crossing) and bridge tenders"
961 "Firemen, fire protection"
962 "Guards, watchmen, and doorkeepers"
963 "Marshals and constables"
964 "Policemen and detectives"
965 "Sheriffs and bailiffs"
976 "Service workers"
980 "Child care workers"
981 "Cooks, private household"
982 "Housekeepers, private household"
983 "Launderers, private household"
984 "Private household cleaners and servants"
986 "Private household workers--allocated"
991 "Unemployed- last worked 1959 or earlier"
994 "Not reported"
999 "No occupation"
;
#delimit cr ;
lab val occ70 occ70
label var occ70 "1970 Census Occupation Classification"
notes occ70: Occupation classification for 1973-1982
notes occ70: 1973-1982 Unicon: occ
