package kr.podosoft.ws.service.em;

import java.util.List;
import java.util.Map;

import kr.podosoft.ws.service.common.Filter;

public interface EmApplyService {
	/* ****************** 교육훈련 > 교육신청 ************************ */

	/* 나의 역량진단 목록 조회 */
	public List<Map<String,Object>> selectMyCamList(long companyid, long userid) throws EmServiceException;
	/* 나의 역량진단 결과정보 조회 */
	public List<Map<String,Object>> selectMyCarScrList(long companyid, long userid, int runNum) throws EmServiceException;
	/* 나의 경력개발계획 목록 조회 */
	public List<Map<String,Object>> selectMyCdpList(long companyid, long userid) throws EmServiceException;
	/* 역량진단 과정목록 조회(페이징) */
	public List<Map<String,Object>> selectMyCamSbjctOpenList(long companyid, long userid, int startIndex, int pageSize, Filter filter, 
			String sortField, String sortDir, int runNum, String fromDate, String toDate, 
			int cmpnumber ) throws EmServiceException;
	/* 경력개발계획 과정목록 조회(페이징) */
	public List<Map<String,Object>> selectMyCdpSbjctOpenList(long companyid, long userid, int startIndex, int pageSize, Filter filter, 
			String sortField, String sortDir, int runNum, String fromDate, String toDate ) throws EmServiceException;
	/* 일반신청 과정목록 조회(페이징) */
	public List<Map<String,Object>> selectSbjctOpenList(long companyid, long userid, int startIndex, int pageSize, Filter filter, 
			String sortField, String sortDir, String fromDate, String toDate ) throws EmServiceException;
	
	/* 과정정보 상세조회 */
	public Map<String,Object> selectSbjctOpenDtl(long companyid, long userid, int openNum) throws EmServiceException;
	/* 과정 신청 처리 */
	public String updateSbjctApply(long companyid, long userid, int openNum, List<Map<String,Object>> approvedList) throws EmServiceException;
}
