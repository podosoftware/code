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

kr.podosoft.ws.service.mtr.action.MtrServiceAction action = (kr.podosoft.ws.service.mtr.action.MtrServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

%>

<%
//총괄관리자 권한 여부..
boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
//고객사운영자 권한 여부..
boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
//부서장 권한 여부..
boolean isManager = request.isUserInRole("ROLE_MANAGER");

Map map1 = new HashMap<String, Object>();
//회사정보
List<Map<String,Object>> items1 = action.getItems1();
if(items1!=null && items1.size()>0){
	map1 = (Map)items1.get(0);
}

//현재 년도, 월
Calendar cal = Calendar.getInstance();
int year = cal.get ( cal.YEAR );
int month = cal.get ( cal.MONTH ) + 1 ;

String menuStr = architecture.ee.web.util.ServletUtils.getServletPath(request);

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage">
<head>
<title></title>
<style>
    .k-dropzone {
        position: relative; 
        width : 378px;
        height: 32px;
    }
    .k-upload-empty{
     	width : 397px;
        height: 32px;
    }
    #plan-file-upload{
    	width : 397px;
        height: 32px;
    }
     #report-file-upload{
    	width : 397px;
        height: 32px;
    }
    #plan-file-gird{
    	min-height : 70px;
    }
    #report-file-gird{
    	min-height : 70px;
    }            

</style>
<script type="text/javascript"> 
var loginUserInfo= <%=action.getUser().getUserId()%>;

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
        var splitter = $("#splitter").kendoSplitter({
			orientation : "horizontal",
			panes : [ {
				collapsible : true,
				min : "300px"
			}, {
				collapsible : true,
				collapsed : true,
				min : "700px"
			} ]
		});
        //로딩바 선언..
        loadingDefine();
        //생성 detail 그리기
        $('.detail_Info').show().html(kendo.template($('#template').html()));
        
        $("#grid").empty();
		$("#grid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/mtr_run_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){	
                    	return { };
                    } 		
                },
                schema: {
                	data: "items",
                	total : "totalItemCount",
                    modxel: {
                        fields: {
                        	MTR_SEQ : { type: "int" },
                        	USERID_MENTOR : { type: "int" },
                        	USERID_MENTEE : { type: "int" },
                        	MTR_NM : { type: "string" },
                        	MTR_ST_DT : { type: "string" },
                        	MTR_ED_DT : { type: "string" },
                        	MENTOR_NM : { type: "string" },
                        	MENTEE_NM : { type: "string" }
                        }
                    }
                },
                pageSize: 30,serverPaging:false, serverFiltering:false, serverSorting:false
            },
            columns: [
                {
                    field:"MTR_NM",
                    title: "멘토링명",
                    width:150,
                    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                attributes:{"class":"table-cell", style:"text-align:center;text-decoration: underline;"},
					template:"<a href='javascript:fn_detailView(${MTR_SEQ},${MTR_MB_SEQ});'> ${MTR_NM} </a>"
                },
                {
                    field:"MTR_DATE",
                    title: "멘토링기간",
                    width:150,
                    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                {
                    field:"MENTOR_NM",
                    title: "멘토",
                    filterable: true,
                    width:150,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                {
                    field: "MENTEE_NM",
                    title: "멘티",
					width:150,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center;"},
                },
                {
                    field: "APP_DIVISION",
                    title: "진행상태",
                    width:170,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}
                },	                   
                {
                    field: "REQ_STS_CD",
                    title: "승인상태",
                    width:170,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"},
                    template: function(data){
                    	if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
                            return "";
                        }else{
                            if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
                                return "";
                            }else{ //승인요청상태
                            	var cancelAbleYn =  "Y";
                            	if(data.REQ_STS_CD == "2" || data.REQ_STS_CD == "3"){
                            		//승인요청건에 대해 최종 처리가 되기전엔 취소가능하도록 함.
                            		cancelAbleYn =  "N";
                            	}
                                return "<button class=\"k-button\" onclick=\"javascript: fn_apprOpen("+data.REQ_NUM+","+data.MTR_REQ_DIV_CD+",'"+cancelAbleYn+"')\" >승인현황</button>";
                            }
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
      	    height: 575,
   			groupable: false,
   			sortable: true,
   			resizable: true,
   			reorderable: true,
   			selectable: "row",
   			pageable : {
	            refresh : false,
	            pageSizes : [10,20,30],
	            buttonCount : 5
	        }
        });
		menteeList(); // 멘티 그리드
		
		function menteeList(){
			$("#menteeList").kendoGrid({
	            dataSource: {
	                type: "json",
	                transport: {
	                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/mtr_mentee_list.do?output=json", type:"POST" },
	                    parameterMap: function (options, operation){	
	                    	return { MTR_SEQ : 0  }; // 멘토링 상세화면에 그리드를 사용하지 않아 틀만 가지고 왔음
	                    } 		
	                },
	                schema: {
	                	data: "items",
	                    model: {
	                        fields: {
	                        	MTR_SEQ : { type: "int" },
	                        	USERID_MENTEE : { type: "int" },
	                        	MENTEE_NM : { type: "string" },
	                        	USERID : { type: "string" }
	                        }
	                    }
	                },
	                serverPaging:false, serverFiltering:false, serverSorting:false
	            },
	            columns: [
	                {
	                    field:"NAME",
	                    title: "멘티",
	                    width:50,
	                    filterable: true,
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                attributes:{"class":"table-cell", style:"text-align:center;text-decoration: underline;"},
						template:{}
	                },
	                {
	                    field:"DVS_NAME",
	                    title: "부서",
	                    width:50,
	                    filterable: true,
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                attributes:{"class":"table-cell", style:"text-align:center"} 
	                },
	                {
	                    title : "삭제",
	                    filterable : false,
	                    sortable : false,
	                    width : 50,
	                    headerAttributes : {
	                        "class" : "table-header-cell",
	                        style : "text-align:center"
	                    },
	                    attributes : {
	                        "class" : "table-cell",
	                        style : "text-align:center"
	                    },
	                    template : "<button id='menteeDel_${USERID}' class='k-button' onclick='javascript:fn_menteeDel(${USERID});'>삭제</button>"
	                }
	            ],
	            filterable: false,
	        	pageSize: 99999,
	      	    height: 150,
	   			groupable: false,
	   			sortable: true,
	   			resizable: true,
	   			reorderable: true,
	   			pageable: false
	        });
		}
		
		
		//스플리터 expand.. 생성영역
		$("#mtrCreat").click(function(){
			
			$("#splitter").data("kendoSplitter").expand("#detail_pane");
			
			// show detail   
  			$('.detail_Info').show().html(kendo.template($('#template').html()));
  			menteeList(); //멘티 그리드
  			numTexBox();  //날짜 입력 제어
  			insertReqBtn(); //부서장 유무에 따른 생성요청버튼 /생성버튼 구분
	
		});

		numTexBox();
		insertReqBtn();
		
		
		
    }
}]);
</script>

