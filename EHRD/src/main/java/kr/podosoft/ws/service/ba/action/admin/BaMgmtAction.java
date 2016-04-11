/**
 * 기본정보관리
 * 1. 공통코드관리
 * 2. 학과관리
 * 3. 쿠폰관리
 */
package kr.podosoft.ws.service.ba.action.admin;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaService;
//import kr.podosoft.ws.service.ca.action.admin.CAMgmtAction;
import kr.podosoft.ws.service.utils.CommonUtils;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;

import architecture.ee.util.ApplicationHelper;
//import architecture.ee.web.attachment.FileInfo;
import architecture.ee.web.struts2.action.UploadAttachmentAction;
//import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

public class BaMgmtAction extends UploadAttachmentAction {

	private static final long serialVersionUID = 6533321353590957499L;
	
	private int pageSize = 15;    
    private int startIndex = 0;
    private String jobLdrNum; // 직무번호
    private String cmpNumber; // 역량번호
    private String indcNumber;
	

	private String checkFlag=""; 
    
	private List items;
	private List items2;
	
	private int totalItemCount = 0;
	private int totalItem2Count = 0;
	private int saveCount = 0;
	
	private int result = 0;
	private String statement="";
	private String msg="";
	
	private BaService baSrv;
	
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
	
	public BaService getBaSrv() {
		return baSrv;
	}

	public void setBaSrv(BaService baSrv) {
		this.baSrv = baSrv;
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
	
	public int getTotalItem2Count() {
		return totalItem2Count;
	}

	public void setTotalItem2Count(int totalItem2Count) {
		this.totalItem2Count = totalItem2Count;
	}

	public List getItems() {
		return items;
	}

	public void setItems(List items) {
		this.items = items;
	}
	
	public List getItems2() {
		return items2;
	}

	public void setItems2(List items2) {
		this.items2 = items2;
	}

	public int getResult() {
		return result;
	}

	public void setResult(int result) {
		this.result = result;
	}

	public String getStatement() {
		return statement;
	}

	public void setStatement(String statement) {
		this.statement = statement;
	}
	
	
	public String getCheckFlag() {
		return checkFlag;
	}

	public void setCheckFlag(String checkFlag) {
		this.checkFlag = checkFlag;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}
	
	public int getSaveCount() {
		return saveCount;
	}
	
	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
	}
	public String getJobLdrNum() {
		return jobLdrNum;
	}

	public void setJobLdrNum(String jobLdrNum) {
		this.jobLdrNum = jobLdrNum;
	}
	public String getCmpNumber() {
		return cmpNumber;
	}

	public void setCmpNumber(String cmpNumber) {
		this.cmpNumber = cmpNumber;
	}
	
	public String getIndcNumber() {
		return indcNumber;
	}

	public void setIndcNumber(String indcNumber) {
		this.indcNumber = indcNumber;
	}

	/**
	 * 
	 * 고객사관리 - 고객사 목록 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 1.
	 */
	public String getCompanyList() throws Exception{
		List<Map<String,Object>> list = baSrv.queryForList("BA.SELECT_COMPANY_LIST", null, null);
		List<Map<String,Object>> tmpList = new ArrayList<Map<String,Object>>();

		log.debug("### list:"+list.size());
		if(list!=null && list.size()>0){
			for(Map<String, Object> map : list){
				if(map.get("PHONE")!=null){
					map.put("PHONE", CommonUtils.ASEDecoding(map.get("PHONE").toString()));						
				}
				if(map.get("EMAIL")!=null){
					map.put("EMAIL", CommonUtils.ASEDecoding(map.get("EMAIL").toString()));
				}
				tmpList.add(map);
			}
			log.debug("### tmpList:"+tmpList.size());
		}
		this.items = tmpList;
		this.totalItemCount = this.items.size();
		return success();
	}
	
	/**
	 * 
	 * 사업자등록번호 중복 체크<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 2.
	 */
	public String getRgstnoCnt() throws Exception{
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		String rgst_no = (String)map.get("RGST_NO");
		this.totalItemCount = CommonUtils.stringToInt(baSrv.queryForObject("BA.SELECT_RGSTNO_CNT", new Object[]{rgst_no}, new int[]{Types.VARCHAR}, String.class)+"", 0);
		return success();
	}
	
	/**
	 * 
	 * 고객사ID 중복 체크<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 2.
	 */
	public String getCstmidCnt() throws Exception{
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		String cstm_id = (String)map.get("CSTM_ID");
		this.totalItemCount = CommonUtils.stringToInt(baSrv.queryForObject("BA.SELECT_CSTMID_CNT", new Object[]{cstm_id}, new int[]{Types.VARCHAR}, String.class)+"", 0);
		return success();
	}
	
	/**
	 * 
	 * 고객사 정보 저장<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 3.
	 */
	public String companySave() throws Exception {
		log.debug("============================================== ");
		log.debug(CommonUtils.printParameter(request));
		log.debug("============================================== ");
		
		this.saveCount = baSrv.companySave(request, getUser()); //
		return success();
	}
	
	/**
	 * 
	 * 고객사관리 - 고객사에서 사용하는 역량목록 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 8.
	 */
	public String getCompanyCmptList() throws Exception{
		String parentCompanyid = ParamUtils.getParameter(request, "COMPANYID");
		int companyid = Integer.parseInt(parentCompanyid.toString());
		this.items = baSrv.queryForList("BA.SELECT_COMPANY_CMPT_USE_LIST", new Object[]{companyid}, new int[] {Types.NUMERIC});
		this.totalItemCount = this.items.size();
		return success();
	}
	
	/**
	 * 
	 * 고객사가 사용하는 역량 저장<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 8.
	 */
	public String companyCmptUseSave() throws Exception {
		log.debug("============================================== ");
		log.debug(CommonUtils.printParameter(request));
		log.debug("============================================== ");
		
		this.saveCount = baSrv.companyCmptUseSave(request, getUser()); 
		return success();
	}
	
