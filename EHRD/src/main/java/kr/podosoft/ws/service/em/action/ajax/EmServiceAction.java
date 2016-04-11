package kr.podosoft.ws.service.em.action.ajax;

/**
 * 학습자
 * 교육훈련 > 나의강의실
 */

import java.sql.Types;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.common.CommonService;
import kr.podosoft.ws.service.em.EmService;
import kr.podosoft.ws.service.em.EmServiceException;
import kr.podosoft.ws.service.utils.CommonUtils;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

public class EmServiceAction extends FrameworkActionSupport {
	
	private int totalItemCount = 0;
	private int saveCount = 0;
	private int year = 0;
	private List<Map<String, Object>> items;
	private List<Map<String, Object>> items1;
	private List<Map<String, Object>> items2;
	private Map<String, Object> item;
	private String statement ;
	
	private int openNum = 0; // 과정개설번호
	private int eduTp = 0; // 과정구분(1:일반,2:상시)
	
	private EmService emService;
	
	private CommonService commonSrv;

	public int getTotalItemCount() {
		return totalItemCount;
	}

	public void setTotalItemCount(int totalItemCount) {
		this.totalItemCount = totalItemCount;
	}

	public int getSaveCount() {
		return saveCount;
	}

	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public List<Map<String, Object>> getItems() {
		return items;
	}

	public void setItems(List<Map<String, Object>> items) {
		this.items = items;
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

	public String getStatement() {
		return statement;
	}

	public void setStatement(String statement) {
		this.statement = statement;
	}

	public EmService getEmService() {
		return emService;
	}

	public void setEmService(EmService emService) {
		this.emService = emService;
	}
	
	public Map<String, Object> getItem() {
		return item;
	}

	public void setItem(Map<String, Object> item) {
		this.item = item;
	}

	public int getOpenNum() {
		return openNum;
	}

	public void setOpenNum(int openNum) {
		this.openNum = openNum;
	}

	public int getEduTp() {
		return eduTp;
	}

	public void setEduTp(int eduTp) {
		this.eduTp = eduTp;
	}

	
	public CommonService getCommonSrv() {
		return commonSrv;
	}

	public void setCommonSrv(CommonService commonSrv) {
		this.commonSrv = commonSrv;
	}

	/**
	 * 교육훈련 > 나의강의실 > 학습현황
	 * 이수현황 조회
	 * @return
	 * @throws EmServiceException
	 */
	public String selectTakeEduList() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		Calendar cal = Calendar.getInstance();
		
		int year = Integer.parseInt(ParamUtils.getParameter(request, "year", cal.get(Calendar.YEAR)+""));
		
		// 이수 현황 점수 조회
		Map<String,List<Map<String,Object>>> data = emService.selectMyReqEduScr(companyid, userid, year);
		
		if(data!=null) {
			// 이수현황
			if(data.get("items")!=null)
				this.item = data.get("items").get(0);
			
			log.debug("############## "+data.get("items").get(0).get("VA_TAKE_TIME"));
			
			// 필수 이수 현황 조회
			if(data.get("items1")!=null)
				this.items1 = data.get("items1");
			
			// 기광성과평가 이수 현황 조회
			if(data.get("items2")!=null)
				this.items2 = data.get("items2");
		}
		
		return success();
	};

	/**
	 * 교육훈련 > 나의강의실 > 학습현황
	 * 교육훈련 > 나의강의실 > 승진교육이수현황
	 * 목록 조회
	 * @return
	 * @throws EmServiceException
	 */
	public String selectEduSttList() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		String _bdate = "";

		Calendar cal = Calendar.getInstance();
		
		int year = Integer.parseInt(ParamUtils.getParameter(request, "year", cal.get(Calendar.YEAR)+""));
		int type = Integer.parseInt(ParamUtils.getParameter(request, "type", "1"));
		
		// 승진기준달성현황에서 해당 로직 사용 시 화면에서  userid 를 보냄
		//총괄관리자 권한 여부..
		boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
		//고객사운영자 권한 여부..
		boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
		//부서장 권한 여부..
		boolean isManager = request.isUserInRole("ROLE_MANAGER");
		if(isSystem || isOperator || isManager){
			String _userid = ParamUtils.getParameter(request, "userid");
			_bdate = ParamUtils.getParameter(request, "bdate"); // 기준일
			if(_userid!=null && !_userid.equals("")) {
				userid = Long.parseLong(_userid);
			}
		}
		
		this.items = emService.selectEduSttList(companyid, userid, year, type, _bdate);
		this.totalItemCount = this.items.size();
		
		return success();
	};
	
	/**
	 * 교육훈련 > 나의강의실
	 * 상세 조회
	 * @return
	 * @throws EmServiceException
	 */
	public String selectEduSttDtl() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		if(eduTp==1) {
			// 일반교육 상세정보
			this.item = emService.selectMyClassDtl(companyid, userid, openNum);
		} else if(eduTp==2) {
			// 상시학습 상세정보
			this.item = emService.selectMyClassAlwDtl(companyid, userid, openNum);
		}
		
		return success();
	};
	
	/**
	 * 교육훈련 > 나의강의실 > 학습현황
	 * 교육 수강상태 취소처리
	 * @return
	 * @throws EmServiceException
	 */
	public String updateEduCancel() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		this.statement = emService.updateEduCancel(companyid, userid, openNum);
		
		return success();
	}
	
	/**
	 * 교육훈련 > 나의강의실 > 학습현황
	 * 학습에 도움이 된 역량을 저장
	 * @return
	 * @throws EmServiceException
	 */
	public String updateEduCmpnumber() throws CommonException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();

		int cmpnumber = Integer.parseInt(ParamUtils.getParameter(request, "cmpnumber", "0"));
		int div = Integer.parseInt(ParamUtils.getParameter(request, "div", "1"));
		
		if(div == 1){
			//정규과정
			saveCount = commonSrv.update("EM.UPDATE_EDU_CMPNUMBER", new Object[]{cmpnumber, userid, openNum, companyid}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		}else{
			//상시학습
			saveCount = commonSrv.update("EM.UPDATE_ALW_CMPNUMBER", new Object[]{cmpnumber, openNum, companyid}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		}
		
		return success();
	}
	
	
	
	
}
