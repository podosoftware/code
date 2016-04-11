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

int s_brdNum = action.getTotalItemCount();

List items = action.getItems();

Map runMap = new HashMap();
if(items!=null && items.size()>0){
	runMap = (Map)items.get(0);
}
	
Object BOARD_TITLE = runMap.get("BOARD_TITLE");
Object BOARD_CONTENT = runMap.get("BOARD_CONTENT");

if(request.getParameter("BOARD_NUM") == ""){
	BOARD_TITLE = "";
	BOARD_CONTENT = "";
}


%>
	<title>게시판</title>

	
	<script type="text/javascript">
	
	var uId = "<%=action.getUser().getUserId()%>";
	var uComId = "<%=action.getUser().getCompanyId()%>";
	var brdCd = "<%=request.getParameter("BOARD_CODE")%>";
	var brdNum = "<%=request.getParameter("BOARD_NUM")%>";
	if(brdNum == "" || brdNum == null){
		brdNum = <%=s_brdNum%>;
	}
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
	  
		   
	   
       function handleCallbackUploadResult(){
           $("#my-file-gird").data('kendoGrid').dataSource.read();             
       }
       
       function getInternetExplorerVersion() {    
           var rv = -1; // Return value assumes failure.    
           if (navigator.appName == 'Microsoft Internet Explorer') {        
                var ua = navigator.userAgent;        
                var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");        
                if (re.exec(ua) != null)            
                    rv = parseFloat(RegExp.$1);    
               }    
           return rv; 
      }
       
       //첨부파일 삭제.
       function deleteFile (attachmentId){
       	if(confirm("첨부파일을 삭제 하시겠습니까?")){
       		$.ajax({
                   type : 'POST',
                   url : '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json' ,
                   data:{ attachmentId : attachmentId },
                   success : function(response){
                   	handleCallbackUploadResult();
                   },
                   dataType : "json"
               });
       	}

       } 
	</script>
	<script type="text/javascript">               
        yepnope([{
       	  load: [ 
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
       	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
       	 	'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
      	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js', 
      	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js'
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
              
              if( !$("#my-file-gird").data('kendoGrid') ){
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
                          	title: "크기(byte)", 
                          	format: "{0:##,###}", 
                          	width: "100px" 
                          },
                          { 
                              width: "160px" , 
                              template: function(dataItem){
                              	return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>'+
                              	'<button style="width:60px; min-width: 50px;" class="k-button" onclick="deleteFile('+dataItem.attachmentId+')">삭제</button>';
                              } 
                          }
                      ]
                  });
              }else{
              	handleCallbackUploadResult();
              }
              
              var ver = getInternetExplorerVersion();
              if( ( ver > -1) && ( ver < 10 ) ){
                  if( $('#my-file-upload').text().length == 0  ) {
                      var template = kendo.template('<button id="openUploadWindow" name="openUploadWindow">파일 업로드 하기</button>');
                      $('#my-file-upload').html(template({}));
                      $('#openUploadWindow').kendoButton({
                          click: function(e){
                        	  var width = 380;
                              var height = 220;
                              var left = (screen.width - width) / 2;
                              var top = (screen.height - height) / 2;
                              
                              var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#objectId").val() ;
                              myWindow = window.open(windowUrl, "_blank", "toolbar=no, scrollbars=yes, resizable=yes, top="+top+", left="+left+", width="+width+", height="+height);
                          }                           
                      });
                      $('button.custom-button-delete').click( function(e){
                          
                          alert ("delete");
                      });
                      $("#my-file-upload").removeClass('hide');
                  }                   
              }else{                  
                  if( $('#my-file-upload').text().length == 0  ) {
                      var template = kendo.template($("#fileupload-template").html());
                      $('#my-file-upload').html(template({}));
                  }                   
                  if( !$('#upload-file').data('kendoUpload') ){             
                      $("#upload-file").kendoUpload({
                          showFileList : false,
                          width : 500,
                          multiple : false,
                          localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.', statusUploaded: "완료.", statusFailed : "업로드 실패." },
                          async: {
                              saveUrl:  '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?output=json',                               
                              autoUpload: true
                          },
                          upload: function (e) {                                       
                              e.data = {objectType: objectType, objectId:$("#objectId").val()};                                                                                                                    
                          },
                          error : function (e){                           
                          },
                          success : function(e){                          
                              handleCallbackUploadResult();
                          },
                          select: function(e){
                              $.each(e.files, function(index, value) {
                                  if(value.size>10485760){
                                      e.preventDefault();
                                      alert("파일 사이즈는 10M로 제한되어 있습니다.");
                                  }else{
                                      $.each(e.files, function(index, value) {
                                          if(value.extension != ".HWP" && value.extension != ".hwp" 
                                              && value.extension != ".DOC" && value.extension != ".doc" 
                                              && value.extension != ".PPT" && value.extension != ".ppt" 
                                              && value.extension != ".XLS" && value.extension != ".xls"
                                              && value.extension != ".PDF" && value.extension != ".pdf" 
                                              && value.extension != ".DOCX" && value.extension != ".docx" 
                                              && value.extension != ".PPTX" && value.extension != ".pptx" 
                                              && value.extension != ".XLSX" && value.extension != ".xlsx"
                                              && value.extension != ".TXT" && value.extension != ".txt"
                                              && value.extension != ".ZIP" && value.extension != ".zip"
                                              && value.extension != ".JPG" && value.extension != ".jpg" 
      	                                    && value.extension != ".JPEG" && value.extension != ".jpeg" 
      	                                    && value.extension != ".GIF" && value.extension != ".gif" 
      	                                    && value.extension != ".BMP" && value.extension != ".bmp"
      	                                    && value.extension != ".PNG" && value.extension != ".png") {
                                          	
                                              e.preventDefault();
                                              alert("업로드가 허용된 형식의 파일만 선택해주세요.\n가능한 파일확장자:hwp, doc, ppt, xls, pdf, docx, pptx, xlsx, txt, zip, jpg, jpeg, gif, bmp, png");
                                          }
                                      });
                                  }
                              });
                          }
                      });
                      $("#my-file-upload").removeClass('hide');
                  }
              }
        	  
              
        	  //게시판에서 글쓰기 입력으로 들어왔을시 취소버튼 hide
        	  if("<%=request.getParameter("BOARD_NUM")%>" == "" || "<%=request.getParameter("BOARD_NUM")%>" == null){
       			 $("#backBtn").hide();
       	 	  }
        		
        	  //에디터창 소환
        	  $("#brdCont").kendoEditor();
        	 
        	  //목록버튼
              $("#listBtn").click(function(){
                  document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_main.do";
                  document.frm.submit();
              });
              
      		  //저장 취소버튼
              $("#backBtn").click(function(){
            	  $("#BOARD_CODE").val(brdCd);
				  $("#BOARD_NUM").val(brdNum);
                  document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_detail.do";
                  document.frm.submit();
              });
            
        	
    			
      		//save btn add click event
           	  $("#brdSave").click( function(){
           			var isDel = confirm("게시물을 등록하시겠습니까?");
    				 	 if(isDel){
    	             		if($("#brdTitle").val()=="") {
    	             			alert("게시물 제목을 입력해 주세요");
    	             			return false;
    	             		}
    	             		if($("#brdCont").val()=="") {
    	             			alert("게시물 내용을 입력해 주세요");
    	             			return false;
    	             		}	
    	             		
    	             		$.ajax({
    	             			type : 'POST',
    	     					url:"/service/ca/brd_cont_save.do?output=json",
    	     					data : { BOARD_TITLE : $("#brdTitle").val(), BOARD_CONTENT : $("#brdCont").val(), BOARD_CODE : brdCd, BOARD_NUM : brdNum },
    	     					complete : function( response ){
    	     						var obj  = eval("(" + response.responseText + ")");
    	     						if(obj.saveCount != 0){
    	     							$("#BOARD_CODE").val(brdCd);
    	     							$("#BOARD_NUM").val(brdNum);
    	     							document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_detail.do";
    	     			                document.frm.submit();
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
		<div class="cont_body" style="height:900px;">
			<div class="title">게시판</div>
<!-- 			<div class="table_tin"> -->
<!--             </div> -->
            <div class="layer_cont">
                <div class="layer_text">
                    <div class="sub_title01"><span>제목:</span><input type="text" id="brdTitle" style="width:920px;" value="<%=BOARD_TITLE %>" /></div>
                    <div class="sub_title01">내용</div>
                    <div class="middle01"><textarea id="brdCont" rows="10" cols="30" style="height:440px"><%=BOARD_CONTENT %></textarea></div>
                    <div style="text-align:right; padding-top:10px;">
							<button id="brdSave" class="k-button">저장</button>
							<button id="backBtn" class="k-button" >취소</button>
							<button id="listBtn" class="k-button" >목록</button>
		            </div>
                </div>
            </div>
      
             <div class="file">
                <ul>
	                <li style="width:300px;float:left;">
	                   <div id="my-file-upload" class="hide"></div>
		                <!-- <div id="my-file-upload">   
		                    <small> 업로드할 파일은 아래의 파일선택 버튼을 클릭하여 직접 선택하거나, 아래의 영역에 파일를 끌어서 놓기(Drag & Drop)를 하세요. </small>
		                    <input name="upload-file" id="upload-file" type="file" class="hide"/>
		                </div> -->
		            </li>
		            <li style="width:600px;float:left;padding-left:25px;">
		                <div id="my-file-gird"></div>
		                
		                <script type="text/x-kendo-tmpl" id="fileupload-template">
                            <small> 업로드할 파일은 아래의 파일선택 버튼을 클릭하여 직접 선택하거나, 아래의 영역에 파일를 끌어서 놓기(Drag & Drop)를 하세요. </small>
                            <input name="upload-file" id="upload-file" type="file"/>
                            <p></p>
                        </script>
		            </li>
                </ul>
            </div>
            
	    </div>
			
			
		</div>
<%-- 		<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/> --%>
	</div>
<style>
<!--
.layer_cont .layer .close{float:right;margin-top:5px;}
.layer_cont{float:left;width:1000px;}
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