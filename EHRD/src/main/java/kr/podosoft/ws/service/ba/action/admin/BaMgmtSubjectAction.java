package kr.podosoft.ws.service.ba.action.admin;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.BaSubjectService;
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
import org.apache.poi.ss.util.Region;
import org.apache.struts2.dispatcher.multipart.MultiPartRequestWrapper;

import architecture.ee.util.ApplicationHelper;
import architecture.ee.web.struts2.action.UploadAttachmentAction;
import architecture.ee.web.util.ParamUtils;

public class BaMgmtSubjectAction extends UploadAttachmentAction {

	private static final long serialVersionUID = -9007378534249653166L;

	//그리드의 페이지, 정렬, 필터 parameter
	private int pageSize = 15 ;
    private int startIndex = 0 ;  
    private String sortField;
    private String sortDir;
	private Filter filter;
    
	private String subjectNum; // 과정번호
	private String openNum; // 개설번호
	private int year; // 과정개설년도
	private int chasu; // 과정개설차수
	
	private String cspSubjectNum; // lms 과정번호
	private String cspSubjectChasu; // lms 과정개설차수
	
	private BaSubjectService baSubjectSrv;
	private CdpService cdpService;
	
	private List<Map<String,Object>> items;
	private List<Map<String,Object>> items2;
	private List<Map<String,Object>> items3;
	
	private int totalItemCount = 0;
	private int totalItem2Count = 0;
	private int totalItem3Count = 0;
	
	private int saveCount = 0;
	
	private String statement;
	
	private String autoHour;
	private String autoMin;

	private String targetAttachmentContentType = "";
	private int targetAttachmentContentLength = 0;	
	private InputStream targetAttachmentInputStream = null;
	private String targetAttachmentFileName = "";

	public String getAutoHour() {
		return autoHour;
	}
    public void setAutoHour(String autoHour) {
		this.autoHour = autoHour;
	}
    public String getAutoMin() {
    	return autoMin;
    }
    public void setAutoMin(String autoMin) {
    	this.autoMin = autoMin;
    }
	public String getSortDir() {
		return sortDir;
	}
	public void setSortDir(String sortDir) {
		this.sortDir = sortDir;
	}
	public String getSortField() {
		return sortField;
	}

	public void setSortField(String sortField) {
		this.sortField = sortField;
	}

	public Filter getFilter() {
		return filter;
	}

	public void setFilter(Filter filter) {
		this.filter = filter;
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

	public CdpService getCdpService() {
		return cdpService;
	}

	public void setCdpService(CdpService cdpService) {
		this.cdpService = cdpService;
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
		try{
			targetAttachmentFileName = URLEncoder.encode(targetAttachmentFileName, "UTF-8");
		}catch(Exception e){
			
		}
		return targetAttachmentFileName;
	}

	public void setTargetAttachmentFileName(String targetAttachmentFileName) {
		this.targetAttachmentFileName = targetAttachmentFileName;
	}

	public String getOpenNum() {
		return openNum;
	}

	public void setOpenNum(String openNum) {
		this.openNum = openNum;
	}
	
	public int getSaveCount() {
		return saveCount;
	}

	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
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

	public BaSubjectService getBaSubjectSrv() {
		return baSubjectSrv;
	}

	public void setBaSubjectSrv(BaSubjectService baSubjectSrv) {
		this.baSubjectSrv = baSubjectSrv;
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
	
	protected boolean isMultiPart() {
		HttpServletRequest request = getRequest();
		return (request instanceof MultiPartRequestWrapper);
	}
	
	
	/**
	 * 교육관리 - 가중치계산<br/>
	 * @since 2015. 02. 08.
	 */
	public String getAutoRecogTime() {
		log.debug(CommonUtils.printParameter(request));
		
		this.items = baSubjectSrv.getAutoRecogTime(request, getUser());
		return success();
	}
	
	/**
	 * 과정관리 - 화면이동
	 * @since 2015. 02. 08.
	 */
	public String goCourceMain() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		return success();
	}
	
	/**
	 * 과정관리 - 상세화면
	 * @since 2015. 02. 08.
	 */
	public String getMgmtSbjctInfo() throws Exception {
		
		if(subjectNum==null) {
			throw new BaException(""); 
		}
		// 과정상세정보
		items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SBJCT_INFO", 
				new Object[] {
				subjectNum, getUser().getCompanyId() 
				}, 
				new int[] {
				Types.VARCHAR, Types.INTEGER
				});
		return success();
	}

	/**
	 * 과정관리 - 목록
	 * @since 2015. 02. 08.
	 */
	public String getMgmtSbjctList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		Map<String, Object> map =  new HashMap<String, Object>();
		
		// 과정목록
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_SBJCT_LIST", startIndex, pageSize, sortField, sortDir, "SUBJECT_NAME", filter, new Object[]{ getUser().getCompanyId() }, new int[]{  Types.INTEGER  }, map);
		
		if(this.items !=null && this.items.size()>0){
			// 과정수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		return success();
	}
	
