package kr.podosoft.ws.service.ca.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ca.CAException;
import architecture.common.user.User;

public interface CADao {
	


	public void updateSocialExceptionFlag(String socialExceptionFlag, long companyId, String cmpNumber);

	public int mergeBhvIndicator(long companyId, String bhvIndicatorNum,  String compNum, String bhvIndicator, 
											String useFlag, long userId);

	
	public String getMaxbhvIndcNum();
	
	public int mergeOperatorCompetency(String cmpNumber, String cmpGroup,
			String cmpName, String cmpDefinition,
			String useFlag, long userId, long companyId);

	
	public List getOperatorCompetencyListDao(int startIndex, int pageSize,
			long companyId);
	
	public List getOperatorBhvListDao(long companyId, String cmpNumber);
	
	
	//가나다
	/**
	 * ��웾紐⑸줉議고쉶
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
	public List getCompetencyListDao(int startIndex, int pageSize, long companyId);
	
	/**
	 * 怨듯넻肄붾뱶議고쉶
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
	public List getCommonCodeListDao(String standardCode, long companyId, String addValue);
	
	/**
	 * ��웾pool愿�━ 硫붾돱���곸꽭議고쉶�먯꽌 �됰룞吏�몴 紐⑸줉 議고쉶
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param company
	 * @param cmpNumber
	 * @return
	 * @since 2014. 3. 17.
	 */
	public List getBhvListDao(long company, String cmpNumber);
	
	/**
	 * ��웾 merge
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param cmpNumber
	 * @param cmpGroup
	 * @param cmpGroup_s
	 * @param cmpName
	 * @param cmpDefinition
	 * @param useFlag
	 * @param userId
	 * @param companyId
	 * @return
	 * @throws CAException
	 * @since 2014. 3. 18.
	 */
	public int mergeCompetency(String cmpNumber, String cmpGroup,
			String cmpGroup_s, String cmpName, String cmpDefinition,
			String useFlag, long userId, long companyId) throws CAException;

	
	/**
	 * ��웾Pool紐⑸줉 �묒�議고쉶
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param companyId
	 * @return
	 * @since 2014. 3. 19.
	 */
	public List getCmptListExcelDao(long companyId);


	/**
	 * �됰룞吏�몴紐⑸줉 �묒�議고쉶
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param companyId
	 * @return
	 * @since 2014. 3. 19.
	 */
	public List getIndicatorListExcelDao(long companyId);

	/**
	 * ��웾援곕ぉ濡�議고쉶
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param useFlag
	 * @param companyId
	 * @return
	 * @since 2014. 3. 18.
	 */
	public List getCmpgroupListDao(String standardCode, String useFlag, long companyId, String value);

	/**
	 * ��웾援�merge
	 * <br/>
	 *
	 * <p></p>
	 *
	 * @param commoncode
	 * @param standardcode
	 * @param cmmCodename
	 * @param useFlag
	 * @param parentCommoncode
	 * @param parentStandardcode
	 * @param userId
	 * @param companyId
	 * @return
	 * @throws CAException
	 * @since 2014. 3. 20.
	 */
	public int mergeCmpGroup(String commoncode, String standardcode, String cmmCodename, String useFlag, String parentCommoncode, String parentStandardcode, long userId, long companyId) throws CAException;

	//역량군저장(고객사)
	public int mergeOperatorCmpGroup(String commoncode, String standardcode, String cmmCodename, String useFlag, String parentCommoncode, String parentStandardcode, long userId, long companyId) throws CAException;
	
	public List<Map<String,Object>> queryForList(String statement, Object[] params, int[] jdbcTypes) throws CAException;
	public int update(String statement, Object[] params, int[] jdbcTypes) throws CAException;
	public int excute(String statement, Object[] params, int[] jdbcTypes) throws CAException;
	

	public String comentMaxCnt(String brdCd, String brdNum, long companyId);

	public int brdComentSaveDao(String brdCd, String brdNum, String maxCnt,
			String brdcont, long userId, long companyId);

	public int brdContSaveDao(String brdtitle, String brdcont, String brdCd,
			String brdNum, String maxCnt, long userId, long companyId);

