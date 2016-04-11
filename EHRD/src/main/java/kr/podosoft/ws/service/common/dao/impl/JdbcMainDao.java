package kr.podosoft.ws.service.common.dao.impl;

import java.io.InputStream;
import java.sql.Types;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import architecture.ee.jdbc.sqlquery.SqlQuery;
import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.jdbc.sqlquery.factory.SqlQueryFactory;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;
import architecture.ee.web.util.WebApplicationHelper;

import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.common.dao.MainDao;

public class JdbcMainDao extends SqlQueryDaoSupport implements MainDao {
	
	public InputStream queryForInputStream(String statement, Object[] params, int[] jdbcTypes) {
		return getSqlQuery().queryForObject(statement,  params,  jdbcTypes, 
				 architecture.ee.jdbc.sqlquery.SqlQueryHelper.getInputStreamRowMapper());
	}
	
	public Object queryForObject(String statement, Object[] params,	int[] jdbcTypes, Class elementType){
		return getSqlQuery().queryForObject(statement, params, jdbcTypes, elementType);
	}
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CommonException {

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

	public List<Map<String, Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws CommonException {
			
		List<Map<String, Object>> list = Collections.EMPTY_LIST;
		try {
			if(params!=null) {
				list = getSqlQuery().setStartIndex(startIndex).setMaxResults(maxResults).queryForList(statement, params, jdbcTypes);
			} else {
				list = getSqlQuery().setStartIndex(startIndex).setMaxResults(maxResults).queryForList(statement);
			}
		} catch(Throwable e) {
			log.error(e);
		}
		
		return list;
	}
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws CommonException {
		
		return getSqlQuery().queryForObject(statement, params, jdbcTypes, Integer.class);
	}

	public int update(String statement, Object[] params, int[] jdbcTypes) throws CommonException {

		return getSqlQuery().update(statement, params, jdbcTypes);
	}


	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws CommonException {
		
		SqlQueryHelper helper = new SqlQueryHelper();
		
		for(Object[] params : parameteres) {
			helper.parameters(params, jdbcTypes).inqueue();
		}
		
		return helper.executeBatchUpdate(getSqlQuery(), statement);
	}
	
	public List<Map<String,Object>> getMainTimeLineList(long companyid, long userid, int startIndex, int pageSize, int sdclass) throws CommonException {
		List<Map<String,Object>> list = Collections.EMPTY_LIST;
		try {
			SqlQueryFactory client = WebApplicationHelper.getComponent(SqlQueryFactory.class);
			SqlQuery query = client.createSqlQuery();
			
			Map<String,Object> additionalParameters = new HashMap<String,Object>();
			
			if(sdclass>0) {
				additionalParameters.put("WHERE_CLASS1", "AND C.SDCLASS = '"+sdclass+"'");
				additionalParameters.put("WHERE_CLASS2", "AND B.CURRENT_CLASS = '"+sdclass+"'");
				additionalParameters.put("WHERE_CLASS3", "AND BC.CURRENT_CLASS = '"+sdclass+"'");
				additionalParameters.put("WHERE_CLASS4", "AND A.SD_CLASS = '"+sdclass+"'");
			} else {
				additionalParameters.put("WHERE_CLASS1", "");
				additionalParameters.put("WHERE_CLASS2", "");
				additionalParameters.put("WHERE_CLASS3", "");
				additionalParameters.put("WHERE_CLASS4", "");
			}
			
			query.setAdditionalParameters(additionalParameters);
			
			list = query.setStartIndex(startIndex+1).setMaxResults(pageSize).queryForList("COMMON.SELECT_MAIN_TIMELINE",
					new Object[] {
						companyid, companyid, userid, 
						companyid, userid, 
						companyid, companyid, userid, 
						userid, userid, userid, userid
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER, 
						Types.INTEGER, Types.INTEGER,
						Types.INTEGER, Types.INTEGER, Types.INTEGER,
						Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER
					});
		} catch(Throwable e) {
			log.error(e);
		}
		
		return list;
	}
	
	public int getMainTimeLineCnt(long companyid, long userid, int sdclass) throws CommonException {
		int result = 0;
		try {
			SqlQueryFactory client = WebApplicationHelper.getComponent(SqlQueryFactory.class);
			SqlQuery query = client.createSqlQuery();
			
			Map<String,Object> additionalParameters = new HashMap<String,Object>();
			
			if(sdclass>0) {
				additionalParameters.put("WHERE_CLASS1", "AND C.SDCLASS = '"+sdclass+"'");
				additionalParameters.put("WHERE_CLASS2", "AND B.CURRENT_CLASS = '"+sdclass+"'");
				additionalParameters.put("WHERE_CLASS3", "AND BC.CURRENT_CLASS = '"+sdclass+"'");
				additionalParameters.put("WHERE_CLASS4", "AND A.SD_CLASS = '"+sdclass+"'");
			} else {
				additionalParameters.put("WHERE_CLASS1", "");
				additionalParameters.put("WHERE_CLASS2", "");
				additionalParameters.put("WHERE_CLASS3", "");
				additionalParameters.put("WHERE_CLASS4", "");
			}
			
			query.setAdditionalParameters(additionalParameters);
			
			result = query.queryForObject("COMMON.SELECT_MAIN_TIMELINE_CNT",
					new Object[] {
						companyid, userid, companyid, userid, userid,
						userid, userid, userid, userid
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER,
						Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER
					
					},
					Integer.class);
		} catch(Throwable e) {
			log.error(e);
		}
		return result;
	}

}