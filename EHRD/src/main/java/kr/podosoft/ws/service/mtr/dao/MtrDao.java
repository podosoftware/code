package kr.podosoft.ws.service.mtr.dao;

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.mtr.MtrException;

public interface MtrDao {

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws MtrException;
	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws MtrException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws MtrException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws MtrException;
	public List<Map<String,Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws MtrException;
	

}


