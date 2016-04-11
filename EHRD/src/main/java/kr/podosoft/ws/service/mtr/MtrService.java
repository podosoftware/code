package kr.podosoft.ws.service.mtr;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import architecture.common.user.User;

public interface MtrService {
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws MtrException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws MtrException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws MtrException;
	public List<Map<String, Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws MtrException;

	public int saveMyMtr(HttpServletRequest  request, User user) throws MtrException;
	public int saveAppMtr(HttpServletRequest  request, User user) throws MtrException;
	public int saveLastAppMtr(HttpServletRequest  request, User user) throws MtrException;
	public int modifyMyMtr(HttpServletRequest  request, User user) throws MtrException;
	public int saveNotAppMtr(HttpServletRequest  request, User user) throws MtrException;
	public int deleteMyMtr(HttpServletRequest  request, User user) throws MtrException;
}
