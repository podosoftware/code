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

import kr.podosoft.ws.service.em.EmService;
import kr.podosoft.ws.service.em.EmServiceException;
import kr.podosoft.ws.service.em.dao.EmDao;
import kr.podosoft.ws.service.utils.CommonUtils;

public class EmServiceImpl implements EmService {

	private Log log = LogFactory.getLog(getClass());

	private EmDao emDao;
	
	public EmDao getEmDao() {
		return emDao;
	}

	public void setEmDao(EmDao emDao) {
		this.emDao = emDao;
	}

	/**
	 * 나의 교육년도(최소,최대) 조회
	 */
	public Map<String, Object> selectMyEduYear(long companyid, long userid) throws EmServiceException {
		
		List<Map<String, Object>> list = emDao.queryForList("EM.SELECT_EDU_YYYY", new Object[] {
				companyid, userid,
				companyid, userid,
				companyid, userid
			}, new int[] {
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC
			});
		
		return list.get(0);
	}

	/**
	 * 이수 현황 점수 조회
	 * 1. Map 필수이수현황, 기관성과평가 이수현황, 보훈직무필수교육 이수현황 
	 * 2. List 필수이수현황 목록
	 * 3. List 기관성과평가 이수현황 목록
	 */
	public Map<String,List<Map<String,Object>>> selectMyReqEduScr(long companyid, long userid, int year) throws EmServiceException {
		Map<String,List<Map<String,Object>>> map = new HashMap<String,List<Map<String,Object>>>();
		
		// 필수이수현황, 기관성과평가 이수현황, 보훈직무필수교육 이수현황
		map.put("items", emDao.queryForList("EM.SELECT_MY_REQ_SCR", new Object[] {
				userid, year,
				userid, year,
				companyid, userid, year,
				companyid, userid, year,
				companyid, userid, year,
				companyid, userid, year,
				userid, year,
				companyid, userid, year,
				companyid, userid, year,
				userid,
				userid, companyid,
				userid, companyid
			}, new int[] {
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC
			}));
		
		// 필수이수현황 목록
		map.put("items1", emDao.queryForList("EM.SELECT_MY_REQ_EDU_SCR_LIST", new Object[] {
					userid, year,
					userid, year,
					companyid, userid, year,
					companyid, userid, year,
					companyid, userid, year,
					companyid, userid, year
				}, new int[] {
					Types.NUMERIC, Types.NUMERIC,
					Types.NUMERIC, Types.NUMERIC,
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
				}));
		
		// 기관성과평가 이수현황 목록
		map.put("items2", emDao.queryForList("EM.SELECT_MY_REQ_PERF_ASSE_SCR_LIST", new Object[] {
					userid, year,
					companyid, userid, year,
					companyid, userid, year
				}, new int[] {
					Types.NUMERIC, Types.NUMERIC,
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
				}));
		
		return map;
	}

	/**
	 * 학습현황 목록 조회
	 * 승진기준달성현황 목록 조회
	 * @param companyid 회사id
	 * @param userid 임직원id
	 * @param year 조회년도
	 * @param type 조회유형
	 * @param bdate 조회기준일, 교육훈련결과 > 승진기준달성현황에서 사용
	 */
	public List<Map<String, Object>> selectEduSttList(long companyid, long userid, int year, int type, String bdate) throws EmServiceException {
		
		return emDao.selectEduSttList(companyid, userid, year, type, bdate);
	}


	/**
	 * 교육 상세정보 조회(일반교육)
	 */
	public Map<String, Object> selectMyClassDtl(long companyid, long userid, int openNum) throws EmServiceException {
		Map<String, Object> item = Collections.EMPTY_MAP;
		
		List<Map<String, Object>> list = emDao.queryForList("EM.SELECT_EDU_INF_DTL", new Object[] {
				companyid, userid, openNum
			}, new int[] {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			});
		
		if(list!=null && list.size()>0) {
			item = list.get(0);
			
			// 수료 정보
			item.put("cmplt_stnd_list", emDao.queryForList("EM.SELECT_SBJCT_CMPLT_STND_LIST", new Object[] {
					companyid, openNum, userid,
					companyid, item.get("SUBJECT_NUM")
				}, new int[] {
					Types.NUMERIC, Types.NUMERIC, Types.NUMERIC,
					Types.NUMERIC, Types.VARCHAR
				}));
			
			// 맵핑과정 정보
			item.put("cm_map_list", emDao.queryForList("EM_APPLY.SELECT_CM_SBJCT_MAP_LIST", new Object[] {
					companyid, companyid, item.get("SUBJECT_NUM")
				}, new int[] {
					Types.NUMERIC, Types.NUMERIC, Types.VARCHAR
				}));
		}
		
		return item;
	}
	
	/**
	 * 교육 상세정보 조회(상시학습)
	 */
	public Map<String, Object> selectMyClassAlwDtl(long companyid, long userid, int openNum) throws EmServiceException {
		Map<String, Object> item = Collections.EMPTY_MAP;
		
		List<Map<String, Object>> list = emDao.queryForList("EM.SELECT_EDU_ALW_INF_DTL", new Object[] {
				companyid, userid, openNum
			}, new int[] {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			});
		
		if(list!=null && list.size()>0) {
			item = list.get(0);
		}
		
		return item;
	}
	
	
	/**
	 * 교육 수강상태 취소처리 
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = EmServiceException.class )
	public String updateEduCancel(long companyid, long userid, int openNum) throws EmServiceException {
		String result = "N";
		
		try {
			// 교육정보 조회
			Map<String, Object> eduinfoMap = selectMyClassDtl(companyid, userid, openNum);
			
			if(eduinfoMap!=null) {
				// 취소 가능여부 판별
				if(eduinfoMap.get("CANCEL_YN").equals("Y")) {
					// 결재정보 유무 판별
					int reqNum = 0;
					// 결재번호가 있으면서 결재상태가 "0" 이 아닐경우 결재회수 처리
					if(eduinfoMap.get("REQ_NUM")!=null && !eduinfoMap.get("REQ_STS_CD").equals("0")) {
						reqNum = CommonUtils.stringToInt(eduinfoMap.get("REQ_NUM").toString(),0);
						
						// 결재정보가 있을 경우 결재 회수처리 후 교육신청 정보의 결재상태를 '0' 으로 변경
						emDao.update("EM.UPDATE_APPR_REQ_WITHDRAW", new Object[] {
								userid,
								companyid, reqNum
						}, new int[] {
								Types.NUMERIC, 
								Types.NUMERIC, Types.NUMERIC
						});
					}
	
					// 교육신청정보 취소 처리
					int updateCnt = emDao.update("EM.UPDATE_EDU_CANCEL", new Object[] {
						userid,	
						userid, openNum, companyid
					}, new int[] {
						Types.NUMERIC,
						Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
					});
					
					if(updateCnt>0) result = "Y";
				}
			}
		} catch(Throwable e) {
			log.error(e);
			throw new EmServiceException(e);
		}
		
		return result;
	}
	
}
