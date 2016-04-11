package kr.podosoft.ws.service.common.impl;

import java.io.InputStream;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.common.MainService;
import kr.podosoft.ws.service.common.dao.MainDao;
import kr.podosoft.ws.service.mtr.MtrException;
import kr.podosoft.ws.service.utils.CommonUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import architecture.common.user.User;
import architecture.ee.web.util.ParamUtils;

public class MainServiceImpl implements MainService {
	
	private Log log = LogFactory.getLog(getClass());
	
	private MainDao mainDao;
	
	public MainDao getMainDao() {
		return mainDao;
	}
	public void setMainDao(MainDao mainDao) {
		this.mainDao = mainDao;
	}
	
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType) throws CommonException {
		Object obj = null;
		try {
			obj = mainDao.queryForObject(statement, params, jdbcTypes, elementType);
		} catch(Throwable e) {
			log.error(e);
		}
		return obj;
	}
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CommonException {
		return mainDao.queryForList(statement, params, jdbcTypes);
	}
	
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CommonException {
		return mainDao.update(statement, params, jdbcTypes);
	}
	
	public InputStream queryForInputStream(String statement, Object[] params, int[] jdbcTypes) throws CommonException{
		return mainDao.queryForInputStream(statement, params, jdbcTypes);
	}

	
	/**
	 * 교육담당자 요청 - 등록 
	 */
	public int mainEduAdminReq(HttpServletRequest  request, User user) throws CommonException{
		int saveCount = 0;
		
		long companyId = user.getCompanyId();
		long userId = user.getUserId();
	   
		try{
			String REQ_DIV_CD = ParamUtils.getParameter(request, "REQ_DIV_CD");
			String CHE_USERID = ParamUtils.getParameter(request, "USERID");
			String DIVISIONID = ParamUtils.getParameter(request, "DIVISIONID");

			saveCount += update("COMMON.MERGE_EDU_ADMIN_REQ", new Object[]{ companyId, DIVISIONID, CHE_USERID, userId, userId, REQ_DIV_CD }, new int[]{Types.NUMERIC,Types.VARCHAR,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.VARCHAR});
			
	    }catch(Throwable e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	/**
	 * 교육담당자 요청 - 승인 
	 */
	public int mainEduAdminApp(HttpServletRequest  request, User user) throws CommonException{
		int saveCount = 0;
		
		long companyId = user.getCompanyId();
		//long userId = user.getUserId();
	    String groupId="2";

		try{
			String userId = ParamUtils.getParameter(request, "USERID");
			String reqDivCd = ParamUtils.getParameter(request, "REQ_DIV_CD");
			String reqUserId = ParamUtils.getParameter(request, "REQ_USERID");

			saveCount += update("COMMON.MERGE_EDU_ADMIN_APP", new Object[]{ companyId, userId,reqDivCd }, new int[]{Types.NUMERIC,Types.NUMERIC,Types.VARCHAR});
			
			if("1".equals(reqDivCd) && saveCount > 0 ){
				update("COMMON.DELETE_EDU_ADMIN_APP_USER", new Object[]{ companyId, reqUserId }, new int[]{Types.NUMERIC,Types.NUMERIC});
				update("COMMON.INSERT_GROUP_MEMBERS", new Object[]{ groupId,userId }, new int[]{Types.NUMERIC,Types.NUMERIC});
				update("COMMON.DELETE_GROUP_MEMBERS", new Object[]{ groupId,reqUserId }, new int[]{Types.NUMERIC,Types.NUMERIC});
			}
			if("2".equals(reqDivCd) && saveCount > 0 ){
				saveCount += update("COMMON.INSERT_GROUP_MEMBERS", new Object[]{ groupId,userId }, new int[]{Types.NUMERIC,Types.NUMERIC});
			}
	    }catch(Throwable e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	
	/**
	 * 교육담당자 요청 - 취소 
	 */
	public int mainEduAdminDel(HttpServletRequest  request, User user) throws CommonException{
		int saveCount = 0;
		
		long companyId = user.getCompanyId();
		//long userId = user.getUserId();

		try{
			String userId = ParamUtils.getParameter(request, "USERID");
			String reqUserId = ParamUtils.getParameter(request, "REQ_USERID");

			saveCount +=update("COMMON.DELETE_EDU_ADMIN_APP_CENCLE", new Object[]{ companyId, userId  ,reqUserId }, new int[]{Types.NUMERIC,Types.NUMERIC,Types.NUMERIC});
	    
		}catch(Throwable e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	
	
	/**
	 * Quick-menu - 등록 
	 */
	public int selectQuickMenu(HttpServletRequest  request, User user) throws CommonException{
		int saveCount = 0;
		
		long companyId = user.getCompanyId();
		long userId = user.getUserId();
	   
		try{
			String MENU_NUM = ParamUtils.getParameter(request, "MENU_NUM");
			String MENU_POS_NUM = ParamUtils.getParameter(request, "MENU_POS_NUM");

			saveCount += update("COMMON.INSERT_QUICK_MENU", new Object[]{ companyId, userId,MENU_NUM,MENU_POS_NUM }, new int[]{Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC});
			
	    }catch(Throwable e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	
	/**
	 * Quick-menu - 삭제 
	 */
	public int deleteQuickMenu(HttpServletRequest  request, User user) throws CommonException{
		int saveCount = 0;
		
		long companyId = user.getCompanyId();
		long userId = user.getUserId();
		
		try{
			String MENU_POS_NUM = ParamUtils.getParameter(request, "MENU_POS_NUM");
			
			saveCount += update("COMMON.DELETE_QUICK_MENU", new Object[]{ companyId, userId,MENU_POS_NUM }, new int[]{Types.NUMERIC,Types.NUMERIC,Types.NUMERIC});
			
		}catch(Throwable e){
			log.debug(e);
		}
		return saveCount;
	}
	
	/* 메인-취업정보 요약보기 */
	public List<Map<String,Object>> getMainWorkInfo(long companyid, int startIndex, int pageSize) throws CommonException {
		
		return mainDao.queryForList("COMMON.SELECT_MAIN_WORK", startIndex, pageSize,
				null, null);
	}
	
	/* 메인-커뮤니티 요약보기 */
	public List<Map<String,Object>> getMainCommunityInfo(long companyid, int startIndex, int pageSize) throws CommonException {
		
		return mainDao.queryForList("COMMON.SELECT_MAIN_COMMUNITY", startIndex, pageSize,
				null, null);
	}
	
	/* 메인-역량진단결과 */
	public List<Map<String,Object>> getMainCaInfo(long companyid, long userid) throws CommonException {
		
		return mainDao.queryForList("COMMON.SELECT_MAIN_CAM", 
				new Object[] {companyid, companyid, userid, companyid, userid}, 
				new int[] {Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER});
	}
	
	/* 메인-역량활동결과 */
	public List<Map<String,Object>> getMainActInfo(long companyid, long userid) throws CommonException {
		
		return mainDao.queryForList("COMMON.SELECT_MAIN_ACT", 
				new Object[] {companyid, userid, userid}, 
				new int[] {Types.INTEGER, Types.INTEGER, Types.INTEGER});
	}
	
	/* 메인-켈린터요약보기 */
	public List<Map<String,Object>> getMainMyCareerCalender(long companyid, long userid, int startIndex, int pageSize) throws CommonException {
		return mainDao.queryForList("COMMON.SELECT_MAIN_CALENDER", startIndex, pageSize,
				new Object[] {userid, companyid, userid}, 
				new int[] {Types.INTEGER, Types.INTEGER, Types.INTEGER});
	}
	
	/* 메인-타임라인 */
	public List<Map<String,Object>> getMainTimeline(long companyid, long userid, int startIndex, int pageSize, int sdclass) throws CommonException {
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		try {
			list = mainDao.getMainTimeLineList(companyid, userid, startIndex, pageSize, sdclass);
			
			if(!list.isEmpty()) {
				for(int i=0; i<list.size(); i++) {
					List<Map<String,Object>> caResultList = new ArrayList<Map<String,Object>>();
					
					Map<String,Object> map = list.get(i);
					String type = map.get("TYPE").toString();
					String flag = map.get("GUBUN1").toString();
					// 역량진단일 경우
					if(type.equals("CA") && flag.equals("진단완료")) {
						// 진단완료일 경우
						caResultList = mainDao.queryForList("COMMON.SELECT_MAIN_TIMELINE_CA_RESULT", 
								new Object[] {companyid, companyid, userid, map.get("KEY1")}, 
								new int[] {Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER});
					}
					map.put("caResultArr", caResultList);
					list.set(i, map);
				}
			}
			
		} catch(Throwable e) {
			log.equals(e);
		}
		
		return list;
	}
	
	public int getMainTimelineCnt(long companyid, long userid, int sdclass) throws CommonException {
		
		return mainDao.getMainTimeLineCnt(companyid, userid, sdclass);
	}
	
	/**
	 * 현재학년
	 * @param companyid
	 * @param userid
	 * @return
	 * @throws CNSLException
	 */
	public int getThisClass(long companyid, long userid) throws CommonException {
		
		return mainDao.queryForInteger("COMMON.SELECT_STUDENT_THIS_CLASS", 
				new Object[] {companyid, userid}, 
				new int[] {Types.INTEGER, Types.INTEGER});
	}
	
	
	/* 켈린더-상세보기 */
	public List<Map<String,Object>> getMyCareerCalenderInfo( 
			long companyId, long userId, int year, int month, int day,
			boolean roleAdmn, boolean roleCnsltr, boolean roleStff, boolean rolePrfssr, boolean roleStdnt ) throws CommonException {
		
		String date = year+"";
		if(month<10) date = date + "0" + month; 
		else date = date + month;
		
		List<Map<String,Object>> list = Collections.EMPTY_LIST;
		try {
			if(roleAdmn || roleCnsltr || roleStff || rolePrfssr) {
				list = mainDao.queryForList("COMMON.SELECT_SCHDL_MNG", 
						new Object[] {userId, date}, 
						new int[] {Types.INTEGER, Types.VARCHAR});
			} else {
				list = mainDao.queryForList("COMMON.SELECT_SCHDL_STUDENT", 
						new Object[] {userId, date}, 
						new int[] {Types.INTEGER, Types.VARCHAR});
			}
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return list;
	}
	
	/* 켈린더-일정추가 */
	public String addSchedule(long companyid, long userid, 
			String schdlType, String chkDate, String startTime, String endTime, String repeatYn, 
			String startDate, String endDate, String chkDayOfWeek, String schdlNote) throws CommonException {
		
		String result = "N";
		try {
			
			int schdlSeq = mainDao.queryForInteger("COMMON.SELECT_NEW_SCHDL_SEQ", 
								new Object[] {userid}, 
								new int[] {Types.INTEGER});
			
			result = setScheduleSrv(companyid, userid, 
					schdlSeq, schdlType, chkDate, startTime, endTime, 
					repeatYn, startDate, endDate, chkDayOfWeek, schdlNote);
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return result;
	}
	
	/* 켈린더-일정수정 */
	public String setSchedule(long companyid, int userid, 
			int schdlSeq, String schdlType, String chkDate, String startTime, String endTime, 
			String repeatYn, String startDate, String endDate, String chkDayOfWeek, String schdlNote) throws CommonException {
		
		String result = "N";
		try {
			// 기존일정 삭제
			mainDao.update("COMMON.DELETE_SCHDL", 
					new Object[] { userid, schdlSeq }, 
					new int[] { Types.INTEGER, Types.INTEGER });
			
			// 일정등록
			result = setScheduleSrv(companyid, userid, 
					schdlSeq, schdlType, chkDate, startTime, endTime, 
					repeatYn, startDate, endDate, chkDayOfWeek, schdlNote);
			
			result = "Y";
		} catch(Throwable e) {
			log.error(e);
		}
		
		return result;
	}
	
	/* 켈린더-일정삭제 */
	public String delSchedule(long companyId, int userId, int schdlSeq) throws CommonException {
		
		String result = "N";
		try {
			
			int chk = mainDao.update("COMMON.DELETE_SCHDL", 
					new Object[] { userId, schdlSeq }, 
					new int[] { Types.INTEGER, Types.INTEGER });
			
			if(chk>0) result = "Y";
		} catch(Throwable e) {
			log.error(e);
		}
		
		return result;
	}
	
	
	private String setScheduleSrv(long companyid, long userid, 
			int schdlSeq, String schdlType, String chkDate, String startTime, String endTime, 
			String repeatYn, String startDate, String endDate, String chkDayOfWeek, String schdlNote) throws CommonException {
		
		String returnStr = "N";
		
		try {
			log.debug("repeatYn :: " + repeatYn);
			
			if(repeatYn.equals("Y")) {
				log.debug("startDate :: " + startDate);
				log.debug("endDate   :: " + endDate);
				log.debug("chkDayOfWeek :: " + chkDayOfWeek);
				
				if(startDate!=null && endDate!=null && chkDayOfWeek!=null) {
				
					Calendar cal = Calendar.getInstance();
					
					List<Object[]> rows = new ArrayList<Object[]>();
					
					String[] weekArr = chkDayOfWeek.split(",");
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
					
					// 날자차이
					Date _beginDate = sdf.parse(startDate);
					Date _endDate = sdf.parse(endDate);
					String _diffDays = String.valueOf(((_endDate.getTime()-_beginDate.getTime()) / (24*60*60*1000)));
					int diffDays = Integer.valueOf(_diffDays)+1;
					log.debug("diff Days :: " + _diffDays);
					
					// 시작일자 요일
					cal.setTime(_beginDate);
					int _beginWeek = cal.get(Calendar.DAY_OF_WEEK);
					// 1(일), 2(월), 3(화), 4(수), 5(목), 6(금), 7(토)
					log.debug("beginWeek :: " + _beginWeek);
					
					int nowWeek = _beginWeek;
					log.debug("nowWeek :: " + nowWeek);
					
					if(diffDays>0 && weekArr!=null && weekArr.length==7) {
						boolean weekSun = weekArr[0].equals("Y") ? true : false;
						boolean weekMon = weekArr[1].equals("Y") ? true : false;
						boolean weekTue = weekArr[2].equals("Y") ? true : false;
						boolean weekWed = weekArr[3].equals("Y") ? true : false;
						boolean weekThu = weekArr[4].equals("Y") ? true : false;
						boolean weekFri = weekArr[5].equals("Y") ? true : false;
						boolean weekSat = weekArr[6].equals("Y") ? true : false;

						for(int i=1; i<=diffDays; i++) {
							String nowDay = sdf.format(cal.getTime());
							log.debug("nowDay :: " + nowDay);
							
							boolean chk = false;
							
							switch(nowWeek) { 
								case 1 : if(weekSun) chk = true; break;
								case 2 : if(weekMon) chk = true; break;
								case 3 : if(weekTue) chk = true; break;
								case 4 : if(weekWed) chk = true; break;
								case 5 : if(weekThu) chk = true; break;
								case 6 : if(weekFri) chk = true; break;
								case 7 : if(weekSat) chk = true; break;
							}
							
							if(chk) {
								rows.add(new Object[] {
									userid, schdlSeq++, schdlType, nowDay+startTime, nowDay+endTime, 
									schdlNote, userid	
								});
							}
							
							nowWeek++;
							
							// 일자증가
							cal.add(Calendar.DATE, 1);
							
							// 요일초기화
							if(nowWeek>7) nowWeek = 1;
						}
					}
					
					if(!rows.isEmpty()) {
						mainDao.batchUpdate("COMMON.INSERT_SCHDL", rows, new int[] {
								Types.INTEGER, Types.INTEGER, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
								Types.VARCHAR, Types.INTEGER
						});
					}					
					
					returnStr = "Y";
				}
				
			} else {
				mainDao.update("COMMON.INSERT_SCHDL", 
						new Object[] {
							userid, schdlSeq, schdlType, chkDate+startTime, chkDate+endTime, 
							schdlNote, userid
						}, 
						new int[] {
							Types.INTEGER, Types.INTEGER, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
							Types.VARCHAR, Types.INTEGER
						}
					);
				
				returnStr = "Y";
			}
		} catch(Throwable e) {
			log.error(e);
			throw new CommonException(e);
		}
		
		return returnStr;
	}
	
	
	
	/* 메인-검색-학생 */
	public List<Map<String,Object>> srchStudentList(long companyId, int startIndex, int pageSize, String srchTxt) throws CommonException {
		
		return mainDao.queryForList("COMMON.SELECT_MAIN_SRCH_STUDENT_LIST", startIndex, pageSize, 
				new Object[] {companyId, companyId, srchTxt}, 
				new int[] {Types.INTEGER, Types.INTEGER, Types.VARCHAR});
	}
	public int srchStudentCnt(long companyId, String srchTxt) throws CommonException {
		
		return mainDao.queryForInteger("COMMON.SELECT_MAIN_SRCH_STUDENT_CNT", 
				new Object[] {companyId, srchTxt}, 
				new int[] {Types.INTEGER, Types.VARCHAR});
	}
	
	/* 메인-검색-활동 */
	public List<Map<String,Object>> srchActList(long companyId, int startIndex, int pageSize, String srchTxt) throws CommonException {
		
		return mainDao.queryForList("COMMON.SELECT_MAIN_SRCH_ACT_LIST", startIndex, pageSize, 
				new Object[] {companyId, companyId, srchTxt}, 
				new int[] {Types.INTEGER, Types.INTEGER, Types.VARCHAR});
	}
	public int srchActCnt(long companyId, String srchTxt) throws CommonException {
		
		return mainDao.queryForInteger("COMMON.SELECT_MAIN_SRCH_ACT_CNT", 
				new Object[] {companyId, srchTxt}, 
				new int[] {Types.INTEGER, Types.VARCHAR});
	}
	
}