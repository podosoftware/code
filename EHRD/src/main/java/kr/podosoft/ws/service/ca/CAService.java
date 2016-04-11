package kr.podosoft.ws.service.ca;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import architecture.common.user.User;

public interface CAService {
	
	public List<Map<String, Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CAException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CAException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CAException;
	
	/**
	 * 역량목록조회
	 * <br/>
	 * 
	 * <p></p>
	 * 
	 * @param startIndex
	 * @param pageSize
	 * @param companyId
	 * @return
	 * @since 2014. 3. 18.
	 */
	public List getCompetencyListService(int startIndex, int pageSize, long companyId);
	
	/**
	 * 공통코드 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param standardCode
	 * @param companyId
	 * @param addValue
	 * @return
	 * @since 2014. 3. 18.
	 */
	public List getCommonCodeListService(String standardCode, long companyId, String addValue);
	
	/**
	 * 
	 * 역량pool관리 메뉴의 상세조회에서 행동지표 목록 조회<br/>
	 *
	 * <p></p>
	 *
	 * @param user
	 * @param cmpNumber
	 * @return
	 * @since 2014. 3. 17.
	 */
	public List getBhvList(User user, String cmpNumber);

	/**
	 * 역량저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param map
	 * @param user
	 * @return
	 * @throws CAException
	 * @since 2014. 3. 18.
	 */
	public int competencySaveService(Map<String, Object> map, User user) throws CAException;
	


	/**
	 * 역량정보 엑셀 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 3. 19.
	 */
	public int cmptExcelSaveService(User user, HttpServletRequest request) ;
	
	
	/**
	 * 
	 * 역량pool관리(고객사) 메뉴의 상세조회에서 행동지표 목록 조회<br/>
	 *
	 * <p></p>
	 *
	 * @param user
	 * @param cmpNumber
	 * @return
	 * @since 2014. 4. 3.
	 */
	public List getOperatorBhvList(User user, String cmpNumber);

	/**
	 * 
	 * 역량목록조회(고객사)
	 *
	 * <p></p>
	 * @param l 
	 * @param pageSize 
	 *
	 * @param user
	 * @param cmpNumber
	 * @return
	 * @since 2014. 4. 3.
	 */
	public List getOperatorCompetencyListService(int startIndex, int pageSize ,long companyId);
	
	/**
	 * 역량군저장(고객사)
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param map
	 * @param user
	 * @return
	 * @throws CAException
	 * @since 2014. 3. 18.
	 */
	public int operatorCmpGroupSaveService(Map<String, Object> map, User user) throws CAException;
	
	
	/**
	 * 역량저장(고객사)
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param map
	 * @param user
	 * @return
	 * @throws CAException
	 * @since 2014. 3. 18.
	 */
	public int operatorCompetencySaveService(Map<String, Object> map, User user) throws CAException;

	/**
	 * 행동지표 엑셀 업로드
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 3. 19.
	 */
	public int indicatorExcelSaveService(User user, HttpServletRequest request) ;

	/**
	 * 역량pool목록 엑셀 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param companyId
	 * @return
	 * @since 2014. 3. 19.
	 */
	public List getCmptListExcel(long companyId);
	

	/**
	 * 행동지표목록 엑셀 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param companyId
	 * @return
	 * @since 2014. 3. 19.
	 */
	public List getIndicatorListExcel(long companyId);

	/**
	 * 역량군목록 조회
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param useFlag
	 * @param companyId
	 * @return
	 * @since 2014. 3. 19.
	 */
	public List getCmpgroupListService(String useFlag, long companyId);
	
	/**
	 * 역량군 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param map
	 * @param user
	 * @return
	 * @throws CAException
	 * @since 2014. 3. 18.
	 */
	public int cmpGroupSaveService(Map<String, Object> map, User user) throws CAException;
	
	
	/**
	 * kpi 지표군 저장
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param map
	 * @param user
	 * @return
	 * @throws CAException
	 * @since 2014. 4. 14.
	 */
	public int kpiGroupSaveService(Map<String, Object> map, User user) throws CAException;

	public String comentMaxCnt(String brdCd, String brdNum, User user);
	
	public int brdComentSave(String brdCd, String brdNum, String maxCnt, String brdcont, long userId, long companyId);
	
	public int brdContSave(String brdtitle, String brdcont, String brdCd, String brdNum, String maxCnt, long userId, long companyId, List<Map<String, Object>> mailList) throws CAException;
	
	public String seqBrdNum();
	
	public List getDomainChk(String subDomain);
	

	public List cmptAdminList(User user); 

	public List cmtpWeightList(User user, String runNum);


	public int cmptAdminSave(Map<String, Object> map,
			List<Map<String, Object>> list, User user) throws Exception;

	/**
	 * 
	 * 대상자관리 - 대상자 저장<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 21.
	 */
	public int runTargetSave(HttpServletRequest request, User user) throws Exception;
	
