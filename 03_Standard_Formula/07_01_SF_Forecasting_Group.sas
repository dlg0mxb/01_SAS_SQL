/* RUN FROM Forecasting Engine */
PROC SQL ;

/*Create Temp table to load the extracted Data*/

OPTIONS MISSING='';

CREATE TABLE WORK.SF_FORECAST_GRP AS 

	SELECT

		FC.CIC_3_4_DIGIT AS CIC_CODES
		, TRIM(TRIM(CIC_CAT.X_CIC_CATEGORY_NM)||' - '||TRIM(CIC_CAT.X_CIC_SUB_CATEGORY_NM)) AS CIC_DESC

		, SUM(CASE WHEN DATA_SOURCE <>  '03 - Lookthrough'  AND NON_ZERO_RATED_COV = 1 AND INFRA_CORP = -1  THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS NON_ZERO_COV_BNDS
		, SUM(CASE WHEN DATA_SOURCE =  '03 - Lookthrough'  AND NON_ZERO_RATED_COV = 1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS LKTHRU_NON_ZERO_COV_BNDS

		, SUM(CASE WHEN DATA_SOURCE <>  '03 - Lookthrough' AND NON_ZERO_RATED_NOT_COV = 1 AND CIC_11_15_NON_EU_CUR_MTCH <> 1 AND INFRA_CORP = -1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS NON_ZERO_NOT_COV_BNDS
		, SUM(CASE WHEN DATA_SOURCE = '03 - Lookthrough' AND NON_ZERO_RATED_NOT_COV = 1 AND CIC_11_15_NON_EU_CUR_MTCH <> 1 AND SUBSTR(CIC,1,1) NOT IN ('5','6') AND INFRA_CORP = -1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS LKTHRU_NON_ZERO_NOT_COV_BNDS

		, SUM(CASE WHEN DATA_SOURCE <>  '03 - Lookthrough'  AND CIC_11_15_NON_EU_CUR_MTCH = 1 AND INFRA_CORP = -1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS CIC_11_15_NON_EU_CUR_MTCHS
		, SUM(CASE WHEN DATA_SOURCE =  '03 - Lookthrough'  AND CIC_11_15_NON_EU_CUR_MTCH = 1 AND INFRA_CORP = -1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS CIC_11_15_NON_EU_CUR_MTCHS_LKTH

		, SUM(CASE WHEN SUBSTR(CIC,3,1) IN ('5','6') AND  TRIM(UPCASE(X_SECURITISED_CREDIT_TYPE)) IN ('TYPE 1','TIER 1','TIERA') /* SEC_CREDIT_TYP1 = 1 */ AND  DATA_SOURCE <>  '03 - Lookthrough'  THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS SECURITISATIONS_TYPE1
		, SUM(CASE WHEN SUBSTR(CIC,3,1) IN ('5','6') AND  TRIM(UPCASE(X_SECURITISED_CREDIT_TYPE)) IN ('TYPE 2' ,'')  AND  DATA_SOURCE <>  '03 - Lookthrough' THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS SECURITISATIONS_TYPE2

		, SUM(CASE WHEN SUBSTR(CIC,3, 1) IN ('5','6') AND  TRIM(UPCASE(X_SECURITISED_CREDIT_TYPE)) IN ('TYPE 1','TIER 1','TIERA') AND  DATA_SOURCE =  '03 - Lookthrough'  THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS LKTHRGH_SECURITISATIONS_TYPE1
		, SUM(CASE WHEN SUBSTR(CIC,3,1) IN ('5','6') AND   TRIM(UPCASE(X_SECURITISED_CREDIT_TYPE)) IN ('TYPE 2' ,'')  AND  DATA_SOURCE =  '03 - Lookthrough'  THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS LKTHRGH_SECURITISATIONS_TYPE2

		, SUM(CASE WHEN DATA_SOURCE <>  '03 - Lookthrough' AND ZERO_RATED = 1 AND INFRA_CORP = -1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS ZERO_RATES_BNDS
		, SUM(CASE WHEN DATA_SOURCE =  '03 - Lookthrough' AND ZERO_RATED = 1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS LKTHRU_ZERO_RATES_BNDS

		, SUM(CASE WHEN INVESTMENT_PROP = 1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS INVESTMENT_PROP
		, SUM(CASE WHEN OWNER_OCC_PROP = 1 AND SUBSTR(CIC,3,2) <> '95' THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS OWNER_PROP

		, SUM(CASE WHEN DATA_SOURCE <>  '03 - Lookthrough' AND CASH = 1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS CASH
		, SUM(CASE WHEN DATA_SOURCE = '03 - Lookthrough' AND CASH=1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS LKTHRU_CASH

		, SUM(CASE WHEN INFRASTRUCTURE_INV_CD_TYPE = 'TYPE 1' THEN  (MKT_VALUE_DIV_1000) ELSE 0 END) AS INFRA_1
		, SUM(CASE WHEN INFRASTRUCTURE_INV_CD_TYPE = 'TYPE 2' THEN  (MKT_VALUE_DIV_1000) ELSE 0 END) AS INFRA_2

		, SUM(CASE WHEN  DATA_SOURCE <>  '03 - Lookthrough'  AND INFRA_CORP = 1 THEN  (MKT_VALUE_DIV_1000) ELSE 0 END) AS INFRA_CORP_QUAL
		, SUM(CASE WHEN DATA_SOURCE <>  '03 - Lookthrough'  AND INFRA_CORP = 0 THEN  (MKT_VALUE_DIV_1000) ELSE 0 END) AS INFRA_CORP_NQUAL

		, SUM(CASE WHEN  DATA_SOURCE =  '03 - Lookthrough' AND  INFRA_CORP = 1 THEN  (MKT_VALUE_DIV_1000) ELSE 0 END) AS INFRA_CORP_QUAL_LKTHR
		, SUM(CASE WHEN DATA_SOURCE =  '03 - Lookthrough' AND INFRA_CORP = 0 THEN  (MKT_VALUE_DIV_1000) ELSE 0 END) AS INFRA_CORP_NQUAL_LKTHR

		, SUM(CASE WHEN DATA_SOURCE <>  '03 - Lookthrough'  AND OTHER = 1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS OTHER
		, SUM(CASE WHEN DATA_SOURCE =  '03 - Lookthrough'  AND OTHER = 1 THEN (MKT_VALUE_DIV_1000) ELSE 0 END) AS LKTHRU_OTHER

		, SUM(
				CASE 
					WHEN  DATA_SOURCE IN ('01 - Blackrock - Without Lookthrough','02 - Non Blackrock - Without Lookthrough') AND SUBSTR(CIC,3,1)='4' THEN 0
					WHEN CUSIP LIKE 'INTERCO%' THEN 0
					WHEN CUSIP LIKE 'OLU%' OR FIN_INV_CLS = 'Plant and Equipment - Own Use' THEN 0
					WHEN I_T_CLS_GRP <> 'Exclude' AND CUSIP LIKE '%_PART%' THEN 0 
					WHEN I_T_CLS_GRP <> 'Exclude' AND CUSIP NOT LIKE '%_PART%' THEN MKT_VALUE_DIV_1000 
					ELSE 0 END 
			) AS TOTAL

	FROM 
		WORK.SF_FORECAST_ENGINE FC

		LEFT JOIN /*get Category subname and names*/
			(
				 SELECT	
					DISTINCT 
						X_CIC_CATEGORY_CD ,
						X_CIC_CATEGORY_NM , 
						X_CIC_CD_LAST_2_CHAR,
						X_CIC_SUB_CATEGORY_NM
				 FROM	
					test.X_CIC_CATEGORY
			) CIC_CAT

			ON 
				CIC_CAT.X_CIC_CD_LAST_2_CHAR = FC.CIC_3_4_DIGIT

	WHERE 
		PORTF_NAME NOT IN ('DLG Legal Services Limited')

GROUP BY 
CIC_CODES
, CIC_DESC	


ORDER BY 
CIC_CODES

	;
QUIT;

DATA SF_FORECAST_GRP_FIN;
SET SF_FORECAST_GRP	;

DIFF = 
		 TOTAL - (	 OTHER +  LKTHRU_OTHER 
										+  INFRA_CORP_QUAL_LKTHR +  INFRA_CORP_NQUAL_LKTHR 
										+  INFRA_CORP_QUAL +  INFRA_CORP_NQUAL
										+  INFRA_1 +  INFRA_2
										+  CASH +  LKTHRU_CASH
										+  INVESTMENT_PROP +  OWNER_PROP
										+  ZERO_RATES_BNDS +  LKTHRU_ZERO_RATES_BNDS
										+  LKTHRGH_SECURITISATIONS_TYPE1 +  LKTHRGH_SECURITISATIONS_TYPE2
										+  SECURITISATIONS_TYPE1 +  SECURITISATIONS_TYPE2
										+  CIC_11_15_NON_EU_CUR_MTCHS +  CIC_11_15_NON_EU_CUR_MTCHS_LKTH
										+  NON_ZERO_NOT_COV_BNDS +  LKTHRU_NON_ZERO_NOT_COV_BNDS
										+  NON_ZERO_COV_BNDS +  LKTHRU_NON_ZERO_COV_BNDS
									);
FORMAT DIFF 21.2;
RUN;


PROC DATASETS LIBRARY=WORK NOLIST;
DELETE SF_FORECAST_GRP;
QUIT;

