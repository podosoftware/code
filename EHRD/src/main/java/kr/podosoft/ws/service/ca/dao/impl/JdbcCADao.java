package kr.podosoft.ws.service.ca.dao.impl;

import java.sql.Types;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
//import java.util.Iterator;
import java.util.List;
import java.util.Map;
//import java.util.Set;

import kr.podosoft.ws.service.ca.CAException;
import kr.podosoft.ws.service.ca.dao.CADao;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;

import architecture.common.user.User;
import architecture.ee.jdbc.sqlquery.SqlQuery;
import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;

public class JdbcCADao  extends SqlQueryDaoSupport implements CADao  {
	
	/* ================================================= 
    mpva project S..... 
    ================================================= */
	


	public void updateSocialExceptionFlag(String socialExceptionFlag, long companyId, String cmpNumber) {

		getSqlQuery().update("CA.UDPATE_SOCIALEXCEPTION_FLAG", socialExceptionFlag, companyId);
		
	}

	public int mergeBhvIndicator(long companyId, String bhvIndicatorNum, String compNum, 
					String bhvIndicator, String useFlag, long userId) {
		
		return getSqlQuery().update("CA.MERGE_BHV_INDICATOR",companyId, compNum,  bhvIndicatorNum, bhvIndicator, 
										useFlag, userId);
	}
	

	public String getMaxbhvIndcNum(){
		
		return getSqlQuery().queryForObject("CA.GET_MAX_BHV_INDCNUM", new Object[]{}, new int[]{}, String.class);
	}
	

	/**
	 * 역량정보(고객사) merge
	 */
	public int mergeOperatorCompetency(String cmpNumber, String cmpGroup,
			String cmpName, String cmpDefinition,
			String useFlag, long userId, long companyId) {

		return getSqlQuery().update("CA.MERGE_OPERATOR_CM_COMPETENCY", companyId,
				cmpNumber, cmpGroup, cmpName, cmpDefinition, 
				useFlag, userId);
	}

	
	/**
	 * 역량목록조회(고객사)
	 */
	public List getOperatorCompetencyListDao(int startIndex, int pageSize, long companyId) {
		
		return getSqlQuery().setStartIndex(startIndex).setMaxResults(pageSize).queryForList("CA.GET_OPERATOR_CMPT_LIST", new Object[]{companyId});
	}
	
	
	/**
	 * 역량Pool관리(고객사) 메뉴의 상세조회에서 행동지표 목록 조회
	 */
	public List<Map<String, Object>> getOperatorBhvListDao(long company, String cmpNumber) {

		return getSqlQuery().list("CA.GET_OPERATOR_BHV_LIST", company, cmpNumber);
	}	
	
	
	
	/**
	 * 서브도메인
	 */
	public List getDomainChkDao(String getDomainChkDao) {

		return getSqlQuery().list("CA.GET_DOMAIN_CHECK", getDomainChkDao);
	}
	
	//게시판 글쓰기시 SEQ
	public String seqBrdNum() {
 
		return getSqlQuery().queryForObject("CA.SEQ_BRD_NUM", new Object[]{}, new int[]{}, String.class);
	}
	//게시판 코맨트 카운터
	public String comentMaxCnt(String brdCd, String brdNum, long companyId) {

		return getSqlQuery().queryForObject("CA.GET_COMENT_MAX_CNT", new Object[]{brdCd, brdNum, companyId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}, String.class);
	}
	//게시판 코맨트 저장 
	public int brdComentSaveDao(String brdCd, String brdNum, String maxCnt,
			String brdcont, long userId, long companyId) {

		return getSqlQuery().update("CA.GET_BRD_COMENT_SAVE", brdCd, brdNum, maxCnt, brdcont, userId, companyId);
	}
	
	//게시판 저장,수정
	public int brdContSaveDao(String brdtitle, String brdcont, String brdCd,
			String brdNum, String maxCnt, long userId, long companyId) {

		return getSqlQuery().update("CA.GET_BRD_CONT_MERGE", brdtitle, brdcont, brdCd, brdNum, userId, companyId);
	}
	
	/**
	 * 설문관리 년도 셀렉트박스
	 */
	public List getSruvYealListDao(long companyId) {

		return getSqlQuery().list("CA.GET_SERV_YEAL_LIST", companyId);
	}
	/**
	 * 설문관리 리스트
	 */
	public List getSurvListDao(long companyId, String runNum) {

		return getSqlQuery().list("CA.GET_SERV_LIST", companyId, runNum);
	}
	
	/**
	 * 설문관리 설문문항
	 */
	public List getSurvQstnDao(long companyId, String ppNo) {

		return getSqlQuery().list("CA.GET_SERV_QSTN", companyId, ppNo);
	}
	
	/**
	 * 설문관리 설문문항 카운트
	 */
	public int getSurvQstnCountDao(long companyId, String ppNo) {

		return getSqlQuery().queryForObject("CA.GET_SERV_QSTN_CONUNT", new Object[]{companyId, ppNo}, 
				new int[]{Types.NUMERIC, Types.NUMERIC}, Integer.class);
	}
	
	/**
	 * 설문관리 설문결과(객관식 유무)
	 */
	public List getSurvRstCountDao(long companyId, String ppNo, int ppType,
			String ppSeq) {

		return getSqlQuery().list("CA.GET_SERV_RST_COUNT", companyId, ppNo, ppSeq);
	}
	
	/**
	 * 설문관리 설문결과(객관식)
	 */
	public List getSurvRstDao(long companyId, String ppNo, int ppType,
			String ppSeq) {

		return getSqlQuery().list("CA.GET_SERV_RST", companyId, ppNo, ppSeq);
	}
	
	/**
	 * 설문관리 설문결과(주관식)
	 */
	public List getSurvRst2Dao(long companyId, String ppNo, int ppType,
			String ppSeq) {

		return getSqlQuery().list("CA.GET_SERV_RST2", companyId, ppNo, ppSeq);
	}
	
	/**
	 * 설문관리 대상자관리
	 */
	public List getSurvTargDao(long companyId, String ppNo) {

		return getSqlQuery().list("CA.GET_SERV_TARG", companyId, ppNo);
	}
	
	/**
	 * 설문관리 설문문항 pool
	 */
	public List getSurvQstnPoolDao(long companyId) {

		return getSqlQuery().list("CA.GET_SERV_QSTN_POOL", companyId);
	}
	
	/**
	 * 설문관리 사용자 리스트
	 */
	public List getSurvUserDao(long companyId) {

		return getSqlQuery().list("CA.GET_SERV_USER", companyId);
	}
	