<script type="text/javascript">
// 첨부파일 함수 시작 
function handleCallbackUploadResult(){
    $("#plan-file-gird").data('kendoGrid').dataSource.read();
    $("#report-file-gird").data('kendoGrid').dataSource.read();
}
//첨부파일 삭제.
function deleteFile (attachmentId){
    if(confirm("첨부파일을 삭제 하시겠습니까?")){

        //로딩바 생성.
        loadingOpen();
        
        $.ajax({
            type : 'POST',
            url : '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json' ,
            data:{ attachmentId : attachmentId },
            success : function(response){
                //로딩바 제거.
                loadingClose();
            	
                handleCallbackUploadResult();
            },
            error: function( xhr, ajaxOptions, thrownError){
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


function planFileUpdown(menDivide,mtrCd , mtrAppCd){
	 var objectType = 4 ; // 멘토 첨부파일 코드 (훈련계획서)
     
     if( !$("#plan-file-gird").data('kendoGrid') ) {
         $("#plan-file-gird").kendoGrid({
             dataSource: {
                 type: 'json',
                 transport: {
                     read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json', type: 'POST' },      
                     destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
                     parameterMap: function (options, operation){
                         if (operation != "read" && options) {                                                                                                                           
                             return { objectType: objectType, objectId:$("#mentorId").val(), attachmentId :options.attachmentId };                                                                   
                         }else{
                              return { objectType: objectType, objectId:$("#mentorId").val(), startIndex: options.skip, pageSize: options.pageSize };
                         }
                     }
                 },
                 schema: {
                     model: Attachment,
                     data : "targetAttachments"
                 },
             },
             pageable: false,
             selectable: false,
             columns: [
                 { 
                     field: "name", 
                     title: "파일명",  
                     width: "130px",
                     headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                     attributes:{"class":"table-cell", style:"text-align:left"} ,
                     template: '#= name #' 
                },
                { 
                    field: "size",
                    title: "크기(byte)", 
                    format: "{0:##,###}", 
                    width: "70px" 
                },
                { 
                    width: "130px" ,
                    attributes:{"class":"table-cell", style:"text-align:center"},
                    template: function(dataItem){
                    	var str;
                    	//멘티 멘토에 따라 다운로드 삭제 구분
                    	if(menDivide =="MENTEE"){
                    		str ='<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button" >다운로드</a>';
                    	}else if(menDivide =="MENTOR"){
                    		if(mtrCd == 5 && mtrAppCd==2){ //완료 승인 되면 첨부파일 삭제를 할 수 없다.
                    			str ='<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button" >다운로드</a>';
                    		}else{
                    			str = '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>'+
                            	'<button style="width:50px; min-width: 40px;" class="k-button" id="planDel" onclick="deleteFile('+dataItem.attachmentId+')" >삭제</button>';
                    		}
                    	} 
                    	return str;
                    } 
                }
             ]
         });
     }else{
         handleCallbackUploadResult();
     }
     
     var ver = getInternetExplorerVersion();
     if( ( ver > -1) && ( ver < 10 ) ){
         if( $('#plan-file-upload').text().length == 0  ) {
             var template = kendo.template('<button id="openUploadWindow" name="openUploadWindow">파일 업로드 하기</button>');
             $('#plan-file-upload').html(template({}));
             $('#openUploadWindow').kendoButton({
                 click: function(e){
                     var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#mentorId").val() +"&fileType=doc" ;
                     var myWindow = window.open(windowUrl, "_blank", "toolbar=no, scrollbars=yes, resizable=yes, top=500, left=500, width=405, height=250");
                 }                           
             });
             $('button.custom-button-delete').click( function(e){
                 alert ("delete");
             });
             $("#plan-file-upload").removeClass('hide');
         }                   
     }else{                  
         if( $('#plan-file-upload').text().length == 0  ) {
             var template = kendo.template($("#plan-fileupload-template").html());
             $('#plan-file-upload').html(template({}));
         }                   
         if( !$('#plan-upload-file').data('kendoUpload') ){                       
             $("#plan-upload-file").kendoUpload({
                 showFileList : false,
                 width : 500,
                 multiple : false,
                 localization:{ select : '파일 선택' , statusUploaded: "완료.", statusFailed : "업로드 실패." },
                 async: {
                     saveUrl:  '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?output=json',                               
                     autoUpload: true
                 },
                 upload: function (e) {                                       
                     e.data = {objectType: objectType, objectId:$("#mentorId").val()};                                                                                                                    
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
                         }/*else{
                             if(value.extension != ".JPG" && value.extension != ".jpg" 
                                       && value.extension != ".GIF" && value.extension != ".gif" 
                                           && value.extension != ".BMP" && value.extension != ".bmp"
                                               && value.extension != ".PNG" && value.extension != ".png") {
                                 e.preventDefault();
                                 alert("이미지 파일만 선택해주세요.");
                             }
                         }*/
                     });
                 }
                 
             });
             $("#plan-file-upload").removeClass('hide');
         }
     }	
}
function reportFileUpdown(menDivide,mtrCd , mtrAppCd){
	 var objectType = 5 ; // 멘티 첨부파일 코드 (훈련보고서)
    
    if( !$("#report-file-gird").data('kendoGrid') ) {
        $("#report-file-gird").kendoGrid({
            dataSource: {
                type: 'json',
                transport: {
                    read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json', type: 'POST' },      
                    destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
                    parameterMap: function (options, operation){
                        if (operation != "read" && options) {                                                                                                                           
                            return { objectType: objectType, objectId:$("#menteeId").val(), attachmentId :options.attachmentId };                                                                   
                        }else{
                             return { objectType: objectType, objectId:$("#menteeId").val(), startIndex: options.skip, pageSize: options.pageSize };
                        }
                    }
                },
                schema: {
                    model: Attachment,
                    data : "targetAttachments"
                },
            },
            pageable: false,
            selectable: false,
            columns: [
                { 
                    field: "name", 
                    title: "파일명",  
                    width: "130px",
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left"} ,
                    template: '#= name #' 
               },
               { 
                   field: "size",
                   title: "크기(byte)", 
                   format: "{0:##,###}", 
                   width: "70px" 
               },
               { 
                   width: "130px" ,
                   attributes:{"class":"table-cell", style:"text-align:center"},
                   template: function(dataItem){
                	   var str;
                	   //멘토 멘티에 따른 다운로드 삭제 버튼 구분
                   	if(menDivide =="MENTOR"){
                   		str ='<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>';
                   	}else if(menDivide =="MENTEE"){
                   		if(mtrCd == 5 && mtrAppCd==2){ //완료 승인 되면 첨부파일 삭제를 할 수 없다.
                   			str ='<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>';
                   		}else{
                   			str = '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>'+
                        	'<button style="width:50px; min-width: 40px;" class="k-button rpDel" id="reportDel" onclick="deleteFile('+dataItem.attachmentId+')">삭제</button>';
                   		}
                   	} 
                   	return str;
                   } 
               }
            ]
        });
    }else{
        handleCallbackUploadResult();
    }
    
    var ver = getInternetExplorerVersion();
    if( ( ver > -1) && ( ver < 10 ) ){
        if( $('#report-file-upload').text().length == 0  ) {
            var template = kendo.template('<button id="openUploadWindow2" name="openUploadWindow2">파일 업로드 하기</button>');
            $('#report-file-upload').html(template({}));
            $('#openUploadWindow2').kendoButton({
                click: function(e){
                    var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#menteeId").val() +"&fileType=doc" ;
                    var myWindow = window.open(windowUrl, "_blank", "toolbar=no, scrollbars=yes, resizable=yes, top=500, left=500, width=405, height=250");
                }                           
            });
            $('button.custom-button-delete').click( function(e){
                alert ("delete");
            });
            $("#report-file-upload").removeClass('hide');
        }                   
    }else{                  
        if( $('#report-file-upload').text().length == 0  ) {
            var template = kendo.template($("#report-fileupload-template").html());
            $('#report-file-upload').html(template({}));
        }                   
        if( !$('#report-upload-file').data('kendoUpload') ){                       
            $("#report-upload-file").kendoUpload({
                showFileList : false,
                width : 500,
                multiple : false,
                localization:{ select : '파일 선택' , statusUploaded: "완료.", statusFailed : "업로드 실패." },
                async: {
                    saveUrl:  '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?output=json',                               
                    autoUpload: true
                },
                upload: function (e) {                                       
                    e.data = {objectType: objectType, objectId:$("#menteeId").val()};                                                                                                                    
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
                        }/*else{
                            if(value.extension != ".JPG" && value.extension != ".jpg" 
                                      && value.extension != ".GIF" && value.extension != ".gif" 
                                          && value.extension != ".BMP" && value.extension != ".bmp"
                                              && value.extension != ".PNG" && value.extension != ".png") {
                                e.preventDefault();
                                alert("이미지 파일만 선택해주세요.");
                            }
                        }*/
                    });
                }
                
            });
            $("#report-file-upload").removeClass('hide');
        }
    }	
}
function numTexBox(){ //날짜 및 숫자입력 텍스트박스 제어

	  var start = $("#mtrStart").kendoDatePicker({
		   format: "yyyy-MM-dd",
		   change: function(e) {                    
			   var startDate = start.value(),
	         endDate = end.value();

	         if (startDate) {
	             startDate = new Date(startDate);
	             startDate.setDate(startDate.getDate());
	             end.min(startDate);
	         } else if (endDate) {
	             start.max(new Date(endDate));
	         } else {
	             endDate = new Date();
	             start.max(endDate);
	             end.min(endDate);
	         }
	            			
	  }
	  }).data("kendoDatePicker");

	  var end = $("#mtrEnd").kendoDatePicker({
		   format: "yyyy-MM-dd",
		   change: function(e) {                    
			   var endDate = end.value(),
	    	        startDate = start.value();
	    	
	    	        if (endDate) {
	    	            endDate = new Date(endDate);
	    	            endDate.setDate(endDate.getDate());
	    	            start.max(endDate);
	    	        } else if (startDate) {
	    	            end.min(new Date(startDate));
	    	        } else {
	    	            endDate = new Date();
	    	            start.max(endDate);
	    	            end.min(endDate);
	    	        }
		   }
	  }).data("kendoDatePicker");
	   
	  start.max(end.value());
	  end.min(start.value());
}

