options validvarname=v7;

/* 
import the combined file
- exported from the last step so we did not need to 
	re-run the script to import and merge all the files
	if we want to re-explore the data
*/

proc import datafile="&CombinedSurvey"
	out=CombinedSurvey
	dbms=xlsx
	replace;
run;

/*
generate some descriptive stats
*/

/* number of responses */
/* 
	this can be read in from the LOG after running the import statement
	in this case it is: 5425 options
*/

/* demographic composition
- assigning macrovariables to explore the composition of each demographic
- each one can be commented/uncommented to produce that
- if this were a regular task, I would have written a macro (function) to do each one
*/
*%let DemoGroup = CM_Tenure;
*%let DemoGroup = Main_Subject_Taught;
*%let DemoGroup = Main_Grade_Taught;
*%let DemoGroup = Region;
%let DemoGroup = Coach_Tenure;

proc freq data=CombinedSurvey;
	tables &DemoGroup;
run;

/* calculate basic for the questions
- same strategy as above where each question is assigned to a macrovariable
- this could be done dynamically if this were a regular task
- additional note: we could modify the number of variables if we wanted a smaller output
*/

proc means data=CombinedSurvey;
	class &DemoGroup;
	var How_would_you_describe_your_over
		I_feel_valued_as_a_person_by_Tea
		My_opinions_matter_at_Teach_For
		I_am_proud_to_be_a_part_of_Teach
		The_ongoing_support_tools_and_le
		My_coach_is_critical_in_my_abili
		How_many_hours_a_month_do_you_sp
		Offerings_on_TFANet_are_critical
		My_experiences_at_Institute_have
		I_would_recommend_Teach_for_Amer
		I_feel_safe_in_my_school;
run;

/* we could also use accumulators and data step code to do manual calculations */
data ForCalculations;
	/* this data set helps us use the First/Last variable
	(plus I assummed we would normally have survey code included) */
	set CombinedSurvey;
	Survey = "EYS";
run;

data ExtracurricLeader;
	set ForCalculations;
	by Survey; /* this lets us use the Last operator */
	/* check to make sure it isn't blank */
	if Do_you_lead_an_extracurricular_a ne " " then
		do;
			Count+1;
			if Do_you_lead_an_extracurricular_a = "Yes" then 
				do;
					Count_Yes+1;
				end;
			end;
	if Last.Survey;
		Percent_Leading_ECActivities = Count_Yes / Count;
		Keep Survey Count_Yes Count Percent_Leading_ECActivities;
run;

/* NOTE:
	all the above code was written to do basic exploration of the data,
	and could be modified to explore more specific hypotheses
*/

/* NOTE:
- there are other tools we could use to create a predictive tool,
	and one of the powerful procedures in SAS is PROC ANOVA.
- PROC ANOVA could help identify which groupings or questions have
	statistical significance, and then a model could be built using
	that additional information
- the analysis could be done question by question, or the analysis could
	be done dynamically by writing MACROs that can filter for instances
	where there is significance and make the work more efficient
*/