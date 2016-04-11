package kr.podosoft.ws.service.car.impl;

import java.sql.Types;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.ca.CAException;
import kr.podosoft.ws.service.car.CarException;
import kr.podosoft.ws.service.car.CarService;
import kr.podosoft.ws.service.car.dao.CarDao;
import kr.podosoft.ws.service.common.MailSenderService;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import architecture.common.user.User;
import architecture.ee.web.util.ParamUtils;


public class CarServiceImpl implements CarService { 

	private Log log = LogFactory.getLog(getClass());

	private CarDao carDao;

	private MailSenderService mailSenderSrv;


	public MailSenderService getMailSenderSrv() {
		return mailSenderSrv;
	} 
	public void setMailSenderSrv(MailSenderService mailSenderSrv) {
		this.mailSenderSrv = mailSenderSrv;
	}

	public CarDao getCamDao() {
		return carDao;
	}
	public void setCamDao(CarDao carDao) {
		this.carDao = carDao;
	}
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws CarException {
		return carDao.queryForObject(statement, params, jdbcTypes, cls);
	}
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CarException {
		return carDao.queryForList(statement, params, jdbcTypes);
	}
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CarException {
		return carDao.update(statement, params, jdbcTypes);
	}
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CarException {
		return carDao.excute(statement, params, jdbcTypes);
	}
	public List<Map<String, Object>> dynamicQueryForList(String statement, Object[] params, int[] jdbcTypes, Map map) throws CarException {
		return carDao.dynamicQueryForList(statement, params, jdbcTypes, map);
	}
	
