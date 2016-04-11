package kr.podosoft.ws.service.ba.action.admin;

import java.sql.Types;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaSyncService;
import kr.podosoft.ws.service.cdp.CdpService;
import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.utils.CommonUtils;

import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

public class BaSyncAction extends FrameworkActionSupport {

	private static final long serialVersionUID = 2709815906565200461L;
	
	//그리드의 페이지, 정렬, 필터 parameter
	private int pageSize = 15 ;
    private int startIndex = 0 ;  
    private String sortField;
    private String sortDir;
    private Filter filter;
    
	private int syear = 0;
    private int smonth = 0;
    private String syncType;
	private String syncSdate;
	private String syncEdate;
    
    private List<Map<String,Object>> items;
	private List<Map<String,Object>> items2;
	private List<Map<String,Object>> items3;
	
	private int totalItemCount = 0;
	private int totalItem2Count = 0;
	private int totalItem3Count = 0;

	private String statement;
	private String msg;
	
	private BaSyncService baSyncSrv;
	private CdpService cdpService;

	public CdpService getCdpService() {
		return cdpService;
	}

	public void setCdpService(CdpService cdpService) {
		this.cdpService = cdpService;
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

	public String getSyncType() {
		return syncType;
	}

	public void setSyncType(String syncType) {
		this.syncType = syncType;
	}

	public String getSyncSdate() {
		return syncSdate;
	}

	public void setSyncSdate(String syncSdate) {
		this.syncSdate = syncSdate;
	}

	public String getSyncEdate() {
		return syncEdate;
	}

	public void setSyncEdate(String syncEdate) {
		this.syncEdate = syncEdate;
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

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public BaSyncService getBaSyncSrv() {
		return baSyncSrv;
	}

	public void setBaSyncSrv(BaSyncService baSyncSrv) {
		this.baSyncSrv = baSyncSrv;
	}

	public int getSyear() {
		return syear;
	}

	public void setSyear(int syear) {
		this.syear = syear;
	}

	public int getSmonth() {
		return smonth;
	}

	public void setSmonth(int smonth) {
		this.smonth = smonth;
	}

	/* ******************************************************************************* */
	
	/**
	 * 동기화이력 조회
	 * @return
	 * @throws Exception
	 */
	public String getSyncJobList() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		
		Map map =  new HashMap();
		//서버 paging
		filter = ParamUtils.getJsonParameter(request, "filter", Filter.class);
		
		this.items = cdpService.dynamicQueryForList("BA_SYNC.SELECT_SYNC_LIST", startIndex, pageSize, sortField, sortDir, "SYNC_DTIME DESC", filter, new Object[]{ getUser().getCompanyId() }, new int[]{ Types.INTEGER }, map);
		if(this.items !=null && this.items.size()>0){
			this.totalItemCount = Integer.parseInt(this.items.get(0).get("TOTALITEMCOUNT").toString());
		}
		return success();
	}
	
	/**
	 * 동기화실행
	 * @return
	 * @throws Exception
	 */
	public String execSyncJob() throws Exception {
		if( log.isDebugEnabled() ) log.debug(CommonUtils.printParameter(request));
		/*
		 * 1 : 부서정보
		 * 2 : 사용자정보
		 * 3 : 직급정보
		 */
		String syncCode = ParamUtils.getParameter(request, "syncCode");
		
		if(syncCode!=null) {
			Map<String,String> rsltMap = new HashMap<String, String>();
			
			rsltMap = baSyncSrv.runSync(getUser().getCompanyId(), getUser().getUserId(), syncCode);
			
			msg = rsltMap.get("msg");
			statement = rsltMap.get("statement");
		} else {
			msg = "진행할 동기화유형이 없습니다.";
			statement = "N";
		}
		
		return success();
	}
	

}
