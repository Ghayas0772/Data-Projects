/* -----------------Data profiling Fortune Project files  -----------------------------------------------------*/

/* 	to access the donor_censuse2 file*/

	libname sasdata '/home/u64175548/my_shared_file_links/kevinduffy-deno1/Datafiles/Homework 4';
	libname ANA610 '/home/u64175548/my_courses/ANA610/Data/Homwork4';
	
		proc contents data=ANA610.fortune_survey; run;
				
		proc print data=ANA610.fortune_survey (firstobs=1 obs=50); run;
		
		proc means data=ANA610.fortune_acct;
		var PerformanceRating;
		
		proc means data= ana610.fortune_acct; run;
		proc freq data= ana610.fortune_acct (obs= 10); run;
		proc print data= ana610.fortune_acct (obs=10); run;
		proc means data= ANA610.fortune_acct n nmiss mean median max std; run;
		
		proc contents data=ANA610.fortune_acct; run;
		proc contents data= ana610.fortune_attrition; run;
		proc contents data=ANA610.fortune_credit; run;
		proc contents data=ANA610.fortune_hr; run;
		proc contents data=ANA610.fortune_survey; run;
		proc print data= ana610.fortune_hr (firstobs=1 obs=10); run;
		
		proc contents data= ANA610.fortune_acct; run;
		
		
proc univariate data=ANA610.fortune_acct;
    var HourlyRate MonthlyIncome PercentSalaryHike PerformanceRating StockOptionLevel DailyRate;
    histogram DailyRate / normal;
run;


proc univariate data=ANA610.fortune_acct;
    var _NUMERIC_;
    histogram / normal;
run;


proc freq data=ANA610.fortune_acct;
    tables _CHARACTER_ / plots=freqplot;
run;

		
		PROC FREQ DATA=ANA610.fortune_acct NLEVELS;
		    TABLES DailyRate / NOPRINT;
		RUN;

/* Task#1 Data Audtit ===================================================== */

/* A. Data profiling for Numaric Variable	*/

/* final micro for numaric variable */

%macro analyze_numeric(dataset, var);
    /* Display dataset contents */
    PROC CONTENTS DATA=&dataset;
    RUN;

    /* Descriptive Statistics */
    proc means data=&dataset n nmiss min mean median max std skewness maxdec=2;
        var &var;
    run;

    /* Distribution Analysis */
    proc univariate data=&dataset;
        var &var;
        histogram &var / normal;
    run;

    /* DISTINCT COUNT and PERCENTAGE */
    PROC SQL;
        SELECT COUNT(*) AS Records,
               COUNT(DISTINCT &var) AS Distinct_Values,
               PUT(COUNT(DISTINCT &var) * 100.0 / COUNT(*), 8.2) AS DistinctPct
        FROM &dataset;
    QUIT;

    /* Handling Missing Values */
    proc freq data=&dataset;
        tables &var / missing;
    run;
%mend analyze_numeric;

/* Run the macro for a specific dataset and numeric variable */
%analyze_numeric(ANA610.fortune_survey,  employee_no
);

/*-----------------------------------------------------------------------------------*/

/*B.Data profileing for Catagorical and character variables */

===================================================================================================

%macro analyze_categorical(dataset, var);
    /* Display dataset contents */
    PROC CONTENTS DATA=&dataset;
    RUN;

    /* Frequency Distribution */
    proc freq data=&dataset;
        tables &var / missing;
    run;

    /* DISTINCT COUNT and PERCENTAGE */
    PROC SQL;
        SELECT COUNT(*) AS Records,
               COUNT(DISTINCT &var) AS Distinct_Values,
               PUT(COUNT(DISTINCT &var) * 100.0 / COUNT(*), 8.2) AS DistinctPct
        FROM &dataset;
    QUIT;

    /* If the variable is ordinal or numeric, use PROC UNIVARIATE */
    /* Check if the variable is numeric (ordinal or continuous numeric categories) */
    PROC SQL NOPRINT;
        SELECT TYPE INTO :var_type 
        FROM DICTIONARY.COLUMNS 
        WHERE LIBNAME = 'ANA610' AND MEMNAME = "%UPCASE(%scan(&dataset, 2, .))" AND NAME = "&var";
    QUIT;

    /* Run PROC UNIVARIATE for ordinal/numeric variables */
    %IF &var_type = 1 %THEN %DO;
        proc univariate data=&dataset;
            var &var;
            histogram &var;
        run;
    %END;

    /* Bar Chart for Visualization */
    proc sgplot data=&dataset;
        vbar &var / datalabel;
        title "Bar Chart of &var";
    run;
