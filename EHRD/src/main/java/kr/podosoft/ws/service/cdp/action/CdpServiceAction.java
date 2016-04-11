package kr.podosoft.ws.service.cdp.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Types;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.car.CarService;
import kr.podosoft.ws.service.cdp.CdpException;
import kr.podosoft.ws.service.cdp.CdpService;
import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.utils.CommonUtils;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;

import architecture.ee.util.ApplicationHelper;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;


public class CdpServiceAction extends FrameworkActionSupport {

	private static final long serialVersionUID = 1L;

    private String sortField;
    private String sortDir;
    private Filter filter;
    
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

	public Filter getFilter() {
		return filter;
	}

	public void setFilter(Filter filter) {
		this.filter = filter;
	}

	public String getTargetAttachmentContentType() {
		return targetAttachmentContentType;
	}

	public void setTargetAttachmentContentType(String targetAttachmentContentType) {
		this.targetAttachmentContentType = targetAttachmentContentType;
	}

	public int getTargetAttachmentContentLength() {
		return targetAttachmentContentLength;
	}

	public void setTargetAttachmentContentLength(int targetAttachmentContentLength) {
		this.targetAttachmentContentLength = targetAttachmentContentLength;
	}

	public InputStream getTargetAttachmentInputStream() {
		return targetAttachmentInputStream;
	}

	public void setTargetAttachmentInputStream(
			InputStream targetAttachmentInputStream) {
		this.targetAttachmentInputStream = targetAttachmentInputStream;
	}

	public String getTargetAttachmentFileName() {
		return targetAttachmentFileName;
	}

	public void setTargetAttachmentFileName(String targetAttachmentFileName) {
		this.targetAttachmentFileName = targetAttachmentFileName;
	}

	private int pageSize = 15 ;
	
    private int startIndex = 0 ;  
     
    private int totalItemCount = 0;
     
	private int year = 0;

	private int saveCount = 0 ;  
	
	private int req_lineSeq = 0;
	 
	public int getReq_lineSeq() {
		return req_lineSeq;
	}

	public void setReq_lineSeq(int req_lineSeq) {
		this.req_lineSeq = req_lineSeq;
	}

	private int runNum = 0; //실시번호
	
	private int mjrTlntSeq = 0;
	
	public int getMjrTlntSeq() {
		return mjrTlntSeq;
	}

	public void setMjrTlntSeq(int mjrTlntSeq) {
		this.mjrTlntSeq = mjrTlntSeq;
	}

	private String gubun = "";
	
	public String getGubun() {
		return gubun;
	}

	public void setGubun(String gubun) {
		this.gubun = gubun;
	}

	private int reqNum = 0; //승인요청번호
	
	public int getReqNum() {
		return reqNum;
	}

	public void setReqNum(int reqNum) {
		this.reqNum = reqNum;
	}

	private long tu = 0; //대상자 
	
	private String req_userid; //승인요청자

	public String getReq_userid() {
		return req_userid;
	}

	public void setReq_userid(String req_userid) {
		this.req_userid = req_userid;
	}

	private List<Map<String,Object>> items;
	
	private List<Map<String,Object>> items1;
	
	private List<Map<String,Object>> items2;	
	
	private String statement ;

	private String subjectNum; // 과정번호
	
	private String comment;
	
	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	private String targetAttachmentContentType = "";
	
	private int targetAttachmentContentLength = 0;
	
	private InputStream targetAttachmentInputStream = null;
	
	private String targetAttachmentFileName = "";
	
	
	public String getSubjectNum() {
		return subjectNum;
	}

	public void setSubjectNum(String subjectNum) {
		this.subjectNum = subjectNum;
	}

	public long getTu() {
		return tu;
	}

	public void setTu(long tu) {
		this.tu = tu;
	}

	private CarService carService;

	public CarService getCarService() {
		return carService;
	}

	public void setCarService(CarService carService) {
		this.carService = carService;
	}

	private CdpService cdpService;

	public int getRunNum() {
		return runNum;
	}

	public void setRunNum(int runNum) {
		this.runNum = runNum;
	}

	public CdpService getCdpService() {
		return cdpService;
	}

