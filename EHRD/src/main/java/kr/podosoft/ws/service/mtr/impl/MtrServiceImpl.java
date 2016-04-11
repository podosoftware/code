package kr.podosoft.ws.service.mtr.impl;

import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.mtr.MtrException;
import kr.podosoft.ws.service.mtr.MtrService;
import kr.podosoft.ws.service.mtr.dao.MtrDao;
import kr.podosoft.ws.service.common.MailSenderService;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import architecture.common.user.User;
import architecture.ee.web.util.ParamUtils;


public class MtrServiceImpl implements MtrService { 
	
	private Log log = LogFactory.getLog(getClass());

	private MtrDao mtrDao;

	private MailSenderService mailSenderSrv;


	public MailSenderService getMailSenderSrv() {
		return mailSenderSrv;
	} 
	public void setMailSenderSrv(MailSenderService mailSenderSrv) {
		this.mailSenderSrv = mailSenderSrv;
	}

	public MtrDao getCamDao() {
		return mtrDao;
	}
	public void setCamDao(MtrDao mtrDao) {
		this.mtrDao = mtrDao;
	}
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws MtrException {
		return mtrDao.queryForObject(statement, params, jdbcTypes, cls);
	}
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws MtrException {
		return mtrDao.queryForList(statement, params, jdbcTypes);
	}
	public int update(String statement, Object[] params, int[] jdbcTypes) throws MtrException {
		return mtrDao.update(statement, params, jdbcTypes);
	}
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws MtrException {
		return mtrDao.excute(statement, params, jdbcTypes);
	}
	public List<Map<String, Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws MtrException {
		return mtrDao.dynamicQueryForList(statement, params, jdbcTypes, map);
	}
	
	/**
	 * 멘토링 - 생성 요청 저장 
	 */
	public int saveMyMtr(HttpServletRequest  request, User user) throws MtrException{
		int saveCount = 0;
		
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
	    try{
			String tu = ParamUtils.getParameter(request, "tu");
			String memtorId = ParamUtils.getParameter(request, "MENTOR_ID","");
			String mtrNm = ParamUtils.getParameter(request, "MTR_NAME");
			String start_mtr = ParamUtils.getParameter(request, "YYYY_TARG", "");
			String end_mtr = ParamUtils.getParameter(request, "LONG_TARG", "");
			String cmpltFlag = ParamUtils.getParameter(request, "CMPLT_FLAG", "N");
			String mod = ParamUtils.getParameter(request, "MOD");
			String manager_yn = ParamUtils.getParameter(request, "IS_MANAGER", "N");
			String comp_mtr_seq = ParamUtils.getParameter(request, "COMP_MTR_SEQ", "");//완료요청을 위한 seq
			
			String div_cd="";
			String sts_cd="";
			
			//부서장일 경우 바로 승인 되도록
			if("true".equals(manager_yn) && "creMod".equals(mod)){ //부서장이면서 승인일경우
				div_cd = "4";
				sts_cd = "2";
			}else if("creMod".equals(mod)){ //일반사용자의 승인 요청
				div_cd = "4";
				sts_cd = "1";
			}else if("compMod".equals(mod)){ // 완료요청일경우
				div_cd = "5";
				sts_cd = "1";
			}

			Object reqNum = queryForObject("MTR.SELECT_SEQ_REQ_NUM", null, null, String.class);
			List<Map<String, Object>> apprLine = ParamUtils.getJsonParameter(request, "item", "APPR_LINE",List.class); //승인경로
			
			saveCount += update("MTR.INSERT_TB_BA_APPR_REQ", 
					new Object[]{ companyid, reqNum, div_cd , execUserid, apprLine.size(),  execUserid }, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC} 
			);
			
			for(Map row: apprLine){
				String apprDivCd = "";
				if(row.get("APPR_DIV_CD")!=null){
					apprDivCd = row.get("APPR_DIV_CD").toString();
				}
				saveCount += update("MTR.INSERT_TB_BA_APPR_REQ_LINE", 
						new Object[]{ companyid, reqNum, row.get("REQ_LINE_SEQ").toString() , row.get("USERID").toString(), apprDivCd, sts_cd,  execUserid }, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR,Types.VARCHAR, Types.NUMERIC} 
				);
			}
				
