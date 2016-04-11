package kr.podosoft.ws.service.ba;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import architecture.common.user.User;

public interface BaService {
	
	/* ***************************************************************************** */
	/* ********** COMMON MANAGEMENT SERVICE ********* */
	/* ***************************************************************************** */

	public List<Map<String,Object>> queryForList(String statement) throws BaException;

	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public List<Map<String,Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException;

	public Object queryForObject(String statement, Class elementType) throws BaException;

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType) throws BaException;

	public Map<String,Object> queryForMap(String statement) throws BaException;

	public Map<String,Object> queryForMap(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public int update(String statement) throws BaException;

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws BaException;

	public int excute(String statement) throws BaException;

	public int excute(String statement, Object[] params, int[] jdbcTypes) throws BaException;
	
	/* ***************************************************************************** */
	/* ********** COMPANY MANAGEMENT SERVICE ********* */
	/* ***************************************************************************** */
	
	public int companySave(HttpServletRequest request, User user) throws Exception;;
	
	public int companyCmptUseSave(HttpServletRequest request, User user) throws Exception;;
	
	public int companyKpiUseSave(HttpServletRequest request, User user) throws Exception;;
	
	
	/* ***************************************************************************** */
	/* ********** DEPARTMENT MANAGEMENT SERVICE ********* */
	/* ***************************************************************************** */
	
	public List<Map<String,Object>> getDeptMngList(long companyid, String useFlag) throws BaException;
	public int divisionExcelSaveService(User user, HttpServletRequest request) ;

	/**
	 * 행동지표 엑셀 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 3. 26.
	 */
	public int jobLdrExcelSaveService(User user,String jobFlag, HttpServletRequest request) ;
	/**
	 * 
	 * 직무관리 - 직무,역량저장<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 11.
	 */
	public int saveJobInfo(HttpServletRequest request, User user);
	/**
	 * 
	 * 직무관리 - 직무,역량삭제<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 11.
	 */
	public int deleteJobComp(HttpServletRequest request, User user);

}
