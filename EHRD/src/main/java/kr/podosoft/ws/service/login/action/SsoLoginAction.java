package kr.podosoft.ws.service.login.action;

import java.sql.Types;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import kr.podosoft.ws.service.ba.BaService;
import kr.podosoft.ws.service.utils.AuthenticationHelper;
import kr.podosoft.ws.service.utils.CommonUtils;

import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import architecture.ee.web.struts2.action.support.FrameworkActionSupport;
import architecture.ee.web.util.ParamUtils;

import SafeSignOn.SSO;

public class SsoLoginAction extends FrameworkActionSupport {

	private static final long serialVersionUID = 906661958061483864L;

	private String ssoStuPersnlNbr;
	
	private static final String API_KEY = "368B184727E89AB69FAF";
	
	private String error = "";
	
	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	private BaService baSrv;
	
	public BaService getBaSrv() {
		return baSrv;
	}

	public void setBaSrv(BaService baSrv) {
		this.baSrv = baSrv;
	}
	
	
	public String loginPodo() throws Exception {
		log.info(this.getClass().getName());
		
		return success();
	}
	
	//로그인 전에 체크..
	public String loginchk() throws Exception {
		String output = ParamUtils.getParameter(request, "output");
		String dev = ParamUtils.getParameter(request, "dev", "N"); //개발용...
		
		List<Map<String,Object>> userList = null ;
		if(dev.equals("Y")){
			//개발서버용.. 로그인창의 아이디, 비번을 통해 로그인 체크..
			String empno = ParamUtils.getParameter(request, "empno"); 
			String passwd = ParamUtils.getParameter(request, "passwd");
			
			if(empno!=null && passwd!=null) {
				//개발서버용...
				
				userList = baSrv.queryForList("BA.SELECT_DEV_LOGIN_CHK_USER_LIST", 
						new Object[] {empno}, 
						new int[] {Types.VARCHAR});
			}else{
				error = "No data";
			}
		}else{
			//운영서버용.. ssotoken의 유효성을 통해 로그인 체크..
			String ssoToken = null;
			int ssoResult = 0;
			int ssoLastErr = 0;		
			String ssoLastErrMsg = null;
			SSO context = new SSO(API_KEY);
			//context.setHostName("was21.knu.ac.kr"); // 테스트 용
			
			ssoToken = CommonUtils.getCookieValue(request, "ssotoken");
			
			if ( ssoToken == null || ssoToken.length() < 1 ) {
				//쿠키값이 없으면 hi.knu.ac.kr 페이지에서 인증받도록 이동..
				//System.out.println("SSO Cookie not exist");

		        log.debug("### SSO Cookie not exist ");
		        
				error = "SSO Cookie not exist";
			} else {
				ssoResult = context.verifyToken(ssoToken, request.getRemoteAddr());
			    if ( ssoResult < 0 ) {
			    	//결과값이 없으면 hi.knu.ac.kr 페이지에서 인증받도록 이동..
			    	
			        ssoLastErr = context.getLastError();
			        ssoLastErrMsg = context.getLastErrorMsg();
			        
			        log.debug("#############sso error..... "+ssoLastErr + " : " + ssoLastErrMsg);
			    	error = ssoLastErr + " : " + ssoLastErrMsg;
			    } else {
			    	ssoStuPersnlNbr = context.getValue("USER_HRSSID"); //교직원번호 empno로 사용됨..
					
					userList = baSrv.queryForList("BA.SELECT_LOGIN_CHK_USER_LIST", 
							new Object[] {ssoStuPersnlNbr, 1}, 
							new int[] {Types.VARCHAR, Types.NUMERIC});
			    }
			}
		}
		
		//에러가 없으면... 정상적으로 사용자데이터 체크..
		if(error.isEmpty()){
			if(userList!=null && userList.size()>0) {
				String useflag = "";
				
				Map<String,Object> item = userList.get(0);
				
				//퇴사등으로 사용 못하도록 설정된 사용자의 접근 시도..
				useflag = item.get("USEFLAG")!=null? item.get("USEFLAG").toString() : "";
				
				if(useflag.equals("N")){
					error = "rejected user";
				}
			}else{
				error = "No user data";
			}
		}
		
		//log.debug("# empno : " +empno);
		//log.debug("# passwd : " + passwd);
		//log.debug("# output : " + output);
		log.debug("### error:"+error);
		
		return success();
	}
	
