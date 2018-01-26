data blood;
	infile '~/myfiles/448_Homework/HW4/blood_pressure.csv' dlm=',' firstobs=2;
	input USUBJID $7. AGE SEX $ RACE $ DSDECOD SAFEFL FASFL 
		PPRFL $ COMPFL $ RANDDT BASEDT RTRT $ RTRTN FIRSTDOSE LASTDOSE SITE BASE 
		VISITNUM SDAY SAMPDT CHG VALUE;
    if visitnum=5;
	keep usubjid age sex race rtrtn site base chg value;
run;

/*Exercise 1*/
*a;
data blood;
	set blood;
	if value<=120 then remission=1;
	else remission=0;
run;
proc logistic data=blood desc;
	class sex race rtrtn site/param=glm descending;
	model remission=age--base;
	ods select ParameterEstimates GlobalTests ModelANOVA;
run;
*b;
proc logistic data=blood desc;
	class sex race rtrtn site/param=glm descending;
	model remission=age--base/selection=stepwise;
	ods select ModelBuildingSummary;
run;
*c d e;
proc logistic data=blood desc;
	class sex rtrtn site/param=glm descending;
	model remission=sex rtrtn site base/lackfit influence;
	ods select OddsRatios ParameterEstimates LackFitChiSq InfluencePlots;
	output predprobs=individual out=blood_out;
run;
proc freq data=blood_out;
	tables remission*_into_/nopercent norow nocol;
run;

/*Exercise 2*/
*a;
data blood;
	set blood;
	if chg<=-40 then responder=1;
	else responder=0;
run;
proc logistic data=blood desc;
	class sex race rtrtn site/param=glm descending;
	model responder=age--base;
	ods select ParameterEstimates GlobalTests ModelANOVA;
run;
*b;
proc logistic data=blood desc;
	class sex race rtrtn site/param=glm descending;
	model responder=age--base/selection=stepwise;
	ods select ModelBuildingSummary;
run;
*c d e;
proc logistic data=blood desc;
	class sex rtrtn site/param=glm descending;
	model responder=sex rtrtn site base/lackfit influence;
	ods select OddsRatios ParameterEstimates LackFitChiSq InfluencePlots;
	output predprobs=individual out=blood_out2;
run;
proc freq data=blood_out2;
	tables responder*_into_/nopercent norow nocol;
run;