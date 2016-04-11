<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}
kr.podosoft.ws.service.ca.action.ajax.CAServiceAction action = (kr.podosoft.ws.service.ca.action.ajax.CAServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

%>

<%
//총괄관리자 권한 여부..
boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
//고객사운영자 권한 여부..
boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
//부서장 권한 여부..
boolean isManager = request.isUserInRole("ROLE_MANAGER");

String brdType = request.getAttribute("BOARD_CODE")+"";

if ( brdType ==null || "".equals(brdType)){
	brdType = request.getParameter("BOARD_CODE");
}
String brdName="";
if("1".equals(brdType)){
	brdName = "공지사항";
}else if("2".equals(brdType)){
	brdName = "질문과 답변";
}else if("3".equals(brdType)){
	brdName = "교육안내";
}

//1.공지사항 /2.질문과답변/3.교육안내
boolean btnCheck = false;
if(("1".equals(brdType) || "3".equals(brdType))  && isSystem == true){ 
	btnCheck = true;
}else if ("2".equals(brdType)){ 
	btnCheck = true;
} 
%>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage">
<head>
<title></title>

<script type="text/javascript"> 
var brdType = "<%=brdType%>";
var uId = "<%=action.getUser().getUserId()%>";
var uComId = "<%=action.getUser().getCompanyId()%>";
var adminRole = "<%=isSystem%>";
var operatorRole = "<%=isOperator%>";
var managerRole = "<%=isManager%>";



yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.<%=theme%>.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
    ],
    complete: function() {
        kendo.culture("ko-KR"); 
        
        //로딩바 선언..
        loadingDefine();
        
        //게시판 리스트
        $("#grid").empty();
       	$("#grid").kendoGrid({
               dataSource: {
                   type: "json",
                   transport: {
                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_list.do?output=json", type:"POST" },
                       parameterMap: function (options, operation){	
	                       var sortField = "";
		                   var sortDir = "";
		                   if (options.sort && options.sort.length>0) {
		                   		sortField = options.sort[0].field;
		                   		sortDir = options.sort[0].dir;
		                   } 
		               	   return {
		               		BRD_CD : brdType,
	                       	startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter) 
	                       };
                       }
                   },
                   schema: {
                    total: "totalItemCount",
                   	data: "items3",
                       model: {
                           fields: {
                        	   BOARD_CODE : { type: "int" },
                        	   BOARD_NUM : { type: "int" },
                        	   BOARD_TITLE : { type: "string" },
                        	   BOARD_CONTENT : { type: "string" },
                        	   NAME : { type: "string" }
                           }
                       }
                   },
                   pageSize: 30, serverPaging: true, serverFiltering: true, serverSorting: true
               },
               columns: [
                   {
                       field:"ROWNUMBER",
                       title: "번호",
                       filterable: false,
					    width:50,
					    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    attributes:{"class":"table-cell", style:"text-align:center"} 
                   },
                   {
                       field: "BOARD_TITLE",
                       title: "제목",
					   width:260,
					   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                       attributes:{"class":"table-cell", style:"text-align:left; text-decoration: underline;"} ,
                       template: function (dataItem) {
                           return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.BOARD_CODE+", "+dataItem.BOARD_NUM+");' >"+dataItem.BOARD_TITLE+" ["+dataItem.REPCOUNT+"]</a>";
                       }
                   },
                   {
                       field: "CREATETIME",
                       title: "등록일",
                       width:100,
                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                       attributes:{"class":"table-cell", style:"text-align:center"} 
                   },
                   {
                       field: "NAME",
                       title: "등록자",
                       width:40,
                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                       attributes:{"class":"table-cell", style:"text-align:center"} 
                   },
                   {
                       field: "VIEW_CNT",
                       title: "조회수",
                       filterable: false,
                       width:40,
                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                       attributes:{"class":"table-cell", style:"text-align:center"} 
                   }
               ],
               height: 550,
               groupable: false,
               filterable:{
                   extra : false,
                   messages : {
                       filter : "필터",
                       clear : "초기화"
                   },
                   operators : {
                       string : {
                           contains : "포함",
                           startswith : "시작문자",
                           eq : "동일단어"
                       },
                       number : {
                           eq : "같음",
                           gte : "이상",
                           lte : "이하"
                       }
                   }
               },
               sortable: true,
               pageable : true,
               resizable: true,
               reorderable: true,
               selectable: "row",
               pageable : {
                   refresh : false,
                   pageSizes : [10,20,30],
                   buttonCount : 5
   	        	}
               
        });
       	//글쓰기
       	$("#newBtn").click(function(){
       		$("#BOARD_CODE").val(brdType);
       	    document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_update.do";
       	    document.frm.submit();
       	});
    }
}]);
</script>

<script type="text/javascript">
//게시물 상세 페이지로 이동
function fn_detailView(brdCd, brdNum){
      	    $("#BOARD_CODE").val(brdCd); //게시물 분류
      	    $("#BOARD_NUM").val(brdNum); //게시물 SEQ
      	    document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_detail.do";
    	    document.frm.submit();
    	    
   	       if (event.preventDefault) {
   	            event.preventDefault();
   	        } else {
   	            event.returnValue = false;
   	        }
}
</script>
     
    </head>
<body>
    <form id="frm" name="frm"  method="post" >
 		<input type="hidden" name="BOARD_CODE" id="BOARD_CODE" />
	    <input type="hidden" name="BOARD_NUM" id="BOARD_NUM" />
    </form>
    
    <div class="container">
		<div id="cont_body">
		 <div class="content">
			 <div class="top_cont">
				<h3 class="tit01"><%=brdName%></h3>
				<%-- <div class="point">
					※ <%=brdName%>의 내용을 수정 및 등록합니다.
				</div> --%>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>게시판&nbsp; &#62;</span>
					<span class="h"><%=brdName%> </span>
				</div><!--//location-->
			</div>
			 <div class="sub_cont">
			 	<div class="btn_right">
					<%if(btnCheck == true){ %>
							<a class="k-button wid90" href="#" id="newBtn" >글쓰기</a>
					<%} %>	
				</div><!--//btn_right-->
				<div id="splitter" style="width:1220px; height: 580px; border:none;" class="mt10 mb10">
					<div id="list_pane">
						<div id="grid"></div>
					</div>
					<!-- <div id="detail_pane">
						<div class="detail_Info"></div>
					</div> -->
				</div>
			 </div><!--//sub_cont-->
		 </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->
</body>
</html>