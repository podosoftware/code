package kr.podosoft.ws.service.ba.action;

//import java.io.File;
//import java.io.FileInputStream;
//import java.io.FileOutputStream;
import java.io.InputStream;
//import java.math.BigDecimal;
import java.net.URLEncoder;
//import java.util.Calendar;
//import java.util.Iterator;
//import java.util.List;
//import java.util.Map;

//import org.apache.poi.hssf.usermodel.HSSFCell;
//import org.apache.poi.hssf.usermodel.HSSFCellStyle;
//import org.apache.poi.hssf.usermodel.HSSFFont;
//import org.apache.poi.hssf.usermodel.HSSFRow;
//import org.apache.poi.hssf.usermodel.HSSFSheet;
//import org.apache.poi.hssf.usermodel.HSSFWorkbook;
//import org.apache.poi.hssf.util.HSSFColor;

//import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.BaService;

//import architecture.ee.util.ApplicationHelper;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
//import architecture.ee.web.util.ParamUtils;

public class BaMainAction extends FrameworkActionSupport {

	private static final long serialVersionUID = 6747326981620816241L;
	
	//엑셀다운로드 시 필요한 변수 
	private String targetAttachmentContentType = "";
	private int targetAttachmentContentLength = 0;
	private InputStream targetAttachmentInputStream = null;
	private String targetAttachmentFileName = "";
	
	private BaService baSrv;
	
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

	public BaService getBaSrv() {
		return baSrv;
	}

	public void setBaSrv(BaService baSrv) {
		this.baSrv = baSrv;
	}
	
	/**
	 * 
	 * 총괄관리자 > 고객사관리 메인<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 1.
	 */
	public String goCompanyMain() throws Exception {
		log.info(this.getClass().getName());
		
		return success();
	}

	
	/**
	 * 기본관리 > 공통코드관리
	 * 메인
	 * @return
	 * @throws Exception
	 */
	public String goCommonCodeMain() throws Exception {
		log.info(this.getClass().getName());
		
		return success();
	}
	