	/**
	 * 설문관리 결과 엑셀다운로드 리스트
	 */
	public List getServListExcelDao(long companyId, String ppNo,
			List<Map<String, Object>> list) {
		
		SqlQuery query = getSqlQuery();
		String selectString = "";
		String fromString = "";
		String whereString = "";
		
		for(int i=0; i<list.size(); i++){
			Map map = (Map)list.get(i);

			selectString += " , B"+i+".SV_RST RST"+i;
			fromString +=
					" ,( "+
			        " SELECT  CASE WHEN SV_RST = '5' THEN '매우 그렇다' WHEN SV_RST = '4' THEN '그렇다'  WHEN SV_RST = '3' THEN '보통이다'  WHEN SV_RST = '2' THEN '아니다'  WHEN SV_RST = '1' THEN '전혀 아니다' WHEN SV_RST != '1' OR SV_RST != '2' OR SV_RST != '3' OR SV_RST != '4' OR SV_RST != '5' THEN SV_RST  END SV_RST, USERID, PP_NO, COMPANYID \n"+
			        " FROM TB_SV_RST \n"+
			        " WHERE COMPANYID = "+companyId+" AND PP_NO = "+ppNo+" AND QSTN_SEQ = "+map.get("QSTN_SEQ")+"\n"+
			        "    AND USEFLAG = 'Y' \n"+
			        " ) B"+i+"\n";
			if(i==0){
				whereString += "AND A.COMPANYID = B0.COMPANYID(+) AND A.PP_NO = B0.PP_NO(+) AND A.USERID = B0.USERID(+)\n";
			}else{
				whereString += "AND A.COMPANYID = B"+i+".COMPANYID(+) AND A.PP_NO = B"+i+".PP_NO(+) AND A.USERID = B"+i+".USERID(+)\n";
			}
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("QUERY_SELECT", selectString);
		map.put("QUERY_FROM", fromString);
		map.put("QUERY_WHERE", whereString);
		
		query.setAdditionalParameters(map);
		return query.list("CA.GET_SERV_LIST_EXCEL", companyId, ppNo);
	}
	
	/**
	 * 역량목록조회
	 */
	public List getCompetencyListDao(int startIndex, int pageSize, long companyId) {
		
		return getSqlQuery().setStartIndex(startIndex).setMaxResults(pageSize).queryForList("CA.GET_CMPT_LIST", new Object[]{companyId});
	}
	
	/**
	 * 공통코드조회
	 */
	public List getCommonCodeListDao(String standardCode, long companyId, String addValue) {
		SqlQuery query = getSqlQuery();
		
		Map<String, Object> map = new HashMap<String, Object>();
		if(addValue!=null && !addValue.equals("")){
			map.put("ADD_OPT", "SELECT null VALUE, '"+addValue+"' TEXT, null P_VALUE, 'Y' USEFLAG FROM DUAL UNION ALL");
		}else{
			map.put("ADD_OPT", "");
		}
		query.setAdditionalParameters(map);
		return query.list("CA.GET_COMMON_CODE_LIST", standardCode, companyId);
	}
	
	/**
	 * 역량Pool관리 메뉴의 상세조회에서 행동지표 목록 조회
	 */
	public List<Map<String, Object>> getBhvListDao(long company, String cmpNumber) {

		return getSqlQuery().list("CA.GET_BHV_LIST", company, cmpNumber);
	}
	

	
	/**
	 * 역량정보 merge
	 */
	public int mergeCompetency(String cmpNumber, String cmpGroup,
			String cmpGroup_s, String cmpName, String cmpDefinition,
			String useFlag, long userId, long companyId) {

		return getSqlQuery().update("CA.MERGE_CM_COMPETENCY", companyId,
				cmpNumber, cmpGroup, cmpGroup_s, cmpName, cmpDefinition, 
				useFlag, userId);
	}
	
	/**
	 * 설문관리 merge
	 */
	public int mergeServ(String qstnPoolNo, String qstnTypeCd, String qstn,
			String useFlag, long userId, long companyId) {
 
		return getSqlQuery().update("CA.MERGE_CM_SERV", companyId,
				qstnPoolNo, qstnTypeCd, qstn, useFlag, userId, companyId);
	}
	
	
	/**
	 * 삭제(공통)
	 */
	public int caCommonDelService(Map<String, Object> map, long userId, long companyId) {
			
		int saveCount = 0;
		
		String flag 		=  (String)map.get("FLAG");
		
		

		log.debug("테스트"+flag);
		//////////////총관리자 영역//////////////////
		
		//역량관리
		if(flag == "1" || flag.equals("1")){
			String cmpNumber 		=  (String)map.get("CMPNUMBER");
			saveCount = getSqlQuery().update("CA.ADMIN_COMMON_DEL", companyId, cmpNumber);
		}
		
		//행동지표관리
		if(flag == "2" || flag.equals("2")){
			String cmpNumber 		=  (String)map.get("CMPNUMBER");
			String bhvIndcNum 		=  (String)map.get("BHVINDCNUM");
			saveCount = getSqlQuery().update("CA.ADMIN_COMMON_DEL2", companyId, cmpNumber, bhvIndcNum);
		}
		
		//KPI관리
		if(flag == "3" || flag.equals("3")){
			String kpiNumber 		=  (String)map.get("KPINUMBER");
			saveCount = getSqlQuery().update("CA.ADMIN_COMMON_DEL3", companyId, kpiNumber);
		}	
		
		//고객사관리
		if(flag == "4" || flag.equals("4")){
			String companyid 		=  (String)map.get("COMPANYID");
			saveCount = getSqlQuery().update("CA.ADMIN_COMMON_DEL4", companyid);
		}
		
		
		//////////고객사 관리자 영역///////////
		
		//직무관리
		if(flag == "5" || flag.equals("5")){
			String jobLdrNum 		=  (String)map.get("jobLdrNum");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL5", companyId, jobLdrNum);
		}
		
		//계급관리
		if(flag == "6" || flag.equals("6")){
			String jobLdrNum 		=  (String)map.get("jobLdrNum");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL6", companyId, jobLdrNum);
		}
		
		//부서관리
		if(flag == "7" || flag.equals("7")){
			String divisionid 		=  (String)map.get("DIVISIONID");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL7", companyId, divisionid);
		}
		
		//직원관리
		if(flag == "8" || flag.equals("8")){
			String userid 		=  (String)map.get("userId");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL8", companyId, userid);
		}
		
		//공통코드관리
		if(flag == "9" || flag.equals("9")){
			String standardcode 	=  (String)map.get("standardcode");
			String code 			=  (String)map.get("code");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL9", companyId, standardcode, code);
		}
		
		//과정관리
		if(flag.equals("10")){
			String subjectNum 	=  (String)map.get("subjectNum");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL10", companyId, subjectNum);
		}
		
		//역량관리
		if(flag == "11" || flag.equals("11")){
			String cmpNumber 		=  (String)map.get("CMPNUMBER");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL11", companyId, cmpNumber);
		}
		//행동지표관리
		if(flag == "12" || flag.equals("12")){
			String cmpNumber 		=  (String)map.get("CMPNUMBER");
			String bhvIndcNum 		=  (String)map.get("BHVINDCNUM");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL12", companyId, cmpNumber, bhvIndcNum);
		}
		//성과관리
		if(flag == "13" || flag.equals("13")){
			String kpiNumber 		=  (String)map.get("KPINUMBER");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL13", companyId, kpiNumber);
		}
		//평가생성/관리
		if(flag == "14" || flag.equals("14")){
			String runNum 		=  (String)map.get("RUN_NUM");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL14", companyId, runNum);
		}
		
		//평가생성/관리
		if(flag == "15" || flag.equals("15")){
			String ppNo 		=  (String)map.get("PP_NO");
			saveCount = getSqlQuery().update("CA.OPERATOR_COMMON_DEL15", companyId, ppNo);
		}
		
		return saveCount;
	}
	
	
	
	/**
	 * 역량Pool목록 엑셀조회
	 */
	public List getCmptListExcelDao(long companyId) {
		return getSqlQuery().list("CA.GET_CMPT_LIST_EXCEL", companyId);
	}
	
	/**
	 * KPI Pool목록 엑셀조회
	 */
	public List getKpiListExcelDao(long companyId) {
		return getSqlQuery().list("CA.GET_KPI_LIST_EXCEL", companyId);
	}
	
	/**
	 * KPI Pool목록 엑셀조회(고객사)
	 */
	public List getOperatorKpiListExcelDao(long companyId) {
		return getSqlQuery().list("CA.GET_OPERATOR_KPI_LIST_EXCEL", companyId);
	}
	
	/**
	 * 행동지표목록 엑셀조회
	 */
	public List getIndicatorListExcelDao(long companyId) {
		return getSqlQuery().list("CA.GET_INDC_LIST_EXCEL", companyId);
	}
	
	


	/**
	 * 역량군목록 조회
	 */
	public List getCmpgroupListDao(String standardCode, String useFlag, long companyId, String value) {
		SqlQuery query = getSqlQuery();
		
		Map<String, Object> map = new HashMap<String, Object>();
		String whereStr = "";
		
		//역량군조회 조건 - 사용/전체
		if(useFlag!=null && useFlag.equals("Y")){
			whereStr += " AND USEFLAG = '"+useFlag+"' ";
		}
		
		//역량군(대)에 속하는 역량군(소) 조회
		if(value!=null && !value.equals("")){
			whereStr += " AND PARENT_COMMONCODE = '"+value+"' ";
		}
		map.put("WHERE_STR", whereStr);
		query.setAdditionalParameters(map);
		
		return query.list("CA.GET_CMPGROUP_LIST", standardCode, companyId);
	}
	
	

	/**
	 * 역량군정보 merge
	 */
	public int mergeCmpGroup(String commoncode, String standardcode, String cmmCodename, String useFlag, String parentCommoncode, String parentStandardcode, long userId, long companyId) {

		return getSqlQuery().update("CA.MERGE_CMPGROUP_COMMONCODE", commoncode,
				cmmCodename, standardcode, useFlag, parentStandardcode, parentCommoncode, 
				companyId, userId, companyId, standardcode);
	}
	
	
	
	
	/**
	 * 역량군정보 merge(고객사)
	 */
	public int mergeOperatorCmpGroup(String commoncode, String standardcode, String cmmCodename, String useFlag, String parentCommoncode, String parentStandardcode, long userId, long companyId) {

		return getSqlQuery().update("CA.MERGE_CMPGROUP_COMMONCODE", commoncode,
				cmmCodename, standardcode, useFlag, parentStandardcode, parentCommoncode, 
				companyId, userId, companyId, standardcode);
	}
	

	/**
	 * KPI목록 조회
	 */
	public List getKpiListDao(int startIndex, int pageSize, long companyId) {
		
		return getSqlQuery().setStartIndex(startIndex).setMaxResults(pageSize).queryForList("CA.GET_KPI_LIST", new Object[]{companyId});
	}
	
	/**
	 * KPI 지표정보 merge
	 */
	public int mergeKpi(String kpiNumber, String kpiGroup, String kpiGroup_s,
			String kpiName, String evlHow, String unit, String useFlag,
			long userId, long companyId) {

		return getSqlQuery().update("CA.MERGE_CM_KPI", companyId,
				kpiNumber, kpiGroup, kpiGroup_s, kpiName, evlHow, unit, 
				useFlag, userId); 
	}
	
	/**
	 * KPI 지표정보 merge(고객사)
	 */
	public int operatorMergeKpi(String kpiNumber, String kpiGroup,
			String kpiName, String kpiType, String meaEvlCyc, String evlYype,
			String evlHow, String unit, String useFlag, long userId,
			long companyId, String cap, String target, String threshold, String targetSetWrnt, String dataSource, String mgmtDept) {

		return getSqlQuery().update("CA.OPERATOR_MERGE_CM_KPI", companyId,
				kpiNumber, kpiName, kpiType, meaEvlCyc, evlYype, evlHow, unit, cap, target, threshold, targetSetWrnt,  dataSource, mgmtDept,
				useFlag, userId);
	}
	
	/**
	 * KPI ADD FLAG 체크
	 */
	public String kpiAddCheckDao(long companyId) {

		return getSqlQuery().queryForObject("CA.KPI_ADD_CHECK", new Object[]{companyId}, new int[]{Types.VARCHAR}, String.class );			
	}
	
	/**
	 * userTargetInfo
	 */
	public String userTargetInfo(long companyId, String userId) {
		
		return getSqlQuery().queryForObject("CA.USER_TARGET_INFO", new Object[]{companyId , userId}, new int[]{Types.VARCHAR, Types.VARCHAR}, String.class );			
	}
	
	/**
	 * userTargetColUser
	 */
	public String userTargetColUser(long companyId, String empNo) {
		
		try {
			

				String colUserEmpNoTmp = "";
				String colUserId = "";
				
				String[] colUserIdArr = empNo.split(",");
				
				for(int i = 0; i < colUserIdArr.length; i ++){
					
					colUserEmpNoTmp = colUserIdArr[i].trim();
					
					colUserId += ""+getSqlQuery().queryForObject("CA.USER_TARGET_ONE_USER", new Object[]{companyId , colUserEmpNoTmp}, new int[]{Types.VARCHAR, Types.VARCHAR}, String.class )+",";
					
				}
			
			return colUserId +"0";	
			
		} catch (EmptyResultDataAccessException e) {
			
			return null;
			
		}
	}
	
	/**
	 * userTargetSubUser
	 */
	public String userTargetSubUser(long companyId, String empNo) {
		
		try {
			

				String subUserEmpNoTmp = "";
				String subUserId = "";
				
				String[] subUserIdArr = empNo.split(",");
				
				for(int i = 0; i < subUserIdArr.length; i ++){
					
					subUserEmpNoTmp = subUserIdArr[i].trim();
					
					subUserId += ""+getSqlQuery().queryForObject("CA.USER_TARGET_ONE_USER", new Object[]{companyId , subUserEmpNoTmp}, new int[]{Types.VARCHAR, Types.VARCHAR}, String.class )+",";
					
				}
			
			return subUserId +"0";	
			
		} catch (EmptyResultDataAccessException e) {
			
			return null;
			
		}
	}
	
	/**
	 * userTargetOneUser
	 */
	public String userTargetOneUser(long companyId, String empNo) {
		
		try {
			
			return getSqlQuery().queryForObject("CA.USER_TARGET_ONE_USER", new Object[]{companyId , empNo}, new int[]{Types.VARCHAR, Types.VARCHAR}, String.class );	
			
		} catch (EmptyResultDataAccessException e) {
			
			return null;
			
		}
	}
	
	/**
	 * userTargetTwoUser
	 */
	public String userTargetTwoUser(long companyId, String empNo2) {
		
		try {
					
		return getSqlQuery().queryForObject("CA.USER_TARGET_TWO_USER", new Object[]{companyId , empNo2}, new int[]{Types.VARCHAR, Types.VARCHAR}, String.class );
		
		} catch (EmptyResultDataAccessException e) {
			
			return null;			
		
		}
	}
	
	/**
	 * 역량 ADD FLAG 체크
	 */
	public String cmptAddCheckDao(long companyId) {

		return getSqlQuery().queryForObject("CA.CMPT_ADD_CHECK", new Object[]{companyId}, new int[]{Types.VARCHAR}, String.class );			
	}
	
	
	/**
	 * KPI 지표목록 조회
	 */
	public List getKpigroupListDao(String standardCode, String useFlag, long companyId, String value) {
		SqlQuery query = getSqlQuery();
		
		Map<String, Object> map = new HashMap<String, Object>();
		String whereStr = "";
		
		//역량군조회 조건 - 사용/전체
		if(useFlag!=null && useFlag.equals("Y")){
			whereStr += " AND USEFLAG = '"+useFlag+"' ";
		}
		
		//역량군(대)에 속하는 역량군(소) 조회
		if(value!=null && !value.equals("")){
			whereStr += " AND PARENT_COMMONCODE = '"+value+"' ";
		}
		map.put("WHERE_STR", whereStr);
		query.setAdditionalParameters(map);
		
		return query.list("CA.GET_CMPGROUP_LIST", standardCode, companyId);
	}
	
	
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CAException {
		return getSqlQuery().executeUpdate(statement, params);
	}
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CAException {
		return getSqlQuery().update(statement, params, jdbcTypes);
	}
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CAException {
		List<Map<String, Object>> list = Collections.EMPTY_LIST;
		try {
			if(params!=null) {
				list = getSqlQuery().queryForList(statement, params, jdbcTypes);
			} else {
				list = getSqlQuery().queryForList(statement);
			}
		} catch(Throwable e) {
			log.error(e);
		}
		return list;
	}
	

	public List cmtpWeightListDao(long companyId, String runNum) {

		return getSqlQuery().list("CA.GET_CMPT_WEIGHT_LIST", companyId, runNum);
	}

	public List cmptAdminListDao(long companyId)  {

		return getSqlQuery().list("CA.GET_CMPT_ADMIN_LIST", companyId);
	}

	public String getMaxRunNum(long companyId)  throws CAException{

		return getSqlQuery().queryForObject("CA.GET_MAX_RUN_NUM", new Object[]{companyId}, new int[]{Types.NUMERIC}, String.class);
	}
	
	
	
	/* ================================================= 
     cnp project E..... 
     ================================================= */
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	public int mergeClassUserDao(long companyId, long userId, String subjectNum, int year, int chasu, int cmpnumber, String couponFlag) {

		return getSqlQuery().update("CA.MERGE_CLASS", cmpnumber, couponFlag,   subjectNum, year, chasu, companyId, userId);
	}

	public String getCpSubjectNum(String subjectNum, String year, String chasu) {

		return getSqlQuery().queryForObject("CA.GET_CP_SUBJECT_NUM", new Object[]{subjectNum}, new int[]{Types.VARCHAR}, String.class );
	}

	public int updateClassUserDao(int companyId, int userId, String courseCd, int eduYear, int courseSq, String attendStateCode) {

		return getSqlQuery().update("CA.UDPATE_CLASS", attendStateCode, userId, courseCd, eduYear, courseSq);
	}

	public int insertDaoPay(String userId, String courseCd, String eduYear,
			String courseSq, String amount, String payMethod, String cpId,
			String daoutrx, String orderNo, String settdate,
			String bankCode, String bankName, String accountNo, String depositendDate, String receiverName) {

		return getSqlQuery().update("CA.INSERT_DAOPAY_INFO", userId, eduYear, courseSq, courseCd,  amount, payMethod, cpId, daoutrx, 
																				  orderNo,  settdate, bankCode, bankName, accountNo, depositendDate, receiverName);
	}

	public Object insertDaoPayOriginal(String userId, String courseCd,
			String eduYear, String courseSq, String amount, String payMethod,
			String cpId, String daoutrx, String orderNo, String settdate) {

		return getSqlQuery().update("CA.INSERT_DAOPAY_ORIGINAL_INFO", userId, eduYear, courseSq, courseCd,  amount, payMethod, cpId, daoutrx, 
				  orderNo,  settdate);
	}
	
	public int insertClassUserDao(long companyId, long userId,
			String subjectNum, int year, int chasu, int cmpnumber,
			String couponFlag, String attendStateCode) {

		return getSqlQuery().update("CA.INSERT_CLASS", cmpnumber, couponFlag, userId,  subjectNum, year, chasu, companyId, userId);
	}

	public String getUserId(String reqSID) {

		return getSqlQuery().queryForObject("CA.GET_USERID", new Object[]{3, reqSID}, new int[]{Types.NUMERIC, Types.VARCHAR}, String.class );
	}

	public List dainPayModuleInfoDao(String sKey, String sID, String compCd,
			String eduYear, String courseCd, String courseSq,
			String subjectNum, String year, String chasu, long companyId, long userId, String cmpnumber) {

		return getSqlQuery().list("CA.DAINPAY_MODULE_INFO", sKey, sID, compCd, courseCd, courseSq, eduYear, subjectNum, year, chasu, cmpnumber, companyId, userId);
	}

	public String getUserId(long companyId, long userId) {

		return getSqlQuery().queryForObject("CA.GET_USER_ID", new Object[]{companyId, userId}, 
																new int[]{Types.NUMERIC, Types.NUMERIC}, String.class);
	}
	
	public List recommendActivityListDao(long companyId) {

		return getSqlQuery().list("CA.RECOMMEND_ACTIVITY_LIST", companyId);
	}

	public List cmptStatisticsDivisionListDao(long companyId, String runNum) {

		return getSqlQuery().list("CA.CMPT_STATISTICS_DIVISION_LIST", companyId, runNum, companyId, runNum);
	}
	
	public List yearCategoryListDao(long companyId) {

		return getSqlQuery().list("CA.YEAR_CATEGORY_LIST",companyId);
	}

	public List cmptStatisticsYearListDao(long companyId) {

		return getSqlQuery().list("CA.CMPT_STATISTICS_YEAR_LIST",companyId, companyId);
	}

	public List divisionCategoryListDao(long companyId) {

		return getSqlQuery().list("CA.DIVISION_CATEGORY_LIST",companyId);
	}

	public List<Map<String, Object>> getRunCompetencyListDao(long companyId, String runNum) {

		return getSqlQuery().list("CA.RUN_COMPETENCY_LIST", companyId, runNum);
	}

	public List diagResultExcelDao(long companyId, String runNum) {

		return getSqlQuery().list("CA.DIAG_RESULT_EXCEL", companyId, runNum);
	}

	public List cmptStatisticsClassListDao(long companyId, String runNum) {
		
		return getSqlQuery().list("CA.CMPT_STATISTICS_CLASS_LIST", companyId, runNum, companyId, runNum);
	}

	public List recommendNotSubjectInfoDao(String subjectNum, String year, String chasu, long companyId, long userId, String cmpnumber) {
		
		return getSqlQuery().list("CA.RECOMMEND_NOT_SUBJECT_INFO", cmpnumber, companyId, userId, userId, userId, subjectNum, year, chasu);
	}

	public List recommendSubjectInfoDao(String subjectNum, String year, String chasu) {

		return getSqlQuery().list("CA.RECOMMEND_SUBJECT_INFO", 	subjectNum, year, chasu);
	}

	public List developmentGuideDao(int runNum, long companyId, long userId) {

		return getSqlQuery().list("CA.DEVELOPMENT_GUIDE", companyId, runNum, userId, companyId, companyId, runNum, userId, companyId, 
					companyId, runNum, userId, companyId);
	}

	public String diagResultScoreDao(int runNum, long companyId, long userId) {

		return getSqlQuery().queryForObject("CA.DIAG_RESULT_SCORE", 
				new Object[]{companyId, runNum, userId}, 
				new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}, String.class);
	}

