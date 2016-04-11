package kr.podosoft.ws.service.ca.impl;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ca.CAException;
import kr.podosoft.ws.service.ca.CAService;
import kr.podosoft.ws.service.ca.dao.CADao;
import kr.podosoft.ws.service.common.MailSenderService;
import kr.podosoft.ws.service.em.EmAlwService;
import kr.podosoft.ws.service.utils.CommonUtils;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
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
//import pjt.dainlms.aria.CipherAria;

public class CAServiceImpl implements CAService { 
	
	private Log log = LogFactory.getLog(getClass());
	
	private Cache answerSheetCache;
	
	private CADao caDao;
	
	private Integer code;
	
	private Map examples; 
	
	private Map items;
	
	private MailSenderService mailSenderSrv;

	private EmAlwService emAlwService;

	public Cache getAnswerSheetCache() {
		return answerSheetCache;
	}
	
	public MailSenderService getMailSenderSrv() {
		return mailSenderSrv;
	} 
	public void setMailSenderSrv(MailSenderService mailSenderSrv) {
		this.mailSenderSrv = mailSenderSrv;
	}

	public void setAnswerSheetCache(Cache answerSheetCache) {
		this.answerSheetCache = answerSheetCache;
	}
	
	public Integer getCode() {
		return code;
	}

	public void setCode(Integer code) {
		this.code = code;
	}

	public Map getItems() {
		return items;
	}

	public void setItems(Map items) {
		this.items = items;
	}

	public Map getExamples() {
		return examples;
	}

	public void setExamples(Map examples) {
		this.examples = examples;
	}

	public CADao getCaDao() {
		return caDao;
	}

	public void setCaDao(CADao caDao) {
		this.caDao = caDao;
	}
	
	public EmAlwService getEmAlwService() {
		return emAlwService;
	}
	public void setEmAlwService(EmAlwService emAlwService) {
		this.emAlwService = emAlwService;
	}
	
	/* ================================================= 
    MPVA project S..... 
    ================================================= */
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CAException {
		return caDao.queryForList(statement, params, jdbcTypes);
	}
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CAException {
		return caDao.update(statement, params, jdbcTypes);
	}
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CAException {
		return caDao.excute(statement, params, jdbcTypes);
	}
	

	/**
	 * 역량 리스트(고객사)
	 */
	public List getCompetencyListService(int startIndex, int pageSize, long companyId){
		
		return caDao.getCompetencyListDao(startIndex, pageSize, companyId);
	}
	

	/**
	 * 공통코드 콤보박스
	 */
	public List getCommonCodeListService(String standardCode, long companyId, String addValue){
		
		return caDao.getCommonCodeListDao(standardCode, companyId, addValue);
	}

	/**
	 * 역량pool관리 메뉴의 상세조회에서 행동지표 목록 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param user
	 * @param cmpNumber
	 * @return
	 * @since 2014. 3. 17.
	 */
	public List getBhvList(User user, String cmpNumber) {
		
		List list = null;
		
		if(cmpNumber != null && !"".equals(cmpNumber)){
			list = caDao.getBhvListDao(user.getCompanyId(), cmpNumber);
		}//else{
			//list = caDao.getSubelementAllListDao(user.getCompanyId());
		//}
		
		
		return list;
	}

	/**
	 * 역량 저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int competencySaveService(Map<String, Object> map, User user) throws CAException{
		
		int saveCount = 0;
		String cmpNumber 		=  (String)map.get("CMPNUMBER");
		String cmpGroup      	=  (String)map.get("CMPGROUP");
		String cmpGroup_s      	=  (String)map.get("CMPGROUP_S");
		String cmpName	 	  	=  (String)map.get("CMPNAME");
		String cmpDefinition 	=  (String)map.get("CMPDEFINITION");
		String useFlag		  	=  (String)map.get("USEFLAG");
		
		saveCount = caDao.mergeCompetency(cmpNumber, cmpGroup, cmpGroup_s, cmpName, cmpDefinition, useFlag, user.getUserId(),  user.getCompanyId());
		
		return saveCount;
	}

	/**
	 * 역량정보 엑셀 저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int cmptExcelSaveService( User user, HttpServletRequest request){
		int result = 0;
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;
		
		/*HSSFWorkbook workbook = null;
		HSSFSheet sheet = null;
		HSSFRow row = null;
		HSSFCell cell = null;*/

		long companyId = user.getCompanyId();
		long userId = user.getUserId();

		try {
			MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper) request;

			File file = multiWrapper.getFiles("files")[0];

			FileInputStream fileInputStrem = new FileInputStream(file);

			//워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 
			//workbook = new HSSFWorkbook(fileInputStrem);
			
