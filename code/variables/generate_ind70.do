********************************************************************************
* Industry: 1970 classification
****************************************************************
capture drop ind70
gen ind70 = .

if $monthlycps == 1 | $maycps == 1 {
	if tm(1973m1) <= $date & $date <= tm(1982m12) {
		replace ind70 = indcode
	}
}

#delimit ;
lab def ind70
17 "Agricultural production"
18 "Agricultural services, except horticultural"
19 "Horticultural services"
27 "Forestry"
28 "Fisheries"
29 "Agriculture, forestry, and fisheries--allocated"
47 "Metal mining"
48 "Coal mining"
49 "Crude petroleum and natural gas extractions"
57 "Nonmetallic mining and quarrying, except fuel"
58 "Mining--allocated"
67 "General building contractors"
68 "General contractors, except building"
69 "Special trade contractors"
77 "Construction, n.s."
78 "Construction--allocated"
107 "Logging"
108 "Sawmills, planing mills, and mill work"
109 "Miscellaneous wood products"
118 "Furniture and fixtures"
119 "Glass and glass products"
127 "Cement, concrete, gypsum, and plaster products"
128 "Structural clay products"
137 "Pottery and related products"
138 "Miscellaneous nonmetallic mineral and stone products"
139 "Blast furnaces, steel works, rolling and finishing mills"
147 "Other primary iron and steel industries"
148 "Primary aluminum industries"
149 "Other primary nonferrous industries"
157 "Cutlery, hand tools, and other hardware"
158 "Fabricated structural metal products"
159 "Screw machine products"
167 "Metal stamping"
168 "Miscellaneous fabricated metal products"
169 "Metal industries, n.s."
177 "Engines and turbines"
178 "Farm machinery and equipment"
179 "Construction and material handling machines"
187 "Metalworking machinery"
188 "Office and accounting machines"
189 "Electronic computing equipment"
197 "Machinery, except electrical, n.e.c."
198 "Machinery, n.s."
199 "Household appliances"
207 "Radio, T.V., and communication equipment"
208 "Electrical machinery, equipment, and supplies, n.e.c."
209 "Electrical machinery, equipment, and supplies, n.s."
219 "Motor vehicles and motor vehicle equipment"
227 "Aircraft and parts"
228 "Ship and boat building and repairing"
229 "Railroad locomotives and equipment"
237 "Mobile dwellings and campers"
238 "Cycles and miscellaneous transportation equipment"
239 "Scientific and controlling instruments"
247 "Optical and health services supplies"
248 "Photographic equipment and supplies"
249 "Watches, clocks, and clockwork-operated devices"
257 "Professional equipment, n.s."
258 "Ordnance"
259 "Miscellaneous manufacturing industries"
267 "Manufacturing, durable goods--allocated"
268 "Meat products"
269 "Dairy products"
278 "Canning and preserving fruits, vegetables, and sea foods"
279 "Grain-mill products"
287 "Bakery products"
288 "Confectionery and related products"
289 "Beverage industries"
297 "Miscellaneous food preparation and kindred products"
298 "Food industries, n.s."
299 "Tobacco manufactures"
307 "Knitting mills"
308 "Dyeing and finishing textiles, except wool and knit goods"
309 "Floor coverings, except hard surface"
317 "Yarn, thread, and fabric mills"
318 "Miscellaneous textile mill products"
319 "Apparel and accessories"
327 "Miscellaneous fabricated textile products"
328 "Pulp, paper, and paperboard mills"
329 "Miscellaneous paper and pulp products"
337 "Paperboard containers and boxes"
338 "Newspaper publishing and printing"
339 "Printing, publishing, and allied industries, except newspapers"
347 "Industrial chemicals"
348 "Plastics, synthetics and resins, except fibers"
349 "Synthetic fibers"
357 "Drugs and medicines"
358 "Soaps and cosmetics"
359 "Paints, varnishes, and related products"
367 "Agricultural chemicals"
368 "Miscellaneous chemicals"
369 "Chemicals and allied products, n.s."
377 "Petroleum refining"
378 "Miscellaneous petroleum and coal products"
379 "Rubber products"
387 "Miscellaneous plastic products"
388 "Tanned, curried, and finished leather"
389 "Footwear, except rubber"
397 "Leather products, except footwear"
399 "Manufacturing, nondurable goods--allocated"
398 "Manufacturing industries, n.s."
407 "Railroads and railway express service"
408 "Street railways and bus lines"
409 "Taxicab service"
417 "Trucking service"
418 "Warehousing and storage"
419 "Water transportation"
427 "Air transportation"
428 "Pipe lines, except natural gas"
429 "Services incidental to transportation"
447 "Radio broadcasting and television"
448 "Telephone (wire and radio)"
449 "Telegraph and miscellaneous communication services"
467 "Electric light and power"
468 "Electric-gas utilities"
469 "Gas and steam supply systems"
477 "Water supply"
478 "Sanitary services"
479 "Other and not specified utilities"
499 "Transportation, communications, and other public utilities--allocated"
507 "Motor vehicles and equipment"
508 "Drugs, chemicals, and allied products"
509 "Dry goods and apparel"
527 "Food and related products"
528 "Farm products--raw materials"
529 "Electrical goods"
537 "Hardware, plumbing, and heating supplies"
538 "Electrical and hardware products, n.s."
539 "Machinery equipment and supplies"
557 "Metals and minerals, n.e.c."
558 "Petroleum products"
559 "Scrap and waste materials"
567 "Alcoholic beverages"
568 "Paper and its products"
569 "Lumber and construction materials"
587 "Wholesalers, n.e.c."
588 "Wholesale trade, n.s."
599 "Wholesale trade--allocated"
607 "Lumber and building material retailing"
608 "Hardware and farm equipment stores"
609 "Department and mail order establishments"
617 "Limited price variety stores"
618 "Vending machine operators"
619 "Direct selling establishments"
627 "Miscellaneous general merchandise stores"
628 "Grocery stores"
629 "Dairy products stores"
637 "Retail bakeries"
638 "Food stores, n.e.c."
639 "Motor vehicle dealers"
647 "Tire, battery, and accessory dealers"
648 "Gasoline service stations"
649 "Miscellaneous vehicle dealers"
657 "Apparel and accessories stores, except shoe stores"
658 "Shoe stores"
667 "Furniture and home furnishings stores"
668 "Household appliances, TV, and radio stores"
669 "Eating and drinking places"
677 "Drug stores"
678 "Liquor stores"
679 "Farm and garden supply stores"
687 "Jewelry stores"
688 "Fuel and ice dealers"
689 "Retail florists"
697 "Miscellaneous retail stores"
698 "Retail trade, n.s."
699 "Retail trade--allocated"
707 "Banking"
708 "Credit agencies"
709 "Security, commodity brokerage, and investment companies"
717 "Insurance"
718 "Real estate, including real estate-insurance-law offices"
719 "Finance, insurance, and real estate--allocated"
727 "Advertising"
728 "Services to dwellings and other buildings"
729 "Commercial research, development, and testing labs"
737 "Employment and temporary help agencies"
738 "Business management and consulting services"
739 "Computer programming services"
747 "Detective and protective services"
748 "Business services, n.e.c."
749 "Automobile services, except repair"
757 "Automobile repair and related services"
758 "Electrical repair shops"
759 "Miscellaneous repair services"
767 "Business and repair services--allocated"
769 "Private households"
777 "Hotels and motels"
778 "Lodging places, except hotels and motels"
779 "Laundering, cleaning, and other garment services"
787 "Beauty shops"
788 "Barber shops"
789 "Shoe repair shops"
797 "Dressmaking shops"
798 "Miscellaneous personal services"
799 "Personal services--allocated"
807 "Theaters and motion pictures"
808 "Bowling alleys, billiard and pool parlors"
809 "Miscellaneous entertainment and recreation services"
817 "Entertainment and recreation services--allocated"
828 "Offices of physicians"
829 "Offices of dentists"
837 "Offices of chiropractors"
838 "Hospitals"
839 "Convalescent institutions"
847 "Offices of health practitioners, n.e.c."
848 "Health services, n.e.c."
849 "Legal services"
857 "Elementary and secondary schools"
858 "Colleges and universities"
859 "Libraries"
867 "Educational services, n.e.c."
868 "Educational services, n.s."
869 "Museums, art galleries, and zoos"
877 "Religious organizations"
878 "Welfare services"
879 "Residential welfare facilities"
887 "Nonprofit membership organizations"
888 "Engineering and architectural services"
889 "Accounting, auditing, and bookkeeping services"
897 "Miscellaneous professional and related services"
899 "Professional and related services--allocated"
907 "Postal service"
917 "Federal public administration"
927 "State public administration"
937 "Local public administration"
947 "Public administration--allocated"
997 "Unemployed persons, last worked 1959 or earlier*"
999 "Industry not reported"
;
#delimit cr;
lab val ind70 ind70
label var ind70 "1970 Census Industry Classification"
notes ind70: Industry classification for 1973-1982
notes ind70: 1973-1982 Unicon: ind
