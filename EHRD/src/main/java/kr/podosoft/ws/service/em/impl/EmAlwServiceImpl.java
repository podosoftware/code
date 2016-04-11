package kr.podosoft.ws.service.em.impl;

/**
 * 교육훈련 > 상시학습
 */

import java.sql.Types;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.common.dao.CommonDao;
import kr.podosoft.ws.service.em.EmAlwService;
import kr.podosoft.ws.service.em.EmServiceException;
import kr.podosoft.ws.service.em.dao.EmAlwDao;
import kr.podosoft.ws.service.utils.CommonUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.velocity.runtime.directive.Parse;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.ee.web.util.ParamUtils;

public class EmAlwServiceImpl implements EmAlwService {

	private Log log = LogFactory.getLog(getClass());

	private EmAlwDao emAlwDao;
	private CommonDao commonDao;
	
	public EmAlwDao getEmAlwDao() {
		return emAlwDao;
	}

	public void setEmAlwDao(EmAlwDao emAlwDao) {
		this.emAlwDao = emAlwDao;
	}

	public CommonDao getCommonDao() {
		return commonDao;
	}

	public void setCommonDao(CommonDao commonDao) {
		this.commonDao = commonDao;
	}

	/**
	 * 상시학습 목록 조회
	 */
	public List<Map<String, Object>> selectAlwList(long companyid, long userid) throws EmServiceException {
		
		return emAlwDao.queryForList("EM.SELECT_EDU_ALW_LIST", new Object[] {
				companyid, companyid, 
				companyid, userid
		}, new int[] {
				Types.NUMERIC, Types.NUMERIC,
				Types.NUMERIC, Types.NUMERIC
		});
	}
	
	/**
	 * 상시학습 목록 조회(엑셀다운로드 용)
	 */
	public List<Map<String, Object>> selectAlwListExcel(long companyid, long userid, int yyyy) throws EmServiceException {
		
		return emAlwDao.queryForList("EM.SELECT_EDU_ALW_LIST_EXCEL", new Object[] { 
				companyid, userid, yyyy
		}, new int[] {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
		});
	}

	
	/**
	 * 상시학습 상세정보 조회
	 */
	public Map<String, Object> selectAlwDtl(long companyid, long userid, int asSeq) throws EmServiceException {
		Map<String, Object> item = Collections.EMPTY_MAP;
		
		List<Map<String, Object>> list = emAlwDao.queryForList("EM.SELECT_ALW_DTL", new Object[] {
				companyid, userid, asSeq
			}, new int[] {
				Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
			});
		
		if(list!=null && list.size()>0) {
			item = list.get(0);
			
			// 증빙자료 목록
			/*
			item.put("file_list", emAlwDao.queryForList("COMMON.SELECT_FILE_INFO", new Object[] {
					6, asSeq
			}, new int[] {
					Types.NUMERIC, Types.NUMERIC
			}));
			*/			
		}
		
		return item;
	}
	