function fn_detailView(mtrSeq,mtrMbSeq){
	
	$("#splitter").data("kendoSplitter").expand("#detail_pane");
	
	// show detail   
	
		
	var grid = $("#grid").data("kendoGrid");
    var data = grid.dataSource.data();
    
    var res = $.grep(data, function (e) {
        return e.MTR_SEQ == mtrSeq;
    });
	
    
    //멘토링 수정 화면 detail
    $('.detail_Info').show().html(kendo.template($('#detail_template').html()));
    
    var selectedCell = res[0];
    
    kendo.bind( $(".dl_wrap"), selectedCell );
    
    //아래의 3줄은 파일 업로드시 유일한 시퀀스를 가지기 위해 각 테이블의 시퀀스를 삽입
    $("#mtrSeq").val(mtrSeq);
    $("#mentorId").val(mtrSeq);
    $("#menteeId").val(res[0].MENTEE_SEQ);
   
    
    planFileUpdown(res[0].DIVIDE,res[0].MTR_REQ_DIV_CD,res[0].REQ_STS_CD); // 훈련계획서 파일 업다운로드
    reportFileUpdown(res[0].DIVIDE,res[0].MTR_REQ_DIV_CD,res[0].REQ_STS_CD); // 훈련보고서 파일 업다운로드
 
    numTexBox(); //날짜 형식 유효성
    handleCallbackUploadResult();
	
	var isManager = <%=isManager%>;
	var isOperator = <%=isOperator%>;
	var isSystem = <%=isSystem%>;
	
	
    if(res[0].DIVIDE=="MENTOR"){
    	$("#drag_plan").show();
    	$("#planDel").show();
    	$("#reportDel").hide();
    	$("#drag_report").hide();
    	$("#mtrComp").hide();
    	
    	//요청 후 승인이 되면 완료 요청 버튼 보이기, 취소 반려 회수 일경우 완료 요청 보이기
		if(res[0].MTR_REQ_DIV_CD=="4" && res[0].REQ_STS_CD=="2"){
    		$("#mtrComp").show();
    	}else if(res[0].MTR_REQ_DIV_CD=="5"){
    		if(res[0].REQ_STS_CD=="0" || res[0].REQ_STS_CD=="3" ||res[0].REQ_STS_CD=="4" ){
    			$("#mtrComp").show();
    		}
    	}
    } else if(res[0].DIVIDE=="MENTEE"){
    	$("#drag_plan").hide();
		$("#mtrMod").hide();    	
    	$("#planDel").hide();
    	$("#reportDel").show();
    	$("#drag_report").show();
    	//$("#mtrDel").hide();
    	$("#mtrComp").hide();
    	$("#mtrMod").hide();
    	//$("#mtrClose").hide();
    	$("#mtrStart").attr("readOnly", true);
    	$("#mtrEnd").attr("readOnly", true);	
    }else{
    	$("#drag_plan").hide();
    	$("#planDel").hide();
    	$("#reportDel").hide();
    	$("#drag_report").hide();
    	//$("#mtrDel").hide();
    	$("#mtrComp").hide();
    	$("#mtrMod").hide();
    	//$("#mtrClose").hide();
    	$("#mtrStart").attr("readOnly", true);
    	$("#mtrEnd").attr("readOnly", true); 
    }

    if(isManager ==true || isOperator ==true ||isSystem == true){
    	$("#mtrMod").show();
    	//$("#mtrDel").show();
    	$("#mtrStart").attr("readOnly", false);
    	$("#mtrEnd").attr("readOnly", false);
    }
    /* else if(res[0].MTR_TERM=="N"){ //멘토링 기간이 지나면 모두 안보이도록
    	$("#drag_plan").hide();
    	$("#planDel").hide();
    	$("#reportDel").hide();
    	$("#drag_report").hide();
    	$("#mtrDel").hide();
    	$("#mtrComp").hide();
    	$("#mtrMod").hide();
    	$("#mtrClose").hide();
    	$("#mtrStart").attr("readOnly", true);
    	$("#mtrEnd").attr("readOnly", true); 
    } */
    else if(res[0].MTR_TERM=="Y"){
    	$("#mtrMod").show();
    }
   
    if(res[0].MTR_REQ_DIV_CD=="5"){
		if(res[0].REQ_STS_CD=="2"){
			$("#reportDel").hide();
			$("#planDel").hide();
			$("#mtrMod").hide();
			$("#drag_plan").hide();
	    	$("#planDel").hide();
	    	$("#reportDel").hide();
	    	$("#drag_report").hide();
		}
	}
}

