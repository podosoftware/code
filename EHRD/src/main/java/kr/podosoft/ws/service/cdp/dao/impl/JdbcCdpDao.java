package kr.podosoft.ws.service.cdp.dao.impl;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.cdp.CdpException;
import kr.podosoft.ws.service.cdp.dao.CdpDao;
import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.common.Filters;
import architecture.ee.jdbc.sqlquery.SqlQuery;
import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;


public class JdbcCdpDao  extends SqlQueryDaoSupport implements CdpDao  {
	
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws CdpException  {
		Object obj = null;
		try {
			if(params!=null) {
				obj = getSqlQuery().queryForObject(statement, params, jdbcTypes, cls );
			} else {
				obj = getSqlQuery().queryForObject(statement, cls);
			}
		} catch(Throwable e) {
			log.error(e);
		}
		return obj;
	}
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws CdpException{
		if(params!=null) {
			return getSqlQuery().queryForObject(statement, params, jdbcTypes, Integer.class);
		} else {
			return getSqlQuery().queryForObject(statement, Integer.class);
			
		}		
	}
	
	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws CdpException{
		
		SqlQueryHelper helper = new SqlQueryHelper();
		
		for(Object[] params : parameteres) {
			helper.parameters(params, jdbcTypes).inqueue();
		}
		
		return helper.executeBatchUpdate(getSqlQuery(), statement);		
	}
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CdpException  {
		List<Map<String, Object>> list = Collections.emptyList();
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
	
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CdpException  {
		return getSqlQuery().update(statement, params, jdbcTypes);
	}
	
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CdpException {
		return getSqlQuery().executeUpdate(statement, params);
	}
	
	public List<Map<String, Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map<String, Object> map) throws CdpException  {
		List<Map<String, Object>> list = Collections.emptyList();
		try {
			SqlQuery query = getSqlQuery();
			query.setAdditionalParameters(map);
			if(params!=null) {
				list = query.queryForList(statement, params, jdbcTypes);
			} else {
				list = query.queryForList(statement);
			}
		} catch(Throwable e) {
			log.error(e);
		}
		return list;
	}

	public List<Map<String, Object>> dynamicQueryForList(String statement, int startIndex, int pageSize, String sortFilter, String sortDir, String defaultSort, Filter filter, Object[] params, int[] jdbcTypes, Map<String, Object> map) throws CdpException  {
		List<Map<String, Object>> list = Collections.emptyList();
		try {
			SqlQuery query = getSqlQuery();
			query.setStartIndex(startIndex);
			query.setMaxResults(pageSize);
			
			String sortSql = "";
			if(sortFilter!=null && !sortFilter.equals("")){
				sortSql = " ORDER BY "+sortFilter+" "+sortDir;
			}else{
				if(defaultSort!=null && !defaultSort.equals("")){
					sortSql = " ORDER BY "+defaultSort;
				}else{
					sortSql = "";
				}
				
			}
			log.debug("##### sortSql:"+sortSql);
			map.put("GRID_ORDERBY_CLAUSE", sortSql);
			
			String filterSql = "";
			if(filter!=null && filter.getFilters().size() > 0){
				String value = "";
				String operator = "";
				String field = "";
				
				for(Filters filters:filter.getFilters()){
					log.debug("Field:"+filters.getField()+" Operator:"+filters.getOperator()+" Value:"+filters.getValue());
					field = filters.getField();
					
					field = filters.getField();
					operator = filters.getOperator();
					value = filters.getValue();
					
					filterSql += " " + filter.getLogic() + " ";
					
					if (operator.equals("lte")) {
		            	filterSql += field + " <= " + value;
		            } else if (operator.equals("gte")) {
		            	filterSql += field + " >= " + value;
		            } else if (operator.equals("startswith")) {
		            	if(field.indexOf("_DATE")>-1){
		            		filterSql += " TO_CHAR(" + field + ", 'YYYY-MM-DD') LIKE '" + value + "%' ";
		            	}else{
		            		//_STRI
		            		filterSql += " UPPER(" + field + ") LIKE UPPER('" + value + "%') ";
		            	}
		            } else if (operator.equals("endswith")) {
		            	if(field.indexOf("_DATE")>-1){
		            		filterSql += " TO_CHAR(" + field + ", 'YYYY-MM-DD') LIKE '%" + value + "' ";
		            	}else{
		            		//_STRI
		            		filterSql += " UPPER(" + field + ") LIKE UPPER('%" + value + "') ";
		            	}
		            } else if (operator.equals("contains")) {
		            	if(field.indexOf("_DATE")>-1){
		            		filterSql += " TO_CHAR(" + field + ", 'YYYY-MM-DD') LIKE '%" + value + "%' ";
		            	}else{
		            		//_STRI
		            		filterSql += " UPPER(" + field + ") LIKE UPPER('%" + value + "%') ";
		            	}
		            }else{
		            	if(field.indexOf("_NUMB")>-1){
		            		filterSql += field + " = " + value;
		            	}else if(field.indexOf("_DATE")>-1){
		            		filterSql += " TO_CHAR(" + field + ", 'YYYY-MM-DD') = '" + value + "' ";
		            	}else{
		            		//_STRI
		            		filterSql += " UPPER(" + field + ") = UPPER('" + value + "') ";
		            	}
		            }
				}
			}
			log.debug("##### filterSql:"+filterSql);
			map.put("GRID_WHERE_CLAUSE", filterSql);
			query.setAdditionalParameters(map);
			if(params!=null) {
				list = query.queryForList(statement, params, jdbcTypes);
			} else {
				list = query.queryForList(statement);
			}
		} catch(Throwable e) {
			log.error(e);
		}
		return list;
	}
	
}