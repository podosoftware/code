package kr.podosoft.ws.service.ba.action.admin;

import java.util.Calendar;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.BaEducationService;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

public class BaMgmtEducationAction extends FrameworkActionSupport {

	private static final long serialVersionUID = -3773828802855727336L;
	
	private int pageSize = 15 ;
    private int startIndex = 0 ;
	
	private int studentId; // 수강생번호
	private String subjectNum; // 과정번호
	private int year; // 과정개설년도
	private int chasu; // 과정개설차수
	
	private String cspSubjectNum; // lms 과정번호
	private String cspSubjectChasu; // lms 과정개설차수
	
	private BaEducationService baEducationSrv;
	
	private List<Map<String,Object>> items;
	private List<Map<String,Object>> items2;
	private List<Map<String,Object>> items3;
	
	private int totalItemCount = 0;
	private int totalItem2Count = 0;
	private int totalItem3Count = 0;
	
	private String statement;

	public int getStudentId() {
		return studentId;
	}

	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}

	public String getSubjectNum() {
		return subjectNum;
	}

	public void setSubjectNum(String subjectNum) {
		this.subjectNum = subjectNum;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public int getChasu() {
		return chasu;
	}

	public void setChasu(int chasu) {
		this.chasu = chasu;
	}

	public String getCspSubjectNum() {
		return cspSubjectNum;
	}

	public void setCspSubjectNum(String cspSubjectNum) {
		this.cspSubjectNum = cspSubjectNum;
	}

	public String getCspSubjectChasu() {
		return cspSubjectChasu;
	}

	public void setCspSubjectChasu(String cspSubjectChasu) {
		this.cspSubjectChasu = cspSubjectChasu;
	}

	public BaEducationService getBaEducationSrv() {
		return baEducationSrv;
	}

	public void setBaEducationSrv(BaEducationService baEducationSrv) {
		this.baEducationSrv = baEducationSrv;
	}

	public List<Map<String, Object>> getItems() {
		return items;
	}

	public void setItems(List<Map<String, Object>> items) {
		this.items = items;
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

	public int getTotalItemCount() {
		return totalItemCount;
	}

	public void setTotalItemCount(int totalItemCount) {
		this.totalItemCount = totalItemCount;
	}

	public int getTotalItem2Count() {
		return totalItem2Count;
	}

	public void setTotalItem2Count(int totalItem2Count) {
		this.totalItem2Count = totalItem2Count;
	}

	public int getTotalItem3Count() {
		return totalItem3Count;
	}

	public void setTotalItem3Count(int totalItem3Count) {
		this.totalItem3Count = totalItem3Count;
	}

	public String getStatement() {
		return statement;
	}

	public void setStatement(String statement) {
		this.statement = statement;
	}
	
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

	/**
	 * 학사관리 > 교육운영관리
	 * 교육이력 목록
	 * @return
	 * @throws BaException
	 */
	public String getMgmtEducationList() throws BaException {
		
		if(year<1) {
			Calendar cal = Calendar.getInstance();
			year = cal.get(Calendar.YEAR);
		}
	
		items = baEducationSrv.getEducationList(getUser().getCompanyId(), getUser().getUserId(), year, false, pageSize,
						startIndex);
		
		totalItemCount = baEducationSrv.getEducationCnt(getUser().getCompanyId(), getUser().getUserId(), year);
		
		return success();
	}
	
	
	/**
	 * 학사관리 > 교육운영관리
	 * 교육이력 상세
	 * @return
	 * @throws BaException
	 */
	public String getMgmtEducationInfo() throws BaException {
		// 신청상세정보
		items = baEducationSrv.getEducationInfo(
					getUser().getCompanyId(), getUser().getUserId(), subjectNum, year, chasu,
					studentId);
		
		totalItemCount = items.size();
		
		// 결제정보
		items2 = baEducationSrv.getEducationSettlementInfo(
					getUser().getCompanyId(), getUser().getUserId(), subjectNum, year, chasu,
					studentId);
		
		totalItem2Count = items2.size();
		
		return success();
	}
	
	
	/**
	 * 학사관리 > 교육운영관리
	 * 교육취소요청 완료처리
	 * @return
	 * @throws BaException
	 */
	public String setMgmtEduCancelSettle() throws BaException {
		
		if(subjectNum!=null && year>0 && chasu>0 && studentId>0) {
			statement = baEducationSrv.setEduCancelSettle(
					getUser().getCompanyId(), getUser().getUserId(), subjectNum, year, chasu,
					studentId);
		} else {
			statement = "N";
		}
		
		return success();
	}
	
	
	/**
	 * 학사관리 > 교육운영관리
	 * 교육이력정보 수강정보 수정
	 * @return
	 * @throws BaException
	 */
	public String setMgmtEduScore() throws BaException {
		String progressRate = ParamUtils.getStringParameter(request, "prgrssRt", "0");
		String progressPoint = ParamUtils.getStringParameter(request, "prgrssPnt", "0");
		String discussPoint = ParamUtils.getStringParameter(request, "dscssPnt", "0");
		String examPoint = ParamUtils.getStringParameter(request, "exmPnt", "0");
		String taskPoint = ParamUtils.getStringParameter(request, "tskPnt", "0");
		String totalPoint = ParamUtils.getStringParameter(request, "ttlPnt", "0");
		
		if(subjectNum!=null && year>0 && chasu>0 && studentId>0) {
			statement = baEducationSrv.setEduScore(
					getUser().getCompanyId(), getUser().getUserId(), subjectNum, year, chasu,
					studentId, progressRate, progressPoint, discussPoint, examPoint, 
					taskPoint, totalPoint);
		} else {
			statement = "N";
		}
		
		return success();
	}
	
	
	/**
	 * 학사관리 > 교육운영관리
	 * 교육이력 교육수료상태변경
	 * 비교과과정만 변경가능
	 * 신청/수강/수료/미수료 로만 변경만 가능
	 * @return
	 * @throws BaException
	 */
	public String setMgmtEduPassChange() throws BaException {
		String changeAttendState = ParamUtils.getStringParameter(request, "chngAttndStt", ""); // 변경될 수강상태
		String existingAttendState = ParamUtils.getStringParameter(request, "exstngAttndStt", ""); // 기존 수강상태
		String nopassReason = ParamUtils.getStringParameter(request, "npssRsn", ""); // 미수료사유
		
		if(!existingAttendState.equals("") && !changeAttendState.equals("")
				&& subjectNum!=null && year>0 && chasu>0 && studentId>0) {
			statement = baEducationSrv.setEduPassChange(
					getUser().getCompanyId(), getUser().getUserId(), subjectNum, year, chasu,
					studentId, changeAttendState, existingAttendState, nopassReason);
		} else {
			statement = "N";
		}
		
		return success();
	}
	
}
