options validvarname=v7;

/* import the alumni survey data */
proc import datafile="&alumsurvey"
	out=AlumRaw
	dbms=xlsx
	replace;
run;

/* data file has 5425 observations, same number as the CM values */

/* need to rename the CM ID variable to merge
-rename
-sort
-merge
*/
data AlumCleaned;
	set AlumRaw(rename=(CM_Iden=CM_ID));
run;

/* sort the files to be merged */
proc sort data=CombinedSurvey;
	by CM_ID;

proc sort data=AlumCleaned;
	by CM_ID;
run;

/* merge the data */
data AllData;
	merge CombinedSurvey AlumCleaned;
	by CM_ID;
run;

/* export to a combined file so it is easier to access later */
proc export data=AllData
	outfile="&AllDataFile"
	dbms=xlsx
	replace;
run;