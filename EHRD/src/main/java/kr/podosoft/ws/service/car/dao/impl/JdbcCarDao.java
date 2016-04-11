package kr.podosoft.ws.service.car.dao.impl;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.car.CarException;
import kr.podosoft.ws.service.car.dao.CarDao;
import architecture.ee.jdbc.sqlquery.SqlQuery;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;

public class JdbcCarDao  extends SqlQueryDaoSupport implements CarDao  {

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws CarException  {
		Object obj = null;
		try {
			if(params!=null) {
				obj = getSqlQuery().queryForObject(statement, params, jdbcTypes, cls );
			} else {
				obj = getSqlQuery().queryForObject(statement, cls);
			}
		} catch(Throwable e) {
			log.error(e);
		}
		return obj;
	}
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CarException  {
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
	
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CarException  {
		return getSqlQuery().update(statement, params, jdbcTypes);
	}
	
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CarException {
		return getSqlQuery().executeUpdate(statement, params);
	}
	
	public List<Map<String, Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws CarException  {
		List<Map<String, Object>> list = Collections.EMPTY_LIST;
		try {
			SqlQuery query = getSqlQuery();
			query.setAdditionalParameters(map);
			if(params!=null) {
				list = query.queryForList(statement, params, jdbcTypes);
			} else {
				list = query.queryForList(statement);
			}
		} catch(Throwable e) {
			log.error(e);
		}
		return list;
	}
	
}