
PROC SQL ;

/*Create Temp table to load the extracted Data*/

OPTIONS MISSING='';

CREATE TABLE WORK.PROP AS 

	SELECT

		CASE 	
			WHEN A.SOURCE_SYSTEM_CD = 'BLR' THEN '01 - Blackrock - Without Lookthrough'
			ELSE '02 - Non Blackrock - Without Lookthrough'
		 END AS DATA_SOURCE

		, CASE
			 WHEN PHY.PHYSICAL_ASSET_ID = 'BRSGYAKH6' AND X_PHY.CIC_CD ='XT91' THEN 'BRSGYAKH6-A'
			 WHEN PHY.PHYSICAL_ASSET_ID = 'BRSGYAKH6' AND X_PHY.CIC_CD ='XT92' THEN 'BRSGYAKH6-B'
			 ELSE PHY.PHYSICAL_ASSET_ID 
		   END AS CUSIP LENGTH=500

		, A.PORTFOLIO_ID AS PORTF_LIST

		, XIP.ENTITY_NAME AS PORTF_NAME

		, ''  AS PARENT_CUSIP LENGTH=32

		, ''  AS PARENT_ISIN LENGTH=12

		, PUT(XFPC.X_PXS_DT,DDMMYY10.) AS PXS_DATE

		, 'FUND' AS SM_SEC_GROUP LENGTH=20
	
		, 'REIT' AS SM_SEC_TYPE LENGTH=60

		, 'FIXED' AS SM_CPN_TYPE LENGTH=14

		, '' AS RESET_INDEX LENGTH=32

		, X_PHY.ASSET_LOCATION_COUNTRY_CD AS COUNTRY LENGTH=32 FORMAT = $32.

		, A.CURRENCY_CD AS CURRENCY LENGTH=32   FORMAT = $32.

		, X_PHY.APPRAISED_AMT AS MKT_VALUE FORMAT=21.2 LABEL='MKT_VALUE'

		, X_PHY.APPRAISED_AMT/1000 AS MKT_VALUE_DIV_1000 FORMAT=21.4


		, CASE 	
			 WHEN PHY.PHYSICAL_ASSET_ID = 'BRSGYAKH6' AND X_PHY.CIC_CD = 'XT92' THEN 0.00 
			 WHEN A.SOURCE_SYSTEM_CD = 'NONBLR' THEN  X_PHY.PURCHASE_AMT 
			 ELSE A.HOLDINGS_NO END AS GBP_CUR_FACE FORMAT=21.4

		, CALCULATED GBP_CUR_FACE/1000 AS GBP_CUR_FACE_DIV_1000 FORMAT=21.6

		, 0.00 AS COUPON

		, 0.00 AS COUPON_FREQUENCY FORMAT=11.2

		, ''   AS NEXT_COUPON LENGTH=10

		, XFPC.X_MOD_DUR AS MOD_DUR

		, XFPC.X_SPREAD_DUR AS SPREAD_DUR

		, 0.00 AS YIELD_TO_MAT 

		, '00/01/1900' AS MATURITY_DATE
		, '00/01/1900' AS ZV_MATURITY_DATE

		, PHY.ASSET_DESC AS SHORT_STD_DESC  LENGTH=250

		, X_PHY.INTERNAL_REPORTING_CD AS ULTIMATE_PARENT_TICKER 	LENGTH = 200 FORMAT=$200.

		, PHY.X_ISSUER_GRP_NM  AS ULT_ISSUER_NAME 	LENGTH = 255 LABEL = 'ULT_ISSUER_NAME' INFORMAT = $255. FORMAT=$255.
		, PHY.X_ISSUER_NM AS ISSUER_NAME 	LENGTH = 255 LABEL = 'ISSUER_NAME' INFORMAT = $255. FORMAT=$255.

		, '' AS LEHM_RATING_TXT	LENGTH = 20
		, '' AS LEHM_RATING_ISS LENGTH = 10
		, '' AS AVE_RATING	LENGTH = 20

		
		, XFPC.X_BARC_FOUR_PILLAR_SECTOR AS BARCLAYS_FOUR_PILLAR_SECTOR     
		, XFPC.X_BARC_FOUR_PILLAR_SUBSECTOR AS BARCLAYS_FOUR_PILLAR_SUBSECTOR
		, XFPC.X_BARC_FOUR_PILLAR_INDUSTRY AS BARCLAYS_FOUR_PILLAR_INDUSTRY   
		, XFPC.X_BARC_FOUR_PILLAR_SUBINDUSTRY AS BARCLAYS_FOUR_PILLAR_SUBINDUSTRY


		, XFPC.X_INFL AS INFL

		, XFPC.X_INTERNAL_RATING  AS INTERNAL_RATING

		, '' AS ISIN LENGTH=60

		, '' AS PUT_CALL LENGTH=3

		, X_PHY.CIC_CD AS CIC LENGTH=4 FORMAT=$4.

		, X_PHY.APPRAISED_AMT AS PAM_MV FORMAT=21.2 LABEL = 'PAM_MV'

		, CASE 	
			 WHEN PHY.PHYSICAL_ASSET_ID = 'BRSGYAKH6' AND X_PHY.CIC_CD = 'XT92' THEN 0.00 
			 WHEN A.SOURCE_SYSTEM_CD = 'NONBLR' THEN  X_PHY.PURCHASE_AMT 
			 ELSE A.HOLDINGS_NO 
		  END AS GBP_CONV_CUR_FACE FORMAT=21.2

		, '' AS TICKER LENGTH=200
		
		, COALESCE (XFPC.X_MKT_NOTION,X_PHY.APPRAISED_AMT) AS MKT_NOTION  FORMAT=21.2

		, 'REIT PAPER - JPUTs' AS X_PAM_GL_GRP LENGTH=100

		, EXC.I_T_CURRENCY_RATE AS I_T_CURRENCY_RATE LABEL = 'EXC_RATES'

		, 'Property' AS I_T_CLS_GRP LENGTH=60
		, 'Property' AS I_T_CLS_CAT LENGTH=60

		, X_PHY.FINANCE_INV_CLS AS FIN_INV_CLS

		
		, '' AS RTG_MOODYS LENGTH=32
		, 0  AS MDY_SCORE

		, '' AS RTG_SP LENGTH=32
		, 0  AS SP_SCORE

		, '' AS RTG_FITCH LENGTH=32
		, 0  AS FIT_SCORE

		, 0  AS WTFL_SCORE
		, '' AS WTFL_GRADE LENGTH=32
		, '' AS WTFL_AGENCY LENGTH=3
		, '' AS SNP_EQUI_RATING LENGTH=20
		, '' AS GROUPED_RATING LENGTH=20
		, . AS WTFL_SII_CREDIT_QLTY_VAL FORMAT=11.

		, X_EEA_MEMBER_FLAG
		, X_OECD_MEMBER_FLAG

		, '' AS X_SECURITISED_CREDIT_TYPE LENGTH=20

		, '' AS INFRASTRUCTURE_INV_CD LENGTH = 10

		, '' AS NACE LENGTH=100

		, '' AS X_STRUCTURE LENGTH = 50
		/***************************************/

		, COALESCE(XFPC.X_MOD_DUR_S2,0) AS MOD_DUR_S2 /*Added for Interest rate risk*/

		, 'None' AS ULT_ISSUER_LEI LENGTH = 100/*Added for CPARTY rate risk*/

		, 'None' AS ISSUER_LEI LENGTH = 100 /*Added for CPARTY rate risk*/

	FROM       				
		test.FINANCIAL_POSITION A

	INNER JOIN 		
		test.PHYSICAL_ASSET PHY
			ON A.PHYSICAL_ASSET_RK = PHY.PHYSICAL_ASSET_RK
	 		AND DATEPART(PHY.VALID_FROM_DTTM)	<= &AS_AT_MTH  
			AND DATEPART(PHY.VALID_TO_DTTM)	> &AS_AT_MTH     

	INNER JOIN 			
		test.X_PHYSICAL_ASSET X_PHY
			ON A.PHYSICAL_ASSET_RK = X_PHY.PHYSICAL_ASSET_RK
	 		AND DATEPART(X_PHY.VALID_FROM_DTTM)	<= &AS_AT_MTH  
			AND DATEPART(X_PHY.VALID_TO_DTTM)	> &AS_AT_MTH 

	INNER JOIN  		
		test.X_I_T_INT_EXC_RATES EXC
			ON A.CURRENCY_CD = EXC.CURRENCY_CD
	 		AND DATEPART(EXC.VALID_FROM_DTTM)	<= &AS_AT_MTH  
			AND DATEPART(EXC.VALID_TO_DTTM)	> &AS_AT_MTH       

	LEFT JOIN 			
		test.X_FINANCIAL_POSITION_CHNG     XFPC
			ON A.FINANCIAL_POSITION_RK = XFPC.FINANCIAL_POSITION_RK       
	 		AND DATEPART(XFPC.VALID_FROM_DTTM)	<= &AS_AT_MTH  
			AND DATEPART(XFPC.VALID_TO_DTTM)	> &AS_AT_MTH 

	LEFT JOIN    		
		test.X_INVESTMENT_PORTFOLIO XIP    
			ON  ( XIP.PORTFOLIO_ID = A.PORTFOLIO_ID   
			AND  PUT(DATEPART(XIP.VALID_TO_DTTM),DATE9.) = '31DEC9999' )   

	LEFT JOIN 	
		test.COUNTRY CNTRY
			ON  ( X_PHY.ASSET_LOCATION_COUNTRY_CD = CNTRY.COUNTRY_CD
			AND PUT(DATEPART(CNTRY.VALID_TO_DTTM),DATE9.) = '31DEC9999')   

	WHERE     
	 	DATEPART(A.VALID_FROM_DTTM)	<= &AS_AT_MTH  
		AND DATEPART(A.VALID_TO_DTTM)	> &AS_AT_MTH 
;

QUIT;

/*------------------
	 	AND DATEPART(PHY.VALID_FROM_DTTM)	<= &AS_AT_MTH  
		AND DATEPART(PHY.VALID_TO_DTTM)	> &AS_AT_MTH 
------------------*/