<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}
%>

<html decorator="subpage">
<head>
<%

kr.podosoft.ws.service.ca.action.ajax.CAServiceAction action = (kr.podosoft.ws.service.ca.action.ajax.CAServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

List items = action.getItems();

Map runMap = new HashMap();
if(items!=null && items.size()>0){
	runMap = (Map)items.get(0);
	
}

List items2 = action.getItems2();

Map runMap2 = new HashMap();
if(items2!=null && items2.size()>0){
	runMap2 = (Map)items2.get(0);
	
}


String DVS_NAME = (String) runMap.get("DVS_NAME");
String NAME = (String) runMap.get("NAME");
String LEADERSHIP_NAME = (String) runMap.get("LEADERSHIP_NAME");
String EMAIL = (String) runMap.get("EMAIL");
String PHONE = (String) runMap.get("PHONE");

//String DVS_NAME2 = (String) runMap2.get("DVS_NAME2");
String NAME2 = (String) runMap2.get("NAME2");
String LEADERSHIP_NAME2 = (String) runMap2.get("LEADERSHIP_NAME2");
String EMAIL2 = (String) runMap2.get("EMAIL2");
String PHONE2 = (String) runMap2.get("PHONE2");

//1 번 리스트 null 처리
if(DVS_NAME == null){DVS_NAME = "";} if(NAME == null){NAME = "";} if(LEADERSHIP_NAME == null){LEADERSHIP_NAME = "";} if(EMAIL == null){EMAIL = "";} if(PHONE == null){PHONE = "";}
//2 번 리스트 null 처리
//if(DVS_NAME2 == null){DVS_NAME2 = "";} 
if(NAME2 == null){NAME2 = "";} if(LEADERSHIP_NAME2 == null){LEADERSHIP_NAME2 = "";} if(EMAIL2 == null){EMAIL2 = "";} if(PHONE2 == null){PHONE2 = "";}


%>


	<title>고객센터</title>
	</style>
	
	<script type="text/javascript">
	var companyId = "<%=action.getUser().getCompanyId()%>";
	</script>
	
	
	<script type="text/javascript">               
        yepnope([{
       	  load: [ 
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
       	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js', 
      	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js'
          ],
          complete: function() {
        	  kendo.culture("ko-KR"); 
        	  
          }
      }]);   
	</script>
	
	
</head>
<body>
<div id="wrap">
	<div id="contents">
		<!-- 헤더영역 -->
<!-- 		<div id="header"> -->
<%-- 			<div class="logo"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/top/logo01.gif" alt="경북대학교"/></div> --%>
<!-- 			<div class="gnb cs_gnb">기존의 대메뉴에 cs_gnb 클래스를 추가함 간격주고 폰트크기 및 링크 삽입 -->
<!-- 				<ul class="menu"> -->
<!-- 					<li class="c01"><a href="#"><span>역량평가</span></a></li> -->
<!-- 					<li class="c02"><a href="#"><span>성과평가</span></a></li> -->
<!-- 					<li class="c03"><a href="#"><span>게시판</span></a></li> -->
<!-- 					<li class="c04 on"><a href="#"><span>고객센터</span></a></li> -->
<!-- 				</ul> -->
<!-- 				<ul class="line"> -->
<!-- 					<li><a href="#">관리자</a></li> -->
<!-- 				</ul> -->
<!-- 			</div> -->
<!-- 		</div> -->
		<!-- 헤더영역 끝 -->
		<!-- 본문영역 -->
		<div id="content">
			<div class="cont_body">
				<div class="title">고객센터</div>
				<ol class="cscenter">
					<li class="mb50">
						<p class="tit"><span class="blind">01.</span>사내 역량 및 성과 제도가 궁금하십니까 ?</p>
						<p class="contact">문의처 : <%= DVS_NAME %>  <%= NAME %> <%= LEADERSHIP_NAME %> </p>
						<p class="info"><span class="email"><%=runMap.get("EMAIL") %></span><span class="tel ml22"><%= PHONE %></span></p>
					</li>
					<li>
						<p class="tit"><span class="blind">02.</span>서비스 이용 중 오류나 장애때문에 불편하십니까 ?</p>
						<p class="contact">문의처 :	경북대학교 <%=runMap2.get("NAME2") %> <%= LEADERSHIP_NAME2 %> </p>
						<p class="info"><span class="email"><%= EMAIL2 %></span><span class="tel ml22"><%= PHONE2 %>  </span><span class="time ml22">월 ~ 금(09~18시)</span></p>
					</li>
				</ol>
				
			</div>
			<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/>
		</div>
		<!-- 본문영역 끝 -->
		<!-- copyright -->
<!-- 		<div id="footer">COPYRIGHTⓒ 2014 CONSULTING. All RIGHTS RESERVED.</div> -->
		<!-- COPYRIGHT 끝 --> 
	</div>
	
</div>
</body>
</html>