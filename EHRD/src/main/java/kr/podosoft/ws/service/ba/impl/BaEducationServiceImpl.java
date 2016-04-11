package kr.podosoft.ws.service.ba.impl;

import java.sql.Types;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.ba.BaEducationService;
import kr.podosoft.ws.service.ba.BaException;
import kr.podosoft.ws.service.ba.dao.BaEducationDao;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
//import pjt.dainlms.aria.CipherAria;

public class BaEducationServiceImpl implements BaEducationService {

	private Log log = LogFactory.getLog(getClass());
	
	private BaEducationDao baEducationDao;

	public BaEducationDao getBaEducationDao() {
		return baEducationDao;
	}
	public void setBaEducationDao(BaEducationDao baEducationDao) {
		this.baEducationDao = baEducationDao;
	}
	
	
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
	public List<Map<String, Object>> getMyEduHistoryList(long companyid, long userid, boolean pageable, int pageSize, int startIndex) throws BaException {
		List<Map<String, Object>> list = Collections.EMPTY_LIST;
		try {
			if(pageable) {
				list = baEducationDao.queryForList("BA_EDU.SELECT_MY_EDU_HISTORY_LIST", startIndex, pageSize, 
						new Object[] {companyid, companyid, companyid, companyid, userid}, 
						new int[] {Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER});
			} else {
				list = baEducationDao.queryForList("BA_EDU.SELECT_MY_EDU_HISTORY_LIST", 
						new Object[] {companyid, companyid, companyid, companyid, userid}, 
						new int[] {Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER});
			}
		} catch(Throwable e) {
			log.error(e);
		}
		return list;
	}
	
