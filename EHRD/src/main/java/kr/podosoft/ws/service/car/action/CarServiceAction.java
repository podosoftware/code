package kr.podosoft.ws.service.car.action;

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

import kr.podosoft.ws.service.ca.CAException;
import kr.podosoft.ws.service.cam.CAMException;
import kr.podosoft.ws.service.car.CarException;
import kr.podosoft.ws.service.car.CarService;
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


public class CarServiceAction extends FrameworkActionSupport {


	private static final long serialVersionUID = -2316562034839240657L;

	private int pageSize = 15 ;
	
    private int startIndex = 0 ;  
     
    private int totalItemCount = 0;
     
	private int year = 0;
	
	private int saveCount = 0 ;  
	 
	private int runNum = 0;

	private List<Map<String,Object>> items;
	
	private List items1;
	
	private List items2;	
	
	private String statement ;

	private CarService carService;

	private String targetAttachmentContentType = "";
	
	private int targetAttachmentContentLength = 0;
	
	private InputStream targetAttachmentInputStream = null;
	
	private String targetAttachmentFileName = "";

	private String sortField;
    private String sortDir;
    private Filter filter;

	private CdpService cdpService;

    
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

	public CarService getCarService() {
		return carService;
	}

	public void setCarService(CarService carService) {
		this.carService = carService;
	}

	public int getRunNum() {
		return runNum;
	}

	public void setRunNum(int runNum) {
		this.runNum = runNum;
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

	public String getStatement() {
		return statement;
	}

	public void setStatement(String statement) {
		this.statement = statement;
	} 
	
	
	/**
	 * 
	 * 역량진단결과 >진단실시현황 화면이동.<br/>
	 *
	 * @return
	 * @since 2014. 10. 29.
	 */
	public String getAssmExctStsListPg(){
		return success();
	}
	
	/**
	 * 
	 * 역량진단결과 >진단실시현황 - 실시 년도 조회.<br/>
	 *
	 * @return
	 * @since 2014. 10. 30.
	 */
	public String getRunYyyyList() throws CarException{
		log.debug(CommonUtils.printParameter(request));
		
		Object [] params = {
				getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC
		};
		this.items = carService.queryForList("CAR.GET_RUN_YYYY", params, jdbcTypes);
		return success();	
	}
	
	/**
	 * 
	 * 역량진단결과 >진단실시현황 - 진단실시 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 10. 30.
	 */
	public String getRunHistoryList() throws CarException{
		log.debug(CommonUtils.printParameter(request));
		
		Object [] params = {
				getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC
		};
		this.items = carService.queryForList("CAR.GET_RUN_HISTORY_LIST", params, jdbcTypes);
		return success();	
	}
	
	/**
	 * 
	 * 역량진단결과 >진단실시현황 - 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 10. 30.
	 */
	public String getAssmExctStsList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		
		Map<String, Object>  map = new HashMap<String, Object>();
		map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		//목록
		this.items = cdpService.dynamicQueryForList("CAR.GET_RUN_STS_LIST", startIndex, pageSize, sortField, sortDir, "NAME", filter, new Object[]{ getUser().getCompanyId(), runNum }, new int[]{  Types.NUMERIC, Types.NUMERIC  }, map);
		if(this.items !=null && this.items.size()>0){
			// 총 건수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}

		return success();	
	}
	
	/**
	 * 
	 * 역량진단 결과 임시저장상태로 변경.<br/>
	 *
	 * @return
	 * @since 2014. 10. 30.
	 */
	public String changeAssmStatus() throws CarException{
		log.debug(CommonUtils.printParameter(request));
		
		this.saveCount = carService.changeAssmStatus(request, getUser());
		return success();
	}
	

	/**
	 * 
	 * 역량진단 실시 현황 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CarException 
	 * @since 2014. 10. 30.
	 */
	@SuppressWarnings({ "deprecation" })
	public String getAssmExctStsExcelList() throws CarException{
		
		try {
			
			String runNo   = ParamUtils.getParameter(request, "RUN_NUM");
			String runName = ParamUtils.getParameter(request, "RUN_NAME");
			
			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
			map.put("GRID_WHERE_CLAUSE", "");
			map.put("GRID_ORDERBY_CLAUSE","ORDER BY NAME");
			Object [] params = {
					getUser().getCompanyId(), runNo
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC
			};
			this.items = carService.dynamicQueryForList("CAR.GET_RUN_STS_LIST", params, jdbcTypes, map);
			
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
					"번호", "부서",  "진단자", "교직원번호", "직급", "계급", "직무", "상태", "진단현황"
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
					Map itMap = (Map)iter.next();
					row = sheet.createRow(i++);
					
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);
						
						Object tmp = new Object();
						Object tmp1 = new Object();
						switch(k) {
						case 0: if(itMap.get("ROWNUMBER")!=null) tmp = itMap.get("ROWNUMBER"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1: if(itMap.get("DVS_NAME")!=null) tmp = itMap.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2: if(itMap.get("NAME")!=null) tmp = itMap.get("NAME"); else tmp = "";  cell.setCellStyle(style2); break;
						case 3: if(itMap.get("EMPNO")!=null) tmp = itMap.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
						case 4: if(itMap.get("GRADE_NM")!=null) tmp = itMap.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 5: if(itMap.get("LEADERSHIP_NAME")!=null) tmp = itMap.get("LEADERSHIP_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 6: if(itMap.get("JOB_NAME")!=null) tmp = itMap.get("JOB_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 7: if(itMap.get("STATE")!=null) tmp = itMap.get("STATE"); else tmp = ""; cell.setCellStyle(style2); break;
						case 8: 
							if(itMap.get("T_CNT")!=null) tmp = itMap.get("T_CNT"); 
							else tmp = ""; 
							
							if(itMap.get("C_CNT")!=null) tmp1 = itMap.get("C_CNT"); 
							else tmp1 = ""; 
							
							cell.setCellStyle(style2); 
							break;
						}
						
						if(k==8){
							cell.setCellValue( ((BigDecimal)tmp).toString()+"명 중" +((BigDecimal)tmp1).toString()+"명 완료" );
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
				if(k==2)sheet.setColumnWidth((short)k, (short)3000);
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)7000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)5000);
				if(k==7)sheet.setColumnWidth((short)k, (short)4000);
				if(k==8)sheet.setColumnWidth((short)k, (short)8000);
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
			this.targetAttachmentFileName = URLEncoder.encode("진단실시현황.xls","UTF-8");
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CarException(e);
		}
		
		return success();
	} 
	
