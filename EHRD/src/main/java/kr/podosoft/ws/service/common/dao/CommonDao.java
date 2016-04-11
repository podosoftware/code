package kr.podosoft.ws.service.common.dao;

import java.io.InputStream;
import java.sql.Blob;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.common.Filter;

public interface CommonDao {
	
	public Blob getImgData(String fileNum, String fileSeq) throws CommonException;
	
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws CommonException;
	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	public List<Map<String,Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws CommonException;
	public List<Map<String,Object>> dynamicQueryForList(String statement, int startIndex, int pageSize, String sortFilter, String sortDir, String defaultSort, Filter filter, Object[] params, int[] jdbcTypes, Map map) throws CommonException;
	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws CommonException;
	
	
	public List<Map<String,Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws CommonException;
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws CommonException;

	
	/* 파일등록 */
	public long getMaxFileNum() throws CommonException;
	public int insertFile(long companyId, long fileNum, String fileName, long fileSize, InputStream file, String contentType, long userId) throws CommonException;
}