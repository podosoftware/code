package kr.podosoft.ws.service.kpi;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import architecture.common.user.User;

public interface KPIService {

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType) throws  KPIException;
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws KPIException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws KPIException;
	public int update(String statement, Object[] params, int[] jdbcTypes, Map map) throws KPIException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws KPIException;
	public int saveKpiUser( HttpServletRequest  request, User user) throws KPIException;
	public int kpiUserMapExcelSave(User user, HttpServletRequest request);
	public int infoMailSend(User user, String runNum, List<Map<String, Object>> list) throws KPIException;
	public int saveUserPrf( HttpServletRequest  request, User user) throws KPIException;
	public int saveApprReqUser( HttpServletRequest  request, User user) throws KPIException;
	public int saveDeptUserPrf( HttpServletRequest  request, User user) throws KPIException;
	public int saveTtEvl( HttpServletRequest  request, User user) throws KPIException;
	public int encourageMailSend(User user, String runName,
			List<Map<String, Object>> list) throws KPIException;
	public int servMailSend(User user, String ppNo,
			List<Map<String, Object>> list)throws KPIException;
	
}
