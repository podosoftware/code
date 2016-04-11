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

Object BOARD_TITLE = runMap.get("BOARD_TITLE");

String BOARD_CONTENT = (String) runMap.get("BOARD_CONTENT");

BOARD_CONTENT = BOARD_CONTENT.replaceAll("\r\n", "<br>");

%>
	<title>게시판</title>

	
	<script type="text/javascript">
	var uId = "<%=action.getUser().getUserId()%>";
	var uComId = "<%=action.getUser().getCompanyId()%>";
	var brdCd = "<%=request.getParameter("BOARD_CODE")%>";
	var brdNum = "<%=request.getParameter("BOARD_NUM")%>";
	var adminRole = "<%=isSystem%>";
	var operatorRole = "<%=isOperator%>";
	var managerRole = "<%=isManager%>";
	
	
    function fn_comDel(repNum){
 			var isDel = confirm("코맨트를 삭제 하시겠습니까?");
		 	 if(isDel){
		          		
		          		$.ajax({
		          			type : 'POST',
		  					url:"/service/ca/brd_coment_del.do?output=json",
		  					data : { REPLY_NUM : repNum, BRD_CD : brdCd, BOARD_NUM : brdNum },
		  					complete : function( response ){
		  						var obj  = eval("(" + response.responseText + ")");
		  						if(obj.saveCount != 0){
		  							openwindow();		
		  							alert("삭제되었습니다.");	
		  						}else{
		  							alert("저장에 실패 하였습니다.");
		  						}							
		  					},
		  					error: function( xhr, ajaxOptions, thrownError){								
		  					},
		  					dataType : "json"
		  				});		
		 	}
        	
     }
	
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
	                       read: { url:"/service/ca/brd_coment.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){	
	                       	return { BRD_CD : brdCd, BOARD_NUM : brdNum };
	                       } 		
	                   },
	                   schema: {
	                    total: "totalItemCount",
	                   	data: "items",
	                       model: {
	                           fields: {
	                        	   BOARD_CODE : { type: "int" },
	                        	   BOARD_NUM : { type: "int" },
	                        	   REPLY_NUM : { type: "int" },
	                        	   BOARD_TITLE : { type: "string" },
	                        	   REPLY_CONTENT : { type: "string" },
	                        	   CREATER : { type: "string" }
	                           }
	                       }
	                   },
	                   pageSize: 30, serverPaging: false, serverFiltering: false, serverSorting: false
	               },
	               columns: [
	                   {
	                       field:"REPLY_NUM",
	                       title: "번호",
	                       filterable: true,
						    width:50,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },
	                   {
	                       field: "REPLY_CONTENT",
	                       title: "코멘트",
						   width:260,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:left"}
	                   },
	                   {
	                       field: "CREATETIME",
	                       title: "등록일",
	                       width:80,
	                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },
	                   {
	                       field: "NAME",
	                       title: "등록자",
	                       width:50,
	                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },
	                   {
	                       field: "",
	                       title: "삭제",
	                       width:40,
	                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:center"},
	                       template: function (dataItem) {
	                    	  if(dataItem.CREATER == uId || adminRole == "true" || operatorRole =="true" ){
	                          	return "<input type='button' class='k-button' style='width:45' value='삭제' onclick='fn_comDel("+dataItem.REPLY_NUM+");'/>";
	                    	  }else{
	                    		return "";
	                    	  }
		                   }
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
	           	  height: 200,
	           	  sortable: true,
	               pageable: true,
	               pageable: { pageSizes:false,  messages: { display: ' {1} / {2}' }  },

	               
	           });

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
        	  
        	  /*
              @@@ 첨부파일 세팅 방법 @@@
              object_type = 2 (고정된 값)
              object_id 값은 해당 업무 테이블의 pk가 unique하다면 해당컬럼의 값으로 처리해도됨. 그렇지 않다면 pk의 조합으로 처리해야함.
              
              object_id = 회사번호+실시번호+평가대상자+지표번호
                 예 ) 회사번호 1, 실시번호 7, 평가대상자 1500, 지표번호 10 => 17150010
                 
              */
              var objectType = 2 ;
              $("#objectId").val(brdNum);
              
              if( !$("#my-file-gird").data('kendoGrid') ) {
                  $("#my-file-gird").kendoGrid({
                      dataSource: {
                          type: 'json',
                          transport: {
                              read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json', type: 'POST' },      
                              destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
                              parameterMap: function (options, operation){
                                  if (operation != "read" && options) {                                                                                                                           
                                      return { objectType: objectType, objectId:$("#objectId").val(), attachmentId :options.attachmentId };                                                                   
                                  }else{
                                       return { objectType: objectType, objectId:$("#objectId").val(), startIndex: options.skip, pageSize: options.pageSize };
                                  }
                              }
                          },
                          schema: {
                              model: Attachment,
                              data : "targetAttachments"
                          },
                      },
                      pageable: false,
                      height: 200,
                      selectable: false,
                      columns: [
                          { 
                              field: "name", 
                              title: "파일",  
                              width: "320px" , 
                              template: '#= name #' 
                         },
                          //{ field: "contentType", title:"contentType", width: "100px" },
                          { 
                              field: "size",
                              title: "크기(byte))", 
                              format: "{0:##,###}", 
                              width: "100px" 
                          },
                          { 
                              width: "160px" , 
                              template: function(dataItem){
                              	return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>'
                                 
                              } 
                          }
                      ]
                  });
              }else{
                  $("#my-file-gird").data('kendoGrid').dataSource.read(); 
              }
              
        	  
        	  if(brdCd ==1){
	        	  //수정,삭제 메뉴 제어(로그인한 유저아이디와 권한에 따라서 show, hide)
	        	  if(adminRole == "true" && <%=runMap.get("CREATER") %> == uId || operatorRole =="true" && <%=runMap.get("CREATER") %> == uId){
	        		  $("#newBtn").show();
	        		  $("#delBtn").show();
	        	  }else{
	        		  $("#updateBtn").hide();
	        		  $("#delBtn").hide();
	        	  }
        	  }else if(brdCd ==2){
        		  if(adminRole == "true" || operatorRole =="true" || <%=runMap.get("CREATER") %> == uId){
	        		  $("#newBtn").show();
	        		  $("#delBtn").show();
	        	  }else{
	        		  $("#updateBtn").hide();
	        		  $("#delBtn").hide();
	        	  }
        	  }
        	  // list call
        	  openwindow();
    			
      		//save btn add click event
           	  $("#repSave").click( function(){
           			var isDel = confirm("코멘트를 등록하시겠습니까?");
    				 	 if(isDel){
    	             		if($("#repVal").val()=="") {
    	             			alert("코멘트 내용을 입력해 주세요");
    	             			return false;
    	             		}	   
    	             		
    	             		$.ajax({
    	             			type : 'POST',
    	     					url:"/service/ca/brd_coment_save.do?output=json",
    	     					data : { REPLY_CONTENT : $("#repVal").val(), BRD_CD : brdCd, BOARD_NUM : brdNum },
    	     					complete : function( response ){
    	     						var obj  = eval("(" + response.responseText + ")");
    	     						if(obj.saveCount != 0){
    	     							openwindow();		
    	     							alert("저장되었습니다.");	
    	     						}else{
    	     							alert("저장에 실패 하였습니다.");
    	     						}							
    	     					},
    	     					error: function( xhr, ajaxOptions, thrownError){								
    	     					},
    	     					dataType : "json"
    	     				});		
    				 	}
              	});
        	  
              $("#listBtn").click(function(){
                  document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_main.do";
                  document.frm.submit();
              });
              
              $("#updateBtn").click(function(){
                  $("#BOARD_CODE").val(brdCd);
                  $("#BOARD_NUM").val(brdNum);
                  document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_update.do";
                  document.frm.submit();
              });

          }
      }]);   


	</script>