%mend analyze_categorical;

/* Run the macro for a categorical variable */
%analyze_categorical(ANA610.fortune_survey,WorkLifeBalance );   
%analyze_categorical(ANA610.fortune_hr, brith_dt hire_dt  ); 


BusinessTravel,  , 
=================================================================================================================

%macro analyze_ssn(dataset, var);
    /* Display dataset contents */
    PROC CONTENTS DATA=&dataset;
    RUN;

    /* Frequency Distribution for SSN */
    proc freq data=&dataset;
        tables &var / missing;
    run;

    /* DISTINCT COUNT and PERCENTAGE */
    PROC SQL;
        SELECT COUNT(*) AS Records,
               COUNT(DISTINCT &var) AS Distinct_Values,
               PUT(COUNT(DISTINCT &var) * 100.0 / COUNT(*), 8.2) AS DistinctPct
        FROM &dataset;
    QUIT;

    /* Bar Chart for Visualization of SSN (if needed) */
    proc sgplot data=&dataset;
        vbar &var / datalabel;
        title "Bar Chart of &var";
    run;
%mend analyze_ssn;

/* Run the macro for SSN */
%analyze_ssn(ANA610.fortune_acct, SSN);




/* data */

proc means data=ANA610.FORTUNE_ATTRITION;
   var depart_dt;
run;

proc univariate data=ANA610.FORTUNE_ATTRITION;
   var depart_dt;
   histogram depart_dt;
run;


/* Task #2 =======================================================================================*/

	
/* Set Library Path */
libname ANA610 '/home/u64175548/my_courses/ANA610/Data/Homwork4';

/* Step 1: Matching Employee Numbers Across Datasets */
proc sql;
    select a.employee_no 
    from ANA610.fortune_acct as a
    inner join ANA610.fortune_attrition as b
    on a.employee_no = b.employee_no;
quit;

/* Step 2: Convert SSN Format for Matching */
data ANA610.fortune_credit_fixed;
    set ANA610.fortune_credit;

    /*  if SSN is numeric and convert accordingly */
    if vtype(ssn) = 'N' then ssn_char = put(ssn, z9.); /* Convert numeric SSN to character with leading zeros */
    else ssn_char = ssn; /* If already character, keep as is */
run;

/* Step 3: Sort Data Before Merging */
proc sort data=ANA610.fortune_acct; by employee_no; run;
proc sort data=ANA610.fortune_hr; by employee_no; run;
proc sort data=ANA610.fortune_attrition; by employee_no; run;
proc sort data=ANA610.fortune_survey; by employee_no; run;

/* Step 4: Perform Left Join to Keep All fortune_acct Records */
data ANA610.final_merged_data;
    merge ANA610.fortune_acct (in=a)
          ANA610.fortune_hr (in=b)
          ANA610.fortune_attrition (in=c)
          ANA610.fortune_survey (in=d);
    by employee_no;
    if a; /* Keep all records from fortune_acct */
run;

/* Step 5: Sort before merging with SSN */
proc sort data=ANA610.final_merged_data; by ssn; run;
proc sort data=ANA610.fortune_credit_fixed; by ssn_char; run;

