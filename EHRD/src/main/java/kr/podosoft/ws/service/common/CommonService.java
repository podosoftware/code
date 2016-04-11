package kr.podosoft.ws.service.common;

import java.sql.Blob;
import java.util.List;
import java.util.Map;

public interface CommonService {

	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CommonException;
	public List<Map<String, Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws CommonException;
	public List<Map<String, Object>> dynamicQueryForList(String statement, int startIndex, int pageSize, String sortFilter, String sortDir, String defaultSort, Filter filter, Object[] params, int[] jdbcTypes, Map map) throws CommonException;
	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws CommonException;
	
	/* 공통-이미지파일정보 */
	public Map<String,Object> getImgFileInfo(String fileNum, String fileSeq) throws CommonException;
	/* 공통-섬네일이미지보기 */
	public Blob getImgFileData(String fileNum, String fileSeq) throws CommonException;	
}