function insertReqBtn(){
	//부서장 권한에 따른 승인요청버튼/승인버튼
	var mnger = <%=isManager%>;
	if(mnger == true ){
		$("#insertReq").hide();
	}else{
		$("#insert").hide();
	}
}
function closeBtn(){
	$("#splitter").data("kendoSplitter").toggle("#list_pane",true);
	$("#splitter").data("kendoSplitter").toggle("#detail_pane",false);

};

 function insertReq(){
	//승인요청 팝업호출.
	var res = $('#menteeList').data('kendoGrid').dataSource.data();

	if($("#mentorNm").val() == null || $("#mentorNm").val() == ""){
		alert("멘토링명을 입력하십시오.");
		return;
	}
	if($("#mtrStart").val() == null || $("#mtrStart").val() == ""){
		alert("멘토링 시작일을 입력하십시오.");
		return;
	}
	if($("#mtrEnd").val() == null || $("#mtrEnd").val() == ""){
		alert("멘토링 종료일을 입력하십시오.");
		return;
	}
	if(ex_date("멘토링 시작일", "mtrStart")==false){
		return;
	}
	if(ex_date("멘토링 종료일", "mtrEnd")==false){
		return;
	}
	if($("#mentorText").val() == null || $("#mentorText").val() == ""){
		alert("멘토를 입력하십시오.");
		return;
	}
	if(res.length == 0){
		alert("멘티를 입력하십시오.");
		return;
	}
	$("#reqMod").val("creMod");
	apprReqOpen();
	apprReqCallBackFunc = apprReqExec;
} 

