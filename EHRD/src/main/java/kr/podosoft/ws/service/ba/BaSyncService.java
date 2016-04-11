package kr.podosoft.ws.service.ba;

import java.util.List;
import java.util.Map;

public interface BaSyncService {
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public List<Map<String,Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException;

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException;

	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws BaException;
	
	/**
	 * 공통 > 동기화 관리 - 동기화실행
	 * @param companyId
	 * @param userId
	 * @param syncCode 동기화유형
	 * @return
	 * @throws BaException
	 */
	public Map<String,String> runSync(long companyId, long userId, String syncCode) throws BaException;


	/* 스케쥴링 동기화용 : 부서정보 */
	public void autoDeptSync() throws BaException;
	/* 스케쥴링 동기화용 : 직급정보 */
	public void autoGradeSync() throws BaException;
	/* 스케쥴링 동기화용 : 사용자정보 */
	public void autoUserSync() throws BaException;
	

	
}
