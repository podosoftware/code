package kr.podosoft.ws.service.common.dao;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.common.CommonException;

public interface MainDao {
	
	public InputStream queryForInputStream(String statement, Object[] params, int[] jdbcTypes);
	
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType);
	
	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CommonException;

	public List<Map<String,Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws CommonException;
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CommonException;

	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws CommonException;
	
	public List<Map<String,Object>> getMainTimeLineList(long companyid, long userid, int startIndex, int pageSize, int sdclass) throws CommonException;
	public int getMainTimeLineCnt(long companyid, long userid, int sdclass) throws CommonException;
}