package kr.podosoft.ws.service.em.action.ajax;

/**
 * 학습자
 * 교육훈련 > 상시학습
 */

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.em.EmAlwService;
import kr.podosoft.ws.service.em.EmServiceException;
import kr.podosoft.ws.service.utils.CommonUtils;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

public class EmAlwServiceAction extends FrameworkActionSupport {
	
	private int totalItemCount = 0;
	private int saveCount = 0;
	private int year = 0;
	private List<Map<String, Object>> items;
	private List<Map<String, Object>> items1;
	private List<Map<String, Object>> items2;
	private Map<String, Object> item;
	private String statement ;
	
	private int asSeq = 0; // 상시학습번호
	
	private EmAlwService emAlwService;

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

	public EmAlwService getEmAlwService() {
		return emAlwService;
	}

	public void setEmAlwService(EmAlwService emAlwService) {
		this.emAlwService = emAlwService;
	}
	
	public Map<String, Object> getItem() {
		return item;
	}

	public void setItem(Map<String, Object> item) {
		this.item = item;
	}
	public int getAsSeq() {
		return asSeq;
	}

	public void setAsSeq(int asSeq) {
		this.asSeq = asSeq;
	}

	/**
	 * 교육훈련 > 상시학습
	 * 목록 조회
	 * @return
	 * @throws EmServiceException
	 */
	public String selectAlwList() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		this.items = emAlwService.selectAlwList(companyid, userid);
		this.totalItemCount = this.items.size();
		
		return success();
	};
	
	/**
	 * 교육훈련 > 상시학습
	 * 상세 조회
	 * @return
	 * @throws EmServiceException
	 */
	public String selectAlwDtl() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		

		this.item = emAlwService.selectAlwDtl(companyid, userid, asSeq);
		
		return success();
	};
	
	/**
	 * 교육훈련 > 상시학습
	 * 등록/수정
	 * @return
	 * @throws EmServiceException
	 */
	public String insertAlwInf() throws EmServiceException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		Map<String,Object> param = new HashMap<String,Object>();
		
		// 파라메터 추출
		param.put("mod", 			ParamUtils.getParameter(request, "mod"));
		// 수정일 경우
		if(ParamUtils.getParameter(request, "mod", "").equals("mod")) {
			param.put("asseq", 		ParamUtils.getParameter(request, "asseq"));
		} else {
			param.put("asseq", 		"");
		}
    	param.put("objectid", 		ParamUtils.getParameter(request, "objectid"));
    	param.put("trainingCode", 	ParamUtils.getParameter(request, "trainingCode"));
    	param.put("subjectNm", 		ParamUtils.getParameter(request, "subjectNm"));
    	param.put("ttGetSco", 		ParamUtils.getParameter(request, "ttGetSco"));
    	param.put("yyyy", 			ParamUtils.getParameter(request, "yyyy","0"));
    	param.put("eduStime", 		ParamUtils.getParameter(request, "eduStime"));
    	param.put("eduEtime", 		ParamUtils.getParameter(request, "eduEtime"));
    	param.put("eduHourH", 		ParamUtils.getParameter(request, "eduHourH","0"));
    	param.put("eduHourM", 		ParamUtils.getParameter(request, "eduHourM","0"));
    	param.put("recogTimeH", 	ParamUtils.getParameter(request, "recogTimeH","0"));
    	param.put("recogTimeM", 	ParamUtils.getParameter(request, "recogTimeM","0"));
    	param.put("eduCont", 		ParamUtils.getParameter(request, "eduCont"));
    	param.put("alwStdCd", 		ParamUtils.getParameter(request, "alwStdCd"));
    	param.put("deptDesignationYn", ParamUtils.getParameter(request, "deptDesignationYn"));
    	param.put("deptDesignationCd", ParamUtils.getParameter(request, "deptDesignationCd"));
    	param.put("perfAsseSbjCd", 	ParamUtils.getParameter(request, "perfAsseSbjCd"));
    	param.put("officeTimeCd", 	ParamUtils.getParameter(request, "officeTimeCd"));
    	param.put("eduinsDivCd", 	ParamUtils.getParameter(request, "eduinsDivCd"));
    	param.put("instituteCode", 	ParamUtils.getParameter(request, "instituteCode"));
    	param.put("instituteName", 	ParamUtils.getParameter(request, "instituteName"));
    	param.put("requiredYn", 	ParamUtils.getParameter(request, "requiredYn"));
    	param.put("gradeNum", ParamUtils.getParameter(request, "gradeNum"));
    	param.put("cmpnumber", ParamUtils.getParameter(request, "cmpnumber"));
        
    	List<Map<String,Object>> apprList = ParamUtils.getJsonParameter(request, "apprList", List.class);
		
		this.statement = emAlwService.insertAlwInf(companyid, userid, param, apprList);
		
		return success();
	}
	
	/**
	 * 교육훈련 > 상시학습
	 * 취소
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
		
		this.statement = emAlwService.updateAlwCancel(companyid, userid, asSeq);
		
		return success();
	}
	

	/**
	 * 교육훈련 > 상시학습
	 * 상시학습종류별 연간인정시간 체크
	 * @return
	 * @throws EmServiceException
	 */
	public String yearRecogLimitCheck() throws CommonException {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		//long userid = getUser().getUserId();
		
		Map<String,Object> param = new HashMap<String,Object>();
		
		// 파라메터 추출
		param.put("asOpenSeq", ParamUtils.getParameter(request, "asOpenSeq", ""));
		param.put("tUserid", ParamUtils.getParameter(request, "tUserid", ""));
		param.put("eduDiv", ParamUtils.getParameter(request, "eduDiv", ""));
    	param.put("yyyy", 	ParamUtils.getParameter(request, "yyyy",""));
    	param.put("recogTimeH", 	ParamUtils.getParameter(request, "recogTimeH","0"));
    	param.put("recogTimeM", 	ParamUtils.getParameter(request, "recogTimeM","0"));
    	param.put("alwStdCd", 		ParamUtils.getParameter(request, "alwStdCd", ""));
    	
		this.statement = emAlwService.yearRecogLimitCheck(companyid, param);
		
		return success();
	}
	
}
