package kr.podosoft.ws.service.ba.impl;

import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.BaSyncService;
import kr.podosoft.ws.service.ba.dao.BaSyncDao;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
//import pjt.dainlms.aria.CipherAria;

public class BaSyncServiceImpl implements BaSyncService {
	
	private Log log = LogFactory.getLog(getClass());
	
	private BaSyncDao baSyncDao;
	
	private PasswordEncoder passwordEncoder;
	
	public PasswordEncoder getPasswordEncoder() {
		return passwordEncoder;
	}
	
	public void setPasswordEncoder(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}

	public BaSyncDao getBaSyncDao() {
		return baSyncDao;
	}

	public void setBaSyncDao(BaSyncDao baSyncDao) {
		this.baSyncDao = baSyncDao;
	}

	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		return baSyncDao.queryForInteger(statement, params, jdbcTypes);
	}

	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		return baSyncDao.queryForList(statement, params, jdbcTypes);
	}

	public List<Map<String, Object>> queryForList(String statement, int startIndex, int maxResults, Object[] params, int[] jdbcTypes) throws BaException {
		return baSyncDao.queryForList(statement, startIndex, maxResults, params, jdbcTypes);
	}

	public int update(String statement, Object[] params, int[] jdbcTypes) throws BaException {
		return baSyncDao.update(statement, params, jdbcTypes);
	}

	public Object batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws BaException {
		return baSyncDao.batchUpdate(statement, parameteres, jdbcTypes);
	}


	/**
	 * 공통 > 동기화관리
	 * @param companyId
	 * @param userId
	 * @param syncCode
	 * @return
	 * @throws BaException
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public Map<String,String> runSync(long companyId, long userId, String syncCode) throws BaException {
		
		Map<String,String> result = new HashMap<String, String>();
		String statement = "";
		StringBuffer msg = new StringBuffer();
		
		msg.append("-동기화 실행-\n");
		
		try {
	
			if(syncCode.equals("1")){
				// 부서동기화
				Map<String,String> deptMap = syncDeptInfo(companyId, userId, "N");
				msg.append(deptMap.get("msg"));
				statement = deptMap.get("statement");

			}else if(syncCode.equals("2")){
				// 직급동기화
				
				Map<String,String>  gradeMap = syncGradeInfo(companyId, userId, "N");
				msg.append(gradeMap.get("msg"));
				statement = gradeMap.get("statement");
				
			}else if(syncCode.equals("3")){
				// 사용자동기화
				
				Map<String,String>  userMap = syncUserInfo(companyId, userId, "N");
				msg.append(userMap.get("msg"));
				statement = userMap.get("statement");

			}
			
			
		} catch(Throwable e) {
			log.error(e);
			
			statement = "N";
			msg.append(e.toString());
			
			throw new BaException(e);
		} finally {
			result.put("statement", statement);
			result.put("msg", msg.toString());
		}
		
		return result;
	}
	

	/**
	 * 부서정보 동기화
	 * @param userid
	 * @return
	 * @throws BaException
	 */
	private Map<String,String> syncDeptInfo(long companyid, long userid, String autoFlag) throws BaException {
		Map<String,String> result = new HashMap<String, String>();
		StringBuffer resultSb = new StringBuffer();
		String statement = "N";
		int ttlCnt = 0;
		int addSccssCnt = 0;
		int modSccssCnt = 0;
		
		try {
			
			// 보훈나라로부터 부서정보 조회
			List<Map<String,Object>> list = baSyncDao.queryForList("BA_SYNC.SELECT_DIVISIONLIST", null, null);
			ttlCnt = list.size();
			
			List<Object[]> iParamList = new ArrayList<Object[]>();
			List<Object[]> uParamList = new ArrayList<Object[]>();
			
			if(!list.isEmpty()) {
				// 부서정보 전부 미사용처리
				baSyncDao.update("BA_SYNC.UPDATE_N_DIVISION", new Object[] {companyid}, new int[] {Types.INTEGER});
				
				int chk = 0;
				
				for(Map<String,Object> item : list) {
					String divisionid = "";
					String dvsName = "";
					String highDvsid = "";
					String fullName = "";
					String dvsManager = "";
					
					if(item.get("DIVISIONID")!=null) divisionid = item.get("DIVISIONID").toString();
					if(item.get("DVS_NAME")!=null) dvsName = item.get("DVS_NAME").toString();
					if(item.get("HIGH_DVSID")!=null) highDvsid = item.get("HIGH_DVSID").toString();
					if(item.get("DVS_FULLNAME")!=null) fullName = item.get("DVS_FULLNAME").toString();
					if(item.get("DVS_MANAGER")!=null) dvsManager = item.get("DVS_MANAGER").toString();
				
					//등록/변경 유무 판별
					chk = baSyncDao.queryForInteger("BA_SYNC.SELECT_DIVISION_COUNT",  new Object[] { companyid, divisionid },  new int[] { Types.NUMERIC, Types.VARCHAR});
					
					// 등록
					if(chk==0) {
						iParamList.add(new Object[]{ companyid, divisionid, dvsName, fullName, highDvsid, userid, dvsManager });
					}else {// 수정
						uParamList.add(new Object[]{ dvsName, fullName, highDvsid, userid, dvsManager, companyid, divisionid });
					}
				}
				
				if(iParamList!=null && iParamList.size()>0)
					addSccssCnt = baSyncDao.batchUpdate("BA_SYNC.INSERT_DIVISION_INFO", iParamList, new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR } );
				

				if(uParamList!=null && uParamList.size()>0)
					modSccssCnt = baSyncDao.batchUpdate("BA_SYNC.UPDATE_DIVISION_INFO", uParamList, new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR } );

				//부서장 권한 부여
				baSyncDao.update("BA_SYNC.INSERT_MANAGER_GROUP_ROLE", null, null);
				
				resultSb.append("연동 부서 수 : ").append(ttlCnt).append("건, ");
				resultSb.append("신규 부서 수 : ").append(addSccssCnt).append("건, ");
				resultSb.append("변경 부서 수 : ").append(modSccssCnt).append("건 ");
				
				statement = "Y";
				
			}else{
				resultSb.append("연동대상으로부터 부서정보를 조회하지 못했습니다.");
			}

			
			result.put("statement", statement);
			result.put("msg", resultSb.toString());
			
		} catch(Throwable e) {
			log.debug(e);
			
			statement = "N";
			resultSb.append(e);

			result.put("statement", statement);
			result.put("msg", resultSb.toString());
			
		}finally {
			baSyncDao.update("BA_SYNC.INSERT_SYNC_INFO", 
					new Object[] {companyid, "1" , companyid, "1", autoFlag, statement, resultSb.toString(), userid}, 
					new int[] {Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.INTEGER}
			);
		}
		return result;
	}
	
	/**
	 * 직급정보 동기화
	 * @param userid
	 * @return
	 * @throws BaException
	 */
	private Map<String,String> syncGradeInfo(long companyid, long userid, String autoFlag) throws BaException {
		Map<String,String> result = new HashMap<String, String>();
		StringBuffer resultSb = new StringBuffer();
		String statement = "N";
		int ttlCnt = 0;
		int addSccssCnt = 0;
		int modSccssCnt = 0;
		
		try {
			
			//직급정보 조회
			List<Map<String,Object>> list = baSyncDao.queryForList("BA_SYNC.SELECT_GRADELIST", null, null);
			ttlCnt = list.size();
			
			List<Object[]> iParamList = new ArrayList<Object[]>();
			List<Object[]> uParamList = new ArrayList<Object[]>();
			
			if(!list.isEmpty()) {
				// 직급정보 전부 미사용처리
				baSyncDao.update("BA_SYNC.UPDATE_N_GRADE", new Object[] {companyid}, new int[] {Types.INTEGER});
				
				int chk = 0;
				
				for(Map<String,Object> item : list) {
					String gradeNum= "";
					String gradeNm = "";
					String cdValue1 = "";
					
					if(item.get("GRADE_CODE")!=null) gradeNum = item.get("GRADE_CODE").toString();
					if(item.get("GRADE_NAME")!=null) gradeNm = item.get("GRADE_NAME").toString();
					if(item.get("CD_VALUE1")!=null) cdValue1 = item.get("CD_VALUE1").toString();
				
					//등록/변경 유무 판별
					chk = baSyncDao.queryForInteger("BA_SYNC.SELECT_GRADE_COUNT",  new Object[] { companyid, gradeNum },  new int[] { Types.NUMERIC, Types.VARCHAR});
					
					// 등록
					if(chk==0) {
						iParamList.add(new Object[]{ companyid, "BA15", gradeNum, gradeNm, userid, cdValue1 });
					}else {// 수정
						uParamList.add(new Object[]{ gradeNm, userid, cdValue1, companyid, "BA15", gradeNum });
					}
				}
				
				if(iParamList!=null && iParamList.size()>0)
					addSccssCnt = baSyncDao.batchUpdate("BA_SYNC.INSERT_GRADE_INFO", iParamList, new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR  } );
				
				if(uParamList!=null && uParamList.size()>0)
					modSccssCnt = baSyncDao.batchUpdate("BA_SYNC.UPDATE_GRADE_INFO", uParamList, new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR } );
				

				resultSb.append("연동 직급 수 : ").append(ttlCnt).append("건, ");
				resultSb.append("신규 직급 수 : ").append(addSccssCnt).append("건, ");
				resultSb.append("변경 직급 수 : ").append(modSccssCnt).append("건 ");
			
				statement = "Y";
			
			}else{
				resultSb.append("연동대상으로부터 직급정보를 조회하지 못했습니다.");
			}
			
			result.put("statement", statement);
			result.put("msg", resultSb.toString());
			
		} catch(Throwable e) {
			log.error(e);
			
			statement = "N";
			resultSb.append(e);

			result.put("statement", statement);
			result.put("msg", resultSb.toString());
			
		}finally {
			baSyncDao.update("BA_SYNC.INSERT_SYNC_INFO", 
					new Object[] {companyid, "2" , companyid, "2", autoFlag, statement, resultSb.toString(), userid}, 
					new int[] {Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.INTEGER}
			);
		}
		
		return result;
	}
	

	/**
	 * 사용자 정보 동기화
	 * @param userid
	 * @return
	 * @throws BaException
	 */
	private Map<String,String> syncUserInfo(long companyid, long userid, String autoFlag) throws BaException {
		Map<String,String> result = new HashMap<String, String>();
		StringBuffer resultSb = new StringBuffer();
		String statement = "N";
		int ttlCnt = 0;
		int addSccssCnt = 0;
		int modSccssCnt = 0;
		
		try {
			
			// 고객사로부터 사용자 정보 조회
			List<Map<String,Object>> list = baSyncDao.queryForList("BA_SYNC.SELECT_USERLIST", null, null);
			ttlCnt = list.size();
			
			List<Object[]> iParamList = new ArrayList<Object[]>();
			List<Object[]> uParamList = new ArrayList<Object[]>();
			
			if(!list.isEmpty()) {
				// 사용자정보 전부 미사용처리
				baSyncDao.update("BA_SYNC.UPDATE_N_USER", new Object[] {companyid}, new int[] {Types.INTEGER});
				
				int chkUserid = 0;
				
				for(Map<String,Object> item : list) {
					String id = ""; // 아이디
					String name = ""; //성명
					String email = ""; //이메일
					String pwd = "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b"; //비번: 1
					String phone = ""; //연락처
					String cellPhone = ""; //핸드폰
					String zipcode = ""; //우편번호
					String addr1 = ""; //주소1
					String addr2 = ""; //주소2
					String divisionid = ""; //소속번호
					String gradeNum = ""; //직급코드
					String gradeNm = ""; //직급명
					String empno = ""; //사번
					String empStsCd = ""; //재직상태 
					String nowGradeApitDt = ""; //현직급임용일
					String useflag = ""; //사용여부
					
					
					if(item.get("USER_ID")!=null) id = item.get("USER_ID").toString();
					if(item.get("P_NAME")!=null) name = item.get("P_NAME").toString();
					if(item.get("EMAIL")!=null) email = item.get("EMAIL").toString();
					if(item.get("OFFICE_TEL")!=null) phone = item.get("OFFICE_TEL").toString();
					if(item.get("MOBILE")!=null) cellPhone = item.get("MOBILE").toString();
					if(item.get("OFFICE_ZIPCODE")!=null) zipcode = item.get("OFFICE_ZIPCODE").toString();
					if(item.get("OFFICE_ADDR")!=null) addr1 = item.get("OFFICE_ADDR").toString();
					if(item.get("OFFICE_DETAIL_ADDR")!=null) addr2 = item.get("OFFICE_DETAIL_ADDR").toString();
					if(item.get("DEPT_ID")!=null) divisionid = item.get("DEPT_ID").toString();
					//if(item.get("DEPT_NAME")!=null) gradeNm = item.get("DEPT_NAME").toString();
					//if(item.get("DEPT_GNTRM_NM")!=null) gradeNum = item.get("DEPT_GNTRM_NM").toString();
					if(item.get("GRADE_CODE")!=null) gradeNum = item.get("GRADE_CODE").toString();
					if(item.get("GRADE_NAME")!=null) gradeNm = item.get("GRADE_NAME").toString();
					if(item.get("EMP_STS_CD")!=null) empStsCd = item.get("EMP_STS_CD").toString();
					if(item.get("NOW_GRADE_APIT_DT")!=null) nowGradeApitDt = item.get("NOW_GRADE_APIT_DT").toString();
					if(item.get("USEFLAG")!=null) useflag = item.get("USEFLAG").toString();
					
					//등록/변경 유무 판별
					chkUserid = baSyncDao.queryForInteger("BA_SYNC.SELECT_USER_COUNT",  new Object[] { id },  new int[] { Types.VARCHAR});
					
					// 등록
					if(chkUserid==0) {
						int maxUserid = baSyncDao.queryForInteger("BA_SYNC.SELECT_SEQ_USERID", new Object[]{}, new int []{});
						
						iParamList.add(new Object[]{ 
								id, name, email, pwd, maxUserid,
								useflag, phone, cellPhone, zipcode, addr1,
								addr2, userid, companyid, gradeNum, companyid,
								divisionid, gradeNm, id, gradeNum, empStsCd, 
								nowGradeApitDt
								});
					}else {// 수정
						uParamList.add(new Object[]{ 
								name, email, useflag, 
								phone, cellPhone, zipcode, addr1,
								addr2, userid, companyid, gradeNum, 
								divisionid, gradeNm, gradeNum, empStsCd, nowGradeApitDt,
								chkUserid
								});
					}
				}
				
				if(iParamList!=null && iParamList.size()>0){
					addSccssCnt = baSyncDao.batchUpdate("BA_SYNC.INSERT_USER_INFO", iParamList, new int[]{ 
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
							Types.VARCHAR
							} );
					
					//신규추가 사용자 권한 부여
					baSyncDao.update("BA_SYNC.INSERT_GROUP_ROLE", null, null);
				}
				
				if(uParamList!=null && uParamList.size()>0){
					modSccssCnt = baSyncDao.batchUpdate("BA_SYNC.UPDATE_USER_INFO", uParamList, new int[]{ 
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
							Types.VARCHAR
							} );
				}
				

				resultSb.append("연동 사용자 수 : ").append(ttlCnt).append("건, ");
				resultSb.append("신규 사용자 수 : ").append(addSccssCnt).append("건, ");
				resultSb.append("변경 사용자 수 : ").append(modSccssCnt).append("건 ");

				statement = "Y";
				
			}else{
				resultSb.append("연동대상으로부터 사용자정보를 조회하지 못했습니다.");
			}

			result.put("statement", statement);
			result.put("msg", resultSb.toString());
			
		} catch(Throwable e) {
			log.error(e);

			statement = "N";
			resultSb.append(e);

			result.put("statement", statement);
			result.put("msg", resultSb.toString());
			
		}finally {
			baSyncDao.update("BA_SYNC.INSERT_SYNC_INFO", 
					new Object[] {companyid, "3" , companyid, "3", autoFlag, statement, resultSb.toString(), userid}, 
					new int[] {Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.INTEGER}
			);
		}
		
		return result;
	}
	

	/**
	 * 
	 * 부서정보 동기화.<br/>
	 *
	 * @throws BaException
	 * @since 2014. 12. 16.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public void autoDeptSync() throws BaException {

		int companyid = 1;
		int userid = 1;
		String autoFlag = "Y";
		
		try {

			syncDeptInfo(companyid, userid, autoFlag);
		
		} catch(Throwable e) {
			log.error(e);
			
			throw new BaException();
		}
	}
	

	/**
	 * 
	 * 직급정보 동기화.<br/>
	 *
	 * @throws BaException
	 * @since 2014. 12. 16.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public void autoGradeSync() throws BaException {

		int companyid = 1;
		int userid = 1;
		String autoFlag = "Y";
		
		try {

			syncGradeInfo(companyid, userid, autoFlag);
			
		} catch(Throwable e) {
			log.error(e);
			
			throw new BaException();
		}
	}
	
	/**
	 * 
	 * 사용자정보 동기화.<br/>
	 *
	 * @throws BaException
	 * @since 2014. 12. 16.
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = BaException.class )
	public void autoUserSync() throws BaException {

		int companyid = 1;
		int userid = 1;
		String autoFlag = "Y";
		
		try {

			syncUserInfo(companyid, userid, autoFlag);
			
		} catch(Throwable e) {
			log.error(e);
			
			throw new BaException();
		}
	}
	
}