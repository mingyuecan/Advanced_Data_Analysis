/*HW3*/
/*Zixin Ouyang*/

data auto;
infile 'C:\Stat 448 spring 2017\homework\HW3\automobile.txt' dlm=',';
length make $ 15 fueltype $ 15 style $ 15;
input make $ fueltype $ ndoors $ style $ engine $ length width height weight ncylinders $ enginesize horsepower citympg highwaympg price;
format weight_cat $30. price_cat $30.;
if make in ('alfa','audi','bmw','jaguar','mercedes','porsche') then type=1; else type=0;
if (price=. or horsepower=. or ndoors=' ') then delete; 
if weight<=2500 then weight_cat='Light'; else if weight>2500 then weight_cat='Heavy';
keep highwaympg citympg type ndoors weight height horsepower enginesize price weight_cat;
run;
/*Exercise 1*/
/*1a*/
proc tabulate data=auto;
  class weight_cat type ndoors;
  var highwaympg;
  table weight_cat*type*ndoors, 
        highwaympg*(mean std n);
run;
/*1b*/
proc glm data=auto;
  class weight_cat type ndoors;
  model highwaympg = weight_cat type ndoors/ss3;
  ods select OverallANOVA FitStatistics ModelANOVA;
run;
proc glm data=auto;
  class weight_cat type;
  model highwaympg = weight_cat type /ss3;
  ods select OverallANOVA FitStatistics ModelANOVA;
run;
/*1c*/
proc glmselect data=auto;
 	class weight_cat type ndoors;
	model highwaympg = weight_cat type ndoors/selection=stepwise(select=SL SLE=0.05 SLS=0.05);
run;
proc glmselect data=auto;
 	class weight_cat type;
	model highwaympg = weight_cat type weight_cat*type/selection=stepwise(select=SL SLE=0.05 SLS=0.05);
run;
/*1d*/
proc glm data=auto plots=diagnostics;
	class weight_cat type;
	model highwaympg = weight_cat|type;
	lsmeans weight_cat|type/pdiff=all cl;
	output out=dataout1 r=resid;
	ods select OverallANOVA ModelANOVA LSMeans LSMeanDiffCL diff DiagnosticsPanel;
run;
proc univariate data=dataout1 normal;
  var resid;
  ods select TestsForNormality;
run;
/*Exercise 2*/
/*2a*/
proc sort data=auto;
  by weight_cat type ndoors;
run;
proc glm data=auto plots=diagnostics;
	class weight_cat type ndoors;
	model highwaympg = weight_cat type ndoors horsepower/solution;
run;
/*2b*/
proc glmselect data=auto;
	class weight_cat type ndoors;
	model highwaympg = weight_cat type ndoors horsepower/selection=stepwise(select=SL SLE=0.05 SLS=0.05);
run;
/*2c*/
proc glm data=auto plots=diagnostics;
	class weight_cat ndoors;
	model highwaympg = weight_cat ndoors horsepower/solution;
	lsmeans weight_cat ndoors/pdiff stderr cl;
	output out=dataout2 r=resid;
run;
proc univariate data=dataout2 normal;
  var resid;
  ods select TestsForNormality;
run;
/* Exercise 3*/
/*3a*/;
proc reg data=auto;
	model citympg=weight height horsepower enginesize price;
run;
/*3b*/
proc reg data=auto;
	model citympg=weight height horsepower enginesize price/ selection=stepwise sle=.05 sls=.05;
	ods select SelectionSummary;
run;
/*3c*/
proc reg data=auto;
	model citympg=weight horsepower enginesize / vif;
run;
/*3d*/
proc reg data=auto noprint;
	model citympg=weight horsepower enginesize;
	output out=diagnostics cookd= cd;
run;
proc print data=diagnostics;
	where cd > 1;
run;
proc reg data=auto;
	model citympg=weight horsepower enginesize;
	output out=dataout3 r=resid;
	ods select ANOVA FitStatistics ParameterEstimates DiagnosticsPanel;
run;
proc univariate data=dataout3 normal;
  var resid;
  ods select TestsForNormality;
run;
/* Exercise 4*/
proc glm data=auto plots=ancovaplot;
	class weight_cat ndoors;
	model highwaympg = weight_cat ndoors horsepower weight_cat*horsepower 
	      ndoors*horsepower weight_cat*ndoors*horsepower/solution;
run;
proc glm data=auto plots=ancovaplot;
	class weight_cat ndoors;
	model highwaympg = weight_cat ndoors horsepower 
	      weight_cat*horsepower ndoors*horsepower /solution;
run;
proc glm data=auto plots=ancovaplot;
	class weight_cat ndoors;
	model highwaympg = weight_cat ndoors horsepower 
	      weight_cat*horsepower /solution;
    output out=dataout4 r=resid;
run;
proc univariate data=dataout4 normal;
  var resid;
  ods select TestsForNormality;
run;