	public String diagResultStringDao(int runNum, long companyId, long userId) {

		Object obj[] = {companyId, runNum, userId, companyId, runNum, userId, companyId, runNum, companyId, runNum, userId,
						companyId, runNum, userId, companyId, runNum, companyId, runNum, userId, companyId, runNum, companyId, runNum, userId,
						 companyId, runNum, userId};
		
		int type[] = {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
				, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
				, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
				, Types.NUMERIC};
		
		return getSqlQuery().queryForObject("CA.DIAG_RESULT_STRING", obj, type, String.class);
	}

	public List cmpScoreListDao(String runNum, long companyId, long userId) {

		return getSqlQuery().list("CA.COMPETENCY_SCORE_LIST", companyId, runNum, userId);
	}

	public List subjectListDao(String runNum, long companyId, long userId, String year) {

		return getSqlQuery().list("CA.SUBJECT_LIST", companyId,  year);
	}

	public List notSubjectListDao(String runNum, long companyId, long userId, String year) {

		return getSqlQuery().list("CA.NOT_SUBJECT_LIST", companyId, year, userId);
	}

	public List cmpExplanationDao(int runNum, long companyId, long userId) {

		return getSqlQuery().list("CA.COMPETENCY_EXPLANATION_LIST", companyId, runNum, userId, companyId);
	}

