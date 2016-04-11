package kr.podosoft.ws.service.kpi.dao;

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.kpi.KPIException;

public interface KPIDao {

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType);
	
	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes);

	public int update(String statement, Object[] params, int[] jdbcTypes) throws KPIException;
	
	public int update(String statement, Object[] params, int[] jdbcTypes, Map map) throws KPIException;
	
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws KPIException;
	
	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws KPIException;
}
