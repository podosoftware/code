package kr.podosoft.ws.service.kpi.action.ajax;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
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
import org.apache.poi.ss.util.Region;

import kr.podosoft.ws.service.kpi.KPIException;
import kr.podosoft.ws.service.kpi.KPIService;
import kr.podosoft.ws.service.utils.CommonUtils;
import architecture.ee.util.ApplicationHelper;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

public class KPIServiceAction extends FrameworkActionSupport{
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2199947026026179661L;

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
	 *  성과관리 페이지 이동<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getOtcPage() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		//년도 목록
		this.items = kpiService.queryForList("KPI.GET_OTC_YEAR_LIST", new Object[]{companyid, userid}, new int[]{Types.VARCHAR, Types.NUMERIC});
		//지표유형 공통코드 조회
		this.items1 = kpiService.queryForList("KPI.GET_COMMON_CODE_LIST", new Object[]{"C106", companyid}, new int[]{Types.VARCHAR, Types.NUMERIC});
		
		return success();
	}
	
	/**
	 * 
	 * 성과관리 - 성과평가 목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getOtcRunList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		this.items = kpiService.queryForList("KPI.GET_USER_OTC_RUN_LIST", new Object[]{companyid, userid}, new int[]{Types.NUMERIC, Types.NUMERIC} );
		return success();
	}
	
	/**
	 * 
	 * 성과관리 - 성과평가 현 상태 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getOtcEvlUserSts() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		this.statement = kpiService.queryForObject("KPI.GET_RUN_EVL_STS", new Object[]{companyid, runNum, tgUserid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}, String.class).toString();
		return success();
	}
	
	/**
	 * 
	 * 성과관리 - KPI 매핑 목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getOtcUserMapList() throws KPIException{
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
	 * 부서원 성과관리 - KPI 매핑 목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getOtcDeptUserMapList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		
		this.items = kpiService.queryForList("KPI.GET_KPI_DEPT_USER_MAP_LIST", new Object[]{companyid, tgUserid, runNum}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 * 성과관리 - 월별 실적 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getMonthPrfList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));
		int kpiNo = Integer.parseInt(ParamUtils.getParameter(request, "KPI_NO"));
		
		this.items = kpiService.queryForList("KPI.GET_MONTH_PRF_LIST", new Object[]{companyid, runNum, tgUserid, kpiNo, companyid, runNum, tgUserid, kpiNo}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC} );
		return success();
	}
	
	/**
	 * 
	 * 성과관리 - 실적 등록<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String saveUserPrf() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		this.saveCount = kpiService.saveUserPrf(request, getUser());
		return success();
	}
	
	
	/**
	 * 
	 * 성과관리 실적 승인요청.. <br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String saveApprReqUser() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		this.saveCount = kpiService.saveApprReqUser(request, getUser());
		return success();
	}
	
	/**
	 * 
	 *  부서원성과평가 - 관리유형 평균인 지표 중에서 실적 등록 안한 지표 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String chkOtcAvgUser() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID"));

		this.items = kpiService.queryForList("KPI.GET_OTC_AVG_NO_REG_LIST", new Object[]{companyid, runNum, companyid, companyid, runNum, tgUserid, companyid, runNum, tgUserid}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		return success();
	}
	
	/**
	 * 
	 *  부서원성과평가 - 페이지 이동<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getDeptOtcPage() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();

		//년도 목록
		this.items = kpiService.queryForList("KPI.GET_DEPT_OTC_YEAR_LIST", new Object[]{companyid}, new int[]{ Types.NUMERIC });
		return success();
	}
	
	/**
	 * 
	 * 부서원성과평가 - 성과평가 목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getDeptOtcRunList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		
		this.items = kpiService.queryForList("KPI.GET_DEPT_USER_OTC_RUN_LIST", new Object[]{ companyid }, new int[]{ Types.NUMERIC } );
		return success();
	}
	
	/**
	 * 
	 * 부서원성과평가 - 평가별 대상자 목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getDeptOtcUserList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long userid = getUser().getUserId();
		long companyid = getUser().getCompanyId();
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		
		this.items = kpiService.queryForList("KPI.GET_DEPT_USER_OTC_LIST", new Object[]{companyid, runNum, userid, companyid, companyid, userid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		this.totalItemCount = items.size();
		return success();
	}

	/**
	 * 
	 *  부서원성과평가 - 성과관리 페이지 이동<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getDeptOtcInfoPage() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		int tgUserid = Integer.parseInt(ParamUtils.getParameter(request, "TG_USERID", "0"));
		
		//평가 기본정보 조회
		this.items = kpiService.queryForList("KPI.GET_DEPT_RUN_INFO", new Object[]{companyid, runNum}, new int[]{Types.VARCHAR, Types.NUMERIC});
		//지표유형 공통코드 조회
		this.items1 = kpiService.queryForList("KPI.GET_COMMON_CODE_LIST", new Object[]{"C106", companyid}, new int[]{Types.VARCHAR, Types.NUMERIC});
		//피평가자정보 조회
		this.items2 = kpiService.queryForList("EVL.GET_USER_EXED_INFO", new Object[]{tgUserid}, new int[]{Types.NUMERIC});
		
		return success();
	}

	/**
	 * 
	 * 부서원성과평가 - 실적 등록<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String saveDeptUserPrf() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		this.saveCount = kpiService.saveDeptUserPrf(request, getUser());
		return success();
	}
	

	/**
	 * 
	 * 부서원종합평가 -  평가년도 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getDeptTtYearList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.GET_DEPT_TT_YEAR_LIST", new Object[]{companyid}, new int[]{Types.NUMERIC} );
		return success();
	}
	
	/**
	 * 
	 * 부서원종합평가 -  평가목록 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getDeptTtRunList() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.GET_DEPT_TT_RUN_LIST", new Object[]{companyid}, new int[]{Types.NUMERIC} );
		return success();
	}

	/**
	 * 
	 * 부서원종합평가 -  평가 구성 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getDeptTtRunSetInfo() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String ttEvlNo =ParamUtils.getParameter(request, "TT_EVL_NO");
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.GET_TT_RUN_SET_INFO", new Object[]{companyid, ttEvlNo}, new int[]{Types.NUMERIC, Types.VARCHAR} );
		return success();
	}

	/**
	 * 
	 * 부서원종합평가 -  평가 결과 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getDeptTtRunResult() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String runNum =ParamUtils.getParameter(request, "TT_EVL_NO");
		
		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		this.items = kpiService.queryForList("KPI.GET_DEPT_TT_RUN_RESULT", new Object[]{companyid, runNum, companyid, companyid, userid}, new int[]{Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC} );
		this.totalItemCount = items.size();
		return success();
	}
	
	/**
	 * 
	 * 부서원종합평가 - 엑셀 다운로드<br/>
	 *
	 * @return
	 * @throws KPIException 
	 * @since 2014. 3. 19.
	 */
	@SuppressWarnings("deprecation")
	public String getDeptTtRunResultExcelDown() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		
		int ttEvlNo = Integer.parseInt(ParamUtils.getParameter(request, "TT_EVL_NO"));
		//종합평가 결과
		this.items = kpiService.queryForList("KPI.GET_DEPT_TT_RUN_RESULT", new Object[]{companyid, ttEvlNo, companyid, companyid, userid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC} );
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
	 * 성과관리 - 지표별 산식 조회<br/>
	 *
	 * @return
	 * @throws KPIException
	 * @since 2014. 4. 24.
	 */
	public String getOtcArithCfsInfo() throws KPIException{
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		String kpiNo =ParamUtils.getParameter(request, "KPI_NO");
		
		long companyid = getUser().getCompanyId();
		this.items = kpiService.queryForList("KPI.SELECT_KPI_ARITH_CFS_INFO", new Object[]{companyid, kpiNo}, new int[]{Types.NUMERIC, Types.NUMERIC} );
		return success();
	}
	
	
	
}
