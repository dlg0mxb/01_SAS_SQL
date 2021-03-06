
PROC SQL ;

/*Create Temp table to load the extracted Data*/

OPTIONS MISSING='';

CREATE TABLE WORK.SF_SINGLE_DETAIL_VW AS 

	SELECT 
			MONOTONIC() AS ROW_NUM
			, DATA_SOURCE
			,CUSIP
			,PORTF_LIST
			,PORTF_NAME
			,PARENT_CUSIP
			,PARENT_ISIN
			,PXS_DATE
			,SM_SEC_GROUP
			,SM_SEC_TYPE
			,SM_CPN_TYPE
			,RESET_INDEX
			,COUNTRY
			,CURRENCY
			,MKT_VALUE
			,MKT_VALUE_DIV_1000
			,GBP_CUR_FACE
			,GBP_CUR_FACE_DIV_1000
			,COUPON
			,COUPON_FREQUENCY
			,NEXT_COUPON
			,MOD_DUR
			,MOD_DUR_S2
			,SPREAD_DUR
			,YIELD_TO_MAT
			,MATURITY_DATE
			,ZV_MATURITY_DATE
			,SHORT_STD_DESC
			,ULTIMATE_PARENT_TICKER
			,ULT_ISSUER_NAME
			,ISSUER_NAME
			,LEHM_RATING_TXT
			,LEHM_RATING_ISS
			,AVE_RATING
			,BARCLAYS_FOUR_PILLAR_SECTOR
			,BARCLAYS_FOUR_PILLAR_SUBSECTOR
			,BARCLAYS_FOUR_PILLAR_INDUSTRY
			,BARCLAYS_FOUR_PILLAR_SUBINDUSTRY
			,INFL
			,INTERNAL_RATING
			,ISIN
			,PUT_CALL
			,CIC
			,PAM_MV
			,GBP_CONV_CUR_FACE
			,TICKER
			,MKT_NOTION
			,X_PAM_GL_GRP
			,I_T_CURRENCY_RATE
			,I_T_CLS_GRP
			,I_T_CLS_CAT
			,FIN_INV_CLS
			,RTG_MOODYS
			,MDY_SCORE
			,RTG_SP
			,SP_SCORE
			,RTG_FITCH
			,FIT_SCORE
			,WTFL_SCORE
			,WTFL_GRADE
			,CASE WHEN WTFL_AGENCY = 'S_P' THEN 'SP' ELSE WTFL_AGENCY END AS WTFL_AGENCY
			,SNP_EQUI_RATING
			,GROUPED_RATING
			,WTFL_SII_CREDIT_QLTY_VAL
			,INT_RT_RSK
			,INT_RT_DRVTS_RSK
			,EQTY_RSK
			,PRPTY_RSK
			,CCY_RSK
			,CCY_RSK_EXP
			,SPRD_RSK_STRUC
			,SPRD_RSK_BND
			,SENSE_CHECK_SPRD_RSK
			,SPRD_RSK
			,BOND_TYPE
			,IS_BND
			,IS_GOVT
			,IS_EEA
			,IS_EEA_GOVT
			,IS_GUARN_EEA_GOVT
			,IS_SUPRA_BNDS
			,SENSE_CHECK_BNDS
			,EXEMPT_SPREAD_RISK
			,REAL_TICKER_CONC_RSK
			,EXEMPT_CONC_RISK
			,NON_EEA_GOVT
			,CONC_RSK
			,TYP_0
			,TYP_1
			,TYP_2
			,TYP_3
			,TYP_4
			,TYP_5
			,CHCK_CONC_2_TYP
			,CHCK_NO_TYP
			,EXP_TYP
			,DEFAULT_RSK
			,LEHM_SCORE
			,ZERO_RATED
			,NON_ZERO_RATED_NOT_COV
			,NON_ZERO_RATED_COV
			,CIC_11_15_NON_EU_CUR_MTCH
			,SENSE_CHK_CIC_BND_CLASS
			,SENSE_CHK_CIC_BND_NT_CLASS
			,SEC_CREDIT_TYP1
			,SEC_CREDIT_TYP2
			,SENSE_CHECK_CIC_SEC_CRED
			,SENSE_CHECK_CIC_SEC_CRED_NC
			,INVESTMENT_PROP
			,OWNER_OCC_PROP
			,CASH
			,OTHER
			,LOOKTHRU
			,CIC_3_4_DIGIT

		FROM 
			WORK.SF_FORECAST_ENGINE

		ORDER BY 	
			ROW_NUM
			,  DATA_SOURCE
			, PORTF_LIST
			, CUSIP
			, CIC	
		;
	QUIT;
