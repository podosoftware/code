package kr.podosoft.ws.service.car;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import architecture.common.user.User;

public interface CarService {
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CarException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CarException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CarException;
	public List<Map<String, Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws CarException;

	public String getUserDivisionList(HttpServletRequest  request, User user, String tableAlias);
	public int changeAssmStatus(HttpServletRequest  request, User user) throws  CarException;
	
	/**
	 * 진단실시현황 독려메일 발송
	 * @param user
	 * @param runNum
	 * @param runName
	 * @param userArr
	 * @return
	 * @throws CAException
	 */
	public int encourageMailSend(User user, String runNum, String runName, String[] userArr, String type) throws CarException;
	
	/**
	 * 진단실시현황 독려SMS 발송
	 * @param user
	 * @param runName
	 * @param userArr
	 * @return
	 * @throws CAException
	 */
	public int encourageSmsSend(User user, String runName, String[] userArr, String type) throws CarException;
}
