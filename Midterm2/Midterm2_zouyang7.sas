/*Midterm 2*/

/*data for exercises 1-4*/
data cancer;
	infile 'C:\Stat 448 spring 2017\midterm2\biomarkers.csv' dlm=',' firstobs=2;
	input P8 P14 P19 P33 P37 P49 P55 P64 P70 P80 grp;
	run;
data cancer; 
	set cancer;
	id=_N_;
run;

/*Exercise 1*/
*a;
proc princomp data=cancer out=pcout;
	var P8--P80;
	id grp;
	ods select Eigenvalues Eigenvectors ScreePlot;
run;
*c;
proc sort data=pcout;
	by grp;
run;
proc sgplot data=pcout;
  scatter y=prin1 x=prin2;
  by grp;
run;

/*Exercise 2*/
*a;
proc logistic data=cancer desc;
  model grp=P8--P80/selection=stepwise;
  ods select ModelBuildingSummary;
run;
*b,c;
proc logistic data=cancer desc;
model grp=P19 P55 P70/lackfit influence;
ods select GlobalTests ParameterEstimates OddsRatios LackFitChiSq InfluencePlots;
run;
*d;
proc logistic data=cancer desc;
	model grp=P19 P55 P70;
    output predicted=pred out=cancer_out1;
run;
proc print data=cancer_out1(obs=10); 
run;
proc logistic data=cancer desc;
model grp=P19 P55 P70;
output predprobs=individual out=cancer_out2;
run;
proc freq data=cancer_out2;
    tables grp*_into_/nopercent norow nocol;
run;

/*Exercise 3*/
*a;
proc discrim data=cancer pool=test crossvalidate manova noclassify;
   class grp;
   var P8--P80;
   priors proportional;
run;
*b;
proc stepdisc data=cancer sle=.05 sls=.05;
   class grp;
   var P8--P80;
   ods select summary;
run;
proc discrim data=cancer pool=test crossvalidate manova noclassify;
   class grp;
   var P19 P70 P37 P55;
   priors proportional;
run;
*c;
proc surveyselect data=cancer
		method=srs sampsize=50
		rep=1 seed=123456789 out=test; 
run;
proc sort data=test; 
	by id; 
run;
proc sort data=cancer; 
	by id; 
run;
data traindata; 
	merge cancer(in=l) test(in=ll); by id;
	if ll=1 then delete; 
run;
proc discrim data=traindata pool=no testdata=test testout=tout noclassify;
   class grp;
   var P19 p70 p37 p55;
   testid id; 
   priors proportional;
run;
/*data for exercise 5*/
data housing;
	infile 'C:\Stat 448 spring 2017\midterm2\housing.txt' dlm=' ';
	input crim zn indus chas nox rm age dis rad tax ptratio b lstat medv;
run;

/*Exercise 5*/
proc genmod data=housing;
	model medv=crim--lstat/ dist=gamma link=log type3;
run;
* remove age, refit the model;
proc genmod data=housing;
	model medv=crim--rm dis--lstat/ dist=gamma link=log type3;
run;
*remove indus, refit the model, now all predictors are significant;
proc genmod data=housing;
	model medv=crim zn chas--rm dis--lstat/ dist=gamma link=log type3;
	output out = gammares pred = pmpg stdreschi = schires stdresdev= sdevres;
run;
proc sgplot data=gammares;
	scatter y=schires x=pmpg;
run;
proc sgplot data=gammares;
	scatter y=sdevres x=pmpg;
run;

/*data for exercise 6*/
data epi;
	infile 'C:\Stat 448 spring 2017\midterm2\epi.dat' dlm=' ';
	input ID Period1 Period2 Period3 Period4 Treat BL Age;
run;
proc genmod data=epi;
  model Period4=Treat BL Age/ dist=poisson 
		link=log type1 type3;
  ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;
run;
* overdispersed Poisson log-linear model;
proc genmod data=epi;
  model Period4=Treat BL Age / dist=poisson 
		link=log type1 type3 scale=deviance;
  output out = poisres pred = presp_n stdreschi = presids stdresdev=dresids;
  ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;
run;
proc sgplot data=poisres;
	scatter y=presids x=presp_n;
run;
proc sgplot data=poisres;
	scatter y=dresids x=presp_n;
run;


