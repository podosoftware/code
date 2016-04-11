package kr.podosoft.ws.service.ba.dao.impl;

import java.io.InputStream;
import java.sql.Types;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.dao.BaUserDao;
import kr.podosoft.ws.service.utils.CommonUtils;

import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;

public class JdbcBaUserDao extends SqlQueryDaoSupport implements BaUserDao {
	
	public List<Map<String, Object>> queryForList(String statement) throws BaException {
		
		return getSqlQuery().queryForList(statement);
	}

	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		List<Map<String,Object>> list = Collections.EMPTY_LIST;
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
		List<Map<String,Object>> list = Collections.EMPTY_LIST;
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
	

	public Object queryForObject(String statement, Class elementType) throws BaException {

		return getSqlQuery().queryForObject(statement, elementType);
	}

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType)  throws BaException {

		return getSqlQuery().queryForObject(statement, params, jdbcTypes, elementType);
	}

	public Map<String, Object> queryForMap(String statement) throws BaException {

		return getSqlQuery().queryForMap(statement);
	}

	public Map<String, Object> queryForMap(String statement, Object[] params, int[] jdbcTypes) throws BaException {

		return getSqlQuery().queryForMap(statement, params, jdbcTypes);
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

	
	public void updateUserPassword(Map map) throws BaException {	
		try{
			
			//비밀번호 암호화
			map.put("password", CommonUtils.passwdEncoding(map.get("password").toString()));
			
			String empNo    = (String)map.get("empNo");  
			String companyid    = (String)map.get("companyid");			
			
			
			log.debug("비밀번호변경"+map.get("password"));
			log.debug("아이디"+empNo);
			log.debug("회사번호"+companyid);
			
			getSqlQuery().update("BA_USER.USER-PASSWORD-MGMT-UPDATE", map.get("password"), empNo, companyid);
			
		}catch(Exception e){
			log.error(e);
			throw new BaException( e );
		}	
	}

	public List<Map<String,Object>> userCompetenceBackgroundList(long userid) throws BaException {
		List<Map<String,Object>> list = Collections.EMPTY_LIST;
		try{
			list = getSqlQuery().list("BA_USER.USER-COMPETENCE-BACKGROUND-SELECT", userid );
		}catch(Exception e){
			log.error(e);
			throw new BaException(e);
		}
		return list;
	}
	
	
	
	public int insertImgFile(int fileNum, long fileSize, InputStream file) throws BaException {		
		try {
			getSqlQuery().update("BA_USER.DELETE_IMG_DATA", new Object[] {fileNum}, new int[] {Types.INTEGER});
			
			SqlQueryHelper helper = new SqlQueryHelper(getLobHandler());
			helper.lob(file, (int)fileSize);
			
			return getSqlQuery().update("BA_USER.INSERT_IMG_DATA", 
					new Object[]{fileNum, helper.values()[0]}, 
					new int[]{Types.INTEGER, Types.BLOB});
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
	}

}