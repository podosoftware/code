package kr.podosoft.ws.service.cam;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import architecture.common.user.User;

public interface CAMService {
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CAMException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CAMException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CAMException;
	

	/**
	 * 
	 * 역량평가 저장<br/>
	 *
	 * @param request
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 16.
	 */
	public int cmptEvlSave(HttpServletRequest  request, User user) throws CAMException;
	
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
