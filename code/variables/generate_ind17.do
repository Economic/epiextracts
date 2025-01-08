********************************************************************************
* Industry: 2017 classification
********************************************************************************
/* 2020-present: 2017 census industry codes */

gen ind17 = .


if $monthlycps == 1 | $marchcps == 1 {
	if tm(2020m1) <= $date {
		replace ind17 = indcode
	}
}

#delimit ;
lab def ind17
170 "Crop production"
180 "Animal production"
190 "Forestry except logging"
270 "Logging"
280 "Fishing, hunting, and trapping"
290 "Support activities for agriculture and forestry"
370 "Oil and gas extraction"
380 "Coal mining"
390 "Metal ore mining"
470 "Nonmetallic mineral mining and quarrying and not specified type of mining"
490 "Support activities for mining"
770 "Construction"
1070 "Animal food, grain, and oilseed milling"
1080 "Sugar and confectionery products"
1090 "Fruit and vegetable preserving and specialty food manufacturing"
1170 "Dairy product manufacturing"
1180 "Animal slaughtering and processing"
1190 "Retail bakeries"
1270 "Bakeries, except retail"
1280 "Seafood and other miscellaneous foods, n.e.c."
1290 "Not specified food industries"
1370 "Beverage manufacturing"
1390 "Tobacco manufacturing"
1470 "Fiber, yarn, and thread mills"
1480 "Fabric mills, except knitting"
1490 "Textile and fabric finishing and coating mills"
1570 "Carpet and rug mills"
1590 "Textile product mills, except carpet and rug"
1670 "Knitting mills, and apparel knitting mills"
1691 "Cut and sew, and apparel accessories and other apparel manufacturing"
1770 "Footwear manufacturing"
1790 "Leather tanning and finishing and other allied products manufacturing"
3770 "Sawmills and wood preservation"
3780 "Veneer, plywood, and engineered wood products"
3790 "Prefabricated wood buildings and mobile homes"
3875 "Miscellaneous wood products"
1870 "Pulp, paper, and paperboard mills"
1880 "Paperboard containers and boxes"
1890 "Miscellaneous paper and pulp products"
1990 "Printing and related support activities"
2070 "Petroleum refining"
2090 "Miscellaneous petroleum and coal products"
2170 "Resin, synthetic rubber and fibers, and filaments manufacturing"
2180 "Agricultural chemical manufacturing"
2190 "Pharmaceutical and medicine manufacturing"
2270 "Paint, coating, and adhesives manufacturing"
2280 "Soap, cleaning compound, and cosmetic manufacturing"
2290 "Industrial and miscellaneous chemicals"
2370 "Plastics product manufacturing"
2380 "Tire manufacturing"
2390 "Rubber product, except tire, manufacturing"
2470 "Pottery, ceramics, and plumbing fixture manufacturing"
2480 "Structural clay product manufacturing"
2490 "Glass and glass product manufacturing"
2570 "Cement, concrete, lime, and gypsum product manufacturing"
2590 "Miscellaneous nonmetallic mineral product manufacturing"
2670 "Iron and steel mills and steel product manufacturing"
2680 "Aluminum production and processing"
2690 "Nonferrous metal (except aluminum) production and processing"
2770 "Foundries"
2780 "Metal forgings and stampings"
2790 "Cutlery and hand tool manufacturing"
2870 "Structural metals, and boiler, tank, and shipping container manufacturing"
2880 "Machine shops; turned product; screw, nut, and bolt manufacturing"
2890 "Coating, engraving, heat treating and allied activities"
2970 "Ordnance"
2980 "Miscellaneous fabricated metal products manufacturing"
2990 "Not specified metal industries"
3070 "Agricultural implement manufacturing"
3080 "Construction, and mining and oil and gas field machinery manufacturing"
3095 "Commercial and service industry machinery manufacturing"
3170 "Metalworking machinery manufacturing"
3180 "Engines, turbines, and power transmission equipment manufacturing"
3191 "Machinery manufacturing, n.e.c. or not specified"
3365 "Computer and peripheral equipment manufacturing"
3370 "Communications, and audio and video equipment manufacturing"
3380 "Navigational, measuring, electromedical, and control instruments manufacturing"
3390 "Electronic component and product manufacturing, n.e.c."
3470 "Household appliance manufacturing"
3490 "Electrical lighting and electrical equipment manufacturing, and other electrical component manufacturing, n.e.c."
3570 "Motor vehicles and motor vehicle equipment manufacturing"
3580 "Aircraft and parts manufacturing"
3590 "Aerospace product and parts manufacturing"
3670 "Railroad rolling stock manufacturing"
3680 "Ship and boat building"
3690 "Other transportation equipment manufacturing"
3895 "Furniture and related product manufacturing"
3960 "Medical equipment and supplies manufacturing"
3970 "Sporting and athletic goods, and doll, toy and game manufacturing"
3980 "Miscellaneous manufacturing, n.e.c."
3990 "Not specified manufacturing industries"
4070 "Motor vehicles, parts and supplies, merchant wholesalers"
4080 "Furniture and home furnishing, merchant wholesalers"
4090 "Lumber and other construction materials, merchant wholesalers"
4170 "Professional and commercial equipment and supplies, merchant wholesalers"
4180 "Metals and minerals, except petroleum, merchant wholesalers"
4195 "Electrical and electronic goods, merchant wholesalers"
4265 "Hardware, plumbing and heating equipment, and supplies, merchant wholesalers"
4270 "Machinery, equipment, and supplies, merchant wholesalers"
4280 "Recyclable material, merchant wholesalers"
4290 "Miscellaneous durable goods, merchant wholesalers"
4370 "Paper and paper products, merchant wholesalers"
4380 "Drugs, sundries, and chemical and allied products, merchant wholesalers"
4390 "Apparel, fabrics, and notions, merchant wholesalers"
4470 "Groceries and related products, merchant wholesalers"
4480 "Farm product raw materials, merchant wholesalers"
4490 "Petroleum and petroleum products, merchant wholesalers"
4560 "Alcoholic beverages, merchant wholesalers"
4570 "Farm supplies, merchant wholesalers"
4580 "Miscellaneous nondurable goods, merchant wholesalers"
4585 "Wholesale electronics markets, agents and brokers"
4590 "Not specified wholesale trade"
4670 "Automobile dealers"
4680 "Other motor vehicle dealers"
4690 "Auto parts, accessories, and tire stores"
4770 "Furniture and home furnishings stores"
4780 "Household appliance stores"
4795 "Radio, TV, and computer stores"
4870 "Building material and supplies dealers"
4880 "Hardware stores"
4890 "Lawn and garden equipment and supplies stores"
4971 "Supermarkets and other grocery (except convenience) stores"
4972 "Convenience stores"
4980 "Specialty food stores"
4990 "Beer, wine, and liquor stores"
5070 "Pharmacies and drug stores"
5080 "Health and personal care, except drug, stores"
5090 "Gasoline stations"
5170 "Clothing stores"
5180 "Shoe stores"
5190 "Jewelry, luggage, and leather goods stores"
5275 "Sporting goods, camera, and hobby and toy stores"
5280 "Sewing, needlework and piece goods stores"
5295 "Music stores"
5370 "Book stores and news dealers"
5381 "Department stores"
5391 "General merchandise stores, including warehouse clubs and supercenters"
5390 "Miscellaneous general merchandise stores"
5470 "Retail florists"
5480 "Office supplies and stationery stores"
5490 "Used merchandise stores"
5570 "Gift, novelty, and souvenir shops"
5580 "Miscellaneous retail stores"
5593 "Electronic shopping and mail-order houses"
5670 "Vending machine operators"
5680 "Fuel dealers"
5690 "Other direct selling establishments"
5790 "Not specified retail trade"
6070 "Air transportation"
6080 "Rail transportation"
6090 "Water transportation"
6170 "Truck transportation"
6180 "Bus service and urban transit"
6190 "Taxi and limousine service"
6270 "Pipeline transportation"
6280 "Scenic and sightseeing transportation"
6290 "Services incidental to transportation"
6370 "Postal Service"
6380 "Couriers and messengers"
6390 "Warehousing and storage"
570 "Electric power generation, transmission and distribution"
580 "Natural gas distribution"
590 "Electric and gas, and other combinations"
670 "Water, steam, air conditioning, and irrigation systems"
680 "Sewage treatment facilities"
690 "Not specified utilities"
6470 "Newspaper publishers"
6480 "Periodical, book, and directory publishers"
6490 "Software publishers"
6570 "Motion pictures and video industries"
6590 "Sound recording industries"
6670 "Radio and television broadcasting and cable subscription programming"
6672 "Internet publishing and broadcasting and web search portals"
6680 "Wired telecommunications carriers"
6690 "Other telecommunication services"
6695 "Data processing, hosting, and related services"
6770 "Libraries and archives"
6780 "Other information services"
6870 "Banking and related activities"
6880 "Savings institutions, including credit unions"
6890 "Non-depository credit and related activities"
6970 "Securities, commodities, funds, trusts, and other financial investments"
6991 "Insurance carriers"
6992 "Agencies, brokerages, and other insurance related activities"
7071 "Lessors of real estate, and offices of real estate agents and brokers"
7072 "Real estate property managers, offices of real estate appraisers, and other activities related to real estate"
7080 "Automotive equipment rental and leasing"
7181 "Other consumer goods rental"
7190 "Commercial, industrial, and other intangible assets rental and leasing"
7270 "Legal services"
7280 "Accounting, tax preparation, bookkeeping and payroll services"
7290 "Architectural, engineering, and related services"
7370 "Specialized design services"
7380 "Computer systems design and related services"
7390 "Management, scientific and technical consulting services"
7460 "Scientific research and development services"
7470 "Advertising and related services"
7480 "Veterinary services"
7490 "Other professional, scientific and technical services"
7570 "Management of companies and enterprises"
7580 "Employment services"
7590 "Business support services"
7670 "Travel arrangements and reservation services"
7680 "Investigation and security services"
7690 "Services to buildings and dwellings"
7770 "Landscaping services"
7780 "Other administrative and other support services"
7790 "Waste management and remediation services"
7860 "Elementary and secondary schools"
7870 "Colleges and universities, including junior colleges"
7880 "Business, technical, and trade schools and training"
7890 "Other schools and instruction, and educational support services"
7970 "Offices of physicians"
7980 "Offices of dentists"
7990 "Office of chiropractors"
8070 "Offices of optometrists"
8080 "Offices of other health practitioners"
8090 "Outpatient care centers"
8170 "Home health care services"
8180 "Other health care services"
8191 "General medical and surgical hospitals, and specialty (except psychiatric and substance abuse) hospitals"
8192 "Psychiatric and substance abuse hospitals"
8270 "Nursing care facilities"
8290 "Residential care facilities, without nursing"
8370 "Individual and family services"
8380 "Community food and housing, and emergency services"
8390 "Vocational rehabilitation services"
8470 "Child day care services"
8561 "Performing arts companies"
8562 "Spectator sports"
8563 "Promoters of performing arts, sports, and similar events, agents and managers for artists,athletes, entertainers, and other public figures"
8564 "Independent artists, writers, and performers"
8570 "Museums, art galleries, historical sites, and similar institutions"
8580 "Bowling centers"
8590 "Other amusement, gambling, and recreation industries"
8660 "Traveler accommodation"
8670 "Recreational vehicle parks and camps, and rooming and boarding houses"
8680 "Restaurants and other food services"
8690 "Drinking places, alcoholic beverages"
8770 "Automotive repair and maintenance"
8780 "Car washes"
8790 "Electronic and precision equipment repair and maintenance"
8870 "Commercial and industrial machinery and equipment repair and maintenance"
8891 "Personal and household goods repair and maintenance"
8970 "Barber shops"
8980 "Beauty salons"
8990 "Nail salons and other personal care services"
9070 "Dry cleaning and laundry services"
9080 "Funeral homes, and cemeteries and crematories"
9090 "Other personal services"
9160 "Religious organizations"
9170 "Civic, social, advocacy organizations, and grantmaking and giving services"
9180 "Labor unions"
9190 "Business, professional, political, and similar organizations"
9290 "Private households"
9370 "Executive offices and legislative bodies"
9380 "Public finance activities"
9390 "Other general government and support"
9470 "Justice, public order, and safety activities"
9480 "Administration of human resource programs"
9490 "Administration of environmental quality and housing programs"
9570 "Administration of economic programs and space research"
9590 "National security and international affairs"
9890 "Armed Forces"
;
#delimit cr;
lab val ind17 ind17
label var ind17 "2017 Census Industry Classification"
notes ind17: Industry classification for 2020-present
notes ind17: 2020-present CPS: peio1icd