	public String login() throws Exception {
		String dev = ParamUtils.getParameter(request, "dev", "N"); //개발용...
		

		List<Map<String,Object>> userList = null ;
		if(dev.equals("Y")){
			//개발서버용.. 로그인창의 아이디, 비번을 통해 로그인 체크..
			String empno = ParamUtils.getParameter(request, "empno"); 
			String passwd = ParamUtils.getParameter(request, "passwd");
			
			if(empno!=null && passwd!=null) {
				//개발서버용...
				
				userList = baSrv.queryForList("BA.SELECT_DEV_LOGIN_CHK_USER_LIST", 
						new Object[] {empno}, 
						new int[] {Types.VARCHAR});
			}else{
				return LOGIN;
			}
		}else{
			//운영서버용.. ssotoken의 유효성을 통해 로그인 체크..
			String ssoToken = null;
			int ssoResult = 0;
			int ssoLastErr = 0;		
			String ssoLastErrMsg = null;
			SSO context = new SSO(API_KEY);
			//context.setHostName("was21.knu.ac.kr"); // 테스트 용
			
			ssoToken = CommonUtils.getCookieValue(request, "ssotoken");
			
			if ( ssoToken == null || ssoToken.length() < 1 ) {
				//쿠키값이 없으면 hi.knu.ac.kr 페이지에서 인증받도록 이동..
				//System.out.println("SSO Cookie not exist");

		        log.debug("#############ssoToken ==null ");
		        
				return LOGIN;
			} else {
				ssoResult = context.verifyToken(ssoToken, request.getRemoteAddr());
			    if ( ssoResult < 0 ) {
			    	//결과값이 없으면 hi.knu.ac.kr 페이지에서 인증받도록 이동..
			    	
			        ssoLastErr = context.getLastError();
			        ssoLastErrMsg = context.getLastErrorMsg();
			        
			        log.debug("#############sso error..... "+ssoLastErr + " : " + ssoLastErrMsg);
			    	return LOGIN;
			    } else {
			    	ssoStuPersnlNbr = context.getValue("USER_HRSSID"); //교직원번호 empno로 사용됨..
					
					userList = baSrv.queryForList("BA.SELECT_LOGIN_CHK_USER_LIST", 
							new Object[] {ssoStuPersnlNbr, 1}, 
							new int[] {Types.VARCHAR, Types.NUMERIC});
			    }
			}
		}
		
		if(userList!=null && userList.size()>0) {
			String useflag = "";
			String userid = "";
			String homeTheme = "";
			String userNm = "";
			
			Map<String,Object> item = userList.get(0);
			
			userid = item.get("USERID").toString();
			homeTheme = item.get("HOME_PG_TYPE").toString();
			userNm = item.get("NAME").toString();
			
			//퇴사등으로 사용 못하도록 설정된 사용자의 접근 시도..
			useflag = item.get("USEFLAG")!=null? item.get("USEFLAG").toString() : "";
			
			if(useflag.equals("N")){
				return LOGIN;
			}else{

				try {	
					SecurityContext sc = AuthenticationHelper.createSecurityContext(userid);
					AuthenticationHelper.saveSecurityContext(sc);
					
					HttpSession httpsession = request.getSession(true);
				    httpsession.setAttribute("SPRING_SECURITY_CONTEXT", sc);
				    httpsession.setAttribute("THEME", homeTheme);
				    httpsession.setAttribute("USER_NAME", userNm);
				    
				    // 최근접속일 업데이트
				    baSrv.update("BA.UPDATE_LAST_LOGIN_DATE", new Object[] {userid}, new int[] {Types.VARCHAR});
					
					return success();
					
				} catch(UsernameNotFoundException unfe) {
					log.error(unfe);
					
					return LOGIN;
				}
			}
		}else{
			return LOGIN;
		}
		
	}
	
