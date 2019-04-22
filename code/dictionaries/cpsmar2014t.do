capture log close
log using cpsmar2014t.log, replace

/*------------------------------------------------
  by Jean Roth Fri Sep 18 17:10:34 EDT 2015
  Please report errors to jroth@nber.org
  NOTE:  This program is distributed under the GNU GPL. 
  See end of this file and http://www.gnu.org/licenses/ for details.
  Run with do cpsmar2014t
----------------------------------------------- */

/* The following line should contain
   the complete path and name of the raw data file.
   On a PC, use backslashes in paths as in C:\  */   

local dat_name "/homes/data/cps/cpsmar2014t.dat"

/* The following line should contain the path to your output '.dta' file */

local dta_name "/homes/data/cps/cpsmar2014t.dta"

/* The following line should contain the path to the data dictionary file */

local dct_name "cpsmar2014t.dct"

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

  Variable names in Stata are case-sensitive

 -----------------------------------------------*/

*The replace statements append household 
*and family variables to their respective
*person records.

replace     h_seq =     h_seq[_n-1]  if  hrecord>1
replace     hhpos =     hhpos[_n-1]  if  hrecord>1
replace    hunits =    hunits[_n-1]  if  hrecord>1
replace  hefaminc =  hefaminc[_n-1]  if  hrecord>1
replace  h_respnm =  h_respnm[_n-1]  if  hrecord>1
replace    h_year =    h_year[_n-1]  if  hrecord>1
replace  h_hhtype =  h_hhtype[_n-1]  if  hrecord>1
replace  h_numper =  h_numper[_n-1]  if  hrecord>1
replace   hnumfam =   hnumfam[_n-1]  if  hrecord>1
replace    h_type =    h_type[_n-1]  if  hrecord>1
replace   h_month =   h_month[_n-1]  if  hrecord>1
replace     h_mis =     h_mis[_n-1]  if  hrecord>1
replace   h_hhnum =   h_hhnum[_n-1]  if  hrecord>1
replace  h_livqrt =  h_livqrt[_n-1]  if  hrecord>1
replace  h_typebc =  h_typebc[_n-1]  if  hrecord>1
replace  h_tenure =  h_tenure[_n-1]  if  hrecord>1
replace  h_telhhd =  h_telhhd[_n-1]  if  hrecord>1
replace  h_telavl =  h_telavl[_n-1]  if  hrecord>1
replace  h_telint =  h_telint[_n-1]  if  hrecord>1
replace     gereg =     gereg[_n-1]  if  hrecord>1
replace   gestcen =   gestcen[_n-1]  if  hrecord>1
replace  gestfips =  gestfips[_n-1]  if  hrecord>1
replace    gtcbsa =    gtcbsa[_n-1]  if  hrecord>1
replace      gtco =      gtco[_n-1]  if  hrecord>1
replace  gtcbsast =  gtcbsast[_n-1]  if  hrecord>1
replace  gtmetsta =  gtmetsta[_n-1]  if  hrecord>1
replace  gtindvpc =  gtindvpc[_n-1]  if  hrecord>1
replace  gtcbsasz =  gtcbsasz[_n-1]  if  hrecord>1
replace     gtcsa =     gtcsa[_n-1]  if  hrecord>1
replace  hunder15 =  hunder15[_n-1]  if  hrecord>1
replace   hh5to18 =   hh5to18[_n-1]  if  hrecord>1
replace   hhotlun =   hhotlun[_n-1]  if  hrecord>1
replace    hhotno =    hhotno[_n-1]  if  hrecord>1
replace   hflunch =   hflunch[_n-1]  if  hrecord>1
replace   hflunno =   hflunno[_n-1]  if  hrecord>1
replace   hpublic =   hpublic[_n-1]  if  hrecord>1
replace   hlorent =   hlorent[_n-1]  if  hrecord>1
replace   hfoodsp =   hfoodsp[_n-1]  if  hrecord>1
replace   hfoodno =   hfoodno[_n-1]  if  hrecord>1
replace   hfoodmo =   hfoodmo[_n-1]  if  hrecord>1
replace   hengast =   hengast[_n-1]  if  hrecord>1
replace   hengval =   hengval[_n-1]  if  hrecord>1
replace   hinc_ws =   hinc_ws[_n-1]  if  hrecord>1
replace    hwsval =    hwsval[_n-1]  if  hrecord>1
replace   hinc_se =   hinc_se[_n-1]  if  hrecord>1
replace    hseval =    hseval[_n-1]  if  hrecord>1
replace   hinc_fr =   hinc_fr[_n-1]  if  hrecord>1
replace    hfrval =    hfrval[_n-1]  if  hrecord>1
replace   hinc_uc =   hinc_uc[_n-1]  if  hrecord>1
replace    hucval =    hucval[_n-1]  if  hrecord>1
replace   hinc_wc =   hinc_wc[_n-1]  if  hrecord>1
replace    hwcval =    hwcval[_n-1]  if  hrecord>1
replace    hss_yn =    hss_yn[_n-1]  if  hrecord>1
replace    hssval =    hssval[_n-1]  if  hrecord>1
replace   hssi_yn =   hssi_yn[_n-1]  if  hrecord>1
replace   hssival =   hssival[_n-1]  if  hrecord>1
replace   hpaw_yn =   hpaw_yn[_n-1]  if  hrecord>1
replace   hpawval =   hpawval[_n-1]  if  hrecord>1
replace   hvet_yn =   hvet_yn[_n-1]  if  hrecord>1
replace   hvetval =   hvetval[_n-1]  if  hrecord>1
replace   hsur_yn =   hsur_yn[_n-1]  if  hrecord>1
replace   hsurval =   hsurval[_n-1]  if  hrecord>1
replace   hdis_yn =   hdis_yn[_n-1]  if  hrecord>1
replace   hdisval =   hdisval[_n-1]  if  hrecord>1
replace   hret_yn =   hret_yn[_n-1]  if  hrecord>1
replace   hretval =   hretval[_n-1]  if  hrecord>1
replace   hint_yn =   hint_yn[_n-1]  if  hrecord>1
replace   hintval =   hintval[_n-1]  if  hrecord>1
replace   hdiv_yn =   hdiv_yn[_n-1]  if  hrecord>1
replace   hdivval =   hdivval[_n-1]  if  hrecord>1
replace   hrnt_yn =   hrnt_yn[_n-1]  if  hrecord>1
replace   hrntval =   hrntval[_n-1]  if  hrecord>1
replace    hed_yn =    hed_yn[_n-1]  if  hrecord>1
replace    hedval =    hedval[_n-1]  if  hrecord>1
replace   hcsp_yn =   hcsp_yn[_n-1]  if  hrecord>1
replace   hcspval =   hcspval[_n-1]  if  hrecord>1
replace   halm_yn =   halm_yn[_n-1]  if  hrecord>1
replace   halmval =   halmval[_n-1]  if  hrecord>1
replace   hfin_yn =   hfin_yn[_n-1]  if  hrecord>1
replace   hfinval =   hfinval[_n-1]  if  hrecord>1
replace    hoi_yn =    hoi_yn[_n-1]  if  hrecord>1
replace    hoival =    hoival[_n-1]  if  hrecord>1
replace   htotval =   htotval[_n-1]  if  hrecord>1
replace  hearnval =  hearnval[_n-1]  if  hrecord>1
replace   hothval =   hothval[_n-1]  if  hrecord>1
replace     hhinc =     hhinc[_n-1]  if  hrecord>1
replace    hmcare =    hmcare[_n-1]  if  hrecord>1
replace    hmcaid =    hmcaid[_n-1]  if  hrecord>1
replace    hchamp =    hchamp[_n-1]  if  hrecord>1
replace    hhi_yn =    hhi_yn[_n-1]  if  hrecord>1
replace  hhstatus =  hhstatus[_n-1]  if  hrecord>1
replace  hunder18 =  hunder18[_n-1]  if  hrecord>1
replace  htop5pct =  htop5pct[_n-1]  if  hrecord>1
replace   hpctcut =   hpctcut[_n-1]  if  hrecord>1
replace  hsup_wgt =  hsup_wgt[_n-1]  if  hrecord>1
replace  h1tenure =  h1tenure[_n-1]  if  hrecord>1
replace  h1livqrt =  h1livqrt[_n-1]  if  hrecord>1
replace  h1telhhd =  h1telhhd[_n-1]  if  hrecord>1
replace  h1telavl =  h1telavl[_n-1]  if  hrecord>1
replace  h1telint =  h1telint[_n-1]  if  hrecord>1
replace  i_hhotlu =  i_hhotlu[_n-1]  if  hrecord>1
replace  i_hhotno =  i_hhotno[_n-1]  if  hrecord>1
replace  i_hflunc =  i_hflunc[_n-1]  if  hrecord>1
replace  i_hflunn =  i_hflunn[_n-1]  if  hrecord>1
replace  i_hpubli =  i_hpubli[_n-1]  if  hrecord>1
replace  i_hloren =  i_hloren[_n-1]  if  hrecord>1
replace  i_hfoods =  i_hfoods[_n-1]  if  hrecord>1
replace  i_hfdval =  i_hfdval[_n-1]  if  hrecord>1
replace  i_hfoodn =  i_hfoodn[_n-1]  if  hrecord>1
replace  i_hfoodm =  i_hfoodm[_n-1]  if  hrecord>1
replace  i_hengas =  i_hengas[_n-1]  if  hrecord>1
replace  i_hengva =  i_hengva[_n-1]  if  hrecord>1
replace  h_idnum2 =  h_idnum2[_n-1]  if  hrecord>1
replace  prop_tax =  prop_tax[_n-1]  if  hrecord>1
replace   housret =   housret[_n-1]  if  hrecord>1
replace   hrhtype =   hrhtype[_n-1]  if  hrecord>1
replace  h_idnum1 =  h_idnum1[_n-1]  if  hrecord>1
replace  i_hunits =  i_hunits[_n-1]  if  hrecord>1
replace  hrpaidcc =  hrpaidcc[_n-1]  if  hrecord>1
replace hprop_val = hprop_val[_n-1]  if  hrecord>1
replace thprop_val = thprop_val[_n-1]  if  hrecord>1
replace i_propval = i_propval[_n-1]  if  hrecord>1
replace  hrnumwic =  hrnumwic[_n-1]  if  hrecord>1
replace   hrwicyn =   hrwicyn[_n-1]  if  hrecord>1
replace    hfdval =    hfdval[_n-1]  if  hrecord>1
replace tcare_val = tcare_val[_n-1]  if  hrecord>1
replace  care_val =  care_val[_n-1]  if  hrecord>1
replace i_careval = i_careval[_n-1]  if  hrecord>1
replace hpres_mort = hpres_mort[_n-1]  if  hrecord>1
replace   frecord =   frecord[_n-1]  if  precord==3
replace    fh_seq =    fh_seq[_n-1]  if  precord==3
replace     ffpos =     ffpos[_n-1]  if  precord==3
replace     fkind =     fkind[_n-1]  if  precord==3
replace     ftype =     ftype[_n-1]  if  precord==3
replace  fpersons =  fpersons[_n-1]  if  precord==3
replace  fheadidx =  fheadidx[_n-1]  if  precord==3
replace  fwifeidx =  fwifeidx[_n-1]  if  precord==3
replace  fhusbidx =  fhusbidx[_n-1]  if  precord==3
replace  fspouidx =  fspouidx[_n-1]  if  precord==3
replace  flastidx =  flastidx[_n-1]  if  precord==3
replace  fmlasidx =  fmlasidx[_n-1]  if  precord==3
replace    fownu6 =    fownu6[_n-1]  if  precord==3
replace   fownu18 =   fownu18[_n-1]  if  precord==3
replace    frelu6 =    frelu6[_n-1]  if  precord==3
replace   frelu18 =   frelu18[_n-1]  if  precord==3
replace   fpctcut =   fpctcut[_n-1]  if  precord==3
replace   fpovcut =   fpovcut[_n-1]  if  precord==3
replace    famlis =    famlis[_n-1]  if  precord==3
replace     povll =     povll[_n-1]  if  precord==3
replace    frspov =    frspov[_n-1]  if  precord==3
replace   frsppct =   frsppct[_n-1]  if  precord==3
replace   finc_ws =   finc_ws[_n-1]  if  precord==3
replace    fwsval =    fwsval[_n-1]  if  precord==3
replace   finc_se =   finc_se[_n-1]  if  precord==3
replace    fseval =    fseval[_n-1]  if  precord==3
replace   finc_fr =   finc_fr[_n-1]  if  precord==3
replace    ffrval =    ffrval[_n-1]  if  precord==3
replace   finc_uc =   finc_uc[_n-1]  if  precord==3
replace    fucval =    fucval[_n-1]  if  precord==3
replace   finc_wc =   finc_wc[_n-1]  if  precord==3
replace    fwcval =    fwcval[_n-1]  if  precord==3
replace   finc_ss =   finc_ss[_n-1]  if  precord==3
replace    fssval =    fssval[_n-1]  if  precord==3
replace  finc_ssi =  finc_ssi[_n-1]  if  precord==3
replace   fssival =   fssival[_n-1]  if  precord==3
replace  finc_paw =  finc_paw[_n-1]  if  precord==3
replace   fpawval =   fpawval[_n-1]  if  precord==3
replace  finc_vet =  finc_vet[_n-1]  if  precord==3
replace   fvetval =   fvetval[_n-1]  if  precord==3
replace  finc_sur =  finc_sur[_n-1]  if  precord==3
replace   fsurval =   fsurval[_n-1]  if  precord==3
replace  finc_dis =  finc_dis[_n-1]  if  precord==3
replace   fdisval =   fdisval[_n-1]  if  precord==3
replace  finc_ret =  finc_ret[_n-1]  if  precord==3
replace   fretval =   fretval[_n-1]  if  precord==3
replace  finc_int =  finc_int[_n-1]  if  precord==3
replace   fintval =   fintval[_n-1]  if  precord==3
replace  finc_div =  finc_div[_n-1]  if  precord==3
replace   fdivval =   fdivval[_n-1]  if  precord==3
replace  finc_rnt =  finc_rnt[_n-1]  if  precord==3
replace   frntval =   frntval[_n-1]  if  precord==3
replace   finc_ed =   finc_ed[_n-1]  if  precord==3
replace    fedval =    fedval[_n-1]  if  precord==3
replace  finc_csp =  finc_csp[_n-1]  if  precord==3
replace   fcspval =   fcspval[_n-1]  if  precord==3
replace  finc_alm =  finc_alm[_n-1]  if  precord==3
replace   falmval =   falmval[_n-1]  if  precord==3
replace  finc_fin =  finc_fin[_n-1]  if  precord==3
replace   ffinval =   ffinval[_n-1]  if  precord==3
replace   finc_oi =   finc_oi[_n-1]  if  precord==3
replace    foival =    foival[_n-1]  if  precord==3
replace   ftotval =   ftotval[_n-1]  if  precord==3
replace  fearnval =  fearnval[_n-1]  if  precord==3
replace   fothval =   fothval[_n-1]  if  precord==3
replace    ftot_r =    ftot_r[_n-1]  if  precord==3
replace  fspanish =  fspanish[_n-1]  if  precord==3
replace  fsup_wgt =  fsup_wgt[_n-1]  if  precord==3
replace  ffposold =  ffposold[_n-1]  if  precord==3
replace   f_mv_fs =   f_mv_fs[_n-1]  if  precord==3
replace   f_mv_sl =   f_mv_sl[_n-1]  if  precord==3
replace  ffngcare =  ffngcare[_n-1]  if  precord==3
replace  ffngcaid =  ffngcaid[_n-1]  if  precord==3
replace  fhoussub =  fhoussub[_n-1]  if  precord==3
replace  ffoodreq =  ffoodreq[_n-1]  if  precord==3
replace  fhousreq =  fhousreq[_n-1]  if  precord==3
replace  fhip_val =  fhip_val[_n-1]  if  precord==3
replace     fmoop =     fmoop[_n-1]  if  precord==3
replace  fotc_val =  fotc_val[_n-1]  if  precord==3
replace  fmed_val =  fmed_val[_n-1]  if  precord==3
replace i_fhipval = i_fhipval[_n-1]  if  precord==3

replace hrecord = 1
keep if precord==3