	/**
	 * 
	 * 고객사관리 - 고객사에서 사용하는 KPI 목록 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 8.
	 */
	public String getCompanyKpiList() throws Exception{
		String parentCompanyid = ParamUtils.getParameter(request, "COMPANYID");
		int companyid = Integer.parseInt(parentCompanyid.toString());
		this.items = baSrv.queryForList("BA.SELECT_COMPANY_KPI_USE_LIST", new Object[]{companyid}, new int[] {Types.NUMERIC});
		this.totalItemCount = this.items.size();
		return success();
	}

	/**
	 * 
	 * 고객사가 사용하는 KPI 저장<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 8.
	 */
	public String companyKpiUseSave() throws Exception {
		log.debug("============================================== ");
		log.debug(CommonUtils.printParameter(request));
		log.debug("============================================== ");
		
		this.saveCount = baSrv.companyKpiUseSave(request, getUser()); 
		return success();
	}
	
	/**
	 * 고객사정보관리 엑셀 다운로드 
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 28.
	 */
	@SuppressWarnings("deprecation")
	public String getCompanyListExcel() throws Exception{
		//부서 전체 목록 조회
		this.items = baSrv.queryForList("BA.SELECT_COMPANY_LIST_EXCEL");
		
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
					"고객사번호", "고객사명", "고객사ID", "사업자등록번호", "계약시작일", "계약종료일", "역량 추가여부", "KPI 지표 추가여부", "담당자", "담당자 사번", "담당자 이메일", "담당자 연락처", "메인코멘트", "사용여부" 
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "고객사 목록");
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
							case 0: if(map.get("COMPANYID")!=null) tmp = map.get("COMPANYID"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 1: if(map.get("COMPANYNAME")!=null) tmp = map.get("COMPANYNAME"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 2: if(map.get("CSTM_ID")!=null) tmp = map.get("CSTM_ID"); else tmp = ""; cell.setCellStyle(styleL); break;
							case 3: if(map.get("RGST_NO")!=null) tmp = map.get("RGST_NO"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 4: if(map.get("CTRT_ST_DT")!=null) tmp = map.get("CTRT_ST_DT"); else tmp = ""; cell.setCellStyle(styleC); break;
							case 5: if(map.get("CTRT_ED_DT")!=null) tmp = map.get("CTRT_ED_DT"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 6: if(map.get("CMPT_INFO_ADD_YN")!=null) tmp = map.get("CMPT_INFO_ADD_YN"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 7: if(map.get("KPI_ADD_YN")!=null) tmp = map.get("KPI_ADD_YN"); else tmp = "";  cell.setCellStyle(styleC); break;
							case 8: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 9: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 10: if(map.get("EMAIL")!=null) tmp = CommonUtils.ASEDecoding(map.get("EMAIL").toString()); else tmp = "";  cell.setCellStyle(styleL); break;
							case 11: if(map.get("PHONE")!=null) tmp = CommonUtils.ASEDecoding(map.get("PHONE").toString()); else tmp = "";  cell.setCellStyle(styleL); break;
							case 12: if(map.get("MN_CMT")!=null) tmp = map.get("MN_CMT"); else tmp = "";  cell.setCellStyle(styleL); break;
							case 13: if(map.get("USE_YN")!=null) tmp = map.get("USE_YN"); else tmp = "";  cell.setCellStyle(styleC); break;
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
				if(k==2)sheet.setColumnWidth((short)k, (short)3000);
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)3000);
				if(k==5)sheet.setColumnWidth((short)k, (short)3000);
				if(k==6)sheet.setColumnWidth((short)k, (short)4000);
				if(k==7)sheet.setColumnWidth((short)k, (short)4000);
				if(k==8)sheet.setColumnWidth((short)k, (short)4000);
				if(k==9)sheet.setColumnWidth((short)k, (short)4000);
				if(k==10)sheet.setColumnWidth((short)k, (short)6000);
				if(k==11)sheet.setColumnWidth((short)k, (short)5000);
				if(k==12)sheet.setColumnWidth((short)k, (short)8000);
				if(k==13)sheet.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "고객사목록.xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}
	
	
	/* ***************************************************************************** */
	/* ********** COMMON CODE MANAGEMENT ********* */
	/* ***************************************************************************** */


	/**
	 * 기본관리 > 공통코드관리
	 * 목록
	 * @return
	 * @throws Exception
	 */
	public String getCategoryList() throws Exception {
		log.debug("### " + this.getClass().getName());

		this.items = baSrv.queryForList("BA.SELET_STANDARDCODE_LIST",
				new Object[] {getUser().getCompanyId()}, 
				new int[] {Types.INTEGER});
		
		return success();
	}
	
	/**
	 * 기본관리 > 공통코드관리(부모카테고리)
	 * 목록
	 * @return
	 * @throws Exception
	 */
	public String getCategoryParentList() throws Exception {
		log.debug("### " + this.getClass().getName());

		this.items = baSrv.queryForList("BA.SELET_PARENT_STANDARDCODE_LIST",
				new Object[] {getUser().getCompanyId()}, 
				new int[] {Types.INTEGER});
		
		return success();
	}
	
	/**
	 * 기본관리 > 공통코드관리(부모카테고리코드)
	 * 목록
	 * @return
	 * @throws Exception
	 */
	public String getCategoryParentCodeList() throws Exception {
		log.debug("### " + this.getClass().getName());
		
		String parentStandardCode = ParamUtils.getParameter(request, "parentStandardCode");
		
		log.debug("###" + parentStandardCode);
		
		this.items = baSrv.queryForList("BA.SELET_PARENT_COMMONCODE_LIST",
				new Object[] {getUser().getCompanyId(),parentStandardCode}, 
				new int[] {Types.INTEGER, Types.VARCHAR});
		
		
		return success();
	}
	
	/**
	 * 기본관리 > 코드 중복체크
	 * 목록
	 * @return
	 * @throws Exception
	 */
	public String getCodeCheckValue() throws Exception {
		log.debug("### " + this.getClass().getName());
		
		String standardCode = ParamUtils.getParameter(request, "STANDARDCODE");
		String checkCode = ParamUtils.getParameter(request, "CHECKCODE");
		
		
		this.checkFlag = baSrv.queryForObject("BA.GET_COMMONCODE_CHECK", new Object[] {standardCode, checkCode, getUser().getCompanyId()},  
																	new int[] {Types.VARCHAR, Types.VARCHAR, Types.NUMERIC}, String.class).toString();
		
		return success();
	}
	
	/**
	 * 기본관리 > 공통코드관리
	 * 목록
	 * @return
	 * @throws Exception
	 */
	public String getCommonCodeList() throws Exception {
		log.debug("### " + this.getClass().getName());
		
		this.totalItemCount = Integer.valueOf(baSrv.queryForObject("BA.SELECT-COMMONCODE-CNT", 
				new Object[] {getUser().getCompanyId()}, 
				new int[] {Types.INTEGER},
				Integer.class).toString());
		
		this.items = baSrv.queryForList("BA.SELECT-COMMONCODE-LIST", startIndex, totalItemCount,new Object[] {getUser().getCompanyId()}, 
																								   new int[] {Types.INTEGER});
		
		return success();
	}
	
	/**
	 * 기본관리 > 공통코드관리
	 * 추가/수정
	 * @return
	 * @throws Exception
	 */
	public String setCommonCodeInfo() throws Exception {
		log.debug("### " + this.getClass().getName());
		
		
		Map map = ParamUtils.getJsonParameter(request, "params", Map.class);

		long companyId = getUser().getCompanyId();
		String userId = String.valueOf(getUser().getUserId());
		
		String mode = map.get("mode").toString();
		String standardCode = map.get("standardcode")==null?"":map.get("standardcode").toString();
		String commonCode = map.get("code")==null?"":map.get("code").toString();
		String cmmCodeName = map.get("codename").toString();
		String cdStartValue = map.get("svalue")==null?"":map.get("svalue").toString();
		String cdEndValue = map.get("evalue")==null?"":map.get("evalue").toString();
		String cdValue1 = map.get("value1")==null?"":map.get("value1").toString();
		String cdValue2 = map.get("value2")==null?"":map.get("value2").toString();
		String cdValue3 = map.get("value3")==null?"":map.get("value3").toString();
		String cdValue4 = map.get("value4")==null?"":map.get("value4").toString();
		String cdValue5 = map.get("value5")==null?"":map.get("value5").toString();
		String parentStandardCode = map.get("parentstandardcode")==null?"":map.get("parentstandardcode").toString();
		String parentCommonCode = map.get("parentcommoncode")==null?"":map.get("parentcommoncode").toString();
		String useFlag = map.get("useflag")==null?"":map.get("useflag").toString();
		
		String empty = "";
		
		log.debug("###수정" + parentStandardCode);
		log.debug("###수정" + parentCommonCode);
		
		//초기화
		if(parentStandardCode.equals("(Select)")){
			parentStandardCode = empty;					
		}
		if(parentCommonCode.equals("(Select)")){
			parentCommonCode = empty;
		}
				
		
		if(mode!=null) {
			if(mode.equals("add")) 
			{
				
				Object[] params = {
						companyId, standardCode, commonCode, cmmCodeName, cdStartValue, 
						cdEndValue, cdValue1, cdValue2, cdValue3, cdValue4,
						cdValue5, parentStandardCode, parentCommonCode, useFlag,
						userId
				};
				
				int[] jdbcTypes = {
						Types.INTEGER, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.VARCHAR
				};
				result = baSrv.update("BA.INSERT-COMMONCODE-INFO", params, jdbcTypes);
			} 
			else if(mode.equals("mod")) 
			{
				Object[] params = {
						cmmCodeName, cdStartValue, cdEndValue, cdValue1, cdValue2, 
						cdValue3, cdValue4, cdValue5, parentStandardCode, parentCommonCode, 
						useFlag, userId,
						companyId, standardCode, commonCode
				};
				int[] jdbcTypes = {
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.VARCHAR, Types.INTEGER,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR
				};
				result = baSrv.update("BA.UPDATE-COMMONCODE-INFO", params, jdbcTypes);
			}
		}
		
		return success();
	}
	
	
	/* ***************************************************************************** */
	/* ********** DEPARTMENT MANAGEMENT ********* */
	/* ***************************************************************************** */
	
	public String getDeptMngList() throws Exception {
		String useFlag = ParamUtils.getParameter(request, "USEFLAG", "Y");
		if(useFlag.equals("A")){
			useFlag = "";
		}
		this.items = baSrv.getDeptMngList(getUser().getCompanyId(), useFlag);
		//this.items = baSrv.queryForList("BA.SELECT_DEPT_MNG_LIST", new Object[] {getUser().getCompanyId(), useFlag}, new int[] {Types.INTEGER, Types.VARCHAR}); 
		
		this.totalItemCount = this.items.size();
		
		return success();
	}
	
	public String getBaDeptMngList() throws Exception {
		String useFlag = ParamUtils.getParameter(request, "USEFLAG", "Y");
		if(useFlag.equals("A")){
			useFlag = "";
		}
		//this.items = baSrv.getDeptMngList(getUser().getCompanyId(), useFlag);
		this.items = baSrv.queryForList("BA.SELECT_DEPT_MNG_LIST", new Object[] {getUser().getCompanyId(), useFlag}, new int[] {Types.INTEGER, Types.VARCHAR}); 
		
		this.totalItemCount = this.items.size();
		
		return success();
	}
	
	/**
	 * 부서정보 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 18.
	 */
	public String deptSave() throws Exception {
		
		log.debug(CommonUtils.printParameter(request));

		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		String divisionid = (String) map.get("DIVISIONID");
		String high_dvsid = (String) map.get("HIGH_DVSID");
		String dvs_name = (String) map.get("DVS_NAME");
		String dvs_manager = (String) map.get("DVS_MANAGER");
		String deptStndCd = (String) map.get("DEPT_STND_CD");
		String useFlag = (String) map.get("USEFLAG");
		
		
		if(dvs_manager!=null && !dvs_manager.equals("")) {
			
		baSrv.update("BA.MERGE_DEPT_MANAGER_USERGROUP", 
				new Object[] {3, dvs_manager}, 
				new int[] {Types.INTEGER, Types.INTEGER});
		}
		
		this.saveCount = baSrv.update("BA.MERGE_DEPT", new Object[] {
				getUser().getCompanyId(), divisionid, dvs_name, high_dvsid,
				dvs_manager, deptStndCd, useFlag, getUser().getUserId(),
				getUser().getCompanyId() }, new int[] { Types.NUMERIC,
				Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
				Types.VARCHAR, Types.VARCHAR, Types.NUMERIC });

		return success();
	}
	
	/**
	 * 부서정보관리 엑셀 다운로드 
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 3. 28.
	 */
	@SuppressWarnings("deprecation")
	public String getDeptListExcel() throws Exception{
		//부서 전체 목록 조회
		this.items = baSrv.queryForList("BA.SELECT_DEPT_MNG_LIST", new Object[] {getUser().getCompanyId(), ""}, new int[]{Types.INTEGER, Types.VARCHAR});
		
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
			String[] cell_value = {
					"부서번호", "부서명", "상위부서번호", "상위부서명", "부서장 성명", "사용여부"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "부서 목록");
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
							case 0: if(map.get("DIVISIONID")!=null) tmp = map.get("DIVISIONID"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("HIGH_DVSID")!=null) tmp = map.get("HIGH_DVSID"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("HIGH_DVSID_NAME")!=null) tmp = map.get("HIGH_DVSID_NAME"); else tmp = "";  cell.setCellStyle(style2); break;
							//case 4: if(map.get("DVS_MANAGER")!=null) tmp = map.get("DVS_MANAGER"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("DVS_MANAGER_NM")!=null) tmp = map.get("DVS_MANAGER_NM"); else tmp = "";  cell.setCellStyle(style2); break;
							case 5: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = "";  cell.setCellStyle(style2); break;
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
				if(k==5)sheet.setColumnWidth((short)k, (short)4000);
				//if(k==6)sheet.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "부서목록.xls";
			
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
	 * 부서정보 엑셀 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 28.
	 */
	public String deptExcelUpload() {	 	
		this.saveCount = baSrv.divisionExcelSaveService(getUser(), request);		
		return success();
	}
		
	/**
	 * 사용자 목록 조회 - 부서장 검색함.
	 * @return
	 * @throws Exception
	 */
	public String getUserListPopup () throws Exception {
		
		String highDvsId = "";
		String dvsId = "";
		String	highDvsUser = "";
		
		highDvsId = ParamUtils.getParameter(request, "HIGH_DVSID", "0");
		dvsId = ParamUtils.getParameter(request, "DIVISIONID", "0");
		
		
		log.debug("상위부서번호" + highDvsId);
		
		//상위부서 부서장 검색
		highDvsUser = baSrv.queryForObject("BA.SELECT_HIGH_USER", new Object[] {highDvsId, getUser().getCompanyId()},  
				new int[] {Types.VARCHAR, Types.NUMERIC}, String.class).toString();
		
		log.debug("부서장 검색" + highDvsUser);
	
		this.items = baSrv.queryForList("BA.SELECT_USER_LIST_POPUP", new Object[]{dvsId, highDvsUser, getUser().getCompanyId()}, new int[]{Types.VARCHAR, Types.VARCHAR, Types.NUMERIC});
		this.totalItemCount = this.items.size();
		return success();
	}
	
	/* ***************************************************************************** */
	/* ********** KOUPON MANAGEMENT ********* */
	/* ***************************************************************************** */
	
	
	/**
	 * 쿠폰형황
	 * @return
	 * @throws Exception
	 */
	public String getCouponState() throws Exception {
		
		//items = baSrv.getCouponState(getUser().getCompanyId());
		
		return success();
	}
	
	/**
	 * 학생별 쿠폰보유현황 목록
	 * @return
	 * @throws Exception
	 */
	public String getStudentCouponHoldList() throws Exception {
		
		//items = baSrv.getStudentCouponHoldList(getUser().getCompanyId());
		
		totalItemCount = items.size();
		
		return success();
	}
	
	/**
	 * 학생별 쿠폰부여
	 * @return
	 * @throws Exception
	 */
	public String setStudentGrantCoupon() throws Exception {
		
		//int grandCouponCnt = ParamUtils.getIntParameter(request, "grndCpnCnt", 0);
		//String studentArr = ParamUtils.getStringParameter(request, "stdntArr", "");
		
		String[] result = new String[2]; 
		//result = baSrv.setStudentGrantCoupon(getUser().getCompanyId(), getUser().getUserId(), grandCouponCnt, studentArr);
		
		if(result!=null && result.length==2) {
			statement = result[0];
			msg = result[1];
		} else {
			statement = "N";
			msg = "처리중 오류가 발생하였습니다.";
		}
		
		return success();
	}
	
	/**
	 * 학생별 쿠폰사용현황 목록
	 * @return
	 * @throws Exception
	 */
	public String getStudentCouponUseList() throws Exception {
		Calendar cal = Calendar.getInstance();
		
		//int year = ParamUtils.getIntParameter(request, "year", cal.get(Calendar.YEAR));
		
		//items = baSrv.getStudentCouponUseList(getUser().getCompanyId(), year);
		
		totalItemCount = items.size();
		
		return success();
	}
	/**
	 * 기본관리 > 직무관리
	 * 목록
	 * @return
	 * @throws Exception
	 */
	public String getJobList() throws Exception {
		
		//직무,계층 코드
		String jobFlag = ParamUtils.getParameter(request, "JOBFLAG");
		
		log.debug("직무,계층 코드 : " + jobFlag);
		
		//역량매핑 (jobFlag == "ALL")
		if(jobFlag.equals("ALL")){
				
			
			this.items = baSrv.queryForList("BA.SELECT-JOBLDR_MAPP-LIST", new Object[] {getUser().getCompanyId()}, 
																						new int[]{Types.INTEGER});
			
			this.totalItemCount = items.size();	
			
			return success();			
		}else{		
//			this.totalItemCount = Integer.valueOf(baSrv.queryForObject("BA.SELECT-JOB-CNT", 
//				new Object[] {getUser().getCompanyId(), jobFlag}, 
//				new int[] {Types.INTEGER, Types.VARCHAR},
//				Integer.class).toString());		
			this.items = baSrv.queryForList("BA.SELECT-JOB-LIST", new Object[] {getUser().getCompanyId(), jobFlag}, 
																					new int[]{Types.INTEGER, Types.VARCHAR});
			this.totalItemCount = items.size();
			
			return success();
		}
	}
	

	
	/**
	 * 기본관리 > 직무관리 delete kht
	 * 직무관리 삭제시 역량매핑 삭제
	 * @return
	 * @throws Exception
	 */
	public String getJobAdminCompDel() throws Exception {
		
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSrv.deleteJobComp(request, getUser() );
		return success();
	
	}
	/**
	 * 기본관리 > 직무관리 save kht
	 * 추가/수정
	 * @return
	 * @throws Exception
	 */
	public String setJobSave() throws Exception {
		
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		saveCount += baSrv.saveJobInfo(request, getUser() );
		return success();
		
	}
	
	/**
	 * 2014-10-01 kht
	 * 역량진단관리 > 직무관리
	 * 역량매핑
	 * @return
	 * @throws Exception
	 */
	public String getJobCmMapList() throws Exception {
		
		long companyId = getUser().getCompanyId();
		
		items = baSrv.queryForList("BA.SELECT_JOB_CM_MAPPING_LIST", new Object[]{companyId, jobLdrNum}, new int[] {Types.INTEGER, Types.VARCHAR});
		
		return success();
	}
	/**
	 * 2014-10-05 kht
	 * 역량진단관리 > 직무관리
	 * 행동지표
	 * @return
	 * @throws Exception
	 */
	public String getJobIndcMapList() throws Exception {
		
		long companyId = getUser().getCompanyId();
		
		items = baSrv.queryForList("BA.SELECT_JOB_INDC_MAPPING_LIST", new Object[]{companyId, jobLdrNum}, new int[] {Types.INTEGER, Types.VARCHAR});
		
		return success();
	}
	
	/**
	 * 2014-10-05 kht
	 * 역량진단관리 > 직무관리
	 * 역량추가
	 * @return
	 * @throws Exception
	 */
	public String getJobNewCompMapList() throws Exception {
		
		long companyId = getUser().getCompanyId();
		items = baSrv.queryForList("BA.SELECT_JOB_CM_NEW_MAPPING_LIST", new Object[]{companyId, jobLdrNum,companyId}, new int[] {Types.INTEGER, Types.VARCHAR, Types.INTEGER});
		
		return success();
	}
	
	/**
	 * 2014-10-05 kht
	 * 역량진단관리 > 직무관리
	 * 행동지표 추가
	 * @return
	 * @throws Exception
	 */
	public String getJobNewIndcMapList() throws Exception {
		
		long companyId = getUser().getCompanyId();
		items = baSrv.queryForList("BA.SELECT_JOB_INDC_NEW_MAPPING_LIST", new Object[]{companyId,jobLdrNum, companyId}, new int[] {Types.INTEGER, Types.VARCHAR,Types.INTEGER});
		
		return success();
	}
	
	/**
	 * 2014-10-05 kht
	 * 역량진단관리 > 직무관리
	 * 행동지표 삭제
	 * @return
	 * @throws Exception
	 */
	public String getJobIndcDel() throws Exception{
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		String mode = map.get("mode")==null?"":map.get("mode").toString();
		String jobLdrNum = map.get("jobLdrNum")==null?"":map.get("jobLdrNum").toString();
		String cmpNumber = map.get("cmpNumber")==null?"":map.get("cmpNumber").toString();
		String indcNumber = map.get("indcNumber")==null?"":map.get("indcNumber").toString();
		String compDelYn = map.get("compDelYn")==null?"":map.get("compDelYn").toString();
		
		long companyId = getUser().getCompanyId();
		
		if("comp".equals(mode) && "".equals(indcNumber)){
			this.saveCount = baSrv.update("BA.UPDATE_JOB_COMP_DEL", new Object[]{companyId,jobLdrNum, cmpNumber}, new int[] {Types.INTEGER, Types.VARCHAR,Types.VARCHAR});
			this.saveCount = baSrv.update("BA.UPDATE_JOB_COMP_DEL_INDC", new Object[]{companyId,jobLdrNum, cmpNumber}, new int[] {Types.INTEGER, Types.VARCHAR,Types.VARCHAR});
		}else if("indc".equals(mode) && indcNumber !=null){
			this.saveCount = baSrv.update("BA.UPDATE_JOB_INDC_DEL", new Object[]{companyId,jobLdrNum, cmpNumber,indcNumber}, new int[] {Types.INTEGER, Types.VARCHAR,Types.VARCHAR,Types.VARCHAR});
		}
		
		log.debug("=================================="+compDelYn);
		log.debug("=================================="+mode);
		//모든 행동지표가 삭제되면 해당 역량도 삭제
		if("Y".equals(compDelYn)  && "indc".equals(mode)){
			this.saveCount = baSrv.update("BA.UPDATE_JOB_COMP_DEL", new Object[]{companyId,jobLdrNum, cmpNumber}, new int[] {Types.INTEGER, Types.VARCHAR,Types.VARCHAR});
		}
		return success();
	}
	
	/**
	 * 2014-10-01 kht
	 * 역량진단관리 > 계급관리
	 * 직급매핑
	 * @return
	 * @throws Exception
	 */
	public String getJobGradeMapList() throws Exception {
		
		long companyId = getUser().getCompanyId();
		
		items = baSrv.queryForList("BA.SELECT_JOB_GRADE_MAPPING_LIST", new Object[]{jobLdrNum, companyId}, new int[] { Types.NUMERIC , Types.NUMERIC});
		
		return success();
	}
	
	/**
	 * 
	 * 직무관리 > 엑셀다운로드<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 12. 4.
	 */
	@SuppressWarnings("deprecation")
	public String downJobListExcel() throws Exception {

		String jobFlag = ParamUtils.getParameter(request, "jobFlag");
		
		long companyid = getUser().getCompanyId();
		// 과정목록
		List<Map<String,Object>> list1 = baSrv.queryForList("BA.SELECT_JOB_LIST_EXCEL", 
											new Object[] {companyid,jobFlag}, 
											new int[] {Types.INTEGER,Types.VARCHAR});
		
		// 역량매핑정보
		List<Map<String,Object>> list2 = baSrv.queryForList("BA.SELECT_JOB_MAPP_CMPT_EXCEL", 
													new Object[] { companyid,jobFlag }, 
													new int[] {Types.INTEGER,Types.VARCHAR});
		
		// 역량매핑정보
		List<Map<String,Object>> list3 = baSrv.queryForList("BA.SELECT_JOB_MAPP_BHV_EXCEL", 
														new Object[] { companyid,jobFlag }, 
														new int[] {Types.INTEGER,Types.VARCHAR});
		
		try {
			log.debug("WorkBook Start......... ");
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet1 = null;
			HSSFSheet sheet2 = null;
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
				"직무코드", "직무명", "직무정의", "주요업무","사용여부"
			}; 
			String[] cell_value2 = {
				"직무코드", "직무명","역량군코드","역량군","역량코드", "역량명", "사용여부"
			};
			String[] cell_value3 = {
				"직무코드", "직무명","역량군코드","역량군","역량코드", "역량명","행동지표코드","행동지표", "사용여부"
			};
			
			log.debug("WorkBook sheet1 start......... ");
			
			sheet1 = workbook.createSheet();
			workbook.setSheetName(0 , "직무목록");
			
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
				if(cidx==0) sheet1.setColumnWidth((short)cidx, (short)3000);
				if(cidx==1) sheet1.setColumnWidth((short)cidx, (short)8000);
				if(cidx==2) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==3) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==4) sheet1.setColumnWidth((short)cidx, (short)4000);
			}

			
			log.debug("WorkBook sheet2 start......... ");
			
			sheet2 = workbook.createSheet();
			workbook.setSheetName(1 , "역량매핑");
			
			row = sheet2.createRow(0);
			
			log.debug("WorkBook sheet2 Head start......... ");
			
			for(int hidx=0; hidx<cell_value2.length; hidx++) {
				HSSFCell cell = row.createCell((short)hidx);
				cell.setCellValue(cell_value2[hidx]);
				cell.setCellStyle(style1);
			}
			
			log.debug("WorkBook sheet2 Body start......... ");
			
			if(!list2.isEmpty()) {
				for(int i=0; i<list2.size(); i++) {
					Map<String,Object> map = list2.get(i);
					row = sheet2.createRow(i+1);
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
			
			for(int cidx=0; cidx<cell_value2.length; cidx++) {
				if(cidx==0) sheet2.setColumnWidth((short)cidx, (short)3000);
				if(cidx==1) sheet2.setColumnWidth((short)cidx, (short)6000);
				if(cidx==2) sheet2.setColumnWidth((short)cidx, (short)3000);
				if(cidx==3) sheet2.setColumnWidth((short)cidx, (short)6000);
				if(cidx==4) sheet2.setColumnWidth((short)cidx, (short)3000);
				if(cidx==5) sheet2.setColumnWidth((short)cidx, (short)6000);
				if(cidx==6) sheet2.setColumnWidth((short)cidx, (short)3000);
			}
			
			log.debug("WorkBook sheet3 start......... ");
			
			sheet3 = workbook.createSheet();
			workbook.setSheetName(2 , "행동지표매핑");
			
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
				if(cidx==0) sheet3.setColumnWidth((short)cidx, (short)3000);
				if(cidx==1) sheet3.setColumnWidth((short)cidx, (short)6000);
				if(cidx==2) sheet3.setColumnWidth((short)cidx, (short)3000);
				if(cidx==3) sheet3.setColumnWidth((short)cidx, (short)6000);
				if(cidx==4) sheet3.setColumnWidth((short)cidx, (short)3000);
				if(cidx==5) sheet3.setColumnWidth((short)cidx, (short)8000);
				if(cidx==6) sheet3.setColumnWidth((short)cidx, (short)3000);
				if(cidx==7) sheet3.setColumnWidth((short)cidx, (short)10000);
				if(cidx==8) sheet3.setColumnWidth((short)cidx, (short)3000);
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
			this.targetAttachmentFileName = "직무관리목록.xls";
			
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
	 * 
	 * 계급관리 > 엑셀다운로드<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 12. 4.
	 */
	@SuppressWarnings("deprecation")
	public String downLdrListExcel() throws Exception {

		String jobFlag = ParamUtils.getParameter(request, "jobFlag");
		
		long companyid = getUser().getCompanyId();
		// 과정목록
		List<Map<String,Object>> list1 = baSrv.queryForList("BA.SELECT_JOB_LIST_EXCEL", 
											new Object[] {companyid,jobFlag}, 
											new int[] {Types.INTEGER,Types.VARCHAR});
		
		// 역량매핑정보
		List<Map<String,Object>> list2 = baSrv.queryForList("BA.SELECT_JOB_MAPP_CMPT_EXCEL", 
													new Object[] { companyid,jobFlag }, 
													new int[] {Types.INTEGER,Types.VARCHAR});
		
		// 역량매핑정보
		List<Map<String,Object>> list3 = baSrv.queryForList("BA.SELECT_JOB_MAPP_BHV_EXCEL", 
														new Object[] { companyid,jobFlag }, 
														new int[] {Types.INTEGER,Types.VARCHAR});

		// 역량매핑정보
		List<Map<String,Object>> list4 = baSrv.queryForList("BA.SELECT_LDR_MAPP_GRADE_EXCEL", 
														new Object[] { companyid,jobFlag }, 
														new int[] {Types.INTEGER,Types.VARCHAR});
		

				
		try {
			log.debug("WorkBook Start......... ");
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet1 = null;
			HSSFSheet sheet2 = null;
			HSSFSheet sheet3 = null;
			HSSFSheet sheet4 = null;
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
				"계급코드", "계급명", "계급정의", "주요역활","사용여부"
			}; 
			String[] cell_value2 = {
				"계급코드", "계급명","역량군코드","역량군","역량코드", "역량명", "사용여부"
			};
			String[] cell_value3 = {
				"계급코드", "계급명","역량군코드","역량군","역량코드", "역량명","행동지표코드","행동지표", "사용여부"
			};
			String[] cell_value4 = {
				"계급코드", "계급명","직급코드","직급명","사용여부"
			};
			
			log.debug("WorkBook sheet1 start......... ");
			
			sheet1 = workbook.createSheet();
			workbook.setSheetName(0 , "계급목록");
			
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
				if(cidx==0) sheet1.setColumnWidth((short)cidx, (short)3000);
				if(cidx==1) sheet1.setColumnWidth((short)cidx, (short)8000);
				if(cidx==2) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==3) sheet1.setColumnWidth((short)cidx, (short)10000);
				if(cidx==4) sheet1.setColumnWidth((short)cidx, (short)4000);
			}

			
			log.debug("WorkBook sheet2 start......... ");
			
			sheet2 = workbook.createSheet();
			workbook.setSheetName(1 , "역량매핑");
			
			row = sheet2.createRow(0);
			
			log.debug("WorkBook sheet2 Head start......... ");
			
			for(int hidx=0; hidx<cell_value2.length; hidx++) {
				HSSFCell cell = row.createCell((short)hidx);
				cell.setCellValue(cell_value2[hidx]);
				cell.setCellStyle(style1);
			}
			
			log.debug("WorkBook sheet2 Body start......... ");
			
			if(!list2.isEmpty()) {
				for(int i=0; i<list2.size(); i++) {
					Map<String,Object> map = list2.get(i);
					row = sheet2.createRow(i+1);
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
			
			for(int cidx=0; cidx<cell_value2.length; cidx++) {
				if(cidx==0) sheet2.setColumnWidth((short)cidx, (short)3000);
				if(cidx==1) sheet2.setColumnWidth((short)cidx, (short)6000);
				if(cidx==2) sheet2.setColumnWidth((short)cidx, (short)3000);
				if(cidx==3) sheet2.setColumnWidth((short)cidx, (short)6000);
				if(cidx==4) sheet2.setColumnWidth((short)cidx, (short)3000);
				if(cidx==5) sheet2.setColumnWidth((short)cidx, (short)6000);
				if(cidx==6) sheet2.setColumnWidth((short)cidx, (short)3000);
			}
			
			log.debug("WorkBook sheet3 start......... ");
			
			sheet3 = workbook.createSheet();
			workbook.setSheetName(2 , "행동지표매핑");
			
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
				if(cidx==0) sheet3.setColumnWidth((short)cidx, (short)3000);
				if(cidx==1) sheet3.setColumnWidth((short)cidx, (short)6000);
				if(cidx==2) sheet3.setColumnWidth((short)cidx, (short)3000);
				if(cidx==3) sheet3.setColumnWidth((short)cidx, (short)6000);
				if(cidx==4) sheet3.setColumnWidth((short)cidx, (short)3000);
				if(cidx==5) sheet3.setColumnWidth((short)cidx, (short)8000);
				if(cidx==6) sheet3.setColumnWidth((short)cidx, (short)3000);
				if(cidx==7) sheet3.setColumnWidth((short)cidx, (short)10000);
				if(cidx==8) sheet3.setColumnWidth((short)cidx, (short)3000);
			}
			
			log.debug("WorkBook sheet4 start......... ");
			
			sheet4 = workbook.createSheet();
			workbook.setSheetName(3 , "직급매핑");
			
			row = sheet4.createRow(0);
			
			log.debug("WorkBook sheet4 Head start......... ");
			
			for(int hidx=0; hidx<cell_value4.length; hidx++) {
				HSSFCell cell = row.createCell((short)hidx);
				cell.setCellValue(cell_value4[hidx]);
				cell.setCellStyle(style1);
			}
			
			log.debug("WorkBook sheet4 Body start......... ");
			
			if(!list4.isEmpty()) {
				for(int i=0; i<list4.size(); i++) {
					Map<String,Object> map = list4.get(i);
					row = sheet4.createRow(i+1);
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
			
			for(int cidx=0; cidx<cell_value4.length; cidx++) {
				if(cidx==0) sheet4.setColumnWidth((short)cidx, (short)3000);
				if(cidx==1) sheet4.setColumnWidth((short)cidx, (short)6000);
				if(cidx==2) sheet4.setColumnWidth((short)cidx, (short)3000);
				if(cidx==3) sheet4.setColumnWidth((short)cidx, (short)6000);
				if(cidx==4) sheet4.setColumnWidth((short)cidx, (short)3000);
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
			this.targetAttachmentFileName = "계급관리목록.xls";
			
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
	
	//직무관리 엑셀 다운로드
	@SuppressWarnings("deprecation")
	public String getJobListExcel() throws Exception{
		
		String jobFlag = ParamUtils.getParameter(request, "jobFlag");
		
		log.debug("엑셀다운로드 직무,계층 코드 : " + jobFlag);
		
		this.items = baSrv.queryForList("BA.SELECT-JOB-LIST", startIndex, totalItemCount,new Object[] {getUser().getCompanyId(), jobFlag}, 
				new int[]{Types.INTEGER, Types.VARCHAR});
		
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
					"","", "", "", "사용여부"
			};
			
			if(jobFlag.equals("J")) 
			{	
				cell_value[0] = "직무번호" ;
				cell_value[1] = "직무명" ;
				cell_value[2] = "직무정의" ;
				cell_value[3] = "주요업무" ;
			}else if(jobFlag.equals("L")){
				cell_value[0] = "계층 번호" ;
				cell_value[1] = "계층명" ;
				cell_value[2] = "계층정의" ;
				cell_value[3] = "주요역할" ;
			}
			 
			
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "직무관리 목록");
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
							case 0: if(map.get("JOBLDR_NUM")!=null) tmp = map.get("JOBLDR_NUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("JOBLDR_NAME")!=null) tmp = map.get("JOBLDR_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("JOBLDR_COMMENT")!=null) tmp = map.get("JOBLDR_COMMENT"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("MAIN_TASK")!=null) tmp = map.get("MAIN_TASK"); else tmp = "";  cell.setCellStyle(style2); break;
							case 4: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = "";  cell.setCellStyle(style2); break;
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
				if(k==2)sheet.setColumnWidth((short)k, (short)20000);
				if(k==3)sheet.setColumnWidth((short)k, (short)20000);
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
			if(jobFlag.equals("J")) 
				{	
					this.targetAttachmentFileName = "직무 리스트.xls";
				}else if(jobFlag.equals("L")){
					this.targetAttachmentFileName = "계층 리스트.xls";
				}
			
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}
	
	public String jobExcelUpload() {	 	
		String jobFlag = ParamUtils.getParameter(request, "jobFlag");
	
		this.saveCount = baSrv.jobLdrExcelSaveService(getUser(),jobFlag, request);		
		return success();
	}
	
	/**
	 * 
	 * 총괄관리자 정보 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 8.
	 */
	public String getMpvaAdminInfo() throws Exception{
		List<Map<String,Object>> list = baSrv.queryForList("BA.GET_MPVAADMIN_INFO", new Object[]{}, new int[] {});
		
		List<Map<String,Object>> tmpList = new ArrayList<Map<String,Object>>();

		log.debug("### list:"+list.size());
		if(list!=null && list.size()>0){
			for(Map<String, Object> map : list){
				if(map.get("PHONE")!=null){
					map.put("PHONE", CommonUtils.ASEDecoding(map.get("PHONE").toString()));						
				}
				if(map.get("EMAIL")!=null){
					map.put("EMAIL", CommonUtils.ASEDecoding(map.get("EMAIL").toString()));
				}
				tmpList.add(map);
			}
			log.debug("### tmpList:"+tmpList.size());
		}
		this.items = tmpList;
		return success();
	}
	
	/**
	 * 
	 * 총괄관리자 정보 저장<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 3.
	 */
	public String saveMpvaAdmin() throws Exception {
		log.debug("============================================== ");
		log.debug(CommonUtils.printParameter(request));
		log.debug("============================================== ");
		
		Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		String cstm_id = (String)map.get("CSTM_ID");
		
		long userid = Long.parseLong((String)map.get("USERID"));
		String empno = (String)map.get("EMPNO");
		String name = (String)map.get("NAME");
		String phone = (String)map.get("PHONE");
		String email = (String)map.get("EMAIL");
		
		log.debug("@@@userid:"+userid);
		log.debug("@@@empno:"+empno);
		log.debug("@@@name:"+name);
		log.debug("@@@phone:"+phone);
		log.debug("@@@email:"+email);
		
		String incPhone = CommonUtils.ASEEncoding(phone);
		String incEmail = CommonUtils.ASEEncoding(email);
		
		log.debug("@@@incPhone:"+incPhone);
		log.debug("@@@incEmail:"+incEmail);
		Object [] obj = {
				name, empno, incPhone, incEmail, userid
		};
		int [] types = {
				Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC
		};
		this.saveCount = baSrv.update("BA.UPDATE_MPVAADMIN", obj, types);
		return success();
	}
	
	/**
	 * 
	 * 총괄관리자 비번 변경.<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 6. 25.
	 */
	public String saveMpvaAdminPwd() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		// 총괄관리자 정보
		long userId = 1;
		String returnVal = "X";
		int saveCount = 0;
		String newPwd = ParamUtils.getParameter(request, "NEW_PWD");
		
		String incNewPwd = CommonUtils.passwdEncoding(newPwd);
		log.debug("## incNewPwd:"+incNewPwd);
		saveCount = baSrv.update("BA.UPDATE_PWD", new Object[]{incNewPwd, userId}, new int[]{ Types.VARCHAR, Types.NUMERIC });
		
		if(saveCount>0){
			returnVal = "Y";
		}else{
			returnVal = "N";
		}
		
		this.statement = returnVal;
		return success();
	}
}