	public String seqBrdNum();

	public List getDomainChkDao(String subDomain);
	
	public List cmptAdminListDao(long companyId);

	public List cmtpWeightListDao(long companyId, String runNum) ;
 

	public String getMaxRunNum(long companyId) throws CAException;

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public int insertRun(long companyId, String runNum, String evlType, String runName,
			Date runStart, Date runEnd, String sClass, String aClass, String bClass
			, String cClass, String dClass, long userId, String selfWeight, String oneWeight
			, String twoWeight, String colWeight, String subWeight, String yyyy, String evlPrdType, String useFlag) throws CAException;

	public int updateRun(String useFlag, String evlType, String runName, Date runStart, Date runEnd, String selfWeight, String oneWeight, String twoWeight, String colWeight, String subWeight,
			String sClass, String aClass, String bClass, String cClass, String dClass, long userId, String runNum, long companyId, String yyyy, String evlPrdType) throws CAException;

	public void deleteCmptWeight(long companyId, String runNum) throws CAException;
 
	public int insertCmptWeight(long companyId, String runNum,
			String cmpnumber, String weight, long userId) throws CAException;
	
	public List getSubjectCompDiagList(int startIndex, long userId, long companyId);
	
	public int getSubjectCompDiagListCnt(long userId, long companyId);
	
	public List getIndicatorList(long companyId);
	
	public int getRunResultFlag(int runNum, long userid, long companyId);
	
	public List getIndicatorListReSelect(int runNum, long userid, long companyId);
	
	public List getExampleList(long companyId);
	
	public List getExampleList(long companyId, String cmpNumber, String bhvIndcNum);

	public List getIndcScoreList(long companyId, String cmpNumber, String bhvIndcNum, int runNum, long userId);
	
	public List getHistoryList(User user);

	public List getSlfAsstQustDtlList(Map map);

	public List getSlfAsstQustList(Map map);
	
	public void asstSlfAnwsSave(long companyId, String cmpNumber, String bhvIndcNum, String subelementNum, int runNum, 
			                                    String userIdEx, String userIdExed, String exmScore, String exampleNum, String questionSeq,  long userId) throws CAException;

	public void saveRunTarget(int runNum,  long companyId, long userId) throws CAException;
	
	public void saveRunDirection(int runNum,  long companyId, long userId) throws CAException;
	
	public void asstSlfAnwsDlt(int runNum,  long companyId, long userId) throws CAException;

	public void asstSlfAnwsDrctn(int runNum, long companyId, long userId) throws CAException;

	public List getCACmptCmpr(int runNum, long userId, long companyId);

	public List getGrwList(int runNum, long userId, long companyId);
	
	public List getGrwSubjectList(int runNum, long userId, long companyId);
	
	public int insertCompetency(String cmpNumber, String cmpGroup, String cmpName, String cmpDefinition, String bsnsReqrLevel, String useFlag, 
												long userId,  long companyId) throws CAException;

	public int updateCompetency(String cmpNumber, String cmpGroup, String cmpName, String cmpDefinition, String bsnsReqrLevel, String useFlag, 
												 long userId,  long companyId) throws CAException;
	
	public List getIndicatorListDao(long companyId);
	
	public int getIndicatorListCount( long companyId);
	
	public List getCompetencyComboList(long companyId);
	
	public int updateIndicator(String bhvIndicator, String useFlag, long userId, 
										String exceptionFlag, long companyId, String  cmpNumber, String bhvIndcNum) throws CAException;


	public int QuestionSaveCnt(int runNum, long userId, long companyId);
	

	public List consistencyListDao(long companyId);

	public int insertIndicator(long companyId, String cmpNumber,
			String maxbhvIndcNum, String bhvIndicator, String useFlag,
			long userId,
			 String exceptionFlag) throws CAException;

	public String getMaxcmpNum();

	public List cmptDiagnosisListDao(long companyId);

	public List cmptTargetListDao(long companyId, String runNum);

	public void deleteCmptTarget(long companyId, String runNum);

	public int insertCmptTarget(List<Object[]> rows);
 
