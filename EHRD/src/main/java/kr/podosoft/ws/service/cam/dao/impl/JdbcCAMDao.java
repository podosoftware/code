package kr.podosoft.ws.service.cam.dao.impl;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.cam.CAMException;
import kr.podosoft.ws.service.cam.dao.CAMDao;
import architecture.ee.jdbc.sqlquery.SqlQuery;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;

public class JdbcCAMDao  extends SqlQueryDaoSupport implements CAMDao  {
	

	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CAMException  {
		List<Map<String, Object>> list = Collections.EMPTY_LIST;
		try {
			if(params!=null) {
				list = getSqlQuery().queryForList(statement, params, jdbcTypes);
			} else {
				list = getSqlQuery().queryForList(statement);
			}
		} catch(Throwable e) {
			log.error(e);
		}
		return list;
	}
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CAMException  {
		return getSqlQuery().update(statement, params, jdbcTypes);
	}
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CAMException {
		return getSqlQuery().executeUpdate(statement, params);
	}
	

	/**
	 * 
	 * 역량성장도 <br/>
	 *
	 * @param companyid
	 * @param tgUserid
	 * @param list
	 * @return
	 * @since 2014. 4. 23.
	 */
	public List getCmptEvlGrow(long companyid, long tgUserid, List list){
		SqlQuery query = getSqlQuery();
		String selectString = "";
		String fromString = "";
		String whereString = "";
		
		for(int i=0; i<list.size(); i++){
			Map map = (Map)list.get(i);
			
			selectString += " , B"+i+".SCORE*20 SCORE_B"+i;
			fromString +=
				" ,( "+
		        " SELECT COMPANYID, RUN_NUM, CMPNUMBER, SCORE \n"+
		        " FROM TB_CAR_EXED_CMPT_SCORE \n"+
		        " WHERE COMPANYID = "+companyid+" AND USERID_EXED = "+tgUserid+" AND CMPNUMBER = "+map.get("CMPNUMBER")+"\n"+
		        "    AND USEFLAG = 'Y' \n"+
		        " ) B"+i+"\n";
			whereString += "    AND B.COMPANYID = B"+i+".COMPANYID(+) AND B.RUN_NUM = B"+i+".RUN_NUM(+) \n";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("QUERY_SELECT", selectString);
		map.put("QUERY_FROM", fromString);
		map.put("QUERY_WHERE", whereString);
		
		query.setAdditionalParameters(map);
		return query.list("EVL.GET_EVL_GROW_ANALYSIS_LIST", companyid, tgUserid, tgUserid);
	}
	
	
	
}