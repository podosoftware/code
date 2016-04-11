package kr.podosoft.ws.service.em.dao;

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.em.EmServiceException;

public interface EmDao {
	
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType);
	
	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes);

	public int update(String statement, Object[] params, int[] jdbcTypes) throws EmServiceException;
	
	public int update(String statement, Object[] params, int[] jdbcTypes, Map map) throws EmServiceException;
	
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws EmServiceException;
	
	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws EmServiceException;
	
	public List<Map<String,Object>> selectEduSttList(long companyid, long userid, int year, int type, String bdate);
}
