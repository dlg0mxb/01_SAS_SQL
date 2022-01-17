
/*Summarise before Pivot*/
PROC SUMMARY DATA=WORK.S0602_D1_IMT NOPRINT;
VAR C0170 ;
CLASS  INT2 FIN_SOLII_CLS SOURCE_SYSTEM_CD;
OUTPUT OUT=WORK.S0602_D1_IMT_SUM SUM=;
RUN;

/*SORT BEFORE THE PIVOT*/
PROC SORT DATA=WORK.S0602_D1_IMT_SUM (WHERE=(_TYPE_=1 OR _TYPE_=7 ) );

BY  _TYPE_ INT2 FIN_SOLII_CLS  _FREQ_ SOURCE_SYSTEM_CD  ;


RUN;


/*PROCEDURE TO PIVOT*/
PROC TRANSPOSE DATA=WORK.S0602_D1_IMT_SUM OUT=WORK.S0602_D1_IMT_PIVOT_CNT(DROP=_TYPE_ _NAME_ _LABEL_ RENAME=(_FREQ_=COUNT) )   ;

/*Y - AXIS*/
BY INT2 FIN_SOLII_CLS  ;

/*PIVOT MONETARY COLUMN*/
VAR _FREQ_ ;
**FORMAT C0170 COMMA21.2;

/*X - AXIS PIVOTAL COLUMN*/
ID SOURCE_SYSTEM_CD;

/* Remove the '.' to ''*/
OPTIONS MISSING='';

RUN;


/*PROCEDURE TO PIVOT*/
PROC TRANSPOSE DATA=WORK.S0602_D1_IMT_SUM OUT=WORK.S0602_D1_IMT_PIVOT_AMT(DROP=_TYPE_ _LABEL_ _NAME_ RENAME=(_FREQ_=COUNT ) )   ;

/*Y - AXIS*/
BY INT2 FIN_SOLII_CLS ;


/*PIVOT MONETARY COLUMN*/
VAR C0170 ;
**FORMAT C0170 COMMA21.2;

/*X - AXIS PIVOTAL COLUMN*/
ID SOURCE_SYSTEM_CD ;

/* Remove the '.' to ''*/
OPTIONS MISSING='';

RUN;


DATA S0602_D1_IMT_PIVOT_AMT;
SET S0602_D1_IMT_PIVOT_AMT;
RENAME BLR=BLR_AMT NONBLR=NONBLR_AMT;
RUN;

DATA S0602_D1_IMT_PIVOT_CNT;
SET S0602_D1_IMT_PIVOT_CNT;
RENAME BLR=BLR_CNT NONBLR=NONBLR_CNT;
RUN;

/*
PROC SQL;
CREATE TABLE S0602_D1_IMT_PIVOT_FIN AS 

SELECT * 
FROM 
S0602_D1_IMT_PIVOT_AMT A,
S0602_D1_IMT_PIVOT_CNT B
WHERE A.INT2 = B.INT2
AND A.FIN_SOLII_CLS = B.FIN_SOLII_CLS;
QUIT;
*/

PROC SORT DATA=S0602_D1_IMT_PIVOT_AMT;
BY INT2 ;
RUN;

PROC SORT DATA=S0602_D1_IMT_PIVOT_CNT;
BY INT2 ;
RUN;

DATA S0602_D1_IMT_PIVOT_FIN;
 MERGE S0602_D1_IMT_PIVOT_CNT(IN=A)  S0602_D1_IMT_PIVOT_AMT(IN=B) ; 
 BY INT2  ;
/* IF A=1 & B=1;*/
 FORMAT NONBLR_AMT BLR_AMT COMMA21.2;
RUN;


TITLE BOLD UNDERLIN=2 "D1 - IM&T Version Pivot Table";
PROC PRINT DATA=S0602_D1_IMT_PIVOT_FIN;
RUN;