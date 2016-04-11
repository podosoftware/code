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

//총괄관리자 권한 여부..
boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
//고객사운영자 권한 여부..
boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
//부서장 권한 여부..
boolean isManager = request.isUserInRole("ROLE_MANAGER");

kr.podosoft.ws.service.ca.action.ajax.CAServiceAction action = (kr.podosoft.ws.service.ca.action.ajax.CAServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

List items = action.getItems();

Map runMap = new HashMap();
if(items!=null && items.size()>0){
	runMap = (Map)items.get(0);
	
}

Object BOARD_TITLE = runMap.get("BOARD_TITLE"); //제목

String BOARD_CONTENT = (String) runMap.get("BOARD_CONTENT"); //내용

BOARD_CONTENT = BOARD_CONTENT.replaceAll("\r\n", "<br>"); //에디터 내용 BR처리

BOARD_CONTENT = BOARD_CONTENT.replaceAll("&amp;nbsp;", "&nbsp;"); //에디터 공백처리

BOARD_CONTENT = BOARD_CONTENT.replaceAll("&lt;p&gt;", "<br>").replaceAll("&lt;/p&gt;", ""); //에디터 BR처리

BOARD_CONTENT = BOARD_CONTENT.replaceAll("&lt;", "<").replaceAll("&gt;", ">"); //에디터 태그처리

Object BOARD_USERID = runMap.get("USERID"); //게시글 작성자

Object userNumber = action.getUser().getUserId(); //로그인한 유저

String brdType = request.getParameter("BOARD_CODE"); //게시판 유형


//게시판 유형별 처리
String brdName="";
if("1".equals(brdType)){
	brdName = "공지사항";
}else if("2".equals(brdType)){
	brdName = "질문과 답변";
}else if("3".equals(brdType)){
	brdName = "교육안내";
}

//공지사항,교육안내는 관리자만 수정 삭제 가능
//qna는 자기가 쓴 글이거나 관리자일경우
String writer = BOARD_USERID.toString();
String loginUser= userNumber.toString();

boolean btnCheck = false;

if(("1".equals(brdType) ||"3".equals(brdType)) && isSystem==true ){ 
	btnCheck = true;
}else if(("2".equals(brdType) && loginUser.equals(writer) ) || isSystem==true  ){
	btnCheck = true;
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage">
<head>
<title></title>
<style type="text/css">
   table.list_view01 ol{display: block; list-style-type: decimal; padding-left: 30px; }
   table.list_view01 ul{display: block; list-style-type: disc; padding-left: 30px;}
</style>
<script type="text/javascript"> 
var brdType = "<%=brdType%>"; 
var uId = "<%=action.getUser().getUserId()%>";
var uComId = "<%=action.getUser().getCompanyId()%>";
var brdCd = "<%=request.getParameter("BOARD_CODE")%>"; 
var brdNum = "<%=request.getParameter("BOARD_NUM")%>";
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
        
       	$("#newBtn").click(function(){
       	    document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_update.do";
       	    document.frm.submit();
       	});
       
       	$("#updateBtn").click(function(){
            $("#BOARD_CODE").val(brdCd);
            $("#BOARD_NUM").val(brdNum);
            document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_update.do";
            document.frm.submit();
        });
       	
       	$("#delBtn").click(function(){
       		var isDel = confirm("게시글을 삭제 하시겠습니까?");
     	 	if(isDel){
     	 		$.ajax({
                    type : 'POST',
                    url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_del.do?output=json",
                    data : {
                    	BRD_CD : brdCd,
                  	   	BOARD_NUM : brdNum
                    },
                    complete : function(response) {
                    	//로딩바 제거.
                        loadingClose();
                    	
                        var obj = eval("(" + response.responseText + ")");
                        if(obj.error){
                        	alert("ERROR==>"+obj.error.message);
                        }else{
                            if (obj.saveCount != 0) {
                                alert("삭제되었습니다.");
                                fn_location();
                            } else {
                                alert("삭제를 실패 하였습니다.");
                            }
                        }
                    },
                    error : function(xhr, ajaxOptions, thrownError) {
                    	//로딩바 제거.
                        loadingClose();
                    	
                        if(xhr.status==403){
                            alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                            sessionout();
                        }else{
                            alert('xrs.status = ' + xhr.status + '\n' + 
                                    'thrown error = ' + thrownError + '\n' +
                                    'xhr.statusText = '  + xhr.statusText );
                        }
                    },
                    dataType : "json"
                });
     		}
       	});
       	
       	/*$("#repVal").keydown(function(evt){ //아이디가 msg_input인 엘리먼에서 키를 눌렀을때
            if( (evt.keyCode) && (evt.keyCode==13) ) { // 누르면 키번호가 13번이면 경고창을 띄움
            	commentInsert();
            }
        });*/
       	
        var objectType = 2 ;
        $("#objectId").val(brdNum);
        
        var fileDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json", type:"POST" },
                parameterMap: function (options, operation){ 
                	return { objectType: objectType, objectId:$("#objectId").val(), startIndex: options.skip, pageSize: options.pageSize };
                }        
            },
            schema: {
            	model: Attachment,
                data : "targetAttachments"
            }
        });
        fileDataSource.fetch(function(){
        	if(fileDataSource.data().length > 0){
        		var i=0;
        		var str = "";
        		$.each(fileDataSource.data(), function(index, value) {
        			if(i>0){
        				str += "<br>";
        			}
        			str += "<a href=<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId="+this.attachmentId+" >"+this.name+"</a>";
        			i++;
                });
        		
                $('#fileDiv').html(str);
            }
        });
        
        $("#tabstrip").kendoTabStrip({
            animation:  {
                open: {
                    effects: "fadeIn"
                }
            }
        });
        

 
           
        //코멘트 목록..
       	commentList();

    }
}]);
</script>

