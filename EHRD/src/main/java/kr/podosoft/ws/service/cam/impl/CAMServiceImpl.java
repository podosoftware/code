package kr.podosoft.ws.service.cam.impl;

import java.sql.Types;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.ca.CAException;
import kr.podosoft.ws.service.cam.CAMException;
import kr.podosoft.ws.service.cam.CAMService;
import kr.podosoft.ws.service.cam.dao.CAMDao;
import kr.podosoft.ws.service.common.MailSenderService;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.common.user.User;
import architecture.ee.web.util.ParamUtils;


public class CAMServiceImpl implements CAMService { 
	
	private Log log = LogFactory.getLog(getClass());

	private CAMDao camDao;

	private MailSenderService mailSenderSrv;


	public MailSenderService getMailSenderSrv() {
		return mailSenderSrv;
	} 
	public void setMailSenderSrv(MailSenderService mailSenderSrv) {
		this.mailSenderSrv = mailSenderSrv;
	}

	public CAMDao getCamDao() {
		return camDao;
	}
	public void setCamDao(CAMDao camDao) {
		this.camDao = camDao;
	}
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CAMException {
		return camDao.queryForList(statement, params, jdbcTypes);
	}
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CAMException {
		return camDao.update(statement, params, jdbcTypes);
	}
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CAMException {
		return camDao.excute(statement, params, jdbcTypes);
	}


	/**
	 * 
	 * 역량평가 저장<br/>
	 *
	 * @param request
	 * @return
	 * @throws CAMException
	 * @since 2014. 4. 16.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAMException.class )
	public int cmptEvlSave(HttpServletRequest  request, User user) throws CAMException{
		int saveCount = 0;
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
		List<Map<String, Object>> answers = ParamUtils.getJsonParameter(request, "item", "ANSWER_LIST",List.class);
		log.debug("answers.size():"+answers.size());
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM") + "");
		
		String evlCompleteFlag    = ParamUtils.getParameter(request, "EVL_COMPLETE_FLAG", "N"); // N: 임시저장, Y : 완료 , S : 코멘트저장

	    try{
		    	//역량 진단 했었던 이력 초기화 useflag = 'N'
				update("EVL.UPDATE_USEFLAG_N_TB_CAR_INDC_SCORE",
						new Object[]{companyid, runNum, execUserid}, 
						new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
				
				Map<String, Object> userExedMap = new HashMap<String, Object>();
				
				//평가문항 저장
				for(Map<String, Object> row: answers){

					//log.debug("------------------------------------------------------------------------");
					
					log.debug("row.get('SCORE'):"+row.get("SCORE"));
					
					if(row.get("BHV_INDC_NUM") != null && !row.get("BHV_INDC_NUM").toString().equals("999999999")){ //쿼리에서 평가의견의 행동지표번호를 999999999로 넘김.. 혹!! 유저data로 행동지표가 저 숫자를 사용하면... 바꿔줘야함..
						log.debug("1 row.get(BHV_INDC_NUM) ==>"+row.get("BHV_INDC_NUM") );
						//행동지표 저장
						if(row.get("SCORE") != null && !row.get("SCORE").equals("0")){
							String cmpNumber = row.get("CMPNUMBER").toString();
						    String bhvIndcNum = row.get("BHV_INDC_NUM").toString();
						    
						    //log.debug("1-1 row.get(USERID_EXED) ==>"+row.get("USERID_EXED") );
						    //log.debug("1-1 row.get(SCORE) ==>"+row.get("SCORE") );
						    
							long tgUserid = Long.parseLong(row.get("USERID_EXED").toString());
						    int score = Integer.parseInt(row.get("SCORE").toString());
						    
						    Object [] params = {companyid, runNum, execUserid, tgUserid, bhvIndcNum, cmpNumber, score, execUserid};
						    int[] jdbcTypes = {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC};
						    saveCount += update("EVL.MERGE_TB_CAR_INDC_SCORE", params, jdbcTypes);
						}
					}else{
						log.debug("2 row.get(BHV_INDC_NUM) ==>"+row.get("BHV_INDC_NUM") );

						//부하직원 평가의견 저장
						String evlOpn = "";
						if(row.get("SCORE") != null){
							evlOpn = row.get("SCORE").toString();
						}
						
						long tgUserid = Long.parseLong(row.get("USERID_EXED").toString());
						
						Object [] cmpParams = {companyid, runNum, execUserid, tgUserid, evlOpn};
					    int[] cmpJdbcTypes = {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR };
						saveCount += update("EVL.MERGE_CMPT_EVL_EXEC_CMT", cmpParams, cmpJdbcTypes);
					}
					
					//피진단자 세팅.
					userExedMap.put( row.get("USERID_EXED")+"", "");
				    
				}
				
				log.debug("@@@@@@@@@@@@@@@@@@@@ saveCount ==>"+saveCount );
				
				//평가완료인 경우.. 결과테이블에 결과 적용..
				if(evlCompleteFlag.equals("Y")){
					//평가자 완료여부, 완료일시 업데이트
					update("EVL.COMPLETE_TB_CAM_RUNDIRECTION_I",  
							new Object[]{companyid, runNum, execUserid}, 
							new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
					Set keyset = userExedMap.keySet();
					Object[] hashkeys = keyset.toArray();
					if (hashkeys.length > 0) {
						for (int i = 0; i < hashkeys.length; i++) {
							//평가 완료결과 데이터 생성.. 피진단자 수만큼 실행..
							excute("EVL.EXCUTE_CMPT_COMPLETE_PROC", 
									new Object[]{companyid, runNum, execUserid, hashkeys[i], ""}, 
									new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
						}
					}
				}
			
	    }catch(Exception e){
	    	log.debug(e);
	    	throw new CAMException(e);
	    }
		
		return saveCount;
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
		return camDao.getCmptEvlGrow(companyid, tgUserid, list);
	}
	
	
}