/* Step 6: Merge with fortune_credit_fixed Using Left Join */
proc sql;
    create table ANA610.merge_all as
    select a.*, b.fico_scr
    from ANA610.final_merged_data as a
    left join ANA610.fortune_credit_fixed as b
    on a.ssn = b.ssn_char;
quit;

 /* Adding a new variable to the final merged data */
data ANA610.final_merged_data;
    set ANA610.final_merged_data;
    New_Variable = "I did it again!";
run;

/* Step 7: Export the final merged dataset to a CSV file */
proc export data=ANA610.final_merged_data
    outfile=' /home/u64175548/my_courses/ANA610/Data/Homwork4/All_CSVs/Ghayas_final_merged_data.csv' /* Replace with desired file path */
    dbms=csv
    replace;
run;


/* Step 7: Validate Data - Check Contents and Print Sample Rows */
proc contents data=ANA610.merge_all; run;
proc print data=ANA610.merge_all (obs=5); run;

proc means data=ANA610.merge_all n nmiss mean min max std skew;
    var depart_dt birth_dt;
run;


 /*Modeling sample */

proc contents data=ANA610.merge_all; run;

proc sql;
    /* Count total observations */
    select count(*) as Total_Records from ANA610.merge_all;
quit;

proc freq data=ANA610.merge_all;
    /* Check distribution of categorical variables */
    tables BusinessTravel Department EducationField Gender MaritalStatus OverTime / missing;
run;

proc means data=ANA610.merge_all n nmiss mean std min max;
    /* Assess numerical variable distributions and missing values */
    var DailyRate DistanceFromHome Education EnvironmentSatisfaction HourlyRate 
        JobInvolvement JobLevel JobSatisfaction MonthlyIncome NumCompaniesWorked 
        PercentSalaryHike PerformanceRating RelationshipSatisfaction StockOptionLevel 
        TotalWorkingYears TrainingTimesLastYear WorkLifeBalance YearsInCurrentRole 
        YearsSince

 
/*========================================================*/
/*Task# 

1.	After merging the 5 files, you should find duplicate rows.  Deduplicate your SAS and R modeling datafiles:
a.	Using SAS,
i.	Show your SAS code here for how you would deduplicate.
ii.	Show here SAS-generated output which shows the before and after row count.*/

libname ANA610 '/home/u64175548/my_courses/ANA610/Data/Homwork4';

/* Check initial row count */
proc sql;
    select count(*) as before_dedup_count 
    from ANA610.merge_all;
quit;

/* Deduplicate the dataset by employee_no */
proc sort data=ANA610.merge_all nodupkey out=ANA610.merge_all_dedup;
    by employee_no;
run;

/* Check row count after deduplication */
proc sql;
    select count(*) as after_dedup_count 
    from ANA610.merge_all_dedup;
quit;

/*================================================*/
/* Step 8: Create AGE, TENURE, and MESSAGE Variables */
data ANA610.employees_with_age_tenure;
    set ANA610.merge_all;

    /* Ensure dates are properly read as SAS date format */
    format birth_dt hire_dt depart_dt date9.;

    /* Creating AGE using YRDIF function */
    if birth_dt ne . then AGE = YRDIF(birth_dt, today(), 'ACT/ACT');
    
    /* Round AGE to nearest integer */
    AGE = round(AGE);

    /* Creating TENURE using YRDIF function */
    if hire_dt ne . then do;
        if depart_dt ne . then 
            TENURE = YRDIF(hire_dt, depart_dt, 'ACT/ACT'); /* For departed employees */
        else 
            TENURE = YRDIF(hire_dt, today(), 'ACT/ACT'); /* For current employees */
    end;

    /* Ensuring that tenure is an integer value */
    TENURE = FLOOR(TENURE);

 
/* Step 9: Print Sample Data */
proc print data=ANA610.employees_with_age_tenure (obs=10);
    var AGE TENURE New_variable;
run;

/* Step 9: Print Sample Data */
proc print data=ANA610.employees_with_age_tenure (obs=10);
    var AGE TENURE;
run;

