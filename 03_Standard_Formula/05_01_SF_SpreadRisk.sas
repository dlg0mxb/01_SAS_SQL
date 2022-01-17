
PROC SQL ;

/*Create Temp table to load the extracted Data*/

OPTIONS MISSING='';

CREATE TABLE WORK.SF_SPREAD_RSK AS 

	SELECT
		DATA_SOURCE
		, PORTF_LIST
		, PORTF_NAME
		, CUSIP AS UNIQUE_IDENTIFIER
		, ISSUER_NAME
		, BOND_TYPE
		, CASE 
			 WHEN SPRD_RSK_STRUC = 1 
				THEN 
					CASE 
						WHEN X_SECURITISED_CREDIT_TYPE in ( 'TYPE 1' , 'Tier 1') AND CALCULATED CREDIT_RATING = 'NR' 
							THEN 'TYPE 2' 
						ELSE 
							UPPER ( CASE WHEN X_SECURITISED_CREDIT_TYPE = 'Tier 1' THEN 'TYPE 1' ELSE X_SECURITISED_CREDIT_TYPE END ) 
					END 
			 ELSE 'No' 
		   END AS SECURITIZATION_TYPE

		, CASE
			WHEN DATA_SOURCE = '03 - Lookthrough' 
				THEN 
					CASE 
						WHEN SUBSTR(CIC,3,1) IN ('5','6') AND (MDY_SCORE = .  AND SP_SCORE  = . AND FIT_SCORE <> .) THEN 'NR'
						WHEN SUBSTR(CIC,3,1) IN ('5','6') AND (MDY_SCORE = .  AND FIT_SCORE = . AND SP_SCORE  <> .) THEN 'NR'
						WHEN SUBSTR(CIC,3,1) IN ('5','6') AND (SP_SCORE  = .  AND FIT_SCORE = . AND MDY_SCORE <> .) THEN 'NR'		 
						ELSE COALESCE (AVE_RATING,'NR')
					END
		 		ELSE 
					CASE 
						WHEN LEHM_RATING_TXT IS NULL OR LEHM_RATING_TXT = '' 
							THEN 
								CASE 
									WHEN PORTF_LIST IN ('A_320QUKIM','A_320UKJPM','A_320VUKRL') 
										THEN 'NR' 
									ELSE 
										CASE 
											WHEN SUBSTR(CIC,3,1) IN ('5','6') AND (MDY_SCORE = .  AND SP_SCORE  = . AND FIT_SCORE <> .) THEN 'NR'
											WHEN SUBSTR(CIC,3,1) IN ('5','6') AND (MDY_SCORE = .  AND FIT_SCORE = . AND SP_SCORE  <> .) THEN 'NR'
											WHEN SUBSTR(CIC,3,1) IN ('5','6') AND (SP_SCORE  = .  AND FIT_SCORE = . AND MDY_SCORE <> .) THEN 'NR'		 
											ELSE SNP_EQUI_RATING  
										END 
								END 
						ELSE 
							CASE 
								WHEN PORTF_LIST IN ('A_320QUKIM','A_320UKJPM','A_320VUKRL') 
									THEN 'NR' 
								ELSE 
									CASE 
										WHEN SUBSTR(CIC,3,1) = '6' AND (MDY_SCORE = .  AND SP_SCORE  = . AND FIT_SCORE <> .) THEN 'NR'
										WHEN SUBSTR(CIC,3,1) = '6' AND (MDY_SCORE = .  AND FIT_SCORE = . AND SP_SCORE  <> .) THEN 'NR'
										WHEN SUBSTR(CIC,3,1) = '6' AND (SP_SCORE  = .  AND FIT_SCORE = . AND MDY_SCORE <> .) THEN 'NR'		
										ELSE LEHM_RATING_TXT
									END
							END 
					END 
		  END AS CREDIT_RATING

		, SPREAD_DUR

		, MOD_DUR

		, MOD_DUR_S2

		, MKT_VALUE_DIV_1000

		, MKT_VALUE

		, SPRD_RSK_BND

		, SPRD_RSK_STRUC

		, SPRD_RSK

		, SM_SEC_GROUP

		, TRIM(SM_SEC_TYPE) AS SM_SEC_TYPE 

		, COUNTRY

		, CURRENCY

		, SHORT_STD_DESC

		, BARCLAYS_FOUR_PILLAR_SECTOR
		, BARCLAYS_FOUR_PILLAR_SUBSECTOR
		, BARCLAYS_FOUR_PILLAR_INDUSTRY
		, BARCLAYS_FOUR_PILLAR_SUBINDUSTRY

		, IS_BND
		, IS_GOVT
		, IS_EEA
		, IS_EEA_GOVT
		, IS_GUARN_EEA_GOVT
		, IS_SUPRA_BNDS
		, SENSE_CHECK_BNDS AS SENSE_CHECK
		, EXEMPT_SPREAD_RISK
		, IS_COV_BOND
		, NON_EEA_GOVT

		, CIC
		, SUBSTR(CIC,3,2) AS CIC_3_4
		, ISIN
		, ZV_MATURITY_DATE

		, CASE
			WHEN  INFRASTRUCTURE_INV_CD_TYPE = '' OR INFRASTRUCTURE_INV_CD_TYPE IS NULL OR  INFRASTRUCTURE_INV_CD_TYPE = '1' THEN 
				CASE 
					WHEN INFRA_CORP = 0 THEN 'Corporate Infrastructure - Non Qualify'
					WHEN INFRA_CORP = 1 THEN 'Corporate Infrastructure - Qualify'
					ELSE 'Not an Infrastrcuture'
				END
			ELSE INFRASTRUCTURE_INV_CD_TYPE
		  END AS INFRASTRUCTURE_INV_CD_TYP


	FROM 
		WORK.SF_FORECAST_ENGINE

	WHERE 	
		SPRD_RSK = 1

	ORDER BY 
		DATA_SOURCE
		, PORTF_LIST
		, UNIQUE_IDENTIFIER
	
		;
QUIT;
