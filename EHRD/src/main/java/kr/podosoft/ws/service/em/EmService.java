package kr.podosoft.ws.service.em;

import java.util.List;
import java.util.Map;

public interface EmService {
	/* ****************** 교육훈련 > 나의강의실 ************************ */
	
	/* 나의 교육년도(최소,최대) */
	public Map<String,Object> selectMyEduYear(long companyid, long userid) throws EmServiceException;
	/* 필수 이수 현황 점수 조회 */
	public Map<String,List<Map<String,Object>>> selectMyReqEduScr(long companyid, long userid, int year) throws EmServiceException;
	/* 
	 * 학습현황 목록 조회 
	 * 보훈직무필수교육 목록 조회
	 */
	public List<Map<String,Object>> selectEduSttList(long companyid, long userid, int year, int type, String bdate) throws EmServiceException;
	/* 교육 상세정보 조회(일반교육) */
	public Map<String,Object> selectMyClassDtl(long companyid, long userid, int openNum) throws EmServiceException;
	/* 교육 상세정보 조회(상시학습) */
	public Map<String,Object> selectMyClassAlwDtl(long companyid, long userid, int openNum) throws EmServiceException;
	/* 교육 수강상태 취소처리 */
	public String updateEduCancel(long companyid, long userid, int openNum) throws EmServiceException;
	
	
}