	/**
	 * ROLE : 학생
	 * MENU : 나의학습
	 * 나의 총 교육이력
	 * @param companyid
	 * @param userid
	 * @return
	 * @throws BaException
	 */
	public int getMyEduHistoryCnt(long companyid, long userid) throws BaException {
		
		return baEducationDao.queryForInteger("BA_EDU.SELECT_MY_EDU_HISTORY_CNT"
						, new Object[] {userid}
						, new int[] {Types.INTEGER});
	}
	
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
	public List<Map<String, Object>> getMyEduHistoryInfo(long companyid, long userid, String subjectNum, int year, int chasu) throws BaException {
		List<Map<String, Object>> list = Collections.EMPTY_LIST;
		try {
			list = baEducationDao.queryForList("BA_EDU.SELECT_MY_EDU_HISTORY_INFO", 
					new Object[] {
						companyid, companyid, companyid, companyid, companyid, 
						userid, subjectNum, year, chasu
					}, 
					new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER,
						Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER
					});
		} catch(Throwable e) {
			log.error(e);
		}
		return list;
	}
	
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
	public int eduCancelReserve(long companyid, long userid, String subjectNum, int year, int chasu) throws BaException {
		int result = 0;
		try {
			// 교육이력정보 상태변경
			result = baEducationDao.update("BA_EDU.UPDATE_EDU_CANCEL_RESERVE"
						, new Object[] {userid, userid, subjectNum, year, chasu}
						, new int[] {Types.INTEGER, Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER});
			
			// 관리자에게 취소요청 메일발송
			
			// 발송정보 추출
			
			// 메일발송
		} catch(Throwable e) {
			log.error(e);
		}
		
		return result;
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
	public Map<String,Object> getStudyInfo(long companyid, long userid, String subjectNum, int year, int chasu) throws BaException {
		Map<String,Object> rsltMap = new HashMap<String, Object>();
		try {

			// 정보추출
			List<Map<String, Object>> eduInfoList = baEducationDao.queryForList("BA_EDU.SELECT_LMS_STUDY_INFO"
					, new Object[] {userid, subjectNum, year, chasu}
					, new int[] {Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER});

			String sKey = "";
			String sID = "";
			String compCd = "";
			String eduYear = year+"";
			String courseCd = subjectNum;
			int courseSq = chasu;
			
			if(!eduInfoList.isEmpty() && eduInfoList.size()>0) {
				Map<String,Object> map = eduInfoList.get(0);
				
				/*
				if(map.get("SYNC_YN")!=null && !map.get("SYNC_YN").equals("Y")) {
					String[][] syncRslt = null;
					String applyYn = "N";
					StringBuffer statement = new StringBuffer();
					
					statement.append(map.get("NAME")).append("(").append(map.get("ID")).append(", ").append(map.get("CURRENT_CLASS")).append("학년").append("<br>");
					statement.append(map.get("SUBJECT_NAME")).append(" (").append(year).append("년도, ").append(chasu).append("차수").append("<br>");
					
					try {
						// 신청정보 LMS에 전송
						SystemWizUtils swu = new SystemWizUtils();
						syncRslt = swu.putCourseApply(
										year+"", map.get("CP_SUBJECT_NUM").toString(), courseSq, map.get("ID").toString(), map.get("ATTEND_STATE_CODE").toString(), 
										map.get("NAME").toString(), "", map.get("CURRENT_CLASS").toString(), map.get("GENDER").toString(), map.get("EMAIL").toString(), 
										map.get("CELLPHONE").toString());
						
						if(syncRslt!=null && syncRslt.length>1) {
							
							// 결과처리
							String memberYn = syncRslt[1][0]; // 회원여부 Y/N, 기존회원이면 Y, 신규면 N
							applyYn = syncRslt[1][1]; // 등록성공여부 Y/N
							String startYmd = ""; // 과정시작일
							String endYmd = ""; // 과정종료일
							String onlineCancelStdt = ""; // 수강취소 시작일
							String onlineCancelEndt = ""; // 수강취소 종료일
							String onlineReeduStdt = ""; // 재학습 시작일
							String onlineReeduEndt = ""; // 재학습 종료일
							
							if(applyYn.equals("Y")) {
								startYmd = syncRslt[1][2]; // 과정시작일
								endYmd = syncRslt[1][3]; // 과정종료일
								onlineCancelStdt = syncRslt[1][4]; // 수강취소 시작일
								onlineCancelEndt = syncRslt[1][5]; // 수강취소 종료일
								onlineReeduStdt = syncRslt[1][6]; // 재학습 시작일
								onlineReeduEndt = syncRslt[1][7]; // 재학습 종료일
							}
		
							if(applyYn.equals("Y")) {
								// 신청정보 연동결과 교육이력정보에 반영
								baEducationDao.update("BA_EDU.UPDATE_EDU_SYNC_RSLT", 
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
						throw new BaException(e);
					} finally {
						// 동기화 결과저장
						baEducationDao.update("BA_SYNC.INSERT_LMS_SYNC_HISTORY", 
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
				*/
				
				log.debug("INIT EDU POP PARAMS..");
				// 정보암호화
				//CipherAria aria = new CipherAria();
				
				//sKey = aria.encode(SystemWizUtils.getSkey(), SystemWizUtils.getCipherkey());
				//sID = aria.encode(map.get("ID").toString(), SystemWizUtils.getCipherkey());
				compCd = "";//SystemWizUtils.getUniversitycode();
				eduYear = year+"";
				courseCd = map.get("CP_SUBJECT_NUM").toString();
				courseSq = chasu;
			}
			
			// 파라메터 셋팅
			//rsltMap.put("callUrl", SystemWizUtils.getDevstudyurl()); // 개발서버
			rsltMap.put("callUrl",""); // 운영서버
			rsltMap.put("sKey", sKey);
			rsltMap.put("sID", sID);
			rsltMap.put("compCd", compCd);
			rsltMap.put("eduYear", eduYear);
			rsltMap.put("courseCd", courseCd);
			rsltMap.put("courseSq", courseSq);

		} catch(Throwable e) {
			log.error(e);
			throw new BaException(e);
		}
		return rsltMap;
	}
	
	/* ================================================================================================= */
	
	
	/**
	 * 교육이력 목록
	 * @param companyid
	 * @param userid
	 * @param year
	 * @return
	 * @throws BaException
	 */
	public List<Map<String,Object>> getEducationList(long companyid, long userid, int year, boolean pageable, int pageSize, 
			int startIndex) throws BaException {
		
		List<Map<String, Object>> list = Collections.EMPTY_LIST;
		try {
			if(pageable) {
				list = baEducationDao.queryForList("BA_EDU.SELECT_MGMT_EDU_LIST", startIndex, pageSize, 
						new Object[] {companyid, companyid, companyid, companyid, companyid, year}, 
						new int[] {Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER});
			} else {
				list = baEducationDao.queryForList("BA_EDU.SELECT_MGMT_EDU_LIST", 
						new Object[] {companyid, companyid, companyid, companyid, companyid, year}, 
						new int[] {Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER});
			}
		} catch(Throwable e) {
			log.error(e);
		}
		return list;
	}
	
	/**
	 * 교육이력 수
	 * @param companyId
	 * @param userId
	 * @param year
	 * @return
	 * @throws BaException
	 */
	public int getEducationCnt(long companyId, long userId, int year) throws BaException {
		
		return baEducationDao.queryForInteger("BA_EDU.SELECT_MGMT_EDU_CNT"
				, new Object[] {year}
				, new int[] {Types.INTEGER});
	}
	
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
			int studentId) throws BaException {
		
		return baEducationDao.queryForList("BA_EDU.SELECT_MGMT_EDU_INFO"
				, new Object[] {
						companyId, companyId, companyId, companyId, companyId,
						studentId, subjectNum, year, chasu
				}
				, new int[] {
						Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER,
						Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER
				});
	}
	
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
			int studentId) throws BaException {
		
		List<Map<String, Object>> list = Collections.EMPTY_LIST;
		try {
			
		} catch(Throwable e) {
			log.error(e);
		}
		return list;
	}
	
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
			int studentId) throws BaException {
		String result = "N";
		
		try {
			int chk = baEducationDao.update("BA_EDU.UPDATE_EDU_CANCEL_SETTLE"
					, new Object[] {
							userId, userId,
							studentId, subjectNum, year, chasu
					}
					, new int[] {
							Types.INTEGER, Types.INTEGER, 
							Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER
					});
			
			if(chk>0) result = "Y";
		} catch(Throwable e) {
			log.error(e);
		}
		return result;
	}
	
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
			String taskPoint, String totalPoint) throws BaException {
		String result = "N";
		
		try {
			int chk = baEducationDao.update("BA_EDU.UPDATE_EDU_POINT_CHANGE"
					, new Object[] {
							progressRate, progressPoint, discussPoint, examPoint, taskPoint,
							totalPoint, userId,
							studentId, subjectNum, year, chasu
					}
					, new int[] {
							Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER, Types.INTEGER,
							Types.INTEGER, Types.INTEGER,
							Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER
					});
			
			if(chk>0) result = "Y";
		} catch(Throwable e) {
			log.error(e);
		}
		return result;
	}
	
	/**
	 * 교육이력 교육수료상태변경
	 * @param companyId
	 * @param userId
	 * @param subjectNum
	 * @param year
	 * @param chasu
	 * @param studentId
	 * @param changeAttendState 변경 수강상태
	 * @param existingAttendState 기존 수강상태
	 * @param nopassReason 미수료 사유
	 * @return
	 * @throws BaException
	 */
	public String setEduPassChange(
			long companyId, long userId, String subjectNum, int year, int chasu,
			int studentId, String changeAttendState, String existingAttendState, String nopassReason) throws BaException {
		String result = "N";
		
		try {
			
			// 수강상태 변경
			int chk = baEducationDao.update("BA_EDU.UPDATE_EDU_ATTEND_CHANGE"
					, new Object[] {
							changeAttendState, changeAttendState, changeAttendState, nopassReason, userId,
							studentId, subjectNum, year, chasu
					}
					, new int[] {
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.INTEGER,
							Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER
					});
			
			// 기존 수강상태가 수료이고 변경상태가 수료가 아닐 경우
			if(existingAttendState.equals("5") && !changeAttendState.equals("5")) {
				// 포트폴리오 교육이력 삭제
				baEducationDao.update("BA_EDU.DELETE_MP_EDU_COMPLETE"
						, new Object[] {
								studentId, subjectNum, year, chasu
						}
						, new int[] {
								Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER
						});
			}
			
			// 기존 수강상태가 수료가 아니고 변경 수강상태가 수료일 경우
			if(!existingAttendState.equals("5") && changeAttendState.equals("5")) {
				// 포트폴리오 교육이력 등록
				baEducationDao.update("BA_EDU.INSERT_MP_EDU_COMPLETE"
						, new Object[] {
								userId, studentId, subjectNum, year, chasu
						}
						, new int[] {
								Types.INTEGER, Types.INTEGER, Types.VARCHAR, Types.INTEGER, Types.INTEGER
						});
			}
			
			if(chk>0) result = "Y";
		} catch(Throwable e) {
			log.error(e);
		}
		return result;
	}
	
	
	
}
