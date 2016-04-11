package kr.podosoft.ws.service.kpi.action.ajax;

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
import kr.podosoft.ws.service.kpi.KPIException;
import kr.podosoft.ws.service.kpi.KPIService;
import kr.podosoft.ws.service.utils.CommonUtils;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.Region;

import architecture.ee.util.ApplicationHelper;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

public class KPIMgmtAction extends FrameworkActionSupport{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -7815438745441951898L;

	private int totalItemCount = 0;

	private int saveCount = 0 ;  
	
	private int year = 0;

	private List items;
	
	private List items1;
	
	private List items2;	
	
	private String statement ; 
	
	private KPIService kpiService;
	
	private String targetAttachmentContentType = "";
	
	private int targetAttachmentContentLength = 0;
	
	private InputStream targetAttachmentInputStream = null;
	
	private String targetAttachmentFileName = "";

	
	public int getTotalItemCount() {
		return totalItemCount;
	}

	public void setTotalItemCount(int totalItemCount) {
		this.totalItemCount = totalItemCount;
	}

	public int getSaveCount() {
		return saveCount;
	}

	public void setSaveCount(int saveCount) {
		this.saveCount = saveCount;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
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

	public String getStatement() {
		return statement;
	}

	public void setStatement(String statement) {
		this.statement = statement;
	}

	public KPIService getKpiService() {
		return kpiService;
	}

	public void setKpiService(KPIService kpiService) {
		this.kpiService = kpiService;
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
	
	
	/**
	 * 
	 * 직원별 KPI관리 페이지 이동<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getKpiListPage() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.GET_EVL_YEAR_LIST", new Object[]{"2", companyid}, new int[]{Types.VARCHAR, Types.NUMERIC});
		return success();
	}
	
	/**
	 * 
	 * 직원별 KPI 관리 성과평가 목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getKpiRunList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.GET_KPI_RUN_LIST", new Object[]{companyid}, new int[]{Types.NUMERIC} );
		return success();
	}
	
	/**
	 * 
	 * 직원별 KPI 관리 사용자 목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getKpiUserList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		if(runNum == 0){
			List list = kpiService.queryForList("KPI.GET_KPI_RUN_LIST", new Object[]{companyid}, new int[]{Types.NUMERIC});
			if(list!=null && list.size()>0){
				Map map = (Map)list.get(0);
				runNum = Integer.parseInt(map.get("RUN_NUM").toString());
			}
		}
		
		this.items = kpiService.queryForList("KPI.GET_KPI_USER_LIST", new Object[]{companyid, runNum, companyid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		this.totalItemCount = items.size();
		return success();
	}
	

	/**
	 * 
	 * 직원별 KPI 관리 사용자 KPI 매핑 목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getKpiUserMapList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		this.items = kpiService.queryForList("KPI.GET_KPI_USER_MAP_LIST", new Object[]{companyid, tgUserid, runNum}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		this.totalItemCount = items.size();
		return success();
	}

	/**
	 * 
	 * 고객사의 사용되는 모든 kpi 지표 목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getKpiUseList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.GET_KPI_USE_LIST", new Object[]{ companyid }, new int[]{ Types.NUMERIC });
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 * 고객사의 사용되는 모든 kpi 지표 목록과 개인이 등록한 KPI목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getKpiUserUseList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		this.items = kpiService.queryForList("KPI.GET_KPI_USER_USE_LIST", new Object[]{ companyid, companyid, userid }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC  });
		this.totalItemCount = items.size();
		return success();
	}

	/**
	 * 
	 * 직원 kpi 지표 추가<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String addKpiUserMap() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		int kpiNo = Integer.parseInt(ParamUtils.getParameter(request, "KPI_NO"));
		
		Map map = new HashMap();
        map.put("TAG_WHERE_STR", " AND USERID = "+tgUserid+" ");
         
		this.saveCount = kpiService.update("KPI.MERGE_TB_CAM_RUNTARGET_I", new Object[]{runNum, userid, companyid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}, map);
		this.saveCount += kpiService.update("KPI.MERGE_TB_KPI_USER_MAP", new Object[]{runNum, tgUserid, userid, "1", companyid, kpiNo}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC});
		return success();
	}

	/**
	 * 
	 * 사용자 kpi 지표 추가<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String addKpiSelfUserMap() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		int kpiNo = Integer.parseInt(ParamUtils.getParameter(request, "KPI_NO"));
		
		Map map = new HashMap();
        map.put("TAG_WHERE_STR", " AND USERID = "+tgUserid+" ");
         
		this.saveCount = kpiService.update("KPI.MERGE_TB_CAM_RUNTARGET_I", new Object[]{runNum, userid, companyid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}, map);
		this.saveCount += kpiService.update("KPI.MERGE_TB_KPI_USER_MAP", new Object[]{runNum, tgUserid, userid, "2", companyid, kpiNo}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC});
		return success();
	}
	
	/**
	 * 
	 * 직원 kpi 세팅 제거<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String delKpiUserMap() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		int kpiNo = Integer.parseInt(ParamUtils.getParameter(request, "KPI_NO"));
		
		
		this.saveCount = kpiService.update("KPI.USE_N_TB_KPI_USER_MAP", 
				new Object[]{companyid, runNum, tgUserid, kpiNo, userid, companyid, runNum, tgUserid, companyid, runNum, tgUserid, companyid, runNum, tgUserid}, 
				new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}
		);
		
		return success();
	}
	
	/**
	 * 
	 * 부서원  kpi 세팅 제거 - 사용여부 처리<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String delKpiDeptUserMap() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		int kpiNo = Integer.parseInt(ParamUtils.getParameter(request, "KPI_NO"));
		
		this.saveCount = kpiService.update("KPI.USE_N_TB_KPI_DEPT_USER_MAP", 
				new Object[]{companyid, runNum, tgUserid, kpiNo}, 
				new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}
		);
		
		return success();
	}

	/**
	 * 
	 * 직원 kpi 세팅<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String saveKpiUser() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		this.saveCount = kpiService.saveKpiUser(request, getUser());
		return success();
	}

	/**
	 * 
	 * 직원 kpi 관리 - 설정된 지표 초기화<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String initKpiUser() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		this.saveCount = kpiService.update("KPI.INIT_USER_KPI_MAPPING", new Object[]{userid, companyid, runNum, tgUserid, userid, companyid, runNum, tgUserid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		return success();
	}

	/**
	 * 
	 * 직원 kpi 관리 엑셀 다운로드<br/>
	 *
	 * @return
	 * @throws KPIException 
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getkpiUserMapListExcel() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		this.items = kpiService.queryForList("KPI.USER_KPI_MAPPING_EXCEL", new Object[]{companyid, runNum}, new int[]{Types.NUMERIC, Types.NUMERIC} );
		
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
					"사번", "성명", "지표번호", "지표유형", "지표명", "전기실적", "당기목표", "당기실적", "우선순위"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "지표 설정");
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
							case 0: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("KPI_NO")!=null) tmp = map.get("KPI_NO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("KPI_TYPE_NM")!=null) tmp = map.get("KPI_TYPE_NM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("KPI_NM")!=null) tmp = map.get("KPI_NM"); else tmp = "";  cell.setCellStyle(style2); break;
							case 5: if(map.get("BEF_PRF")!=null) tmp = map.get("BEF_PRF"); else tmp = ""; cell.setCellStyle(style2); break;
							case 6: if(map.get("NOW_TARG")!=null) tmp = map.get("NOW_TARG"); else tmp = ""; break;
							case 7: if(map.get("NOW_PRF")!=null) tmp = map.get("NOW_PRF"); else tmp = ""; break;
							case 8: if(map.get("PRIO")!=null) tmp = map.get("PRIO"); else tmp = ""; break;
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
				if(k==4)sheet.setColumnWidth((short)k, (short)10000);
				if(k==5)sheet.setColumnWidth((short)k, (short)3000);
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
			this.targetAttachmentFileName = "직원별KPI설정목록.xls";
			
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
	 * 직원 kpi 관리 excel 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @return
	 * @since 2014. 3. 19.
	 */
	public String kpiUserMapExcelUpload() {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		this.saveCount = kpiService.kpiUserMapExcelSave(getUser(), request);
		return success();
	}
	
	/**
	 * 
	 * 직원정보 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getUserInfo() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		this.items = kpiService.queryForList("KPI.SELECT_USER_INFO", new Object[]{ companyid, tgUserid }, new int[]{ Types.NUMERIC, Types.NUMERIC  });
		return success();
	}
	
	/**
	 * 
	 * 안내 메일 발송<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 5. 1.
	 */
	public String infoMailSend() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
	    String runNum= ParamUtils.getParameter(request, "RUN_NUM");	
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		
		this.saveCount = kpiService.infoMailSend(getUser(), runNum, list);
		
		return success();
	} 
	
	
	public String encourageMailSend() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
	    String runName = ParamUtils.getParameter(request, "RUN_NAME");	
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		
		 
		this.saveCount = kpiService.encourageMailSend(getUser(), runName, list);
		
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
	public String servMailSend() throws KPIException{
		log.debug(CommonUtils.printParameter(request));
		
	    String ppNo= ParamUtils.getParameter(request, "PP_NO");	
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		
		this.saveCount = kpiService.servMailSend(getUser(), ppNo, list);
		
		return success();
	
	}
	

	/**
	 * 
	 * 종합평가 -  평가년도 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getTtYearList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.GET_TT_YEAR_LIST", new Object[]{companyid}, new int[]{Types.NUMERIC} );
		return success();
	}
	
	/**
	 * 
	 * 종합평가 -  평가목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getTtRunList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.GET_TT_RUN_LIST", new Object[]{companyid}, new int[]{Types.NUMERIC} );
		return success();
	}

	/**
	 * 
	 * 종합평가 -  평가 구성 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getTtRunSetInfo() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String ttEvlNo =ParamUtils.getParameter(request, "TT_EVL_NO");
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.GET_TT_RUN_SET_INFO", new Object[]{companyid, ttEvlNo}, new int[]{Types.NUMERIC, Types.VARCHAR} );
		return success();
	}

	/**
	 * 
	 * 종합평가 -  평가 결과 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getTtRunResult() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String runNum =ParamUtils.getParameter(request, "TT_EVL_NO");
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.GET_TT_RUN_RESULT", new Object[]{companyid, runNum}, new int[]{Types.NUMERIC, Types.VARCHAR} );
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 * 종합평가- 공개 설정<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 5. 1.
	 */
	public String saveTtPublic() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
	    String evnNo= ParamUtils.getParameter(request, "TT_EVL_NO");	
		this.saveCount = kpiService.update("KPI.SAVE_TT_EVL_PUBLIC", new Object[]{userid, companyid, evnNo}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
		
		return success();
	} 

	/**
	 * 
	 * 종합평가- 평가 삭제<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 5. 1.
	 */
	public String delTtPublic() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
	    String evnNo= ParamUtils.getParameter(request, "TT_EVL_NO");	
		this.saveCount = kpiService.update("KPI.DEL_TT_EVL_PUBLIC", new Object[]{userid, companyid, evnNo}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
		
		return success();
	}
	
	/**
	 * 
	 * 종합평가 - 엑셀 다운로드<br/>
	 *
	 * @return
	 * @throws KPIException 
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getTtRunResultExcelDown() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		long companyid = getUser().getCompanyId();
		int ttEvlNo = Integer.parseInt(ParamUtils.getParameter(request, "TT_EVL_NO"));
		//종합평가 결과
		this.items = kpiService.queryForList("KPI.GET_TT_RUN_RESULT", new Object[]{companyid, ttEvlNo}, new int[]{Types.NUMERIC, Types.NUMERIC} );
		//종합평가 구성
		this.items1 = kpiService.queryForList("KPI.GET_TT_RUN_SET_INFO", new Object[]{companyid, ttEvlNo}, new int[]{Types.NUMERIC, Types.VARCHAR} );
		
		String ttEvlNm = "";
		try {
			
			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet sheet = null;
			HSSFRow row = null;
			HSSFCell cell = null;
	
			HSSFFont font = workbook.createFont();
			font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
	
			HSSFCellStyle style = workbook.createCellStyle();
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setFont(font);
			style.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle style1 = workbook.createCellStyle();
			style1.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			style1.setFont(font);
			style1.setFillForegroundColor(HSSFColor.TAN.index);
				
			HSSFCellStyle styleC = workbook.createCellStyle();
			styleC.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			styleC.setFillForegroundColor(HSSFColor.TAN.index);
			
			HSSFCellStyle styleL = workbook.createCellStyle();
			styleL.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			styleL.setFillForegroundColor(HSSFColor.TAN.index);
	
	
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "종합평가");
			row = sheet.createRow(0);
	
			if(items1!=null && items1.size()>0){
				Map tMap = (Map)items1.get(0);
				
				ttEvlNm = tMap.get("TT_EVL_NM").toString();
				//0라인 종합평가명. 병합가운데정렬
				cell = row.createCell((short)0);
				cell.setCellValue(ttEvlNm);
				sheet.addMergedRegion(new Region(0,(short)0, 0,(short)9));
				cell.setCellStyle(style);
				
				//1라인 평가생성일. 병합가운데정렬
				row = sheet.createRow(1);
				cell = row.createCell((short)0);
				cell.setCellValue("평가생성일 : "+tMap.get("CREATETIME").toString());
				sheet.addMergedRegion(new Region(1,(short)0, 1,(short)9));
				cell.setCellStyle(style1);

				//2라인 평가대상자. 병합가운데정렬
				row = sheet.createRow(2);
				cell = row.createCell((short)0);
				cell.setCellValue("평가대상자 : "+tMap.get("EVL_TARG_CNT").toString()+"명");
				sheet.addMergedRegion(new Region(2,(short)0, 2,(short)9));
				cell.setCellStyle(style1);

				//3라인 성과-1. 병합가운데정렬
				row = sheet.createRow(3);
				cell = row.createCell((short)0);
				cell.setCellValue("성과-1 : "+tMap.get("OTC1").toString());
				sheet.addMergedRegion(new Region(3,(short)0, 3,(short)9));
				cell.setCellStyle(style1);

				//4라인 역량-1. 병합가운데정렬
				row = sheet.createRow(4);
				cell = row.createCell((short)0);
				cell.setCellValue("역량-1 : "+tMap.get("CMPT1").toString());
				sheet.addMergedRegion(new Region(4,(short)0, 4,(short)9));
				cell.setCellStyle(style1);

				//5라인 성과-2. 병합가운데정렬
				row = sheet.createRow(5);
				cell = row.createCell((short)0);
				cell.setCellValue("성과-2 : "+tMap.get("OTC2").toString());
				sheet.addMergedRegion(new Region(5,(short)0, 5,(short)9));
				cell.setCellStyle(style1);

				//6라인 역량-2 . 병합가운데정렬
				row = sheet.createRow(6);
				cell = row.createCell((short)0);
				cell.setCellValue("역량-2 : "+tMap.get("CMPT2").toString());
				sheet.addMergedRegion(new Region(6,(short)0, 6,(short)9));
				cell.setCellStyle(style1);

				//7라인 공백 . 병합가운데정렬
				row = sheet.createRow(7);
				cell = row.createCell((short)0);
				cell.setCellValue("");
				sheet.addMergedRegion(new Region(7,(short)0, 7,(short)9));
				cell.setCellStyle(style1);
				
				String[] cell_value = {
					"부서", "성명", "사번", "직무", "계층", "종합평가", "성과-1(가중치)", "역량-1(가중치)", "성과-2(가중치)", "역량-2(가중치)"
				};
				
				row = sheet.createRow(8);
				for(int k=0; k<cell_value.length; k++) {
					cell = row.createCell((short)k);
					cell.setCellValue(cell_value[k]);
					cell.setCellStyle(style);
				}
		
				int i = 9;
				if(this.items!=null && this.items.size()>0) {
					for( Iterator iter = this.items.iterator(); iter.hasNext();) {
						Map map = (Map)iter.next();
						row = sheet.createRow(i++);
		
						for(int k=0; k<cell_value.length; k++) {
							cell = row.createCell((short)k);
		
							Object tmp = new Object();
							
							switch(k) {
								case 0: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
								case 1: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(styleL); break;
								case 2: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(styleL); break;
								case 3: if(map.get("JOB_NM")!=null) tmp = map.get("JOB_NM"); else tmp = ""; cell.setCellStyle(styleL); break;
								case 4: if(map.get("LEADERSHIP_NM")!=null) tmp = map.get("LEADERSHIP_NM"); else tmp = "";  cell.setCellStyle(styleL); break;
								case 5: if(map.get("TT_SCO")!=null) tmp = map.get("TT_SCO"); else tmp = ""; cell.setCellStyle(styleC); break;
								case 6: if(map.get("OTC1_SCO")!=null) tmp = map.get("OTC1_SCO"); else tmp = ""; cell.setCellStyle(styleC); break;
								case 7: if(map.get("CMPT1_SCO")!=null) tmp = map.get("CMPT1_SCO"); else tmp = ""; cell.setCellStyle(styleC); break;
								case 8: if(map.get("OTC2_SCO")!=null) tmp = map.get("OTC2_SCO"); else tmp = ""; cell.setCellStyle(styleC); break;
								case 9: if(map.get("CMPT2_SCO")!=null) tmp = map.get("CMPT2_SCO"); else tmp = ""; cell.setCellStyle(styleC); break;
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
					if(k==1)sheet.setColumnWidth((short)k, (short)3000);
					if(k==2)sheet.setColumnWidth((short)k, (short)3000);
					if(k==3)sheet.setColumnWidth((short)k, (short)4000);
					if(k==4)sheet.setColumnWidth((short)k, (short)4000);
					if(k==5)sheet.setColumnWidth((short)k, (short)3000);
					if(k==6)sheet.setColumnWidth((short)k, (short)3750);
					if(k==7)sheet.setColumnWidth((short)k, (short)3750);
					if(k==8)sheet.setColumnWidth((short)k, (short)3750);
					if(k==9)sheet.setColumnWidth((short)k, (short)3750);
				}
			}else{
				//0라인 종합평가명. 병합가운데정렬
				cell = row.createCell((short)0);
				cell.setCellValue("종합평가 정보가 존재하지 않습니다.");
				sheet.addMergedRegion(new Region(0,(short)0, 0,(short)9));
				cell.setCellStyle(style);
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
			this.targetAttachmentFileName = ttEvlNm+".xls";
			
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
	 * 종합평가 -  년간 평가목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getTtYearRunList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String yyyy =ParamUtils.getParameter(request, "YYYY");
		
		long companyid = getUser().getCompanyId();
		List<Map<String, Object>> list = kpiService.queryForList("KPI.SELECT_YEAR_RUN_LIST", new Object[]{companyid, yyyy}, new int[]{Types.NUMERIC, Types.VARCHAR} );
		if(list!=null && list.size()>0){
			for(Map<String, Object> row: list){
				Map<String, String> map = new HashMap<String, String>();
				map.put("WEI_APL_TARG", "");
				map.put("WEI_APL_TARG_NM", "선택");
				
				row.put("WEI_APL_TARG", map);
			}
		}
		this.items = list;
		return success();
	}

	/**
	 * 
	 * 종합평가 -  평가 대상 직원 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getTtUserList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.SELECT_TT_USER_LIST", new Object[]{companyid}, new int[]{Types.NUMERIC} );
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 * 종합평가- 신규생성<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 5. 1.
	 */
	public String saveTtEvl() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		this.saveCount = kpiService.saveTtEvl(request, getUser());
		
		return success();
	}
	