/* Step 10: Univariate Analysis */
proc univariate data=ANA610.employees_with_age_tenure;
    var AGE TENURE;
    histogram AGE TENURE;
run;

/* Step 11: Boxplots for AGE and TENURE */
proc sgplot data=ANA610.employees_with_age_tenure;
    vbox AGE;
    vbox TENURE;
run;

/* Final validation */
proc contents data= ANA610.employees_with_age_tenure; run;


proc means data=ANA610.employees_with_age_tenure n nmiss mean min max;
run;

proc freq data=ANA610.employees_with_age_tenure;
    tables BusinessTravel Department EducationField Gender MaritalStatus OverTime;
run;

proc print data=ANA610.employees_with_age_tenure (obs=5);
run;

/*=============================================================================================*/
/*Checking AGE and TENURE Integrity in SAS*/

libname ANA610 '/home/u64175548/my_courses/ANA610/Data/Homwork4';
/* Step 1: Check for missing values */
proc means data=ANA610.employees_with_age_tenure n nmiss mean min max std;
    var AGE TENURE;
run;

/* Step 2: Univariate analysis for extreme values */
proc univariate data=ANA610.employees_with_age_tenure;
    var AGE TENURE;
    histogram AGE TENURE;
    qqplot AGE TENURE;
    inset mean median min max std / position=ne;
run;

/* DISTINCT COUNT and PERCENTAGE */
PROC SQL;
    SELECT COUNT(*) AS Records, 
           COUNT(DISTINCT AGE) AS Distinct_Age, 
           COUNT(DISTINCT TENURE) AS Distinct_Tenure, 
           PUT((COUNT(DISTINCT AGE) * 100.0 / COUNT(*)), 8.2) AS AgeDistinctPct,
           PUT((COUNT(DISTINCT TENURE) * 100.0 / COUNT(*)), 8.2) AS TenureDistinctPct
    FROM ANA610.employees_with_age_tenure;
QUIT;


/* Step 3: Boxplots to detect extreme distribution */
proc sgplot data=ANA610.employees_with_age_tenure;
    vbox AGE / datalabel=AGE;
    vbox TENURE / datalabel=TENURE;
run;

/*=======================================================================================*/
/*2. Creating the Target Variable ATT_Q*/
/* a. Create ATT_Q variable */

libname ANA610 '/home/u64175548/my_courses/ANA610/Data/Homwork4';
/* Step 1: Ensure both datasets are sorted by employee_no */
proc sort data=ANA610.employees_with_age_tenure; 
    by employee_no; 
run;

proc sort data=ANA610.fortune_survey; 
    by employee_no; 
run;

/* Step 2: Merge datasets */
data ANA610.final_target;
    merge ANA610.employees_with_age_tenure (in=a)
          ANA610.fortune_survey (in=b keep=employee_no);
    by employee_no;

    /* survey_taken = 1 if employee is in fortune_survey dataset */
    if b then survey_taken = 1;
    else survey_taken = 0;

    /* voluntary_attrition = 1 if depart_dt is NOT missing */
    if not missing(depart_dt) then voluntary_attrition = 1;
    else voluntary_attrition = 0;

    /* Create ATT_Q: 1 if took survey and voluntarily left, 0 otherwise */
    ATT_Q = (survey_taken = 1 and voluntary_attrition = 1);
run;

/*(b) SAS-Generated Output for Frequency of ATT_Q*/

proc contents data=ANA610.final_target; 
run;

proc freq data=ANA610.final_target;
    tables survey_taken * voluntary_attrition * ATT_Q / list missing;
run;

/* Display frequency counts for ATT_Q variable */
proc freq data=ANA610.final_target;
    tables survey_taken voluntary_attrition ATT_Q;
run;

/* Cross-tabulation of survey_taken, voluntary_attrition, and ATT_Q */
proc freq data=ANA610.final_target;
    tables survey_taken * voluntary_attrition * ATT_Q / list missing;
run;