** These note statements incorporate variable universes into the Stata data file.
note: by Jean Roth, jroth@nber.org Fri Sep 18 17:10:34 EDT 2015
note h_seq: U All households
note hefaminc: U H-HHTYPE = 1
note h_respnm: U All households
note h_hhtype: U All households
note h_numper: U All
note hnumfam: U H-HHTYPE = 1
note h_type: U H-HHTYPE = 1
note h_month: U H-HHTYPE = 1
note h_mis: U All households
note h_hhnum: U All households
note h_livqrt: U All households
note h_typebc: U All households
note h_tenure: U H-HHTYPE = 3
note h_telhhd: U H-HHTYPE = 1
note h_telavl: U H-HHTYPE = 1
note h_telint: U H-TELHHD = 2
note gereg: U H-TELAVL = 1
note gestcen: U All households
note gestfips: U All households
note gtcbsast: U All HHLD's in sample
note gtmetsta: U All
note gtindvpc: U All
note gtcsa: U All HHLD's in sample
note hh5to18: U ITEM 79 = 1
note hhotno: U HH5TO18 = 1+
note hflunch: U HHOTLUN = 1
note hflunno: U HHOTLUN = 1
note hpublic: U HFLUNCH = 1
note hlorent: U HTENURE = 2
note hfoodsp: U HPUBLIC = 2
note hfoodno: U H-HHTYPE = 1
note hfoodmo: U HFOODSP = 1
note hengast: U HFOODSP = 1
note hengval: U H-HHTYPE = 1
note hinc_ws: U HENGAST = 1
note hwsval: U H-HHTYPE = 1
note hinc_se: U HINC-WS = 1
note hseval: U H-HHTYPE = 1
note hinc_fr: U HINC-SE  = 1
note hfrval: U H-HHTYPE = 1
note hinc_uc: U HINC-FR = 1
note hucval: U H-HHTYPE = 1
note hinc_wc: U HINC-UC = 1
note hwcval: U H-HHTYPE = 1
note hss_yn: U HINC-WC = 1
note hssval: U H-HHTYPE = 1
note hssi_yn: U HSS-YN = 1
note hssival: U H-HHTYPE = 1
note hpaw_yn: U HSSI-YN = 1
note hpawval: U H-HHTYPE = 1
note hvet_yn: U HPAW-YN = 1
note hvetval: U H-HHTYPE = 1
note hsur_yn: U HVET-YN = 1
note hsurval: U H-HHTYPE = 1
note hdis_yn: U HSUR-YN = 1
note hdisval: U H-HHTYPE = 1
note hret_yn: U HDIS-YN = 1
note hretval: U H-HHTYPE = 1
note hint_yn: U HRET-YN = 1
note hintval: U H-HHTYPE = 1
note hdiv_yn: U HINT-YN = 1
note hdivval: U H-HHTYPE = 1
note hrnt_yn: U HDIV-YN = 1
note hrntval: U H-HHTYPE = 1
note hed_yn: U HRNT-YN = 1
note hedval: U H-HHTYPE = 1
note hcsp_yn: U HED-YN = 1
note hcspval: U H-HHTYPE = 1
note halm_yn: U HCSP-YN = 1
note halmval: U H-HHTYPE = 1
note hfin_yn: U HALM-YN = 1
note hfinval: U H-HHTYPE = 1
note hoi_yn: U HFIN-YN = 1
note hoival: U H-HHTYPE = 1
note htotval: U HOI-YN = 1
note hearnval: U H-HHTYPE = 1
note hothval: U HINC-WS,HINC-SE or HINC-FR = 1
note hmcare: U H-HHTYPE = 1
note hmcaid: U H-HHTYPE = 1
note hchamp: U H-HHTYPE = 1
note hhi_yn: U H-HHTYPE = 1
note hhstatus: U H-HHTYPE = 1
note hunder18: U H-TYPE = 1:8
note htop5pct: U H-HHTYPE = 1
note hpctcut: U H-HHTYPE = 1
note hsup_wgt: U H-HHTYPE = 1
note h1tenure: U H-HHTYPE = 1
note prop_tax: U ALL
note h_idnum1: U H-HHTYPE = 1
note i_hunits: U ALL
note thprop_val: U H-TENURE = 1
note i_propval: U H_HHTYPE = 1
note hrnumwic: U H_HHTYPE = 1
note tcare_val: U HFOODSP = 1
note i_careval: U U�	HRPAIDCC=1
note fh_seq: U All families
note ffpos: U All families
note fkind: U All families
note ftype: U All families
note fpersons: U All families
note fheadidx: U All families
note fwifeidx: U All families
note fhusbidx: U F-KIND = 1
note fspouidx: U F-KIND = 1
note flastidx: U F-KIND = 1
note fmlasidx: U All families
note fownu6: U All families
note frelu6: U All families
note frelu18: U All families
note fpctcut: U All families
note fpovcut: U All families
note frsppct: U F-TYPE = 3
note finc_ws: U F-TYPE = 3
note finc_se: U FINC-WS = 1
note fseval: U All families
note finc_fr: U FINC-SE = 1
note ffrval: U All families
note finc_uc: U FINC-FR = 1
note fucval: U All families
note finc_wc: U FINC-UC = 1
note fwcval: U All families
note finc_ss: U FINC-WC = 1
note fssval: U All families
note finc_ssi: U FINC-SS = 1
note fssival: U All families
note finc_paw: U FINC-SSI = 1
note fpawval: U All families
note finc_vet: U FINC-PAW = 1
note fvetval: U All families
note finc_sur: U FINC-VET = 1
note fsurval: U All families
note finc_dis: U FINC-SUR = 1
note fdisval: U All families
note finc_ret: U FINC-DIS = 1
note fretval: U All families
note finc_int: U FINC-RET = 1
note fintval: U All families
note finc_div: U FINC-INT = 1
note fdivval: U All families
note finc_rnt: U FINC-DIV = 1
note frntval: U All families
note finc_ed: U FINC-RNT = 1
note fedval: U All families
note finc_csp: U FINC-ED = 1
note fcspval: U All families
note finc_alm: U FINC-CSP = 1
note falmval: U All families
note finc_fin: U FINC-ALM = 1
note ffinval: U All families
note finc_oi: U FINC-FIN = 1
note foival: U All families
note ftotval: U FINC=OI = 1
note fearnval: U All families
note fothval: U FINC-WS, FINC-SE OR FINC-FR = 1
note ftot_r: U All other types of income except HEARNVAL
note fspanish: U All families
note fsup_wgt: U All families
note ffposold: U All families
note f_mv_fs: U All families
note pppos: U All
note a_parent: U All
note a_exprrp: U all
note a_age: U All persons
note a_maritl: U All
note a_spouse: U All
note a_sex: U All
note a_hga: U All
note prdtrace: U All
note p_stat: U All
note prdthsp: U All
note a_famnum: U PEHSPNON = 1
note a_famtyp: U All
note a_famrel: U All
note a_pfrel: U All
note hhdrel: U All
note peafwhn1: U A-AGE greater than or equal to 17
note peafwhn2: U PEAFEVER=1
note peafwhn3: U PEAFEVER=1
note peafwhn4: U PEAFEVER=1
note pedisear: U PEAFEVER=1
note pediseye: U PRPERTYP = 2
note pedisrem: U PRPERTYP = 2
note pedisphy: U PRPERTYP = 2
note pedisdrs: U PRPERTYP = 2
note pedisout: U PRPERTYP = 2
note prdisflg: U PRPERTYP = 2
note penatvty: U PRPERTYP = 2
note fl_665: U All
note prdasian: U All
note a_fnlwgt: U PRDTRACE = 04
note marsupwt: U H-MIS=4 or 8
note a_hrs1: U All
note a_uslft: U PEMLR=1
note a_whyabs: U A-HRS1 LE 34
note a_payabs: U PEMLR=2
note peioocc: U CLSWKR = 1-7
note a_clswkr: U CLSWKR = 1-7
note a_wkslk: U PEMLR=1-4 or H-MIS=4 or 8 and PEMLR=5-7
note a_whenlj: U PEMLR=3 or 4
note a_nlflj: U PEMLR = 4
note a_wantjb: U PEMLR=5,6,or 7 and H-MIS=4 or 8 and
note prerelg: U PEMLR=5,6,7
note a_uslhrs: U All
note a_hrlywk: U All
note a_hrspay: U PRERELG=1
note a_grswk: U A-HRLYWK=1
note a_unmem: U PRERELG=1
note a_uncov: U PRERELG=1
note a_enrlw: U A-UNMEM=2
note a_hscol: U A-AGE=16-54
note a_ftpt: U A-ENRLW=1
note a_lfsr: U A-ENRLW=1
note a_untype: U All
note a_wkstat: U A-LFSR=3 or 4
note a_explf: U All
note a_wksch: U A-CLSWRK NE 8
note a_civlf: U All
note a_mjind: U F/T
note a_dtind: U A-CLSWKR = 1-7
note a_mjocc: U A-CLSWKR=1-7
note a_dtocc: U A_CLSWKR = 1-7
note peio1cow: U A-CLSWKR=1-7
note prnlfsch: U PEMLR = 2
note wtemp: U WORKYN = 1 or WTEMP = 1
note nwlook: U WORKYN = 2
note nwlkwk: U WORKYN = 2
note rsnnotw: U NWLOOK = 1
note wkswork: U WORKYN = 2
note wkcheck: U WORKYN = 1
note losewks: U WORKYN = 1
note lknone: U 50 or 51 in WKSWORK
note lkweeks: U 1 to 51 in WKSWORK
note lkstrch: U 1 to 51 in WKSWORK
note pyrsn: U Entry in LKWEEKS
note phmemprs: U Sum of entries in WKSWORK and LKWEEKS add
note hrswk: U Yes in WKSWORK
note hrcheck: U WORKYN = 1
note ptyn: U WORKYN = 1
note ptweeks: U HRCHECK = 2
note ptrsn: U PTYN = 1 or HRCHECK = 1
note wexp: U PTYN = 1 or HRCHECK = 1
note wewkrs: U All adults
note welknw: U All adults
note weuemp: U All adults
note earner: U All adults
note clwk: U All adults
note weclw: U All adults
note poccu2: U All adults
note wemocg: U All adults
note weind: U All adults
note wemind: U All adults
note ljcw: U All adults
note industry: U WORKYN = 1
note occup: U WORKYN = 1
note noemp: U WORKYN = 1
note migsame: U MIGSAME = 2
note ern_otr: U ERN-YN = 1
note wageotr: U ERN-YN = 1
note wsal_yn: U ERN-OTR = 1
note wsal_val: U ERN-YN = 1 or WAGEOTR = 1
note ws_val: U ERN-YN = 1 or WAGEOTR = 1
note seotr: U ERN-OTR = 1
note semp_yn: U ERN-OTR = 1
note semp_val: U ERN-YN = 1 or SEOTR = 1
note frmotr: U SEOTR = 1
note frse_yn: U ERN-OTR = 1
note frse_val: U ERN-YN = 1 or FRMOTR = 1
note frm_val: U ERN-YN = 1 or FRMOTR = 1
note uc_yn: U FRMOTR = 1
note strkuc: U UC-YN = 1
note uc_val: U UC-YN = 1
note wc_yn: U UC-YN = 1
note wc_val: U WC-YN = 1
note ss_yn: U WC-YN = 1
note ss_val: U P-STAT = 1 or 2
note resnss1: U SS-YN = 1
note ssi_val: U P-STAT = 1 or 2
note resnssi1: U SSI-YN = 1
note paw_typ: U P-STAT = 1 or 2
note paw_mon: U PAW-YN = 1
note paw_val: U PAW-YN = 1
note vet_yn: U PAW-YN = 1
note vet_typ1: U P-STAT = 1 or 2
note vet_typ2: U VET-YN = 1
note vet_typ3: U VET-YN = 1
note vet_typ4: U VET-YN = 1
note vet_typ5: U VET-YN = 1
note vet_qva: U VET-YN = 1
note vet_val: U VET-YN = 1
note sur_yn: U VET-YN = 1
note sur_sc1: U P-STAT = 1 or 2
note sur_sc2: U SUR-YN = 1
note sur_val1: U SUR-YN = 1
note sur_val2: U SUR-YN = 1
note srvs_val: U SUR-YN = 1
note dis_cs: U P-STAT = 1 or 2
note dis_yn: U P-STAT = 1 or 2
note dis_sc1: U P-STAT = 1 or 2
note dis_sc2: U DIS-YN = 1
note dis_val1: U DIS-YN = 1
note dis_val2: U DIS-SC1 = 1
note dsab_val: U DIS-SC2 = 1
note ret_sc1: U P-STAT= 1 or 2
note ret_sc2: U RET-YN = 1
note ret_val1: U RET-YN = 1
note ret_val2: U RET-SC1 = 1
note rtm_val: U RET-SC2 = 1
note int_val: U P-STAT = 1 or 2
note div_yn: U INT-YN = 1
note div_non: U P-STAT = 1 or 2
note div_val: U HDIV-YN = 1
note rnt_yn: U DIV-YN = 1
note rnt_val: U P-STAT = 1 or 2
note ed_yn: U RNT-YN = 1
note oed_typ1: U P-STAT = 1 or 2
note oed_typ2: U ED-YN = 1
note oed_typ3: U ED-YN = 1
note ed_val: U ED-YN = 1
note csp_yn: U ED-YN = 1
note csp_val: U P-STAT = 1 or 2
note alm_yn: U CSP-YN = 1
note alm_val: U P-STAT = 1 or 2
note fin_yn: U ALM-YN = 1
note fin_val: U P-STAT = 1 or 2
note oi_off: U FIN-YN = 1
note oi_yn: U OI-YN = 1
note oi_val: U P-STAT = 1 or 2
note ptotval: U OI-YN = 1
note p_mvcare: U HMCARE = 1
note p_mvcaid: U HMCAID = 1
note hi_yn: U HCHAMP = 1
note hiown: U HHI-YN = 1
note hiemp: U HI-YN = 1
note hipaid: U HIOWN = 1
note emcontrb: U HIEMP = 1
note hityp: U PRPERTYP = 2,3
note ahiper: U All
note penincl: U WRK-CK = 1
note filestat: U PENPLAN = 1
note paidccyn: U U
note pxdisear: U PEAFEVER=1
*Everything below this point, aside from the final save, are value labels

#delimit ;

;
label values hrecord  hrecord;
label define hrecord 
	1           "Household record"              
;
label values hunits   hunits; 
label define hunits  
	1           "1 Unit"                        
	2           "2 Units"                       
	3           "3 - 4 Units"                   
	4           "5 - 9 Units"                   
	5           "10+ Units"                     
;
label values hefaminc hefaminc;
label define hefaminc
	-1          "Not in universe"               
	1           "Less than $5,000"              
	2           "$5,000 to $7,499"              
	3           "$7,500 to $9,999"              
	4           "$10,000 to $12,499"            
	5           "$12,500 to $14,999"            
	6           "$15,000 to $19,999"            
	7           "$20,000 to $24,999"            
	8           "$25,000 to $29,999"            
	9           "$30,000 to $34,999"            
	10          "$35,000 to $39,999"            
	11          "$40,000 to $49,999"            
	12          "$50,000 to $59,999"            
	13          "$60,000 to $74,999"            
	14          "$75,000 to $99,999"            
	15          "$100,000 to $149,999"          
	16          "$150,000 and over"             
;
label values h_respnm h_respnm;
label define h_respnm
	-1          "Not in universe (non-interview)"
	0           "Blank or impossible"           
;
label values h_hhtype h_hhtype;
label define h_hhtype
	1           "Interview"                     
	2           "Type A non-interview"          
	3           "Type B/C non-interview"        
;
label values h_numper h_numper;
label define h_numper
	0           "Noninterview household"        
;
label values hnumfam  hnumfam;
label define hnumfam 
	0           "Noninterview household"        
;
label values h_type   h_type; 
label define h_type  
	0           "Non-interview household"       
	1           "Husband/wife primary family"   
	2           "Husband/wife primary family"   
	3           "Unmarried civilian male"       
	4           "Unmarried civilian female"     
	5           "Primary family household -"    
	6           "Civilian male nonfamily"       
	7           "Civilian female nonfamily"     
	8           "Nonfamily householder"         
	9           "Group quarters"                
;
label values h_month  h_month;
label define h_month 
	3           "March"                         
;
label values h_hhnum  h_hhnum;
label define h_hhnum 
	0           "Blank"                         
;
label values h_livqrt h_livqrt;
label define h_livqrt
	1           "House, apt., flat"             
	2           "HU in nontransient hotel, etc."
	3           "HU, perm,  in trans. hotel,"   
	4           "HU in rooming house"           
	5           "Mobile home or trailer with no"
	6           "Mobile home or trailer with 1" 
	7           "HU not specified above"        
	8           "Qtrs not hu in rooming or"     
	9           "Unit not perm in trans. hotel,"
	10          "Tent or trailer site"          
	11          "Student quarters in college"   
	12          "Other not HU"                  