	public String getRunNameDao(long companyId, String runNum);

	public String getMaxRun(long companyId);

	public List cmptStatisticsListDao(long companyId, String runNum);

	public void insertCmptDirection(List<Object[]> rows1);

	public void deleteCmptDirection(long companyId, String runNum);

	public int cmptDiagInitialization(long companyId, long session, String runNum, String userId);

	public List<Map<String, Object>> getCompDiagResultList(String run_num,
			long companyId, long userId);

	public void udpateCnstFlag(int runNum, long companyId, long userId);

	public void updateSocialFlag(int runNum, long companyId, long userId);

	public List cmpExplanationDao(int runNum, long companyId, long userId);

	public List subelementResultListDao(int runNum, long companyId, long userId);

	public List subelementExplanationDao(int runNum, long companyId, long userId);

	public List cmpScoreListDao(String runNum, long companyId, long userId);

	public List subjectListDao(String runNum, long companyId, long userId, String year);

	public List notSubjectListDao(String runNum, long companyId, long userId, String year);

	public String diagResultStringDao(int runNum, long companyId, long userId);

	public String diagResultScoreDao(int runNum, long companyId, long userId);

	public List developmentGuideDao(int runNum, long companyId, long userId);

	public List recommendSubjectInfoDao(String subjectNum, String year,
			String chasu);

	public List recommendNotSubjectInfoDao(String subjectNum, String year,
			String chasu, long companyId, long userId, String cmpnumber);

	public List cmptStatisticsClassListDao(long companyId, String runNum);

	public List diagResultExcelDao(long companyId, String runNum);

	public List<Map<String, Object>> getRunCompetencyListDao(long companyId,
			String runNum);

	public List yearCategoryListDao(long companyId);

	public List cmptStatisticsYearListDao(long companyId);

	public List divisionCategoryListDao(long companyId);

	public List cmptStatisticsDivisionListDao(long companyId, String runNum);

	public List recommendActivityListDao(long companyId);

	public String getUserId(long companyId, long userId);

	public List dainPayModuleInfoDao(String sKey, String sID, String compCd,
			String eduYear, String courseCd, String courseSq,
			String subjectNum, String year, String chasu, long companyId, long userId, String cmpnumber);

	public String getUserId(String reqSID);

	public int insertDaoPay(String userId, String courseCd, String eduYear,
			String courseSq, String amount, String payMethod, String cpId,
			String daoutrx, String orderNo, String settdate,  
			String bankCode, String bankName, String accountNo, String depositendDate, String receiverName);

	public int insertClassUserDao(long companyId, long userId,
			String subjectNum, int year, int chasu, int cmpnumber,
			String couponFlag, String attendStateCode);

	public int updateClassUserDao(int companyId, int userId, String courseCd,
			int eduYear, int courseSq, String attendStateCode);

	public String getCpSubjectNum(String subjectNum, String year, String chasu);

	public int mergeClassUserDao(long companyId, long userId,
			String subjectNum, int year, int chasu, int cmpnumber,
			String couponFlag);
	
	
	public Object insertDaoPayOriginal(String userId, String courseCd,
			String eduYear, String courseSq, String amount, String payMethod,
			String cpId, String daoutrx, String orderNo, String settdate);

	public List<Map<String, Object>> getMailInfoList(long companyId,
			String userId);
	
	
	public List getOperatorIndicatorListDao(long companyId);

	public int getOperatorIndicatorListCount(long companyId);

//	public List getOperatorIndicatorExampleListDao(int cmpNumber,
//			int bhvIndcNum, long companyId);
	
	public int operatorInsertIndicator(long companyId, String cmpNumber,
			String maxbhvIndcNum, String bhvIndicator, String useFlag,
			long userId,
			 String exceptionFlag) throws CAException;

	public int operatorUpdateIndicator(String bhvIndicator, String useFlag, long userId, 
			String exceptionFlag, long companyId, String  cmpNumber, String bhvIndcNum) throws CAException;
	
//	public int operatorDeleteExample(long companyId, String cmpNumber, String bhvIndcNum) throws CAException;