/*================================================================================*/
/* 31.	You have found that AGE has missing values. 
 Using SAS and your SAS deduplicated datafile, impute these missing values using Predictive Mean Matching (PMM). 
 Use as control variables EDUCATION and HIRE_DT for this conditional imputation approach.  
 Impute AGE across the entire datafile.  */

libname ANA610 '/home/u64175548/my_courses/ANA610/Data/Homwork4';

proc contents data=ANA610.employees_with_age_tenure; run;
proc means data=ANA610.employees_with_age_tenure;  run;
proc print data=ANA610.employees_with_age_tenure (firstobs=1 obs=10)


/* Step 1: Impute Missing AGE Using Predictive Mean Matching */
proc mi data=ANA610.EMPLOYEES_WITH_AGE_TENURE seed=1234 out=ANA610.imputed_data;
    class EDUCATION;  /* EDUCATION is categorical */
    
    /* Define the variables to be used in imputation */
    var AGE EDUCATION HIRE_DT;  /* AGE to be imputed using EDUCATION and HIRE_DT */
    
    /* Use Predictive Mean Matching for imputation */
    fcs regpmm(AGE = EDUCATION HIRE_DT);  /* Perform imputation for AGE using PMM */
run;


/* Step 2: Summary Statistics for Observed and Imputed AGE */

/* Create a combined dataset with observed and imputed AGE */
data combined_data;
   set ANA610.EMPLOYEES_WITH_AGE_TENURE (rename=(AGE=AGE_orig)) 
       ANA610.imputed_data (rename=(AGE=AGE_imputed));
   if missing(AGE_orig) then AGE_orig = .; /* Keep original values */
run;

proc means data=combined_data n min mean median max std;
   var AGE_orig AGE_imputed;
   output out=summary_stats 
          n=n min=min mean=mean median=median max=max std=std;
run;

/* Display the results in a table format */
proc print data=summary_stats;
   title "Summary Statistics for Observed and Imputed AGE";
run;

/* Calculate Correlations between AGE, EDUCATION, and HIRE_DT */
proc corr data=ANA610.imputed_data;
   var AGE EDUCATION HIRE_DT;
run;


/* Step 3: Overlaid Histogram and Boxplot Using PROC SGPLOT */

/* Overlaid Histogram */
proc sgplot data=ANA610.imputed_data;
   histogram AGE / fillattrs=(color=lightblue) binwidth=1;
   density AGE / type=kernel;
   xaxis label="AGE" grid;
   yaxis label="Frequency";
   title "Histogram of Imputed AGE";
run;

/* Boxplot for Observed and Imputed AGE */
proc sgplot data=combined_data;
   vbox AGE_orig / category="Observed" group="Observed" fillattrs=(color=lightgreen);
   vbox AGE_imputed / category="Imputed" group="Imputed" fillattrs=(color=lightblue);
   xaxis label="AGE" grid;
   title "Boxplot of Observed vs Imputed AGE";
run;

/*=================*Task#4=========================================================*/ from here on ward 

libname ANA610 '/home/u64175548/my_courses/ANA610/Data/Homwork4';
proc contents data=ANA610.imputed_data; run;
proc means data=ANA610.imputed_data;  run;
proc print data=ANA610.imputed_data (firstobs=1 obs=10); run;


/* Load dataset */
libname ANA610 "/home/u64175548/my_courses/ANA610/Data/Homwork4/";

proc univariate data=ANA610.imputed_data;
    var AGE TENURE;
    histogram AGE TENURE / endpoints=10;
run;

proc univariate data=ANA610.imputed_data;
    var AGE TENURE;
    histogram AGE TENURE;
run;


/* Determine number of bins dynamically */
proc rank data=ANA610.imputed_data out=AGE_BINS groups=10;  
    var AGE;  
    ranks AGE_BIN;  
run;

proc freq data=AGE_BINS;
    tables AGE_BIN / nocum;
run;