	/**
	 * SSO LOGIN
	 * @param 학번/교원번호
	 * @return
	 * @throws Exception
	 */
	public String ssologin() throws Exception {
		
		log.info("Call sso login start");

		String type =  ParamUtils.getParameter(request, "type", "");

		String ssoToken = null;
		int ssoResult = 0;
		int ssoLastErr = 0;		
		String ssoLastErrMsg = null;
		SSO context = new SSO(API_KEY);
		//context.setHostName("was21.knu.ac.kr"); // 테스트 용
		
		ssoToken = CommonUtils.getCookieValue(request, "ssotoken");
		
		if ( ssoToken == null || ssoToken.length() < 1 ) {
			//쿠키값이 없으면 hi.knu.ac.kr 페이지에서 인증받도록 이동..
			//System.out.println("SSO Cookie not exist");

	        log.debug("#############ssoToken ==null ");
	        
			return LOGIN;
		} else {
			ssoResult = context.verifyToken(ssoToken, request.getRemoteAddr());
		    if ( ssoResult < 0 ) {
		    	//결과값이 없으면 hi.knu.ac.kr 페이지에서 인증받도록 이동..
		    	
		        ssoLastErr = context.getLastError();
		        ssoLastErrMsg = context.getLastErrorMsg();
		        
		        log.debug("#############sso error..... "+ssoLastErr + " : " + ssoLastErrMsg);
		    	return LOGIN;
		    } else {
		    	ssoStuPersnlNbr = context.getValue("USER_HRSSID"); //교직원번호 empno로 사용됨..

		        log.debug("############# ssoStuPersnlNbr: "+ssoStuPersnlNbr);
		        
				List<Map<String,Object>> userList = baSrv.queryForList("BA.SELECT_LOGIN_CHK_USER_LIST", 
						new Object[] {ssoStuPersnlNbr, 1}, 
						new int[] {Types.VARCHAR, Types.VARCHAR});
				
				//고객사 홈페이지 테마.
				String homeTheme = "";
				String userid = "";
				String userNm = "";
				if(!userList.isEmpty()) {
					for(Map<String,Object> item : userList) {
						userid = item.get("USERID").toString();
						homeTheme = item.get("HOME_PG_TYPE").toString();
						userNm = item.get("NAME").toString();
						
						break;
					}
					
					try {
						SecurityContext sc = AuthenticationHelper.createSecurityContext(userid);
						AuthenticationHelper.saveSecurityContext(sc);
						
						HttpSession httpsession = request.getSession(true);
					    httpsession.setAttribute("SPRING_SECURITY_CONTEXT", sc);
					    httpsession.setAttribute("THEME", homeTheme);
					    httpsession.setAttribute("USER_NAME", userNm);
					    
					    // 최근접속일 업데이트
					    baSrv.update("BA.UPDATE_LAST_LOGIN_DATE", new Object[] {userid}, new int[] {Types.VARCHAR});
						
					    //요청된 화면으로 이동..
					    if(type.equals("cmpt")){
					    	//역량진단
					    	return "cmpt";
					    }else if(type.equals("cdp")){
					    	//경력개발계획
					    	return "cdp";
					    }else if(type.equals("board")){
					    	//교육안내
					    	return "board";
					    }else if(type.equals("edu")){
					    	//교육신청
					    	return "edu";
					    }else{
					    	return success();
					    }
					} catch(UsernameNotFoundException unfe) {
						log.error(unfe);

						return LOGIN;
					}
				}else{
					return LOGIN;
				}
		    }
		}
	}
	
	
}