	/**
	 * 기본관리 > 학과관리
	 * 메인
	 * @return
	 * @throws Exception
	 */
	public String goDeptMain() throws Exception {
		log.info(this.getClass().getName());
		
		return success();
	}
	
	
	/**
	 * 기본관리 > 쿠폰관리
	 * 메인
	 * @return
	 * @throws Exception
	 */
	public String goCouponMain() throws Exception {
		log.info(this.getClass().getName());
		
		return success();
	}
	
	
	/**
	 * 기본관리 > 쿠폰관리
	 * 쿠폰할당
	 * 엑셀다운로드
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public String downStudentCouponHoldList() throws Exception {
		/*
		List<Map<String,Object>> list1 = baSrv.getStudentCouponHoldList(getUser().getCompanyId());
		
		try {
			log.debug("WorkBook Start......... ");
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet1 = null;
			HSSFRow row = null;
			
			// font 설정
			HSSFFont font1 = workbook.createFont();
			font1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFFont font2 = workbook.createFont();
			font1.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
			
			// style 설정
			HSSFCellStyle style1 = workbook.createCellStyle();
			style1.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style1.setFont(font1);
			style1.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle style2 = workbook.createCellStyle();
			style2.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			style2.setFont(font2);
			style2.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle style3 = workbook.createCellStyle();
			style3.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style3.setFont(font2);
			style3.setFillForegroundColor(HSSFColor.TAN.index);
			
			
			// sheet별 header 설정
			String[] cell_value1 = {
				"성명","학번","학과","학년","보유쿠폰","사용쿠폰"
			}; // 6
			
			log.debug("WorkBook sheet1 start......... ");
			
			sheet1 = workbook.createSheet();
			workbook.setSheetName(0 , "쿠폰할당현황");
			
			row = sheet1.createRow(0);
			
			log.debug("WorkBook sheet1 Head start......... ");
			
			for(int hidx=0; hidx<cell_value1.length; hidx++) {
				HSSFCell cell = row.createCell((short)hidx);
				cell.setCellValue(cell_value1[hidx]);
				cell.setCellStyle(style1);
			}
			
			log.debug("WorkBook sheet1 Body start......... ");
			
			if(!list1.isEmpty()) {
				for(int i=0; i<list1.size(); i++) {
					Map<String,Object> map = list1.get(i);
					row = sheet1.createRow(i+1);
					int k = 0;
					int j = 0;
					for(Iterator<String> iter = map.keySet().iterator(); iter.hasNext();) {
						Object tmp = map.get(iter.next());
						if(j>0) {
							HSSFCell cell = row.createCell((short)k++);
							
							if ( tmp instanceof BigDecimal ) {
					            cell.setCellValue( ((BigDecimal)tmp).toString() );
							} else {
								cell.setCellValue((String)tmp);
							}
							
							cell.setCellStyle(style2);
						}
						j++;
					}
				}
			}
			
			for(int cidx=0; cidx<cell_value1.length; cidx++) {
				if(cidx==0) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==1) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==2) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==3) sheet1.setColumnWidth((short)cidx, (short)3000);
				if(cidx==4) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==5) sheet1.setColumnWidth((short)cidx, (short)4000);
			}
			
			File dir = ApplicationHelper.getRepository().getFile("temp_excel");
			if(!dir.exists())
				dir.mkdir();
			
			File file = File.createTempFile("tempExcelFile", ".xls", dir);
			FileOutputStream fileOutStream = new FileOutputStream(file);			
			workbook.write(fileOutStream);
			
			this.targetAttachmentContentType = "application/vnd.ms-excel";
			this.targetAttachmentContentLength = (int)file.length();
			this.targetAttachmentInputStream = new FileInputStream(file);	
			this.targetAttachmentFileName = "학생별 쿠폰분배현황.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			log.error(e);
			throw new BaException(e);
		}
		*/
		return success();
	}
	
	
	/**
	 * 기본관리 > 쿠폰관리
	 * 쿠폰사용현황
	 * 엑셀다운로드
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("deprecation")
	public String downStudentCouponUseList() throws Exception {
		/*
		Calendar cal = Calendar.getInstance();
		
		int year = ParamUtils.getIntParameter(request, "year", cal.get(Calendar.YEAR));
		
		List<Map<String,Object>> list1 = baSrv.getStudentCouponUseList(getUser().getCompanyId(), year);
		
		try {
			log.debug("WorkBook Start......... ");
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet1 = null;
			HSSFRow row = null;
			
			// font 설정
			HSSFFont font1 = workbook.createFont();
			font1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFFont font2 = workbook.createFont();
			font1.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
			
			// style 설정
			HSSFCellStyle style1 = workbook.createCellStyle();
			style1.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style1.setFont(font1);
			style1.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle style2 = workbook.createCellStyle();
			style2.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			style2.setFont(font2);
			style2.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle style3 = workbook.createCellStyle();
			style3.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style3.setFont(font2);
			style3.setFillForegroundColor(HSSFColor.TAN.index);
			
			
			// sheet별 header 설정
			String[] cell_value1 = {
				"과정번호","과정명","개설년도","개설차수","성명",
				"학번","학과","학년","수강상태","사용일시"
			}; // 10
			
			log.debug("WorkBook sheet1 start......... ");
			
			sheet1 = workbook.createSheet();
			workbook.setSheetName(0 , "쿠폰사용현황");
			
			row = sheet1.createRow(0);
			
			log.debug("WorkBook sheet1 Head start......... ");
			
			for(int hidx=0; hidx<cell_value1.length; hidx++) {
				HSSFCell cell = row.createCell((short)hidx);
				cell.setCellValue(cell_value1[hidx]);
				cell.setCellStyle(style1);
			}
			
			log.debug("WorkBook sheet1 Body start......... ");
			
			if(!list1.isEmpty()) {
				for(int i=0; i<list1.size(); i++) {
					Map<String,Object> map = list1.get(i);
					row = sheet1.createRow(i+1);
					int k = 0;
					
					for(Iterator<String> iter = map.keySet().iterator(); iter.hasNext();) {

						Object tmp = map.get(iter.next());
						
						HSSFCell cell = row.createCell((short)k++);
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
						
						cell.setCellStyle(style2);
					}
				}
			}
			
			for(int cidx=0; cidx<cell_value1.length; cidx++) {
				if(cidx==0) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==1) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==2) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==3) sheet1.setColumnWidth((short)cidx, (short)3000);
				if(cidx==4) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==5) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==6) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==7) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==8) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==9) sheet1.setColumnWidth((short)cidx, (short)4000);
			}
			
			File dir = ApplicationHelper.getRepository().getFile("temp_excel");
			if(!dir.exists())
				dir.mkdir();
			
			File file = File.createTempFile("tempExcelFile", ".xls", dir);
			FileOutputStream fileOutStream = new FileOutputStream(file);			
			workbook.write(fileOutStream);
			
			this.targetAttachmentContentType = "application/vnd.ms-excel";
			this.targetAttachmentContentLength = (int)file.length();
			this.targetAttachmentInputStream = new FileInputStream(file);	
			this.targetAttachmentFileName = "학생별 쿠폰사용현황.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			log.error(e);
			throw new BaException(e);
		}
		*/
		return success();
	}
}