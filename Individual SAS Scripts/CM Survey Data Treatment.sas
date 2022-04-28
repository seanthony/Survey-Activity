/*
    NOTE: this is just practice and the data used are not real
*/

/*
open each of the files and combine them into a single data set
*/
/* i prefer to have escaped variable names,
and updating the options changes to spaces to _, etc.
(default is any) */
options validvarname=v7;


/* write a macro to simplify the import procedure
instead of copy pasting the same code */
%macro importTXTfiles();
	%do i = 1 %to 4;
		%let filename = &CMsurvey&&i;
		proc import datafile="&filename"
			dbms=csv
			out=SurveyRaw&i
			replace;
		run;
	%end;
%mend importTXTfiles;

%importTXTfiles();

/* clean errors in the data
SurveyRaw3 has mixed types where some
values are "n/a" and it is causing errors
-- going to convert to missing data
to access the numeric values

otherwise all data have 5425 observations.
*/
data Survey1Cleaned;
	/* rename columns to merge on later */
	set SurveyRaw1(
		rename=(
			CM_Identification__=CM_ID
			Constituent_ID__=Constituent_ID
		)
	);
run;

data Survey2Cleaned;
	/* rename column to merge on later */
	set SurveyRaw2(
		rename=(
			CM_ID__=CM_ID
		)
	);
run;

data Survey3Cleaned;
	/* rename to merge */
	set SurveyRaw3(
		rename=(
			Offerings_on_TFANet_are_critical=Offerings_on_TFANet_are_Text
			Constituent_Identification__=Constituent_ID
		)
	);

	/* reassign to updated variable and replace with . */
	if Offerings_on_TFANet_are_Text = "n/a" then Offerings_on_TFANet_are_critical = .;
	else Offerings_on_TFANet_are_critical = input(Offerings_on_TFANet_are_Text, 2.);

	drop Offerings_on_TFANet_are_Text;
run;

data Survey4Cleaned;
	/* rename columns to merge */
	set SurveyRaw4(
		rename=(
			CM_Identification__=CM_ID
		)
	);
run;

/*
combine data sets 1 and 2 on CM_ID
- sort
- merge
*/
proc sort data=Survey1Cleaned;
	by CM_ID;
run;

proc sort data=Survey2Cleaned;
	by CM_ID;
run;

data Survey1and2;
	merge Survey1Cleaned Survey2Cleaned;
	by CM_ID;
run;

/* 
combine data set 1and2 and 3 on Constituent_ID
- sort
- merge
*/
proc sort data=Survey1and2;
	by Constituent_ID;
run;

proc sort data=Survey3Cleaned;
	by Constituent_ID;
run;

data Survey1and2and3;
	merge Survey1and2 Survey3Cleaned;
	by Constituent_ID;
run;

/*
combine final data set on CM_ID
- sort
- merge
*/
proc sort data=Survey1and2and3;
	by CM_ID;
run;

proc sort data=Survey4Cleaned;
	by CM_ID;
run;

data CombinedCMSurvey;
	merge Survey1and2and3 Survey4Cleaned;
	by CM_ID;
run;

/* export for convenience later */
proc export data=CombinedCMSurvey
	file="&CombinedSurvey"
	dbms=xlsx
	replace;
run;