;
label values h_typebc h_typebc;
label define h_typebc
	0           "Interviewed, or Type A"        
	1           "Vacant - regular"              
	2           "Vacant - storage of HHLD"      
	3           "Temp occ by persons with URE"  
	4           "Unfit or to be demolished"     
	5           "Under construction, not ready" 
	6           "Converted to temp business or" 
	7           "Occ by AF members or persons"  
	8           "Unocc tent or trailer site"    
	9           "Permit granted, construction"  
	10          "Other"                         
	11          "Demolished"                    
	12          "House or trailer moved"        
	13          "Outside segment"               
	14          "Converted to perm business"    
	15          "Merged"                        
	16          "Condemned"                     
	17          "Built after April 1, 1980"     
	18          "Unused line of listing sheet"  
	19          "Other"                         
;
label values h_tenure h_tenure;
label define h_tenure
	0           "Not in universe"               
	1           "Owned or being bought"         
	2           "Rent"                          
	3           "No cash rent"                  
;
label values h_telhhd h_telhhd;
label define h_telhhd
	0           "Not in universe (non-interview)"
	1           "Yes"                           
	2           "No"                            
;
label values h_telavl h_telavl;
label define h_telavl
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values h_telint h_telint;
label define h_telint
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values gereg    gereg;  
label define gereg   
	1           "Northeast"                     
	2           "Midwest"                       
	3           "South"                         
	4           "West"                          
;
label values gestcen  gestcen;
label define gestcen 
	11          "Maine"                         
	12          "New Hampshire"                 
	13          "Vermont"                       
	14          "Massachusetts"                 
	15          "Rhode Island"                  
	16          "Connecticut"                   
	21          "New York"                      
	22          "New Jersey"                    
	23          "Pennsylvania"                  
	31          "Ohio"                          
	32          "Indiana"                       
	33          "Illinois"                      
	34          "Michigan"                      
	35          "Wisconsin"                     
	41          "Minnesota"                     
	42          "Iowa"                          
	43          "Missouri"                      
	44          "North Dakota"                  
	45          "South Dakota"                  
	46          "Nebraska"                      
	47          "Kansas"                        
	51          "Delaware"                      
	52          "Maryland"                      
	53          "District Of Columbia"          
	54          "Virginia"                      
	55          "West Virginia"                 
	56          "North Carolina"                
	57          "South Carolina"                
	58          "Georgia"                       
	59          "Florida"                       
	61          "Kentucky"                      
	62          "Tennessee"                     
	63          "Alabama"                       
	64          "Mississippi"                   
	71          "Arkansas"                      
	72          "Louisiana"                     
	73          "Oklahoma"                      
	74          "Texas"                         
	81          "Montana"                       
	82          "Idaho"                         
	83          "Wyoming"                       
	84          "Colorado"                      
	85          "New Mexico"                    
	86          "Arizona"                       
	87          "Utah"                          
	88          "Nevada"                        
	91          "Washington"                    
	92          "Oregon"                        
	93          "California"                    
	94          "Alaska"                        
	95          "Hawaii"                        
;
label values gtcbsa   gtcbsa; 
label define gtcbsa  
	0           "Non-met or not identified"     
;
label values gtco     gtco;   
label define gtco    
	0           "Not identified"                
;
label values gtcbsast gtcbsast;
label define gtcbsast
	1           "Principal city"                
	2           "Balance of CBSA"               
	3           "Non CBSA"                      
	4           "Not identified"                
;
label values gtmetsta gtmetsta;
label define gtmetsta
	1           "Metropolitan"                  
	2           "Non-metropolitan"              
	3           "Not identified"                
;
label values gtindvpc gtindvpc;
label define gtindvpc
	0           "Not identified, non-met, or"   
;
label values gtcbsasz gtcbsasz;
label define gtcbsasz
	0           "Not identified or"             
	2           "100,000 - 249,999"             
	3           "250,000 - 499,999"             
	4           "500,000 - 999,999"             
	5           "1,000,000 - 2,499,999"         
	6           "2,500,000 - 4,999,999"         
	7           "5,000,000+"                    
;
label values gtcsa    gtcsa;  
label define gtcsa   
	0           "Non-met or not identified"     
;
label values hunder15 hunder1e;
label define hunder1e
	0           "None"                          
;
label values hh5to18  hh5to18l;
label define hh5to18l
	0           "None"                          
;
label values hhotlun  hhotlun;
label define hhotlun 
	0           "Not in universe"               
	1           "All or some"                   
	2           "None"                          
;
label values hhotno   hhotno; 
label define hhotno  
	0           "Not in universe"               
	1           "1 child"                       
	9           "9 or more children"            
;
label values hflunch  hflunch;
label define hflunch 
	0           "Not in universe"               
	1           "Some or all"                   
	2           "None"                          
;
label values hflunno  hflunno;
label define hflunno 
	0           "Not in universe"               
	1           "1"                             
	9           "9 or more"                     
;
label values hpublic  hpublic;
label define hpublic 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hlorent  hlorent;
label define hlorent 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hfoodsp  hfoodsp;
label define hfoodsp 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hfoodno  hfoodno;
label define hfoodno 
	0           "Not in universe"               
	1           "1"                             
	9           "9 or more"                     
;
label values hfoodmo  hfoodmo;
label define hfoodmo 
	0           "Not in universe"               
	1           "1 month"                       
	12          "12 Months"                     
;
label values hengast  hengast;
label define hengast 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hengval  hengval;
label define hengval 
	0           "Not in universe"               
;
label values hinc_ws  hinc_ws;
label define hinc_ws 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hwsval   hwsval; 
label define hwsval  
	0           "None or not in universe"       
;
label values hinc_se  hinc_se;
label define hinc_se 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hseval   hseval; 
label define hseval  
	0           "None or not in universe"       
;
label values hinc_fr  hinc_fr;
label define hinc_fr 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hfrval   hfrval; 
label define hfrval  
	0           "None or not in universe"       
;
label values hinc_uc  hinc_uc;
label define hinc_uc 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hucval   hucval; 
label define hucval  
	0           "None or not in universe"       
;
label values hinc_wc  hinc_wc;
label define hinc_wc 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hwcval   hwcval; 
label define hwcval  
	0           "None or not in universe"       
;
label values hss_yn   hss_yn; 
label define hss_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hssval   hssval; 
label define hssval  
	0           "None or not in universe"       
;
label values hssi_yn  hssi_yn;
label define hssi_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hssival  hssival;
label define hssival 
	0           "None"                          
;
label values hpaw_yn  hpaw_yn;
label define hpaw_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hpawval  hpawval;
label define hpawval 
	0           "None"                          
;
label values hvet_yn  hvet_yn;
label define hvet_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hvetval  hvetval;
label define hvetval 
	0           "None or not in universe"       
;
label values hsur_yn  hsur_yn;
label define hsur_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hsurval  hsurval;
label define hsurval 
	0           "None or not in universe"       
;
label values hdis_yn  hdis_yn;
label define hdis_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hdisval  hdisval;
label define hdisval 
	0           "None or not in universe"       
;
label values hret_yn  hret_yn;
label define hret_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hretval  hretval;
label define hretval 
	0           "None or not in universe"       
;
label values hint_yn  hint_yn;
label define hint_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hintval  hintval;
label define hintval 
	0           "None or not in universe"       
;
label values hdiv_yn  hdiv_yn;
label define hdiv_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hdivval  hdivval;
label define hdivval 
	0           "None or not in universe"       
;
label values hrnt_yn  hrnt_yn;
label define hrnt_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hrntval  hrntval;
label define hrntval 
	0           "None or not in universe"       
;
label values hed_yn   hed_yn; 
label define hed_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hedval   hedval; 
label define hedval  
	0           "None or not in universe"       
;
label values hcsp_yn  hcsp_yn;
label define hcsp_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hcspval  hcspval;
label define hcspval 
	0           "None or not in universe"       
;
label values halm_yn  halm_yn;
label define halm_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values halmval  halmval;
label define halmval 
	0           "None or not in universe"       
;
label values hfin_yn  hfin_yn;
label define hfin_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hfinval  hfinval;
label define hfinval 
	0           "None or not in universe"       
;
label values hoi_yn   hoi_yn; 
label define hoi_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hoival   hoival; 
label define hoival  
	0           "None or not in universe"       
;
label values htotval  htotval;
label define htotval 
	0           "None or not in universe"       
;
label values hearnval hearnval;
label define hearnval
	0           "None or not in universe"       
;
label values hothval  hothval;
label define hothval 
	0           "None or not in universe"       
;
label values hhinc    hhinc;  
label define hhinc   
	0           "Not in universe"               
	1           "Under $2,500"                  
	2           "$2,500 to $4,999"              
	3           "$5,000 to $7,499"              
	4           "$7,500 to $9,999"              
	5           "$10,000 to $12,499"            
	6           "$12,500 to $14,999"            
	7           "$15,000 to $17,499"            
	8           "$17,500 to $19,999"            
	9           "$20,000 to $22,499"            
	10          "$22,500 to $24,999"            
	11          "$25,000 to $27,499"            
	12          "$27,500 to $29,999"            
	13          "$30,000 to $32,499"            
	14          "$32,500 to $34,999"            
	15          "$35,000 to $37,499"            
	16          "$37,500 to $39,999"            
	17          "$40,000 to $42,499"            
	18          "$42,500 to $44,999"            
	19          "$45,000 to $47,499"            
	20          "$47,500 to $49,999"            
	21          "$50,000 to $52,499"            
	22          "$52,500 to $54,999"            
	23          "$55,000 to $57,499"            
	24          "$57,500 to $59,999"            
	25          "$60,000 to $62,499"            
	26          "$62,500 to $64,999"            
	27          "$65,000 to $67,499"            
	28          "$67,500 to $69,999"            
	29          "$70,000 to $72,499"            
	30          "$72,500 to $74,999"            
	31          "$75,000 to $77,499"            
	32          "$77,500 to $79,999"            
	33          "$80,000 to $82,499"            
	34          "$82,500 to $84,999"            
	35          "$85,000 to $87,499"            
	36          "$87,500 to $89,999"            
	37          "$90,000 to $92,499"            
	38          "$92,500 to $94,999"            
	39          "$95,000 to $97,499"            
	40          "$97,500 to $99,999"            
	41          "$100,000 and over"             
;
label values hmcare   hmcare; 
label define hmcare  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hmcaid   hmcaid; 
label define hmcaid  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hchamp   hchamp; 
label define hchamp  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hhi_yn   hhi_yn; 
label define hhi_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hhstatus hhstatus;
label define hhstatus
	0           "Not in universe (group"        
	1           "Primary family"                
	2           "Nonfamily householder living"  
	3           "Nonfamily householder living"  
;
label values hunder18 hunder1h;
label define hunder1h
	0           "None"                          
;
label values htop5pct htop5pct;
label define htop5pct
	0           "Not in universe (group"        
	1           "In top 5 percent"              
	2           "Not in top 5 percent"          
;
label values hpctcut  hpctcut;
label define hpctcut 
	0           "Not in universe (group"        
	1           "Lowest 5 percent"              
	2           "Second 5 percent"              
	20          "Top 5 percent"                 
;
label values h1tenure h1tenure;
label define h1tenure
	0           "No change"                     
	1           "Value to blank"                
	4           "Allocated"                     
;
label values h1livqrt h1livqrt;
label define h1livqrt
	0           "No change"                     
	4           "Allocated"                     
	7           "Blank to NA - no error"        
;
label values h1telhhd h1telhhd;
label define h1telhhd
	0           "No change"                     
	1           "Value to blank"                
	4           "Allocated"                     
;
label values h1telavl h1telavl;
label define h1telavl
	0           "No change"                     
	1           "Value to blank"                
	4           "Allocated"                     
;
label values h1telint h1telint;
label define h1telint
	0           "No change"                     
	1           "Value to blank"                
	4           "Allocated"                     
;
label values i_hhotlu i_hhotlu;
label define i_hhotlu
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hhotno i_hhotno;
label define i_hhotno
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hflunc i_hflunc;
label define i_hflunc
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hflunn i_hflunn;
label define i_hflunn
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hpubli i_hpubli;
label define i_hpubli
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hloren i_hloren;
label define i_hloren
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hfoods i_hfoods;
label define i_hfoods
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hfdval i_hfdval;
label define i_hfdval
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hfoodn i_hfoodn;
label define i_hfoodn
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hfoodm i_hfoodm;
label define i_hfoodm
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hengas i_hengas;
label define i_hengas
	0           "No change"                     
	1           "Allocated"                     
;
label values i_hengva i_hengva;
label define i_hengva
	0           "No change"                     
	1           "Allocated"                     
;
label values prop_tax prop_tax;
label define prop_tax
	0           "None"                          
;
label values housret  housret;
label define housret 
	0           "None"                          
;
label values hrhtype  hrhtype;
label define hrhtype 
	0           "Non-interview household"       
	1           "Husband/wife primary family"   
	2           "Husband/wife primary family"   
	3           "Unmarried civilian male"       
	4           "Unmarried civilian female"     
	5           "Primary family household -"    
	6           "Civilian male nonfamily"       
	7           "Civilian female nonfamily"     
	8           "Nonfamily householder"         
	9           "Group quarters with actual"    
	10          "Group quarters with secondary" 
;
label values i_hunits i_hunits;
label define i_hunits
	0           "No change"                     
	1           "Allocated"                     
;
label values hrpaidcc hrpaidcc;
label define hrpaidcc
	0           "NIU"                           
	1           "YES"                           
	2           "NO"                            
;
label values hprop_val hprop_val;
label define hprop_val
	0           "Not in universe"               
;
label values thprop_val thprop_val;
label define thprop_val
	0           "Not swapped"                   
	1           "Topcoded"                      
;
label values i_propval i_propval;
label define i_propval
	0           "No allocation"                 
	1           "Allocated"                     
;
label values hrwicyn  hrwicyn;
label define hrwicyn 
	0           "NIU"                           
	1           "YES"                           
	2           "NO"                            
;
label values hfdval   hfdval; 
label define hfdval  
	0           "Not in universe"               
;
label values tcare_val tcare_val;
label define tcare_val
	0           "No change"                     
	1           "Topcoded"                      
;
label values care_val care_val;
label define care_val
	0           "Not in universe"               
;
label values i_careval i_careval;
label define i_careval
	0           "No change"                     
	1           "Allocated"                     
;
label values hpres_mort hpres_mort;
label define hpres_mort
	0           " Not in universe"              
	1           " Yes"                          
	2           " No"                           
;
label values frecord  frecord;
label define frecord 
	2           "Family record"                 
;
label values fkind    fkind;  
label define fkind   
	1           "Husband-wife family"           
	2           "Male reference person"         
	3           "Female reference person"       
;
label values ftype    ftype;  
label define ftype   
	1           "Primary family"                
	2           "Nonfamily householder"         
	3           "Related subfamily"             
	4           "Unrelated subfamily"           
	5           "Secondary individual"          
;
label values fwifeidx fwifeidx;
label define fwifeidx
	0           "No wife"                       
;
label values fhusbidx fhusbidx;
label define fhusbidx
	0           "No husband"                    
;
label values fspouidx fspouidx;
label define fspouidx
	0           "No spouse"                     
;
label values fownu6   fownu6l;
label define fownu6l 
	0           "None, not in universe"         
	1           "1"                             
	2           "2"                             
	6           "6+"                            
;
label values fownu18  fownu18l;
label define fownu18l
	0           "None, not in universe"         
	1           "1"                             
	9           "9 or more"                     
;
label values frelu6   frelu6l;
label define frelu6l 
	0           "None, not in universe"         
	1           "1"                             
	2           "2"                             
	6           "6+"                            
;
label values frelu18  frelu18l;
label define frelu18l
	0           "None, not in universe"         
	1           "1"                             
	2           "2"                             
	9           "9+"                            
;
label values fpctcut  fpctcut;
label define fpctcut 
	0           "NIU (FTYPE=2+)"                
	1           "Lowest 5 percent"              
	2           "Second 5 percent"              
	20          "Top 5 percent"                 
;
label values famlis   famlis; 
label define famlis  
	1           "Below low-income level"        
	2           "100 - 124 percent of the low-" 
	3           "125 - 149 percent of the low-" 
	4           "150 percent and above the"     