	/**
	 * 
	 * 역량진단 독려메일 발송.<br/>
	 *
	 * @return
	 * @throws CarException
	 * @since 2014. 10. 30.
	 */
	public String encourageMailSend() throws CarException{
		log.debug(">>>>> " + getClass().getName() + ".encourageMailSend");
		log.debug(CommonUtils.printParameter(request));
		
	    String runNUm = ParamUtils.getParameter(request, "rnum");
	    String runName = ParamUtils.getParameter(request, "rname");
	    String userArrStr = ParamUtils.getParameter(request, "item");
	    String type = ParamUtils.getParameter(request, "type");
		 
	    if(userArrStr!=null && !userArrStr.equals(""))
	    	this.saveCount = carService.encourageMailSend(getUser(), runNUm, runName, userArrStr.split(","), type);
	    else 
	    	this.saveCount = 0;
		
		return success();
	} 
	
	/**
	 * 진단실시현황
	 * 독려SMS발송
	 * @return
	 * @throws CAException
	 */
	public String encourageSmsSend() throws CarException{
		log.debug(">>>>> " + getClass().getName() + ".encourageSmsSend");
		log.debug(CommonUtils.printParameter(request));
		
	    //String runNUm = ParamUtils.getParameter(request, "rnum");
	    String runName = ParamUtils.getParameter(request, "rname");
	    String userArrStr = ParamUtils.getParameter(request, "item");
	    String type = ParamUtils.getParameter(request, "type");
	    
	    if(userArrStr!=null && !userArrStr.equals(""))
	    	this.saveCount = carService.encourageSmsSend(getUser(), runName, userArrStr.split(","), type);
	    else 
	    	this.saveCount = 0;
	    	
		return success();
	}
	
	
	/**
	 * 
	 * 역량진단결과 >소속별응답현황 화면이동.<br/>
	 *
	 * @return
	 * @since 2014. 10. 29.
	 */
	public String getDivisionExecStsListPg(){
		return success();
	}

