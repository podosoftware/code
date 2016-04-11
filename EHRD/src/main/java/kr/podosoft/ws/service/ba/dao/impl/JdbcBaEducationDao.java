package kr.podosoft.ws.service.ba.dao.impl;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.dao.BaEducationDao;
import kr.podosoft.ws.service.ba.BaException;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;

public class JdbcBaEducationDao extends SqlQueryDaoSupport implements BaEducationDao {
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException {

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

	public List<Map<String, Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException {
			
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
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		
		return getSqlQuery().queryForObject(statement, params, jdbcTypes, Integer.class);
	}

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException {

		return getSqlQuery().update(statement, params, jdbcTypes);
	}
}