;
label values povll    povll;  
label define povll   
	1           "Under .50"                     
	2           ".50 to .74"                    
	3           ".75 to .99"                    
	4           "1.00 to 1.24"                  
	5           "1.25 to 1.49"                  
	6           "1.50 to 1.74"                  
	7           "1.75 to 1.99"                  
	8           "2.00 to 2.49"                  
	9           "2.50 to 2.99"                  
	10          "3.00 to 3.49"                  
	11          "3.50 to 3.99"                  
	12          "4.00 to 4.49"                  
	13          "4.50 to 4.99"                  
	14          "5.00 and over"                 
;
label values frspov   frspov; 
label define frspov  
	0           "Not in universe"               
	1           "Under .50"                     
	2           ".50 to .74"                    
	3           ".75 to .99"                    
	4           "1.00 to 1.24"                  
	5           "1.25 to 1.49"                  
	6           "1.50 to 1.74"                  
	7           "1.75 to 1.99"                  
	8           "2.00 to 2.49"                  
	9           "2.50 to 2.99"                  
	10          "3.00 to 3.49"                  
	11          "3.50 to 3.99"                  
	12          "4.00 to 4.49"                  
	13          "4.50 to 4.99"                  
	14          "5.00 and over"                 
;
label values finc_ws  finc_ws;
label define finc_ws 
	1           "Yes"                           
	2           "No"                            
;
label values finc_se  finc_se;
label define finc_se 
	1           "Yes"                           
	2           "No"                            
;
label values fseval   fseval; 
label define fseval  
	0           "None or not in universe"       
;
label values finc_fr  finc_fr;
label define finc_fr 
	1           "Yes"                           
	2           "No"                            
;
label values ffrval   ffrval; 
label define ffrval  
	0           "None or not in universe"       
;
label values finc_uc  finc_uc;
label define finc_uc 
	1           "Yes"                           
	2           "No"                            
;
label values fucval   fucval; 
label define fucval  
	0           "None or not in universe"       
;
label values finc_wc  finc_wc;
label define finc_wc 
	1           "Yes"                           
	2           "No"                            
;
label values fwcval   fwcval; 
label define fwcval  
	0           "None or not in universe"       
;
label values finc_ss  finc_ss;
label define finc_ss 
	1           "Yes"                           
	2           "No"                            
;
label values fssval   fssval; 
label define fssval  
	0           "None or not in universe"       
;
label values finc_ssi finc_ssi;
label define finc_ssi
	1           "Yes"                           
	2           "No"                            
;
label values fssival  fssival;
label define fssival 
	0           "None"                          
;
label values finc_paw finc_paw;
label define finc_paw
	1           "Yes"                           
	2           "No"                            
;
label values fpawval  fpawval;
label define fpawval 
	0           "None"                          
;
label values finc_vet finc_vet;
label define finc_vet
	1           "Yes"                           
	2           "No"                            
;
label values fvetval  fvetval;
label define fvetval 
	0           "None or not in universe"       
;
label values finc_sur finc_sur;
label define finc_sur
	1           "Yes"                           
	2           "No"                            
;
label values fsurval  fsurval;
label define fsurval 
	0           "None or not in universe"       
;
label values finc_dis finc_dis;
label define finc_dis
	1           "Yes"                           
	2           "No"                            
;
label values fdisval  fdisval;
label define fdisval 
	0           "None or not in universe"       
;
label values finc_ret finc_ret;
label define finc_ret
	1           "Yes"                           
	2           "No"                            
;
label values fretval  fretval;
label define fretval 
	0           "None or not in universe"       
;
label values finc_int finc_int;
label define finc_int
	1           "Yes"                           
	2           "No"                            
;
label values fintval  fintval;
label define fintval 
	0           "None or not in universe"       
;
label values finc_div finc_div;
label define finc_div
	1           "Yes"                           
	2           "No"                            
;
label values fdivval  fdivval;
label define fdivval 
	0           "None or not in universe"       
;
label values finc_rnt finc_rnt;
label define finc_rnt
	1           "Yes"                           
	2           "No"                            
;
label values frntval  frntval;
label define frntval 
	0           "None or not in universe"       
;
label values finc_ed  finc_ed;
label define finc_ed 
	1           "Yes"                           
	2           "No"                            
;
label values fedval   fedval; 
label define fedval  
	0           "None or not in universe"       
;
label values finc_csp finc_csp;
label define finc_csp
	1           "Yes"                           
	2           "No"                            
;
label values fcspval  fcspval;
label define fcspval 
	0           "None or not in universe"       
;
label values finc_alm finc_alm;
label define finc_alm
	1           "Yes"                           
	2           "No"                            
;
label values falmval  falmval;
label define falmval 
	0           "None or not in universe"       
;
label values finc_fin finc_fin;
label define finc_fin
	1           "Yes"                           
	2           "No"                            
;
label values ffinval  ffinval;
label define ffinval 
	0           "None or not in universe"       
;
label values finc_oi  finc_oi;
label define finc_oi 
	1           "Yes"                           
	2           "No"                            
;
label values foival   foival; 
label define foival  
	0           "None or not in universe"       
;
label values ftotval  ftotval;
label define ftotval 
	0           "None or not in universe"       
;
label values fearnval fearnval;
label define fearnval
	0           "None or not in universe"       
;
label values fothval  fothval;
label define fothval 
	0           "None"                          
;
label values ftot_r   ftot_r; 
label define ftot_r  
	1           "Under $2,500"                  
	2           "$2,500 to $4,999"              
	3           "$5,000 to $7,499"              
	4           "$7,500 to $9,999"              
	5           "$10,000 to $12,499"            
	6           "$12,500 to $14,999"            
	7           "$15,000 to $17,499"            
	8           "$17,500 to $19,999"            
	9           "$20,000 to $22,499"            
	10          "$22,500 to $24,999"            
	11          "$25,000 to $27,499"            
	12          "$27,500 to $29,999"            
	13          "$30,000 to $32,499"            
	14          "$32,500 to $34,999"            
	15          "$35,000 to $37,499"            
	16          "$37,500 to $39,999"            
	17          "$40,000 to $42,499"            
	18          "$42,500 to $44,999"            
	19          "$45,000 to $47,499"            
	20          "$47,500 to $49,999"            
	21          "$50,000 to $52,499"            
	22          "$52,500 to $54,999"            
	23          "$55,000 to $57,499"            
	24          "$57,500 to $59,999"            
	25          "$60,000 to $62,499"            
	26          "$62,500 to $64,999"            
	27          "$65,000 to $67,499"            
	28          "$67,500 to $69,999"            
	29          "$70,000 to $72,499"            
	30          "$72,500 to $74,999"            
	31          "$75,000 to $77,499"            
	32          "$77,500 to $79,999"            
	33          "$80,000 to $82,499"            
	34          "$82,500 to $84,999"            
	35          "$85,000 to $87,499"            
	36          "$87,500 to $89,999"            
	37          "$90,000 to $92,499"            
	38          "$92,500 to $94,999"            
	39          "$95,000 to $97,499"            
	40          "$97,500 to $99,999"            
	41          "$100,000 and over"             
;
label values fspanish fspanish;
label define fspanish
	1           "Yes"                           
	2           "No"                            
;
label values f_mv_fs  f_mv_fs;
label define f_mv_fs 
	0           "None"                          
;
label values f_mv_sl  f_mv_sl;
label define f_mv_sl 
	0           "None"                          
;
label values ffngcare ffngcare;
label define ffngcare
	0           "None"                          
;
label values ffngcaid ffngcaid;
label define ffngcaid
	0           "None"                          
;
label values fhoussub fhoussub;
label define fhoussub
	0           "None"                          
;
label values ffoodreq ffoodreq;
label define ffoodreq
	0           "None"                          
;
label values fhousreq fhousreq;
label define fhousreq
	0           "None"                          
;
label values fhip_val fhip_val;
label define fhip_val
	0           "Not in Universe"               
;
label values fmoop    fmoop;  
label define fmoop   
	0           "Not in Universe"               
;
label values fotc_val fotc_val;
label define fotc_val
	0           " Not in Universe"              
;
label values fmed_val fmed_val;
label define fmed_val
	0           "Not in Universe"               
;
label values i_fhipval i_fhipval;
label define i_fhipval
	0           "No change"                     
	1           "Allocated"                     
;
label values precord  precord;
label define precord 
	3           "Person record"                 
;
label values a_parent a_parent;
label define a_parent
	0           "None"                          
;
label values a_exprrp a_exprrp;
label define a_exprrp
	1           "Reference person with relatives"
	2           "Reference person without"      
	3           "Husband"                       
	4           "Wife"                          
	5           "Own child"                     
	7           "Grandchild"                    
	8           "Parent"                        
	9           "Brother/sister"                
	10          "Other relative"                
	11          "Foster child"                  
	12          "Nonrelative with relatives"    
	13          "Partner/roommate"              
	14          "Nonrelative without relatives" 
;
label values perrp    perrp;  
label define perrp   
	1           "Reference person w/rels."      
	2           "Reference person w/o rels."    
	3           "Spouse"                        
	4           "Child"                         
	5           "Grandchild"                    
	6           "Parent"                        
	7           "Brother/sister"                
	8           "Other rel. of ref. person"     
	9           "Foster child"                  
	10          "Nonrel. of ref. person w/rels."
	11          "Not used"                      
	12          "Nonrel. of ref. person w/o"    
	13          "Unmarried partner w/rels."     
	14          "Unmarried partner w/o rels."   
	15          "Housemate/roommate w/rels."    
	16          "Housemate/roommate w/o rels."  
	17          "Roomer/boarder w/rels."        
	18          "Roomer/boarder w/o rels."      
;
label values a_age    a_age;  
label define a_age   
	80          "80-84 years of age"            
	85          "85+ years of age"              
;
label values a_maritl a_maritl;
label define a_maritl
	1           "Married - civilian spouse"     
	2           "Married - AF spouse present"   
	3           "Married - spouse absent (exc." 
	4           "Widowed"                       
	5           "Divorced"                      
	6           "Separated"                     
	7           "Never married"                 
;
label values a_spouse a_spouse;
label define a_spouse
	0           "None or children"              
;
label values a_sex    a_sex;  
label define a_sex   
	1           "Male"                          
	2           "Female"                        
;
label values a_hga    a_hga;  
label define a_hga   
	0           "Children"                      
	31          "Less than 1st grade"           
	32          "1st,2nd,3rd,or 4th grade"      
	33          "5th or 6th grade"              
	34          "7th and 8th grade"             
	35          "9th grade"                     
	36          "10th grade"                    
	37          "11th grade"                    
	38          "12th grade no diploma"         
	39          "High school graduate - high"   
	40          "Some college but no degree"    
	41          "Associate degree in college -" 
	42          "Associate degree in college -" 
	43          "Bachelor's degree (for"        
	44          "Master's degree (for"          
	45          "Professional school degree (for"
	46          "Doctorate degree (for"         
;
label values prdtrace prdtrace;
label define prdtrace
	1           "White only"                    
	2           "Black only"                    
	3           "American Indian,"              
	4           "Asian only"                    
	5           "Hawaiian/Pacific Islander"     
	6           "White-Black"                   
	7           "White-AI"                      
	8           "White-Asian"                   
	9           "White-HP"                      
	10          "Black-AI"                      
	11          "Black-Asian"                   
	12          "Black-HP"                      
	13          "AI-Asian"                      
	14          "AI-HP"                         
	15          "Asian-HP"                      
	16          "White-Black-AI"                
	17          "White-Black-Asian"             
	18          "White-Black-HP"                
	19          "White-AI-Asian"                
	20          "White-AI-HP"                   
	21          "White-Asian-HP"                
	22          "Black-AI-Asian"                
	23          "White-Black-AI-Asian"          
	24          "White-AI-Asian-HP"             
	25          "Other 3 race comb."            
	26          "Other 4 or 5 race comb."       
;
label values p_stat   p_stat; 
label define p_stat  
	1           "Civilian 15+"                  
	2           "Armed Forces"                  
	3           "Children 0 - 14"               
;
label values prpertyp prpertyp;
label define prpertyp
	1           "Child household member"        
	2           "Adult civilian household member"
	3           "Adult Armed Forces household"  
;
label values pehspnon pehspnon;
label define pehspnon
	1           "Yes"                           
	2           "No"                            
;
label values prdthsp  prdthsp;
label define prdthsp 
	0           "Not in universe"               
	1           "Mexican"                       
	2           "Puerto Rican"                  
	3           "Cuban"                         
	4           "Dominican"                     
	5           "Salvadoran"                    
	6           "Central American, (exc. Salv)" 
	7           "South American"                
	8           "Other Hispanic"                
;
label values a_famnum a_famnum;
label define a_famnum
	0           "Not a family member"           
	1           "Primary family member only"    
;
label values a_famtyp a_famtyp;
label define a_famtyp
	1           "Primary family"                
	2           "Nonfamily householder"         
	3           "Related subfamily"             
	4           "Unrelated subfamily"           
	5           "Secondary individual"          
;
label values a_famrel a_famrel;
label define a_famrel
	0           "Not a family member"           
	1           "Reference person"              
	2           "Spouse"                        
	3           "Child"                         
	4           "Other relative (primary"       
;
label values a_pfrel  a_pfrel;
label define a_pfrel 
	0           "Not in primary family"         
	1           "Husband"                       
	2           "Wife"                          
	3           "Own child"                     
	4           "Other relative"                
	5           "Unmarried reference person"    
;
label values hhdrel   hhdrel; 
label define hhdrel  
	1           "Householder"                   
	2           "Spouse of householder"         
	3           "Under 18 years, single (never" 
	4           "Under 18 years, ever married"  
	5           "18 years and over"             
	6           "Other relative of householder" 
	7           "Nonrelative of householder"    
	8           "Secondary individual"          
;
label values famrel   famrel; 
label define famrel  
	1           "Reference person of family"    
	2           "Spouse of reference person"    
	3           "Under 18 years, single (never" 
	4           "Under 18 years, ever married"  
	5           "18 years and over"             
	6           "Grandchild of reference person"
	7           "Under 18 years, single (never" 
	8           "Under 18 years, ever married"  
	9           "18 years and over"             
	10          "Nonfamily householder"         
	11          "Secondary individual"          
;
label values hhdfmx   hhdfmx; 
label define hhdfmx  
	1           "Householder"                   
	2           "Spouse of householder"         
	3           "Reference person of subfamily" 
	4           "Not in a subfamily"            
	5           "Reference person of subfamily" 
	6           "Spouse of subfamily reference" 
	7           "Not in a subfamily"            
	8           "Head of a subfamily"           
	9           "Not in a subfamily"            
	10          "Reference person of subfamily" 
	11          "Spouse of subfamily reference" 
	12          "Not in a subfamily"            
	23          "Reference person of subfamily" 
	24          "Child of a subfamily"          
	25          "Not in a subfamily"            
	26          "Reference person of subfamily" 
	27          "Spouse of subfamily reference" 
	28          "Not used"                      
	29          "Not in a subfamily"            
	30          "Reference person of a subfamily"
	31          "Not in a subfamily"            
	32          "Reference person of subfamily" 
	33          "Spouse of subfamily reference" 
	34          "Not in a subfamily"            
	35          "Reference person of subfamily" 
	36          "Child of subfamily reference"  
	37          "Not in a subfamily"            
	38          "Reference person of subfamily" 
	39          "Spouse of subfamily reference" 
	40          "Not in a subfamily"            
	41          "Reference person of a subfamily"
	42          "Not in a subfamily"            
	43          "Reference person of subfamily" 
	44          "Spouse of subfamily reference" 
	45          "Not in a subfamily"            
	46          "Reference person of unrelated" 
	47          "Spouse of unrelated subfamily" 
	48          "Child < 18, single (never-"    
	49          "Nonfamily householder"         
	50          "Secondary individual"          
	51          "In group quarters"             
;
label values parent   parent; 
label define parent  
	0           "Not in universe"               
	1           "Both parents present"          
	2           "Mother only present"           
	3           "Father only present"           
	4           "Neither parent present"        
;
label values age1     age1l;  
label define age1l   
	0           "Not in universe"               
	1           "15 years"                      
	2           "16 and 17 years"               
	3           "18 and 19 years"               
	4           "20 and 21 years"               
	5           "22 to 24 years"                
	6           "25 to 29 years"                
	7           "30 to 34 years"                
	8           "35 to 39 years"                
	9           "40 to 44 years"                
	10          "45 to 49 years"                
	11          "50 to 54 years"                
	12          "55 to 59 years"                
	13          "60 to 61 years"                
	14          "62 to 64 years"                
	15          "65 to 69 years"                
	16          "70 to 74 years"                
	17          "75 years and over"             
