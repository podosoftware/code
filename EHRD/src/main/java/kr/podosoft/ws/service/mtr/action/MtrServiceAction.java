package kr.podosoft.ws.service.mtr.action;

import java.sql.Types;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.cdp.CdpService;
import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.mtr.MtrException;
import kr.podosoft.ws.service.mtr.MtrService;
import kr.podosoft.ws.service.utils.CommonUtils;
import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;


public class MtrServiceAction extends FrameworkActionSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private int pageSize = 15 ;
	
    private int startIndex = 0 ;
    
    private String sortField;
    
	private String sortDir;
    
    private Filter filter;
    
    
     
    private int totalItemCount = 0;
     
	private int year = 0;
	
	private int saveCount = 0 ;  
	
	private List items;
	
	private List items1;
	
	private List items2;	
	
	private String statement ;

	private List<Map<String,Object>> items3;

	private MtrService mtrService;
	
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
	public List<Map<String, Object>> getItems3() {
		return items3;
	}

	public void setItems3(List<Map<String, Object>> items3) {
		this.items3 = items3;
	}

	public MtrService getMtrService() {
		return mtrService;
	}

	public void setMtrService(MtrService MtrService) {
		this.mtrService = MtrService;
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
	
	
	
	/**
	 * 
	 * 멘토링 목록 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 11. 03.
	 */
	public String getMtrRunListPg(){
		return success();
	}
	/**
	 * 
	 * 멘토링승인 목록 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 11. 04.
	 */
	public String getMtrRunAppListPg(){
		return success();
	}
	/**
	 * 
	 * 멘토링관리 목록 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 11. 04.
	 */
	public String getMtrRunAdminListPg(){
		return success();
	}
	
	/**
	 * 
	 * 멘토링승인 목록 년도.<br/>
	 *
	 * @return
	 * @since 2014. 11. 04.
	 */
	public String getMtrYearList() throws MtrException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getCompanyId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC
		};
		this.items = mtrService.queryForList("MTR.GET_MTR_YEAR_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();
	}
	/**
	 * 
	 * 멘토링 리스트 목록 화면으로 이동.<br/>
	 *
	 * @return
	 * @since 2014. 11. 04.
	 */
	public String getMtrRunList() throws MtrException{
		log.debug(CommonUtils.printParameter(request));
		Object [] params = {
				getUser().getUserId(),
				getUser().getUserId(),
				getUser().getUserId(),
				getUser().getCompanyId(),
				getUser().getUserId(),
				getUser().getUserId()
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC,Types.NUMERIC,Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		};
		this.items = mtrService.queryForList("MTR.GET_MTR_RUN_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();
	}
	/**
	 * 
	 * 멘토링 승인 리스트.<br/>
	 *
	 * @return
	 * @since 2014. 11. 04.
	 */
	public String getMtrRunAppList() throws Exception{
		log.debug(CommonUtils.printParameter(request));
/*		Object [] params = {
				getUser().getUserId(),
				getUser().getCompanyId(),
				getUser().getUserId(),
		}; 
		int[] jdbcTypes = { Types.NUMERIC, Types.NUMERIC, Types.NUMERIC};
		this.items = mtrService.queryForList("MTR.GET_MTR_RUN_APP_LIST", params, jdbcTypes);*/
		
		Map<String, Object>  map = new HashMap<String, Object>();
		
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		this.items3 = cdpService.dynamicQueryForList("MTR.GET_MTR_RUN_APP_LIST", startIndex, pageSize, sortField, sortDir, "MY_REQ_STS_NM DESC,MTR_ST_DT", filter, new Object[]{getUser().getCompanyId(),getUser().getUserId()}, new int []{ Types.NUMERIC, Types.NUMERIC},map);
		
		//서버 paging
		if(this.items3 !=null && this.items3.size()>0){
			this.totalItemCount = Integer.parseInt(this.items3.get(0).get("TOTALITEMCOUNT").toString());
		}


		return success();
	}
	
	/**
	 * 
	 * 멘토링 관리 리스트.<br/>
	 *
	 * @return
	 * @since 2014. 11. 04.
	 */
	public String getMtrRunAdminList() throws Exception{
		log.debug(CommonUtils.printParameter(request));

		long companyid = getUser().getCompanyId();
		long userid = getUser().getUserId();
		long mtrReqDivCd = 5;
		
		String divisionStr = "";
		if(request.isUserInRole("ROLE_SYSTEM")){ //총괄관리자
			//조건 없이 모두 조회..
			divisionStr = " AND A.COMPANYID = "+companyid+"";
		}else if(request.isUserInRole("ROLE_OPERATOR")){ //교육담당자
			//담당하는 부서(하위 포함)에 해당하는 사용자
			divisionStr = " AND A.COMPANYID = "+companyid+" AND C.DIVISIONID IN (SELECT DIVISIONID FROM TB_BA_DIVISION_EDU_MGR WHERE COMPANYID = "+companyid+" AND USERID = "+userid+" AND USEFLAG = 'Y') ";
		}
		else{ //직원
			//소속부서(하위 포함)의 사용자
			divisionStr = " AND A.COMPANYID = NULL";
		}
		Map<String, Object>  map = new HashMap<String, Object>();
		map.put("DIVISION_STR", divisionStr);
		
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		this.items3 = cdpService.dynamicQueryForList("MTR.GET_MTR_RUN_ADMIN_LIST", startIndex, pageSize, sortField, sortDir, "HRD_ADMIN_NM", filter, new Object[]{mtrReqDivCd}, new int []{Types.NUMERIC},map);
		
		//서버 paging
		if(this.items3 !=null && this.items3.size()>0){
			this.totalItemCount = Integer.parseInt(this.items3.get(0).get("TOTALITEMCOUNT").toString());
		}
		
		return success();
	}
	
	/**
	 * 
	 * 멘토링 멘티 리스트.<br/>
	 *
	 * @return
	 * @since 2014. 11. 04.
	 */
	public String getMtrMenteeList() throws MtrException{
		log.debug(CommonUtils.printParameter(request));
		String mtr_seq = ParamUtils.getParameter(request, "MTR_SEQ");
		Object [] params = {
				getUser().getCompanyId(),
				mtr_seq
				
		}; 
		int[] jdbcTypes = {
				Types.NUMERIC, Types.VARCHAR
		};
		this.items = mtrService.queryForList("MTR.GET_MTR_MENTEE_LIST", params, jdbcTypes);
		this.totalItemCount = items.size();
		return success();
	}
	/**
	 * 
	 * 멘토링 - 생성요청<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 04.
	 */
	public String saveMyMtr() throws MtrException {
		log.debug(CommonUtils.printParameter(request));
		this.saveCount = mtrService.saveMyMtr(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 멘토링 승인- 승인처리 저장<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 04.
	 */
	public String saveAppMtr() throws MtrException {
		log.debug(CommonUtils.printParameter(request));
		this.saveCount = mtrService.saveAppMtr(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 멘토링 관리- 최종 승인 처리 저장<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 04.
	 */
	public String saveLastAppMtr() throws MtrException {
		log.debug(CommonUtils.printParameter(request));
		this.saveCount = mtrService.saveLastAppMtr(request, getUser());
		return success();
	}

	/**
	 * 
	 * 멘토링승인-미승인 처리 저장 <br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 05.
	 */
	public String saveNotAppMtr() throws MtrException {
		log.debug(CommonUtils.printParameter(request));
		this.saveCount = mtrService.saveNotAppMtr(request, getUser());
		return success();
	}
	
	
	
	/**
	 * 
	 * 멘토링 - 날짜 수정<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 04.
	 */
	public String modifyMyMtr() throws MtrException {
		log.debug(CommonUtils.printParameter(request));
		this.saveCount = mtrService.modifyMyMtr(request, getUser());
		return success();
	}
	
	/**
	 * 
	 * 공통 - 임직원 목록 조회<br/>
	 *
	 * @return
	 * @throws Exception
	 * @since 2014. 11. 04.
	 */
		public String getEmployeelist() throws Exception {

			if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

			long companyid = getUser().getCompanyId();
			long userid = getUser().getUserId();
			
			String divisionStr = "";
			if(request.isUserInRole("ROLE_SYSTEM")){ //총괄관리자
				//조건 없이 모두 조회..
				divisionStr = " AND A.COMPANYID = "+companyid+"";
			}else if(request.isUserInRole("ROLE_OPERATOR")){ //교육담당자
				//담당하는 부서(하위 포함)에 해당하는 사용자
				divisionStr = " AND A.COMPANYID = "+companyid+" AND A.DIVISIONID IN (SELECT DIVISIONID FROM TB_BA_DIVISION_EDU_MGR WHERE COMPANYID = "+companyid+" AND USERID = "+userid+" AND USEFLAG = 'Y') ";
			}else if(request.isUserInRole("ROLE_MANAGER")){ //부서장
				//담당하는 부서(하위 포함)에 해당하는 사용자
				divisionStr = "AND A.COMPANYID = "+companyid+" AND B.HIGH_DVSID IN ( SELECT HIGH_DVSID FROM TB_BA_DIVISION WHERE COMPANYID = "+companyid+" AND DIVISIONID = '"+getUser().getProfile().get("DIVISIONID")+"')";
			}
			else{ //직원
				//소속부서(하위 포함)의 사용자
				divisionStr = " AND A.COMPANYID = "+companyid+" AND A.DIVISIONID = '"+getUser().getProfile().get("DIVISIONID")+"' "; 
			}
			Map<String, Object>  map = new HashMap<String, Object>();
			map.put("DIVISION_STR", divisionStr);

			filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
			
			this.items3 = cdpService.dynamicQueryForList("MTR.SELECT_EMPOLYEE_LIST", startIndex, pageSize, sortField, sortDir, "NAME", filter, new Object[]{companyid}, new int []{Types.NUMERIC},map);
			
			if(this.items3 !=null && this.items3.size()>0){
				this.totalItemCount = Integer.parseInt(this.items3.get(0).get("TOTALITEMCOUNT").toString());
			}
			
			return success();
		}
		
		/**
		 * 
		 * 공통 - 임직원 목록 조회<br/>
		 *
		 * @return
		 * @throws Exception
		 * @since 2014. 11. 04.
		 */
			public String getGradeNamelist() throws Exception {

				if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));

				long companyid = getUser().getCompanyId();
				long userid = getUser().getUserId();
				
				String divisionStr = "";
				
				Map<String, Object>  map = new HashMap<String, Object>();
				map.put("DIVISION_STR", divisionStr);

				filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
				
				this.items3 = cdpService.dynamicQueryForList("MTR.SELECT_GRADE_NM_LIST", startIndex, pageSize, sortField, sortDir, "COMMONCODE", filter, new Object[]{companyid}, new int []{Types.NUMERIC},map);
				
				if(this.items3 !=null && this.items3.size()>0){
					this.totalItemCount = Integer.parseInt(this.items3.get(0).get("TOTALITEMCOUNT").toString());
				}
				
				return success();
			}
		
		/**
		 * 
		 * 멘토링 승인 - 멘토링 삭제<br/>
		 *
		 * @return
		 * @throws Exception
		 * @since 2014. 11. 04.
		 */
		public String deleteMyMtr() throws MtrException {
			log.debug(CommonUtils.printParameter(request));
			this.saveCount = mtrService.deleteMyMtr(request, getUser());
			return success();
		}
	
}