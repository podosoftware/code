package kr.podosoft.ws.service.common.dao;

public interface SmsDao {
	
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
			String callbackUrl, String callBack, String sendDate, int destCnt, String destInfo);
}