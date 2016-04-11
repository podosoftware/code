package kr.podosoft.ws.service.ba;

import java.util.List;
import java.util.Map;

public interface BaEducationService {

	/**
	 * ROLE : 학생
	 * MENU : 나의학습
	 * 나의 교육이력 목록
	 * @param companyid
	 * @param userid
	 * @param pageable
	 * @param pageSize
	 * @param startIndex
	 * @return
	 * @throws BaException
	 */
	public List<Map<String, Object>> getMyEduHistoryList(long companyid, long userid, boolean pageable, int pageSize, int startIndex) throws BaException;
	
	/**
	 * ROLE : 학생
	 * MENU : 나의학습
	 * 나의 총 교육이력
	 * @param companyid
	 * @param userid
	 * @return
	 * @throws BaException
	 */
	public int getMyEduHistoryCnt(long companyid, long userid) throws BaException;
	
	/**
	 * ROLE : 학생
	 * MENU : 나의학습
	 * 나의 교육이력 상세정보
	 * @param companyid
	 * @param userid
	 * @param subjectNum
	 * @param year
	 * @param chasu
	 * @return
	 * @throws BaException
	 */
	public List<Map<String, Object>> getMyEduHistoryInfo(long companyid, long userid, String subjectNum, int year, int chasu) throws BaException;
	
	/**
	 * ROLE : 학생
	 * MENU : 나의학습
	 * 수강 취소 예약
	 * @param companyid
	 * @param userid
	 * @param subjectNum
	 * @param year
	 * @param chasu
	 * @return
	 * @throws BaException
	 */
	public int eduCancelReserve(long companyid, long userid, String subjectNum, int year, int chasu) throws BaException;
	
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
	public Map<String, Object> getStudyInfo(long companyid, long userid, String subjectNum, int year, int chasu) throws BaException;
	
	
	/* ================================================================================================= */
	
	/**
	 * 교육이력 목록
	 * @param companyId
	 * @param userId
	 * @param year
	 * @return
	 * @throws BaException
	 */
	public List<Map<String,Object>> getEducationList(long companyId, long userId, int year, boolean pageable, int pageSize, 
			int startIndex) throws BaException;
	
	/**
	 * 교육이력 수
	 * @param companyId
	 * @param userId
	 * @param year
	 * @return
	 * @throws BaException
	 */
	public int getEducationCnt(long companyId, long userId, int year) throws BaException;
	
	/**
	 * 교육이력 상세 신청정보
	 * @param companyId
	 * @param userId
	 * @param subjectNum
	 * @param year
	 * @param chasu
	 * @param studentId
	 * @return
	 * @throws BaException
	 */
	public List<Map<String,Object>> getEducationInfo(long companyId, long userId, String subjectNum, int year, int chasu,
			int studentId) throws BaException;
	
	/**
	 * 교육이력 상세 결제정보
	 * @param companyId
	 * @param userId
	 * @param subjectNum
	 * @param year
	 * @param chasu
	 * @param studentId
	 * @return
	 * @throws BaException
	 */
	public List<Map<String,Object>> getEducationSettlementInfo(long companyId, long userId, String subjectNum, int year, int chasu,
			int studentId) throws BaException;
	
	/**
	 * 교육취소요청 완료처리
	 * @param companyId
	 * @param userId
	 * @param subjectNum
	 * @param year
	 * @param chasu
	 * @param studentId
	 * @return
	 * @throws BaException
	 */
	public String setEduCancelSettle(long companyId, long userId, String subjectNum, int year, int chasu,
			int studentId) throws BaException;
	
	/**
	 * 교육이력정보 수강정보 수정
	 * @param companyId
	 * @param userId
	 * @param subjectNum
	 * @param year
	 * @param chasu
	 * @param studentId
	 * @param progressRate
	 * @param progressPoint
	 * @param discussPoint
	 * @param examPoint
	 * @param taskPoint
	 * @param totalPoint
	 * @return
	 * @throws BaException
	 */
	public String setEduScore(
			long companyId, long userId, String subjectNum, int year, int chasu,
			int studentId, String progressRate, String progressPoint, String discussPoint, String examPoint, 
			String taskPoint, String totalPoint) throws BaException;
	
	/**
	 * 교육이력 교육수료상태변경
	 * @param companyId
	 * @param userId
	 * @param subjectNum
	 * @param year
	 * @param chasu
	 * @param studentId
	 * @param changeAttendState
	 * @param existingAttendState
	 * @param nopassReason
	 * @return
	 * @throws BaException
	 */
	public String setEduPassChange(
			long companyId, long userId, String subjectNum, int year, int chasu,
			int studentId, String changeAttendState, String existingAttendState, String nopassReason) throws BaException;

	
}