	/**
	 * 세션 사용자의 권한에 따른 관리부서 쿼리 동적 생성..
	 */
	public String getUserDivisionList(HttpServletRequest  request, User user, String tableAlias){
		String divisionStr = "";
		long companyid = user.getCompanyId();
		long userid = user.getUserId();
		
		if(request.isUserInRole("ROLE_SYSTEM")){ //총괄관리자
			//조건 없이 모두 조회..
			log.debug("### ROLE_SYSTEM");
		}else if(request.isUserInRole("ROLE_OPERATOR")){ //교육담당자
			//담당하는 부서(하위 포함)에 해당하는 사용자
			divisionStr = " AND "+tableAlias+" IN ( SELECT DIVISIONID FROM TB_BA_DIVISION WHERE COMPANYID = "+companyid+" AND DEL_YN = 'N' and USEFLAG = 'Y' START WITH DIVISIONID IN (SELECT DIVISIONID FROM TB_BA_DIVISION_EDU_MGR WHERE COMPANYID = "+companyid+" AND USERID = "+userid+" AND USEFLAG = 'Y') CONNECT BY PRIOR DIVISIONID = HIGH_DVSID ) ";
			
			log.debug("### ROLE_OPERATOR");
		}else{ //부서장
			//소속부서(하위 포함)의 사용자
			divisionStr = " AND "+tableAlias+" IN ( SELECT DIVISIONID FROM TB_BA_DIVISION WHERE COMPANYID = "+companyid+" AND DEL_YN = 'N' and USEFLAG = 'Y' START WITH DIVISIONID IN (SELECT DIVISIONID FROM TB_BA_DIVISION WHERE COMPANYID = "+companyid+" AND DVS_MANAGER = "+userid+") CONNECT BY PRIOR DIVISIONID = HIGH_DVSID ) ";
			
			log.debug("### ROLE_MANAGER");
		}
		return divisionStr;
	}
	/**
	 * 역량진단 임시저장상태로 변경..
	 */
	public int changeAssmStatus(HttpServletRequest  request, User user) throws  CarException{
		int saveCount = 0;
		long companyid = user.getCompanyId();
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM") + "");
		int tgUserid = Integer.parseInt(ParamUtils.getParameter(request, "USERID") + "");
		
		String evlFlag    = ParamUtils.getParameter(request, "EVL_FLAG", "T"); // T: 임시저장, I:초기화

	    try{
	    	//초기화인경우..
    		if(evlFlag.equals("I")){
    			//역량 진단 했었던 이력 초기화 useflag = 'N'
    			saveCount += update("EVL.UPDATE_USEFLAG_N_TB_CAR_INDC_SCORE", new Object[]{companyid, runNum, tgUserid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
			}
	    	
    		//진단자 완료상태였던 데이터를 취소처리...
    		saveCount += update("EVL.UPDATE_TEMP_STATE_TB_CAM_RUNDIRECTION_I",  new Object[]{companyid, runNum, tgUserid}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
			
			//완료된 진단자가 취소되었으므로 피진단자들 최종점수 재계산해줘야함..
    		List<Map<String, Object>> list = queryForList("EVL.SELECT_TEMP_STATE_TARG_USER_LIST", new Object[]{companyid, runNum, tgUserid}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
    		
    		if(list!=null && list.size()>0){
    			for(Map row: list){
					log.debug("row.get('USERID_EXED'):"+row.get("USERID_EXED"));
					long exedUserid = Long.parseLong(row.get("USERID_EXED").toString());
					
					//피진단자 수만큼 실행..
					saveCount += excute("EVL.EXCUTE_CMPT_COMPLETE_PROC", new Object[]{companyid, runNum, tgUserid, exedUserid, ""}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
    			}
    		}
	    }catch(Exception e){
	    	log.debug(e);
			throw new CarException(e);
	    }
		return saveCount;
	}
	
	
	/**
	 * 진단실시현황 독려메일 발송
	 * @param user
	 * @param runNum
	 * @param runName
	 * @param userArr
	 * @return
	 * @throws CAException
	 */
	public int encourageMailSend(User user, String runNum, String runName, String[] userArr, String type) throws CarException {
		int saveCount = 0;
		try{
			// 학생에게 독려 메일발송
			if(userArr!=null && userArr.length>0) {
				
				// 역량진단 또는 경력개발계획의 기본정보 추출
				List<Map<String, Object>> runInfoList = queryForList("CAR.GET_RUN_INFO", new Object[] {user.getCompanyId(), runNum}, new int[] {Types.NUMERIC, Types.NUMERIC});
				Map<String, Object> runInfo = null;
				if(runInfoList!=null && runInfoList.size()>0) {
					runInfo = runInfoList.get(0);
				}
				
				for(String userid: userArr){
					List<Map<String,Object>> mailInfoList = carDao.queryForList("CAR.GET_SEND_INFO_LIST", new Object[]{user.getCompanyId(), user.getUserId(), user.getCompanyId(), userid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
					// 발송자 정보추출(성명,이메일)
					String subjectName = "";
					String fromUser = "";
					String toUser = "";
					String toEmpno = "";
					String ssoType = ""; // 메일에서 바로가기 시 SSO 포워드 구분
					StringBuffer sb = new StringBuffer(); // 본문내용
					StringBuffer sb2 = new StringBuffer(); // 링크정보
					
					if(mailInfoList!=null && mailInfoList.size()>0) {
						Map<String,Object> row = mailInfoList.get(0);
						
						String fromMail = "";
						String toMail = "";
						if(row.get("FROM_EMAIL")!=null){
							fromMail = row.get("FROM_EMAIL").toString();
						}
						if(row.get("TO_EMAIL")!=null){
							toMail = row.get("TO_EMAIL").toString();
						}
						if(row.get("TO_EMPNO")!=null){
							toEmpno = row.get("TO_EMPNO").toString();
						}
						
						//수신,발신 이메일 정보가 온전한 경우에만 메일 발송.
						if(fromMail!=null && !fromMail.equals("") && toMail!=null && !toMail.equals("")){
							
							fromUser = fromMail;
							toUser = toMail;
							//제목 MPVA 제공..
							
							sb.append(" 안녕하세요. 경북대학교 e-HRD시스템에서 알려드립니다.");
							if(type.equals("CAR")) {
								subjectName = row.get("TO_NAME") + "님 역량진단을 실시하여 주십시오.";

								//sb.append("<br>");
								//sb.append(subjectName);
								sb.append("<br><br><b>[").append(runName).append("]</b> 역량진단을 아직 실시 하지 않으셨습니다.");
								sb.append("<br> 참여 바랍니다.");
								sb.append("<br>");
								sb.append("<br><b>▣ 진 단 명</b> : ").append(runInfo.get("RUN_NAME"));
								sb.append("<br><b>▣ 진단일정 </b>: ").append(runInfo.get("RUN_DATE"));
								sb.append("<br><br>감사합니다.<br>");
								
								ssoType = "cmpt"; // SSO로그인 이후 역량진단으로 이동
							} else if(type.equals("CDP")) {
								subjectName = row.get("TO_NAME") + "님 경력개발계획을 실시하여 주십시오.";
								
								//sb.append("<br>");
								//sb.append(subjectName);
								sb.append("<br><br><b>[").append(runName).append("]</b> 경력개발계획을 아직 실시 하지 않으셨습니다.");
								sb.append("<br> 참여 바랍니다.");
								sb.append("<br>");
								sb.append("<br><b>▣ 경력개발계획 명</b> : ").append(runInfo.get("RUN_NAME"));
								sb.append("<br><b>▣ 경력개발계획 일정</b> : ").append(runInfo.get("RUN_DATE"));
								sb.append("<br><br>감사합니다.<br>");
								
								ssoType = "cdp"; // SSO로그인 이후 경력개발계획으로 이동 
							}
							
							sb2.append("http://ehrd.knu.ac.kr/ehrd/accounts/sso/ssologin.do?");
							//sb2.append("ssoflag=").append("Y");
							//sb2.append("&empno=").append(toEmpno);
							sb2.append("type=").append(ssoType);
							
							Map<String,String> contents = new HashMap<String, String>();
							contents.put("SUBJECT_NAME", subjectName);
							contents.put("CONTENTS", sb.toString());
							
							contents.put("LINK", sb2.toString());
							contents.put("LINK_NM", "참여하기");
							
							log.debug("send mail.........");
							
							log.debug("fromUser : " + fromUser + ", toUser : " + toUser); 
							
							log.debug(subjectName);
							log.debug(contents);
							log.debug(fromUser);
							log.debug(toUser);
							
							mailSenderSrv.mailSender(subjectName, contents, fromUser, toUser, null, true);
						}
							
					}
				}
						
				saveCount = 1;
			}
			
		}catch(Throwable e){
			saveCount = 0;
			log.error(e);
			throw new CarException(e);
		}
		
		return saveCount;
	}
	
	/**
	 * 진단실시현황 독려SMS 발송
	 * @param user
	 * @param runName
	 * @param userArr
	 * @return
	 * @throws CAException
	 */
	public int encourageSmsSend(User user, String runName, String[] userArr, String type) throws CarException {
		int saveCount = 0;
		
		try{
			// 독려 SMS 발송
			if(userArr!=null && userArr.length>0) {
				for(String userid: userArr){
					List<Map<String,Object>> mailInfoList = carDao.queryForList("CAR.GET_SEND_INFO_LIST", new Object[]{user.getCompanyId(), user.getUserId(), user.getCompanyId(), userid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
					// 발송자 정보추출(성명, 핸드폰)
					String fromUser = "";
					String toUser = "";
					String title = "";
					String msg = "";
					
					if(mailInfoList!=null && mailInfoList.size()>0) {
						Map<String,Object> row = mailInfoList.get(0);
	
						if(row.get("FROM_PHONE")!=null){
							fromUser = row.get("FROM_PHONE").toString();
						}
						
						if(row.get("TO_PHONE")!=null){
							toUser = row.get("TO_NAME").toString()+"^"+row.get("TO_PHONE").toString();
						}
						
						//수신,발신 이메일 정보가 온전한 경우에만 메일 발송.
						if( toUser!=null && !toUser.equals("")){
							//제목 MPVA 제공..
							if(type.equals("CAR")) {
								title = "역량진단참여 독려("+row.get("TO_NAME")+") 안내";
								msg = row.get("TO_NAME") + "님 역량진단에 아직 참여하지 않았습니다.참여 바랍니다";
							} else if(type.equals("CDP")) {
								title = "경력개발계획참여 독려("+row.get("TO_NAME")+") 안내";
								msg = row.get("TO_NAME") + "님 경력개발계획에 아직 참여하지 않았습니다.참여 바랍니다";
							}
							
							log.debug("send sms.........");
							
							log.debug("fromUser : " + fromUser + ", toUser : " + toUser);
							
							Map<String, Object> map = mailSenderSrv.snedSms(title, msg, fromUser, toUser);
							
							if(map!=null) {
								if(map.get("RESULT")!=null && 
								   Integer.parseInt(map.get("RESULT").toString())>0) {
									saveCount = 1;
								}
								
								log.debug(map.get("ERROR"));
							}
						}
							
					}
				}
			}
		}catch(Throwable e){
			saveCount = 0;
			log.error(e);
			throw new CarException(e);
		}
		
		return saveCount;
	}
	
}
