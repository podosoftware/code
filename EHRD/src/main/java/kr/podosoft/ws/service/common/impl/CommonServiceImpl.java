package kr.podosoft.ws.service.common.impl;

import java.sql.Blob;
import java.sql.Types;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.common.CommonService;
import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.common.dao.CommonDao;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

public class CommonServiceImpl implements CommonService {
	
	private Log log = LogFactory.getLog(getClass());
	
	private CommonDao commonDao;
	
	public CommonDao getCommonDao() {
		return commonDao;
	}
	public void setCommonDao(CommonDao commonDao) {
		this.commonDao = commonDao;
	}

	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws CommonException {
		return commonDao.queryForInteger(statement, params, jdbcTypes);
	}
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws CommonException {
		return commonDao.queryForObject(statement, params, jdbcTypes, cls); 
	}
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CommonException {
		return commonDao.queryForList(statement, params, jdbcTypes);
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CommonException.class )
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CommonException {
		int retVal = 0;
		try{
			retVal = commonDao.update(statement, params, jdbcTypes);
		}catch(CommonException e){
			throw new CommonException(e);
		}
		return retVal;
	}
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CommonException { 
		return commonDao.excute(statement, params, jdbcTypes);
	}
	public List<Map<String, Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws CommonException {
		return commonDao.dynamicQueryForList(statement, params, jdbcTypes, map);
	}

	public List<Map<String, Object>> dynamicQueryForList(String statement, int startIndex, int pageSize, String sortFilter, String sortDir, String defaultSort, Filter filter, Object[] params, int[] jdbcTypes, Map map) throws CommonException {
		return commonDao.dynamicQueryForList(statement, startIndex, pageSize, sortFilter, sortDir, defaultSort, filter, params, jdbcTypes, map);
	}
	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws CommonException {
		return commonDao.batchUpdate(statement, parameteres, jdbcTypes);
	}
	
	/* 공통-이미지파일정보 */
	public Map<String,Object> getImgFileInfo(String fileNum, String fileSeq) throws CommonException {
		Map<String,Object> map = new HashMap<String, Object>();
		
		try {
			List<Map<String,Object>> list = commonDao.queryForList("COMMON.SELECT_IMG_INFO", new Object[] {fileNum, fileSeq}, new int[] {Types.VARCHAR, Types.INTEGER});
			
			if(!list.isEmpty() && list.size()>0) {
				map = list.get(0);
			}
		} catch(Throwable e) {
			log.error(e);
		}
		
		return map;
	}
	
	/* 공통-섬네일이미지보기 */
	public Blob getImgFileData(String fileNum, String fileSeq) throws CommonException {
		try {
			return commonDao.getImgData(fileNum, fileNum);
		} catch(Throwable e) {
			log.error(e);
			return null;
		}
	}
	

	

}