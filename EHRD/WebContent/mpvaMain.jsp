<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="architecture.common.user.User"%>
<%@ page import="architecture.ee.web.util.ServletUtils"%>
<%@ page import="architecture.user.util.SecurityHelper"%>
<%
String path = ServletUtils.getServletPath(request);
User user = SecurityHelper.getUser();

if(user.isAnonymous()) {
	//response.sendRedirect(architecture.ee.web.util.ServletUtils.getContextPath(request) + "/accounts/sso/cnpLogin.do");
}
%>
<html decorator="main">
<head>
	<title></title>   
</head>
<body>
    
        <script type="text/javascript"> 
        var cnpAdm = <%= request.isUserInRole("ROLE_SYSTEM")%>;
        if(cnpAdm){
            location.href = "<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/admin/ca/ca_cmpt_main.do";
        }else{
            alert("총괄관리자 권한이 없습니다.");
            location.href = "<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/accounts/sso/cnpLogin.do";
        }
        
        </script>
        
</body>
</html>