<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
%>
<%
//총괄관리자 권한 여부..
boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
//고객사운영자 권한 여부..
boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
//부서장 권한 여부..
boolean isManager = request.isUserInRole("ROLE_MANAGER");
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

%>

	<title>게시판</title>
	
	</style>
	
	<script type="text/javascript">
	
	var uId = "<%=action.getUser().getUserId()%>";
	var uComId = "<%=action.getUser().getCompanyId()%>";
	var adminRole = "<%=isSystem%>";
	var operatorRole = "<%=isOperator%>";
	var managerRole = "<%=isManager%>";
	
	   function buttonEvent(){
           
			
       		//cancel btn add click event
 	    $("#cencelBtn").click( function(){
         		kendo.bind( $(".tabular"),  null );
         		 
         		$("#cudMode").val()=="";
         		 
         		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
                $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
         	});
			
	   }
	
       function openwindow() {
    	    $("#grid").empty();
	       	$("#grid").kendoGrid({
	               dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"/service/ca/brd_list.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){	
	                       	return { };
	                       } 		
	                   },
	                   schema: {
	                    total: "totalItemCount",
	                   	data: "items",
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
	                   pageSize: 30, serverPaging: false, serverFiltering: false, serverSorting: false
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
	                       attributes:{"class":"table-cell", style:"text-align:left"} ,
	                       template: function (dataItem) {
	                           return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.BOARD_CODE+", "+dataItem.BOARD_NUM+");' >"+dataItem.BOARD_TITLE+"</a>";
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
	               filterable: true,
	               filterable: {
	           	      extra : false,
	           	      messages : {filter : "필터", clear : "초기화"},
	           	      operators : { 
	           	       string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
	           	       number : { eq : "같음", gte : "이상", lte : "이하"}
	           	      }
	           	     },
	           	  height: 600,
	           	  sortable: true,
	               pageable: true,
	               pageable: { pageSizes:false,  messages: { display: ' {1} / {2}' }  }
	               
	           });

	       }
       
       
       //게시물 상세 페이지로 이동
       function fn_detailView(brdCd, brdNum){
           $("#BOARD_CODE").val(brdCd);
           $("#BOARD_NUM").val(brdNum);
           document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_detail.do";
           document.frm.submit();

       }
       
       function filterData(brdCd){
           var gridDatasource = $("#grid").data('kendoGrid').dataSource;
           
           $("#BOARD_CODE").val(brdCd);
           
		   if(brdCd == 1){
	     	  if(adminRole == "true" || operatorRole == "true"){
	     		  $("#newBtn").show();
	     	  }else{
	     		  $("#newBtn").hide();
	     	  }
		   }else{
			   $("#newBtn").show();
		   }
		   
           if(brdCd==null || brdCd == ""){
               gridDatasource.filter({});
           }else{
               gridDatasource.filter({
                   "field":"BOARD_CODE",
                   "operator":"eq",
                   "value":brdCd
               });
           }
       }
		   
	</script>
	<script type="text/javascript">               
        yepnope([{
       	  load: [ 
                 'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
                 'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
                 '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
                 '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
                 '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
                 '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
          ],
          complete: function() {
        	  kendo.culture("ko-KR"); 
        	  

        	  // list call
        	  openwindow();
        	  
              $("#newBtn").click(function(){
                  document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_update.do";
                  document.frm.submit();
              });
              
              //탭 생성...
              var tabArr = [];
              tabArr[0] = "";
              var tabStrip = $("#tabstrip").kendoTabStrip({
              	select: function(e){
              		var x = e.item;
                    var index= $(x).index();
//               		alert($(e.item).index());
//               		alert(tabArr[index]);
              		filterData(tabArr[index]);
              	}
              }).data("kendoTabStrip");
              //var tabStrip = $("#tabstrip").kendoTabStrip().data("kendoTabStrip");
              tabStrip.append({
                  text:"공지사항"
              });
              tabStrip.append({
                  text:"자료실"
              });
        	  
              tabArr[0] = 1;
              tabArr[1] = 2;
              
              tabStrip.select(0);
          }
      }]);   


	</script>
</head>
<body>

	<form id="frm" name="frm"  method="post" >
	    <input type="hidden" name="BOARD_CODE" id="BOARD_CODE" />
	    <input type="hidden" name="BOARD_NUM" id="BOARD_NUM" />
	</form>
	
	<!-- START MAIN CONTNET -->
	
	
	<div id="content">
		<div class="cont_body">
			<div class="title">게시판</div>
<!-- 			<div class="table_tin"> -->
               
<!--             </div> -->
			<div class="table_zone">
			    <div id="tabstrip" style="border-style:none;"></div>
				<div id="grid" style="height:100%; "></div>
			</div>
			
			<div style="text-align:right; padding-top:10px;">
            	<button id="newBtn" class="k-button" >글쓰기</button>
            </div>
		</div>
<%-- 		<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/> --%>
	</div>

	<!-- END MAIN CONTENT  --> 	
	<footer>
  	</footer>
</body>
</html>