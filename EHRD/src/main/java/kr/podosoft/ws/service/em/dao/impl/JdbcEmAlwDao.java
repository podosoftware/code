package kr.podosoft.ws.service.em.dao.impl;

/**
 * 교육훈련 > 상시학습
 */

import java.util.Collections;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.em.dao.EmAlwDao;
import kr.podosoft.ws.service.em.EmServiceException;

import architecture.ee.jdbc.sqlquery.SqlQuery;
import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.jdbc.sqlquery.factory.SqlQueryFactory;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;
import architecture.ee.web.util.WebApplicationHelper;

public class JdbcEmAlwDao extends SqlQueryDaoSupport implements EmAlwDao {

	public JdbcEmAlwDao() {
		
	}
	
	public Object queryForObject(String statement, Object[] params,	int[] jdbcTypes, Class elementType){
		if(params!=null)		
			return getSqlQuery().queryForObject(statement, params, jdbcTypes, elementType);
		else 
			return getSqlQuery().queryForObject(statement, elementType);
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
	
	public int update(String statement, Object[] params, int[] jdbcTypes) throws EmServiceException {
		int result = 0;
		result = getSqlQuery().update(statement, params, jdbcTypes);
		return result;
	}

	public int update(String statement, Object[] params, int[] jdbcTypes, Map map) throws EmServiceException {
		int result = 0;
		SqlQueryFactory client = WebApplicationHelper.getComponent(SqlQueryFactory.class);
		SqlQuery query = client.createSqlQuery();
		
		if(map!=null){
			query.setAdditionalParameters(map);
		}
		result = query.update(statement, params, jdbcTypes);
	
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
	
}