proc rank data=ANA610.imputed_data out=TENURE_BINS groups=10;  
    var TENURE;  
    ranks TENURE_BIN;  
run;

proc freq data=TENURE_BINS;
    tables TENURE_BIN / nocum;
run;

/* Adjust bins to ensure each has at least 20 observations */
%macro adjust_bins(var);
    %let done = 0;
    %let num_bins = 10;

    %do %while (&done = 0);
        proc rank data=ANA610.imputed_data out=&var._BINS groups=&num_bins;
            var &var;
            ranks &var._BIN;
        run;

        proc freq data=&var._BINS;
            tables &var._BIN / out=freq_out noprint;
        run;

        proc sql noprint;
            select count(*) into :below_thresh 
            from freq_out
            where count < 20;
        quit;

        %if &below_thresh > 0 %then %let num_bins = %eval(&num_bins - 1);
        %else %let done = 1;
    %end;

    %put Final bins for &var = &num_bins;
%mend adjust_bins;

%adjust_bins(AGE);
%adjust_bins(TENURE);

proc sql;
    select min(count) as Min_Obs_Per_Bin
    from freq_out;
quit;


proc freq data=&var._BINS;
    tables &var._BIN / out=freq_out noprint;
run;

proc sql noprint;
    select count(*) into :below_thresh 
    from freq_out
    where frequency < 20;
quit;


/*----------------------------------*/

%macro adjust_bins(var);
    %let done = 0;
    %let num_bins = 10;

    %do %while (&done = 0);
        /* Rank the variable into bins */
        proc rank data=ANA610.imputed_data out=&var._BINS groups=&num_bins;
            var &var;
            ranks &var._BIN;
        run;

        /* Get frequency count for each bin */
        proc freq data=&var._BINS;
            tables &var._BIN / out=freq_out noprint;
        run;

        /* Check if any bin has fewer than 20 observations */
        proc sql noprint;
            select count(*) into :below_thresh 
            from freq_out
            where COUNT < 20; /* Using the correct column name 'COUNT' */
        quit;

        /* If any bin has fewer than 20, decrease the number of bins */
        %if &below_thresh > 0 %then %let num_bins = %eval(&num_bins - 1);
        %else %let done = 1;
    %end;

    %put Final bins for &var = &num_bins;
%mend adjust_bins;

/* Run macro for both AGE and TENURE */
%adjust_bins(AGE);
%adjust_bins(TENURE);


/* Print frequency counts for debugging */
proc print data=freq_out;
run;

/* Check frequency counts and thresholds */
proc sql noprint;
    select COUNT, TENURE_BIN
    from freq_out;
quit;

proc sql;
    select COUNT, TENURE_BIN
    from freq_out;
quit;

proc sql;
    create table tenure_counts as
    select COUNT, TENURE_BIN
    from freq_out;
quit;



proc hpbin data=work.tenure_data out=tenure_bins;
   input TENURE;
   target target_variable;   /* Replace target_variable with your actual target variable */
   bins 10 / method=height;
run;


proc hpbin data=work.tenure_data out=tenure_bins;
   input TENURE;
   target attrition;   /* Replace attrition with your actual target variable */
   bins 10 / method=height;
run;



proc datasets library=work;
run;

proc hpbin data=work.tenure_bins out=final_tenure_bins;
   input TENURE;
   target attrition;   /* Replace 'attrition' with your actual target variable */
   bins 10 / method=height;
run;


proc contents data=work.tenure_bins;
run;

proc contents data=work.tenure_bins;
   ods select Variables;
run;

proc hpbin data=work.tenure_bins out=final_tenure_bins;
   input TENURE;
   target OverTime;   /* Using OverTime as a proxy for attrition */
   bins 10 / method=height;
run;




===================




* For AGE;
proc hpbin data=work.tenure_bins out=age_bins;
   input AGE;
   bins 10 / method=height;
run;