	/**
	 * 
	 * 방향설정 - 진단자 설정  저장<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 27
	 */
	public int saveDirUser(HttpServletRequest request, User user) throws Exception;
	/**
	 * 
	 * 방향설정 - 진단자 설정  저장<br/>
	 *
	 * @param request
	 * @param user
	 * @return
	 * @since 2014. 10. 27
	 */
	public int saveDirAutoUser(HttpServletRequest request, User user) throws Exception;
	
	/**
	 * 
	 * 핵심역량교육실적관리 엑셀 업로드<br/>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 12. 2.
	 */
	public String upLoadCoreCmptEduListExcel(User user, HttpServletRequest request);
	
	/**
	 * 
	 * 대상자관리 엑셀 업로드<br/>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 12. 9.
	 */
	public String upLoadCaCmptObjListExcel(User user, HttpServletRequest request);
	
	/**
	 * 
	 * 방향설정 엑셀 업로드<br/>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 12. 11.
	 */
	public String upLoadCaCmptDirListExcel(User user, HttpServletRequest request);
	
	/**
	 * 
	 * 상시학습관리 엑셀 업로드<br/>
	 *
	 * @param user
	 * @param request
	 * @return
	 * @since 2014. 12. 11.
	 */
	public String upLoadEmAdminClassListExcel(User user, HttpServletRequest request) throws CAException;
	
	
	
	
	/* ================================================= 
     MPVA project E..... 
     ================================================= */
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

//	public void asstSlfAnwsSave(int runNum,int saveStatus, List<Map<String,Object>> answers, User user) throws CAException;

	/**
	 * 공통역량진단
	 * 결과보기 > 진단비교
	 * @param runNum
	 * @param user
	 * @param userid
	 * @return
	 */
	public List getCACmptCmpr(int runNum, long companyId, long userId);
	 
	/**
	 * 공통역량진단
	 * 결과보기 > 역량성장도
	 * @param runNum
	 * @param user
	 * @param userid
	 * @return
	 */
	public List getGrwList(int runNum, long companyId, long userid);
	
	public List getGrwSubjectList(int runNum, long companyId, long userId); 
	 
    public List getSubjectCompDiagList(int startIndex, long userId, long companyId);
    
    public int getSubjectCompDiagListCnt(long userId, long companyId);
	
	public List getSelfDiagnosisList(int runNum, long userId, long companyId);
	
	public int QuestionSaveCnt(int runNum, long userId, long companyId);
	
	public List getIndicatorListService(long companyId);
	
	public int getIndicatorListCount(long companyId);
	
	public List getCompetencyComboList(long companyId);
	
	public int indicatorSaveService(Map map, User user) throws CAException;
	
	public List consistencyList(User user);
	
	public List cmptDiagnosisList(User user);

	public List cmptTargetList(User user, String runNum);

	public int cmptTargetSave(String runNum, List<Map<String, Object>> list,
			User user);

	public String getRunName(long companyId, String runNum);

	public List cmptStatisticsList(User user, String runNum);

	public int cmptDiagInitialization(User user, String runNum, String userId);
	
	public List cmpExplanation(int runNum, long companyId, long userId);

	public List subelementResultList(int runNum, long companyId, long userId);

	public List subelementExplanation(int runNum, long companyId, long userId);

	public List cmpScoreList(User user, String runNum);

	public List subjectList(User user, String runNum, String year);

	public List notSubjectList(User user, String runNum, String year);

	public String diagResultString(int runNum, User user);

	public String diagResultScore(int runNum, User user);

	public List developmentGuide(int runNum, User user);

	public List recommendSubjectInfo(String subjectNum, String year,
			String chasu); 

	public List recommendNotSubjectInfo(String subjectNum, String year,
			String chasu, User user, String cmpnumber);

	public List cmptStatisticsClassList(long companyId, String runNum);

	public List diagResultExcel(long companyId, String runNum);

	public List<Map<String, Object>> getRunCompetencyList(long companyId,
			String runNum);

	public List yearCategoryList(long companyId);

	public List cmptStatisticsYearList(long companyId);

	public List divisionCategoryList(long companyId);

	public List cmptStatisticsDivisionList(long companyId, String runNum);

	public List recommendActivityList(long companyId);

	public List dainPayModuleInfo(long companyId, long userId,
			String subjectNum, String year, String chasu, String cmpnumber);

	public int daoPayReturnInfo(String reqSKey, String reqSID,
			String reqCompCd, String courseCd, String courseSq, String eduYear,
			String name, String email, String hp, String amount,
			String payMethod, String cpId, String daoutrx, String orderNo,
			String settdate, String bankCode, String bankName, String accountNo, String depositendDate, String receiverName);

	public String getUserId(String reqSID);

	public int insertClassUser(long companyId, long userId, String subjectNum,
			int year, int chasu, int cmpnumber, String couponFlag);

	public int updateClassUser(int companyId, int userId, String courseCd,
			int eduYear, int courseSq, String attendStateCode);

