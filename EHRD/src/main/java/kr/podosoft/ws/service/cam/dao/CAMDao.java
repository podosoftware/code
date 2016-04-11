package kr.podosoft.ws.service.cam.dao;

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.cam.CAMException;

public interface CAMDao {

	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CAMException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CAMException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CAMException;
	
	/**
	 * 
	 * 역량성장도 <br/>
	 *
	 * @param companyid
	 * @param tgUserid
	 * @param list
	 * @return
	 * @since 2014. 4. 23.
	 */
	public List getCmptEvlGrow(long companyid, long tgUserid, List list);
	
	
}


