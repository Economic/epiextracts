log using rw0207,text replace
set mem 200m
*by Jean Roth Fri Oct 24 10:38:16 EDT 2003

*Please report errors to jroth@nber.org
*NOTE:  This program is distributed under the GNU GPL. See end of
*this file and http://www.gnu.org/licenses/ for details.
*run with do rw0207
*Change output file name/location as desired in the first line of the .dct file
*If you are using a PC, you may need to change the direction of the slashes, as in C:\
*  or "\\Nber\homes\data\cps-basic\rw0207.dat"
*All items, except those with one character, also can have values
*of -1, -2, or -3 even if the values are not in the documentation
*The meaning is
*       -1 .Blank or not in universe
*       -2 .Don't know
*       -3 .Refused
* The following changes in variable names have been made, if necessary:
*      '$' to 'd';            '-' to '_';              '%' to 'p';
*      ($ = unedited data;     - = edited data;         % = allocated data)
* Note:  Variable names in Stata are case-sensitive
clear
quietly infile using rw0207

*Everything below this point are value labels
#delimit ;

;
label values neio1cow neio1cow;
label define neio1cow
	1           "GOVERNMENT - FEDERAL"          
	2           "GOVERNMENT - STATE"            
	3           "GOVERNMENT - LOCAL"            
	4           "PRIVATE, FOR PROFIT"           
	5           "PRIVATE, NONPROFIT"            
	6           "SELF-EMPLOYED, INCORPORATED"   
	7           "SELF-EMPLOYED, UNINCORPORATED" 
	8           "WITHOUT PAY"                   
;
label values neio2cow neio2cow;
label define neio2cow
	1           "GOVERNMENT - FEDERAL"          
	2           "GOVERNMENT - STATE"            
	3           "GOVERNMENT - LOCAL"            
	4           "PRIVATE, FOR PROFIT"           
	5           "PRIVATE, NONPROFIT"            
	6           "SELF-EMPLOYED, INCORPORATED"   
	7           "SELF-EMPLOYED, UNINCORPORATED" 
	8           "WITHOUT PAY"                   
;
label values nragna   nragna; 
label define nragna  
	1           "AGRICULTURAL 0170-0290"        
	2           "NON-AGRICULTURAL 0370-9890"    
;
label values nrcow1   nrcow1l;
label define nrcow1l 
	1           "FEDERAL GOVT"                  
	2           "STATE GOVT"                    
	3           "LOCAL GOVT"                    
	4           "PRIVATE (INCL. SELF-EMPLOYED INCORP.)"
	5           "SELF-EMPLOYED, UNINCORP."      
	6           "WITHOUT PAY"                   
;
label values nrcow2   nrcow2l;
label define nrcow2l 
	1           "FEDERAL GOVT"                  
	2           "STATE GOVT"                    
	3           "LOCAL GOVT"                    
	4           "PRIVATE (INCL. SELF-EMPLOYED INCORP.)"
	5           "SELF-EMPLOYED, UNINCORP."      
	6           "WITHOUT PAY"                   
;
label values nrcowpg  nrcowpg;
label define nrcowpg 
	1           "PRIVATE"                       
	2           "GOVERNMENT"                    
;
label values nrdtcow1 nrdtcowa;
label define nrdtcowa
	1           "AGRI., WAGE & SALARY, PRIVATE" 
	2           "AGRI., WAGE & SALARY, GOVERNMENT"
	3           "AGRI., SELF-EMPLOYED"          
	4           "AGRI., UNPAID"                 
	5           "NONAG, WS, PRIVATE, PRIVATE HHLDS"
	6           "NONAG, WS, PRIVATE, OTHER PRIVATE"
	7           "NONAG, WS, GOVT, FEDERAL"      
	8           "NONAG, WS, GOVT, STATE"        
	9           "NONAG, WS, GOVT, LOCAL"        
	10          "NONAG, SELF-EMPLOYED"          
	11          "NONAG, UNPAID"                 
;
label values nrdtcow2 nrdtcowb;
label define nrdtcowb
	1           "AGRI., WAGE & SALARY, PRIVATE" 
	2           "AGRI., WAGE & SALARY, GOVERNMENT"
	3           "AGRI., SELF-EMPLOYED"          
	4           "AGRI., UNPAID"                 
	5           "NONAG, WS, PRIVATE, PRIVATE HHLDS"
	6           "NONAG, WS, PRIVATE, OTHER PRIVATE"
	7           "NONAG, WS, GOVT, FEDERAL"      
	8           "NONAG, WS, GOVT, STATE"        
	9           "NONAG, WS, GOVT, LOCAL"        
	10          "NONAG, SELF-EMPLOYED"          
	11          "NONAG, UNPAID"                 
