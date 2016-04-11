package kr.podosoft.ws.service.cdp.dao;

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.cdp.CdpException;
import kr.podosoft.ws.service.common.Filter;

public interface CdpDao {

	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CdpException;
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws CdpException;
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws CdpException;

	public List<Map<String,Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map<String, Object> map) throws CdpException;
	public List<Map<String,Object>> dynamicQueryForList(String statement, int startIndex, int pageSize, String sortFilter, String sortDir, String defaultSort, Filter filter, Object[] params, int[] jdbcTypes, Map<String, Object> map) throws CdpException;

	public int update(String statement, Object[] params, int[] jdbcTypes) throws CdpException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CdpException;
	
	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws CdpException;
	
}


