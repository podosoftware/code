<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="architecture.common.user.User" %>
<%@ page import="architecture.user.util.SecurityHelper"%>
<%
String companyid = "";

User user = SecurityHelper.getUser();       

//메뉴 selected 처리
String menuStr = architecture.ee.web.util.ServletUtils.getServletPath(request);
int oNum = -1;
int tNum = -1;
if(menuStr.indexOf("/operator/ca/ca_cmpt_operator_main")>-1){ //역량진단관리>역량관리
    oNum = 0;
    tNum = 0;
}else if(menuStr.indexOf("/operator/ca/ca_operator_indc_main")>-1){ //역량진단관리>행동지표관리
    oNum = 0;
    tNum = 1;
}else if(menuStr.indexOf("/operator/ba/ba_job_admin_main")>-1){ //역량진단관리>직무관리
    oNum = 0;
    tNum = 2;
}else if(menuStr.indexOf("/operator/ba/ba_ldr_admin_main")>-1){ //역량진단관리>계층관리
    oNum = 0;
    tNum = 3;
}else if(menuStr.indexOf("/operator/ca/ca_cmpt_admin_main")>-1){ //진단&CDP 실시관리>실시관리
    oNum = 1;
    tNum = 0;
}else if(menuStr.indexOf("/operator/ca/ca_cmpt_object_main")>-1){ //진단&CDP 실시관리>대상자관리
    oNum = 1;
    tNum = 1;
}else if(menuStr.indexOf("/operator/ca/ca_cmpt_direction_main")>-1){ //진단&CDP 실시관리>방향설정
    oNum = 1;
    tNum = 2;
}else if(menuStr.indexOf("/operator/sbjct/ba-cource-main")>-1){ //교육관리>과정관리
    oNum = 2;
    tNum = 0;
}else if(menuStr.indexOf("/operator/sbjct/ba-cource-open-main")>-1){ //교육관리>차시관리
    oNum = 2;
    tNum = 1;
}else if(menuStr.indexOf("/operator/sbjct/ba-cource-open-run-main")>-1){ //교육관리>운영관리
    oNum = 2;
    tNum = 2;
}else if(menuStr.indexOf("/operator/sbjct/ba-recog-base-mgmt-main")>-1){ //교육관리>교육이수기준관리
    oNum = 2;
    tNum = 3;
}else if(menuStr.indexOf("/operator/cdp/core_person_manage_list_pg")>-1){ //교육관리>핵심인재관리
    oNum = 2;
    tNum = 4;
}else if(menuStr.indexOf("/operator/ca/core_cmpt_edu_manage_main")>-1){ //교육관리>핵심역량교육실적관리
    oNum = 2;
    tNum = 5;
}else if(menuStr.indexOf("/operator/baUser/user-main")>-1){ //공통>사용자관리
    oNum = 3;
    tNum = 0;
}else if(menuStr.indexOf("/operator/ba/ba-dept-main")>-1){ //공통>조직관리
    oNum = 3;
    tNum = 1;
}else if(menuStr.indexOf("/operator/ba/ba-main")>-1){ //공통>공통코드관리
    oNum = 3; 
    tNum = 2;
}else if(menuStr.indexOf("/operator/ba/ba-sync-main")>-1){ //공통>동기화관리
    oNum = 3; 
    tNum = 3;
}else{
	oNum = -1;
    tNum = -1;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><decorator:title default="경북대학교" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<!-- explorer버전을 pc의 최신버전으로 띄우도록 처리 -->
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta http-equiv="Pragma" content="no-cache">
		<meta http-equiv="Expires" content="-1">
		<link rel="stylesheet" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/css/sub.css" type="text/css" />
		<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
		<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/js/jquery-1.8.1.min.js"></script>
		<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/js/gnb.js"></script>
        <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.js"></script>
		<decorator:head />
		
		<script type="text/javascript">
		
		//로딩바
		var winElement = this;

        function logout(){
            if(confirm("로그아웃하시겠습니까?")){
                document.logout.submit();
            }
        }
        
        function sessionout(){
            document.logout.submit();
        }
        
        //로딩바 정의
        function loadingDefine(){
        	//로딩바윈도우
            if( !$("#loading-window").data("kendoWindow") ){
            	winElement = $("#loading-window").kendoWindow({
                    width:"215px",
                    height:"73px",
                    minHeight:"60px",
                    resizable : false,
                    title : false,
                    modal: true,
                    visible: false
                });
                
                winElement.animation = { open: { effects: "fadeIn"  }, close: { effects: "fadeIn", reverse: true} };
                winElement.css("overflow", "hidden");
            }
        }
        
        //로딩바 생성...
      function loadingOpen(){
          $("#loading-window").data("kendoWindow").center();
          $("#loading-window").data("kendoWindow").open();
          winElement.append(loadingElement());
      }
      //로딩바 제거..
      function loadingClose(){
          winElement.find(".k-loading-mask").remove();
          $("#loading-window").data("kendoWindow").close();
      }

      //로딩바 
      function loadingElement() {
    	  return $("<img class=\"k-loading-mask\" src=\"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/loading.gif\" />");
      }
      
        </script>
	</head>
	<body onload="<decorator:getProperty property="body.onload" />">
	<form id="logout" name="logout" method="POST"  action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/logout"></form>
	<input type="hidden" class="oneNum" id="oneNum" value="<%=oNum%>"/>
	<input type="hidden" class="twoNum" id="twoNum" value="<%=tNum%>"/>
	<div id="wrap">
	   <div id="contents" style="height: 100%;">
        <!-- 헤더영역 -->
        <div id="header">
            <div style="position: absolute; z-index: 20; padding-top: 5px; padding-left: 34px; white-space: nowrap; z-index: 20; ">
				<div class="logo01">
					<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/main.do"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/images/top/logo01.png" style="max-height:40px;" alt="경북대학교"/></a>
				</div>
			</div>
            <div class="login_group"><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/main.do">사용자</a>    <a href="javascript:logout(); ">로그아웃</a></div>
            <div class="gnb_area">
                <div class="gnbDivNew">
                    <div class="gnbNew">
                        <ul>
                            <li class="">
                                <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_operator_main.do" class="depthOne">역량진단관리</a>
                                <div class="depthTwo" style="left:0;">
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_operator_main.do" class="" menucode="MF0101">역량관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_indc_main.do" menucode="MF0102">행동지표관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_admin_main.do" class="" menucode="MF0103">직무관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_ldr_admin_main.do" menucode="MF0104">계급관리</a>
                                </div>
                            </li>
                            <li class="">
                                <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_admin_main.do" class="depthOne">진단&CDP 실시관리</a>
                                <div class="depthTwo" style="left:0px;">
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_admin_main.do" class="" menucode="MF0201">실시관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_object_main.do" class="" menucode="MF0202">대상자관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_direction_main.do" menucode="MF0203">방향설정</a>
                                </div>
                            </li>
                            <li class="">
                                <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/ba-cource-main.do" class="depthOne">교육관리</a>
                                <div class="depthTwo" style="left:0px;">
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/ba-cource-main.do" class="" menucode="MF0301">과정관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/ba-cource-open-main.do" menucode="MF0302">차시관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/ba-cource-open-run-main.do" menucode="MF0303">운영관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/ba-recog-base-mgmt-main.do" menucode="MF0304">교육이수기준관리</a>
                                    <!--<span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/cdp/core_person_manage_list_pg.do" menucode="MF0305">핵심인재관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/core_cmpt_edu_manage_main.do" menucode="MF0306">핵심역량교육실적관리</a>
                                    -->
                                </div>
                            </li>
                            <li class="">
                                <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/user-main.do" class="depthOne">공통</a>
<%--                                 <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_admin_main.do" class="depthOne">공통</a> --%>
                                <div class="depthTwo"  style="left:-180px;">
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/user-main.do" menucode="MF1401">사용자관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-dept-main.do" menucode="MF1402">조직관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-main.do" menucode="MF1403">공통코드관리</a>
                                    <span>|</span>
                                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-sync-main.do" menucode="MF1404">동기화관리</a>
                                </div>
                            </li>
                            
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <!-- 헤더영역 끝 -->
        <!-- 본문영역 -->
        <decorator:body />
        <!-- 본문영역 끝 -->
        
        <!-- 로딩바 -->
        <div id="loading-window" style="display:none; overflow:hidden;"></div>

        <!-- copyright 
        <div id="footer">COPYRIGHTⓒ 2014 경북대학교. All RIGHTS RESERVED.</div>
        COPYRIGHT 끝 --> 
       </div>
   </div>	
	</body>
</html>