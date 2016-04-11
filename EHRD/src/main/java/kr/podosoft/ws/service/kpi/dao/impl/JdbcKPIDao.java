package kr.podosoft.ws.service.kpi.dao.impl;

import java.sql.Types;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ca.CAException;
import kr.podosoft.ws.service.kpi.KPIException;
import kr.podosoft.ws.service.kpi.dao.KPIDao;
import architecture.ee.jdbc.sqlquery.SqlQuery;
import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.jdbc.sqlquery.factory.SqlQueryFactory;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;
import architecture.ee.web.util.WebApplicationHelper;

public class JdbcKPIDao extends SqlQueryDaoSupport implements KPIDao{
	/**
	 *
	 * @author  ReeSSang
	 * @version 
	 */
	
	public Object queryForObject(String statement, Object[] params,	int[] jdbcTypes, Class elementType){
		return getSqlQuery().queryForObject(statement, params, jdbcTypes, elementType);
	}

	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes){

		List list = Collections.EMPTY_LIST;
		try {
			if (params != null) {
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
			throws KPIException {
		int result = 0;
		try {
			result = getSqlQuery().update(statement, params, jdbcTypes);
		} catch (Throwable e) {
			log.error(e);
		}

		return result;
	}

	public int update(String statement, Object[] params, int[] jdbcTypes, Map map)
			throws KPIException {
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
	
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws KPIException {
		return getSqlQuery().executeUpdate(statement, params);
	}
	
	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws KPIException {
		SqlQueryHelper helper = new SqlQueryHelper();
		
		for(Object[] params : parameteres) {
			helper.parameters(params, jdbcTypes).inqueue();
		}
		
		return helper.executeBatchUpdate(getSqlQuery(), statement);
	}

}
