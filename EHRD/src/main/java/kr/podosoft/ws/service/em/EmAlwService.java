package kr.podosoft.ws.service.em;

/**
 * 교육훈련 > 상시학습
 */

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.common.CommonException;

public interface EmAlwService {

	/* 상시학습 목록 조회 */
	public List<Map<String,Object>> selectAlwList(long companyid, long userid) throws EmServiceException;
	/* 상시학습 목록 조회(엑셀다운로드 용) */
	public List<Map<String,Object>> selectAlwListExcel(long companyid, long userid, int yyyy) throws EmServiceException;
	/* 상시학습 상세 */
	public Map<String,Object> selectAlwDtl(long companyid, long userid, int asSeq) throws EmServiceException;
	/* 상시학습 등록 */
	public String insertAlwInf(long companyid, long userid, Map<String,Object> param, List<Map<String,Object>> apprList) throws EmServiceException;
	/* 상시학습 취소 */
	public String updateAlwCancel(long companyid, long userid, int asSeq) throws EmServiceException;
	
	/**
	 * 
	 * 상시학습종류별 연간인정시간 정보 조회<br/><br/>
	 *
	 * @param companyid 회사번호
	 * @param seq 개설번호 or 상시학습번호
	 * @param tUserid 사용자번호 
	 * @param eduDiv 과정구분 1: 정규과정 , 2: 상시학습
	 * @param yyyy 해당년도
	 * @param recogTimeH 인정시간_시
	 * @param recogTimeM 인정시간_분
	 * @param alwStdCd 상시학습종류코드
	 * @return
	 * @throws CommonException
	 * @since 2015. 2. 11.
	 */
	public List<Map<String,Object>> yearRecogList(long companyid, String seq, String tUserid, String eduDiv, String yyyy, String recogTimeH, String recogTimeM, String alwStdCd) throws CommonException;
	
	/**
	 * 
	 * 상시학습종류별 연간인정시간 체크<br/>
	 *
	 * @param companyid
	 * @param param
	 * @return
	 * @throws CommonException
	 * @since 2015. 2. 11.
	 */
	public String yearRecogLimitCheck(long companyid, Map<String,Object> param) throws CommonException;
	
}
