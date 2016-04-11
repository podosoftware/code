<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<title>
	<decorator:title default="HRD" />
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="stylesheet" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/yui/cssreset/cssreset.css" type="text/css">
<link rel="stylesheet" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/yui/cssfonts/cssfonts.css" type="text/css">
<link rel="stylesheet" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/yui/cssgrids/cssgrids.css" type="text/css">

<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/common/common.ui.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css" />
<link  rel="stylesheet" type="text/css"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css" />

<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>

<decorator:head />

<style>

    #doc {
        margin: auto; /* center in viewport */
        width: 960px;
    }
    
	.yui3-g .main-title {
		    border: 0px;
		    margin-bottom:10px;
		    height: 100px;
		    color: #ffffff;
		    background-color: #00aba9;
		}    
	    
	.yui3-g .content {
	    border: 0px solid #000;
	   /*  margin-right:10px;  "column" gutters */
	    padding: 1em;
	}    
    
</style>

</head>
<body>

	<decorator:body />	
    
</body>
</html>