<script type="text/javascript">
	//코멘트 등록
	function commentInsert(){
		if($("#repVal").val()=="") {
				alert("코멘트 내용을 입력해 주세요");
				return false;
		}		
		var isDel = confirm("코멘트를 등록하시겠습니까?");
	 	if(isDel){   
	 		
	 		var repVal = $("#repVal").val().replace(/</gi,'&lt;').replace(/>/gi,'&gt;');;
	 		
	   		$.ajax({
	              type : 'POST',
	              url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_coment_save.do?output=json",
	              data : {
	              	REPLY_CONTENT : repVal ,
	              	BRD_CD : brdCd,
	              	BOARD_NUM : brdNum 
	              },
	              complete : function(response) {
	              	//로딩바 제거.
	                  loadingClose();
	              	
	                  var obj = eval("(" + response.responseText + ")");
	                  if(obj.error){
	                  	alert("ERROR==>"+obj.error.message);
	                  }else{
	                      if (obj.saveCount != 0) {
	                          //alert("저장되었습니다.");
	                          commentList(); //저장후 코멘트 영역 리로딩
	                          $("#repVal").val("");
	                      } else {
	                          alert("저장에 실패 하였습니다.");
	                      }
	                  }
	              },
	              error : function(xhr, ajaxOptions, thrownError) {
	              	//로딩바 제거.
	                  loadingClose();
	              	
	                  if(xhr.status==403){
	                      alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
	                      sessionout();
	                  }else{
	                      alert('xrs.status = ' + xhr.status + '\n' + 
	                              'thrown error = ' + thrownError + '\n' +
	                              'xhr.statusText = '  + xhr.statusText );
	                  }
	              },
	              dataType : "json"
	        });
	 	}
	};
	function commentList(){
		//코멘트 리스트
	    $.ajax({
	       type : 'POST',
	       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_comment_list.do?output=json",
	       data : {
	    	   BRD_CD : brdCd,
	    	   BOARD_NUM : brdNum
	       },
	       complete : function( response ){
	           var obj = eval("(" + response.responseText + ")");
	            if(obj.error){
	                alert("ERROR=>"+obj.error.message);
	            }else{
	            	var brdData=obj.items;
	                if(brdData.length > 0){
	                	var tab = "";
	                	for(var i=0 ; i < brdData.length ; i++ ){
	                			tab +="<tr>";
	                			tab +="<td colspan='2' style='padding:5px 0 !important;'>";
	                			tab +="<dl class='replyArea'>";
	                			tab +="<dt>";
	                			tab +="<span class='id'>"+brdData[i].NAME+"</span>";
	                			tab +="</dt>";
	                			
	                			var cont = brdData[i].REPLY_CONTENT.replace(/(?:\r\n|\r|\n)/g, '<br/>');
	                			
	                			tab +="<dd class='txt' >"+cont+"</dd><dd class='date' style='font-size: 11px;'>"+brdData[i].CREATETIME+"&nbsp;&nbsp;&nbsp;";
	                			if(brdData[i].USERID == uId || adminRole == "true" ){ //코멘트 삭제 버튼 권한 
                                    tab +=" <span id='delBtn' style='cursor: pointer; text-decoration: underline' onclick='fn_comDel("+brdData[i].REPLY_NUM+")'>삭제</span>";
	                			}
	                			tab +="</dd>";
	                			tab +="</dl>";
	                			tab +="</td>";
	                			tab +="</tr>";
	                	}
						$('#brdContent').html(tab);
	                }else{
	                	var emptyStr = "";
                		emptyStr +="<tr>";
                		emptyStr +="<td colspan='2' style='padding:5px 0 !important;'>";
                		emptyStr +="<dl class='replyArea'>";
                		emptyStr +="<dd class='txt' >작성된 코멘트가 존재하지 않습니다.</dd>";
                        emptyStr +="</dl>";
                        emptyStr +="</td>";
                        emptyStr +="</tr>";
	                	
	                	$('#brdContent').html(emptyStr); //건수가 없을 경우에 화면 출력 안함.
	                }
	                
	                $("#cmtCnt").text(brdData.length);
	            }
	       },
	       error: function( xhr, ajaxOptions, thrownError){
	          if(xhr.status==403){
	              alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
	              sessionout();
	          }else{
	              alert('xrs.status = ' + xhr.status + '\n' + 
	                      'thrown error = ' + thrownError + '\n' +
	                      'xhr.statusText = '  + xhr.statusText );
	          }
	          
	           if(event.preventDefault){
	               event.preventDefault();
	           } else {
	               event.returnValue = false;
	           };
	       },
	       dataType : "json"
	   });
	}
	//코멘트 삭제
	function fn_comDel(repNum){
		var isDel = confirm("코멘트를 삭제 하시겠습니까?");
	 	if(isDel){
	 		loadingOpen();
	 		$.ajax({
	 		    type : 'POST',
	 		    url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_coment_del.do?output=json",
	 		    data : {
	 		    	 REPLY_NUM : repNum,
	 				 BRD_CD : brdCd,
	 				 BOARD_NUM : brdNum 
	 		    },
	 		    complete : function(response) {
	 		    	//로딩바 제거.
	 		        loadingClose();
	 		    	
	 		        var obj = eval("(" + response.responseText + ")");
	 		        if(obj.error){
	 		        	alert("ERROR==>"+obj.error.message);
	 		        }else{
	 		        	if(obj.saveCount != 0){
	 						alert("삭제되었습니다.");	
	 						commentList(); //삭제후 코멘트 영역 리로딩
	 					}else{
	 						alert("저장에 실패 하였습니다.");
	 					}	
	 		        }
	 		    },
	 		    error : function(xhr, ajaxOptions, thrownError) {
	 		    	//로딩바 제거.
	 		        loadingClose();
	 		    	
	 		        if(xhr.status==403){
	 		            alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
	 		            sessionout();
	 		        }else{
	 		            alert('xrs.status = ' + xhr.status + '\n' + 
	 		                    'thrown error = ' + thrownError + '\n' +
	 		                    'xhr.statusText = '  + xhr.statusText );
	 		        }
	 		    },
	 		    dataType : "json"
	 		});
		}
		
	}
	function fn_location(){ //저장,삭제 후 페이지 이동 처리
		if(brdType=="1"){
	    	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_notice_main.do";
	    }else if(brdType=="2"){
	    	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_qna_main.do";
	    }else if(brdType=="3"){
	    	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_edu_info_main.do";
	    }
			
	    document.frm.submit();
	};