	public void setCdpService(CdpService cdpService) {
		this.cdpService = cdpService;
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

	public int getTotalItemCount() {
		return totalItemCount;
	}

	public void setTotalItemCount(int totalItemCount) {
		this.totalItemCount = totalItemCount;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public int getSaveCount() {
		return saveCount;
	}

	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
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
	
	
	// ------------------------------------------------------------------------------------------------------------------------
	// -------------------------------------핵심인재관리 소스관리로 인해 CDP에 작성-------------------------------------------------
	// ------------------------------------------------------------------------------------------------------------------------	


	
	
	/**
	 * (관리자) 교육관리 > 핵심인재관리
	 * @return
	 * @since 2014.11.17 
	 */
	public String goCorePersonManageListPg(){
		return success();
	}	
	
	/**
	 * 
	 * (관리자) 교육관리 > 핵심인재관리 리스트 상세보기
	 *
	 * @return
	 * @since 2014. 11. 17.
	 */
	public String getCorePersonManageUserDetail() throws CdpException{
		
		log.debug(CommonUtils.printParameter(request));
		
		//log.debug("######## req_userid : " + req_userid);
		log.debug("######## mjrTlntSeq : " + mjrTlntSeq);
		
		
		
		Object [] params = {
				getUser().getCompanyId(), mjrTlntSeq
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.SELECT_TB_EM_MJR_TLNT_USER_INFO", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();	
	}	
	
	/**
	 * 
	 * (관리자) 교육관리 > 핵심인재관리 리스트
	 *
	 * @return
	 * @since 2014. 11. 17.
	 */
	public String getCorePersonManageList() throws CdpException{
		
		log.debug(CommonUtils.printParameter(request));
		
		//log.debug("######## req_userid : " + req_userid);
		log.debug("######## year : " + year);
		
		Object [] params = {
				getUser().getCompanyId(), year
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.SELECT_TB_EM_MJR_TLNT_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();	
	}		
	
	/**
	 * 
	 * (관리자) 교육관리 > 핵심인재관리 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CdpException 
	 * @since 2014. 11. 26.
	 */
	@SuppressWarnings({ "deprecation" })
	public String goCorePersonManageListExcel() throws CdpException{
		
		try {
			
			year   = CommonUtils.stringToInt(ParamUtils.getParameter(request, "SELECTED_YEAR", "0"), 0);
			
			log.debug("######### year : " + year);
			
			Object [] params = {
					getUser().getCompanyId(), year
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC
			};
			this.items = cdpService.queryForList("CDP.SELECT_TB_EM_MJR_TLNT_LIST", params, jdbcTypes);
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet = null;
			HSSFRow row = null;
			
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFCellStyle style = workbook.createCellStyle();
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setFont(font);
			style.setFillForegroundColor(HSSFColor.TAN.index);
			
			
			HSSFCellStyle style2 = workbook.createCellStyle();
			style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style2.setFillForegroundColor(HSSFColor.TAN.index);
			
			// START : =================================================================
			String[] cell_value = {
					"성명","교직원번호","당시소속","당시직무","당시계급","당시직급","핵심인재구분","성적","등수","통과여부","학습유형","과정명","교육시작일","교육종료일",
					"인정시간(H)","인정시간(M)","실적시간(H)","실적시간(M)","상시학습종류","부처지정학습여부","지정학습구분","기간성과평가","교육기관구분","교육기관명",
					"사용여부"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "핵심인재관리 리스트");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
			
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> itMap = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
					
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
						
						Object tmp = new Object();
						//Object tmp1 = new Object();
						switch(k) {
						case 0 : if(itMap.get("NAME")!=null) tmp = itMap.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1 : if(itMap.get("EMPNO")!=null) tmp = itMap.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2 : if(itMap.get("DVS_NAME")!=null) tmp = itMap.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 3 : if(itMap.get("JOB_NM")!=null) tmp = itMap.get("JOB_NM"); else tmp = "";  cell.setCellStyle(style2); break;
						case 4 : if(itMap.get("LEADERSHIP_NM")!=null) tmp = itMap.get("LEADERSHIP_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 5 : if(itMap.get("GRADE_NM")!=null) tmp = itMap.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 6 : if(itMap.get("MJR_TLNT_DIV_CD_NM")!=null) tmp = itMap.get("MJR_TLNT_DIV_CD_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 7 : if(itMap.get("RESULT")!=null) tmp = itMap.get("RESULT"); else tmp = ""; cell.setCellStyle(style2); break;
						case 8 : if(itMap.get("RANKING")!=null) tmp = itMap.get("RANKING"); else tmp = ""; cell.setCellStyle(style2); break;
						case 9 : if(itMap.get("PASS_YN")!=null) tmp = itMap.get("PASS_YN"); else tmp = ""; cell.setCellStyle(style2); break;
						case 10: if(itMap.get("TRAINING_CD_NM")!=null) tmp = itMap.get("TRAINING_CD_NM"); else tmp = "";  cell.setCellStyle(style2); break;
						case 11: if(itMap.get("SBJ_NM")!=null) tmp = itMap.get("SBJ_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 12: if(itMap.get("EDU_ST_DT")!=null) tmp = itMap.get("EDU_ST_DT"); else tmp = ""; cell.setCellStyle(style2); break;
						case 13: if(itMap.get("EDU_ED_DT")!=null) tmp = itMap.get("EDU_ED_DT"); else tmp = ""; cell.setCellStyle(style2); break;
						case 14: if(itMap.get("RECOG_TIME_H")!=null) tmp = itMap.get("RECOG_TIME_H"); else tmp = ""; cell.setCellStyle(style2); break;
						case 15: if(itMap.get("RECOG_TIME_M")!=null) tmp = itMap.get("RECOG_TIME_M"); else tmp = ""; cell.setCellStyle(style2); break;
						case 16: if(itMap.get("PERF_TIME_H")!=null) tmp = itMap.get("PERF_TIME_H"); else tmp = ""; cell.setCellStyle(style2); break;
						case 17: if(itMap.get("PERF_TIME_M")!=null) tmp = itMap.get("PERF_TIME_M"); else tmp = "";  cell.setCellStyle(style2); break;
						case 18: if(itMap.get("ALW_STD_CD_NM")!=null) tmp = itMap.get("ALW_STD_CD_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 19: if(itMap.get("DEPT_DESIGNATION_YN")!=null) tmp = itMap.get("DEPT_DESIGNATION_YN"); else tmp = ""; cell.setCellStyle(style2); break;
						case 20: if(itMap.get("DEPT_DESIGNATION_CD_NM")!=null) tmp = itMap.get("DEPT_DESIGNATION_CD_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 21: if(itMap.get("PERF_ASSE_SBJ_CD_NM")!=null) tmp = itMap.get("PERF_ASSE_SBJ_CD_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 22: if(itMap.get("EDUINS_DIV_CD_NM")!=null) tmp = itMap.get("EDUINS_DIV_CD_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 23: if(itMap.get("INSTITUTE_NM")!=null) tmp = itMap.get("INSTITUTE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 24: if(itMap.get("USEFLAG")!=null) tmp = itMap.get("USEFLAG"); else tmp = "";  cell.setCellStyle(style2); break;
						}
						
						if ( tmp instanceof BigDecimal ) {
							cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue( (String)tmp.toString() );
						}
						
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0 )sheet.setColumnWidth((short)k, (short)5000);
				if(k==1 )sheet.setColumnWidth((short)k, (short)5000);    
				if(k==2 )sheet.setColumnWidth((short)k, (short)8000);
				if(k==3 )sheet.setColumnWidth((short)k, (short)5000);
				if(k==4 )sheet.setColumnWidth((short)k, (short)5000);
				if(k==5 )sheet.setColumnWidth((short)k, (short)5000);
				if(k==6 )sheet.setColumnWidth((short)k, (short)5000);
				if(k==7 )sheet.setColumnWidth((short)k, (short)5000);
				if(k==8 )sheet.setColumnWidth((short)k, (short)5000);
				if(k==9 )sheet.setColumnWidth((short)k, (short)5000);
				if(k==10)sheet.setColumnWidth((short)k, (short)5000);
				if(k==11)sheet.setColumnWidth((short)k, (short)8000);
				if(k==12)sheet.setColumnWidth((short)k, (short)5000);
				if(k==13)sheet.setColumnWidth((short)k, (short)5000);
				if(k==14)sheet.setColumnWidth((short)k, (short)5000);
				if(k==15)sheet.setColumnWidth((short)k, (short)5000);
				if(k==16)sheet.setColumnWidth((short)k, (short)5000);
				if(k==17)sheet.setColumnWidth((short)k, (short)5000);
				if(k==18)sheet.setColumnWidth((short)k, (short)5000);
				if(k==19)sheet.setColumnWidth((short)k, (short)5000);
				if(k==20)sheet.setColumnWidth((short)k, (short)5000);
				if(k==21)sheet.setColumnWidth((short)k, (short)5000);
				if(k==22)sheet.setColumnWidth((short)k, (short)5000);
				if(k==23)sheet.setColumnWidth((short)k, (short)5000);
				if(k==24)sheet.setColumnWidth((short)k, (short)5000);			
			}
			
			// END : =================================================================
			
			File dir = ApplicationHelper.getRepository().getFile("temp_excel");
			if(!dir.exists())
				dir.mkdir();
			
			File file = File.createTempFile("tempExcelFile", ".xls", dir);
			FileOutputStream fileOutStream = new FileOutputStream(file);			
			workbook.write(fileOutStream);
			
			this.targetAttachmentContentType = "application/vnd.ms-excel";			
			this.targetAttachmentContentLength = (int)file.length();
			this.targetAttachmentInputStream = new FileInputStream(file);	
			this.targetAttachmentFileName = "coreList.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CdpException(e);
		}
		
		return success();
	} 	
	
	
	// ------------------------------------------------------------------------------------------------------------------------
	// -------------------------------------핵심인재관리 소스관리로 인해 CDP에 작성-------------------------------------------------
	// ------------------------------------------------------------------------------------------------------------------------
	
	/**
	 * 
	 * 경력개발계획 > 계획승인 - 승인팝업 : 승인/미승인 처리<br/>
	 *
	 * @return
	 * @since 2014. 11. 06.
	 */
	public String cdpPlanApprReq() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		log.debug("######## req_userid : " + req_userid); //승인요청자
		log.debug("######## req_lineSeq : " + req_lineSeq); // 승인요청 순번
		log.debug("######## runNum : " + runNum); // 경력개발계획 
		log.debug("######## reqNum : " + reqNum); // 승인요청번호
		log.debug("######## gubun : " + gubun); // 승인(Y) 미승인(N)
		log.debug("######## comment : " + comment); // 검토의견
		
		//REQ_LINE_SEQ
		
		this.saveCount = cdpService.cdpPlanApprReq(request, getUser());
		return success();		
	}
	
	/**
	 * 
	 * 경력개발계획 > 계획승인 - 승인팝업 : 승인요청자 교육계획 정보<br/>
	 * OR
	 * 경력개발계획 > 계획수립현황 - 성명 클릭 (수립현황 팝업)
	 *
	 * @return
	 * @since 2014. 11. 06.
	 */
	public String getCdpPlanApprReqInfoEdu() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		log.debug("######## req_userid : " + req_userid);
		log.debug("######## runNum : " + runNum);
		
		Object [] params = {
				getUser().getCompanyId(), req_userid, getUser().getCompanyId(), req_userid, runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.CDP_EDU_PLAN_USERINFO", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();	
	}
	
	/**
	 * 
	 * 경력개발계획 > 계획승인 - 승인팝업 : 승인요청자 어학계획 정보<br/>
	 *
	 * @return
	 * @since 2014. 11. 06.
	 */
	public String getCdpPlanApprReqInfoLang() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		log.debug("######## req_userid : " + req_userid);
		
		Object [] params = {
				getUser().getCompanyId(), req_userid, runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.CDP_LANG_PLAN_USERINFO", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();	
	}
	
	/**
	 * 
	 * 경력개발계획 > 계획승인 - 승인팝업 : 승인요청자 자격증계획 정보<br/>
	 *
	 * @return
	 * @since 2014. 11. 06.
	 */
	public String getCdpPlanApprReqInfoCert() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		log.debug("######## req_userid : " + req_userid);
		
		Object [] params = {
				getUser().getCompanyId(), req_userid, runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.CDP_CERT_PLAN_USERINFO", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();	
	}
	
	/**
	 * 
	 * 경력개발계획 > 계획승인 - 승인팝업 : 승인요청자 계획 정보<br/>
	 *
	 * @return
	 * @since 2014. 11. 06.
	 */
	public String getCdpPlanApprReqInfo() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		log.debug("######## req_userid : " + req_userid);
		log.debug("######## runNum : " + runNum);
		
		Object [] params = {
				getUser().getCompanyId(), req_userid, runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.CDP_PLAN_APPROVAL_REQUEST_USERINFO", params, jdbcTypes);
		return success();	
	}
	
	/**
	 * 
	 * 경력개발계획 계획승인 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 10. 31.
	 */
	public String getCdpPlanApprovalListPg(){
		return success();
	}	
	
	/**
	 * 
	 * 경력개발계획 > 계획수립현황 - 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getCdpPlanApprovalList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		/*
		Map<Object, String>  map = new HashMap();
		log.debug("######## carService.getUserDivisionList(request, getUser()===>"+carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
		map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
		 */
		
		log.debug("######## rnuNum : " + runNum);
		
		Object [] params = {
				getUser().getCompanyId(), getUser().getUserId(), runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_CDP_PLAN_APPROVAL_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();	
	}	
	
	/**
	 * 
	 * 경력개발계획 > 계획수립현황 - 목록 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CdpException 
	 * @since 2014. 10. 30.
	 */
	@SuppressWarnings({ "deprecation" })
	public String getCdpPlanApprovalListExcel() throws CdpException{
		
		try {
			
			String runNum   = ParamUtils.getParameter(request, "RUN_NUM");
			String runName = ParamUtils.getParameter(request, "RUN_NAME");
			
			log.debug("######### run_num : " + runNum);
			log.debug("######### run_name : " + runName);
			
			//Map<Object, String>  map = new HashMap();
			//map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
			Object [] params = {
					getUser().getCompanyId(), getUser().getUserId(), runNum
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			};
			this.items = cdpService.queryForList("CDP.GET_CDP_PLAN_APPROVAL_LIST", params, jdbcTypes);
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet = null;
			HSSFRow row = null;
			
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFCellStyle style = workbook.createCellStyle();
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setFont(font);
			style.setFillForegroundColor(HSSFColor.TAN.index);
			
			
			HSSFCellStyle style2 = workbook.createCellStyle();
			style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style2.setFillForegroundColor(HSSFColor.TAN.index);
			
			// START : =================================================================
			String[] cell_value = {
					"계획명","부서", "전체부서명", "성명", "교직원번호", "직급", "승인현황"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "경력개발계획 계획승인현황");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
			
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> itMap = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
					
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
						
						Object tmp = new Object();
						//Object tmp1 = new Object();
						switch(k) {
						case 0: if(itMap.get("RUN_NAME")!=null) tmp = itMap.get("RUN_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1: if(itMap.get("DVS_NAME")!=null) tmp = itMap.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2: if(itMap.get("DVS_FULLNAME")!=null) tmp = itMap.get("DVS_FULLNAME"); else tmp = "";  cell.setCellStyle(style2); break;
						case 3: if(itMap.get("REQ_NAME")!=null) tmp = itMap.get("REQ_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 4: if(itMap.get("EMPNO")!=null) tmp = itMap.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
						case 5: if(itMap.get("GRADE_NM")!=null) tmp = itMap.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 6: if(itMap.get("REQ_STS_CD_NAME")!=null) tmp = itMap.get("REQ_STS_CD_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						}
						
						if ( tmp instanceof BigDecimal ) {
							cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue( (String)tmp );
						}
						
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet.setColumnWidth((short)k, (short)8000);
				if(k==3)sheet.setColumnWidth((short)k, (short)5000);
				if(k==4)sheet.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)5000);
			}
			
			// END : =================================================================
			
			File dir = ApplicationHelper.getRepository().getFile("temp_excel");
			if(!dir.exists())
				dir.mkdir();
			
			File file = File.createTempFile("tempExcelFile", ".xls", dir);
			FileOutputStream fileOutStream = new FileOutputStream(file);			
			workbook.write(fileOutStream);
			
			this.targetAttachmentContentType = "application/vnd.ms-excel";			
			this.targetAttachmentContentLength = (int)file.length();
			this.targetAttachmentInputStream = new FileInputStream(file);	
			this.targetAttachmentFileName = runName+".xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CdpException(e);
		}
		
		return success();
	} 
		
		
	/**
	 * 
	 * 경력개발계획 계획대비 실행율 목록 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2015. 2. 23
	 */
	public String getCdpPlanStateRateListPg(){
		return success();
	}	
	
	/**
	 * 
	 * 경력개발계획 > 계획대비 실행율현황 - 목록 조회.<br/>
	 *
	 * @return
	 * @since 2015. 2. 23
	 */
	public String getCdpPlanStateRateList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		Map<String, Object>  map = new HashMap<String, Object>();
		log.debug("######## carService.getUserDivisionList(request, getUser()===>"+carService.getUserDivisionList(request, getUser(), "TBU.DIVISIONID"));
		map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "TBU.DIVISIONID"));
		
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		
		// 서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		log.debug("######## yyyy : " + yyyy);
		log.debug("######## getUser().getCompanyId() : " + getUser().getCompanyId());
		log.debug("######## getUser().getUserId() : " + getUser().getUserId());
		
		
		Object [] params = {
				yyyy, yyyy, getUser().getCompanyId(), yyyy, getUser().getCompanyId(), yyyy, getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.dynamicQueryForList("CDP.GET_CDP_PLAN_STATE_RATE_LIST", startIndex, pageSize, sortField, sortDir, "", filter, params, jdbcTypes, map);
		this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		return success();	
	}	
	
	/**
	 * 
	 * 경력개발계획 > 계획대비 실행율 - 목록 상세조회.<br/>
	 *
	 * @return
	 * @since 2015. 2. 24
	 */
	public String getCdpPlanStateRateDetail() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		/*
		Map<String, Object>  map = new HashMap<String, Object>();
		log.debug("######## carService.getUserDivisionList(request, getUser()===>"+carService.getUserDivisionList(request, getUser(), "USERINFO.DIVISIONID"));
		map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "USERINFO.DIVISIONID"));
		*/
		
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		String selectUser = ParamUtils.getParameter(request, "SELECT_USER");
		
		log.debug("######## yyyy : " + yyyy);
		log.debug("######## selectUser : " + selectUser);
		log.debug("######## getUser().getCompanyId() : " + getUser().getCompanyId());
		log.debug("######## getUser().getUserId() : " + getUser().getUserId());
		
		
		Object [] params = {
				yyyy, selectUser, getUser().getCompanyId(), yyyy, selectUser, getUser().getCompanyId(), yyyy, selectUser, getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		//this.items = cdpService.dynamicQueryForList("CDP.GET_CDP_PLAN_STATE_RATE_DETAIL", params, jdbcTypes, map);
		
		this.items = cdpService.queryForList("CDP.GET_CDP_PLAN_STATE_RATE_DETAIL", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();	
	}	
	
	/**
	 * 
	 * 경력개발계획 > 계획대비 실행율 - 목록 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CdpException 
	 * @since 2014. 10. 30.
	 */
	@SuppressWarnings({ "deprecation" })
	public String getCdpPlanStateRateListExcel() throws CdpException{
		
		try {
			
			String yyyy = ParamUtils.getParameter(request, "YYYY");
			
			log.debug("######## yyyy : " + yyyy);
			log.debug("######## getUser().getCompanyId() : " + getUser().getCompanyId());
			
			String excelTitle = yyyy+"년 계획대비 실행율.xls";
			
			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "TBU.DIVISIONID"));
			map.put("GRID_WHERE_CLAUSE", "");
			map.put("GRID_ORDERBY_CLAUSE", "");
			
			Object [] params = {
					yyyy, yyyy, getUser().getCompanyId(), yyyy, getUser().getCompanyId(), yyyy, getUser().getCompanyId()
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			};
			this.items = cdpService.dynamicQueryForList("CDP.GET_CDP_PLAN_STATE_RATE_LIST", params, jdbcTypes, map);
			
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet = null;
			HSSFRow row = null;
			
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFCellStyle style = workbook.createCellStyle();
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setFont(font);
			style.setFillForegroundColor(HSSFColor.TAN.index);
			
			
			HSSFCellStyle style2 = workbook.createCellStyle();
			style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style2.setFillForegroundColor(HSSFColor.TAN.index);
			
			// START : =================================================================
			String[] cell_value = {
					"부서명", "전체부서명", "성명", "교직원번호", "직급", "계획년도", "실행율(%)"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "경력개발계획 계획대비실행율 현황");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
			
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> itMap = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
					
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
						
						Object tmp = new Object();
						//Object tmp1 = new Object();
						switch(k) {
						case 0: if(itMap.get("DVS_NAME")!=null) tmp = itMap.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1: if(itMap.get("DVS_FULLNAME")!=null) tmp = itMap.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2: if(itMap.get("NAME")!=null) tmp = itMap.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 3: if(itMap.get("EMPNO")!=null) tmp = itMap.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
						case 4: if(itMap.get("GRADE_NM")!=null) tmp = itMap.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 5: if(itMap.get("YEAR")!=null) tmp = itMap.get("YEAR"); else tmp = ""; cell.setCellStyle(style2); break;
						case 6: if(itMap.get("AVG_RATE")!=null) tmp = itMap.get("AVG_RATE"); else tmp = ""; cell.setCellStyle(style2); break;
						}
						
						if ( tmp instanceof BigDecimal ) {
							cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue( (String)tmp );
						}
						
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet.setColumnWidth((short)k, (short)8000);
				if(k==2)sheet.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet.setColumnWidth((short)k, (short)5000);
				if(k==4)sheet.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)5000);
			}
			
			// END : =================================================================
			
			File dir = ApplicationHelper.getRepository().getFile("temp_excel");
			if(!dir.exists())
				dir.mkdir();
			
			File file = File.createTempFile("tempExcelFile", ".xls", dir);
			FileOutputStream fileOutStream = new FileOutputStream(file);			
			workbook.write(fileOutStream);
			
			this.targetAttachmentContentType = "application/vnd.ms-excel";			
			this.targetAttachmentContentLength = (int)file.length();
			this.targetAttachmentInputStream = new FileInputStream(file);	
			this.targetAttachmentFileName = URLEncoder.encode(excelTitle,"UTF-8");
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CdpException(e);
		}
		
		return success();
	}	
	
	
	

	/**
	 * 
	 * 경력개발계획 수립현황 목록 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 10. 31.
	 */
	public String getCdpPlanStateListPg(){
		return success();
	}
	
	/**
	 * 
	 * 경력개발계획 > 계획수립현황 - 실시 년도 조회.<br/>
	 *
	 * @return
	 * @since 2014. 10. 31.
	 */
	public String getRunYyyyListCDP() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		Object [] params = {
				getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_RUN_YYYY_CDP", params, jdbcTypes);
		return success();	
	}	
	
	/**
	 * 
	 * 경력개발계획 > 계획수립현황 - 실시 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 10. 30.
	 */
	public String getRunHistoryListCDP() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		Object [] params = {
				getUser().getCompanyId()
		};
		
		int[] jdbcTypes = {
				Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_RUN_HISTORY_LIST_CDP", params, jdbcTypes);
		return success();	
	}	
	
	/**
	 * 
	 * 경력개발계획 > 계획수립현황 - 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getCdpPlanStateList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		Map<String, Object>  map = new HashMap<String, Object>();
		log.debug("######## carService.getUserDivisionList(request, getUser()===>"+carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
		map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
		
		log.debug("######## rnuNum : " + runNum);
		
		Object [] params = {
				getUser().getCompanyId(), runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.dynamicQueryForList("CDP.GET_CDP_PLAN_STATE_LIST", params, jdbcTypes, map);
		this.totalItemCount = items.size();
		return success();	
	}	
	
	
	/**
	 * 
	 * 경력개발계획 > 계획수립현황 - 목록 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CdpException 
	 * @since 2014. 10. 30.
	 */
	@SuppressWarnings({ "deprecation" })
	public String getCdpPlanStateListExcel() throws CdpException{
		
		try {
			
			String runNo   = ParamUtils.getParameter(request, "RUN_NUM");
			String runName = ParamUtils.getParameter(request, "RUN_NAME");
			
			log.debug("######### run_num : " + runNo);
			log.debug("######### run_name : " + runName);
			
			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
			Object [] params = {
					getUser().getCompanyId(), runNo
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC
			};
			this.items = cdpService.dynamicQueryForList("CDP.GET_CDP_PLAN_STATE_LIST", params, jdbcTypes, map);
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet = null;
			HSSFRow row = null;
			
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFCellStyle style = workbook.createCellStyle();
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setFont(font);
			style.setFillForegroundColor(HSSFColor.TAN.index);
			
			
			HSSFCellStyle style2 = workbook.createCellStyle();
			style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style2.setFillForegroundColor(HSSFColor.TAN.index);
			
			// START : =================================================================
			String[] cell_value = {
					"계획명", "부서", "전체부서명", "성명", "교직원번호", "직급", "상태"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "경력개발계획 수립현황");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
			
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> itMap = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
					
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
						
						Object tmp = new Object();
						//Object tmp1 = new Object();
						switch(k) {
						case 0: if(itMap.get("RUN_NAME")!=null) tmp = itMap.get("RUN_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1: if(itMap.get("DVS_NAME")!=null) tmp = itMap.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2: if(itMap.get("DVS_FULLNAME")!=null) tmp = itMap.get("DVS_FULLNAME"); else tmp = "";  cell.setCellStyle(style2); break;
						case 3: if(itMap.get("NAME")!=null) tmp = itMap.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 4: if(itMap.get("EMPNO")!=null) tmp = itMap.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
						case 5: if(itMap.get("GRADE_NM")!=null) tmp = itMap.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 6: if(itMap.get("EVL_CMD2")!=null) tmp = itMap.get("EVL_CMD2"); else tmp = ""; cell.setCellStyle(style2); break;
						}
						
						if ( tmp instanceof BigDecimal ) {
							cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue( (String)tmp );
						}
						
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet.setColumnWidth((short)k, (short)8000);
				if(k==3)sheet.setColumnWidth((short)k, (short)5000);
				if(k==4)sheet.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)5000);
			}
			
			// END : =================================================================
			
			File dir = ApplicationHelper.getRepository().getFile("temp_excel");
			if(!dir.exists())
				dir.mkdir();
			
			File file = File.createTempFile("tempExcelFile", ".xls", dir);
			FileOutputStream fileOutStream = new FileOutputStream(file);			
			workbook.write(fileOutStream);
			
			this.targetAttachmentContentType = "application/vnd.ms-excel";			
			this.targetAttachmentContentLength = (int)file.length();
			this.targetAttachmentInputStream = new FileInputStream(file);	
			this.targetAttachmentFileName = URLEncoder.encode("계획수립현황.xls","UTF-8");
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CdpException(e);
		}
		