	public List subelementResultListDao(int runNum, long companyId, long userId) {

		return getSqlQuery().list("CA.SUBELEMENT_RESULT_LIST", companyId, runNum, userId, companyId, runNum, 
									companyId, runNum, companyId, runNum, userId,
									companyId, runNum, companyId, runNum, userId, companyId, companyId);
	}

	public List subelementExplanationDao(int runNum, long companyId, long userId) {

		return getSqlQuery().list("CA.SUBELEMENT_EXPLANATION_LIST", companyId, runNum, userId, companyId);
	}

	public void udpateCnstFlag(int runNum, long companyId, long userId) {
		
		getSqlQuery().update("CA.UPDATE_CNST_FLAG", companyId, runNum, userId,  companyId, runNum, userId);
		
	}

	public void updateSocialFlag(int runNum, long companyId, long userId) {
		
		getSqlQuery().update("CA.UPDATE_SOCIAL_FLAG", companyId, runNum, userId,  companyId, runNum, userId);
		
	}

	public int cmptDiagInitialization(long companyId, long session, String runNum, String userId) {
		
		int result = getSqlQuery().update("CA.UPDATE_COMPLETE_CANCEL",session, companyId, runNum, userId);
		getSqlQuery().update("CA.UPDATE_COMPLETE_CANCEL2",session, companyId, runNum, userId);
		
		getSqlQuery().update("CA.UPDATE_INDC_SCORE",session, companyId, runNum, userId);
		getSqlQuery().update("CA.UPDATE_CMPT_SCORE",session, companyId, runNum, userId);
		getSqlQuery().update("CA.UPDATE_EXED_CMPT_SCORE",session, companyId, runNum, userId);
		getSqlQuery().update("CA.UPDATE_CMPT_DIRECTION_SCORE",session, companyId, runNum, userId);
		
//		getSqlQuery().update("CA.DELETE_CMPTGROUP_SOCRE", companyId, runNum, userId);
		
		return result;
	}