;
label values pecohab  pecohab;
label define pecohab 
	-1          "No Partner present"            
;
label values pelnmom  pelnmom;
label define pelnmom 
	-1          "No Mother present"             
	1           "Min Value"                     
	16          "Max Value"                     
;
label values pelndad  pelndad;
label define pelndad 
	-1          "No Father present"             
;
label values pemomtyp pemomtyp;
label define pemomtyp
	-1          "No Mother present"             
	1           "Biological"                    
	2           "Step"                          
	3           "Adopted"                       
;
label values pedadtyp pedadtyp;
label define pedadtyp
	-1          "No Father present"             
	1           "Biological"                    
	2           "Step"                          
	3           "Adopted"                       
;
label values peafever peafever;
label define peafever
	-1          "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values peafwhn1 peafwhna;
label define peafwhna
	-1          "Not in universe"               
	1           "September 2001 or later"       
	2           "August 1990 to August 2001"    
	3           "May 1975 to July 1990"         
	4           "Vietnam Era (August 1964 to"   
	5           "February 1955 to July 1964"    
	6           "Korean War (July 1950 to"      
	7           "January 1947 to June 1950"     
	8           "World War II (December 1941"   
	9           "November 1941 or earlier"      
;
label values peafwhn2 peafwhnb;
label define peafwhnb
	-1          "Not in universe"               
	1           "September 2001 or later"       
	2           "August 1990 to August 2001"    
	3           "May 1975 to July 1990"         
	4           "Vietnam Era (August 1964 to"   
	5           "February 1955 to July 1964"    
	6           "Korean War (July 1950 to"      
	7           "January 1947 to June 1950"     
	8           "World War II (December 1941"   
	9           "November 1941 or earlier"      
;
label values peafwhn3 peafwhnc;
label define peafwhnc
	-1          "Not in universe"               
	1           "September 2001 or later"       
	2           "August 1990 to August 2001"    
	3           "May 1975 to July 1990"         
	4           "Vietnam Era (August 1964 to"   
	5           "February 1955 to July 1964"    
	6           "Korean War (July 1950 to"      
	7           "January 1947 to June 1950"     
	8           "World War II (December 1941"   
	9           "November 1941 or earlier"      
;
label values peafwhn4 peafwhnd;
label define peafwhnd
	-1          "Not in universe"               
	1           "September 2001 or later"       
	2           "August 1990 to August 2001"    
	3           "May 1975 to July 1990"         
	4           "Vietnam Era (August 1964 to"   
	5           "February 1955 to July 1964"    
	6           "Korean War (July 1950 to"      
	7           "January 1947 to June 1950"     
	8           "World War II (December 1941"   
	9           "November 1941 or earlier"      
;
label values pedisear pedisear;
label define pedisear
	-1          "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values pediseye pediseye;
label define pediseye
	-1          "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values pedisrem pedisrem;
label define pedisrem
	-1          "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values pedisphy pedisphy;
label define pedisphy
	-1          "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values pedisdrs pedisdrs;
label define pedisdrs
	-1          "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values pedisout pedisout;
label define pedisout
	-1          "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values prdisflg prdisflg;
label define prdisflg
	-1          "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values peinusyr peinusyr;
label define peinusyr
	0           "NIU"                           
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
	14          "1994-1995"                     
	15          "1996-1997"                     
	16          "1998-1999"                     
	17          "2000-2001"                     
	18          "2002-2003"                     
	19          "2004-2005"                     
	20          "2006-2007"                     
	21          "2008-2009"                     
	22          "2010-2011"                     
	23          "2012-2014"                     
;
label values prcitshp prcitshp;
label define prcitshp
	1           "Native, born in the United"    
	2           "Native, born in Puerto Rico or"
	3           "Native, born abroad of American"
	4           "Foreign born, U.S. citizen by" 
	5           "Foreign born, not a citizen of"
;
label values fl_665   fl_665l;
label define fl_665l 
	0           "Complete nonresponse to"       
	1           "Supplement interview"          
	2           "Some supplement response but"  
	3           "Supplement interview but not"  
;
label values prdasian prdasian;
label define prdasian
	-1          "NIU"                           
	1           "Asian Indian"                  
	2           "Chinese"                       
	3           "Filipino"                      
	4           "Japanese"                      
	5           "Korean"                        
	6           "Vietnamese"                    
	7           "Other Asian"                   
;
label values a_fnlwgt a_fnlwgt;
label define a_fnlwgt
	0           "Supplemental Spanish sample"   
;
label values a_ernlwt a_ernlwt;
label define a_ernlwt
	0           "Not in universe or children and"
;
label values a_hrs1   a_hrs1l;
label define a_hrs1l 
	-1          "Not in universe"               
	0           "Children and Armed Forces"     
;
label values a_uslft  a_uslft;
label define a_uslft 
	0           "Not in universe or children and"
	1           "Yes"                           
	2           "No"                            
;
label values a_whyabs a_whyabs;
label define a_whyabs
	0           "Not in universe or children and"
	1           "Own illness"                   
	2           "On vacation"                   
	3           "Bad weather"                   
	4           "Labor dispute"                 
	8           "Other"                         
;
label values a_payabs a_payabs;
label define a_payabs
	0           "Not in universe or children and"
	1           "Yes"                           
	2           "No"                            
	3           "Self-employed"                 
;
label values peioind  peioind;
label define peioind 
	0           "Not in universe or children"   
;
label values peioocc  peioocc;
label define peioocc 
	-001        "Not in universe or children"   
;
label values a_clswkr a_clswkr;
label define a_clswkr
	0           "Not in universe or children and"
	1           "Private"                       
	2           "Federal government"            
	3           "State government"              
	4           "Local government"              
	5           "Self-employed-incorporated"    
	6           "Self-employed-not incorporated"
	7           "Without pay"                   
	8           "Never worked"                  
;
label values a_wkslk  a_wkslk;
label define a_wkslk 
	-1          "Not in universe"               
	0           "Children or Armed Forces"      
;
label values a_whenlj a_whenlj;
label define a_whenlj
	0           "Not in universe or children and"
	1           "In last 12 months"             
	2           "More than 12 months ago"       
	5           "Never worked at all"           
;
label values a_nlflj  a_nlflj;
label define a_nlflj 
	0           "Not in universe or children and"
	1           "Within a past 12 months"       
	3           "More than 12 months ago"       
	7           "Never worked"                  
;
label values a_wantjb a_wantjb;
label define a_wantjb
	0           "Not in universe or children and"
	1           "Yes"                           
	2           "No"                            
	5           "February 1955 to July 1964"    
	6           "Korean War (July 1950 to"      
	7           "January 1947 to June 1950"     
	8           "World War II (December 1941"   
	9           "November 1941 or earlier"      
;
label values prerelg  prerelg;
label define prerelg 
	0           "Not earnings eligible"         
	1           "Earnings eligible"             
;
label values a_uslhrs a_uslhrs;
label define a_uslhrs
	-4          "Hours vary"                    
	-1          "Not in universe"               
	0           "None, no hours"                
;
label values a_hrlywk a_hrlywk;
label define a_hrlywk
	0           "Not in universe or children and"
	1           "Yes"                           
	2           "No"                            
;
label values a_hrspay a_hrspay;
label define a_hrspay
	0           "Not in universe or children and"
;
label values a_grswk  a_grswk;
label define a_grswk 
	0           "Not in universe or children or"
;
label values a_unmem  a_unmem;
label define a_unmem 
	0           "Not in universe or children and"
	1           "Yes"                           
	2           "No"                            
;
label values a_uncov  a_uncov;
label define a_uncov 
	0           "Not in universe or children and"
	1           "Yes"                           
	2           "No"                            
;
label values a_enrlw  a_enrlw;
label define a_enrlw 
	0           "Not in universe or children and"
	1           "Yes"                           
	2           "No"                            
;
label values a_hscol  a_hscol;
label define a_hscol 
	0           "Not in universe or children and"
	1           "High school"                   
	2           "College or univ."              
;
label values a_ftpt   a_ftpt; 
label define a_ftpt  
	0           "Not in universe or children and"
	1           "Full time"                     
	2           "Part time"                     
;
label values a_lfsr   a_lfsr; 
label define a_lfsr  
	0           "Children or Armed Forces"      
	3           "Unemployed, looking for work"  
	4           "Unemployed, on layoff"         
	7           "Nilf"                          
;
label values a_untype a_untype;
label define a_untype
	0           "Not in universe or children"   
	1           "Job loser - on layoff"         
	2           "Other job loser"               
	3           "Job leaver"                    
	4           "Re-entrant"                    
	5           "New entrant"                   
;
label values a_wkstat a_wkstat;
label define a_wkstat
	0           "Children or Armed Forces"      
	1           "Not in labor force"            
	2           "Full-time schedules"           
	3           "Part-time for economic reasons,"
	4           "Part-time for non-economic"    
	5           "Part-time for economic reasons,"
	6           "Unemployed FT"                 
	7           "Unemployed PT"                 
;
label values a_explf  a_explf;
label define a_explf 
	0           "Not in experienced labor force"
	1           "Employed"                      
	2           "Unemployed"                    
;
label values a_wksch  a_wksch;
label define a_wksch 
	0           "Not in universe"               
	1           "At work"                       
	2           "With job, not at work"         
	3           "Unemployed, seeks FT"          
	4           "Unemployed, seeks PT"          
;
label values a_civlf  a_civlf;
label define a_civlf 
	0           "Not in universe or children and"
	1           "In universe"                   
;
label values a_ftlf   a_ftlf; 
label define a_ftlf  
	0           "Not in universe or children and"
	1           "In universe"                   
;
label values a_mjind  a_mjind;
label define a_mjind 
	0           "Not in universe, or children"  
	1           "Agriculture, forestry,"        
	2           "Mining"                        
	3           "Construction"                  
	4           "Manufacturing"                 
	5           "Wholesale and retail trade"    
	6           "Transportation and utilities"  
	7           "Information"                   
	8           "Financial activities"          
	9           "Professional and business"     
	10          "Educational and health services"
	11          "Leisure and hospitality"       
	12          "Other services"                
	13          "Public administration"         
	14          "Armed Forces"                  
;
label values a_dtind  a_dtind;
label define a_dtind 
	0           "Not in universe or children or"
;
label values a_mjocc  a_mjocc;
label define a_mjocc 
	0           "Not in universe or children"   
	1           "Management, business, and"     
	2           "Professional and related"      
	3           "Service occupations"           
	4           "Sales and related occupations" 
	5           "Office and administrative"     
	6           "Farming, fishing, and"         
	7           "Construction and extraction"   
	8           "Installation, maintenance,"    
	9           "Production occupations"        
	10          "Transportation and material"   
	11          "Armed Forces"                  
;
label values a_dtocc  a_dtocc;
label define a_dtocc 
	0           "Not in universe for children or"
;
label values peio1cow peio1cow;
label define peio1cow
	0           "NIU"                           
	1           "Government-federal"            
	2           "Government-state"              
	3           "Government - local"            
	4           "Private, for profit"           
	5           "Private, nonprofit"            
	6           "Self-employed, incorporated"   
	7           "Self-employed, unincorporated" 
	8           "Without pay"                   
;
label values prcow1   prcow1l;
label define prcow1l 
	0           "NIU"                           
	1           "Federal govt"                  
	2           "State govt"                    
	3           "Local govt"                    
	4           "Private (incl. self-employed"  
	5           "Self-employed, unincorp."      
	6           "Without pay"                   
;
label values pemlr    pemlr;  
label define pemlr   
	0           "NIU"                           
	1           "Employed - at work"            
	2           "Employed - absent"             
	3           "Unemployed - on layoff"        
	4           "Unemployed - looking"          
	5           "Not in labor force - retired"  
	6           "Not in labor force - disabled" 
	7           "Not in labor force - other"    
;
label values pruntype pruntype;
label define pruntype
	0           "NIU"                           
	1           "Job loser/on layoff"           
	2           "Other job loser"               
	3           "Temporary job ended"           
	4           "Job leaver"                    
	5           "Re-entrant"                    
	6           "New-entrant"                   
;
label values prwkstat prwkstat;
label define prwkstat
	0           "NIU"                           
	1           "Not in labor force"            
	2           "FT hours (35+), usually FT"    
	3           "PT for economic reasons,"      
	4           "PT for non-economic reasons,"  
	5           "Not at work, usually FT"       
	6           "PT hrs, usually PT for economic"
	7           "PT hrs, usually PT for non-"   
	8           "FT hours, usually PT for"      
	9           "FT hours, usually PT for non-" 
	10          "Not at work, usually part-time"
	11          "Unemployed FT"                 
	12          "Unemployed PT"                 
;
label values prptrea  prptrea;
label define prptrea 
	-1          "NIU - adult civilian"          
	0           "NIU - children or Armed Forces"
	1           "Usually FT - slack work/"      
	2           "Usually FT - seasonal work"    
	3           "Usually FT - job started/ended"
	4           "Usually FT - vacation/personal"
	5           "Usually FT - own illness/"     
	6           "Usually FT - holiday"          
	7           "Usually FT - child care"       
	8           "Usually FT - other fam/pers"   
	9           "Usually FT - labor dispute"    
	10          "Usually FT - weather affected" 
	11          "Usually FT - school/training"  
	12          "Usually FT - civic/military"   
	13          "Usually FT - other reason"     
	14          "Usually PT - slack"            
	15          "Usually PT - PT could only find"
	16          "Usually PT - seasonal work"    
	17          "Usually PT - child care"       
	18          "Usually PT - other fam/pers"   
	19          "Usually PT - health/medical"   
	20          "Usually PT - school/training"  
	21          "Usually PT - retired/social"   
	22          "Usually PT - workweek <35 hours"
	23          "Usually PT - other reason"     
;
label values prdisc   prdisc; 
label define prdisc  
	0           "NIU"                           
	1           "Discouraged worker"            
	2           "Conditionally interested"      
	3           "Not available"                 
;
label values peabsrsn peabsrsn;
label define peabsrsn
	-1          "NIU - adult civilian"          
	0           "NIU - children or Armed Forces"
	2           "Slack work/business conditions"
	4           "Vacation/personal days"        
	5           "Own illness/injury/medical"    
	6           "Child care problems"           
	7           "Other family/personal"         
	8           "Maternity/paternity leave"     
	9           "Labor dispute"                 
	10          "Weather affected job"          
	11          "School/training"               
	12          "Civic/military duty"           
	13          "Does not work in the business" 
	14          "Other (specify)"               
;
label values prnlfsch prnlfsch;
label define prnlfsch
	0           "NIU"                           
	1           "In school"                     
	2           "Not in school"                 
;
label values pehruslt pehruslt;
label define pehruslt
	-4          "Hours vary"                    
	-1          "NIU - adult civilian"          
	0           "NIU - children or Armed Forces"
;
label values workyn   workyn; 
label define workyn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values wrk_ck   wrk_ck; 
label define wrk_ck  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values wtemp    wtemp;  
label define wtemp   
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values nwlook   nwlook; 
label define nwlook  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values nwlkwk   nwlkwk; 
label define nwlkwk  
	0           "Not in universe"               
	1           "1 week"                        
	52          "52 weeks"                      
;
label values rsnnotw  rsnnotw;
label define rsnnotw 
	0           "Not in universe"               
	1           "Ill or disabled"               
	2           "Retired"                       
	3           "Taking care of home or family" 
	4           "Going to school"               
	5           "Could not find work"           
	6           "Other"                         
;
label values wkswork  wkswork;
label define wkswork 
	0           "Not in universe"               
	1           "1 week"                        
	52          "52 weeks"                      
;
label values wkcheck  wkcheck;
label define wkcheck 
	0           "Not in universe"               
	1           "1-49 weeks"                    
	2           "50-51 weeks"                   
	3           "52 weeks"                      
;
label values losewks  losewks;
label define losewks 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values lknone   lknone; 
label define lknone  
	0           "Not in universe"               
	1           "No weeks looking for work or on"
;
label values lkweeks  lkweeks;
label define lkweeks 
	0           "Not in universe"               
	1           "01 weeks"                      
	51          "51 weeks"                      
;
label values lkstrch  lkstrch;
label define lkstrch 
	0           "Not in universe"               
	1           "Yes, 1 stretch"                
	2           "No, 2 stretches"               
	3           "No, 3 plus stretches"          
