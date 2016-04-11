<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="architecture.common.user.User"%>
<%@ page import="architecture.ee.web.util.ServletUtils"%>
<%@ page import="architecture.user.util.SecurityHelper"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    if (request != null)
    {
    	//경북대학교는 로그인페이지가 없이 sso처리됨.. 로컬또는 개발서버는 아래 주소를 사용함.
    	
    	//운영서버용...
    	//response.sendRedirect(request.getContextPath() + "/accounts/login.do");
        
    	//개발서버용..
    	response.sendRedirect(request.getContextPath() + "/accounts/sso/podo_login.do");
        
        return;
    }
%>

<html>
	<head>
	   <meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title></title>
	</head>
	<body>
		<strong><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/accounts/login.do">Click here!</a></strong> to go to System.
    </body>
</html>