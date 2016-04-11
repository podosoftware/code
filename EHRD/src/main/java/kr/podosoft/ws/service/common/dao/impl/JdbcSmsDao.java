package kr.podosoft.ws.service.common.dao.impl;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;

import architecture.ee.jdbc.sqlquery.SqlQueryHelper;
import architecture.ee.spring.jdbc.support.SqlQueryDaoSupport;

import kr.podosoft.ws.service.common.dao.SmsDao;

public class JdbcSmsDao extends SqlQueryDaoSupport implements SmsDao {
	
	/**
	 * SMS메시지발송
	 * @param userid 관계자ID, varchar2
	 * @param cdrid 과금ID, varchar2
	 * @param scheduleType 발송시점구분(0:즉시, 1:예약), number
	 * @param subject 제목, varchar2
	 * @param smsMsg 발송메시지, varchar2, max 80byte 초과시 80byte단위로 분할 발송됨
	 * @param callbackUrl 회신자정보, varchar2(200)
	 * @param callBack 회신번호, varchar2(20)
	 * @param sendDate 발송희망시간(yyyyMMddHHmmss), varchar2(20)
	 * @param destCnt 수신자 수, number
	 * @param destInfo 착신자 정보(이름, 전화번호), text
	 *                 이름과 전화번호 사이구분자 : ^
	 *                 수신자와 수신자 사이 구분자 : |
	 * @throws Exception
	 */
	public int smsSender(String userid, String cdrid, int scheduleType, String subject, String smsMsg, 
			String callbackUrl, String callBack, String sendDate, int destCnt, String destInfo) {
		
		log.debug("## SmsDAO smsSender start..........");
		
		// 데이터소스를 이용해 프로시져 호출, 프로시져 으름을 직접입력 querymap 을 사용하지 않음
		//SimpleJdbcCall call = new SimpleJdbcCall(getDataSource()).withProcedureName("COMM.PA_COMM_UMS.PR_SEND_SMS");
		SimpleJdbcCall call = new SimpleJdbcCall(getDataSource()).withProcedureName("PR_SEND_SMS");
		log.debug("## SmsDAO SimpleJdbcCall addValue.....");
		// 프로시져에서 맵핑될 파라메터 셋팅
		SqlParameterSource in = new MapSqlParameterSource()
				.addValue("i_user_id", userid).addValue("i_cdr_id", cdrid).addValue("i_schedule_type", scheduleType).addValue("i_subject", subject).addValue("i_sms_msg", smsMsg)
				.addValue("i_callback_url", callbackUrl).addValue("i_send_date", sendDate).addValue("i_callback", callBack).addValue("i_dest_count", destCnt).addValue("i_dest_info", destInfo);
		// 프호시져 호출
		log.debug("## SmsDAO SimpleJdbcCall call.....");
		Map<String, Object> result = call.execute(in);

		Set<String> keyset = result.keySet();
		for(Iterator ite = keyset.iterator(); ite.hasNext();) {
			String key = (String)ite.next();
			log.debug("## result [" + key + "] :: " + result.get(key));
		}
		
		// 프로시져 결과 확인, 결과는 프로시져에 설정된 out 의 key 로 반환됨(대문자)
		if(result.get("O_ERRYN")!=null) {
			log.debug("## SmsDAO smsSender result :: " + result.get("O_ERRYN"));
		
			if(result.get("O_ERRYN").equals("Y") || result.get("O_ERRYN").equals("0")) {
				log.debug(result.get("O_ERRMSG"));
				return 1;
			} else {
				log.debug(result.get("O_ERRMSG"));
				return 0;
			}
		} else {
			return 0;
		}
	}
	
}