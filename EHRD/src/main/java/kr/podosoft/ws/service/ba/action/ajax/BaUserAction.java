package kr.podosoft.ws.service.ba.action.ajax;

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

import kr.podosoft.ws.service.ba.BaUserService;
import kr.podosoft.ws.service.cdp.CdpService;
import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.utils.CommonUtils;

import architecture.ee.util.ApplicationHelper;
import architecture.ee.web.attachment.FileInfo;
import architecture.ee.web.struts2.action.UploadAttachmentAction;
import architecture.ee.web.util.ParamUtils;

public class BaUserAction  extends UploadAttachmentAction   {

	private static final long serialVersionUID = 2767313942420614982L;

	private int pageSize = 15 ;
    private int startIndex = 0;  
    
    private CdpService cdpService;
    
    public CdpService getCdpService() {
		return cdpService;
	}

	public void setCdpService(CdpService cdpService) {
		this.cdpService = cdpService;
	}


	private String sortField;
    private String sortDir;
    private Filter filter;
    
    public Filter getFilter() {
		return filter;
	}

	public void setFilter(Filter filter) {
		this.filter = filter;
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


	private int totalItemCount = 0;

	private int saveCount = 0;
    
	private List items;
	
	private List<Map<String,Object>> items2;
	
	public List<Map<String, Object>> getItems2() {
		return items2;
	}

	public void setItems2(List<Map<String, Object>> items2) {
		this.items2 = items2;
	}


	private String statement ; 
	
	private BaUserService baUserSrv;
	
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
	
	public BaUserService getBaUserSrv() {
		return baUserSrv;
	}

	public void setBaUserSrv(BaUserService baUserSrv) {
		this.baUserSrv = baUserSrv;
	}
	
	public int getSaveCount() {
		return saveCount;
	}
	
	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
	}

