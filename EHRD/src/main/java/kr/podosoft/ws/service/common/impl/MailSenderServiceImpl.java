package kr.podosoft.ws.service.common.impl;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import kr.podosoft.ws.service.common.CommonException;
import kr.podosoft.ws.service.common.MailSenderService;
import kr.podosoft.ws.service.common.dao.SmsDao;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import architecture.common.util.StringUtils;
import architecture.ee.util.ApplicationHelper;

public class MailSenderServiceImpl implements MailSenderService {
	
	private Log log = LogFactory.getLog(getClass());
	
	// spring mail sender bean, commonSubsystemContext.xml
	private JavaMailSender mailSender;
	private SmsDao smsDao;

	public JavaMailSender getMailSender() {
		return mailSender;
	}
	public void setMailSender(JavaMailSender mailSender) {
		this.mailSender = mailSender;
	}

	public void setSmsDao(SmsDao smsDao) {
		this.smsDao = smsDao;
	}
	/**
	 * 메일발송
	 * @param subject 메일제목
	 * @param contents 메일내용(Map<String,String> key, value 로 mail 본문내용 구성)
	 * @param fromUser 보내는이
	 * @param toUserArr 받는이
	 * @param toCC 참조받는이 목록
	 * @param isLinkBtn 바로가기 링크유무
	 * @throws Exception
	 */
	public void mailSender(String subject, Map<String,String> contents, String fromUser, String toUser, String[] toCC, boolean isLinkBtn) throws Exception {
		
    	log.debug("mail sender ...........................................");
    	log.debug("mail subject  : " + subject);
    	log.debug("mail fromUser : " + fromUser);
    	log.debug("mail toUser   : " + toUser);
    	
        try {
        	mailSender = newMailSender();

            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            
            // 보내는이 주소
            helper.setFrom(new InternetAddress(fromUser, ""));
            // 받는이 주소
    		helper.setTo(new InternetAddress(toUser, ""));
    		
    		// 메일제목
    		helper.setSubject(subject);
            // 본문내용
    		helper.setText(getHtmlTemplate(contents, "EUC-KR", isLinkBtn), true);
    		
    		mailSender.send(message);

    		// 메일발송
            log.debug("mail send ................");

        } catch (MessagingException e) {
        	log.error(e);
        }
	}

	public static JavaMailSender newMailSender(){		
		JavaMailSenderImpl sender = new JavaMailSenderImpl();
		//sender.setHost("222.122.47.196"); // PODO MailSrv IP
		sender.setHost("155.230.11.8"); // 경북대 SMTP서버 IP
		Properties javaMailProperties = new Properties();
		javaMailProperties.put("mail.debug", "true");
		javaMailProperties.put("mail.smtp.auth", "false");
		sender.setJavaMailProperties(javaMailProperties);
		sender.setDefaultEncoding("UTF-8");
		sender.setPort(25);
		sender.setProtocol("smtp");		
		return sender;
	}
	
