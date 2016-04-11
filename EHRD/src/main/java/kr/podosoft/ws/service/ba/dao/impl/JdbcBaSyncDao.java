package kr.podosoft.ws.service.ba.dao.impl;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.dao.BaSyncDao;

import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;

public class JdbcBaSyncDao extends SqlQueryDaoSupport implements BaSyncDao {
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes)  throws BaException {
		int result = 0;
		try {
			if(params!=null)
				result = getSqlQuery().queryForObject(statement, params, jdbcTypes, Integer.class);
			else 
				result = getSqlQuery().queryForObject(statement, Integer.class);
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		return result;
	}

	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException {

		List list = Collections.EMPTY_LIST;
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

	public List<Map<String, Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException {
		List list = Collections.EMPTY_LIST;
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

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		int result = 0;
		try {
			if(params!=null) {
				result = getSqlQuery().update(statement, params, jdbcTypes);
			} else {
				result = getSqlQuery().update(statement);
			}
		} catch(Throwable e) {
			log.error(e);
		}

		return result;
	}

	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws BaException {
		
		SqlQueryHelper helper = new SqlQueryHelper();
		
		for(Object[] params : parameteres) {
			helper.parameters(params, jdbcTypes).inqueue();
		}
		
		return helper.executeBatchUpdate(getSqlQuery(), statement);
	}

	
}
