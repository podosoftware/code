package kr.podosoft.ws.service.common;

import java.util.Map;

public interface MailSenderService {

	/**
	 * 메일발송
	 * SMTP 메일서버를 사용
	 * @param subject 메일제목
	 * @param contents 메일내용(Map<String,String> key, value 로 mail 본문내용 구성)
	 * @param fromUser 보내는이
	 * @param toUserArr 받는이
	 * @param toCC 참조받는이 목록
	 * @param isLinkBtn 바로가기 링크유무
	 * @throws Exception
	 */
	public void mailSender(String subject, Map<String,String> contents, String fromUser, String toUser, String[] toCC, boolean isLinkBtn) throws Exception;
	
	/**
	 * 경북대학교 SMS 발송
	 * DB를 이용하여 발송
	 * @param subject		제목(생략가능)
	 * @param msg			메시지내용(최대 80byte)
	 * @param callBack		회신번호
	 * @param destInfo		수신자정보(이름^전화번호|이름^전화번호)
	 * @throws Exception
	 */
	public Map<String,Object> snedSms(String subject, String msg, String callBack, String destInfo) throws CommonException;
}