;
label values pyrsn    pyrsn;  
label define pyrsn   
	0           "Not in universe"               
	1           "Ill or disabled"               
	2           "Taking care of home"           
	3           "Going to school"               
	4           "Retired"                       
	5           "No work available"             
	6           "Other"                         
;
label values phmemprs phmemprs;
label define phmemprs
	0           "Not in universe"               
	1           "1 employer"                    
	2           "2"                             
	3           "3 plus"                        
;
label values hrswk    hrswk;  
label define hrswk   
	0           "Not in universe"               
	1           "1 hour"                        
	99          "99 hours plus"                 
;
label values hrcheck  hrcheck;
label define hrcheck 
	0           "Not in universe"               
	1           "Part time (1-34)"              
	2           "Full time (35+)"               
;
label values ptyn     ptyn;   
label define ptyn    
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values ptweeks  ptweeks;
label define ptweeks 
	0           "Not in universe"               
	1           "1 week"                        
	52          "52 weeks"                      
;
label values ptrsn    ptrsn;  
label define ptrsn   
	0           "Not in universe"               
	1           "Could only find PT job"        
	2           "Wanted part time"              
	3           "Slack work"                    
	4           "Other"                         
;
label values wexp     wexp;   
label define wexp    
	0           "Not in universe"               
	1           "50 to 52 weeks"                
	2           "48 to 49 weeks"                
	3           "40 to 47 weeks"                
	4           "27 to 39 weeks"                
	5           "14 to 26 weeks"                
	6           "13 weeks or less"              
	7           "50 to 52 weeks"                
	8           "48 to 49 weeks"                
	9           "40 to 47 weeks"                
	10          "27 to 39 weeks"                
	11          "14 to 26 weeks"                
	12          "13 weeks or less"              
	13          "Nonworker"                     
;
label values wewkrs   wewkrs; 
label define wewkrs  
	0           "Not in universe"               
	1           "Full time"                     
	2           "Part time"                     
	3           "Full time"                     
	4           "Part time"                     
	5           "Nonworker"                     
;
label values welknw   welknw; 
label define welknw  
	0           "Children"                      
	1           "None (not looking for work)"   
	2           "1 to 4 weeks looking"          
	3           "5 to 14 weeks looking"         
	4           "15 to 26 weeks looking"        
	5           "27 to 39 weeks looking"        
	6           "40 or more weeks looking"      
	7           "Workers"                       
;
label values weuemp   weuemp; 
label define weuemp  
	0           "Not in universe"               
	1           "None"                          
	2           "1 to 4 weeks"                  
	3           "5 to 10 weeks"                 
	4           "11 to 14 weeks"                
	5           "15 to 26 weeks"                
	6           "27 to 39 weeks"                
	7           "40 or more weeks"              
	8           "Full year worker"              
	9           "Nonworker"                     
;
label values earner   earner; 
label define earner  
	0           "Not in universe"               
	1           "Earner (pearnval ne 0)"        
	2           "Nonearner"                     
;
label values clwk     clwk;   
label define clwk    
	0           "Not in universe"               
	1           "Private (includes self-"       
	2           "Government"                    
	3           "Self-employed"                 
	4           "Without pay"                   
	5           "Never worked"                  
;
label values weclw    weclw;  
label define weclw   
	0           "Not in universe"               
	1           "Wage and salary"               
	2           "Self-employed"                 
	3           "Unpaid"                        
	4           "Private household"             
	5           "Other private"                 
	6           "Government"                    
	7           "Self-employed"                 
	8           "Unpaid"                        
	9           "Never worked"                  
;
label values ljcw     ljcw;   
label define ljcw    
	0           "Not in universe"               
	1           "Private"                       
	2           "Federal"                       
	3           "State"                         
	4           "Local"                         
	5           "Self employed incorporated, yes"
	6           "Self employed incorporated, no"
	7           "Without pay"                   
;
label values industry industry;
label define industry
	0           "Not in universe or children"   
;
label values occup    occup;  
label define occup   
	0           "Not in universe or children"   
;
label values noemp    noemp;  
label define noemp   
	0           "Not in universe"               
	1           "Under 10"                      
	2           "10 - 49"                       
	3           "50 - 99"                       
	4           "100 - 499"                     
	5           "500 - 999"                     
	6           "1000+"                         
;
label values nxtres   nxtres; 
label define nxtres  
	0           "NIU"                           
	1           "Change in marital status"      
	2           "To establish own household"    
	3           "Other family reason"           
	4           "New job or job transfer"       
	5           "To look for work or lost job"  
	6           "To be closer to work/easier"   
	7           "Retired"                       
	8           "Other job-related reason"      
	9           "Wanted to own home, not rent"  
	10          "Wanted new or better house/"   
	11          "Wanted better neighborhood"    
	12          "Cheaper housing"               
	13          "Foreclosure/eviction"          
	14          "Other housing reason"          
	15          "Attend/leave college"          
	16          "Change of climate"             
	17          "Health reasons"                
	18          "Natural disaster"              
	19          "Other reason"                  
;
label values mig_cbst mig_cbst;
label define mig_cbst
	0           "NIU, nonmover"                 
	1           "CBSA"                          
	2           "non CBSA"                      
	3           "Abroad"                        
	4           "Not identifiable"              
;
label values migsame  migsame;
label define migsame 
	0           "NIU"                           
	1           "Yes (nonmover)"                
	2           "No, difference house in U.S."  
	3           "No, outside the U.S. (mover)"  
;
label values mig_reg  mig_reg;
label define mig_reg 
	0           "Not in universe under 1 year"  
	1           "Northeast"                     
	2           "Midwest"                       
	3           "South"                         
	4           "West"                          
	5           "Abroad"                        
;
label values mig_st   mig_st; 
label define mig_st  
	0           "Nonmatch"                      
	1           "Alabama"                       
	2           "Alaska"                        
	4           "Arizona"                       
	5           "Arkansas"                      
	6           "California"                    
	8           "Colorado"                      
	9           "Connecticut"                   
	10          "Delaware"                      
	11          "District of Columbia"          
	12          "Florida"                       
	13          "Georgia"                       
	15          "Hawaii"                        
	16          "Idaho"                         
	17          "Illinois"                      
	18          "Indiana"                       
	19          "Iowa"                          
	20          "Kansas"                        
	21          "Kentucky"                      
	22          "Louisiana"                     
	23          "Maine"                         
	24          "Maryland"                      
	25          "Massachusetts"                 
	26          "Michigan"                      
	27          "Minnesota"                     
	28          "Mississippi"                   
	29          "Missouri"                      
	30          "Montana"                       
	31          "Nebraska"                      
	32          "Nevada"                        
	33          "New Hampshire"                 
	34          "New Jersey"                    
	35          "New Mexico"                    
	36          "New York"                      
	37          "North Carolina"                
	38          "North Dakota"                  
	39          "Ohio"                          
	40          "Oklahoma"                      
	41          "Oregon"                        
	42          "Pennsylvania"                  
	44          "Rhode Island"                  
	45          "South Carolina"                
	46          "South Dakota"                  
	47          "Tennessee"                     
	48          "Texas"                         
	49          "Utah"                          
	50          "Vermont"                       
	51          "Virginia"                      
	53          "Washington"                    
	54          "West Virginia"                 
	55          "Wisconsin"                     
	56          "Wyoming"                       
	96          "Abroad"                        
;
label values mig_dscp mig_dscp;
label define mig_dscp
	0           "NIU (under 1 year old,"        
	1           "Principal city of a CBSA"      
	2           "Balance of a CBSA"             
	3           "Non-metro"                     
	4           "Abroad"                        
	5           "Not identified"                
;
label values gediv    gediv;  
label define gediv   
	1           "New England"                   
	2           "Middle Atlantic"               
	3           "East North Central"            
	4           "West North Central"            
	5           "South Atlantic"                
	6           "East South Central"            
	7           "West South Central"            
	8           "Mountain"                      
	9           "Pacific"                       
;
label values mig_div  mig_div;
label define mig_div 
	0           "Not in universe (under 1 year" 
	1           "New England"                   
	2           "Middle Atlantic"               
	3           "East North Central"            
	4           "West North Central"            
	5           "South Atlantic"                
	6           "East South Central"            
	7           "West South Central"            
	8           "Mountain"                      
	9           "Pacific"                       
	10          "Aboard"                        
;
label values mig_mtr1 mig_mtra;
label define mig_mtra
	1           "Nonmover"                      
	2           "Metro to metro"                
	3           "Metro to non-metro"            
	4           "Non-metro to metro"            
	5           "Non-metro to non-metro"        
	6           "Abroad to metro"               
	7           "Abroad to non-metro"           
	8           "Not in universe (Children"     
	9           "Not identifiable"              
;
label values mig_mtr3 mig_mtrc;
label define mig_mtrc
	1           "Nonmover"                      
	2           "Same county"                   
	3           "Different county, same state"  
	4           "Different state, same division"
	5           "Different division, same"      
	6           "Different region"              
	7           "Abroad"                        
	8           "Not in universe (children"     
;
label values mig_mtr4 mig_mtrd;
label define mig_mtrd
	1           "Nonmover"                      
	2           "Same county"                   
	3           "Different county, same state"  
	4           "Different state in Northeast"  
	5           "Different state in Midwest"    
	6           "Different state in South"      
	7           "Different state in West"       
	8           "Abroad, foreign country"       
	9           "Not in universe (children"     
;
label values ern_yn   ern_yn; 
label define ern_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values ern_srce ern_srce;
label define ern_srce
	0           "Not in universe"               
	1           "Wage and salary"               
	2           "Self employment"               
	3           "Farm self employment"          
	4           "Without pay"                   
;
label values ern_otr  ern_otr;
label define ern_otr 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values ern_val  ern_val;
label define ern_val 
	0           "None or not in universe"       
;
label values wageotr  wageotr;
label define wageotr 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values wsal_yn  wsal_yn;
label define wsal_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values wsal_val wsal_val;
label define wsal_val
	0           "None or not in universe"       
;
label values ws_val   ws_val; 
label define ws_val  
	0           "None or not in universe"       
;
label values seotr    seotr;  
label define seotr   
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values semp_yn  semp_yn;
label define semp_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values semp_val semp_val;
label define semp_val
	0           "None or not in universe"       
;
label values se_val   se_val; 
label define se_val  
	0           "None or not in universe"       
;
label values frmotr   frmotr; 
label define frmotr  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values frse_yn  frse_yn;
label define frse_yn 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values frse_val frse_val;
label define frse_val
	0           "None or not in universe"       
;
label values frm_val  frm_val;
label define frm_val 
	0           "None or not in universe"       
;
label values uc_yn    uc_yn;  
label define uc_yn   
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values subuc    subuc;  
label define subuc   
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values strkuc   strkuc; 
label define strkuc  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values uc_val   uc_val; 
label define uc_val  
	0           "None or not in universe"       
;
label values wc_yn    wc_yn;  
label define wc_yn   
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values wc_type  wc_type;
label define wc_type 
	0           "Not in universe"               
	1           "State worker's compensation"   
	2           "Employer or employers insurance"
	3           "Own insurance"                 
	4           "Other"                         
;
label values wc_val   wc_val; 
label define wc_val  
	0           "None or not in universe"       
;
label values ss_yn    ss_yn;  
label define ss_yn   
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values ss_val   ss_val; 
label define ss_val  
	0           "None or not in universe"       
;
label values resnss1  resnss1l;
label define resnss1l
	0           "NIU"                           
	1           "Retired"                       
	2           "Disabled (adult or child)"     
	3           "Widowed"                       
	4           "Spouse"                        
	5           "Surviving child"               
	6           "Dependent child"               
	7           "on behalf of surviving,"       
	8           "Other (adult or child)"        
;
label values resnss2  resnss2l;
label define resnss2l
	0           "NIU"                           
	1           "Retired"                       
	2           "Disabled (adult or child)"     
	3           "Widowed"                       
	4           "Spouse"                        
	5           "Surviving child"               
	6           "Dependent child"               
	7           "On behalf of surviving,"       
	8           "Other (adult or child)"        
;
label values sskidyn  sskidyn;
label define sskidyn 
	0           "NIU"                           
	1           "Received SS"                   
	2           "Did not receive SS"            
;
label values ssi_yn   ssi_yn; 
label define ssi_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values ssi_val  ssi_val;
label define ssi_val 
	0           "None or not in universe"       
;
label values resnssi1 resnssia;
label define resnssia
	0           "NIU"                           
	1           "Disabled (adult or child)"     
	2           "Blind (adult or child)"        
	3           "On behalf of a disabled child" 
	4           "On behalf of a blind child"    
	5           "Other (adult or child)"        
;
label values resnssi2 resnssib;
label define resnssib
	0           "NIU"                           
	1           "Disabled (adult or child)"     
	2           "Blind (adult or child)"        
	3           "On behalf of a disabled child" 
	4           "On behalf of a blind child"    
	5           "Other (adult or child)"        
;
label values ssikidyn ssikidyn;
label define ssikidyn
	0           "NIU"                           
	1           "Received SSI"                  
	2           "Did not receive SSI"           
;
label values paw_yn   paw_yn; 
label define paw_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values paw_typ  paw_typ;
label define paw_typ 
	0           "Not in universe"               
	1           "TANF/AFDC"                     
	2           "Other"                         
	3           "Both"                          
;
label values paw_mon  paw_mon;
label define paw_mon 
	0           "Not in universe"               
	1           "One"                           
	12          "Twelve"                        
;
label values paw_val  paw_val;
label define paw_val 
	0           "None or not in universe"       
;
label values vet_yn   vet_yn; 
label define vet_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values vet_typ1 vet_typa;
label define vet_typa
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values vet_typ2 vet_typb;
label define vet_typb
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values vet_typ3 vet_typc;
label define vet_typc
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values vet_typ4 vet_typd;
label define vet_typd
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values vet_typ5 vet_type;
label define vet_type
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values vet_qva  vet_qva;
label define vet_qva 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values vet_val  vet_val;
label define vet_val 
	0           "None or not in universe"       
;
label values sur_yn   sur_yn; 
label define sur_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values sur_sc1  sur_sc1l;
label define sur_sc1l
	0           "None or not in universe"       
	1           "Company or union survivor"     
	2           "Federal government"            
	3           "Us military retirement"        
	4           "State or local government"     
	5           "Us railroad retirement"        
	6           "Worker's compensation survivor"
	7           "Black Lung Survivor Pension"   
	8           "Regular payments from estates" 
	9           "Regular payments from"         
	10          "Other or don't know"           
;
label values sur_val1 sur_vala;
label define sur_vala
	0           "None or not in universe"       
;
label values sur_val2 sur_valb;
label define sur_valb
	0           "None or not in universe"       
;
label values srvs_val srvs_val;
label define srvs_val
	0           "None or not in universe"       
;
label values dis_hp   dis_hp; 
label define dis_hp  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values dis_cs   dis_cs; 
label define dis_cs  
	0           "Not in universe or children"   
	1           "Yes"                           
	2           "No"                            
;
label values dis_yn   dis_yn; 
label define dis_yn  
	0           "Not in universe or children"   
	1           "Yes"                           
	2           "No"                            
;
label values dis_sc1  dis_sc1l;
label define dis_sc1l
	0           "Not in universe"               
	1           "Worker's compensation"         
	2           "Company or union disability"   
	3           "Federal government disability" 
	4           "Us military retirement"        
	5           "State or local gov't employee" 
	6           "Us railroad retirement"        
	7           "Accident or disability"        
	8           "Black Lung miner’s disability" 
	9           "State temporary sickness"      
	10          "Other or don't know"           
;
label values dis_val1 dis_vala;
label define dis_vala
	0           "None or not in universe"       
;
label values dis_val2 dis_valb;
label define dis_valb
	0           "None or not in universe"       
;
label values dsab_val dsab_val;
label define dsab_val
	0           "None or not in universe"       
;
label values ret_yn   ret_yn; 
label define ret_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values ret_sc1  ret_sc1l;
label define ret_sc1l
	0           "None or not in universe"       
	1           "Company or union pension"      
	2           "Federal government retirement" 
	3           "US military retirement"        
	4           "State or local government"     
	5           "US railroad retirement"        
	6           "Regular payments from annuities"
	7           "Regular payments from ira,"    
	8           "Other sources or don't know"   
;
label values ret_val1 ret_vala;
label define ret_vala
	0           "None or not in universe"       
;
label values ret_val2 ret_valb;
label define ret_valb
	0           "None or not in universe"       