;
label values nrdtind1 nrdtinda;
label define nrdtinda
	1           "Agriculture 0170-0180, 0290"   
	2           "Forestry, logging, fishing, hunting, and trapping 0190-0280"
	3           "Mining 0370-0490"              
	4           "Construction 0770"             
	5           "Nonmetallic mineral product manufacturing 2470-2590"
	6           "Primary metals and fabricated metal products 2670-2990"
	7           "Machinery manufacturing 3070-3290"
	8           "Computer and electronic product manufacturing 3360-3390"
	9           "Electrical equipment, appliance manufacturing 3470-3490"
	10          "Transportation equipment manufacturing 3570-3690"
	11          "Wood products 3770-3870"       
	12          "Furniture and fixtures manufacturing 3890"
	13          "Miscellaneous and not specified manufacturing 3960-3990"
	14          "Food manufacturing 1070-1290"  
	15          "Beverage and tobacco products 1370-1390"
	16          "Textile, apparel, and leather manufacturing 1470-1790"
	17          "Paper and printing 1870-1990"  
	18          "Petroleum and coal products manufacturing 2070-2090"
	19          "Chemical manufacturing 2170-2290"
	20          "Plastics and rubber products 2370-2390"
	21          "Wholesale trade 4070-4590"     
	22          "Retail trade 4670-5790"        
	23          "Transportation and warehousing 6070-6390"
	24          "Utilities 0570-0690"           
	25          "Publishing industries (except internet) 6470-6490"
	26          "Motion picture and sound recording industries 6570-6590"
	27          "Broadcasting (except internet) 6670"
	28          "Internet publishing and broadcasting 6675"
	29          "Telecommunications 6680-6690"  
	30          "Internet service providers and data processing services 6692,6695"
	31          "Other information services 6770-6780"
	32          "Finance 6870-6970"             
	33          "Insurance 6990"                
	34          "Real estate 7070"              
	35          "Rental and leasing services 7080-7190"
	36          "Professional and technical services 7270-7490"
	37          "Management of companies and enterprises 7570"
	38          "Administrative and support services 7580-7780"
	39          "Waste management and remediation services 7790"
	40          "Educational services 7860-7890"
	41          "Hospitals 8190"                
	42          "Health care services, except hospitals 7970-8180, 8270, 8290"
	43          "Social assistance 8370-8470"   
	44          "Arts, entertainment, and recreation 8560-8590"
	45          "Accommodation 8660-8670"       
	46          "Food services and drinking places 8680-8690"
	47          "Repair and maintenance 8770-8890"
	48          "Personal and laundry services 8970-9090"
	49          "Membership associations and organizations 9160-9190"
	50          "Private households 9290"       
	51          "Public administration 9370-9590"
	52          "Armed forces 9890"             
;
label values nrdtind2 nrdtindb;
label define nrdtindb
	1           "Agriculture"                   
	2           "Forestry, logging, fishing, hunting, and trapping"
	3           "Mining"                        
	4           "Construction"                  
	5           "Nonmetallic mineral product manufacturing"
	6           "Primary metals and fabricated metal products"
	7           "Machinery manufacturing"       
	8           "Computer and electronic product manufacturing"
	9           "Electrical equipment, appliance manufacturing"
	10          "Transportation equipment manufacturing"
	11          "Wood products"                 
	12          "Furniture and fixtures manufacturing"
	13          "Miscellaneous and not specified manufacturing"
	14          "Food manufacturing"            
	15          "Beverage and tobacco products" 
	16          "Textile, apparel, and leather manufacturing"
	17          "Paper and printing"            
	18          "Petroleum and coal products manufacturing"
	19          "Chemical manufacturing"        
	20          "Plastics and rubber products"  
	21          "Wholesale trade"               
	22          "Retail trade"                  
	23          "Transportation and warehousing"
	24          "Utilities"                     
	25          "Publishing industries (except internet)"
	26          "Motion picture and sound recording industries"
	27          "Broadcasting (except internet)"
	28          "Internet publishing and broadcasting"
	29          "Telecommunications"            
	30          "Internet service providers and data processing services"
	31          "Other information services"    
	32          "Finance"                       
	33          "Insurance"                     
	34          "Real estate"                   
	35          "Rental and leasing services"   
	36          "Professional and technical services"
	37          "Management of companies and enterprises"
	38          "Administrative and support services"
	39          "Waste management and remediation services"
	40          "Educational services"          
	41          "Hospitals"                     
	42          "Health care services, except hospitals"
	43          "Social assistance"             
	44          "Arts, entertainment, and recreation"
	45          "Accommodation"                 
	46          "Food services and drinking places"
	47          "Repair and maintenance"        
	48          "Personal and laundry services" 
	49          "Membership associations and organizations"
	50          "Private households"            
	51          "Public administration"         
	52          "Armed forces"                  