data age_dummy_vars;
   set age_bins;
   array age_bins[10] age_bin1-age_bin10;   /* Create 10 dummy variables for 10 bins */
   do i = 1 to 10;
      age_bins[i] = (AGE in <age_bin_range>);  /* Adjust <age_bin_range> with actual ranges */
   end;
run;

* For TENURE;
proc hpbin data=work.tenure_bins out=tenure_bins;
   input TENURE;
   bins 10 / method=height;
run;

data tenure_dummy_vars;
   set tenure_bins;
   array tenure_bins[10] tenure_bin1-tenure_bin10;   /* Create 10 dummy variables for 10 bins */
   do i = 1 to 10;
      tenure_bins[i] = (TENURE in <tenure_bin_range>);  /* Adjust <tenure_bin_range> with actual ranges */
   end;
run;

PROC CONTENTS data= age_dummy_vars; RUN;

* Check the data in the original dataset for AGE;
proc print data=work.tenure_bins(obs=10);  /* View the first 10 rows */
   var AGE;
run;

* Binning the AGE variable into 5 bins using PROC HPBIN;
proc hpbin data=work.tenure_bins out=age_bins;
   input AGE;
   bins 5 / method=height;  /* Binning into 5 equal height bins */
run;

* View the bins created by PROC HPBIN;
proc print data=age_bins;
   var AGE _BIN_;
run;


* Run the PROC HPBIN and view the dataset structure;
proc hpbin data=work.tenure_bins out=age_bins;
   input AGE;
   bins 5 / method=height;  /* Binning into 5 equal height bins */
run;

* Print the contents of the age_bins dataset to check the bin variable name;
proc contents data=age_bins;
run;

* Creating dummy variables based on bins (assuming the bin variable is AGE_BIN);
data age_dummy_vars;
   set age_bins;
   array age_bins[5] age_bin1-age_bin5;  /* Create 5 dummy variables for 5 bins */
   do i = 1 to 5;
      age_bins[i] = (AGE in <bin_range_for_bin[i]>);  /* Adjust <bin_range_for_bin[i]> with the bin ranges */
   end;
run;


data age_dummy_vars;
   set age_bins;
   * Create dummy variables for each bin;
   array age_bins[5] age_bin1-age_bin5;
   do i = 1 to 5;
      age_bins[i] = (AGE_BIN = i);  /* Assuming AGE_BIN has values from 1 to 5 */
   end;
run;

PROC means data=age_dummy_vars; run;





























/* for catagorical variable */


PROC FREQ DATA=ANA610.fortune_acct;
    TABLES Department / OUT=dept_freq OUTPCT;
RUN;

PROC SGPLOT DATA=dept_freq;
    VBAR Department / RESPONSE=PERCENT;
    TITLE "Department Distribution (Percentage)";
    YAXIS LABEL="Percentage";
RUN;

PROC GCHART DATA=ANA610.fortune_acct;
    PIE Department / PERCENT;
    TITLE "Department Distribution (Pie Chart)";
RUN;
QUIT;


/*mcro for catagorical variables */

%macro analyze_categorical(dataset, var);
    /* Display dataset contents */
    PROC CONTENTS DATA=&dataset;
    RUN;

    /* Frequency Distribution */
    proc freq data=&dataset;
        tables &var / missing;
    run;
    
      /* Distribution Analysis */
    proc univariate data=&dataset;
        var &var;
       run;

    /* DISTINCT COUNT and PERCENTAGE */
    PROC SQL;
        SELECT COUNT(*) AS Records,
               COUNT(DISTINCT &var) AS Distinct_Values,
               PUT(COUNT(DISTINCT &var) * 100.0 / COUNT(*), 8.2) AS DistinctPct
        FROM &dataset;
    QUIT;

    /* Bar Chart for Visualization */
    proc sgplot data=&dataset;
        vbar &var / datalabel;
        title "Bar Chart of &var";
    run;
%mend analyze_categorical;

/* Run the macro for a categorical variable */
%analyze_categorical(ANA610.fortune_acct, snn);
