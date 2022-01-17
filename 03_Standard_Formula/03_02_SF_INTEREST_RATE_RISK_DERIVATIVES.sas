/* RUN FROM Append */

PROC SQL ;

/*Create Temp table to load the extracted Data*/

OPTIONS MISSING='';

CREATE TABLE WORK.SF_INT_RSK_DVTS AS 

	SELECT

		DATA_SOURCE

		, PORTF_LIST

		, PORTF_NAME

		, CUSIP AS UNIQUE_IDENTIFIER

		, ISSUER_NAME

		, X_PAM_GL_GRP AS INVESTMENT_TYPE

		, SM_CPN_TYPE AS VARIABLE

		, MOD_DUR AS DURATION

		, MOD_DUR_S2 AS DURATION_S2

		, CURRENCY

		, COUPON

		, COUPON_FREQUENCY

		, GBP_CUR_FACE_DIV_1000

		, ZV_MATURITY_DATE AS REDEMPTION_DATE

		, GBP_CUR_FACE_DIV_1000 AS CUR_FACE_DIV_NOTIONAL_VALUE_FUT

		, COUPON AS COUPON_RATE

		, RESET_INDEX

		, CASE 	
			WHEN RESET_INDEX = '5Y TSY' 	THEN 0.72
			WHEN RESET_INDEX = '3M Libor' 	THEN 0.52
			WHEN RESET_INDEX = '1M Libor'  	THEN 0.50
			WHEN RESET_INDEX = '12M Libor' 	THEN 1.01
			WHEN RESET_INDEX = '1D USOIS' 	THEN 0.17
			WHEN RESET_INDEX = '3M EURIBOR' THEN 0.11
			WHEN RESET_INDEX = '1M EURIBOR' THEN 0.19
			WHEN RESET_INDEX = '6M Libor' 	THEN  0.52
			ELSE 0.00 
		  END AS VARIABLE_RATE

		, CASE 
			WHEN SUBSTR(CIC,3,1) IN ('D','A') AND PORTF_LIST <> 'A_320UKIDE' 
				THEN 1 
			ELSE 0 
		  END AS INT_RT_DRVTS_RSK_SCOPE 

		, CIC

	FROM 
		WORK.SF_BASE_APPEND

	WHERE 
		SUBSTR(CIC,3,1) = 'D' /* ONLY SWAPS */
	
	ORDER BY 
		DATA_SOURCE

		, PORTF_NAME

		, UNIQUE_IDENTIFIER

	;
QUIT;