	public int mergeClassUser(long companyId, long userId, String subjectNum,
			int year, int chasu, int cmpnumber, String couponFlag);
	
	public String getStudyInfo(long companyid, long userid, String subjectNum, int year, int chasu) ;

	public void daoPayCompleteInfo(String reqSKey, String reqSID,
			String reqCompCd, String courseCd, String courseSq, String eduYear,
			String name, String email, String hp, String amount,
			String payMethod, String cpId, String daoutrx, String orderNo,
			String settdate);

	public List getOperatorIndicatorListService(long companyId);

	public int getOperatorIndicatorListCount(long companyId);

	public int operatorIndicatorSaveService(Map map, User user, List<Map<String,Object>> items) throws CAException;	
	
	public List getOperatorCompetencyMappingListService(long companyId,String jobLdrNum);
	
	public int operatorCompetencyMappingSaveService(List<Map<String, Object>> list, User user, String jobLdrNum);
	
	public List getKpiListService(int startIndex, int pageSize,
			long companyId);
	
	public int kpiSaveService(Map<String, Object> map, User user) throws CAException;
	
	public int operatorKpiSaveService(Map<String, Object> map, User user) throws CAException;
	

	public int userKpiSaveService(Map<String, Object> map, User user, String runNum) throws CAException;

	public List getKpigroupListService(String useFlag, long companyId);

	public List getKpiListExcel(long companyId);

	public int kpiExcelSaveService(User user, HttpServletRequest request);
	
	public String kpiAddCheckService(User user) throws CAException;

	public List getOperatorKpiListExcel(long companyId);

	public String cmptAddCheckService(User user) throws CAException;
	
	public int cmptSingleTargetSave(Map<String, Object> map, User user);
	
	public int cmptTargetExcelSaveService(String runNum, User user, HttpServletRequest request);
	
	public List getSruvYealListService(long companyId);
	
	public List getSurvList(User user, String runNum);
	
	public List getSurvQstn(User user, String ppNo);
	
	public List getSurvQstnPool(User user);
	
	public int getQstnPoolSave(List<Map<String, Object>> list,
			User user);
	
	public List getSurvTarg(User user, String ppNo);
	
	public int getQstnPoolDel(String qstnPoolNo, User user);
	
	public int getQstnDel(List<Map<String, Object>> list, String qstnSeq, User user);
	
	public int getServAllSave(String ppNo, String ppNm, String ppPerp,
			Date ppSt, Date ppEd, User user, String useFlag);
	
	public List getSurvUser(User user);
	
	public int getQstnBindSave(String ppNo, List<Map<String, Object>> list,
			User user);
	
	public int getUserBindSave(String ppNo, List<Map<String, Object>> list,
			User user);
	
	public int getQstnUserDel(List<Map<String, Object>> list, String ppNo,
			User user);
	public List getSurvRst(User user, String ppNo, int ppType, String ppSeq);
	
	public List getSurvRstCount(User user, String ppNo, int ppType, String ppSeq);
	
	public List cmptTargetUserList(User user, int dvsId, int highDvsId);
	
	public int infoMailSend(User user, String ppNo,
			List<Map<String, Object>> list);
	
	public List getServListExcel(User user, String ppNo,
			List<Map<String, Object>> list);
	
	public int getSurvQstnCount(User user, String ppNo);
	
	public int getServPpDel(List<Map<String, Object>> list,
			User user);
	
	
	public int setSbjctCmMapping(String subjectNum,
			List<Map<String, Object>> list, User user);
	
	public int setSbjctOpen(String subjectNum, String subjectName,
			String trainingCode, String institueName, String eduTarget,
			String eduObject, String course_cont, User user, String useFlag, String sampleUrl);
	
	public int setSbjctDatail(String subjectName, String trainingCode,
			String institueName, String eduTarget, String eduObject,
			String course_cont, User user, String useFlag, String sampleUrl);
	
	public int delSbjectOpen(String subjectNum, String year, String chasu, User user);
	
	public int setSbjctOpenDetail(String subjectNum,
			List<Map<String, Object>> list2, User user)  throws Exception;
	
	public List cmpGroupChkService(String useFlag, long companyId);
	public int getQstnRstSave(List<Map<String, Object>> list, User user, String ppNo, String age, String gender);
	
	public int caCommonDelService(Map<String, Object> map, User user) throws CAException;
	public List getcaOperatorCmptMappExcel(long companyId);
	
	public int caOperatorCmptMappUploadService(User user,
			HttpServletRequest request);
	
	public List cmptListUser(long companyid, long pUserid, String colUserid);
	public List cmptTargetListV2(User user, String runNum);
	public int cmptSingleTargetSaveV2(Map<String, Object> map, User user);
	public int servExcelSaveService(User user, HttpServletRequest request);
	

	public int caOperatorKpiMappUploadService(User user, HttpServletRequest request);
	
	public int operatorKpiMappingSaveService(List<Map<String, Object>> list, User user, String jobLdrNum) throws CAException;
	
}
