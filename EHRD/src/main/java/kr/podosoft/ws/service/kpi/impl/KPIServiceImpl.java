package kr.podosoft.ws.service.kpi.impl;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.struts2.dispatcher.multipart.MultiPartRequestWrapper;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.common.user.User;
import architecture.ee.web.util.ParamUtils;

import kr.podosoft.ws.service.ca.CAException;
import kr.podosoft.ws.service.common.MailSenderService;
import kr.podosoft.ws.service.kpi.KPIException;
import kr.podosoft.ws.service.kpi.KPIService;
import kr.podosoft.ws.service.kpi.dao.KPIDao;
import kr.podosoft.ws.service.utils.CommonUtils;

public class KPIServiceImpl implements KPIService{
	/**
	 *
	 * @author  ReeSSang
	 * @version 
	 */
	private Log log = LogFactory.getLog(getClass());
	
	
	private KPIDao kpiDao;
	
	private MailSenderService mailSenderSrv;
	
	public KPIDao getKpiDao() {
		return kpiDao;
	}

	public void setKpiDao(KPIDao kpiDao) {
		this.kpiDao = kpiDao;
	}
	
	public MailSenderService getMailSenderSrv() {
		return mailSenderSrv;
	}
	
	public void setMailSenderSrv(MailSenderService mailSenderSrv) {
		this.mailSenderSrv = mailSenderSrv;
	}

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType) throws KPIException {
		Object obj = null;
		try {
			obj = kpiDao.queryForObject(statement, params, jdbcTypes, elementType);
		} catch(Throwable e) {
			log.error(e);
		}
		return obj;
	}
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws KPIException {
		return kpiDao.queryForList(statement, params, jdbcTypes);
	}
	
	public int update(String statement, Object[] params, int[] jdbcTypes) throws KPIException {
		return kpiDao.update(statement, params, jdbcTypes);
	}
	
	public int update(String statement, Object[] params, int[] jdbcTypes, Map map) throws KPIException {
		return kpiDao.update(statement, params, jdbcTypes, map);
	}
	
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws KPIException {
		return kpiDao.excute(statement, params, jdbcTypes);
	}
	
	/**
	 * 직원별 KPI 관리 - 지표 세팅
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = KPIException.class )
	public int saveKpiUser( HttpServletRequest  request, User user) throws KPIException{
		int saveCount = 0;
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		log.debug("@@@@ list.size():"+list.size());
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM") + "");
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID") + "");
		String regTypeCd = ParamUtils.getParameter(request, "REG_TYPE_CD", "1");
		
	    try{
	    	saveCount = saveKpiUser(list, companyid, runNum, tgUserid, execUserid, regTypeCd);
	    }catch(Exception e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	
	/**
	 * 
	 * 직원별 kpi 지표세팅 <br/>
	 *
	 * @param list
	 * @param companyid
	 * @param runNum
	 * @param tgUserid
	 * @param execUserid
	 * @return
	 * @throws KPIException
	 * @since 2014. 5. 7.
	 */
	public int saveKpiUser( List<Map<String, Object>> list, long companyid, int runNum, long tgUserid, long execUserid, String regTypeCd) throws KPIException{
		int saveCount = 0;
		
		log.debug("### saveKpiUser list.size:"+list.size());
		
		//평가지표 저장
		if(list!=null && list.size()>0){
			for(Map row: list){
				if(row.get("USEFLAG").equals("Y")){
					
					int kpiNo = 0;
					double befPrf = 0.0;
					double nowTarg = 0.0;
					int prio = 0;
					
					if(row.get("KPI_NO") !=null && !row.get("KPI_NO").equals("")){
						kpiNo = Integer.parseInt(row.get("KPI_NO").toString());
					}
					if(row.get("BEF_PRF") !=null && !row.get("BEF_PRF").equals("")){
						befPrf = Double.parseDouble(row.get("BEF_PRF").toString());
					}
					if(row.get("NOW_TARG") !=null && !row.get("NOW_TARG").equals("")){
						nowTarg = Double.parseDouble(row.get("NOW_TARG").toString());
					}
					if(row.get("PRIO") !=null && !row.get("PRIO").equals("")){
						prio = Integer.parseInt(row.get("PRIO").toString());
					}
					Map map = new HashMap();
		            map.put("WHERE_STR", " AND USERID = "+tgUserid+" ");
		            
					Object [] params = { runNum, companyid, befPrf, nowTarg, 0, prio, execUserid, regTypeCd, companyid, kpiNo };
				    int[] jdbcTypes = {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC};
				    saveCount += update("KPI.SETTING_TB_KPI_USER_MAP", params, jdbcTypes, map);

				}
			}
			
			log.debug("### saveCount:"+saveCount);
			
			if(saveCount > 0){
				//평가 완료결과 데이터 생성
				excute("KPI.EXCUTE_PROC_USER_KPI_MAPPING", new Object[]{companyid, runNum, tgUserid, ""}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
			}
		}
		return saveCount;
	}
	
	/**
	 * KPI 설정 정보 엑셀 저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int kpiUserMapExcelSave( User user, HttpServletRequest request){
		int result = 0;

		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM"));
		//String regTypeCd = ParamUtils.getParameter(request, "REG_TYPE_CD", "1");
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;
		/*
		 HSSFWorkbook workbook = null;
	     HSSFSheet sheet = null;
	     HSSFRow row = null;
	     HSSFCell cell = null;
	     */
	     long companyId = user.getCompanyId();
	     long userId = user.getUserId();
	     
	     try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("files")[0];
            
            FileInputStream fileInputStrem = new FileInputStream(file);
		     
	         //workbook = new HSSFWorkbook(fileInputStrem);
			//워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 

	         if( workbook != null)
	         {
	             sheet = workbook.getSheetAt( 0);

	             if( sheet != null)
	             {
	                 //기록물철의 경우 실제 데이터가 시작되는 Row지정
	                 int nRowStartIndex = 1;
	                 //기록물철의 경우 실제 데이터가 끝 Row지정
	                 int nRowEndIndex   = sheet.getLastRowNum();
	                 //기록물철의 경우 실제 데이터가 시작되는 Column지정
	                 int nColumnStartIndex = 0;
	                 
	                 String szValue = "";
	                 String bfEmpNo = "";
	                 log.debug("### nRowEndIndex:"+nRowEndIndex);
	                 for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                 {
	                     row  = sheet.getRow( i);
	                     
	                     String empNo = "";
	                     int kpiNo = 0;
                         double befPrf = 0.0;
                         double nowTarg = 0.0;
                         double nowPrf = 0.0;
                         int prio = 0;
                         
                        //기록물철의 경우 실제 데이터가 끝나는 Column지정
    	                 int nColumnEndIndex = sheet.getRow(i).getLastCellNum();
    	                 log.debug("### nColumnEndIndex:"+nColumnEndIndex);
	                     for( int nColumn = nColumnStartIndex; nColumn <= nColumnEndIndex ; nColumn++)
	                     {
	                         cell = row.getCell(( short ) nColumn);
	                         if(cell != null){
	                        	
		                         if( cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
		                         {
		                             szValue = (int)cell.getNumericCellValue() + "";
		                         }else{
		                             szValue = cell.getStringCellValue();
		                         }
		                         log.debug("### szValue:"+szValue);
	                             switch (nColumn) {
		                         	 case 0 : empNo = szValue; break; 
			                         case 2 : 
			                        	 if(szValue!=null && !szValue.equals(""))
			                        		 kpiNo = Integer.parseInt(szValue); 
			                        	 
			                        	 break;    
			                         case 5 :
			                        	 if(szValue!=null && !szValue.equals(""))
			                        		 befPrf  = Double.parseDouble(szValue);
			                        	 
			                        	 break;
			                         case 6 : 
			                        	 if(szValue!=null && !szValue.equals(""))
			                        		 nowTarg = Double.parseDouble(szValue);  
			                        	 
			                        	 break;  
			                         case 7 : 
			                        	 if(szValue!=null && !szValue.equals(""))
			                        		 nowPrf = Double.parseDouble(szValue);  
			                        	 
			                        	 break; 
			                         case 8 : 
			                        	 if(szValue!=null && !szValue.equals(""))
			                        		 prio = Integer.parseInt(szValue);  
			                        	 
			                        	 break;
		                         }
		                     }
	                     }

	                     log.debug("empNo : " + empNo);
	                     log.debug("kpiNo : " + kpiNo);
	                     log.debug("befPrf : " + befPrf);
	                     log.debug("nowTarg : " + nowTarg);
	                     log.debug("nowPrf : " + nowPrf);
	                     log.debug("prio : " + prio);

	                     if(empNo!=null && !empNo.equals("") && kpiNo > 0){
		                     Map map = new HashMap();
		                     if(!empNo.equals(bfEmpNo)){
		                    	 map.put("TAG_WHERE_STR", " AND EMPNO = '"+empNo+"' ");
			                     update("KPI.MERGE_TB_CAM_RUNTARGET_I", new Object[]{runNum, userId, companyId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}, map);
		                     }
		                     map.put("WHERE_STR", " AND EMPNO = '"+empNo+"' ");
		                     Object [] params = { runNum, companyId, befPrf, nowTarg, nowPrf, prio, userId, "1", companyId, kpiNo };
		                     int[] jdbcTypes = {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC};
		                     result += update("KPI.SETTING_MGR_TB_KPI_USER_MAP", params, jdbcTypes, map);
	                     }
	                     bfEmpNo = empNo;
	                 }
	                 if(result>0){
	                	 //엑셀업로드가 완료된 이후엔 KPI평가정보를 최종적으로 생성...
	                	 excute("KPI.EXCUTE_PROC_ALL_USER_KPI_MAPPING", new Object[]{companyId, runNum, ""}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
	                 }
	             }
	         }
	     }
	     catch(Exception e){
	         e.printStackTrace();
	     }
		
		return result;
	}
	
	public int infoMailSend(User user, String runNum, List<Map<String, Object>> list) throws KPIException {
		
		int result = 0;
		
		try{
			log.debug(list);
			long companyid =  user.getCompanyId();
			
			List runInfo = queryForList("KPI.GET_SIMPLE_RUN_INFO", new  Object[]{companyid, Integer.parseInt(runNum)}, new int[]{ Types.NUMERIC, Types.NUMERIC});
			String runName = "";
			if(runInfo!=null && runInfo.size()>0){
				Map runMap = (Map)runInfo.get(0);
				runName = runMap.get("RUN_NAME").toString();
				
				// 안내메일발송
				for(Map map: list){
					String checkFlag = map.get("CHK")==null?"":map.get("CHK").toString();
					log.debug("테스트");
					log.debug(checkFlag);
					if(checkFlag.equals("checked")){
						
						String userId = map.get("USERID")==null?"":map.get("USERID").toString();	   		    			    
				
						List<Map<String,Object>> mailInfoList = kpiDao.queryForList("KPI.GET_KPI_MAIL_LIST", new Object[]{companyid, companyid, userId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});//(user.getCompanyId(), userId);
						// 발송자 정보추출(성명,이메일) --> 고객사 운영자 정보 조회..
							
						String subjectName = "";
						String fromUser = "";
						String toUser = "";
						StringBuffer sb = new StringBuffer(); // 본문내용
						
						if(mailInfoList!=null && mailInfoList.size()>0) {
							Map<String,Object> row = mailInfoList.get(0);
							
							String incFromMail = "";
							String decFromMail = "";
							String incToMail = "";
							String decToMail = "";
							if(row.get("FROM_EMAIL")!=null){
								incFromMail = row.get("FROM_EMAIL").toString();
								decFromMail = CommonUtils.ASEDecoding(incFromMail);
							}
							if(row.get("TO_EMAIL")!=null){
								incToMail = row.get("TO_EMAIL").toString();
								decToMail = CommonUtils.ASEDecoding(incToMail);
							}
							
							//수신,발신 이메일 정보가 온전한 경우에만 메일 발송.
							if(decFromMail!=null && !decFromMail.equals("") && decToMail!=null && !decToMail.equals("")){
								fromUser = decFromMail;
								toUser = decToMail;
								
								//제목 mpva 제공..
								subjectName = "[MPVA 시스템] "+ row.get("TO_NAME") + "님 성과평가를 실시합니다.";
								
								sb.append(subjectName);
								sb.append("<br><br>[" + runName  + "] 평가를 실시합니다.<br> 많은 참여 바랍니다.");
								sb.append("<br><br><br>감사합니다.<br><br><br>");
								
								Map<String,String> contents = new HashMap<String, String>();
								contents.put("CONTENTS", sb.toString());
								
								log.debug("send mail.........");
								
								log.debug("%%%% fromUser : " + fromUser + ", toUser : " + toUser);
								
								mailSenderSrv.mailSender(subjectName, contents, fromUser, toUser, null, false);
							}
						}
					}
				}
			}
			result = 1;	
			
		}catch(Throwable e){
			result = 0;
			throw new KPIException(e);
		}
		return result;
	}
	
	
	public int encourageMailSend(User user, String runName, List<Map<String, Object>> list) throws KPIException {
		
		int result = 0;
		
		try{
			//CipherAria aria = new CipherAria();
			log.debug(list);
			// 상담자에게 상담요청 메일발송
			for(Map map: list){
				String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
				log.debug(checkFlag);
				if(checkFlag.equals("checked=\"1\"")){
					
					String userId = map.get("USERID")==null?"":map.get("USERID").toString();	   		    			    
				  
			
					//List<Map<String,Object>> mailInfoList = caDao.getMailInfoList(user.getCompanyId(), userId);
					List<Map<String,Object>> mailInfoList = kpiDao.queryForList("KPI.GET_KPI_MAIL_LIST", new Object[]{user.getCompanyId(), user.getCompanyId(), userId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
					// 발송자 정보추출(성명,이메일)
						
					String subjectName = "";
					String fromUser = "";
					String toUser = "";
					StringBuffer sb = new StringBuffer(); // 본문내용
					
					if(mailInfoList!=null && mailInfoList.size()>0) {
						Map<String,Object> row = mailInfoList.get(0);
						
						String incFromMail = "";
						String decFromMail = "";
						String incToMail = "";
						String decToMail = "";
						if(row.get("FROM_EMAIL")!=null){
							incFromMail = row.get("FROM_EMAIL").toString();
							decFromMail = CommonUtils.ASEDecoding(incFromMail);
						}
						if(row.get("TO_EMAIL")!=null){
							incToMail = row.get("TO_EMAIL").toString();
							decToMail = CommonUtils.ASEDecoding(incToMail);
						}
						
						
						//수신,발신 이메일 정보가 온전한 경우에만 메일 발송.
						if(decFromMail!=null && !decFromMail.equals("") && decToMail!=null && !decToMail.equals("")){
							fromUser = decFromMail;
							toUser = decToMail;
							//제목 mpva 제공..
							subjectName = "[MPVA 시스템] "+ row.get("TO_NAME") + "님 역량평가를 실시하여 주십시오.";
							
							log.debug("테스트"+row.get("TO_NAME"));
							
							sb.append(subjectName);
							sb.append("<br><br>[" + runName  + "] 평가을 아직 실시 하지 않으셨습니다.<br> 많은 참여 바랍니다.");
							sb.append("<br><br><br>감사합니다.<br><br><br>");
							
							
							Map<String,String> contents = new HashMap<String, String>();
							contents.put("CONTENTS", sb.toString());
							
							log.debug("send mail.........");
							
							log.debug("fromUser : " + fromUser + ", toUser : " + toUser); 
							
							log.debug(subjectName);
							log.debug(contents);
							log.debug(fromUser);
							log.debug(toUser);
							
							
							mailSenderSrv.mailSender(subjectName, contents, fromUser, toUser, null, false);
						}
							
					}
				}
			}
					
			result = 1;
			
		}catch(Throwable e){
			result = 0;
			throw new KPIException(e);
		}
		
		return result;
	}
	
	
	/**
	 * 설문관리 메일전송
	 */
	public int servMailSend(User user, String ppNo, List<Map<String, Object>> list) throws KPIException{
		
		int result = 0;
		log.debug("메일전송");
		try{
			log.debug(list);
			long companyid =  user.getCompanyId();
			
			List runInfo = queryForList("CA.GET_SIMPLE_SERV_INFO", new  Object[]{companyid, Integer.parseInt(ppNo)}, new int[]{ Types.NUMERIC, Types.NUMERIC});
			String ppName = "";
			if(runInfo!=null && runInfo.size()>0){
				Map runMap = (Map)runInfo.get(0);
				ppName = runMap.get("PP_NM").toString();
				log.debug(ppName); 
				
				// 안내메일발송
				for(Map map: list){
					String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
					log.debug("테스트");
					log.debug(checkFlag);
					if(checkFlag.equals("checked=\"1\"")){
						
						String userId = map.get("USERID")==null?"":map.get("USERID").toString();	   		    			    
				
						List<Map<String,Object>> mailInfoList = kpiDao.queryForList("KPI.GET_KPI_MAIL_LIST", new Object[]{companyid, companyid, userId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});//(user.getCompanyId(), userId);
						// 발송자 정보추출(성명,이메일) --> 고객사 운영자 정보 조회..
							
						String subjectName = "";
						String fromUser = "";
						String toUser = "";
						StringBuffer sb = new StringBuffer(); // 본문내용
						
						if(mailInfoList!=null && mailInfoList.size()>0) {
							Map<String,Object> row = mailInfoList.get(0);
							
							String incFromMail = "";
							String decFromMail = "";
							String incToMail = "";  
							String decToMail = "";
							if(row.get("FROM_EMAIL")!=null){
								incFromMail = row.get("FROM_EMAIL").toString();
								decFromMail = CommonUtils.ASEDecoding(incFromMail);
							}
							if(row.get("TO_EMAIL")!=null){
								incToMail = row.get("TO_EMAIL").toString();
								decToMail = CommonUtils.ASEDecoding(incToMail);
							}
							 
							//수신,발신 이메일 정보가 온전한 경우에만 메일 발송.
							if(decFromMail!=null && !decFromMail.equals("") && decToMail!=null && !decToMail.equals("")){
								fromUser = decFromMail;
								toUser = decToMail;
								
								//제목 mpva 제공..
								subjectName = "[MPVA 시스템] "+ row.get("TO_NAME") + "님 설문을 실시합니다.";
								
								sb.append(subjectName);
								sb.append("<br><br>[" + ppName  + "] 설문을 실시합니다.<br> 많은 참여 바랍니다.");
								sb.append("<br><br><br>감사합니다.<br><br><br>");
								
								Map<String,String> contents = new HashMap<String, String>();
								contents.put("CONTENTS", sb.toString());
								
								log.debug("send mail.........");
								
								log.debug("fromUser : " + fromUser + ", toUser : " + toUser);
								
								log.debug(subjectName);
								log.debug(contents);
								log.debug(fromUser);
								log.debug(toUser);
								
								mailSenderSrv.mailSender(subjectName, contents, fromUser, toUser, null, false);
							}
						}
					}
				}
			}
			result = 1;	
			
		}catch(Throwable e){
			result = 0;
			throw new KPIException(e);
		}
		
		return result;
	}
	
	/**
	 * 성과관리 - 실적등록
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = KPIException.class )
	public int saveUserPrf( HttpServletRequest  request, User user) throws KPIException{
		int saveCount = 0;
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		log.debug("@@@@ list.size():"+list.size());
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM") + "");
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID") + "");
		int kpiNo = Integer.parseInt(ParamUtils.getParameter(request, "KPI_NO"));
		
	    try{
		    	
	    	//실적데이터 초기화..
	    	update("KPI.USEFLAG_N_TB_KPI_OTCEVL_PRF_MGMT", new Object[]{companyid, runNum, tgUserid, kpiNo}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
	    	
	    	//월별 실적 데이터 merge
	    	if(list!=null && list.size()>0){
	    		Map row = list.get(0);
	    		
	    		//1~12월까지 실적 입력
	    		for(int i=1; i<=12; i++){
	    			log.debug("###### "+row.get("PRF_"+i));
	    			if(row.get("PRF_"+i)!=null && !row.get("PRF_"+i).equals("") ){
	    				double prf  = Double.parseDouble(row.get("PRF_"+i).toString());
	    				
	    				Object obj[] = {companyid, runNum, tgUserid, kpiNo, i, prf, execUserid};
	    				int types[] = {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC};
	        			
	    				saveCount+=update("KPI.MERGE_TB_KPI_OTCEVL_PRF_MGMT", obj, types);
	        	    }
	    		}
	    	}
	    	
			//if(saveCount > 0){
			
			//}
	    }catch(Exception e){
	    	log.debug(e);
	    }
		return saveCount;
	}

	/**
	 * 성과관리 - 목표승인요청 or 실적승인요청
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = KPIException.class )
	public int saveApprReqUser( HttpServletRequest  request, User user) throws KPIException{
		int saveCount = 0;
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		if(list!=null){
			log.debug("@@@@ list.size():"+list.size());
		}
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM") + "");
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID") + "");
		String saveDiv = ParamUtils.getParameter(request, "SAVE_DIV");
		String regTypeCd = ParamUtils.getParameter(request, "REG_TYPE_CD", "1");
		
	    try{
	    	String str = "";
	    	if(saveDiv.equals("T") || saveDiv.equals("TC")){
	    		//목표승인요청 or 목표 승인
	    		saveCount = saveKpiUser(list, companyid, runNum, tgUserid, execUserid, regTypeCd);
		    	
		    	//목표승인요청 상태로 변경
	    		if(saveDiv.equals("T")){
	    			str = "1";
	    		}else if(saveDiv.equals("TC")){
	    			str = "4";
	    		}
	    	}else if(saveDiv.equals("RT")){
	    		//목표설정 반려처리 상태 공백처리.
		    	str = "";
		    }else if(saveDiv.equals("P")){
	    		//실적 승인요청
		    	saveCount = update("KPI.APPR_REQ_TB_KPI_OTCEVL_PRF_MGMT", new Object[]{ companyid, runNum, tgUserid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		    	
		    	//실적승인요청 상태로 변경
		    	str = "2";
		    }else if(saveDiv.equals("PC") || saveDiv.equals("CMPL")){
	    		//실적 승인 처리
		    	saveCount = update("KPI.APPR_CONF_TB_KPI_OTCEVL_PRF_MGMT", new Object[]{ companyid, runNum, tgUserid, companyid, runNum, tgUserid }, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
		    	
		    	//평가점수 재계산
		    	excute("KPI.EXCUTE_PROC_USER_KPI_MAPPING", new Object[]{companyid, runNum, tgUserid, ""}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
		    	
		    	if(saveDiv.equals("PC")){
			    	//실적등록 상태로 변경
			    	str = "4";
		    	}else if(saveDiv.equals("CMPL")){
		    		//평가 완료 상태로 변경
	    			str = "5";
	    		}
		    }else if(saveDiv.equals("RTCM")){
	    		//실적등록 상태로 변경 - 평가 완료 건을 실적등록상태로 변경.
    			str = "4";
    		}
	    	
	    	//성과평가 상태 변경
	    	saveCount+=update("KPI.UPDATE_OTC_EVL_STATUS", new Object[]{ str, companyid, runNum, tgUserid }, new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
	    	
	    }catch(Exception e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	

	/**
	 * 부서원성과실적 승인 - 실적등록
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = KPIException.class )
	public int saveDeptUserPrf( HttpServletRequest  request, User user) throws KPIException{
		int saveCount = 0;
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		log.debug("@@@@ list.size():"+list.size());
		
		int runNum = Integer.parseInt(ParamUtils.getParameter(request, "RUN_NUM") + "");
		long tgUserid = Long.parseLong(ParamUtils.getParameter(request, "TG_USERID") + "");
		int kpiNo = Integer.parseInt(ParamUtils.getParameter(request, "KPI_NO"));
		
	    try{
		    	
	    	//실적데이터 초기화..
	    	update("KPI.USEFLAG_N_TB_KPI_OTCEVL_PRF_MGMT", new Object[]{companyid, runNum, tgUserid, kpiNo}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
	    	
	    	//월별 실적 데이터 merge
	    	if(list!=null && list.size()>0){
	    		Map row = list.get(0);
	    		
	    		//1~12월까지 실적 입력
	    		for(int i=1; i<=12; i++){
	    			log.debug("###### "+row.get("PRF_"+i));
	    			if(row.get("PRF_"+i)!=null && !row.get("PRF_"+i).equals("") ){
	    				double prf  = Double.parseDouble(row.get("PRF_"+i).toString());
	    				
	    				Object obj[] = {companyid, runNum, tgUserid, kpiNo, i, prf, execUserid};
	    				int types[] = {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC};
	        			
	    				saveCount+=update("KPI.MERGE_DEPT_TB_KPI_OTCEVL_PRF_MGMT", obj, types);
	        	    }
	    		}
	    	}
	    	
			if(saveCount > 0){
				//실적 재계산
				update("KPI.UPDATE_NOW_PRF", new Object[]{companyid, runNum, tgUserid, kpiNo} , new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
				
				//평가 완료결과 데이터 생성
				excute("KPI.EXCUTE_PROC_USER_KPI_MAPPING", new Object[]{companyid, runNum, tgUserid, ""}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
			}
	    }catch(Exception e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	

	/**
	 * 종합평가 - 신규생성
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = KPIException.class )
	public int saveTtEvl( HttpServletRequest  request, User user) throws KPIException{
		int saveCount = 0;
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();

		List<Map<String, Object>> wlist = ParamUtils.getJsonParameter(request, "item", "WLIST",List.class);
		List<Map<String, Object>> tlist = ParamUtils.getJsonParameter(request, "item", "TLIST",List.class);
		
		log.debug("@@@@ wlist.size():"+wlist.size()+", tlist.size():"+tlist.size());
		
		int evlyyyy = Integer.parseInt(ParamUtils.getParameter(request, "EVLYYYY") + "");
		String ttEvlNm = ParamUtils.getParameter(request, "TT_EVL_NM");
		
	    try{
		    //max 종합평가번호 조회
	    	String maxNo = queryForObject("KPI.MAX_TT_EVL_NO", new Object[]{companyid}, new int[]{Types.NUMERIC}, String.class).toString();
	    	
	    	//종합평가 저장
	    	saveCount = update("KPI.INSERT_TB_TT_EVL", new Object[]{companyid, Integer.parseInt(maxNo), evlyyyy, ttEvlNm, tlist.size(), execUserid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC});
	    	
	    	//종합평가 적용 평가목록 저장
	    	if(wlist!=null && wlist.size()>0){
	    		for (int i = 0; i < wlist.size(); i++) {
					Map wRow = (Map)wlist.get(i);
					
					log.debug("1 runNum : "+wRow.get("RUN_NUM")+", WEI_APL_TARG:"+wRow.get("WEI_APL_TARG")+", wei:"+wRow.get("WEI"));
					
					int runNum = Integer.parseInt(wRow.get("RUN_NUM").toString());
					
					Map wat = (Map)wRow.get("WEI_APL_TARG");
					String weiAplTarg = "";
					log.debug("2 WEI_APL_TARG:"+wat.get("WEI_APL_TARG"));
					if(wat.get("WEI_APL_TARG")!=null){
						weiAplTarg = wat.get("WEI_APL_TARG").toString();
					}
					
					double wei = 0.0;
					if(wRow.get("WEI")!=null){
						wei = Double.parseDouble(wRow.get("WEI").toString());
					}
					
					
					if(weiAplTarg!=null && !weiAplTarg.equals("")){
						saveCount += update("KPI.INSERT_TB_TT_EVL_RUN", 
								new Object[]{companyid, Integer.parseInt(maxNo), runNum, weiAplTarg, wei, execUserid}, 
								new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC});
					}
				}
	    	}
	    	
	    	//종합평가 대상자 저장
	    	if(tlist!=null && tlist.size()>0){
	    		List<Object[]> paramList = new ArrayList();
	    		for (int i = 0; i < tlist.size(); i++) {
					Map tRow = (Map)tlist.get(i);
					
					double otc1 = 0.0;
					double otc2 = 0.0;
					double cmpt1 = 0.0;
					double cmpt2 = 0.0;
					if(tRow.get("OTC1")!=null){
						otc1 = Double.parseDouble(tRow.get("OTC1").toString());
					}
					if(tRow.get("OTC2")!=null){
						otc2 = Double.parseDouble(tRow.get("OTC2").toString());
					}
					if(tRow.get("CMPT1")!=null){
						cmpt1 = Double.parseDouble(tRow.get("CMPT1").toString());
					}
					if(tRow.get("CMPT2")!=null){
						cmpt2 = Double.parseDouble(tRow.get("CMPT2").toString());
					}

					paramList.add(new Object[]{companyid, Integer.parseInt(maxNo), Integer.parseInt(tRow.get("USERID").toString()), otc1, otc2, cmpt1, cmpt2, execUserid});
				}
	    		saveCount += kpiDao.batchUpdate("KPI.INSERT_TB_TT_EVL_USER", paramList, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
	    		
	    	}
	    	
	    	//대상자별 종합점수 update
	    	if(saveCount > 0){
				//실적 재계산
				update("KPI.UPDATE_TB_TT_EVL_USER", new Object[]{companyid, Integer.parseInt(maxNo)} , new int[]{Types.NUMERIC, Types.NUMERIC});
			}
	    }catch(Exception e){
	    	log.debug(e);
	    }
		return saveCount;
	}
	
	
}