		return success();
	} 

	/**
	 * 
	 * 경력개발계획 > 계획수립현황 - 교육계획 수립현황 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CdpException 
	 * @since 2014. 10. 30.
	 */
	@SuppressWarnings({ "deprecation" })
	public String getCdpEduPlanStateListExcel() throws CdpException{
		
		try {
			
			String runNo   = ParamUtils.getParameter(request, "RUN_NUM");
			String runName = ParamUtils.getParameter(request, "RUN_NAME");
			
			log.debug("######### run_num : " + runNo);
			log.debug("######### run_name : " + runName);
			
			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "E.DIVISIONID"));
			Object [] params = {
					getUser().getCompanyId(), getUser().getCompanyId(), runNo
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			};
			this.items = cdpService.dynamicQueryForList("CDP.GET_CDP_EDU_PLAN_STATE_LIST", params, jdbcTypes, map);
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet = null;
			HSSFRow row = null;
			
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFCellStyle style = workbook.createCellStyle();
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setFont(font);
			style.setFillForegroundColor(HSSFColor.TAN.index);
			
			
			HSSFCellStyle styleC = workbook.createCellStyle();
			styleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleC.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle styleL = workbook.createCellStyle();
			styleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			styleL.setFillForegroundColor(HSSFColor.TAN.index);
			
			// START : =================================================================
			String[] cell_value = {
					"과정명", "학습유형", "부처지정학습", "교육기관", "인정시간", "교육희망월", "성명", "부서", "학습역량", "학습역량 최근점수"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "경력개발계획 교육수립현황");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
			
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> itMap = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
					
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
						
						Object tmp = new Object();
						//Object tmp1 = new Object();
						switch(k) {
						case 0: if(itMap.get("SUBJECT_NAME")!=null) tmp = itMap.get("SUBJECT_NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
						case 1: if(itMap.get("TRAINING_NM")!=null) tmp = itMap.get("TRAINING_NM"); else tmp = ""; cell.setCellStyle(styleC); break;
						case 2: if(itMap.get("DEPT_DESIGNATION_YN")!=null) tmp = itMap.get("DEPT_DESIGNATION_YN"); else tmp = "";  cell.setCellStyle(styleC); break;
						case 3: if(itMap.get("INSTITUTE_NAME")!=null) tmp = itMap.get("INSTITUTE_NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
						case 4: if(itMap.get("RECOG_TIME")!=null) tmp = itMap.get("RECOG_TIME"); else tmp = ""; cell.setCellStyle(styleC); break;
						case 5: if(itMap.get("HOPE_YYYYMM")!=null) tmp = itMap.get("HOPE_YYYYMM"); else tmp = ""; cell.setCellStyle(styleC); break;
						case 6: if(itMap.get("NAME")!=null) tmp = itMap.get("NAME"); else tmp = ""; cell.setCellStyle(styleC); break;
						case 7: if(itMap.get("DVS_FULLNAME")!=null) tmp = itMap.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(styleL); break;
						case 8: if(itMap.get("CMPNAME")!=null) tmp = itMap.get("CMPNAME"); else tmp = ""; cell.setCellStyle(styleL); break;
						case 9: if(itMap.get("SCORE_STRI")!=null) tmp = itMap.get("SCORE_STRI"); else tmp = ""; cell.setCellStyle(styleC); break;
						}
						
						if ( tmp instanceof BigDecimal ) {
							cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue( (String)tmp );
						}
						
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)10000);
				if(k==1)sheet.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet.setColumnWidth((short)k, (short)7000);
				if(k==4)sheet.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)5000);
				if(k==7)sheet.setColumnWidth((short)k, (short)8000);
				if(k==8)sheet.setColumnWidth((short)k, (short)6000);
				if(k==9)sheet.setColumnWidth((short)k, (short)5000);
			}
			
			// END : =================================================================
			
			File dir = ApplicationHelper.getRepository().getFile("temp_excel");
			if(!dir.exists())
				dir.mkdir();
			
			File file = File.createTempFile("tempExcelFile", ".xls", dir);
			FileOutputStream fileOutStream = new FileOutputStream(file);			
			workbook.write(fileOutStream);
			
			this.targetAttachmentContentType = "application/vnd.ms-excel";			
			this.targetAttachmentContentLength = (int)file.length();
			this.targetAttachmentInputStream = new FileInputStream(file);	
			this.targetAttachmentFileName = URLEncoder.encode("교육계획수립현황.xls","UTF-8");
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CdpException(e);
		}
		
		return success();
	} 
		
	
	
	

	/**
	 * 
	 * 경력개발계획 목록 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getCdpRunListPg(){
		return success();
	}
	
	/**
	 * 
	 * 경력개발계획 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getCdpRunList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId(),
				getUser().getUserId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_CDP_RUN_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();	
	}

	/**
	 * 
	 * 경력개발계획 수립 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getUserCdpExecPg(){
		return success();
	}
	
	/**
	 * 
	 * 경력개발계획 내용 조회<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getMyCdpInfo() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId(), runNum, tu
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_MY_CDP_INFO", params, jdbcTypes);
		return success();	
	}
	
	/**
	 * 
	 * 직무목록 조회<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getJobList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_JOB_PROFILE_LIST", params, jdbcTypes);
		return success();	
	}
	

	/**
	 * 
	 * 자격증 목록 조회<br/>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getCertList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId(), getUser().getCompanyId(), runNum, tu
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_CERT_PROFILE_LIST", params, jdbcTypes);
		return success();	
	}
	
	/**
	 * 
	 * 자격증 계획 목록 조회<br/>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getCertPlanList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId(), runNum, tu
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_CERT_PLAN_LIST", params, jdbcTypes);
		return success();	
	}

	/**
	 * 
	 * 어학  목록 조회<br/>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getLangList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId(), getUser().getCompanyId(), runNum, tu
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_LANG_PROFILE_LIST", params, jdbcTypes);
		return success();	
	}

	/**
	 * 
	 * 어학 계획 목록 조회<br/>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getLangPlanList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId(), runNum, tu
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_LANG_PLAN_LIST", params, jdbcTypes);
		return success();	
	}
	
	/**
	 * 공통코드 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getCommonCode() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		String standardCode = ParamUtils.getParameter(request, "STANDARDCODE");
		
		this.items = cdpService.queryForList("CDP.GET_COMMON_CODE", new Object[]{standardCode, getUser().getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
		return success();
	}
	

	/**
	 * 
	 * 필수 계획 현황 조회<br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getReqPlan() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		List<Map<String,Object>> list = cdpService.queryForList("CDP.GET_COMMON_CODE", new Object[]{"BA04", getUser().getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
		
		String selectStr = "";
		String maxStr = "";
		if(list!=null && list.size()>0){
			for(Map<String, Object> row : list){
				selectStr += ", DD_H"+row.get("VALUE").toString()+", DD_M"+row.get("VALUE").toString();
				maxStr += ", MAX(DECODE(ED.DEPT_DESIGNATION_CD, '"+row.get("VALUE")+"', ED.CMP_TIME_H)) DD_H"+row.get("VALUE")+", MAX(DECODE(ED.DEPT_DESIGNATION_CD, '"+row.get("VALUE")+"', ED.CMP_TIME_M)) DD_M"+row.get("VALUE");
			}
		}
		log.debug("#### "+selectStr);
		log.debug("#### "+maxStr);
		
		Map<String, Object> map =  new HashMap<String, Object>();
		map.put("SELECT_STR", selectStr);
		map.put("MAX_STR", maxStr);
		
		this.items = cdpService.dynamicQueryForList("CDP.GET_REQUIRED_PLAN", new Object[]{ tu, year, tu, year }, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}, map);
		return success();
	}

	/**
	 * 
	 * 기관성과평가교육 계획 현황 조회<br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getPerfPlan() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		List<Map<String,Object>> list = cdpService.queryForList("CDP.GET_COMMON_CODE", new Object[]{"BA11", getUser().getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
		
		String maxStr = "";
		if(list!=null && list.size()>0){
			for(Map<String, Object> row : list){
				maxStr += ", MAX(DECODE(EP.PERF_ASSE_SBJ_CD, '"+row.get("VALUE")+"', CMP_TIME_H)) PD_H"+row.get("VALUE")+", MAX(DECODE(EP.PERF_ASSE_SBJ_CD, '"+row.get("VALUE")+"', CMP_TIME_M)) PD_M"+row.get("VALUE");
			}
		}
		log.debug("#### "+maxStr);
		
		Map<String, Object> map =  new HashMap<String, Object>();
		map.put("MAX_STR", maxStr);
		
		this.items = cdpService.dynamicQueryForList("CDP.GET_PERF_PLAN", new Object[]{ tu, year }, new int[]{Types.NUMERIC, Types.NUMERIC }, map);
		return success();
	}

	/**
	 * 
	 * 교육 계획 목록 조회<br/>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getEduPlanList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId(), runNum, tu
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_EDU_PLAN", params, jdbcTypes);
		return success();	
	}
	
	/**
	 * 
	 * 역량진단이력 목록 조회<br/>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getCmpRunList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId(), tu, getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_CMP_RUN_LIST", params, jdbcTypes);
		return success();	
	}
	

	/**
	 * 
	 * 역량진단결과 조회<br/>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getCmpRunResult() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		//최초 화면로딩 시 실시번호안넘어올경우 가장 최근의 실시번호로 역량진단결과를 조회한다.
		if(runNum==0){
			Object [] tmpparams = {
					getUser().getCompanyId(), tu, getUser().getCompanyId()
			}; 
			int[] tmpjdbcTypes = {
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			};
			List<Map<String, Object>> list = cdpService.queryForList("CDP.GET_CMP_RUN_LIST", tmpparams, tmpjdbcTypes);
			if(list!=null && list.size()>0){
				Map<String, Object> map = (Map<String, Object>)list.get(0);
				runNum = Integer.parseInt(map.get("RUN_NUM").toString());
			}
		}
		
		Object [] params = {
				getUser().getCompanyId(), tu, tu, getUser().getCompanyId(), tu, runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("EM_APPLY.SELECT_MYCAR_SCR_LIST", params, jdbcTypes);
		return success();	
	}

	/**
	 * 
	 * 역량진단결과와 매핑된 교육과정 목록 조회<br/>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getCmpSubjectMapList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));

		//최초 화면로딩 시 실시번호안넘어올경우 가장 최근의 실시번호로 역량진단결과를 조회한다.
		if(runNum==0){
			Object [] tmpparams = {
					getUser().getCompanyId(), tu, getUser().getCompanyId()
			}; 
			int[] tmpjdbcTypes = {
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			};
			List<Map<String, Object>> list = cdpService.queryForList("CDP.GET_CMP_RUN_LIST", tmpparams, tmpjdbcTypes);
			if(list!=null && list.size()>0){
				Map<String, Object> map = (Map<String, Object>)list.get(0);
				runNum = Integer.parseInt(map.get("RUN_NUM").toString());
			}
		}

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		Map<String, Object> map =  new HashMap<String, Object>();
		
		// 과정목록
		this.items = cdpService.dynamicQueryForList("CDP.GET_CMP_SUBJECT_MAP_LIST", startIndex, pageSize, sortField, sortDir, "subject_name, SUBJECT_NAME", filter,
													new Object[]{ 
														getUser().getCompanyId()
														, tu
														, tu
														, getUser().getCompanyId()
														, tu
														, runNum
														, getUser().getCompanyId()
														, getUser().getCompanyId()
														, getUser().getCompanyId()
													},
													new int[]{  
														Types.NUMERIC,
														Types.NUMERIC,
														Types.NUMERIC,
														Types.NUMERIC,
														Types.NUMERIC,
														Types.NUMERIC,
														Types.NUMERIC,
														Types.NUMERIC,
														Types.NUMERIC
													}, map);
		if(this.items !=null && this.items.size()>0){
			// 과정수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}

		return success();	
	}
	

	/**
	 * 
	 * 과정정보 상세 조회<br/>
	 *
	 * @return
	 * @since 2014. 10. 22.
	 */
	public String getSbjctInfo() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				subjectNum, getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC
		};
		this.items = cdpService.queryForList("CDP.GET_SUBJECT_INFO", params, jdbcTypes);
		return success();	
	}

	/**
	 * 
	 * 경력개발계획 - 과정검색 팝업 > 사용하는 과정 목록 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 10. 27.
	 */
	public String getNormalSbjctList() throws CdpException {

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		Map<String, Object> map =  new HashMap<String, Object>();

		// 과정목록
		this.items = cdpService.dynamicQueryForList("CDP.SELECT_NORMAL_SBJCT_LIST", startIndex, pageSize, sortField, sortDir, "SUBJECT_NAME", filter, new Object[]{ getUser().getCompanyId() }, new int[]{  Types.NUMERIC  }, map);
		if(this.items !=null && this.items.size()>0){
			// 과정수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	}
	
	/**
	 * 
	 * 승인요청 팝업 - 승인자 검색(소속부서 and 차상위부서 직원까지 검색됨.<br/>
	 *
	 * @return
	 * @throws CdpException
	 * @since 2014. 10. 27.
	 */
	public String getApprUserReqSearchList() throws CdpException{
		log.debug(CommonUtils.printParameter(request));
		
		String name = ParamUtils.getParameter(request, "NAME", "");
		String searchdiv = ParamUtils.getParameter(request, "SEARCHDIV");
		
		List<Map<String, Object>> list = cdpService.queryForList("CDP.SELECT_USER_INFO", new Object[]{getUser().getUserId()}, new int[]{Types.NUMERIC});
		
		String divisionid = "";
		if(list!=null && list.size()>0){
			Map<String, Object> map = (Map<String, Object>)list.get(0);
			if(map.get("DIVISIONID")!=null){
				divisionid =  map.get("DIVISIONID").toString();
			}
		}
		
		
		if(searchdiv!=null && searchdiv.equals("Y")){
			//성명검색 할때는 일반사용자 모두 검색..
			this.items = cdpService.queryForList("CDP.SELECT_APPR_USER_REQ_NOR_SEARCH_LIST", new Object[] { "%"+name+"%" }, new int[] { Types.VARCHAR });
		}else{
			//승인요청 팝업 띄울때 검색은 부서장만 검색
			this.items = cdpService.queryForList("CDP.SELECT_APPR_USER_REQ_SEARCH_LIST", new Object[] { getUser().getCompanyId(), divisionid, "%"+name+"%" }, new int[] { Types.VARCHAR, Types.VARCHAR, Types.VARCHAR });
		}
		
		
		return success();	
	}
	

	/**
	 * 
	 * 승인요청 팝업 - 최근 승인요청 목록 조회.<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 10. 27.
	 */
	public String getLatestApprReqList() throws CdpException {
		this.items = cdpService.queryForList("CDP.SELECT_LATEST_APPR_REQ_LIST", new Object[] { getUser().getCompanyId(), getUser().getUserId() }, new int[] { Types.INTEGER, Types.INTEGER });
		return success();
	}

	/**
	 * 
	 * 승인요청 팝업 - 최근 승인요청 승인라인 조회.<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 10. 27.
	 */
	public String getApprReqLineList() throws CdpException {
		log.debug(CommonUtils.printParameter(request));
		
		String reqNum = ParamUtils.getParameter(request, "REQ_NUM", "");
		this.items = cdpService.queryForList("CDP.SELECT_APPR_REQ_LINE_LIST", new Object[] { getUser().getCompanyId(), getUser().getUserId(), reqNum }, new int[] { Types.INTEGER, Types.INTEGER, Types.INTEGER });
		return success();
	}


	/**
	 * 
	 * 경력개발계획 - 승인요청<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 10. 27.
	 */
	public String saveMyCdp() throws CdpException {
		log.debug(CommonUtils.printParameter(request));
		
		this.saveCount = cdpService.saveMyCdp(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 승인현황 팝업 - 승인라인별 상태 조회..<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 10. 27.
	 */
	public String getApprStsList() throws CdpException {
		log.debug(CommonUtils.printParameter(request));
		
		String reqNum = ParamUtils.getParameter(request, "REQ_NUM", "");
		this.items = cdpService.queryForList("CDP.SELECT_APPR_REQ_STS_LIST", new Object[] { getUser().getCompanyId(), reqNum }, new int[] { Types.INTEGER, Types.INTEGER  });
		return success();
	}
	
	/**
	 * 
	 *  승인요청 - 취소처리.<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 10. 27.
	 */
	public String cancelApprReq() throws CdpException {
		log.debug(CommonUtils.printParameter(request));
		
		this.saveCount = cdpService.cancelApprReq(request, getUser());
		return success();
	}
	

	
}