package kr.podosoft.ws.service.em.action;

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.em.EmService;
import kr.podosoft.ws.service.em.EmApplyService;

import architecture.ee.web.struts2.action.support.FrameworkActionSupport;

/**
 * 교육훈련 > 교육신청
 * @author thlim
 *
 */
public class EmApplyMainAction extends FrameworkActionSupport {
	
	private List<Map<String, Object>> items;
	private List<Map<String, Object>> items1;
	private Map<String, Object> item;
	
	private EmApplyService emApplyService;
	private EmService emService;
	
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

	public Map<String, Object> getItem() {
		return item;
	}

	public void setItem(Map<String, Object> item) {
		this.item = item;
	}

	public EmApplyService getEmApplyService() {
		return emApplyService;
	}

	public void setEmApplyService(EmApplyService emApplyService) {
		this.emApplyService = emApplyService;
	}

	public EmService getEmService() {
		return emService;
	}

	public void setEmService(EmService emService) {
		this.emService = emService;
	}

	/**
	 * 교육훈련 교육신청 메인페이지 호출
	 * @return
	 * @throws Exception
	 */
	public String viewSbjctApplyMain() throws Exception {
		log.info(this.getClass().getName());
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		// 기초정보
		this.item = emService.selectMyEduYear(companyid, userid);
		
		// 나의 역량진단 목록 조회
		this.items = emApplyService.selectMyCamList(companyid, userid);
		
		// 나의 경력개발계획 목록 조회
		//this.items1 = emApplyService.selectMyCdpList(companyid, userid);
		
		request.setAttribute("item", item);
		request.setAttribute("items", items);
		//request.setAttribute("items1", items1);
		
		return success();
	}
	
}