			if("creMod".equals(mod)){
				Object mtrReqNum = queryForObject("MTR.SELECT_SEQ_MTR_SEQ", null, null, String.class);
				
				saveCount += update("MTR.MERGE_TB_MTR", new Object[]{ companyid, mtrReqNum,reqNum, memtorId,div_cd,sts_cd, mtrNm, start_mtr, end_mtr,tu }, new int[]{Types.NUMERIC, Types.NUMERIC,Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,  Types.DATE,  Types.DATE, Types.VARCHAR});
				
				List<Map<String, Object>> menteeSave = ParamUtils.getJsonParameter(request, "item", "MENTEE",List.class);//자격증계획
				//멘티저장
				for(Map row: menteeSave){
					if(row.get("USERID")!=null){
						String menteeId = row.get("USERID")==null?"":row.get("USERID").toString();
						Object mtrMbSeq = queryForObject("MTR.SELECT_SEQ_MTR_MB_SEQ", null, null, String.class);
						
						Object [] params = { companyid,mtrReqNum, mtrMbSeq,menteeId,tu};
					    int[] jdbcTypes = { Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR};
					    saveCount += update("MTR.INSERT_TB_MTR_MENTEE", params, jdbcTypes);
					}
				}
			}
			else if("compMod".equals(mod)){
				saveCount += update("MTR.UPDATE_COMP_TB_MTR", new Object[]{ reqNum, div_cd, sts_cd, companyid, comp_mtr_seq}, new int[]{Types.NUMERIC, Types.VARCHAR, Types.VARCHAR,Types.NUMERIC, Types.NUMERIC});
			}
	    }catch(MtrException e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	
	/**
	 * 멘토링승인 - 승인 처리
	 */
	public int saveAppMtr(HttpServletRequest  request, User user) throws MtrException{
		int saveCount = 0;
		
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
	    try{
			String tu = ParamUtils.getParameter(request, "tu");
			String reqNum = ParamUtils.getParameter(request, "REQ_NUM","");
			String mtrNm = ParamUtils.getParameter(request, "MTR_SEQ");
			String reqLineSeq = ParamUtils.getParameter(request, "REQ_LINE_SEQ", "");
			String lastReqLineSeq = ParamUtils.getParameter(request, "LAST_REQ_LINE_SEQ", "");
			
			
			if(reqLineSeq.equals(lastReqLineSeq)){ //최종 승인자가 승인 할 경우 (승인자가 1명일경우)
				saveCount += update("MTR.UPDATE_TB_APPR_REQ_LINE", new Object[]{ companyid, reqNum, reqLineSeq }, new int[]{Types.NUMERIC, Types.NUMERIC,Types.NUMERIC});
				saveCount += update("MTR.UPDATE_TB_MTR", new Object[]{ companyid, mtrNm}, new int[]{Types.NUMERIC ,Types.NUMERIC});
				saveCount += update("MTR.UPDATE_TB_BA_APPR_REQ", new Object[]{ companyid, reqNum }, new int[]{Types.NUMERIC ,Types.NUMERIC});
			}
			else{ //  최종승인자 이전 승인자가 승인하였을 경우
				saveCount += update("MTR.UPDATE_TB_APPR_REQ_LINE", new Object[]{ companyid, reqNum, reqLineSeq }, new int[]{Types.NUMERIC, Types.NUMERIC,Types.NUMERIC});
			}
	    }catch(MtrException e){
	    	log.debug(e);
	    }

		return saveCount;
	}
	
	/**
	 * 멘토링승인 - 미승인처리
	 */
	public int saveNotAppMtr(HttpServletRequest  request, User user) throws MtrException{
		int saveCount = 0;
		
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
	    try{
			String tu = ParamUtils.getParameter(request, "tu");
			String reqNum = ParamUtils.getParameter(request, "REQ_NUM","");
			String mtrNm = ParamUtils.getParameter(request, "MTR_SEQ");
			String reqLineSeq = ParamUtils.getParameter(request, "REQ_LINE_SEQ", "");
			String lastReqLineSeq = ParamUtils.getParameter(request, "LAST_REQ_LINE_SEQ", "");
			
			//결자들중 한 결재자라도 미승인 할경우 관련된 테이블 모두 미승인(3) 처리
			saveCount += update("MTR.UPDATE_TB_NOT_APPR_REQ_LINE", new Object[]{ companyid, reqNum, reqLineSeq }, new int[]{Types.NUMERIC, Types.NUMERIC,Types.NUMERIC});
			saveCount += update("MTR.UPDATE_NOT_TB_MTR", new Object[]{ companyid, mtrNm}, new int[]{Types.NUMERIC ,Types.NUMERIC});
			saveCount += update("MTR.UPDATE_TB_BA_NOT_APPR_REQ", new Object[]{ companyid, reqNum }, new int[]{Types.NUMERIC ,Types.NUMERIC});

	    }catch(MtrException e){
	    	log.debug(e);
	    }

		return saveCount;
	}
	
	/**
	 * 멘토링 - 날짜 저장 
	 */
	public int modifyMyMtr(HttpServletRequest  request, User user) throws MtrException{
		int saveCount = 0;
		
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
	   
		try{
			String mtrSeq = ParamUtils.getParameter(request, "MTR_SEQ");
			String start_mtr = ParamUtils.getParameter(request, "MTR_START", "");
			String end_mtr = ParamUtils.getParameter(request, "MTR_END", "");

			saveCount += update("MTR.UPDATE_TB_MTR_DATE", new Object[]{ start_mtr,end_mtr,companyid, mtrSeq }, new int[]{Types.DATE,  Types.DATE, Types.NUMERIC,Types.NUMERIC});
			
	    }catch(MtrException e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	/**
	 * 멘토링 승인 - 멘토링 삭제 
	 */
	public int deleteMyMtr(HttpServletRequest  request, User user) throws MtrException{
		int saveCount = 0;
		
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
	   
		try{
			String mtrSeq = ParamUtils.getParameter(request, "MTR_SEQ");

			saveCount += update("MTR.DELETE_TB_MTR_DATE", new Object[]{ companyid, mtrSeq }, new int[]{Types.NUMERIC,Types.NUMERIC});
			
	    }catch(MtrException e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	
	
	/**
	 * 멘토링관리 - 최종 승인 처리
	 */
	public int saveLastAppMtr(HttpServletRequest  request, User user) throws MtrException{
		int saveCount = 0;
		
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
	    try{
			String tu = ParamUtils.getParameter(request, "tu");
			String mtrNm = ParamUtils.getParameter(request, "MTR_SEQ");
			String mod = ParamUtils.getParameter(request, "MOD", "");
			String startDate = ParamUtils.getParameter(request, "MTR_START", "");
			String endDate = ParamUtils.getParameter(request, "MTR_END", "");
			String recogTimeM = "0";
			String recogTimeH ="0";
			//미승인일 경우 인정시간/분을 넣지 않는다.
			if("N".equals(mod)){
				startDate = "";
				endDate = "";
				recogTimeM="";
				recogTimeH="";
				saveCount += update("MTR.UPDATE_TB_MTR_LAST_APPR_N", new Object[]{ mod, recogTimeH,recogTimeM,companyid, mtrNm,}, new int[]{Types.VARCHAR ,Types.VARCHAR ,Types.VARCHAR ,Types.NUMERIC,Types.NUMERIC});
			}else if("Y".equals(mod)){
				saveCount += update("MTR.UPDATE_TB_MTR_LAST_APPR_Y", new Object[]{ mod, endDate,startDate,endDate,startDate,recogTimeM,companyid, mtrNm,}, new int[]{Types.VARCHAR ,Types.DATE,  Types.DATE, Types.DATE,  Types.DATE,Types.NUMERIC,Types.NUMERIC ,Types.NUMERIC});
	    	}
	    }catch(MtrException e){
	    	log.debug(e);
	    }

		return saveCount;
	}
}
