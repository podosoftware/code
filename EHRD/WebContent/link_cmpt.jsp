<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="architecture.common.user.User"%>
<%@ page import="architecture.ee.web.util.ServletUtils"%>
<%@ page import="architecture.user.util.SecurityHelper"%>
<%
String path = ServletUtils.getServletPath(request);
User user = SecurityHelper.getUser();
%>
<html decorator="main">
<head>
    <title></title>   
</head>
<body>
    <script>
<% 
    if(user.isAnonymous()) {
           out.println("location.href=\""+architecture.ee.web.util.ServletUtils.getContextPath(request)+"/accounts/login.do\";");
    }else{
           out.println("location.href=\""+architecture.ee.web.util.ServletUtils.getContextPath(request)+"/service/cam/cmpt_evl_run_pg.do\";");
    }
%>
    </script>
</body>
</html>