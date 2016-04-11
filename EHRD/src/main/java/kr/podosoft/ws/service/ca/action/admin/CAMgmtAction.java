package kr.podosoft.ws.service.ca.action.admin;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Types;
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

import kr.podosoft.ws.service.ca.CAException;
import kr.podosoft.ws.service.ca.CAService;
import kr.podosoft.ws.service.kpi.KPIException;
import kr.podosoft.ws.service.utils.CommonUtils;

import architecture.ee.util.ApplicationHelper;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;


public class CAMgmtAction extends FrameworkActionSupport {

	private static final long serialVersionUID = 1725681046182286268L;

	private int pageSize = 15 ;
	
    private int startIndex = 0 ;  
    
    private int totalItemCount = 0;	
    
    private int saveCount = 0;

	private int year = 0;

	private List items;
	
	private List items1;
	
	private List items2;
	 
	private List items3;
	
	private List items4; 
	
	private List items5;
	
	private List items6;
	
	private List subItems;
	
	private String statement ; 
	
	private CAService caService;
	
	private Map question;
	
	private List examples;
	 
	private String targetAttachmentContentType = "";
	
	private int targetAttachmentContentLength = 0;
	
	private InputStream targetAttachmentInputStream = null;
	
	private String targetAttachmentFileName = "";

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
	
	public List getItems3() {
		return items3;
	}

	public void setItems3(List items3) {
		this.items3 = items3;
	}
	
	public List getItems4() {
		return items4;
	}

	public void setItems4(List items4) {
		this.items4 = items4;
	}
	
	public List getItems5() {
		return items5;
	}

	public void setItems5(List items5) {
		this.items5 = items5;
	}
	
	public List getItems6() {
		return items6;
	}

