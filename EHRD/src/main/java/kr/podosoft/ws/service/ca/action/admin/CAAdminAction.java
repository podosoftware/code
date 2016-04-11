package kr.podosoft.ws.service.ca.action.admin;

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

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;

import kr.podosoft.ws.service.ba.BaService;
import kr.podosoft.ws.service.cdp.CdpService;
import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.ca.CAException;
import kr.podosoft.ws.service.ca.CAService;
import kr.podosoft.ws.service.kpi.KPIException;
import kr.podosoft.ws.service.utils.CommonUtils;

import architecture.common.util.StringUtils;
import architecture.ee.util.ApplicationHelper;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

public class CAAdminAction extends FrameworkActionSupport {

	private static final long serialVersionUID = 4156263706700955611L;

	private int pageSize = 15 ;
	
    private int startIndex = 0 ;  
    
    private String sortField;
    
    
	private String sortDir;
    
    private Filter filter;
    
    private int totalItemCount = 0;	
    
    private int saveCount = 0;

	private int year = 0;

	private List items;
	
	private List items1;
	
	private List items2; 

	private List<Map<String,Object>> items3;
	
	private List subItems;
	 
	private String statement ; 
	
	private CAService caService; 
	
	private Map question;
	
	private List examples;
	
	private String targetAttachmentContentType = "";
	
	private int targetAttachmentContentLength = 0;
	
	private InputStream targetAttachmentInputStream = null;
	
	private String targetAttachmentFileName = "";
	
	private CdpService cdpService;
	
	private BaService baSrv;
	
	private String rslt;
	
	

	public String getRslt() {
		return rslt;
	}

	public void setRslt(String rslt) {
		this.rslt = rslt;
	}

	public BaService getBaSrv() {
		return baSrv;
	}

	public void setBaSrv(BaService baSrv) {
		this.baSrv = baSrv;
	}

	public CdpService getCdpService() {
		return cdpService;
	}

	public void setCdpService(CdpService cdpService) {
		this.cdpService = cdpService;
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

	public Filter getFilter() {
		return filter;
	}

	public void setFilter(Filter filter) {
		this.filter = filter;
	}

	
	public List getExamples() {
		return examples;
	}

	public void setExamples(List examples) {
		this.examples = examples;
	}

	public Map getQuestion() {
		return question;
	}

	public void setQuestion(Map question) {
		this.question = question;
	}

	public CAService getCaService() {
		return caService;
	}

	public void setCaService(CAService caService) {
		this.caService = caService;
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

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}
		
	public int getTotalItemCount() {
		return totalItemCount;
	}
	

	public void setTotalItemCount(int totalItemCount) {
		this.totalItemCount = totalItemCount;
	}

	
	public String getStatement() {
		return statement;
	}


	public void setStatement(String statement) {
		this.statement = statement;
	}


	public List getItems() {
		return items;
	}


	public void setItems(List items) {
		this.items = items;
	}
	
	public List getItems1() {
		return items1;
	}

	public void setItems1(List items1) {
		this.items1 = items1;
	}
	
	public List getItems2() {
		return items2;
	}

	public void setItems2(List items2) {
		this.items2 = items2;
	}
	
	public List<Map<String, Object>> getItems3() {
		return items3;
	}

	public void setItems3(List<Map<String, Object>> items3) {
		this.items3 = items3;
	}
	
	
	public int getSaveCount() {
		return saveCount;
	}

	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
	}

	public List getSubItems() {
		return subItems;
	}

	public void setSubItems(List subItems) {
		this.subItems = subItems;
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

	public void setTargetAttachmentContentLength(
			int targetAttachmentContentLength) {
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
		
		try{
			targetAttachmentFileName = URLEncoder.encode(targetAttachmentFileName, "UTF-8");
		}catch(Exception e){
			
		}
		return targetAttachmentFileName;
	}

	public void setTargetAttachmentFileName(String targetAttachmentFileName) {
		this.targetAttachmentFileName = targetAttachmentFileName;
	}
	
	//평가 생성/관리 리스트
	public String cmptAdminList(){
		this.items = caService.cmptAdminList(getUser());
		this.totalItemCount = this.items.size();
		return success();
	}
	
	public String cmtpWeightList(){  
		
		String runNum = ParamUtils.getParameter(request, "RUN_NUM");
		
		this.items = caService.cmtpWeightList(getUser(), runNum);
		return success();   
	}     
	
	//평가 생성/관리 저장
	public String cmptAdminSave() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		
		this.saveCount = caService.cmptAdminSave(map, list, getUser()); 
		
		return success();
	} 
	
	//실시관리 역량군 리스트
	public String getCmpGroupList() throws Exception {

		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		
		String runNum = ParamUtils.getParameter(request, "RUNNUM");

		items = caService.queryForList("CA.SELECT_CMPT_CMPGROUP_LIST", new Object[]{runNum,getUser().getCompanyId()}, new int []{Types.NUMERIC,Types.NUMERIC});
		return success();
	}
	
