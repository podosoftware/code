package kr.podosoft.ws.service.ba.impl;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.BaSubjectService;
import kr.podosoft.ws.service.ba.dao.BaSubjectDao;
import kr.podosoft.ws.service.cdp.CdpException;
import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.em.EmAlwService;
import kr.podosoft.ws.service.utils.CommonUtils;

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

public class BaSubjectServiceImpl implements BaSubjectService {
	
	private Log log = LogFactory.getLog(getClass());
	
	private BaSubjectDao baSubjectDao;
	
	private EmAlwService emAlwService;
	
	public BaSubjectDao getBaSubjectDao() {
		return baSubjectDao;
	}
	public void setBaSubjectDao(BaSubjectDao baSubjectDao) {
		this.baSubjectDao = baSubjectDao;
	}

	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		return baSubjectDao.queryForList(statement, params, jdbcTypes);
	}

	public List<Map<String, Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException {
		return baSubjectDao.queryForList(statement, startIndex, maxResults, params, jdbcTypes);
	}
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		return baSubjectDao.queryForInteger(statement, params, jdbcTypes);
	}

	public int update(String statement) throws BaException {
		return baSubjectDao.update(statement);
	}

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		return baSubjectDao.update(statement, params, jdbcTypes);
	}

	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws BaException {
		return baSubjectDao.batchUpdate(statement, parameteres, jdbcTypes);
	}
	public Object queryForObject(String statement, Object[] params, int[] jdbcTypes, Class<?> cls) throws BaException {
		return baSubjectDao.queryForObject(statement, params, jdbcTypes, cls);
	}
	public EmAlwService getEmAlwService() {
		return emAlwService;
	}
	public void setEmAlwService(EmAlwService emAlwService) {
		this.emAlwService = emAlwService;
	}
	
	/**
	 * 차시정보 일괄삭제처리
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int severalDelSbjctOpenInfo(User user, String[] openArr) throws BaException {
		int resultCnt = 0;
		try {
			log.debug("###openArr.length:"+openArr.length);
			if(openArr!=null && openArr.length>0) {
				for(String openNum: openArr){
					log.debug("###openNum:"+openNum);
					if(openNum!=null && !openNum.equals("")){
						resultCnt += baSubjectDao.update("BA_SUBJECT.SEVERAL_DELETE_TB_BA_SBJCT_OPEN",
								new Object[] {user.getUserId(), user.getCompanyId(), openNum}, 
								new int[] {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
					}
					log.debug("======resultCnt:"+resultCnt);
				}
			}
			
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}

		log.debug("###resultCnt:"+resultCnt);
		return resultCnt;
	}
	
	/**
	 * 교육관리 - 가중치계산<br/>
	 * @param autoTime 
	 * @return
	 * @since 2015. 02. 04.
	 */
	public List<Map<String, Object>> getAutoRecogTime(HttpServletRequest request, User user) {
		List<Map<String, Object>>  list = new ArrayList<Map<String, Object>>();
		Map<String, Object> map =  new HashMap<String, Object>();
		String autoHour="";
		String autoMin="";
		try {
			String hour = ParamUtils.getParameter(request, "hour","0");
			String min = ParamUtils.getParameter(request, "min","0");
			String weight = ParamUtils.getParameter(request, "weight","0");
			int h = Integer.parseInt(hour)*60;
			int m = Integer.parseInt(min);
			int autoTime = (h+m)*Integer.parseInt(weight)/100;
			
			autoHour = String.valueOf(Math.floor(autoTime/60));
			autoMin =String.valueOf(autoTime-(Math.floor(autoTime/60)*60));
			map.put("autoHour", autoHour);
			map.put("autoMin", autoMin);
		} catch (Exception e) {
			log.debug(e);
		}
		list.add(map);
		log.debug(list);
		return list;
	}
	
	/**
	 * 차수관리 - 차수 엑셀 업로드
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class )
	public String upLoadSbjctOpenListExcel( User user, HttpServletRequest request){
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
	                
	                //과정정보 리스트(추가)
	                List<Object[]> iParamList = new ArrayList<Object[]>();
	                //과정정보 리스트(수정)
	                //List<Object[]> uParamList = new ArrayList<Object[]>();
	                //과정정보 리스트(삭제)
	                //List<Object[]> dParamList = new ArrayList<Object[]>();
	     			
	                String szValue = "";

					int invalidCnt = 0;
					int dupCnt = 0;
					int reqCnt = 0;
					String msg = "";
					
	                for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                {
	                    row  = sheet.getRow( i);
	                     
	                    //String div = ""; //작업구분
	                    //String openNum = ""; //개설번호
                        //String subjectName = ""; //과정명
	                    String subjectNum = ""; //과정번호
                        String yyyy = ""; //개설년도
                        String chasu = ""; //차수
                        String eduSdate = ""; //교육시작일
                        String eduEdate = ""; //교육종료일
                        String applySdate = ""; //수강신청시작일
                        String applyEdate = ""; //수강신청종료일
                        String cancelDate = ""; //취소마감일
                        String applicant = ""; //모집정원
                        String eduDays = ""; //교육일수
                         
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
			                        //case 1 : openNum = szValue; break;
		                        	//case 1 : subjectName = szValue;  break;
		                        	case 0 : subjectNum = szValue; break;
			                        case 1 : yyyy = szValue;  break;
			                        case 2 : chasu = szValue;  break;
			                        case 3 : eduSdate = szValue;  break;
			                        case 4 : eduEdate = szValue;  break;
			                        case 5 : applySdate = szValue;  break;
			                        case 6 : applyEdate = szValue;  break;
			                        case 7 : cancelDate = szValue;  break;
			                        case 8 : applicant = szValue;  break;
			                        case 9 : eduDays = szValue;  break;
		                        }
	                        }
	                    }

	                    //div = div.toUpperCase();
	                    
	                    if(applicant.equals("")){
	                    	applicant = "0";
	                    }

	                    if(eduDays.equals("")){
	                    	eduDays = "0";
	                    }
	                    
	                    eduSdate = eduSdate.replace(".", "-");
	                    eduEdate = eduEdate.replace(".", "-");
	                    applySdate = applySdate.replace(".", "-");
	                    applyEdate = applyEdate.replace(".", "-");
	                    cancelDate = cancelDate.replace(".", "-");
	                    
	                    //log.debug("#### div:"+div);
	                    //log.debug("#### openNum : " + openNum);

	                    log.debug("#### subjectNum : " + subjectNum);
	                    log.debug("####"+eduSdate +","+ eduEdate +","+ applySdate +","+ applyEdate +","+ cancelDate);
	                    log.debug("####"+CommonUtils.isDate(eduSdate) +","+ CommonUtils.isDate(eduEdate) +","+ CommonUtils.isDate(applySdate) +","+ CommonUtils.isDate(applyEdate) +","+ CommonUtils.isDate(cancelDate));

	                    if(!subjectNum.equals("") && !yyyy.equals("") && !chasu.equals("") && !eduSdate.equals("") && !eduEdate.equals("") && !applySdate.equals("") && !applyEdate.equals("") && !cancelDate.equals("") ){
	                    	int isCnt = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_IS_USE_OPEN_CNT",
	                    			new Object[]{ user.getCompanyId(), subjectNum },
	                    			new int[]{ Types.NUMERIC, Types.NUMERIC});
	                    	
	                    	if(isCnt > 0){
	                    		
                    			//개설년도 유효성 검사.
	                    		if(CommonUtils.isNumber(yyyy) && yyyy.length()==4){
	                    			//숫자형 데이터 체크
	                    			if(CommonUtils.isNumber(chasu) && (applicant.equals("")||CommonUtils.isNumber(applicant)) && (eduDays.equals("")||CommonUtils.isNumber(eduDays))){
	                    				// 날짜 입력 값 유효성 체크
	                    				if( CommonUtils.isDate(eduSdate) && CommonUtils.isDate(eduEdate) && CommonUtils.isDate(applySdate) && CommonUtils.isDate(applyEdate) && CommonUtils.isDate(cancelDate) ){
	                    					//동일기간으로 입력된 개설 있는지 체크
	                    					int isExCnt = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_IS_USE_SAME_PERIOD_OPEN_CNT",
	                    							new Object[]{ user.getCompanyId(), subjectNum, yyyy, eduSdate, eduEdate }, 
	                    							new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.DATE, Types.DATE });
	                    					
	                    					if(isExCnt == 0){
	                    						
	                    						int maxOpenNum = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_SEQ_OPEN_NUM", new Object[]{}, new int[]{});
	                    						
	                    						result += baSubjectDao.update("BA_SUBJECT.INSERT_TB_BA_SBJCT_OPEN", 
	                    								new Object[]{
	                    									maxOpenNum,yyyy, chasu,
				    	                    				eduSdate, eduEdate, applySdate, applyEdate, cancelDate,
				    	                    				applicant, user.getUserId(), eduDays,
				    	                    				user.getCompanyId(), subjectNum
						    	                    	}, new int []{
		                		                			Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
		                		                			Types.DATE, Types.DATE, Types.DATE, Types.DATE, Types.DATE, 
		                		                			Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
		                		                			Types.NUMERIC, Types.NUMERIC
		                		                	});
	                    						
	                    					}else{
	                    						dupCnt++;
	                    						msg += (i+1)+"줄 해당과정이 동일한 교육기간으로 개설 됨\n";
	                    					}
	                    				}else{
	                    					invalidCnt++;
					                    	msg += (i+1)+"줄 교육시작일, 교육종료일, 신청시작일, 신청종료일, 취소마감일은 'yyyy-mm-dd'형식으로 입력해야함.\n";
	                    				}
	                    			}else{
	                    				invalidCnt++;
				                    	msg += (i+1)+"줄 차수, 모집정원, 교육일수는 숫자로만 입력해야함.\n";
	                    			}
	                    		}else{
	                    			invalidCnt++;
			                    	msg += (i+1)+"줄 개설년도는 4자리 숫자로 입력해야함.\n";
	                    		}
	                    	}else{
	                    		invalidCnt++;
		                    	msg += (i+1)+"줄 존재하지 않는 과정번호\n";
	                    	}
	                    }else{
	                    	reqCnt++;
							msg += (i+1)+"줄 필수값 누락\n";
	                    }
	                    
	                }

					resultVal = "추가 - "+result+"건 \n\n";
					resultVal += "입력값 오류 - "+invalidCnt+"건 \n";
					resultVal += "이미 존재하는 차수 - "+dupCnt+"건 \n";
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
	     }
		return resultVal;
	}
	 
	/**
	 * 과정관리 - 역량매핑 엑셀 저장
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = Exception.class )
	public String upLoadSbjctCmmappingListExcel( User user, HttpServletRequest request){
		String resultVal = "";
		int result = 0;
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;
	     
	    try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("subjectCmmappingUploadFile")[0];
            
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
	                
	                //역량매핑정보 리스트(추가)
	                List<Object[]> iParamList = new ArrayList<Object[]>();
	                //역량매핑정보 리스트(삭제)
	                List<Object[]> dParamList = new ArrayList<Object[]>();
	     			
	                String szValue = "";

					int invalidSCnt = 0;
					int invalidCCnt = 0;
					int invalidCnt = 0;
					int reqCnt = 0;
					int isUseCnt = 0;
					String msg = "";
					
					for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                {
	                    row  = sheet.getRow( i);
	                     
	                    String subjectNum = ""; //과정번호
                        String cmpnumber = ""; //역량코드
                         
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
			                        case 0 : subjectNum = szValue; break;
			                        case 1 : cmpnumber = szValue; break;
		                        }
	                        }
	                    }
	                    
	                    if(!subjectNum.equals("") && !cmpnumber.equals("") ){
	                    	if(CommonUtils.isNumber(subjectNum) && CommonUtils.isNumber(cmpnumber)){
		                    	List scList  = baSubjectDao.queryForList("BA_SUBJECT.SELECT_SUBEJCT_CMPNUMBER", new Object[]{user.getCompanyId(), subjectNum, user.getCompanyId(), cmpnumber}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		                    	if(scList!=null && scList.size()>0){
		                    		Map scMap = (Map)scList.get(0);
		                    		
		                    		int tmpSubjectNum = Integer.parseInt(scMap.get("SUBJECT_NUM").toString());
		                    		int tmpCmpnumber  = Integer.parseInt(scMap.get("CMPNUMBER").toString());
		                    		
		                    		if(tmpSubjectNum > 0 && tmpCmpnumber > 0){
		                    			
		                    			int isCnt =  baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_SUBEJCT_CMPNUMBER_MAPPING_CNT", new Object[]{user.getCompanyId(), subjectNum, cmpnumber}, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
		                    			
		                    			if(isCnt == 0){
		                    				result += baSubjectDao.update("BA_SUBJECT.MERGE_TB_CM_SUBJECT_MAP", 
			                    					new Object[]{ 
				    	                    				user.getCompanyId(), cmpnumber, subjectNum
				    	                    		}, new int []{
					    		                			Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
					    		                	});
		                    			}else{
		                    				isUseCnt++;
		                    				msg += (i+1)+"줄 이미 존재하는 역량매핑\n";
		                    			}
		                    		}else{
		                    			if(tmpSubjectNum==0){
		                    				invalidSCnt++;
			                    			msg += (i+1)+"줄 존재하지 않는 과정번호\n";
		                    			}else{
		                    				invalidCCnt++;
			                    			msg += (i+1)+"줄 존재하지 않는 역량번호\n";
		                    			}
		                    		}
		                    	}else{
		                    		invalidCnt++;
									msg += (i+1)+"줄 과정번호, 역량번호 숫자형 아님\n";
		                    	}
		                    }else{
		                    	invalidCnt++;
								msg += (i+1)+"줄 과정번호, 역량번호 숫자형 아님\n";
		                    }
	                    }else{
	                    	reqCnt++;
							msg += (i+1)+"줄 필수값 누락\n";
	                    }
	                     
	                }
					
					resultVal = "추가 - "+result+"건 \n\n";
					resultVal += "존재하지 않는 과정번호 - "+invalidSCnt+"건 \n";
					resultVal += "존재하지 않는 역량번호 - "+invalidCCnt+"건 \n";
					resultVal += "과정번호, 역량번호 숫자형 아님 - "+invalidCnt+"건 \n";
					resultVal += "이미 존재하는 역량매핑 - "+isUseCnt+"건 \n";
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
	     }
		
		return resultVal;
	}

	/**
	 * 과정관리 - 과정 엑셀 업로드
	*/
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CommonException.class )
	public String upLoadSbjctListExcel( User user, HttpServletRequest request) throws CommonException {
		
		String resultVal = "";
		int result = 0;
		
		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;

		Row row = null;
		Cell cell = null;
	     
	    try {
	    	MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper)request;
	    	 
            File file= multiWrapper.getFiles("subjectUploadFile")[0];
            
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
	                
	                //과정정보 리스트(추가)
	                List<Object[]> iParamList = new ArrayList<Object[]>();
	     			
	                String szValue = "";

					int invalidNumberCnt = 0;
					int invalidJobCnt = 0;
					int reqCnt = 0;
					String msg = "";
					
	                for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                {
	                    row  = sheet.getRow( i);
	                     
	                    String subjectName = ""; //과정명
                        String trainingCd = "";  //학습유형
                        String edu_h = "";  //교육시간_시
                        String edu_m = ""; //교육시간_분
                        String recog_h = "";  //인정시간_시
                        String recog_m = ""; //인정시간_분
                        String eduObject = ""; //목적
                        String eduTarget = ""; //대상
                        String courseContents = ""; //내용
                        String alwStdCd = ""; //상시학습유형
                        String institueCode = ""; //교육기관코드
                        String institueName = ""; //교육기관명
                        String deptDesignationYn = ""; //지정학습
                        //String deptdesignationCd = ""; //지정학습종류
                        String perfAsseSbjCd = ""; //기관성과평가필수교육
                        String officeTimeCd = ""; //교육시간구분코드
                        String eduinsDivCd = ""; //교육기관구분코드
                        String useFlag = "Y"; //과정사용여부
                         
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
		                        case 0 : subjectName = szValue; break;
		                        case 1 : trainingCd = szValue;  break;
		                        case 2 : edu_h = szValue;  break;
		                        case 3 : edu_m = szValue;  break;
		                        case 4 : recog_h = szValue;  break;
		                        case 5 : recog_m = szValue;  break;
		                        case 6 : eduObject = szValue;  break;
		                        case 7 : eduTarget = szValue;  break;
		                        case 8 : courseContents = szValue;  break;
		                        case 9 : alwStdCd = szValue;  break;
		                        case 10 : institueCode = szValue;  break;
		                        case 11 : institueName = szValue;  break;
		                        case 12 : deptDesignationYn = szValue;  break;
		                        //case 13 : deptdesignationCd = szValue;  break;
		                        case 13 : perfAsseSbjCd = szValue;  break;
		                        case 14 : officeTimeCd = szValue;  break;
		                        case 15 : eduinsDivCd = szValue;  break;
		                        //case 16 : useFlag = szValue;  break;
		                        }
	                        }
	                    }
	                    
	                    //학습유형코드
	                    if(trainingCd!=null){
	                    	trainingCd = trainingCd.toUpperCase();
	                    }
	                    //교육시간(시간)
	                    if(edu_h==null || edu_h.equals("")){
	                    	edu_h = "0";
	                    }
	                    //교육시간(분)
	                    if(edu_m==null || edu_m.equals("")){
	                    	edu_m = "0";
	                    }
	                    //인정시간(시간)
	                    if(recog_h==null || recog_h.equals("")){
	                    	recog_h = "0";
	                    }
	                    //인정시간(분)
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
	                    
	                    log.debug("subjectName : " + subjectName);
	                    log.debug("trainingCode : " + trainingCd);
	                    log.debug("bhvIndicator : " + institueName);
	                    log.debug("useFlag : " + useFlag);
	                    
	                    if(!subjectName.equals("") &&  !trainingCd.equals("") && !edu_h.equals("") && !edu_m.equals("") && !recog_h.equals("") && !recog_m.equals("") && !alwStdCd.equals("") && !institueCode.equals("") && !deptDesignationYn.equals("") && !useFlag.equals("")) {
	                    	if(CommonUtils.isNumber(edu_h) && CommonUtils.isNumber(edu_m) && CommonUtils.isNumber(recog_h) && CommonUtils.isNumber(recog_m) ){
	                    		//중복과정 여부
	                    		int isUseCnt =  baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_IS_USE_SUBJECT_CNT", new Object[]{ user.getCompanyId(), subjectName, trainingCd, alwStdCd }, new int[]{ Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR });
	                    		
		                    	if(isUseCnt == 0){
		                    		
		                    		int maxSubjectNum = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_SEQ_SUBJECT_NUM", new Object[]{}, new int[]{});
		                    		
		                    		result += baSubjectDao.update("BA_SUBJECT.INSERT_TB_BA_SBJCT", 
		                    				new Object[]{ 
		    	                    				user.getCompanyId(), maxSubjectNum, subjectName, trainingCd,
		    	                    				edu_h, edu_m, recog_h, recog_m, eduObject, eduTarget,
		    	                					courseContents, alwStdCd, institueCode, institueName, deptDesignationYn,
		    	                					officeTimeCd, eduinsDivCd, useFlag, user.getUserId(),
		    	                					perfAsseSbjCd
		    	                    		}, new int []{
				                			Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
			                				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR,
			                				Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
			                				Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
			                				Types.VARCHAR
				                	});
		                    	}else{
		                    		invalidJobCnt++;
		                    		msg +=  (i+1)+"줄 이미 존재하는 과정임.\n";
		                    	}
	                    	}else{
	                    		invalidNumberCnt++;
								msg += (i+1)+"줄 교육시간, 인정시간 숫자형 아님\n";
	                    	}
	                    	
	                    }else{
	                    	reqCnt++;
							msg += (i+1)+"줄 필수값 누락\n";
	                    }
	                }
	                
					resultVal = "추가 - "+result+"건 \n\n";
					resultVal += "필수값 누락 - "+reqCnt+"건 \n";
					resultVal += "교육시간, 인정시간 숫자형 아님 - "+invalidNumberCnt+"건 \n";
					resultVal += "이미 존재하는 과정 - "+invalidJobCnt+"건 \n\n";
					
					if(msg!=null && msg.length() > 300){
						resultVal += msg.substring(0, 299)+" 등...";
					}else{
						resultVal += msg;
					}
					

	            }
	         }
	     }
	     catch(Throwable e){
	    	 log.error(e);
			throw new CommonException(e); 
	     }
		
		return resultVal;
	}/*
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
	                
	                //과정정보 리스트(추가)
	                List<Object[]> iParamList = new ArrayList<Object[]>();

	                String szValue = "";
	                boolean isChk = true;
	                //int[]  chkParamsType  = { Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR };
	                
	                for( int i = nRowStartIndex; i <= nRowEndIndex ; i++)
	                {
	                	isChk = true;
	                    row  = sheet.getRow( i);
	                     
                        String subjectName = ""; //과정명
                        String trainingCd = "";  //학습유형
                        String edu_h = "";  //교육시간_시
                        String edu_m = ""; //교육시간_분
                        String recog_h = "";  //인정시간_시
                        String recog_m = ""; //인정시간_분
                        String eduObject = ""; //목적
                        String eduTarget = ""; //대상
                        String courseContents = ""; //내용
                        String alwStdCd = ""; //상시학습유형
                        String institueCode = ""; //교육기관코드
                        String institueName = ""; //교육기관명
                        String deptDesignationYn = ""; //지정학습
                        //String deptdesignationCd = ""; //지정학습종류
                        String perfAsseSbjCd = ""; //기관성과평가필수교육
                        String officeTimeCd = ""; //교육시간구분코드
                        String eduinsDivCd = ""; //교육기관구분코드
                        String useFlag = ""; //과정사용여부
                        
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
			                        case 0 : subjectName = szValue; break;
			                        case 1 : trainingCd = szValue;  break;
			                        case 2 : edu_h = szValue;  break;
			                        case 3 : edu_m = szValue;  break;
			                        case 4 : recog_h = szValue;  break;
			                        case 5 : recog_m = szValue;  break;
			                        case 6 : eduObject = szValue;  break;
			                        case 7 : eduTarget = szValue;  break;
			                        case 8 : courseContents = szValue;  break;
			                        case 9 : alwStdCd = szValue;  break;
			                        case 10 : institueCode = szValue;  break;
			                        case 11 : institueName = szValue;  break;
			                        case 12 : deptDesignationYn = szValue;  break;
			                        //case 13 : deptdesignationCd = szValue;  break;
			                        case 13 : perfAsseSbjCd = szValue;  break;
			                        case 14 : officeTimeCd = szValue;  break;
			                        case 15 : eduinsDivCd = szValue;  break;
			                        case 16 : useFlag = szValue;  break;
		                        }
	                        }
	                    }
	                    //학습유형코드
	                    if(trainingCd!=null){
	                    	trainingCd = trainingCd.toUpperCase();
	                    }
	                    //교육시간(시간)
	                    if(edu_h==null || edu_h.equals("")){
	                    	edu_h = "0";
	                    }
	                    //교육시간(분)
	                    if(edu_m==null || edu_m.equals("")){
	                    	edu_m = "0";
	                    }
	                    //인정시간(시간)
	                    if(recog_h==null || recog_h.equals("")){
	                    	recog_h = "0";
	                    }
	                    //인정시간(분)
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
	                    
	                    if(useFlag==null || useFlag.equals("")){
	                    	useFlag = "Y";
	                    }else{
	                    	useFlag = useFlag.toUpperCase();
	                    }
	                    
	                    log.debug("subjectName : " + subjectName);
	                    log.debug("trainingCode : " + trainingCd);
	                    log.debug("bhvIndicator : " + institueName);
	                    log.debug("useFlag : " + useFlag);
	                    

                    	// 중복체크
                    	if(subjectName== null || subjectName.equals("")) {
                    		isChk = false;
                			msg += (i+1)+"줄 과정명 형식이 틀림.\n";
                		}
                    	//필수값 체크
                		if( subjectName.equals("") ||
                			trainingCd.equals("") || 
            				edu_h.equals("") ||
            				edu_m.equals("") || 
            				recog_h.equals("") ||
            				recog_m.equals("") ||
            				alwStdCd.equals("") ||
            				institueCode.equals("") ||
            				deptDesignationYn.equals("") ||
            				//deptdesignationCd.equals("") ||
            				useFlag.equals("")){
                			
                    		isChk = false;
                    		msg += (i+1)+"줄 노란색의 셀은 필수값임.\n";
                    	}
						// 과정명
                    	if(subjectName== null || subjectName.equals("")) {
                    		isChk = false;
                			msg += (i+1)+"줄 과정명 형식이 틀림.\n";
                		}
                    	// 학습유형코드
                    	if(trainingCd== null || trainingCd.equals("")) {
                    		isChk = false;
                    		msg += (i+1)+"줄 학습유형코드 형식이 틀림.\n";
                    	}
                    	// 상시학습유형코드
                    	if(alwStdCd== null || alwStdCd.equals("")) {
                    		isChk = false;
                    		msg += (i+1)+"줄 과정명 형식이 틀림.\n";
                    	}
                    	// 교육기관코드	                    	
                    	if(institueCode== null || institueCode.equals("")) {
                    		isChk = false;
                    		msg += (i+1)+"줄 과정명 형식이 틀림.\n";
                    	}
                    	// 지정학습(Y/N)
                    	if(deptDesignationYn== null || !(deptDesignationYn.equals("Y")||deptDesignationYn.equals("N")) ) {
                    		isChk = false;
                    		msg += (i+1)+"줄 지정학습 형식이 틀림.\n";
                    	}
                    	// 지정학습종류코드
                    	if(deptdesignationCd== null || deptdesignationCd.equals("") ) {
                    		isChk = false;
                    		msg += (i+1)+"줄 지정학습종류코드 형식이 틀림.\n";
                    	}
                    	// 과정사용여부(Y/N)
                    	if(useFlag== null || useFlag.equals("") ) {
                    		isChk = false;
                    		msg += (i+1)+"줄 과정사용여부 형식이 틀림.\n";
                    	}
                    	//교육시간 숫자 체크
                    	if(!CommonUtils.isNumber(edu_h) || !CommonUtils.isNumber(edu_m)){
                    		isChk = false;
                    		msg += (i+1)+"줄 교육시간 형식이 틀림.\n";
                    	}
                    	//인정시간 숫자 체크
                    	if(!CommonUtils.isNumber(recog_h) || !CommonUtils.isNumber(recog_m)){
                    		isChk = false;
                    		msg += (i+1)+"줄 인정시간 형식이 틀림.\n";
                    	}

	                    if(!isChk) {
	                    	invalidCnt++;
	                    } else {
	                    	int  maxSubjNum= baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_SEQ_SUBJECT_NUM", null, null); //과정번호 조회
	                    	iParamList.add(new Object[] {
                					user.getCompanyId(), maxSubjNum, subjectName, trainingCd, edu_h,
                					edu_m, recog_h, recog_m, eduObject, eduTarget,
                					courseContents, alwStdCd, institueCode, institueName, deptDesignationYn,
                					officeTimeCd, eduinsDivCd, useFlag, user.getUserId(),
                					perfAsseSbjCd
                			});
	                    }
					}
	                //과정 등록
	                if(iParamList!=null && iParamList.size()>0){
	                	result = baSubjectDao.batchUpdate("BA_SUBJECT.INSERT_TB_BA_SBJCT", iParamList,
	                			new int[] {
	                				Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
	                				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR,
	                				Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
	                				Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
	                				Types.VARCHAR
	                	});
	                }
				}
	        }
		}catch(Throwable e){
			log.error(e);
			throw new CommonException(e); 
		}
	    
	    resultVal = "추가 - "+result+"건 \n\n";
		resultVal += "유효하지 않은 데이터 - "+invalidCnt+"건 \n";
		//resultVal += "동일한 데이터 - "+sameCnt+"건 \n";
		//resultVal += "필수값 누락 - "+reqCnt+"건 \n\n";
		
		if(msg!=null && msg.length() > 300){
			resultVal += msg.substring(0, 299)+" 등...";
		}else{
			resultVal += msg;
		}
		return resultVal;
	}*/

	/**
	 * 승인하기 - 교육추천승인처리
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveClsRecommReq(HttpServletRequest request, User user) throws BaException{
		int resultCnt = 0;
		try {
			
			int reqNum= CommonUtils.stringToInt(ParamUtils.getParameter(request, "reqNum", "0"), 0);
			String reqStsCd = ParamUtils.getParameter(request, "reqStsCd");
			String lastReqLineSeq = ParamUtils.getParameter(request, "lastReqLineSeq");
			String reqLineSeq = ParamUtils.getParameter(request, "reqLineSeq");
			String reqRemarks = ParamUtils.getParameter(request, "reqRemarks");
			
			//승인요청 라인 처리.
			resultCnt += baSubjectDao.update("BA_SUBJECT.UPDATE_TB_BA_APPR_REQ_LINE", 
					new Object[]{ reqStsCd, reqRemarks, user.getUserId(), user.getCompanyId(), reqNum, reqLineSeq }, 
					new int[]{ Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC }
			);
			
			//상태가 미승인이거나, 마지막 승인자인 경우 추가 처리..
			if(reqStsCd.equals("3") || reqLineSeq.equals(lastReqLineSeq)){
				resultCnt += baSubjectDao.update("BA_SUBJECT.UPDATE_TB_BA_RECOMM_REQ_ADD_DATA", 
						new Object[]{ 
							reqStsCd, user.getUserId(), user.getCompanyId(), reqNum, // TB_BA_APPR_REQ 테이블 param
							reqStsCd, user.getUserId(), user.getCompanyId(), reqNum  //TB_BA_SBJCT_OPEN 테이블 param
						}, 
						new int[]{ 
							Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
							Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
						}
				);
			}
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return resultCnt;
	}
	
	/**
	 * 승인하기 - 교육승인처리
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveClsApplyReq(HttpServletRequest request, User user) throws BaException{
		int resultCnt = 0;
		try {
			
			String eduDiv = ParamUtils.getParameter(request, "EDU_DIV", "S");  // S :정규과정 , A:상시학습
			int openNum = CommonUtils.stringToInt(ParamUtils.getParameter(request, "openNum", "0"), 0);
			int reqNum= CommonUtils.stringToInt(ParamUtils.getParameter(request, "reqNum", "0"), 0);
			long userid = Long.parseLong(ParamUtils.getParameter(request, "userid", "0"));
			String reqStsCd = ParamUtils.getParameter(request, "reqStsCd");
			String lastReqLineSeq = ParamUtils.getParameter(request, "lastReqLineSeq");
			String reqLineSeq = ParamUtils.getParameter(request, "reqLineSeq");
			String reqRemarks = ParamUtils.getParameter(request, "reqRemarks");
			
			//승인요청 라인 처리.
			resultCnt += baSubjectDao.update("BA_SUBJECT.UPDATE_TB_BA_APPR_REQ_LINE", 
					new Object[]{ reqStsCd, reqRemarks, user.getUserId(), user.getCompanyId(), reqNum, reqLineSeq }, 
					new int[]{ Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC }
			);
			
			//상태가 미승인이거나, 마지막 승인자인 경우 추가 처리..
			if(reqStsCd.equals("3") || reqLineSeq.equals(lastReqLineSeq)){
				
				//상시학습의 경우 인정시간을 체크함.
				String recogTimeH = "0";
				String recogTimeM = "0";
				
				if(eduDiv.equals("A")){
					String yyyy = "";
					String alwStdCd = "";
					//현재 등록된 상시학습정보 조회.
					List alwInfo = baSubjectDao.queryForList("BA_SUBJECT.GET_EDU_ALW_INFO", new Object[]{user.getCompanyId(), openNum}, new int[]{Types.NUMERIC, Types.NUMERIC});
					if(alwInfo != null && alwInfo.size()>0){
						Map alwInfoMap =  (Map)alwInfo.get(0);
						
						recogTimeH = alwInfoMap.get("RECOG_TIME_H")+"";
						recogTimeM = alwInfoMap.get("RECOG_TIME_M")+"";
						yyyy = alwInfoMap.get("YYYY")+"";
						alwStdCd = alwInfoMap.get("ALW_STD_CD")+"";
						log.debug("@@@ recogTimeH:"+recogTimeH+", recogTimeM:"+recogTimeM+", yyyy:"+yyyy+", alwStdCd:"+alwStdCd);
					}
					
					//승인인 경우 연간인정시간 체크하여 리턴..
					if(reqStsCd.equals("2")){
						//상시학습종류에 따른 입력 가능한 인정시간 조회.
						List<Map<String,Object>> recogList = emAlwService.yearRecogList(user.getCompanyId(), openNum+"", userid+"", "2", yyyy, recogTimeH, recogTimeM, alwStdCd);
						
				    	if(recogList!=null && recogList.size()>0){
				    		Map alwMap = (Map)recogList.get(0);
				    		
				    		recogTimeH = alwMap.get("ABLE_TIME_H").toString();
				    		recogTimeM = alwMap.get("ABLE_TIME_M").toString();
							log.debug("@@@ recogTimeH:"+recogTimeH+", recogTimeM:"+recogTimeM);
				    	}
					}
					
				}
				
		    	
				resultCnt += baSubjectDao.update("BA_SUBJECT.UPDATE_TB_BA_APPR_REQ_ADD_DATA", 
						new Object[]{ 
							reqStsCd, user.getUserId(), user.getCompanyId(), reqNum, // TB_BA_APPR_REQ 테이블 param
							eduDiv,
							reqStsCd, reqStsCd, reqStsCd, reqRemarks, reqStsCd, user.getUserId(), user.getCompanyId(), openNum, userid, //TB_BA_SBJCT_OPEN_CLASS 테이블 param
							reqStsCd, user.getUserId(), recogTimeH, recogTimeM, user.getCompanyId(), openNum // TB_EM_ALW_STD 테이블 param
						}, 
						new int[]{ 
							Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
							Types.VARCHAR, 
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, // TB_BA_APPR_REQ 테이블 types
							Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
						}
				);
			}
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return resultCnt;
	}
	
	/**
	 * 승인하기 - 수정팝업 - 교육승인처리
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveClsApplyReqPopup(HttpServletRequest request, User user) throws BaException{
		int resultCnt = 0;
		int saveCount = 0;
		
		try {		
			// 상시학습 정보 수정(저장) =====================================================
			//부서원 정보
			//List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
			String eduDiv = ParamUtils.getParameter(request, "EDU_DIV", "S");  // S :정규과정 , A:상시학습
			int openNum = CommonUtils.stringToInt(ParamUtils.getParameter(request, "openNum", "0"), 0);
			int reqNum= CommonUtils.stringToInt(ParamUtils.getParameter(request, "reqNum", "0"), 0);
			String userId = ParamUtils.getParameter(request, "userid", "0");
			String reqStsCd = ParamUtils.getParameter(request, "reqStsCd");
			String lastReqLineSeq = ParamUtils.getParameter(request, "lastReqLineSeq");
			String reqLineSeq = ParamUtils.getParameter(request, "reqLineSeq");
			String reqRemarks = ParamUtils.getParameter(request, "reqRemarks");
			String gradNum = ParamUtils.getParameter(request, "GRADE_NUM");
			String getSco = ParamUtils.getParameter(request, "TT_GET_SCO");
			String divisionId = ParamUtils.getParameter(request, "DIVISIONID");
			String job = ParamUtils.getParameter(request, "JOB");
			String leadership = ParamUtils.getParameter(request, "LEADERSHIP");
			
			int alwStdSeq = CommonUtils.stringToInt(ParamUtils.getParameter(request, "ALW_STD_SEQ", "0"), 0);
			String trainingCode = ParamUtils.getParameter(request, "TRAINING_CODE");
			String subjectName = ParamUtils.getParameter(request, "SUBJECT_NM");
			String recogTimeH = ParamUtils.getParameter(request, "RECOG_TIME_H", "0");
			String recogTimeM = ParamUtils.getParameter(request, "RECOG_TIME_M", "0");
			String eduHour_H = ParamUtils.getParameter(request, "EDU_HOUR_H", "0");
			String eduHour_M = ParamUtils.getParameter(request, "EDU_HOUR_M", "0");
			String eduCont = ParamUtils.getParameter(request, "EDU_CONT");
			String yyyy = ParamUtils.getParameter(request, "YYYY");
			String eduStime = ParamUtils.getParameter(request, "EDU_STIME", "0");
			String eduEtime = ParamUtils.getParameter(request, "EDU_ETIME", "0");
			String alwStdCd = ParamUtils.getParameter(request, "ALW_STD_CD");
			String institueName = ParamUtils.getParameter(request, "INSTITUTE_NAME");
			String institueCode = ParamUtils.getParameter(request, "INSTITUTE_CODE");
			String deptDesignationYn = ParamUtils.getParameter(request, "DEPT_DESIGNATION_YN");
			String deptDesignationCd = ParamUtils.getParameter(request, "DEPT_DESIGNATION_CD");
			String perfAsseSbjCd = ParamUtils.getParameter(request, "PERF_ASSE_SBJ_CD"); 
			String officeTimeCd = ParamUtils.getParameter(request, "OFFICETIME_CD");
			String eduinsDivCd = ParamUtils.getParameter(request, "EDUINS_DIV_CD");
			String requiredYn = ParamUtils.getParameter(request, "REQUIRED_YN"); //임시첨부파일 id
			String objectiD = ParamUtils.getParameter(request, "OBJECTID"); //임시첨부파일 id
			String cmpnumber = ParamUtils.getParameter(request, "CMPNUMBER");
			
			
			String sts_cd="";
			String req_num="" ; //관리자가 등록할경우 결재번호를 넣지 않는다 (관리자가 등록할경우 결재라인을 타지 않고 바로 승인 된다.)
			
			//if(request.isUserInRole("ROLE_SYSTEM")){ //총괄 관리자  승인일경우
			sts_cd = "2";
			//}
			/*if(alwStdSeq == 0 ){
				alwStdSeq = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_SEQ_ALW_NUM", new Object[]{}, new int[]{});
				// 등록일 경우 첨부파일 번호를 수정한다.(램덤으로 넣어진 번호 수정)
				baSubjectDao.update("BA_SUBJECT.UPDATE_V2_ATTACHMENT", new Object[]{ alwStdSeq, 6, objectiD}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});

			}*/
			
			/*String userId = ""; //대상 부서원의 사용자번호
			String divisionId = "";
			String job = "";
			String leadership = "";
			String gradNum = "";
			String getSco = "";
			
			if(list!=null && list.size()>0){
				Map<String, Object> map = (Map<String, Object>)list.get(0);
				
				userId = map.get("USERID")==null?"":map.get("USERID").toString();
				divisionId = map.get("DIVISIONID")==null?"":map.get("DIVISIONID").toString();
				job = map.get("JOB")==null?"":map.get("JOB").toString();
				leadership = map.get("LEADERSHIP")==null?"":map.get("LEADERSHIP").toString();
				gradNum = map.get("GRADE_NUM")==null?"":map.get("GRADE_NUM").toString();
				getSco = map.get("TT_GET_SCO")==null?"0":map.get("TT_GET_SCO").toString();
			}*/
			
			//상시학습종류에 따른 입력 가능한 인정시간 조회. ----------------------------------------------------
			List<Map<String,Object>> recogList = emAlwService.yearRecogList(user.getCompanyId(), alwStdSeq+"", userId, "2", yyyy, recogTimeH, recogTimeM, alwStdCd);
			
	    	if(recogList!=null && recogList.size()>0){
	    		Map<String, Object> alwMap = (Map<String, Object>)recogList.get(0);
	    		
	    		recogTimeH = alwMap.get("ABLE_TIME_H").toString();
	    		recogTimeM = alwMap.get("ABLE_TIME_M").toString();
	    		
	    		log.debug("#####recogTimeH:"+recogTimeH+", recogTimeM:"+recogTimeM);
	    	}
	    	// --------------------------------------------------------------------------------------------------------
	    	
			//상시학습 입력
			saveCount += baSubjectDao.update("BA_SUBJECT.UPDATE_ALW_INFO", 
					new Object[]{
					    alwStdSeq, user.getCompanyId(), trainingCode, subjectName, recogTimeH, 
						recogTimeM, eduStime, eduEtime, eduCont, alwStdCd, 
						institueName, institueCode, deptDesignationYn, deptDesignationCd, officeTimeCd, eduinsDivCd, 
						user.getUserId(), perfAsseSbjCd, yyyy, eduHour_H , eduHour_M, 
						sts_cd, req_num, requiredYn, cmpnumber
					}, 
					new int[]{
						Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
						Types.NUMERIC, Types.DATE, Types.DATE, Types.VARCHAR, Types.VARCHAR,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, 
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR
					}
				);
			
				//부서원 미사용처리 
				//baSubjectDao.update("BA_SUBJECT.UPDATE_ALW_EMP", new Object[]{user.getCompanyId(), alwStdSeq}, new int[]{ Types.NUMERIC, Types.NUMERIC });
				
				if(!userId.equals("")){
					saveCount += baSubjectDao.update("BA_SUBJECT.MERGE_ALW_EMP_MAP",
							new Object[]{user.getCompanyId(), alwStdSeq, userId, divisionId, job, leadership, gradNum,getSco, user.getUserId() },
							new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC });
				}
			

			// 승인처리 =============================================================			
			//승인요청 라인 처리.
			resultCnt += baSubjectDao.update("BA_SUBJECT.UPDATE_TB_BA_APPR_REQ_LINE", 
					new Object[]{ reqStsCd, reqRemarks, user.getUserId(), user.getCompanyId(), reqNum, reqLineSeq }, 
					new int[]{ Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC }
			);
			
			//상태가 미승인이거나, 마지막 승인자인 경우 추가 처리..
			if(reqStsCd.equals("3") || reqLineSeq.equals(lastReqLineSeq)){
				
				//상시학습의 경우 인정시간을 체크함.
				if(eduDiv.equals("A")){
					//String yyyy = "";
					//String alwStdCd = "";
					//현재 등록된 상시학습정보 조회.
					List alwInfo = baSubjectDao.queryForList("BA_SUBJECT.GET_EDU_ALW_INFO", new Object[]{user.getCompanyId(), openNum}, new int[]{Types.NUMERIC, Types.NUMERIC});
					if(alwInfo != null && alwInfo.size()>0){
						Map alwInfoMap =  (Map)alwInfo.get(0);
						
						recogTimeH = alwInfoMap.get("RECOG_TIME_H")+"";
						recogTimeM = alwInfoMap.get("RECOG_TIME_M")+"";
						yyyy = alwInfoMap.get("YYYY")+"";
						alwStdCd = alwInfoMap.get("ALW_STD_CD")+"";
						log.debug("@@@ recogTimeH:"+recogTimeH+", recogTimeM:"+recogTimeM+", yyyy:"+yyyy+", alwStdCd:"+alwStdCd);
					}
					
					//승인인 경우 연간인정시간 체크하여 리턴..
					/*if(reqStsCd.equals("2")){
						//상시학습종류에 따른 입력 가능한 인정시간 조회.
						List<Map<String,Object>> recogList = emAlwService.yearRecogList(user.getCompanyId(), openNum+"", userid+"", "2", yyyy, recogTimeH, recogTimeM, alwStdCd);
						
				    	if(recogList!=null && recogList.size()>0){
				    		Map alwMap = (Map)recogList.get(0);
				    		
				    		recogTimeH = alwMap.get("ABLE_TIME_H").toString();
				    		recogTimeM = alwMap.get("ABLE_TIME_M").toString();
							log.debug("@@@ recogTimeH:"+recogTimeH+", recogTimeM:"+recogTimeM);
				    	}
					}*/
					
				}
				
		    	
				resultCnt += baSubjectDao.update("BA_SUBJECT.UPDATE_TB_BA_APPR_REQ_ADD_DATA", 
						new Object[]{ 
							reqStsCd, user.getUserId(), user.getCompanyId(), reqNum, // TB_BA_APPR_REQ 테이블 param
							eduDiv,
							reqStsCd, reqStsCd, reqStsCd, reqRemarks, reqStsCd, user.getUserId(), user.getCompanyId(), openNum, userId, //TB_BA_SBJCT_OPEN_CLASS 테이블 param
							reqStsCd, user.getUserId(), recogTimeH, recogTimeM, user.getCompanyId(), openNum // TB_EM_ALW_STD 테이블 param
						}, 
						new int[]{ 
							Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
							Types.VARCHAR, 
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, // TB_BA_APPR_REQ 테이블 types
							Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
						}
				);
			}
			
			
			
			
			
			
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return saveCount;
	}
	
	/**
	 * 운영관리 - 수료처리
	 */
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveOpenCmplt(HttpServletRequest request, User user) {
		int resultCnt = 0;
		try {
			//학습자 정보
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item","LIST",List.class);

			int openNum = CommonUtils.stringToInt(ParamUtils.getParameter(request, "openNum", "0"), 0);
			String recogTimeH= ParamUtils.getParameter(request, "RECOG_TIME_H", "0");
			String recogTimeM= ParamUtils.getParameter(request, "RECOG_TIME_M", "0");
			String yyyy= ParamUtils.getParameter(request, "YYYY", "");
			String subjectNum= ParamUtils.getParameter(request, "SUBJECT_NUM", "");
			String alwStdCd= ParamUtils.getParameter(request, "alwStdCd", "");
			
			//수료정보 처리( 수강상태 , 점수 등 ) 
			for(Map<String, Object> map: list){
				String targetUserId = map.get("USERID")==null?"":map.get("USERID").toString();
				String attendStateCode = map.get("ATTEND_STATE_CODE")==null?"0":map.get("ATTEND_STATE_CODE").toString();
				String attendSco = map.get("ATTEND_SCO")==null?"0":map.get("ATTEND_SCO").toString();
				String pracSco = map.get("PRAC_SCO")==null?"0":map.get("PRAC_SCO").toString();
				String annoSco = map.get("ANNO_SCO")==null?"0":map.get("ANNO_SCO").toString();
				String challSco = map.get("CHALL_SCO")==null?"0":map.get("CHALL_SCO").toString();
				String etcSco = map.get("ETC_SCO")==null?"0":map.get("ETC_SCO").toString();
				String discuSco = map.get("DISCU_SCO")==null?"0":map.get("DISCU_SCO").toString();
				String ttGetSco = map.get("TT_GET_SCO")==null?"0":map.get("TT_GET_SCO").toString();
				//신청상태인경우 skip..
				
				String recogH = "0";
				String recogM = "0";
		    	
		    	// --------------------------------------------------------------------------------------------------------
				//|| attendStateCode.equals("6") || attendStateCode.equals("7") || attendStateCode.equals("9") || attendStateCode.equals("10") 
				if(attendStateCode.equals("5")){
					//상시학습종류에 따른 입력 가능한 인정시간 조회. --------------------------------------------------
					List<Map<String,Object>> recogList = emAlwService.yearRecogList(user.getCompanyId(), openNum+"", targetUserId+"", "1", yyyy, recogTimeH, recogTimeM, alwStdCd);
					recogH = recogTimeH;
					recogM = recogTimeM;
			    	if(recogList!=null && recogList.size()>0){
			    		Map<String, Object> alwMap = (Map<String, Object>)recogList.get(0);
			    		
			    		recogH = alwMap.get("ABLE_TIME_H").toString();
			    		recogM = alwMap.get("ABLE_TIME_M").toString();
			    		
			    		log.debug("#####recogTimeH:"+recogTimeH+", recogTimeM:"+recogTimeM);
			    	}
				}

				resultCnt += baSubjectDao.update("BA_SUBJECT.SAVE_EDU_CMPLT",
						new Object[]{
						openNum, attendStateCode, attendSco, pracSco, annoSco, 
						challSco, etcSco, discuSco, ttGetSco, attendStateCode, 
						recogH, attendStateCode, recogM, user.getUserId(), 
						attendStateCode, yyyy, subjectNum, subjectNum, yyyy, 
						targetUserId,
						attendStateCode, attendStateCode, attendStateCode, attendStateCode, attendStateCode
						}, 
					new int[]{ 
						Types.NUMERIC, Types.VARCHAR, Types.DOUBLE, Types.DOUBLE, Types.DOUBLE, 
						Types.DOUBLE, Types.DOUBLE, Types.DOUBLE, Types.DOUBLE, Types.VARCHAR, 
						Types.DOUBLE, Types.VARCHAR, Types.DOUBLE, Types.NUMERIC, 
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
						Types.NUMERIC,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR
				});
				
			}
		} catch(Throwable e) {
			log.error(e);
		}
		return resultCnt;
	}
	
	/**
	 * 차수정보 등록.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveSbjctOpenInfo(HttpServletRequest request, User user) {
		int resultCnt = 0;
		try {
			int subjectNum = CommonUtils.stringToInt(ParamUtils.getParameter(request, "subjectNum"), 0);
			int openNum = CommonUtils.stringToInt(ParamUtils.getParameter(request, "OPEN_NUM"), 0);
			String trainingCode = ParamUtils.getParameter(request, "TRAINING_CODE");
			String subjectName = ParamUtils.getParameter(request, "SUBJECT_NAME");
			String recogTimeH = ParamUtils.getParameter(request, "RECOG_TIME_H");
			String recogTimeM = ParamUtils.getParameter(request, "RECOG_TIME_M");
			String eduTarget = ParamUtils.getParameter(request, "EDU_TARGET");
			String eduObject = ParamUtils.getParameter(request, "EDU_OBJECT");
			String course_cont = ParamUtils.getParameter(request, "COURSE_CONTENTS");
			String alwStdCd = ParamUtils.getParameter(request, "ALW_STD_CD");
			String institueCode = ParamUtils.getParameter(request, "INSTITUTE_CODE");
			String institueName = ParamUtils.getParameter(request, "INSTITUTE_NAME");
			String deptDesignationYn = ParamUtils.getParameter(request, "DEPT_DESIGNATION_YN");
			//String deptDesignationCd = ParamUtils.getParameter(request, "DEPT_DESIGNATION_CD");
			String perfAsseSbjCd = ParamUtils.getParameter(request, "PERF_ASSE_SBJ_CD"); 
			String officeTimeCd = ParamUtils.getParameter(request, "OFFICETIME_CD");
			String eduinsDivCd = ParamUtils.getParameter(request, "EDUINS_DIV_CD");
			
			String yyyy = ParamUtils.getParameter(request, "YYYY");
			String chasu = ParamUtils.getParameter(request, "CHASU");
			String eduStime = ParamUtils.getParameter(request, "EDU_STIME");
			String eduEtime = ParamUtils.getParameter(request, "EDU_ETIME");
			String applyStime = ParamUtils.getParameter(request, "APPLY_STIME");
			String applyEtime = ParamUtils.getParameter(request, "APPLY_ETIME");
			String cancelEtime = ParamUtils.getParameter(request, "CANCEL_ETIME");
			String applicant = ParamUtils.getParameter(request, "APPLICANT");
			String eduDays = ParamUtils.getParameter(request, "EDU_DAYS");
			String objectiD = ParamUtils.getParameter(request, "OBJECTID"); //임시첨부파일 id
			String eduHourH = ParamUtils.getParameter(request, "EDU_HOUR_H");
			String eduHourM = ParamUtils.getParameter(request, "EDU_HOUR_M");
			String evlCmpl = ParamUtils.getParameter(request, "EVL_CMPL");
			
			log.debug("@@@@ openNum:"+openNum);
			
			if(openNum == 0){
				// 개설번호가 없는 경우는 신규 등록일 경우임.
				openNum = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_SEQ_OPEN_NUM", new Object[]{}, new int[]{});
				
				//신규등록인 경우 교육자료의 첨부파일 ID가 임시번호이므로 위에서 조회된 SEQUENCE값으로 업데이트한다..
				baSubjectDao.update("BA_SUBJECT.UPDATE_V2_ATTACHMENT", new Object[]{ openNum, 1, objectiD}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
			}
			
			//차수정보 입력
			resultCnt += baSubjectDao.update("BA_SUBJECT.MERGE_SBJCT_OPEN_INFO", 
					new Object[]{
						user.getCompanyId(), subjectNum, trainingCode, subjectName, recogTimeH, recogTimeM,
						eduTarget, eduObject, course_cont, alwStdCd, institueCode, institueName,
						deptDesignationYn, //deptDesignationCd, 
						officeTimeCd, eduinsDivCd,"Y", user.getUserId(),
						perfAsseSbjCd, openNum, yyyy, chasu, eduStime, eduEtime,
						applyStime, applyEtime, cancelEtime, applicant, eduDays, eduHourH,eduHourM, evlCmpl
					}, 
					new int[]{
						Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.VARCHAR, //Types.VARCHAR, 
						Types.VARCHAR, Types.NUMERIC, Types.VARCHAR,  Types.VARCHAR,
						Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.DATE, Types.DATE,
						Types.DATE, Types.DATE, Types.DATE, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR
					}
			);
		} catch(Throwable e) {
			log.error(e);
		}
		return resultCnt;
	}
	
	/**
	 * 과정정보 등록.
	 */
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveSbjctInfo(HttpServletRequest request, User user) {
		int resultCnt = 0;
		try {
			
			//역량매핑 정보
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
			//수료기준
			List<Map<String, Object>> list2 = ParamUtils.getJsonParameter(request, "item", "LIST2",List.class);
			
			int subjectNum = CommonUtils.stringToInt(ParamUtils.getParameter(request, "subjectNum", "0"), 0);
			String trainingCode = ParamUtils.getParameter(request, "TRAINING_CODE");
			String subjectName = ParamUtils.getParameter(request, "SUBJECT_NAME");
			String eduHourH = ParamUtils.getParameter(request, "EDU_HOUR_H", "0");
			String eduHourM = ParamUtils.getParameter(request, "EDU_HOUR_M", "0");
			String recogTimeH = ParamUtils.getParameter(request, "RECOG_TIME_H", "0");
			String recogTimeM = ParamUtils.getParameter(request, "RECOG_TIME_M", "0");
			String eduTarget = ParamUtils.getParameter(request, "EDU_TARGET");
			String eduObject = ParamUtils.getParameter(request, "EDU_OBJECT");
			String course_cont = ParamUtils.getParameter(request, "COURSE_CONTENTS");
			String alwStdCd = ParamUtils.getParameter(request, "ALW_STD_CD");
			String institueCode = ParamUtils.getParameter(request, "INSTITUTE_CODE");
			String institueName = ParamUtils.getParameter(request, "INSTITUTE_NAME");
			String deptDesignationYn = ParamUtils.getParameter(request, "DEPT_DESIGNATION_YN");
			//String deptDesignationCd = ParamUtils.getParameter(request, "DEPT_DESIGNATION_CD");
			String officeTimeCd = ParamUtils.getParameter(request, "OFFICETIME_CD");
			String eduinsDivCd = ParamUtils.getParameter(request, "EDUINS_DIV_CD");
			String requiredYn = ParamUtils.getParameter(request, "REQUIRED_YN");
			String useFlag = ParamUtils.getParameter(request, "USEFLAG");
			String perfAsseSbjCd = ParamUtils.getParameter(request, "PERF_ASSE_SBJ_CD"); 
			String evlCmpl = ParamUtils.getParameter(request, "EVL_CMPL");
			
			if(subjectNum == 0){
				subjectNum = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_SEQ_SUBJECT_NUM", new Object[]{}, new int[]{});
			}
			
			//과정정보 입력
			resultCnt += baSubjectDao.update("BA_SUBJECT.MERGE_SBJCT_INFO", 
					new Object[]{
						user.getCompanyId(), subjectNum, trainingCode, subjectName, eduHourH,
						eduHourM,	recogTimeH, recogTimeM, eduTarget, eduObject, 
						course_cont, alwStdCd, institueCode, institueName, deptDesignationYn, //deptDesignationCd,
						officeTimeCd, eduinsDivCd, requiredYn, useFlag, user.getUserId(), perfAsseSbjCd, evlCmpl
					}, 
					new int[]{
						Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
						Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, //Types.VARCHAR,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR
					}
			);
			
			//역량매핑정보 전체 사용안함처리.
			baSubjectDao.update("BA_SUBJECT.UPDATE_SBJCT_CM_MAPPING",
											new Object[]{user.getCompanyId(), subjectNum},
											new int []{Types.NUMERIC, Types.NUMERIC}
			);

			//역량매핑정보 머지
			for(Map<String, Object> map: list){
				String checkFlag = map.get("CHECKFLAG")==null?"":map.get("CHECKFLAG").toString();
				String cmpnumber = map.get("CMPNUMBER")==null?"":map.get("CMPNUMBER").toString();
				
				if(checkFlag.equals("checked") && !cmpnumber.equals("")){
					resultCnt += baSubjectDao.update("BA_SUBJECT.MERGE_TB_CM_SUBJECT_MAP", new Object[]{user.getCompanyId(), cmpnumber, subjectNum}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
				}
			}

			//수료기준 정보 전체 사용안함 처리.
			baSubjectDao.update("BA_SUBJECT.UPDATE_TB_EM_CMPLT_STND",
					new Object[]{user.getUserId(), user.getCompanyId(), subjectNum},
					new int []{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC}
			);
			
			//수료기준 정보 merge
			for(Map<String, Object> map: list2){
				String cmpltStndCd = map.get("CODE")==null?"":map.get("CODE").toString();
				String wei = map.get("WEI")==null?"":map.get("WEI").toString();
				
				if(!wei.equals("") && CommonUtils.isNumber(wei)){
					resultCnt += baSubjectDao.update("BA_SUBJECT.MERGE_TB_EM_CMPLT_STND",
							new Object[]{user.getCompanyId(), subjectNum, cmpltStndCd, wei, user.getUserId() },
							new int[]{ Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC }
					);
				}
			}
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return resultCnt;
	}

	/**
	 * 대상확정 승인요청 처리
	 */
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveOpenRecommTarget(HttpServletRequest request, User user) throws BaException {
		int resultCnt = 0;
		try {
			
			//교육대상자 정보
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);

			int openNum = CommonUtils.stringToInt(ParamUtils.getParameter(request, "openNum", "0"), 0);
			
			List<Map<String, Object>> apprLine = ParamUtils.getJsonParameter(request, "apprList",List.class); //승인경로

			log.debug("apprLine.size():"+apprLine.size());
			

			
			
			if(list!=null && list.size()>0){

				//추천순위 처리
				for(Map<String, Object> map: list){
					String targetUserId = map.get("USERID")==null?"":map.get("USERID").toString();
					String recommRanking = map.get("RECOMM_RANKING")==null?"":map.get("RECOMM_RANKING").toString();
					
					resultCnt += baSubjectDao.update("BA_SUBJECT.UPDATE_EDU_TARGET_RECOMM_RANKING_CONFIRM", 
							new Object[]{recommRanking, user.getUserId(), user.getCompanyId(), openNum, targetUserId}, 
							new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
				}

			}
			
			if(resultCnt>0){
				
				if(apprLine!=null && apprLine.size()>0){
					//승인요청번호
					Object reqNum = baSubjectDao.queryForObject("CDP.SELECT_SEQ_REQ_NUM", null, null, String.class);
					log.debug("@@@ reqNum:"+reqNum);
					
					update("CDP.INSERT_TB_BA_APPR_REQ", 
							/* 승인요청구분코드 1-경력개발계획, 2-교육승인요청, 3-상시학습이력승인요청 , 6-교육대상 추천순위 승인요청*/
							new Object[]{ user.getCompanyId(), reqNum, "6" , user.getUserId(), apprLine.size(),  user.getUserId() }, 
							new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC} 
					);
					
					for(Map<String, Object> row: apprLine){
						String apprDivCd = "";
						if(row.get("APPR_DIV_CD")!=null){
							apprDivCd = row.get("APPR_DIV_CD").toString();
						}
						update("CDP.INSERT_TB_BA_APPR_REQ_LINE", 
								new Object[]{ user.getCompanyId(), reqNum, row.get("REQ_LINE_SEQ").toString() , row.get("USERID").toString(), apprDivCd,  user.getUserId() },
								new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC} 
						);
					}

					update("BA_SUBJECT.UPDATE_TB_BA_SBJCT_OPEN_RECOMM_REQ", new Object[]{reqNum, "1", user.getCompanyId(), openNum}, new int[]{ Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC });
				}
			}
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return resultCnt;
	}
	
	/**
	 * 대상확정 저장 처리
	 */
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveOpenTarget(HttpServletRequest request, User user) throws BaException{
		int resultCnt = 0;
		try {
			
			//교육대상자 정보
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);

			int openNum = CommonUtils.stringToInt(ParamUtils.getParameter(request, "openNum", "0"), 0);
			
			//수강상태 변경처리 ( 선정 or 미선정 )
			for(Map<String, Object> map: list){
				String attendStateCode = map.get("ATTEND_STATE_CODE")==null?"":map.get("ATTEND_STATE_CODE").toString();
				String targetUserId = map.get("USERID")==null?"":map.get("USERID").toString();
				String reason = map.get("FAIL_REASON")==null?"":map.get("FAIL_REASON").toString();
				
				//신청상태인경우 skip..
				if(!attendStateCode.equals("1")){
					resultCnt += baSubjectDao.update("BA_SUBJECT.UPDATE_EDU_TARGET_CONFIRM", 
							new Object[]{attendStateCode, attendStateCode, attendStateCode, reason, user.getUserId(), user.getCompanyId(), openNum, targetUserId}, 
							new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC });
				}
			}
			
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return resultCnt;
	}
	
	/**
	 * 교육생 엑셀업로드
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public String saveTargetUserUpload(HttpServletRequest request, User user) throws BaException {
		log.debug("##########saveTargetUserUpload ");
		String resultVal = "";
		int result = 0;
		//int returnval = 0;

		//엑셀 xls, xlsx 처리가능.
		Workbook workbook = null;
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;

		long companyId = user.getCompanyId();
		long userId = user.getUserId();

		try {
			String subjectNum = request.getParameter("subjectNum");
			String openNum = request.getParameter("openNum");
			log.debug("########## openNum:"+openNum);
			
			MultiPartRequestWrapper multiWrapper = (MultiPartRequestWrapper) request;

			File file = multiWrapper.getFiles("upload_file")[0];
			log.debug("########## file:"+file.getName());
			FileInputStream fileInputStrem = new FileInputStream(file);

			//워크북을 특정 모듈(HSSF, XSSF)이 아닌 워크북팩토리로 생성..
			workbook = WorkbookFactory.create(fileInputStrem); 
			
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

					int invalidCnt = 0;
					int alreadyCnt = 0;
					int reqCnt = 0;
					String msg = "";
					
					for (int i = nRowStartIndex; i <= nRowEndIndex; i++) {
						row = sheet.getRow(i);

						String targetUserId = "";
						long _userid = 0;
						
						// 기록물철의 경우 실제 데이터가 끝나는 Column지정
						int nColumnEndIndex = sheet.getRow(i).getLastCellNum();

						for (int nColumn = nColumnStartIndex; nColumn <= nColumnEndIndex; nColumn++) {
							cell = row.getCell((short) nColumn); 
							if (cell != null) {

								if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									szValue = (int) cell.getNumericCellValue() + "";
								} else {
									szValue = cell.getStringCellValue();
								}

		                        //null 제거
		                        szValue = CommonUtils.noNull(szValue);
		                        
								switch (nColumn) {
								case 0:
									targetUserId = szValue;
									break;
								}
							}
						}

						log.debug("############# targetUserId : " + targetUserId);

						if(!targetUserId.equals("")){
	                    	_userid = baSubjectDao.queryForInteger("BA_USER.SELECT_USERID", new Object[]{targetUserId, user.getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
	                    	
	                    	if(_userid > 0){
	                    		//이미 신청정보가 존재하는지 체크
	                    		
	                    		int isAplCnt = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_EDU_TARGET_EXCEL_UPLOAD", new Object[]{user.getCompanyId(), openNum, targetUserId }, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR });
	                    		
	                    		if(isAplCnt==0){
	                    			result += baSubjectDao.update("BA_SUBJECT.INSERT_EDU_TARGET_EXCEL_UPLOAD", 
											new Object[]{subjectNum, openNum, userId, companyId, targetUserId}, 
											new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR});
	                    		}else{
	                    			alreadyCnt++;
			                    	msg += (i+1)+"줄 이미 수강정보 존재\n";
	                    		}
	                    	}else{
	                    		invalidCnt++;
		                    	msg += (i+1)+"줄 존재하지 않는 사용자\n";
	                    	}   	
	                    }else{
	                    	reqCnt++;
							msg += (i+1)+"줄 필수값 누락\n";
						}
					}
					
					resultVal = "추가 - "+result+"건 \n\n";
					resultVal += "존재하지 않는 사용자 - "+invalidCnt+"건 \n";
					resultVal += "이미 수강정보 존재 - "+alreadyCnt+"건 \n";
					resultVal += "필수값 누락 - "+reqCnt+"건 \n\n";
					if(msg!=null && msg.length() > 300){
						resultVal += msg.substring(0, 299)+" 등...";
					}else{
						resultVal += msg;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new BaException(e);
		}
		return resultVal;
	
	}

	/**
	 * 교육기준이수관리 - 직급별 이수시간 저장.
	 */
	@SuppressWarnings("unchecked")
	public int saveGradeRecogTime(HttpServletRequest request, User user){
		int resultCnt = 0;
		try {
			//부처지정학습 코드 조회
			List<Map<String,Object>> deptDesiList = queryForList("CDP.GET_COMMON_CODE", new Object[]{"BA04", user.getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
			
			//직급별 이수시간 조회
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
			
			//직급별 이수시간 초기화 
			update("BA_SUBJECT.INIT_GRADE_CMP_TIME", new Object[]{ user.getCompanyId(), user.getCompanyId() }, new int[]{ Types.NUMERIC, Types.NUMERIC });
			
			List<Object[]> ttParamList = new ArrayList<Object[]>();
			List<Object[]> ddParamList = new ArrayList<Object[]>();
			
			//직급별 이수시간정보 merge
			for(Map<String, Object> map: list){
				//log.debug("#### GRADE_CD:"+map.get("GRADE_CD").toString());
				String gradeCd = map.get("GRADE_CD").toString();
				String ttTimeH = map.get("TT_CMP_TIME_H")==null?"":map.get("TT_CMP_TIME_H").toString();
				String ttTimeM = map.get("TT_CMP_TIME_M")==null?"":map.get("TT_CMP_TIME_M").toString();
				
				ttParamList.add(new Object[]{ user.getCompanyId(), gradeCd, ttTimeH, ttTimeM, user.getUserId() });
				
				//부처지정구분 코드별 이수시간 merge
				for(Map<String, Object> ddMap: deptDesiList){
					String ddCode = ddMap.get("VALUE").toString();
					String ddTimeH = map.get("DD_H"+ddMap.get("VALUE").toString())==null ? "":map.get("DD_H"+ddMap.get("VALUE").toString()).toString();
					String ddTimeM = map.get("DD_M"+ddMap.get("VALUE").toString())==null ? "":map.get("DD_M"+ddMap.get("VALUE").toString()).toString();
					
					ddParamList.add(new Object[]{ user.getCompanyId(), gradeCd, ddCode, ddTimeH, ddTimeM, user.getUserId() });
				}
			}
			
			resultCnt += baSubjectDao.batchUpdate("BA_SUBJECT.MERGE_TB_EM_GRADE_CMP_TIME", ttParamList, new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR } );
			resultCnt += baSubjectDao.batchUpdate("BA_SUBJECT.MERGE_TB_EM_GRADE_DEPT_DESI_TIME", ddParamList, new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR } );
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return resultCnt;
	}

	/**
	 * 교육기준이수관리 - 기관성과평가 필수교육 이수시간 저장.
	 */
	@SuppressWarnings("unchecked")
	public int savePerfAsseRecogTime(HttpServletRequest request, User user){
		int resultCnt = 0;
		try {
			//기관성과평가 필수교육 코드 조회
			List<Map<String,Object>> perfAsseList = queryForList("CDP.GET_COMMON_CODE", new Object[]{"BA11", user.getCompanyId()}, new int[]{Types.VARCHAR, Types.NUMERIC});
			
			//기관성과평가 필수교육 이수시간 조회
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
			
			//직급별 이수시간 초기화 
			update("BA_SUBJECT.INIT_TB_EM_DEPT_PERF_ASSE_TIME", new Object[]{ user.getCompanyId() }, new int[]{ Types.NUMERIC });
			
			List<Object[]> paramList = new ArrayList<Object[]>();
			
			//기관성과평가 필수교육 이수시간정보 merge
			for(Map<String, Object> map: list){
				String deptStndCd = map.get("DEPT_STND_CD").toString();
				
				//부처지정구분 코드별 이수시간 merge
				for(Map<String, Object> paMap: perfAsseList){
					String pdCode = paMap.get("VALUE").toString();
					String pdTimeH = map.get("PD_H"+paMap.get("VALUE").toString())==null ? "":map.get("PD_H"+paMap.get("VALUE").toString()).toString();
					String pdTimeM = map.get("PD_M"+paMap.get("VALUE").toString())==null ? "":map.get("PD_M"+paMap.get("VALUE").toString()).toString();
					
					paramList.add(new Object[]{ user.getCompanyId(), deptStndCd, pdCode, pdTimeH, pdTimeM, user.getUserId() });
				}
			}
			
			resultCnt += baSubjectDao.batchUpdate("BA_SUBJECT.MERGE_TB_EM_DEPT_PERF_ASSE_TIME", paramList, new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR } );
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return resultCnt;
	}

	/**
	 * 교육기준이수관리 - 부서원 기준 이수시간 저장.
	 */
	@SuppressWarnings("unchecked")
	public int saveUserRecogTime(HttpServletRequest request, User user){
		int resultCnt = 0;
		try {
			
			//기준년도 
			String yyyy = ParamUtils.getParameter(request, "YYYY");
			
			//부서원 이수 기준 시간
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
			
			//부처지정학습구분 목록
			List<Map<String,Object>> ddList = queryForList("BA_SUBJECT.SELECT_DEPT_DESIGNATION_CODE_LIST", new Object[] {yyyy}, new int[] { Types.INTEGER });
			//기관성과평가 필수교육 목록
			List<Map<String,Object>> pdList =queryForList("BA_SUBJECT.SELECT_PERF_ASSE_CODE_LIST", new Object[] {yyyy}, new int[] { Types.INTEGER });

			List<Object[]> ttParamList = new ArrayList<Object[]>();
			List<Object[]> ddParamList = new ArrayList<Object[]>();
			List<Object[]> pdParamList = new ArrayList<Object[]>();
			
			//기관성과평가 필수교육 이수시간정보 merge
			for(Map<String, Object> map: list){
				
				String userid = map.get("USERID").toString();
				String ttTime_h = map.get("TT_CMP_TIME_H")==null  ? "" : map.get("TT_CMP_TIME_H").toString(); //총이수시간_시
				String ttTime_m = map.get("TT_CMP_TIME_M")==null ? "" : map.get("TT_CMP_TIME_M").toString(); //총이수시간_분
				
				ttParamList.add(new Object[]{ yyyy, userid, ttTime_h, ttTime_m, user.getUserId() });

				for(Map<String, Object> ddMap: ddList){
					String ddCode = ddMap.get("VALUE").toString(); //부처지정학습구분코드
					String ddTimeH = map.get("DD_H"+ddMap.get("VALUE").toString())==null ? "":map.get("DD_H"+ddMap.get("VALUE").toString()).toString(); //부처지정시간_시
					String ddTimeM = map.get("DD_M"+ddMap.get("VALUE").toString())==null ? "":map.get("DD_M"+ddMap.get("VALUE").toString()).toString(); //부처지정시간_분
					
					ddParamList.add(new Object[]{ yyyy, userid, ddCode, user.getCompanyId(), ddCode, ddTimeH, ddTimeM, user.getUserId() });
				}

				for(Map<String, Object> pdMap: pdList){
					String pdCode = pdMap.get("VALUE").toString(); //기관성과평가 필수교육 코드
					String pdTimeH = map.get("PD_H"+pdMap.get("VALUE").toString())==null ? "":map.get("PD_H"+pdMap.get("VALUE").toString()).toString(); //기관성과평가시간_시
					String pdTimeM = map.get("PD_M"+pdMap.get("VALUE").toString())==null ? "":map.get("PD_M"+pdMap.get("VALUE").toString()).toString(); //기관성과평가시간_분
					
					pdParamList.add(new Object[]{ yyyy, userid, pdCode, user.getCompanyId(), pdCode, pdTimeH, pdTimeM, user.getUserId() });
				}
				
			}

			//총시간 입력.
			resultCnt += baSubjectDao.batchUpdate("BA_SUBJECT.MERGEE_TB_EM_USER_EDU_CMP_TIME", ttParamList, new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR } );
			//부처지정학습구분 이수시간 입력.
			resultCnt += baSubjectDao.batchUpdate("BA_SUBJECT.MERGE_TB_EM_USER_DEPT_DESI_TIME", ddParamList, new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR  } );
			//기관성과평가 필수교육 이수시간 입력
			resultCnt += baSubjectDao.batchUpdate("BA_SUBJECT.MERGE_TB_EM_USER_PERF_ASSE_TIME", pdParamList, new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR  } );
			
		} catch(Throwable e) {
			log.error(e);
		}
		
		return resultCnt;
	}

	/**
	 * 상시학습 관리 정보 등록.
	 */
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveAlwReq(HttpServletRequest request, User user) throws BaException {
		int saveCount = 0;
		
		long companyid = user.getCompanyId();
		long execUserid = user.getUserId();
		
		try {
			
			//부서원 정보
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
			
			int alwStdSeq = CommonUtils.stringToInt(ParamUtils.getParameter(request, "ALW_STD_SEQ", "0"), 0);
			String trainingCode = ParamUtils.getParameter(request, "TRAINING_CODE");
			String subjectName = ParamUtils.getParameter(request, "SUBJECT_NM");
			String recogTimeH = ParamUtils.getParameter(request, "RECOG_TIME_H", "0");
			String recogTimeM = ParamUtils.getParameter(request, "RECOG_TIME_M", "0");
			String eduHour_H = ParamUtils.getParameter(request, "EDU_HOUR_H");
			String eduHour_M = ParamUtils.getParameter(request, "EDU_HOUR_M");
			String eduCont = ParamUtils.getParameter(request, "EDU_CONT");
			String yyyy = ParamUtils.getParameter(request, "YYYY");
			String eduStime = ParamUtils.getParameter(request, "EDU_STIME", "0");
			String eduEtime = ParamUtils.getParameter(request, "EDU_ETIME", "0");
			
			String alwStdCd = ParamUtils.getParameter(request, "ALW_STD_CD");
			String instituteName = ParamUtils.getParameter(request, "INSTITUTE_NAME");
			String instituteCode = ParamUtils.getParameter(request, "INSTITUTE_CODE");
			String deptDesignationYn = ParamUtils.getParameter(request, "DEPT_DESIGNATION_YN");
			String deptDesignationCd = ParamUtils.getParameter(request, "DEPT_DESIGNATION_CD");
			String perfAsseSbjCd = ParamUtils.getParameter(request, "PERF_ASSE_SBJ_CD"); 
			String officeTimeCd = ParamUtils.getParameter(request, "OFFICETIME_CD");
			String eduinsDivCd = ParamUtils.getParameter(request, "EDUINS_DIV_CD");
			//String getSco = ParamUtils.getParameter(request, "TT_GET_SCO"); 
			String objectiD = ParamUtils.getParameter(request, "OBJECTID"); //임시첨부파일 id
			String requiredYn = ParamUtils.getParameter(request, "REQUIRED_YN"); 
			

			String div_cd="3"; //상시학습 공통 코드
			
			int reqNum = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_SEQ_REQ_NUM", new Object[]{}, new int[]{});
			
			List<Map<String, Object>> apprLine = ParamUtils.getJsonParameter(request, "item", "APPR_LINE",List.class); //승인경로
			
			saveCount += update("BA_SUBJECT.INSERT_TB_BA_APPR_REQ", 
					new Object[]{ companyid, reqNum, div_cd , execUserid, apprLine.size(),  execUserid }, new int[]{Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC} 
			);
			
			for(Map<String, Object> row: apprLine){
				String apprDivCd = "";
				String req_std = "1"; //승인대기상태
				if(row.get("APPR_DIV_CD")!=null){
					apprDivCd = row.get("APPR_DIV_CD").toString();
				}
				saveCount += update("BA_SUBJECT.INSERT_TB_BA_APPR_REQ_LINE", 
						new Object[]{ companyid, reqNum, row.get("REQ_LINE_SEQ").toString() , row.get("USERID").toString(), apprDivCd, req_std ,  execUserid }, new int[]{Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR,Types.VARCHAR, Types.NUMERIC} 
				);
			}
			
			String sts_cd="";
			
			//부서장일 경우 바로 승인 되도록
			if(request.isUserInRole("ROLE_SYSTEM")){ //총괄 관리자  승인일경우
				sts_cd = "2";
			}else{ //일반사용자의 승인 요청
				sts_cd = "1";
			}
			//상시학습 시퀀스
			alwStdSeq = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_SEQ_ALW_NUM", new Object[]{}, new int[]{});
			// 등록일 경우 첨부파일 번호를 수정한다.(램덤으로 넣어진 번호 수정)
			baSubjectDao.update("BA_SUBJECT.UPDATE_V2_ATTACHMENT", new Object[]{ alwStdSeq, 6, objectiD}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});

			//상시학습 입력
			saveCount += baSubjectDao.update("BA_SUBJECT.MERGE_ALW_INFO", 
					new Object[]{
						user.getCompanyId(), alwStdSeq, trainingCode, subjectName, recogTimeH, 
						recogTimeM, eduStime, eduEtime, eduCont, alwStdCd, 
						instituteName, instituteCode, deptDesignationYn, deptDesignationCd, officeTimeCd, eduinsDivCd, 
						user.getUserId(), perfAsseSbjCd, yyyy, reqNum, sts_cd,
						eduHour_H , eduHour_M ,requiredYn
					}, 
					new int[]{
						Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
						Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.VARCHAR,
						Types.NUMERIC, Types.NUMERIC, Types.VARCHAR
					}
			);
			
			//부서원 정보 저장
			for(Map<String, Object> map: list){
				String userId = map.get("USERID")==null?"":map.get("USERID").toString();
				String divisionId = map.get("DIVISIONID")==null?"":map.get("DIVISIONID").toString();
				String job = map.get("JOB")==null?"":map.get("JOB").toString();
				String leadership = map.get("LEADERSHIP")==null?"":map.get("LEADERSHIP").toString();
				String gradNum = map.get("GRADE_NUM")==null?"":map.get("GRADE_NUM").toString();
				String getSco = map.get("TT_GET_SCO")==null?"":map.get("TT_GET_SCO").toString();
				
				if(userId !=null){
					saveCount += baSubjectDao.update("BA_SUBJECT.MERGE_ALW_EMP_MAP",
							new Object[]{user.getCompanyId(), alwStdSeq, userId, divisionId, job, leadership, gradNum,getSco, user.getUserId() },
							new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC });
				}
			}

		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return saveCount;
	}
		
	/**
	 * 상시학습 관리 데이터상태 코드 변경.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveAlwDataSts(HttpServletRequest request, User user) {
		int saveCount = 0;
		
		long companyid = user.getCompanyId();
		
		String year = ParamUtils.getParameter(request, "YYYY");
		
		try {
			saveCount += update("BA_SUBJECT.UPDATE_TB_ALW_CLASS_DATA_STS", 
			new Object[]{companyid,year }, new int[]{Types.NUMERIC , Types.VARCHAR}); 

		} catch(Throwable e) {
			log.error(e);
		}
		
		return saveCount;
	}
	
	/**
	 * 상시학습 관리 정보 수정 저장.
	 * @throws BaException 
	 */
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int saveAlwInfo(HttpServletRequest request, User user) throws BaException{
		int saveCount = 0;
		
		try {
			
			//부서원 정보
			List<Map<String, Object>> list = ParamUtils.getJsonParameter(request, "item", "LIST",List.class);
			
			int alwStdSeq = CommonUtils.stringToInt(ParamUtils.getParameter(request, "ALW_STD_SEQ", "0"), 0);
			String trainingCode = ParamUtils.getParameter(request, "TRAINING_CODE");
			String subjectName = ParamUtils.getParameter(request, "SUBJECT_NM");
			String recogTimeH = ParamUtils.getParameter(request, "RECOG_TIME_H", "0");
			String recogTimeM = ParamUtils.getParameter(request, "RECOG_TIME_M", "0");
			String eduHour_H = ParamUtils.getParameter(request, "EDU_HOUR_H", "0");
			String eduHour_M = ParamUtils.getParameter(request, "EDU_HOUR_M", "0");
			String eduCont = ParamUtils.getParameter(request, "EDU_CONT");
			String yyyy = ParamUtils.getParameter(request, "YYYY");
			String eduStime = ParamUtils.getParameter(request, "EDU_STIME", "0");
			String eduEtime = ParamUtils.getParameter(request, "EDU_ETIME", "0");
			String alwStdCd = ParamUtils.getParameter(request, "ALW_STD_CD");
			String institueName = ParamUtils.getParameter(request, "INSTITUTE_NAME");
			String institueCode = ParamUtils.getParameter(request, "INSTITUTE_CODE");
			String deptDesignationYn = ParamUtils.getParameter(request, "DEPT_DESIGNATION_YN");
			String deptDesignationCd = ParamUtils.getParameter(request, "DEPT_DESIGNATION_CD");
			String perfAsseSbjCd = ParamUtils.getParameter(request, "PERF_ASSE_SBJ_CD"); 
			String officeTimeCd = ParamUtils.getParameter(request, "OFFICETIME_CD");
			String eduinsDivCd = ParamUtils.getParameter(request, "EDUINS_DIV_CD");
			String requiredYn = ParamUtils.getParameter(request, "REQUIRED_YN"); //임시첨부파일 id
			String objectiD = ParamUtils.getParameter(request, "OBJECTID"); //임시첨부파일 id
			String cmpnumber = ParamUtils.getParameter(request, "CMPNUMBER");
			
			String sts_cd="";
			String req_num="" ; //관리자가 등록할경우 결재번호를 넣지 않는다 (관리자가 등록할경우 결재라인을 타지 않고 바로 승인 된다.)
			
			if(request.isUserInRole("ROLE_SYSTEM")){ //총괄 관리자  승인일경우
				sts_cd = "2";
			}
			if(alwStdSeq == 0 ){
				alwStdSeq = baSubjectDao.queryForInteger("BA_SUBJECT.SELECT_SEQ_ALW_NUM", new Object[]{}, new int[]{});
				// 등록일 경우 첨부파일 번호를 수정한다.(램덤으로 넣어진 번호 수정)
				baSubjectDao.update("BA_SUBJECT.UPDATE_V2_ATTACHMENT", new Object[]{ alwStdSeq, 6, objectiD}, new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});

			}
			
			String userId = ""; //대상 부서원의 사용자번호
			String divisionId = "";
			String job = "";
			String leadership = "";
			String gradNum = "";
			String getSco = "";
			
			if(list!=null && list.size()>0){
				Map<String, Object> map = (Map<String, Object>)list.get(0);
				
				userId = map.get("USERID")==null?"":map.get("USERID").toString();
				divisionId = map.get("DIVISIONID")==null?"":map.get("DIVISIONID").toString();
				job = map.get("JOB")==null?"":map.get("JOB").toString();
				leadership = map.get("LEADERSHIP")==null?"":map.get("LEADERSHIP").toString();
				gradNum = map.get("GRADE_NUM")==null?"":map.get("GRADE_NUM").toString();
				getSco = map.get("TT_GET_SCO")==null?"0":map.get("TT_GET_SCO").toString();
			}
			
			
			//상시학습종류에 따른 입력 가능한 인정시간 조회. ----------------------------------------------------
			List<Map<String,Object>> recogList = emAlwService.yearRecogList(user.getCompanyId(), alwStdSeq+"", userId, "2", yyyy, recogTimeH, recogTimeM, alwStdCd);
			
	    	if(recogList!=null && recogList.size()>0){
	    		Map<String, Object> alwMap = (Map<String, Object>)recogList.get(0);
	    		
	    		recogTimeH = alwMap.get("ABLE_TIME_H").toString();
	    		recogTimeM = alwMap.get("ABLE_TIME_M").toString();
	    		
	    		log.debug("#####recogTimeH:"+recogTimeH+", recogTimeM:"+recogTimeM);
	    	}
	    	// --------------------------------------------------------------------------------------------------------
	    	
			//상시학습 입력
			saveCount += baSubjectDao.update("BA_SUBJECT.UPDATE_ALW_INFO", 
					new Object[]{
					    alwStdSeq, user.getCompanyId(), trainingCode, subjectName, recogTimeH, 
						recogTimeM, eduStime, eduEtime, eduCont, alwStdCd, 
						institueName, institueCode, deptDesignationYn, deptDesignationCd, officeTimeCd, eduinsDivCd, 
						user.getUserId(), perfAsseSbjCd, yyyy, eduHour_H , eduHour_M, 
						sts_cd, req_num, requiredYn, cmpnumber
					}, 
					new int[]{
						Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
						Types.NUMERIC, Types.DATE, Types.DATE, Types.VARCHAR, Types.VARCHAR,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
						Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, 
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR
					}
				);
			
				//부서원 미사용처리 
				baSubjectDao.update("BA_SUBJECT.UPDATE_ALW_EMP", new Object[]{user.getCompanyId(), alwStdSeq}, new int[]{ Types.NUMERIC, Types.NUMERIC });
				if(!userId.equals("")){
					saveCount += baSubjectDao.update("BA_SUBJECT.MERGE_ALW_EMP_MAP",
							new Object[]{user.getCompanyId(), alwStdSeq, userId, divisionId, job, leadership, gradNum,getSco, user.getUserId() },
							new int[]{ Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC });
				}
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return saveCount;
	}
	
	/**
	 * 상시학습 인정직급 수정 저장.
	 * @throws BaException 
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int updateGradeInfo(HttpServletRequest request, User user) throws BaException{
		int saveCount = 0;
		
		try {		

			int alwStdSeq = CommonUtils.stringToInt(ParamUtils.getParameter(request, "ALW_STD_SEQ", "0"), 0);
			String gradNum = ParamUtils.getParameter(request, "GRADE_NUM");		

			//인정직급 수정 
			saveCount += baSubjectDao.update("BA_SUBJECT.UPDATE_ALW_GRADENUM", new Object[]{gradNum, user.getCompanyId(), alwStdSeq}, new int[]{ Types.VARCHAR, Types.NUMERIC, Types.NUMERIC });
				
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return saveCount;
	}
	
	/**
	 * 상시학습 관리 정보 요청 취소처리
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int cencleAlwReq(HttpServletRequest request, User user) throws BaException {
		int saveCount = 0;
		
		long companyid = user.getCompanyId();
		//long execUserid = user.getUserId();
		try {
			int alwStdSeq = CommonUtils.stringToInt(ParamUtils.getParameter(request, "alwSeq", "0"), 0);
			int reqNum = CommonUtils.stringToInt(ParamUtils.getParameter(request, "reqNum", "0"), 0);
			
			if(alwStdSeq != 0 ){
				//상시학습 요청취소
				saveCount += baSubjectDao.update("BA_SUBJECT.UPDATE_CENCLE_ALW", 
						new Object[]{
							companyid, alwStdSeq
						}, 
						new int[]{
							Types.NUMERIC, Types.NUMERIC
						}
				);
				saveCount += baSubjectDao.update("BA_SUBJECT.UPDATE_CENCLE_APP_REQ", 
						new Object[]{
							companyid, reqNum
						}, 
						new int[]{
							Types.NUMERIC, Types.NUMERIC
						}
				);
			}
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return saveCount;
	}
	
	/**
	 * 상시학습 관리 정보 삭제.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int deleteAlwReq(HttpServletRequest request, User user) throws BaException{
		int saveCount = 0;
 
		long companyid = user.getCompanyId();
		try {
			int alwStdSeq = CommonUtils.stringToInt(ParamUtils.getParameter(request, "alwSeq", "0"), 0);
			if(alwStdSeq != 0 ){
				//상시학습 요청취소
				saveCount += baSubjectDao.update("BA_SUBJECT.UPDATE_DELETE_ALW", 
						new Object[]{
							companyid, alwStdSeq
						}, 
						new int[]{
							Types.NUMERIC, Types.NUMERIC
						}
				);
			}
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e); 
		}
		
		return saveCount;
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
			divisionStr = " AND "+tableAlias+" IN ( SELECT DIVISIONID FROM TB_BA_DIVISION WHERE COMPANYID = "+companyid+" AND DEL_YN = 'N' and USEFLAG = 'Y' START WITH DIVISIONID IN (SELECT DIVISIONID FROM TB_BA_DIVISION_EDU_MGR WHERE COMPANYID = "+companyid+" AND USERID = "+userid+" AND USEFLAG = 'Y' ) CONNECT BY PRIOR DIVISIONID = HIGH_DVSID ) ";
			
			log.debug("### ROLE_OPERATOR");
		}else{ //부서장
			//소속부서(하위 포함)의 사용자
			divisionStr = " AND "+tableAlias+" IN ( SELECT DIVISIONID FROM TB_BA_DIVISION WHERE COMPANYID = "+companyid+" AND DEL_YN = 'N' and USEFLAG = 'Y' START WITH DIVISIONID IN (SELECT DIVISIONID FROM TB_BA_DIVISION WHERE COMPANYID = "+companyid+" AND DVS_MANAGER = "+userid+") CONNECT BY PRIOR DIVISIONID = HIGH_DVSID ) ";
			
			log.debug("### ROLE_MANAGER");
		}
		return divisionStr;
	}
	

	/**
	 * 이사람 연동 용 엑셀다운로드 후 해당 이력의 데이터 상태 변경
	 * @param companyid
	 * @param items
	 * @throws BaException
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public void updateSyncEduState(long companyid, List<Map<String,Object>> items) throws BaException {
		log.debug("## baSubjectSrv updateSyncEduState start.......");
		
		if(items!=null && items.size()>0) {
			
			log.debug("## baSubjectSrv updateSyncEduState list size :: " + items.size());
			
			List<Object[]> eduBatchList = new ArrayList<Object[]>();
			List<Object[]> alwBatchList = new ArrayList<Object[]>();
			
			for(Map<String,Object> item : items) {
				// 기 다운로드 이력이 아닐 경우
				if(item.get("COL01")!=null && !( item.get("DATA_STS_CD")!=null && (item.get("DATA_STS_CD").toString()).equals("C") )
				) {
					if( (item.get("COL01").toString()).equals("EDU")) {
						// 일반교육
						eduBatchList.add(new Object[] {
							companyid, item.get("OPEN_NUM"), item.get("USERID")
						});
					} else if( (item.get("COL01").toString()).equals("ALW")) {
						// 상시학습
						alwBatchList.add(new Object[] {
							companyid, item.get("OPEN_NUM")
						});
					}
				}
			}
			
			log.debug("## baSubjectSrv updateSyncEduState eduBatchList size :: " + eduBatchList.size());
			log.debug("## baSubjectSrv updateSyncEduState alwBatchList size :: " + alwBatchList.size());
			
			// 교육이력 상태변경
			if(eduBatchList!=null && eduBatchList.size()>0) {
				baSubjectDao.batchUpdate("BA_SUBJECT.UPDATE_EDU_DOWN_STATE", eduBatchList, new int[] {Types.NUMERIC, Types.NUMERIC, Types.NUMERIC});
			}
			// 상시학습이력 상태변경
			if(alwBatchList!=null && alwBatchList.size()>0) {
				baSubjectDao.batchUpdate("BA_SUBJECT.UPDATE_ALW_DOWN_STATE", alwBatchList, new int[] {Types.NUMERIC, Types.NUMERIC});
			}
		}
		
		log.debug("## baSubjectSrv updateSyncEduState end.......");
	}
	

	/**
	 * 운영관리 - 인정시간 재계산
	 * @throws BaException 
	 */
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public int changeUserRecogTime(HttpServletRequest request, User user) throws BaException{
		int saveCount = 0;
		
		try {
			
			int openNum = CommonUtils.stringToInt(ParamUtils.getParameter(request, "OPEN_NUM", "0"), 0);
			String tUserid = ParamUtils.getParameter(request, "tUserid", "0");
			String recogTimeH = ParamUtils.getParameter(request, "RECOG_TIME_H", "0");
			String recogTimeM = ParamUtils.getParameter(request, "RECOG_TIME_M", "0");
			String yyyy = ParamUtils.getParameter(request, "YYYY");
			String alwStdCd = ParamUtils.getParameter(request, "ALW_STD_CD");
			
			
			//상시학습종류에 따른 입력 가능한 인정시간 조회. ----------------------------------------------------
			List<Map<String,Object>> recogList = emAlwService.yearRecogList(user.getCompanyId(), openNum+"", tUserid, "1", yyyy, recogTimeH, recogTimeM, alwStdCd);
			
	    	if(recogList!=null && recogList.size()>0){
	    		Map<String, Object> alwMap = (Map<String, Object>)recogList.get(0);
	    		
	    		recogTimeH = alwMap.get("ABLE_TIME_H").toString();
	    		recogTimeM = alwMap.get("ABLE_TIME_M").toString();
	    		
	    		log.debug("#####recogTimeH:"+recogTimeH+", recogTimeM:"+recogTimeM);
	    	}
	    	// --------------------------------------------------------------------------------------------------------
	    	
			//인정시간 입력
			saveCount += baSubjectDao.update("BA_SUBJECT.UPDATE_CLASS_RECOG_TIME", 
					new Object[]{
					    recogTimeH, recogTimeM, user.getCompanyId(), openNum,  tUserid
					}, 
					new int[]{
						Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
					}
				);
			
		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		
		return saveCount;
	}
}
