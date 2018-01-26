options nodate nonumber;
title;
ods rtf file='C:\Stat 448\HW1.rtf' nogtitle startpage=no;
ods noproctitle;

/*### Data for all exercises ###*/

data fish; set sashelp.fish;
if species in ('Bream','Perch','Roach');
if weight=. then delete;
run;
data fish; set fish;
id=_N_;
run;

/* Exercise 1*/
title 'Exercise1';
proc univariate data=fish;
  var weight;
  ods select Moments Basicmeasures;
run;
proc sort data=fish;
  by Species;
run; 
proc univariate data=fish;
  var weight;
  by Species;
  ods select Moments Basicmeasures;
run;

/* Exercise 2*/
title 'Exercise2';
proc univariate data=fish normal;
  var weight;
  histogram weight /normal;
  probplot weight;
  ods select Histogram Probplot TestsForNormality;
run;
proc univariate data=fish normal;
  var weight;
  histogram weight /normal;
  probplot weight;
  by Species; 
  ods select Histogram ProbPlot TestsForNormality;
run;

/* Exercise 3*/
title 'Exercise3';
proc npar1way data=fish wilcoxon ;
  where Species^='Roach';
  class Species;
  var weight;
  ods exclude KruskalWallisTest;
run;

/* Exercise 4*/
title 'Exercise4';
proc sgscatter data=fish;
  where Species='Bream';
  matrix Weight Length1 Length2 Length3 Height Width;
run;

/* Exercise 5*/
title 'Exercise5';
proc corr data=fish pearson spearman;
  where Species='Bream';
  var Weight Length1 Length2 Length3 Height Width;
  ods select PearsonCorr SpearmanCorr;
run;

ods rtf close;