	public List getOperatorCompetencyMappingListDao(long companyId, String jobLdrNum);

	public int mergeCompetencyMappingDao(long companyId, String jobLdrNum,
			String cmpNumber, String checkFlag);

	public int updateCompetencyMappingDao(long companyId, String jobLdrNum,
			String cmpNumber, String checkFlag);	
	
	public List getKpiListDao(int startIndex, int pageSize,
			long companyId);

	public int mergeKpi(String kpiNumber, String kpiGroup, String kpiGroup_s,
			String kpiName, String evlHow, String unit, String useFlag,
			long userId, long companyId);

	public List getKpigroupListDao(String standardCode, String useFlag, long companyId, String value);

	public List getKpiListExcelDao(long companyId);

	public String kpiAddCheckDao(long companyId);

	public int operatorMergeKpi(String kpiNumber, String kpiGroup,
			String kpiName, String kpiType, String meaEvlCyc, String evlYype,
			String evlHow, String unit, String useFlag, long userId,
			long companyId, String cap, String target, String threshold, String targetSetWrnt, String dataSource, String mgmtDept);

	public List getOperatorKpiListExcelDao(long companyId);

	public String cmptAddCheckDao(long companyId);

	public int mergeCmptTargetDao(long companyId, String runNum,
			String divisionId, String userId, String job, String leadership,
			long sessionId, String checkFlag);

	public int updateCmptTargetDao(String checkFlag, long sessionId,
			long companyId, String runNum);

	public int updateCmptTargetUserDao(String checkFlag, long sessionId,
			long companyId, String runNum, String userid);
	
	public int mergeCmptDirectionOneDao(long companyId, String runNum,
			String oneUserId, String userId, long sessionId, String oneWeight,
			String checkFlag);
	
	public int mergeCmptDirectionTwoDao(long companyId, String runNum,
			String twoUserId, String userId, long sessionId, String twoWeight,
			String checkFlag);

	public int mergeCmptDirectionSelfDao(long companyId, String runNum,
			String userId, long sessionId, String selfWeight, String checkFlag);

	public int updateCmptDirectionDao(String checkFlag, long companyId,
			String runNum, long sessionId);
	
	public int updateCmptDirectionSelfDao(String checkFlag, long companyId,
			String runNum, String userId, long sessionId);

	public int updateCmptDirectionOneDao(String checkFlag, long companyId,
			String runNum, String oneUserId, String userId, long sessionId);

	public int updateCmptDirectionTwoDao(String checkFlag, long companyId,
			String runNum, String twoUserId, String userId, long sessionId);

	public String userTargetInfo(long companyId, String userId);

	public String userTargetOneUser(long companyId, String empNo);

	public String userTargetTwoUser(long companyId, String empNo2);

	public List getSruvYealListDao(long companyId);

	public List getSurvListDao(long companyId, String runNum);

	public String getSurvRun(long companyId);

	public List getSurvQstnDao(long companyId, String ppNo);

	public List getSurvQstnPoolDao(long companyId);

	public List getSurvTargDao(long companyId, String ppNo);

	public String getMaxQstnPoolNo(long companyId);

	public int mergeQstnPooltDao(String qstnPoolNo, String qstnTypeCd,
			String qstn, long companyId, long sessionId);

	public int updateQstnPooltDao(long sessionId, String qstnPoolNo, long companyId);
	public String getMaxppNo(long companyId);

	public int mergeServPpDao(String ppNo, String ppNm, String ppPerp,
			Date ppSt, Date ppEd, long companyId, long sessionId, String useFlag);


	public String getMaxQstnSeq(long companyId);

	public int mergeQstnDao(String qstnSeq, String qstnTypeCd, String qstn,
			long companyId, long sessionId, String ppNo);

	public List getSurvUserDao(long companyId);

	public int mergeServUserDao(String userId, String ppNo, long companyId,
			long sessionId);

	public int updateQstnDao(long sessionId, String ppNo, long companyId,
			String qstnSeq);

	public int updateQstnUserDao(long sessionId, String ppNo, long companyId,
			String userId);

