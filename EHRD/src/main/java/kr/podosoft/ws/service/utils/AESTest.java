package kr.podosoft.ws.service.utils;
import org.junit.Test;
  
public class AESTest { 
  
	private static String encString = "" ; 
	   
	 @Test 
	 public void testASEEncodeWithKey() throws Exception { 
		//암호화 / 복호화
		System.out.println(CommonUtils.ASEEncoding("01064277579"));
		System.out.println(CommonUtils.ASEEncoding("cpla_jsk@naver.com"));
		System.out.println(CommonUtils.ASEDecoding(CommonUtils.ASEEncoding("01000000000")));
		//System.out.println(CommonUtils.ASEDecoding("da1dc619360479b491d70ad92b0d97718d5a8b9597b9c1fef805999a14a610b1"));
		

		//패스워드 암호화 - 복호화 안됨. 함수 호출 시 인자는 ( 패스워드, 사용자 아이디 ) 를 사용
		org.springframework.security.authentication.encoding.MessageDigestPasswordEncoder encoder = new org.springframework.security.authentication.encoding.MessageDigestPasswordEncoder("SHA-256");
		System.out.println(encoder.encodePassword("1111", ""));
		
		System.out.println(CommonUtils.passwdEncoding("1"));
		
		
		System.out.println(CommonUtils.randomStr(8));
		
		
		System.out.println( CommonUtils.isDate("2014.04.30")+","+"2014.04.30".replace(".", "-"));
	 }
}