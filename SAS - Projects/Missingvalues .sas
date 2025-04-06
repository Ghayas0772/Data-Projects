



/* Step 1: Define the library for the shared folder (source) */
libname sasdata '/home/u64175548/my_shared_file_links/kevinduffy-deno1/Datafiles/Lecture Week 2';

/* Step 2: Define the library where you want to copy the dataset (destination) */
libname ANA610 '/home/u64175548/my_courses/ANA610/Program/Homework4';

/* Step 3: Copy the dataset from shared folder to your ANA610 library */
data ANA610.annuity_master_new;
    set sasdata.annuity_master_new;
run;

/* Step 4: View the contents (columns, types, etc.) of the copied dataset */
proc contents data=ANA610.annuity_master_new;
run;

/* Unconditonal Impuation */
/*Step 1: Filter rows where mmk_act_id is not missing */

data annuity_master_new1;
    set ANA610.annuity_master_new;
    where mmk_act_id notine(.); /* only want bank customers who have mmk account */
run;

/* Step 2: Create a copy of mmbal and a dummy variable to flag missing values8*/

proc print data =ana610.annuity_master_new (firstobs=1 obs=10);
		 run;
data one;
    set annuity_master_new1;
    mmbal_mi = mmbal;
    mmbal_mi_dum = missing(mmbal);
run;

proc print data= one  (firstobs=1 obs=10); run;
proc print data= one  (firstobs=1 obs=25); var mmbal mmbal_mi mmbal_mi_dum; run;

proc means data=one n nmiss min mean max median std; var mmbal mmbal_mi mmbal_mi_dum; run;

proc univariate data=one; var mmbal; histogram mmbal; run;

proc sgplot data=one; 
	histogram mmbal / binwidth=1000 transparency=.5; run;
	
proc corr data=one; var mmbal; with inarea chk_have; run;	
	
*Step 2 : impute missing value indicator and duplicate of varible to impute;

	proc stdize data=one
		method = median
		reponly
		out=imputed;
		var mmbal_mi;
	run;

proc print data= imputed  (firstobs=1 obs=25); var mmbal mmbal_mi mmbal_mi_dum; run;

proc means data=imputed n nmiss min mean max median std; var mmbal mmbal_mi; run;

proc sgplot data= imputed ;
	histogram mmbal / binwidth=1000 transparency=.5;
	histogram mmbal_mi / binwidth=1000 transparency=.5; run;
	
proc sgplot data= imputed ;
	hbox mmbal;
	hbox mmbal_mi;
	run;
	
 proc corr data= imputed; var mmbal mmbal_mi; with inarea chk_have; run;
 
 
 *===============> Conditional Imputation ===============================;
 * Exxmple : hot-deck  conditional imputation ;
 
 
 data one_1;
    set annuity_master_new1;
    mmbal_mi = mmbal;
    mmbal_mi_dum = missing(mmbal);
run;
 
 
proc print data= one_1  (firstobs=1 obs=25); var mmbal mmbal_mi mmbal_mi_dum; run;

proc surveyimpute data= one_1 seed=1234 method = hotdeck(selection =srswr);
	var mmbal_mi sdb orig_dt ins_have chk_have mtg_have sav_have ira_have cc_have inarea;
	output out= imputed_1; 
	run; 

proc means data=imputed_1 n nmiss min mean max median std; var mmbal mmbal_mi; run;

proc sgplot data= imputed_1 ;
	histogram mmbal / binwidth=1000 transparency=.5;
	histogram mmbal_mi / binwidth=1000 transparency=.5; run;
	
proc sgplot data= imputed_1 ;
	hbox mmbal;
	hbox mmbal_mi;
	run;
 
 proc corr data=imputed_1; var mmbal mmbal_mi; with inarea chk_have; run;
 
 
 *====> Example: mmbal and PMM conditional imputation +====;
 
 
 data one;
    set annuity_master_new1;
    mmbal_mi = mmbal;
    mmbal_mi_dum = missing(mmbal);
run;

	proc mi data=one nimpute=1 seed=12345 out= imputed;
	fcs regpmm (mmbal_mi sdb orig_dt ins_have chk_have mtg_have sav_have ira_have cc_have inarea);
	var mmbal_mi sdb orig_dt ins_have chk_have mtg_have sav_have ira_have cc_have inarea;
	run;
	

*step 3: conduct compartaive analysis ;
	proc means data=imputed n nmiss min mean max median std; var mmbal mmbal_mi; run;
	
	
 proc corr data=imputed; var mmbal mmbal_mi; with inarea chk_have; run;
	
	
	proc sgplot data= imputed ;
	histogram mmbal / binwidth=1000 transparency=.5;
	histogram mmbal_mi / binwidth=1000 transparency=.5; run;
	
proc sgplot data= imputed ;
	hbox mmbal;
	hbox mmbal_mi;
	run;
	
*====> Imputing a catagorical varibale .;


/* Step 1: Define the library for the shared folder (source) */
libname sasdata '/home/u64175548/my_shared_file_links/kevinduffy-deno1/Datafiles/Lecture Week 2';
	
/* Step 2: Define the library where you want to copy the dataset (destination) */
libname ANA610 '/home/u64175548/my_courses/ANA610/Program/Homework4';

/* Step 3: Copy the dataset from shared folder to your ANA610 library */
data ANA610.annuity_master_new;
    set sasdata.annuity_master_new;
run;

proc freq data= ana610.annuity_master_new; table res; run; /* missing 1500 values */

data one ; set ana610.annuity_master_new; 
	if missing(res) then res="Missing";
	run;

* to check dublicate values i res table ;

proc sort data=ana610.annuity_master_new nodupkey;
    by res;
run;

*2. Counting Missing Values in Specific Categories;

proc freq data=ana610.annuity_master_new;
    tables res / missing;
    where res in ('R', 'S', 'U');
run;

proc sql;
    select res, count(*) as missing_count
    from ana610.annuity_master_new
    where res in ('R', 'S', 'U')
    group by res;
quit;


proc sql;
    select count(*) as missing_res_count
    from ana610.annuity_master_new
    where res is missing;
quit;


proc means data=ana610.annuity_master_new noprint;
    var res;
    output out=mean_values mean=mean_res;
run;

data imputed_data;
    set ana610.annuity_master_new;
    if missing(res) then set mean_values;
    if missing(res) then res = mean_res;
run;



data res_num;
    set ana610.annuity_master_new;
    if res = "R" then res_num = 1;
    else if res = "S" then res_num = 2;
    else if res = "U" then res_num = 3;
    else res_num = .; /* For missing or other values */
run;


proc means data=res_num noprint;
    var res_num;
    output out=mean_val mean=mean_res;
run;

data res_imputed;
    if _n_ = 1 then set mean_val;
    set res_num;
    if missing(res_num) then res_num = mean_res;
run;