	public List getSurvRstDao(long companyId, String ppNo, int ppType,
			String ppSeq);

	public List getSurvRst2Dao(long companyId, String ppNo, int ppType,
			String ppSeq);

	public List getSurvRstCountDao(long companyId, String ppNo, int ppType,
			String ppSeq);

	public List cmptTargetUserDao(long companyId, int dvsId, int highDvsId);

	public List getServListExcelDao(long companyId, String ppNo,
			List<Map<String, Object>> list);

	public int getSurvQstnCountDao(long companyId, String ppNo);

	public int updateServPpDao(long sessionId, String ppNo, long companyId);

	public int mergSbjctCmMappingDao(long companyId, String subjectNum, String cmpNumber,
			String checkFlag);
	
	public int updateSbjctCmMappingDao(long companyId, String subjectNum, String cmpNumber,
			String checkFlag);

	public int mergeSbjctOpenDao(String subjectName, String trainingCode,
			String institueName, String eduTarget, String eduObject,
			String course_cont, long companyId, String subjectNum, String useFlag, String sampleUrl);

	public int insertSbjctOpenDao(String subjectName, String trainingCode,
			String institueName, String eduTarget, String eduObject,
			String course_cont, long companyId, String useFlag, String sampleUrl);

	public int upSbjctOpenDao(String subjectName, String trainingCode,
			String institueName, long companyId, String subjectNum,
			String useFlag, String eduTarget, String eduObject, String courseContents, String sampleUrl);

	public int delSbjectOpen(String subjectNum, String year, String chasu,
			long companyId);

	public int mergeSbjctOpenDetail(long companyId, String subjectNum,
			String chasu, Date eduStime, Date eduEtime, String year);

	public int upSbjctDetailDao(String subjectNum, String year, String chasu,
			long companyId, String eduStime, String eduEtime);

	public int mergeQstnRsttDao(long companyId, String ppNo, long sessionId,
			String qstnSeq, String svRst);

	public int updateQstnRsttDao(String age, String gender, long companyId, String ppNo, long sessionId);

	public int caCommonDelService(Map<String, Object> map, long userId,
			long companyId);

	public List getcaOperatorCmptMappExcelDao(long companyId);

	public int upSbjctMappDao(String subjectNum, String cmpNum, long companyId,
			String useFlag);

	public List cmptListUserDao(long companyid, long pUserid, String colUserid);

	public int mergeCmptDirectioncolDao(long companyId, String runNum,
			String colUserIdTmp, String userId, long sessionId,
			String colWeight, String checkFlag);

	public List cmptTargetListV2Dao(long companyId, String runNum);

	public int mergeCmptDirectionsubDao(long companyId, String runNum,
			String subUserIdTmp, String userId, long sessionId,
			String subWeight, String checkFlag);

	public void initCmptDirectionUserDao(long sessionId, long companyId, String runNum, String userId);
	
	public void delCmptDirectioncolDao(long sessionId, long companyId,
			String runNum, String userId);

	public void delCmptDirectionsubDao(long sessionId, long companyId,
			String runNum, String userId);

	public int updateCmptDirectioncolDao(String checkFlag, long companyId,
			String runNum, String userId, long sessionId);

	public int updateCmptDirectionsubDao(String checkFlag, long companyId,
			String runNum, String userId, long sessionId);

	public String userTargetColUser(long companyId, String szValue);

	public String userTargetSubUser(long companyId, String szValue);

	public int mergeServ(String qstnPoolNo, String qstnTypeCd, String qstn,
			String useFlag, long userId, long companyId);


	public int getMaxKpiNo();
	
	public int queryForInteger(String statement, Object[] params, int[] jdbcTypes) throws CAException;
	
	public int batchUpdate(String statement, List<Object[]> parameteres, int[] jdbcTypes) throws CAException;


	/**
	 * 자동방향설정 프로시져 호출
	 * @param companyid 회사ID
	 * @param userid 작업자ID
	 * @param runNum 진단실시번호
	 * @return
	 * @throws CAException
	 */
	public int setRunDirAutoUser(long companyid, long userid, int runNum) throws CAException;


	

	
}


