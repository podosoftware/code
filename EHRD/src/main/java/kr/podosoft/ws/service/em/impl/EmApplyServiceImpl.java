package kr.podosoft.ws.service.em.impl;

import java.sql.Types;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import kr.podosoft.ws.service.cdp.dao.CdpDao;
import kr.podosoft.ws.service.common.Filter;
import kr.podosoft.ws.service.em.EmApplyService;
import kr.podosoft.ws.service.em.EmServiceException;
import kr.podosoft.ws.service.em.dao.EmApplyDao;

public class EmApplyServiceImpl implements EmApplyService {

	private Log log = LogFactory.getLog(getClass());

	private EmApplyDao emApplyDao;
	private CdpDao cdpDao; // 서버 페이징 용 dao로 사용 

	public EmApplyDao getEmApplyDao() {
		return emApplyDao;
	}

	public void setEmApplyDao(EmApplyDao emApplyDao) {
		this.emApplyDao = emApplyDao;
	}

	public CdpDao getCdpDao() {
		return cdpDao;
	}

	public void setCdpDao(CdpDao cdpDao) {
		this.cdpDao = cdpDao;
	}

	/**
	 *  나의 역량진단 목록 조회 
	 */
	public List<Map<String,Object>> selectMyCamList(long companyid, long userid) throws EmServiceException {
		
		return emApplyDao.queryForList("EM_APPLY.SELECT_MYCAM_LIST", new Object[] {
				companyid, userid
		}, new int[] {
				Types.NUMERIC, Types.NUMERIC
		});
	}
	
	/**
	 *  나의 역량진단 결과정보 조회 
	 */
	public List<Map<String,Object>> selectMyCarScrList(long companyid, long userid, int runNum) throws EmServiceException {
		
		return emApplyDao.queryForList("EM_APPLY.SELECT_MYCAR_SCR_LIST", new Object[] {
				companyid, userid, userid, companyid, userid, runNum
		}, new int[] {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		});
	}
	
	/**
	 *  나의 경력개발계획 목록 조회 
	 */
	public List<Map<String,Object>> selectMyCdpList(long companyid, long userid) throws EmServiceException {
		
		return emApplyDao.queryForList("EM_APPLY.SELECT_MYCDP_LIST", new Object[] {
				companyid, userid
		}, new int[] {
				Types.NUMERIC, Types.NUMERIC
		});
	}
	
	/**
	 * 역량진단 과정목록 조회(페이징) 
	 */
	public List<Map<String,Object>> selectMyCamSbjctOpenList(long companyid, long userid, int startIndex, int pageSize, Filter filter, 
			String sortField, String sortDir, int runNum, String fromDate, String toDate, 
			int cmpnumber ) throws EmServiceException {
		
		log.debug("[emApplyService selectMyCamSbjctOpenList] ----------------------------------- Begin");
		log.debug("[emApplyService selectMyCamSbjctOpenList] fromDate : " + fromDate);
		log.debug("[emApplyService selectMyCamSbjctOpenList] toDate : " + toDate);
		log.debug("[emApplyService selectMyCamSbjctOpenList] runNum : " + runNum);
		log.debug("[emApplyService selectMyCamSbjctOpenList] cmpnumber : " + cmpnumber);
		
		List<Map<String,Object>> list = Collections.EMPTY_LIST;
		
		try {
			String query = "";
			String defaultSort = "APPLY_NM DESC, SUBJECT_NAME";
			
			Map<String,Object> map = new HashMap<String, Object>();
			
			query = "EM_APPLY.SELECT_MYCAM_SBJCT_OPEN_LIST"; // 역량진단 결과와 연계된 과정개설 목록 조회
			Object[] params = {
					companyid
					, userid
					, userid
					, companyid
					, userid
					, runNum
					, companyid
					, userid
					, companyid
					, companyid
					, companyid
					, fromDate
					, toDate
			};
			
			int[] jdbcTypes = {
					Types.NUMERIC,
					Types.NUMERIC,
					Types.NUMERIC,
					Types.NUMERIC,
					Types.NUMERIC,
					Types.NUMERIC,
					Types.NUMERIC,
					Types.NUMERIC,
					Types.NUMERIC,
					Types.NUMERIC,
					Types.NUMERIC,
					Types.VARCHAR,
					Types.VARCHAR
			};
			
			// 역량목록에서 역량선택 시
			if(cmpnumber>0) {
				map.put("WHERE_CMPNUMBER", " AND MC.CMPNUMBER = " + cmpnumber);
			} else {
				map.put("WHERE_CMPNUMBER", "");
			}
			
			list = cdpDao.dynamicQueryForList(query, startIndex, pageSize, sortField, sortDir, defaultSort, filter, params, jdbcTypes, map);
			
		} catch(Throwable e) {
			log.error(e);
			e.printStackTrace();
		}
		
		log.debug("[emApplyService selectMyCamSbjctOpenList] ----------------------------------- End");
		
		return list;
	}
	
