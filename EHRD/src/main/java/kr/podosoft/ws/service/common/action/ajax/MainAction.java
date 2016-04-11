package kr.podosoft.ws.service.common.action.ajax;

import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.common.MainService;
import kr.podosoft.ws.service.utils.CommonUtils;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

public class MainAction extends FrameworkActionSupport {

	private static final long serialVersionUID = -1739370355727857659L;
	
	private MainService mainSrv;
	
	private List<Map<String,Object>> items1;
	private List<Map<String,Object>> items2;
	private List<Map<String,Object>> items3;
	private List<Map<String,Object>> items4;
	private List<Map<String,Object>> items5;
	
	private int totalItems1Count = 0;
	private int totalItems2Count = 0;
	private int totalItems3Count = 0;
	private int totalItems4Count = 0;
	private int totalItems5Count = 0;
	
	private String statement;
	
	private int sdClass = 0; // 학년
	
	private int startIndex = 0; // 페이지번호
	private int pageSize = 15; // 페이지사이즈
	
	private int year = 0;
	private int month = 0;
	private int day = 0;
	
	private int saveCount = 0 ;

	public int getSaveCount() {
		return saveCount;
	}

	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
	}

	public MainService getMainSrv() {
		return mainSrv;
	}

	public void setMainSrv(MainService mainSrv) {
		this.mainSrv = mainSrv;
	}

	public List<Map<String, Object>> getItems1() {
		return items1;
	}

	public void setItems1(List<Map<String, Object>> items1) {
		this.items1 = items1;
	}

	public List<Map<String, Object>> getItems2() {
		return items2;
	}

	public void setItems2(List<Map<String, Object>> items2) {
		this.items2 = items2;
	}

	public List<Map<String, Object>> getItems3() {
		return items3;
	}

	public void setItems3(List<Map<String, Object>> items3) {
		this.items3 = items3;
	}

	public int getTotalItems1Count() {
		return totalItems1Count;
	}

	public void setTotalItems1Count(int totalItems1Count) {
		this.totalItems1Count = totalItems1Count;
	}

	public int getTotalItems2Count() {
		return totalItems2Count;
	}

	public void setTotalItems2Count(int totalItems2Count) {
		this.totalItems2Count = totalItems2Count;
	}

	public int getTotalItems3Count() {
		return totalItems3Count;
	}

	public void setTotalItems3Count(int totalItems3Count) {
		this.totalItems3Count = totalItems3Count;
	}

	public int getSdClass() {
		return sdClass;
	}

	public void setSdClass(int sdClass) {
		this.sdClass = sdClass;
	}

	public int getStartIndex() {
		return startIndex;
	}

	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public int getMonth() {
		return month;
	}

	public void setMonth(int month) {
		this.month = month;
	}

	public int getDay() {
		return day;
	}

	public void setDay(int day) {
		this.day = day;
	}

	public String getStatement() {
		return statement;
	}

	public void setStatement(String statement) {
		this.statement = statement;
	}

	public List<Map<String, Object>> getItems4() {
		return items4;
	}

	public void setItems4(List<Map<String, Object>> items4) {
		this.items4 = items4;
	}

	public List<Map<String, Object>> getItems5() {
		return items5;
	}

	public void setItems5(List<Map<String, Object>> items5) {
		this.items5 = items5;
	}

	public int getTotalItems4Count() {
		return totalItems4Count;
	}

	public void setTotalItems4Count(int totalItems4Count) {
		this.totalItems4Count = totalItems4Count;
	}

	public int getTotalItems5Count() {
		return totalItems5Count;
	}

	public void setTotalItems5Count(int totalItems5Count) {
		this.totalItems5Count = totalItems5Count;
	}

	/**
	 * 공통 - 메인화면
	 * @return
	 * @throws Exception
	 */
	public String getMain() throws Exception {
		 List list = mainSrv.queryForList("COMMON.SELECT_MAIN_COMPANY_INFO", new Object[]{ getUser().getCompanyId() }, new int[]{ Types.NUMERIC});
		 
		// List list2 = mainSrv.queryForList("COMMON.SELECT_REQ_DIVISION_CNT", new Object[]{getUser().getCompanyId() }, new int[]{ Types.NUMERIC});
		 
		 Map map = new HashMap<String, Object>();
		 log.debug("!!list.size():"+list.size());
		 if(list!=null && list.size()>0){
			 map = (Map)list.get(0);
			 /*
			 String email = "";
			 String phone = "";
			 String cellphone = "";
			 
			 log.debug("map.get(EMAIL):"+map.get("EMAIL"));
			 if(map.get("EMAIL")!=null){
				 try{
					 email = CommonUtils.ASEDecoding(map.get("EMAIL").toString()); 
				 }catch(Exception e){ log.debug(e); }
			 }
			 log.debug(email+"-map.get(PHONE):"+map.get("PHONE"));
			 if(map.get("PHONE")!=null){
				 try{
					 phone = CommonUtils.ASEDecoding(map.get("PHONE").toString()); 
				 }catch(Exception e){ log.debug(e); }
			 }
			 log.debug(phone+"-map.get(CELLPHONE):"+map.get("CELLPHONE"));
			 if(map.get("CELLPHONE")!=null){
				 try{
					 cellphone = CommonUtils.ASEDecoding(map.get("CELLPHONE").toString()); 
				 }catch(Exception e){ log.debug(e); }
			 }

			 map.put("DEC_MAIL", email);
			 map.put("DEC_PHONE", phone);
			 map.put("DEC_CELLPHONE", cellphone);
			 */
		 }
		 /*if(list2!=null && list2.size()>0){
			 Map map2 = new HashMap<String, Object>();
			 map2 = (Map)list2.get(0);
			 String entrustCnt="";
			 if(map2.get("ENTRUST_CNT")!=null){
				 entrustCnt = map2.get("ENTRUST_CNT").toString(); 
			 }
			 log.debug("888888888888888888888888888"+map2.get("ENTRUST_CNT"));
			 request.setAttribute("ENTRUST_CNT", entrustCnt);
		 }*/
		 this.items1 = new ArrayList();
		 this.items1.add(map);
		 
		return success();
	}
	//부서원 직무관리
	public String getJobAdmin() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				companyId,userId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_MY_JOB_LIST", params, jdbcTypes);
		this.items2 = mainSrv.queryForList("COMMON.GET_JOB_LIST", null, null);
		return success();	
	}
	//부서원 목록
	public String getJobAdminList() throws Exception {

		this.items1 = mainSrv.queryForList("COMMON.GET_JOB_LIST", null, null);
		return success();	
	}
	
	//부서원 직무변경
	public String setJobAdmin() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		String setUserJob = ParamUtils.getParameter(request, "setUserJob");
		String userId = ParamUtils.getParameter(request, "userId");
		
		Object [] params = {
				setUserJob, userId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		this.saveCount = mainSrv.update("COMMON.SET_TEAM_JOB", params, jdbcTypes);
		return success();	
	}
	
	//계획대비 실행율
	public String getCdpPlanStateRate() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				yyyy, userId,
				yyyy, userId, companyId,
				yyyy, userId, companyId,
				yyyy, userId, companyId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_CDP_PLAN_STATE_RATE", params, jdbcTypes);
		return success();	
	}
	
	//역량진단 파라미터get
	public String getMainCamUserInfo() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				userId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_MAIN_CAM_USER_INFO", params, jdbcTypes);
		return success();	
	}
	//역량진단 결과
	public String getMainCamRes() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		String runNum = ParamUtils.getParameter(request, "RUN_NUM");
		String job = ParamUtils.getParameter(request, "JOB");
		String leadership = ParamUtils.getParameter(request, "LEADERSHIP");
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				companyId,runNum,userId,
				//companyId,runNum,job,
				//companyId,runNum,leadership
				
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,
				//Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,
				//Types.NUMERIC,Types.NUMERIC,Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_MAIN_CAM_RES", params, jdbcTypes);
		return success();	
	}
	//연간상시학습 이수현황
	public String getAlwEduList() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		
		long userId = getUser().getUserId();
		long companyId = getUser().getCompanyId();
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		
		Object [] params = {
				yyyy,userId,
				yyyy,userId,
				yyyy,userId,companyId,
				yyyy,userId,companyId,
				yyyy,userId,companyId,
				yyyy,userId,companyId,
		}; 
		int[] jdbcTypes = {
				Types.VARCHAR, Types.NUMERIC,
				Types.VARCHAR, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_MAIN_ALW_EDU", params, jdbcTypes);
		return success();	
	}
	//부처지정학습 이수현황
	public String getReqList() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		String yyyy = ParamUtils.getParameter(request, "yyyy");
		long userId = getUser().getUserId();
		long companyId = getUser().getCompanyId();
		
		Object [] params = {
				yyyy ,yyyy ,yyyy,companyId,userId ,yyyy,companyId,userId, yyyy,companyId,userId, 
				yyyy,companyId,userId,yyyy,companyId,userId,userId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,
				Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,
				Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_REQ_LIST", params, jdbcTypes);
		return success();	
	}
	//승인 요청/처리 현황 > 교육
	public String getEduAppData() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		String yyyy = ParamUtils.getParameter(request, "yyyy");
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				userId,yyyy,companyId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC,Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_MY_EDU_APP_DATA", params, jdbcTypes);
		this.items2 = mainSrv.queryForList("COMMON.GET_ALW_EDU_APP_DATA", params, jdbcTypes);
		return success();	
	}
	
	
	//승인 처리 현황 > 교육추천승인
	public String getEduRecommAppCntData() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		String yyyy = ParamUtils.getParameter(request, "yyyy");
		
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				userId,yyyy,companyId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC,Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_MY_EDU_RECOMM_APP_CNT_DATA", params, jdbcTypes);
		return success();	
	}
	
	//승인 요청/처리 현황 > 교육
	public String getEduAppCntData() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		String yyyy = ParamUtils.getParameter(request, "yyyy");
		
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				//userId,yyyy,companyId,userId,yyyy,companyId
				userId,yyyy,companyId,userId,yyyy,companyId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_MY_EDU_APP_CNT_DATA", params, jdbcTypes);
		return success();	
	}
	
	//승인 요청/처리 현황 > 경력개발계획
	public String getCdpAppData() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				companyId,userId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_CDP_APP_DATA", params, jdbcTypes);
		return success();	
	}
	//승인 요청/처리 현황 > 계획승인
	public String getCdpAppCntData() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				companyId,userId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_CDP_APP_CNT_DATA", params, jdbcTypes);
		return success();	
	}
	//승인 요청/처리 현황 > 멘토링
	public String getMtrAppData() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				companyId,userId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_MTR_APP_DATA", params, jdbcTypes);
		return success();	
	}
	//처리 현황 > 멘토링
	public String getMtrData() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				userId,companyId,userId,userId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_MTR_DATA", params, jdbcTypes);
		return success();	
	}

	//메인하단 quick_menu
	public String getQmenuData() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				companyId,userId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.SELECT_USER_MENU", params, jdbcTypes);
		return success();	
	}
	//main-quick-menu-popup
	public String getMainMenuPop() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		Object [] params = {
				userId
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC
		};
		this.items1 = mainSrv.queryForList("COMMON.GET_MAIN_CAM_USER_INFO", params, jdbcTypes);
		return success();	
	}
	/**
	 * 
	 * Quick Menu - 등록<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 04.
	 */
	public String selectQuickMenu() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		this.saveCount = mainSrv.selectQuickMenu(request, getUser());
		return success();
	}
	/**
	 * 
	 * Quick Menu - 삭제<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 04.
	 */
	public String deleteQuickMenu() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		this.saveCount = mainSrv.deleteQuickMenu(request, getUser());
		return success();
	}
	/**
	 * 메인화면 - 성과평가정보
	 * @return
	 * @throws Exception
	 */
	public String getMainOtcInfo() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		
		this.items1 = mainSrv.queryForList("COMMON.SELECT_MAIN_OTC_RUN", new Object[]{companyId,userId}, new int[]{Types.NUMERIC, Types.NUMERIC});
		return success();
	}
	
	/**
	 * 메인화면 - 성과평가 현황 정보 
	 * @return
	 * @throws Exception
	 */
	public String getMainChartInfo() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		
		List list = mainSrv.queryForList("COMMON.SELECT_MAIN_OTC_RUN", new Object[]{companyId,userId}, new int[]{Types.NUMERIC, Types.NUMERIC});
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			int runNum = Integer.parseInt(map.get("RUN_NUM").toString());
			this.items1 = mainSrv.queryForList("COMMON.SELECT_MAIN_OTC_RATE", new Object[]{ companyId,userId,runNum,companyId,userId,runNum }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		}
		return success();
	}
	
	/**
	 * 메인화면 - 게시물 목록 정보 
	 * @return
	 * @throws Exception
	 */
	public String getMainBoardList() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		
		this.items1 = mainSrv.queryForList("COMMON.SELECT_MAIN_BOARD_LIST", new Object[]{ companyId }, new int[]{ Types.NUMERIC });
		return success();
	}
	

	/**
	 * 메인화면 - 부서원역량평가현황 정보 
	 * @return
	 * @throws Exception
	 */
	public String getMainDeptCmptInfo() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		this.items1 = mainSrv.queryForList("COMMON.SELECT_MAIN_DEPT_CMPT_INFO", new Object[]{ companyId, userId,  companyId }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		return success();
	}

	/**
	 * 메인화면 - 부서원성과평가 요청현황 정보 
	 * @return
	 * @throws Exception
	 */
	public String getMainDeptOtcReqInfo() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		List list = mainSrv.queryForList("COMMON.SELECT_MAIN_DEPT_OTC_RUN_INFO", new Object[]{ companyId, companyId, companyId, userId }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			int runNum = Integer.parseInt(map.get("RUN_NUM").toString());
			this.items1 = mainSrv.queryForList("COMMON.SELECT_MAIN_DEPT_OTC_REQ_LIST", new Object[]{ companyId, runNum, companyId, companyId, userId }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC  });
		}
		
		return success();
	}

	/**
	 * 메인화면 - 부서 평가 현황 정보 
	 * @return
	 * @throws Exception
	 */
	public String getMainDeptTtInfo() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		this.items1 = mainSrv.queryForList("COMMON.SELECT_MAIN_DEPT_TT_INFO", new Object[]{ companyId }, new int[]{ Types.NUMERIC });
		return success();
	}
	
	/**
	 * 메인화면 - 부서 평가 현황 점수 
	 * @return
	 * @throws Exception
	 */
	public String getMainDeptTtScore() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		List list = mainSrv.queryForList("COMMON.SELECT_MAIN_DEPT_TT_INFO", new Object[]{ companyId }, new int[]{ Types.NUMERIC });
		
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			int ttEvlNo = Integer.parseInt(map.get("TT_EVL_NO").toString());
			this.items1 = mainSrv.queryForList("COMMON.SELECT_MAIN_DEPT_TT_SCORE", new Object[]{ companyId, ttEvlNo, companyId, companyId, userId }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC  });
		}
		return success();
	}

	/**
	 * 메인화면 - 나의 역량평가 정보 
	 * @return
	 * @throws Exception
	 */
	public String getMainMyCmptInfo() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		this.items1 = mainSrv.queryForList("COMMON.SELECT_MAIN_MY_CMPT_INFO", new Object[]{ companyId, userId, companyId, userId, companyId, userId, companyId, userId }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	/**
	 * 메인화면 - 나의 성과평가  정보 
	 * @return
	 * @throws Exception
	 */
	public String getMainMyOtcRunInfo() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		List tmpList = mainSrv.queryForList("COMMON.SELECT_MAIN_MY_OTC_RUN_INFO", new Object[]{ companyId, userId }, new int[]{ Types.NUMERIC, Types.NUMERIC });
		if(tmpList!=null && tmpList.size()>0){
			Map map = (Map)tmpList.get(0);
			int runNum =  Integer.parseInt(map.get("RUN_NUM").toString());
			List list = mainSrv.queryForList("COMMON.SELECT_MAIN_MY_OTC_MONTH_KPI_LIST", new Object[]{ companyId, runNum, companyId, companyId, runNum, userId, companyId, runNum, userId }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
			map.put("obj", list);
			
			this.items1 = new ArrayList();
			this.items1.add(map);
			
		}
		return success();
	}

	/**
	 * 메인화면 - 나의 설문목록
	 * @return
	 * @throws Exception
	 */
	public String getMainMySvList() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		this.items1 = mainSrv.queryForList("COMMON.SELECT_MAIN_MY_SV_LIST", new Object[]{ companyId, userId }, new int[]{ Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	

	/**
	 * 메인화면 - 비밀번호 조회
	 * @return
	 * @throws Exception
	 */
	public String saveMainPwd() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		String returnVal = "X";
		int saveCount = 0;
		String oldPwd = ParamUtils.getParameter(request, "OLD_PWD");
		String newPwd = ParamUtils.getParameter(request, "NEW_PWD");
		String incOldPwd = CommonUtils.passwdEncoding(oldPwd);
		
		List list = mainSrv.queryForList("COMMON.SELECT_MAIN_PWD_INFO", new Object[]{ companyId, userId }, new int[]{ Types.NUMERIC, Types.NUMERIC });
		if( list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			String incPwd = "";
			if(map.get("PASSWORD")!=null){
				incPwd = map.get("PASSWORD").toString();
			}
			log.debug("## incPwd     :"+incPwd);
			log.debug("## incOldPwd:"+incOldPwd);
			
			if(incOldPwd.equals(incPwd)){
				String incNewPwd = CommonUtils.passwdEncoding(newPwd);
				log.debug("## incNewPwd:"+incNewPwd);
				saveCount = mainSrv.update("COMMON.UPDATE_PASSWORD", new Object[]{incNewPwd, companyId, userId}, new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC });
				
				if(saveCount>0){
					returnVal = "Y";
				}else{
					returnVal = "N";
				}
			}
		}
		this.statement = returnVal;
		return success();
	}
	
	/**
	 * 
	 * 고객사 홈페이지 테마 조회<br/>
	 *
	 * @return
	 * @throws CommonException
	 * @since 2014. 5. 22.
	 */
	public String getCompanyType() throws CommonException{
		long companyid = getUser().getUserId();
		this.statement = mainSrv.queryForObject("COMMON.SELECT_COMPANY_TYPE", new Object[]{companyid}, new int[]{Types.NUMERIC}, String.class).toString();
		return success();
	}

	/**
	 * 메인화면 - 역량진단 결과 -역량진단> 
	 * @return
	 * @throws Exception
	 */
	public String getMainMyClass() throws Exception {
		// 사용자 정보
		long companyId = getUser().getCompanyId();
		long userId = getUser().getUserId();
		this.items1 = mainSrv.queryForList("COMMON.SELECT_MY_ALW_CLASS_MAIN", new Object[]{ companyId, userId, companyId, userId, companyId, userId, companyId, userId }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	/**
	 * 메인 > 권한위임 > 정보
	 */
	public String getMainAdminReqList() throws Exception {

		this.items1 = mainSrv.queryForList("COMMON.SELECT_EDU_DIVISION_INFO", 
				new Object[] {
				getUser().getCompanyId(),
				getUser().getUserId(),
				}, 
				new int[] {
				Types.NUMERIC, Types.NUMERIC
				});
		return success();
	}
	/**
	 * 
	 * 교육담당자 요청<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 04.
	 */
	public String mainEduAdminReq() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		this.saveCount = mainSrv.mainEduAdminReq(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 교육담당자 추가 변경 - 승인<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 04.
	 */
	public String mainEduAdminApp() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		this.saveCount = mainSrv.mainEduAdminApp(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 교육담당자 요청 리스트 <br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 12. 17.
	 */	
	public String getMainAdminEduReqList() throws Exception {
		
		String reqDivCd = ParamUtils.getParameter(request, "REQ_DIV_CD");
		
		this.items1 = mainSrv.queryForList("COMMON.SELECT_EDU_DIVISION_CH_LIST", 
				new Object[] {
				getUser().getCompanyId(),
				reqDivCd,
				}, 
				new int[] {
				Types.NUMERIC, Types.VARCHAR
				});
		return success();
	}
	
	/**
	 * 
	 * 교육담당자 요청 리스트 <br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 12. 17.
	 */	
	public String getMainAdminEduCnt() throws Exception {
		
		this.items1 = mainSrv.queryForList("COMMON.SELECT_REQ_DIVISION_CNT", 
				new Object[] {
				getUser().getCompanyId()
				}, 
				new int[] {
				Types.NUMERIC
				});
		return success();
	}
	/**
	 * 
	 * 교육담당자 추가 변경 - 승인<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 04.
	 */
	public String mainEduAdminDel() throws Exception {
		log.debug(CommonUtils.printParameter(request));
		this.saveCount = mainSrv.mainEduAdminDel(request, getUser());
		return success();
	}
	/**
	 * 
	 * 교육담당자 추가 중복체크 <br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 12. 17.
	 */	
	public String getMainAdminEduInsertCnt() throws Exception {
		String userid = ParamUtils.getParameter(request, "USERID");
		
		this.items1 = mainSrv.queryForList("COMMON.SELECT_EDU_INSERT_OVERLAP", 
				new Object[] {
				getUser().getCompanyId() , userid
				}, 
				new int[] {
				Types.NUMERIC,Types.NUMERIC
				});
		return success();
	}

	
	
	
}
