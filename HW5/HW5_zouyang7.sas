/*data for all exercises*/
data auto;
infile 'C:\Stat 448 spring 2017\homework\HW5\automobile.txt' dlm=',';
length make $ 15 fueltype $ 15 style $ 15;
input make $ fueltype $ ndoors $ style $ engine $ length width height weight ncylinders $ enginesize horsepower citympg highwaympg price;
format weight_cat $30. price_cat $30.;
if make in ('alfa','audi','bmw','jaguar','mercedes','porsche') then type=1; else type=0;
if (price=. or horsepower=. or ndoors=' ') then delete; 
keep highwaympg citympg type ndoors weight height horsepower enginesize price;
run;

/*Exercise 1*/
*a;
proc genmod data=auto;
	class ndoors;
	model highwaympg=weight height horsepower enginesize price ndoors / dist=gamma 
		link=log type1 type3;	
	ods select ModelInfo ModelFit ParameterEstimates Type1 Type3;	
run;
*b/c;
proc genmod data=auto;
	class ndoors;
	model highwaympg=weight height horsepower enginesize ndoors / dist=gamma 
		link=log type3;	
	ods select ModelInfo ModelFit ParameterEstimates Type3;	
run;
proc genmod data=auto;
	class ndoors;
	model highwaympg=weight horsepower enginesize ndoors / dist=gamma 
		link=log type3;	
	ods select ModelInfo ModelFit ParameterEstimates Type3;	
run;
proc genmod data=auto;
	model highwaympg=weight horsepower enginesize / dist=gamma 
		link=log type3;	
	output out=gammares pred=presp_n stdreschi=presids
		stdresdev= dresids;
	ods select ModelInfo ModelFit ParameterEstimates Type3;	
run;
proc sgplot data=gammares;
	scatter y= presids x=presp_n;
	scatter y= dresids x=presp_n;
	where presp_n<100;
run;
/*Exercise 2*/
*a;
proc princomp data=auto out=pcout;
	var highwaympg citympg weight height horsepower enginesize price;;
run;
*c;
proc sgplot data=pcout;
  scatter y=prin1 x=prin2 / markerchar=type;
run;

/*Exercise 3*/
proc princomp data=auto cov out=pcout1;
	var highwaympg citympg weight height horsepower enginesize price;;
run;
proc sgplot data=pcout1;
  vbox prin1 / category=type;
run;





















