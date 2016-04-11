
package kr.podosoft.ws.service.utils;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.security.core.userdetails.UserDetails;

import architecture.ee.util.ApplicationHelper;
import architecture.user.security.spring.userdetails.ExtendedUserDetailsService;

public class AuthenticationHelper {

	public static Authentication toAuthentication(String username){		
		ExtendedUserDetailsService detailsService = ApplicationHelper.getComponent(ExtendedUserDetailsService.class);
		UserDetails details = detailsService.loadUserByUsername(username);	
		UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(details, null, details.getAuthorities());
		return token;
	}
	
	public static SecurityContext  createSecurityContext( String username ){
		Authentication authentication = toAuthentication(username);		
		SecurityContextImpl context = new SecurityContextImpl ();
		context.setAuthentication(authentication);		
	    return context;
	}
	
	public static void saveSecurityContext( SecurityContext context ){
		SecurityContextHolder.setContext( context );
	}
	
	/**
	public static void forceAuthentication( String username, HttpServletRequest request, HttpServletResponse response ){
		Authentication authentication = toAuthentication(username);		
		SecurityContextImpl context = new SecurityContextImpl ();
		context.setAuthentication(authentication);		
	    HttpSession httpsession = request.getSession(true);
	    httpsession.setAttribute("SPRING_SECURITY_CONTEXT", context);
	}
	**/
}