</head>
<body>

	<form id="frm" name="frm"  method="post" >
	    <input type="hidden" name="BOARD_CODE" id="BOARD_CODE" />
	    <input type="hidden" name="BOARD_NUM" id="BOARD_NUM" />
	    <input type="hidden" name="objectId" id="objectId" />
	</form>
	
	<!-- START MAIN CONTNET -->
	
	
	<div id="content">
		<div class="cont_body" >
			<div class="title">게시판</div>
<!-- 			<div class="table_tin"> -->
               
<!--             </div> -->
            <div class="layer_cont">
                <div class="layer_text">
                    <div class="sub_title01" style="border-bottom:1px solid #222222;"><span>제목 :</span> <%=runMap.get("BOARD_TITLE") %></div>
                    <div class="sub_title01">내용</div>
                    <div class="middle01">
                    <table><tr><td><font size=2><%=BOARD_CONTENT.replaceAll("&lt;", "<").replaceAll("&gt;", ">")%></font>
                    </td></tr></table>
                    
                    </div>
                    <div class="text_table"><div id="grid" style="height:100%; "></div></div>
                    <div style="padding-top:10px;">
                    	코멘트 : <input type="text" id="repVal" style="width:930px;"  />
                    	<button  id="repSave" class="k-button"  >입력</button>
						<div style="text-align:right; padding-top:10px;">
							<button  id="updateBtn" class="k-button">수정</button>
							<button  id="delBtn" class="k-button">삭제</button>
							<button  id="listBtn" class="k-button" >목록</button>
						</div>
		            </div>
		            
		            
		            <div class="sub_title01">첨부파일</div>
                    <div class="text_table">
                        <div id="my-file-gird"></div>
                    </div>
  
                </div>
            </div>
	
			
		</div>