	//실시관리 역량군 삭
	public String getCmpGroupDel() throws Exception {

		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		
		String runNum = ParamUtils.getParameter(request, "RUNNUM");

		this.items = caService.queryForList("CA.UPDATE_CAM_RUN_CMPGROUP", new Object[]{companyId , runNum }, new int []{Types.NUMERIC,Types.NUMERIC});
		this.saveCount = items.size();
		
		return success();
	}
	//대상자관리 대상자목록 리스트
	public String runTargetList() throws Exception {

		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		
		String runNum = ParamUtils.getParameter(request, "RUN_NUM");
		String mod = ParamUtils.getParameter(request, "MOD");
		Map map =  new HashMap();
		
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		if("NOTRUN".equals(mod)){
			this.items3 = cdpService.dynamicQueryForList("CA.SELECT_NOT_RUN_TARGET_LIST", startIndex, pageSize, sortField, sortDir, "NAME", filter, new Object[]{companyId,runNum}, new int []{Types.NUMERIC,Types.NUMERIC},map);
		}else if("RUN".equals(mod)){
			this.items3 = cdpService.dynamicQueryForList("CA.SELECT_RUN_TARGET_LIST", startIndex, pageSize, sortField, sortDir, "NAME", filter, new Object[]{companyId,runNum}, new int []{Types.NUMERIC,Types.NUMERIC},map);
		}
		
		//서버 paging
		if(this.items3 !=null && this.items3.size()>0){
			this.totalItemCount = Integer.parseInt(this.items3.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		
		//this.totalItemCount = this.items.size();
		
		return success();
	}
	//대상자관리 대상자 목록 저장
	public String setRunTargetSave() throws Exception {
		
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		saveCount += caService.runTargetSave(request, getUser() );
		return success();
		
	}
	
	/**
	 * 방향설정 목록리스트
	 * @return
	 * @throws Exception
	 */
	public String runDirList() throws Exception {

		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		
		String runNum = ParamUtils.getParameter(request, "RUN_NUM");

		//items3 = caService.queryForList("CA.SELECT_RUN_DIRECTION_LIST", new Object[]{companyId,runNum,companyId,runNum}, new int []{Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC});
		
		Map map =  new HashMap();
		
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		this.items3 = cdpService.dynamicQueryForList("CA.SELECT_RUN_DIRECTION_LIST", startIndex, pageSize, sortField, sortDir, "NAME", filter, new Object[]{companyId,runNum,companyId,runNum}, new int []{Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC},map);
		
		//서버 paging
		if(this.items3 !=null && this.items3.size()>0){
			this.totalItemCount = Integer.parseInt(this.items3.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	}
	//방향설정 임직원 리스트
	public String dirEmployeeList() throws Exception {

		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		String userId = ParamUtils.getParameter(request, "USERID");
		String runNum = ParamUtils.getParameter(request, "RUN_NUM");
		
		Map map =  new HashMap();
		
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		this.items3 = cdpService.dynamicQueryForList("CA.SELECT_RUN_EMPOLYEE_LIST", startIndex, pageSize, sortField, sortDir, "NAME", filter, new Object[]{companyId,runNum,userId, userId}, new int []{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC},map);

		//서버 paging
		if(this.items3 !=null && this.items3.size()>0){
			this.totalItemCount = Integer.parseInt(this.items3.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	}
	//방향설정 상사진단자 리스트
	public String dirUserList() throws Exception {

		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		long companyId = getUser().getCompanyId();
		String userId = ParamUtils.getParameter(request, "USERID");
		String runNum = ParamUtils.getParameter(request, "RUN_NUM");
		String runDirCd = ParamUtils.getParameter(request, "RUNDIRECTION_CD");
		
		items = caService.queryForList("CA.SELECT_RUN_DIR_USER_LIST", new Object[]{companyId, userId,runDirCd,runNum}, new int []{Types.NUMERIC, Types.NUMERIC,Types.VARCHAR, Types.NUMERIC});
		return success();
	}
	
	//방향 설정, 진단자 설정저장
	public String saveDirUser() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += caService.saveDirUser(request, getUser());
		return success();
	}
	
	//방향 설정, 자동 설정저장
	public String saveDirAutoUser() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		this.saveCount += caService.saveDirAutoUser(request, getUser());
		
		
		return success();
	}
		
	
	//실시관리 엑셀 다운로드
	@SuppressWarnings("deprecation")
	public String cmptAdminListExcel(){
		
		try {		
						
			this.items = caService.cmptAdminList(getUser());
			
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
			/* 40°³ */
			String[] cell_value = {
					"실시년도", "실시코드", "실시유형", "실시명", "실시기간", "상태", "사용여부"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "실시관리목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						String[] tempStr = null;

						switch(k) {
							case 0: if(map.get("YYYY")!=null) tmp = map.get("YYYY"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("RUN_NUM")!=null) tmp = map.get("RUN_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("EVL_TYPE_STRING")!=null) tmp = map.get("EVL_TYPE_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("RUN_NAME")!=null) tmp = map.get("RUN_NAME"); else tmp = "";  cell.setCellStyle(style2); break;
							case 4: if(map.get("RUN_DATE")!=null) tmp = map.get("RUN_DATE"); else tmp = ""; cell.setCellStyle(style2); break;
							case 5: if(map.get("RUN_STATE")!=null) tmp = map.get("RUN_STATE"); else tmp = ""; cell.setCellStyle(style2); break;
							case 6: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; cell.setCellStyle(style2); break;
						}
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet.setColumnWidth((short)k, (short)10000);
				if(k==3)sheet.setColumnWidth((short)k, (short)10000);
				if(k==4)sheet.setColumnWidth((short)k, (short)8000);
				if(k==5)sheet.setColumnWidth((short)k, (short)3000);
				if(k==6)sheet.setColumnWidth((short)k, (short)3000);

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
			this.targetAttachmentFileName = " 실시관리목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	} 
	
	// 설문관리 - 설문문항 POOL 리스트 엑셀 다운로드
	@SuppressWarnings("deprecation")
	public String getSurvQstnPoolExcel(){
		
		try {		
						
			this.items = caService.getSurvQstnPool(getUser());
			
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
					"문항POOL 번호", "문항유형", "문항유형코드", "설문문항", "사용여부(Y/N)"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "대상자 목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						String[] tempStr = null;

						switch(k) {
							case 0: if(map.get("QSTN_POOL_NO")!=null) tmp = map.get("QSTN_POOL_NO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("QSTN_TYPE_CD_STRING")!=null) tmp = map.get("QSTN_TYPE_CD_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("QSTN_TYPE_CD")!=null) tmp = map.get("QSTN_TYPE_CD"); else tmp = "";  cell.setCellStyle(style2); break;
							case 3: if(map.get("QSTN")!=null) tmp = map.get("QSTN"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; cell.setCellStyle(style2); break;
						}
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet.setColumnWidth((short)k, (short)4000);
				if(k==2)sheet.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet.setColumnWidth((short)k, (short)8000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);

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
			this.targetAttachmentFileName = " 설문관리 문항POOL 목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	} 
	
	//역량평가자 설정 엑셀 업로드
	public String cmptTargetExcelUpload() {
		String runNum = ParamUtils.getParameter(request, "runNum");
		this.saveCount = caService.cmptTargetExcelSaveService(runNum, getUser(), request);
		
		return success();
	}
	

	//KPI매핑 설정 엑셀 업로드
	public String caOperatorKpiMappUpload() {
		this.saveCount = caService.caOperatorKpiMappUploadService(getUser(), request);
		return success();
	}
	
	
	//역량매핑 설정 엑셀 업로드
	public String caOperatorCmptMappUpload() {
		this.saveCount = caService.caOperatorCmptMappUploadService(getUser(), request);
		
		return success();
	}
	
	//역량평가자 설정 역량진단 콤보박스 리스트
	public String cmptDiagnosisList(){
		
		this.items = caService.cmptDiagnosisList(getUser());
		
		return success();
	}
	//역량평가자 설정 역량진단 콤보박스 리스트 (대상자관리)
		public String cmptDiagnosisObjList() throws CAException{
			long companyid = getUser().getCompanyId();
			
			this.items1 = caService.queryForList("CA.GET_CMPT_DIAG_OBJ_LIST", new Object[]{companyid}, new int []{Types.NUMERIC});
			
			return success();
		} 
	
	//역량 평가자 설정 리스트
	public String cmptTargetList(){
		
	    String runNum = ParamUtils.getParameter(request, "RUN_NUM");
		
		this.items2 = caService.cmptTargetList(getUser(), runNum);
		this.totalItemCount = items2.size();
		return success();
	} 
	
	
	//역량 평가자 설정 리스트V2
	public String cmptTargetListV2(){
		
	    String runNum = ParamUtils.getParameter(request, "RUN_NUM");
		
		this.items2 = caService.cmptTargetListV2(getUser(), runNum);
		this.totalItemCount = items2.size();
		return success();
	} 
	

	
	//역량 평가자 1,2차 설정 평가자 리스트
	public String cmptTargetUser() throws CAException{
		    
		long companyid = getUser().getCompanyId();
	    int dvsId = Integer.parseInt(ParamUtils.getParameter(request, "DIVISIONID"));
	    int highDvsId = Integer.parseInt(ParamUtils.getParameter(request, "HIGH_DVSID"));
	    long pUserid = Long.parseLong(ParamUtils.getParameter(request, "USERID"));
	    String evlLevel = ParamUtils.getParameter(request, "EVL_LEVEL", "1");
	    
	    int deptNo = 0;
	    if(evlLevel.equals("1")){
	    	deptNo = dvsId;
	    }else{
	    	deptNo = highDvsId;
	    }
	    
	    if(evlLevel.equals("1") || evlLevel.equals("2")){
	    	//대상자의 소속 부서 내 부서장 검색
	    	this.items1 = caService.queryForList("CA.GET_CMPT_TARGET_USER", new Object[]{companyid, deptNo, companyid, pUserid}, new int []{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
	    }else{
	    	//전사 부서장 검색
	    	this.items1 = caService.queryForList("CA.GET_CMPT_TARGET_ALL_MANAGER", new Object[]{companyid}, new int []{Types.NUMERIC});
	    }
	    
		return success();
	} 	
	
	
	//역량 평가자 1,2차 설정 평가자 리스트 V2
	public String cmptTargetUserV2() throws CAException{
		    
		long companyid = getUser().getCompanyId();
	    int dvsId = Integer.parseInt(ParamUtils.getParameter(request, "DIVISIONID"));
	    int highDvsId = Integer.parseInt(ParamUtils.getParameter(request, "HIGH_DVSID"));
	    long pUserid = Long.parseLong(ParamUtils.getParameter(request, "USERID"));
	    String evlLevel = ParamUtils.getParameter(request, "EVL_LEVEL", "1");
	    
	    int deptNo = 0;
	    if(evlLevel.equals("1")){
	    	deptNo = dvsId;
	    }else{
	    	deptNo = highDvsId;
	    }
	    
	    if(evlLevel.equals("1") || evlLevel.equals("2")){
	    	//대상자의 소속 부서 내 부서장 검색
	    	this.items1 = caService.queryForList("CA.GET_CMPT_TARGET_USER", new Object[]{companyid, deptNo, companyid, pUserid}, new int []{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
	    }else{
	    	//전사 부서장 검색
	    	this.items1 = caService.queryForList("CA.GET_CMPT_TARGET_ALL_MANAGER", new Object[]{companyid}, new int []{Types.NUMERIC});
	    }
	    
		return success();
	} 
	
	//역량 평가자 동료,부하 설정 평가자 리스트
	public String cmptListUserV2() throws CAException{
		    
		long companyid = getUser().getCompanyId();
	    long pUserid = Long.parseLong(ParamUtils.getParameter(request, "USERID"));
	    String colUserid = ParamUtils.getParameter(request, "COL_USERID");
	    
	   
	    
	    this.items1 = caService.cmptListUser(companyid, pUserid, colUserid);
	    
//	    this.items1 = caService.queryForList("CA.GET_CMPT_LIST_USER", new Object[]{companyid, colUserid, companyid, pUserid}, new int []{Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC});
	    
		return success();
	} 	
	
	//역량 평가자 설정 단일 저장
	public String cmptSingleTargetSave() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		this.saveCount = caService.cmptSingleTargetSave(map, getUser());

		return success();
	}
	
	//역량 평가자 설정 단일 저장V2
	public String cmptSingleTargetSaveV2() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		this.saveCount = caService.cmptSingleTargetSaveV2(map, getUser());

		return success();
	}
	
	//역량 평가자 설정 단일 삭제
	public String cmptSingleTargetDel() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		int runNum = map.get("RUN_NUM")==null? 0 : Integer.parseInt(map.get("RUN_NUM").toString());
		long userId = map.get("USERID")==null? 0 : Long.parseLong(map.get("USERID").toString());
		long companyid = getUser().getCompanyId();
		long sUserid = getUser().getUserId();
		
		this.saveCount = caService.update("CA.GET_CMPT_TARGET_INIT", new Object[]{"N", sUserid, companyid, runNum, userId}, new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		this.saveCount += caService.update("CA.GET_CMPT_DIRECTION_INIT", new Object[]{"N", sUserid, companyid, runNum, userId}, new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		
		return success();
	}
	
	//역량 평가자 설정 단일 삭제
	public String cmptSingleTargetDelV2() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		int runNum = map.get("RUN_NUM")==null? 0 : Integer.parseInt(map.get("RUN_NUM").toString());
		long userId = map.get("USERID")==null? 0 : Long.parseLong(map.get("USERID").toString());
		long companyid = getUser().getCompanyId();
		long sUserid = getUser().getUserId();
		
		this.saveCount = caService.update("CA.GET_CMPT_TARGET_INIT", new Object[]{"N", sUserid, companyid, runNum, userId}, new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		this.saveCount += caService.update("CA.GET_CMPT_DIRECTION_INIT", new Object[]{"N", sUserid, companyid, runNum, userId}, new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		
		return success();
	}
	
	//역량 평가자 설정 저장 
	public String cmptTargetSave(){
		
		String runNum  = ParamUtils.getParameter(request, "RUN_NUM");
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);				
		
		this.saveCount = caService.cmptTargetSave( runNum, list, getUser());
		
		return success(); 
	}
	
	  
	
	//역량 평가자 엑셀 다운로드
	@SuppressWarnings("deprecation")
	public String cmptTargetListExcel(){
		
		try {
			
			String runNum   = ParamUtils.getParameter(request, "RUN_NUM");
			String runName = caService.getRunName(getUser().getCompanyId(), runNum);
			
			
			this.items = caService.cmptTargetList(getUser(), runNum);
			
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
			/* 40°³ */
			String[] cell_value = {
					"번호","대상자여부", "부서", "부서번호", "이름", "사용자번호", "직무번호", "계층번호", "자가가중치", "1차평가자", "1차평가자 교직원번호", "1차 평가가중치", "2차평가자", "2차평가자 교직원번호", "2차 평가가중치"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "대상자 목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						String[] tempStr = null;
						
						
						
						switch(k) {
							case 0: if(map.get("ROWNUMBER")!=null) tmp = map.get("ROWNUMBER"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("EXCEL_CHECK")!=null) tmp = map.get("EXCEL_CHECK"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = "";  cell.setCellStyle(style2); break;
							case 3: if(map.get("DIVISIONID")!=null) tmp = map.get("DIVISIONID"); else tmp = "";  cell.setCellStyle(style2); break;
							case 4: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 5: if(map.get("USERID")!=null) tmp = map.get("USERID"); else tmp = ""; cell.setCellStyle(style2); break;
							case 6: if(map.get("JOB")!=null) tmp = map.get("JOB"); else tmp = ""; cell.setCellStyle(style2); break;
							case 7: if(map.get("LEADERSHIP")!=null) tmp = map.get("LEADERSHIP"); else tmp = ""; cell.setCellStyle(style2); break;
							case 8: if(map.get("SELF_WEIGHT")!=null) tmp = map.get("SELF_WEIGHT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 9: if(map.get("ONE_NAME")!=null) tmp = map.get("ONE_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 10: if(map.get("ONE_EMPNO")!=null) tmp = map.get("ONE_EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 11: if(map.get("ONE_WEIGHT")!=null) tmp = map.get("ONE_WEIGHT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 12: if(map.get("TWO_NAME")!=null) tmp = map.get("TWO_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 13: if(map.get("TWO_EMPNO")!=null) tmp = map.get("TWO_EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 14: if(map.get("TWO_WEIGHT")!=null) tmp = map.get("TWO_WEIGHT"); else tmp = ""; cell.setCellStyle(style2); break;
						}
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)3000);
				if(k==1)sheet.setColumnWidth((short)k, (short)3000);
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
				if(k==6)sheet.setColumnWidth((short)k, (short)4000);
				if(k==7)sheet.setColumnWidth((short)k, (short)4000);
				if(k==8)sheet.setColumnWidth((short)k, (short)3000);
				if(k==9)sheet.setColumnWidth((short)k, (short)3000);
				if(k==10)sheet.setColumnWidth((short)k, (short)3000);
				if(k==11)sheet.setColumnWidth((short)k, (short)3000);
				if(k==12)sheet.setColumnWidth((short)k, (short)3000);
				if(k==13)sheet.setColumnWidth((short)k, (short)3000);
				if(k==14)sheet.setColumnWidth((short)k, (short)3000);

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
			this.targetAttachmentFileName = runName +" 대상자 목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	} 

	//역량 평가자 엑셀 다운로드
	@SuppressWarnings("deprecation")
	public String cmptTargetListExcelV2(){
		
		try {
			
			String runNum   = ParamUtils.getParameter(request, "RUN_NUM");
			String runName = caService.getRunName(getUser().getCompanyId(), runNum);
			
			
			this.items = caService.cmptTargetListV2(getUser(), runNum);
			
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
			/* 40°³ */
			String[] cell_value = {
					"번호","대상자여부", "부서", "부서번호", "이름", "사용자번호", "직무번호", "계층번호", "자가가중치", "동료평가자 교직원번호", "동료 평가가중치", "부하평가자 교직원번호", "부하 평가가중치" , "1차평가자", "1차평가자 교직원번호", "1차 평가가중치", "2차평가자", "2차평가자 교직원번호", "2차 평가가중치"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "대상자 목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						String[] tempStr = null;
						
						
						
						switch(k) {
							case 0: if(map.get("ROWNUMBER")!=null) tmp = map.get("ROWNUMBER"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("EXCEL_CHECK")!=null) tmp = map.get("EXCEL_CHECK"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = "";  cell.setCellStyle(style2); break;
							case 3: if(map.get("DIVISIONID")!=null) tmp = map.get("DIVISIONID"); else tmp = "";  cell.setCellStyle(style2); break;
							case 4: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 5: if(map.get("USERID")!=null) tmp = map.get("USERID"); else tmp = ""; cell.setCellStyle(style2); break;
							case 6: if(map.get("JOB")!=null) tmp = map.get("JOB"); else tmp = ""; cell.setCellStyle(style2); break;
							case 7: if(map.get("LEADERSHIP")!=null) tmp = map.get("LEADERSHIP"); else tmp = ""; cell.setCellStyle(style2); break;
							case 8: if(map.get("SELF_WEIGHT")!=null) tmp = map.get("SELF_WEIGHT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 9: if(map.get("COL_EMPNO")!=null) tmp = map.get("COL_EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 10: if(map.get("COL_WEIGHT")!=null) tmp = map.get("COL_WEIGHT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 11: if(map.get("SUB_EMPNO")!=null) tmp = map.get("SUB_EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 12: if(map.get("SUB_WEIGHT")!=null) tmp = map.get("SUB_WEIGHT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 13: if(map.get("ONE_NAME")!=null) tmp = map.get("ONE_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 14: if(map.get("ONE_EMPNO")!=null) tmp = map.get("ONE_EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 15: if(map.get("ONE_WEIGHT")!=null) tmp = map.get("ONE_WEIGHT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 16: if(map.get("TWO_NAME")!=null) tmp = map.get("TWO_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 17: if(map.get("TWO_EMPNO")!=null) tmp = map.get("TWO_EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 18: if(map.get("TWO_WEIGHT")!=null) tmp = map.get("TWO_WEIGHT"); else tmp = ""; cell.setCellStyle(style2); break;
						}
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)3000);
				if(k==1)sheet.setColumnWidth((short)k, (short)3000);
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
				if(k==3)sheet.setColumnWidth((short)k, (short)3000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
				if(k==6)sheet.setColumnWidth((short)k, (short)3000);
				if(k==7)sheet.setColumnWidth((short)k, (short)3000);
				if(k==8)sheet.setColumnWidth((short)k, (short)4000);
				if(k==9)sheet.setColumnWidth((short)k, (short)8000);
				if(k==10)sheet.setColumnWidth((short)k, (short)4000);
				if(k==11)sheet.setColumnWidth((short)k, (short)8000);
				if(k==12)sheet.setColumnWidth((short)k, (short)4000);
				if(k==13)sheet.setColumnWidth((short)k, (short)4000);
				if(k==14)sheet.setColumnWidth((short)k, (short)4000);
				if(k==15)sheet.setColumnWidth((short)k, (short)4000);
				if(k==16)sheet.setColumnWidth((short)k, (short)4000);
				if(k==17)sheet.setColumnWidth((short)k, (short)4000);
				if(k==18)sheet.setColumnWidth((short)k, (short)4000);

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
			this.targetAttachmentFileName = runName +" 대상자 목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	} 
	
	
	public String cmptStatisticsList(){
		
	    String runNum = ParamUtils.getParameter(request, "RUN_NUM");
		System.out.println(runNum);
		this.items = caService.cmptStatisticsList(getUser(), runNum);
		this.totalItemCount = this.items.size();
		
		return success();
	} 
	
	
	@SuppressWarnings({ "deprecation" })
	public String cmptStatisticsListExcel(){
		
		try {
			
			String runNum   = ParamUtils.getParameter(request, "RUN_NUM");
			String runName =caService.getRunName(getUser().getCompanyId(), runNum);
			
			this.items = caService.cmptStatisticsList(getUser(), runNum);
			
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
			/* 40°³ */
			String[] cell_value = {
					"번호", "부서",  "평가자", "교직원번호", "계층", "상태", "평가현황"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "진단현황");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
			
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet.createRow(i++);
					
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
						
						Object tmp = new Object();
						Object tmp1 = new Object();
						switch(k) {
						case 0: if(map.get("ROWNUMBER")!=null) tmp = map.get("ROWNUMBER"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = "";  cell.setCellStyle(style2); break;
						case 3: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
						case 4: if(map.get("LEADERSHIP_NAME")!=null) tmp = map.get("LEADERSHIP_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 5: if(map.get("STATE")!=null) tmp = map.get("STATE"); else tmp = ""; cell.setCellStyle(style2); break;
						case 6: 
							if(map.get("T_CNT")!=null) tmp = map.get("T_CNT"); 
							else tmp = ""; 
							
							if(map.get("C_CNT")!=null) tmp1 = map.get("C_CNT"); 
							else tmp1 = ""; 
							
							cell.setCellStyle(style2); 
							break;
						}
						
						if(k==6){
							cell.setCellValue( ((BigDecimal)tmp).toString()+"명 중" +((BigDecimal)tmp1).toString()+"명 평가 완료" );
						}else{
							if ( tmp instanceof BigDecimal ) {
								cell.setCellValue( ((BigDecimal)tmp).toString() );
							} else {
								cell.setCellValue( (String)tmp );
							}
						}
						
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)3000);
				if(k==1)sheet.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)3000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)5000);
				if(k==7)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = runName +" 진단현황.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	} 
	
	public String cmptDiagInitialization(){
		
	    String runNum = ParamUtils.getParameter(request, "RUN_NUM");
	    String userId = ParamUtils.getParameter(request, "USERID");
		
		this.saveCount = caService.cmptDiagInitialization(getUser(), runNum, userId);
		
		return success();
	} 

	//KPI 매핑리스트(고객사)
	public String getOperatorKpiMappingList() throws CAException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		String jobLdrNum   = ParamUtils.getParameter(request, "jobLdrNum");
		
		
		this.items = caService.queryForList("CA.GET_OPERATOR_KPI_MAPP_LIST", new Object[] {getUser().getCompanyId(),jobLdrNum,getUser().getCompanyId()}, 
				new int[]{Types.INTEGER,Types.VARCHAR,Types.INTEGER});
		
		this.totalItemCount = items.size();
		return success();
	}
	
	//역량매핑리스트(고객사)
	public String getOperatorCompetencyMappingList() throws CAException{

		String jobLdrNum   = ParamUtils.getParameter(request, "jobLdrNum");
		log.debug("이경상"+jobLdrNum);
		
		
		this.items = caService.queryForList("CA.GET_OPERATOR_CMPT_MAPP_LIST", new Object[] {getUser().getCompanyId(),jobLdrNum,getUser().getCompanyId()}, 
				new int[]{Types.INTEGER,Types.VARCHAR,Types.INTEGER});
		
		this.totalItemCount = items.size();
		return success();
	}
	
	
	//kpi매핑저장(고객사) 
	public String operatorKpiMappingSave() throws Exception{
		
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		String jobLdrNum   = ParamUtils.getParameter(request, "jobLdrNum");
		
		this.saveCount = caService.operatorKpiMappingSaveService(list, getUser() ,jobLdrNum);
		return success();
	}
		
	
	//역량매핑저장(고객사) 
	public String getOperatorCompetencyMappingSave() throws Exception{
		
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		String jobLdrNum   = ParamUtils.getParameter(request, "jobLdrNum");
		
		
		this.saveCount = caService.operatorCompetencyMappingSaveService(list, getUser() ,jobLdrNum);
		return success();
	}
	

	
	//과정 매핑 저장
	public String setSbjctCmDetail() throws Exception{
		
		String subjectName = ParamUtils.getParameter(request, "SUBJECT_NAME");
		String trainingCode = ParamUtils.getParameter(request, "TRAINING_CODE");
		String institueName = ParamUtils.getParameter(request, "INSTITUTE_NAME");
		String eduTarget = ParamUtils.getParameter(request, "EDU_TARGET");
		String eduObject = ParamUtils.getParameter(request, "EDU_OBJECT");
		String course_cont = ParamUtils.getParameter(request, "COURSE_CONTENTS");
		String sampleUrl = ParamUtils.getParameter(request, "SAMPLE_URL");
		String useFlag = ParamUtils.getParameter(request, "USEFLAG");
		
		
		log.debug("시작한다");
		log.debug(subjectName);
		log.debug(trainingCode);
		log.debug(institueName);
		log.debug(eduTarget);			
		log.debug(eduObject);
		log.debug(course_cont);
		log.debug(sampleUrl);
		log.debug(useFlag);
		
		this.saveCount =+ caService.setSbjctDatail(subjectName, trainingCode, institueName, eduTarget, eduObject, course_cont, getUser(), useFlag, sampleUrl);
		
		
		
		return success();
	}
	
	//개설 차수 삭제
	public String delSbjectOpen() throws Exception{
		
		String subjectNum = ParamUtils.getParameter(request, "SUBJECT_NUM");
		String year = ParamUtils.getParameter(request, "YEAR");
		String chasu = ParamUtils.getParameter(request, "CHASU");
		
		
		log.debug(subjectNum);
		log.debug(year);
		log.debug(chasu);
		
		this.saveCount =+ caService.delSbjectOpen(subjectNum, year, chasu, getUser());
		
		
		
		return success();
	}
	
	/**
	 * 
	 * 평가년도 조회<br/>
	 *
	 * @return
	 * @throws CAException
	 * @since 2014. 5. 27.
	 */
	public String getEvlYearList() throws CAException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String evlFlag = ParamUtils.getParameter(request, "EVL_TYPE", "1");
		long companyid = getUser().getCompanyId();
		this.items = caService.queryForList("KPI.GET_EVL_YEAR_LIST", new Object[]{evlFlag, companyid}, new int[]{Types.VARCHAR, Types.NUMERIC});
		return success();
	}
	/**
	 * 핵심역량교육실적관리 엑셀다운로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 12. 03
	 */
	@SuppressWarnings("deprecation")
	public String getCmptEduMngListExcel() throws CAException{
		
		this.items = caService.queryForList("CA.GET_CMPT_EDU_MNG_LIST_EXCEL", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC});
		
		try {
			
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
	
			String[] cell_value = {
					"연번","핵심역량교육실적코드","평가종류", "성명", "현재소속", "현재소속코드", "현재직급","현재직급코드","재직상태","당시소속","당시소속코드","당시직급","당시직급코드","평가결과","평가점수","평가일","사전교육시작일","사전교육종료일"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "핵심역량교육실적 목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						
						switch(k) {
							case 0: if(map.get("ROWNUMBER")!=null) tmp = map.get("ROWNUMBER"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("MJR_CMPT_EDU_PRF_SEQ")!=null) tmp = map.get("MJR_CMPT_EDU_PRF_SEQ"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("EVL_NM")!=null) tmp = map.get("EVL_NM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 5: if(map.get("DIVISIONID")!=null) tmp = map.get("DIVISIONID"); else tmp = "";  cell.setCellStyle(style2); break;
							case 6: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 7: if(map.get("GRADE_NUM")!=null) tmp = map.get("GRADE_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 8: if(map.get("EMP_STS_NM")!=null) tmp = map.get("EMP_STS_NM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 9: if(map.get("THEN_DVS_NM")!=null) tmp = map.get("THEN_DVS_NM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 10: if(map.get("THEN_DIVISIONID")!=null) tmp = map.get("THEN_DIVISIONID"); else tmp = ""; cell.setCellStyle(style2); break;
							case 11: if(map.get("THEN_GRADE_NM")!=null) tmp = map.get("THEN_GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 12: if(map.get("THEN_GRADE_NUM")!=null) tmp = map.get("THEN_GRADE_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 13: if(map.get("EVL_RST")!=null) tmp = map.get("EVL_RST"); else tmp = ""; cell.setCellStyle(style2); break;
							case 14: if(map.get("EVL_SCO")!=null) tmp = map.get("EVL_SCO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 15: if(map.get("EVL_DT")!=null) tmp = map.get("EVL_DT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 16: if(map.get("EDU_ST_DT")!=null) tmp = map.get("EDU_ST_DT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 17: if(map.get("EDU_ED_DT")!=null) tmp = map.get("EDU_ED_DT"); else tmp = ""; cell.setCellStyle(style2); break;
							
						}
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)2000);
				if(k==1)sheet.setColumnWidth((short)k, (short)7000);
				if(k==2)sheet.setColumnWidth((short)k, (short)8000);
				if(k==3)sheet.setColumnWidth((short)k, (short)7000);
				if(k==4)sheet.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)6000);
				if(k==7)sheet.setColumnWidth((short)k, (short)5000);
				if(k==8)sheet.setColumnWidth((short)k, (short)3000);
				if(k==9)sheet.setColumnWidth((short)k, (short)5000);
				if(k==10)sheet.setColumnWidth((short)k, (short)4000);
				if(k==11)sheet.setColumnWidth((short)k, (short)5000);
				if(k==12)sheet.setColumnWidth((short)k, (short)5000);
				if(k==13)sheet.setColumnWidth((short)k, (short)3000);
				if(k==14)sheet.setColumnWidth((short)k, (short)3000);
				if(k==15)sheet.setColumnWidth((short)k, (short)4000);
				if(k==16)sheet.setColumnWidth((short)k, (short)4000);
				if(k==17)sheet.setColumnWidth((short)k, (short)4000);
				
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
			this.targetAttachmentFileName = "핵심역량교육실적관리 목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}
	/**
	 * 대상자관리 엑셀다운로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 12. 03
	 */
	@SuppressWarnings("deprecation")
	public String getCmptObjListExcel() throws CAException{
		
		String runNum   = ParamUtils.getParameter(request, "runNum");
		
		this.items = caService.queryForList("CA.GET_CMPT_OBJ_LIST_EXCEL", new Object[]{getUser().getCompanyId(),runNum}, new int[]{Types.NUMERIC,Types.NUMERIC});
		
		try {
			
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
	
			String[] cell_value = {
					"실시번호", "성명", "ID", "부서","부서코드", "직급","직급코드", "직무","직무코드", "계급","계급코드"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "대상자목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			Object numName="";
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						
						switch(k) {
							case 0: if(map.get("RUN_NUM")!=null) tmp = map.get("RUN_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("DIVISION")!=null) tmp = map.get("DIVISION"); else tmp = "";  cell.setCellStyle(style2); break;
							case 5: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 6: if(map.get("GRADE_NUM")!=null) tmp = map.get("GRADE_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 7: if(map.get("JOB_NAME")!=null) tmp = map.get("JOB_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 8: if(map.get("JOB")!=null) tmp = map.get("JOB"); else tmp = ""; cell.setCellStyle(style2); break;
							case 9: if(map.get("LEADERSHIP_NAME")!=null) tmp = map.get("LEADERSHIP_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 10: if(map.get("LEADERSHIP")!=null) tmp = map.get("LEADERSHIP"); else tmp = ""; cell.setCellStyle(style2); break;
							
						}
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
					}
					numName = map.get("RUN_NAME");
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet.setColumnWidth((short)k, (short)5000);
				if(k==4)sheet.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)5000);
				if(k==7)sheet.setColumnWidth((short)k, (short)5000);
				if(k==8)sheet.setColumnWidth((short)k, (short)5000);
				if(k==9)sheet.setColumnWidth((short)k, (short)5000);
				if(k==10)sheet.setColumnWidth((short)k, (short)5000);
				
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
			this.targetAttachmentFileName = numName+" 대상자목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}
	
	/**
	 * 
	 * 방향설정 엑셀다운로드(목록)<br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 12. 03
	 */
	@SuppressWarnings("deprecation")
	public String getCmptDirListExcel() throws CAException{
		
		String runNum   = ParamUtils.getParameter(request, "runNum");
		
		this.items = caService.queryForList("CA.GET_CMPT_DIR_LIST_EXCEL", new Object[]{getUser().getCompanyId(),runNum,getUser().getCompanyId(),runNum}, new int[]{Types.NUMERIC,Types.NUMERIC,Types.NUMERIC,Types.NUMERIC});
		
		try {
			
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
	
			String[] cell_value = {
					"실시번호", "성명", "ID", "부서","부서코드", "직급","직급코드", "직무","직무코드", "계급","계급코드", "상사", "동료", "부하", "본인"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "방향설정목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			Object numName="";
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						
						switch(k) {
							case 0: if(map.get("RUN_NUM")!=null) tmp = map.get("RUN_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("DIVISION")!=null) tmp = map.get("DIVISION"); else tmp = "";  cell.setCellStyle(style2); break;
							case 5: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 6: if(map.get("GRADE_NUM")!=null) tmp = map.get("GRADE_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 7: if(map.get("JOB_NAME")!=null) tmp = map.get("JOB_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 8: if(map.get("JOB")!=null) tmp = map.get("JOB"); else tmp = ""; cell.setCellStyle(style2); break;
							case 9: if(map.get("LEADERSHIP_NAME")!=null) tmp = map.get("LEADERSHIP_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 10: if(map.get("LEADERSHIP")!=null) tmp = map.get("LEADERSHIP"); else tmp = ""; cell.setCellStyle(style2); break;
							case 11: if(map.get("BOSS_CNT")!=null) tmp = map.get("BOSS_CNT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 12: if(map.get("COL_CNT")!=null) tmp = map.get("COL_CNT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 13: if(map.get("SUB_CNT")!=null) tmp = map.get("SUB_CNT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 14: if(map.get("SELF_CNT")!=null) tmp = map.get("SELF_CNT"); else tmp = ""; cell.setCellStyle(style2); break;
							
						}
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
					}
					numName = map.get("RUN_NAME");
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet.setColumnWidth((short)k, (short)5000);
				if(k==4)sheet.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)5000);
				if(k==7)sheet.setColumnWidth((short)k, (short)5000);
				if(k==8)sheet.setColumnWidth((short)k, (short)5000);
				if(k==9)sheet.setColumnWidth((short)k, (short)5000);
				if(k==10)sheet.setColumnWidth((short)k, (short)5000);
				if(k==11)sheet.setColumnWidth((short)k, (short)5000);
				if(k==12)sheet.setColumnWidth((short)k, (short)5000);
				if(k==13)sheet.setColumnWidth((short)k, (short)5000);
				if(k==14)sheet.setColumnWidth((short)k, (short)5000);
				
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
			this.targetAttachmentFileName = numName+" 방향설정목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}

	/**
	 * 
	 * 방향설정 엑셀다운로드(설정)<br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 12. 03
	 */
	@SuppressWarnings("deprecation")
	public String getCmptDirExcel() throws CAException{
		
		String runNum   = ParamUtils.getParameter(request, "runNum");
		
		this.items = caService.queryForList("CA.GET_CMPT_DIR_EXCEL", new Object[]{getUser().getCompanyId(),runNum}, new int[]{ Types.NUMERIC,Types.NUMERIC });
		
		try {
			
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
	
			String[] cell_value = {
					"진단자 교직원번호", "피진단자 교직원번호", "진단방향", "사용여부"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "방향설정");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						
						switch(k) {
							case 0: if(map.get("EXEC_EMPNO")!=null) tmp = map.get("EXEC_EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("EXED_EMPNO")!=null) tmp = map.get("EXED_EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("RUNDIRECTION_CD")!=null) tmp = map.get("RUNDIRECTION_CD"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; cell.setCellStyle(style2); break;
							
						}
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
					}
				}
			} else {
				
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)6000);
				if(k==1)sheet.setColumnWidth((short)k, (short)6000);
				if(k==2)sheet.setColumnWidth((short)k, (short)6000);
				if(k==3)sheet.setColumnWidth((short)k, (short)6000);
				
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
			this.targetAttachmentFileName = "방향설정.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}
	
	/**
	 * 
	 * 핵심역량교육실적관리  엑셀 업로드<br/>
	 *
	 * @return
	 * @since 2014. 12. 4.
	 */
	public String upLoadCoreCmptEduListExcel() {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		this.statement = caService.upLoadCoreCmptEduListExcel(getUser(), request);
		return success();
	}
	
	/**
	 * 
	 * 대상자관리  엑셀 업로드<br/>
	 *
	 * @return
	 * @since 2014. 12. 09.
	 */
	public String upLoadCaCmptObjListExcel() {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		this.statement = caService.upLoadCaCmptObjListExcel(getUser(), request);
		return success();
	}
	
	/**
	 * 
	 * 방향설정  엑셀 업로드<br/>
	 *
	 * @return
	 * @since 2014. 12. 11.
	 */
	public String upLoadCaCmptDirListExcel() {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		this.statement = caService.upLoadCaCmptDirListExcel(getUser(), request);
		return success();
	}
	/**
	 * 
	 * 상시학습관리  엑셀 업로드<br/>
	 *
	 * @return
	 * @throws CAException 
	 * @since 2014. 12. 11.
	 */
	public String upLoadEmAdminClassListExcel() throws CAException {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		this.statement = caService.upLoadEmAdminClassListExcel(getUser(), request);
		return success();
	}
}