	public List cmptStatisticsListDao(long companyId, String runNum) {

		return getSqlQuery().list("CA.GET_CMPT_STATISTICS_LIST", companyId, runNum);
	}

	public String getMaxRun(long companyId) {

		return getSqlQuery().queryForObject("CA.GET_CURRENT_RUN_NUM", new Object[]{companyId}, new int[]{Types.NUMERIC}, String.class);
	}
	
	public String getSurvRun(long companyId) {

		return getSqlQuery().queryForObject("CA.GET_SURV_RUN_NULL", new Object[]{companyId}, new int[]{Types.NUMERIC}, String.class);
	}
	
	public String getMaxQstnPoolNo(long companyId) {

		return getSqlQuery().queryForObject("CA.GET_QSTN_POOL_NUM", new Object[]{companyId}, new int[]{Types.NUMERIC}, String.class);
	}
	
	public String getMaxQstnSeq(long companyId) {

		return getSqlQuery().queryForObject("CA.GET_QSTN_NUM", new Object[]{companyId}, new int[]{Types.NUMERIC}, String.class);
	}
	
	public String getMaxppNo(long companyId) {

		return getSqlQuery().queryForObject("CA.GET_SERV_NUM", new Object[]{companyId}, new int[]{Types.NUMERIC}, String.class);
	}

	public String getRunNameDao(long companyId, String runNum) {

		return getSqlQuery().queryForObject("CA.GET_RUN_NAME", new Object[]{companyId, runNum}, new int[]{Types.NUMERIC, Types.NUMERIC}, String.class);
	}
	

	public void deleteCmptDirection(long companyId, String runNum) {
		
		getSqlQuery().update("CA.DELETE_RUN_DIRECTION", companyId, runNum);
		
	}

	public void deleteCmptTarget(long companyId, String runNum) {
		
		getSqlQuery().update("CA.DELETE_RUN_TARGET", companyId, runNum);
	}

	public int insertCmptTarget(List<Object[]> rows) {

		SqlQueryHelper helper = new SqlQueryHelper();
		
		for(Object[] params : rows) {
			helper.parameters(params, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR}).inqueue();
		}
		
