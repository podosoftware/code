package kr.podosoft.ws.service.car.dao;

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.car.CarException;

public interface CarDao {

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws CarException;
	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CarException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CarException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CarException;
	public List<Map<String,Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws CarException;
	
}


