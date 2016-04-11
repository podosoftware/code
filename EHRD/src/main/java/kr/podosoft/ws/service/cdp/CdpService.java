package kr.podosoft.ws.service.cdp;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.common.Filter;

import architecture.common.user.User;

public interface CdpService {
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CdpException;

	public int update(String statement, Object[] params, int[] jdbcTypes) throws CdpException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CdpException;

	public int saveMyCdp(HttpServletRequest  request, User user) throws CdpException;
	public int cancelApprReq(HttpServletRequest  request, User user) throws CdpException;
	public int cdpPlanApprReq(HttpServletRequest  request, User user) throws CdpException; //승인처리
	
	public List<Map<String, Object>> dynamicQueryForList(String string, Object[] params, int[] jdbcTypes, Map<String, Object> map) throws CdpException;
	public List<Map<String, Object>> dynamicQueryForList(String statement, int startIndex, int pageSize, String sortFilter, String sortDir, String defaultSort, Filter filter, Object[] params, int[] jdbcTypes, Map map) throws CdpException;
}