		return helper.executeBatchUpdate(getSqlQuery(), "CA.INSERT_RUN_TARGET");
	}

	public void insertCmptDirection(List<Object[]> rows1) {
		
		SqlQueryHelper helper = new SqlQueryHelper();
		
		for(Object[] params : rows1) {
			helper.parameters(params, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC}).inqueue();
		}
		
		helper.executeBatchUpdate(getSqlQuery(), "CA.INSERT_RUN_DIRECTION");
		
	}
	
	//역량 평가자 설정 리스트
	public List cmptTargetListDao(long companyId, String runNum) {

		return getSqlQuery().list("CA.GET_CMPT_TARGET_LIST", companyId, runNum, companyId, runNum, companyId, runNum, companyId, runNum, companyId, companyId);
	}
	
	
	//역량 평가자 설정 리스트V2
	public List cmptTargetListV2Dao(long companyId, String runNum) {

		return getSqlQuery().list("CA.GET_CMPT_TARGET_LIST_V2", companyId, runNum, companyId, runNum, companyId, runNum, companyId, runNum, companyId, runNum, companyId, runNum, companyId, companyId);
	}
	
	
	//역량 평가자 설정 리스트(동료,부하)
	public List cmptListUserDao(long companyid, long pUserid, String colUserid) {
		
		SqlQuery query = getSqlQuery();
		String whereString = "";
		
		String[] colUseridArr = colUserid.split(",");
		
		for(int i = 0; i < colUseridArr.length; i ++){
			
			whereString += ""+colUseridArr[i].trim()+",0";
			
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("QUERY_WHERE", whereString);
		query.setAdditionalParameters(map);
		return query.list("CA.GET_CMPT_LIST_USER", companyid, companyid, pUserid);
	}
	
	//역량 평가자 설정 평가자 리스트
	public List cmptTargetUserDao(long companyId, int dvsId, int highDvsId) {
		return getSqlQuery().list("CA.GET_CMPT_TARGET_USER", companyId, companyId, dvsId, highDvsId, companyId);
	}	

	public List cmptDiagnosisListDao(long companyId) {

		return getSqlQuery().list("CA.GET_CMPT_DIAG_LIST", companyId);
	}


	public int insertRun(long companyId, String runNum, String evlType, String runName, Date runStart, Date runEnd, String sClass, String aClass, String bClass
			, String cClass, String dClass, long userId, String selfWeight, String oneWeight
			, String twoWeight, String colWeight, String subWeight, String yyyy, String evlPrdType, String useFlag) throws CAException {

		return getSqlQuery().update("CA.INSERT_CAM_RUN", companyId, runNum, evlType, runName, runStart, runEnd, sClass, aClass, bClass, cClass, dClass, userId,
				selfWeight, oneWeight, twoWeight, colWeight, subWeight, yyyy, evlPrdType, useFlag );
		
	}

	public int updateRun(String useFlag, String evlType, String runName, Date runStart, Date runEnd, String selfWeight, String oneWeight, String twoWeight, String colWeight, String subWeight,
			String sClass, String aClass, String bClass, String cClass, String dClass, long userId, String runNum, long companyId, String yyyy, String evlPrdType) throws CAException {

		return getSqlQuery().update("CA.UPDATE_CAM_RUN", useFlag, evlType,  runName, runStart, runEnd, selfWeight, oneWeight, twoWeight, colWeight, subWeight,
				sClass, aClass, bClass, cClass, dClass, userId, yyyy, evlPrdType, companyId, runNum );
	}

	public void deleteCmptWeight(long companyId, String runNum) throws CAException {
		
		getSqlQuery().update("CA.DELETE_CMPT_WEIGHT", companyId, runNum );
	}

	public int insertCmptWeight(long companyId, String runNum, String cmpnumber, String weight, long userId) throws CAException {

		return getSqlQuery().update("CA.INSERT_CMPT_WEIGHT", companyId, runNum, cmpnumber, weight);
	}

	public String getMaxcmpNum() {
		return getSqlQuery().queryForObject("CA.GET_MAX_CMP_NUM", new Object[]{}, new int[]{}, String.class);
	}


	public List consistencyListDao(long companyId) {

		return getSqlQuery().list("CA.GET_CONSISTENCY_LIST", companyId);
	}

	//public List getSubelementAllListDao(long company) {

	//	return getSqlQuery().list("CA.GET_SUBELEMENT_ALL_LIST", company);
	//}


	public List getSubjectCompDiagList(int startIndex, long userId, long companyId) {
		return getSqlQuery().list("CA.USER_RUN_MAP_SELECT",  companyId, userId, startIndex, startIndex);
	}
	
	
	
	public List<Map<String, Object>> getCompDiagResultList(String run_num,
			long companyId, long userId) {
		return getSqlQuery().list("CA.USER_DIAG_RESULT_LIST",  companyId, run_num, userId );
	}

	public int getSubjectCompDiagListCnt(long userId, long companyId) {
		return getSqlQuery().queryForObject("CA.USER_RUN_MAP_SELECT_CNT", new Object[]{companyId, userId}, 
																new int[]{Types.NUMERIC, Types.NUMERIC}, Integer.class);
	}
	
	public List getIndicatorList(long companyId) {
		return getSqlQuery().list("CA.INDICATOR_SELECT", companyId);
	}
	
	public int getRunResultFlag(int runNum, long userid, long companyId){
		return getSqlQuery().queryForObject("CA.GET_RUN_RESULT_COUNT", new Object[]{companyId, runNum, userid}, 
																new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}, Integer.class);
	}
	
	public List getIndicatorListReSelect(int runNum, long userid, long companyId){
		return getSqlQuery().list("CA.INDICATOR_RE_SELECT", companyId, runNum, userid);
	}
	
	public List getExampleList(long companyId) {
		return getSqlQuery().list("CA.INDICATOR_EXAMPLE_SELECT", companyId);
	}
	
	public List getExampleList(long companyId, String cmpNumber, String bhvIndcNum) {
		return getSqlQuery().list("CA.INDICATOR_EXAMPLE_SELECT_TEST", companyId, cmpNumber, bhvIndcNum);
	}
	
	public List getIndcScoreList(long companyId, String cmpNumber, String bhvIndcNum, int runNum, long userId) {
		return getSqlQuery().list("CA.INDICATOR_SCORE_SELECT", companyId, runNum, userId, cmpNumber, bhvIndcNum );
	}
	
	public List getHistoryList(User user) {

		return getSqlQuery().list("CA.SELECT-CALIST",user.getCompanyId(),user.getUserId());
	}

	
	public List getSlfAsstQustDtlList(Map map) {

		String run_num = (String)map.get("run_num");
		String userid_ex = (String)map.get("userid_ex");
		String userid_exed = (String)map.get("userid_exed");
		String self_flag = (String)map.get("self_flag");

		return getSqlQuery().list("CA.SELECT-DIAGNOSIS-ASSESSMENT-EXAMPLE", run_num,userid_ex,userid_exed);
	}


	public List getSlfAsstQustList(Map map) {
		
		return getSqlQuery().list("CA.SELECT-SELF-DIAGNOSIS-ASSESSMENT");
	}

	public List getMltExtList(Map map, Integer code) {

		return null;
	}

	// 행동지표별 진단결과 저장
	public void asstSlfAnwsSave(long companyId, String cmpNumber, String bhvIndcNum, String subelementNum, int runNum, 
            String userIdEx, String userIdExed, String exmScore, String exampleNum, String questionSeq, long userId) throws CAException {
		
		try {
			getSqlQuery().update("CA.INSERT_QUESTION_EXAMPLE", companyId, cmpNumber, bhvIndcNum, subelementNum, runNum,
									userIdEx, userIdExed, exmScore, companyId, runNum, cmpNumber,  exampleNum,  questionSeq, userId);
				
		}catch(Exception e){
			throw new CAException( e );
		}
	}
	
	//역량진단 대상자 저장
	public void saveRunTarget(int runNum, long companyId, long userId) throws CAException {
		try{			
			getSqlQuery().update("CA.MERGE_RUN_TARGET", companyId, runNum, userId, userId);
			
		}catch(Exception e){
			throw new CAException( e );
		}
	}
	
	//역량진단 방향 저장
	public void saveRunDirection(int runNum, long companyId, long userId) throws CAException {
		try {
			getSqlQuery().update("CA.MERGE_RUN_DIRECTION", companyId, runNum, userId, userId, userId);
			
		}catch(Exception e){
			throw new CAException( e );
		}
		
	}

	public void asstSlfAnwsDlt(int runNum, long companyId, long userId) throws CAException {
		
		getSqlQuery().update("CA.DELETE_SELF_QUESTION_EXAMPLE",companyId,runNum, userId);
	
	}

	public void asstSlfAnwsDrctn(int runNum, long companyId, long userId) throws CAException {


		getSqlQuery().update("CA.INSERT_ASSESSMENT_RESULT", userId, runNum, userId);
		getSqlQuery().update("CA.CMPTGROUP_SCORE_RESULT", userId, runNum, userId);
		getSqlQuery().update("CA.UPDATE_ASSESSMENT_RESULT",userId,companyId,runNum,userId);
	}
	
	 

	public List getCACmptCmpr(int runNum, long userId, long companyId) {
		
		return getSqlQuery().list("CA.SELECT_CMPT_CMPR_LIST", companyId, companyId, runNum, userId, companyId, runNum, companyId, runNum, 
					companyId, runNum, userId, companyId, runNum, companyId, runNum, userId);
	
	}

	public List getGrwList(int runNum, long userId, long companyId) {
		
		return getSqlQuery().list("CA.SELECT_RESULT_CMPT_GROW_LIST",companyId, runNum,  userId, companyId, runNum, companyId, runNum,  userId, companyId,  userId);
	}
	
	public List getGrwSubjectList(int runNum, long userId, long companyId) {
		return getSqlQuery().list("CA.SELECT_RESULT_CMPT_GROW_SUBJECT_LIST", companyId, runNum, userId, companyId, runNum,  userId, runNum, companyId);
	}
	
	public int insertCompetency(String cmpNumber, String cmpGroup, String cmpName, String cmpDefinition, String bsnsReqrLevel, String useFlag, 
					long userId,  long companyId) {
		
		return getSqlQuery().update("CA.INSERT_CM_COMPETENCY", companyId, cmpNumber, cmpGroup, cmpName, cmpDefinition, bsnsReqrLevel, useFlag, userId);
	}
	
	public int updateCompetency(String cmpNumber, String cmpGroup, String cmpName, String cmpDefinition, String bsnsReqrLevel, String useFlag, 
					long userId,  long companyId) {
		
		return getSqlQuery().update("CA.UPDATE_CM_COMPETENCY", cmpGroup, cmpName, cmpDefinition, bsnsReqrLevel, useFlag, userId, companyId, cmpNumber);
	}
	//역량관리 리스트
	public List getIndicatorListDao(long companyId) {
		return getSqlQuery().list("CA.GET_INDC_LIST", companyId);
	}
	//역량관리 리스트(고객사)
	public List getOperatorIndicatorListDao(long companyId) {
		return getSqlQuery().list("CA.GET_OPERATOR_INDC_LIST", companyId);
	}
	//역량관리 리스트 카운트
	public int getIndicatorListCount( long companyId) {
		
		List list = getSqlQuery().list("CA.GET_INDC_LIST", companyId);
		
		return list.size();
	}
	//역량관리 리스트 카운트(고객사)
	public int getOperatorIndicatorListCount( long companyId) {
		
		List list = getSqlQuery().list("CA.GET_OPERATOR_INDC_LIST", companyId);
		
		return list.size();
	}

	public List getCompetencyComboList(long companyId) {
		
		return getSqlQuery().list("CA.GET_COMPETENCY_COMBO_LIST",companyId);
	}
	
//	public List getIndicatorExampleListDao(int cmpNumber, int  bhvIndcNum, long companyId) {
//		
//		return getSqlQuery().list("CA.GET_INDC_EXAMPLE_LIST",companyId, cmpNumber, bhvIndcNum);
//	}
	
//	public List getOperatorIndicatorExampleListDao(int cmpNumber, int  bhvIndcNum, long companyId) {
//		
//		return getSqlQuery().list("CA.GET_OPERATOR_INDC_EXAMPLE_LIST",companyId, cmpNumber, bhvIndcNum);
//	}
	
	
	
	public List<Map<String, Object>> getMailInfoList(long companyId,
			String userId) {
		return getSqlQuery().list("CA.GET_MAIL_INFO",companyId, companyId, userId);
	}

	public int insertIndicator(long companyId, String cmpNumber, String bhvIndcNum,  String bhvIndicator,  String useFlag, long userId, 
									 String exceptionFlag) throws CAException{
		
		return getSqlQuery().update("CA.INSERT_CM_INDICATOR",companyId, cmpNumber, bhvIndcNum,  bhvIndicator, 
													useFlag, userId+"", exceptionFlag);
	}
	
	public int operatorInsertIndicator(long companyId, String cmpNumber, String bhvIndcNum,  String bhvIndicator,  String useFlag, long userId, 
			 String exceptionFlag) throws CAException{

		return getSqlQuery().update("CA.OPERATOR_INSERT_CM_INDICATOR",companyId, cmpNumber, bhvIndcNum,  bhvIndicator, 
							useFlag, userId+"", exceptionFlag);
	}
	

	public int updateIndicator(String bhvIndicator, String useFlag, long userId,
											String exceptionFlag, long companyId, String  cmpNumber, String bhvIndcNum) throws CAException {
		
		return getSqlQuery().update("CA.UDPATE_CM_INDICATOR",bhvIndicator, useFlag, userId,exceptionFlag, companyId, cmpNumber, bhvIndcNum);
	}
	
	public int operatorUpdateIndicator(String bhvIndicator, String useFlag, long userId,
			String exceptionFlag, long companyId, String  cmpNumber, String bhvIndcNum) throws CAException {

		return getSqlQuery().update("CA.OPERATOR_UDPATE_CM_INDICATOR",bhvIndicator, useFlag, userId,
															    companyId, cmpNumber, bhvIndcNum);
	}
	
	
