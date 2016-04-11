package kr.podosoft.ws.service.em.dao.impl;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.em.dao.EmDao;
import kr.podosoft.ws.service.em.EmServiceException;

import architecture.ee.jdbc.sqlquery.SqlQuery;
import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.jdbc.sqlquery.factory.SqlQueryFactory;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;
import architecture.ee.web.util.WebApplicationHelper;

public class JdbcEmDao extends SqlQueryDaoSupport implements EmDao {

	public JdbcEmDao() {
		
	}
	
	public Object queryForObject(String statement, Object[] params,	int[] jdbcTypes, Class elementType){
		return getSqlQuery().queryForObject(statement, params, jdbcTypes, elementType);
	}

	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes){

		List<Map<String, Object>> list = Collections.EMPTY_LIST;
		try {
			if(params != null) {
				list = getSqlQuery().queryForList(statement, params, jdbcTypes);
			} else {
				list = getSqlQuery().queryForList(statement);
			}
		} catch (Throwable e) {
			log.error(e);
		}

		return list;
	}
	
	public int update(String statement, Object[] params, int[] jdbcTypes)
			throws EmServiceException {
		int result = 0;
		try {
			result = getSqlQuery().update(statement, params, jdbcTypes);
		} catch (Throwable e) {
			log.error(e);
		}

		return result;
	}

	public int update(String statement, Object[] params, int[] jdbcTypes, Map map)
			throws EmServiceException {
		int result = 0;
		try {
			SqlQueryFactory client = WebApplicationHelper.getComponent(SqlQueryFactory.class);
			SqlQuery query = client.createSqlQuery();
			
			if(map!=null){
				query.setAdditionalParameters(map);
			}
			result = query.update(statement, params, jdbcTypes);
		} catch (Throwable e) {
			log.error(e);
		}
		return result;
	}
	
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws EmServiceException {
		return getSqlQuery().executeUpdate(statement, params);
	}
	
	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws EmServiceException {
		SqlQueryHelper helper = new SqlQueryHelper();
		
		for(Object[] params : parameteres) {
			helper.parameters(params, jdbcTypes).inqueue();
		}
		
		return helper.executeBatchUpdate(getSqlQuery(), statement);
	}
	
	
	public List<Map<String, Object>> selectEduSttList(long companyid, long userid, int year, int type, String bdate){

		List<Map<String, Object>> list = Collections.EMPTY_LIST;
		try {
			SqlQuery query = getSqlQuery();
			
			Map<String, Object> dynamicMap = new HashMap<String, Object>();
			
			StringBuffer sb1 = new StringBuffer();
			StringBuffer sb2 = new StringBuffer();
			if(type==2 || type==3) {
				// 현직급 승진교육이수목록 조회
				sb1.append(" AND BSOC.TIME_GRADE_NUM = (SELECT GRADE_NUM FROM TB_BA_USER WHERE USERID = ").append(userid).append(" ) "); // 현 직급 시 교육이력으로 제한
				sb1.append("\n AND BSOC.ATTEND_STATE_CODE = '5' "); // 수료한 교육이력만
				sb1.append("\n AND BSOC.REQ_STS_CD = '2' "); // 승인완료 상태만
				
				sb2.append(" AND EASU.GRADE_NUM = (SELECT GRADE_NUM FROM TB_BA_USER WHERE USERID = ").append(userid).append(" ) "); // 현 직급 시 교육이력으로 제한
			} 
			// 교육훈련결과 승진교육달성현황에서는 기준일 추가입력
			if(type==3) {
				sb1.append("\n AND TO_CHAR(BSO.EDU_ETIME,'YYYYMMDD') <= ");
				if(bdate!=null && !bdate.equals("")) {
					sb1.append("'").append(bdate.replaceAll("-", "")).append("'");
				} else {
					sb1.append("TO_CHAR(SYSDATE, 'YYYYMMDD') ");
				}
				
				sb2.append("\n AND TO_CHAR(EAS.EDU_ETIME,'YYYYMMDD') <= ");
				if(bdate!=null && !bdate.equals("")) {
					sb2.append("'").append(bdate.replaceAll("-", "")).append("'");
				} else {
					sb2.append("TO_CHAR(SYSDATE, 'YYYYMMDD') ");
				}
			}
			
			dynamicMap.put("QUERY_WHERE", sb1.toString());
			dynamicMap.put("QUERY_WHERE2", sb2.toString());
			
			query.setAdditionalParameters(dynamicMap);

			list = query.list("EM.SELECT_EDU_STT_LIST", 
					companyid, companyid, companyid, companyid, userid,
					companyid, companyid, companyid, userid);
			
		} catch (Throwable e) {
			log.error(e);
		}

		return list;
	}

	
	
}
