
/*Summarise before Pivot*/
PROC SUMMARY DATA=WORK.S0801_D2o_IMT_NEWRULES_CONSLDTD NOPRINT;
VAR C0240FIN ;
CLASS  INT10 INT17;
OUTPUT OUT=WORK.S0801_D2o_IMT_NEWRULES_C_SUM SUM=;
RUN;

/*SORT BEFORE THE PIVOT*/
PROC SORT DATA=WORK.S0801_D2o_IMT_NEWRULES_C_SUM (WHERE=(_TYPE_=1 OR _TYPE_=3 ));
BY INT10;
RUN;


/*PROCEDURE TO PIVOT*/
PROC TRANSPOSE DATA=WORK.S0801_D2o_IMT_NEWRULES_C_SUM OUT=WORK.S0801_D2o_IMT_NEWRULES_C_PIVOT(DROP=_LABEL_ _NAME_ RENAME=(INT10=DERIV_CATEGORY _FREQ_=COUNT) )   ;

/*Y - AXIS*/
BY INT10 _FREQ_;


/*PIVOT MONETARY COLUMN*/
VAR  C0240FIN;
FORMAT C0240FIN COMMA21.2;

/*X - AXIS PIVOTAL COLUMN*/
ID INT17;

/* Remove the '.' to ''*/
OPTIONS MISSING='';

RUN;