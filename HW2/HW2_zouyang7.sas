options nodate nonumber;
title;
ods rtf file='C:\Stat 448\HW2.rtf' nogtitle startpage=no;
ods noproctitle;

/* Exercise 1*/
title1 'Exercise1';
data peanut;
 input treat $13. allergy $1. count;
cards;
control      N 87
control      Y 43
intervention N 109
intervention Y 8
; run;
proc freq data=peanut;
  tables treat*allergy/ nopercent nocol expected chisq riskdiff;
  weight count;
run;

/* Exercise 2*/
title1 'Exercise2';
data fish; set sashelp.fish;
format weight_cat $30.;
if species in ('Bream','Perch','Roach');
if weight=. then delete;
if weight<=135 then weight_cat='1-Light';
else if 135<weight<=500 then weight_cat='2-Medium';
else if weight>500 then weight_cat='3-Heavy';
run;
proc freq data=fish;
  tables species*weight_cat/ nopercent norow nocol expected chisq;
run;
proc freq data=fish;
  tables species*weight_cat/ nopercent nocol riskdiff;
  where species in ('Bream','Perch') and weight_cat in ('1-Light','3-Heavy');
run;
/* Exercise 3*/
title1 'Exercise3';
data fish;
	set fish;
	lweight=log(weight);
run;
proc tabulate data=fish;
  class species;
  var lweight;
  table species,
        lweight*(mean std n);
run;
proc anova data=fish;
  class species;
  model lweight=species;
  means species /hovtest tukey cldiff welch;
  ods select HOVFTest Welch OverallANOVA FitStatistics ModelANOVA CLDiffs;
run;

ods rtf close;


