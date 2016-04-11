package kr.podosoft.ws.service.ba.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.BaUserService;
import kr.podosoft.ws.service.ba.dao.BaUserDao;
import kr.podosoft.ws.service.cdp.CdpService;
import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.utils.CommonUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.struts2.dispatcher.multipart.MultiPartRequestWrapper;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.common.user.User;
import architecture.ee.util.ApplicationHelper;
import architecture.ee.web.attachment.FileInfo;
//import pjt.dainlms.aria.CipherAria;

public class BaUserServiceImpl implements BaUserService {

	private Log log = LogFactory.getLog(getClass());

	private BaUserDao baUserDao;
	
	private CdpService cdpService;
	
	private PasswordEncoder passwordEncoder;
	
	public PasswordEncoder getPasswordEncoder() {
		return passwordEncoder;
	}
	
	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}
	
	public BaUserDao getBaUserDao() {
		return baUserDao;
	}
	public void setBaUserDao(BaUserDao baUserDao) {
		this.baUserDao = baUserDao;
	}
	
	public List<Map<String, Object>> queryForList(String statement) throws BaException {

		return baUserDao.queryForList(statement);
	}

	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException {
 
		return baUserDao.queryForList(statement, params, jdbcTypes);
	}

	public List<Map<String, Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException {

		return baUserDao.queryForList(statement, startIndex, maxResults, params, jdbcTypes);
	}
	
	public Object queryForObject(String statement, Class elementType) throws BaException {

		return baUserDao.queryForObject(statement, elementType);
	}

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType) throws BaException {
		
		return baUserDao.queryForObject(statement, params, jdbcTypes, elementType);
	}

	public Map<String, Object> queryForMap(String statement) throws BaException {

		return baUserDao.queryForMap(statement);
	}

	public Map<String, Object> queryForMap(String statement, Object[] params, int[] jdbcTypes) throws BaException {

		return baUserDao.queryForMap(statement, params, jdbcTypes);
	}

	public int update(String statement) throws BaException {
		
		return baUserDao.update(statement);
	}

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		
		return baUserDao.update(statement, params, jdbcTypes);
	}
	
	/* 기본관리|학생관리 - 사용자목록 */
	public List<Map<String,Object>> getUserList(long companyid) throws BaException {
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		
		try {
			
			Map map2 =  new HashMap();
			
			list = baUserDao.queryForList("BA_USER.USER-MGMT-SELECT-ALL-EXCEL", 
								new Object[] { companyid, companyid, companyid ,companyid}, 
								new int[] { Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER });
			/*
			if(list!=null && list.size()>0){
				for(Map map : list){
					if(map.get("PHONE")!=null){
						map.put("PHONE", CommonUtils.ASEDecoding(map.get("PHONE").toString()));						
					}
					if(map.get("CELLPHONE")!=null){
						map.put("CELLPHONE", CommonUtils.ASEDecoding(map.get("CELLPHONE").toString()));
					}
					if(map.get("EMAIL")!=null){
						map.put("EMAIL", CommonUtils.ASEDecoding(map.get("EMAIL").toString()));
					}
					
				
				}
			}
			*/
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return list;
	}
	
	/* 기본관리|학생관리 - 사용자수 */
	public int getTotalUserCount(long companyid) throws BaException {
		
		return baUserDao.queryForInteger("BA_USER.COUNT_USER", 
				new Object[] { companyid }, 
				new int[] { Types.INTEGER });
	}
	
	
	/**
	 * 기본관리 > 사용자관리
	 * 사용자 상세정보
	 * @param companyid
	 * @param userid
	 * @return
	 * @throws BaException
	 */
	public List<Map<String,Object>> getMgmtUserInfo(long companyid, int userid) throws BaException {
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		
		try {
			list = baUserDao.queryForList("BA_USER.SELECT_MGMT_USER_INFO", 
								new Object[] { companyid, companyid, userid }, 
								new int[] { Types.INTEGER, Types.INTEGER, Types.INTEGER });
			
			// 암호화된 핸드폰, 전화, 이메일 복호화 작업
			
			/*
			if(list!=null && list.size()>0){
				for(Map map : list){
					if(map.get("PHONE")!=null){
						map.put("PHONE", CommonUtils.ASEDecoding(map.get("PHONE").toString()));						
					}
					if(map.get("CELLPHONE")!=null){
						map.put("CELLPHONE", CommonUtils.ASEDecoding(map.get("CELLPHONE").toString()));
					}
					if(map.get("EMAIL")!=null){
						map.put("EMAIL", CommonUtils.ASEDecoding(map.get("EMAIL").toString()));
					}
					
					log.debug("상세조회");
					log.debug(map.get("PHONE"));
					log.debug(map.get("CELLPHONE"));
					log.debug(map.get("EMAIL"));
				}
			}
			*/
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return list;
	}
	
	/**
	 * 기본관리 > 사용자저장
	 * 사용자 상세정보
	 * @param companyid
	 * @param userid
	 * @return
	 * @throws BaException
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int updateUser(Map map, User user) throws BaException {
		int saveCount = 0;
		long companyId = user.getCompanyId();
		long userId = user.getUserId();
		
		String comId = "" +companyId;
		log.debug("사용자저장");
		try {
			if(map != null) {
				if(map.get("mode").equals("add")) {	
					
					int _userid = baUserDao.queryForInteger("BA_USER.SELECT_NEW_USREID", null, null);
					// 비밀번호 생성
//					map.put("PASSWORD", passwordEncoder.encodePassword("123456", map.get("Id") ));
					
					
					//암호화
					//map.put("password", CommonUtils.passwdEncoding(map.get("password").toString()));
					//map.put("email", CommonUtils.ASEEncoding(map.get("email").toString()));
					//map.put("phone", CommonUtils.ASEEncoding(map.get("phone").toString()));
					//map.put("cellphone", CommonUtils.ASEEncoding(map.get("cellphone").toString()));
					
					//log.debug("사원 정보 저장 암호화");
					//log.debug(map.get("email"));
					//log.debug(map.get("password"));
					//log.debug(map.get("phone"));
					//log.debug(map.get("cellphone"));
					//CipherAria aria = new CipherAria();
										
					String id = "";
					if( map.get("Id").equals("") || map.get("Id")=="") {
						id = comId +"_"+ map.get("empNo");
						//log.debug("이경상"+id);
					} else {
						id = map.get("Id").toString();
					}
					
					saveCount = baUserDao.update("BA_USER.INSERT_BA_USER_INFO", 
							new Object[] { 
								_userid, map.get("password"), id, user.getCompanyId(), map.get("name"), 
								map.get("email"), map.get("phone"), map.get("cellphone"), map.get("dvsid"),
								map.get("job"), map.get("ldr"), map.get("useFlag"), user.getUserId(), map.get("empNo")
							}, 
							new int[] { 
								Types.INTEGER, Types.VARCHAR, Types.VARCHAR, Types.INTEGER, Types.VARCHAR,
								Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
								Types.INTEGER, Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.VARCHAR
							});
					
					// 기본권한부여
					int groupid = 4; 
					baUserDao.update("BA_USER.INSERT_USER_GROUPS", 
							new Object[] { groupid, _userid}, 
							new int[] {Types.INTEGER, Types.INTEGER});
				} else {
					// 사용자 정보변경
					
					//CipherAria aria = new CipherAria();
					
					//암호화
					//map.put("email", CommonUtils.ASEEncoding(map.get("email").toString()));
					//map.put("phone", CommonUtils.ASEEncoding(map.get("phone").toString()));
					//map.put("cellphone", CommonUtils.ASEEncoding(map.get("cellphone").toString()));
					
					log.debug("사원 정보 수정 암호화");
					//log.debug(map.get("email"));
					//log.debug(map.get("phone"));
					//log.debug(map.get("cellphone"));
					
					
					saveCount = baUserDao.update("BA_USER.UPDATE_BA_USER_INFO_NEW", 
							new Object[] { 
								//map.get("useFlag"),  
								//map.get("ldr"), 
								map.get("job"),
								user.getUserId(),
								map.get("userId"), 
								map.get("companyid")
							}, 
							new int[] { 
								//Types.VARCHAR, 
								//Types.VARCHAR, 
								Types.VARCHAR, 
								Types.INTEGER, 
								Types.INTEGER, 
								Types.INTEGER
							});
				}
					
			}
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		return saveCount;
	}
	
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public void updateUserPassword(Map map, User user) throws BaException {
		
		String password = (String) map.get("password");
		String empNo = (String)map.get("empNo");  		
		
		log.debug("비밀번호변경"+password);
		log.debug("교직원번호"+empNo);
		
		baUserDao.updateUserPassword(map);
	}
	
	/**
	 * 사용자관리 엑셀 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 04. 02.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CommonException.class )
	public int setUserListExcelUpload( User user,HttpServletRequest request) throws CommonException{ 
		
		int result = 0;
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;
		 
		long companyId = user.getCompanyId();
		long userId = user.getUserId();
		int groupid = 4;
		
		String comId = "" +companyId;
		
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
	                     
	                     String empNo = "";
	                     String pass = "";
	                     String name = "";
	                     String cellPhone = "";
	                     String phone = "";
                         String divisionId = "";
                         String job = "";
                         String leadership = "";
                         String email = "";
                         String useFlag = "";
                         String id = "";
                         
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
		                         	
		                         	 case 1 : empNo = szValue; break; 
		                         	 case 2 : pass = szValue; break; 
		                         	 case 3 : name = szValue; break;
			                         case 4 : cellPhone = szValue;  break;  
			                         case 5 : phone = szValue;  break;  
			                         case 7 : divisionId = szValue;  break;  
			                         case 9 : job = szValue;  break;
			                         case 11 : leadership = szValue; break;  
			                         case 12 : email = szValue; break; 
			                         case 13 : useFlag = szValue; break; 
		                         }
	                         }
	                     }
	                    
//	                     try {
	                     
	                     // 사용자 아이디 셀렉트
	         			int _userid = baUserDao.queryForInteger("BA_USER.SELECT_NEW_USREID_EXCEL", 
	        					new Object[] {companyId, empNo}, 
	        					new int[] {Types.INTEGER, Types.VARCHAR});
	           			
	 					//아이디 세팅
	 					id = comId +"_"+ empNo;
	                     
	                    pass = CommonUtils.passwdEncoding(pass.toString());
	                    cellPhone = CommonUtils.ASEEncoding(cellPhone.toString());
	                    phone = CommonUtils.ASEEncoding(phone.toString());
	                    email = CommonUtils.ASEEncoding(email.toString());
	                    
	                     log.debug("empNo : " + empNo);
	                     log.debug("divisionId : " + divisionId);
	                     log.debug("job: " + job);
	                     log.debug("leadership : " + leadership);
	                     log.debug("phone: " + phone);
	                     log.debug("useFlag : " + useFlag);
		                 log.debug("TEST"+_userid);
	                     
	                     this.update(
								"BA_USER.MERGE_USER",
								new Object[] { user.getCompanyId(), empNo, pass ,name, cellPhone, phone ,divisionId ,job ,leadership ,email,
										user.getUserId(), useFlag, id, _userid
										}, new int[] {
										Types.NUMERIC, Types.VARCHAR,
										Types.VARCHAR, Types.VARCHAR,
										Types.VARCHAR, Types.VARCHAR,
										Types.VARCHAR, Types.VARCHAR,
										Types.VARCHAR, Types.VARCHAR,
										Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR});
	                     
	                     //그룹 권한 부여 그룹아이디, 유저아이디
		 					this.update("BA_USER.MERGE_USER_GROUPS", 
		 							new Object[] { groupid, _userid}, 
		 							new int[] {Types.NUMERIC, Types.NUMERIC});
	                     
//	                     } catch (EmptyResultDataAccessException e) {
//	                    	 
//	                    	 return 0;
//	                     }
	                 }
	             }
	         }
	     }
	     catch(Throwable e){
	         e.printStackTrace();
	         throw new CommonException(e);
	     }
		
		return result;
	}
	
	/**
	 * 사용자관리 - 엑셀 저장
	 * @throws BaException 
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CommonException.class )
	public String userExcelUpload( User user, HttpServletRequest request) throws CommonException{
		String resultVal = "";
		int result = 0;
		int result2 = 0;
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;

		Row row = null;
		Cell cell = null;
	     
	    try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("userUploadFile")[0];
            
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
	                
	                //사용자정보 리스트(수정)
	                List<Object[]> uParamList1 = new ArrayList<Object[]>();
	                List<Object[]> uParamList2 = new ArrayList<Object[]>();
	     			
	                String szValue = "";
	                

					int invalidCnt = 0;
					int invalidJobCnt = 0;
					int reqCnt = 0;
					String msg = "";
					
					
	                for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                {
	                    row  = sheet.getRow( i);
	                     
	                    String userid = ""; //교직원번호
	                    String job = ""; //직무
                        //String leader = ""; //계급
                        //String manager = "";  //부서장여부
                        //int managerid = 0;
                        int _userid = 0;
                        int _job = 0;
                         
                        //실제 데이터가 끝나는 Column지정
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

		                        //null 제거
		                        szValue = CommonUtils.noNull(szValue);
		                        
		                        switch (nColumn) {
			                        case 0 : userid = szValue; break;
			                        case 1 : job = szValue; break;
			                        //case 2 : leader = szValue; break;
			                        //case 2 : manager = szValue;  break;
		                        }
	                        }
	                    }
	                    /*
	                    if(manager.equals("")){
	                    	manager = "N";
	                    }else{
	                    	manager = manager.toUpperCase();
	                    }
	                    */
	                    // 아이디(userid)를 통해 사용자번호를 받아온다. 
	                    // 엑셀업로드 템플릿 작성 시 입력받는 사번을 사용자번호로 바꿔준다.
	                    if(!userid.equals("") && !job.equals("")){
	                    	_userid = baUserDao.queryForInteger("BA_USER.SELECT_USERID", new Object[]{userid, user.getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
	                    	_job = baUserDao.queryForInteger("BA_USER.SELECT_JOBID", new Object[]{user.getCompanyId(), job}, new int[]{Types.NUMERIC,Types.NUMERIC});

		                    if(_userid > 0 && _job > 0){
		                    	
		                    	result += baUserDao.update("BA_USER.UPDATE_USER_JOB_LEADER", new Object[]{ job, _userid } , new int[]{Types.NUMERIC, Types.NUMERIC});
		                    	/*
		                    	managerid = 3;
	                    		if(manager.equals("Y")){
		                    		baUserDao.update("BA_USER.MERGE_USER_GROUPS", new Object[]{ managerid, _userid }, new int[]{Types.NUMERIC,Types.NUMERIC});
		                    	}else{
		                    		//부서장권한 삭제.
		                    		baUserDao.update("BA_USER.DELETE_INTO_GROUP", new Object[]{ managerid, _userid }, new int[]{Types.NUMERIC,Types.NUMERIC});
		                    	}
		                    	*/
		                    }else{
		                    	if(_userid == 0){
		                    		invalidCnt++;
			                    	msg += (i+1)+"줄 존재하지 않는 사용자\n";
		                    	}else{
		                    		invalidJobCnt++;
			                    	msg += (i+1)+"줄 존재하지 않는 직무코드\n";
		                    	}
		                    	
		                    }
	                    }else{
	                    	reqCnt++;
							msg += (i+1)+"줄 필수값 누락\n";
	                    }
	                }
	                

					resultVal = "변경 - "+result+"건 \n\n";
					resultVal += "존재하지 않는 사용자 - "+invalidCnt+"건 \n";
					resultVal += "존재하지 않는 직무코드 - "+invalidJobCnt+"건 \n";
					resultVal += "필수값 누락 - "+reqCnt+"건 \n\n";
					if(msg!=null && msg.length() > 300){
						resultVal += msg.substring(0, 299)+" 등...";
					}else{
						resultVal += msg;
					}
	            }
	         }
	     }catch(Throwable e){
	         e.printStackTrace();
	         throw new CommonException(e);
	     }
		
		return resultVal;
	}

	public List userCompetenceBackgroundList(User user) throws BaException {

		return baUserDao.userCompetenceBackgroundList(user.getUserId());
	}

	
	/* **************************************** */
	/* ************ 사용자 권한/그룹관리******* */
	/* **************************************** */
	
	/**
	 * 해당 고객사가 가지는 그룹목록
	 * @param companyid
	 * @return
	 * @throws BaException
	 */
	public List<Map<String,Object>> getGroups(long companyid) throws BaException {
		return baUserDao.queryForList("BA_USER.SELECT_USERGROUP_LIST", 
				new Object[] {}, 
				new int[] {});
	}
	
	/**
	 * 해당 고객사의 수강생이 가지고있는 그룹목록
	 * @param companyid
	 * @param userid
	 * @return
	 * @throws BaException
	 */
	public List getUserGroups(long companyid, String userid) throws BaException {
		return baUserDao.queryForList("BA_USER.SELECT_USER_SET_USERGROUP_LIST", 
				new Object[] { userid}, 
				new int[] { Types.INTEGER});
	}
	
	/**
	 * 그룹권한/삭제
	 * @param companyid
	 * @param userid
	 * @param items
	 * @return
	 * @throws BaException
	 */
	public String setUserGroups(long companyid, String userid, List<Map<String,Object>> items, String eduManagerFlag, String divisionid, long sessionUser) throws BaException { 
		String result = "N";
		try {
			
			// 교육운영 담당 부서 지정
			if(eduManagerFlag.equals("true")){
				
				// 기존 이력 삭제
				baUserDao.update("BA_USER.DELETE_TB_BA_DIVISION_EDU_MGR", new Object[] {userid}, new int[] {Types.INTEGER});
				
				// 새로운 부서 지정
				Object[] mergeParam = {companyid, divisionid, userid, 'Y', sessionUser };
				int[] jdbcTypes = {Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC	};
				baUserDao.update("BA_USER.INSERT_TB_BA_DIVISION_EDU_MGR", mergeParam, jdbcTypes);
				
			}
			
			baUserDao.update("BA_USER.DELETE_USER_SET_USERGROUP", 
					new Object[] {userid}, 
					new int[] {Types.INTEGER});
			
			if(items!=null && !items.isEmpty()) {
				for(Map<String,Object> row : items) {
					baUserDao.update("BA_USER.INSERT_USER_SET_USERGROUP", 
							new Object[] {row.get("DATA"), userid}, 
							new int[] {Types.INTEGER, Types.INTEGER});
				}
			}
			result = "Y";
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return result;
	}

	
	/**
	 * 사용자 중복체크
	 * @param companyId
	 * @param name 성명
	 * @param cellPhone 핸드폰번호
	 * @return
	 * @throws BaException
	 */
	public String chkUser(long companyId, String name, String cellPhone)  throws BaException {
		String result = "Y";
		try {
			// 성명이 동일한 인원 추출
			List<Map<String,Object>> list = baUserDao.queryForList("BA_USER.SELECT_CHK_USER_NAME_LIST", 
					new Object[] {companyId, name}, 
					new int[] {Types.INTEGER, Types.VARCHAR});
			
			if(!list.isEmpty()) {
			
				// DB의 핸드폰번호는 암호화되어 있으므로 복호화하여 비교
				//CipherAria aria = new CipherAria();
				
				String dcdCllPhn = "";
				
				for(Map<String,Object> item : list) {
					
					if(item.get("CELLPHONE")!=null){
						item.put("CELLPHONE", CommonUtils.ASEDecoding(item.get("CELLPHONE").toString()));
					}
					//dcdCllPhn = item.get("CELLPHONE")!=null? aria.decode(item.get("CELLPHONE").toString(), SystemWizUtils.getCipherkey(),0): "";
					
					log.debug("들어온값"+cellPhone);					
					log.debug("복호화 후 디비에 있던값"+item.get("CELLPHONE"));
					if(cellPhone.equals(item.get("CELLPHONE"))) {
						result = "N";
						break;
					}
				}
				
				/*
				result = baUserDao.queryForObject("BA_USER.SELECT_CHK_USER", 
										new Object[] {companyId, name, encdCllPhn}, 
										new int[] {Types.INTEGER, Types.VARCHAR, Types.VARCHAR}, 
										String.class).toString();
				*/
			}
		} catch(Throwable e) {
			log.error(e);
		}
		
		return result;
	}
	
	
	public List<Map<String,Object>> getUserInfo(long companyid, long userid) throws BaException {
		
		List<Map<String,Object>> list = Collections.EMPTY_LIST;
		
		try {
			list = baUserDao.queryForList("BA_USER.SELECT_USER_INFO", 
						new Object[] {userid, companyid, userid}, 
						new int[] {Types.INTEGER, Types.INTEGER, Types.INTEGER});
			
			if(!list.isEmpty() && list.size()>0) {
				Map<String,Object> map = list.get(0);
				// 전화번호, 핸드폰번호, 이메일 은 암호화 되어있으므로 복호화
				//CipherAria aria = new CipherAria();
				
				String dcdPhn = "";
				String dcdCllPhn = "";
				String dcdEmail = "";
					
				//dcdPhn = map.get("PHONE")!=null? aria.decode(map.get("PHONE").toString(), SystemWizUtils.getCipherkey(),0): "";
				log.debug(dcdPhn);
				//dcdCllPhn = map.get("CELLPHONE")!=null? aria.decode(map.get("CELLPHONE").toString(), SystemWizUtils.getCipherkey(),0): "";
				log.debug(dcdCllPhn);
				//dcdEmail = map.get("EMAIL")!=null? aria.decode(map.get("EMAIL").toString(), SystemWizUtils.getCipherkey(),0): "";
				log.debug(dcdEmail);
					
				map.put("PHONE", dcdPhn);
				map.put("CELLPHONE", dcdCllPhn);
				map.put("EMAIL", dcdEmail);
				
				// 사용자 이미지 셋팅
				if(map.get("IMAGE_ID")!=null) {
					map.put("IMG_URL","/secure/view-image.do?width=150&height=200&imageId="+map.get("IMAGE_ID")); 
				}
				list.set(0, map);
			}
		} catch(Throwable e) {
			log.error(e);
		}
		
		return list;
	}
	
	public String setUserImg(int userid, List<FileInfo> fileList) throws BaException {
		String result = "N";
		try {
			// 기존 이미지정보 유무파악
			int existingFileid = baUserDao.queryForInteger("BA_USER.SELECT_USER_IMG_ID", 
					new Object[] { userid}, 
					new int[] {Types.INTEGER});
			
			int fileid = 0;
			if(existingFileid<1) {	
				// 이미지 파일번호 추출
				fileid = baUserDao.queryForInteger("BA_USER.SELECT_IMG_NUMBER", null, null);
				existingFileid = fileid + 1;
				
				// 이미지 파일번호 갱신
				baUserDao.update("BA_USER.UPDATE_IMGNUMBER_INC", 
						new Object[] {existingFileid, 1, fileid}, 
						new int[] {Types.INTEGER, Types.INTEGER, Types.INTEGER});
			}
			
			if(!fileList.isEmpty()) {
				for(FileInfo file : fileList) {
					InputStream in = new FileInputStream(file.getFile());
					
					// 이미지 데이터 등록
					baUserDao.insertImgFile(existingFileid, file.getFile().length(), in);
					
					// 이미지 데이터 삭제
					baUserDao.update("BA_USER.DELETE_IMAGE_INFO", 
							new Object[] { existingFileid, 2, userid }, 
							new int[] { Types.INTEGER, Types.INTEGER, Types.INTEGER });
					
					// 이미지 정보 등록
					baUserDao.update("BA_USER.INSERT_IMAGE_INFO", 
						new Object[] {
							existingFileid, 2, userid, file.getName(), file.getFile().length(), file.getContentType()
						}, 
						new int[] {
							Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.VARCHAR
						});
				}
			}
			
			// 사용자 프로퍼티 삭제
			baUserDao.update("BA_USER.DELETE_USER_IMG_PROPERTY", 
					new Object[] { userid, existingFileid }, 
					new int[] { Types.INTEGER, Types.VARCHAR });
			
			// 사용자 프로퍼티 등록
			baUserDao.update("BA_USER.INSERT_USER_IMG_PROPERTY", 
					new Object[] { userid, existingFileid }, 
					new int[] { Types.INTEGER, Types.VARCHAR });
			
			// 기존 섬네일파일 삭제
			// 섬네일은 호출 시 변경사항을 알 수 없으므로 물리적 삭제, 이미지호출 시 재 생성
			try {
				File dir = ApplicationHelper.getRepository().getFile("images/cache");
				String pathname = dir.getPath();
				log.info("PATH :: " + dir.getPath());
				
				File dirFile = new File(pathname);
				
				File[] dirFileList = dirFile.listFiles();
				
				log.debug("FILE ID :: " + existingFileid);
				for(File tmpFile : dirFileList) {
					if(tmpFile.isFile()) {
						String filename = tmpFile.getName();
						log.debug("FILE NAME :: " + filename);
						try {
							if(filename.equals(existingFileid+".bin")) {
								log.debug("Ok.....");
								tmpFile.delete();
							} else if(filename.matches(existingFileid+".*\\.bin")) {
								log.debug("Ok.....");
								tmpFile.delete();
							} else {
								log.debug("No.....");
							}
						} catch(Exception ex) {
							log.error(ex);
						}
					}
				}
				
				
			} catch(Exception ie) {
				log.error(ie);
			}
			
			result = "Y";
		} catch(Throwable e) {
			log.error(e);
		}
		
		return result;
	}
	
	public List<Map<String,Object>> getUserImg(int userid) throws BaException {
		List<Map<String,Object>> list = baUserDao.queryForList("BA_USER.SELECT_USER_IMG_INFO", 
				new Object[] {userid}, 
				new int[] {Types.INTEGER});

		if(!list.isEmpty() && list.size()>0) {
			Map<String,Object> map = list.get(0);
			if(map.get("IMAGE_ID")!=null) {
				map.put("IMG_URL","/secure/view-image.do?width=150&height=200&imageId="+map.get("IMAGE_ID")); 
			}
			list.set(0, map);
		}
		
		return list;
	}
	
	
	public List<Map<String,Object>> getUserDeptList(long companyid) throws BaException {
		
		return baUserDao.queryForList("BA_USER.GET_BA_USER_DEPT_LIST", 
				new Object[] { companyid }, 
				new int[] { Types.INTEGER }); 
	}
	
	public String setUserInfoSdVisible(long userid, int sdVisible) throws BaException {
		String result = "N";
		try {
			baUserDao.update("BA_USER.UPDATE_USER_INFO_SD_VISIBLE", 
					new Object[] {sdVisible, userid}, 
					new int[] {Types.INTEGER, Types.INTEGER});
			
			result = "Y";
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return result;
	}
	
	
public List<Map<String,Object>> getUserJobList(long companyid, String jobLdrFlag) throws BaException {
	log.debug("직무");
	log.debug(jobLdrFlag);
	
		return baUserDao.queryForList("BA_USER.GET_BA_USER_JOBLDR_LIST", 
				new Object[] { companyid, jobLdrFlag }, 
				new int[] { Types.INTEGER, Types.VARCHAR }); 
	}

public List<Map<String,Object>> getUserLdrList(long companyid, String jobLdrFlag) throws BaException {
	log.debug("리더십");
	log.debug(jobLdrFlag);
	
		return baUserDao.queryForList("BA_USER.GET_BA_USER_JOBLDR_LIST", 
				new Object[] { companyid, jobLdrFlag }, 
				new int[] { Types.INTEGER, Types.VARCHAR }); 
	}
}
