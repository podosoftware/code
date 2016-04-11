<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<title>
	<decorator:title default="경북대학교" />
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<!-- <link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/yui/cssfonts/cssfonts-min.css" />-->
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/yui/cssgrids/cssgrids.css" />
<!-- <link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/yui/cssreset/cssreset-min.css" />-->
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common/common.ui.css" />
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
<decorator:head />
<style>

    #doc {
        margin: auto; /* center in viewport */
        width: 960px;
    }
    
	.yui3-g .main-title {
		    border: 0px;
		    margin: 0px;
		    padding: 0px;
		    height: 80px;
		    color: #ffffff;
		    background-color: #00aba9;
		}    
		
	/* YUI Extention */
	    
	.yui3-g .content {
		padding-top: 5px;
		padding-left: 5px;
		padding-right: 5px;
		padding-bottom: 0px;
		margin: 0px; 
	}    
</style>
</head>
<body onload="<decorator:getProperty property="body.onload" />" class="<decorator:getProperty property="body.class" />">
	<decorator:body />
</body>
</html>