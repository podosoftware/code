package kr.podosoft.ws.service.ba.dao.impl;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.dao.BaSubjectDao;
import kr.podosoft.ws.service.cdp.CdpException;

import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;

public class JdbcBaSubjectDao extends SqlQueryDaoSupport implements BaSubjectDao {
	
	public int mergeCompetencyMappingDao(long companyId, String subjectNum,
			String cmpNumber, String checkFlag) {

		return getSqlQuery().update("BA.INSERT_SBJCT_CM_MAPPING", companyId, subjectNum, cmpNumber, checkFlag);
	}
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws BaException  {
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
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		List<Map<String, Object>> list = Collections.emptyList();
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
		List<Map<String, Object>> list = Collections.emptyList();
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
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		if(params!=null) {
			return getSqlQuery().queryForObject(statement, params, jdbcTypes, Integer.class);
		} else {
			return getSqlQuery().queryForObject(statement, Integer.class);
			
		}
	}

	public int update(String statement)  throws BaException {

		return getSqlQuery().update(statement);
	}

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException {

		return getSqlQuery().update(statement, params, jdbcTypes);
	}

	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws BaException {
		
		SqlQueryHelper helper = new SqlQueryHelper();
		
		for(Object[] params : parameteres) {
			helper.parameters(params, jdbcTypes).inqueue();
		}
		
		return helper.executeBatchUpdate(getSqlQuery(), statement);
	}
	
}
