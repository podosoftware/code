package kr.podosoft.ws.service.cdp.impl;

import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.cdp.CdpException;
import kr.podosoft.ws.service.cdp.CdpService;
import kr.podosoft.ws.service.cdp.dao.CdpDao;
import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.common.MailSenderService;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.common.user.User;
import architecture.ee.web.util.ParamUtils;


public class CdpServiceImpl implements CdpService { 
	
	private Log log = LogFactory.getLog(getClass());

	private CdpDao cdpDao;

	private MailSenderService mailSenderSrv;

	public MailSenderService getMailSenderSrv() {
		return mailSenderSrv;
	} 
	public void setMailSenderSrv(MailSenderService mailSenderSrv) {
		this.mailSenderSrv = mailSenderSrv;
	}
	public CdpDao getCamDao() {
		return cdpDao;
	}
	public void setCamDao(CdpDao cdpDao) {
		this.cdpDao = cdpDao;
	}
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws CdpException {
		return cdpDao.queryForObject(statement, params, jdbcTypes, cls);
	}
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CdpException {
		return cdpDao.queryForList(statement, params, jdbcTypes);
	}
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CdpException {
		return cdpDao.update(statement, params, jdbcTypes);
	}
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CdpException {
		return cdpDao.excute(statement, params, jdbcTypes);
	}
	public List<Map<String, Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws CdpException {
		return cdpDao.dynamicQueryForList(statement, params, jdbcTypes, map);
	}

	public List<Map<String, Object>> dynamicQueryForList(String statement, int startIndex, int pageSize, String sortFilter, String sortDir, String defaultSort, Filter filter, Object[] params, int[] jdbcTypes, Map map) throws CdpException {
		return cdpDao.dynamicQueryForList(statement, startIndex, pageSize, sortFilter, sortDir, defaultSort, filter, params, jdbcTypes, map);
	}