	/**
	 * 상시학습 등록
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = EmServiceException.class )
	public String insertAlwInf(long companyid, long userid, Map<String,Object> param, List<Map<String,Object>> apprList) throws EmServiceException {
		String result = "N";
		String reqTypeCd = "3"; // 결재유형 : 상시학습 승인요청
		String reqStsCd = "1"; // 결재상태 : 신청
		int objectType = 6; // 파일Type : 상시학습
		boolean approvedChk = false;
		int updateCnt = 0;
		
		try {
			// 신규 결재번호 조회
			int reqNum = Integer.parseInt(emAlwDao.queryForObject("EM_APPLY.SELECT_NEW_REQ_NUM", new Object[] {}, new int[] {}, Integer.class).toString());
			
			// 결재정보 저장
			if(apprList!=null && apprList.size()>0) {
				//마지막 승인자가 될 교육훈련승인자 검색.
				List<Map<String,Object>> lastUser = emAlwDao.queryForList("EM_APPLY.SELECT_APPER_USER", null, null );
				if(lastUser!=null && lastUser.size()>0){
					Map<String,Object> map = (Map<String, Object>)lastUser.get(0);
					long lastUserid = Long.parseLong(map.get("USERID").toString());
					
					boolean dupChk = false;
					//승인요청자중에 중복되는지 체크
					for(int i=0; i<apprList.size(); i++) {
						Map<String,Object> appItem = apprList.get(i);
						
						log.debug("### "+appItem.get("USERID")+", "+lastUserid);
						if(Long.parseLong(appItem.get("USERID").toString()) == lastUserid){
							dupChk = true;
						}
					}
					
					log.debug("### dupChk:"+dupChk);
					
					if(!dupChk){
						Map<String,Object> addMap = new HashMap();
						addMap.put("REQ_LINE_SEQ", apprList.size()+1);
						addMap.put("USERID", lastUserid);
						addMap.put("APPR_DIV_CD", "6"); //통보..
						apprList.add(addMap);
					}
				}
				
				Map<String,Object> item;
				for(int i=0; i<apprList.size(); i++) {
					 item = apprList.get(i);
					// 결재정보 등록
					if(i==0) {
						emAlwDao.update("EM_APPLY.INSERT_BA_APPR_REQ", new Object[] {
							companyid, reqNum, reqTypeCd, userid, 
							reqStsCd, apprList.size(), userid
						}, new int[] {
							Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, 
							Types.VARCHAR, Types.NUMERIC, Types.NUMERIC
						});
					}
					
					// 결재라인정보 등록
					emAlwDao.update("EM_APPLY.INSERT_BA_APPR_REQ_LINE", new Object[] {
							companyid, reqNum, item.get("REQ_LINE_SEQ"), item.get("USERID"), reqStsCd,
							item.get("APPR_DIV_CD"), userid
					}, new int[] {
							Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR,
							Types.VARCHAR, Types.NUMERIC
					});
				}
				
				approvedChk = true;
			} else {
				result = "N"; // 등록불가 : 결재정보 없음
			}
			
			if(approvedChk) {
				int asSeq = 0; // 상시학습번호
				if(param.get("mod").equals("mod")) {
					// 기존 상시학습 번호 조회
					asSeq = Integer.parseInt(param.get("asseq").toString());
				} else {
					// 신규 상시학습 번호 조회
					asSeq = Integer.parseInt(emAlwDao.queryForObject("EM.SELECT_NEW_ALW_SEQ", null, null, Integer.class).toString());
				}
				
				if(param.get("mod").equals("mod")) {
					// 상시학습 기본정보 수정
					updateCnt = emAlwDao.update("EM.UPDATE_EDU_ALW_STN_INF", new Object[] {
							param.get("subjectNm"), param.get("yyyy"), param.get("instituteName"), param.get("trainingCode"), param.get("eduCont"), 
							param.get("eduStime"), param.get("eduEtime"), param.get("eduHourH"), param.get("eduHourM"), param.get("recogTimeH"), 
							param.get("recogTimeM"), param.get("alwStdCd"), param.get("deptDesignationYn"),  param.get("deptDesignationCd"), param.get("perfAsseSbjCd"), 
							param.get("officeTimeCd"), param.get("eduinsDivCd"), reqNum, reqStsCd, userid,
							param.get("requiredYn"),  param.get("instituteCode"),  param.get("cmpnumber"),
							companyid, asSeq						
						}, new int[] {
							Types.VARCHAR, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
							Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, 
							Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, 
							Types.VARCHAR, Types.VARCHAR, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC,
							Types.VARCHAR, Types.VARCHAR, Types.VARCHAR,
							Types.NUMERIC, Types.NUMERIC,
							
						});
				} else {
					// 상시학습 기본정보 등록
					updateCnt = emAlwDao.update("EM.INSERT_EDU_ALW_STN_INF", new Object[] {
						companyid, asSeq, param.get("subjectNm"), param.get("yyyy"), param.get("instituteName"),
						param.get("trainingCode"), param.get("eduCont"), param.get("eduStime"), param.get("eduEtime"), param.get("eduHourH"),
						param.get("eduHourM"), param.get("recogTimeH"), param.get("recogTimeM"), param.get("alwStdCd"), param.get("deptDesignationYn"), 
						param.get("deptDesignationCd"), param.get("perfAsseSbjCd"), param.get("officeTimeCd"), param.get("eduinsDivCd"), reqNum,
						userid,
						param.get("requiredYn"), param.get("instituteCode"), param.get("cmpnumber")
					}, new int[] {
						Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.VARCHAR,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
						Types.NUMERIC, Types.NUMERIC, Types.NUMERIC, Types.VARCHAR, Types.VARCHAR, 
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.NUMERIC,
						Types.NUMERIC,
						Types.VARCHAR, Types.VARCHAR, Types.VARCHAR
					});
				}
				
				// 상시학습 상세정보 등록
				updateCnt = emAlwDao.update("EM.INSERT_EDU_ALW_DTL_INF", new Object[] {
						asSeq, param.get("gradeNum"), param.get("ttGetSco"), userid
				}, new int[] {
						Types.NUMERIC, Types.VARCHAR, Types.NUMERIC, Types.NUMERIC
				});
				
				// 증빙자료 등록, 해당 번호로 등록된 파일유무 판별
				int fileCnt = Integer.parseInt(emAlwDao.queryForObject("EM.SELECT_FILE_CNT", new Object[] {
						objectType, param.get("objectid")
					}, new int[] {
						Types.NUMERIC, Types.NUMERIC
					}, Integer.class).toString());
				// 파일이 있을 경우 생성된 상시학습 번호로 변경
				if(fileCnt>0) {
					emAlwDao.update("EM.UPDATE_ATTACHMENT_OBJECT_ID", new Object[] {
							asSeq, objectType, param.get("objectid")
					}, new int[] {
							Types.NUMERIC, Types.NUMERIC, Types.NUMERIC
					});
				}
			}
			
			if(updateCnt>0) result = "Y";
			
		} catch(Exception e) {
			log.error(e);
			throw new EmServiceException(e);
		}
		
		return result;
	}
	

	
	/**
	 * 상시학습 취소
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = EmServiceException.class )
	public String updateAlwCancel(long companyid, long userid, int asSeq) throws EmServiceException {
		String result = "N";
		
		try {
			// 상시학습 정보 조회
			Map<String, Object> eduinfoMap = selectAlwDtl(companyid, userid, asSeq);
			
			if(eduinfoMap!=null) {
				// 취소 가능여부 판별
				if(eduinfoMap.get("CANCEL_YN").equals("Y")) {
					// 결재정보 유무 판별
					int reqNum = 0;
					// 결재번호가 있으면서 결재상태가 "0" 이 아닐경우 결재회수 처리
					if(eduinfoMap.get("REQ_NUM")!=null && !eduinfoMap.get("REQ_STS_CD").equals("0")) {
						reqNum = CommonUtils.stringToInt(eduinfoMap.get("REQ_NUM").toString(),0);
						
						// 결재정보가 있을 경우 결재 회수처리 후 교육신청 정보의 결재상태를 '0' 으로 변경
						emAlwDao.update("EM.UPDATE_ALW_REQ_WITHDRAW", new Object[] {
								userid,
								companyid, reqNum
						}, new int[] {
								Types.NUMERIC, 
								Types.NUMERIC, Types.NUMERIC
						});
					}
	
					// 교육신청정보 취소 처리
					int updateCnt = emAlwDao.update("EM.UPDATE_ALW_CANCEL", new Object[] {
						userid,	
						userid, asSeq, companyid
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
	
	/*
	 * 상시학습종류별 연간 인정시간 정보 조회
	 *  companyid 회사번호
	 *  seq 개설번호 or 상시학습번호
	 *  tUserid 사용자번호 
	 *  eduDiv 과정구분 1: 정규과정 , 2: 상시학습
	 *  yyyy 해당년도
	 *  recogTimeH 인정시간_시
	 *  recogTimeM 인정시간_분
	 *  alwStdCd 상시학습종류코드
	 */
	public List<Map<String,Object>> yearRecogList(long companyid, String seq, String tUserid, String eduDiv, String yyyy, String recogTimeH, String recogTimeM, String alwStdCd) throws CommonException{

		Map<String,Object> map = new HashMap<String, Object>();
		if(!seq.equals("")){
			//수정하는 경우 요청한 과정의 인정시간은 제외하여 결과리턴..
			if(eduDiv.equals("1")){
				//정규과정
				map.put("QUERY_WHERE_OPEN", " AND BSO.OPEN_NUM != "+seq);
				map.put("QUERY_WHERE_ALW", "");
			}else{
				//상시학습
				map.put("QUERY_WHERE_OPEN", "");
				map.put("QUERY_WHERE_ALW", " AND EAS.ALW_STD_SEQ != "+seq);
			}
		}else{
			//신규입력일 경우 제외되는 과정 없이 모든 과정의 결과 리턴..
			map.put("QUERY_WHERE_OPEN", "");
			map.put("QUERY_WHERE_ALW", "");
		}
		
    	List<Map<String,Object>> list = commonDao.dynamicQueryForList("EM.SELECT_YEAR_ALW_LIMIT_CHECK", 
    			new Object[]{ companyid, tUserid, yyyy, alwStdCd, companyid, tUserid, yyyy, alwStdCd, alwStdCd, recogTimeH, recogTimeM }, 
    			new int[]{ Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR, Types.VARCHAR}, 
    			map);
    	
    	return list;
	}
	
	/**
	 * 상시학습종류별 연간 인정시간 체크
	 * @throws CommonException 
	 */
	public String yearRecogLimitCheck(long companyid, Map<String,Object> param) throws CommonException{
		String result = "";

		String seq = param.get("asOpenSeq").toString();
		String tUserid = param.get("tUserid").toString();
		String eduDiv = param.get("eduDiv").toString();
		String yyyy = param.get("yyyy").toString();
		String recogTimeH = param.get("recogTimeH").toString();
		String recogTimeM = param.get("recogTimeM").toString();
		String alwStdCd = param.get("alwStdCd").toString();
		
		List<Map<String,Object>> list = yearRecogList(companyid, seq, tUserid, eduDiv, yyyy, recogTimeH, recogTimeM, alwStdCd);
		
    	if(list!=null && list.size()>0){
    		Map alwMap = (Map)list.get(0);
    		
    		String flag = alwMap.get("FLAG").toString();
    		if(flag.equals("N")){
    			result = alwMap.get("MSG")+"";
    		}
    	}
		return result;
	}
	
}
