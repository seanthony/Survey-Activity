/*
    NOTE: this is just practice and the data used are not real
*/

/* Import from the exported + merged file
- this is done so we do not have to re-run all the code over everytime
	and we can just import the single file
*/
proc import datafile="&AllDataFile"
	out=AllData
	dbms=xlsx
	replace;
run;

/* exploring the data can be done as shown with the CM survey data
- reading the output log to explore the data
- using procedures like PROC FREQ or PROC MEANS to explore the data
- use base SAS and writing DATA step code to filter out the data
- etc.
*/

/*
	EXPLORING HYPOTHESES IN THE DATA
*/

/* Hypothesis 1:
- do educators have a higher NPS?
*/
data hypothesis1;
	set AllData;
	/* subset to only the needed variables */
	keep professioncategory npsStrong;
	/* assign a new value if their nps (net promoter score)
	is greater than or equal to 10 */
	if nps >= 9 then npsStrong = 1;
	else npsStrong = 0;

	/* only keep data where there is profession and nps */
	if (professioncategory ne " ") and nps ne .;
run;

proc means data=hypothesis1;
	class professioncategory;
run;
	
/* results from Hypothesis 1
- the largest sample of our alum are working in education,
	but they do not have the highest nps. Business had the
	highest NPS percentage, makes me think maybe those alum
	planned on making a career change after their corps
	experience so have a more positive view of their time teaching.
*/
	
/* Hypothesis 2:
- do school leaders have higher cli scores?
*/
data hypothesis2;
	set AllData;
	/* keep only necessary variables */
	keep schoolleader meancli cli1-cli8;
	/* calculate mean of cli scores */
	/* SAS uses sequential notation for variables with the OF operator */
	meancli = sum(of cli1-cli8) / 8;
run;

proc means data=hypothesis2;
	class schoolleader;
	var meancli;
run;

/* results from hypothesis 2
- it does appear that mean CLI scores are higher for those that
	are school leaders.
- next i would want to do some more analysis to see if thise is
	significant and maybe interrogate specific Qs
*/