</script>
     
    </head>
<body>
	<form id="frm" name="frm"  method="post" >
	    <input type="hidden" name="BOARD_CODE" id="BOARD_CODE" />
	    <input type="hidden" name="BOARD_NUM" id="BOARD_NUM" />
	    <input type="hidden" name="objectId" id="objectId" />
	</form>
    
   <div class="container">
		<div id="cont_body">
		 <div class="content">
		<div class="top_cont" style ="margin-bottom : 50px">
		 
				<h3 class="tit01"><%=brdName%> </h3>
				<%-- <div class="point">
					※ <%=brdName%>의 내용을 수정 및 등록합니다.
				</div>	 --%>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span><%=brdName%>&nbsp; &#62;</span>
					<span class="h">상세보기 </span>
				</div><!--//location-->
		</div>
		<div class="sub_cont">
				<div class="table_wp04">
					<table class="list_view01">
						<caption>게시판 view</caption>
						<colgroup>
							<col style="width:150px"/>
							<col style="width:1070px"/>
						</colgroup>
						<tbody >
							<tr>
								<th><div class="tb_tit">제목</div></th>
								<td><%=runMap.get("BOARD_TITLE")%></td>
							</tr>
							<tr>
								<th><div class="tb_tit">내용</div></th>
								<td><div class="cont" style="width:1020px;min-height:250px;"><%=BOARD_CONTENT%></div></td>
							</tr>
                            <tr>
                                <th><div class="tb_tit">첨부파일</div></th>
                                <td><div id="fileDiv" ></div></td>
                            </tr>
							<tr>
							<td colspan="2"><div style="text-align:right; padding-top:0px;">
										<%if(btnCheck==true ){%>
											<button  id="updateBtn" class="k-button">수정</button>
											<button  id="delBtn" class="k-button">삭제</button>
										<%}%>
											<button  id="listBtn" class="k-button" onclick="fn_location();" >목록</button>
										</div>
							</td>
							</tr>
							
						</tbody>
					</table>
					
					<table class="list_view01">
                    <tbody>
                        <tr>
                            <td colspan="2">
                                <b>간단한 코멘트를 작성해주세요.</b>
                                     <div style="padding-top:10px;">
                                        <textarea type="text" id="repVal" style="width:1040px;"  ></textarea>
                                        <button  id="repSave" class="k-button k-primary btn_style02" onclick="commentInsert();" >입력</button>
                                        
                                    </div>
                                </td>
                            </tr>
                        <tr>
                                <td colspan="2" class="grid_wp"><div id="grid" class="mt10 mb10"></div></td>
                        </tr>
                    </tbody>
                    </table>
                    <div style="height:10px;">&nbsp;</div>
                    
                    <div id="tabstrip">
	                    <ul>
	                        <li class="k-state-active">코멘트 <span id="cmtCnt" style="color:red;"></span></li>
	                    </ul>
	                    <div>
		                    <table class="list_view01">
								<tbody id="brdContent">
								</tbody>
							</table>
						</div>
                    </div>
					<!-- <div class="sub_title01"></div>
                    <div class="text_table">
                        <div id="my-file-gird"></div>
                    </div> -->
				</div>
			 </div><!--//sub_cont-->                
		 </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->
</body>
</html>