	/**
	 * 승인요청 처리.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class )
	public int cdpPlanApprReq(HttpServletRequest  request, User user) throws CdpException{
		int saveCount = 0;
		
		String reqNum = ParamUtils.getParameter(request, "reqNum");// 승인요청번호
		String comment = ParamUtils.getParameter(request, "comment");// 검토의견
		String gubun = ParamUtils.getParameter(request, "gubun");// 승인(Y) 미승인(N)	
		String req_userid = ParamUtils.getParameter(request, "req_userid");// 승인(Y) 미승인(N)	
		
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
		//int firCnt = 0;
		//int secCnt = 0;
		//int thiCnt = 0;
		//int classCnt = 0;
		
		try{
			
			String sts = "";
			if(gubun.equals("Y")){
				//승인
				sts = "2";
			}else{
				//미승인
				sts = "3";
			}
			
			// 1. TB_BA_APPR_REQ_LINE (승인요청 - 라인)
			Object [] param1 = {sts, execUserid, comment, companyid, reqNum, execUserid };
		    int[] jdbcTypes1 = { Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC };
		    saveCount = update("CDP.UPDATE_TB_BA_APPR_REQ_LINE", param1 , jdbcTypes1 );
			
			// 최종결재자 여부
			String lastApprFlag = queryForObject("CDP.SELECT_LAST_APPR_FLAG", new Object[]{companyid, reqNum, execUserid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}, String.class).toString();
			
			//미승인이거나 마지막 승인자인경우..
			if(sts.equals("3") || lastApprFlag.equals("Y")){
			
				// 2. TB_BA_APPR_REQ (승인요청)
				Object [] param2 = {sts, execUserid, companyid, reqNum };
			    int[] jdbcTypes2 = { Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC };
			    saveCount += update("CDP.UPDATE_TB_BA_APPR_REQ", param2 , jdbcTypes2 );

				// 3. TB_CDP (경력개발계획)
			    saveCount += update("CDP.UPDATE_TB_CDP_APPR_REQ", param2 , jdbcTypes2 );
				
			}
			
			/*
			//미승인이거나 마지막 승인자인경우..
			if(lastApprFlag.equals("Y")){
				// 최종결재자일 경우 3군데 모두 처리
				
				if(gubun.equals("Y")){
					// 승인

					// 1. TB_BA_APPR_REQ_LINE (승인요청)
					Object [] param1 = {"2", execUserid, comment, companyid, reqNum, execUserid };
				    int[] jdbcTypes1 = { Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC };
					firCnt = update("CDP.UPDATE_TB_BA_APPR_REQ_LINE", param1 , jdbcTypes1 );
					
					// 2. TB_BA_APPR_REQ (승인요청 - 라인)
					Object [] param2 = {"2", execUserid, companyid, reqNum };
				    int[] jdbcTypes2 = { Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC };
					secCnt = update("CDP.UPDATE_TB_BA_APPR_REQ", param2 , jdbcTypes2 );
					
					// 3. TB_CDP (경력개발계획)
					thiCnt = update("CDP.UPDATE_TB_CDP_APPR_REQ", param2 , jdbcTypes2 );

					
					List<Map<String, Object>> eduList = queryForList("CDP.SELECT_CDP_EDU_LIST", new Object[]{companyid, req_userid}, new int[]{Types.NUMERIC, Types.NUMERIC});
					int[] jdbcTypes3 = { Types.NUMERIC, Types.VARCHAR, 
							Types.VARCHAR, 
							Types.VARCHAR, 
							Types.VARCHAR, 
							Types.VARCHAR, 
							Types.NUMERIC, Types.VARCHAR, Types.NUMERIC,Types.NUMERIC, Types.VARCHAR };
					for(Map<String, Object> row: eduList)
					{
						// 4. 교육신청
						if(row.get("OPEN_NUM")!=null){
							Object [] param3 = {companyid, req_userid, 
									row.get("OPEN_NUM"), 
									row.get("SUBJECT_NUM"), 
									row.get("DIVISIONID"),
									row.get("GRADE_NUM"),
									"3",reqNum, "1", "2", execUserid};
							update("CDP.MERGE_BA_SBJCT_OPEN_CLASS", param3 , jdbcTypes3 );
						}
					}
					
				}else{
					// 미승인
					
					// 1. TB_BA_APPR_REQ_LINE (승인요청)
					Object [] param1 = {"3", execUserid, comment, companyid, reqNum, execUserid };
				    int[] jdbcTypes1 = { Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC };
					firCnt = update("CDP.UPDATE_TB_BA_APPR_REQ_LINE", param1 , jdbcTypes1 );
					
					// 2. TB_BA_APPR_REQ (승인요청 - 라인)
					Object [] param2 = {"3", execUserid, companyid, reqNum };
				    int[] jdbcTypes2 = { Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC };
					secCnt = update("CDP.UPDATE_TB_BA_APPR_REQ", param2 , jdbcTypes2 );
					
					// 3. TB_CDP (경력개발계획)
					thiCnt = update("CDP.UPDATE_TB_CDP_APPR_REQ", param2 , jdbcTypes2 );				
					
				}
				
				if(firCnt > 0 && secCnt > 0 && thiCnt > 0 ){
					saveCount = 1;
				}
				
			}else{
				// 최종결재자가 아닐 경우 TB_BA_APPR_REQ_LINE 만 처리
				if(gubun.equals("Y")){
					// 승인
					// 1. TB_BA_APPR_REQ_LINE (승인요청)
					Object [] param1 = {"2", execUserid, comment, companyid, reqNum, execUserid };
				    int[] jdbcTypes1 = { Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC };
				    saveCount = update("CDP.UPDATE_TB_BA_APPR_REQ_LINE", param1 , jdbcTypes1 );
				}else{
					// 미승인
					// 1. TB_BA_APPR_REQ_LINE (승인요청)
					Object [] param1 = {"3", execUserid, comment, companyid, reqNum, execUserid };
				    int[] jdbcTypes1 = { Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC };
				    saveCount = update("CDP.UPDATE_TB_BA_APPR_REQ_LINE", param1 , jdbcTypes1 );
				}
				
			}
			*/
		
		}catch(Exception e){
			log.debug(e);
		}		
		return saveCount;
	}	
	
	/**
	 * 경력개발계획 - 저장 승인요청
	 */
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class )
	public int saveMyCdp(HttpServletRequest  request, User user) throws CdpException{
		int saveCount = 0;
		
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
	    try{
	    
			List<Map<String, Object>> certPlan = ParamUtils.getJsonParameter(request, "item", "CERT_PLAN",List.class);//자격증계획
			List<Map<String, Object>> langPlan = ParamUtils.getJsonParameter(request, "item", "LANG_PLAN",List.class); //어학계획
			List<Map<String, Object>> eduPlan = ParamUtils.getJsonParameter(request, "item", "EDU_PLAN",List.class); //교육계획
			
			log.debug("langPlan.size():"+langPlan.size());
			log.debug("eduPlan.size():"+eduPlan.size());
			log.debug("certPlan.size():"+certPlan.size());
			
			String runNum = ParamUtils.getParameter(request, "runNum");
			String yTarget = ParamUtils.getParameter(request, "YYYY_TARG", "");
			String lTarget = ParamUtils.getParameter(request, "LONG_TARG", "");
			String hJob1 = ParamUtils.getParameter(request, "HOPE_JOB1", "");
			String hJob2 = ParamUtils.getParameter(request, "HOPE_JOB2", "");
			String hDivisionid = ParamUtils.getParameter(request, "HOPE_DIVISIONID", "");
			String cmpltFlag = ParamUtils.getParameter(request, "CMPLT_FLAG", "N");
			

	    	//경력개발계획 저장
			saveCount += update("CDP.MERGE_TB_CDP", 
					new Object[]{ companyid, runNum, execUserid, yTarget, lTarget,
											hJob1, hJob2, hDivisionid, cmpltFlag, execUserid }, 
					new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR,
									Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC});

			//자격증, 어학, 교육계획 초기화.. 모두 'N' 처리.
			update("CDP.UPDATE_N_CDP", 
					new Object[]{ companyid, runNum, execUserid, companyid, runNum,
										execUserid, companyid, runNum, execUserid },
					new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
									Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
			 
			//자격증 계획 저장
			for(Map<String, Object> row: certPlan){
				if(row.get("COMMONCODE")!=null){
					Object [] params = { companyid, runNum, execUserid, row.get("COMMONCODE").toString(), execUserid };
				    int[] jdbcTypes = { Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC };
				    saveCount += update("CDP.MERGE_TB_CDP_CERT_PLAN", params, jdbcTypes);
				}
			}

			//어학 계획 저장
			for(Map<String, Object> row: langPlan){
				if(row.get("COMMONCODE")!=null){
					String sco = "";
					if(row.get("TARG_SCO")!=null){
						sco = row.get("TARG_SCO").toString();
					}
					Object [] params = { companyid, runNum, execUserid, row.get("COMMONCODE").toString(), sco, execUserid };
				    int[] jdbcTypes = { Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC };
				    saveCount += update("CDP.MERGE_TB_CDP_LANG_PLAN", params, jdbcTypes);
				}
			}

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
			
			//교육 계획 저장
			for(Map<String, Object> row: eduPlan){
				
				if(row.get("SUBJECT_NUM")!=null){
					Date hym = null;
					if(row.get("HOPE_YYYYMM")!=null){
						try {
							hym = sdf.parse(row.get("HOPE_YYYYMM").toString());
							log.debug("####hym:"+hym);
							
						} catch (ParseException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					Object [] params = { companyid, runNum, execUserid, row.get("SUBJECT_NUM").toString(), hym,  row.get("CMPNUMBER").toString(), execUserid };
				    int[] jdbcTypes = { Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.DATE, Types.NUMERIC, Types.NUMERIC };
				    saveCount += update("CDP.MERGE_TB_CDP_EDU_PLAN", params, jdbcTypes);
				}
			}
			
			//승인요청인 경우..
			if(cmpltFlag.equals("Y")){

				List<Map<String, Object>> apprLine = ParamUtils.getJsonParameter(request, "item", "APPR_LINE",List.class); //승인경로

				log.debug("apprLine.size():"+apprLine.size());
				
				//승인요청번호
				Object reqNum = queryForObject("CDP.SELECT_SEQ_REQ_NUM", null, null, String.class);
				log.debug("@@@ reqNum:"+reqNum);
				
				saveCount += update("CDP.INSERT_TB_BA_APPR_REQ", 
						/* 승인요청구분코드 1-경력개발계획, 2-교육승인요청, 3-상시학습이력승인요청 */
						new Object[]{ companyid, reqNum, "1" , execUserid, apprLine.size(),  execUserid }, 
						new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC} 
				);
				
				for(Map<String, Object> row: apprLine){
					String apprDivCd = "";
					if(row.get("APPR_DIV_CD")!=null){
						apprDivCd = row.get("APPR_DIV_CD").toString();
					}
					saveCount += update("CDP.INSERT_TB_BA_APPR_REQ_LINE", 
							new Object[]{ companyid, reqNum, row.get("REQ_LINE_SEQ").toString() , row.get("USERID").toString(), apprDivCd,  execUserid },
							new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC} 
					);
				}
				
				//경력개발계획에 승인요청번호, 승인요청상태 update
				saveCount += update("CDP.UPDATE_REQ_TB_CDP", new Object[]{ "1", reqNum, companyid, runNum, execUserid },
						new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
			}
			
			
	    }catch(CdpException e){
	    	log.debug(e);
	    }
		
		return saveCount;
	}
	
	/**
	 * 승인요청 취소처리.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class )
	public int cancelApprReq(HttpServletRequest  request, User user) throws CdpException{
		int saveCount = 0;

		String reqTypeCd = ParamUtils.getParameter(request, "REQ_TYPE_CD", "");
		String reqNum = ParamUtils.getParameter(request, "REQ_NUM");
		
		//승인요청 취소처리.
		saveCount += update("CDP.CANCEL_APPR_REQ", new Object[]{ user.getCompanyId(), reqNum}, new int[]{ Types.NUMERIC, Types.NUMERIC });
		
		if(reqTypeCd.equals("1")){
			//경력개발계획
			saveCount += update("CDP.CANCEL_CDP_APPR_REQ", new Object[]{ user.getCompanyId(), reqNum}, new int[]{ Types.NUMERIC, Types.NUMERIC });
			
		}else if(reqTypeCd.equals("2")){
			//교육생승인요청
			
		}else if(reqTypeCd.equals("3")){
			//상시학습이력승인요청
			saveCount += update("CA.CANCEL_CLASS_ADMIN_APPR_REQ", new Object[]{ user.getCompanyId(), reqNum}, new int[]{ Types.NUMERIC, Types.NUMERIC });
		}else if(reqTypeCd.equals("4")||reqTypeCd.equals("5")){
			//멘토링생성요청
			saveCount += update("MTR.CANCEL_MTR_APPR_REQ", new Object[]{ user.getCompanyId(), reqNum}, new int[]{ Types.NUMERIC, Types.NUMERIC });
		}else if(reqTypeCd.equals("6")){
			//교육대상 선발 추천순위 승인요청
			saveCount += update("BA_SUBJECT.CANCEL_EDU_RECOMM_APPR_REQ", new Object[]{user.getCompanyId(), reqNum}, new int[]{Types.NUMERIC, Types.NUMERIC});
		}
		return saveCount;
	}
	

}
