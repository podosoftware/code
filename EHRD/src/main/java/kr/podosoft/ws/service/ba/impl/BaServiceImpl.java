package kr.podosoft.ws.service.ba.impl;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.BaService;
import kr.podosoft.ws.service.ba.dao.BaDao;
import kr.podosoft.ws.service.ca.CAException;
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
import architecture.ee.web.util.ParamUtils;

public class BaServiceImpl implements BaService {
	
	private Log log = LogFactory.getLog(getClass());
	
	private BaDao baDao;
	
	private PasswordEncoder passwordEncoder;
	
	public PasswordEncoder getPasswordEncoder() {
		return passwordEncoder;
	}
	
	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}
	
	public BaDao getBaDao() {
		return baDao;
	}
	
	public void setBaDao(BaDao baDao) {
		this.baDao = baDao;
	}	

	public List<Map<String, Object>> queryForList(String statement) throws BaException {
		return baDao.queryForList(statement);
	}

	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		return baDao.queryForList(statement, params, jdbcTypes);
	}

	public List<Map<String, Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException {
		return baDao.queryForList(statement, startIndex, maxResults, params, jdbcTypes);
	}

	public Object queryForObject(String statement, Class elementType) throws BaException {
		Object obj = null;
		try {
			obj = baDao.queryForObject(statement, elementType);
		} catch(Throwable e) {
			log.error(e);
		}
		return obj;
	}

	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class elementType) throws BaException {
		Object obj = null;
		try {
			obj = baDao.queryForObject(statement, params, jdbcTypes, elementType);
		} catch(Throwable e) {
			log.error(e);
		}
		return obj;
	}

	public Map<String, Object> queryForMap(String statement) throws BaException {
		return baDao.queryForMap(statement);
	}

	public Map<String, Object> queryForMap(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		return baDao.queryForMap(statement, params, jdbcTypes);
	}

	public int update(String statement) throws BaException {
		return baDao.update(statement);
	}

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		return baDao.update(statement, params, jdbcTypes);
	}

	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws BaException {
		return baDao.batchUpdate(statement, parameteres, jdbcTypes);
	}

	public int excute(String statement) throws BaException {
		return baDao.excute(statement);
	}

	public int excute(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		return baDao.excute(statement, params, jdbcTypes);
	}
	
	/* ***************************************************************************** */
	/* ********** COMPANY MANAGEMENT SERVICE ********* */
	/* ***************************************************************************** */
	/**
	 * 회사정보 저장
	 * @throws Exception 
	 */
	public int companySave(HttpServletRequest request, User user) throws Exception{
		int saveCount = 0;
		
		try{
			Map<String, Object> map = ParamUtils.getJsonParameter(request, "item", Map.class);
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			
			String companyid = (String)map.get("COMPANYID");
			String companyname = (String)map.get("COMPANYNAME"); //고객사명
			String rgstNo = (String)map.get("RGST_NO"); //사업자등록번호
			//Date ctrtStDt = new Date(map.get("CTRT_ST_DT").toString()); //계약시작일
			//Date ctrtEdDt = new Date(map.get("CTRT_ED_DT").toString()); //계약종료일
			
			Date ctrtStDt = sdf.parse(map.get("CTRT_ST_DT").toString());
			Date ctrtEdDt  = sdf.parse(map.get("CTRT_ED_DT").toString());
			
			String cmptInfoAddYn = (String)map.get("CMPT_INFO_ADD_YN"); //역량추가여부
			String kpiAddYn = (String)map.get("KPI_ADD_YN"); //kpi지표추가여부
			String cstmId = (String)map.get("CSTM_ID"); //고객사id
			String userid = (String)map.get("USERID"); //운영사 사용자번호
			String empno = (String)map.get("EMPNO"); //운영자 사번
			String pwd = (String)map.get("PWD"); //운영자 비번
			String name = (String)map.get("NAME"); //운영자성명
			String email = (String)map.get("EMAIL"); //운영자이메일
			String phone = (String)map.get("PHONE"); //운영자연락처
			String homePgType = (String)map.get("HOME_PG_TYPE"); //홈페이지 타입
			String useflag = (String)map.get("USEFLAG"); //사용여부
			//String logoFileid = (String)map.get("LOGO_FILEID"); //로고 파일번호
			String mnCmt = (String)map.get("MN_CMT"); //회사별 코멘트.
			String objectiD = (String)map.get("OBJECTID"); //임시첨부파일 id
			
			
			//개인정보 암호화
			String encEmail = CommonUtils.ASEEncoding(email);
			String encPhone = CommonUtils.ASEEncoding(phone);
			
			log.debug("@@@@companyname:"+companyname +", companyid:"+companyid);
			
			
			int companyidNum = 0;
			int useridNum = 0;
			if(companyid!=null && !companyid.equals("")){
				//기존 고객사 수정 프로세스...
				companyidNum = Integer.parseInt(companyid);
			}else{
				//신규 고객사 등록
				int maxCompanyid = Integer.parseInt(queryForObject("BA.MAX_COMPANYID", null, null, String.class).toString());
				companyidNum = maxCompanyid;
			}
			if(userid!=null && !userid.equals("")){
				useridNum = Integer.parseInt(userid);
			}else{
				int maxUserid = Integer.parseInt(queryForObject("BA.MAX_USERID", null, null, String.class).toString());
				useridNum = maxUserid;
			}
			String encPwd = CommonUtils.passwdEncoding(pwd);
			log.debug("@@@@encPwd:"+encPwd);
			
			
			//1. 고객사 정보 입력/수정
			//2. 담당자 정보 입력/수정
			//3. 담당자 권한입력(일반사용자, 고객사 운영자) / 수정
			//4. 공통코드 해당 내용 입력/수정
			//5. 임시첨부파일 id update
			saveCount = update("BA.INSERT_COMPANY", 
					new Object[]{
					companyidNum, companyname, rgstNo, ctrtStDt, ctrtEdDt, cmptInfoAddYn, // 6
					kpiAddYn, cstmId, homePgType, useflag, user.getUserId(), //5
					mnCmt, //company Parameter.. //1
					useridNum, encPwd, companyidNum, name, encEmail, //5 
					encPhone, useflag, user.getUserId(), empno, //user Parameter //4
					useridNum, //1
					companyidNum, //1
					useridNum, //1
					useridNum, //1
					companyidNum, companyidNum, //2
					companyidNum, Integer.parseInt(objectiD) //2
			}, 
					new int[]{
					Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.DATE, Types.DATE, Types.VARCHAR, // 6
					Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,//5
					Types.VARCHAR, //company Types..//1
					Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, //5 
					Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.VARCHAR, //user Types //4
					Types.NUMERIC,  //1
					Types.NUMERIC,  //1
					Types.NUMERIC,  //1
					Types.NUMERIC,  //1
					Types.NUMERIC, Types.NUMERIC, //2
					Types.NUMERIC, Types.NUMERIC //2
			});
			log.debug("#### saveCount:"+saveCount);
		}catch(Exception e){
			
			e.printStackTrace();
		}
		return saveCount;
	}
	
	/**
	 * 고객사에서 사용하는 역량 저장
	 * @throws Exception 
	 */
	public int companyCmptUseSave(HttpServletRequest request, User user) throws Exception{
		int saveCount = 0;
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		String paramCompanyid = ParamUtils.getParameter(request, "COMPANYID");
		int companyid = Integer.parseInt(paramCompanyid);
		
		//선택된 고객사의 모든 역량, 행동지표를 사용안함 처리하고,
		update("BA.SELECT_COMPANY_CMPT_USE_N", new Object[]{companyid}, new int[]{Types.NUMERIC});
		update("BA.SELECT_COMPANY_BHV_USE_N", new Object[]{companyid}, new int[]{Types.NUMERIC});
		
		//사용할 역량과 행동지표를 merge 한다.
		int listCnt = 0;
		for(Map<String, Object> map: list){
			String chk = map.get("CHK")==null ? "" : map.get("CHK").toString();
			//사용하기로 체크된 역량만 저장.
			if(chk.equals("checked")){
				int cmpNumber = map.get("CMPNUMBER")==null ? 0 : Integer.parseInt(map.get("CMPNUMBER").toString());
				saveCount += update("BA.SELECT_COMPANY_CMPT_USE_MERGE", 
						new Object[]{
							companyid, user.getUserId(), cmpNumber, companyid, user.getUserId(), cmpNumber
						}, new int[]{
							Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
					});
			}else{
				listCnt++;
			}
		}
		// 모든 KPI를 체크해제한경우..
		if(list.size() == listCnt){
			saveCount = 99999;
		}
		log.debug("#### saveCount:"+saveCount);
		
		return saveCount;
	}
	
	/**
	 * 고객사에서 사용하는 KPI 저장
	 * @throws Exception 
	 */
	public int companyKpiUseSave(HttpServletRequest request, User user) throws Exception{
		int saveCount = 0;
		List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
		String paramCompanyid = ParamUtils.getParameter(request, "COMPANYID");
		int companyid = Integer.parseInt(paramCompanyid);
		
		//선택된 고객사의 모든 KPI를 사용안함 처리하고,
		update("BA.SELECT_COMPANY_KPI_USE_N", new Object[]{companyid}, new int[]{Types.NUMERIC});
		
		//사용할 KPI를 merge 한다.
		int listCnt = 0;
		for(Map<String, Object> map: list){
			String chk = map.get("CHK")==null ? "" : map.get("CHK").toString();
			//사용하기로 체크된 KPI 만 저장.
			if(chk.equals("checked")){
				int kpiNo = map.get("KPI_NO")==null ? 0 : Integer.parseInt(map.get("KPI_NO").toString());
				saveCount += update("BA.COMPANY_KPI_USE_MERGE", 
						new Object[]{
							companyid, user.getUserId(), kpiNo
						}, new int[]{
							Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
					});
			}else{
				listCnt ++;
			}
		}
		// 모든 KPI를 체크해제한경우..
		if(list.size() == listCnt){
			saveCount = 99999;
		}
		log.debug("#### saveCount:"+saveCount);
		
		return saveCount;
	}
	
	/* ***************************************************************************** */
	/* ********** DEPARTMENT MANAGEMENT SERVICE ********* */
	/* ***************************************************************************** */
	
	/**
	 * 부서트리는 level 6까지 허용되는것으로 처리함..
	 */
	public List<Map<String,Object>> getDeptMngList(long companyid, String useFlag) throws BaException {
		//log.debug("@@@@@@@@@ 1 time..... "+new Timestamp(System.currentTimeMillis()));
		List<Map<String,Object>> list = baDao.queryForList("BA.SELECT_DEPT_MNG_LIST", new Object[] {companyid, useFlag}, new int[] {Types.INTEGER, Types.VARCHAR});
		//log.debug("@@@@@@@@@ 2 time..... "+new Timestamp(System.currentTimeMillis()));
		
		List<Map<String, Object>> oneList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> twoList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> threeList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> fourList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> fiveList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> sixList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> sevenList = new ArrayList<Map<String, Object>>();
 		
		log.debug("list.size:"+list.size());
		if(list!=null && list.size()>0){
			int maxLevel = Integer.parseInt(list.get(0).get("MAXLVL").toString());
			
			int index = 0;
			//최상위 노드 
			//for(Map map : list){
			for(int i=0; i<list.size(); i++){
				Map<String, Object> map = list.get(i);
				switch(Integer.parseInt(map.get("LVL").toString())){
				case 1:
					oneList.add(map);
					break;
				case 2:
					twoList.add(map);
					break;
				case 3:
					threeList.add(map);
					break;
				case 4:
					fourList.add(map);
					break;
				case 5:
					fiveList.add(map);
					break;
				case 6:
					sixList.add(map);
					break;
				case 7:
					sevenList.add(map);
					break;
				}
			}
	
			log.debug("@@@@ oneList.size():"+oneList.size());
			if(oneList.size()>0){
				//최상위 노드 하위로 max level 까지 loop..
				//int fIndex = 0;
				if(maxLevel>=2){
					for(Map onemap : oneList){
						//log.debug("@@@@ fmap.get('CHILDREN_CNT'):"+fmap.get("CHILDREN_CNT"));
						
						//현재 조직이 level 2의 하위조직이 존재하는지 체크
						if(!onemap.get("CHILDREN_CNT").toString().equals("0")){
							List<Map<String, Object>> secondList = new ArrayList<Map<String, Object>>();
							log.debug("list.size:"+list.size());
							int sindex = 0;
		 					for(Map twomap : twoList){
								//log.debug("@@@@ :"+map.get("LVL")+", "+map.get("HIGH_DVSID")+", "+fmap.get("DIVISIONID"));
		 						if(twomap.get("HIGH_DVSID").toString().equals(onemap.get("DIVISIONID").toString())){
		 							
		 							//현재 조직이 level 3의 하위조직이 존재하는지 체크
		 							if(!twomap.get("CHILDREN_CNT").toString().equals("0")){
						 				List<Map<String, Object>> thirdList = new ArrayList<Map<String, Object>>();
					 					for(Map threeMap : threeList){
				 							if(threeMap.get("HIGH_DVSID").toString().equals(twomap.get("DIVISIONID").toString())){
				 								
				 								//현재 조직이 level4에 해당하는 하위조직이 있는지 체크
				 								if(!threeMap.get("CHILDREN_CNT").toString().equals("0")){
				 									List<Map<String, Object>> fourthList = new ArrayList<Map<String, Object>>();
								 					for(Map fourMap : fourList){
								 						if(fourMap.get("HIGH_DVSID").toString().equals(threeMap.get("DIVISIONID").toString())){
								 							
							 								//현재 조직이 level5에 해당하는 하위조직이 있는지 체크
							 								if(!fourMap.get("CHILDREN_CNT").toString().equals("0")){
							 									List<Map<String, Object>> fifthList = new ArrayList<Map<String, Object>>();
											 					for(Map fiveMap : fiveList){
											 						if(fiveMap.get("HIGH_DVSID").toString().equals(fourMap.get("DIVISIONID").toString())){

										 								//현재 조직이 level6에 해당하는 하위조직이 있는지 체크
										 								if(!fiveMap.get("CHILDREN_CNT").toString().equals("0")){
										 									List<Map<String, Object>> sixthList = new ArrayList<Map<String, Object>>();
														 					for(Map sixMap : sixList){
														 						if(sixMap.get("HIGH_DVSID").toString().equals(fiveMap.get("DIVISIONID").toString())){

													 								//현재 조직이 level7에 해당하는 하위조직이 있는지 체크
													 								if(!sixMap.get("CHILDREN_CNT").toString().equals("0")){
													 									List<Map<String, Object>> seventhList = new ArrayList<Map<String, Object>>();
													 									for(Map sevenMap : sevenList){
													 										if(sevenMap.get("HIGH_DVSID").toString().equals(sixMap.get("DIVISIONID").toString())){
													 											
													 											seventhList.add(sevenMap);
													 										}
													 									}
													 									if(seventhList.size()>0){
													 										sixMap.put("items", seventhList);
													 									}
													 								}
														 							sixthList.add(sixMap);
														 						}
														 					}
														 					if(sixthList.size()>0){
														 						fiveMap.put("items", sixthList);
														 					}
										 								}
											 							fifthList.add(fiveMap);
											 						}
											 					}
											 					if(fifthList.size()>0){
											 						fourMap.put("items", fifthList);
											 					}
							 								}
								 							fourthList.add(fourMap);
								 						}
								 					}
								 					if(fourthList.size()>0){
								 						threeMap.put("items", fourthList);
								 					}
				 								}
				 								thirdList.add(threeMap);
				 							}
				 						}
				 						if(thirdList.size()>0){
				 							twomap.put("items", thirdList);
					 					}
		 							}
			 						secondList.add(twomap);
			 					}
			 				}
							if(secondList.size()>0){
								onemap.put("items", secondList);
							}
						}
						//fIndex++;
					}//end for
				}//end if
			}
		}
		//log.debug("@@@@@@@@@ 3 time..... "+new Timestamp(System.currentTimeMillis()));
		return oneList;
	}
	
	/**
	 * 부서정보 엑셀 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 3. 28.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int divisionExcelSaveService( User user,HttpServletRequest request){
		
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
	                     
	                     String divisionid = "";
                         String dvsName = "";
                         String dvsManager = "";
                         String dvsManagerNm = "";
                         String highDvsid = "";
                         String highDvsidName = "";
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
		                         	
		                         	 case 0 : divisionid = szValue; break; 
			                         case 1 : dvsName = szValue; break;
			                         case 2 : highDvsid = szValue;  break;  
			                         case 3 : highDvsidName = szValue;  break;
			                         case 4 : dvsManager = szValue; break;  
			                         case 5 : dvsManagerNm = szValue;  break;
			                         case 6 : useFlag = szValue; break; 
		                         }
	                         }
	                     }

	                     
	                     log.debug("divisionid : " + divisionid);
	                     log.debug("dvsName : " + dvsName);
	                     log.debug("highDvsid : " + highDvsid);
	                     log.debug("highDvsidName: " + highDvsidName);   
	                     log.debug("dvsManager : " + dvsManager);
	                     log.debug("dvsManagerNm: " + dvsManagerNm);   
	                     log.debug("useFlag : " + useFlag);
	                     
	                     
						this.update(
								"BA.MERGE_DEPT",
								new Object[] { user.getCompanyId(), divisionid,
										dvsName, highDvsid, dvsManager,
										useFlag, user.getUserId(),
										user.getCompanyId() }, new int[] {
										Types.NUMERIC, Types.VARCHAR,
										Types.VARCHAR, Types.VARCHAR,
										Types.VARCHAR, Types.VARCHAR,
										Types.VARCHAR, Types.NUMERIC });
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
	 * 직무정보,역량매핑 등록.
	 */
	public int saveJobInfo(HttpServletRequest request, User user) {
		int resultCnt = 0;
		try {
			//역량매핑 정보
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
			//행동지표 정보
			List<Map<String, Object>> list2 = ParamUtils.getJsonParameter(request, "item", "LIST2",List.class);
			//직급매핑 정보
			List<Map<String, Object>> list3 = ParamUtils.getJsonParameter(request, "item", "LIST3",List.class);

			long companyId = user.getCompanyId();
			String userId = String.valueOf(user.getUserId());
			
			String mode = ParamUtils.getParameter(request, "mode");
			String jobLdrNum = ParamUtils.getParameter(request, "jobLdrNum");
			String jobLdrName = ParamUtils.getParameter(request, "jobLdrName");
			String comJobCd = ParamUtils.getParameter(request, "comJobCd");
			String jobLdrComment = ParamUtils.getParameter(request, "jobLdrComment");
			String useFlag = ParamUtils.getParameter(request, "useFlag");
			String jobFlag = ParamUtils.getParameter(request, "jobFlag");
			String mainTask = ParamUtils.getParameter(request, "mainTask");
			
			//직무 기본 정보 저장,추가
			if(mode!=null) {
				if(mode.equals("add")) 
				{	
					resultCnt = Integer.valueOf(baDao.queryForObject("BA.SELECT-JOB-INSERT-CNT", 
							new Object[] {user.getCompanyId()}, 
							new int[] {Types.INTEGER},
							Integer.class).toString());
					Object[] params = {
							companyId, resultCnt, jobLdrName, jobFlag, jobLdrComment ,useFlag, userId ,mainTask, comJobCd
					};
					int[] jdbcTypes = {
							Types.INTEGER, Types.INTEGER, Types.VARCHAR, Types.VARCHAR ,Types.VARCHAR ,Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR
					};
					jobLdrNum = String.valueOf(resultCnt);
					resultCnt = baDao.update("BA.SELECT-JOB-INSERT", params, jdbcTypes);
				} 
				else if(mode.equals("mod")) 
				{
					Object[] params = {
							jobLdrName, comJobCd, jobLdrComment, useFlag ,userId, mainTask, companyId  ,jobLdrNum ,jobFlag 
					};
					int[] jdbcTypes = {
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR ,Types.INTEGER, Types.INTEGER, Types.VARCHAR
					};
					resultCnt = baDao.update("BA.SELECT-JOB-UPDATE", params, jdbcTypes);
				}
			}
			
			//해당하는 역량 미사용처리
			baDao.update("BA.UPDATE_JOB_COMP_MAPPING", new Object[]{user.getCompanyId(), jobLdrNum}, new int []{Types.NUMERIC, Types.NUMERIC});
            			
			//역량매핑정보 merge
			for(Map map: list){
				String cmpnumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
				//String std_score = map.get("STD_SCORE")==null?"":map.get("STD_SCORE").toString();
				
				//요구수준 저장 안함. 추후 검토
				//resultCnt += baDao.update("BA.MERGE_TB_COMP_JOB_MAP", new Object[]{user.getCompanyId(), cmpnumber, jobLdrNum, std_score}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC , Types.DOUBLE });
				resultCnt += baDao.update("BA.MERGE_TB_COMP_JOB_MAP", new Object[]{user.getCompanyId(), cmpnumber, jobLdrNum}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
				//해당하는 행동지표 미사용처리
				baDao.update("BA.UPDATE_JOB_INDC_MAPPING", new Object[]{user.getCompanyId(), jobLdrNum}, new int []{Types.NUMERIC, Types.NUMERIC});
			}
			
			//행동지표 매핑 정보 merge
			for(Map map: list2){
				String cmpnumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
				String indcNum = map.get("BHV_INDC_NUM")==null?"":map.get("BHV_INDC_NUM").toString();
				
				resultCnt += baDao.update("BA.MERGE_TB_INDC_JOB_MAP", new Object[]{user.getCompanyId(), cmpnumber, jobLdrNum, indcNum}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
			}
			
			baDao.update("BA.UPDATE_JOB_GRADE_MAPPING", new Object[]{user.getCompanyId(), jobLdrNum}, new int []{Types.NUMERIC, Types.NUMERIC});
			
			//직급 매핑 정보 merge
			for(Map map: list3){
				String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
				String commonCode = map.get("COMMONCODE")==null?"":map.get("COMMONCODE").toString();
				String listJobLdrNum = map.get("JOBLDR_NUM")==null?"":map.get("JOBLDR_NUM").toString();
				
				//다른 계급에서 사용하고 있을경우 N처리
				if((listJobLdrNum != null || !"".equals(listJobLdrNum)) && checkFlag.equals("checked")){
					baDao.update("BA.UPDATE_TB_GRADE_JOB_NOT_USE", new Object[]{user.getCompanyId(), listJobLdrNum, commonCode}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.VARCHAR });
				}
				if(checkFlag.equals("checked") && !commonCode.equals("")){
					resultCnt += baDao.update("BA.MERGE_TB_GRADE_JOB_MAP", new Object[]{user.getCompanyId(), jobLdrNum, commonCode}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.VARCHAR });
			
				}
			}
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return resultCnt;
	}
	
	/**
	 * 직무삭제시 역량매핑삭제.
	 */
	public int deleteJobComp(HttpServletRequest request, User user) {
		int resultCnt = 0;
		try {
			//역량매핑 정보
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
			//행동지표 정보
			List<Map<String, Object>> list2 = ParamUtils.getJsonParameter(request, "item", "LIST2",List.class);
			//직급매핑 정보
			List<Map<String, Object>> list3 = ParamUtils.getJsonParameter(request, "item", "LIST3",List.class);

			long companyId = user.getCompanyId();
			String userId = String.valueOf(user.getUserId());
			
			String jobLdrNum = ParamUtils.getParameter(request, "jobLdrNum");
			
			//역량매핑정보 삭제
			for(Map<String, Object> map: list){
				String cmpnumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
				
				baDao.update("BA.UPDATE_JOB_COMP_DEL", new Object[]{user.getCompanyId(), jobLdrNum,cmpnumber}, new int []{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
			}
			
			//행동지표 매핑 정보 삭제
			for(Map<String, Object> map: list2){
				String cmpnumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
				String indcNum = map.get("BHV_INDC_NUM")==null?"":map.get("BHV_INDC_NUM").toString();
				
				resultCnt += baDao.update("BA.UPDATE_JOB_INDC_DEL",
						new Object[]{user.getCompanyId(),jobLdrNum, cmpnumber, indcNum},
						new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
			}
			//직급 매핑 정보 삭제
			for(Map<String, Object> map: list3){
				String cmpnumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
				
				resultCnt += baDao.update("BA.UPDATE_JOB_GRADE_DEL", new Object[]{user.getCompanyId(),jobLdrNum}, new int[]{ Types.NUMERIC, Types.NUMERIC});
			}
			
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return resultCnt;
	}

	/**
	 * 기본관리 -> 직무관리 엑셀저장
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CAException.class )
	public int jobLdrExcelSaveService( User user,String jobFlag, HttpServletRequest request){
		
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
	                     
	                     String jobLdrNum = "";
                         String jobLdrName = "";
                         String jobLdrComment = "";
                         String mainTask = "";
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
		                         	
		                         	 case 0 : jobLdrNum = szValue; break; 
			                         case 1 : jobLdrName = szValue; break;
			                         case 2 : jobLdrComment = szValue;  break;  
			                         case 3 : mainTask = szValue;  break;
			                         case 4 : useFlag = szValue; break; 
		                         }
	                         }
	                     }

	                     
	                     log.debug("jobLdrNum : " + jobLdrNum);
	                     log.debug("jobLdrName : " + jobLdrName);
	                     log.debug("jobLdrComment : " + jobLdrComment);
	                     log.debug("useFlag : " + useFlag);   
	                     log.debug("직무관리 플래그값 : " + jobFlag);
	                     
	                     
	                     baDao.mergeBhvIndicator(companyId, jobLdrNum, jobLdrName, jobFlag, jobLdrComment, mainTask,  useFlag, userId);
	                     
	                     //baDao.deleteExample(companyId, cmpNum, bhvIndicatorNum);
	                     
	                    
	                 }
	             }
	         }
	     }
	     catch(Exception e){
	         e.printStackTrace();
	     }
		
		return result;
	}
	
}