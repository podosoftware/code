<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="architecture.common.user.User"%>
<%@ page import="architecture.ee.web.util.ServletUtils"%>
<%@ page import="architecture.user.util.SecurityHelper"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    if (request != null)
    {
    	response.sendRedirect(architecture.ee.web.util.ServletUtils.getContextPath(request) + "/accounts/sso/mpvaLogin.do");
    }

%>
<html>
	<head>
	   <meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title></title>
	</head>
</html>