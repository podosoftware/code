package kr.podosoft.ws.service.ba.dao;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaException;

public interface BaUserDao {

	public List<Map<String,Object>> queryForList(String statement) throws BaException;

	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public List<Map<String,Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException;
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public Object queryForObject(String statement, Class elementType) throws BaException;

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType) throws BaException;

	public Map<String,Object> queryForMap(String statement) throws BaException;

	public Map<String,Object> queryForMap(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public int update(String statement) throws BaException;

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public void updateUserPassword(Map map) throws BaException;

	public List<Map<String,Object>> userCompetenceBackgroundList(long userId) throws BaException;
	
	public int insertImgFile(int fileNum, long fileSize, InputStream file) throws BaException;
	
	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws BaException;
	
}