	/**
	 * 과정관리 - 과정 등록<br/> 
	 * @since 2015. 02. 08.
	 */
	public String saveSbjctInfo() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSubjectSrv.saveSbjctInfo(request, getUser());
		return success();
	}
	
	/**
	 * 과정관리 - 상시학습유형 목록 조회<br/>
	 * @since 2015. 02. 08.
	 */
	public String getAlwStdTypeList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String level = ParamUtils.getParameter(request,"LEVEL", "1");
		String queryStr = "";
		if(level.equals("1")){
			queryStr = "SELECT_ALW_STD_CD_LIST1";
		}else if(level.equals("2")){
			queryStr = "SELECT_ALW_STD_CD_LIST2";
		}else if(level.equals("3")){
			queryStr = "SELECT_ALW_STD_CD_LIST";
		}
		items = baSubjectSrv.queryForList("BA_SUBJECT."+queryStr, new Object[]{getUser().getCompanyId()}, new int []{Types.NUMERIC});
		return success();
	}
	
	/**
	 * 과정관리 - 수료기준 목록 조회<br/>
	 * @since 2015. 02. 08.
	 */
	public String getSbjctCmpltStndList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String subjectNum = ParamUtils.getParameter(request,"SUBJECT_NUM");
		
		items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SBJCT_CMPLT_STND_LIST", new Object[]{getUser().getCompanyId(), subjectNum}, new int []{Types.NUMERIC, Types.NUMERIC});
		return success();
	}

	/**
	 * 과정관리 - 과정역량매핑
	 * @since 2015. 02. 08.
	 */
	public String getSbjctCmMapList() throws Exception {
		
		long companyId = getUser().getCompanyId();
		
		items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SBJCT_CM_MAPPING_LIST", new Object[]{companyId, subjectNum, companyId}, new int[] {Types.INTEGER, Types.VARCHAR, Types.INTEGER});
		
		return success();
	}
	
	/**
	 * 과정관리 - 과정 엑셀 업로드<br/>
	 * @since 2015. 02. 08.
	 */
	public String upLoadSbjctListExcel() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		this.statement = baSubjectSrv.upLoadSbjctListExcel(getUser(), request);
		return success();
	}
	
	/**
	 * 과정관리 - 과정 엑셀 다운로드<br/>
	 * @since 2015. 02. 08.
	 */
	@SuppressWarnings("deprecation")
	public String downSbjctListExcel() throws Exception {
		if(year<1) {
			Calendar cal = Calendar.getInstance();
			year = cal.get(Calendar.YEAR);
		}
		
		long companyid = getUser().getCompanyId();
		// 과정목록
		List<Map<String,Object>> list1 = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SBJCT_LIST_EXCEL", 
											new Object[] {companyid}, 
											new int[] {Types.INTEGER});
		
		// 역량매핑정보
		List<Map<String,Object>> list3 = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SBJCT_MAPP_EXCEL", 
													new Object[] { companyid, }, 
													new int[] {Types.INTEGER,});
		
		
		try {
			log.debug("WorkBook Start......... ");
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet1 = null;
			HSSFSheet sheet3 = null;
			HSSFRow row = null;
			
			// font 설정
			HSSFFont font1 = workbook.createFont();
			font1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFFont font2 = workbook.createFont();
			font2.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
			
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
				"과정번호", "과정명", "학습유형코드", "학습유형",
				"교육시간(시)", "교육시간(분)", "인정시간(시)", "인정시간(분)",
				"목적", "대상", "내용", "상시학습종류코드", "상시학습종류",
				"교육기관코드", "교육기관", "부처지정학습",
				"기관성과평가필수교육코드", "기관성과평가필수교육", "교육시간구분코드", "교육시간구분",
				"교육기관구분코드", "교육기관구분", "사용여부"
			}; 
			String[] cell_value3 = {
				"과정번호", "과정명", "역량코드", "역량명", "사용여부"
			};
			
			log.debug("WorkBook sheet1 start......... ");
			
			sheet1 = workbook.createSheet();
			workbook.setSheetName(0 , "과정목록");
			
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
						HSSFCell cell = row.createCell((short)k++);
						
						Object tmp = map.get(iter.next());
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
				            cell.setCellStyle(style3);
						} else {
							cell.setCellValue((String)tmp);
							cell.setCellStyle(style2);
						}
						
					}
				}
			}
			
			for(int cidx=0; cidx<cell_value1.length; cidx++) {
				if(cidx==0) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==1) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==2) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==3) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==4) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==5) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==6) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==7) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==8) sheet1.setColumnWidth((short)cidx, (short)6000);
				if(cidx==9) sheet1.setColumnWidth((short)cidx, (short)6000);
				if(cidx==10) sheet1.setColumnWidth((short)cidx, (short)6000); //내용
				if(cidx==11) sheet1.setColumnWidth((short)cidx, (short)6000);
				if(cidx==12) sheet1.setColumnWidth((short)cidx, (short)6000);
				if(cidx==13) sheet1.setColumnWidth((short)cidx, (short)6000);
				if(cidx==14) sheet1.setColumnWidth((short)cidx, (short)6000);
				if(cidx==15) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==16) sheet1.setColumnWidth((short)cidx, (short)7000);
				if(cidx==17) sheet1.setColumnWidth((short)cidx, (short)6000);
				if(cidx==18) sheet1.setColumnWidth((short)cidx, (short)6000);
				if(cidx==19) sheet1.setColumnWidth((short)cidx, (short)6000);
				if(cidx==20) sheet1.setColumnWidth((short)cidx, (short)6000);
				if(cidx==21) sheet1.setColumnWidth((short)cidx, (short)7000);
				if(cidx==22) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==23) sheet1.setColumnWidth((short)cidx, (short)8000);
			}

			
			log.debug("WorkBook sheet3 start......... ");
			
			sheet3 = workbook.createSheet();
			workbook.setSheetName(1 , "역량매핑");
			
			row = sheet3.createRow(0);
			
			log.debug("WorkBook sheet3 Head start......... ");
			
			for(int hidx=0; hidx<cell_value3.length; hidx++) {
				HSSFCell cell = row.createCell((short)hidx);
				cell.setCellValue(cell_value3[hidx]);
				cell.setCellStyle(style1);
			}
			
			log.debug("WorkBook sheet3 Body start......... ");
			
			if(!list3.isEmpty()) {
				for(int i=0; i<list3.size(); i++) {
					Map<String,Object> map = list3.get(i);
					row = sheet3.createRow(i+1);
					int k = 0;
					
					for(Iterator<String> iter = map.keySet().iterator(); iter.hasNext();){
						HSSFCell cell = row.createCell((short)k++);
						
						Object tmp = map.get(iter.next());
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
				            cell.setCellStyle(style3);
						} else {
							cell.setCellValue((String)tmp);
							cell.setCellStyle(style2);
						}
						
						
					}
				}
			}
			
			for(int cidx=0; cidx<cell_value3.length; cidx++) {
				if(cidx==0) sheet3.setColumnWidth((short)cidx, (short)4000);
				if(cidx==1) sheet3.setColumnWidth((short)cidx, (short)8000);
				if(cidx==2) sheet3.setColumnWidth((short)cidx, (short)4000);
				if(cidx==3) sheet3.setColumnWidth((short)cidx, (short)8000);
				if(cidx==4) sheet3.setColumnWidth((short)cidx, (short)4000);
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
			this.targetAttachmentFileName = "과정목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			log.error(e);
			throw new Exception(e);
		}
		
		return success();
	}
	
	/**
	 * 과정관리 - 역량매핑 엑셀 업로드<br/>
	 * @since 2015. 02. 08.
	 */
	public String upLoadSbjctCmmappingListExcel() {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		this.statement = baSubjectSrv.upLoadSbjctCmmappingListExcel(getUser(), request);
		return success();
	}

	
	/**
	 * 차수관리 - 차수 엑셀 업로드<br/>
	 * @since 2015. 02. 08.
	 */
	public String upLoadSbjctOpenListExcel() {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		this.statement = baSubjectSrv.upLoadSbjctOpenListExcel(getUser(), request);
		return success();
	}
	
	/**
	 * 차수관리 - 폐강처리<br/>
	 * @since 2015. 02. 08.
	 */
	public String closeSbjctOpenInfo() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String subjectNum = ParamUtils.getParameter(request, "SUBJECT_NUM");
		String openNum = ParamUtils.getParameter(request, "OPEN_NUM");
		
		saveCount += baSubjectSrv.update("BA_SUBJECT.CLOSE_TB_BA_SBJCT_OPEN", new Object[]{"Y", "", getUser().getCompanyId(), subjectNum, openNum, getUser().getCompanyId(), subjectNum, openNum}, new int[]{Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		return success();
	}
	
	/**
	 * 차수관리 - 차수 번호 유효성 검사<br/>
	 * @since 2015. 02. 08.
	 */
	public String chkChasu() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		String chasu = ParamUtils.getParameter(request, "CHASU");
		saveCount = baSubjectSrv.queryForInteger("BA_SUBJECT.CHASU_COUNT_CHECK", new Object[]{getUser().getCompanyId(), subjectNum, yyyy, chasu} , new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		return success();
	}
	
	/**
	 * 차수관리 - 상세화면
	 * @since 2015. 02. 08.
	 */
	public String getMgmtSbjctOpenInfo() throws Exception {
		
		if(subjectNum==null || openNum==null) {
			throw new BaException(""); 
		}
		
		// 개설상세정보
		items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SBJCT_OPEN_INFO", 
				new Object[] {
					subjectNum, openNum, getUser().getCompanyId() 
				}, 
				new int[] {
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
				});

		return success();
	}
	
	/**
	 * 차수관리 - 차수 등록<br/>
	 * @since 2015. 02. 08.
	 */
	public String saveSbjctOpenInfo() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSubjectSrv.saveSbjctOpenInfo(request, getUser());
		return success();
	}
	
	/**
	 * 차수관리 - 일괄 차수 삭제<br/>
	 * @since 2015. 02. 08.
	 */
	public String severalDelSbjctOpenInfo() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

	    String openArrStr = ParamUtils.getParameter(request, "item");
		saveCount = baSubjectSrv.severalDelSbjctOpenInfo(getUser(), openArrStr.split(","));
		
		return success();
	}
	
	/**
	 * 차수관리 - 차수 삭제<br/>
	 * @since 2015. 02. 08.
	 */
	public String delSbjctOpenInfo() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String SUBJECT_NUM = ParamUtils.getParameter(request, "SUBJECT_NUM"); 
		String OPEN_NUM = ParamUtils.getParameter(request, "OPEN_NUM"); 
		
		saveCount = baSubjectSrv.update("BA_SUBJECT.DELETE_TB_BA_SBJCT_OPEN",
				new Object[] {getUser().getUserId(), getUser().getCompanyId(), SUBJECT_NUM, OPEN_NUM}, 
				new int[] {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		
		return success();
	}
	
	/**
	 * 차수관리 - 과정검색 팝업 - 사용하는 과정 목록 조회
	 * @since 2015. 02. 08.
	 */
	public String getSbjctUseList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		Map<String, Object> map =  new HashMap<String, Object>();

		// 과정목록
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_SBJCT_USE_LIST", startIndex, pageSize, sortField, sortDir, "SUBJECT_NAME", filter, new Object[]{ getUser().getCompanyId()  }, new int[]{  Types.INTEGER  }, map);
		if(this.items !=null && this.items.size()>0){
			// 과정수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	}
	
	/**
	 * 차수관리 - 차수목록 조회<br/>
	 * @since 2015. 02. 08.
	 */
	public String getSubjectOpenList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String sdiv = ParamUtils.getParameter(request, "SEARCHDIV", "EDU_STIME");
		String sdate = ParamUtils.getParameter(request, "SEARCHSDATE");
		String edate = ParamUtils.getParameter(request, "SEARCHEDATE");
		
		Map<String, Object> map =  new HashMap<String, Object>();
		map.put("SEARCHDIV", " AND TO_CHAR(B."+sdiv+", 'YYYY-MM-DD') BETWEEN '"+sdate+"' AND '"+edate+"' ");
		
		System.out.println("sidv >> " + sdiv);
		
		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);

		// 과정목록
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_SUBJECT_OPEN_LIST", startIndex, pageSize, sortField, sortDir, "SUBJECT_NAME", filter,
				new Object[]{ getUser().getCompanyId() }, new int[]{  Types.INTEGER  }, map);
		if(this.items !=null && this.items.size()>0){
			// 과정수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	}
	
	/**
	 * 차수관리 - 엑셀 다운로드<br/>
	 * @since 2015. 02. 08.
	 */
	@SuppressWarnings("deprecation")
	public String downSbjctOpenListExcel() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date sdate = sdf.parse(ParamUtils.getParameter(request, "SEARCHSDATE"));
		Date edate = sdf.parse(ParamUtils.getParameter(request, "SEARCHEDATE"));
		
		long companyid = getUser().getCompanyId();
		// 차수목록
		List<Map<String,Object>> list1 = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SBJCT_OPEN_LIST_EXCEL", 
											new Object[] {companyid, sdate, edate}, 
											new int[] {Types.INTEGER, Types.DATE, Types.DATE});
		
		
		try {
			log.debug("WorkBook Start......... ");
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet1 = null;
			HSSFRow row = null;
			
			// font 설정
			HSSFFont font1 = workbook.createFont();
			font1.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			HSSFFont font2 = workbook.createFont();
			font2.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
			
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
				"과정번호", "개설번호", "과정명", "학습유형", "개설년도",
				"차수", "교육시작일", "교육종료일", "신청시작일", "신청종료일",
				"취소마감일", "교육시간(시)", "교육시간(분)", "인정시간(시)", "인정시간(분)",
				"정원", "교육일수", "목적","대상", "내용",
				"상시학습종류", "교육기관", "지정학습", "기관성과평가필수교육",
				"교육시간구분", "교육기관구분", "폐강여부"
			}; 
			
			log.debug("WorkBook sheet1 start......... ");
			
			sheet1 = workbook.createSheet();
			workbook.setSheetName(0 , "차수목록");
			
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
						HSSFCell cell = row.createCell((short)k++);
						
						Object tmp = map.get(iter.next());
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
				            cell.setCellStyle(style3);
						} else {
							cell.setCellValue((String)tmp);
							cell.setCellStyle(style2);
						}
						
					}
				}
			}
			
			for(int cidx=0; cidx<cell_value1.length; cidx++) {
				if(cidx==0) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==1) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==2) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==3) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==4) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==5) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==6) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==7) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==8) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==9) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==10) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==11) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==12) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==13) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==14) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==15) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==16) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==17) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==18) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==19) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==20) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==21) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==22) sheet1.setColumnWidth((short)cidx, (short)4000);
				if(cidx==23) sheet1.setColumnWidth((short)cidx, (short)8000);
				if(cidx==24) sheet1.setColumnWidth((short)cidx, (short)8000);
				if(cidx==25) sheet1.setColumnWidth((short)cidx, (short)8000);
				if(cidx==26) sheet1.setColumnWidth((short)cidx, (short)8000);
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
			this.targetAttachmentFileName = "차수목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			log.error(e);
			throw new Exception(e);
		}
		
		
		
		return success();
	}
	
	/**
	 * 차수관리 - 화면 이동
	 * @since 2015. 02. 08.
	 */
	public String goCourceOpenMain() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		return success();
	}
	


	/**
	 * 운영관리 - 수료관리 엑셀다운로드<br/>
	 * @since 2015. 02. 08.
	 */
	@SuppressWarnings("deprecation")
	public String eduCmpltListExcel() throws Exception{
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_EDU_TARGET_LIST_EXCEL", 
					new Object[] {
						getUser().getCompanyId(), subjectNum, openNum
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER
					});
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

			HSSFCellStyle styleC = workbook.createCellStyle();
			styleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleC.setFillForegroundColor(HSSFColor.TAN.index);
	
			HSSFCellStyle styleL = workbook.createCellStyle();
			styleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			styleL.setFillForegroundColor(HSSFColor.TAN.index);
	
			// START : =================================================================
			String[] cell_value = {
					"번호", "성명", "부서", "근태", "실기평가", "발표", "과제", "기타", "분임토의", "총점수", "수강상태" 
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "수료관리");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						switch(k) {
							case 0: if(map.get("RNUM")!=null) tmp = map.get("RNUM"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 1: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 2: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 3: if(map.get("ATTEND_SCO")!=null) tmp = map.get("ATTEND_SCO"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 4: if(map.get("PRAC_SCO")!=null) tmp = map.get("PRAC_SCO"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 5: if(map.get("ANNO_SCO")!=null) tmp = map.get("ANNO_SCO"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 6: if(map.get("CHALL_SCO")!=null) tmp = map.get("CHALL_SCO"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 7: if(map.get("ETC_SCO")!=null) tmp = map.get("ETC_SCO"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 8: if(map.get("DISCU_SCO")!=null) tmp = map.get("DISCU_SCO"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 9: if(map.get("TT_GET_SCO")!=null) tmp = map.get("TT_GET_SCO"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 10: if(map.get("ATTEND_STATE_NM")!=null) tmp = map.get("ATTEND_STATE_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
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
				if(k==1)sheet.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "수료관리목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			log.debug(e);
		}
		
		return success();
	}
	
	/**
	 * 운영관리 - 수료처리 저장<br/>
	 * @since 2015. 02. 08.
	 */
	public String saveOpenCmplt() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		saveCount += baSubjectSrv.saveOpenCmplt(request, getUser());
		return success();
	}
	
	/**
	 * 운영관리 - 수료관리 증빙자료 다운로드<br/>
	 * @since 2015. 02. 08.
	 */
	public String downloadAttachments() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String userId = ParamUtils.getParameter(request, "userId");
		String openNum = ParamUtils.getParameter(request, "openNum");
		
		String objectId = userId+openNum;
		String objectType = ParamUtils.getParameter(request, "objectType");

		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_BA_DOWN_ATTACHMENTS", new Object[]{objectId, objectType},
				new int[]{Types.NUMERIC, Types.NUMERIC});
		
		return success();
	}
	
	/**
	 * 운영관리 - 수강 확정처리 대상자 역량진단결과 엑셀 다운로드<br/>
	 * @since 2015. 02. 08.
	 */
	@SuppressWarnings("deprecation")
	public String eduTargetCmptResultListExcel() throws Exception{
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_EDU_TARGET_CMPT_RESULT_LIST_EXCEL", 
					new Object[] {
						getUser().getCompanyId(), subjectNum, openNum, getUser().getCompanyId(), subjectNum, getUser().getCompanyId()
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER
					});
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

			HSSFCellStyle styleC = workbook.createCellStyle();
			styleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleC.setFillForegroundColor(HSSFColor.TAN.index);
	
			HSSFCellStyle styleL = workbook.createCellStyle();
			styleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			styleL.setFillForegroundColor(HSSFColor.TAN.index);
	
			// START : =================================================================
			String[] cell_value = {
					"성명", "부서", "교직원번호", "직급", "역량", "취득점수" 
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "역량진단결과");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						switch(k) {
							case 0: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 1: if(map.get("DVS_FULLNAME")!=null) tmp = map.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 2: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 3: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 4: if(map.get("CMPNAME")!=null) tmp = map.get("CMPNAME"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 5: if(map.get("SCORE_NUMB")!=null) tmp = map.get("SCORE_NUMB"); else tmp = ""; cell.setCellStyle(styleC); break;
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
				if(k==0)sheet.setColumnWidth((short)k, (short)4000);
				if(k==1)sheet.setColumnWidth((short)k, (short)7000);
				if(k==2)sheet.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet.setColumnWidth((short)k, (short)5000);
				if(k==4)sheet.setColumnWidth((short)k, (short)8000);
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "교육확정_역량진단결과.xls";
			
		} catch(Exception e) {
			log.debug(e);
		}
		
		return success();
	}
	
	/**
	 * 운영관리 - 대상자 추천순위 엑셀 다운로드<br/>
	 * @since 2015. 02. 08.
	 */
	@SuppressWarnings("deprecation")
	public String eduTargetRecommListExcel() throws Exception{
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_CONFIRM_THE_TARGET_LIST", 
				new Object[] {
				getUser().getCompanyId(), subjectNum, openNum
			}, 
			new int[] {
				Types.INTEGER, Types.INTEGER, Types.INTEGER
			});
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

			HSSFCellStyle styleC = workbook.createCellStyle();
			styleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleC.setFillForegroundColor(HSSFColor.TAN.index);
	
			HSSFCellStyle styleL = workbook.createCellStyle();
			styleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			styleL.setFillForegroundColor(HSSFColor.TAN.index);
	
			// START : =================================================================
			String[] cell_value = {
					"추천순위", "성명", "부서", "신청일자", "교직원번호", "직급"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "추천순위목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						switch(k) {
							case 0: if(map.get("RECOMM_RANKING")!=null) tmp = map.get("RECOMM_RANKING"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 1: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 2: if(map.get("DVS_FULLNAME")!=null) tmp = map.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 3: if(map.get("APL_DTIME")!=null) tmp = map.get("APL_DTIME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 4: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 5: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
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
				if(k==0)sheet.setColumnWidth((short)k, (short)4000);
				if(k==1)sheet.setColumnWidth((short)k, (short)4000);
				if(k==2)sheet.setColumnWidth((short)k, (short)8000);
				if(k==3)sheet.setColumnWidth((short)k, (short)6000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
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
			this.targetAttachmentFileName = "추천순위목록.xls";
			
		} catch(Exception e) {
			log.debug(e);
		}
		
		return success();
	}
	
	/**
	 * 운영관리 - 수강생 엑셀 다운로드<br/>
	 * @since 2015. 02. 08.
	 */
	@SuppressWarnings("deprecation")
	public String eduTargetListExcel() throws Exception{
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_EDU_TARGET_LIST_EXCEL", 
					new Object[] {
						getUser().getCompanyId(), subjectNum, openNum
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER
					});
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

			HSSFCellStyle styleC = workbook.createCellStyle();
			styleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleC.setFillForegroundColor(HSSFColor.TAN.index);
	
			HSSFCellStyle styleL = workbook.createCellStyle();
			styleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			styleL.setFillForegroundColor(HSSFColor.TAN.index);
	
			// START : =================================================================
			String[] cell_value = {
					"번호", "성명", "부서", "신청일자", "교직원번호", "직급", "신청구분", "수강상태" 
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "수강생목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						switch(k) {
							case 0: if(map.get("RNUM")!=null) tmp = map.get("RNUM"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 1: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 2: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 3: if(map.get("APL_DTIME")!=null) tmp = map.get("APL_DTIME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 4: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 5: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 6: if(map.get("APL_DIV_NM")!=null) tmp = map.get("APL_DIV_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 7: if(map.get("ATTEND_STATE_NM")!=null) tmp = map.get("ATTEND_STATE_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
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
				if(k==1)sheet.setColumnWidth((short)k, (short)4000);
				if(k==2)sheet.setColumnWidth((short)k, (short)8000);
				if(k==3)sheet.setColumnWidth((short)k, (short)6000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)5000);
				if(k==7)sheet.setColumnWidth((short)k, (short)5000);
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
			this.targetAttachmentFileName = "수강생목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			log.debug(e);
		}
		
		return success();
	}
	
	/**
	 * 운영관리 - 수강생 엑셀 업로드<br/>
	 * @since 2015. 02. 08.
	 */
	public String saveTargetUserUpload() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		this.statement = baSubjectSrv.saveTargetUserUpload(request, getUser()); 
		return success();
	}
	
	/**
	 * 운영관리 - 대상확정자 목록 조회<br/>
	 * @since 2015. 02. 08.
	 */
	public String getEduTargetList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_EDU_TARGET_LIST", 
					new Object[] {
						getUser().getCompanyId(), subjectNum, openNum
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER
					});
		this.totalItemCount = this.items.size();
		return success();
	}

	/**
	 * 운영관리 - 대상확정 추천순위 승인요청<br/>
	 * @since 2015. 02. 08.
	 */
	public String saveOpenRecommTarget() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		saveCount += baSubjectSrv.saveOpenRecommTarget(request, getUser());
		return success();
	}
	
	/**
	 * 운영관리 - 대상확정 저장<br/>
	 * @since 2015. 02. 08.
	 */
	public String saveOpenTarget() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		saveCount += baSubjectSrv.saveOpenTarget(request, getUser());
		return success();
	}
	
	/**
	 * 운영관리 - 대상확정이 필요한 신청자 목록 조회<br/>
	 * @since 2015. 02. 08.
	 */
	public String getConfirmTheTargetList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_CONFIRM_THE_TARGET_LIST", 
					new Object[] {
						getUser().getCompanyId(), subjectNum, openNum
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER
					});
		this.totalItemCount = this.items.size();
		return success();
	}
	
	/**
	 * 운영관리 - 차수변경처리<br/>
	 * @since 2015. 02. 08.
	 */
	public String changeUserChasu() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String oOpenNum = ParamUtils.getParameter(request, "O_OPEN_NUM");
		String nOpenNum = ParamUtils.getParameter(request, "N_OPEN_NUM");
		String userid = ParamUtils.getParameter(request, "USERID");
		
		saveCount += baSubjectSrv.update("BA_SUBJECT.CHANGE_USER_CHASU", new Object[]{ nOpenNum, getUser().getCompanyId(), oOpenNum, userid}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	/**
	 * 운영관리 - 인정직급 리스트
	 * @since 2015. 02. 08.
	 */
	public String getGradeList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_GRADE_LIST", new Object[]{getUser().getCompanyId()}, new int []{Types.NUMERIC});
		return success();
	}
	
	/**
	 * 운영관리 - 인정직급 변경처리<br/>
	 * @since 2015. 02. 08.
	 */
	public String changeUserGrade() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String TIME_GRADE_NUM = ParamUtils.getParameter(request, "TIME_GRADE_NUM");
		String openNum = ParamUtils.getParameter(request, "OPEN_NUM");
		String userid = ParamUtils.getParameter(request, "USERID");
		
		saveCount += baSubjectSrv.update("BA_SUBJECT.CHANGE_USER_GRADE", new Object[]{ TIME_GRADE_NUM, getUser().getCompanyId(), openNum, userid}, new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	/**
	 * 운영관리 - 메모저장<br/>
	 * @since 2015. 02. 08.
	 */
	public String changeUserMemo() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String eduMemo = ParamUtils.getParameter(request, "EDU_MEMO");
		
		saveCount += baSubjectSrv.update("BA_SUBJECT.CHANGE_USER_GRADE", new Object[]{ eduMemo, getUser().getCompanyId(), openNum}, new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	/**
	 * 운영관리 - 인정시간 재계산처리<br/>
	 * @since 2015. 02. 08.
	 */
	public String changeUserRecogTime() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount = baSubjectSrv.changeUserRecogTime(request, getUser());
		return success();
	}
	
	
	/**
	 * 운영관리 - 운영현황 목록 조회<br/>
	 * @since 2015. 02. 08.
	 */
	public String getSameSubjectChasuList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		

		String subjectNum = ParamUtils.getParameter(request, "SUBJECT_NUM");
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		String chasu = ParamUtils.getParameter(request, "CHASU");
		
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SAME_SUBJECT_CHASU_LIST", 
					new Object[] {
						getUser().getCompanyId(), subjectNum, yyyy, chasu
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER
					});
		
		return success();
	}
	
	/**
	 * 운영관리 - 수강상태변경처리<br/>
	 * @since 2015. 02. 08.
	 */
	public String openRunUserAttendStateChange() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String openNum = ParamUtils.getParameter(request, "OPEN_NUM");
		String userid = ParamUtils.getParameter(request, "USERID");
		String attendStateCode = ParamUtils.getParameter(request, "ATTEND_STATE_CODE");
		
		saveCount += baSubjectSrv.update("BA_SUBJECT.CHANGE_ATTEND_STATE_CODE", new Object[]{ attendStateCode, getUser().getUserId(), getUser().getCompanyId(), openNum, userid}, new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	/**
	 * 운영관리 - 사용자 삭제처리<br/>
	 * @since 2015. 02. 08.
	 */
	public String openRunUserDel() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		String openNum = ParamUtils.getParameter(request, "OPEN_NUM");
		String userid = ParamUtils.getParameter(request, "USERID");
		
		saveCount += baSubjectSrv.update("BA_SUBJECT.DEL_TB_BA_SBJCT_OPEN_CLASS", new Object[]{ getUser().getUserId(), getUser().getCompanyId(), openNum, userid}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	/**
	 * 운영관리 - 운영현황 목록 조회<br/>
	 * @since 2015. 02. 08.
	 */
	public String getSubjectOpenRunAttendList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		

		String subjectNum = ParamUtils.getParameter(request, "SUBJECT_NUM");
		String openNum = ParamUtils.getParameter(request, "OPEN_NUM");
		
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SUBJECT_OPEN_RUN_ATTEND_LIST", 
					new Object[] {
						getUser().getCompanyId(), subjectNum, openNum
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER
					});
		this.totalItemCount = this.items.size();
		return success();
	}
	
	/**
	 * 운영관리 - 운영현황 조회<br/>
	 * @since 2015. 02. 08.
	 */
	public String getSubjectOpenRunAttendCur() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		

		String subjectNum = ParamUtils.getParameter(request, "SUBJECT_NUM");
		String openNum = ParamUtils.getParameter(request, "OPEN_NUM");
		
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SUBJECT_OPEN_RUN_ATTEND_CUR", 
					new Object[] {
						getUser().getCompanyId(), subjectNum, openNum
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER
					});
		
		return success();
	}
	
	/**
	 * 운영관리 - 운영과정 목록 조회<br/>
	 * @since 2015. 02. 08.
	 */
	public String getSubjectOpenRunList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		String sdiv = ParamUtils.getParameter(request, "SEARCHDIV", "EDU_STIME");
		String sdate = ParamUtils.getParameter(request, "SEARCHSDATE");
		String edate = ParamUtils.getParameter(request, "SEARCHEDATE");
		
		Map<String, Object> map =  new HashMap<String, Object>();
		map.put("SEARCHDIV", " AND TO_CHAR(B."+sdiv+", 'YYYY-MM-DD') BETWEEN '"+sdate+"' AND '"+edate+"' ");
		
		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_SUBJECT_OPEN_RUN_LIST", startIndex, pageSize, sortField, sortDir, "SUBJECT_NAME", filter,
				new Object[]{ getUser().getCompanyId() },
				new int[]{ Types.INTEGER }, map);
		
		if(this.items !=null && this.items.size()>0){
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}

		return success();
	}

	
	/**
	 * 교육이수기준관리 - 화면 이동
	 * @return
	 * @throws Exception
	 */
	public String getRecogBaseMgmtMain() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		return success();
	}
	
	/**
	 * 교육이수기준관리 - 직급별 이수시간 조회
	 * @return
	 * @throws Exception
	 */
	public String getGradeRecogBaseTime() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		List<Map<String,Object>> list = cdpService.queryForList("CDP.GET_COMMON_CODE", new Object[]{"BA04", getUser().getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
		
		String selectOStr = "";
		String selectTStr = "";
		if(list!=null && list.size()>0){
			for(Map<String, Object> row : list){
				selectOStr += ", DD_H"+row.get("VALUE").toString()+", DD_M"+row.get("VALUE").toString();
				selectTStr += ", MAX(DECODE(ED.DEPT_DESIGNATION_CD, '"+row.get("VALUE")+"', ED.CMP_TIME_H)) DD_H"+row.get("VALUE")+", MAX(DECODE(ED.DEPT_DESIGNATION_CD, '"+row.get("VALUE")+"', ED.CMP_TIME_M)) DD_M"+row.get("VALUE");
			}
		}
		Map<String, Object> map =  new HashMap<String, Object>();
		map.put("SELECT_O_STR", selectOStr);
		map.put("SELECT_T_STR", selectTStr);
		
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_GRADE_RECOG_BASE_TIME", new Object[]{getUser().getCompanyId(), getUser().getCompanyId()}, new int[]{ Types.NUMERIC, Types.NUMERIC }, map);
		this.totalItemCount = this.items.size();
		
		return success();
	}
	
	/**
	 * 
	 * 교육이수기준관리 - 직급별 이수시간 저장<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 9. 29.
	 */
	public String saveGradeRecogTime() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSubjectSrv.saveGradeRecogTime(request, getUser());
		return success();
	}

	/**
	 * 교육이수기준관리 - 기관성과평가 필수과정 이수시간 조회
	 * @return
	 * @throws Exception
	 */
	public String getPerfAsseRecogBaseTime() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		List<Map<String,Object>> list = cdpService.queryForList("CDP.GET_COMMON_CODE", new Object[]{"BA11", getUser().getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
		
		String selectOStr = "";
		String selectTStr = "";
		if(list!=null && list.size()>0){
			for(Map<String, Object> row : list){
				selectOStr += ", PD_H"+row.get("VALUE").toString()+", PD_M"+row.get("VALUE").toString();
				selectTStr += ", MAX(DECODE(ED.PERF_ASSE_SBJ_CD, '"+row.get("VALUE")+"', ED.CMP_TIME_H)) PD_H"+row.get("VALUE")+", MAX(DECODE(ED.PERF_ASSE_SBJ_CD, '"+row.get("VALUE")+"', ED.CMP_TIME_M)) PD_M"+row.get("VALUE");
			}
		}
		Map<String, Object> map =  new HashMap<String, Object>();
		map.put("SELECT_O_STR", selectOStr);
		map.put("SELECT_T_STR", selectTStr);
		
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_PERF_ASSE_RECOG_BASE_TIME", new Object[]{getUser().getCompanyId(), getUser().getCompanyId()}, new int[]{ Types.NUMERIC, Types.NUMERIC }, map);
		this.totalItemCount = this.items.size();
		
		return success();
	}

	/**
	 * 
	 * 교육이수기준관리 - 기관성과평가 필수교육 이수시간 저장<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 9. 29.
	 */
	public String savePerfAsseRecogTime() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSubjectSrv.savePerfAsseRecogTime(request, getUser());
		return success();
	}

	/**
	 * 교육이수기준관리 - 기준에 따른 부처지정구분 코드 조회
	 * @return
	 * @throws Exception
	 */
	public String getDeptDesignationCodeList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		//String sDiv = ParamUtils.getParameter(request, "SDIV", "YEAR");
		String yyyy = ParamUtils.getParameter(request, "YYYY", "");
		
		//if(sDiv.equals("YEAR")){
			this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_DEPT_DESIGNATION_CODE_LIST", new Object[] {yyyy}, new int[] { Types.INTEGER });
		//}else{
		//	this.items = cdpService.queryForList("CDP.GET_COMMON_CODE", new Object[]{"BA04", getUser().getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
		//}
		
		return success();
	}

	/**
	 * 교육이수기준관리 - 기준에 따른 기관성과평가 필수교육 코드 조회
	 * @return
	 * @throws Exception
	 */
	public String getPerfAsseCodeList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		//String sDiv = ParamUtils.getParameter(request, "SDIV", "YEAR");
		String yyyy = ParamUtils.getParameter(request, "YYYY", "");
		
		//if(sDiv.equals("YEAR")){
			this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_PERF_ASSE_CODE_LIST", new Object[] {yyyy}, new int[] { Types.INTEGER });
		//}else{
		//	this.items = cdpService.queryForList("CDP.GET_COMMON_CODE", new Object[]{"BA11", getUser().getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
		//}
		
		return success();
	}

	/**
	 * 교육이수기준관리 - 부서원별 이수시간 조회
	 * @return
	 * @throws Exception
	 */
	public String getUserRecogBaseTime() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		String yyyy = ParamUtils.getParameter(request, "YYYY", "");
		
		//부처지정학습
		List<Map<String,Object>> ddList = new ArrayList<Map<String, Object>>();
		//기관성과평가 필수교육
		List<Map<String,Object>> pdList = new ArrayList<Map<String, Object>>();
		
			ddList = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_DEPT_DESIGNATION_CODE_LIST", new Object[] {yyyy}, new int[] { Types.INTEGER });
			
			pdList = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_PERF_ASSE_CODE_LIST", new Object[] {yyyy}, new int[] { Types.INTEGER });
		
		//부처지정학습 처리
		String selectTOStr = "";
		String selectMaxDdStr = "";
		String selectDecodeDdStr = "";
		if(ddList!=null && ddList.size()>0){
			for(Map<String, Object> row : ddList){
				selectTOStr += ", DD_H"+row.get("VALUE").toString()+", DD_M"+row.get("VALUE").toString();
				selectMaxDdStr += ", MAX(DD_H"+row.get("VALUE")+") DD_H"+row.get("VALUE")+", MAX(DD_M"+row.get("VALUE")+") DD_M"+row.get("VALUE")+"";
				selectDecodeDdStr += ", DECODE(ECD.DEPT_DESIGNATION_CD, '"+row.get("VALUE")+"', ECD.CMP_TIME_H) DD_H"+row.get("VALUE")+", DECODE(ECD.DEPT_DESIGNATION_CD, '"+row.get("VALUE")+"', ECD.CMP_TIME_M) DD_M"+row.get("VALUE")+"";
				
			}
		}
        
		//기관성과평가 필수교육 처리
		String selectMaxPdStr = "";
		String selectDecodePdStr = "";
		if(pdList!=null && pdList.size()>0){
			for(Map<String, Object> row : pdList){
				selectTOStr += ", PD_H"+row.get("VALUE")+", PD_M"+row.get("VALUE")+"";
				selectMaxPdStr += ", MAX(PD_H"+row.get("VALUE")+") PD_H"+row.get("VALUE")+", MAX(PD_M"+row.get("VALUE")+") PD_M"+row.get("VALUE")+"";
				selectDecodePdStr += ", DECODE(EP.PERF_ASSE_SBJ_CD, '"+row.get("VALUE")+"', EP.CMP_TIME_H) PD_H"+row.get("VALUE")+", DECODE(EP.PERF_ASSE_SBJ_CD, '"+row.get("VALUE")+"', EP.CMP_TIME_M) PD_M"+row.get("VALUE")+"";

			}
		}
		
		Map<String, Object> map =  new HashMap<String, Object>();
		map.put("SELECT_TO_STR", selectTOStr);
		map.put("SELECT_MAX_DD_STR", selectMaxDdStr);
		map.put("SELECT_DECODE_DD_STR", selectDecodeDdStr);
		map.put("SELECT_MAX_PD_STR", selectMaxPdStr);
		map.put("SELECT_DECODE_PD_STR", selectDecodePdStr);
		//map.put("FROM_DD_STR", fromDdStr);
		//map.put("FROM_PD_STR", fromPdStr);
		
		log.debug("selectTOStr>>>>>>>>>>>>>>>>>>>>>"+selectTOStr);
		log.debug("selectMaxDdStr>>>>>>>>>>>>>>>>>>>>>"+selectMaxDdStr);
		log.debug("selectDecodeDdStr>>>>>>>>>>>>>>>>>>>>>"+selectDecodeDdStr);
		log.debug("selectMaxPdStr>>>>>>>>>>>>>>>>>>>>>"+selectMaxPdStr);
		log.debug("selectDecodePdStr>>>>>>>>>>>>>>>>>>>>>"+selectDecodePdStr);
		
		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_USER_RECOG_TIME_LIST", startIndex, pageSize, sortField, sortDir, "NAME", filter, new Object[]{ yyyy, yyyy }, new int[]{ Types.NUMERIC, Types.NUMERIC }, map);
		if(this.items !=null && this.items.size()>0){
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		
		return success();
	}

	

	/**
	 * 
	 * 교육이수기준관리 - 부서원별 이수시간 엑셀다운로드<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 12. 01.
	 */
	@SuppressWarnings("deprecation")
	public String getUserRecogBaseTimeExcel() throws Exception{
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		

		String yyyy = ParamUtils.getParameter(request, "YYYY", "");
		
		//부처지정학습
		List<Map<String,Object>> ddList = new ArrayList<Map<String, Object>>();
		//기관성과평가 필수교육
		List<Map<String,Object>> pdList = new ArrayList<Map<String, Object>>();
		
		ddList = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_DEPT_DESIGNATION_CODE_LIST", new Object[] {yyyy}, new int[] { Types.INTEGER });
		
		pdList = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_PERF_ASSE_CODE_LIST", new Object[] {yyyy}, new int[] { Types.INTEGER });
		

		String [] cell_value = new String[4+ddList.size()+pdList.size()];
		cell_value[0] = "성명";
		cell_value[1] = "부서";
		cell_value[2] = "직급";
		cell_value[3] = "총이수시간";
		
		int cellCnt = 3;
		
		//부처지정학습 처리
		String selectTOStr = "";
		String selectMaxDdStr = "";
		String selectDecodeDdStr = "";
		if(ddList!=null && ddList.size()>0){
			for(Map<String, Object> row : ddList){
				selectTOStr += ", DD_H"+row.get("VALUE").toString()+", DD_M"+row.get("VALUE").toString();
				selectMaxDdStr += ", MAX(DD_H"+row.get("VALUE")+") DD_H"+row.get("VALUE")+", MAX(DD_M"+row.get("VALUE")+") DD_M"+row.get("VALUE")+"";
				selectDecodeDdStr += ", DECODE(ECD.DEPT_DESIGNATION_CD, '"+row.get("VALUE")+"', ECD.CMP_TIME_H) DD_H"+row.get("VALUE")+", DECODE(ECD.DEPT_DESIGNATION_CD, '"+row.get("VALUE")+"', ECD.CMP_TIME_M) DD_M"+row.get("VALUE")+"";
				
				cellCnt++;
				cell_value[cellCnt] = row.get("TEXT").toString();
				
			}
		}
        
		//기관성과평가 필수교육 처리
		String selectMaxPdStr = "";
		String selectDecodePdStr = "";
		if(pdList!=null && pdList.size()>0){
			for(Map<String, Object> row : pdList){
				selectTOStr += ", PD_H"+row.get("VALUE")+", PD_M"+row.get("VALUE")+"";
				selectMaxPdStr += ", MAX(PD_H"+row.get("VALUE")+") PD_H"+row.get("VALUE")+", MAX(PD_M"+row.get("VALUE")+") PD_M"+row.get("VALUE")+"";
				selectDecodePdStr += ", DECODE(EP.PERF_ASSE_SBJ_CD, '"+row.get("VALUE")+"', EP.CMP_TIME_H) PD_H"+row.get("VALUE")+", DECODE(EP.PERF_ASSE_SBJ_CD, '"+row.get("VALUE")+"', EP.CMP_TIME_M) PD_M"+row.get("VALUE")+"";

				cellCnt++;
				cell_value[cellCnt] = row.get("TEXT").toString();
				
			}
		}
		
		Map<String, Object> dYmap =  new HashMap<String, Object>();
		dYmap.put("SELECT_TO_STR", selectTOStr);
		dYmap.put("SELECT_MAX_DD_STR", selectMaxDdStr);
		dYmap.put("SELECT_DECODE_DD_STR", selectDecodeDdStr);
		dYmap.put("SELECT_MAX_PD_STR", selectMaxPdStr);
		dYmap.put("SELECT_DECODE_PD_STR", selectDecodePdStr);
		dYmap.put("GRID_ORDERBY_CLAUSE", " ORDER BY NAME ");
		dYmap.put("GRID_WHERE_CLAUSE", "");
		
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_USER_RECOG_TIME_LIST", new Object[]{ yyyy, yyyy }, new int[]{ Types.NUMERIC, Types.NUMERIC }, dYmap);
		
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

			HSSFCellStyle styleC = workbook.createCellStyle();
			styleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleC.setFillForegroundColor(HSSFColor.TAN.index);
	
			HSSFCellStyle styleL = workbook.createCellStyle();
			styleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			styleL.setFillForegroundColor(HSSFColor.TAN.index);
	
			// START : =================================================================
			//String[] cell_value = {
			//		"부서","부서코드", "전체부서명", "성명", "현직급명", "현직급코드", "당시직급명", "당시직급코드", "부처지정학습", "학습시작일자", "학습종료일자", "제목", "실적시간_시간", "실적시간_분", "인정시간_시간", "인정시간_분", "학습유형", "학습유형코드", "업무시간구분", "교육기관구분", "교육기관명", "내용", "취득점수", "상시학습종류" 
			//};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "교육이수기준 현황");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					//성명
					HSSFCell cell = row.createCell((short)0);
					cell.setCellStyle(styleC);
					Object tmp = new Object();
					if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = "";
					cell.setCellValue((String)tmp);
					
					//부서
					cell = row.createCell((short)1);
					cell.setCellStyle(styleL);
					tmp = new Object();
					if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = "";
					cell.setCellValue((String)tmp);
					
					//직급
					cell = row.createCell((short)2);
					cell.setCellStyle(styleL);
					tmp = new Object();
					if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = "";
					cell.setCellValue((String)tmp);
					
					//총이수시간
					cell = row.createCell((short)3);
					cell.setCellStyle(styleC);
					tmp = new Object();
					if(map.get("TT_CMP_TIME_H")!=null){
						tmp = map.get("TT_CMP_TIME_H"); 
					}else{
						tmp = "0";
					}
					tmp = tmp +"시간";
					if(map.get("TT_CMP_TIME_M")!=null){
						tmp = tmp + map.get("TT_CMP_TIME_M").toString(); 
					}else{
						tmp = tmp + "0";
					}
					tmp = tmp +"분";
					cell.setCellValue((String)tmp);
					
					if(ddList!=null && ddList.size()>0){
						for(int x=0; x<ddList.size(); x++){
							Map<String, Object> ddrow = (Map)ddList.get(x);

							//부처지정학습 코드 반영.
							cell = row.createCell((short)4+x);
							cell.setCellStyle(styleC);
							tmp = new Object();
							if(map.get("DD_H"+ddrow.get("VALUE"))!=null){
								tmp = map.get("DD_H"+ddrow.get("VALUE")); 
							}else{
								tmp = "0";
							}
							tmp = tmp +"시간";
							if(map.get("DD_M"+ddrow.get("VALUE"))!=null){
								tmp = tmp + map.get("DD_M"+ddrow.get("VALUE")).toString(); 
							}else{
								tmp = tmp + "0";
							}
							tmp = tmp +"분";
							cell.setCellValue((String)tmp);
							
						}
					}

					if(pdList!=null && pdList.size()>0){
						for(int x=0; x<pdList.size(); x++){
							Map<String, Object> pdrow = (Map)pdList.get(x);

							//부처지정학습 코드 반영.
							cell = row.createCell((short)(4+ddList.size())+x);
							cell.setCellStyle(styleC);
							tmp = new Object();
							if(map.get("PD_H"+pdrow.get("VALUE"))!=null){
								tmp = map.get("PD_H"+pdrow.get("VALUE")); 
							}else{
								tmp = "0";
							}
							tmp = tmp +"시간";
							if(map.get("PD_M"+pdrow.get("VALUE"))!=null){
								tmp = tmp + map.get("PD_M"+pdrow.get("VALUE")).toString(); 
							}else{
								tmp = tmp + "0";
							}
							tmp = tmp +"분";
							cell.setCellValue((String)tmp);
							
						}
					}

				}
			}
			
			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet.setColumnWidth((short)k, (short)8000);
				if(k==2)sheet.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet.setColumnWidth((short)k, (short)5000);
				if(k > 3)sheet.setColumnWidth((short)k, (short)5000);
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
			this.targetAttachmentFileName = "교육이수기준현황"+yyyy+"년.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			log.debug(e);
		}
		
		
		return success();
	}
	
	/**
	 * 
	 * 교육이수기준관리 - 부서원별 기준생성 저장<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 9. 29.
	 */
	public String saveAllUserRecogTime() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		long userid = getUser().getUserId();
		String yyyy = ParamUtils.getParameter(request, "YYYY", "");
		
		saveCount += baSubjectSrv.update("BA_SUBJECT.SAVE_ALL_USER_YEAR_RECOG_TIME",
				new Object[]{ userid, yyyy, yyyy, userid, userid, yyyy, yyyy, userid, userid, yyyy, yyyy, userid},
				new int []{ Types.NUMERIC, Types.NUMERIC,  Types.NUMERIC, Types.NUMERIC ,  Types.NUMERIC, Types.NUMERIC ,  Types.NUMERIC, Types.NUMERIC ,  Types.NUMERIC, Types.NUMERIC,   Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	/**
	 * 
	 * 교육이수기준관리 - 부서원 교육 이수시간 기준 저장<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 9. 29.
	 */
	public String saveUserRecogTime() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		saveCount += baSubjectSrv.saveUserRecogTime(request, getUser());
		return success();
	}
	
	
	/* 
	 * PAGE : 사용자단
	 * ROLE : ADMIN
	 * MENU : 교육훈련 > 상시학습관리
	 * MENU : 교육훈련결과 > 부서원교육현황, 부서원상시학습달성현황
	 * MENU : 승인하기 > 경력개발계획승인, 교육승인
	 */
	
	/**
	 * 교육훈련 > 상시학습관리 > 목록
	 */
	public String getAlwAdminList() throws Exception {
		
		/*
		if(request.isUserInRole("ROLE_SYSTEM")){ //총괄관리자
			//조건 없이 모두 조회..
			str = " AND COMPANYID = "+getUser().getCompanyId()+"";
		}else if(request.isUserInRole("ROLE_OPERATOR")){ //교육담당자
			//담당하는 부서(하위 포함)에 해당하는 사용자
			str = " AND CREATER = "+getUser().getUserId()+" AND COMPANYID = "+getUser().getCompanyId()+"";
		}
		*/
		
		Map<String, Object> map =  new HashMap<String, Object>();
		
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_ALW_ADMIN_LIST", startIndex, pageSize, sortField, sortDir, "CREATETIME DESC", filter, new Object[]{ year }, new int []{ Types.NUMERIC },map);
		
		//서버 paging
		if(this.items !=null && this.items.size()>0){
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		return success();
	}
	
	/**
	 * 교육훈련 > 상시학습관리 > 상세정보
	 */
	public String getAlwAdminInfo() throws Exception {
		// 상시학습 상세 정보
		String alwStdSeq = ParamUtils.getParameter(request, "alwStdSeq");
		String reqNum = ParamUtils.getParameter(request, "reqNum");
		
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_ALW_ADMIN_INFO", 
					new Object[] {
						reqNum, getUser().getCompanyId(),alwStdSeq
					}, 
					new int[] {
						Types.NUMERIC ,Types.NUMERIC ,Types.NUMERIC
					});

		totalItemCount = this.items.size();
		return success();
	}
	
	/**
	 * 교육훈련 > 상시학습관리 > 상세정보  > 임직원 리스트
	 */
	public String getAlwAdminEmpList() throws Exception {
		
		String alwStdSeq = ParamUtils.getParameter(request, "alwStdSeq");
		
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_ALW_ADMIN_EMP_LIST", 
					new Object[] {
						getUser().getCompanyId(),alwStdSeq
					}, 
					new int[] {
						Types.NUMERIC ,Types.NUMERIC
					});

		totalItemCount = this.items.size();
		return success();
	}
	
	/**
	 * 교육훈련 > 상시학습관리 - 년도조회
	 * @return
	 * @throws Exception
	 */
	public String getAlwYearList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC
		};
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.GET_ALW_YEAR_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 * 교육훈련 > 상시학습관리 - 등록 (부서교육담당자 권한)<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String saveAlwReq() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSubjectSrv.saveAlwReq(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 교육훈련 > 상시학습관리 - 수정<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String saveAlwInfo() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSubjectSrv.saveAlwInfo(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 교육훈련 > 상시학습관리 - 인정직급 수정<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String updateGradeInfo() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSubjectSrv.updateGradeInfo(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 교육훈련 > 상시학습관리 - 요청취소<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String cencleAlwReq() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSubjectSrv.cencleAlwReq(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 교육훈련 > 상시학습관리 - 요청취소<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String deleteAlwReq() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSubjectSrv.deleteAlwReq(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 교육훈련 > 상시학습관리 - 엑셀다운로드<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 12. 01.
	 */
	@SuppressWarnings("deprecation")
	public String downAlwClassAdminByExcel() throws Exception{
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		
		String year = ParamUtils.getParameter(request, "YYYY");
		
		this.items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_ALW_LIST_EXCEL", 
				new Object[] {
				year , companyid
		}, 
		new int[] {
				Types.NUMERIC ,Types.NUMERIC
		});
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

			HSSFCellStyle styleC = workbook.createCellStyle();
			styleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleC.setFillForegroundColor(HSSFColor.TAN.index);
	
			HSSFCellStyle styleL = workbook.createCellStyle();
			styleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			styleL.setFillForegroundColor(HSSFColor.TAN.index);
	
			// START : =================================================================
			String[] cell_value = {
					"부서","부서코드", "전체부서명", "성명", "현직급명", "현직급코드", "당시직급명", "당시직급코드", "부처지정학습", "학습시작일자", "학습종료일자", "제목", "실적시간_시간", "실적시간_분", "인정시간_시간", "인정시간_분", "학습유형", "학습유형코드", "업무시간구분", "교육기관구분", "교육기관명", "내용", "취득점수", "상시학습종류" 
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "상시학습관리 현황");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						switch(k) {
							case 0: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 1: if(map.get("DIVISIONID")!=null) tmp = map.get("DIVISIONID"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 2: if(map.get("DVS_FULLNAME")!=null) tmp = map.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 3: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 4: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 5: if(map.get("GRADE_NUM")!=null) tmp = map.get("GRADE_NUM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 6: if(map.get("AFTER_GRADE_NM")!=null) tmp = map.get("AFTER_GRADE_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 7: if(map.get("AFTER_GRADE_NUM")!=null) tmp = map.get("AFTER_GRADE_NUM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 8: if(map.get("DEPT_DESIGNATION_NM")!=null) tmp = map.get("DEPT_DESIGNATION_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 9: if(map.get("EDU_STIME")!=null) tmp = map.get("EDU_STIME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 10: if(map.get("EDU_ETIME")!=null) tmp = map.get("EDU_ETIME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 11: if(map.get("SUBJECT_NM")!=null) tmp = map.get("SUBJECT_NM"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 12: if(map.get("EDU_HOUR_H")!=null) tmp = map.get("EDU_HOUR_H"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 13: if(map.get("EDU_HOUR_M")!=null) tmp = map.get("EDU_HOUR_M"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 14: if(map.get("RECOG_TIME_H")!=null) tmp = map.get("RECOG_TIME_H"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 15: if(map.get("RECOG_TIME_M")!=null) tmp = map.get("RECOG_TIME_M"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 16: if(map.get("TRAINING_NM")!=null) tmp = map.get("TRAINING_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 17: if(map.get("TRAINING_CD")!=null) tmp = map.get("TRAINING_CD"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 18: if(map.get("OFFICETIME_NM")!=null) tmp = map.get("OFFICETIME_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 19: if(map.get("EDUINS_DIV_NM")!=null) tmp = map.get("EDUINS_DIV_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 20: if(map.get("INSTITUTE_NAME")!=null) tmp = map.get("INSTITUTE_NAME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 21: if(map.get("EDU_CONT")!=null) tmp = map.get("EDU_CONT"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 22: if(map.get("TT_GET_SCO")!=null) tmp = map.get("TT_GET_SCO"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 23: if(map.get("ALW_STD_STRING")!=null) tmp = map.get("ALW_STD_STRING"); else tmp = "";  cell.setCellStyle(styleL); break;
							
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
				if(k==2)sheet.setColumnWidth((short)k, (short)8000);
				if(k==3)sheet.setColumnWidth((short)k, (short)3000);
				if(k==4)sheet.setColumnWidth((short)k, (short)6000);
				if(k==5)sheet.setColumnWidth((short)k, (short)3000);
				if(k==6)sheet.setColumnWidth((short)k, (short)6000);
				if(k==7)sheet.setColumnWidth((short)k, (short)3000);
				if(k==8)sheet.setColumnWidth((short)k, (short)5000);
				if(k==9)sheet.setColumnWidth((short)k, (short)5000);
				if(k==10)sheet.setColumnWidth((short)k, (short)5000);
				if(k==11)sheet.setColumnWidth((short)k, (short)10000);
				if(k==12)sheet.setColumnWidth((short)k, (short)5000);
				if(k==13)sheet.setColumnWidth((short)k, (short)5000);
				if(k==14)sheet.setColumnWidth((short)k, (short)5000);
				if(k==15)sheet.setColumnWidth((short)k, (short)5000);
				if(k==16)sheet.setColumnWidth((short)k, (short)5000);
				if(k==17)sheet.setColumnWidth((short)k, (short)5000);
				if(k==18)sheet.setColumnWidth((short)k, (short)5000);
				if(k==19)sheet.setColumnWidth((short)k, (short)5000);
				if(k==20)sheet.setColumnWidth((short)k, (short)6000);
				if(k==21)sheet.setColumnWidth((short)k, (short)10000);
				if(k==22)sheet.setColumnWidth((short)k, (short)6000);
				if(k==23)sheet.setColumnWidth((short)k, (short)10000);
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
			this.targetAttachmentFileName = "상시학습관리 현황"+year+"년.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
			//saveCount += baSubjectSrv.saveAlwDataSts(request, getUser());
			saveCount += 1;
		} catch(Exception e) {
			log.debug(e);
		}
		
		
		return success();
	}
	
	/**
	 * 
	 * 교육훈련결과 > 부서원교육현황 - 화면이동<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 26.
	 */
	public String getEduResultPage() throws Exception{
		
		return success();
	}
	
	/**
	 * 
	 * 교육훈련결과 > 부서원교육현황 - 목록 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 26.
	 */
	public String getEduResultList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date sdate = sdf.parse(ParamUtils.getParameter(request, "SEARCHSDATE"));
		Date edate = sdf.parse(ParamUtils.getParameter(request, "SEARCHEDATE"));
		Map<String, Object>  map = new HashMap<String, Object>();
		String dvs = baSubjectSrv.getUserDivisionList(request, getUser(), "BU.DIVISIONID");
		map.put("DIVISION_STR", dvs);
		
		log.debug("######## baSubjectSrv.getUserDivisionList(request, getUser()===>"+dvs);
		
		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		//item
		Object [] params = {
				getUser().getCompanyId(), sdate,  edate, getUser().getCompanyId(), sdate,  edate
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.DATE, Types.DATE, Types.NUMERIC, Types.DATE, Types.DATE
		};
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_EDU_RES_LIST", startIndex, pageSize, sortField, sortDir, "EDU_PERIOD DESC, NAME", filter, params, jdbcTypes, map);

		if(this.items !=null && this.items.size()>0){
			// 총 갯수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		return success();
	}
	
	/**
	 * 
	 * 교육훈련결과 > 부서원교육현황 - 엑셀다운로드<br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 27.
	 */
	@SuppressWarnings("deprecation")
	public String eduResultListExcel() throws Exception{
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			
			Date sdate = sdf.parse(ParamUtils.getParameter(request, "SEARCHSDATE"));
			Date edate = sdf.parse(ParamUtils.getParameter(request, "SEARCHEDATE"));
			
			Map<String, Object>  map = new HashMap<String, Object>();
			log.debug("######## baSubjectSrv.getUserDivisionList(request, getUser()===>"+baSubjectSrv.getUserDivisionList(request, getUser(), "TA.DIVISIONID"));
			map.put("DIVISION_STR", baSubjectSrv.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
			map.put("GRID_ORDERBY_CLAUSE", " ORDER BY EDU_PERIOD, NAME ");
			map.put("GRID_WHERE_CLAUSE", "");
			map.put("GRID_ORDERBY_CLAUSE", " ORDER BY EDU_PERIOD, NAME ");
			
			Object [] params = {
					getUser().getCompanyId(), sdate,  edate, getUser().getCompanyId(), sdate,  edate
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.DATE, Types.DATE, Types.NUMERIC, Types.DATE, Types.DATE
			};
			this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_EDU_RES_LIST", params, jdbcTypes, map);

			
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
					"성명","직급", "부서명","과정명", "교육기간","학습유형", "인정시간", "부처지정학습", "수강상태" 
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "부서원교육현황");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					 map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						switch(k) {
							//case 0: if(map.get("RNUM")!=null) tmp = map.get("RNUM"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 0: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 1: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 2: if(map.get("DVS_FULLNAME")!=null) tmp = map.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 3: if(map.get("SUBJECT_NAME")!=null) tmp = map.get("SUBJECT_NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 4: if(map.get("EDU_PERIOD")!=null) tmp = map.get("EDU_PERIOD"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 5: if(map.get("TRAINING_NM")!=null) tmp = map.get("TRAINING_NM"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 6: if(map.get("RECOG_TIME")!=null) tmp = map.get("RECOG_TIME"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 7: if(map.get("DEPT_DESIGNATION_YN")!=null) tmp = map.get("DEPT_DESIGNATION_YN"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 8: if(map.get("ATTEND_STATE_NM")!=null) tmp = map.get("ATTEND_STATE_NM"); else tmp = "";  cell.setCellStyle(styleL); break;
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
				//if(k==0)sheet.setColumnWidth((short)k, (short)3000);
				if(k==0)sheet.setColumnWidth((short)k, (short)4000);
				if(k==1)sheet.setColumnWidth((short)k, (short)6000);
				if(k==2)sheet.setColumnWidth((short)k, (short)8000);
				if(k==3)sheet.setColumnWidth((short)k, (short)12000);
				if(k==4)sheet.setColumnWidth((short)k, (short)6000);
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
				if(k==6)sheet.setColumnWidth((short)k, (short)5000);
				if(k==7)sheet.setColumnWidth((short)k, (short)4000);
				if(k==8)sheet.setColumnWidth((short)k, (short)5000);
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
			this.targetAttachmentFileName = "부서원교육현황.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			log.debug(e);
		}
		
		return success();
	}
	
	/**
	 * 
	 * 교육훈련결과 > 부서원상시학습달성현황 - 엑셀다운로드<br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 27.
	 */
	@SuppressWarnings("deprecation")
	public String eduAlwResultListExcel() throws Exception{
		try {
			
			String yyyy = ParamUtils.getParameter(request, "YYYY");
			
			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", baSubjectSrv.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
			
			Object [] params = {
					yyyy,yyyy,yyyy,yyyy,yyyy,yyyy
			}; 
			int[] jdbcTypes = {
					Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR
			};
			this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_ALW_EDU_RES_LIST_EXCEL", params, jdbcTypes, map);

			
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
					"성명","직급","부서명","총시간(기준)","총시간(실적)", "부처지정학습(기준)", "부처지정학습(실적)", "결과" 
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "부서원상시학습달성현황");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					 map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						switch(k) {
							case 0: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 1: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 2: if(map.get("DVS_FULLNAME")!=null) tmp = map.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 3: if(map.get("DD0_REQ_TIME")!=null) tmp = map.get("DD0_REQ_TIME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 4: if(map.get("DD0_TAKE_TIME")!=null) tmp = map.get("DD0_TAKE_TIME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 5: if(map.get("DD1_REQ_TIME")!=null) tmp = map.get("DD1_REQ_TIME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 6: if(map.get("DD1_TAKE_TIME")!=null) tmp = map.get("DD1_TAKE_TIME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 7: if(map.get("REVAL")!=null) tmp = map.get("REVAL"); else tmp = "";  cell.setCellStyle(styleC); break;
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
				if(k==1)sheet.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet.setColumnWidth((short)k, (short)8000);
				if(k==3)sheet.setColumnWidth((short)k, (short)6000);
				if(k==4)sheet.setColumnWidth((short)k, (short)6000);
				if(k==5)sheet.setColumnWidth((short)k, (short)6000);
				if(k==6)sheet.setColumnWidth((short)k, (short)6000);
				if(k==7)sheet.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "부서원상시학습달성현황.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			log.debug(e);
		}
		
		return success();
	}
	
	/**
	 * 
	 * 교육훈련결과 > 부서원상시학습달성현황 - 화면이동<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 26.
	 */
	public String getAlwEduResultPage() throws Exception{
		
		return success();
	}
	
	/**
	 * 
	 * 교육훈련결과 > 부서원상시학습달성현황 - 목록 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String getAlwEduResultList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		
		Map<String, Object>  map = new HashMap<String, Object>();
		map.put("DIVISION_STR", baSubjectSrv.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		Object [] params = {
				yyyy,yyyy,yyyy,yyyy,yyyy,yyyy
		}; 
		int[] jdbcTypes = {
				Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR
		};
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_ALW_EDU_RES_LIST", startIndex, pageSize, sortField, sortDir, "NAME", filter, params, jdbcTypes, map);

		if(this.items !=null && this.items.size()>0){
			// 과정수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		return success();
	}

	/**
	 * 
	 * 교육훈련결과 > 부서원상시학습달성현황 - 상세 과정 목록<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String getAlwEduResultDetailList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		String userid = ParamUtils.getParameter(request, "userid");
		
		Object [] params = {
				getUser().getCompanyId(), userid, yyyy, getUser().getCompanyId(), userid, yyyy
		}; 
		int[] jdbcTypes = {
				Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR
		};
		this.items = cdpService.queryForList("BA_SUBJECT.SELECT_ALW_EDU_RES_LIST_DETAIL", params, jdbcTypes);

		if(this.items !=null && this.items.size()>0){
			// 과정수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		return success();
	}

	/**
	 * 
	 * 교육훈련결과 > 부서원상시학습달성현황 - 상세 과정 목록 엑셀 다운로드<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String getAlwEduResultDetailListExcel() throws Exception{
		
		log.debug(CommonUtils.printParameter(request));
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		String userid = ParamUtils.getParameter(request, "userid");
		
		try{
			Object [] params = {
					getUser().getCompanyId(), userid, yyyy, getUser().getCompanyId(), userid, yyyy
			}; 
			int[] jdbcTypes = {
					Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR
			};
			this.items = cdpService.queryForList("BA_SUBJECT.SELECT_ALW_EDU_RES_LIST_DETAIL", params, jdbcTypes);
			
			Map<String, Object>  map = new HashMap<String, Object>();
			
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
					"과정명","학습유형","교육기간","인정시간","부처지정학습"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "부서원상시학습달성현황 상세과정");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					 map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						switch(k) {
							case 0: if(map.get("SUBJECT_NAME")!=null) tmp = map.get("SUBJECT_NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 1: if(map.get("TRAINING_NM")!=null) tmp = map.get("TRAINING_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 2: if(map.get("EDU_PERIOD")!=null) tmp = map.get("EDU_PERIOD"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 3: if(map.get("RECOG_TIME")!=null) tmp = map.get("RECOG_TIME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 4: if(map.get("DEPT_DESIGNATION_YN")!=null) tmp = map.get("DEPT_DESIGNATION_YN"); else tmp = "";  cell.setCellStyle(styleC); break;
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
				if(k==0)sheet.setColumnWidth((short)k, (short)8000);
				if(k==1)sheet.setColumnWidth((short)k, (short)4000);
				if(k==2)sheet.setColumnWidth((short)k, (short)6000);
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)6000);
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
			this.targetAttachmentFileName = "부서원상시학습달성현황 상세과정.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);

		} catch(Exception e) {
			log.debug(e);
		}

		return success();
	}
	
	/**
	 * 
	 * 승인하기 > 교육추천승인 - 승인처리<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 10. 8.
	 */
	public String saveClsRecommReq() throws BaException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		saveCount += baSubjectSrv.saveClsRecommReq(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 승인하기 > 교육승인 - 승인처리<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 10. 8.
	 */
	public String saveClsApplyReq() throws BaException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		saveCount += baSubjectSrv.saveClsApplyReq(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 승인하기 > 교육승인 - 수정팝업 - 수정&승인처리<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2015. 05. 06.
	 */
	public String saveClsApplyReqPopup() throws BaException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		saveCount += baSubjectSrv.saveClsApplyReqPopup(request, getUser());
		return success();
	}

	/**
	 * 
	 * 승인하기 > 교육추천승인 - 목록 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String getEduRecommApprList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		
		Map<String, Object>  map = new HashMap<String, Object>();

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		
		//목록
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.GET_EDU_RECOMM_APPR_LIST", startIndex, pageSize, sortField, sortDir, "STS_SORT, REQ_DTIME DESC", filter, 
				new Object[]{ userid, yyyy, companyid  }, 
				new int[]{  Types.NUMERIC, Types.VARCHAR, Types.NUMERIC  }, map);
		
		log.debug("## this.items.size():"+this.items.size());
		
		if(this.items !=null && this.items.size()>0){
			// 총 건수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	}
	
	/**
	 * 
	 * 승인하기 > 교육승인 - 목록 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String getEduApprList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		
		Map<String, Object>  map = new HashMap<String, Object>();

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		
		//목록
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.GET_EDU_APPR_LIST", startIndex, pageSize, sortField, sortDir, "STS_SORT, REQ_DTIME DESC", filter, 
				new Object[]{ userid, yyyy, companyid, userid, yyyy, companyid  }, 
				new int[]{  Types.NUMERIC, Types.VARCHAR, Types.NUMERIC,  Types.NUMERIC, Types.VARCHAR, Types.NUMERIC   }, map);
		
		if(this.items !=null && this.items.size()>0){
			// 총 건수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	}

	/**
	 * 
	 * 승인하기 > 교육승인 - 엑셀다운로드<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 12. 01.
	 */
	@SuppressWarnings("deprecation")
	public String getEduApprListExcel() throws Exception{
		if( log.isDebugEnabled() ) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		
		Map<String, Object>  paramMap = new HashMap<String, Object>();
		paramMap.put("GRID_WHERE_CLAUSE", "");
		paramMap.put("GRID_ORDERBY_CLAUSE", "ORDER BY STS_SORT, REQ_DTIME DESC");
		
		//목록
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.GET_EDU_APPR_LIST", 
				new Object[]{ userid, yyyy, companyid, userid, yyyy, companyid  }, 
				new int[]{  Types.NUMERIC, Types.VARCHAR, Types.NUMERIC,  Types.NUMERIC, Types.VARCHAR, Types.NUMERIC   }, paramMap);
		
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

			HSSFCellStyle styleC = workbook.createCellStyle();
			styleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleC.setFillForegroundColor(HSSFColor.TAN.index);
	
			HSSFCellStyle styleL = workbook.createCellStyle();
			styleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			styleL.setFillForegroundColor(HSSFColor.TAN.index);
	
			// START : =================================================================
			String[] cell_value = {
					"승인요청구분","요청자부서명", "요청자", "과정명", "교육기간", "학습유형", "승인상태" 
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "교육승인 목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						switch(k) {
							case 0: if(map.get("EDU_DIV_NM")!=null) tmp = map.get("EDU_DIV_NM"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 1: if(map.get("DVS_FULLNAME")!=null) tmp = map.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 2: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 3: if(map.get("SUBJECT_NAME")!=null) tmp = map.get("SUBJECT_NAME"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 4: if(map.get("EDU_PERIOD")!=null) tmp = map.get("EDU_PERIOD"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 5: if(map.get("TRAINING_NM")!=null) tmp = map.get("TRAINING_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 6: if(map.get("REQ_STS_NM")!=null) tmp = map.get("REQ_STS_NM"); else tmp = "";  cell.setCellStyle(styleC); break;
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
				if(k==1)sheet.setColumnWidth((short)k, (short)8000);
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
				if(k==3)sheet.setColumnWidth((short)k, (short)10000);
				if(k==4)sheet.setColumnWidth((short)k, (short)6000);
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
				if(k==6)sheet.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "교육승인목록"+yyyy+"년.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			log.debug(e);
		}
		
		
		return success();
	}

	/**
	 * 
	 * 승인하기 > 교육추천승인 - 교육 상세정보 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String getEduRecommDetailInfo() throws Exception {

		//과정정보..
		items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SBJCT_OPEN_INFO", new Object[] {subjectNum, openNum, getUser().getCompanyId()}, new int[] {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
			
		//교육신청자 조회.
		items2 = baSubjectSrv.queryForList("BA_SUBJECT.GET_EDU_APPLY_USER_LIST", new Object[] { getUser().getCompanyId(), subjectNum, openNum }, new int[] { Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		
		return success();
	}
	
	/**
	 * 
	 * 승인하기 > 교육승인 - 교육 상세정보 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 24.
	 */
	public String getEduDetailInfo() throws Exception {

		String eduDiv = ParamUtils.getParameter(request, "EDU_DIV", "S");
		if(eduDiv.equals("S")){
			//과정정보..
			items = baSubjectSrv.queryForList("BA_SUBJECT.SELECT_SBJCT_OPEN_INFO", new Object[] {subjectNum, openNum, getUser().getCompanyId()}, new int[] {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		}else{
			//상시학습정보
			items = baSubjectSrv.queryForList("BA_SUBJECT.GET_EDU_ALW_INFO", new Object[] { getUser().getCompanyId(), openNum }, new int[] {Types.NUMERIC, Types.NUMERIC });
			
			//교육대상자 조회.
			items2 = baSubjectSrv.queryForList("BA_SUBJECT.GET_EDU_ALW_USER_LIST", new Object[] { getUser().getCompanyId(), openNum }, new int[] {Types.NUMERIC, Types.NUMERIC });
		}
		
		return success();
	}
	
	
	/**
	 * 교육훈련결과 > 부서원교육현황 - 이사람연동 교육현황 목록 조회<br/>
	 * @return
	 * @throws Exception
	 * @since 2014. 12. 10.
	 */
	public String syncEdursltList() throws Exception{
		if(log.isDebugEnabled()) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId(); 
		//String syncFdate = ParamUtils.getParameter(request, "syncFdate");
		//String syncTdate = ParamUtils.getParameter(request, "syncTdate");

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date syncFdate = sdf.parse(ParamUtils.getParameter(request, "syncFdate"));
		Date syncTdate = sdf.parse(ParamUtils.getParameter(request, "syncTdate"));
		
		Map<String,Object> map = new HashMap<String, Object>();
		// 서버 Filter
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);

		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_SYNC_EDU_LIST", startIndex, pageSize, sortField, sortDir, "COL02 DESC", filter, new Object[] {
				companyid, syncFdate, syncTdate,
				companyid, syncFdate, syncTdate
		}, new int[] {
				Types.NUMERIC, Types.DATE, Types.DATE,
				Types.NUMERIC, Types.DATE, Types.DATE
		}, map);

		if(this.items !=null && this.items.size()>0){
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	}
	
	/**
	 * 
	 * 교육훈련결과 > 부서원교육현황 - 이사람연동 교육현황 엑셀 다운로드<br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 27.
	 */
	@SuppressWarnings("deprecation")
	public String syncEdursltListExcel() throws Exception{
		if(log.isDebugEnabled()) {
			log.debug(this.getClass().getName());
			log.debug(CommonUtils.printParameter(request));
		}
		
		long companyid = getUser().getCompanyId(); 
		//String syncFdate = ParamUtils.getParameter(request, "syncFdate");
		//String syncTdate = ParamUtils.getParameter(request, "syncTdate");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date syncFdate = sdf.parse(ParamUtils.getParameter(request, "syncFdate"));
		Date syncTdate = sdf.parse(ParamUtils.getParameter(request, "syncTdate"));
		
		boolean isSuccessEnd = false;
		
		List<Map<String,Object>> list = Collections.emptyList();
		
		try {
			Map<String,Object> map = new HashMap<String, Object>();
			// 서버 Filter
			filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);

			list = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_SYNC_EDU_LIST", startIndex, pageSize, sortField, sortDir, "COL02 DESC", filter, new Object[] {
					companyid, syncFdate, syncTdate,
					companyid, syncFdate, syncTdate
			}, new int[] {
					Types.NUMERIC, Types.DATE, Types.DATE,
					Types.NUMERIC, Types.DATE, Types.DATE
			}, map);

			
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
			String[] cell_value1 = {
				"", "현재소속", "현재직급코드", "성명", "인정직급코드", 
				"부처지정학습", "부처지정학습종류", "학습종류", "시작일자", "종료일자", 
				"제목", "실적시간", "", "인정시간", "", 
				"학습방법", "교육시간구분", "교육기관구분", "교육기관코드", "교육기관명", 
				"내용",	"평정점", "입력자", "입력일시", "수정자",
				"수정일시", "교직원번호", "연동구분"
			}; // 33
			String[] cell_value2 = {
				"", "", "", "", "", 
				"", "", "", "", "", //10
				"", "시간", "분", "시간", "분", 
				"", "", "", "", "", //20
				"", "",	"", "", "", 
				"", "", ""
			}; // 28
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "학습이력현황");
			
			int rowidx = 0;
			// 1행 생성
			row = sheet.createRow(rowidx++);
			
			sheet.addMergedRegion (new Region(( int) 0 , ( short )1 , ( int) 1, (short )1 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )2 , ( int) 1, (short )2 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )3 , ( int) 1, (short )3 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )4 , ( int) 1, (short )4 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )5 , ( int) 1, (short )5 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )6 , ( int) 1, (short )6 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )7 , ( int) 1, (short )7 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )8 , ( int) 1, (short )8 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )9 , ( int) 1, (short )9 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )10 , ( int) 1, (short )10 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )11 , ( int) 0, (short )12 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )13 , ( int) 0, (short )14 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )15 , ( int) 1, (short )15 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )16 , ( int) 1, (short )16 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )17 , ( int) 1, (short )17 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )18 , ( int) 1, (short )18 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )19 , ( int) 1, (short )19 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )20 , ( int) 1, (short )20 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )21 , ( int) 1, (short )21 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )22 , ( int) 1, (short )22 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )23 , ( int) 1, (short )23 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )24 , ( int) 1, (short )24 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )25 , ( int) 1, (short )25 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )26 , ( int) 1, (short )26 )); 
			sheet.addMergedRegion (new Region(( int) 0 , ( short )27 , ( int) 1, (short )27 )); 
			
			for(int k=0; k<cell_value1.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value1[k]);
				cell.setCellStyle(style);
			}
			// 2행 생성
			row = sheet.createRow(rowidx++);
			for(int k=0; k<cell_value2.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value2[k]);
				cell.setCellStyle(style);
			}
			
			
			if(list!=null && list.size()>0) {
				for( Iterator<Map<String, Object>> iter = list.iterator(); iter.hasNext();) {
					 map = (Map<String, Object>)iter.next();
					row = sheet.createRow(rowidx++);
	
					for(int k=0; k<cell_value1.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();

						switch(k) {
							case 0: tmp = ""; cell.setCellStyle(styleC); break;
							case 1: if(map.get("COL02")!=null) tmp = map.get("COL02"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 2: if(map.get("COL03")!=null) tmp = map.get("COL03"); else tmp = ""; cell.setCellStyle(styleC); break;
							//case 3: if(map.get("COL04")!=null) tmp = map.get("COL04"); else tmp = ""; cell.setCellStyle(styleC); break;
							//case 4: if(map.get("COL05")!=null) tmp = map.get("COL05"); else tmp = ""; cell.setCellStyle(styleL); break;
							//case 5: if(map.get("COL06")!=null) tmp = map.get("COL06"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 3: if(map.get("COL07")!=null) tmp = map.get("COL07"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 4: if(map.get("COL08")!=null) tmp = map.get("COL08"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 5: if(map.get("COL09")!=null) tmp = map.get("COL09"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 6: if(map.get("COL10")!=null) tmp = map.get("COL10"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 7: if(map.get("COL11")!=null) tmp = map.get("COL11"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 8: if(map.get("COL12")!=null) tmp = map.get("COL12"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 9: if(map.get("COL13")!=null) tmp = map.get("COL13"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 10: if(map.get("COL14")!=null) tmp = map.get("COL14"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 11: if(map.get("COL15")!=null) tmp = map.get("COL15"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 12: if(map.get("COL16")!=null) tmp = map.get("COL16"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 13: if(map.get("COL17")!=null) tmp = map.get("COL17"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 14: if(map.get("COL18")!=null) tmp = map.get("COL18"); else tmp = ""; cell.setCellStyle(styleC); break;
							//case 18: if(map.get("COL19")!=null) tmp = map.get("COL19"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 15: if(map.get("COL20")!=null) tmp = map.get("COL20"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 16: if(map.get("COL21")!=null) tmp = map.get("COL21"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 17: if(map.get("COL22")!=null) tmp = map.get("COL22"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 18: if(map.get("COL23")!=null) tmp = map.get("COL23"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 19: if(map.get("COL24")!=null) tmp = map.get("COL24"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 20: if(map.get("COL25")!=null) tmp = map.get("COL25"); else tmp = ""; cell.setCellStyle(styleL); break;
							//case 25: if(map.get("COL26")!=null) tmp = map.get("COL26"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 21: if(map.get("COL27")!=null) tmp = map.get("COL27"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 22: if(map.get("COL28")!=null) tmp = map.get("COL28"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 23: if(map.get("COL29")!=null) tmp = map.get("COL29"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 24: if(map.get("COL30")!=null) tmp = map.get("COL30"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 25: if(map.get("COL31")!=null) tmp = map.get("COL31"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 26: if(map.get("COL32")!=null) tmp = map.get("COL32"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 27: if(map.get("COL33")!=null) tmp = map.get("COL33"); else tmp = ""; cell.setCellStyle(styleC); break;
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
			
			for (int k=0; k<cell_value1.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)1000);
				if(k==1)sheet.setColumnWidth((short)k, (short)8000);
				if(k==2)sheet.setColumnWidth((short)k, (short)3000);
				//if(k==3)sheet.setColumnWidth((short)k, (short)3000);
				//if(k==4)sheet.setColumnWidth((short)k, (short)3000);
				//if(k==5)sheet.setColumnWidth((short)k, (short)3000);
				if(k==3)sheet.setColumnWidth((short)k, (short)3000);
				if(k==4)sheet.setColumnWidth((short)k, (short)3000);
				if(k==5)sheet.setColumnWidth((short)k, (short)3000);
				if(k==6)sheet.setColumnWidth((short)k, (short)3000);
				if(k==7)sheet.setColumnWidth((short)k, (short)3000);
				if(k==8)sheet.setColumnWidth((short)k, (short)3000);
				if(k==9)sheet.setColumnWidth((short)k, (short)3000);
				if(k==10)sheet.setColumnWidth((short)k, (short)8000); //제목
				if(k==11)sheet.setColumnWidth((short)k, (short)3000);
				if(k==12)sheet.setColumnWidth((short)k, (short)3000);
				if(k==13)sheet.setColumnWidth((short)k, (short)3000);
				if(k==14)sheet.setColumnWidth((short)k, (short)3000);
				if(k==15)sheet.setColumnWidth((short)k, (short)3000); //학습방법
				if(k==16)sheet.setColumnWidth((short)k, (short)3000);
				if(k==17)sheet.setColumnWidth((short)k, (short)3000);
				if(k==18)sheet.setColumnWidth((short)k, (short)3000);
				if(k==19)sheet.setColumnWidth((short)k, (short)3000);
				if(k==20)sheet.setColumnWidth((short)k, (short)8000); //내용
				if(k==21)sheet.setColumnWidth((short)k, (short)3000);
				if(k==22)sheet.setColumnWidth((short)k, (short)3000);
				if(k==23)sheet.setColumnWidth((short)k, (short)3000);
				if(k==24)sheet.setColumnWidth((short)k, (short)3000);
				if(k==25)sheet.setColumnWidth((short)k, (short)3000); //수정일시
				if(k==26)sheet.setColumnWidth((short)k, (short)3000);
				if(k==27)sheet.setColumnWidth((short)k, (short)3000);
				//if(k==31)sheet.setColumnWidth((short)k, (short)3000);
				//if(k==32)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = "이사람연동 엑셀 다운로드.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
			isSuccessEnd = true;
			log.debug("## isSuccessEnd :: " + isSuccessEnd);
		} catch(Exception e) {
			log.error(e);
		} finally {
			log.debug("## isSuccessEnd updateSyncEduState :: " + isSuccessEnd);
			/* 다운 받은 교육이력 정보 상태변경 */
			if(isSuccessEnd && list!=null && list.size()>0) {
				baSubjectSrv.updateSyncEduState(companyid, list);
			}
		}
		
		return success();
	}

	
	
	/**
	 * 교육훈련 > 승진교육달성현황
	 * 메인페이지
	 * @return
	 * @throws Exception
	 */
	public String selectDeptPrmtnEduMain() throws Exception {
		
		Calendar cal = Calendar.getInstance();
		int yyyy = cal.get(Calendar.YEAR);
		int mm = cal.get(Calendar.MONTH)+1;
		int dd = cal.get(Calendar.DATE);
		
		String nowdate = (String.valueOf(yyyy) +"-"+ ( mm<10 ? "0"+mm : String.valueOf(mm) ) +"-"+ ( dd<10 ? "0"+dd : String.valueOf(dd) )) ;
		request.setAttribute("nowdate", nowdate);
		
		return success();
	}
	
	/**
	 * 교육훈련 > 승진교육달성현황
	 * 목록조회
	 * @return
	 * @throws Exception
	 */
	public String selectDeptPrmtnEduList() throws Exception {
		if(log.isDebugEnabled()) {
			log.debug(this.getClass().getName() +".selectDeptPrmtnEduList");
			log.debug(CommonUtils.printParameter(request));
		}
		
		String bdate = ParamUtils.getParameter(request, "bdate"); // 기준일
		if(bdate!=null) bdate = bdate.replaceAll("-", "");
		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		Map<String, Object> map =  new HashMap<String, Object>();
		
		map.put("WHERE_DIVISION", baSubjectSrv.getUserDivisionList(request, getUser(), "DIVISIONID" ));
		
		items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_DEPT_PRMTN_EDU_LIST", startIndex, pageSize, sortField, sortDir, "NAME", filter, 
					new Object[] {
						bdate, bdate, bdate, bdate, bdate, bdate,
						getUser().getCompanyId(),
						//getUser().getProfileFieldValueString("DIVISIONID"),
						getUser().getCompanyId(),
						getUser().getCompanyId()
					}, 
					new int[] {
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.NUMERIC,
						//Types.VARCHAR,
						Types.NUMERIC,
						Types.NUMERIC
					},
					map);
		
		if(items!=null && items.size()>0)
			totalItemCount = Integer.parseInt(items.get(0).get("TOTALITEMCOUNT").toString());
		
		return success();
	}
	
	/**
	 * 교육훈련 > 승진교육달성현황
	 * 목록 엑셀다운로드
	 * @return
	 * @throws Exception
	 */
	public String selectDeptPrmtnEduListExcel() throws Exception {
		if(log.isDebugEnabled()) {
			log.debug(this.getClass().getName() + ".selectDeptPrmtnEduListExcel");
			log.debug(CommonUtils.printParameter(request));
		}
		
		String bdate = ParamUtils.getParameter(request, "bdate"); // 기준일
		if(bdate!=null) bdate = bdate.replaceAll("-", "");
		
		Map<String, Object>  paramMap = new HashMap<String, Object>();
		paramMap.put("WHERE_DIVISION", baSubjectSrv.getUserDivisionList(request, getUser(), "DIVISIONID" ));
		paramMap.put("GRID_WHERE_CLAUSE", "");
		paramMap.put("GRID_ORDERBY_CLAUSE", "ORDER BY DVS_FULLNAME, NAME");
		
		//목록
		this.items = cdpService.dynamicQueryForList("BA_SUBJECT.SELECT_DEPT_PRMTN_EDU_LIST",  
					new Object[] {
						bdate, bdate, bdate, bdate, bdate, bdate,
						getUser().getCompanyId(),
						//getUser().getProfileFieldValueString("DIVISIONID"),
						getUser().getCompanyId(),
						getUser().getCompanyId()
					}, 
					new int[] {
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.NUMERIC,
						//Types.VARCHAR,
						Types.NUMERIC,
						Types.NUMERIC
					},
					paramMap);
		
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

			HSSFCellStyle styleC = workbook.createCellStyle();
			styleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleC.setFillForegroundColor(HSSFColor.TAN.index);
	
			HSSFCellStyle styleL = workbook.createCellStyle();
			styleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			styleL.setFillForegroundColor(HSSFColor.TAN.index);
	
			// START : =================================================================
			String[] cell_value = {
				"부서명", "전체부서명", "성명", "직급", "목표시간", "달성시간", "결과" 
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "승진교육달성현황");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
	
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator<Map<String, Object>> iter = this.items.iterator(); iter.hasNext();) {
					Map<String, Object> map = (Map<String, Object>)iter.next();
					row = sheet.createRow(i++);
	
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						switch(k) {
							case 0: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 1: if(map.get("DVS_FULLNAME")!=null) tmp = map.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 2: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 3: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 4: if(map.get("VA_REQ_TIME")!=null) tmp = map.get("VA_REQ_TIME"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 5: if(map.get("VA_TAKE_TIME")!=null) tmp = map.get("VA_TAKE_TIME"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 6: if(map.get("CHK")!=null) tmp = map.get("CHK"); else tmp = "";  cell.setCellStyle(styleC); break;
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
				if(k==1)sheet.setColumnWidth((short)k, (short)10000);
				if(k==2)sheet.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet.setColumnWidth((short)k, (short)6000);
				if(k==4)sheet.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
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
			this.targetAttachmentFileName = "승진교육달성현황("+bdate+").xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);

		} catch(Exception e) {
			log.debug(e);
		}
		
		return success();
	}
	
	
	
}