<%-- 		<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/> --%>
	</div>
                  
<style>
    #my-file-gird{
        min-height: 150px;
    }
    
    #my-file-upload{ 
        width : 300px;
    }
    .k-dropzone {
        border: 2px dashed #d4d4d4;
        background-color: #f7f7f7;
        position: relative; 
        text-align: center;
        padding: 34px 34px 40px 10px;
        -webkit-border-radius: 18px;
        -moz-border-radius: 18px;
        border-radius: 18px;
        margin: 20px 0 0 0;
    }       
    
    .k-upload.k-header {
        border-color: transparent;
    }
    
    .k-button.k-upload-button {
        min-width: 120px;
        float: right;
    }               

</style>

<style>
<!--
.layer_cont .layer .close{float:right;margin-top:5px;}
.layer_cont{width:1000px;}
.layer_cont .layer_text{position:relative;width:1030px;margin-top:0px;padding:0 20px 10px 10px;}
.layer_cont .layer_text .sub_title{width:1030px;border-bottom:1px solid #d4d4d4;font-weight:bold;color:#2eb398;font-size:16px;padding:15px 0;}
.layer_cont .layer_text .sub_btn{position:absolute;top:10px;right:30px;}
.layer_cont .layer_text .sub_title01{margin-top:20px;background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_cir02.gif) no-repeat 0 5px;padding-left:18px;font-weight:bold;}
.layer_cont .layer_text .sub_title01 span{float:left;width:73px;}

.layer_cont .layer_text .top01{width:1035px;margin-top:10px;}
.layer_cont .layer_text .bottom01{width:1030px;}
.layer_cont .layer_text .middle01{width:993px; padding:15px 20px;min-height:250px;}
.layer_cont .layer_text .text_table{width:1030px;margin-top:10px;min-height:110px;}
-->
</style>
	<!-- END MAIN CONTENT  --> 	
	<footer>
  	</footer>
</body>
</html>