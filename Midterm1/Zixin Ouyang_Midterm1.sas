/* Midterm 1*/
/*Zixin Ouyang*/

/*Data for exercise 1-5*/
data blood; 
infile 'C:\Stat 448 spring 2017\midterm1\blood_pressure.csv' dlm=',' firstobs=2;
input USUBJID $7. AGE SEX $ RACE $ DSDECOD SAFEFL FASFL PPRFL $ COMPFL $ RANDDT BASEDT RTRT $ RTRTN FIRSTDOSE LASTDOSE SITE BASE VISITNUM SDAY SAMPDT CHG VALUE;
if visitnum=5;
if value<120 then responder=1; else responder=0;
keep usubjid age sex race rtrtn site base value responder;
run;
/*Exercise 1*/
*a;
proc univariate data=blood;
  var value; 
  ods select Moments Basicmeasures;
run;
proc univariate data=blood normal;  
	var value;
	histogram value/ normal;
	probplot value;
	ods select TestsForNormality Histogram ProbPlot;
run;
*b;
proc sort data=blood; 
  by RTRTN;
run;
proc univariate data=blood;
  by RTRTN;
  var value; 
  ods select Moments BasicMeasures;
run;
proc univariate data=blood normal;  
	var value;
	histogram value/ normal;
	probplot value;
	by RTRTN;
	ods select TestsForNormality Histogram ProbPlot;
run;
/*Exercise 2*/
proc ttest data=blood sides=u;
  where RTRTN in (1, 4);
  class RTRTN;
  var value;
  ods select ConfLimits TTests Equality;
run;
/*Exercise 3*/
proc freq data=blood;
  tables RTRTN*responder/ nopercent norow nocol chisq expected;
run;
proc freq data=blood;
	tables RTRTN*responder/expected chisq norow nocol nopercent riskdiff;
	where RTRTN in (1, 4);
run;
/*Exercise 4*/
proc glmselect data=blood;
  class SEX RACE RTRTN SITE;
  model VALUE=SEX RACE RTRTN SITE /selection=stepwise(select=SL SLE=0.05 SLS=0.05);
run;
proc glm data=blood;
  class SEX RTRTN SITE;
  model VALUE=SEX|RTRTN|SITE /ss1 ss3;
run;
proc glm data=blood plots=diagnostics;
	class SEX RTRTN SITE;
	model VALUE=SEX RTRTN SITE;
	output out=dataout r=resid; 
	lsmeans RTRTN /tdiff=all pdiff cl;
run;
proc univariate data=dataout normal;
  var resid; 
  ods select TestsForNormality; 
run;
/*Exercise 5*/
proc glmselect data=blood;
  class SEX RACE RTRTN SITE;
  model VALUE=SEX RACE RTRTN SITE BASE /selection=stepwise(select=SL SLE=0.05 SLS=0.05); 
run;
proc glm data=blood plots=diagnostics;
	class SEX RTRTN SITE;
	model VALUE=SEX RTRTN SITE BASE/ss1 ss3;
	output out=dataout1 cookd=cd r=resid;
run;
proc print data=dataout1;
	where cd > 1;
run;
proc univariate data=dataout1 normal;
  var resid; 
  ods select TestsForNormality; 
run;

/*Data for exercise 6*/
data housing;
	infile 'C:\Stat 448 spring 2017\midterm1\housing.txt' dlm=' ';
	input crim zn indus chas nox rm age dis rad tax ptratio bb lstat medv;
run;
/*Exercise 6*/
proc reg data=housing;
	model medv=crim--indus nox--dis tax--lstat/selection=stepwise sle=.05 sls=.05;
	ods select SelectionSummary;
run;
proc reg data=housing;
	model medv=crim zn nox rm dis ptratio bb lstat/vif;
	ods select ANOVA FitStatistics ParameterEstimates DiagnosticsPanel;
run;
proc reg data=housing;
	model medv=crim zn nox rm dis ptratio bb lstat;
	output out=diagnostics cookd= cd;
run;
proc print data=diagnostics;
	where cd > 1;
run;
proc reg data=housing;
	model medv=crim zn nox rm dis ptratio bb lstat;
    output out=dataout2 r=resid;
	ods select ANOVA FitStatistics ParameterEstimates DiagnosticsPanel;
run;
proc univariate data=dataout2 normal;
  var resid; 
  ods select TestsForNormality; 
run;

















