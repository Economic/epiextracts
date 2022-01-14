********************************************************************************
* Occupation: 1980 classification
********************************************************************************
/* 1983-1991: 1980 census occupation codes */
gen occ80 = .

if $monthlycps == 1 | $marchcps == 1 {
	if tm(1983m1) <= $date & $date <= tm(1991m12) {
		replace occ80 = occcode
	}
}

#delimit ;
lab def occ80
000 "No occupation"
003 "Legislators"
004 "Chief executives"
005 "Administrators and officials--public administration"
006 "Administrators-protective services"
007 "Financial managers"
008 "Personnel and labor relations workers"
009 "Purchasing managers"
013 "Managers, marketing, advertising"
014 "Administrators, education and related fields"
015 "Managers, medicine and health"
016 "Managers, properties and retail"
017 "Postmasters and superintendents"
018 "Funeral directors"
019 "Managers and adminstrators. n.e.c."
023 "Accountants and auditors"
024 "Underwriters"
025 "Other financial officers"
026 "Management analysts"
027 "Personal, training and labor relation specialists"
028 "Purchasing agents"
029 "Buyers, wholesale and retail trade"
033 "Purchasing agents, n.e.c."
034 "Business and promotion managers"
035 "Construction inspectors"
036 "Inspectors compliance officers"
037 "Management occupations, n.e.c."
043 "Architects"
044 "Engineers, aeronautical"
045 "Engineers, metallurgical, metallurgists"
046 "Engineers, mining"
047 "Engineers, petroleum"
048 "Engineers, chemical"
049 "Nuclear scientists"
053 "Engineers, civil"
054 "Agricultural"
055 "Engineers, electrical"
056 "Industrial"
057 "Mechanical"
058 "Marine and naval architects"
059 "Engineers n.e.c."
063 "Surveyers and mapping scientists"
064 "Computer system analysts"
065 "Operations and system analysts"
066 "Actuaries"
067 "Statisticians"
068 "Mathematical scientists"
069 "Physicians and astronomers"
073 "Chemists"
074 "Atomic and space scientists"
075 "Geologists"
076 "Physical scientists, n.e.c."
077 "Agricultural scientists"
078 "Biological scientists"
079 "Foresters and conservationists"
083 "Medical scientists"
084 "Physicians and surgeons"
085 "Dentists"
086 "Veterinarians"
087 "Optometrists"
088 "Podiatrists"
089 "Health diagnosing practitioners, n.e.c."
095 "Registered nurses"
096 "Pharmacists"
097 "Dieticians and nutritionists"
098 "Inhalation therapists"
099 "Occupational therapists"
103 "Physical therapists"
104 "Speech therapists"
105 "Therapists, n.e.c."
106 "Physicians assistants"
113 "Atmosphere, earth, marine teachers"
114 "Professors and instructors, biological sciences"
115 "Professors and instructors, chemistry"
116 "Professors and instructors, physics"
117 "Natural science teachers"
118 "Professors and instructors, psychology"
119 "Professors and instructors, economics"
123 "History teachers"
124 "Political science teachers"
125 "Sociology teachers"
126 "Professors and instructors, social sciences (nec)"
127 "Professors and instructors, engineering"
128 "Professors and instructors, mathematical sciences"
129 "Professors and instructors, mathematics"
133 "Professors and instructors, medical sciences"
134 "Health speialists teachers"
135 "Business and commerce teachers"
136 "Professors and instructors, agricultural sciences"
137 "Art, drama and music teachers"
138 "Physical education teachers"
139 "Education teachers"
143 "English teachers"
144 "Foreign language teachers"
145 "Law teachers"
146 "Social work teachers"
147 "Theology teachers"
148 "Trade and industrial teachers"
149 "Home economics teachers"
153 "Teachers, post-secondary (n.e.c.)"
154 "Post secondary teachers-subject not specified"
155 "Teachers, prekindergarten and kindergarten"
156 "Teachers, elementary school"
157 "Teachers, secondary school"
158 "Teachers special education"
159 "Teachers, n.e.c."
163 "Counselors"
164 "Librarians"
165 "Archivists and curators"
166 "Economists"
167 "Psychologists"
168 "Sociologists"
169 "Social scientists, n.e.c."
173 "Urban planners"
174 "Social workers"
175 "Recreation workers"
176 "Clergy"
177 "Religious workers, n.e.c."
178 "Lawyers"
179 "Judges"
183 "Authors"
184 "Technical writers"
185 "Designers"
186 "Musicians and composers"
187 "Actors and directors"
188 "Painters and sculptors"
189 "Photographers"
193 "Dancers and dancing teachers"
194 "Artists, performers"
195 "Editors and reporters"
197 "Public relation specialists and publicity writers"
198 "Public relation specialists"
199 "Athletes"
203 "Clinical lab technologists"
204 "Dental hygenists"
205 "Health record technicians"
206 "Radiologic technicians"
207 "Licensed pratical nurses"
208 "Health technologists"
213 "Electrical and electronic tecnicians"
213 "Electrical technicians"
214 "Industrial enginnering technicians"
215 "Mechanical engineering technicians"
216 "Engineering technicians, n.e.c."
217 "Draftsmen"
218 "Surveyers and mapping technicians"
223 "Biological technicians"
224 "Chemical technicians"
225 "Science technicians, n.e.c."
226 "Airplane pilots and navigators"
227 "Air traffic controllers"
228 "Broadcast equipment operators"
229 "Computer programmers"
233 "Tool programmers"
234 "Legal assistants"
235 "Tecnicians, n.e.c"
243 "Supervisors and proprietors, sales occ."
253 "Insurance sales occupations"
254 "Real estate occupations"
255 "Securities occupations"
256 "Advertising agents and salesmen"
257 "Sales occupations other business services"
258 "Engineer sales"
259 "Sales representatives"
263 "Sales workers, motor vehicles"
264 "Sales workers, apparel"
265 "Sales workers, shoes"
266 "Sales workers, furniture"
267 "Sales workers, radio, television"
268 "Sales workers, hardware"
269 "Sales workers, parts"
274 "Sales workers, other comm."
275 "Sales counter clerks"
276 "Cashiers"
277 "Hucksters and peddlers"
278 "News vendors"
283 "Demonstrators"
284 "Auctioneers"
285 "Sales support occupations, n.e.c."
303 "Supervisors, general office"
304 "Supervisors--computer equipment"
305 "Supervisors--financial records processing"
306 "Chief communication operators"
307 "Supervisors, distribution etc"
308 "Computer operators"
309 "Peripheral machine operators"
313 "Secretaries"
314 "Stenographers"
315 "Typists"
316 "Interviewers"
317 "Hotel clerks"
318 "Transportation agents"
319 "Receptionists"
323 "Information clerks, n.e.c."
325 "Classified-ad clerks"
326 "Correspondence clerks"
327 "Order clerks"
328 "Personnel clerks"
329 "Library clerks"
335 "File clerks"
336 "Record clerks"
337 "Bookkeepers"
338 "Payroll clerks"
339 "Billing clerks"
343 "Cost and rate clerks"
344 "Billing operators"
345 "Duplicating machine operators"
346 "Mail preparing operators"
347 "Office machine operators, n.e.c."
348 "Telephone operators"
349 "Telegraphers"
353 "Communications equipment operators, n.e.c."
354 "Postal clerks except mail carriers"
355 "Mail carriers"
356 "Mail clerks, except postal services"
357 "Messengers"
359 "Dispatchers"
363 "Production co-ordinators"
364 "Traffic clerks"
365 "Stock inventory clerks"
366 "Meter readers"
368 "Weighers"
369 "Samplers"
373 "Expediters"
374 "Material recording"
375 "Insurance adjusters"
376 "Investigators and adjusters"
377 "Eligibility clerks, social welfare"
378 "Bill and account collecters"
379 "General office clerks"
383 "Bank tellers"
384 "Proofreaders"
385 "Data-entry keyers"
386 "Statistical clerks"
387 "Teachers aides"
389 "Administrative support occupations, n.e.c."
403 "Launderers and ironers"
404 "Cooks, private household"
405 "Housekeeper and butlers"
406 "Child care workers"
407 "Private household cleaners and servants"
413 "Supervisors, firefighting and fire prevention occupations"
414 "Supervisors , police and detectives"
415 "Supervisors, guards"
416 "Fire inspection and fire prevention occupations"
417 "Firefighting occupations"
418 "Police and detectives, public service"
423 "Sheriffs, bailiffs and other law enforcement officers"
424 "Correctional institution officers"
425 "Crossing guards"
426 "Guards and police except public service"
427 "Protective service occupations, n.e.c."
433 "Supervisors food preparation"
434 "Bartenders"
435 "Waiters and Waitresses"
436 "Cooks, except short order"
437 "Short-order cooks"
438 "Food counter"
439 "Kitchen workers-food preparation"
443 "Waiters/waitresses assistants"
444 "Misc. food preparation occupations"
445 "Dental assistants"
446 "Health aides, except nursing"
447 "Nursing aides, orderlies"
448 "Supervisors-cleaning and building equipments"
449 "Maids and housemen"
453 "Janitors and cleaners"
454 "Elevator operators"
455 "Pest control operations"
456 "Supervisors, personal service equipments"
457 "Barbers"
458 "Hairdressers and cosmetologists"
459 "Attendants, amusements and recreational facilties"
463 "Giudes"
464 "Ushers"
465 "Public transportation attendants"
466 "Baggage porters and bellhops"
467 "Welfare service aides"
468 "Child care workers"
469 "Personal service occupations, n.e.c."
473 "Farmers, except horticulture"
474 "Horticulture speciality farmers"
475 "Managers farms except horticulture"
476 "Managers--horticulture speciality farms"
477 "Supervisors--farm workers"
479 "Farm workers"
483 "Marine life cultivation workers"
484 "Nursery workers"
485 "Supervisors agricultural operations"
486 "Groundskeepers and Gardeners except farms"
487 "Animal caretakers, except farms"
488 "Graders and sorters--agricultural products"
489 "Inspectors, agricultural products"
494 "Supervisors-forestry"
495 "Forestry workers, except logging"
496 "Timber cutting and logging operations"
497 "Captains, officers-shipping vessel"
498 "Fishers"
499 "Hunters and trappers"
503 "Supervisors, mechanics, repairers"
505 "Auto mechanics"
506 "Automobile mechanic apprentices"
507 "Bus, truck mechanic"
508 "Aircraft engine mechanics"
509 "Small engine repairers"
514 "Automobile body repairers"
515 "Aircraft mechanics"
516 "Heavy equipment mechanics"
517 "Farm euipment mechanics"
518 "Industry machinery operators"
519 "Machinery maintenance occupations"
523 "Electronic repairers"
525 "Data processing equipment repairers"
526 "Household appliance repairers"
527 "Telephone line installers"
529 "Telephone installers"
533 "Misc. electrical equipment operators"
534 "Heating, air conditioning mechanics"
535 "Camera, watch repairers"
536 "Locksmiths and safe repairers"
538 "Office machine repairers"
539 "Maechanical control and valve repairers"
543 "Elevator installers"
544 "Milwrights"
547 "Specific mechanics, repairers"
549 "Mechanics, repairers, n.e.c."
553 "Supervisors, brickmasons"
554 "Supervisors-carpenters"
555 "Supervisors-electrical"
556 "Supervisors, painters, paperhangers"
557 "Supervisors-plumbers, pipe fitters"
558 "Supervisors, n.e.c."
563 "Brickmasons and stonemasons"
564 "Brickmason"
565 "Tile setters"
566 "Carpet installers"
567 "Carpenetrs"
569 "Carpet apprentices"
573 "Drywall installers"
575 "Electricians"
576 "Electrician apprentices"
577 "Electrical power installers"
579 "Painters, construction, maintenance"
583 "Paperhangers"
584 "Plasterers"
585 "Plumbers, pipefitters"
587 "Plumber, pipefitters"
588 "Concrete finishers"
589 "Glaziers"
593 "Insulation workers"
594 "Paving, surfacing euipment operators"
595 "Roofers"
596 "Sheetmetal duct installers"
597 "Structural metal workers"
598 "Drillers, earth"
599 "Construction trades, n.e.c."
613 "Supervisors, extraction operators"
614 "Drillers, oil"
615 "Explosive workers"
616 "Mining machine operators"
617 "Mining occupations, n.e.c."
633 "Superviser, production occupations"
634 "Tool and die makers"
635 "Tool and die makers apprentices"
636 "Precision assemblers"
637 "Machinists"
639 "Machinist apprentices"
643 "Boilermakers"
644 "Precision grinders"
645 "Pattern and model makers, metal"
646 "Lay-out workers"
647 "Precious stone, metal workers"
649 "Engravers, metal"
653 "Sheet metal worker apprentices"
654 "Sheet metal worker apprentices"
655 "Misc. precision metal workers"
656 "Pattern and model makers, wood"
657 "Cabinet makers"
658 "Furniture, wood finishers"
659 "Misc. precision wood workers"
666 "Dressmakers"
667 "Tailors"
668 "Upholsterers"
669 "Shoe repairers"
673 "Apparel and fabric pattern makers"
674 "Misc. precision apparel workers"
675 "Hand molders and shapers"
676 "Pattern makers, lay-out workers"
677 "Optical goods workers"
678 "Dental lab technicians"
679 "Bookbinders"
683 "Electrical equipment assemblers"
684 "Misc. precision workers, n.e.c."
686 "Butchers and meat cutters"
687 "Bakers"
688 "Food batchmakers"
689 "Inspectors, testers, graders"
693 "Adjusters, calibrators"
694 "Water-Sewage plant operators"
695 "Power plant operators"
696 "Stationary engineers"
699 "Misc. plant and system operators"
703 "Lathe and turning mchine operators"
704 "Lathe turning machine operators"
705 "Milling and planting machine operators"
706 "Punching and stamp machine operators"
707 "Rolling machine operators"
708 "Drilling and boring machine operators"
709 "Grinding, buffing machine operators"
713 "Forging machine operators"
714 "Numerical machine control operators"
715 "Misc. metal, plastic , glass operators"
717 "Fabricating machine operators, n.e.c."
719 "Molding and casting machine operators"
723 "Metal plating machine operators"
724 "Heat treating equipment operators"
725 "Misc. plastic metal molding operators"
726 "Wood lathe machine operators"
727 "Sawing machine operators"
728 "Shaping and joining machine operators"
729 "Nail and tacking machine operators"
733 "Printing machine operators"
734 "Printing machine operators"
735 "Photoengravers, lithographers"
736 "Typesetters and composers"
737 "Misc. printing machine operators"
738 "Winding and twisting machine operators"
739 "Knitting, looping machine operators"
743 "Textile cutting machine operators"
744 "Textile sewing machine operators"
745 "Shoe machine operators"
747 "Pressing machine operators"
748 "Laundering and dry cleaning machine operators"
749 "Misc. textile machine operators"
753 "Cementing and gluing machine operators"
754 "Packaging and filling machine operators"
755 "Extruding and forming machine operators"
756 "Mixing and blending machine operators"
757 "Separating, filtering, clarifying machine operators"
758 "Compressing, compact machine operators"
759 "Painting, spraying machine operators"
763 "Roasting and baking mc. Operators"
764 "Washing, cleaning, pickling machine operators"
765 "Folding machine operators"
766 "Furnace, kiln, oven operators"
768 "Crushing and grinding machine operators"
769 "Slicing, cutting machine operators"
773 "Motion picture projectionists"
774 "Photographic process machine operators"
777 "Misc. machine operators"
779 "Machine operators, n.s."
783 "Welders and cutters"
784 "Solderers and brazers"
785 "Assemblers"
786 "Hand cutting and trimming operations"
787 "Hand molding, casting and forming operations"
789 "Hand painting, coating operations"
793 "Hand engraving and printing operations"
794 "Hand grinding and polishing operations"
795 "Misc. hand working operations"
796 "Production inspectors"
797 "Production testers"
798 "Production samplers and weighers"
799 "Graders and sorters"
803 "Supervisors, motor vehicle operators"
804 "Truck drivers(heavy)"
805 "Truck drivers, light"
806 "Driver-sales workers"
808 "Bus drivers"
809 "Taxicab drivers and chauffeurs"
813 "Parking lot attendants"
814 "Motor transportation occupations, n.e.c."
823 "Railroad conductors, yardmasters"
824 "Locomotive operators"
825 "Railroad brake, signal workers"
826 "Rail vehicle operators, n.e.c."
828 "Ship captains and mates"
829 "Sailors and deckhands"
833 "Marine engineers"
834 "Bridge, lock and lighthouse tenders"
843 "Supervisors, material moving"
844 "Operating engineers"
845 "Longshore equipment operators"
848 "Hoist and winch operators"
849 "Crane and tower operators"
853 "Excavating operators"
855 "Grader, Dozer, Scraper operator"
856 "Industrial truck and tractor equipment operators"
859 "Misc. material moving equipment operators"
863 "Supervisors, laborers, n.e.c."
864 "Helpers, machiners, repairers"
865 "Helpers, construction trade"
866 "Helpers, surveyors"
867 "Helpers, extractive operations"
869 "Construction laborers"
873 "Production helpers"
875 "Garbage collectors"
876 "Stevedores"
877 "Stock handlers and baggers"
878 "Machine feeders and offbeaters"
883 "Freight, stock material handlers, n.e.c."
885 "Garage and service station occ."
887 "Vehicle washers and equipment cleaners"
888 "Hand packers and packagers"
889 "Laborers, except construction"
905 "Unemployed, or last job in armed forces"
;
#delimit cr ;
lab val occ80 occ80
label var occ80 "1980 Census Occupation Classification"
notes occ80: Occupation classification for 1983-1991
notes occ80: 1983-1991 Unicon: occ
