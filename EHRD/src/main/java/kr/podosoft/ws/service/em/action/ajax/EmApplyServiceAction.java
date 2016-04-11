package kr.podosoft.ws.service.em.action.ajax;

/**
 * 학습자
 * 교육훈련 > 교육신청
 */

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.em.EmApplyService;
import kr.podosoft.ws.service.em.EmServiceException;
import kr.podosoft.ws.service.utils.CommonUtils;

import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

public class EmApplyServiceAction extends FrameworkActionSupport {
	
	private int pageSize = 15; // Page MaxSize
    private int startIndex = 0; // current Page Number
    
    private String sortField; // Grid Sort Field Name
	private String sortDir; // Grid Sort Order 
    private Filter filter; // Grid Filter Option
    
    private int runNum = 0; // 역량진단 실시번호
    private String fromDate; // 교육시작일 from
    private String toDate; // 교육시작일 to
    private int type = 1; // 검색유형(1:역량진단, 2:경력개발계획, 3:일반신청)
    private int cmpnumber = 0; // 역량번호
    
    private int openNum = 0; // 과정개설번호    
	
	private int totalItemCount = 0;
	private List<Map<String, Object>> items;
	private List<Map<String, Object>> items1;
	private List<Map<String, Object>> items2;
	private Map<String, Object> item;
	
	private int saveCount = 0;
	private String statement ;
	
	private EmApplyService emApplyService;

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getStartIndex() {
		return startIndex;
	}

	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}

	public String getSortField() {
		return sortField;
	}

	public void setSortField(String sortField) {
		this.sortField = sortField;
	}

	public String getSortDir() {
		return sortDir;
	}

	public void setSortDir(String sortDir) {
		this.sortDir = sortDir;
	}

	public int getRunNum() {
		return runNum;
	}

	public void setRunNum(int runNum) {
		this.runNum = runNum;
	}

	public String getFromDate() {
		return fromDate;
	}

	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}

	public String getToDate() {
		return toDate;
	}

	public void setToDate(String toDate) {
		this.toDate = toDate;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public int getOpenNum() {
		return openNum;
	}

	public void setOpenNum(int openNum) {
		this.openNum = openNum;
	}

	public int getTotalItemCount() {
		return totalItemCount;
	}

	public void setTotalItemCount(int totalItemCount) {
		this.totalItemCount = totalItemCount;
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

	public Map<String, Object> getItem() {
		return item;
	}

	public void setItem(Map<String, Object> item) {
		this.item = item;
	}

	public int getSaveCount() {
		return saveCount;
	}

	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
	}

	public String getStatement() {
		return statement;
	}

	public void setStatement(String statement) {
		this.statement = statement;
	}

	public EmApplyService getEmApplyService() {
		return emApplyService;
	}

	public void setEmApplyService(EmApplyService emApplyService) {
		this.emApplyService = emApplyService;
	}
	
	/**
	 * 교육훈련 > 교육신청
	 * 역량진단 결과목록
	 * @return
	 * @throws EmServiceException
	 */
	public String selectMyCarScrList() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		this.items = emApplyService.selectMyCarScrList(companyid, userid, runNum);
		
		return success();
	};

	/**
	 * 교육훈련 > 교육신청 > 역량진단
	 * 교육훈련 > 교육신청 > 경력개발계획
	 * 교육훈련 > 교육신청 > 일반신청
	 * 목록 조회(페이징)
	 * @return
	 * @throws EmServiceException
	 */
	public String selectSbjctOpenList() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		// 필터 객체는 json type 으로 전송되므로 별도 처리
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		if(type==1) {
			this.items = emApplyService.selectMyCamSbjctOpenList(companyid, userid, startIndex, pageSize, filter, sortField, sortDir, runNum, fromDate, toDate, cmpnumber);
		//} else if(type==2) {
		//	this.items = emApplyService.selectMyCdpSbjctOpenList(companyid, userid, startIndex, pageSize, filter, sortField, sortDir, runNum, fromDate, toDate);
		} else if(type==3) {
			this.items = emApplyService.selectSbjctOpenList(companyid, userid, startIndex, pageSize, filter, sortField, sortDir, fromDate, toDate);
		}
		
		if(this.items !=null && this.items.size()>0){
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	};
	
	/**
	 * 교육훈련 > 교육신청
	 * 상세 조회
	 * @return
	 * @throws EmServiceException
	 */
	public String selectSbjctOpenDtl() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		this.item = emApplyService.selectSbjctOpenDtl(companyid, userid, openNum);
		
		return success();
	};
	
	/**
	 * 교육훈련 > 교육신청
	 * 교육 신청처리
	 * @return
	 * @throws EmServiceException
	 */
	public String updateSbjctApply() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		// 결재라인
		List<Map<String,Object>> approvedList = ParamUtils.getJsonParameter(request, "apprList", List.class);
		
		this.statement = emApplyService.updateSbjctApply(companyid, userid, openNum, approvedList);
		
		return success();
	}
	
	
	
	
}