//	public int deleteExample(long companyId, String cmpNumber, String bhvIndcNum) throws CAException {
//		
//		return getSqlQuery().update("CA.DELETE_CM_EXAMPLE",companyId, cmpNumber, bhvIndcNum);
//	}
	
//	public int insertExample(long companyId, String cmpNumber, String bhvIndcNum, String example, String exmOrder, String exmScore, long userId) throws CAException {
//		
//		return getSqlQuery().update("CA.INSERT_CM_EXAMPLE",companyId, cmpNumber, bhvIndcNum, companyId, cmpNumber, bhvIndcNum,
//													example, exmOrder, exmScore, userId);
//	}
	
//	public int operatorInsertExample(long companyId, String cmpNumber, String bhvIndcNum, String example, String exmOrder, String exmScore, long userId) throws CAException {
//		
//		return getSqlQuery().update("CA.OPERATOR_INSERT_CM_EXAMPLE",companyId, cmpNumber, bhvIndcNum, companyId, cmpNumber, bhvIndcNum,
//													example, exmOrder, exmScore, userId);
//	}
	
	public int QuestionSaveCnt(int runNum, long userId, long companyId){
		
		return getSqlQuery().queryForObject("CA.GET_QUESTION_SAVE_CNT", new Object[]{companyId, runNum, userId},  
				new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}, Integer.class);
	}