	/**
	 * 경력개발계획 과정목록 조회(페이징) 
	 */
	public List<Map<String,Object>> selectMyCdpSbjctOpenList(long companyid, long userid, int startIndex, int pageSize, Filter filter, 
			String sortField, String sortDir, int runNum, String fromDate, String toDate ) throws EmServiceException {
		
		log.debug("[emApplyService selectMyCdpSbjctOpenList] ----------------------------------- Begin");
		log.debug("[emApplyService selectMyCdpSbjctOpenList] fromDate : " + fromDate);
		log.debug("[emApplyService selectMyCdpSbjctOpenList] toDate : " + toDate);
		log.debug("[emApplyService selectMyCdpSbjctOpenList] runNum : " + runNum);
		
		List<Map<String,Object>> list = Collections.EMPTY_LIST;
		
		try {
			String query = "";
			String defaultSort = "SUBJECT_NAME, EDU_PERIOD DESC";
			Object[] params = null;
			int[] jdbcTypes = null;
			Map<String,Object> map = new HashMap<String, Object>();
			
			query = "EM_APPLY.SELECT_MYCDP_SBJCT_OPEN_LIST"; // 경력개발계획 시 계획한 과정의 과정개설 목록 조회

			params = new Object[10];
			jdbcTypes = new int[10];
			
			params[0] = companyid;
			params[1] = runNum;
			params[2] = userid;
			params[3] = companyid;
			params[4] = userid;
			params[5] = companyid;
			params[6] = companyid;
			params[7] = companyid;
			params[8] = fromDate;
			params[9] = toDate;
			
			jdbcTypes[0] = Types.NUMERIC;
			jdbcTypes[1] = Types.NUMERIC;
			jdbcTypes[2] = Types.NUMERIC;
			jdbcTypes[3] = Types.NUMERIC;
			jdbcTypes[4] = Types.NUMERIC;
			jdbcTypes[5] = Types.NUMERIC;
			jdbcTypes[6] = Types.NUMERIC;
			jdbcTypes[7] = Types.NUMERIC;
			jdbcTypes[8] = Types.VARCHAR;
			jdbcTypes[9] = Types.VARCHAR;

			list = cdpDao.dynamicQueryForList(query, startIndex, pageSize, sortField, sortDir, defaultSort, filter, params, jdbcTypes, map);
			
		} catch(Throwable e) {
			log.error(e);
			e.printStackTrace();
		}
		
		log.debug("[emApplyService selectMyCdpSbjctOpenList] ----------------------------------- End");
		
		return list;
	}
	
	/**
	 * 일반신청 과정목록 조회(페이징) 
	 */
	public List<Map<String,Object>> selectSbjctOpenList(long companyid, long userid, int startIndex, int pageSize, Filter filter, 
			String sortField, String sortDir, String fromDate, String toDate ) throws EmServiceException {
		
		log.debug("[emApplyService selectSbjctOpenList] ----------------------------------- Begin");
		log.debug("[emApplyService selectSbjctOpenList] fromDate : " + fromDate);
		log.debug("[emApplyService selectSbjctOpenList] toDate : " + toDate);
		
		List<Map<String,Object>> list = Collections.EMPTY_LIST;
		
		try {
			String query = "";
			String defaultSort = "APPLY_NM DESC, SUBJECT_NAME";
			Object[] params = null;
			int[] jdbcTypes = null;
			Map<String,Object> map = new HashMap<String, Object>();
			
			query = "EM_APPLY.SELECT_SBJCT_OPEN_LIST"; // 유효 과정개설 목록 조회
			params = new Object[7];
			jdbcTypes = new int[7];
			
			params[0] = companyid;
			params[1] = userid;
			params[2] = companyid;
			params[3] = companyid;
			params[4] = companyid;
			params[5] = fromDate;
			params[6] = toDate;
			
			jdbcTypes[0] = Types.NUMERIC;
			jdbcTypes[1] = Types.NUMERIC;
			jdbcTypes[2] = Types.NUMERIC;
			jdbcTypes[3] = Types.NUMERIC;
			jdbcTypes[4] = Types.NUMERIC;
			jdbcTypes[5] = Types.VARCHAR;
			jdbcTypes[6] = Types.VARCHAR;
			
			list = cdpDao.dynamicQueryForList(query, startIndex, pageSize, sortField, sortDir, defaultSort, filter, params, jdbcTypes, map);
			
		} catch(Throwable e) {
			log.error(e);
			e.printStackTrace();
		}
		
		log.debug("[emApplyService selectSbjctOpenList] ----------------------------------- End");
		
		return list;
	}