;
label values rtm_val  rtm_val;
label define rtm_val 
	0           "None or not in universe"       
;
label values int_yn   int_yn; 
label define int_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values int_val  int_val;
label define int_val 
	0           "None or not in universe"       
;
label values div_yn   div_yn; 
label define div_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values div_non  div_non;
label define div_non 
	0           "Not in universe"               
	1           "None"                          
;
label values div_val  div_val;
label define div_val 
	0           "None or not in universe"       
;
label values rnt_yn   rnt_yn; 
label define rnt_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values rnt_val  rnt_val;
label define rnt_val 
	0           "None or not in universe"       
;
label values ed_yn    ed_yn;  
label define ed_yn   
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values oed_typ1 oed_typa;
label define oed_typa
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values oed_typ2 oed_typb;
label define oed_typb
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values oed_typ3 oed_typc;
label define oed_typc
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values ed_val   ed_val; 
label define ed_val  
	0           "None or not in universe"       
;
label values csp_yn   csp_yn; 
label define csp_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values csp_val  csp_val;
label define csp_val 
	0           "None or not in universe"       
;
label values alm_yn   alm_yn; 
label define alm_yn  
	0           "None or not in universe"       
	1           "Yes"                           
	2           "No"                            
;
label values alm_val  alm_val;
label define alm_val 
	0           "None or not in universe"       
;
label values fin_yn   fin_yn; 
label define fin_yn  
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values fin_val  fin_val;
label define fin_val 
	0           "None or not in universe"       
;
label values oi_off   oi_off; 
label define oi_off  
	0           "NIU"                           
	1           "Social security"               
	2           "Private pensions"              
	3           "AFDC"                          
	4           "Other public assistance"       
	5           "Interest"                      
	6           "Dividends"                     
	7           "Rents or royalties"            
	8           "Estates or trusts"             
	9           "State disability payments"     
	10          "Disability payments (own"      
	11          "Unemployment compensation"     
	12          "Strike benefits"               
	13          "Annuities or paid up insurance"
	14          "Not income"                    
	15          "Longest job"                   
	16          "Wages or salary"               
	17          "Nonfarm self-employment"       
	19          "Anything else"                 
;
label values oi_yn    oi_yn;  
label define oi_yn   
	0           "None or not in universe"       
	1           "Yes"                           
	2           "No"                            
;
label values oi_val   oi_val; 
label define oi_val  
	0           "None or not in universe"       
;
label values ptotval  ptotval;
label define ptotval 
	0           "None or not in universe"       
;
label values pearnval pearnval;
label define pearnval
	0           "None or not in universe"       
;
label values pothval  pothval;
label define pothval 
	0           "None"                          
;
label values ptot_r   ptot_r; 
label define ptot_r  
	0           "Not in universe"               
	1           "Under $2,500"                  
	2           "$2,500 to $4,999"              
	3           "$5,000 to $7,499"              
	4           "$7,500 to $9,999"              
	5           "$10,000 to $12,499"            
	6           "$12,500 to $14,999"            
	7           "$15,000 to $17,499"            
	8           "$17,500 to $19,999"            
	9           "$20,000 to $22,499"            
	10          "$22,500 to $24,999"            
	11          "$25,000 to $27,499"            
	12          "$27,500 to $29,999"            
	13          "$30,000 to $32,499"            
	14          "$32,500 to $34,999"            
	15          "$35,000 to $37,499"            
	16          "$37,500 to $39,999"            
	17          "$40,000 to $42,499"            
	18          "$42,500 to $44,999"            
	19          "$45,000 to $47,499"            
	20          "$47,500 to $49,999"            
	21          "$50,000 to $52,499"            
	22          "$52,500 to $54,999"            
	23          "$55,000 to $57,499"            
	24          "$57,500 to $59,999"            
	25          "$60,000 to $62,499"            
	26          "$62,500 to $64,999"            
	27          "$65,000 to $67,499"            
	28          "$67,500 to $69,999"            
	29          "$70,000 to $72,499"            
	30          "$72,500 to $74,999"            
	31          "$75,000 to $77,499"            
	32          "$77,500 to $79,999"            
	33          "$80,000 to $82,499"            
	34          "$82,500 to $84,999"            
	35          "$85,000 to $87,499"            
	36          "$87,500 to $89,999"            
	37          "$90,000 to $92,499"            
	38          "$92,500 to $94,999"            
	39          "$95,000 to $97,499"            
	40          "$97,500 to $99,999"            
	41          "$100,000 and over"             
;
label values perlis   perlis; 
label define perlis  
	1           "Below low-income level"        
	2           "100 - 124 percent of the low-" 
	3           "125 - 149 percent of the low-" 
	4           "150 and above the low-income"  
;
label values pov_univ pov_univ;
label define pov_univ
	0           "Person NIU"                    
	1           "Person in poverty universe"    
;
label values wicyn    wicyn;  
label define wicyn   
	0           "NIU"                           
	1           "Received WIC"                  
	2           "Did not receive WIC"           
;
label values mcare    mcare;  
label define mcare   
	0           "NIU (children under 15)"       
	1           "Yes"                           
	2           "No"                            
;
label values p_mvcare p_mvcare;
label define p_mvcare
	0           "None"                          
;
label values mcaid    mcaid;  
label define mcaid   
	1           "Yes"                           
	2           "No"                            
;
label values p_mvcaid p_mvcaid;
label define p_mvcaid
	0           "None"                          
;
label values champ    champ;  
label define champ   
	1           "Yes"                           
	2           "No"                            
;
label values hi_yn    hi_yn;  
label define hi_yn   
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hiown    hiown;  
label define hiown   
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hiemp    hiemp;  
label define hiemp   
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values hipaid   hipaid; 
label define hipaid  
	0           "Not in universe"               
	1           "All"                           
	2           "Part"                          
	3           "None"                          
;
label values emcontrb emcontrb;
label define emcontrb
	0           "None"                          
;
label values hi       hi;     
label define hi      
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values hityp    hityp;  
label define hityp   
	0           "NIU"                           
	1           "Family plan"                   
	2           "Self-only"                     
;
label values dephi    dephi;  
label define dephi   
	0           "NIU"                           
	1           "Yes"                           
;
label values hilin1   hilin1l;
label define hilin1l 
	0           "NIU"                           
;
label values hilin2   hilin2l;
label define hilin2l 
	0           "NIU"                           
;
label values paid     paid;   
label define paid    
	0           "NIU"                           
	1           "All"                           
	2           "Part"                          
	3           "None"                          
;
label values hiout    hiout;  
label define hiout   
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values priv     priv;   
label define priv    
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values prityp   prityp; 
label define prityp  
	0           "NIU"                           
	1           "Family plan"                   
	2           "Self-only"                     
;
label values depriv   depriv; 
label define depriv  
	0           "No or NIU"                     
	1           "Yes"                           
;
label values pilin1   pilin1l;
label define pilin1l 
	0           "NIU"                           
;
label values pilin2   pilin2l;
label define pilin2l 
	0           "NIU"                           
;
label values pout     pout;   
label define pout    
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values out      out;    
label define out     
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values care     care;   
label define care    
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values caid     caid;   
label define caid    
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values mon      mon;    
label define mon     
	0           "NIU"                           
;
label values oth      oth;    
label define oth     
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values otyp_1   otyp_1l;
label define otyp_1l 
	0           "No"                            
	1           "Yes"                           
;
label values otyp_2   otyp_2l;
label define otyp_2l 
	0           "No"                            
	1           "Yes"                           
;
label values otyp_3   otyp_3l;
label define otyp_3l 
	0           "No"                            
	1           "Yes"                           
;
label values otyp_4   otyp_4l;
label define otyp_4l 
	0           "No"                            
	1           "Yes"                           
;
label values otyp_5   otyp_5l;
label define otyp_5l 
	0           "No"                            
	1           "Yes"                           
;
label values othstper othstper;
label define othstper
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values othstyp1 othstypa;
label define othstypa
	0           "NIU"                           
	1           "Medicare"                      
	2           "Medicaid"                      
	3           "CHAMPUS"                       
	4           "CHAMPVA"                       
	5           "VA health care"                
	6           "Military health care"          
	7           "State Children's Health"       
	8           "Indian health service"         
	9           "Other government health care"  
	10          "Employer/union-provided"       
	11          "Employer/union-provided (as"   
	12          "Privately purchased"           
	13          "Privately purchased (as"       
	14          "Plan of someone outside the"   
	15          "Other"                         
;
label values hea      hea;    
label define hea     
	0           "NIU"                           
	1           "Excellent"                     
	2           "Very good"                     
	3           "Good"                          
	4           "Fair"                          
	5           "Poor"                          
;
label values ihsflg   ihsflg; 
label define ihsflg  
	1           "Yes"                           
	2           "No"                            
;
label values ahiper   ahiper; 
label define ahiper  
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values ahityp6  ahityp6l;
label define ahityp6l
	0           "NIU"                           
	1           "Medicare"                      
	2           "Medicaid"                      
	3           "Tricare or champus"            
	4           "CAMPVA ('CHAMPVA' is the"      
	5           "Va health care"                
	6           "Military health care"          
	7           "Children's health insurance"   
	8           "Indian health service"         
	9           "Other government health care"  
	10          "Employer/union-provided"       
	11          "Employer/union-provided (as"   
	12          "Privately purchased"           
	13          "Privately purchased (as"       
	14          "Plan of someone outside the"   
	15          "Other"                         
;
label values pchip    pchip;  
label define pchip   
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values cov_gh   cov_gh; 
label define cov_gh  
	1           "Yes"                           
	2           "No"                            
;
label values cov_hi   cov_hi; 
label define cov_hi  
	1           "Yes"                           
	2           "No"                            
;
label values ch_mc    ch_mc;  
label define ch_mc   
	0           "Not child's record"            
	1           "Yes"                           
	2           "No"                            
;
label values ch_hi    ch_hi;  
label define ch_hi   
	0           "Not child's record"            
	1           "Covered by person in household"
	2           "Covered by person outside of"  
	3           "Not covered"                   
;
label values marg_tax marg_tax;
label define marg_tax
	0           "None"                          
;
label values ctc_crd  ctc_crd;
label define ctc_crd 
	0           "None"                          
;
label values penplan  penplan;
label define penplan 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values penincl  penincl;
label define penincl 
	0           "Not in universe"               
	1           "Yes"                           
	2           "No"                            
;
label values filestat filestat;
label define filestat
	1           "Joint, both <65"               
	2           "Joint, one <65 &  one 65+"     
	3           "Joint, both 65+"               
	4           "Head of household"             
	5           "Single"                        
	6           "Nonfiler"                      
;
label values dep_stat dep_stat;
label define dep_stat
	0           "Not a dependent"               
;
label values eit_cred eit_cred;
label define eit_cred
	0           "None"                          
;
label values actc_crd actc_crd;
label define actc_crd
	0           "None"                          
;
label values fica     fica;   
label define fica    
	0           "None"                          
;
label values fed_ret  fed_ret;
label define fed_ret 
	0           "None"                          
;
label values agi      agi;    
label define agi     
	0           "None or not in universe"       
;
label values tax_inc  tax_inc;
label define tax_inc 
	0           "None"                          
;
label values fedtax_bc fedtax_bc;
label define fedtax_bc
	0           "None"                          
;
label values fedtax_ac fedtax_ac;
label define fedtax_ac
	0           "None"                          
;
label values statetax_bc statetax_bc;
label define statetax_bc
	0           "None"                          
;
label values statetax_ac statetax_ac;
label define statetax_ac
	0           "None"                          
;
label values paidccyn paidccyn;
label define paidccyn
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values paidcyna paidcyna;
label define paidcyna
	0           "Not imputed or NIU"            
	1           "Imputed"                       
;
label values moop     moop;   
label define moop    
	0           " NIU"                          
;
label values phip_val phip_val;
label define phip_val
	0           " NIU"                          
;
label values potc_val potc_val;
label define potc_val
	0           " NIU"                          
;
label values pmed_val pmed_val;
label define pmed_val
	0           " NIU"                          
;
label values chsp_val chsp_val;
label define chsp_val
	0           " NIU"                          
;
label values chsp_yn  chsp_yn;
label define chsp_yn 
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values chelsew_yn chelsew_yn;
label define chelsew_yn
	0           "NIU"                           
	1           "Yes"                           
	2           "No"                            
;
label values axrrp    axrrp;  
label define axrrp   
	0           "No change"                     
	2           "Blank to value"                
	3           "Value to value"                
;
label values axage    axage;  
label define axage   
	0           "No change"                     
	4           "Allocated"                     
;
label values axmaritl axmaritl;
label define axmaritl
	0           "No change"                     
	4           "Allocated"                     
;
label values axspouse axspouse;
label define axspouse
	0           "No change"                     
	2           "Blank to value"                
	3           "Value to value"                
;
label values axsex    axsex;  
label define axsex   
	0           "No change"                     
	4           "Allocated"                     
;
label values axhga    axhga;  
label define axhga   
	0           "No change"                     
	4           "Allocated"                     
;
label values pxrace1  pxrace1l;
label define pxrace1l
	0           "Not allocated"                 
	1           "Blank - no change"             
	2           "Don't know - no change"        
	3           "Refused - no change"           
	10          "Value to value"                
	11          "Blank to value"                
	12          "Don't know to value"           
	13          "Refused to value"              
	20          "Value to longitudinal value"   
	21          "Blank to longitudinal value"   
	22          "Don't know to longitudinal"    
	23          "Refused to longitudinal value" 
	30          "Value to allocated value long" 
	31          "Blank to allocated value long" 
	32          "Don't know to allocated value" 
	33          "Refused to allocated value long"
	40          "Value to allocated value"      
	41          "Blank to allocated value"      
	42          "Don't know to allocated value" 
	43          "Refused to allocated value"    
	50          "Value to blank"                
	52          "Don't know to blank"           
	53          "Refused to blank"              
;
label values pxhspnon pxhspnon;
label define pxhspnon
	0           "Not allocated"                 
	1           "Blank - no change"             
	2           "Don't know - no change"        
	3           "Refused - no change"           
	10          "Value to value"                
	11          "Blank to value"                
	12          "Don't know to value"           
	13          "Refused to value"              
	20          "Value to longitudinal value"   
	21          "Blank to longitudinal value"   
	22          "Don't know to longitudinal"    
	23          "Refused to longitudinal value" 
	30          "Value to allocated value long" 
	31          "Blank to allocated value long" 
	32          "Don't know to allocated value" 
	33          "Refused to allocated value long"
	40          "Value to allocated value"      
	41          "Blank to allocated value"      
	42          "Don't know to allocated value" 
	43          "Refused to allocated value"    
	50          "Value to blank"                
	52          "Don't know to blank"           
	53          "Refused to blank"              
;
label values pxcohab  pxcohab;
label define pxcohab 
	-1          "Not allocated"                 
	0           "Value - No change"             
	1           "Blank - No change"             
	2           "Don’t know - No change"        
	3           "Refused - No change"           
	10          "Value to Value"                
	11          "Blank to Value"                
	12          "Don’t know to Value"           
	13          "Refused to Value"              
	20          "Value to Longitudinal value"   
	21          "Blank to Longitudinal value"   
	22          "Don't know to Longitudinal"    
	23          "Refused to Longitudinal value" 
	30          "Value to Allocated value long."
	31          "Blank to Allocated value long."
	32          "Don't know to Allocated value" 
	33          "Refused to Allocated value"    
	40          "Value to Allocated value"      
	41          "Blank to Allocated value"      
	42          "Don't know to Allocated value" 
	43          "Refused to Allocated value"    
	50          "Value to Blank"                
	52          "Don't know to Blank"           
	53          "Refused to Blank"              
;
label values pxlndad  pxlndad;
label define pxlndad 
	0           "Value - No change"             
	1           "Blank - No change"             
	2           "Don't know - No change"        
	3           "Refused - No change"           
	10          "Value to Value"                
	11          "Blank to Value"                
	12          "Don't know to Value"           
	13          "Refused to Value"              
	20          "Value to Longitudinal value"   
	21          "Blank to Longitudinal value"   
	22          "Don't know to Longitudinal"    
	23          "Refused to Longitudinal value" 
	30          "Value to Allocated value long."
	31          "Blank to Allocated value long."
	32          "Don't know to Allocated value" 
	33          "Refused to Allocated value"    
	40          "Value to Allocated value"      
	41          "Blank to Allocated value"      
	42          "Don't know to Allocated value" 
	43          "Refused to Allocated value"    
	50          "Value to Blank"                
	52          "Don't know to Blank"           
	53          "Refused to Blank"              