			if (workbook != null) {
				sheet = workbook.getSheetAt(0);

				if (sheet != null) {
					// 기록물철의 경우 실제 데이터가 시작되는 Row지정
					int nRowStartIndex = 1;
					// 기록물철의 경우 실제 데이터가 끝 Row지정
					int nRowEndIndex = sheet.getLastRowNum();
					// 기록물철의 경우 실제 데이터가 시작되는 Column지정
					int nColumnStartIndex = 0;

					String szValue = "";
					
					for (int i = nRowStartIndex; i <= nRowEndIndex; i++) {
						row = sheet.getRow(i);

						String cmpgroup = "";
						String cmpgroup_s = "";
						String cmpNm = "";
						String cmpNum = "";
						String cmpDesc = "";
						String useFlag = "";

						// 기록물철의 경우 실제 데이터가 끝나는 Column지정
						int nColumnEndIndex = sheet.getRow(i).getLastCellNum();

						for (int nColumn = nColumnStartIndex; nColumn <= nColumnEndIndex; nColumn++) {
							cell = row.getCell((short) nColumn);
							if (cell != null) {

								if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									szValue = (int) cell.getNumericCellValue()
											+ "";
								} else {
									szValue = cell.getStringCellValue();
								}

								switch (nColumn) {

								case 1:
									cmpgroup = szValue;
									break;
								case 3:
									cmpgroup_s = szValue;
									break;
								case 4:
									cmpNm = szValue;
									break;
								case 5:
									cmpNum = szValue;
									break;
								case 6:
									cmpDesc = szValue;
									break;
								case 7:
									useFlag = szValue;
									break;
								}
							}
						}

						log.debug("cmpgroup : " + cmpgroup);
						log.debug("cmpgroup_s : " + cmpgroup_s);
						log.debug("cmpNm : " + cmpNm);
						log.debug("cmpNum : " + cmpNum);
						log.debug("cmpDesc : " + cmpDesc);
						log.debug("useFlag : " + useFlag);

						result += caDao.mergeCompetency(cmpNum, cmpgroup,
								cmpgroup_s, cmpNm, cmpDesc, useFlag, userId,
								companyId);

					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 역량pool관리(고객사) 메뉴의 상세조회에서 행동지표 목록 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param user
	 * @param cmpNumber
	 * @return
	 * @since 2014. 3. 17.
	 */
	public List getOperatorBhvList(User user, String cmpNumber) {
		
		List list = null;
		
		if(cmpNumber != null && !"".equals(cmpNumber)){
			list = caDao.getOperatorBhvListDao(user.getCompanyId(), cmpNumber);
		}//else{
			//list = caDao.getSubelementAllListDao(user.getCompanyId());
		//}
		
		
		return list;
	}
	
	/**
	 * 역량관리 리스트(고객사)
	 */
	public List getOperatorCompetencyListService(int startIndex, int pageSize, long companyId){
		
		return caDao.getOperatorCompetencyListDao(startIndex, pageSize, companyId);
	}

	/**
	 * 역량군 저장(고객사)
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int operatorCmpGroupSaveService(Map<String, Object> map, User user) throws CAException{
		
		int saveCount = 0;
		String commoncode = (String)map.get("COMMONCODE");
        String standardcode = (String)map.get("STANDARDCODE");
        String cmmCodename = (String)map.get("CMM_CODENAME");
        String useFlag = (String)map.get("USEFLAG");
        String parentCommoncode = (String)map.get("PARENT_COMMONCODE");
        String parentStandardcode = (String)map.get("PARENT_STANDARDCODE");
        
		saveCount = caDao.mergeOperatorCmpGroup(commoncode, standardcode, cmmCodename, useFlag, parentCommoncode, parentStandardcode, user.getUserId(),  user.getCompanyId());
		
		return saveCount;
	}

	
	/**
	 * 역량관리 저장(고객사)
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int operatorCompetencySaveService(Map<String, Object> map, User user) throws CAException{
		
		int saveCount = 0;
		String cmpNumber 		=  (String)map.get("CMPNUMBER");
		String cmpGroup      	=  (String)map.get("CMPGROUP");
		String cmpName	 	  	=  (String)map.get("CMPNAME");
		String cmpDefinition 	=  (String)map.get("CMPDEFINITION");
		String useFlag		  	=  (String)map.get("USEFLAG");
		
		saveCount = caDao.mergeOperatorCompetency(cmpNumber, cmpGroup, cmpName, cmpDefinition, useFlag, user.getUserId(),  user.getCompanyId());
		
		return saveCount;
	}

	/**
	 * 행동지표 엑셀 저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int indicatorExcelSaveService( User user, HttpServletRequest request){
		int result = 0;
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;
	     
	     long companyId = user.getCompanyId();
	     long userId = user.getUserId();
	     
	     try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("files")[0];
            
            FileInputStream fileInputStrem = new FileInputStream(file);
		     
          //워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 
			//workbook = new HSSFWorkbook(fileInputStrem);

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
	                 for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                 {
	                     row  = sheet.getRow( i);
	                     
	                     String bhvIndicatorNum = "";
                         String cmpNum = "";
                         String bhvIndicator = "";
                         String useFlag = "";
//                         String example1 = "";
//                         String order1 = "";
//                         String score1 = "";
//                         String example2 = "";
//                         String order2 = "";
//                         String score2 = "";
//                         String example3 = "";
//                         String order3 = "";
//                         String score3 = "";
//                         String example4 = "";
//                         String order4 = "";
//                         String score4 = "";
//                         String example5 = "";
//                         String order5 = "";
//                         String score5 = "";
                         
                        //기록물철의 경우 실제 데이터가 끝나는 Column지정
    	                 int nColumnEndIndex = sheet.getRow(i).getLastCellNum();
    	                 
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
		                         
		                         switch (nColumn) {
		                         	
		                         	 case 0 : bhvIndicatorNum = szValue; break; 
			                         case 4 : cmpNum = szValue; break;
			                         case 5 : bhvIndicator = szValue;  break;  
			                         case 6 : useFlag = szValue;  break;
//			                         case 7 : example1 = szValue; break; 
//			                         case 8 : order1 = szValue; break;  
//			                         case 9 : score1 = szValue; break; 
//			                         case 10 : example2 = szValue; break;      
//			                         case 11 : order2 = szValue; break;
//			                         case 12 : score2 = szValue; break;
//			                         case 13 :example3 = szValue; break;
//			                         case 14 :order3 = szValue; break;
//			                         case 15 :score3 = szValue; break;
//			                         case 16 :example4 = szValue; break;
//			                         case 17 :order4 = szValue; break;
//			                         case 18 :score4 = szValue; break;
//			                         case 19 :example5 = szValue; break;
//			                         case 20 :order5 = szValue; break;
//			                         case 21 :score5 = szValue; break;
		                         }
	                         }
	                     }

	                     if("".equals(bhvIndicatorNum)){
	                    	 bhvIndicatorNum = caDao.getMaxbhvIndcNum();
	                     }
	                     
	                     log.debug("bhvIndicatorNum : " + bhvIndicatorNum);
	                     log.debug("cmpNum : " + cmpNum);
	                     log.debug("bhvIndicator : " + bhvIndicator);
	                     log.debug("useFlag : " + useFlag);
//	                     log.debug("example1 : " + example1);
//	                     log.debug("order1 : " + order1);
//	                     log.debug("score1 : " + score1);
//	                     log.debug("example2 : " + example2);
//	                     log.debug("order2 : " + order2);
//	                     log.debug("score2 : " + score2);
//	                     log.debug("example3 : " + example3);
//	                     log.debug("order3 : " + order3);
//	                     log.debug("score3 : " + score3);
//	                     log.debug("example4 : " + example4);
//	                     log.debug("order4 : " + order4);
//	                     log.debug("score4 : " + score4);
//	                     log.debug("example5 : " + example5);
//	                     log.debug("order5 : " + order5);
//	                     log.debug("score5 : " + score5);
	                     
	                     
	                     caDao.mergeBhvIndicator(companyId, bhvIndicatorNum, cmpNum, bhvIndicator, useFlag, userId);
	                     
	                     caDao.updateSocialExceptionFlag("Y", companyId, cmpNum);
	                     
//	                     caDao.deleteExample(companyId, cmpNum, bhvIndicatorNum);
	                     
//	                     if(!"".equals(example1)){
//	                    	 result = caDao.insertExample(companyId,  cmpNum, bhvIndicatorNum, example1, order1, score1, userId);
//	                     }
//	                     
//	                     if(!"".equals(example2)){
//	                    	 result = caDao.insertExample(companyId,  cmpNum, bhvIndicatorNum, example2, order2, score2, userId);
//	                     }
//	                     
//	                     if(!"".equals(example3)){
//	                    	 result = caDao.insertExample(companyId,  cmpNum, bhvIndicatorNum, example3, order3, score3, userId);
//	                     }
//	                     
//	                     if(!"".equals(example4)){
//	                    	 result = caDao.insertExample(companyId,  cmpNum, bhvIndicatorNum, example4, order4, score4, userId);
//	                     }
//	                     
//	                     if(!"".equals(example5)){
//	                    	 result = caDao.insertExample(companyId,  cmpNum, bhvIndicatorNum, example5, order5, score5,  userId);
//	                     }
	                 }
	             }
	         }
	     }
	     catch(Exception e){
	         e.printStackTrace();
	     }
		
		return result;
	}

	/**
	 * 역량 Pool 엑셀조회
	 */
	public List getCmptListExcel(long companyId){
		
		return caDao.getCmptListExcelDao(companyId);
	}

	/**
	 * 행동지표목록 엑셀조회
	 */
	public List getIndicatorListExcel(long companyId){
		
		return caDao.getIndicatorListExcelDao(companyId);
	}
	

	/**
	 * 역량군 목록 조회
	 */
	public List getCmpgroupListService(String useFlag, long companyId){
		String value = "";
		
		//역량군(대) 조회
		List<Map<String,Object>> list = caDao.getCmpgroupListDao("C102", useFlag, companyId, value);
 		int index= 0;
		for(Map map : list){
 			value = map.get("VALUE").toString();
 			List<Map<String, Object>> resultList = caDao.getCmpgroupListDao("C103", useFlag, companyId, value);
 			if(resultList!=null && resultList.size()>0){
 				list.get(index).put("items", resultList);
 	 		}
 			index ++;
 		}
		return list;
	}
	

	/**
	 * 역량군 저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int cmpGroupSaveService(Map<String, Object> map, User user) throws CAException{
		
		int saveCount = 0;
		String commoncode = (String)map.get("COMMONCODE");
        String standardcode = (String)map.get("STANDARDCODE");
        String cmmCodename = (String)map.get("CMM_CODENAME");
        String useFlag = (String)map.get("USEFLAG");
        String parentCommoncode = (String)map.get("PARENT_COMMONCODE");
        String parentStandardcode = (String)map.get("PARENT_STANDARDCODE");
        
		saveCount = caDao.mergeCmpGroup(commoncode, standardcode, cmmCodename, useFlag, parentCommoncode, parentStandardcode, user.getUserId(),  user.getCompanyId());
		
		return saveCount;
	}

	/**
	 * kpi 지표군 저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int kpiGroupSaveService(Map<String, Object> map, User user) throws CAException{
		
		int saveCount = 0;
		String commoncode = (String)map.get("COMMONCODE");
        String standardcode = (String)map.get("STANDARDCODE");
        String cmmCodename = (String)map.get("CMM_CODENAME");
        String useFlag = (String)map.get("USEFLAG");
        String parentCommoncode = (String)map.get("PARENT_COMMONCODE");
        String parentStandardcode = (String)map.get("PARENT_STANDARDCODE");
        
		saveCount = caDao.mergeCmpGroup(commoncode, standardcode, cmmCodename, useFlag, parentCommoncode, parentStandardcode, user.getUserId(),  user.getCompanyId());
		
		return saveCount;
	}
	

	/**
	 * 서브도메인 회사값 불러오기
	 */
	public List getDomainChk(String subDomain) {
		
	log.debug("진입");
		return caDao.getDomainChkDao(subDomain);
	}
	
	/**
	 * 게시판 코멘트 max cnt
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public String comentMaxCnt(String brdCd, String brdNum, User user){
		
		int result = 0;
		
		log.debug("코멘트 카운트 service단 진입");
		
	    long  companyId = user.getCompanyId();
	    long  userId = user.getUserId();		

		return caDao.comentMaxCnt(brdCd, brdNum, companyId);
	}
	
	
	/**
	 * 게시판 글쓰기시 SEQ
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public String seqBrdNum(){
		
		log.debug("게시판 글쓰기시 SEQ");
		

		return caDao.seqBrdNum();
	}
	
	
	/**
	 * 게시판 코멘트 저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int brdComentSave(String brdCd, String brdNum, String maxCnt,
			String brdcont, long userId, long companyId){
		
		log.debug("코멘트 카운트 service단 진입");
			
		return caDao.brdComentSaveDao(brdCd, brdNum, maxCnt, brdcont, userId, companyId);
	}
	
	
	/**
	 * 게시판 저장,수정
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int brdContSave(String brdtitle, String brdcont, String brdCd,
			String brdNum, String maxCnt, long fromUserId, long companyId, List<Map<String, Object>> mailList) throws CAException{
		log.debug("게시판 저장,수정 service단 진입");
		int saveCnt=0;
		try{
			
			saveCnt = caDao.brdContSaveDao(brdtitle, brdcont, brdCd, brdNum, brdCd, fromUserId, companyId);
			
			
			//교육안내 게시물인 경우 메일대상자가 있을 경우 메일 전송..
			try{
				if(brdCd!=null && brdCd.equals("3")){
					
					log.error("#### mailList.size():" + mailList.size());
					int mailCnt = 0;
					if(mailList!=null && mailList.size()>0) {
						
						for(Map<String, Object> mailMap: mailList){
							mailCnt++;
							log.error("#### mailCnt=>"+mailCnt);
							
							try{
								String userid = mailMap.get("USERID").toString();
								List<Map<String,Object>> mailInfoList = caDao.queryForList("CAR.GET_SEND_INFO_LIST", new Object[]{companyId, fromUserId, companyId, userid}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
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
										//제목
										subjectName = "경북대학교 e-HRD시스템에서 보내는 교육안내 메일입니다.";
			
										sb.append("안녕하세요. 경북대학교 e-HRD시스템에 교육안내 게시물이 등록되었습니다.");
										sb.append("<br>");
										sb.append("<br><b>▣ 게시물   제   목</b> : ").append(brdtitle);
										sb.append("<br><b>▣ 게시물확인방법</b> : ").append("e-HRD시스템 접속 -> 게시판>교육안내 메뉴로 이동하여 게시물을 조회할 수 있습니다. ");
										sb.append("<br><br>감사합니다.<br>");
									
										sb2.append("http://ehrd.knu.ac.kr/ehrd/accounts/sso/ssologin.do");
			
										Map<String,String> contents = new HashMap<String, String>();
										contents.put("SUBJECT_NAME", subjectName);
										contents.put("CONTENTS", sb.toString());
			
										contents.put("LINK", sb2.toString());
										contents.put("LINK_NM", "확인");
										
										log.debug("send mail.........");
										log.debug("fromUser : " + fromUser + ", toUser : " + toUser); 
										
										log.debug(subjectName);
										log.debug(contents);
										log.debug(fromUser);
										
										log.error("### subjectName:"+subjectName+", fromUser:"+fromUser+"toUSER =>"+toUser);
										
										mailSenderSrv.mailSender(subjectName, contents, fromUser, toUser, null, true);
										log.error("mailCnt send!!!!! =>"+toUser);
										
									}
								}
							}catch(Throwable e){
								log.error("#### mailSendSrv ERROR ####");
								log.error("#### ERROR111 ==>>>>"+e);
							}
						}
					}
				}
			}catch(Throwable e){}

		}catch(Throwable e){
			log.error("### ERROR222 ==>"+e);
			throw new CAException(e);
		}
		return saveCnt;
	}

	public List cmptAdminList(User user) { 

		return caDao.cmptAdminListDao(user.getCompanyId());    
	}
	
	
	public List cmtpWeightList(User user, String runNum) {

		return caDao.cmtpWeightListDao(user.getCompanyId(), runNum);
	}


	public int cmptAdminSave(Map<String, Object> map,
			List<Map<String, Object>> list, User user) throws Exception {
		
		int result = 0;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		try{
			
			String runNum 	= (String)map.get("RUN_NUM");
			String evlType 	= (String)map.get("EVL_TYPE_CD");
			String yyyy 	= (String)map.get("YYYY");		
			String runName 	= (String)map.get("RUN_NAME");

			Date runStart = sdf.parse(map.get("RUN_START").toString());
			Date runEnd  = sdf.parse(map.get("RUN_END").toString());
			Date runOpen = null;
			
			String resultOpenDate = map.get("RESULT_OPEN_DATE")==null?"":map.get("RESULT_OPEN_DATE").toString();
			
			if(resultOpenDate != null && !"".equals(resultOpenDate)){
				runOpen  = sdf.parse(map.get("RESULT_OPEN_DATE").toString());
			}
			String evlDiagType   = (String)map.get("DIAGNO_DIR_TYPE_CD");

			double selfWeight   = map.get("SELF_WEIGHT")!=null && !map.get("SELF_WEIGHT").equals("") ? Double.parseDouble((String)map.get("SELF_WEIGHT")) : 0;
			double bossWeight   = map.get("BOSS_WEIGHT")!=null && !map.get("BOSS_WEIGHT").equals("") ? Double.parseDouble((String)map.get("BOSS_WEIGHT")) : 0;
			double colWeight   = map.get("COL_WEIGHT")!=null && !map.get("COL_WEIGHT").equals("") ? Double.parseDouble((String)map.get("COL_WEIGHT")) : 0;
			double subWeight   = map.get("SUB_WEIGHT")!=null && !map.get("SUB_WEIGHT").equals("") ? Double.parseDouble((String)map.get("SUB_WEIGHT")) : 0;
			
			String bossYn   = (String)map.get("BOSS_YN");
			String subYn   = (String)map.get("SUB_YN");
			String colYn   = (String)map.get("COL_YN");
			String selfYn   = (String)map.get("SELF_YN");
			
			String bossHcnt   = (String)map.get("BOSS_HCNT");
			String colHcnt   = (String)map.get("COL_HCNT");
			String subHcnt   = (String)map.get("SUB_HCNT");
			String selfHcnt   = (String)map.get("SELF_HCNT");
			
			String useFlag   = (String)map.get("USEFLAG");
			
		    long  companyId = user.getCompanyId();
		    long  userId = user.getUserId();		
		    
	    	if("".equals(runNum)||runNum==null){
				runNum =  caDao.getMaxRunNum(companyId);
				if(evlType.equals("1")){

				}else if(evlType.equals("2")){
					selfWeight = 0;
					bossWeight = 0;
					colWeight = 0;
					subWeight = 0;
					bossYn = "N";  
					subYn  = "N";
					colYn  = "N";
					selfYn = "N";
					bossHcnt = "0";
					colHcnt = "0";
					subHcnt = "0";
					selfHcnt = "0";
					runOpen =null;
					
				}
				result = caDao.update("CA.INSERT_CAM_RUN", 
						new Object[]{
							companyId, runNum, evlType, runName, runStart, runEnd,runOpen, 
							bossYn, colYn, subYn, selfYn, userId,
							bossWeight, colWeight, subWeight,selfWeight, 
							colHcnt, subHcnt, bossHcnt,
							yyyy, evlDiagType, useFlag
						}, 
						new int[]{
							Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.DATE, Types.DATE, Types.DATE 
							, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC
							, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
							, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR
							, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR
						}
				);
			}else{
				if(evlType.equals("1")){

				}else if(evlType.equals("2")){
					selfWeight = 0;
					bossWeight = 0;
					colWeight = 0;
					subWeight = 0;
					bossYn = "N";  
					subYn  = "N";
					colYn  = "N";
					selfYn = "N";
					bossHcnt = "0";
					colHcnt = "0";
					subHcnt = "0";
					selfHcnt = "0";
					runOpen =null;
					
				}
				result = caDao.update("CA.UPDATE_CAM_RUN", 
						new Object[]{
							useFlag, evlType,  runName, runStart, runEnd, runOpen,
							bossWeight, colWeight, subWeight, selfWeight,
							bossYn, colYn, subYn, selfYn, 
							colHcnt, subHcnt, bossHcnt,
							userId, yyyy, evlDiagType, companyId, runNum
						}, 
						new int[]{
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.DATE, Types.DATE , Types.DATE
							, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
							, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR
							, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR
							, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC
						}

				);
			}
	    	caDao.update("CA.UPDATE_CAM_RUN_CMPGROUP", new Object[]{userId, companyId, runNum  }, new int []{Types.VARCHAR, Types.NUMERIC, Types.NUMERIC });
    	
	    	for(Map map2: list){
				String checkFlag = map2.get("CHECKFLAG")==null?"":map2.get("CHECKFLAG").toString();
		    	String comm = map2.get("COMMONCODE")==null?"":map2.get("COMMONCODE").toString();
		    	
		    	if("checked".equals(checkFlag)){
				caDao.update("CA.MERGE_TB_CAM_RUN_CMPGROUP", new Object[]{companyId, runNum, comm ,userId }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,Types.VARCHAR});
			
		    	}
		    }
    	
		    
				
	    }catch(CAException e){
	    	log.debug(e);
	    	e.printStackTrace();
	    }
		return result;
	}

	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 설문관리 년도 셀렉트박스(고객사)
	 */
	public List getSruvYealListService(long companyId){
		
		return caDao.getSruvYealListDao(companyId);
	}
	
	/**
	 * 설문관리 리스트(고객사)
	 */
	public List getSurvList(User user, String runNum) {
		
		if(runNum == null || "".equals(runNum)){
			runNum = caDao.getSurvRun(user.getCompanyId());
		}
		
		return caDao.getSurvListDao(user.getCompanyId(), runNum);
	}
	
	/**
	 * 설문관리 설문문항(고객사)
	 */
	public List getSurvQstn(User user, String ppNo) {
		
		return caDao.getSurvQstnDao(user.getCompanyId(), ppNo);
	}
	
	/**
	 * 설문관리 설문문항 카운트(고객사)
	 */
	public int getSurvQstnCount(User user, String ppNo) {
		
		return caDao.getSurvQstnCountDao(user.getCompanyId(), ppNo);
	}
	
	/**
	 * 설문관리 주관식 설문결과 유무(고객사)
 	 */
	public List getSurvRstCount(User user, String ppNo, int ppType, String ppSeq) {
		
		return caDao.getSurvRstCountDao(user.getCompanyId(), ppNo, ppType, ppSeq);
	}
	
	/**
	 * 설문관리 설문결과(고객사)
	 */
	public List getSurvRst(User user, String ppNo, int ppType, String ppSeq) {
		
		List list = null;

		if(ppType == 1){
			log.debug("객관식");
			list = caDao.getSurvRstDao(user.getCompanyId(), ppNo, ppType, ppSeq);
		}else{
			log.debug("주관식");
			list = caDao.getSurvRst2Dao(user.getCompanyId(), ppNo, ppType, ppSeq);
		}		
		
		return list;
	}
	
	/**
	 * 설문관리 설문대상자(고객사)
	 */
	public List getSurvTarg(User user, String ppNo) {
		
		
		
		return caDao.getSurvTargDao(user.getCompanyId(), ppNo);
	}
	
	/**
	 * 설문관리 설문문항 pool(고객사)
	 */
	public List getSurvQstnPool(User user) {
		
		
		
		return caDao.getSurvQstnPoolDao(user.getCompanyId());
	}
	
	/**
	 * 설문관리 유저리스트
	 */
	public List getSurvUser(User user) {
		
		return caDao.getSurvUserDao(user.getCompanyId());
	}
	
	/**
	 * 설문관리 엑셀 다운로드
	 */
	public List getServListExcel(User user, String ppNo,
			List<Map<String, Object>> list)  {
		
		log.debug("엑셀다운로드 service단");
			
		return caDao.getServListExcelDao(user.getCompanyId(), ppNo, list);
	}
	
	/**
	 * 설문관리 메일전송 (경북대학교 설문 없음.. 사용안함..)
	 */
	
	public int infoMailSend(User user, String ppNo, List<Map<String, Object>> list){
		
		int saveCount = 0;
		log.debug("메일전송");
		try{
			log.debug(list);
			long companyid =  user.getCompanyId();
			long fromUserid = user.getUserId();
			
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
				
						List<Map<String,Object>> mailInfoList = caDao.queryForList("CA.GET_SEND_INFO_LIST", new Object[]{companyid, fromUserid, companyid, userId}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});//(user.getCompanyId(), userId);
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
								
								//제목 MPVA 제공..
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
								
								mailSenderSrv.mailSender(subjectName, contents, fromUser, toUser, null, true);
							}
						}
					}
				}
			}
			saveCount = 1;	
			
		}catch(Throwable e){
			saveCount = 0;
		}
		return saveCount;
	}
	/**
	 * 역량매핑 리스트
	 */
	public List getOperatorCompetencyMappingListService(long companyId,String jobLdrNum){
		return caDao.getOperatorCompetencyMappingListDao(companyId, jobLdrNum);
	}
	
	
	/**
	 * 삭제(공통)
*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int caCommonDelService(Map<String, Object> map, User user) throws CAException{
		
		int saveCount = 0;

		
		saveCount = caDao.caCommonDelService(map, user.getUserId(), user.getCompanyId());
		
		return saveCount;
	}
	
	/**
	 * 설문관리 엑셀 저장
*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int servExcelSaveService( User user, HttpServletRequest request){
		int result = 0;
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;

		long companyId = user.getCompanyId();
		long userId = user.getUserId();

		try {
			MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper) request;

			File file = multiWrapper.getFiles("files")[0];

			FileInputStream fileInputStrem = new FileInputStream(file);

			//워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 
			//workbook = new HSSFWorkbook(fileInputStrem);
			
			if (workbook != null) {
				sheet = workbook.getSheetAt(0);

				if (sheet != null) {
					// 기록물철의 경우 실제 데이터가 시작되는 Row지정
					int nRowStartIndex = 1;
					// 기록물철의 경우 실제 데이터가 끝 Row지정
					int nRowEndIndex = sheet.getLastRowNum();
					// 기록물철의 경우 실제 데이터가 시작되는 Column지정
					int nColumnStartIndex = 0;

					String szValue = "";
					
					for (int i = nRowStartIndex; i <= nRowEndIndex; i++) {
						row = sheet.getRow(i);

						String qstnPoolNo = "";
						String qstnTypeCd = "";
						String qstn = "";
						String useFlag = "";

						// 기록물철의 경우 실제 데이터가 끝나는 Column지정
						int nColumnEndIndex = sheet.getRow(i).getLastCellNum();

						for (int nColumn = nColumnStartIndex; nColumn <= nColumnEndIndex; nColumn++) {
							cell = row.getCell((short) nColumn); 
							if (cell != null) {

								if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									szValue = (int) cell.getNumericCellValue()
											+ "";
								} else {
									szValue = cell.getStringCellValue();
								}

								switch (nColumn) {

								case 0:
									qstnPoolNo = szValue;
									break;
								case 2:
									qstnTypeCd = szValue;
									break;
								case 3:
									qstn = szValue;
									break;
								case 4:
									useFlag = szValue;
									break;
								}
							}
						}

						log.debug("cmpNm : " + qstnPoolNo);
						log.debug("cmpNum : " + qstnTypeCd);
						log.debug("cmpDesc : " + qstn);
						log.debug("useFlag : " + useFlag);

						result += caDao.mergeServ(qstnPoolNo, qstnTypeCd,
								qstn, useFlag, userId,
								companyId);

					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * KPI 정보 엑셀 저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int kpiExcelSaveService( User user, HttpServletRequest request){
		int result = 0;
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;
		
		
	     
	     long companyId = user.getCompanyId();
	     long userId = user.getUserId();
	     
	     try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("files")[0];
            
            FileInputStream fileInputStrem = new FileInputStream(file);
		     
          //워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 
			//workbook = new HSSFWorkbook(fileInputStrem);

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
	                 for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                 {
	                     row  = sheet.getRow( i);
	                     
	                     String kpiGroup = "";
	                     String kpiGroup_s = "";
	                     String kpiName = "";
                         String kpiNumber = "";
                         String evlHow = "";
                         String unit = "";
                         String useFlag = "";
                         
                        //기록물철의 경우 실제 데이터가 끝나는 Column지정
    	                 int nColumnEndIndex = sheet.getRow(i).getLastCellNum();
    	                 
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
		                         
		                         switch (nColumn) {
		                         	
		                         	 case 1 : kpiGroup = szValue; break; 
			                         case 3 : kpiGroup_s = szValue; break;    
			                         case 4 : kpiName  = szValue; break;
			                         case 5 : kpiNumber = szValue;  break;  
			                         case 7 : evlHow = szValue;  break; 
			                         case 9 : unit = szValue;  break;
			                         case 10 : useFlag = szValue;  break;
		                         }
	                         }
	                     }

	                     
	                     log.debug("kpiGroup_s : " + kpiGroup_s);
	                     log.debug("kpiName : " + kpiName);
	                     log.debug("kpiNumber : " + kpiNumber);
	                     log.debug("evlHow : " + evlHow);
	                     log.debug("unit : " + unit);
	                     
	                     result += caDao.mergeKpi(kpiNumber, kpiGroup, kpiGroup_s, kpiName, evlHow, unit, useFlag, user.getUserId(),  user.getCompanyId());
	                     
	                 }
	             }
	         }
	     }
	     catch(Exception e){ 
	         e.printStackTrace();
	     }
		
		return result;
	}

	/**
	 * KPI Pool 엑셀조회
	 */
	public List getKpiListExcel(long companyId){
		
		return caDao.getKpiListExcelDao(companyId);
	}
	
	
	/**
	 * KPI Pool 엑셀조회(고객사)
	 */
	public List getOperatorKpiListExcel(long companyId){
		
		return caDao.getOperatorKpiListExcelDao(companyId);
	}
	
	
	

	
	/**
	 * 역량군 목록 체크
	 */
	public List cmpGroupChkService(String useFlag, long companyId){
		String value = "";
		
		//역량군(대) 조회
		List<Map<String,Object>> list = caDao.getCmpgroupListDao("C102", useFlag, companyId, value);
 		int index= 0;
		for(Map map : list){
 			value = map.get("VALUE").toString();
 			List<Map<String, Object>> resultList = caDao.getCmpgroupListDao("C103", useFlag, companyId, value);
 			if(resultList!=null && resultList.size()>0){
 				list.get(index).put("items", resultList);
 	 		}
 			index ++;
 		}
		return list;
	}
	
	
	
	/* ================================================= 
    MPVA project E..... 
    ================================================= */
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	protected List<Map<String, Object>> getAnswerSheet(String sheetId, long companyId, String cmpNumber, String bhvIndcNum, int runNum, long userId) {
		List<Map<String, Object>> sheet;
		
		if( answerSheetCache.get(sheetId) != null ){
			sheet = (List<Map<String, Object>>)answerSheetCache.get(sheetId).getValue();
		}else{
			sheet = caDao.getIndcScoreList(companyId, cmpNumber,  bhvIndcNum, runNum, userId );
			if(sheet != null){
				answerSheetCache.put(new Element( sheetId, sheet ));
			}
		}	
		return sheet;
	}

	/**
	 *나의공통역량진단이력 메인화면 
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public List getSubjectCompDiagList(int startIndex, long userId, long companyId) {
		
		List<Map<String,Object>> list = caDao.getSubjectCompDiagList(startIndex, userId, companyId);
 		
 		int index= 0;
		
		for(Map map : list){
 			
 			String run_num = map.get("RUN_NUM").toString();
 			
 			List<Map<String, Object>> resultList = caDao.getCompDiagResultList(run_num, companyId, userId );
 			
 			list.get(index).put("RESULT", resultList);
 			
 			index ++;
 		}
 		
		return list;
		
	}
	 
	/**
	 *나의공통역량진단이력 메인화면 
	 
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int getSubjectCompDiagListCnt(long userId, long companyId) {
		
		return caDao.getSubjectCompDiagListCnt(userId, companyId);
		
	}
	/**
	 * 자가진단 문항
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public List getSelfDiagnosisList(int runNum, long userid, long companyId) {
		
		List<Map<String, Object>> exampleList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> indicatorList = new ArrayList<Map<String, Object>>();
        
		List<Map<String, Object>>  list1  = null;
		
		int cnt = caDao.getRunResultFlag(runNum, userid, companyId);
		
		//행동지표 결과가 있으면 임시저장이라고 판단하고, 없으면 처음으로 진단한다고 판단한다.
		if(cnt == 0){
			list1 = caDao.getIndicatorList(companyId);
		}else{
			 list1 = caDao.getIndicatorListReSelect(runNum, userid, companyId);
		}
		

	    for(int k=0; k < list1.size(); k ++){
	    	
			Map indicatorMap = list1.get(k);
				    	
	    	String cmpNumber = indicatorMap.get("CMPNUMBER") + "";
	    	String bhvIndcNum = indicatorMap.get("BHV_INDC_NUM") + "";
	    	
	    	exampleList = caDao.getExampleList(companyId, cmpNumber,  bhvIndcNum );
	    	indicatorList = caDao.getIndcScoreList(companyId, cmpNumber,  bhvIndcNum, runNum, userid );
	    	
	    	list1.get(k).put("EXAMPLE", exampleList);
	    	list1.get(k).put("INDICATOR", indicatorList);
	    }
		
		return list1;
	}
	
	/**
	 *나의공통역량진단이력 메인화면 
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int QuestionSaveCnt(int runNum, long userId, long companyId) {
		
		return caDao.QuestionSaveCnt(runNum, userId, companyId);
	}

	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public void asstSlfAnwsSave(int runNum, int saveStatus, List<Map<String,Object>> answers,User user) throws CAException {

	    long companyId = user.getCompanyId();
	    long userId = user.getUserId();
		
	    //역량 진단 했었던 이력 삭제 개발
		caDao.asstSlfAnwsDlt(runNum, companyId, userId);
		
		for(Map row: answers){
			
		    String questionSeq  		= row.get("QUESTION_SEQ").toString();
		    String cmpNumber   		= row.get("CMPNUMBER").toString();
		    String bhvIndcNum  		= row.get("BHV_INDC_NUM").toString();
		    String subelementNum  	= row.get("SUBELEMENT_NUM").toString();
//		    String userIdEx       = row.get("USERID_EX").toString();
//		    String userIdExed   = (String)row.get("USERID_EXED");
		    String exampleNum 		= row.get("EXAMPLE_NUM")==null?"":row.get("EXAMPLE_NUM").toString();
		    String exmScore     		= row.get("EXM_SCORE")==null?"0":row.get("EXM_SCORE").toString();
			caDao.asstSlfAnwsSave(companyId, cmpNumber, bhvIndcNum, subelementNum, runNum, userId+"", userId+"", exmScore, exampleNum,questionSeq, userId);	
		}
	    
		//saveStatus가 1일경우 역량진단 완료
		if(saveStatus==1){
			caDao.asstSlfAnwsDrctn(runNum, companyId, userId);
			//일관성 척도 업데이트
			caDao.udpateCnstFlag(runNum, companyId, userId);
			//사회적 바람직성 척도 업데이트
			caDao.updateSocialFlag(runNum, companyId, userId);
		}
	}
    
	/**
	 * 공통역량진단
	 * 결과보기 > 진단비교
	 * @param runNum
	 * @param user
	 * @param userid
	 * @return
	 */
	public List getCACmptCmpr(int runNum,  long companyId, long userId) {
		
		return caDao.getCACmptCmpr(runNum, userId, companyId);
	}
	
	/**
	 * 공통역량진단
	 * 결과보기 > 역량성장도
	 * @param runNum
	 * @param user
	 * @param userid
	 * @return
	 */
	public List getGrwList(int runNum, long companyId, long userId ) { 

		return caDao.getGrwList(runNum, userId, companyId);
	}
	
	/**
	 * 역량성장도 진단결과 차트 범례
	 */
	public List getGrwSubjectList(int runNum, long companyId, long userId) {

		return caDao.getGrwSubjectList(runNum,  userId, companyId);
	}
	
	
	
	
	/**
	 * 행동지표 리스트
	 */
	public List getIndicatorListService(long companyId){
		
		return caDao.getIndicatorListDao(companyId);
	}
	
	/**
	 * 행동지표 리스트(고객사)
	 */
	public List getOperatorIndicatorListService(long companyId){
		
		return caDao.getOperatorIndicatorListDao(companyId);
	}

	
	/**
	 * 역량관리 리스트
	 */
	public int getIndicatorListCount( long companyId){
		
		return caDao.getIndicatorListCount(companyId);
	}
	
	/**
	 * 역량관리 리스트(고객사)
	 */
	public int getOperatorIndicatorListCount( long companyId){
		
		return caDao.getOperatorIndicatorListCount(companyId);
	}

	/**
	 * 역량 콤보박스 리스트
	 */
	public List getCompetencyComboList( long companyId){
		
		return caDao.getCompetencyComboList(companyId);
	}
	
	
	/**
	 * 행동지표별 보기문항 리스트
	 */
