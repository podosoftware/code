package kr.podosoft.ws.service.ba.dao;

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaException;

public interface BaEducationDao {
	
	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public List<Map<String,Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException;
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws BaException;
	
	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException;
}