	public void setItems6(List items6) {
		this.items6 = items6;
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
	

	/* ================================================= 
     MPVA project S..... 
     ================================================= */
	
	
	/**
	 * 설문관리 년도 셀렉트박스
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getSurvYealList(){	
		
		//this.items = caService.getSruvYealListService(getUser().getCompanyId());
		
		return success();
	}
	
	/**
	 * 설문관리 리스트
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getSurvList(){
		
	    String runNum = ParamUtils.getParameter(request, "RUN_NUM");
		System.out.println(runNum);
		this.items = caService.getSurvList(getUser(), runNum);
		
		return success();
	}
	
	/**
	 * 설문문항 리스트
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getSurvQstn(){
		
	    String ppNo = ParamUtils.getParameter(request, "PP_NO");
	    
		this.items2 = caService.getSurvQstn(getUser(), ppNo);
		
		return success();
	}
		
	/**
	 * 설문문항 결과 리스트
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getSurvRst(){
		
	    String ppNo = ParamUtils.getParameter(request, "PP_NO");
	    
	    int ppType= Integer.parseInt(ParamUtils.getParameter(request, "QSTN_TYPE_CD"));
	    
	    String ppSeq = ParamUtils.getParameter(request, "QSTN_SEQ");
	    
		this.items5 = caService.getSurvRst(getUser(), ppNo, ppType, ppSeq);
		
		return success();
	}
	
	/**
	 * 설문관리 - 설문결과 객관식 유무 확인
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getSurvRstCount(){
		
	    String ppNo = ParamUtils.getParameter(request, "PP_NO");
	    
	    int ppType= Integer.parseInt(ParamUtils.getParameter(request, "QSTN_TYPE_CD"));
	    
	    String ppSeq = ParamUtils.getParameter(request, "QSTN_SEQ");
	    
		this.items6 = caService.getSurvRstCount(getUser(), ppNo, ppType, ppSeq);
		
		return success();
	}
	/**
	 * 설문문항 대상자
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getSurvTarg(){
		
	    String ppNo = ParamUtils.getParameter(request, "PP_NO");
		this.items3 = caService.getSurvTarg(getUser(), ppNo);
		
		return success();
	}
	
	/**
	 * 설문문항 리스트 Pool
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getSurvQstnPool(){	
		this.items1 = caService.getSurvQstnPool(getUser());
		
		return success();
	}
	
	/**
	 * 설문관리 사용자 리스트
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getSurvUser(){		
	   
		this.items4 = caService.getSurvUser(getUser());
		
		return success();
	}
	
	/**
	 * 설문문항  Pool 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getQstnPoolSave(){
				
		String ppNo  = ParamUtils.getParameter(request, "PP_NO");
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);				
				
		this.saveCount = caService.getQstnPoolSave(list, getUser());
				
		return success();
	}
	
	/**
	 * 설문지 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getQstnRstSave(){
				
		String ppNo  = ParamUtils.getParameter(request, "PP_NO");
		
		String age  = ParamUtils.getParameter(request, "AGE");
		
		
		String gender  = ParamUtils.getParameter(request, "GENDER");
		
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);				
				
		this.saveCount = caService.getQstnRstSave(list, getUser(), ppNo, age, gender);
				
		return success();
	}
	
	/**
	 * 설문문항  bind 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getQstnBindSave(){
				
		String ppNo  = ParamUtils.getParameter(request, "PP_NO");
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);				
				
		this.saveCount = caService.getQstnBindSave(ppNo, list, getUser());
				
		return success();
	}
	
	
	/**
	 * 
	 * 설문관리 안내 메일 발송<br/>
	 *
	 * @return
	 * @throws CAException
	 * @since 2014. 5. 1.
	 */
	public String infoMailSend() throws Exception{
		log.debug(CommonUtils.printParameter(request));
		
	    String ppNo= ParamUtils.getParameter(request, "PP_NO");	
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		
		this.saveCount = caService.infoMailSend(getUser(), ppNo, list);
		
		return success();
	
	}
	/**
	 * 설문결과 엑셀 다운로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 29.
	 */
	@SuppressWarnings("deprecation")
	public String getServListExcel(){
		try {
		
		String ppNo  = ParamUtils.getParameter(request, "PP_NO");
		String add ="";
		
		//문항리스트
		List list = caService.getSurvQstn(getUser(), ppNo);
		
		//카운트
		//int count = caService.getSurvQstnCount(getUser(), ppNo);

		
		this.items = caService.getServListExcel(getUser() , ppNo, list);
		
			log.debug(items);
		
		
		
			
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
	
			int arrSize = list.size()+5;
			String [] cell_value= new String[arrSize];
			cell_value[0] = "부서";
			cell_value[1] = "성명";
			cell_value[2] = "교직원번호";
			cell_value[3] = "성별";
			cell_value[4] = "나이";
			
			for(int j=0; j<list.size(); j++){
				Map rowMap = (Map)list.get(j);
				
				cell_value[j+5] = rowMap.get("QSTN").toString();
			}
			
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "지표 목록");
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
						
						/*switch(k) {
							case 0: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("GD")!=null) tmp = map.get("GD"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("AGE")!=null) tmp = map.get("AGE"); else tmp = ""; cell.setCellStyle(style2); break;
						}*/
						
						if(k==0){
							if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2);
						}else if(k==1){
							if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(style2);
						}else if(k==2){
							if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2);
						}else if(k==3){
							if(map.get("GD")!=null) tmp = map.get("GD"); else tmp = ""; cell.setCellStyle(style2);
						}else if(k==4){
							if(map.get("AGE")!=null) tmp = map.get("AGE"); else tmp = ""; cell.setCellStyle(style2);
						}else{
							if(map.get("RST"+(k-5))!=null) tmp = map.get("RST"+(k-5)); else tmp = ""; cell.setCellStyle(style2);
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
				if(k !=0 && k!=1 && k!=2 && k!=3 && k!=4 )sheet.setColumnWidth((short)k, (short)7000);
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
			this.targetAttachmentFileName = "설문결과목록.xls";
			
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
	 * 설문관리 문항POOL excel 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 19.
	 */
	public String servExcelUpload() { 
	 	
		this.saveCount = caService.servExcelSaveService(getUser(), request);
		
		return success();
	}
	
	/**
	 * 대상자 관리  bind 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getUserBindSave(){
				
		String ppNo  = ParamUtils.getParameter(request, "PP_NO");
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);				
				
		this.saveCount = caService.getUserBindSave(ppNo, list, getUser());
				
		return success();
	}
	
	/**
	 * 설문문항  Pool 삭제
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getQstnPoolDel(){
				
		String qstnPoolNo  = ParamUtils.getParameter(request, "QSTNPOOLNO");	
		this.saveCount = caService.getQstnPoolDel(qstnPoolNo, getUser());
				
		return success();
	}
	
	/**
	 * 설문문항 삭제
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getQstnDel(){
				
		String ppNo  = ParamUtils.getParameter(request, "PP_NO");	
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		this.saveCount = caService.getQstnDel(list, ppNo, getUser());
				
		return success();
	}
	
	/**
	 * 설문지 삭제
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getServPpDel(){
				
		
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		this.saveCount = caService.getServPpDel(list, getUser());
				
		return success();
	}
	
	/**
	 * 설문문항 유저 삭제
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 28.
	 */
	public String getQstnUserDel(){
				
		String ppNo  = ParamUtils.getParameter(request, "PP_NO");	
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		this.saveCount = caService.getQstnUserDel(list, ppNo, getUser());
				
		return success();
	}
	
	/**
	 * 설문 총 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws ParseException 
	 * @since 2014. 4. 28.
	 */
	public String getServAllSave() throws ParseException{
		
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		String ppNo  = ParamUtils.getParameter(request, "PP_NO");
		String ppNm  = ParamUtils.getParameter(request, "PP_NM");
		String ppPerp  = ParamUtils.getParameter(request, "PP_PURP");
		String useFlag = ParamUtils.getParameter(request, "USEFLAG");
		Date ppSt = sdf.parse(ParamUtils.getParameter(request, "PP_ST").toString());
		Date ppEd = sdf.parse(ParamUtils.getParameter(request, "PP_ED").toString());
		
		log.debug("ppNo"+ppNo);
		log.debug("ppNm"+ppNm);
		log.debug("ppPerp"+ppPerp);
		log.debug("ppSt"+ppSt);
		log.debug("ppEd"+ppEd);
		
		
		this.saveCount = caService.getServAllSave(  ppNo, ppNm, ppPerp, ppSt, ppEd, getUser(), useFlag);
		
		return success();
	}
	

	/**
	 * 역량목록 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws CAException 
	 * @since 2014. 3. 18.
	 */
	public String getCompetencyList() throws CAException{
		
		//this.items = caService.getCompetencyListService(startIndex, pageSize, getUser().getCompanyId());
		this.items = caService.queryForList("CA.GET_CMPT_LIST", new Object[]{getUser().getCompanyId()}, new int []{Types.NUMERIC});
		this.totalItemCount = this.items.size();
		
		return success();
	}
	
	/**
	 * 공통코드 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 18.
	 */
	public String getCommonCodeList(){
		
		String standardCode = ParamUtils.getParameter(request, "STANDARDCODE");
		
		//콤보박스의 옵션 추가 
		//ADDVALUE = null -> 옵션추가없음
		//ADDVALUE != null -> 파라메타값으로 옵션추가(예: 전체, 선택 등..)
		String addValue = ParamUtils.getParameter(request, "ADDVALUE"); 
		
		this.items = caService.getCommonCodeListService( standardCode, getUser().getCompanyId(), addValue);
		return success();
	}
	

	/**
	 * 역량저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String competencySave() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		this.saveCount = caService.competencySaveService(map, getUser());

		return success();
	}
	
	
	/**
	 * 코드모음 엑셀 다운로드 개발중
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws CAException 
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getCommonExcel() throws CAException{
		
		this.items = caService.queryForList("CA.COMMON_ADMIN_EXCEL_LIST", new Object[]{getUser().getCompanyId(), getUser().getCompanyId()}, new int[]{Types.NUMERIC, Types.NUMERIC});
		this.items2 = caService.queryForList("CA.COMMON_ADMIN_EXCEL_LIST2", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC});
		this.items3 = caService.queryForList("CA.COMMON_ADMIN_EXCEL_LIST3", new Object[]{getUser().getCompanyId(), getUser().getCompanyId()}, new int[]{Types.NUMERIC, Types.NUMERIC});
		this.items4 = caService.queryForList("CA.COMMON_ADMIN_EXCEL_LIST4", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC});
		
		try {
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet = null;
			HSSFSheet sheet2 = null;
			HSSFSheet sheet3 = null;
			HSSFSheet sheet4 = null;
			HSSFRow row = null;
	
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
	
			HSSFCellStyle style = workbook.createCellStyle();
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setFont(font);
			style.setFillForegroundColor(HSSFColor.TAN.index);
			
	
			HSSFCellStyle style2 = workbook.createCellStyle();
			style2.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			style2.setFillForegroundColor(HSSFColor.TAN.index);
			
			log.debug("WorkBook sheet Body start......... ");
			
			String[] cell_value = {
					"역량군(대)", "코드번호", "역량군(소)", "코드번호"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "역량군코드");
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
							case 0: if(map.get("CMM_CODENAME")!=null) tmp = map.get("CMM_CODENAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("COMMONCODE")!=null) tmp = map.get("COMMONCODE"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("S_CMM_CODENAME")!=null) tmp = map.get("S_CMM_CODENAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("S_COMMONCODE")!=null) tmp = map.get("S_COMMONCODE"); else tmp = ""; cell.setCellStyle(style2); break;
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
				if(k==1)sheet.setColumnWidth((short)k, (short)4000);
				if(k==2)sheet.setColumnWidth((short)k, (short)6000);
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
			}
			
			log.debug("WorkBook sheet2 Body start......... ");
			
			String[] cell_value2 = {
					"역량군(대)", "역량군(소)", "역량명", "코드번호"
			};
			
			sheet2 = workbook.createSheet();
			workbook.setSheetName(1 , "역량코드");
			row = sheet2.createRow(0);
	
			for(int k=0; k<cell_value2.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value2[k]);
				cell.setCellStyle(style);
			}
			i = 1;
			if(this.items2!=null && this.items2.size()>0) {
				for( Iterator iter = this.items2.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet2.createRow(i++);
	
					for(int k=0; k<cell_value2.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						String[] tempStr = null;

						switch(k) {
							case 0: if(map.get("CMPGROUP_STRING")!=null) tmp = map.get("CMPGROUP_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("CMPGROUP_S_STRING")!=null) tmp = map.get("CMPGROUP_S_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("CMPNAME")!=null) tmp = map.get("CMPNAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("CMPNUMBER")!=null) tmp = map.get("CMPNUMBER"); else tmp = "";  cell.setCellStyle(style2); break;
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
			
			for (int k=0; k<cell_value2.length; k++) {
				if(k==0)sheet2.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet2.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet2.setColumnWidth((short)k, (short)7000);
				if(k==3)sheet2.setColumnWidth((short)k, (short)4000);
			}
			
			log.debug("WorkBook sheet3 Body start......... ");
			
			String[] cell_value3 = {
					"지표대분류", "코드번호", "지표소분류", "코드번호"
			};
			
			sheet3 = workbook.createSheet();
			workbook.setSheetName(2 , "지표분류코드");
			row = sheet3.createRow(0);
	
			for(int k=0; k<cell_value3.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value3[k]);
				cell.setCellStyle(style);
			}
	
			i = 1;
			if(this.items3!=null && this.items3.size()>0) {
				for( Iterator iter = this.items3.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet3.createRow(i++);
	
					for(int k=0; k<cell_value3.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						
						switch(k) {
							case 0: if(map.get("CMM_CODENAME")!=null) tmp = map.get("CMM_CODENAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("COMMONCODE")!=null) tmp = map.get("COMMONCODE"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("S_CMM_CODENAME")!=null) tmp = map.get("S_CMM_CODENAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("S_COMMONCODE")!=null) tmp = map.get("S_COMMONCODE"); else tmp = ""; cell.setCellStyle(style2); break;
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
			
			for (int k=0; k<cell_value3.length; k++) {
				if(k==0)sheet3.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet3.setColumnWidth((short)k, (short)7000);
				if(k==2)sheet3.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet3.setColumnWidth((short)k, (short)7000);
			}
			
			
			
			log.debug("WorkBook sheet4 Body start......... ");
			
			String[] cell_value4 = {
					"코드분류", "코드명", "코드번호"
			};
			
			sheet4 = workbook.createSheet();
			workbook.setSheetName(3 , "공통코드");
			row = sheet4.createRow(0);
	
			for(int k=0; k<cell_value4.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value4[k]);
				cell.setCellStyle(style);
			}
	
			i = 1;
			if(this.items4!=null && this.items4.size()>0) {
				for( Iterator iter = this.items4.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet4.createRow(i++);
	
					for(int k=0; k<cell_value4.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						
						switch(k) {
							case 0: if(map.get("STN_CODENAME")!=null) tmp = map.get("STN_CODENAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("CMM_CODENAME")!=null) tmp = map.get("CMM_CODENAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("COMMONCODE")!=null) tmp = map.get("COMMONCODE"); else tmp = ""; cell.setCellStyle(style2); break;
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
			
			for (int k=0; k<cell_value4.length; k++) {
				if(k==0)sheet4.setColumnWidth((short)k, (short)8000);
				if(k==1)sheet4.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet4.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "엑셀용 코드 목록.xls";
			
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
	 * 코드모음 엑셀 다운로드 개발중
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws CAException 
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getCommonOperatorExcel() throws CAException{
		
		this.items = caService.queryForList("CA.COMMON_OPERATOR_EXCEL_LIST", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC});
		this.items2 = caService.queryForList("CA.COMMON_OPERATOR_EXCEL_LIST2", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC});
		this.items3 = caService.queryForList("CA.COMMON_OPERATOR_EXCEL_LIST3", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC});
		this.items4 = caService.queryForList("CA.COMMON_OPERATOR_EXCEL_LIST4", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC});
		this.items5 = caService.queryForList("CA.COMMON_OPERATOR_EXCEL_LIST5", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC});
		this.items6 = caService.queryForList("CA.COMMON_OPERATOR_EXCEL_LIST6", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC});
		
		try {
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet = null;
			HSSFSheet sheet2 = null;
			HSSFSheet sheet3 = null;
			HSSFSheet sheet4 = null;
			HSSFSheet sheet5 = null;
			HSSFSheet sheet6 = null;
			HSSFRow row = null;
	
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
	
			HSSFCellStyle style = workbook.createCellStyle();
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setFont(font);
			style.setFillForegroundColor(HSSFColor.TAN.index);
			
	
			HSSFCellStyle style2 = workbook.createCellStyle();
			style2.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			style2.setFillForegroundColor(HSSFColor.TAN.index);
			
			log.debug("WorkBook sheet Body start......... ");
			
			String[] cell_value = {
				 "역량군명", "역량군코드"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "역량군코드");
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
							case 0: if(map.get("CMM_CODENAME")!=null) tmp = map.get("CMM_CODENAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("COMMONCODE")!=null) tmp = map.get("COMMONCODE"); else tmp = ""; cell.setCellStyle(style2); break;
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
			}
			
			log.debug("WorkBook sheet2 Body start......... ");
			
			String[] cell_value2 = {
					"역량군",  "역량명", "역량코드"
			};
			
			sheet2 = workbook.createSheet();
			workbook.setSheetName(1 , "역량코드");
			row = sheet2.createRow(0);
	
			for(int k=0; k<cell_value2.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value2[k]);
				cell.setCellStyle(style);
			}
			i = 1;
			if(this.items2!=null && this.items2.size()>0) {
				for( Iterator iter = this.items2.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet2.createRow(i++);
	
					for(int k=0; k<cell_value2.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						String[] tempStr = null;

						switch(k) {
							case 0: if(map.get("CMPGROUP_STRING")!=null) tmp = map.get("CMPGROUP_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("CMPNAME")!=null) tmp = map.get("CMPNAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("CMPNUMBER")!=null) tmp = map.get("CMPNUMBER"); else tmp = "";  cell.setCellStyle(style2); break;
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
			
			for (int k=0; k<cell_value2.length; k++) {
				if(k==0)sheet2.setColumnWidth((short)k, (short)4000);
				if(k==1)sheet2.setColumnWidth((short)k, (short)4000);
				if(k==2)sheet2.setColumnWidth((short)k, (short)4000);
			}
			
			log.debug("WorkBook sheet3 Body start......... ");
			
			String[] cell_value3 = {
				 "카테고리", "공통코드", "공통코드명"
			};
			
			sheet3 = workbook.createSheet();
			workbook.setSheetName(2 , "공통코드");
			row = sheet3.createRow(0);
	
			for(int k=0; k<cell_value3.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value3[k]);
				cell.setCellStyle(style);
			}
	
			i = 1;
			if(this.items3!=null && this.items3.size()>0) {
				for( Iterator iter = this.items3.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet3.createRow(i++);
	
					for(int k=0; k<cell_value3.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						
						switch(k) {
							case 0: if(map.get("STN_CODENAME")!=null) tmp = map.get("STN_CODENAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("COMMONCODE")!=null) tmp = map.get("COMMONCODE"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("CMM_CODENAME")!=null) tmp = map.get("CMM_CODENAME"); else tmp = ""; cell.setCellStyle(style2); break;
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
			
			for (int k=0; k<cell_value3.length; k++) {
				if(k==0)sheet3.setColumnWidth((short)k, (short)6000);
				if(k==1)sheet3.setColumnWidth((short)k, (short)4000);
				if(k==1)sheet3.setColumnWidth((short)k, (short)10000);
			}
			
			
			
			log.debug("WorkBook sheet4 Body start......... ");
			
			String[] cell_value4 = {
					"직무/계급", "직무/계급명", "직무/계급코드"
			};
			
			sheet4 = workbook.createSheet();
			workbook.setSheetName(3 , "직무,계급코드");
			row = sheet4.createRow(0);
	
			for(int k=0; k<cell_value4.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value4[k]);
				cell.setCellStyle(style);
			}
	
			i = 1;
			if(this.items4!=null && this.items4.size()>0) {
				for( Iterator iter = this.items4.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet4.createRow(i++);
	
					for(int k=0; k<cell_value4.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						
						switch(k) {
							case 0: if(map.get("JOBLDR_FLAG")!=null) tmp = map.get("JOBLDR_FLAG"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("JOBLDR_NAME")!=null) tmp = map.get("JOBLDR_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("JOBLDR_NUM")!=null) tmp = map.get("JOBLDR_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
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
			
			for (int k=0; k<cell_value4.length; k++) {
				if(k==0)sheet4.setColumnWidth((short)k, (short)4000);
				if(k==1)sheet4.setColumnWidth((short)k, (short)8000);
				if(k==2)sheet4.setColumnWidth((short)k, (short)4000);
			}
			
			log.debug("WorkBook sheet5 Body start......... ");
			
			String[] cell_value5 = {
					"부서명", "부서코드"
			};
			
			sheet5 = workbook.createSheet();
			workbook.setSheetName(4 , "부서코드");
			row = sheet5.createRow(0);
	
			for(int k=0; k<cell_value5.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value5[k]);
				cell.setCellStyle(style);
			}
	
			i = 1;
			if(this.items5!=null && this.items5.size()>0) {
				for( Iterator iter = this.items5.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet5.createRow(i++);
	
					for(int k=0; k<cell_value5.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						
						switch(k) {
							case 0: if(map.get("DVS_FULLNAME")!=null) tmp = map.get("DVS_FULLNAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("DIVISIONID")!=null) tmp = map.get("DIVISIONID"); else tmp = ""; cell.setCellStyle(style2); break;
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
			
			for (int k=0; k<cell_value5.length; k++) {
				if(k==0)sheet5.setColumnWidth((short)k, (short)8000);
				if(k==1)sheet5.setColumnWidth((short)k, (short)4000);
			}
			
			log.debug("WorkBook sheet6 Body start......... ");
			
			String[] cell_value6 = {
					 "부서", "계급", "계급코드", "직무", "직무코드","직급","직급코드", "이름","찾기", "교직원번호", "사용자코드"
			};
			
			sheet6 = workbook.createSheet();
			workbook.setSheetName(5 , "사용자정보");
			row = sheet6.createRow(0);
	
			for(int k=0; k<cell_value6.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value6[k]);
				cell.setCellStyle(style);
			}
	
			i = 1;
			if(this.items6!=null && this.items6.size()>0) {
				for( Iterator iter = this.items6.iterator(); iter.hasNext();) {
					Map map = (Map)iter.next();
					row = sheet6.createRow(i++);
	
					for(int k=0; k<cell_value6.length; k++) {
						HSSFCell cell = row.createCell((short)k);
	
						Object tmp = new Object();
						
						switch(k) {
							case 0: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("LEADERSHIP_NAME")!=null) tmp = map.get("LEADERSHIP_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("LEADERSHIP")!=null) tmp = map.get("LEADERSHIP"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("JOB_NAME")!=null) tmp = map.get("JOB_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("JOB")!=null) tmp = map.get("JOB"); else tmp = ""; cell.setCellStyle(style2); break;
							case 5: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 6: if(map.get("GRADE_NUM")!=null) tmp = map.get("GRADE_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 7: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 8: if(map.get("SEARCH_STR")!=null) tmp = map.get("SEARCH_STR"); else tmp = ""; cell.setCellStyle(style2); break;
							case 9: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 10: if(map.get("USERID")!=null) tmp = map.get("USERID"); else tmp = ""; cell.setCellStyle(style2); break;
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
			
			for (int k=0; k<cell_value6.length; k++) {
				if(k==0)sheet6.setColumnWidth((short)k, (short)5000);
				if(k==1)sheet6.setColumnWidth((short)k, (short)5000);
				if(k==2)sheet6.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet6.setColumnWidth((short)k, (short)5000);
				if(k==4)sheet6.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet6.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet6.setColumnWidth((short)k, (short)5000);
				if(k==7)sheet6.setColumnWidth((short)k, (short)5000);
				if(k==8)sheet6.setColumnWidth((short)k, (short)5000);
				if(k==9)sheet6.setColumnWidth((short)k, (short)4000);
				if(k==10)sheet6.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "엑셀용코드목록.xls";
			
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
	 * 삭제(공통)
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String caCommonDel() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		this.saveCount = caService.caCommonDelService(map, getUser());

		return success();
	}
	
	
	
	/**
	 * 역량정보 excel 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 19.
	 */
	public String cmptExcelUpload() {
	 	
		this.saveCount = caService.cmptExcelSaveService(getUser(), request);
		
		return success();
	}
	
	
	/**
	 * KPI 정보 excel 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 19.
	 */
	public String kpiExcelUpload() {
	 	
		this.saveCount = caService.kpiExcelSaveService(getUser(), request);
		
		return success();
	}
	 
	 
	/**
	 * 역량pool 엑셀다운로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getCmptListExcel(){
		
		this.items = caService.getCmptListExcel(getUser().getCompanyId());
		
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
					"역량군(대)", "역량군(대)코드", "역량군(소)", "역량군(소)코드", "역량명", "역량번호", "역량정의","사용여부"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "역량 목록");
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
							case 0: if(map.get("CMPGROUP_STRING")!=null) tmp = map.get("CMPGROUP_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("CMPGROUP")!=null) tmp = map.get("CMPGROUP"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("CMPGROUP_S_STRING")!=null) tmp = map.get("CMPGROUP_S_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("CMPGROUP_S")!=null) tmp = map.get("CMPGROUP_S"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("CMPNAME")!=null) tmp = map.get("CMPNAME"); else tmp = "";  cell.setCellStyle(style2); break;
							case 5: if(map.get("CMPNUMBER")!=null) tmp = map.get("CMPNUMBER"); else tmp = ""; cell.setCellStyle(style2); break;
							case 6: if(map.get("CMPDEFINITION")!=null) tmp = map.get("CMPDEFINITION"); else tmp = ""; break;
							case 7: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; cell.setCellStyle(style2); break;
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
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
				if(k==6)sheet.setColumnWidth((short)k, (short)15000);
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
			this.targetAttachmentFileName = "역량pool목록.xls";
			
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
	 * 역량pool 엑셀다운로드(고객사)
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getOperatorCmptListExcel(){
		
		this.items = caService.getCmptListExcel(getUser().getCompanyId());
		
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
					"역량군", "역량군코드", "역량명", "역량번호", "역량정의","사용여부"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "역량목록");
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
							case 0: if(map.get("CMPGROUP_STRING")!=null) tmp = map.get("CMPGROUP_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("CMPGROUP")!=null) tmp = map.get("CMPGROUP"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("CMPNAME")!=null) tmp = map.get("CMPNAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("CMPNUMBER")!=null) tmp = map.get("CMPNUMBER"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("CMPDEFINITION")!=null) tmp = map.get("CMPDEFINITION"); else tmp = "";  cell.setCellStyle(style2); break;
							case 5: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; cell.setCellStyle(style2); break;
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
				if(k==3)sheet.setColumnWidth((short)k, (short)5000);
				if(k==4)sheet.setColumnWidth((short)k, (short)15000);
				if(k==5)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = "역량목록.xls";
			
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
	 * KPI pool 엑셀 다운로드 개발중
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getkpiListExcel(){
		
		this.items = caService.getKpiListExcel(getUser().getCompanyId());
		
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
					"지표(대)", "지표(대)코드", "지표(소)", "지표(소)코드", "지표명", "지표번호", "관리유형", "평가코드", "단위", "단위코드", "사용여부"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "지표 목록");
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
							case 0: if(map.get("KPIGROUP_STRING")!=null) tmp = map.get("KPIGROUP_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("KPIGROUP")!=null) tmp = map.get("KPIGROUP"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("KPIGROUP_S_STRING")!=null) tmp = map.get("KPIGROUP_S_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("KPIGROUP_S")!=null) tmp = map.get("KPIGROUP_S"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("KPI_NM")!=null) tmp = map.get("KPI_NM"); else tmp = "";  cell.setCellStyle(style2); break;
							case 5: if(map.get("KPI_NO")!=null) tmp = map.get("KPI_NO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 6: if(map.get("EVL_HOW_STRING")!=null) tmp = map.get("EVL_HOW_STRING"); else tmp = ""; break;
							case 7: if(map.get("EVL_HOW")!=null) tmp = map.get("EVL_HOW"); else tmp = ""; break;
							case 8: if(map.get("UNIT_STRING")!=null) tmp = map.get("UNIT_STRING"); else tmp = ""; break;
							case 9: if(map.get("UNIT")!=null) tmp = map.get("UNIT"); else tmp = ""; break;
							case 10: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; cell.setCellStyle(style2); break;
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
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)7000);
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
				if(k==6)sheet.setColumnWidth((short)k, (short)3000);
				if(k==7)sheet.setColumnWidth((short)k, (short)3000);
				if(k==8)sheet.setColumnWidth((short)k, (short)3000);
				if(k==9)sheet.setColumnWidth((short)k, (short)3000);
				if(k==10)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = "KPIpool목록.xls";
			
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
	 * KPI pool 엑셀 다운로드(고객사)
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getOperatorKpiListExcel(){
		
		this.items = caService.getOperatorKpiListExcel(getUser().getCompanyId());
		
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
					"지표번호", "지표명", "지표유형", "지표유형코드", "관리주기", "관리주기코드", "단위", "단위코드", "사용여부"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "지표 목록");
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
							case 0: if(map.get("KPI_NO")!=null) tmp = map.get("KPI_NO"); else tmp = "";  cell.setCellStyle(style2); break;
							case 1: if(map.get("KPI_NM")!=null) tmp = map.get("KPI_NM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("KPI_TYPE_STRING")!=null) tmp = map.get("KPI_TYPE_STRING"); else tmp = ""; break;
							case 3: if(map.get("KPI_TYPE")!=null) tmp = map.get("KPI_TYPE"); else tmp = ""; break;
							case 4: if(map.get("MEA_EVL_CYC_STRING")!=null) tmp = map.get("MEA_EVL_CYC_STRING"); else tmp = ""; break;
							case 5: if(map.get("MEA_EVL_CYC")!=null) tmp = map.get("MEA_EVL_CYC"); else tmp = ""; break;
							case 6: if(map.get("UNIT_STRING")!=null) tmp = map.get("UNIT_STRING"); else tmp = ""; break;
							case 7: if(map.get("UNIT")!=null) tmp = map.get("UNIT"); else tmp = ""; break;
							case 8: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; cell.setCellStyle(style2); break;
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
				if(k==1)sheet.setColumnWidth((short)k, (short)15000);
				if(k==2)sheet.setColumnWidth((short)k, (short)5000);
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)5000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)3000);
				if(k==7)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = "성과관리 목록.xls";
			
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
	 * 역량군목록 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 18.
	 */
	public String getCmpgroupList(){
		
		String useFlag = ParamUtils.getParameter(request, "USEFLAG", "Y");
		
		this.items = caService.getCmpgroupListService( useFlag, getUser().getCompanyId());
		return success();
	}

	
	/**
	 * 역량군 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String cmpGroupSave() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		this.saveCount = caService.cmpGroupSaveService(map, getUser());

		return success();
	}
	
	
	
	/**
	 * 역량군 체크
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String cmpGroupChk() throws Exception{
		
		
		
		
		
		String useFlag = ParamUtils.getParameter(request, "USEFLAG", "Y");
		
		this.items = caService.cmpGroupChkService( useFlag, getUser().getCompanyId());

		return success();
	}
	
	
	
	/**
	 * 역량군(고객사) 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String operatorCmpGroupSave() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		this.saveCount = caService.operatorCmpGroupSaveService(map, getUser());

		return success();
	}
	
	/**
	 * 역량저장(고객사)
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String operatorCompetencySave() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		this.saveCount = caService.operatorCompetencySaveService(map, getUser());

		return success();
	}
	

	/* ================================================= 
     MPVA project E..... 
     ================================================= */	
	
	
	//행동지표 리스트
	public String getIndicatorList(){
		this.items = caService.getIndicatorListService(getUser().getCompanyId());
		this.totalItemCount = items.size();
		return success();
	}
	
	//행동지표 리스트(고객사)
	public String getOperatorIndicatorList(){
		this.items = caService.getOperatorIndicatorListService(getUser().getCompanyId());
		this.totalItemCount = items.size();
		return success();
	}
	
	
	//계층 리스트
	public String getLdrList() throws Exception {
		
		long companyid = getUser().getCompanyId();
		
		this.items = caService.queryForList("CA.SELECT_JOBLDR_CODE_LIST", new Object[] {companyid}, new int[] {Types.INTEGER});
		
		this.totalItemCount = this.items.size();
		
		return success();
	}
	
	//행동지표에 맵핑된 계층 리스트
	public String getBhidLdrList() throws Exception {
		
		long companyid = getUser().getCompanyId();
		
		String bhidNum = ParamUtils.getParameter(request, "BHID_NUM");
		
		log.debug("######## bhidNum"+bhidNum);		
		
		this.items = caService.queryForList("CA.SELECT_BHID_LDR_MAPPING_LIST", new Object[] {companyid,companyid,bhidNum}, new int[] {Types.NUMERIC,Types.NUMERIC,Types.NUMERIC});
		
		this.totalItemCount = this.items.size();
		
		return success();
	}
	
	@SuppressWarnings("deprecation")
	public String getIndicatorListExcel(){
		
		this.items = caService.getIndicatorListExcel(getUser().getCompanyId());
		
		try {
			//String filename = "sampleDown.xls";
			
			//response.setHeader("Content-Disposition", "attachment; filename="+filename);
			
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
					"행동지표번호", "역량군(대)", "역량군(소)", "역량명", "역량번호", "행동지표", "사용여부"
//					, "보기1","보기순서1","보기1점수","보기2","보기순서2","보기2점수","보기3"
//					,"보기순서3", "보기3점수","보기4","보기순서4","보기4점수", "보기5","보기순서5","보기5점수"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "행동지표 목록");
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
							case 0: if(map.get("BHV_INDC_NUM")!=null) tmp = map.get("BHV_INDC_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("CMPGROUP_STRING")!=null) tmp = map.get("CMPGROUP_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("CMPGROUP_S_STRING")!=null) tmp = map.get("CMPGROUP_S_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("CMPNAME")!=null) tmp = map.get("CMPNAME"); else tmp = "";  cell.setCellStyle(style2); break;
							case 4: if(map.get("CMPNUMBER")!=null) tmp = map.get("CMPNUMBER"); else tmp = ""; cell.setCellStyle(style2); break;
							case 5: if(map.get("BHV_INDICATOR")!=null) tmp = map.get("BHV_INDICATOR"); else tmp = ""; break;
							case 6: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; cell.setCellStyle(style2); break;							
//							case 7: if(map.get("EXAMPLE1")!=null) tmp = map.get("EXAMPLE1"); else tmp = ""; break;
//							case 8: if(map.get("ORDER1")!=null) tmp = map.get("ORDER1"); else tmp = ""; cell.setCellStyle(style2); break;
//							case 9: if(map.get("SCORE1")!=null) tmp = map.get("SCORE1"); else tmp = ""; cell.setCellStyle(style2); break;
//							case 10: if(map.get("EXAMPLE2")!=null) tmp = map.get("EXAMPLE2"); else tmp = ""; break;
//							case 11: if(map.get("ORDER2")!=null) tmp = map.get("ORDER2"); else tmp = ""; cell.setCellStyle(style2); break;
//							case 12: if(map.get("SCORE2")!=null) tmp = map.get("SCORE2"); else tmp = ""; cell.setCellStyle(style2); break;
//							case 13: if(map.get("EXAMPLE3")!=null) tmp = map.get("EXAMPLE3"); else tmp = ""; break;
//							case 14: if(map.get("ORDER3")!=null) tmp = map.get("ORDER3"); else tmp = ""; cell.setCellStyle(style2); break;
//							case 15: if(map.get("SCORE3")!=null) tmp = map.get("SCORE3"); else tmp = ""; cell.setCellStyle(style2); break;
//							case 16: if(map.get("EXAMPLE4")!=null) tmp = map.get("EXAMPLE4"); else tmp = ""; break;
//							case 17: if(map.get("ORDER4")!=null) tmp = map.get("ORDER4"); else tmp = ""; cell.setCellStyle(style2); break;
//							case 18: if(map.get("SCORE4")!=null) tmp = map.get("SCORE4"); else tmp = ""; cell.setCellStyle(style2); break;
//							case 19: if(map.get("EXAMPLE5")!=null) tmp = map.get("EXAMPLE5"); else tmp = ""; break;
//							case 20: if(map.get("ORDER5")!=null) tmp = map.get("ORDER5"); else tmp = ""; cell.setCellStyle(style2); break;
//							case 21: if(map.get("SCORE5")!=null) tmp = map.get("SCORE5"); else tmp = ""; cell.setCellStyle(style2); break;
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
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);
				if(k==5)sheet.setColumnWidth((short)k, (short)20000);
				if(k==6)sheet.setColumnWidth((short)k, (short)2500);
//				if(k==7)sheet.setColumnWidth((short)k, (short)3000);
//				if(k==8)sheet.setColumnWidth((short)k, (short)4000);
//				if(k==9)sheet.setColumnWidth((short)k, (short)6000);
//				if(k==10)sheet.setColumnWidth((short)k, (short)10000);
//				if(k==11)sheet.setColumnWidth((short)k, (short)3000);
//				if(k==12)sheet.setColumnWidth((short)k, (short)3000);
//				if(k==13)sheet.setColumnWidth((short)k, (short)10000);
//				if(k==14)sheet.setColumnWidth((short)k, (short)3000);
//				if(k==15)sheet.setColumnWidth((short)k, (short)3000);
//				if(k==16)sheet.setColumnWidth((short)k, (short)10000);
//				if(k==17)sheet.setColumnWidth((short)k, (short)3000);
//				if(k==18)sheet.setColumnWidth((short)k, (short)3000);
//				if(k==19)sheet.setColumnWidth((short)k, (short)10000);
//				if(k==20)sheet.setColumnWidth((short)k, (short)3000);
//				if(k==21)sheet.setColumnWidth((short)k, (short)3000);
//				if(k==22)sheet.setColumnWidth((short)k, (short)10000);
//				if(k==23)sheet.setColumnWidth((short)k, (short)3000);
//				if(k==24)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = "행동지표_리스트.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}
	
	@SuppressWarnings("deprecation")
	public String getOperatorIndicatorListExcel(){
		
		this.items = caService.getIndicatorListExcel(getUser().getCompanyId());
		
		try {
			//String filename = "sampleDown.xls";
			
			//response.setHeader("Content-Disposition", "attachment; filename="+filename);
			
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
					"행동지표번호", "역량군(대)", "역량명", "역량번호", "행동지표", "사용여부"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "행동지표목록");
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
							case 0: if(map.get("BHV_INDC_NUM")!=null) tmp = map.get("BHV_INDC_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("CMPGROUP_STRING")!=null) tmp = map.get("CMPGROUP_STRING"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("CMPNAME")!=null) tmp = map.get("CMPNAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("CMPNUMBER")!=null) tmp = map.get("CMPNUMBER"); else tmp = "";  cell.setCellStyle(style2); break;
							case 4: if(map.get("BHV_INDICATOR")!=null) tmp = map.get("BHV_INDICATOR"); else tmp = ""; cell.setCellStyle(style2); break;
							case 5: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; break;
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
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)20000);
				if(k==5)sheet.setColumnWidth((short)k, (short)2500);
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
			this.targetAttachmentFileName = "행동지표목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}
	
	
	//역량 매핑 엑셀 다운로드
	@SuppressWarnings("deprecation")
	public String caOperatorCmptMappExcel(){
		
		this.items = caService.getcaOperatorCmptMappExcel(getUser().getCompanyId());
		
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
	
			// START : =================================================================
			/* 40°³ */
			String[] cell_value = {
					"구분", "직무/리더십명", "직무/리더십코드", "역량군", "역량", "역량코드", "매핑여부(Y/N)"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "역량매핑 목록");
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
							case 0: if(map.get("JOBLDR_FLAG_NAME")!=null) tmp = map.get("JOBLDR_FLAG_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("JOBLDR_NAME")!=null) tmp = map.get("JOBLDR_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("JOBLDR_NUM")!=null) tmp = map.get("JOBLDR_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("CMPGROUP_STRING")!=null) tmp = map.get("CMPGROUP_STRING"); else tmp = "";  cell.setCellStyle(style2); break;
							case 4: if(map.get("CMPNAME")!=null) tmp = map.get("CMPNAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 5: if(map.get("CMPNUMBER")!=null) tmp = map.get("CMPNUMBER"); else tmp = ""; break;
							case 6: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; break;
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
				if(k==1)sheet.setColumnWidth((short)k, (short)7000);
				if(k==2)sheet.setColumnWidth((short)k, (short)6000);
				if(k==3)sheet.setColumnWidth((short)k, (short)8000);
				if(k==4)sheet.setColumnWidth((short)k, (short)10000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
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
			this.targetAttachmentFileName = "역량매핑 리스트.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}
	

	//KPI 매핑 엑셀 다운로드
	@SuppressWarnings("deprecation")
	public String caOperatorKpiMappExcel() throws CAException{
		
		this.items = caService.queryForList("CA.GET_KPI_MAPP_LIST_EXCEL", new Object[]{getUser().getCompanyId()}, new int []{Types.NUMERIC});
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
			
			HSSFCellStyle style_y = workbook.createCellStyle();
			style_y.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style_y.setFont(font);
			style_y.setFillForegroundColor(HSSFColor.YELLOW.index);
			style_y.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND); 
			
	
			HSSFCellStyle style2 = workbook.createCellStyle();
			style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style2.setFillForegroundColor(HSSFColor.TAN.index);
			

			HSSFCellStyle style2_y = workbook.createCellStyle();
			style2_y.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style2_y.setFillForegroundColor(HSSFColor.YELLOW.index);
			style2_y.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND); 
	
			// START : =================================================================
			/* 40°³ */
			String[] cell_value = {
					"구분", "직무/리더십명", "직무/리더십코드", "지표명", "지표코드", "지표유형", "관리주기", "Characteristic", "관리유형", "단위", "우선순위", "매핑여부(Y/N)"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "성과매핑 목록");
			row = sheet.createRow(0);
	
			for(int k=0; k<cell_value.length; k++) {
				HSSFCell cell = row.createCell((short)k);
				cell.setCellValue(cell_value[k]);
				if(k==2 || k==4 || k==10 || k==11){
					cell.setCellStyle(style_y);
				}else{
					cell.setCellStyle(style);
				}
				
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
							case 0: if(map.get("JOBLDR_FLAG_NAME")!=null) tmp = map.get("JOBLDR_FLAG_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("JOBLDR_NAME")!=null) tmp = map.get("JOBLDR_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("JOBLDR_NUM")!=null) tmp = map.get("JOBLDR_NUM"); else tmp = ""; cell.setCellStyle(style2_y); break;
							case 3: if(map.get("KPI_NM")!=null) tmp = map.get("KPI_NM"); else tmp = "";  cell.setCellStyle(style2); break;
							case 4: if(map.get("KPI_NO")!=null) tmp = map.get("KPI_NO"); else tmp = ""; cell.setCellStyle(style2_y); break;
							case 5: if(map.get("KPI_TYPE_NM")!=null) tmp = map.get("KPI_TYPE_NM"); else tmp = ""; break;
							case 6: if(map.get("MEA_EVL_CYC_NM")!=null) tmp = map.get("MEA_EVL_CYC_NM"); else tmp = ""; break;
							case 7: if(map.get("EVL_TYPE_NM")!=null) tmp = map.get("EVL_TYPE_NM"); else tmp = ""; break;
							case 8: if(map.get("EVL_HOW_NM")!=null) tmp = map.get("EVL_HOW_NM"); else tmp = ""; break;
							case 9: if(map.get("UNIT_NM")!=null) tmp = map.get("UNIT_NM"); else tmp = ""; break;
							case 10: if(map.get("PRIO")!=null) tmp = map.get("PRIO"); else tmp = ""; cell.setCellStyle(style2_y);break;
							case 11: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = ""; cell.setCellStyle(style2_y);break;
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
				if(k==1)sheet.setColumnWidth((short)k, (short)7000);
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
				if(k==3)sheet.setColumnWidth((short)k, (short)13000);
				if(k==4)sheet.setColumnWidth((short)k, (short)4000);
				if(k==5)sheet.setColumnWidth((short)k, (short)5000);
				if(k==6)sheet.setColumnWidth((short)k, (short)4000);
				if(k==7)sheet.setColumnWidth((short)k, (short)4000);
				if(k==8)sheet.setColumnWidth((short)k, (short)4000);
				if(k==9)sheet.setColumnWidth((short)k, (short)4000);
				if(k==10)sheet.setColumnWidth((short)k, (short)4000);
				if(k==11)sheet.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "성과매핑 리스트.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}
	
	public String getCompetencyComboList(){
		this.items = caService.getCompetencyComboList(getUser().getCompanyId());
		return success();
	}

	public String getCmptList() throws CAException{
		this.items = caService.queryForList("CA.GET_COMPETENCY_GROUP_COMBO_LIST", new Object[]{ getUser().getCompanyId()}, new int[]{ Types.NUMERIC });
		return success();
	}

	/**
	 * 
	 * 나의 역량 목록<br/>
	 *
	 * @return
	 * @throws CAException
	 * @since 2015. 5. 15.
	 */
	public String getMyCmptList() throws CAException{
		long userid = getUser().getUserId();
		long companyid = getUser().getCompanyId();
		
		this.items = caService.queryForList("CA.GET_MY_COMPETENCY_GROUP_COMBO_LIST", new Object[]{ companyid, userid, companyid, userid, companyid, userid, userid }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	//행동지표 저장
	public String indicatorSave() throws Exception{
		
		Map map = ParamUtils.getJsonParameter(request, "item", Map.class);

		this.saveCount = caService.indicatorSaveService(map, getUser());
		return success();
	}
	
	//행동지표 저장(고객사)
	public String operatorIndicatorSave() throws Exception{
		
		Map map = ParamUtils.getJsonParameter(request, "item", Map.class);

		List<Map<String,Object>> items = ParamUtils.getJsonParameter(request, "bhidItem", List.class); 
		
		this.saveCount = caService.operatorIndicatorSaveService(map, getUser(), items);
		return success();
	}
	
	public String indcExcelUpload() {
	 	
		this.saveCount = caService.indicatorExcelSaveService(getUser(), request);
		
		return success();
	}
	 
	/*
	public String getSubelementList() {
		
		String cmpNumber = ParamUtils.getParameter(request, "CMPNUMBER");
		
		this.items = caService.getSubelementList(getUser(), cmpNumber);
		
		return success();
	}
	*/
	
	/**
	 * 역량pool관리 메뉴의 상세조회에서 행동지표 목록 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 17.
	 */
	public String getBhvList(){
		String cmpNumber = ParamUtils.getParameter(request, "CMPNUMBER");
		
		this.items = caService.getBhvList(getUser(), cmpNumber);
		
		return success();
	}
	
	public String consistencyList() {
		
		this.items = caService.consistencyList(getUser());
		
		return success();
	}
	
	
	/**
	 * 역량pool관리(고객사) 메뉴의 상세조회에서 행동지표 목록 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 17.
	 */
	public String getOperatorBhvList(){
		String cmpNumber = ParamUtils.getParameter(request, "CMPNUMBER");
		
		this.items = caService.getOperatorBhvList(getUser(), cmpNumber);
		
		return success();
	}
	
	
	/**
	 * 역량목록(고객사) 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws CAException 
	 * @since 2014. 3. 18.
	 */
	public String getOperatorCompetencyList() throws CAException{
		//this.items = caService.getOperatorCompetencyListService(startIndex, pageSize, getUser().getCompanyId());
		this.items =caService.queryForList("CA.GET_OPERATOR_CMPT_LIST", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC} );
		this.totalItemCount = this.items.size();
		return success();
	}

	/**
	 * KPI 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 9.
	 */
	public String getKpiList() throws CAException{
//		this.items = caService.getKpiListService(startIndex, pageSize, getUser().getCompanyId());
		this.items = caService.queryForList("CA.GET_KPI_LIST", new Object[]{getUser().getCompanyId()}, new int[]{Types.NUMERIC} );
		this.totalItemCount = this.items.size();
		return success();
	}
	
	/**
	 * KPI 지표저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String kpiSave() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		this.saveCount = caService.kpiSaveService(map, getUser());

		return success();
	}
	
	/**
	 * 성과관리 - 지표생성(일반사용자)
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String userKpiSave() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		String runNum = ParamUtils.getParameter(request, "RUN_NUM");
		
		this.saveCount = caService.userKpiSaveService(map, getUser(), runNum);

		return success();
	}
	
	
	
	/**
	 * 
	 * 회사지표로 사용 처리(고객사)<br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String operatorKpiChangeRegTypeSave() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		String kpiNumber 		=  (String)map.get("KPINUMBER");
		
		this.saveCount = caService.update("CA.OPERATOR_CHANGE_REGTYPE", new Object[]{"1", getUser().getCompanyId(), kpiNumber}, new int[]{Types.VARCHAR, Types.NUMERIC, Types.NUMERIC});

		return success();
	}
	
	/**
	 * KPI 지표저장(고객사)
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String operatorKpiSave() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		this.saveCount = caService.operatorKpiSaveService(map, getUser());

		return success();
	}
	
	/**
	 * KPI Add 체크
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String kpiAddCheck() throws Exception{
		
		
		this.statement = caService.kpiAddCheckService(getUser());

		return success();
	}
	
	/**
	 * 역량 Add 체크
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String cmptAddCheck() throws Exception{
		
		
		this.statement = caService.cmptAddCheckService(getUser());

		return success();
	}
	
	
	/**
	 * KPI 트리뷰 목록 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 18.
	 */
	public String getKpigroupList(){
		
		String useFlag = ParamUtils.getParameter(request, "USEFLAG", "Y");
		
		this.items = caService.getKpigroupListService( useFlag, getUser().getCompanyId());
		return success();
	}
	
	
	/**
	 * kpi 지표군 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String kpiGroupSave() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		this.saveCount = caService.kpiGroupSaveService(map, getUser());

		return success();
	}
	
}