	/**
	 * 
	 * 역량진단결과 >소속별응답현황 - 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 10. 30.
	 */
	public String getDivisionExecStsList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		String divisionStr = "";
		if(request.isUserInRole("ROLE_SYSTEM")){ //총괄관리자
			//조건 없이 모두 조회..
			divisionStr = " HIGH_DVSID IS NULL "; // 고객사 ROOT
			
			log.debug("### ROLE_SYSTEM");
		}else if(request.isUserInRole("ROLE_OPERATOR")){ //교육담당자
			//담당하는 부서(하위 포함)에 해당하는 사용자
			divisionStr = " DIVISIONID IN (SELECT DIVISIONID FROM TB_BA_DIVISION_EDU_MGR WHERE COMPANYID = "+companyid+" AND USERID = "+userid+" AND USEFLAG = 'Y') ";
			
			log.debug("### ROLE_OPERATOR");
		}else{ //부서장
			//소속부서(하위 포함)의 사용자
			//divisionStr = " DIVISIONID = '"+getUser().getProfile().get("DIVISIONID")+"' "; 
			divisionStr = " DIVISIONID IN ( SELECT DIVISIONID FROM TB_BA_DIVISION WHERE COMPANYID = "+companyid+" AND DVS_MANAGER = "+userid+" ) ";
			log.debug("### ROLE_MANAGER");
		}
		
		Map<String, Object>  map = new HashMap<String, Object>();
		map.put("DIVISION_STR", divisionStr);

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		//목록
		this.items = cdpService.dynamicQueryForList("CAR.GET_CAR_DIVISION_CMPLT_LIST", startIndex, pageSize, sortField, sortDir, "DVS_NAME", filter, new Object[]{ companyid, companyid, runNum }, new int[]{  Types.NUMERIC, Types.NUMERIC, Types.NUMERIC  }, map);
		if(this.items !=null && this.items.size()>0){
			// 총 건수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();	
	}
	

	/**
	 * 
	 * 소속별응답현황 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CarException 
	 * @since 2014. 10. 30.
	 */
	@SuppressWarnings({ "deprecation" })
	public String getDivisionExecStsExcelList() throws CarException{
		
		try {

			String runName = ParamUtils.getParameter(request, "RUN_NAME");
			
			long companyid = getUser().getCompanyId();
			long userid = getUser().getUserId();
			
			String divisionStr = "";
			if(request.isUserInRole("ROLE_SYSTEM")){ //총괄관리자
				//조건 없이 모두 조회..
				divisionStr = " HIGH_DVSID IS NULL "; // ROOT 경북대 (추후 변경해야함)
				
				log.debug("### ROLE_SYSTEM");
			}else if(request.isUserInRole("ROLE_OPERATOR")){ //교육담당자
				//담당하는 부서(하위 포함)에 해당하는 사용자
				divisionStr = " DIVISIONID IN (SELECT DIVISIONID FROM TB_BA_DIVISION_EDU_MGR WHERE COMPANYID = "+companyid+" AND USERID = "+userid+" AND USEFLAG = 'Y') ";
				
				log.debug("### ROLE_OPERATOR");
			}else{ //부서장
				//소속부서(하위 포함)의 사용자
				//divisionStr = " DIVISIONID = '"+getUser().getProfile().get("DIVISIONID")+"' "; 
				divisionStr = " DIVISIONID IN ( SELECT DIVISIONID FROM TB_BA_DIVISION WHERE COMPANYID = "+companyid+" AND DVS_MANAGER = "+userid+" ) ";
				log.debug("### ROLE_MANAGER");
			}
			
			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", divisionStr);
			map.put("GRID_WHERE_CLAUSE", "");
			map.put("GRID_ORDERBY_CLAUSE","ORDER BY DVS_NAME");
			
			Object [] params = {
					companyid, companyid, runNum
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			};
			this.items = carService.dynamicQueryForList("CAR.GET_CAR_DIVISION_CMPLT_LIST", params, jdbcTypes, map);
			
			
			
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
					"부서", "전체부서명", "부서장", "총인원", "완료인원", "미완료인원", "완료율(%)"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "소속별응답현황");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
			}
			