	/**
	 * 
	 * 직무별고성과자 -  결과 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getJobHighUser() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		String jobNum = ParamUtils.getParameter(request, "JOB_NUM");
		long companyid = getUser().getCompanyId();

		this.items = kpiService.queryForList("KPI.GET_JOB_HIGH_USER_LIST", new Object[]{ companyid, jobNum, companyid, yyyy }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR } );
		this.totalItemCount = items.size();
		return success();
	}
	
	
	/**
	 * 
	 * 직무별고성과자 -  결과 엑셀 다운로드<br/>
	 *
	 * @return
	 * @throws KPIException 
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getJobHighUserExcelDown() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		long companyid = getUser().getCompanyId();
		String yyyy = ParamUtils.getParameter(request, "yyyy");
		String jobNum = ParamUtils.getParameter(request, "JOB_NUM");
		String jobName = ParamUtils.getParameter(request, "JOB_NAME");
	
		this.items = kpiService.queryForList("KPI.GET_JOB_HIGH_USER_LIST", new Object[]{ companyid, jobNum, companyid, yyyy }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR } );
		
		String ttEvlNm = "";
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
					"번호", "부서", "사번", "성명", "현직무", "점수", "신뢰도"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "직무별고성과자");
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
							case 0: if(map.get("RNUM")!=null) tmp = map.get("RNUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("DVS_NAME")!=null) tmp = map.get("DVS_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("EMPNO")!=null) tmp = map.get("EMPNO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("NAME")!=null) tmp = map.get("NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("JOBLDR_NAME")!=null) tmp = map.get("JOBLDR_NAME"); else tmp = "";  cell.setCellStyle(style2); break;
							case 5: if(map.get("KPI_SCORE")!=null) tmp = map.get("KPI_SCORE"); else tmp = ""; cell.setCellStyle(style2); break;
							case 6: if(map.get("T_SCORE")!=null) tmp = map.get("T_SCORE"); else tmp = ""; break;
						}
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
					}
				}
			}
			

			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)3000);
				if(k==1)sheet.setColumnWidth((short)k, (short)6000);
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
				if(k==3)sheet.setColumnWidth((short)k, (short)4000);
				if(k==4)sheet.setColumnWidth((short)k, (short)6000);
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
			this.targetAttachmentFileName = "직무별고성과자("+jobName+").xls";
			
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
	 * 직원별 직무적합도 -  결과 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getUserJobSuit() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String yyyy = ParamUtils.getParameter(request, "YYYY");
		String userid = ParamUtils.getParameter(request, "USERID");
		long companyid = getUser().getCompanyId();

		this.items = kpiService.queryForList("KPI.GET_USER_JOB_SUIT_LIST", new Object[]{ companyid, yyyy, userid }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC } );
		this.totalItemCount = items.size();
		return success();
	}	
	
	/**
	 * 
	 * 사용자검색<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getTargetUserList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();

		this.items = kpiService.queryForList("KPI.GET_TARGET_USER_LIST", new Object[]{ companyid }, new int[]{ Types.NUMERIC } );
		this.totalItemCount = items.size();
		return success();
	}	
	
	/**
	 * 
	 * 직원별직무적합도 -  결과 엑셀 다운로드<br/>
	 *
	 * @return
	 * @throws KPIException 
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getUserJobSuitExcel() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		String yyyy = ParamUtils.getParameter(request, "YYYY");
		String userid = ParamUtils.getParameter(request, "userid");
		String name = ParamUtils.getParameter(request, "userNm");
		long companyid = getUser().getCompanyId();

		this.items = kpiService.queryForList("KPI.GET_USER_JOB_SUIT_LIST", new Object[]{ companyid, yyyy, userid }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC } );
		
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
					"순위", "직무명", "적합도점수", "신뢰도", "현직무여부"
			};
			
			sheet = workbook.createSheet();
			workbook.setSheetName(0 , "직원별 직무적합도");
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
							case 0: if(map.get("RNUM")!=null) tmp = map.get("RNUM"); else tmp = ""; cell.setCellStyle(style2); break;
							case 1: if(map.get("JOBLDR_NAME")!=null) tmp = map.get("JOBLDR_NAME"); else tmp = ""; cell.setCellStyle(style2); break;
							case 2: if(map.get("EVL_SCO")!=null) tmp = map.get("EVL_SCO"); else tmp = ""; cell.setCellStyle(style2); break;
							case 3: if(map.get("T_SCORE")!=null) tmp = map.get("T_SCORE"); else tmp = ""; cell.setCellStyle(style2); break;
							case 4: if(map.get("EFLAG")!=null) tmp = map.get("EFLAG"); else tmp = "";  cell.setCellStyle(style2); break;
						}
						
						if ( tmp instanceof BigDecimal ) {
				            cell.setCellValue( ((BigDecimal)tmp).toString() );
						} else {
							cell.setCellValue((String)tmp);
						}
					}
				}
			}
			

			for (int k=0; k<cell_value.length; k++) {
				if(k==0)sheet.setColumnWidth((short)k, (short)3000);
				if(k==1)sheet.setColumnWidth((short)k, (short)6000);
				if(k==2)sheet.setColumnWidth((short)k, (short)4000);
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
			this.targetAttachmentFileName = "직원별직무적합도("+name+").xls";
			
			log.debug("파일타입 : " + this.targetAttachmentContentType);
			log.debug("파일길이 : " + this.targetAttachmentContentLength+"");
			log.debug("파일내용 : " + this.targetAttachmentInputStream.toString());
			log.debug("파일이름 : " + this.targetAttachmentFileName);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return success();
	}
	
	
}
