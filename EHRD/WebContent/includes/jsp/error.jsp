<%@ page pageEncoding="UTF-8"  isErrorPage="true" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>                 
<%@ page import="architecture.common.exception.Codeable" %>
<%@ page import="architecture.common.util.I18nTextUtils" %>
<%@ page import="architecture.ee.util.OutputFormat" %>
<%@ page import="architecture.ee.web.util.WebApplicationHelper" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%@ page import="architecture.ee.web.struts2.util.ActionUtils" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
                 
	String formatString = ParamUtils.getParameter(request, "output", "html");
	OutputFormat format = OutputFormat.stingToOutputFormat(formatString);	
	Throwable ex = exception;	

	if( ex == null ){
		ex = (Throwable) request.getAttribute(org.springframework.security.web.WebAttributes.AUTHENTICATION_EXCEPTION );
	}
	
	if( ex == null ){
		ex = ActionUtils.getException();
	}
		
	int objectType = 1;
	int objectAttribute = 1 ;
	int errorCode = 0;
	Locale localeToUse = WebApplicationHelper.getLocale();
	
	String exceptionClassName = "";
	String exceptionMessage   = "";
		
	if( ex != null ){		
		if( ex  instanceof Codeable ){
			errorCode = ((Codeable)	ex).getErrorCode();				
		}
		exceptionClassName =  ex.getClass().getName();
		exceptionMessage = ex.getMessage() ;
	}
		
    if(format == OutputFormat.XML ){
    	response.setContentType("text/xml;charset=UTF-8");
%>
<?xml version="1.0" encoding="UTF-8"?>
<response>
    <error>
        <locale><%= localeToUse %></locale>
        <code><%= I18nTextUtils.generateResourceBundleKey(objectType, errorCode, objectAttribute ) %></code>
        <exception><%= exceptionClassName  %></exception>
        <message><%= exceptionMessage == null ? "" : exceptionMessage %></message>        
    </error>
</response>    	
<%    	
    } else if (format == OutputFormat.JSON ) {
    	response.setContentType("application/json;charset=UTF-8");
%>{"error":{ "locale" : "<%= localeToUse %>", "code": "<%= I18nTextUtils.generateResourceBundleKey(objectType, errorCode, objectAttribute ) %>", "exception" : "<%= exceptionClassName  %>", "message" : "<%= exceptionMessage == null ? "" : exceptionMessage %>" }}<%	
    } else if (format == OutputFormat.HTML ) { 
    	
%><html>
    <head> 
        <title>오류가 발생했습니다.</title>
    </head>
    <body>
      <%= errorCode %><p/>
      <%= exceptionMessage == null ? "오류가발생됨" : exceptionMessage %><p/>
      <%    
      if(ex != null){    	  
    	  StringWriter sout = new StringWriter();
          PrintWriter pout = new PrintWriter(sout);
          ex.printStackTrace(pout);
          response.flushBuffer();
          %>
          <pre>
          <%= sout.toString() %>
          </pre>
          <%    	  
      }
      %>
    </body>
</html>        
<%
    } 
%>    