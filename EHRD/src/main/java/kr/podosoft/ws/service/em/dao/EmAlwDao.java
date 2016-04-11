package kr.podosoft.ws.service.em.dao;

/**
 * 교육훈련 > 상시학습
 */

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.em.EmServiceException;

public interface EmAlwDao {
	
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType);
	
	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes);

	public int update(String statement, Object[] params, int[] jdbcTypes) throws EmServiceException;
	
	public int update(String statement, Object[] params, int[] jdbcTypes, Map map) throws EmServiceException;
	
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws EmServiceException;
	
	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws EmServiceException;
}
