package kr.podosoft.ws.service.ba.dao.impl;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.dao.BaDao;
import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;

public class JdbcBaDao extends SqlQueryDaoSupport implements BaDao {

	public List<Map<String, Object>> queryForList(String statement) throws BaException {
		
		return getSqlQuery().queryForList(statement);
	}

	public List<Map<String, Object>> queryForList(String statement,
			Object[] params, int[] jdbcTypes) throws BaException {

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

	public List<Map<String, Object>> queryForList(String statement, int startIndex,
			int maxResults, Object[] params, int[] jdbcTypes) throws BaException {
			
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

	public Object queryForObject(String statement, Class elementType) throws BaException {
		return getSqlQuery().queryForObject(statement, elementType);
	}

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType)  throws BaException {

		return getSqlQuery().queryForObject(statement, params, jdbcTypes, elementType);
	}
	
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

	public Map<String, Object> queryForMap(String statement) throws BaException {

		return getSqlQuery().queryForMap(statement);
	}

	public Map<String, Object> queryForMap(String statement, Object[] params,
			int[] jdbcTypes) throws BaException {

		return getSqlQuery().queryForMap(statement, params, jdbcTypes);
	}

	public int update(String statement)  throws BaException {
		int result = 0;
		try {
			result = getSqlQuery().update(statement);
		} catch(Throwable e) {
			log.error(e);
		}

		return result;
	}

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		int result = 0;
		try {
			result = getSqlQuery().update(statement, params, jdbcTypes);
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

	public int excute(String statement) throws BaException {

		return getSqlQuery().executeUpdate(statement);
	}

	public int excute(String statement, Object[] params, int[] jdbcTypes) throws BaException {

		return getSqlQuery().executeUpdate(statement, params);
	}
	
	public int mergeBhvIndicator(long companyId, String jobLdrNum, String jobLdrName, String jobFlag, 
			String jobLdrComment, String mainTask, String useFlag, long userId) {

	return getSqlQuery().update("BA.MERGE_EXCEL_JOB",companyId, jobLdrNum,  jobLdrName, mainTask, jobFlag, jobLdrComment , useFlag,
			userId ,companyId);
	}

	
	
}
