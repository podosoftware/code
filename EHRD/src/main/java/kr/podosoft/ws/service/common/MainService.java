package kr.podosoft.ws.service.common;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.mtr.MtrException;
import architecture.common.user.User;

public interface MainService {
	
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType) throws  CommonException;
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	public InputStream queryForInputStream(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	
	/* 메인-QuickMenu 등록 */
	public int selectQuickMenu(HttpServletRequest  request, User user) throws CommonException;
	/* 메인-권한위임 등록 */
	public int mainEduAdminReq(HttpServletRequest  request, User user) throws CommonException;
	
	/* 메인-권한위임 승인 */
	public int mainEduAdminApp(HttpServletRequest  request, User user) throws CommonException;
	
	/* 메인-권한위임 삭제 */
	public int mainEduAdminDel(HttpServletRequest  request, User user) throws CommonException;
	
	
	/* 메인-QuickMenu 삭제 */
	public int deleteQuickMenu(HttpServletRequest  request, User user) throws CommonException;
	/* 메인-취업정보 요약보기 */
	public List<Map<String,Object>> getMainWorkInfo(long companyid, int startIndex, int pageSize) throws CommonException;
	/* 메인-커뮤니티 요약보기 */
	public List<Map<String,Object>> getMainCommunityInfo(long companyid, int startIndex, int pageSize) throws CommonException;
	/* 메인-역량진단결과 */
	public List<Map<String,Object>> getMainCaInfo(long companyid, long userid) throws CommonException;
	/* 메인-역량활동결과 */
	public List<Map<String,Object>> getMainActInfo(long companyid, long userid) throws CommonException;
	/* 메인-타임라인 */
	public List<Map<String,Object>> getMainTimeline(long companyid, long userid, int startIndex, int pageSize, int sdclass) throws CommonException;
	public int getMainTimelineCnt(long companyid, long userid, int sdclass) throws CommonException;
	/* 현재학년*/
	public int getThisClass(long companyid, long userid) throws CommonException;
	
	/* 메인-켈린터요약보기 */
	public List<Map<String,Object>> getMainMyCareerCalender(long companyId, long userId, int startIndex, int pageSize) throws CommonException;
	
	/* 켈린더-상세보기 */
	public List<Map<String,Object>> getMyCareerCalenderInfo( 
			long companyId, long userId, int year, int month, int day,
			boolean roleAdmn, boolean roleCnsltr, boolean roleStff, boolean rolePrfssr, boolean roleStdnt ) throws CommonException;
	
	/* 켈린더-일정추가 */
	public String addSchedule(long companyid, long userid, 
			String schdlType, String chkDate, String startTime, String endTime, String repeatYn, 
			String startDate, String endDate, String chkDayOfWeek, String schdlNote) throws CommonException;
	
	/* 켈린더-일정수정 */
	public String setSchedule(long companyid, int userid, 
			int schdlSeq, String schdlType, String chkDate, String startTime, String endTime, 
			String repeatYn, String startDate, String endDate, String chkDayOfWeek, String schdlNote) throws CommonException;
	
	/* 켈린더-일정삭제 */
	public String delSchedule(long companyId, int userId, int schdlSeq) throws CommonException;
	
	/* 메인-검색-학생 */
	public List<Map<String,Object>> srchStudentList(long companyId, int startIndex, int pageSize, String srchTxt) throws CommonException;
	public int srchStudentCnt(long companyId, String srchTxt) throws CommonException;
	
	/* 메인-검색-활동 */
	public List<Map<String,Object>> srchActList(long companyId, int startIndex, int pageSize, String srchTxt) throws CommonException;
	public int srchActCnt(long companyId, String srchTxt) throws CommonException;
	
	
}