//	public int operatorDeleteExample(long companyId, String cmpNumber, String bhvIndcNum) throws CAException {
//		
//		return getSqlQuery().update("CA.OPERATOR_DELETE_CM_EXAMPLE",companyId, cmpNumber, bhvIndcNum);
//	}
	
	//역량매핑 리스트
	public List getOperatorCompetencyMappingListDao(long companyId, String jobLdrNum) {
		return getSqlQuery().queryForList("CA.GET_OPERATOR_CMPT_MAPP_LIST", new Object[]{companyId,jobLdrNum,companyId});
	}
	
	//역량매핑 엑셀조회
	public List getcaOperatorCmptMappExcelDao(long companyId) {
		return getSqlQuery().list("CA.GET_MAPP_LIST_EXCEL", companyId,companyId,companyId);
	}
	
	public int mergeCompetencyMappingDao(long companyId, String jobLdrNum,
			String cmpNumber, String checkFlag) {

		return getSqlQuery().update("CA.GET_OPERATOR_CMPT_MAPP_MERGE", companyId, jobLdrNum, cmpNumber, checkFlag);
	}
	
	public int mergSbjctCmMappingDao(long companyId, String subjectNum, String cmpNumber,
			String checkFlag) {

		return getSqlQuery().update("CA.INSERT_SBJCT_CM_MAPPING", companyId, subjectNum, cmpNumber, checkFlag);
	}
	
	public int mergeSbjctOpenDetail(long companyId, String subjectNum,
			String chasu, Date eduStime, Date eduEtime, String year) {

		return getSqlQuery().update("CA.MERGE_SBJCT_OPEN_DETAIL", subjectNum, year, chasu, companyId, eduStime, eduEtime, companyId, year);
	}
	 
	public int mergeCmptTargetDao(long companyId, String runNum,
			String divisionId, String userId, String job, String leadership,
			long sessionId, String checkFlag) {

		return getSqlQuery().update("CA.GET_CMPT_TARGET_MERGE", companyId, runNum, userId, divisionId , job, leadership, sessionId, checkFlag);
	}
	
	public int mergeQstnPooltDao(String qstnPoolNo, String qstnTypeCd,
			String qstn, long companyId, long sessionId) {

		return getSqlQuery().update("CA.GET_QSTN_POOL_MERGE", companyId, qstnPoolNo, qstnTypeCd, qstn , sessionId);
	}
	
	public int mergeQstnRsttDao(long companyId, String ppNo, long sessionId,
			String qstnSeq, String svRst) {

		return getSqlQuery().update("CA.GET_QSTN_RST_MERGE", companyId, ppNo, sessionId, qstnSeq , svRst);
	}
	
	public int updateQstnRsttDao(String age, String gender, long companyId, String ppNo, long sessionId) {

		return getSqlQuery().update("CA.GET_QSTN_RST_UPDATE", age, gender, companyId, ppNo, sessionId );
	}
	
	public int mergeQstnDao(String qstnSeq, String qstnTypeCd, String qstn,
			long companyId, long sessionId, String ppNo) {

		return getSqlQuery().update("CA.GET_QSTN_MERGE", companyId, ppNo, qstnSeq, qstnTypeCd, qstn , sessionId);
	}
	
	public int mergeServUserDao(String userId, String ppNo, long companyId,
			long sessionId) {

		return getSqlQuery().update("CA.GET_SERV_USER_MERGE", userId, ppNo, companyId, sessionId);
	}
	
	public int mergeServPpDao(String ppNo, String ppNm, String ppPerp,
			Date ppSt, Date ppEd, long companyId, long sessionId,  String useFlag) {

		return getSqlQuery().update("CA.GET_SERV_PP_MERGE", companyId, ppNo, ppNm, ppPerp , ppSt, ppEd, sessionId, useFlag);
	}
	
	public int updateQstnPooltDao(long sessionId, String qstnPoolNo, long companyId) {

		return getSqlQuery().update("CA.GET_QSTN_POOL_UPDATE",sessionId, companyId, qstnPoolNo);
	}
	
	public int updateQstnDao(long sessionId, String ppNo, long companyId,
			String qstnSeq) {

		return getSqlQuery().update("CA.GET_QSTN_UPDATE",sessionId, ppNo, companyId, qstnSeq);
	}
	
	public int updateServPpDao(long sessionId, String ppNo, long companyId) {

		return getSqlQuery().update("CA.GET_SERV_PP_UPDATE",sessionId, ppNo, companyId);
	}
	
	public int updateQstnUserDao(long sessionId, String ppNo, long companyId,
			String userId) {

		return getSqlQuery().update("CA.GET_QSTN_USER_UPDATE",sessionId, ppNo, companyId, userId);
	}
	
	
	public int mergeCmptDirectionSelfDao(long companyId, String runNum,
			String userId, long sessionId, String selfWeight, String checkFlag) {

		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_SELF_MERGE", companyId, runNum, userId, userId , sessionId, selfWeight, checkFlag);
	}
	
	
	
	public void initCmptDirectionUserDao(long sessionId, long companyId, String runNum, String userId) {
		 getSqlQuery().update("CA.GET_CMPT_DIRECTION_USER_INIT", sessionId, companyId, runNum, userId);
	}
	
	public void delCmptDirectioncolDao(long sessionId, long companyId,
			String runNum, String userId) {

		 getSqlQuery().update("CA.GET_CMPT_DIRECTION_COL_DEL", sessionId, companyId, runNum, userId);
	}
	
	public void delCmptDirectionsubDao(long sessionId, long companyId,
			String runNum, String userId) {

		 getSqlQuery().update("CA.GET_CMPT_DIRECTION_SUB_DEL", sessionId, companyId, runNum, userId);
	}
	
	public int mergeCmptDirectioncolDao(long companyId, String runNum,
			String colUserIdTmp, String userId, long sessionId,
			String colWeight, String checkFlag) {

		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_COL_MERGE", companyId, runNum, colUserIdTmp, userId , sessionId, colWeight, checkFlag);
	}
	
	public int mergeCmptDirectionsubDao(long companyId, String runNum,
			String subUserIdTmp, String userId, long sessionId,
			String subWeight, String checkFlag) {

		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_SUB_MERGE", companyId, runNum, subUserIdTmp, userId , sessionId, subWeight, checkFlag);
	}
	
	public int mergeCmptDirectionOneDao(long companyId, String runNum,
			String oneUserId, String userId, long sessionId, String oneWeight,
			String checkFlag) {

		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_ONE_MERGE", companyId, runNum, oneUserId, userId , sessionId, oneWeight, checkFlag);
	}
	
	
	public int mergeCmptDirectionTwoDao(long companyId, String runNum,
			String twoUserId, String userId, long sessionId, String twoWeight,
			String checkFlag) {

		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_TWO_MERGE", companyId, runNum, twoUserId, userId , sessionId, twoWeight, checkFlag);
	}
	
	public int updateCmptTargetDao(String checkFlag, long sessionId, long companyId, String runNum) {

		return getSqlQuery().update("CA.GET_CMPT_TARGET_UPDATE", checkFlag, sessionId, companyId, runNum);
	}	

	public int updateCmptTargetUserDao(String checkFlag, long sessionId, long companyId, String runNum, String userid) {

		return getSqlQuery().update("CA.GET_CMPT_TARGET_INIT", checkFlag, sessionId, companyId, runNum, userid);
	}	

	public int updateCmptDirectionDao(String checkFlag, long companyId, String runNum, long sessionId) {
		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_UPDATE", checkFlag, sessionId, companyId, runNum);
	}	
	
	public int updateCmptDirectionSelfDao(String checkFlag, long companyId,
			String runNum, String userId, long sessionId) {

		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_SELF_UPDATE", checkFlag, sessionId, companyId, runNum, userId, userId);
	}	
	
	public int updateCmptDirectioncolDao(String checkFlag, long companyId,
			String runNum, String userId, long sessionId) {

		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_COL_UPDATE", checkFlag, sessionId, companyId, runNum, userId);
	}	
	
	public int updateCmptDirectionsubDao(String checkFlag, long companyId,
			String runNum, String userId, long sessionId) {

		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_SUB_UPDATE", checkFlag, sessionId, companyId, runNum, userId);
	}	
	
	public int updateCmptDirectionOneDao(String checkFlag, long companyId,
			String runNum, String oneUserId, String userId, long sessionId) {

		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_ONE_UPDATE", checkFlag, sessionId, companyId, runNum, oneUserId, userId);
	}	
	
	public int updateCmptDirectionTwoDao(String checkFlag, long companyId,
			String runNum, String twoUserId, String userId, long sessionId) {

		return getSqlQuery().update("CA.GET_CMPT_DIRECTION_TWO_UPDATE", checkFlag, sessionId, companyId, runNum, twoUserId, userId);
	}	
	
	public int updateCompetencyMappingDao(long companyId, String jobLdrNum,
			String cmpNumber, String checkFlag) {

		return getSqlQuery().update("CA.GET_OPERATOR_CMPT_MAPP_UPDATE", checkFlag, companyId, jobLdrNum, cmpNumber);
	}
	
	public int updateSbjctCmMappingDao(long companyId, String subjectNum, String cmpNumber,
			String checkFlag) {

		return getSqlQuery().update("CA.UPDATE_SBJCT_CM_MAPPING", checkFlag, subjectNum, companyId, cmpNumber);
	}
	
	public int mergeSbjctOpenDao(String subjectName, String trainingCode,
			String institueName, String eduTarget, String eduObject,
			String course_cont, long companyId, String subjectNum, String useFlag, String sampleUrl) {

		return getSqlQuery().update("CA.INSERT_SBJCT_OPEN", subjectName, trainingCode, institueName, eduTarget, eduObject, course_cont, companyId, subjectNum, companyId, useFlag, sampleUrl);
	}
	
	public int upSbjctOpenDao(String subjectName, String trainingCode,
			String institueName, long companyId, String subjectNum,
			String useFlag, String eduTarget, String eduObject, String courseContents, String sampleUrl) {

		return getSqlQuery().update("CA.UP_SBJCT_OPEN", subjectName, trainingCode, institueName, eduTarget, eduObject ,courseContents, companyId, subjectNum, companyId, useFlag, sampleUrl);
	}
	
	public int upSbjctDetailDao(String subjectNum, String year, String chasu,
			long companyId, String eduStime, String eduEtime) {

		return getSqlQuery().update("CA.UP_SBJCT_OPEN_DETAIL", subjectNum, year, chasu, companyId, eduStime, eduEtime, companyId, year);
	}
	
	public int upSbjctMappDao(String subjectNum, String cmpNum, long companyId,
			String useFlag) {

		return getSqlQuery().update("CA.UP_SBJCT_MAPP", companyId, subjectNum, cmpNum, useFlag);
	}
	
	public int insertSbjctOpenDao(String subjectName, String trainingCode,
			String institueName, String eduTarget, String eduObject,
			String course_cont, long companyId, String useFlag, String sampleUrl) {

		return getSqlQuery().update("CA.INSERT_SBJCT_DETAIL", companyId, subjectName, trainingCode, institueName, eduTarget, eduObject, course_cont, companyId, useFlag, sampleUrl);
	}
	
	public int delSbjectOpen(String subjectNum, String year, String chasu,
			long companyId) {

		return getSqlQuery().update("CA.DEL_SBJCT_OPEN", subjectNum, year, chasu, companyId);
	}
	
	public int getMaxKpiNo(){
		return getSqlQuery().queryForObject("CA.SELECT_MAX_SEQ_KPI_NO", new Object[]{}, new int[]{}, Integer.class);
	}
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws CAException {
		if(params!=null) {
			return getSqlQuery().queryForObject(statement, params, jdbcTypes, Integer.class);
		} else {
			return getSqlQuery().queryForObject(statement, Integer.class);
			
		}
	}
	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws CAException {
		
		SqlQueryHelper helper = new SqlQueryHelper();
		
		for(Object[] params : parameteres) {
			helper.parameters(params, jdbcTypes).inqueue();
		}
		
		return helper.executeBatchUpdate(getSqlQuery(), statement);
	}
	
	
	/**
	 * 자동방향설정 프로시져 호출
	 * @param companyid 회사ID
	 * @param userid 작업자ID
	 * @param runNum 진단실시번호
	 * @return
	 * @throws CAException
	 */
	public int setRunDirAutoUser(long companyid, long userid, int runNum) throws CAException {
		log.debug("## CADao setRunDirAutoUser start..........");
		
		// 데이터소스를 이용해 프로시져 호출
		SimpleJdbcCall call = new SimpleJdbcCall(getDataSource()).withProcedureName("PROC_AUTO_SET_RUNDIRECTION");
		// 프로시져에서 맵핑될 파라메터 셋팅
		SqlParameterSource in = new MapSqlParameterSource().addValue("i_companyid", companyid).addValue("i_run_num", runNum).addValue("i_ss_userid", userid);
		// 프호시져 호출
		Map<String, Object> result = call.execute(in);
		/*
		Set<String> keyset = result.keySet();
		for(Iterator ite = keyset.iterator(); ite.hasNext();) {
			String key = (String)ite.next();
			log.debug("## result [" + key + "] :: " + result.get(key));
		}
		*/
		// 프로시져 결과 확인, 결과는 프로시져에 설정된 out 의 key 로 반환됨(대문자)
		if(result.get("RESULT")!=null) {
			log.debug("## CADao setRunDirAutoUser result :: " + result.get("result"));
		
			if(result.get("RESULT").equals("SUCCESS")) {
				return 1;
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	}
	
}