function completeReq(){
	var planData = $("#plan-file-gird").data('kendoGrid').dataSource.data();
	var reportData =$("#report-file-gird").data('kendoGrid').dataSource.data();
	 
	if(planData.length ==0){
		alert("훈련계획서가 없습니다.");
		return;
	}else if(reportData.length ==0){ 
		alert("훈련보고서가 없습니다.");
		return;
	}else{
		$("#reqMod").val("compMod");
		apprReqOpen();
		apprReqCallBackFunc = apprReqExec;
	}
}
//승인요청 처리 콜백 함수..
var apprReqExec = function(cmpltFlag){
	
	var apprReqDataSource = null;
		if($("#apprReqUserGrid").data("kendoGrid")){
			apprReqDataSource = $("#apprReqUserGrid").data("kendoGrid").dataSource.data();
		}

	if($("#reqMod").val() == "creMod"){	
		var params = {
	            APPR_LINE :  apprReqDataSource, //승인경로
	            MENTEE: $('#menteeList').data('kendoGrid').dataSource.data()  //맨티
	            
	    };
	}else if($("#reqMod").val() == "compMod"){
		var params = {
	            APPR_LINE :  apprReqDataSource //승인경로
	    };
	}
    //로딩바생성.
    loadingOpen();
    
    //승인요청
    $.ajax({
       type : 'POST',
       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/save_my_mtr.do?output=json",
       data : { 
    	   item: kendo.stringify( params ), 
    	   tu:$("#tu").val(),
    	   YYYY_TARG : $("#mtrStart").val(),
    	   LONG_TARG : $("#mtrEnd").val(),
    	   MTR_NAME : $("#mentorNm").val(),
    	   MENTOR_ID : $("#userId").val(),
    	   COMP_MTR_SEQ : $("#mtrSeq").val(),
    	   MOD : $("#reqMod").val(),
           CMPLT_FLAG : cmpltFlag,
           IS_MANAGER : <%=isManager%>
           
       },
       complete : function( response ){

           //로딩바 제거
          loadingClose();
           
           var obj = eval("(" + response.responseText + ")");
            if(obj.error){
                alert("ERROR=>"+obj.error.message);
            }else{
                if(obj.saveCount > 0){
                	if(cmpltFlag=="Y"){
                		alert("승인 요청이 완료되었습니다.");
                		 $("#grid").data('kendoGrid').dataSource.read();
	                		$("#splitter").data("kendoSplitter").toggle("#list_pane",true);
	                		$("#splitter").data("kendoSplitter").toggle("#detail_pane",false);
                       <%--  document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/mtr_run_list_pg.do";
                        document.frm.submit(); --%>

                	}
                   if(event.preventDefault){
                       event.preventDefault();
                   } else {
                       event.returnValue = false;
                   }
                }else{
                    alert("승인요청이 실패 하였습니다.");
                }
            }

       },
       error: function( xhr, ajaxOptions, thrownError){

           //로딩바 제거
          loadingClose();
           
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

function mentoNmDel(){
	$("#mentorText").val("");
}

function modifyMtr(){
	if(ex_date("멘토링 시작일", "mtrStart")==false){
		return;
	}
	if(ex_date("멘토링 종료일", "mtrEnd")==false){
		return;
	}
	
	// 멘토링 수정 ( 날짜만 수정한다.)
	var isDel = confirm("멘토링 기간을 저장하시겠습니까?");
	if(isDel){
		$.ajax({
		       type : 'POST',
		       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/modify_my_mtr.do?output=json",
		       data : { 
		    	   MTR_START : $("#mtrStart").val(),
		    	   MTR_END : $("#mtrEnd").val(),
		    	   MTR_SEQ : $("#mtrSeq").val()
		       },
		       complete : function( response ){
	
		           //로딩바 제거
		          loadingClose();
		           
		           var obj = eval("(" + response.responseText + ")");
		            if(obj.error){
		                alert("ERROR=>"+obj.error.message);
		            }else{
		                if(obj.saveCount > 0){
		                		alert("수정이 완료되었습니다.");
		                		$("#grid").data('kendoGrid').dataSource.read();
		                		$("#splitter").data("kendoSplitter").toggle("#list_pane",true);
		                		$("#splitter").data("kendoSplitter").toggle("#detail_pane",false);
		                   if(event.preventDefault){
		                       event.preventDefault();
		                   } else {
		                       event.returnValue = false;
		                   }
		                }else{
		                    alert("수정에 실패 하였습니다.");
		                }
		            }
	
		       },
		       error: function( xhr, ajaxOptions, thrownError){
	
		           //로딩바 제거
		          loadingClose();
		           
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
}

function fn_apprOpen(reqNum,reqType_cd ,cencleYn){

	//승인현황 팝업 호출.
	apprStsOpen(reqType_cd, reqNum, cencleYn );
	//승인취소 처리 후 callback 함수 정의
	reqCancelCompleteCallbackFunc = fn_afterReqCancel;
}

//승인요청 취소후 처리
function fn_afterReqCancel(){
	//그리드 내용 refresh.
	$("#grid").data("kendoGrid").dataSource.read();
	<%-- document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/mtr_run_list_pg.do";
    document.frm.submit(); --%>
	
}

function deleteMtr(){
	alert("삭제 할 수 없습니다. 부서장권한의 멘토링 승인 메뉴에서 가능하니 부서장 권한이 있으신 분께 문의해 주세요.");
	return;
}

//멘티 삭제 (ROW 삭제)
function fn_menteeDel(userId){
	if(userId != null && userId != "" ){
		isDel = confirm("맨티를 삭제 하시겠습니까?");
	}
	if(isDel){
		var array;
		array = $('#menteeList').data('kendoGrid').dataSource.data();
		var res = $.grep(array, function (e) {
			return e.USERID == userId;
		});
		
	    $($('#menteeList')).data('kendoGrid').dataSource.remove(res[0]);
	 }
}

//멘티 추가
function fn_empInsert(userId,mod){
	//var array;
	var popArray;
	var empArray;
	var overlap = true;
	
	
	popArray = $('#findEmp').data('kendoGrid').dataSource.data();
	var res = $.grep(popArray, function (e) {
		return e.USERID == userId;
	});
	
	//그리드의 유저 목록을 가져옴
	empArray = $($('#menteeList')).data('kendoGrid').dataSource.data();
	
	if(mod == "mentor"){
		if(empArray.length > 0){
			for(var i = 0 ; i < empArray.length ; i++){
				if(empArray[i].USERID == userId){
					alert("이미 멘티에 선택된 임직원입니다.");
					return;
				}
			}
		}
		$("#mentorText").val(res[0].NAME);
		$("#userId").val(res[0].USERID);
		$("#pop04").data("kendoWindow").close();
	}else if(mod == "mentee"){
		for(var i = 0 ; i < empArray.length ; i++){
			if(empArray[i].USERID == res[0].USERID ){
				overlap = false;
				break;
			}else{
				overlap = true;
			}
		}
		if($("#userId").val()==userId){
			alert("이미 멘토에 선택된 임직원입니다.");
			return;
		}
		
		if(overlap == true){
			$($('#menteeList')).data('kendoGrid').dataSource.insert(res[0]);
			$("#pop04").data("kendoWindow").close();
		}else{
			alert("이미 멘티에 선택된 임직원입니다.");
			return;
		}
		
		
	}
}

</script>
     
    </head>
<body>
    <form id="frm" name="frm"  method="post" >
        <input type="hidden" name="tu" id="tu" value="<%=action.getUser().getUserId()%>" />
        <input type="hidden" name="year" id="year" />
        <input type="hidden" name="userId" id="userId" />
        <input type="hidden" name="mtrSeq" id="mtrSeq" /> 
        <input type="hidden" name="reqNum" id="reqNum"/>
        <input type="hidden" name="reqMod" id="reqMod"/>	
    </form>
    
    <div class="container">
		<div id="cont_body">
		 <div class="content">
			 <div class="top_cont">
				<h3 class="tit01">멘토링</h3>
				<div class="point">
					※ 멘토링을 생성하고 활동 합니다. 
				</div>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>멘토링&nbsp; &#62;</span>
					<span class="h">멘토링 </span>
				</div><!--//location-->
			</div>
			 <div class="sub_cont">
				<div class="btn_right">
					<a class="k-button wid90" href="#" id="mtrCreat" >생성</a>
				</div><!--//btn_right-->
				 <div id="splitter" style="width:1220px; height: 580px; border:none;" class="mt10 mb10">
					<div id="list_pane">
						<div id="grid"></div>
					</div>
					<div id="detail_pane">
						<div class="detail_Info">
						</div>
					</div><!--//detail_pane-->
				</div>
			 </div><!--//sub_cont-->
		 </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->
	<script type="text/x-kendo-template"  id="template"> 
	<div class="tit">멘토링 생성</div>
		<div class="dl_wrap">
			<dl>
				<dt class="fir">멘토링명 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/></dt>
				<dd class="fir inp_top">
					<input id="mentorNm" type="text" class="k-textbox inp_style02" value="" style="width:270px;" title="멘토링명 입력"/>
				</dd>
			</dl>
			<dl>
				<dt> 멘토링기간 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/> </dt>
				<dd>
					<input type="text"  id="mtrStart" data-bind="value:MTR_ST_DT" style="width:125px;border:none;" title="멘토링 기간 시작"/> ~ 
					<input type="text" id="mtrEnd" data-bind="value:MTR_ED_DT" style="width:125px;border:none;" title="멘토링 기간 끝"/>
				</dd>
			</dl>
			<dl>
				<dt> 멘토 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/></dt>
				<dd>
					<input type="text" id="mentorText" class="k-textbox inp_style02" disabled style="width:270px;margin-right:1px;" title="멘토명 입력"/>
					<button  class="k-button wid60 ie7_left" onclick="empPop('mentor');">찾기</button>
					<button  onclick="mentoNmDel()" class="k-button  wid60">삭제</button>
				</dd>
			</dl>
			<dl>
				<dt class="last4"> 멘티 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif"  alt="필수"/></dt>
				<dd class="last4">
					<!--<input type="text" class="k-textbox inp_style02" value="" style="width:250px;margin-right:1px;" title="멘티명 입력"/>-->
					<div style="text-align:right"><button class="k-button wid60 ie7_left" onclick="empPop('mentee');">찾기</button></div>					
					<div id="menteeList"></div>
				</dd>
			</dl >
			<div class="btn_btm">
				<button id ="insertReq" class="k-primary k-button " style="width:75px;" onclick="insertReq();">생성요청</button>
				<button id ="insert" class="k-primary k-button " style="width:75px;" onclick="insertReq();">생성</button>
				<button id="close" class="k-button" style="width:75px;" onclick="closeBtn();">취소</button>
			</div>
		</div>
</script>
<script type="text/x-kendo-template"  id="detail_template">
<input type="hidden" name="mentorId" id="mentorId" />
<input type="hidden" name="menteeId" id="menteeId" />
<div class="tit">멘토링 </div>
	<div class="dl_wrap">
		<dl>
			<dt class="fir">멘토링명</dt>
			<dd class="fir">
				<strong data-bind="text:MTR_NM"></strong>
			</dd>
		</dl>
		<dl>
			<dt> 멘토링기간</dt>
			<dd>
				<input type="text"  id="mtrStart" data-bind="value:MTR_ST_DT" style="width:125px;border:none;" title="멘토링 기간 시작"/> ~ 
					<input type="text" id="mtrEnd" data-bind="value:MTR_ED_DT" style="width:125px;border:none;" title="멘토링 기간 끝"/>
			</dd>
		</dl>
		<dl>
			<dt> 멘토 / 멘티</dt>
			<dd>
				<strong data-bind="text:MENTOR_NM"></strong> / <strong data-bind="text:MENTEE_NM"></strong>
			</dd>
		</dl>
		<dl>
			<dt> 훈련계획서</dt>
			<dd>
				<div class="drag_Area" id="drag_plan">
					<div class="info">업로드할 파일은 아래의 파일선택 버튼을 클릭하여 직접 선택하거나, <br/>아래의 영역에 파일를 끌어서 놓기(Drag & Drop)를 하세요</div>
					<div class="area">
							<div id="plan-file-upload" class="hide"></div>
					</div>
				</div>
				<div class="table_wp03">
                        <div id="plan-file-gird" ></div>
				</div>
				
			</dd>
		</dl>
		<dl>
			<dt> 훈련보고서</dt>
			<dd style="padding-bottom:98px;">
				<div class="drag_Area" id="drag_report">
					<div class="info">업로드할 파일은 아래의 파일선택 버튼을 클릭하여 직접 선택하거나, <br/>아래의 영역에 파일를 끌어서 놓기(Drag & Drop)를 하세요</div>
					<div class="area">
							<div id="report-file-upload" class="hide"></div>
					</div>
				</div>
				<div class="table_wp03">
                        <div id="report-file-gird" ></div>
				</div>
				<div class="btn_btm2">
					<!--<button class="k-button" style="width:75px;" id="mtrDel" onclick ="deleteMtr()">삭제</button>-->
					<button class="k-button" style="width:75px;" id="mtrMod" onclick ="modifyMtr()">수정</button>
					<button class="k-button" style="width:75px;" id="mtrComp" onclick="completeReq();">완료요청</button>
					<button class="k-button" style="width:75px;" id="mtrClose" onclick="closeBtn();">취소</button>
				</div>
			</dd>
		</dl>
		
	</div>
</script>

    <!-- 첨부파일 template -->
    <script type="text/x-kendo-tmpl" id="plan-fileupload-template">
        <input name="plan-upload-file" id="plan-upload-file" type="file"/>
    </script>
     <!-- 첨부파일 template -->
    <script type="text/x-kendo-tmpl" id="report-fileupload-template">
        <input name="report-upload-file" id="report-upload-file" type="file"/>
    </script>
    
<%@ include file="/includes/jsp/user/common/apprStsPopup.jsp"  %>
<%@ include file="/includes/jsp/user/common/apprReqPopup.jsp"  %>
<%@ include file="/includes/jsp/user/common/findEmployeePopup.jsp"  %>
</body>
</html>