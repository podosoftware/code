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
import kr.podosoft.ws.service.em.EmAlwService;
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
 * 교육훈련 > 상시학습
 * @author thlim
 *
 */
public class EmAlwMainAction extends FrameworkActionSupport {
	
	private List<Map<String, Object>> items;
	private List<Map<String, Object>> items1;
	private Map<String, Object> item;
	
	private EmAlwService emAlwService;
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

	public EmAlwService getEmAlwService() {
		return emAlwService;
	}

	public void setEmAlwService(EmAlwService emAlwService) {
		this.emAlwService = emAlwService;
	}

	public EmService getEmService() {
		return emService;
	}

	public void setEmService(EmService emService) {
		this.emService = emService;
	}

	/**
	 * 교육훈련 상시학습 메인페이지 호출
	 * @return
	 * @throws Exception
	 */
	public String viewMain() throws Exception {
		log.info(this.getClass().getName());
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		// 최소/최대 년도 조회
		item = emService.selectMyEduYear(companyid, userid);
		
		request.setAttribute("item", item);
		
		return success();
	}
	
	
	/**
	 * 교육훈련 > 상시학습
	 * 엑셀다운로드 
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public String downByExcel() throws Exception {
		
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		Calendar cal = Calendar.getInstance();
		
		int year = Integer.parseInt(ParamUtils.getParameter(request, "year", cal.get(Calendar.YEAR)+""));
		
		this.items = emAlwService.selectAlwListExcel(companyid, userid, year);
		
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
					"상시학습종류","과정명","취득점수","학습기간","실적시간","인정시간","지정학습","지정학습구분","기관성과평가","업무시간구분",
					"교육기관구분","교육기관명", "인정직급","승인현황"
			}; // 13
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "상시학습현황("+year+"년)");
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
						case 0: // 상시학습종류
							if(itMap.get("ALW_STD_NM")!=null) tmp = itMap.get("ALW_STD_NM"); else tmp = ""; 
							cell.setCellStyle(dataStyleL);
							break;
						case 1: // 과정명
							if(itMap.get("SUBJECT_NM")!=null) tmp = itMap.get("SUBJECT_NM"); else tmp = ""; 
							cell.setCellStyle(dataStyleL);
							break;
						case 2: // 취득점수
							if(itMap.get("SCR")!=null) tmp = itMap.get("SCR"); else tmp = ""; 
							cell.setCellStyle(dataStyleR);
							break;
						case 3: // 학습기간
							if(itMap.get("EDU_PERIOD")!=null) tmp = itMap.get("EDU_PERIOD"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 4: // 실적시간
							if(itMap.get("EDU_HOUR")!=null) tmp = itMap.get("EDU_HOUR"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 5: // 인정시간
							if(itMap.get("RECOG_TIME")!=null) tmp = itMap.get("RECOG_TIME"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 6: // 지정학습
							if(itMap.get("DEPT_DESIGNATION_YN")!=null) tmp = itMap.get("DEPT_DESIGNATION_YN"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 7: // 지정학습구분
							if(itMap.get("DEPT_DESIGNATION_NM")!=null) tmp = itMap.get("DEPT_DESIGNATION_NM"); else tmp = ""; 
							cell.setCellStyle(dataStyleC);
							break;
						case 8: // 기관성과평가
							if(itMap.get("PERF_ASSE_SBJ_NM")!=null) tmp = itMap.get("PERF_ASSE_SBJ_NM"); else tmp = "";
							cell.setCellStyle(dataStyleC);
							break;
						case 9: // 업무시간구분
							if(itMap.get("OFFICETIME_NM")!=null) tmp = itMap.get("OFFICETIME_NM"); else tmp = "";
							cell.setCellStyle(dataStyleC);
							break;
						case 10: // 교육기관구분
							if(itMap.get("EDUINS_DIV_NM")!=null) tmp = itMap.get("EDUINS_DIV_NM"); else tmp = "";
							cell.setCellStyle(dataStyleC);
							break;
						case 11: // 교육기관명
							if(itMap.get("INSTITUTE_NAME")!=null) tmp = itMap.get("INSTITUTE_NAME"); else tmp = "";
							cell.setCellStyle(dataStyleC);
							break;
						case 12: // 인정직급
							if(itMap.get("GRADE_NM")!=null) tmp = itMap.get("GRADE_NM"); else tmp = "";
							cell.setCellStyle(dataStyleC);
							break;
						case 13: // 승인현황
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
				if(k==0)sheet.setColumnWidth((short)k, (short)12000);
				if(k==1)sheet.setColumnWidth((short)k, (short)10000);
				if(k==2)sheet.setColumnWidth((short)k, (short)3000);
				if(k==3)sheet.setColumnWidth((short)k, (short)6000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
				if(k==6)sheet.setColumnWidth((short)k, (short)4000);
				if(k==7)sheet.setColumnWidth((short)k, (short)4000);
				if(k==8)sheet.setColumnWidth((short)k, (short)4000);
				if(k==9)sheet.setColumnWidth((short)k, (short)4000);
				if(k==10)sheet.setColumnWidth((short)k, (short)4000);
				if(k==11)sheet.setColumnWidth((short)k, (short)4000);
				if(k==12)sheet.setColumnWidth((short)k, (short)4000);
				if(k==13)sheet.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "상시학습현황("+year+"년).xls";
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return success();
	}
	
}
