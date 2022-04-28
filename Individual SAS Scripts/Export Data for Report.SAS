/* this export is designed with human readable columns
so changing the validvarnames option to ANY */
options validvarname=any;


/* Import from the exported + merged file
- this is done so we do not have to re-run all the code over everytime
	and we can just import the single file
*/
proc import datafile="&AllDataFile"
	out=AllData
	dbms=xlsx
	replace;
run;

/* add a time field to the data (in this year, assigning
	the school year. Doing this so a region could technically
	update the report in future iterations by concatenating
	new data to the existing data

	+ renaming variables to be more readable
*/
data ReportingData;
	set AllData(rename=(
		CM_ID = 'CM ID#'n
		Constituent_ID = 'Constituent ID#'n
		CM_Tenure = 'Corps Year'n
		Main_Subject_Taught = 'Main Subject Taught'n
		Main_Grade_Taught = 'Main Grade Taught'n
		Region = 'Region'n
		Coach_Tenure = 'Coach Tenure'n
		How_would_you_describe_your_over = 'Overall Experience at TFA'n
		I_feel_valued_as_a_person_by_Tea = 'Valued by TFA Staff'n
		My_opinions_matter_at_Teach_For = 'My Opinion Matters'n
		I_am_proud_to_be_a_part_of_Teach = 'Proud to be TFA'n
		The_ongoing_support_tools_and_le = 'Ongoing Support...'n
		My_coach_is_critical_in_my_abili = 'My Coach is Critical'n
		How_many_hours_a_month_do_you_sp = 'How Many Hours/Month'n
		Offerings_on_TFANet_are_critical = 'Offerings on TFANet are Critical'n
		Do_you_lead_an_extracurricular_a = 'Do you lead an extracurricular?'n
		My_experiences_at_Institute_have = 'My exp. at Institute...'n
		I_would_recommend_Teach_for_Amer = 'I would recommend TFA'n
		I_feel_safe_in_my_school = 'I feel safe in my school'n
		ethnicity = 'Ethnicity'n
		economicbackground = 'Economic Background'n
		personofcolor = 'Person of Color'n
		teacher = 'Teacher'n
		schoolleader = 'School Leader'n
		schoolsystemsleader = 'School Systems Leader'n
		professioncategory = 'Profession Category'n
		involvement = 'Involvement'n
		gender = 'Gender'n
		nps = 'NPS'n
		cli1 = 'CLI1'n
		cli2 = 'CLI2'n
		cli3 = 'CLI3'n
		cli4 = 'CLI4'n
		cli5alum = 'CLI5alum'n
		cli5 = 'CLI5'n
		cli6 = 'CLI6'n
		cli7 = 'CLI7'n
		cli8 = 'CLI8'n
	));
	'School Year'n = '2013-2014';
run;

proc export data=ReportingData
	outfile="&ReportingDataFile"
	dbms=xlsx
	replace;
run;