	/**
	 * MAIL 기본탬플릿 호출 및 인자값으로 내용 변환 
	 * @param item MAIL 기본탬플릿을 동적으로 변경할 키와 값
	 * @param encodingType MAIL 탬플릿 변환 인코딩타입
	 * @return
	 * @throws Exception
	 */
	private String getHtmlTemplate(Map<String,String> item, String encodingType, boolean isLinkBtn) throws Exception {
		String html = "";
		
		String templatePath = ApplicationHelper.getRepository().getFile("template/mail").getPath();
		log.info("PATH :: " + templatePath);
		
		String fileNm = "";
		if(isLinkBtn) {
			fileNm = "/mail2.html";
		} else {
			fileNm = "/mail.html";
		}

		File file = new File(templatePath + fileNm);
		
		if(file.isFile()) {
			log.debug(" template file get ...... ");
			
			RandomAccessFile raf = null;
			StringBuffer sb = new StringBuffer();
			try {
				log.debug(" template file read ...... ");
				
				raf = new RandomAccessFile(file, "r");
				raf.seek(0);
				
				String lineData = "";
				while( (lineData = raf.readLine()) != null ) {
					sb.append(lineData);
				}
				
				raf.close();
				
				html = new String(sb.toString().getBytes(encodingType));
				
				/* 변환
				 * key 는 StringType 으로 구성
				 * tag 는 ${key} 로 구성
				*/
				if(item!=null && html!=null && !html.equals("")) {
					String key = "";
					String tag = "";
					String value = "";
					
					for( Iterator itr = item.keySet().iterator(); itr.hasNext(); ) {
						key = (String)itr.next();
						tag = "${"+key+"}";
						value = item.get(key);
						
						html = StringUtils.replace(html, tag, value);
					}
				}
				
			} catch(IOException ioe) {
				log.error(ioe);
			} catch (Exception e) {
				log.error(e);
			}
		}
		
		return html;
	}
	
	
	/**
	 * 경북대학교 SMS 발송
	 * DB를 이용하여 발송
	 * @param subject		제목(생략가능)
	 * @param smsMsg		메시지내용(최대 80byte)
	 * @param destInfo		수신자정보(이름^전화번호|이름^전화번호)
	 * @throws Exception
	 */
	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW, rollbackFor = CommonException.class )
	public Map<String,Object> snedSms(String subject, String smsMsg, String callBack, String destInfo) throws CommonException {
		Map<String,Object> rsltMap = new HashMap<String, Object>();
		boolean chk = true;
		int result = 0;
		// 값체크
		StringBuffer sb = new StringBuffer();
		if(destInfo==null || destInfo.equals("")) {
			sb.append("수시자 정보가 없습니다.");
			chk = false;
		}
		log.debug("#### smsMsg :: " + smsMsg);
		//if(msg==null || msg.equals("") || msg.getBytes().length>80) {
		if(smsMsg==null || smsMsg.trim().equals("")) {
			log.debug("#### msg size :: " + smsMsg.getBytes().length);
			//sb.append("메시지 내용이 없거나 80byte를 초과하였습니다.");
			sb.append("메시지 내용이 없습니다.");
			chk = false;
		}
		
		log.debug("#### snedSms chk :: " + chk);
		
		if(chk) {
			String userid		= "knuparking"; // SMS발송자ID(변경불가)
			String cdrid		= "knuparking";	// SMS과금ID(변경불가)
			int scheduleType	= 0; // 발송시점(0:즉시,1:예약)
			String sendDate		= ""; // 발송시간(scheduleType 이 1이면 필수입력, yyyymmddhh24miss)
			String callbackUrl	= ""; // 전송된 URL, 통화버튼을  누르면  해당 URL로  접속한다(생략가능 )
			int destCnt			= 1; // 수신자 수(단체전송이 가능하나 오류확인을 위해 명단위로 분할)
			//String errYn		= null;
			//String errMsg		= null;
			
			// 현재 시간 추출
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA);
			Date currentTime = new Date();
			sendDate = formatter.format(currentTime);
			
			String[] destInfArr = destInfo.split("[|]");
			if(destInfArr!=null && destInfArr.length>0) {
				// 타계정에 있는 프로시져를 Call 하는 거라 batch 사용 안함
				for(int i=0; i<destInfArr.length; i++) {
					if(destInfArr[i]!=null && 
					   !destInfArr[i].equals("") && 
					   destInfArr[i].split("\\^").length==2
					) {
						log.debug("#### smsSender CALL ");
						result += smsDao.smsSender(userid, cdrid, scheduleType, subject, smsMsg, 
								callbackUrl, callBack, sendDate, destCnt, destInfArr[i]);
						log.debug("#### result :: " + result);
					}
				}
			} else {
				sb.append("수신자 정보가 올바르지 않습니다.");
			}
		}
		
		rsltMap.put("RESULT", result);
		rsltMap.put("ERROR", sb.toString());

		return rsltMap;
	}
	
	
	
	
	
}