			int i = 1;
			if(this.items!=null && this.items.size()>0) {
				for( Iterator iter = this.items.iterator(); iter.hasNext();) {
					Map itMap = (Map)iter.next();
					row = sheet.createRow(i++);
					
					for(int k=0; k<cell_value.length; k++) {
						HSSFCell cell = row.createCell((short)k);

						log.debug("########## itMap.get(TCNT):"+itMap.get("TCNT"));
						
						Object tmp = new Object();
						switch(k) {
						case 0: if(itMap.get("DVS_NAME")!=null) tmp = itMap.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1: if(itMap.get("DVS_FULLNAME")!=null) tmp = itMap.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2: if(itMap.get("MANAGER_NAME")!=null) tmp = itMap.get("MANAGER_NAME"); else tmp = "";  cell.setCellStyle(style2); break;
						case 3: if(itMap.get("TCNT_NUMB")!=null) tmp = itMap.get("TCNT_NUMB"); else tmp = ""; cell.setCellStyle(style2); break;
						case 4: if(itMap.get("YCNT_NUMB")!=null) tmp = itMap.get("YCNT_NUMB"); else tmp = ""; cell.setCellStyle(style2); break;
						case 5: if(itMap.get("NCNT_NUMB")!=null) tmp = itMap.get("NCNT_NUMB"); else tmp = ""; cell.setCellStyle(style2); break;
						case 6: if(itMap.get("YRATE_NUMB")!=null) tmp = itMap.get("YRATE_NUMB"); else tmp = ""; cell.setCellStyle(style2); break;
						}
					
						log.debug("########## tmp:"+tmp);
						
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
				if(k==0)sheet.setColumnWidth((short)k, (short)4000);
				if(k==1)sheet.setColumnWidth((short)k, (short)8000);
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
				if(k==3)sheet.setColumnWidth((short)k, (short)3000);
				if(k==4)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = URLEncoder.encode("소속별응답현황.xls","UTF-8");
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CarException(e);
		}
		
		return success();
	} 
	

	/**
	 * 
	 * 역량진단결과 >직무별응답현황 화면이동.<br/>
	 *
	 * @return
	 * @since 2014. 10. 29.
	 */
	public String getJobExecStsListPg(){
		return success();
	}

	/**
	 * 
	 * 역량진단결과 >직무별응답현황 - 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 10. 30.
	 */
	public String getJobExecStsList() throws CarException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		Map<String, Object>  map = new HashMap<String, Object>();
		map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
		
		Object [] params = {
				companyid, companyid, runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = carService.dynamicQueryForList("CAR.GET_CAR_JOB_CMPLT_LIST", params, jdbcTypes, map);
		this.totalItemCount = items.size();
		return success();	
	}
	

	/**
	 * 
	 * 직무별응답현황 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CarException 
	 * @since 2014. 10. 30.
	 */
	@SuppressWarnings({ "deprecation" })
	public String getJobExecStsExcelList() throws CarException{
		
		try {

			String runName = ParamUtils.getParameter(request, "RUN_NAME");
			
			long companyid = getUser().getCompanyId();
			long userid = getUser().getUserId();
			
			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
			
			Object [] params = {
					companyid, companyid, runNum
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			};
			this.items = carService.dynamicQueryForList("CAR.GET_CAR_JOB_CMPLT_LIST", params, jdbcTypes, map);
			
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
					"직무명", "총인원", "완료인원", "미완료인원", "완료율(%)"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "직무별응답현황");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
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
						case 0: if(itMap.get("JOBLDR_NAME")!=null) tmp = itMap.get("JOBLDR_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1: if(itMap.get("TCNT")!=null) tmp = itMap.get("TCNT"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2: if(itMap.get("YCNT")!=null) tmp = itMap.get("YCNT"); else tmp = ""; cell.setCellStyle(style2); break;
						case 3: if(itMap.get("NCNT")!=null) tmp = itMap.get("NCNT"); else tmp = ""; cell.setCellStyle(style2); break;
						case 4: if(itMap.get("YRATE")!=null) tmp = itMap.get("YRATE"); else tmp = ""; cell.setCellStyle(style2); break;
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
				if(k==0)sheet.setColumnWidth((short)k, (short)4000);
				if(k==1)sheet.setColumnWidth((short)k, (short)3000);
				if(k==2)sheet.setColumnWidth((short)k, (short)3000);
				if(k==3)sheet.setColumnWidth((short)k, (short)3000);
				if(k==4)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = URLEncoder.encode("직무별응답현황.xls","UTF-8");
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CarException(e);
		}
		
		return success();
	} 


	/**
	 * 
	 * 역량진단결과 >역량별 직무/계급 점수 화면이동.<br/>
	 *
	 * @return
	 * @since 2014. 10. 29.
	 */
	public String getCmptJobLeadershipScoListPg(){
		return success();
	}

	/**
	 * 
	 * 직무 / 계급 목록 조회<br/>
	 *
	 * @return
	 * @since 2014. 4. 11.
	 */
	public String getJobLeadershipList() throws CarException{
		log.debug(CommonUtils.printParameter(request));
		
		String jobldrFlag   = ParamUtils.getParameter(request, "JOBLDR_FLAG", "J");
		Object [] params = {
				getUser().getCompanyId(), jobldrFlag
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.VARCHAR
		};
		this.items = carService.queryForList("CAR.GET_JOB_LEADERSHIP_PROFILE_LIST", params, jdbcTypes);
		return success();	
	}
	
	/**
	 * 
	 * 역량진단결과 >역량별 직무/계급 점수 - 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 10. 30.
	 */
	public String getCmptJobLeadershipScoList() throws CarException{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		
		String jobNum   = ParamUtils.getParameter(request, "JOB_NUM", "");
		String leadershipNum = ParamUtils.getParameter(request, "LEADERSHIP_NUM", "");
		String runNum = ParamUtils.getParameter(request, "runNum", "0");
		
		Map<String, Object>  map = new HashMap<String, Object>();
		map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
		
		if(jobNum.equals("") && leadershipNum.equals("")){
			//둘다 전체인경우..
		    map.put("WHERE_STR", " AND ( LEADERSHIP IS NULL OR JOB IS NULL ) ");
		}else if(jobNum.equals("") && !leadershipNum.equals("")){
			//계급만 선택인경우..
			map.put("WHERE_STR", " AND ( JOB IS NULL AND LEADERSHIP = "+leadershipNum+") ");
		}else if(!jobNum.equals("") && leadershipNum.equals("")){
			//직무만 선택인경우..
			map.put("WHERE_STR", " AND ( JOB = "+jobNum+" AND LEADERSHIP IS NULL ) ");
		}else if(!jobNum.equals("") && !leadershipNum.equals("")){
			//둘다 선택인경우..
			map.put("WHERE_STR", " AND ( JOB = "+jobNum+" AND LEADERSHIP = "+leadershipNum+" ) ");
		}else{
			map.put("WHERE_STR", "");
		}
		
		Object [] params = {
				companyid, runNum, companyid, runNum, companyid, runNum
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = carService.dynamicQueryForList("CAR.GET_CAR_CMPT_JOB_LEADERSHIP_SCO_LIST", params, jdbcTypes, map);
		this.totalItemCount = items.size();
		return success();	
	}


	/**
	 * 
	 * 역량별 직무/계급 점수 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CarException 
	 * @since 2014. 10. 30.
	 */
	@SuppressWarnings({ "deprecation" })
	public String getCmptJobLeadershipScoExcelList() throws CarException{
		
		try {

			long companyid = getUser().getCompanyId();
			
			//String runName = ParamUtils.getParameter(request, "RUN_NAME");
			String jobNum   = ParamUtils.getParameter(request, "JOB_NUM", "");
			String leadershipNum = ParamUtils.getParameter(request, "LEADERSHIP_NUM", "");
			
			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
			
			if(jobNum.equals("") && leadershipNum.equals("")){
				//둘다 전체인경우..
			    map.put("WHERE_STR", " AND ( LEADERSHIP IS NULL OR JOB IS NULL ) ");
			}else if(jobNum.equals("") && !leadershipNum.equals("")){
				//계급만 선택인경우..
				map.put("WHERE_STR", " AND ( JOB IS NULL AND LEADERSHIP = "+leadershipNum+") ");
			}else if(!jobNum.equals("") && leadershipNum.equals("")){
				//직무만 선택인경우..
				map.put("WHERE_STR", " AND ( JOB = "+jobNum+" AND LEADERSHIP IS NULL ) ");
			}else if(!jobNum.equals("") && !leadershipNum.equals("")){
				//둘다 선택인경우..
				map.put("WHERE_STR", " AND ( JOB = "+jobNum+" AND LEADERSHIP = "+leadershipNum+" ) ");
			}else{
				map.put("WHERE_STR", "");
			}
			
			Object [] params = {
					companyid, runNum, companyid, runNum, companyid, runNum
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			};
			this.items = carService.dynamicQueryForList("CAR.GET_CAR_CMPT_JOB_LEADERSHIP_SCO_LIST", params, jdbcTypes, map);
			
			
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
					"직무명", "계급명", "역량명", "역량군", "평점(점)"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "역량별직무계급점수");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
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
						case 0: if(itMap.get("JOB_NM")!=null) tmp = itMap.get("JOB_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1: if(itMap.get("LEADERSHIP_NM")!=null) tmp = itMap.get("LEADERSHIP_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2: if(itMap.get("CMPNAME")!=null) tmp = itMap.get("CMPNAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 3: if(itMap.get("CMPGROUP_NM")!=null) tmp = itMap.get("CMPGROUP_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 4: if(itMap.get("SCORE")!=null) tmp = itMap.get("SCORE"); else tmp = ""; cell.setCellStyle(style2); break;
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
				if(k==0)sheet.setColumnWidth((short)k, (short)3000);
				if(k==1)sheet.setColumnWidth((short)k, (short)3000);
				if(k==2)sheet.setColumnWidth((short)k, (short)3000);
				if(k==3)sheet.setColumnWidth((short)k, (short)3000);
				if(k==4)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = URLEncoder.encode("역량별직무계급점수.xls","UTF-8");
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CarException(e);
		}
		
		return success();
	}

	
	/**
	 * 
	 * 역량진단결과 >역량별점수 화면이동.<br/>
	 *
	 * @return
	 * @since 2014. 10. 29.
	 */
	public String getCmptUserScoListPg(){
		return success();
	}
	
	/**
	 * 
	 * 역량진단결과 >역량별점수 - 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 10. 30.
	 */
	public String getCmptUserScoList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		Map<String, Object>  map = new HashMap<String, Object>();
		map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		//목록
		this.items = cdpService.dynamicQueryForList("CAR.GET_CAR_CMPT_USER_SCO_LIST", startIndex, pageSize, sortField, sortDir, "NAME, CMPGROUP, CMPNAME", filter, new Object[]{ companyid, runNum }, new int[]{  Types.NUMERIC, Types.NUMERIC  }, map);
		if(this.items !=null && this.items.size()>0){
			// 총 건수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		return success();
	}
	
	/**
	 * 
	 * 역량별점수 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CarException 
	 * @since 2014. 10. 30.
	 */
	@SuppressWarnings({ "deprecation" })
	public String getCmptUserScoExcelList() throws CarException{
		
		try {

			long companyid = getUser().getCompanyId();

			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
			map.put("GRID_WHERE_CLAUSE", "");
			map.put("GRID_ORDERBY_CLAUSE","ORDER BY NAME, CMPGROUP, CMPNAME");
			
			Object [] params = {
					companyid, runNum
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC
			};
			this.items = carService.dynamicQueryForList("CAR.GET_CAR_CMPT_USER_SCO_LIST", params, jdbcTypes, map);
			
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
					"역량군", "역량", "부서", "성명", "ID", "직급", "직무", "계급", "평점"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "역량별점수");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
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
						case 0: if(itMap.get("CMPGROUP_NM")!=null) tmp = itMap.get("CMPGROUP_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1: if(itMap.get("CMPNAME")!=null) tmp = itMap.get("CMPNAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2: if(itMap.get("DVS_NAME")!=null) tmp = itMap.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 3: if(itMap.get("NAME")!=null) tmp = itMap.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 4: if(itMap.get("EMPNO")!=null) tmp = itMap.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
						case 5: if(itMap.get("GRADE_NM")!=null) tmp = itMap.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 6: if(itMap.get("JOB_NAME")!=null) tmp = itMap.get("JOB_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 7: if(itMap.get("LEADERSHIP_NAME")!=null) tmp = itMap.get("LEADERSHIP_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 8: if(itMap.get("SCORE_NUMB")!=null) tmp = itMap.get("SCORE_NUMB"); else tmp = ""; cell.setCellStyle(style2); break;
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
				if(k==1)sheet.setColumnWidth((short)k, (short)4000);
				if(k==2)sheet.setColumnWidth((short)k, (short)8000);
				if(k==3)sheet.setColumnWidth((short)k, (short)3000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);
				if(k==5)sheet.setColumnWidth((short)k, (short)6000);
				if(k==6)sheet.setColumnWidth((short)k, (short)6000);
				if(k==7)sheet.setColumnWidth((short)k, (short)6000);
				if(k==8)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = URLEncoder.encode("역량별점수.xls","UTF-8");
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CarException(e);
		}
		
		return success();
	}
	

	/**
	 * 
	 * 역량진단결과 >종합진단결과 화면이동.<br/>
	 *
	 * @return
	 * @since 2014. 10. 29.
	 */
	public String getCmptUserTotalScoListPg(){
		return success();
	}
	
	/**
	 * 
	 * 역량진단결과 >종합진단결과 - 목록 조회.<br/>
	 *
	 * @return
	 * @since 2014. 10. 30.
	 */
	public String getCmptUserTotalScoList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		Map<String, Object>  map = new HashMap<String, Object>();
		map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));

		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		//목록
		this.items = cdpService.dynamicQueryForList("CAR.GET_CAR_CMPT_USER_TOTAL_SCORE_LIST", startIndex, pageSize, sortField, sortDir, "NAME", filter, new Object[]{ companyid, runNum }, new int[]{  Types.NUMERIC, Types.NUMERIC  }, map);
		if(this.items !=null && this.items.size()>0){
			// 총 건수
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	}
	
	/**
	 * 
	 * 종합진단결과 엑셀 다운로드.<br/>
	 *
	 * @return
	 * @throws CarException 
	 * @since 2014. 10. 30.
	 */
	@SuppressWarnings({ "deprecation" })
	public String getCmptUserTotalScoExcelList() throws CarException{
		
		try {

			long companyid = getUser().getCompanyId();

			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", carService.getUserDivisionList(request, getUser(), "BU.DIVISIONID"));
			map.put("GRID_WHERE_CLAUSE", "");
			map.put("GRID_ORDERBY_CLAUSE","ORDER BY NAME");
			
			Object [] params = {
					companyid, runNum
			}; 
			int[] jdbcTypes = {
					Types.NUMERIC, Types.NUMERIC
			};
			this.items = carService.dynamicQueryForList("CAR.GET_CAR_CMPT_USER_TOTAL_SCORE_LIST", params, jdbcTypes, map);
			
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
					"부서", "성명", "ID", "직급", "직무", "계급", "전체평점"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "종합진단결과");
			row = sheet.createRow(0);
			
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				cell.setCellStyle(style);
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
						case 0: if(itMap.get("DVS_NAME")!=null) tmp = itMap.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 1: if(itMap.get("NAME")!=null) tmp = itMap.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 2: if(itMap.get("EMPNO")!=null) tmp = itMap.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
						case 3: if(itMap.get("GRADE_NM")!=null) tmp = itMap.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
						case 4: if(itMap.get("JOB_NAME")!=null) tmp = itMap.get("JOB_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 5: if(itMap.get("LEADERSHIP_NAME")!=null) tmp = itMap.get("LEADERSHIP_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
						case 6: if(itMap.get("EVL_TOTAL_SCORE")!=null) tmp = itMap.get("EVL_TOTAL_SCORE"); else tmp = ""; cell.setCellStyle(style2); break;
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
				if(k==0)sheet.setColumnWidth((short)k, (short)8000);
				if(k==1)sheet.setColumnWidth((short)k, (short)3000);
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
				if(k==3)sheet.setColumnWidth((short)k, (short)6000);
				if(k==4)sheet.setColumnWidth((short)k, (short)6000);
				if(k==5)sheet.setColumnWidth((short)k, (short)6000);
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
			this.targetAttachmentFileName = URLEncoder.encode("종합진단결과.xls","UTF-8");
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
			throw new CarException(e);
		}
		
		return success();
	}
	
	/**
	 * 
	 * 종합진단결과 - 사용자별 진단결과 조회...<br/>
	 *
	 * @return
	 * @throws CAMException
	 * @since 2014. 10. 17.
	 */
	public String getCarAnalysisCmpt() throws CarException{
		log.debug(CommonUtils.printParameter(request));
		
		this.items = carService.queryForList("EVL.CMPT_ANALY_RUN_INFO", new Object[]{getUser().getCompanyId(), ParamUtils.getParameter(request, "RUN_NUM"), ParamUtils.getParameter(request, "TG_USERID")}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC} );
		if(this.items!=null && this.items.size()>0){
			Map map = (Map)this.items.get(0);
			
			request.setAttribute("JOB", map.get("JOB"));
			request.setAttribute("LEADERSHIP", map.get("LEADERSHIP"));
			request.setAttribute("NAME", map.get("NAME"));
			request.setAttribute("GRADE_NM", map.get("GRADE_NM"));
			request.setAttribute("JOB_NAME", map.get("JOB_NAME"));
			request.setAttribute("LEADERSHIP_NAME", map.get("LEADERSHIP_NAME"));
			
		}
		return success();
	}
}