	/**
	 * 사용자 목록
	 * @return
	 * @throws Exception
	 */
	public String getUserList () throws Exception {
		
		log.debug(CommonUtils.printParameter(request));
		
		// 서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		this.totalItemCount =  baUserSrv.getTotalUserCount(getUser().getCompanyId());
		
		Map map =  new HashMap();
		
		
		//this.items = baUserSrv.getUserList(getUser().getCompanyId());
		
		Object[] params = {getUser().getCompanyId(),getUser().getCompanyId(),getUser().getCompanyId(),getUser().getCompanyId()};
		
		int[] jdbcTypes = { Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC };
		
		this.items2 = cdpService.dynamicQueryForList("BA_USER.USER-MGMT-SELECT-ALL", startIndex, pageSize, sortField, sortDir, "", filter, params, jdbcTypes, map);
		
		this.items = this.items2;
		
		if(this.items2 !=null && this.items.size()>0){
			this.totalItemCount = Integer.parseInt(this.items2.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		log.debug("####### complete");
		
		return success();
	}
	
	/**
	 * 사용자정보 상세
	 * @return
	 * @throws Exception
	 */
	public String getMgmtUserInfo() throws Exception {
		
		int userid = ParamUtils.getIntParameter(request, "userid", 0);
		
		this.items = baUserSrv.getMgmtUserInfo(getUser().getCompanyId(), userid);
		
		return success();
	}

	/**
	 * 사용자정보 변경
	 * @return
	 * @throws Exception
	 */
	public String updateUser() throws Exception {
		Map map = ParamUtils.getJsonParameter(request, "item", Map.class);
		
		saveCount = baUserSrv.updateUser(map, getUser());
		
		return success();
	}
	
	/**
	 * 비밀번호 변경
	 * @return
	 * @throws Exception
	 */
	public String updateUserPassword()throws Exception {
		Map map = ParamUtils.getJsonParameter(request, "item", Map.class);			
		baUserSrv.updateUserPassword(map, getUser());	
		return success();
	}
	
	/**
	 * 사용자 교직원번호 중복체크
	 * @return
	 * @throws Exception
	 */
	public String getChkId() throws Exception {
		String tmpId = ParamUtils.getParameter(request, "tmpId");
		
		if(tmpId!=null && !tmpId.trim().equals("")) {
			statement = baUserSrv.queryForObject("BA_USER.SELECT_CHK_USER_ID", new Object[] {tmpId, getUser().getCompanyId()}, new int[] {Types.VARCHAR, Types.NUMERIC}, String.class).toString();
		} else {
			statement = "N";
		}
		
		return success();
	}
	
	/**
	 * 사용자 중복체크
	 * @return
	 * @throws Exception
	 */
	public String getChkUser() throws Exception {
		
		String tmpNm = ParamUtils.getStringParameter(request, "tmpNm",""); // 성명
		String tmpPhn = ParamUtils.getStringParameter(request, "tmpPhn",""); // 핸드폰
		
		if(!tmpNm.trim().equals("") && !tmpPhn.trim().equals("")) {
			
			statement = baUserSrv.chkUser(getUser().getCompanyId(), tmpNm, tmpPhn);
			
		} else {
			statement = "N";
		}
		
		return success();
	}
	
	/**
	 * 해당 고객사가 가지는 그룹목록
	 * @return
	 * @throws Exception
	 */
	public String getGroupList() throws Exception {
		
		items = baUserSrv.getGroups(getUser().getCompanyId());
		totalItemCount = items.size();
		
		return success();
	}
	
	/**
	 * 사용자에게 부여한 그룹목록
	 * @return
	 * @throws Exception
	 */
	public String getUserSetGroupList() throws Exception {
		String userId = ParamUtils.getParameter(request, "userId");
		
		items = baUserSrv.getUserGroups(getUser().getCompanyId(), userId);
		totalItemCount = items.size();
		
		return success();
	}
	
	/**
	 * 사용자에게 그룹부여/삭제
	 * @return
	 * @throws Exception
	 */
	public String setUserGroup() throws Exception {
		String userId = ParamUtils.getParameter(request, "userId");
		String groupId = ParamUtils.getParameter(request, "groupId");
		String eduManagerFlag = ParamUtils.getParameter(request, "eduManager");
		String divisionid = ParamUtils.getParameter(request, "divisionid");
		List<Map<String,Object>> items = ParamUtils.getJsonParameter(request, "items", List.class); 
		
		log.debug("###### eduManagerFlag : "+eduManagerFlag+" / divisionid : "+divisionid);
		
		statement = baUserSrv.setUserGroups(getUser().getCompanyId(), userId, items, eduManagerFlag, divisionid, getUser().getUserId());
		
		return success();
	}

	
	
	public String getUserInfo() throws Exception {
		
		items = baUserSrv.getUserInfo(getUser().getCompanyId(), getUser().getUserId());
		
		return success();
	}
	
	
	public String setUserImg() throws Exception {
		
		int userid = ParamUtils.getIntParameter(request, "userid", 0);
		if(userid<1) {
			userid = (int)getUser().getUserId();
		}
		List<FileInfo> fileList = getAttachmentFileInfos();
		
		statement = baUserSrv.setUserImg(userid, fileList);
		
		items = baUserSrv.getUserImg(userid);
		
		return success();
	}
	
	/**
	 * 학생의 취업경쟁령지수공개여부 변경 
	 * @return
	 * @throws Exception
	 */
	public String setUserInfoSdVisible() throws Exception {
		int sdVisible = ParamUtils.getIntParameter(request, "sdVisible", 0);
		
		statement = baUserSrv.setUserInfoSdVisible(getUser().getUserId(), sdVisible);
		
		return success();
	}
	
	
	/**
	 * 조직목록
	 * @return
	 * @throws Exception
	 */
	public String getUserDeptList() throws Exception {
		
		items = baUserSrv.getUserDeptList(getUser().getCompanyId());
		
		return success();
		
	}
	
	
	
	/**
	 * 직무 콤보박스 조회
	 * @return
	 * @throws Exception
	 */
	public String getUserJobList() throws Exception {
		String jobLdrFlag = ParamUtils.getParameter(request, "JOBLDRFLAG");
		
		items = baUserSrv.getUserJobList(getUser().getCompanyId(),jobLdrFlag);
		
		return success();
		
	}
	
	/**
	 * 리더쉽 콤보박스 조회
	 * @return
	 * @throws Exception
	 */
	public String getUserLdrList() throws Exception {
		String jobLdrFlag = ParamUtils.getParameter(request, "JOBLDRFLAG");
		
		items = baUserSrv.getUserLdrList(getUser().getCompanyId(),jobLdrFlag);
		
		return success();
		
	}
	
	/**
	 * 사용자관리 엑셀 다운로드 
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 2.
	 */
	@SuppressWarnings("deprecation")
	public String getUserListExcel() throws Exception{
		//사용자관리 목록 조회
		this.items = baUserSrv.getUserList(getUser().getCompanyId());
		
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
					"순번", "교직원번호", "성명", "핸드폰", "연락처", "부서", "부서번호", "직무", "직무번호", "계급", "계급번호", "이메일", "직급", "직렬","재직상태","사용여부","사용자번호"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "사용자 목록");
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
							case 0:  if(map.get("RNUM")!=null) tmp = map.get("RNUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1:  if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2:  if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = "";  cell.setCellStyle(style2); break;                         
							case 3:  if(map.get("CELLPHONE")!=null) tmp = map.get("CELLPHONE"); else tmp = "";  cell.setCellStyle(style2); break;               
							case 4:  if(map.get("PHONE")!=null) tmp = map.get("PHONE"); else tmp = ""; cell.setCellStyle(style2); break;                        
							case 5:  if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;                  
							case 6:  if(map.get("DIVISIONID")!=null) tmp = map.get("DIVISIONID"); else tmp = "";  cell.setCellStyle(style2); break;             
							case 7:  if(map.get("JOB_NAME")!=null) tmp = map.get("JOB_NAME"); else tmp = "";  cell.setCellStyle(style2); break;                 
							case 8:  if(map.get("JOB")!=null) tmp = map.get("JOB"); else tmp = "";  cell.setCellStyle(style2); break;                           
							case 9:  if(map.get("LEADERSHIP_NAME")!=null) tmp = map.get("LEADERSHIP_NAME"); else tmp = "";  cell.setCellStyle(style2); break;   
							case 10: if(map.get("LEADERSHIP")!=null) tmp = map.get("LEADERSHIP"); else tmp = "";  cell.setCellStyle(style2); break;             
							case 11: if(map.get("EMAIL")!=null) tmp = map.get("EMAIL"); else tmp = "";  cell.setCellStyle(style2); break;                       
							case 12: if(map.get("GRADE_NM")!=null) tmp = map.get("GRADE_NM"); else tmp = "";  cell.setCellStyle(style2); break;        
							case 13: if(map.get("GRADE_DIV_NM")!=null) tmp = map.get("GRADE_DIV_NM"); else tmp = "";  cell.setCellStyle(style2); break;                
							case 14: if(map.get("EMP_STS_CD_NM")!=null) tmp = map.get("EMP_STS_CD_NM"); else tmp = "";  cell.setCellStyle(style2); break;       
							case 15: if(map.get("USEFLAG")!=null) tmp = map.get("USEFLAG"); else tmp = "";  cell.setCellStyle(style2); break;  							
							case 16: if(map.get("USERID")!=null) tmp = map.get("USERID"); else tmp = "";  cell.setCellStyle(style2); break;  							
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
				if(k==6)sheet.setColumnWidth((short)k, (short)4000);
				if(k==7)sheet.setColumnWidth((short)k, (short)4000);
				if(k==8)sheet.setColumnWidth((short)k, (short)4000);
				if(k==9)sheet.setColumnWidth((short)k, (short)4000);
				if(k==10)sheet.setColumnWidth((short)k, (short)4000);
				if(k==11)sheet.setColumnWidth((short)k, (short)10000);
				if(k==12)sheet.setColumnWidth((short)k, (short)4000);
				if(k==13)sheet.setColumnWidth((short)k, (short)4000);
				if(k==14)sheet.setColumnWidth((short)k, (short)4000);
				if(k==15)sheet.setColumnWidth((short)k, (short)4000);
				if(k==16)sheet.setColumnWidth((short)k, (short)4000);
				
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
			this.targetAttachmentFileName = "사용자목록.xls";
			
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
	 * 사용자관리 엑셀 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 4. 2.
	 */
	public String setUserListExcelUpload() throws Exception{
		this.saveCount = baUserSrv.setUserListExcelUpload(getUser(), request);		
		return success();
	}
	
	/**
	 * 
	 * 과정관리 - 과정 엑셀 업로드<br/>
	 *
	 * @return
	 * @since 2014. 12. 2.
	 */
	public String upLoadUserListExcel() throws Exception{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		this.statement = baUserSrv.userExcelUpload(getUser(), request);
		return success();
	}		
	
}
