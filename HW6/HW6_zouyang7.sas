data sids;
infile 'C:\Stat 448 spring 2017\homework\HW6\sids.dat' expandtabs;
input group hr bw factor68 age;
run;
data sids; set sids;
id=_N_;
run;

/*Exercise 1*/
proc discrim data=sids pool=test crossvalidate manova;
  	class group;
  	var hr bw factor68 age;
  	priors proportional;
run;

/*Exercise 2*/
proc stepdisc data=sids sle=.05 sls=.05;
   	class group;
   	var hr bw factor68 age;
   	ods select summary;
run;
proc discrim data=sids pool=test crossvalidate manova;
  	class group;
  	var bw factor68;
  	priors proportional;
run;

/*data for exercise 3*/
proc surveyselect data=sids
		method=srs sampsize=20
		rep=1 seed=123 out=test; 
run;
proc sort data=test; 
	by id; 
run;
proc sort data=sids; 
	by id; 
run;
data traindata; 
	merge sids(in=l) test(in=ll); by id;
	if ll=1 then delete; 
run;
proc discrim data=traindata method=normal pool=no testdata=test testout=tout;
   class group;
   priors proportional;
   var bw factor68;
run;