;
label values nrdtocc1 nrdtocca;
label define nrdtocca
	1           "Management occupations 0010-0430"
	2           "Business and financial operations occupations 0500-0950"
	3           "Computer and mathematical science occupations 1000-1240"
	4           "Architecture and engineering occupations 1300-1560"
	5           "Life, physical, and social science occupations 1600-1960"
	6           "Community and social service occupations 2000-2060"
	7           "Legal occupations 2100-2150"   
	8           "Education, training, and library occupations 2200-2550"
	9           "Arts, design, entertainment, sports, and media"
	10          "Healthcare practitioner and technical occupations 3000-3540"
	11          "Healthcare support occupations 3600-3650"
	12          "Protective service occupations 3700-3950"
	13          "Food preparation and serving related occupations 4000-4160"
	14          "Building and grounds cleaning and maintenance"
	15          "Personal care and service occupations 4300-4650"
	16          "Sales and related occupations 4700-4960"
	17          "Office and administrative support occupations 5000-5930"
	18          "Farming, fishing, and forestry occupations 6000-6130"
	19          "Construction and extraction occupations 6200-6940"
	20          "Installation, maintenance, and repair occupations 7000-7620"
	21          "Production occupations 7700-8960"
	22          "Transportation and material moving occupations 9000-9750"
	23          "Armed Forces 9840"             
;
label values nrdtocc2 nrdtoccb;
label define nrdtoccb
	1           "Management occupations"        
	2           "Business and financial operations occupations"
	3           "Computer and mathematical science occupations"
	4           "Architecture and engineering occupations"
	5           "Life, physical, and social science occupations"
	6           "Community and social service occupations"
	7           "Legal occupations"             
	8           "Education, training, and library occupations"
	9           "Arts, design, entertainment, sports, and media"
	10          "Healthcare practitioner and technical occupations"
	11          "Healthcare support occupations"
	12          "Protective service occupations"
	13          "Food preparation and serving related occupations"
	14          "Building and grounds cleaning and maintenance"
	15          "Personal care and service occupations"
	16          "Sales and related occupations" 
	17          "Office and administrative support occupations"
	18          "Farming, fishing, and forestry occupations"
	19          "Construction and extraction occupations"
	20          "Installation, maintenance, and repair occupations"
	21          "Production occupations"        
	22          "Transportation and material moving occupations"
	23          "Armed Forces"                  
;
label values nrmjind1 nrmjinda;
label define nrmjinda
	1           "Agriculture, forestry, fishing, and hunting 0170-0290"
	2           "Mining 0370-0490"              
	3           "Construction 0770"             
	4           "Manufacturing 1070-3990"       
	5           "Wholesale and retail trade 4070-5790"
	6           "Transportation and utilities 6070-6390 and 0570-0690"
	7           "Information 6470-6780"         
	8           "Financial activities 6870-7190"
	9           "Professional and business services 7270-7790"
	10          "Educational and health services 7860-8470"
	11          "Leisure and hospitality 8560-8690"
	12          "Other services 8770-9290"      
	13          "Public administration 9370-9590"
	14          "Armed Forces 9890"             
;
label values nrmjind2 nrmjindb;
label define nrmjindb
	1           "Agriculture, forestry, fishing, and hunting"
	2           "Mining"                        
	3           "Construction"                  
	4           "Manufacturing"                 
	5           "Wholesale and retail trade"    
	6           "Transportation and utilities"  
	7           "Information"                   
	8           "Financial activities"          
	9           "Professional and business services"
	10          "Educational and health services"
	11          "Leisure and hospitality"       
	12          "Other services"                
	13          "Public administration"         
	14          "Armed Forces"                  
;
label values nrmjocc1 nrmjocca;
label define nrmjocca
	1           "Management, business, and financial occupations 0010-0950"
	2           "Professional and related occupations 1000-3540"
	3           "Service occupations 3600-4650" 
	4           "Sales and related occupations 4700-4960"
	5           "Office and administrative support occupations 5000-5930"
	6           "Farming, fishing, and forestry occupations 6000-6130"
	7           "Construction and extraction occupations 6200-6940"
	8           "Installation, maintenance, and repair occupations 7000-7620"
	9           "Production occupations 7700-8960"
	10          "Transportation and material moving occupations 9000-9750"
	11          "Armed Forces 9840"             
;
label values nrmjocc2 nrmjoccb;
label define nrmjoccb
	1           "Management, business, and financial occupations"
	2           "Professional and related occupations"
	3           "Service occupations"           
	4           "Sales and related occupations" 
	5           "Office and administrative support occupations"
	6           "Farming, fishing, and forestry occupations"
	7           "Construction and extraction occupations"
	8           "Installation, maintenance, and repair occupations"
	9           "Production occupations"        
	10          "Transportation and material moving occupations"
	11          "Armed Forces"                  
;
label values nrmjocgr nrmjocgr;
label define nrmjocgr
	1           "Management, professional, and related occupations"
	2           "Service occupations"           
	3           "Sales and office occupations"  
	4           "Farming, fishing, and forestry occupations"
	5           "Construction, and maintenance occupations"
	6           "Production, transportation, and material moving"
	7           "Armed Forces"                  
;
label values nrsjmj   nrsjmj; 
label define nrsjmj  
	1           "SINGLE JOBHOLDER"              
	2           "MULTIPLE JOBHOLDER"            
;
label values neerncov neerncov;
label define neerncov
	1           "YES"                           
	2           "NO"                            
;
label values neernlab neernlab;
label define neernlab
	1           "YES"                           
	2           "NO"                            
;

/*
Copyright 2004 shared by the National Bureau of Economic Research and Jean Roth

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
