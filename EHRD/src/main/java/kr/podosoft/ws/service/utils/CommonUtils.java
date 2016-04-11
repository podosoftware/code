package kr.podosoft.ws.service.utils;

import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Locale;
import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.binary.Hex;

/**
 * 
 * 공통유틸리티 Class<br/>
 * 
 * @author sylee
 * @version 1.0
 * @since 2014. 4. 1.
 */
public class CommonUtils {

	//암호화 / 복호화 키
	private static String encKey= "mpva!@34" ;

	/**
	 * null 제거
	 * @param str
	 * @return
	 */
	public static String noNull(String str)
    {
        try
        {
        	if(str==null){
        		str = "";
        	}
            return str;
        }
        catch(Exception _ex)
        {
            return str;
        }
    }

	/**
	 * String -> int
	 * @param str
	 * @param defaultValue
	 * @return
	 */
	public static int stringToInt(String str, int defaultValue)
    {
        try
        {
            return Integer.parseInt(str);
        }
        catch(NumberFormatException _ex)
        {
            return defaultValue;
        }
    }


	/**
	 * request String 반환
	 * @param request
	 * @return
	 */
	public static String printParameter(HttpServletRequest request){
    	StringBuffer sb = new StringBuffer();
    	Enumeration e = request.getParameterNames();

    	sb.append("\n ==================== printParameter ====================");
    	while(e.hasMoreElements()) {
    	    String key   = (String)e.nextElement();
    	    String value = request.getParameter(key);
    	    sb.append("\n ==== "+key+ " : " + value+" ");
    	}
    	sb.append("\n ==================== printParameter ====================\n");

    	return sb.toString();
    }

		
	/**
	 * 
	 * AES 알고리즘을 적용하여 데이터를 암호화<br/>
	 *
	 * @param arg
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 1.
	 */
	public static String ASEEncoding(String originalString) throws Exception{
		byte[] seedB = encKey.getBytes();
		SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
		sr.setSeed(seedB);
		KeyGenerator kgen = KeyGenerator.getInstance("AES");
		kgen.init(128, sr); // 192 and 256 bits may not be available
		
		// Generate the secret key specs.
		SecretKey skey = kgen.generateKey();
		String keyString = Hex.encodeHexString(skey.getEncoded());
		SecretKeySpec skeySpec = new SecretKeySpec(skey.getEncoded(), "AES");
		
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
		
		byte[] encrypted = cipher.doFinal(originalString.getBytes());

		return Hex.encodeHexString(encrypted);
	}
	
	/**
	 * 
	 * AES 알고리즘을 적용하여 데이터를 복호화<br/>
	 *
	 * @param arg
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 1.
	 */
	public static String ASEDecoding(String encryptedString) throws Exception{
		byte[] seedB = encKey.getBytes();
		SecureRandom sr = SecureRandom.getInstance("SHA1PRNG");
		sr.setSeed(seedB);

		KeyGenerator kgen = KeyGenerator.getInstance("AES");
		kgen.init(128, sr); // 192 and 256 bits may not be available

		// Generate the secret key specs.
		SecretKey skey = kgen.generateKey();
		SecretKeySpec skeySpec = new SecretKeySpec(skey.getEncoded(), "AES");

		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.DECRYPT_MODE, skeySpec);
		byte[] decrypted = cipher.doFinal(Hex.decodeHex(encryptedString.toCharArray()));

	    return new String(decrypted);
	}
	
	/**
	 * 
	 * 비밀번호 암호화 - 복호화 되지 않음.<br/>
	 *
	 * @param passwd
	 * @return
	 * @throws Exception
	 * @since 2014. 4. 2.
	 */
	public static String passwdEncoding(String passwd) throws Exception{
		org.springframework.security.authentication.encoding.MessageDigestPasswordEncoder encoder = new org.springframework.security.authentication.encoding.MessageDigestPasswordEncoder("SHA-256");
		return encoder.encodePassword(passwd, "");
	}
	
	/**
	 * 
	 * 랜덤 문자 생성<br/>
	 * 
	 * @param length 랜덤문자의 자릿수
	 * @return
	 * @since 2014. 5. 29.
	 */
	public static String randomStr(int length) {
		Random rnd =new Random();

		StringBuffer buf =new StringBuffer();

		for(int i=0;i<length;i++){
		    if(rnd.nextBoolean()){
		        buf.append((char)((int)(rnd.nextInt(26))+97));
		    }else{
		        buf.append((rnd.nextInt(10))); 
		    }
		}
		return buf.toString();
	}
	
	/**
	 * 
	 * long 타입의 숫자인지 체크.<br/>
	 *
	 * @param s
	 * @return
	 * @since 2014. 8. 28.
	 */
	public static boolean isStringLong(String s) {
		try {
			Long.parseLong(s);
			return true;
		} catch (NumberFormatException e) {
			return false;
		}
	}
	
	/**
	 * 
	 * 숫자인지 체크.<br/>
	 *
	 * @param s
	 * @return
	 * @since 2014. 8. 28.
	 */
	public static boolean isNumber(String s) {
		try {
			Double.parseDouble(s);
			return true;
		} catch (NumberFormatException e) {
			return false;
		}
	}

	/**
	 * 
	 * 날짜 유효성 체크<br/>
	 *
	 * @param s
	 * @return
	 * @since 2014. 12. 3.
	 */
	public static boolean isDate(String s){
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.KOREA);
			sdf.setLenient(false); 
			sdf.parse(s);
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	/**
	 * 문자열 byte 길이 반환
	 * 한글2byte, 나머지 1byte로 계산
	 * @param s
	 * @return
	 */
	public static int stringSize(String s) {
		try {
			int byteSize = 0;
			
			
			
			return byteSize;
		} catch(Exception e) {
			return -1;
		}
	}
	
	/**
	 * 
	 * sso연동을 위한 쿠키값 조회..<br/>
	 *
	 * @param request
	 * @param cookieName
	 * @return
	 * @since 2015. 3. 3.
	 */
	public static String getCookieValue(HttpServletRequest request, String cookieName){
		Cookie[] cookies = request.getCookies();
		if(cookies != null){
			for(Cookie cookie : cookies){
				if(cookie.getName().equals(cookieName))
					return cookie.getValue();
			}
		}
		return null;
	}
	
}