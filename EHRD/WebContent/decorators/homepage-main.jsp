<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<title>
	<decorator:title default="" />
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- explorer버전을 pc의 최신버전으로 띄우도록 처리 -->
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="stylesheet" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/css/main_mpva.css" type="text/css" />
<link href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css" rel="stylesheet" />
<link href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css" rel="stylesheet" />
<link href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css" rel="stylesheet" />
<link href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.bootstrap.min.css" rel="stylesheet" />
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
<%-- <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js"></script> --%>
<%-- <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/jquery.easing.1.3.js"></script> --%>
<%-- <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/common.js"></script> --%>
<%-- <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js"></script> --%>
<%-- <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js"></script> --%>
<%-- <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js"></script> --%>
<%-- <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js"></script> --%>
    
<decorator:head />

<style>

	header {
	background-color: #2ba6cb;
	padding: 20px 0;
	}

	#mainContent {
	margin-top: 44px;
	margin-bottom: 22px;
	padding-bottom: 22px;
	border-bottom: 1px solid #eee;
	overflow: hidden;
	}
	
</style>
</head>
<body onload="<decorator:getProperty property="body.onload" />" class="<decorator:getProperty property="body.class" />">
	<decorator:body />
</body>
</html>