	/**
	 * 과정 상세정보 조회
	 */
	public Map<String, Object> selectSbjctOpenDtl(long companyid, long userid, int openNum) throws EmServiceException {
		Map<String, Object> item = Collections.EMPTY_MAP;
		
		List<Map<String, Object>> list = emApplyDao.queryForList("EM_APPLY.SELECT_SBJCT_OPEN_DTL", new Object[] {
				companyid, userid, 
				companyid, openNum
			}, new int[] {
				Types.NUMERIC, Types.NUMERIC, 
				Types.NUMERIC, Types.NUMERIC
			});
		
		if(list!=null && list.size()>0) {
			item = list.get(0);

			// 맵핑과정 정보
			item.put("cm_map_list", emApplyDao.queryForList("EM_APPLY.SELECT_CM_SBJCT_MAP_LIST", new Object[] {
					companyid, companyid, item.get("SUBJECT_NUM")
				}, new int[] {
					Types.NUMERIC, Types.NUMERIC, Types.VARCHAR
				}));
			
			// 수료기준 정보
			item.put("cmplt_stnd_list", emApplyDao.queryForList("EM_APPLY.SELECT_SBJCT_CMPLT_STND_LIST", new Object[] {
					companyid, companyid, item.get("SUBJECT_NUM")
				}, new int[] {
					Types.NUMERIC, Types.NUMERIC, Types.VARCHAR
				}));
		}
		
		return item;
	}
	
	
	/**
	 * 과정개설 신청 처리 
	 * @param companyid 회사번호
	 * @param userid 사용자번호
	 * @param openNum 과정개설번호
	 * @param approvedList 결재라인목록
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = EmServiceException.class )
	public String updateSbjctApply(long companyid, long userid, int openNum, List<Map<String,Object>> approvedList) throws EmServiceException {
		String result = "";
		boolean approvedChk = false;
		
		try {
			// 과정개설정보 추출
			Map<String,Object> sbjctOpenInfo = selectSbjctOpenDtl(companyid, userid, openNum);
			
			if(sbjctOpenInfo!=null) {
				// 신청가능여부 판단
				if(sbjctOpenInfo.get("APPLY_CD").equals("00")) {
					int reqNum = 0; // 결재 승인요청번호
					String reqTypeCd = "2"; // 결재 승인유형
					String reqStsCd = ""; // 결재 승인상태
					
					/*
					 * 결재필요과정 여부 판단(비사이버과정은 결재라인 존재)
					 * TRAINING_CODE A(합숙), B(집합교육), D(사이버+집합)
					 */
					if( sbjctOpenInfo.get("TRAINING_CODE").equals("A") ||
						sbjctOpenInfo.get("TRAINING_CODE").equals("B") ||
						sbjctOpenInfo.get("TRAINING_CODE").equals("D")
						) {
						
						reqStsCd = "1"; // 승인상태 : 승인대기
						
						if(approvedList!=null && approvedList.size()>0) {
							// 신규 결재번호 조회
							reqNum = Integer.parseInt(emApplyDao.queryForObject("EM_APPLY.SELECT_NEW_REQ_NUM", new Object[] {}, new int[] {}, Integer.class).toString());
	
							Map<String,Object> item;
							
							for(int i=0; i<approvedList.size(); i++) {
								 item = approvedList.get(i);
								// 결재정보 등록
								if(i==0) {
									emApplyDao.update("EM_APPLY.INSERT_BA_APPR_REQ", new Object[] {
										companyid, reqNum, reqTypeCd, userid, 
										reqStsCd, approvedList.size(), userid
									}, new int[] {
										Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, 
										Types.VARCHAR, Types.NUMERIC, Types.NUMERIC
									});
								}
								
								// 결재라인정보 등록
								emApplyDao.update("EM_APPLY.INSERT_BA_APPR_REQ_LINE", new Object[] {
										companyid, reqNum, item.get("REQ_LINE_SEQ"), item.get("USERID"), reqStsCd,
										item.get("APPR_DIV_CD"), userid
								}, new int[] {
										Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR,
										Types.VARCHAR, Types.NUMERIC
								});
							}
							
							approvedChk = true;
						} else {
							result = "09"; // 신청불가 : 결재정보 없음
						}
						
					} else {
						// 사이버과정은 결재필요없음
						approvedChk = true;
						// 사이버과정은 결재승인상태를 '승인' 으로
						reqStsCd = "2";
					}
					
					/*
					 * 과정신청정보 저장
					 */
					if(approvedChk) {
						int insertRslt = emApplyDao.update("EM_APPLY.INSERT_SBJCT_OPEN_CLASS", new Object[] {
							openNum, sbjctOpenInfo.get("SUBJECT_NUM"), reqNum, reqNum, 
							reqStsCd, 
							userid
						}, new int[] {
							Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, 
							Types.VARCHAR, 
							Types.NUMERIC
						});
						
						if(insertRslt>0) result = "Y"; // 신청성공
					}
				} else {
					/*
					 * 01 : 신청불가 : 신청중
					 * 02 : 신청불가 : 수강중
					 * 05 : 신청불가 : 수료
					 * 09 : 신청불가 : 결재정보 X
					 * 10 : 신청불가 : 신청기간 X
					 */
					result = sbjctOpenInfo.get("APPLY_CD").toString(); 
				}
			} else {
				result = "11"; // 과정개설정보가 없습니다.
			}
		} catch(Throwable e) {
			log.error(e);
			throw new EmServiceException(e);
		}
		
		return result;
	}
	
}
