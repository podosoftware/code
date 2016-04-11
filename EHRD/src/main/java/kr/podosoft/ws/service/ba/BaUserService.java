package kr.podosoft.ws.service.ba;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.common.CommonException;
import architecture.common.user.User;
import architecture.ee.web.attachment.FileInfo;

public interface BaUserService {

	public List<Map<String,Object>> queryForList(String statement) throws BaException;

	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public List<Map<String,Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException;

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType) throws BaException;

	public Map<String,Object> queryForMap(String statement) throws BaException;

	public Map<String,Object> queryForMap(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public int update(String statement) throws BaException;

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public int updateUser(Map map, User user) throws BaException ;

	public void updateUserPassword(Map map, User user) throws BaException ;

	public List<Map<String,Object>> userCompetenceBackgroundList(User user) throws BaException;
	
	
	/**
	 * 기본관리 > 사용자관리
	 * 사용자 목록
	 * @param companyid
	 * @return
	 * @throws BaException
	 */
	//public List<Map<String,Object>> getUserList(long companyid, int startIndex, int pageSize, String sortField, String sortDir, Filter filter) throws BaException;
	public List<Map<String,Object>> getUserList(long companyid) throws BaException;
	
	/**
	 * 기본관리 > 사용자관리
	 * 사용자 전체수
	 * @param companyid
	 * @return
	 * @throws BaException
	 */
	public int getTotalUserCount(long companyid) throws BaException;
	
	/**
	 * 기본관리 > 사용자관리
	 * 사용자 상세정보
	 * @param companyid
	 * @param userid
	 * @return
	 * @throws BaException
	 */
	public List<Map<String,Object>> getMgmtUserInfo(long companyid, int userid) throws BaException;
	
	
	/* **************************************** */
	/* ************ 사용자 권한/그룹관리******* */
	/* **************************************** */
	
	/**
	 * 해당 고객사가 가지는 그룹목록
	 * @param companyid
	 * @return
	 * @throws BaException
	 */
	public List getGroups(long companyid) throws BaException;
	
	/**
	 * 해당 고객사의 수강생이 가지고있는 그룹목록
	 * @param companyid
	 * @param userid
	 * @return
	 * @throws BaException
	 */
	public List getUserGroups(long companyid, String userid) throws BaException;
	
	/**
	 * 수강생의 그룹등록/삭제
	 * @param companyid
	 * @param userid
	 * @param items
	 * @return
	 * @throws BaException
	 */
	public String setUserGroups(long companyid, String userid, List<Map<String,Object>> items, String eduManagerFlag, String divisionid, long sessionUser) throws BaException;
	
	/**
	 * 사용자 중복체크
	 * @param companyId
	 * @param name 성명
	 * @param cellPhone 핸드폰번호
	 * @return
	 * @throws BaException
	 */
	public String chkUser(long companyId, String name, String cellPhone)  throws BaException;
	
	public List<Map<String,Object>> getUserInfo(long companyid, long userid) throws BaException;
	
	public String setUserImg(int userid, List<FileInfo> fileList) throws BaException;
	
	public List<Map<String,Object>> getUserImg(int userid) throws BaException;
	
	public List<Map<String,Object>> getUserDeptList(long companyid) throws BaException;
	
	public List<Map<String,Object>> getUserJobList(long companyid ,String jobLdrFlag ) throws BaException;
	
	public List<Map<String,Object>> getUserLdrList(long companyid ,String jobLdrFlag ) throws BaException;
	
	public String setUserInfoSdVisible(long userid, int sdVisible) throws BaException;
	
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

	public int setUserListExcelUpload(User user, HttpServletRequest request) throws CommonException;
	
	public String userExcelUpload(User user, HttpServletRequest request) throws CommonException;
}