;
label values pxafever pxafever;
label define pxafever
	-1          "Not allocated"                 
	0           "Value - no change"             
	1           "Blank - no change"             
	2           "Don’t know - no change"        
	3           "Refused - no change"           
	10          "Value to value"                
	11          "Blank to value"                
	12          "Don’t know to value"           
	13          "Refused to value"              
	20          "Value to longitudinal value"   
	21          "Blank to longitudinal value"   
	22          "Don’t know to longitudinal"    
	23          "Refused to longitudinal value" 
	30          "Value to allocated value long" 
	31          "Blank to allocated value long" 
	32          "Don’t know to allocated value" 
	33          "Refused to allocated value long"
	40          "Value to allocated value"      
	41          "Blank to allocated value"      
	42          "Don’t know to allocated value" 
	43          "Refused to allocated value"    
	50          "Value to blank"                
	52          "Don’t know to blank"           
	53          "Refused to blank"              
;
label values pxafwhn1 pxafwhna;
label define pxafwhna
	-1          "Not allocated"                 
	0           "Value - no change"             
	1           "Blank - no change"             
	2           "Don’t know - no change"        
	3           "Refused - no change"           
	10          "Value to value"                
	11          "Blank to value"                
	12          "Don’t know to value"           
	13          "Refused to value"              
	20          "Value to longitudinal value"   
	21          "Blank to longitudinal value"   
	22          "Don’t know to longitudinal"    
	23          "Refused to longitudinal value" 
	30          "Value to allocated value long" 
	31          "Blank to allocated value long" 
	32          "Don’t know to allocated value" 
	33          "Refused to allocated value long"
	40          "Value to allocated value"      
	41          "Blank to allocated value"      
	42          "Don’t know to allocated value" 
	43          "Refused to allocated value"    
	50          "Value to blank"                
	52          "Don’t know to blank"           
	53          "Refused to blank"              
;
label values pxdisear pxdisear;
label define pxdisear
	-1          "Not allocated"                 
	0           "Value - no change"             
	1           "Blank - no change"             
	2           "Don’t know - no change"        
	3           "Refused - no change"           
	10          "Value to value"                
	11          "Blank to value"                
	12          "Don’t know to value"           
	13          "Refused to value"              
	20          "Value to longitudinal value"   
	21          "Blank to longitudinal value"   
	22          "Don’t know to longitudinal"    
	23          "Refused to longitudinal value" 
	30          "Value to allocated value long" 
	31          "Blank to allocated value long" 
	32          "Don’t know to allocated value" 
	33          "Refused to allocated value long"
	40          "Value to allocated value"      
	41          "Blank to allocated value"      
	42          "Don’t know to allocated value" 
	43          "Refused to allocated value"    
	50          "Value to blank"                
	52          "Don’t know to blank"           
	53          "Refused to blank"              
;
label values pxnatvty pxnatvty;
label define pxnatvty
	-1          "Not allocated"                 
	0           "Value - no change"             
	1           "Blank - no change"             
	2           "Don't know - no change"        
	3           "Refused - no change"           
	10          "Value to value"                
	11          "Blank to value"                
	12          "Don't know to value"           
	13          "Refused to value"              
	20          "Value to longitudinal value"   
	21          "Blank to longitudinal value"   
	22          "Don't know to longitudinal"    
	23          "Refused to longitudinal value" 
	30          "Value to allocated value long."
	31          "Blank to allocated value long."
	32          "Don't know to allocated value" 
	33          "Refused to allocated value"    
	40          "Value to allocated value"      
	41          "Blank to allocated value"      
	42          "Don't know to allocated value" 
	43          "Refused to allocated value"    
	50          "Value to blank"                
	52          "Don't know to blank"           
	53          "Refused to blank"              
;
label values prwernal prwernal;
label define prwernal
	0           "Not allocated"                 
	1           "Allocated"                     
;
label values prhernal prhernal;
label define prhernal
	0           "Not allocated"                 
	1           "Allocated"                     
;
label values axhrs    axhrs;  
label define axhrs   
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axwhyabs axwhyabs;
label define axwhyabs
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axpayabs axpayabs;
label define axpayabs
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axclswkr axclswkr;
label define axclswkr
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axnlflj  axnlflj;
label define axnlflj 
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axuslhrs axuslhrs;
label define axuslhrs
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axhrlywk axhrlywk;
label define axhrlywk
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axunmem  axunmem;
label define axunmem 
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axuncov  axuncov;
label define axuncov 
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axenrlw  axenrlw;
label define axenrlw 
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axhscol  axhscol;
label define axhscol 
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axftpt   axftpt; 
label define axftpt  
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values axlfsr   axlfsr; 
label define axlfsr  
	0           "No change or children or armed"
	4           "Allocated"                     
;
label values i_workyn i_workyn;
label define i_workyn
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_wtemp  i_wtemp;
label define i_wtemp 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_nwlook i_nwlook;
label define i_nwlook
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_nwlkwk i_nwlkwk;
label define i_nwlkwk
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_rsnnot i_rsnnot;
label define i_rsnnot
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_wkswk  i_wkswk;
label define i_wkswk 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_wkchk  i_wkchk;
label define i_wkchk 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_losewk i_losewk;
label define i_losewk
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_lkweek i_lkweek;
label define i_lkweek
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_lkstr  i_lkstr;
label define i_lkstr 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_pyrsn  i_pyrsn;
label define i_pyrsn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_phmemp i_phmemp;
label define i_phmemp
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_hrswk  i_hrswk;
label define i_hrswk 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_hrchk  i_hrchk;
label define i_hrchk 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_ptyn   i_ptyn; 
label define i_ptyn  
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_ptwks  i_ptwks;
label define i_ptwks 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_ptrsn  i_ptrsn;
label define i_ptrsn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_ljcw   i_ljcw; 
label define i_ljcw  
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_indus  i_indus;
label define i_indus 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_occup  i_occup;
label define i_occup 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_noemp  i_noemp;
label define i_noemp 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_nxtres i_nxtres;
label define i_nxtres
	0           "NIU, or not changed"           
	1           "Assigned from householder"     
	2           "Assigned from spouse"          
	3           "Assigned from mother"          
	4           "Assigned from father"          
	5           "Allocated from matrix"         
;
label values i_mig1   i_mig1l;
label define i_mig1l 
	0           "NIU, or not changed."          
	1           "Assigned from householder."    
	2           "Assigned from spouse"          
	3           "Assign from mother"            
	4           "Assign from father"            
	5           "Allocated from matrix mob"     
;
label values i_mig2   i_mig2l;
label define i_mig2l 
	0           "NIU, or not changed."          
	1           "Assigned from householder"     
	2           "Assigned from spouse"          
	3           "Assigned from mother"          
	4           "Assigned from father"          
	5           "Allocated from matrix MIG1"    
	6           "Allocated from matrix MIG2"    
	7           "Allocated from MIG3"           
	8           "Allocated from MIG4"           
	9           "Allocated from MIG5"           
	10          "Allocated from MIG6"           
;
label values i_mig3   i_mig3l;
label define i_mig3l 
	0           "NIU, or not changed."          
	1           "State and below assigned"      
	2           "County and below assigned"     
	3           "MCD and below assigned"        
	4           "Place only"                    
	5           "County in New York City"       
;
label values i_disyn  i_disyn;
label define i_disyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_ernyn  i_ernyn;
label define i_ernyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_ernsrc i_ernsrc;
label define i_ernsrc
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_ernval i_ernval;
label define i_ernval
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_retsc2 i_retscb;
label define i_retscb
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_wsyn   i_wsyn; 
label define i_wsyn  
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_wsval  i_wsval;
label define i_wsval 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_seyn   i_seyn; 
label define i_seyn  
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_seval  i_seval;
label define i_seval 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_frmyn  i_frmyn;
label define i_frmyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_frmval i_frmval;
label define i_frmval
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_ucyn   i_ucyn; 
label define i_ucyn  
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_ucval  i_ucval;
label define i_ucval 
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at"      
	4           "Statistically matched at"      
;
label values i_wcyn   i_wcyn; 
label define i_wcyn  
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_wctyp  i_wctyp;
label define i_wctyp 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_wcval  i_wcval;
label define i_wcval 
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values i_ssyn   i_ssyn; 
label define i_ssyn  
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_ssval  i_ssval;
label define i_ssval 
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values resnssa  resnssa;
label define resnssa 
	0           "Not imputed or not in universe"
	1           "Imputed"                       
;
label values i_ssiyn  i_ssiyn;
label define i_ssiyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values sskidyna sskidyna;
label define sskidyna
	0           "Not imputed or not in universe"
	1           "Imputed"                       
;
label values i_ssival i_ssival;
label define i_ssival
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values resnssia resnssix;
label define resnssix
	0           "Not imputed or not in universe"
	1           "Imputed"                       
;
label values i_pawyn  i_pawyn;
label define i_pawyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values ssikdyna ssikdyna;
label define ssikdyna
	0           "Not imputed or not in universe"
	1           "Imputed"                       
;
label values i_pawtyp i_pawtyp;
label define i_pawtyp
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_pawmo  i_pawmo;
label define i_pawmo 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_pawval i_pawval;
label define i_pawval
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values i_vetyn  i_vetyn;
label define i_vetyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_vettyp i_vettyp;
label define i_vettyp
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_vetqva i_vetqva;
label define i_vetqva
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_vetval i_vetval;
label define i_vetval
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values i_suryn  i_suryn;
label define i_suryn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_sursc1 i_sursca;
label define i_sursca
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_sursc2 i_surscb;
label define i_surscb
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_survl1 i_survla;
label define i_survla
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at"      
	4           "Statistically matched at"      
;
label values i_survl2 i_survlb;
label define i_survlb
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at"      
	4           "Statistically matched at"      
;
label values i_dishp  i_dishp;
label define i_dishp 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_discs  i_discs;
label define i_discs 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_dissc1 i_dissca;
label define i_dissca
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_dissc2 i_disscb;
label define i_disscb
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_disvl1 i_disvla;
label define i_disvla
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at"      
	4           "Statistically matched at"      
;
label values i_disvl2 i_disvlb;
label define i_disvlb
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values i_retyn  i_retyn;
label define i_retyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_retsc1 i_retsca;
label define i_retsca
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_retvl1 i_retvla;
label define i_retvla
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values i_retvl2 i_retvlb;
label define i_retvlb
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values i_intyn  i_intyn;
label define i_intyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_intval i_intval;
label define i_intval
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values i_divyn  i_divyn;
label define i_divyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_divval i_divval;
label define i_divval
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values i_rntyn  i_rntyn;
label define i_rntyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_rntval i_rntval;
label define i_rntval
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at Level 1"
	4           "Statistically matched at Level 2"
;
label values i_edyn   i_edyn; 
label define i_edyn  
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_edtyp1 i_edtypa;
label define i_edtypa
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_edtyp2 i_edtypb;
label define i_edtypb
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_oedval i_oedval;
label define i_oedval
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at"      
	4           "Statistically matched at"      
;
label values i_cspyn  i_cspyn;
label define i_cspyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_cspval i_cspval;
label define i_cspval
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at"      
	4           "Statistically matched at"      
;
label values i_almyn  i_almyn;
label define i_almyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_almval i_almval;
label define i_almval
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at"      
	4           "Statistically matched at"      
;
label values i_finyn  i_finyn;
label define i_finyn 
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_finval i_finval;
label define i_finval
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at"      
	4           "Statistically matched at"      
;
label values i_oival  i_oival;
label define i_oival 
	0           "No allocation"                 
	1           "Allocated from hot deck"       
	2           "Allocated a loss"              
	3           "Statistically matched at"      
	4           "Statistically matched at"      
;
label values wicyna   wicyna; 
label define wicyna  
	0           "Not imputed or not in universe"
	1           "Imputed"                       
;
label values i_hi     i_hi;   
label define i_hi    
	0           "No"                            
	1           "Allocated"                     
;
label values i_dephi  i_dephi;
label define i_dephi 
	0           "No"                            
	1           "Allocated"                     
;
label values i_paid   i_paid; 
label define i_paid  
	0           "No"                            
	1           "Allocated"                     
;
label values i_hiout  i_hiout;
label define i_hiout 
	0           "No"                            
	1           "Allocated"                     
;
label values i_priv   i_priv; 
label define i_priv  
	0           "No"                            
	1           "Allocated"                     
;
label values i_depriv i_depriv;
label define i_depriv
	0           "No"                            
	1           "Allocated"                     
;
label values i_pout   i_pout; 
label define i_pout  
	0           "No"                            
	1           "Allocated"                     
;
label values i_out    i_out;  
label define i_out   
	0           "No"                            
	1           "Allocated"                     
;
label values i_care   i_care; 
label define i_care  
	0           "No"                            
	1           "Allocated"                     
	2           "Logical imputed"               
;
label values i_caid   i_caid; 
label define i_caid  
	0           "No"                            
	1           "Allocated"                     
	2           "Logical imputed"               
;
label values i_mon    i_mon;  
label define i_mon   
	0           "No"                            
	1           "Allocated"                     
;
label values i_oth    i_oth;  
label define i_oth   
	0           "No"                            
	1           "Allocated"                     
	2           "Logical imputed"               
;
label values i_otyp   i_otyp; 
label define i_otyp  
	0           "No"                            
	1           "Allocated"                     
	2           "Logical imputed"               
;
label values i_ostper i_ostper;
label define i_ostper
	0           "No"                            
	1           "Allocated"                     
;
label values i_ostyp  i_ostyp;
label define i_ostyp 
	0           "No"                            
	1           "Allocated"                     
;
label values i_hea    i_hea;  
label define i_hea   
	0           "No"                            
	1           "Allocated"                     
;
label values iahiper  iahiper;
label define iahiper 
	0           "Not imputed OR NIU"            
	1           "Imputed"                       
;
label values iahityp  iahityp;
label define iahityp 
	0           "Not imputed OR NIU"            
	1           "NIU"                           
;
label values i_pchip  i_pchip;
label define i_pchip 
	0           "Not imputed or NIU"            
	1           "Imputed"                       
;
label values i_penpla i_penpla;
label define i_penpla
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_peninc i_peninc;
label define i_peninc
	0           "No change or children"         
	1           "Allocated"                     
;
label values i_phipval i_phipval;
label define i_phipval
	0           "�Valid response or niu"        
	1           " Allocated at family level (non-   elderly only)"
	2           " Allocated at individual level (elderly only)"
	3           " Missing in family with at least one valid response"
	4           " Value changed to $0 because all family members are uninsured"
	5           " Logical imputation equal to $0 for elderly Medicare enrollees, elderly"
;
label values i_potcval i_potcval;
label define i_potcval
	0           "No"                            
	1           "Allocated"                     
;
label values i_pmedval i_pmedval;
label define i_pmedval
	0           "No"                            
	1           "Allocated"                     
;
label values i_chspval i_chspval;
label define i_chspval
	0           "No"                            
	1           "Allocated"                     
;
label values i_chspyn i_chspyn;
label define i_chspyn
	0           "No"                            
	1           "Allocated"                     
;
label values i_chelsewyn i_chelsewyn;
label define i_chelsewyn
	0           "No"                            
	1           "Allocated"                     
;
label values tsurval1 tsurvala;
label define tsurvala
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tsurval2 tsurvalb;
label define tsurvalb
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tdisval1 tdisvala;
label define tdisvala
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tdisval2 tdisvalb;
label define tdisvalb
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tretval1 tretvala;
label define tretvala
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tretval2 tretvalb;
label define tretvalb
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tint_val tint_val;
label define tint_val
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tdiv_val tdiv_val;
label define tdiv_val
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values trnt_val trnt_val;
label define trnt_val
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values ted_val  ted_val;
label define ted_val 
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tcsp_val tcsp_val;
label define tcsp_val
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values talm_val talm_val;
label define talm_val
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tfin_val tfin_val;
label define tfin_val
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values toi_val  toi_val;
label define toi_val 
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tphip_val tphip_val;
label define tphip_val
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tpotc_val tpotc_val;
label define tpotc_val
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tpmed_val tpmed_val;
label define tpmed_val
	0           "Not topcoded"                  
	1           "Topcoded"                      
;
label values tchsp_val tchsp_val;
label define tchsp_val
	0           "Not topcoded"                  
	1           "Topcoded"                      
;

#delimit cr
compress
saveold `dta_name' , replace
/*
Copyright 2015 shared by the National Bureau of Economic Research and Jean Roth

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
