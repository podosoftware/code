package kr.podosoft.ws.service.em.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.em.EmService;
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

/**
 * 교육훈련 > 나의강의실
 * @author thlim
 *
 */
public class EmMainAction extends FrameworkActionSupport {
	
	private List<Map<String, Object>> items;
	private List<Map<String, Object>> items1;
	private Map<String, Object> item;
	
	private EmService emService;
	
	//엑셀다운로드 시 필요한 변수 
	private String targetAttachmentContentType = "";
	private int targetAttachmentContentLength = 0;
	private InputStream targetAttachmentInputStream = null;
	private String targetAttachmentFileName = "";
	
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
		try{
			targetAttachmentFileName = URLEncoder.encode(targetAttachmentFileName, "UTF-8");
		}catch(Exception e){
			
		}
		return targetAttachmentFileName;
	}

	public void setTargetAttachmentFileName(String targetAttachmentFileName) {
		this.targetAttachmentFileName = targetAttachmentFileName;
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

	public Map<String, Object> getItem() {
		return item;
	}

	public void setItem(Map<String, Object> item) {
		this.item = item;
	}

	public EmService getEmService() {
		return emService;
	}

	public void setEmService(EmService emService) {
		this.emService = emService;
	}

	/**
	 * 교육훈련 나의강의실 메인페이지 호출
	 * @return
	 * @throws Exception
	 */
	public String viewMyClassMain() throws Exception {
		log.info(this.getClass().getName());
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		// 최소/최대 년도 조회
		item = emService.selectMyEduYear(companyid, userid);
		
		request.setAttribute("item", item);
		
		return success();
	}
	/**
	 * 교육훈련 교육훈련관리 메인페이지 호출
	 * @return
	 * @throws Exception
	 */
	public String viewMyClassAdminMain() throws Exception {
		log.info(this.getClass().getName());
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		// 최소/최대 년도 조회
		//item = emService.selectMyEduYear(companyid, userid);
		
		//request.setAttribute("item", item);
		
		return success();
	}
	
	/**
	 * 교육훈련 > 나의강의실
	 * 학습현황 엑셀다운로드 
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public String downEduSttByExcel() throws Exception {
		
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		Calendar cal = Calendar.getInstance();
		
		int year = Integer.parseInt(ParamUtils.getParameter(request, "year", cal.get(Calendar.YEAR)+""));
		
		this.items = emService.selectEduSttList(companyid, userid, year, 1, "");
		
		try {
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet = null;
			HSSFRow row = null;
			
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFCellStyle titleStyle = workbook.createCellStyle();
			titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			titleStyle.setFont(font);
			titleStyle.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle dataStyleC = workbook.createCellStyle();
			dataStyleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			dataStyleC.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle dataStyleL = workbook.createCellStyle();
			dataStyleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			dataStyleL.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle dataStyleR = workbook.createCellStyle();
			dataStyleR.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
			dataStyleR.setFillForegroundColor(HSSFColor.TAN.index);
			
			// START : =================================================================
			String[] cell_value = {
					"학습유형","과정명","차수","교육기간","인정시간","부처지정학습","상시학습종류","수강상태","승인현황"
			}; // 9
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "나의학습현황");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(titleStyle);
			}
			
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map itMap = (Map)iter.next();
					row = sheet.createRow(i++);
					
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
						
						Object tmp = new Object();
						switch(k) {
						case 0: 
							if(itMap.get("TRAINING_NM")!=null) tmp = itMap.get("TRAINING_NM"); else tmp = "";
							cell.setCellStyle(dataStyleC);
							break;
						case 1:  
							if(itMap.get("SUBJECT_NAME")!=null) tmp = itMap.get("SUBJECT_NAME"); else tmp = "";
							cell.setCellStyle(dataStyleL);
							break;
						case 2:  
							if(itMap.get("CHASU")!=null) tmp = itMap.get("CHASU"); else tmp = "";
							cell.setCellStyle(dataStyleC);
							break;
						case 3:  
							if(itMap.get("EDU_PERIOD")!=null) tmp = itMap.get("EDU_PERIOD"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 4:  
							if(itMap.get("RECOG_TIME")!=null) tmp = itMap.get("RECOG_TIME"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 5:  
							if(itMap.get("DEPT_DESIGNATION_YN")!=null) tmp = itMap.get("DEPT_DESIGNATION_YN"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 6:  
							if(itMap.get("ALW_STD_NM")!=null) tmp = itMap.get("ALW_STD_NM"); else tmp = ""; 
							cell.setCellStyle(dataStyleL);
							break;
						case 7:  
							if(itMap.get("ATTEND_STATE_NM")!=null) tmp = itMap.get("ATTEND_STATE_NM"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 8: 
							if(itMap.get("REQ_STS_NM")!=null) tmp = itMap.get("REQ_STS_NM"); else tmp = "";
							cell.setCellStyle(dataStyleC);
							break;
						}
						
						if ( tmp instanceof BigDecimal ) {
							cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue( (String)tmp );
						}
					}
				}
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)3000);
				if(k==1)sheet.setColumnWidth((short)k, (short)8000);
				if(k==2)sheet.setColumnWidth((short)k, (short)3000);
				if(k==3)sheet.setColumnWidth((short)k, (short)6000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
				if(k==6)sheet.setColumnWidth((short)k, (short)12000);
				if(k==7)sheet.setColumnWidth((short)k, (short)4000);
				if(k==8)sheet.setColumnWidth((short)k, (short)4000);
			}
			
			// END : =================================================================
			
			// 엑셀파일 생성
			File dir = ApplicationHelper.getRepository().getFile("temp_excel");
			if(!dir.exists())
				dir.mkdir();
			
			File file = File.createTempFile("tempExcelFile", ".xls", dir);
			FileOutputStream fileOutStream = new FileOutputStream(file);			
			workbook.write(fileOutStream);
			
			this.targetAttachmentContentType = "application/vnd.ms-excel";
			this.targetAttachmentContentLength = (int)file.length();
			this.targetAttachmentInputStream = new FileInputStream(file);	
			this.targetAttachmentFileName = "나의학습현황.xls";
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return success();
	}
	
	
	/**
	 * 교육훈련 > 나의강의실
	 * 승진교육이수현황 엑셀다운로드 
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public String downVeterAsseReqEduByExcel() throws Exception {
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		// 교육훈련결과 승진기준달성현황 임직원상세에서 조회이면 3으로 넘어옴
		int type = Integer.parseInt(ParamUtils.getParameter(request, "type", "2"));; // 조회기준
		String _bdate = "";
		
		
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
		
		this.items = emService.selectEduSttList(companyid, userid, 0, type, _bdate);
		
		try {
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet = null;
			HSSFRow row = null;
			
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFCellStyle titleStyle = workbook.createCellStyle();
			titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			titleStyle.setFont(font);
			titleStyle.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle dataStyleC = workbook.createCellStyle();
			dataStyleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			dataStyleC.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle dataStyleL = workbook.createCellStyle();
			dataStyleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			dataStyleL.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle dataStyleR = workbook.createCellStyle();
			dataStyleR.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
			dataStyleR.setFillForegroundColor(HSSFColor.TAN.index);
			
			// START : =================================================================
			String[] cell_value = {
					"학습유형","과정명","차수","교육기간","인정시간","부처지정유무"
			}; // 6
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "승진기준달성현황");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(titleStyle);
			}
			
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map itMap = (Map)iter.next();
					row = sheet.createRow(i++);
					
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
						
						Object tmp = new Object();
						switch(k) {
						case 0: 
							if(itMap.get("TRAINING_NM")!=null) tmp = itMap.get("TRAINING_NM"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 1:  
							if(itMap.get("SUBJECT_NAME")!=null) tmp = itMap.get("SUBJECT_NAME"); else tmp = ""; 
							cell.setCellStyle(dataStyleL);
							break;
						case 2:  
							if(itMap.get("CHASU")!=null) tmp = itMap.get("CHASU"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 3:  
							if(itMap.get("EDU_PERIOD")!=null) tmp = itMap.get("EDU_PERIOD"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 4:  
							if(itMap.get("RECOG_TIME")!=null) tmp = itMap.get("RECOG_TIME"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 5:  
							if(itMap.get("DEPT_DESIGNATION_YN")!=null) tmp = itMap.get("DEPT_DESIGNATION_YN"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						}
						
						if ( tmp instanceof BigDecimal ) {
							cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue( (String)tmp );
						}
					}
				}
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)3000);
				if(k==1)sheet.setColumnWidth((short)k, (short)8000);
				if(k==2)sheet.setColumnWidth((short)k, (short)3000);
				if(k==3)sheet.setColumnWidth((short)k, (short)6000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
			}
			
			// END : =================================================================
			
			// 엑셀파일 생성
			File dir = ApplicationHelper.getRepository().getFile("temp_excel");
			if(!dir.exists())
				dir.mkdir();
			
			File file = File.createTempFile("tempExcelFile", ".xls", dir);
			FileOutputStream fileOutStream = new FileOutputStream(file);			
			workbook.write(fileOutStream);
			
			this.targetAttachmentContentType = "application/vnd.ms-excel";
			this.targetAttachmentContentLength = (int)file.length();
			this.targetAttachmentInputStream = new FileInputStream(file);	
			this.targetAttachmentFileName = "보훈직무필수교육현황.xls";
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return success();
	}
	
}