//	public List getIndicatorExampleListService(int cmpNumber, int  bhvIndcNum, long companyId){
//		
//		return caDao.getIndicatorExampleListDao(cmpNumber, bhvIndcNum, companyId);
//	}
	
	/**
	 * 행동지표별 보기문항 리스트(고객사)
	 */
//	public List getOperatorIndicatorExampleListService(int cmpNumber, int  bhvIndcNum, long companyId){
//		
//		return caDao.getOperatorIndicatorExampleListDao(cmpNumber, bhvIndcNum, companyId);
//	}
	
	
	/**
	 * 행동지표 저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int indicatorSaveService(Map map, User user) throws CAException{
		
		int result = 0;
		
		String cmpNumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
		String bhvIndcNum = map.get("BHVINDCNUM")==null?"":map.get("BHVINDCNUM").toString();
		String bhvIndicator = map.get("BHVINDICATOR")==null?"":map.get("BHVINDICATOR").toString();
		String useFlag = map.get("USEFLAG")==null?"":map.get("USEFLAG").toString();
		String exceptionFlag = "";

		String MaxbhvIndcNum = "";
		
	    long  companyId = user.getCompanyId();
	    long  userId = user.getUserId();		
	    
		
		if("".equals(bhvIndcNum)||bhvIndcNum==null){
			MaxbhvIndcNum =  caDao.getMaxbhvIndcNum();
			log.debug("MaxbhvIndcNum : " + MaxbhvIndcNum);
			result = caDao.insertIndicator(companyId, cmpNumber, MaxbhvIndcNum, bhvIndicator, useFlag, userId, 
											 exceptionFlag);
		}else{
			MaxbhvIndcNum = bhvIndcNum;
			result = caDao.updateIndicator(bhvIndicator, useFlag, userId, exceptionFlag, 
												companyId,  cmpNumber, bhvIndcNum);
		}
	
		return result;
	}
	
	
	/**
	 * 행동지표 저장(고객사)
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int operatorIndicatorSaveService(Map map, User user, List<Map<String,Object>> items) throws CAException{
		
		int result = 0;
		
		String cmpNumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
		String bhvIndcNum = map.get("BHVINDCNUM")==null?"":map.get("BHVINDCNUM").toString();
		String bhvIndicator = map.get("BHVINDICATOR")==null?"":map.get("BHVINDICATOR").toString();
		String useFlag = map.get("USEFLAG")==null?"":map.get("USEFLAG").toString();
		String exceptionFlag = "";

		//String MaxbhvIndcNum = "";
		
	    long  companyId = user.getCompanyId();
	    long  userId = user.getUserId();		
		
		if("".equals(bhvIndcNum)||bhvIndcNum==null){
			bhvIndcNum =  caDao.getMaxbhvIndcNum();
			log.debug("MaxbhvIndcNum : " + bhvIndcNum);
			result = caDao.operatorInsertIndicator(companyId, cmpNumber, bhvIndcNum, bhvIndicator, useFlag, userId, 
											 exceptionFlag);
		}else{
			
			result = caDao.operatorUpdateIndicator(bhvIndicator, useFlag, userId, exceptionFlag, 
												companyId,  cmpNumber, bhvIndcNum);
		}
				

		// 행동지표별 계층을 맵핑 삭제 후 저장 ----------------------------------------------------------------------------------------------
		
		int cnt = 0;
		
		cnt = caDao.queryForInteger("CA.SELECT_TB_CM_BHID_LDR", 
				                 new Object[]{companyId,bhvIndcNum,cmpNumber}, 
				                 new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		
		if(cnt > 0){
			caDao.update("CA.DELETE_TB_CM_BHID_LDR", 
					new Object[]{companyId,bhvIndcNum,cmpNumber}, 
					new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		}
		
		
		
		if(items!=null && !items.isEmpty()){
			for(Map<String,Object> row : items){
				caDao.update("CA.INSERT_TB_CM_BHID_LDR", 
						     new Object[]{bhvIndcNum, companyId, cmpNumber, row.get("DATA"),"Y",userId}, 
						     new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC});
			}
		}
		

		return result;
	}
	
	
	/**
	 * KPI관리 리스트
	 */
	public List getKpiListService(int startIndex, int pageSize, long companyId){
		
		return caDao.getKpiListDao(startIndex, pageSize, companyId);
	}
	
	/**
	 * KPI지표 저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int kpiSaveService(Map<String, Object> map, User user) throws CAException{
		
		int saveCount = 0;
		String kpiNumber 		=  (String)map.get("KPINUMBER");
		String kpiGroup      	=  (String)map.get("KPIGROUP");
		String kpiGroup_s      	=  (String)map.get("KPIGROUP_S");
		String kpiName	 	  	=  (String)map.get("KPINAME");
		String evlHow 			=  (String)map.get("EVLHOW");
		String unit		  		=  (String)map.get("UNIT");
		String useFlag		  	=  (String)map.get("USEFLAG");
		
		
		saveCount = caDao.mergeKpi(kpiNumber, kpiGroup, kpiGroup_s, kpiName, evlHow, unit, useFlag, user.getUserId(),  user.getCompanyId());
		
		return saveCount;
	}

	/**
	 * 성과관리 지표생성 저장(일반사용자) & 개인 성과관리 지표로 추가
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int userKpiSaveService(Map<String, Object> map, User user, String runNum) throws CAException{
		
		int saveCount = 0;
		String kpiName	 	  	=  (String)map.get("KPINAME");
		String kpiType      	=  (String)map.get("KPITYPE");
		String meaEvlCyc      	=  (String)map.get("MEAEVLCYC");
		String evlYype      	=  (String)map.get("EVLTYPE");
		String evlHow 			=  (String)map.get("EVLHOW");
		String unit		  		=  (String)map.get("UNIT");
		String cap		  		=  (String)map.get("CAP");
		String target		  	=  (String)map.get("TARGET");
		String threshold		=  (String)map.get("THRESHOLD");
		String targetSetWrnt	=  (String)map.get("TARGET_SET_WRNT");
		String dataSource		=  (String)map.get("DATASOURCE");
		String mgmtDept			=  (String)map.get("MGMT_DEPT");
		String useFlag		  	=  "Y";
		
		//kpi 지표번호 조회
		int kpiNumber = caDao.getMaxKpiNo();
		
		Object[] params= {
				user.getCompanyId(), kpiNumber, kpiName, kpiType, meaEvlCyc, 
				evlYype, evlHow, unit, cap, target, 
				threshold, targetSetWrnt,  dataSource, mgmtDept, useFlag, 
				user.getUserId(), "2",
				user.getCompanyId(), runNum, user.getUserId(), kpiNumber, user.getUserId(), "2"
		};
		int [] jdbcTypes = {
				Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
				Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
				Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
				Types.VARCHAR, Types.VARCHAR,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR
		};
		saveCount = caDao.update("CA.INSERT_USER_KPI", params, jdbcTypes);
		return saveCount;
	}
	
	/**
	 * KPI지표 저장(고객사)
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int operatorKpiSaveService(Map<String, Object> map, User user) throws CAException{
		
		int saveCount = 0;
		String kpiNumber 		=  (String)map.get("KPINUMBER");
		String kpiGroup      	=  (String)map.get("KPIGROUP");		
		String kpiName	 	  	=  (String)map.get("KPINAME");
		String kpiType      	=  (String)map.get("KPITYPE");
		String meaEvlCyc      	=  (String)map.get("MEAEVLCYC");
		String evlYype      	=  (String)map.get("EVLTYPE");
		String evlHow 			=  (String)map.get("EVLHOW");
		String unit		  		=  (String)map.get("UNIT");
		String cap		  		=  (String)map.get("CAP");
		String target		  	=  (String)map.get("TARGET");
		String threshold		=  (String)map.get("THRESHOLD");
		String targetSetWrnt	=  (String)map.get("TARGET_SET_WRNT");
		String dataSource		=  (String)map.get("DATASOURCE");
		String mgmtDept			=  (String)map.get("MGMT_DEPT");
		String useFlag		  	=  (String)map.get("USEFLAG");
		
		
		saveCount = caDao.operatorMergeKpi(kpiNumber, kpiGroup, kpiName, kpiType, meaEvlCyc, evlYype, evlHow, unit, useFlag, user.getUserId(),  user.getCompanyId(), cap, target, threshold, targetSetWrnt, dataSource, mgmtDept);
		
		return saveCount;
	}
	
	/**
	 * KPI Add Flag 체크
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public String kpiAddCheckService(User user) throws CAException{
		
		String statement = "";
	
		
		statement = caDao.kpiAddCheckDao(user.getCompanyId());
		
		
		
		return statement;
	}
	 
	/**
	 * 역량 Add Flag 체크
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public String cmptAddCheckService(User user) throws CAException{
		
		String statement = "";
	
		
		statement = caDao.cmptAddCheckDao(user.getCompanyId());
		
		
		
		return statement;
	}
	
	

	/**
	 * KPI 목록 조회
	 */
	public List getKpigroupListService(String useFlag, long companyId){
		String value = "";
		
		//역량군(대) 조회
		List<Map<String,Object>> list = caDao.getKpigroupListDao("C104", useFlag, companyId, value);
 		int index= 0;
		for(Map map : list){
 			value = map.get("VALUE").toString();
 			List<Map<String, Object>> resultList = caDao.getKpigroupListDao("C105", useFlag, companyId, value);
 			if(resultList!=null && resultList.size()>0){
 				list.get(index).put("items", resultList);
 	 		}
 			index ++;
 		}
		return list;
	}
	
	
	
	/**
	 * kpi매핑 저장(고객사) 
	 */
	public int operatorKpiMappingSaveService(List<Map<String, Object>> list, User user,String jobLdrNum) throws CAException{
		
		int result = 0;
	    long companyId = user.getCompanyId();
	    long userid = user.getUserId();
	  
		log.debug("직무번호"+jobLdrNum);
		
		//모두 사용여부 'N' 처리
		result += caDao.update("CA.OPERATOR_KPI_MAPP_UPDATE", new Object[]{"N", companyId, jobLdrNum}, new int[]{Types.VARCHAR, Types.NUMERIC, Types.NUMERIC});
		
		int cnt = 0;
		for(Map map: list){
			String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
			String kpiNo = map.get("KPI_NO")==null?"":map.get("KPI_NO").toString();
			String prio = map.get("PRIO")==null?"0":map.get("PRIO").toString();
			
			if(checkFlag.equals("checked")){
				result += caDao.update("CA.OPERATOR_KPI_MAPP_MERGE", new Object[]{companyId, jobLdrNum, kpiNo, "Y",  userid, prio}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC});
				cnt++;
			}
		}
		if(cnt>0){
			//1개 이상의 지표가 매핑된 경우 우선순위 가중치를 재계산 함.
			result += caDao.update("CA.OPERATOR_KPI_MAPP_UPDATE_WEI", new Object[]{companyId, jobLdrNum, companyId, jobLdrNum, companyId, jobLdrNum, companyId, jobLdrNum}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		}
		return result;
	}
	
	/**
	 * 역량매핑 저장(고객사) 
	 */
	public int operatorCompetencyMappingSaveService(List<Map<String, Object>> list, User user,String jobLdrNum){
		
		int result = 0;
		
		log.debug("직무번호"+jobLdrNum);
		
		for(Map map: list){
			String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
			
			if(checkFlag.equals("checked=\"1\"")){
				checkFlag = "Y";
				
				String cmpNumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
				
			    long  companyId = user.getCompanyId();		    			    
			  
			    
			    result = caDao.mergeCompetencyMappingDao(companyId, jobLdrNum, cmpNumber, checkFlag);
			}
			if(checkFlag.equals("N")){
				checkFlag = "N";
				
				long  companyId = user.getCompanyId();
				String cmpNumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
				
				log.debug(checkFlag);
				result = caDao.updateCompetencyMappingDao(companyId, jobLdrNum, cmpNumber, checkFlag);
			}			
		}	   		
		
		
		return result;
	}
	
	/**
	 * 역량매핑 엑셀 다운로드 조회
	 */
	public List getcaOperatorCmptMappExcel(long companyId){
		
		return caDao.getcaOperatorCmptMappExcelDao(companyId);
	}
	
	
	/**
	 * 역량매핑 엑셀업로드(고객사) 
	 */
		@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
		public int caOperatorCmptMappUploadService(User user, HttpServletRequest request){
			int saveCount = 0;
			
			//엑셀 xls, xlsx 처리가능.
			Workbook workbook = null;
			Sheet sheet = null;
			Row row = null;
			Cell cell = null;
		     
		     long companyId = user.getCompanyId();
		     long sessionId = user.getUserId();
		     
		     try {
		    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
		    	 
	            File file= multiWrapper.getFiles("files")[0];
	            
	            FileInputStream fileInputStrem = new FileInputStream(file);
			     
	          //워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
				workbook = WorkbookFactory.create(fileInputStrem); 
				//workbook = new HSSFWorkbook(fileInputStrem);

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
		                 for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
		                 {
		                     row  = sheet.getRow( i);
		                     
		                     String jobLdrNum = "";
		                     String cmpNumber= "";
		                     String checkFlag = "";
	                         
	                        //기록물철의 경우 실제 데이터가 끝나는 Column지정
	    	                 int nColumnEndIndex = sheet.getRow(i).getLastCellNum();
	    	                 
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
			                         
			                         switch (nColumn) {
			                         	
			                         	 case 2 : jobLdrNum = szValue; break; 
			                         	 case 5 : cmpNumber = szValue; break;
			                         	 case 6 : checkFlag = szValue; break;
			                         }
		                         }	                         
		                     }
		                     
		                     if(checkFlag == "" || checkFlag.equals(null)){
		                    	 checkFlag = "Y"; 
		                     }
		                     
		                     saveCount = caDao.mergeCompetencyMappingDao(companyId, jobLdrNum, cmpNumber, checkFlag);
		                    
		                }
		             }
		         }
		     }
		     catch(Exception e){
		         e.printStackTrace();
		     }
			
			return saveCount;
		}
	
		/**
		 * Kpi매핑 엑셀업로드(고객사) 
		 */
			@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
			public int caOperatorKpiMappUploadService(User user, HttpServletRequest request){
				int saveCount = 0;
				
				//엑셀 xls, xlsx 처리가능.
				Workbook workbook = null;
				Sheet sheet = null;
				Row row = null;
				Cell cell = null;
			     
			     long companyId = user.getCompanyId();
			     long sessionId = user.getUserId();
			     
			     try {
			    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
			    	 
		            File file= multiWrapper.getFiles("files")[0];
		            
		            FileInputStream fileInputStrem = new FileInputStream(file);
				     
		          //워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
					workbook = WorkbookFactory.create(fileInputStrem); 
					//workbook = new HSSFWorkbook(fileInputStrem);

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
			                 
			                 Map kpiMap = new HashMap();
			                 for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
			                 {
			                     row  = sheet.getRow( i);
			                     
			                     String jobLdrNum = "";
			                     String kpiNo= "";
			                     String checkFlag = "";
			                     String prio = "";
		                        //기록물철의 경우 실제 데이터가 끝나는 Column지정
		    	                 int nColumnEndIndex = sheet.getRow(i).getLastCellNum();
		    	                 
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
				                         
				                         switch (nColumn) {
				                         	 case 2 : jobLdrNum = szValue; kpiMap.put(szValue, ""); break; 
				                         	 case 4 : kpiNo = szValue; break;
				                         	 case 10 : prio = szValue; break;
				                         	 case 11 : checkFlag = szValue; break;
				                         }
			                         }	                         
			                     }
			                     
			                     if(checkFlag == null || checkFlag.equals("") || checkFlag.length()>1){
			                    	 checkFlag = "Y"; 
			                     }
			                     
			                     if(CommonUtils.isStringLong(jobLdrNum) && CommonUtils.isStringLong(kpiNo)){
			                    	 saveCount += caDao.update("CA.OPERATOR_KPI_MAPP_MERGE", new Object[]{companyId, jobLdrNum, kpiNo, checkFlag, sessionId, prio}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC});
			                     }
			                }
		
							Set keyset = kpiMap.keySet();
							Object[] hashkeys = keyset.toArray();
							log.debug("@@@@@@@@@@@@ saveCount:"+saveCount+", hashkeys.length:"+hashkeys.length);
							if (saveCount > 0 && hashkeys.length > 0) {
								for (int i = 0; i < hashkeys.length; i++) {
		
									//Integer key = (Integer) hashkeys[i];
		log.debug("@@@@@@@@@@@@ hashkeys[i]:"+hashkeys[i]);
									// 1개 이상의 지표가 매핑된 경우 우선순위 가중치를 재계산 함.
									caDao.update(
											"CA.OPERATOR_KPI_MAPP_UPDATE_WEI",
											new Object[] { companyId, hashkeys[i], companyId,
													hashkeys[i], companyId, hashkeys[i], companyId, hashkeys[i] },
											new int[] { Types.NUMERIC, Types.NUMERIC,
													Types.NUMERIC, Types.NUMERIC,
													Types.NUMERIC, Types.NUMERIC,
													Types.NUMERIC, Types.NUMERIC });
		
								}
		
							}
			                 
			             }
			         }
			     }
			     catch(Exception e){
			         e.printStackTrace();
			     }
				
				return saveCount;
			}
		
			
	/**
	 * 과정매핑 저장
	*/
	public int setSbjctCmMapping(String subjectNum,
			List<Map<String, Object>> list, User user){
		
		int result = 0;
		
		log.debug("번호"+subjectNum);
		
		for(Map map: list){
			String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
			
			if(checkFlag.equals("checked=\"1\"")){
				checkFlag = "Y";
				
				String cmpNumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
				
			    long  companyId = user.getCompanyId();		    			    
			  
			    
			    result = caDao.mergSbjctCmMappingDao(companyId, subjectNum, cmpNumber, checkFlag);
			}
			if(checkFlag.equals("N")){
				checkFlag = "N";
				
				long  companyId = user.getCompanyId();
				String cmpNumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
				
				log.debug(checkFlag);
				result = caDao.updateSbjctCmMappingDao(companyId, subjectNum, cmpNumber, checkFlag);
			}			
		}	   		
		
		
		return result;
	}
	 
	/**
	 * 개설 차수정보 저장
	 */
	public int setSbjctOpenDetail(String subjectNum,
			List<Map<String, Object>> list2, User user)  throws Exception{
		
		int result = 0;
		
		log.debug(""+subjectNum);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		for(Map map: list2){
			
			String chasu = map.get("CHASU")==null?"":map.get("CHASU").toString();
			Date eduStime = map.get("EDU_STIME")==null? null:sdf.parse(map.get("EDU_STIME").toString());
			Date eduEtime = map.get("EDU_ETIME")==null?null:sdf.parse(map.get("EDU_ETIME").toString());
			String year = map.get("YEAR")==null?"":map.get("YEAR").toString();
				
				
			    long  companyId = user.getCompanyId();		    			    
			    
			    result = caDao.mergeSbjctOpenDetail(companyId, subjectNum, chasu, eduStime, eduEtime, year);
				
		}	   		
		
		
		return result;
	}
	
	/**
	 * 과정 새로 저장
	 */
	public int setSbjctDatail(String subjectName,
			String trainingCode, String institueName, String eduTarget,
			String eduObject, String course_cont, User user, String useFlag, String sampleUrl){
		
			long companyId = user.getCompanyId();
			
			
		int result = 0;
		
		result = caDao.insertSbjctOpenDao(subjectName, trainingCode, institueName, eduTarget, eduObject, course_cont, companyId, useFlag, sampleUrl);
		
		return result;
	}
	
	
	/**
	 * 과정 상세 저장
	 */
	public int setSbjctOpen(String subjectNum, String subjectName,
			String trainingCode, String institueName, String eduTarget,
			String eduObject, String course_cont, User user, String useFlag, String sampleUrl){
		
			long companyId = user.getCompanyId();
			
			
		int result = 0;
		
		result = caDao.mergeSbjctOpenDao(subjectName, trainingCode, institueName, eduTarget, eduObject, course_cont, companyId, subjectNum, useFlag, sampleUrl);
		
		return result;
	}
	
	/**
	 * 개설 차수 삭제
	 */
	public int delSbjectOpen(String subjectNum, String year, String chasu, User user){
		
			long companyId = user.getCompanyId();
			
			
		int result = 0;
		
		result = caDao.delSbjectOpen(subjectNum, year, chasu, companyId);
		
		return result;
	}
	
	public List consistencyList(User user) {

		return caDao.consistencyListDao(user.getCompanyId());
	} 

	public List cmptDiagnosisList(User user) {

		return caDao.cmptDiagnosisListDao(user.getCompanyId());
	}
	
	//역량 평가자 설정 리스트
	public List cmptTargetList(User user, String runNum) {
		
		if(runNum == null || "".equals(runNum)){
			runNum = caDao.getMaxRun(user.getCompanyId());
		}
		
		return caDao.cmptTargetListDao(user.getCompanyId(), runNum);
	}
	
	//역량 평가자 설정 리스트V2
	public List cmptTargetListV2(User user, String runNum) {
		
		if(runNum == null || "".equals(runNum)){
			runNum = caDao.getMaxRun(user.getCompanyId());
		}
		
		return caDao.cmptTargetListV2Dao(user.getCompanyId(), runNum);
	}
	
	
	//역량 평가자 설정 리스트(동료,부하)
	public List cmptListUser(long companyid, long pUserid, String colUserid) {
		
	
		
		return caDao.cmptListUserDao(companyid, pUserid, colUserid);
	}
	
	
	//역량 평가자 설정 엑셀업로드 
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int cmptTargetExcelSaveService(String runNum, User user, HttpServletRequest request){
		int saveCount = 0;
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;
	     
	     long companyId = user.getCompanyId();
	     long sessionId = user.getUserId();
	     
	     try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("files")[0];
            
            FileInputStream fileInputStrem = new FileInputStream(file);
		     
          //워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 
			//workbook = new HSSFWorkbook(fileInputStrem);

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
	                 for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                 {
	                     row  = sheet.getRow( i);
	                     
	                     String divisionId = "";
	                     String checkFlag= "";
	                     String job = "";
	                     String leadership = "";
                         String userId = "";
                         String selfWeight = "";
                         String oneUserId = "";
                         String oneWeight = "";
                         String twoUserId = "";
                         String twoWeight = "";
                         String empNo = "";
                         String empNo2 = "";
                         String colUserId = "";
                         String colWeight = "";
                         String subUserId = "";
                         String subWeight = "";
                         
                        //기록물철의 경우 실제 데이터가 끝나는 Column지정
    	                 int nColumnEndIndex = sheet.getRow(i).getLastCellNum();
    	                 
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
		                         
		                         switch (nColumn) {
		                         	 case 1 : checkFlag = szValue; break;
		                         	 case 3 : divisionId = szValue; break;
			                         case 5 : userId = szValue; break;
			                         case 8 : selfWeight = szValue;  break;
			                         case 9 : if(szValue!=null) colUserId = caDao.userTargetColUser(companyId, szValue); else colUserId ="";break;
			                         case 10 : colWeight = szValue;  break;
			                         case 11 : if(szValue!=null) subUserId = caDao.userTargetSubUser(companyId, szValue); else subUserId ="";break;
			                         case 12 : subWeight = szValue;  break;
			                         case 14 : if(szValue!=null) oneUserId = caDao.userTargetOneUser(companyId, szValue); else oneUserId ="";break;
			                         case 15 : oneWeight = szValue;  break;
			                         case 17 : if(szValue!=null) twoUserId = caDao.userTargetTwoUser(companyId, szValue); else twoUserId =""; break;
			                         case 18 : twoWeight = szValue;  break;
		                         }
	                         }
	                     }

	                     log.debug("checkFlag : " + checkFlag);
	                     log.debug("runNum : " + runNum);
	                     log.debug("userId : " + userId);
	                     log.debug("oneUserId : " + oneUserId);
	                     log.debug("twoUserId : " + twoUserId);
	                     log.debug("divisionId : " + divisionId);
	                     log.debug("oneUserId : " + oneUserId);
	                     log.debug("twoUserId : " + twoUserId);
	                     log.debug("colUserId : " + colUserId);
	                     log.debug("colWeight : " + colWeight);
	                     log.debug("subUserId : " + subUserId);
	                     log.debug("subWeight : " + subWeight);
	                                        	                     	                     
	                   	                     
	                    if(checkFlag.equals("Y") || checkFlag.equals("y")){
	                    	
		                    saveCount = caDao.mergeCmptTargetDao(companyId, runNum, divisionId, userId, job, leadership, sessionId ,checkFlag);			     		
		                    
		     				//기존 설정된 평가방향 초기화..
							caDao.initCmptDirectionUserDao(sessionId, companyId, runNum, userId);
							
		                    
		     				//자가 평가
		     				if(selfWeight != null && !"".equals(selfWeight)){
		     					saveCount = caDao.mergeCmptDirectionSelfDao(companyId, runNum, userId, sessionId, selfWeight, checkFlag);					
		     				}		
		     				
		     				//동료 평가자
							if(colUserId != null && !"".equals(colUserId)){
									
								String colUserIdTmp = "";
								
								//caDao.delCmptDirectioncolDao(sessionId, companyId, runNum, userId);
								
								String[] colUserIdArr = colUserId.split(",");
								
								for(int j = 0; j < colUserIdArr.length; j ++){
									
									colUserIdTmp = colUserIdArr[j].trim();
									log.debug("colUserIdTmp"+colUserIdTmp);
									log.debug("colWeight"+colWeight);
									
									if(colUserIdTmp == "0" || colUserIdTmp.equals("0")){
										
									}else{
										saveCount = caDao.mergeCmptDirectioncolDao(companyId, runNum, colUserIdTmp, userId, sessionId, colWeight, checkFlag);
									}
								}
							}
							//부하 평가자
							if(subUserId != null && !"".equals(subUserId)){
								
								String subUserIdTmp = "";
								
								//caDao.delCmptDirectionsubDao(sessionId, companyId, runNum, userId);
								
								String[] subUserIdArr = subUserId.split(",");
								
								for(int j = 0; j < subUserIdArr.length; j ++){
									
									subUserIdTmp = subUserIdArr[j].trim();
									log.debug("subUserIdTmp"+subUserIdTmp);
									log.debug("colWeight"+colWeight);
									
									if(subUserIdTmp == "0" || subUserIdTmp.equals("0")){
										
									}else{
										saveCount = caDao.mergeCmptDirectionsubDao(companyId, runNum, subUserIdTmp, userId, sessionId, subWeight, checkFlag);	
									}
								}
							}
		     				
		     				//1차 평가자
		     				if(oneUserId != null && !"".equals(oneUserId)){
		     					saveCount = caDao.mergeCmptDirectionOneDao(companyId, runNum, oneUserId, userId, sessionId, oneWeight, checkFlag);					
		     				}
		     				//2차 평가자
		     				if(twoUserId != null && !"".equals(twoUserId)){
		     					saveCount = caDao.mergeCmptDirectionTwoDao(companyId, runNum, twoUserId, userId, sessionId, twoWeight, checkFlag);					
		     				}
	                     
	                    }else if(checkFlag.equals("") || checkFlag.equals("N") || checkFlag.equals("n")){
	        								
	                    	checkFlag = "N";
	                    	
	                    	saveCount = caDao.updateCmptTargetUserDao(checkFlag, sessionId, companyId, runNum, userId);
	        				
	        				//자가 평가
	        				if(selfWeight != null && !"".equals(selfWeight)){
	        					saveCount = caDao.updateCmptDirectionSelfDao(checkFlag, companyId, runNum, userId, sessionId);					
	        				}					
	        				//1차 평가
	        				if(oneUserId != null && !"".equals(oneUserId)){					
	        					saveCount = caDao.updateCmptDirectionOneDao(checkFlag, companyId, runNum, oneUserId, userId, sessionId);					
	        				}
	        				//1차 평가
	        				if(twoUserId != null && !"".equals(twoUserId)){					
	        					saveCount = caDao.updateCmptDirectionTwoDao(checkFlag, companyId, runNum, twoUserId, userId, sessionId);					
	        				}	
	        				
	        			}
	                    
	                    
	                }
	             }
	         }
	     }
	     catch(Exception e){
	         e.printStackTrace();
	     }
		
		return saveCount;
	}

	/**
	 * 대상자관리 저장.
	 */
	public int runTargetSave(HttpServletRequest request, User user) {
		int resultCnt = 0;
		
		try {
			//대상자 정보
			List<Map<String, Object>> list1 = ParamUtils.getJsonParameter(request, "item", "LIST1",List.class);
			
			long sessionId = user.getUserId();	
			long companyId = user.getCompanyId();
			String runNum = ParamUtils.getParameter(request, "RUN_NUM");
			//String useFlag = ParamUtils.getParameter(request, "USEFLAG");
			
			//caDao.update("CA.TB_RUN_TARGET_YN", new Object[]{companyId, runNum}, new int[]{Types.NUMERIC, Types.NUMERIC});
			//대상자
			for(Map map: list1){
					String division = map.get("DIVISIONID")==null?"":map.get("DIVISIONID").toString();
					String job = map.get("JOB")==null?"":map.get("JOB").toString();
					String leadership = map.get("LEADERSHIP")==null?"":map.get("LEADERSHIP").toString();
					String user_id = map.get("USERID")==null?"":map.get("USERID").toString();
					String useFlag = map.get("USEFLAG")==null?"":map.get("USEFLAG").toString();
					String grade = map.get("GRADE_NUM")==null?"":map.get("GRADE_NUM").toString();
					resultCnt += caDao.update("CA.TB_RUN_TARGET_MAP", new Object[]{companyId, runNum, useFlag, division, job, leadership,  user_id, sessionId,grade}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR , Types.NUMERIC , Types.NUMERIC,Types.VARCHAR });
			}
			

		} catch(Throwable e) {
			log.error(e);
		}
		
		return resultCnt;
	}
	
	
	
	/**
	 * 방향설정 진단자 저장.
	 */
	public int saveDirUser(HttpServletRequest request, User user) {
		int resultCnt = 0;
		try {
			//상사진단 정보
			List<Map<String, Object>> list1 = ParamUtils.getJsonParameter(request, "item", "LIST1",List.class);
			//동료진단 정보
			List<Map<String, Object>> list2 = ParamUtils.getJsonParameter(request, "item", "LIST2",List.class);
			//부하진단 정보
			List<Map<String, Object>> list3 = ParamUtils.getJsonParameter(request, "item", "LIST3",List.class);
			
			long sessionId = user.getUserId();
			String userIdExed = ParamUtils.getParameter(request, "USERID_EXED");
			String runNum = ParamUtils.getParameter(request, "RUN_NUM");
			String selfChecked = ParamUtils.getParameter(request, "SELF_CHECKED");
			String dirCd = ParamUtils.getParameter(request, "DIR_CD");

			
			
			//진단자정보 전체 사용안함처리.
			resultCnt+=caDao.update("CA.TB_RUN_DIR_USER_UPDATE", new Object[]{user.getCompanyId(), runNum,userIdExed,dirCd}, new int []{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,Types.VARCHAR});
			
			//상사진단 merge
			if("4".equals(dirCd)){
				for(Map map: list1){
					String userId = map.get("USERID")==null?"":map.get("USERID").toString();
					String useFlag = "Y";
					resultCnt += caDao.update("CA.MERGE_TB_RUN_DIR_MAP", new Object[]{user.getCompanyId(), runNum, userId, userIdExed, dirCd, useFlag, sessionId}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR });
				}
			}
			//동료진단 merge
			if("3".equals(dirCd)){
				for(Map map: list2){
					String userId = map.get("USERID")==null?"":map.get("USERID").toString();
					String useFlag = "Y";
					resultCnt += caDao.update("CA.MERGE_TB_RUN_DIR_MAP", new Object[]{user.getCompanyId(), runNum, userId, userIdExed, dirCd, useFlag, sessionId}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR });
				}
			}
			//부하진단 merge
			if("2".equals(dirCd)){
				for(Map map: list3){
					String userId = map.get("USERID")==null?"":map.get("USERID").toString();
					String useFlag = "Y";
					resultCnt += caDao.update("CA.MERGE_TB_RUN_DIR_MAP", new Object[]{user.getCompanyId(), runNum, userId, userIdExed, dirCd, useFlag, sessionId}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR });
				}
			}
			if("1".equals(dirCd)){
				if("checked".equals(selfChecked)){
					String useFlag = "Y";
					resultCnt += caDao.update("CA.MERGE_TB_RUN_DIR_MAP", new Object[]{user.getCompanyId(), runNum, userIdExed, userIdExed, dirCd, useFlag, sessionId}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR });
				}
			}

			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return resultCnt;
	}
	/**
	 * 방향설정 진단자 저장.
	 */
	public int saveDirAutoUser(HttpServletRequest request, User user) {
		log.debug("## CAService saveDirAutoUser start..........");
		int saveCount = 0;
		int runNum = Integer.valueOf(ParamUtils.getParameter(request, "RUN_NUM", "0"));
		try {
			/*
			 * 프로시져 Call
			 * 호출은 DAO 에서 구현해야 함
			 */
			//saveCount += excute("CA.SET_RUN_DIR_AUTO_SAVE", new Object[]{user.getCompanyId(), runNum, user.getUserId(), ""}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
			saveCount = caDao.setRunDirAutoUser(user.getCompanyId(), user.getUserId(), runNum);
			log.debug("===================================="+saveCount);
		} catch(Throwable e) {
			log.error(e);
		}
		
		return saveCount;
	}
	
	
	
	//역량 평가자 설정 평가자 리스트
	public List cmptTargetUserList(User user, int dvsId, int highDvsId) {		
		
		return caDao.cmptTargetUserDao(user.getCompanyId(), dvsId, highDvsId);
	}
	
	//역량평가자 설정 단일 저장
		public int cmptSingleTargetSave(Map<String, Object> map, User user){
			
			int saveCount = 0;
			
			long companyId = user.getCompanyId();
			long sessionId = user.getUserId();
			
			
			String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
			log.debug(checkFlag);
				
				if(checkFlag.equals("checked=\"1\"")){
					
					checkFlag = "Y";						
					
					String runNum = map.get("RUN_NUM")==null?"":map.get("RUN_NUM").toString();
					String userId = map.get("USERID")==null?"":map.get("USERID").toString();
					String divisionId = map.get("DIVISIONID")==null?"":map.get("DIVISIONID").toString();
					String job = map.get("JOB")==null?"":map.get("JOB").toString();
					String leadership = map.get("LEADERSHIP")==null?"":map.get("LEADERSHIP").toString();
					
					String selfWeight = map.get("SELF_WEIGHT")==null?"":map.get("SELF_WEIGHT").toString();
					String oneUserId = map.get("ONE_USERID")==null?"":map.get("ONE_USERID").toString();
					String oneWeight = map.get("ONE_WEIGHT")==null?"":map.get("ONE_WEIGHT").toString();
					String twoUserId = map.get("TWO_USERID")==null?"":map.get("TWO_USERID").toString();
					String twoWeight = map.get("TWO_WEIGHT")==null?"":map.get("TWO_WEIGHT").toString();
					
		
					
					
					saveCount = caDao.mergeCmptTargetDao(companyId, runNum, divisionId, userId, job, leadership, sessionId ,checkFlag);
					
					//자가 평가
					if(selfWeight != null && !"".equals(selfWeight)){
						saveCount = caDao.mergeCmptDirectionSelfDao(companyId, runNum, userId, sessionId, selfWeight, checkFlag);					
					}	

					//1차 평가자
					if(oneUserId != null && !"".equals(oneUserId)){
						saveCount = caDao.mergeCmptDirectionOneDao(companyId, runNum, oneUserId, userId, sessionId, oneWeight, checkFlag);					
					}
					//2차 평가자
					if(twoUserId != null && !"".equals(twoUserId)){
						saveCount = caDao.mergeCmptDirectionTwoDao(companyId, runNum, twoUserId, userId, sessionId, twoWeight, checkFlag);					
					}
					
				}
				
			return saveCount;
		}
		
		//역량평가자 설정 단일 저장
		public int cmptSingleTargetSaveV2(Map<String, Object> map, User user){
			
			int saveCount = 0;
			
			long companyId = user.getCompanyId();
			long sessionId = user.getUserId();
			
			
			String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
			log.debug(checkFlag);
				
				if(checkFlag.equals("checked=\"1\"")){
					
					checkFlag = "Y";						
					
					String runNum = map.get("RUN_NUM")==null?"":map.get("RUN_NUM").toString();
					String userId = map.get("USERID")==null?"":map.get("USERID").toString();
					String divisionId = map.get("DIVISIONID")==null?"":map.get("DIVISIONID").toString();
					String job = map.get("JOB")==null?"":map.get("JOB").toString();
					String leadership = map.get("LEADERSHIP")==null?"":map.get("LEADERSHIP").toString();
					
					String selfWeight = map.get("SELF_WEIGHT")==null?"":map.get("SELF_WEIGHT").toString();
					String colUserId = map.get("COL_USERID")==null?"":map.get("COL_USERID").toString();
					String colWeight = map.get("COL_WEIGHT")==null?"":map.get("COL_WEIGHT").toString();
					String subUserId = map.get("SUB_USERID")==null?"":map.get("SUB_USERID").toString();
					String subWeight = map.get("SUB_WEIGHT")==null?"":map.get("SUB_WEIGHT").toString();
					String oneUserId = map.get("ONE_USERID")==null?"":map.get("ONE_USERID").toString();
					String oneWeight = map.get("ONE_WEIGHT")==null?"":map.get("ONE_WEIGHT").toString();
					String twoUserId = map.get("TWO_USERID")==null?"":map.get("TWO_USERID").toString();
					String twoWeight = map.get("TWO_WEIGHT")==null?"":map.get("TWO_WEIGHT").toString();
					
					String colUserIdTmp = "";
					String subUserIdTmp = "";

					
					//대상자테이블 MERGE..
					saveCount += caDao.mergeCmptTargetDao(companyId, runNum, divisionId, userId, job, leadership, sessionId ,checkFlag);
					
					//설정 전 기존 방향 설정값 초기화..
					caDao.initCmptDirectionUserDao(sessionId, companyId, runNum, userId);
					
					//자가 평가
					if(selfWeight != null && !"".equals(selfWeight)){
						saveCount += caDao.mergeCmptDirectionSelfDao(companyId, runNum, userId, sessionId, selfWeight, checkFlag);					
					}	
					//동료 평가자
					if(colUserId != null && !"".equals(colUserId)){
							
						//caDao.delCmptDirectioncolDao(sessionId, companyId, runNum, userId);
						
						String[] colUserIdArr = colUserId.split(",");
						
						for(int i = 0; i < colUserIdArr.length; i ++){
							
							colUserIdTmp = colUserIdArr[i].trim();
							log.debug("colUserIdTmp"+colUserIdTmp);
							log.debug("colWeight"+colWeight);
							
							if(colUserIdTmp == "0" || colUserIdTmp.equals("0")){
								
							}else{
								saveCount += caDao.mergeCmptDirectioncolDao(companyId, runNum, colUserIdTmp, userId, sessionId, colWeight, checkFlag);
							}
						}
					}
					//부하 평가자
					if(subUserId != null && !"".equals(subUserId)){
						
						//caDao.delCmptDirectionsubDao(sessionId, companyId, runNum, userId);
						
						String[] subUserIdArr = subUserId.split(",");
						
						for(int i = 0; i < subUserIdArr.length; i ++){
							
							subUserIdTmp = subUserIdArr[i].trim();
							log.debug("subUserIdTmp"+subUserIdTmp);
							log.debug("colWeight"+colWeight);
							
							if(subUserIdTmp == "0" || subUserIdTmp.equals("0")){
								
							}else{
								saveCount += caDao.mergeCmptDirectionsubDao(companyId, runNum, subUserIdTmp, userId, sessionId, subWeight, checkFlag);	
							}
						}
					}

					//1차 평가자
					if(oneUserId != null && !"".equals(oneUserId)){
						saveCount += caDao.mergeCmptDirectionOneDao(companyId, runNum, oneUserId, userId, sessionId, oneWeight, checkFlag);					
					}
					//2차 평가자
					if(twoUserId != null && !"".equals(twoUserId)){
						saveCount += caDao.mergeCmptDirectionTwoDao(companyId, runNum, twoUserId, userId, sessionId, twoWeight, checkFlag);					
					}
					
				}
				
			return saveCount;
		}
	
	//역량평가자 설정 저장
	public int cmptTargetSave(String runNum, List<Map<String, Object>> list,
			User user) {
		
		int saveCount = 0;
		
		long companyId = user.getCompanyId();
		long sessionId = user.getUserId();
		
		//대상자 테이블 초기화..
		saveCount+=caDao.updateCmptTargetDao("N", sessionId, companyId, runNum);
		//평가방향 테이블 초기화..
		saveCount+=caDao.updateCmptDirectionDao("N", companyId, runNum, sessionId); 
		
		for(Map map: list){
			String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
			log.debug(checkFlag);
			if(checkFlag.equals("checked=\"1\"")){ 
				
				checkFlag = "Y";						

				String userId = map.get("USERID")==null?"":map.get("USERID").toString();
				String divisionId = map.get("DIVISIONID")==null?"":map.get("DIVISIONID").toString();
				String job = map.get("JOB")==null?"":map.get("JOB").toString();
				String leadership = map.get("LEADERSHIP")==null?"":map.get("LEADERSHIP").toString();
				String checkflag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
				
				String selfWeight = map.get("SELF_WEIGHT")==null?"":map.get("SELF_WEIGHT").toString();
				String colUserId = map.get("COL_USERID")==null?"":map.get("COL_USERID").toString();
				String colWeight = map.get("COL_WEIGHT")==null?"":map.get("COL_WEIGHT").toString();
				String subUserId = map.get("SUB_USERID")==null?"":map.get("SUB_USERID").toString();
				String subWeight = map.get("SUB_WEIGHT")==null?"":map.get("SUB_WEIGHT").toString();
				String oneUserId = map.get("ONE_USERID")==null?"":map.get("ONE_USERID").toString();
				String oneWeight = map.get("ONE_WEIGHT")==null?"":map.get("ONE_WEIGHT").toString();
				String twoUserId = map.get("TWO_USERID")==null?"":map.get("TWO_USERID").toString();
				String twoWeight = map.get("TWO_WEIGHT")==null?"":map.get("TWO_WEIGHT").toString();
				
				
				log.debug("oneUserId"+oneUserId);
				log.debug("colUserId"+colUserId);
				log.debug("subUserId"+subUserId);
				
				saveCount += caDao.mergeCmptTargetDao(companyId, runNum, divisionId, userId, job, leadership, sessionId ,checkFlag);
				
				//자가 평가
				if(selfWeight != null && !"".equals(selfWeight)){
					saveCount += caDao.mergeCmptDirectionSelfDao(companyId, runNum, userId, sessionId, selfWeight, checkFlag);					
				}
				//동료 평가자
				if(colUserId != null && !"".equals(colUserId)){
					String colUserIdTmp = "";
					
					//caDao.delCmptDirectioncolDao(sessionId, companyId, runNum, userId);
					
					String[] colUserIdArr = colUserId.split(",");
					
					for(int i = 0; i < colUserIdArr.length; i ++){
						
						colUserIdTmp = colUserIdArr[i].trim();
						log.debug("colUserIdTmp"+colUserIdTmp);
						log.debug("colWeight"+colWeight);
						
						if(colUserIdTmp == "0" || colUserIdTmp.equals("0")){
							
						}else{
							saveCount += caDao.mergeCmptDirectioncolDao(companyId, runNum, colUserIdTmp, userId, sessionId, colWeight, checkFlag);
						}
					}
				}
				
				//부하 평가자
				if(subUserId != null && !"".equals(subUserId)){
					String subUserIdTmp = "";
					//caDao.delCmptDirectionsubDao(sessionId, companyId, runNum, userId);
					
					String[] subUserIdArr = subUserId.split(",");
					
					for(int i = 0; i < subUserIdArr.length; i ++){
						
						subUserIdTmp = subUserIdArr[i].trim();
						log.debug("subUserIdTmp"+subUserIdTmp);
						log.debug("subWeight"+subWeight);
						
						if(subUserIdTmp == "0" || subUserIdTmp.equals("0")){
							
						}else{
							saveCount += caDao.mergeCmptDirectionsubDao(companyId, runNum, subUserIdTmp, userId, sessionId, subWeight, checkFlag);	
						}
					}
				}
				//1차 평가자
				if(oneUserId != null && !"".equals(oneUserId)){
					saveCount += caDao.mergeCmptDirectionOneDao(companyId, runNum, oneUserId, userId, sessionId, oneWeight, checkFlag);					
				}
				//2차 평가자
				if(twoUserId != null && !"".equals(twoUserId)){
					saveCount += caDao.mergeCmptDirectionTwoDao(companyId, runNum, twoUserId, userId, sessionId, twoWeight, checkFlag);					
				}
				
			}
		}
		

		return saveCount;
	}
	
	
	//설문관리 POOL 저장
		public int getQstnPoolSave(List<Map<String, Object>> list,
				User user) {
			
			int result = 0;
			
			long companyId = user.getCompanyId();
			long sessionId = user.getUserId();

			
			for(Map map: list){		
				
				String qstnPoolNo = map.get("QSTN_POOL_NO")==null?"":map.get("QSTN_POOL_NO").toString();
				String qstnTypeCd = map.get("QSTN_TYPE_CD")==null?"":map.get("QSTN_TYPE_CD").toString();
				String qstn = map.get("QSTN")==null?"":map.get("QSTN").toString();
				
				log.debug("이경상"+qstnPoolNo);
				
				if(qstnPoolNo == null || "".equals(qstnPoolNo)){
					log.debug("이경상"+qstnPoolNo);
					qstnPoolNo = caDao.getMaxQstnPoolNo(user.getCompanyId());
				}
				
					
				result = caDao.mergeQstnPooltDao(qstnPoolNo, qstnTypeCd, qstn, companyId, sessionId);
					
				log.debug("qstnTypeCd="+qstnTypeCd);
				log.debug("qstn="+qstn);
					
			}
			return result;
		}
		
		//설문 저장
		public int getQstnRstSave(List<Map<String, Object>> list,
				User user, String ppNo, String age, String gender) {
			
			int result = 0;
			
			long companyId = user.getCompanyId();
			long sessionId = user.getUserId();

			
			for(Map map: list){
				
				String qstnTypeCd = map.get("QSTN_TYPE_CD")==null?"":map.get("QSTN_TYPE_CD").toString();
				String qstnSeq = map.get("QSTN_SEQ")==null?"":map.get("QSTN_SEQ").toString();
				String svRst = map.get("SV_RST")==null?"":map.get("SV_RST").toString();
					
				result = caDao.mergeQstnRsttDao(companyId, ppNo, sessionId, qstnSeq, svRst);
				
					
				log.debug("qstnTypeCd="+qstnTypeCd);
				log.debug("qstnSeq="+qstnSeq);
				log.debug("svRst="+svRst);
					
			}
			
			if(result != 0 ){
				result = caDao.updateQstnRsttDao(age, gender, companyId, ppNo, sessionId);
			}
			
			return result;
		}
		
		
		//설문관리 Bind 저장
		public int getQstnBindSave(String ppNo, List<Map<String, Object>> list,
				User user) {
			
			int result = 0;
			
			long companyId = user.getCompanyId();
			long sessionId = user.getUserId();

			
			for(Map map: list){
				String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
					log.debug(checkFlag);
				if(checkFlag.equals("checked=\"1\"")){
				
					String qstnTypeCd = map.get("QSTN_TYPE_CD")==null?"":map.get("QSTN_TYPE_CD").toString();
					String qstn = map.get("QSTN")==null?"":map.get("QSTN").toString();
					String qstnSeq = map.get("QSTN_SEQ")==null?"":map.get("QSTN_SEQ").toString();
					
					if(qstnSeq == null || "".equals(qstnSeq)){
						qstnSeq = caDao.getMaxQstnSeq(user.getCompanyId());
					}
					
						
					result = caDao.mergeQstnDao(qstnSeq, qstnTypeCd, qstn, companyId, sessionId , ppNo);
						
					log.debug("qstnTypeCd="+qstnTypeCd);
					log.debug("qstn="+qstn);
					
				}
			}
			return result;
		}
		
		//대상자관리 Bind 저장
		public int getUserBindSave(String ppNo, List<Map<String, Object>> list,
				User user) {
			
			int result = 0;
			
			long companyId = user.getCompanyId();
			long sessionId = user.getUserId();

			
			for(Map map: list){
				String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
				log.debug(checkFlag);
				if(checkFlag.equals("checked=\"1\"")){
				
				String userId = map.get("USERID")==null?"":map.get("USERID").toString();
					
				result = caDao.mergeServUserDao(userId, ppNo, companyId, sessionId);
					
				log.debug("userId="+userId);
				
				}
			}
			
			return result;
		}
		
		
	//설문관리 POOL 삭제
	public int getQstnPoolDel(String qstnPoolNo, User user) {
			
			int result = 0;
			
			long companyId = user.getCompanyId();
			long sessionId = user.getUserId();
			
			result = caDao.updateQstnPooltDao(sessionId, qstnPoolNo, companyId);
	
			return result;
		}
	
	//설문관리  삭제
	public int getQstnDel(List<Map<String, Object>> list, String ppNo, User user) {
		
		int result = 0;
		
		long companyId = user.getCompanyId();
		long sessionId = user.getUserId();
		
		for(Map map: list){
			String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
				log.debug(checkFlag);
			if(checkFlag.equals("checked=\"1\"")){
				
				String qstnTypeCd = map.get("QSTN_TYPE_CD")==null?"":map.get("QSTN_TYPE_CD").toString();
				String qstn = map.get("QSTN")==null?"":map.get("QSTN").toString();
				String qstnSeq = map.get("QSTN_SEQ")==null?"":map.get("QSTN_SEQ").toString();
				
					
				result = caDao.updateQstnDao(sessionId, ppNo, companyId, qstnSeq);
					
				log.debug("qstnTypeCd="+qstnTypeCd);
				log.debug("qstn="+qstn);
			}
		}
		
		

		return result;
	}
	
	//설문지  삭제
	public int getServPpDel(List<Map<String, Object>> list, User user) {
		
		int result = 0;
		
		long companyId = user.getCompanyId();
		long sessionId = user.getUserId();
		
		for(Map map: list){
			String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
				log.debug(checkFlag);
			if(checkFlag.equals("checked=\"1\"")){
				
				String qstnTypeCd = map.get("QSTN_TYPE_CD")==null?"":map.get("QSTN_TYPE_CD").toString();
				String qstn = map.get("QSTN")==null?"":map.get("QSTN").toString();
				String ppNo = map.get("PP_NO")==null?"":map.get("PP_NO").toString();
				
					
				result = caDao.updateServPpDao(sessionId, ppNo, companyId);
					
				log.debug("qstnTypeCd="+qstnTypeCd);
				log.debug("qstn="+qstn);
			}
		}
		
		

		return result;
	}
	
	//설문 대상자 관리 삭제
	public int getQstnUserDel(List<Map<String, Object>> list, String ppNo, User user) {
		
		int result = 0;
		
		long companyId = user.getCompanyId();
		long sessionId = user.getUserId();
		
		for(Map map: list){
			String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
				log.debug(checkFlag);
			if(checkFlag.equals("checked=\"1\"")){
				
				String qstnTypeCd = map.get("QSTN_TYPE_CD")==null?"":map.get("QSTN_TYPE_CD").toString();
				String qstn = map.get("QSTN")==null?"":map.get("QSTN").toString();
				String userId = map.get("USERID")==null?"":map.get("USERID").toString();
				
					
				result = caDao.updateQstnUserDao(sessionId, ppNo, companyId, userId);
					
				log.debug("qstnTypeCd="+qstnTypeCd);
				log.debug("qstn="+qstn);
			}
		}
		
		

		return result;
	}
	
	//설문관리 All 저장
	public int getServAllSave(String ppNo, String ppNm, String ppPerp,
			Date ppSt, Date ppEd, User user, String useFlag){
		
		int result = 0;
		
		long companyId = user.getCompanyId();
		long sessionId = user.getUserId();
		
		if(ppNo == null || "".equals(ppNo)){
			ppNo = caDao.getMaxppNo(user.getCompanyId());
		}
		
		result = caDao.mergeServPpDao(ppNo, ppNm, ppPerp, ppSt, ppEd, companyId, sessionId, useFlag);
		
		
		return result;
	}

	public String getRunName(long companyId, String runNum) {

		return caDao.getRunNameDao(companyId, runNum);
	}

	public List cmptStatisticsList(User user, String runNum) {
		
		if(runNum == null || "".equals(runNum)){
			runNum = caDao.getMaxRun(user.getCompanyId());
		}
		
		return caDao.cmptStatisticsListDao(user.getCompanyId(), runNum);
	}

	public int cmptDiagInitialization(User user, String runNum, String userId) {
		
		return caDao.cmptDiagInitialization(user.getCompanyId(), user.getUserId(), runNum, userId);
	}


	public List cmpExplanation(int runNum, long companyId, long userId) {

		return caDao.cmpExplanationDao(runNum, companyId, userId);
	}

	public List subelementResultList(int runNum, long companyId, long userId) {

		return caDao.subelementResultListDao(runNum, companyId,  userId);
	}

	public List subelementExplanation(int runNum, long companyId, long userId) {

		return caDao.subelementExplanationDao(runNum, companyId, userId);
	}

	public List cmpScoreList(User user, String runNum) {

		return caDao.cmpScoreListDao(runNum, user.getCompanyId(), user.getUserId());
	}

	public List subjectList(User user, String runNum, String year) {

		return caDao.subjectListDao(runNum, user.getCompanyId(), user.getUserId(), year);
	}

	public List notSubjectList(User user, String runNum, String year) {

		return caDao.notSubjectListDao(runNum, user.getCompanyId(), user.getUserId(), year);
	}

	public String diagResultString(int runNum, User user) {

		return caDao.diagResultStringDao(runNum, user.getCompanyId(), user.getUserId());
	}

	public String diagResultScore(int runNum, User user) {

		return caDao.diagResultScoreDao(runNum, user.getCompanyId(), user.getUserId());
	}

	public List developmentGuide(int runNum, User user) {

		return caDao.developmentGuideDao(runNum, user.getCompanyId(), user.getUserId());
	}

	public List recommendSubjectInfo(String subjectNum, String year, String chasu) {

		return caDao.recommendSubjectInfoDao(subjectNum, year, chasu);
	}

	public List recommendNotSubjectInfo(String subjectNum, String year, String chasu, User user, String cmpnumber) {

		return caDao.recommendNotSubjectInfoDao(subjectNum, year, chasu, user.getCompanyId(), user.getUserId(), cmpnumber);
	}

	public List cmptStatisticsClassList(long companyId, String runNum) {
		
		if(runNum == null || "".equals(runNum)){
			runNum = caDao.getMaxRun(companyId);
		}

		return caDao.cmptStatisticsClassListDao(companyId, runNum);
	}

	public List diagResultExcel(long companyId, String runNum) {

		return caDao.diagResultExcelDao(companyId, runNum);
	}

	public List<Map<String, Object>> getRunCompetencyList(long companyId, String runNum) {

		return caDao.getRunCompetencyListDao(companyId, runNum);
	}

	public List yearCategoryList(long companyId) {

		return caDao.yearCategoryListDao(companyId);
	}

	public List cmptStatisticsYearList(long companyId) {

		return caDao.cmptStatisticsYearListDao(companyId);
	}

	public List divisionCategoryList(long companyId) {

		return caDao.divisionCategoryListDao(companyId);
	}


	public List cmptStatisticsDivisionList(long companyId, String runNum) {
		if(runNum == null || "".equals(runNum)){
			runNum = caDao.getMaxRun(companyId);
		}

		return caDao.cmptStatisticsDivisionListDao(companyId, runNum);
	}

	public List recommendActivityList(long companyId) {

		return caDao.recommendActivityListDao(companyId);
	}

	public List dainPayModuleInfo(long companyId, long userId,
			String subjectNum, String year, String chasu, String cmpnumber) {
		
		String sKey = "";
		String sID = "";
		String compCd = "";
		String eduYear = "";
		String courseCd = "";
		String courseSq= "";

		try{
			// 정보암호화
			//CipherAria aria = new CipherAria();
			String id = caDao.getUserId(companyId, userId);
			courseCd =  caDao.getCpSubjectNum(subjectNum, year, chasu);

		}catch(Exception e){
			
		}
		
		return caDao.dainPayModuleInfoDao(sKey, sID, compCd, eduYear, courseCd, courseSq, subjectNum, year, chasu, companyId, userId, cmpnumber);
	}
	
	/**
	 * 가상계좌용 결제정보
	 */
	public int daoPayReturnInfo(String reqSKey, String reqSID,
			String reqCompCd, String courseCd, String courseSq, String eduYear,
			String name, String email, String hp, String amount,
			String payMethod, String cpId, String daoutrx, String orderNo,
			String settdate, String bankCode, String bankName, String accountNo, String depositendDate, String receiverName) {
		
		String userId = caDao.getUserId(reqSID);

		return caDao.insertDaoPay(userId, courseCd, eduYear, courseSq, amount, payMethod, cpId, daoutrx, orderNo, settdate, 
										bankCode, bankName, accountNo, depositendDate, receiverName);
		
	}
	
	public void daoPayCompleteInfo(String reqSKey, String reqSID,
			String reqCompCd, String courseCd, String courseSq, String eduYear,
			String name, String email, String hp, String amount,
			String payMethod, String cpId, String daoutrx, String orderNo,
			String settdate) {
		String userId = caDao.getUserId(reqSID);

		caDao.insertDaoPayOriginal(userId, courseCd, eduYear, courseSq, amount, payMethod, cpId, daoutrx, orderNo, settdate);
		
	}

	public String getUserId(String reqSID) {

		return caDao.getUserId(reqSID);
	}

	public int insertClassUser(long companyId, long userId, String subjectNum, int year, int chasu, int cmpnumber, String couponFlag) {
		
		String attendStateCode = "";
		
		if("Y".equals(couponFlag)){
			attendStateCode = "2";
		}else{
			attendStateCode = "1";
		}
		
		
		return caDao.insertClassUserDao(companyId, userId, subjectNum, year, chasu, cmpnumber, couponFlag, attendStateCode);
	}

	public int updateClassUser(int companyId, int userId, String courseCd, int eduYear, int courseSq, String attendStateCode) {

		return caDao.updateClassUserDao(companyId, userId, courseCd, eduYear, courseSq, attendStateCode);
	}

	public int mergeClassUser(long companyId, long userId, String subjectNum, int year, int chasu, int cmpnumber, String couponFlag) {

		return caDao.mergeClassUserDao(companyId, userId, subjectNum, year, chasu, cmpnumber, couponFlag);
	}
	
	/**
	 * ROLE : 학생
	 * MENU : 나의학습
	 * LMS학습창 열기 용 정보추출
	 * @param companyid
	 * @param userid
	 * @param subjectNum
	 * @param year
	 * @param chasu
	 * @return
	 * @throws BaException
	 */
	public String getStudyInfo(long companyid, long userid, String subjectNum, int year, int chasu) {
		String applyYn = "N";
		
		try { 
			log.debug("=====================start===============");
			// 정보추출
			List<Map<String, Object>> eduInfoList = caDao.queryForList("BA_EDU.SELECT_LMS_STUDY_INFO"
					, new Object[] {userid, subjectNum, year, chasu}
					, new int[] {Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER});
			log.debug("=====================baEducationDao===============");
			//String sKey = "";
			//String sID = "";
			//String compCd = "";
			//String eduYear = year+"";
			//String courseCd = subjectNum;
			int courseSq = chasu;
			
			if(!eduInfoList.isEmpty() && eduInfoList.size()>0) {
				Map<String,Object> map = eduInfoList.get(0);
				
				if(map.get("SYNC_YN")!=null && !map.get("SYNC_YN").equals("Y")) {
					String[][] syncRslt = null;
					StringBuffer statement = new StringBuffer();
					statement.append(map.get("NAME")).append("(").append(map.get("ID")).append(", ").append(map.get("CURRENT_CLASS")).append("학년").append("<br>");
					statement.append(map.get("SUBJECT_NAME")).append(" (").append(year).append("년도, ").append(chasu).append("차수").append("<br>");
					
					try {
						// 신청정보 LMS에 전송
						//SystemWizUtils swu = new SystemWizUtils();
						//syncRslt = swu.putCourseApply(
						//				year+"", map.get("CP_SUBJECT_NUM").toString(), courseSq, map.get("ID").toString(), map.get("ATTEND_STATE_CODE").toString(), 
						//				map.get("NAME").toString(), "", map.get("CURRENT_CLASS").toString(), map.get("GENDER").toString(), map.get("EMAIL").toString(), 
						//				map.get("CELLPHONE").toString());
						
						if(syncRslt!=null && syncRslt.length>1) {
							
							// 결과처리
							//String memberYn = syncRslt[1][0]; // 회원여부 Y/N, 기존회원이면 Y, 신규면 N
							applyYn = syncRslt[1][1]; // 등록성공여부 Y/N
							String startYmd = ""; // 과정시작일
							String endYmd = ""; // 과정종료일
							String onlineCancelStdt = ""; // 수강취소 시작일
							String onlineCancelEndt = ""; // 수강취소 종료일
							String onlineReeduStdt = ""; // 재학습 시작일
							String onlineReeduEndt = ""; // 재학습 종료일

							log.debug(onlineReeduEndt);
							if(applyYn.equals("Y")) {
								onlineCancelStdt = syncRslt[1][2]; // 수강취소 시작일
								onlineCancelEndt = syncRslt[1][3]; // 수강취소 종료일
								onlineReeduStdt = syncRslt[1][4]; // 재학습 시작일
								onlineReeduEndt = syncRslt[1][5]; // 재학습 종료일
								startYmd = syncRslt[1][6]; // 과정시작일
								endYmd = syncRslt[1][7]; // 과정종료일
							}

							log.debug(startYmd);
							log.debug(endYmd);
							log.debug(onlineCancelStdt);
							log.debug(onlineCancelEndt);
							log.debug(onlineReeduStdt);
							log.debug(onlineReeduEndt);
							if(applyYn.equals("Y")) {
								// 신청정보 연동결과 교육이력정보에 반영
								caDao.update("BA_EDU.UPDATE_EDU_SYNC_RSLT", 
										new Object[] {
											startYmd, endYmd, onlineCancelStdt, onlineCancelEndt, onlineReeduStdt,
											onlineReeduEndt, userid,
											userid, subjectNum, year, chasu
										}, 
										new int[] {
											Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
											Types.VARCHAR, Types.INTEGER,
											Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER
										});
							}
						}
					} catch(Throwable e) {
						log.error(e);
						statement.append(e);
						throw new CAException(e);
					} finally {
						// 동기화 결과저장
						caDao.update("BA_SYNC.INSERT_LMS_SYNC_HISTORY", 
								new Object[] {
									companyid, "3" , userid, applyYn, 
									statement.toString(), userid
								}, 
								new int[] {
									Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.VARCHAR, 
									Types.VARCHAR, Types.INTEGER
								});
					}
				}
				
			}
			

		} catch(Throwable e) {
			log.debug(e.toString());
		}
		
		return applyYn;
	}
	
	
	/**
	 * 핵심역량교육실적관리 엑셀 저장
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class )
	public String upLoadCoreCmptEduListExcel( User user, HttpServletRequest request) {
		String resultVal = "";
		int result = 0;
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;

		Row row = null;
		Cell cell = null;
	     
	    try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("openUploadFile")[0];
            
            FileInputStream fileInputStrem = new FileInputStream(file);
		     
            //워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 

	        if( workbook != null)
	        {
	            sheet = workbook.getSheetAt( 0);

	            if( sheet != null)
	            {
	                //실제 데이터가 시작되는 Row지정
	                int nRowStartIndex = 1;
	                //실제 데이터가 끝 Row지정
	                int nRowEndIndex   = sheet.getLastRowNum();
	                //실제 데이터가 시작되는 Column지정
	                int nColumnStartIndex = 0;
	                
	                //핵심역량교육실적관리 리스트(추가)
	                List<Object[]> iParamList = new ArrayList<Object[]>();
	                //핵심역량교육실적관리 리스트(수정)
	                List<Object[]> uParamList = new ArrayList<Object[]>();
	                //핵심역량교육실적관리 리스트(삭제)
	                List<Object[]> dParamList = new ArrayList<Object[]>();
	     			
	                String szValue = "";
	                for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                {
	                    row  = sheet.getRow( i);
	                     
	                    String div = ""; //작업구분
	                    String mjrCmptEduReq = null; //핵심역량교육실적관리 SEQ
	                    String userId = ""; //개설번호
	                    String name = ""; //성명
                        String evlNm = ""; //평가종류
                        String divisionId = ""; //부서코드
                        String dvsNm = ""; //부서명
                        String gradeNm = ""; //직급코드
                        String grade = ""; //직급코드
                        String evlRst = ""; //평가결과
                        String evlSco = ""; //평가점수
                        String evlDt = ""; //평가일
                        String eduStDt = ""; //사전교육시작일
                        String eduEdDt = ""; //사전교육종료일
                        String useFlag = ""; //사용여부
                        String delYn = ""; //삭제여부
                         
                        //실제 데이터가 끝나는 Column지정
    	                int nColumnEndIndex = sheet.getRow(i).getLastCellNum();
    	                 
	                    for( int nColumn = nColumnStartIndex; nColumn <= nColumnEndIndex ; nColumn++)
	                    {
	                        cell = row.getCell(( short ) nColumn);
	                        if(cell != null){
	                        	
		                        if( cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
		                        {
		                        	//날짜형식을 숫자로 인식하므로 분기 처리.
		                        	if(HSSFDateUtil.isCellDateFormatted(cell)){
		                        		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		                        		szValue = formatter.format(cell.getDateCellValue());
		                        	}else{
		                        		szValue = (int)cell.getNumericCellValue() + "";
		                        	}
		                        }else{
		                            szValue = cell.getStringCellValue();
		                        }
		                        
		                        //null 제거
		                        szValue = CommonUtils.noNull(szValue);
		                        
		                        switch (nColumn) {
			                        case 0 : div = szValue; break;
			                        case 1 : mjrCmptEduReq = szValue; break;
			                        case 2 : evlNm = szValue;  break;
			                        case 3 : userId = szValue; break;
			                        case 4 : name = szValue; break;
			                        case 5 : dvsNm = szValue; break;
			                        case 6 : divisionId = szValue;  break;
			                        case 7 : gradeNm = szValue;  break;
			                        case 8 : grade = szValue;  break;
			                        case 9 : evlRst = szValue;  break;
			                        case 10 : evlSco = szValue;  break;
			                        case 11 : evlDt = szValue;  break;
			                        case 12 : eduStDt = szValue;  break;
			                        case 13 : eduEdDt = szValue;  break;
			                        case 14 : useFlag = szValue;  break;
		                        }
	                        }
	                    }

	                    div = div.toUpperCase();
	                    useFlag = useFlag.toUpperCase();
	                    
	                    //삭제여부 결정
	                    if("Y".equals(useFlag)){
	                    	delYn="N";
	                    }else if("N".equals(useFlag)){
	                    	delYn="Y";
	                    }
	                    
	                    evlDt = evlDt.replace(".", "-");
	                    eduStDt = eduStDt.replace(".", "-");
	                    eduEdDt = eduEdDt.replace(".", "-");
	                    
	                    log.debug("#### div:"+div);
	                    log.debug("#### mjrCmptEduReq : " + mjrCmptEduReq);
	                    log.debug("#### userId : " + userId);
	                    log.debug("#### name : " + name);
	                    log.debug("#### evlNm : " + evlNm);
	                    log.debug("#### divisionId : " + divisionId);
	                    log.debug("#### grade : " + grade);
	                    

	                    log.debug("####"+eduStDt +","+ eduEdDt);
        				
	                    if(div.equals("I")){ //추가
	                    	if(!userId.equals("") && !evlNm.equals("") &&!divisionId.equals("") &&!grade.equals("") ){
		                    	//평가결과 유효성 검사.
	                    		if("Y".equals(useFlag) || "N".equals(useFlag)){
		                    		if("통과".equals(evlRst) || "미통과".equals(evlRst) ){
		                    			//숫자형 데이터 체크
		                    			if((divisionId.equals("")||CommonUtils.isNumber(divisionId)) && (grade.equals("")||CommonUtils.isNumber(grade)) && (evlSco.equals("")||CommonUtils.isNumber(evlSco)) ){
		                    				// 날짜 입력 값 유효성 체크
		                    				if( CommonUtils.isDate(eduStDt) && CommonUtils.isDate(eduEdDt) && CommonUtils.isDate(evlDt)){
		                    					iParamList.add(
		                    							new Object[]{
		                    									mjrCmptEduReq, user.getCompanyId(), evlNm,  userId, name, divisionId, grade, 
		                    									evlRst, evlSco, evlDt,  eduStDt, eduEdDt, user.getUserId(),useFlag,delYn 
					    	                    		}
					    	                    );
		                    				}else{
		                    					resultVal = resultVal + (i+1)+"줄 평가일, 사전교육시작일, 사전교육종료일은 'yyyy-mm-dd'형식으로 입력해야함.\n";
		                    				}
		                    			}else{
		                    				resultVal = resultVal + (i+1)+"줄 소속부서, 직급코드, 평가점수는 숫자로 입력해야함.\n";
		                    			}
		                    		}else{
		                    			resultVal = resultVal + (i+1)+"줄 평가결과는 통과,미통과를 입력해야함.\n";
		                    		}
	                    		}else{
	                    			resultVal = resultVal + (i+1)+"줄 사용여부는 Y,N 을 입력해야함.\n";
	                    		}
	                    	}else{
	                    		resultVal = resultVal + (i+1)+"줄 평가종류, 성명, 당시소속은 필수입력임.\n";
	                    	}
	                    }else if(div.equals("U")){ //수정
	                    	if(!mjrCmptEduReq.equals("") && mjrCmptEduReq != null){
	                    		if(!userId.equals("") && !evlNm.equals("") && !divisionId.equals("") && !grade.equals("") ){
	                    			//개설정보 존재 여부 확인
		                    		if(caDao.queryForInteger("CA.SELECT_CORE_CMPT_EDU_USE_CNT", new Object[]{ user.getCompanyId(), mjrCmptEduReq}, new int[]{ Types.NUMERIC, Types.NUMERIC }) > 0){
			                    		//개설년도 유효성 검사.
		                    			if("Y".equals(useFlag) || "N".equals(useFlag)){
				                    		if("통과".equals(evlRst) || "미통과".equals(evlRst)){
				                    			//숫자형 데이터 체크
				                    			if(CommonUtils.isNumber(mjrCmptEduReq) && (divisionId.equals("")||CommonUtils.isNumber(divisionId)) && (grade.equals("")||CommonUtils.isNumber(grade)) && (evlSco.equals("")||CommonUtils.isNumber(evlSco))){
				                    				// 날짜 입력 값 유효성 체크
				                    				if( CommonUtils.isDate(eduStDt) && CommonUtils.isDate(eduEdDt) && CommonUtils.isDate(evlDt) ){
			                    						uParamList.add(
			                    								new Object[]{
			                    										mjrCmptEduReq, user.getCompanyId(), evlNm,  userId, name, divisionId, grade, 
				                    									evlRst, evlSco, evlDt,  eduStDt, eduEdDt, user.getUserId(),useFlag ,delYn
							    	                    		}
							    	                    );
				                    				}else{
				                    					resultVal = resultVal + (i+1)+"줄 평가일, 사전교육시작일, 사전교육종료일은 'yyyy-mm-dd'형식으로 입력해야함.\n";
				                    				}
				                    			}else{
				                    				resultVal = resultVal + (i+1)+"줄 소속부서, 직급코드, 평가점수는 숫자로 입력해야함.\n";
				                    			}
				                    		}else{
				                    			resultVal = resultVal + (i+1)+"줄 평가결과는 통과,미통과를 입력해야함.\n";
				                    		}
		                    			}else{
			                    			resultVal = resultVal + (i+1)+"줄 사용여부는 Y,N을 입력해야함.\n";
			                    		}
			                    	}else{
			                    		resultVal = resultVal + (i+1)+"줄 핵심역량교육실적코드가 일치하지 않음.\n";
			                    	}
		                    	}else{
		                    		resultVal = resultVal + (i+1)+"줄 평가종류, 성명, 당시소속, 직급은 필수입력임.\n";
		                    	}
	                    	}else{
	                    		resultVal = resultVal + (i+1)+"줄 핵심역량교육실적 코드는 필수임.\n";
	                    	}
	                    }else if(div.equals("D")){ //삭제
	                    	if(CommonUtils.isNumber(mjrCmptEduReq)){
	                    		//개설정보 존재 여부 확인
		                    	if(caDao.queryForInteger("CA.SELECT_CORE_CMPT_EDU_USE_CNT", new Object[]{ user.getCompanyId(), mjrCmptEduReq }, new int[]{ Types.NUMERIC, Types.NUMERIC }) > 0){
		                    		dParamList.add(
				                    		new Object[]{
				                    				user.getUserId(), mjrCmptEduReq, user.getCompanyId()
				                    		}
				                    );
		                    	}else{
		                    		resultVal = resultVal + (i+1)+"줄 핵심역량교육실적코드가  일치하는 않음.\n";
		                    	}
	                    	}else{
	                    		resultVal = resultVal + (i+1)+"줄 핵심역량교육실적코드가 유효하지 않음.\n";
	                    	}
	                    }else{
	                    	resultVal = resultVal + (i+1)+"줄 작업구분을 입력하지 않음.\n";
	                    }
	                }
	                //입력값이 유효하지 않은 것이 있다면 리턴처리함.
	                if(resultVal!=null && resultVal.length()>0){
	                	return resultVal;
	                }else{
	                	//추가할 과정
		                if(iParamList!=null && iParamList.size()>0){
		                	result = caDao.batchUpdate("CA.UPLOAD_CMPT_EDU_MNG", iParamList , new int []{
		                			Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR,Types.VARCHAR,
		                			Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR, Types.VARCHAR,
		                			Types.VARCHAR,Types.VARCHAR,Types.NUMERIC,Types.VARCHAR, Types.VARCHAR
		                	});
		                	resultVal = "추가 - "+result+"건 \n";
		                }
		                //수정할 과정
		                if(uParamList!=null && uParamList.size()>0){
		                	result = caDao.batchUpdate("CA.UPLOAD_CMPT_EDU_MNG", uParamList , new int []{
		                			Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR,Types.VARCHAR,
		                			Types.VARCHAR,Types.VARCHAR,Types.VARCHAR,Types.VARCHAR, Types.VARCHAR,
		                			Types.VARCHAR,Types.VARCHAR,Types.NUMERIC,Types.VARCHAR, Types.VARCHAR
		                	});
		                	resultVal = resultVal + "변경 - "+result+"건 \n";
		                }
		                //삭제할 과정
		                if(dParamList!=null && dParamList.size()>0){
		                	result = caDao.batchUpdate("CA.DELETE_CMPT_EDU_MNG", dParamList , new int []{
		                			Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		                	});
		                	resultVal = resultVal + "삭제 - "+result+"건 \n";
		                }
		                
	                }
	            }
	         }
	         
	     }
	     catch(Exception e){
	         e.printStackTrace();
	     }
		
		return resultVal;
	}
	/**
	 * 대상자관리 엑셀 업로드
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class )
	public String upLoadCaCmptObjListExcel( User user, HttpServletRequest request) {
		String resultVal = "";
		int result = 0;
		String runNum   = ParamUtils.getParameter(request, "upload_run_num");
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;

		Row row = null;
		Cell cell = null;
	     
	    try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("openUploadFile")[0];
            
            FileInputStream fileInputStrem = new FileInputStream(file);
		     
            //워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 

	        if( workbook != null)
	        {
	            sheet = workbook.getSheetAt( 0);

	            if( sheet != null)
	            {
	                //실제 데이터가 시작되는 Row지정
	                int nRowStartIndex = 1;
	                //실제 데이터가 끝 Row지정
	                int nRowEndIndex   = sheet.getLastRowNum();
	                //실제 데이터가 시작되는 Column지정
	                int nColumnStartIndex = 0;
	                
	                // 리스트(추가)
	                List<Object[]> iParamList = new ArrayList<Object[]>();
	                // 리스트(수정)
	                //List<Object[]> uParamList = new ArrayList<Object[]>();
	                // 리스트(삭제)
	                //List<Object[]> dParamList = new ArrayList<Object[]>();
	     			
	                String szValue = "";
	                for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                {
	                    row  = sheet.getRow( i);
	                     
	                    String div = "I"; //작업구분 (I 만 사용하도록...)
	                    String id = null; //user ID
	                    String name = ""; //이름
	                    String dvsNm ="";
	                    String division = ""; // 부서코드
	                    String gradeNm = ""; //직급코드
                        String grade = ""; //직급코드
                        String job = ""; //직무
                        String leadership = ""; //계급
                        String useFlag = ""; //사용여부
                     
                         
                        //실제 데이터가 끝나는 Column지정
    	                int nColumnEndIndex = sheet.getRow(i).getLastCellNum();
    	                 
	                    for( int nColumn = nColumnStartIndex; nColumn <= nColumnEndIndex ; nColumn++)
	                    {
	                        cell = row.getCell(( short ) nColumn);
	                        if(cell != null){
	                        	
		                        if( cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
		                        {
		                        	//날짜형식을 숫자로 인식하므로 분기 처리.
		                        	if(HSSFDateUtil.isCellDateFormatted(cell)){
		                        		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		                        		szValue = formatter.format(cell.getDateCellValue());
		                        	}else{
		                        		szValue = (int)cell.getNumericCellValue() + "";
		                        	}
		                        }else{
		                            szValue = cell.getStringCellValue();
		                        }
		                        
		                        //null 제거
		                        szValue = CommonUtils.noNull(szValue);
		                        
		                        switch (nColumn) {
			                        //case 0 : div = szValue; break;
			                        case 0 : id = szValue; break;
			                        case 1 : useFlag = szValue;  break;
		                        }
	                        }
	                    }

	                    div = div.toUpperCase();
	                    useFlag = useFlag.toUpperCase();

	                    log.debug("#### div:"+div);
	                    log.debug("#### id : " + id);
	                    log.debug("#### name : " + name);
	                    log.debug("#### division : " + division);
	                    log.debug("#### grade : " + grade);
	                    log.debug("#### job : " + job);
	                    log.debug("#### leadership : " + leadership);

        				
	                    if(div.equals("I")){ //추가 수정
	                    	if(!id.equals("")){
	                    		if(caDao.queryForInteger("CA.SELECT_CORE_CA_OBJ_USE_CNT", new Object[]{ user.getCompanyId(),runNum, id}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.VARCHAR }) < 1){
		                    		// 유효성 검사.
		                    		if("Y".equals(useFlag) || "N".equals(useFlag)){
		                    					iParamList.add(
		                							new Object[]{
		                									user.getCompanyId() ,runNum, useFlag, id, user.getUserId()
				    	                    		}
					    	                    );
		                    		}else{
		                    			resultVal = resultVal + (i+1)+"줄 사용여부는 Y,N 을 입력해야함.\n";
		                    		}
	                    		}else{
		                    		resultVal = resultVal + (i+1)+"줄 이미 존제하는 대상자임.\n"+id;
		                    	}
	                    	}else{
	                    		resultVal = resultVal + (i+1)+"줄 교직원번호는 필수입력임.\n";
	                    	}
	                    }else if(div.equals("U")){ //수정 기능 사용안함 추후 사용할수 있으므로 주석처리
                    		/*if(!id.equals("") && !name.equals("") &&!division.equals("") &&!grade.equals("") ){
                    			
	                    		if(caDao.queryForInteger("CA.SELECT_CORE_CA_OBJ_USE_CNT", new Object[]{ user.getCompanyId(),runNum, id}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.VARCHAR }) > 0){
		                    		
	                    			if("Y".equals(useFlag) || "N".equals(useFlag)){
		                    			//숫자형 데이터 체크
		                    			if((division.equals("")||CommonUtils.isNumber(division)) && (grade.equals("")||CommonUtils.isNumber(grade)) ){
		                    				//숫자형 데이터 체크
		                    				if( (job.equals("")||CommonUtils.isNumber(job))&& (leadership.equals("")||CommonUtils.isNumber(leadership)) ){
	                    						uParamList.add(
                    								new Object[]{
                    										user.getCompanyId() ,runNum, useFlag, division, job, leadership, id, user.getUserId()
				    	                    		}
					    	                    );
		                    				}else{
		                    					resultVal = resultVal + (i+1)+"줄 직무, 계급은 숫자로 입력해야함.\n";
		                    				}
		                    			}else{
		                    				resultVal = resultVal + (i+1)+"줄 소속부서, 직급코드는 숫자로 입력해야함.\n";
		                    			}
	                    			}else{
		                    			resultVal = resultVal + (i+1)+"줄 사용여부는 Y,N을 입력해야함.\n";
		                    		}
		                    	}else{
		                    		resultVal = resultVal + (i+1)+"줄 이미 존제하는 대상자임.\n";
		                    	}
	                    	}else{
	                    		resultVal = resultVal + (i+1)+"줄 id, 성명, 당시소속, 직급은 필수입력임.\n";
	                    	}*/
	                    }else if(div.equals("D")){ //삭제
	                    	resultVal = resultVal + (i+1)+"줄 작업구분 D는 해당 메뉴에는 사용되지 않음. 사용여부 yn 을 선택바람.\n";
	                    	/*if(CommonUtils.isNumber(id)){
	                    		//개설정보 존재 여부 확인
		                    	if(caDao.queryForInteger("CA.SELECT_CORE_CA_OBJ_USE_CNT", new Object[]{ user.getCompanyId(),runNum, id }, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.VARCHAR }) > 0){
		                    		dParamList.add(
				                    		new Object[]{
				                    				id, runNum, user.getCompanyId()
				                    		}
				                    );
		                    	}else{
		                    		resultVal = resultVal + (i+1)+"줄 대상자가 존제하지 않음.\n";
		                    	}
	                    	}else{
	                    		resultVal = resultVal + (i+1)+"줄 id 유효하지 않음.\n";
	                    	}*/
	                    }else{
	                    	resultVal = resultVal + (i+1)+"줄 작업구분을 입력하지 않음.\n";
	                    }
	                }
	                //입력값이 유효하지 않은 것이 있다면 리턴처리함.
	                if(resultVal!=null && resultVal.length()>0){
	                	return resultVal;
	                }else{
	                	// 모두 사용 안함 처리 후 데이터를 업로드함
	                	/*if(nRowStartIndex == 1){ // 한번만 실행 되도록
	                		caDao.update("CA.UPLOAD_CA_OBJ_NOT_USE", new Object[]{user.getCompanyId(),runNum},  new int []{Types.NUMERIC, Types.NUMERIC});
	                	}*/
	                	//추가
		                if(iParamList!=null && iParamList.size()>0){
		                	result = caDao.batchUpdate("CA.UPLOAD_CMPT_OBJ_MNG", iParamList , new int []{
		                			Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR,Types.VARCHAR
		                	});
		                	resultVal = "추가 - "+result+"건 \n";
		                }
		                //수정
		               /* if(uParamList!=null && uParamList.size()>0){
		                	result = caDao.batchUpdate("CA.UPLOAD_CMPT_OBJ_MNG", uParamList , new int []{
		                			Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR,Types.NUMERIC,
		                			Types.NUMERIC,Types.VARCHAR,Types.NUMERIC
		                	});
		                	resultVal = resultVal + "변경 - "+result+"건 \n";
		                }*/
		                //삭제
		               /* if(dParamList!=null && dParamList.size()>0){
		                	result = caDao.batchUpdate("CA.DELETE_CMPT_OBJ_MNG", dParamList , new int []{
		                			Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		                	});
		                	resultVal = resultVal + "삭제 - "+result+"건 \n";
		                }*/
		                
	                }
	            }
	         }
	         
	     }
	     catch(Exception e){
	         log.debug(e);
	     }
		
		return resultVal;
	}
	
	/**
	 * 방향설정 엑셀 업로드
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class )
	public String upLoadCaCmptDirListExcel( User user, HttpServletRequest request) {
		String resultVal = "";
		int result = 0;
		String runNum   = ParamUtils.getParameter(request, "upload_run_num");
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;

		Row row = null;
		Cell cell = null;
	     
	    try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("openUploadFile")[0];
            
            FileInputStream fileInputStrem = new FileInputStream(file);
		     
            //워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 

	        if( workbook != null)
	        {
	            sheet = workbook.getSheetAt( 0);

	            if( sheet != null)
	            {
	                //실제 데이터가 시작되는 Row지정
	                int nRowStartIndex = 1;
	                //실제 데이터가 끝 Row지정
	                int nRowEndIndex   = sheet.getLastRowNum();
	                //실제 데이터가 시작되는 Column지정
	                int nColumnStartIndex = 0;
	                
	                // 리스트(추가)
	                List<Object[]> iParamList = new ArrayList<Object[]>();
	                // 리스트(수정)
	                List<Object[]> uParamList = new ArrayList<Object[]>();
	                // 리스트(삭제)
	                //List<Object[]> dParamList = new ArrayList<Object[]>();
	     			
	                String szValue = "";
	                for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                {
	                    row  = sheet.getRow( i);
	                     
	                    String div = "I"; //작업구분 (작업구분을 I만 사용함...)
	                    String id = ""; //진단자 id
                        String exedId = ""; //피진단자 id
                        String rundirection = ""; //진단방향
                        String useFlag = ""; //사용여부
                     
                         
                        //실제 데이터가 끝나는 Column지정
    	                int nColumnEndIndex = sheet.getRow(i).getLastCellNum();
    	                 
	                    for( int nColumn = nColumnStartIndex; nColumn <= nColumnEndIndex ; nColumn++)
	                    {
	                        cell = row.getCell(( short ) nColumn);
	                        if(cell != null){
	                        	
		                        if( cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
		                        {
		                        	//날짜형식을 숫자로 인식하므로 분기 처리.
		                        	if(HSSFDateUtil.isCellDateFormatted(cell)){
		                        		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		                        		szValue = formatter.format(cell.getDateCellValue());
		                        	}else{
		                        		szValue = (int)cell.getNumericCellValue() + "";
		                        	}
		                        }else{
		                            szValue = cell.getStringCellValue();
		                        }
		                        
		                        //null 제거
		                        szValue = CommonUtils.noNull(szValue);
		                        
		                        switch (nColumn) {
			                        case 0 : id = szValue; break;
			                        case 1 : exedId = szValue;  break;
			                        case 2 : rundirection = szValue;  break;
			                        case 3 : useFlag = szValue;  break;
		                        }
	                        }
	                    }

	                    //div = div.toUpperCase();
	                    useFlag = useFlag.toUpperCase();

	                  //log.debug("#### div:"+div);
	                    log.debug("#### runNum : " + runNum);
	                    log.debug("#### id : " + id);
	                    log.debug("#### exedId : " + exedId);
	                    log.debug("#### rundirection : " + rundirection);

        				
                    	if(!id.equals("") && !exedId.equals("") && !rundirection.equals("")){
                    		//피진단자 실시번호 체크
	                    		if("Y".equals(useFlag) || "N".equals(useFlag)){
	                    			//아이디가 유효한지 체크
	                    			List isList = queryForList("CA.IS_USE_USER", new Object[]{id, exedId}, new int[]{Types.VARCHAR, Types.VARCHAR});
	                    			Map isMap = (Map)isList.get(0);
	                    			String execUser = isMap.get("EXEC_USERID").toString();
	                    			String exedUser = isMap.get("EXED_USERID").toString();
	                    			if(execUser!=null && !execUser.equals("") && !execUser.equals("0")){
	                    				if(exedUser!=null && !exedUser.equals("") && !exedUser.equals("0")){
	                    					iParamList.add(
	                							new Object[]{
	                									user.getCompanyId() ,runNum, id, exedId, rundirection, useFlag, user.getUserId()
			    	                    		}
				    	                    );
		                    			}else{
		                    				resultVal = resultVal + (i+1)+"줄 피진단자 교직원번호가 DB에 존재하지 않음\n";
		                    			}
	                    			}else{
	                    				resultVal = resultVal + (i+1)+"줄 진단자 교직원번호가 DB에 존재하지 않음\n";
	                    			}
	                    		}else{
	                    			resultVal = resultVal + (i+1)+"줄 사용여부는 Y,N 을 입력해야함.\n";
	                    		}
                    	}else{
                    		resultVal = resultVal + (i+1)+"줄 진단자, 피진단자, 진단뱡향 필수입력임.\n";
                    	}
	                   
	                }
	                //입력값이 유효하지 않은 것이 있다면 리턴처리함.
	                if(resultVal!=null && resultVal.length()>0){
	                	if(resultVal!=null && resultVal.length() > 300){
							resultVal = resultVal.substring(0, 299)+" 등...";
						}
	                	return resultVal;
	                }else{
	                	// 모두 사용 안함 처리 후 데이터를 업로드함
	                	if(nRowStartIndex == 1){ // 한번만 실행 되도록
	                		caDao.update("CA.UPLOAD_CA_DIR_NOT_USE", new Object[]{user.getCompanyId(),runNum},  new int []{Types.NUMERIC, Types.NUMERIC});
	                	}
	                	//추가
		                if(iParamList!=null && iParamList.size()>0){
		                	result = caDao.batchUpdate("CA.UPLOAD_CA_DIR_MNG", iParamList , new int []{
		                			Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR,Types.VARCHAR,
		                			Types.VARCHAR,Types.NUMERIC
		                	});
		                	resultVal = "추가 - "+result+"건 \n";
		                }
		                // 사용안함
		                /*if(uParamList!=null && uParamList.size()>0){
		                	result = caDao.batchUpdate("CA.UPLOAD_CA_DIR_MNG", iParamList , new int []{
		                			Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR,Types.VARCHAR,
		                			Types.VARCHAR,Types.NUMERIC
		                	});
		                	resultVal = resultVal + "변경 - "+result+"건 \n";
		                }*/
		                //삭제 사용안함
		               /* if(dParamList!=null && dParamList.size()>0){
		                	result = caDao.batchUpdate("CA.DELETE_CMPT_OBJ_MNG", dParamList , new int []{
		                			Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		                	});
		                	resultVal = resultVal + "삭제 - "+result+"건 \n";
		                }*/
		                
	                }
	            }
	         }
	         
	     }
	     catch(Exception e){
	         log.debug(e);
	     }
		
		return resultVal;
	}
	
	/**
	 * 상시학습관리 엑셀 업로드
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public String upLoadEmAdminClassListExcel( User user, HttpServletRequest request) throws CAException{
		String resultVal = "";
		int result = 0;
		int alwStdSeq = 0;
		//String runNum   = ParamUtils.getParameter(request, "upload_run_num");
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;

		Row row = null;
		Cell cell = null;
	     
	    try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("openUploadFile")[0];
            
            FileInputStream fileInputStrem = new FileInputStream(file);
		     
            //워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 

	        if( workbook != null)
	        {
	            sheet = workbook.getSheetAt( 0);

	            if( sheet != null)
	            {
	                //실제 데이터가 시작되는 Row지정
	                int nRowStartIndex = 1;
	                //실제 데이터가 끝 Row지정
	                int nRowEndIndex   = sheet.getLastRowNum();
	                //실제 데이터가 시작되는 Column지정
	                int nColumnStartIndex = 0;
	                
	                // 리스트(추가)
	                List<Object[]> iParamList = new ArrayList<Object[]>();
	                // 수료자 리스트(추가)
	                List<Object[]> empParamList = new ArrayList<Object[]>();
	                
	                // 리스트(수정)
	                //List<Object[]> uParamList = new ArrayList<Object[]>();
	                // 리스트(삭제)
	                //List<Object[]> dParamList = new ArrayList<Object[]>();
	     			
	                String szValue = "";

					int sameCnt = 0;
					int invalidCnt = 0;
					int reqCnt = 0;
					String msg = "";
					
	                for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                {
	                    row  = sheet.getRow( i);
	                     
	                    //String div = ""; //작업구분 
	                    String alwSeqCd=""; //상시학습코드
	                    String trainingCd = "";  //학습유형
	                    String subjectName = ""; //과정명
	                    String ttGetSco = ""; //수료점수
	                    String yyyy = ""; //해당년도
	                    String eduStart = ""; //교육시작일
	                    String eduEnd = ""; //교육종료일
	                    String eduHour_H =""; //실적시간 시
	                    String eduHour_M =""; //실적시간 분
                        String recog_h = "";  //인정시간시간_시
                        String recog_m = ""; //인정시간_분
                        String eduCont = ""; //내용
                        String alwStdCd = ""; //상시학습종류코드
                        String deptDesignationYn = ""; //부처지정여부
                        String deptdesignationCd = ""; //지정학습구분
                        String perfAsseSbjCd = ""; //기관성과평가필수교육
                        String officeTimeCd = ""; //업무시간구분
                        String eduinsDivCd = ""; //교육기관구분
                        String institueName = ""; //교육기관명
                        String instituteCode = ""; //교육기관코드
                        String requiredYn =""; //필수여부
                        String empNo= ""; //교육수료자ID
                        String eduUserNm= ""; //교육수료자 성명
                        String dvsNm = ""; //소속명
                        String division = ""; //소속
                        String job =""; //직무
                        String leadership =""; //계급
                        String gradeNm =""; // 직급명
                        String grade =""; // 직급
                        //String eduComUseFlag =""; //수료자 사용여부
                        //String req_num = "";
                        String sts_cd = "2";
                        String cmpnumber = "";
                     
                         
                        //실제 데이터가 끝나는 Column지정
    	                int nColumnEndIndex = sheet.getRow(i).getLastCellNum();
    	                 
	                    for( int nColumn = nColumnStartIndex; nColumn <= nColumnEndIndex ; nColumn++)
	                    {
	                        cell = row.getCell(( short ) nColumn);
	                        if(cell != null){
	                        	
		                        if( cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC)
		                        {
		                        	//날짜형식을 숫자로 인식하므로 분기 처리.
		                        	if(HSSFDateUtil.isCellDateFormatted(cell)){
		                        		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		                        		szValue = formatter.format(cell.getDateCellValue());
		                        	}else{
		                        		szValue = (int)cell.getNumericCellValue() + "";
		                        	}
		                        }else{
		                            szValue = cell.getStringCellValue();
		                        }
		                        
		                        //null 제거
		                        szValue = CommonUtils.noNull(szValue);
		                        
		                        switch (nColumn) {
			                        case 0 : trainingCd = szValue.toUpperCase(); break;
			                        case 1 : subjectName = szValue; break;
			                        case 2 : ttGetSco = szValue; break;
			                        case 3 : yyyy = szValue;  break;
			                        case 4 : eduStart = szValue;  break;
			                        case 5 : eduEnd = szValue;  break;
			                        case 6 : eduHour_H = szValue;  break;
			                        case 7 : eduHour_M = szValue;  break;
			                        case 8 : recog_h = szValue;  break;
			                        case 9 : recog_m = szValue;  break;
			                        case 10 : eduCont = szValue;  break;
			                        case 11 : alwStdCd = szValue;  break;
			                        case 12 : deptDesignationYn = szValue.toUpperCase();  break;
			                        //case 13 : deptdesignationCd = szValue;  break;
			                        case 13 : perfAsseSbjCd = szValue;  break;
			                        case 14 : officeTimeCd = szValue;  break;
			                        case 15 : eduinsDivCd = szValue;  break;
			                        case 16 : instituteCode = szValue;  break;
			                        case 17 : institueName = szValue;  break;
			                        case 18 : empNo = szValue;  break;
			                        case 19 : division = szValue;  break;
			                        case 20 : grade = szValue;  break;
			                        case 21 : cmpnumber = szValue; break;
		                        }
	                        }
	                    }

	                    if(trainingCd!=null){
	                    	trainingCd = trainingCd.toUpperCase();
	                    }
	                    
	                    if(eduHour_H==null || eduHour_H.equals("")){
	                    	eduHour_H = "0";
	                    }

	                    if(eduHour_M==null || eduHour_M.equals("")){
	                    	eduHour_M = "0";
	                    }
	                    
	                    
	                    if(recog_h==null || recog_h.equals("")){
	                    	recog_h = "0";
	                    }

	                    if(recog_m==null || recog_m.equals("")){
	                    	recog_m = "0";
	                    }
	                    
	                    if(deptDesignationYn==null || deptDesignationYn.equals("")){
	                    	deptDesignationYn = "N";
	                    }else{
	                    	deptDesignationYn = deptDesignationYn.toUpperCase();
	                    }

	                    if(officeTimeCd!=null){
	                    	officeTimeCd = officeTimeCd.toUpperCase();
	                    }
	                    
	                    //역량번호가 숫자가 아닌경우 입력안함.
	                    if(!CommonUtils.isNumber(cmpnumber)){
	                    	cmpnumber = "";
	                    }
	                    
	                   /* if(eduComUseFlag==null || eduComUseFlag.equals("")){
	                    	eduComUseFlag = "Y";
	                    }else{
	                    	eduComUseFlag = eduComUseFlag.toUpperCase();
	                    }*/
	                    
	                    log.debug("alwSeqCd" + alwSeqCd);
	                    log.debug("subjectName : " + subjectName);
	                    log.debug("trainingCode : " + trainingCd);
	                    log.debug("institueName : " + institueName);
	                    log.debug("recog_h : " + recog_h);
	                    log.debug("recog_m : " + recog_m);
                
	                    //필수값 체크
                		if( !trainingCd.equals("") && !subjectName.equals("") && !ttGetSco.equals("") && !yyyy.equals("") && !eduStart.equals("") && !eduEnd.equals("") && !eduHour_H.equals("") && !eduHour_M.equals("") 
                				&& !recog_h.equals("") && !recog_m.equals("") && !alwStdCd.equals("") && !deptDesignationYn.equals("") && !instituteCode.equals("") && !institueName.equals("") 
                				&& !empNo.equals("") ){
                			//숫자형 입력 체크
                    		if(CommonUtils.isNumber(ttGetSco) && CommonUtils.isNumber(yyyy) && CommonUtils.isNumber(eduHour_H) && CommonUtils.isNumber(eduHour_M) && CommonUtils.isNumber(recog_h) && CommonUtils.isNumber(recog_m) ){
                    			//날짜형식 입력 체크
                    			if(CommonUtils.isDate(eduStart) && CommonUtils.isDate(eduEnd)){

                					//아이디를 통해 사용자번호 조회
                					int alwUserid = caDao.queryForInteger("EM.SELECT_USERID_BY_EMPNO", new Object[]{empNo}, new int []{Types.VARCHAR});
                					
                					if(alwUserid!=999999){
                						//중복입력 체크
                        				int isCnt = caDao.queryForInteger("EM.SELECT_SAME_DATA_ALW", new Object[]{alwUserid, eduStart, eduEnd, subjectName}, new int[]{Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR});
                        				
                        				if(isCnt == 0){
                        					//시퀀스 생성
                        					alwStdSeq = caDao.queryForInteger("BA_SUBJECT.SELECT_SEQ_ALW_NUM", new Object[]{}, new int[]{});
                        					
                        					//상시학습종류에 따른 입력 가능한 인정시간 조회. --------------------------------------------------
                        					List<Map<String,Object>> recogList = emAlwService.yearRecogList(user.getCompanyId(), alwStdSeq+"", alwUserid+"", "2", yyyy, recog_h, recog_m, alwStdCd);
                        					String reH = recog_h;
                        					String reM = recog_m;
                        					
                        			    	if(recogList!=null && recogList.size()>0){
                        			    		Map<String, Object> alwMap = (Map<String, Object>)recogList.get(0);
                        			    		
                        			    		reH = alwMap.get("ABLE_TIME_H").toString();
                        			    		reM = alwMap.get("ABLE_TIME_M").toString();
                        			    		
                        			    		log.debug("#####reH:"+reH+", reM:"+reM);
                        			    	}
                        			    	// --------------------------------------------------------------------------------------------------------
                        					
                        					Object [] params = {
                    								alwStdSeq, user.getCompanyId(), trainingCd, subjectName, reH, 
                    								reM, eduStart, eduEnd, eduCont, alwStdCd, 
                    								institueName, instituteCode, deptDesignationYn, deptdesignationCd, officeTimeCd, eduinsDivCd, 
                    								user.getUserId(), perfAsseSbjCd, yyyy, eduHour_H , eduHour_M, 
                    								sts_cd, requiredYn, cmpnumber
                    						};
                        					int [] paramsType = {
                        							Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
                    								Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
                    								Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
                    								Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, 
                    								Types.NUMERIC, Types.VARCHAR, Types.VARCHAR
                        					};
                        					//상시학습 기본정보 입력
                        					result += caDao.update("BA_SUBJECT.UPLOAD_ALW_ADMIN_CLASS", params, paramsType);
                        					
                        					Object [] userParams = {
                        							user.getCompanyId(), alwStdSeq, alwUserid, division,
                    								job, leadership, grade,ttGetSco, user.getUserId()
                        					};
                        					int [] userType = {
                        							Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC
                        					};
                        					//상시학습 사용자정보 입력
                        					caDao.update("BA_SUBJECT.MERGE_ALW_EMP_MAP", userParams, userType);
                        				}else{
                        					sameCnt++;
                        					msg += (i+1)+"줄 중복 데이터 존재(과정명, 교육기간, 교직원번호 동일).\n";
                        				}
                					}else{
                						invalidCnt++;
                        				msg += (i+1)+"줄 존재하지 않는 교직원번호\n";
                					}
                    			}else{
                    				invalidCnt++;
                    				msg += (i+1)+"줄 학습기간의 날짜형식이 틀림.\n";
                    			}
                			}else{
                				invalidCnt++;
                				msg += (i+1)+"줄 취득점수,해당년도,실적시간, 인정시간 숫자가 아님.\n";
                    		}
                    	}else{
                    		reqCnt++;
                    		msg += (i+1)+"줄 노란색의 셀은 필수값임.\n";
                    	}
	                }
	                
					resultVal = "추가 - "+result+"건 \n\n";
					resultVal += "유효하지 않은 데이터 - "+invalidCnt+"건 \n";
					resultVal += "동일한 데이터 - "+sameCnt+"건 \n";
					resultVal += "필수값 누락 - "+reqCnt+"건 \n\n";
					
					if(msg!=null && msg.length() > 300){
						resultVal += msg.substring(0, 299)+" 등...";
					}else{
						resultVal += msg;
					}
					
	            }
	         }
	         
	     }
	     catch(Exception e){
	         e.printStackTrace();
	         throw new CAException(e);
	     }
		
		return resultVal;
	}
	
}



