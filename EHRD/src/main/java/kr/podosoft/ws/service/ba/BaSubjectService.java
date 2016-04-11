package kr.podosoft.ws.service.ba;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.common.CommonException;

import architecture.common.user.User;

public interface BaSubjectService {

	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public List<Map<String,Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException;
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws BaException;
		
	public int update(String statement) throws BaException;

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws BaException;

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws BaException;

	/**
	 * 
	 * 차시정보 일괄삭제처리<br/>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 12. 2.
	 */
	public int severalDelSbjctOpenInfo(User user, String[] openArr) throws BaException;;
	
	/**
	 * 
	 * 차시정보 엑셀 업로드<br/>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 12. 2.
	 */
	public String upLoadSbjctOpenListExcel(User user, HttpServletRequest request);
	
	/**
	 * 
	 * 역량매핑 정보 엑셀 업로드<br/>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 12. 2.
	 */
	public String upLoadSbjctCmmappingListExcel(User user, HttpServletRequest request);
	
	/**
	 * 
	 * 과정정보 엑셀 업로드<br/>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @throws BaException 
	 * @throws CommonException 
	 * @since 2014. 12. 2.
	 */
	public String upLoadSbjctListExcel(User user, HttpServletRequest request) throws CommonException;
	

	/**
	 * 
	 * 승인하기 - 교육추천승인 처리<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 8.
	 */
	public int saveClsRecommReq(HttpServletRequest request, User user) throws BaException;
	
	
	/**
	 * 
	 * 승인하기 - 교육승인 처리<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 8.
	 */
	public int saveClsApplyReq(HttpServletRequest request, User user) throws BaException;
	
	/**
	 * 
	 * 승인하기 - 수정팝업 - 교육승인 처리<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 8.
	 */
	public int saveClsApplyReqPopup(HttpServletRequest request, User user) throws BaException;
	
	/**
	 * 
	 * 운영관리 - 수료처리 저장<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 8.
	 */
	public int saveOpenCmplt(HttpServletRequest request, User user);
	
	/**
	 * 
	 * 차시관리 - 차시 등록<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 9. 29.
	 */
	public int saveSbjctOpenInfo(HttpServletRequest request, User user);
	
	/**
	 * 
	 * 과정관리 - 과정정보 등록<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 9. 29.
	 */
	public int saveSbjctInfo(HttpServletRequest request, User user);
	
	/**
	 * 
	 * 운영관리 - 대상자확정 추천순위 승인요청<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 8.
	 */
	public int saveOpenRecommTarget(HttpServletRequest request, User user)  throws BaException;
	
	/**
	 * 
	 * 운영관리 - 대상자확정 저장<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 8.
	 */
	public int saveOpenTarget(HttpServletRequest request, User user)  throws BaException;
	
	/**
	 * 
	 * 교육생엑셀업로드<br/>
	 *
	 * @param openNum
	 * @param attachments
	 * @param user
	 * @return
	 * @throws BaException 
	 * @since 2014. 10. 9.
	 */
	public String saveTargetUserUpload(HttpServletRequest request, User user) throws BaException;  

	/**
	 * 
	 * 교육이수기준관리 - 직급별 이수시간 저장<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 11. 11.
	 */
	public int saveGradeRecogTime(HttpServletRequest request, User user);

	/**
	 * 
	 * 교육이수기준관리 - 기관성과평가 필수교육 이수시간 저장<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 11. 11.
	 */
	public int savePerfAsseRecogTime(HttpServletRequest request, User user);
	
	/**
	 * 
	 * 교육이수기준관리 - 부서원 이수시간 저장<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 11. 11.
	 */
	public int saveUserRecogTime(HttpServletRequest request, User user);
	
	/**
	 * 
	 * 상시학습관리 - 등록<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 11. 24.
	 */
	public int saveAlwReq(HttpServletRequest request, User user) throws BaException;
	
	/**
	 * 
	 * 상시학습관리 - 데이터 상태 변경<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 12. 09.
	 */
	public int saveAlwDataSts(HttpServletRequest request, User user);
	
	/**
	 * 
	 * 상시학습관리 - 저장<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 11. 24.
	 */
	public int saveAlwInfo(HttpServletRequest request, User user) throws BaException ;
	/**
	 * 
	 * 상시학습관리 - 인정직급수정<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2015. 09. 30.
	 */
	public int updateGradeInfo(HttpServletRequest request, User user) throws BaException ;
	/**
	 * 
	 * 상시학습관리 - 요청취소<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 11. 24.
	 */
	public int cencleAlwReq(HttpServletRequest request, User user) throws BaException;
	/**
	 * 
	 * 상시학습관리 - 삭제<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 11. 27.
	 */
	public int deleteAlwReq(HttpServletRequest request, User user) throws BaException;
	/**
	 * 
	 * 부서원교육현황 - 권한체크<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 11. 24.
	 */
	public String getUserDivisionList(HttpServletRequest  request, User user, String tableAlias);
	
	public List<Map<String, Object>> getAutoRecogTime(HttpServletRequest request, User user);
	
	/**
	 * 이사람 연동 용 엑셀다운로드 후 해당 이력의 데이터 상태 변경
	 * @param companyid
	 * @param items
	 * @throws BaException
	 */
	public void updateSyncEduState(long companyid, List<Map<String,Object>> items) throws BaException;
	
	/**
	 * 
	 * 운영관리 -  인정시간 재계산<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @throws BaException
	 * @since 2015. 3. 1.
	 */
	public int changeUserRecogTime(HttpServletRequest request, User user) throws BaException;
	
}