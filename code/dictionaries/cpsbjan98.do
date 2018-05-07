/*------------------------------------------------
  by Jean Roth Fri Sep  2 10:30:54 EDT 2011
  Please report errors to jroth@nber.org
  NOTE:  This program is distributed under the GNU GPL. 
  See end of this file and http://www.gnu.org/licenses/ for details.
  Run with do cpsbjan98
----------------------------------------------- */

local dat_name "`1'"
local dct_name "`2'"

/* The line below does NOT need to be changed */

quietly infile using "`dct_name'", using("`dat_name'") clear

/*------------------------------------------------

  All items, except those with one character, also can have values
  of -1, -2, or -3 even if the values are not in the documentation
  The meaning is
       -1 .Blank or not in universe
       -2 .Don't know
       -3 .Refused

  The following changes in variable names have been made, if necessary:
      '$' to 'd';            '-' to '_';              '%' to 'p';
      ($ = unedited data;     - = edited data;         % = allocated data)

  Decimal places have been made explict in the dictionary file.  
  Stata resolves a missing value of -1 / # of decimal places as a missing value.  
 -----------------------------------------------*/

** These note statements incorporate variable universes into the Stata data file.
note: by Jean Roth, jroth@nber.org Fri Sep  2 10:30:54 EDT 2011
note hrmonth: U All Households in Sample 
note hurespli: U All Households
note hetelhhd: U All Hhlds In Sample 
note hephoneo: U HETELHHD=2 
note hufaminc: U HETELHHD=1 Or HETELAVL=1 
note geindvcc: U All 
note gemsasz: U All Households in Sample Valid 
note hulensec: U All 
note peparent: U Every Person Valid 
note peage: U all 
note ptage: U PRPERTYP = 1, 2, 
note pesex: U All<BR> Valid 
note puafever: U Every Person Valid Entries 
note peafnow: U AFEVER=1 Valid Entries 
note peeduca: U PEAGE&gt;=15 And PEAGE&lt;=65 
note puslfprx: U PRCITSHP = 2, 3, 4, or 5 Valid 
note puwk: U PRPERTYP=2 Valid Entries 
note pudis1: U PEMLR=5 
note pemjot: U PEABSRSN=4-12,14 Valid Entries 
note pemjnum: U PEMLR=1,2 Valid 
note pehrusl1: U PEMJOT=1 Valid Entries 
note pehrusl2: U PEMJOT=1,2 (PEMLR=1,2) 
note pehrftpt: U PEMJOT=1 
note pehrwant: U PEMLR=1,2 Valid Entries 
note pehrrsn1: U PEHRUSLT=0-34 (PEMLR=1) Valid 
note pehrrsn2: U PEHRWANT=1 
note pehrrsn3: U PEHRWANT=2 
note puhroff1: U PEHRACTT=1-34 And 
note pehract2: U PEMLR=1 (PEMJOT=1,2) Valid 
note pehractt: U PEMLR=1 (PEMJOT=1) Valid 
note pehravl: U PEMLR=1 Valid Entries 
note pulbhsec: U PEHRACTT=1-34 
note pulayavr: U PEMLR=3 Valid Entries 
note pelayfto: U Pelklwo=1-3 Valid Entries 
note pulayck1: U PELAYDUR=0-120 Valid Entries 
note pulkm2: U PEMLR=4 Valid Entries 
note pelkll2o: U Pelkavl=1,2 Valid Entries 
note pelklwo: U PELKLL1O=1,3 Valid 
note pelkfto: U Pelklwo=1-3 Valid Entries 
note pedwrsn: U PUDWCK1=3,4,-1 Valid 
note pedwlko: U PUDWCK4=4,-1 Valid 
note pedw4wk: U PEDWLKO=1 Valid Entries 
note pedwlkwk: U PEDWWK=1 
note pedwavl: U PEDW4WK=2 Valid Entries 
note pedwavr: U (PEDWWK=2) or (PEDWLKWK=1) 
note pudwck1: U PEDWAVL=2 Valid Entries 
note pujhdp1o: U HRMIS=4,8 Valid 
note pejhwant: U PEJHWKO=1 
note puio1mfg: U (PEMLR=1-3) Or 
note peio1ocd: U (PEMLR=1-3) Or (PEMLR=4 And 
note peio2cow: U (PEMLR=1-3) Or 
note peio2ocd: U PEMJOT=1 And HRMIS=4,8 
note puiock1: U PEMJOT=1 And HRMIS=4,8 Valid 
note peernper: U (PUERNCK=3 And PEIO1COW Ne 6-8) 
note peernhry: U PEERNPER=2-7 Valid 
note penlfjh: U (PUERNCK=3 And PEIO1COW Ne 6-8) 
note penlfret: U HRMIS=4,8 
note penlfact: U PEAGE=50+ Valid Entries 
note peschft: U (PRPERTYP=2 and 
note prnlfsch: U PESCHENR=1 Valid Entries 
note prnmchld: U PRFAMREL = 1 or 2
note prwernal: U PRFAMREL = 1 or 2
note pxsex: U (PEDWWK=2) or (PEDWLKWK=1) 
note pxafwhen: U PEDWWK=1 
note pxnatvty: U PEABSRSN=4-12,14 Valid Entries 
note pxhrusl2: U (PEMLR=1-3) Or 
note pxhrftpt: U (PEMLR=1-3) Or (PEMLR=4 And 
note pxhrwant: U (PEMLR=1-3) Or 
note pxjhwant: U PEMJOT=1 And HRMIS=4,8 
note pxio1cow: U PEMJOT=1 And HRMIS=4,8 Valid 
note pehgcomp: U PEEDUCA = 39
note pecyc: U PEDIPGED = 2
note pegrprof: U PEEDUCA = 40-42
note pegr6cor: U PEEDUCA = 43
note pems123: U PEGRPROF = 1
note pxdipged: U PEEDUCA = 44
note pxhgcomp: U PEEDUCA = 39
note pxcyc: U PEDIPGED = 2
note pxgrprof: U PEEDUCA = 40-42
note pxgr6cor: U PEEDUCA = 43
note pxms123: U PEGRPROF = 1
note pwcmpwgt: U PEEDUCA = 44
*Everything below this point, aside from the final save, are value labels

#delimit ;

;
label values hrmonth  hrmonth;
label define hrmonth 
	1           "January"                                 
	2           "February"                                
	3           "March"                                   
	4           "April"                                   
	5           "May"                                     
	6           "June"                                    
	7           "July"                                    
	8           "August"                                  
	9           "September"                               
	10          "October"                                 
	11          "November"                                
	12          "December"                                
;
label values hurespli hurespli;
label define hurespli
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values huspnish huspnish;
label define huspnish
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Spanish Only Language Spoken"            
;
label values hetenure hetenure;
label define hetenure
	1           "Owned or being bought by a HH"           
	2           "Rented for cash"                         
	3           "Occupied without payment of cash"        
;
label values hehousut hehousut;
label define hehousut
	0           "Other Unit"                              
	1           "House, Apartment, Flat"                  
	2           "HU In Nontransient Hotel, Motel,"        
	3           "HU Permanent In Transient Hotel,"        
	4           "HU In Rooming House"                     
	5           "Mobile Home Or Trlr W/No Perm Rm"        
	6           "Mh Or Trlr W/1 Or More Perm Rms"         
	7           "HU Not Specified Above"                  
	8           "Quarters Not HU In Rooming Or"           
	9           "Unit Not Perm. In Transient"             
	10          "Unoccupied Tent Site Or Trlr"            
	11          "Student Quarters In College Dorm"        
	12          "Other Unit Not Specified Above"          
;
label values hetelhhd hetelhhd;
label define hetelhhd
	1           "Yes"                                     
	2           "No"                                      
;
label values hetelavl hetelavl;
label define hetelavl
	1           "Yes"                                     
	2           "No"                                      
;
label values hephoneo hephoneo;
label define hephoneo
	0           "Unknown"                                 
	1           "Yes"                                     
	2           "No"                                      
;
label values hufaminc hufaminc;
label define hufaminc
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Less Than $5,000"                        
	2           "5,000 To 7,499"                          
	3           "7,500 To 9,999"                          
	4           "10,000 To 12,499"                        
	5           "12,500 To 14,999"                        
	6           "15,000 To 19,999"                        
	7           "20,000 To 24,999"                        
	8           "25,000 To 29,999"                        
	9           "30,000 To 34,999"                        
	10          "35,000 To 39,999"                        
	11          "40,000 To 49,999"                        
	12          "50,000 To 59,999"                        
	13          "60,000 To 74,999"                        
	14          "75,000 Or More"                          
;
label values hutypea  hutypea;
label define hutypea 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "No One Home (NOH)"                       
	2           "Temporarily Absent (TA)"                 
	3           "Refused (REF)"                           
	4           "Other Occupied - Specify"                
;
label values hutypb   hutypb; 
label define hutypb  
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Vacant Regular"                          
	2           "Temporarily Occupied By Persons"         
	3           "Vacant-Storage Of Hhld Furniture"        
	4           "Unfit Or To Be Demolished"               
	5           "Under Construction, Not Ready"           
	6           "Converted To Temp Business Or"           
	7           "Unoccupied Tent Site Or Trailer"         
	8           "Permit Granted Construction Not"         
	9           "Other Type B - Specify"                  
;
label values hutypc   hutypc; 
label define hutypc  
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Demolished"                              
	2           "House Or Trailer Moved"                  
	3           "Outside Segment"                         
	4           "Coverted To Perm. Business Or"           
	5           "Merged"                                  
	6           "Condemned"                               
	8           "Unused Line Of Listing Sheet"            
	9           "Other - Specify"                         
;
label values hrintsta hrintsta;
label define hrintsta
	1           "Interview"                               
	2           "Type A Non-Interview"                    
	3           "Type B Non-Interview"                    
	4           "Type C Non-Interview"                    
;
label values hrhtype  hrhtype;
label define hrhtype 
	-1          "In Universe, Met No Conditions"          
	0           "Non-Interview Household"                 
	1           "Husband/Wife Primary"                    
	2           "Husb/Wife Prim."                         
	3           "Unmarried Civilian Male-Prim Fam"        
	4           "Unmarried Civ. Female-Prim Fam"          
	5           "Primary Family Hhlder-Rp In"             
	6           "Civilian Male Primary Individual"        
	7           "Civilian Female Primary"                 
	8           "Primary Individual Hhld-Rp In AF"        
	9           "Group Quarters With Family"              
	10          "Grp Quarters Without Family"             
;
label values hrmis    hrmis;  
label define hrmis   
	1           "MIS 1"                                   
	2           "MIS 2"                                   
	3           "MIS 3"                                   
	4           "MIS 4"                                   
	5           "MIS 5"                                   
	6           "MIS 6"                                   
	7           "MIS 7"                                   
	8           "MIS 8"                                   
;
label values huinttyp huinttyp;
label define huinttyp
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Personal"                                
	2           "Telephone"                               
;
label values huprscnt huprscnt;
label define huprscnt
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values hrlonglk hrlonglk;
label define hrlonglk
	-1          "In Universe, Met No Conditions"          
	0           "MIS 1 Or Replacement HH (no"             
	2           "MIS 2-4 Or MIS 6-8 (link To"             
	3           "MIS 5 (link To Db03)"                    
;
label values huhhnum  huhhnum;
label define huhhnum 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values hubus    hubus;  
label define hubus   
	1           "Yes"                                     
	2           "No"                                      
;
label values hubusl2  hubusl2l;
label define hubusl2l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values hubusl3  hubusl3l;
label define hubusl3l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values hubusl4  hubusl4l;
label define hubusl4l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values gereg    gereg;  
label define gereg   
	1           "Northeast"                               
	2           "Midwest (formerly North Central)"        
	3           "South"                                   
	4           "West"                                    
;
label values gecmsa   gecmsa; 
label define gecmsa  
	0           "Not Identified or"                       
	7           "Boston-Worcester-Lawrence,"              
	14          "Chicago-Gary-Kenosha, IL-IN-WI"          
	21          "Cincinnati-Hamilton, OH-KY-IN"           
	28          "Cleveland-Akron, OH"                     
	31          "Dallas-Fort Worth, TX"                   
	34          "Denver-Boulder-Greeley, CO"              
	35          "Detroit-Ann Arbor-Flint, MI"             
	42          "Houston-Galveston-Brazoria, TX"          
	49          "Los Angeles-Riverside-Orange"            
	56          "Miami-Fort Lauderdale, FL"               
	63          "Milwaukee-Racine, WI"                    
	70          "New York-Northern New"                   
	77          "Philadelphia-Wilmington-Atlantic"        
	79          "Portland-Salem, OR-WA"                   
	82          "Sacramento-Yolo, CA"                     
	84          "San Francisco-Oakland-San Jose,"         
	91          "Seattle-Tacoma-Bremerton, WA"            
	97          "Washington-Baltimore,"                   
;
label values gemsast  gemsast;
label define gemsast 
	1           "Central City"                            
	2           "Balance On MSA"                          
	3           "Non-Metropolitan"                        
	4           "Not Identified"                          
;
label values gemetsta gemetsta;
label define gemetsta
	1           "Metropolitan"                            
	2           "Nonmetropolitan"                         
	3           "Not Identified"                          
;
label values geindvcc geindvcc;
label define geindvcc
	0           "Not Identified or"                       
;
label values gemsasz  gemsasz;
label define gemsasz 
	0           "Not Identified or"                       
	2           "100,000 - 249,999"                       
	3           "250,000 - 499,999"                       
	4           "500,000 - 999,999"                       
	5           "1,000,000 - 2,499,999"                   
	6           "2,500,000 - 4,999,999"                   
	7           "5,000,000+"                              
;
label values gecmsasz gecmsasz;
label define gecmsasz
	0           "Not Identified Or"                       
	2           "100,000 - 249,999"                       
	3           "250,000 - 499,999"                       
	4           "500,000 - 999,999"                       
	5           "1,000,000 - 2,499,999"                   
	6           "2,500,000 - 4,999,999"                   
	7           "5,000,000+"                              
;
label values hulensec hulensec;
label define hulensec
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values proldrrp proldrrp;
label define proldrrp
	1           "Ref Pers W/ Rels"                        
	2           "Ref Pers W/O Rels"                       
	3           "Spouse"                                  
	4           "Child"                                   
	5           "Grandchild"                              
	6           "Parent"                                  
	7           "Brother/Sister"                          
	8           "Other Rel Of Ref Per"                    
	9           "Foster Child"                            
	10          "Nonrel Of Ref Per W/ Own Rels In"        
	11          "Partner/Roommate"                        
	12          "Nonrel. of ref per W/O Own Rels"         
;
label values pupelig  pupelig;
label define pupelig 
	1           "Eligible For Interview"                  
	2           "Labor Force Fully Complete"              
	3           "Missing Labor Force Data For"            
	4           "(Not Used)"                              
	5           "Assigned If Age Is Blank"                
	6           "Armed Forces Member"                     
	7           "Under 15 Years Old"                      
	8           "Not a HH Member"                         
	9           "Deleted"                                 
	10          "Deceased"                                
	11          "End Of List"                             
	12          "After End Of List"                       
;
label values perrp    perrp;  
label define perrp   
	1           "Ref Pers with other relativew in"        
	2           "Ref pers with no other relatives"        
	3           "Spouse"                                  
	4           "Child"                                   
	5           "Grandchild"                              
	6           "Parent"                                  
	7           "Brother/sister"                          
	8           "Other relative"                          
	9           "Foster child"                            
	10          "Non-rel of ref. per w/own rels"          
	11          "Not used"                                
	12          "Non-rel of ref per w/no own rels"        
	13          "Unmarried partner w/ own rels in"        
	14          "Unmar. partner w/ no own rels in"        
	15          "Housemate/roommate w/ own rels"          
	16          "Hsemate/roommate w/ no own rels"         
	17          "Roomer/boarder w/ own rels in HH"        
	18          "Roomer/brder w/ no own rels in"          
;
label values ptage    ptage;  
label define ptage   
	0           "No Top Code"                             
	1           "Top Coded Value For Age"                 
;
label values pemaritl pemaritl;
label define pemaritl
	1           "Married - Spouse Present"                
	2           "Married-Spouse Absent"                   
	3           "Widowed"                                 
	4           "Divorced"                                
	5           "Separated"                               
	6           "Never Married"                           
;
label values pesex    pesex;  
label define pesex   
	1           "Male"                                    
	2           "Female"                                  
;
label values puafever puafever;
label define puafever
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values peafwhen peafwhen;
label define peafwhen
	1           "Vietnam Era (8/64-4/75)"                 
	2           "Korean War (6/50-1/55)"                  
	3           "World War II (9/40-7/47)"                
	4           "World War I (4/17-11/18)"                
	5           "Other Service (all Other"                
	6           "Nonveteran"                              
;
label values peafnow  peafnow;
label define peafnow 
	1           "Yes"                                     
	2           "No"                                      
;
label values peeduca  peeduca;
label define peeduca 
	31          "Less Than 1st Grade"                     
	32          "1st,2nd,3rd Or 4th Grade"                
	33          "5th Or 6th Grade"                        
	34          "7th Or 8th Grade"                        
	35          "9th Grade"                               
	36          "10th Grade"                              
	37          "11th Grade"                              
	38          "12th Grade No Diploma"                   
	39          "High School Grad-Diploma Or"             
	40          "Some College But No Degree"              
	41          "Associate"                               
	42          "Associate Deg.-Academic Program"         
	43          "Bachelor's Degree(ex:ba,ab,bs)"          
	44          "Master's"                                
	45          "Professional School"                     
	46          "Doctorate Degree(ex:PhD,EdD)"            
;
label values perace   perace; 
label define perace  
	1           "White"                                   
	2           "Black"                                   
	3           "American Indian, Aleut, Eskimo"          
	4           "Asian or Pacific Islander"               
;
label values prorigin prorigin;
label define prorigin
	1           "Mexican American"                        
	2           "Chicano"                                 
	3           "Mexican (Mexicano)"                      
	4           "Puerto Rican"                            
	5           "Cuban"                                   
	6           "Central Or South American"               
	7           "Other Spanish"                           
	8           "All Other"                               
	9           "Don't Know"                              
	10          "NA"                                      
;
label values puchinhh puchinhh;
label define puchinhh
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Person Added"                            
	2           "Person Added - URE"                      
	3           "Person Undeleted"                        
	4           "Person Died"                             
	5           "Deleted For Reason Other Than"           
	6           "Person Joined Armed Forces"              
	7           "Person No Longer In AF"                  
	9           "Change In Demographic"                   
;
label values purelflg purelflg;
label define purelflg
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	0           "Not owner or related to owner"           
	1           "Owner of bus or related to owner"        
;
label values pulineno pulineno;
label define pulineno
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values prfamrel prfamrel;
label define prfamrel
	0           "Not A Family Member"                     
	1           "Reference Person"                        
	2           "Spouse"                                  
	3           "Child"                                   
	4           "Other Relative (primary Family"          
;
label values prfamtyp prfamtyp;
label define prfamtyp
	1           "Primary Family"                          
	2           "Primary Individual"                      
	3           "Related Subfamily"                       
	4           "Unrelated Subfamily"                     
	5           "Secondary Individual"                    
;
label values prhspnon prhspnon;
label define prhspnon
	1           "Hispanic"                                
	2           "Non-Hipsanic"                            
;
label values prmarsta prmarsta;
label define prmarsta
	-1          "In Universe, Met No Conditions"          
	1           "Married, Civilian Spouse Present"        
	2           "Married, Armed Forces Spouse"            
	3           "Married, Spouse Absent (exc."            
	4           "Widowed"                                 
	5           "Divorced"                                
	6           "Separated"                               
	7           "Never Married"                           
;
label values prpertyp prpertyp;
label define prpertyp
	-1          "In Universe, Met No Conditions"          
	1           "Child Household Member"                  
	2           "Adult Civilian Household Member"         
	3           "Adult Armed Forces Household"            
	4           "Non-Household Member"                    
;
label values prcitshp prcitshp;
label define prcitshp
	1           "Native, Born In US"                      
	2           "Native, Born in PR or US"                
	3           "Native, Born Abroad Of US"               
	4           "Foreign Born, US Cit By"                 
	5           "Foreign Born, Not a US Citizen"          
;
label values prinusyr prinusyr;
label define prinusyr
	-1          "Not In Universe (Born In U.S.)"          
	0           "Not Foreign Born"                        
	1           "Before 1950"                             
	2           "1950-1959"                               
	3           "1960-1964"                               
	4           "1965-1969"                               
	5           "1970-1974"                               
	6           "1975-1979"                               
	7           "1980-1981"                               
	8           "1982-1983"                               
	9           "1984-1985"                               
	10          "1986-1987"                               
	11          "1988-1989"                               
	12          "1990-1991"                               
	13          "1992-1993"                               
	14          "1994-1997"                               
;
label values puslfprx puslfprx;
label define puslfprx
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Self"                                    
	2           "Proxy"                                   
	3           "Both self and proxy"                     
;
label values pemlr    pemlr;  
label define pemlr   
	1           "Employed-At Work"                        
	2           "Employed-Absent"                         
	3           "Unemployed-On Layoff"                    
	4           "Unemployed-Looking"                      
	5           "Retired-Not In Labor Force"              
	6           "Disabled-Not In Labor Force"             
	7           "Other-Not In Labor Force"                
;
label values puwk     puwk;   
label define puwk    
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
	3           "Retired"                                 
	4           "Disabled"                                
	5           "Unable To Work"                          
;
label values pubus1   pubus1l;
label define pubus1l 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values pubus2ot pubus2ot;
label define pubus2ot
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values pubusck1 pubuscka;
label define pubuscka
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUBUS1"                             
	2           "Goto PURETCK1"                           
;
label values pubusck2 pubusckb;
label define pubusckb
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUHRUSL1"                           
	2           "Goto PUBUS2"                             
;
label values pubusck3 pubusckc;
label define pubusckc
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUABSRSN"                           
	2           "Goto PULAY"                              
;
label values pubusck4 pubusckd;
label define pubusckd
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUHRUSL1"                           
	2           "Goto PUABAPD"                            
;
label values puretot  puretot;
label define puretot 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
	3           "Was not retired last month"              
;
label values pudis    pudis;  
label define pudis   
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
	3           "Did Not Have Disability Last"            
;
label values peret1   peret1l;
label define peret1l 
	1           "Yes"                                     
	2           "No"                                      
	3           "Has a job"                               
;
label values pudis1   pudis1l;
label define pudis1l 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values pudis2   pudis2l;
label define pudis2l 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values puabsot  puabsot;
label define puabsot 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
	3           "Retired"                                 
	4           "Disabled"                                
	5           "Unable To Work"                          
;
label values pulay    pulay;  
label define pulay   
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
	3           "Retired"                                 
	4           "Disabled"                                
	5           "Unable To Work"                          
;
label values peabsrsn peabsrsn;
label define peabsrsn
	1           "On Layoff"                               
	2           "Slack Work/Business Conditions"          
	3           "Waiting For A New Job To Begin"          
	4           "Vacation/Personal Days"                  
	5           "Own Illness/Injury/Medical"              
	6           "Child Care Problems"                     
	7           "Other Family/Personal Obligation"        
	8           "Maternity/Paternity Leave"               
	9           "Labor Dispute"                           
	10          "Weather Affected Job"                    
	11          "School/Training"                         
	12          "Civic/Military Duty"                     
	13          "Does Not Work In The Business"           
	14          "Other (specify)"                         
;
label values peabspdo peabspdo;
label define peabspdo
	1           "Yes"                                     
	2           "No"                                      
;
label values pemjot   pemjot; 
label define pemjot  
	1           "Yes"                                     
	2           "No"                                      
;
label values pemjnum  pemjnum;
label define pemjnum 
	-1          "Not in Universe"                         
	2           "2 Jobs"                                  
	3           "3 Jobs"                                  
	4           "4 Or More Jobs"                          
;
label values pehrusl1 pehrusla;
label define pehrusla
	-4          "Hours vary"                              
;
label values pehrusl2 pehruslb;
label define pehruslb
	-4          "Hours vary"                              
;
label values pehrftpt pehrftpt;
label define pehrftpt
	-1          "Not in Universe"                         
	1           "Yes"                                     
	2           "No"                                      
	3           "Hours Vary"                              
;
label values pehrwant pehrwant;
label define pehrwant
	1           "Yes"                                     
	2           "No"                                      
	3           "Regular Hours Are Full-Time"             
;
label values pehrrsn1 pehrrsna;
label define pehrrsna
	1           "Slack Work/Business Conditions"          
	2           "Could Only Find Part-Time Work"          
	3           "Seasonal Work"                           
	4           "Child Care Problems"                     
	5           "Other Family/Personal"                   
	6           "Health/Medical Limitations"              
	7           "School/Training"                         
	8           "Retired/Social Security Limit On"        
	9           "Full-Time Workweek Is Less Than"         
	10          "Other - Specify"                         
;
label values pehrrsn2 pehrrsnb;
label define pehrrsnb
	1           "Child Care Problems"                     
	2           "Other Family/Personal"                   
	3           "Health/Medical Limitiations"             
	4           "School/Training"                         
	5           "Retired/Social Security Limit On"        
	6           "Full-Time Workweek Less Than 35"         
	7           "Other - Specify"                         
;
label values pehrrsn3 pehrrsnc;
label define pehrrsnc
	1           "Slack Work/Business Conditions"          
	2           "Seasonal Work"                           
	3           "Job Started Or Ended During Week"        
	4           "Vacation/Personal Day"                   
	5           "Own Illness/Injury/Medical"              
	6           "Holiday (legal Or Religious)"            
	7           "Child Care Problems"                     
	8           "Other Family/Personal"                   
	9           "Labor Dispute"                           
	10          "Weather Affected Job"                    
	11          "School/Training"                         
	12          "Civic/Military Duty"                     
	13          "Other Reason"                            
;
label values puhroff1 puhroffa;
label define puhroffa
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values puhroff2 puhroffb;
label define puhroffb
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values puhrot1  puhrot1l;
label define puhrot1l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values puhrot2  puhrot2l;
label define puhrot2l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values pehravl  pehravl;
label define pehravl 
	1           "Yes"                                     
	2           "No"                                      
;
label values pulbhsec pulbhsec;
label define pulbhsec
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values puhrck1  puhrck1l;
label define puhrck1l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUHRUSL2"                           
	2           "Goto PUHRUSLT"                           
;
label values puhrck2  puhrck2l;
label define puhrck2l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUHRFTPT"                           
	2           "Go To PUHRFTPT"                          
	3           "Go to PUHRFTPT"                          
	4           "go to PUHRFTPT"                          
	5           "Goto PUHRCK3"                            
;
label values puhrck3  puhrck3l;
label define puhrck3l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUHRCK8"                            
	2           "Go To PUHRCK8"                           
	3           "Goto PUHRACT1"                           
	4           "Goto PUHRCK4"                            
	5           "Goto PUHROFF1"                           
	6           "Go To PUHRCK4"                           
;
label values puhrck4  puhrck4l;
label define puhrck4l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUHRACT1"                           
	2           "Goto PUHROFF1"                           
	3           "Goto PUHRWANT"                           
	4           "Go to PUHRWANT"                          
	5           "Go to PUHRACT1"                          
;
label values puhrck5  puhrck5l;
label define puhrck5l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUHRACT2"                           
	2           "Goto PUHRCK6"                            
;
label values puhrck6  puhrck6l;
label define puhrck6l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PULK"                               
	2           "Goto PUABSRSN"                           
	3           "Goto PUHRACTT"                           
;
label values puhrck7  puhrck7l;
label define puhrck7l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUHRCK8"                            
	2           "Go to PUHRCK8"                           
	3           "Goto PUHRRSN3"                           
	4           "Goto PUHRAVL"                            
	5           "Go To PUHRCK8"                           
;
label values puhrck12 puhrck1b;
label define puhrck1b
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PULK"                               
	2           "Goto PUIOCK1"                            
;
label values pulaydt  pulaydt;
label define pulaydt 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values pulay6m  pulay6m;
label define pulay6m 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values pelayavl pelayavl;
label define pelayavl
	1           "Yes"                                     
	2           "No"                                      
;
label values pulayavr pulayavr;
label define pulayavr
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Own Temporary Illness"                   
	2           "Going To School"                         
	3           "Other"                                   
;
label values pelaylk  pelaylk;
label define pelaylk 
	1           "Yes"                                     
	2           "No"                                      
;
label values pelayfto pelayfto;
label define pelayfto
	1           "Yes"                                     
	2           "No"                                      
;
label values pulayck1 pulaycka;
label define pulaycka
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PULAYCK3"                           
	2           "Goto PULAYFT"                            
	3           "Goto PULAYDR"                            
;
label values pulayck2 pulayckb;
label define pulayckb
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PULAYDR3"                           
	2           "Goto PULAYFT"                            
;
label values pulayck3 pulayckc;
label define pulayckc
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "MISCK=5 Goto IO1INT"                     
	2           "I-ICR=1 Or I-OCR=1, Goto IO1INT"         
	3           "All Others Goto SCHCK"                   
;
label values pulk     pulk;   
label define pulk    
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
	3           "Retired"                                 
	4           "Disabled"                                
	5           "Unable To Work"                          
;
label values pelkm1   pelkm1l;
label define pelkm1l 
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	12          "Nothing"                                 
	13          "Other Passive"                           
;
label values pulkm2   pulkm2l;
label define pulkm2l 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkm3   pulkm3l;
label define pulkm3l 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkm4   pulkm4l;
label define pulkm4l 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkm5   pulkm5l;
label define pulkm5l 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkm6   pulkm6l;
label define pulkm6l 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkdk1  pulkdk1l;
label define pulkdk1l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank or No"                             
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	12          "Nothing"                                 
	13          "Other Passive"                           
;
label values pulkdk2  pulkdk2l;
label define pulkdk2l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkdk3  pulkdk3l;
label define pulkdk3l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkdk4  pulkdk4l;
label define pulkdk4l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkdk5  pulkdk5l;
label define pulkdk5l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkdk6  pulkdk6l;
label define pulkdk6l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkps1  pulkps1l;
label define pulkps1l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "BLANK or NO"                             
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	12          "Nothing"                                 
	13          "Other Passive"                           
;
label values pulkps2  pulkps2l;
label define pulkps2l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkps3  pulkps3l;
label define pulkps3l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkps4  pulkps4l;
label define pulkps4l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkps5  pulkps5l;
label define pulkps5l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pulkps6  pulkps6l;
label define pulkps6l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Contacted Employer"                      
	2           "Contacted Pulbic Employment"             
	3           "Contacted Private Employment"            
	4           "Contacted Friends Or Relatives"          
	5           "Contacted School/University Empl"        
	6           "Sent Out Resumes/Filled Out"             
	7           "Checked Union/Professional"              
	8           "Placed Or Answered Ads"                  
	9           "Other Active"                            
	10          "Looked At Ads"                           
	11          "Attended Job Training"                   
	13          "Other Passive"                           
;
label values pelkavl  pelkavl;
label define pelkavl 
	1           "Yes"                                     
	2           "No"                                      
;
label values pulkavr  pulkavr;
label define pulkavr 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Waiting For New Job To Begin"            
	2           "Own Temporary Illness"                   
	3           "Going To School"                         
	4           "Other - Specify"                         
;
label values pelkll1o pelkll1o;
label define pelkll1o
	1           "Working"                                 
	2           "School"                                  
	3           "Left Military Service"                   
	4           "Something Else"                          
;
label values pelkll2o pelkll2o;
label define pelkll2o
	1           "Lost Job"                                
	2           "Quit Job"                                
	3           "Temporary Job Ended"                     
;
label values pelklwo  pelklwo;
label define pelklwo 
	1           "Within The Last 12 Months"               
	2           "More Than 12 Months Ago"                 
	3           "Never Worked"                            
;
label values pelkfto  pelkfto;
label define pelkfto 
	1           "Yes"                                     
	2           "No"                                      
	3           "Doesn't Matter"                          
;
label values pedwwnto pedwwnto;
label define pedwwnto
	1           "Yes, Or Maybe, It Depends"               
	2           "No"                                      
	3           "Retired"                                 
	4           "Disabled"                                
	5           "Unable"                                  
;
label values pedwrsn  pedwrsn;
label define pedwrsn 
	1           "Believes No Wrk Avl In Line Lk"          
	2           "Couldn't Find Any Work"                  
	3           "Lacks Necessary"                         
	4           "Employers Think Too Young Or Too"        
	5           "Other Types Of Discrimination"           
	6           "Can't Arrange Child Care"                
	7           "Family Responsibilities"                 
	8           "In School Or Other Training"             
	9           "Ill-Health, Physical Disability"         
	10          "Transportation Problems"                 
	11          "Other - Specify"                         
;
label values pedwlko  pedwlko;
label define pedwlko 
	1           "Yes"                                     
	2           "No"                                      
;
label values pedwwk   pedwwk; 
label define pedwwk  
	1           "Yes"                                     
	2           "No"                                      
;
label values pedw4wk  pedw4wk;
label define pedw4wk 
	1           "Yes"                                     
	2           "No"                                      
;
label values pedwlkwk pedwlkwk;
label define pedwlkwk
	1           "Yes"                                     
	2           "No"                                      
;
label values pedwavl  pedwavl;
label define pedwavl 
	1           "Yes"                                     
	2           "No"                                      
;
label values pedwavr  pedwavr;
label define pedwavr 
	1           "Own Temporary Illness"                   
	2           "Going To School"                         
	3           "Other"                                   
;
label values pudwck1  pudwck1l;
label define pudwck1l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUSCHCK"                            
	2           "Goto PUNLFCK1"                           
	3           "Goto PUDWCK4"                            
	4           "Goto PUDWWANT"                           
;
label values pudwck2  pudwck2l;
label define pudwck2l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUJHCK1"                            
	2           "Goto PUDIS1"                             
	3           "Goto PUDIS2"                             
	4           "Goto PUDWCK4"                            
;
label values pudwck3  pudwck3l;
label define pudwck3l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUDWCK4"                            
	2           "Goto PUNLFCK2"                           
;
label values pudwck4  pudwck4l;
label define pudwck4l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUDWCK5"                            
	2           "Go To PUDWCK5"                           
	3           "Go to PUDWCK5"                           
	4           "Goto PUDWRSN"                            
;
label values pudwck5  pudwck5l;
label define pudwck5l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUDWWK"                             
	2           "Goto PUDWLK"                             
;
label values pejhwko  pejhwko;
label define pejhwko 
	1           "Yes"                                     
	2           "No"                                      
;
label values pujhdp1o pujhdp1o;
label define pujhdp1o
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values pejhrsn  pejhrsn;
label define pejhrsn 
	1           "Personal/Family (including"              
	2           "Return To School"                        
	3           "Health"                                  
	4           "Retirement Or Old Age"                   
	5           "Temp, Seasonal Or Intermitt. Job"        
	6           "Slack Work/Business Conditions"          
	7           "Unsatis. Wrk."                           
	8           "Other - Specify"                         
;
label values pejhwant pejhwant;
label define pejhwant
	1           "Yes, Or It Depends"                      
	2           "No"                                      
;
label values pujhck1  pujhck1l;
label define pujhck1l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUJHCK2"                            
	2           "Goto PUNLFCK1"                           
	3           "Goto"                                    
;
label values pujhck2  pujhck2l;
label define pujhck2l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUJHRSN"                            
	2           "Goto PUJHWANT"                           
	3           "Goto PUJHWK"                             
;
label values prcivlf  prcivlf;
label define prcivlf 
	-1          "In Universe, Met No Conditions"          
	1           "In Civilian Labor Force"                 
	2           "Not In Civilian Labor Force"             
;
label values prdisc   prdisc; 
label define prdisc  
	-1          "In Universe, Met No Conditions"          
	1           "Discouraged Worker"                      
	2           "Conditionally Interested"                
	3           "Not Available"                           
;
label values prempnot prempnot;
label define prempnot
	-1          "In Universe, Met No Conditions"          
	1           "Employed"                                
	2           "Unemployed"                              
	3           "Discouraged-Not in labor force"          
	4           "Other Not in labor force (NILF)"         
;
label values prexplf  prexplf;
label define prexplf 
	-1          "In Universe, Met No Conditions"          
	1           "Employed"                                
	2           "Unemployed"                              
;
label values prftlf   prftlf; 
label define prftlf  
	-1          "In Universe, Met No Conditions"          
	1           "Full Time Labor Force"                   
	2           "Part Time Labor Force"                   
;
label values prhrusl  prhrusl;
label define prhrusl 
	-1          "In Universe, Met No Conditions"          
	1           "0-20 Hrs"                                
	2           "21-34 Hrs"                               
	3           "35-39 Hrs"                               
	4           "40 Hrs"                                  
	5           "41-49 Hrs"                               
	6           "50 Or More Hrs"                          
	7           "Varies-Full Time"                        
	8           "Varies-Part Time"                        
;
label values prjobsea prjobsea;
label define prjobsea
	-1          "In Universe, Met No Conditions"          
	1           "Not worked - Looked Last 4 Weeks"        
	2           "Worked-Looked Last 4 Weeks"              
	3           "Layoff-Looked Last 4 Weeks"              
	4           "Unavailable Job Seekers"                 
	5           "No Recent Job Search"                    
;
label values prpthrs  prpthrs;
label define prpthrs 
	-1          "In Universe, Met No Conditions"          
	0           "Usualy FT, PT For Noneconomic"           
	1           "1-4 Hrs;Usu.FT, PT Econ Reasons"         
	2           "5-14 Hrs;Usu.FT, PT Econ Reasons"        
	3           "15-29 Hrs;Usu.FT, PT Econ"               
	4           "30-34 Hrs;Usu.FT, PT Econ"               
	5           "1-4 Hrs; Usu.PT, Econ Reasons"           
	6           "5-14 Hrs; Usu.PT, Econ Reasons"          
	7           "15-29 Hrs; Usu.PT, Econ Reasons"         
	8           "30-34 Hrs; Usu.PT, Econ Reasons"         
	9           "1-4 Hrs;Usu.PT, Non-Econ Reasons"        
	10          "5-14 Hrs;Usu.PT, Non-Econ"               
	11          "15-29 Hrs;Usu.PT, Non-Econ"              
	12          "30-34 HrsUsu.PT, Non-Econ"               
;
label values prunedur prunedur;
label define prunedur
	-1          "In Universe, Met No Conditions"          
;
label values prusftpt prusftpt;
label define prusftpt
	-1          "In Universe, Met No Conditions"          
	1           "Full Time"                               
	2           "Part Time"                               
	3           "Status Unknown"                          
;
label values pruntype pruntype;
label define pruntype
	-1          "In Universe, Met No Conditions"          
	1           "Job Loser/On Layoff"                     
	2           "Other Job Loser"                         
	3           "Temporary Job Ended"                     
	4           "Job Leaver"                              
	5           "Re-Entrant"                              
	6           "New-Entrant"                             
;
label values prwksch  prwksch;
label define prwksch 
	-1          "In Universe, Met No Conditions"          
	0           "Not In Labor Force"                      
	1           "At Work"                                 
	2           "With Job, Not At Work"                   
	3           "Unemployed, Seeks FT"                    
	4           "Unemp., Seeks PT"                        
;
label values prwkstat prwkstat;
label define prwkstat
	-1          "In Universe, Met No Conditions"          
	1           "Not In Labor Force"                      
	2           "FT Hours (35+), Usually FT"              
	3           "PT For Economic Reasons, Usually"        
	4           "PT For Non-Economic Reasons,"            
	5           "Not At Work, Usually FT"                 
	6           "PT Hours, Usually PT For"                
	7           "PT hrs, Usually PT For"                  
	8           "FT Hours, Usually PT For"                
	9           "FT hrs, Usually PT For"                  
	10          "Not at work, Usually Part-Time"          
	11          "Unemployed FT"                           
	12          "Unemployed PT"                           
;
label values prwntjob prwntjob;
label define prwntjob
	-1          "In Universe, Met No Conditions"          
	1           "Want A Job"                              
	2           "Other Not In Labor Force"                
;
label values pujhck3  pujhck3l;
label define pujhck3l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUJHDP1"                            
	2           "Goto PUJHRSN"                            
;
label values pujhck4  pujhck4l;
label define pujhck4l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUJHCK5"                            
	2           "Goto PUIO1INT"                           
	3           "Go to PUJHCK5"                           
	4           "Go to PUIO1INT"                          
	5           "Goto PUNLFCK1"                           
;
label values pujhck5  pujhck5l;
label define pujhck5l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUIO1INT"                           
	2           "Goto PUIOCK5"                            
;
label values puiodp1  puiodp1l;
label define puiodp1l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values puiodp2  puiodp2l;
label define puiodp2l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values puiodp3  puiodp3l;
label define puiodp3l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Yes"                                     
	2           "No"                                      
;
label values peio1cow peio1cow;
label define peio1cow
	1           "Government - Federal"                    
	2           "Government - State"                      
	3           "Government - Local"                      
	4           "Private, For Profit"                     
	5           "Private, Nonprofit"                      
	6           "Self-Employed, Incorporated"             
	7           "Self-Employed, Unincorporated"           
	8           "Without Pay"                             
;
label values puio1mfg puio1mfg;
label define puio1mfg
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Manufacturing"                           
	2           "Retail Trade"                            
	3           "Wholesale Trade"                         
	4           "Something Else"                          
;
label values peio2cow peio2cow;
label define peio2cow
	1           "Government - Federal"                    
	2           "Government - State"                      
	3           "Government - Local"                      
	4           "Private, For Profit"                     
	5           "Private, Nonprofit"                      
	6           "Self-Employed, Incorporated"             
	7           "Self-Employed, Unincorporated"           
	8           "Without Pay"                             
;
label values puio2mfg puio2mfg;
label define puio2mfg
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Manufacturing"                           
	2           "Retail Trade"                            
	3           "Wholesale Trade"                         
	4           "Something Else"                          
;
label values puiock1  puiock1l;
label define puiock1l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUIO1INT"                           
	2           "Go to PUIO1INT"                          
	3           "Go To PUIO1INT"                          
	4           "Goto PUIODP1"                            
	5           "GoTo PUIO1INT"                           
;
label values puiock2  puiock2l;
label define puiock2l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUIO1IND"                           
	2           "Goto PUIO1OCC"                           
	3           "Goto PUIODP2"                            
;
label values puiock3  puiock3l;
label define puiock3l
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "Goto PUIO1OCC"                           
	2           "Goto PUIO10CC"                           
	3           "Goto PUIODP3"                            
;
label values prioelg  prioelg;
label define prioelg 
	-1          "In Universe, Met No Conditions"          
	0           "Not Eligible For Edit"                   
	1           "Eligible For Edit"                       
;
label values pragna   pragna; 
label define pragna  
	-1          "In Universe, Met No Conditions"          
	1           "Agricultural"                            
	2           "Non-Agricultural"                        
;
label values prcow1   prcow1l;
label define prcow1l 
	-1          "In Universe, Met No Conditions"          
	1           "Federal Govt"                            
	2           "State Govt"                              
	3           "Local Govt"                              
	4           "Private (incl. Self-Employed"            
	5           "Self-Employed, Unincorp."                
	6           "Without Pay"                             
;
label values prcow2   prcow2l;
label define prcow2l 
	-1          "In Universe, Met No Conditions"          
	1           "Federal Govt"                            
	2           "State Govt"                              
	3           "Local Govt"                              
	4           "Private (incl. Self-Employed"            
	5           "Self-Employed, Unincorp."                
	6           "Without Pay"                             
;
label values prcowpg  prcowpg;
label define prcowpg 
	-1          "In Universe, Met No Conditions"          
	1           "Private"                                 
	2           "Government"                              
;
label values prdtcow1 prdtcowa;
label define prdtcowa
	-1          "In Universe, Met No Conditions"          
	1           "Agri.,wage & Salary,private"             
	2           "Agri,wage & Salary, Government"          
	3           "Agri., Self-Employed"                    
	4           "Agri., Unpaid"                           
	5           "Nonag,ws,private,private Hhlds"          
	6           "Nonag,ws,priv.,other Private"            
	7           "Nonag,ws,govt,federal"                   
	8           "Nonag,ws,govt,state"                     
	9           "Nonag,ws,govt,local"                     
	10          "Nonag, Self-Employed"                    
	11          "Nonag, Unpaid"                           
;
label values prdtcow2 prdtcowb;
label define prdtcowb
	-1          "In Universe, Met No Conditions"          
	1           "Agri.,wage & Salary,private"             
	2           "Agri,wage & Salary, Government"          
	3           "Agri., Self-Employed"                    
	4           "Agri., Unpaid"                           
	5           "Nonag,ws,private,private Hhlds"          
	6           "Nonag,ws,priv.,other Private"            
	7           "Nonag,ws,govt,federal"                   
	8           "Nonag,ws,govt,state"                     
	9           "Nonag,ws,govt,local"                     
	10          "Nonag, Self-Employed"                    
	11          "Nonag, Unpaid"                           
;
label values premp    premp;  
label define premp   
	-1          "In Universe, Met No Conditions"          
	1           "Employed Persons (exc. Farm &"           
;
label values prmjocc1 prmjocca;
label define prmjocca
	-1          "In Universe, Met No Conditions"          
	1           "Executive, Admin, & Managerial"          
	2           "Professional Specialty Occs"             
	3           "Technicians And Related Support"         
	4           "Sales Occs"                              
	5           "Admin. Support Occs, Incl."              
	6           "Private Household Occs"                  
	7           "Protective Service Occs"                 
	8           "Service Occs, Exc. Protective &"         
	9           "Precision Prod., Craft & Repair"         
	10          "Machine Opers, Assemblers &"             
	11          "Transportation And Material"             
	12          "Handlers,equip"                          
	13          "Farming, Forestry And Fishing"           
	14          "Armed Forces"                            
;
label values prmjocc2 prmjoccb;
label define prmjoccb
	-1          "In Universe, Met No Conditions"          
	1           "Executive, Admin, & Managerial"          
	2           "Professional Specialty Occs"             
	3           "Technicians And Related Support"         
	4           "Sales Occs"                              
	5           "Admin. Support Occs, Incl."              
	6           "Private Household Occs"                  
	7           "Protective Service Occs"                 
	8           "Service Occs, Exc. Protective &"         
	9           "Precision Prod., Craft & Repair"         
	10          "Machine Opers, Assemblers &"             
	11          "Transportation And Material"             
	12          "Handlers,equip"                          
	13          "Farming, Forestry And Fishing"           
	14          "Armed Forces"                            
;
label values prmjocgr prmjocgr;
label define prmjocgr
	-1          "In Universe, Met No Conditions"          
	1           "Mgr. & Prof, Tech, Sales &"              
	2           "Service Occupations"                     
	3           "Production, Craft, Repair,"              
	4           "Farming, Forestry & Fishing"             
;
label values prnagpws prnagpws;
label define prnagpws
	-1          "In Universe, Met No Conditions"          
	1           "Non-Ag Priv Wage & Salary (ex"           
;
label values prnagws  prnagws;
label define prnagws 
	-1          "In Universe, Met No Conditions"          
	1           "Non-Ag Wage And Salary Workers"          
;
label values prsjmj   prsjmj; 
label define prsjmj  
	-1          "In Universe, Met No Conditions"          
	1           "Single jobholder"                        
	2           "Multiple jobholder"                      
;
label values prerelg  prerelg;
label define prerelg 
	-1          "In Universe, Met No Conditions"          
	0           "Not Eligible For Edit"                   
	1           "Eligible For Edit"                       
;
label values peernuot peernuot;
label define peernuot
	1           "Yes"                                     
	2           "No"                                      
;
label values peernper peernper;
label define peernper
	1           "Hourly"                                  
	2           "Weekly"                                  
	3           "Bi-Weekly"                               
	4           "Twice Monthly"                           
	5           "Monthly"                                 
	6           "Annually"                                
	7           "Other - Specify"                         
;
label values peernrt  peernrt;
label define peernrt 
	1           "Yes"                                     
	2           "No"                                      
;
label values peernhry peernhry;
label define peernhry
	1           "Hourly Worker"                           
	2           "Nonhourly Worker"                        
;
label values puernh1c puernh1c;
label define puernh1c
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values prernhly prernhly;
label define prernhly
	-1          "In Universe, Met No Conditions"          
;
label values pthr     pthr;   
label define pthr    
	0           "Not Topcoded"                            
	1           "Topcoded"                                
;
label values prernwa  prernwa;
label define prernwa 
	-1          "In Universe, Met No Conditions"          
;
label values ptwk     ptwk;   
label define ptwk    
	0           "Not Topcoded"                            
	1           "Topcoded"                                
;
label values puern2   puern2l;
label define puern2l 
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
;
label values ptot     ptot;   
label define ptot    
	0           "Not Topcoded"                            
	1           "Topcoded"                                
;
label values peernlab peernlab;
label define peernlab
	1           "Yes"                                     
	2           "No"                                      
;
label values peerncov peerncov;
label define peerncov
	1           "Yes"                                     
	2           "No"                                      
;
label values penlfjh  penlfjh;
label define penlfjh 
	1           "Within The Last 12 Months"               
	2           "More Than 12 Months Ago"                 
	3           "Never Worked"                            
;
label values penlfret penlfret;
label define penlfret
	1           "Yes"                                     
	2           "No"                                      
;
label values penlfact penlfact;
label define penlfact
	1           "Disabled"                                
	2           "Ill"                                     
	3           "In School"                               
	4           "Taking Care Of House Or Family"          
	5           "In Retirement"                           
	6           "Something Else/Other"                    
;
label values punlfck1 punlfcka;
label define punlfcka
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "AGERNG-I=1-4,9, Goto NLFACT"             
	2           "All Others Goto NLFRET"                  
;
label values punlfck2 punlfckb;
label define punlfckb
	-3          "Refused"                                 
	-2          "Don't Know"                              
	-1          "Blank"                                   
	1           "MIS-CK=4, Goto NLFJH"                    
	2           "All Other Rotations, End"                
;
label values peschenr peschenr;
label define peschenr
	1           "Yes"                                     
	2           "No"                                      
;
label values peschft  peschft;
label define peschft 
	1           "Full-time"                               
	2           "Part-time"                               
;
label values peschlvl peschlvl;
label define peschlvl
	1           "High school"                             
	2           "College or university"                   
;
label values prnlfsch prnlfsch;
label define prnlfsch
	-1          "In Universe, Met No Conditions"          
	1           "In School"                               
	2           "Not In School"                           
;
label values prwernal prwernal;
label define prwernal
	-1          "In Universe, Met No Conditions"          
	0           "No Component Allocated"                  
	1           "1 Or More Components Allocated"          
;
label values prhernal prhernal;
label define prhernal
	-1          "In Universe, Met No Conditions"          
	0           "No Components Allocated"                 
	1           "1 or more components Allocated"          
;
label values pedipged pedipged;
label define pedipged
	-1          "Not in Universe"                         
	1           "Graduation from High School"             
	2           "GED or  other Equivalent"                
;
label values pehgcomp pehgcomp;
label define pehgcomp
	-1          "Not in Universe"                         
	1           "Less than 1st grade"                     
	2           "1st, 2nd, 3rd, or 4th Grade"             
	3           "5th or 6th Grade"                        
	4           "7th or 8th Grade"                        
	5           "9th Grade"                               
	6           "10th Grade"                              
	7           "11th Grade"                              
	8           "12th Grade, NO DIPLOMA"                  
;
label values pecyc    pecyc;  
label define pecyc   
	-1          "Not in Universe"                         
	1           "Less than 1 year (includes 0"            
	2           "The first, or Freshman year?"            
	3           "The second, or Sophomore year?"          
	4           "The third, or Junior year?"              
	5           "Four or more years?"                     
;
label values pegrprof pegrprof;
label define pegrprof
	-1          "Not in Universe"                         
	1           "Yes"                                     
	2           "No"                                      
;
label values pegr6cor pegr6cor;
label define pegr6cor
	-1          "Not in Universe"                         
	1           "Yes"                                     
	2           "No"                                      
;
label values pems123  pems123l;
label define pems123l
	-1          "Not in Universe"                         
	1           "1 year program"                          
	2           "2 year program"                          
	3           "3 year program (or longer)"              
;

#delimit cr
compress

/*
Copyright 2011 shared by the National Bureau of Economic Research and Jean Roth

National Bureau of Economic Research.
1050 Massachusetts Avenue
Cambridge, MA 02138
jroth@nber.org

This program and all programs referenced in it are free software. You
can redistribute the program or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
USA.
*/
