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
     #menteeList{
    	min-height : 70px;
    }              

</style>
<script type="text/javascript"> 

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
        
        //년도 받아오기
        var yyyyDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/mtr_year_list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){ 
                 return { };
                }        
            },
            schema: {
                data: "items",
                model: {
                       fields: {
                           YYYY: { type: "string" }
                       }
                   }
            }
        });
        
      //요청년도 콤보박스
      $("#yyyy").kendoDropDownList({
          dataTextField: "TEXT",
          dataValueField: "YYYY",
          dataSource: yyyyDataSource,
          filter: "contains",
          suggest: true,
          index: 0,
          width: 120,
          change: function() {
              runFilter();
           },
           dataBound:function(e){
               if(yyyyDataSource.data().length>0){
                   runFilter();
               }
           }
      }).data("kendoDropDownList");
      //요청 년도 필터
      function runFilter(){
	        if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
	            $("#grid").data("kendoGrid").dataSource.filter({
	                "field":"YYYY",
	                "operator":"eq",
	                "value":Number($("#yyyy").val())
	            });
	        }else{
	            $("#grid").data("kendoDropDownList").dataSource.filter({});
	        }
	    }
      
      
        //생성 detail 그리기
        $('.detail_Info').show().html(kendo.template($('#cmop_detail_template').html()));
        
        //메인 리스트
        $("#grid").empty();
		$("#grid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/mtr_run_admin_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){	
                    	var sortField = "";
                    	var sortDir = "";
                    	if (options.sort && options.sort.length>0) {
                    		sortField = options.sort[0].field;
                    		sortDir = options.sort[0].dir;
                        } 
                	   return {
                        	startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter) 
                        };
                    } 		
                },
                schema: {
                	data: "items3",
                	total : "totalItemCount",
                    model: {
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
                pageSize: 30,serverPaging:true, serverFiltering:true, serverSorting:true
            },
            columns: [
				{
				    field:"DVS_NAME",
				    title: "부서명",
				    width:105,
				    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
				    attributes:{"class":"table-cell", style:"text-align:center;"},
				},
				{
				    field:"DVS_FULLNAME",
				    title: "전체부서명",
				    width:120,
				    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
				    attributes:{"class":"table-cell", style:"text-align:center;"},
				},
				{
				    field:"NAME",
				    title: "요청자",
				    width:95,
				    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
				    attributes:{"class":"table-cell", style:"text-align:center;text-decoration: underline;"},
				    template:"<a href='javascript:fn_detailView(${MTR_SEQ});'> ${NAME} </a>"
				},
				{
				    field:"GRADE_NM",
				    title: "직급",
				    width:110,
				    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
				    attributes:{"class":"table-cell", style:"text-align:center;"},
				},
				{
				    field:"APP_DIVISION",
				    title: "승인구분",
				    width:110,
				    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
				    attributes:{"class":"table-cell", style:"text-align:center;"}
				},
                {
                    field:"MTR_NM",
                    title: "멘토링명",
                    width:125,
                    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                attributes:{"class":"table-cell", style:"text-align:center;text-decoration: underline;"},
					template:"<a href='javascript:fn_detailView(${MTR_SEQ});'> ${MTR_NM} </a>"
                },
                {
                    field:"MTR_DATE",
                    title: "멘토링기간",
                    width:120,
                    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                {
                    field:"MENTOR_NM",
                    title: "멘토",
                    filterable: true,
                    width:80,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                {
                    field: "MENTEE_NM",
                    title: "멘티",
					width:80,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center;"},
                },
                /* {
                    field: "LAST_REQ_STS_NM",
                    title: "승인상태",
                    width:105,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"},
                }, */
                {
                    field: "HRD_ADMIN_NM",
                    title: "최종확정",
                    width:115,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"},
                } 
                /* {
                    field: "REQ_STS_CD",
                    title: "승인현황",
                    width:105,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"},
                    template: function(data){
                    	if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
                            return "";
                        }else{
                            if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
                                return "";
                            }else{ //승인요청상태
                                return "<button class=\"k-button\" onclick=\"javascript: fn_apprOpen("+data.REQ_NUM+","+data.MTR_REQ_DIV_CD+")\" >승인현황</button>";
                            }
                        }
                    }
                } */
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
		numTexBox();
    }
}]);
</script>

<script type="text/javascript">
//맨티목록 그리드
function menteeList(mtrSeq){
	$("#menteeList").kendoGrid({
        dataSource: {
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/mtr_mentee_list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){	
                	return { MTR_SEQ : mtrSeq  };
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
                attributes:{"class":"table-cell", style:"text-align:center;"},
				template:{}
            },
            {
                field:"DVS_NAME",
                title: "부서",
                width:50,
                filterable: true,
				headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"} 
            }
        ],
        filterable: false,
    	pageSize: 99999,
		groupable: false,
		sortable: true,
		resizable: true,
		reorderable: true,
		pageable: false
    });
}

// 첨부파일 함수 시작 
function handleCallbackUploadResult(){
    $("#plan-file-gird").data('kendoGrid').dataSource.read();
    $("#report-file-gird").data('kendoGrid').dataSource.read();
}

function planFileUpdown(){
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
                    	return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>'
                    } 
                }
             ]
         });
     }else{
         handleCallbackUploadResult();
     }
    	
}
function reportFileUpdown(){
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
                   		return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>'
                   } 
               }
            ]
        });
    }else{
        handleCallbackUploadResult();
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
//스플리터 expand.. 수정영역
function fn_detailView(mtrSeq){
	
	$("#splitter").data("kendoSplitter").expand("#detail_pane");
	
	// show detail   
	
		
	var grid = $("#grid").data("kendoGrid");
    var data = grid.dataSource.data();
    
    var res = $.grep(data, function (e) {
        return e.MTR_SEQ == mtrSeq;
    });
	
    	//완료 디테일창
    $('.detail_Info').show().html(kendo.template($('#cmop_detail_template').html()));
    	
    menteeList(res[0].MTR_SEQ); //멘티리스트
    var selectedCell = res[0];
    
    kendo.bind( $(".dl_wrap"), selectedCell ); //디테일창 바인딩
    
    $("#mtrSeq").val(mtrSeq);
    $("#reqNum").val(res[0].REQ_NUM);
    //파일 업로드 다운로드를 위한 value
    $("#mentorId").val(mtrSeq);
    $("#menteeId").val(res[0].MENTEE_SEQ);

   
    planFileUpdown(); //계획서 다운로드 출력
    reportFileUpdown(); //보고서 다운로드 출력
    
    numTexBox(); //날짜 형식 유효성
   if(res[0].MTR_REQ_DIV_CD == "5"){ //구분이 완료일 경우 다운로드 호출
	   handleCallbackUploadResult();
   }
   if(res[0].HRD_ADMIN_YN == "Y"){ //맨토링이 최종 승인 되면 버튼 숨김
	   $("#mtrApprovel").hide();
	   $("#mtrNotApprovel").hide();ㄴ
   }
}
//승인처리
 function apprReq(mod){
		var isDel = confirm("해당 멘토링을 최종 확정처리하시겠습니까?");
		if(isDel){
		 //승인요청
		    $.ajax({
		       type : 'POST',
		       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/mtr_last_app_save.do?output=json",
		       data : {
		    	   tu:$("#tu").val(),
	    	   	   MTR_SEQ : $("#mtrSeq").val(),
	    	   	   MOD : mod,
	    	   	   MTR_START : $("#mtrStart").val(),
	     	       MTR_END : $("#mtrEnd").val()
		       },
		       complete : function( response ){
		           //로딩바 제거
		          loadingClose();
		           
		           var obj = eval("(" + response.responseText + ")");
		            if(obj.error){
		                alert("ERROR=>"+obj.error.message);
		            }else{
		                if(obj.saveCount > 0){
		                	if(mod == "Y"){
		                		alert("최종 승인이 완료되었습니다.");
		                	}else if(mod == "N"){
		                		//alert("최종 미승인 되었습니다.");
		                	}
	                	    $("#grid").data('kendoGrid').dataSource.read();
	                		$("#splitter").data("kendoSplitter").toggle("#list_pane",true);
	                		$("#splitter").data("kendoSplitter").toggle("#detail_pane",false);
		                }else{
		                    alert("최종 확정처리에 실패 하였습니다.");
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

function fn_apprOpen(reqNum,mtrType_cd){
	//승인현황 팝업 호출.
	apprStsOpen(mtrType_cd, reqNum);
	//승인취소 처리 후 callback 함수 정의
	reqCancelCompleteCallbackFunc = fn_afterReqCancel;
}
//승인요청 취소후 처리
function fn_afterReqCancel(){
	//그리드 내용 refresh.
	$("#grid").data("kendoGrid").dataSource.read();
	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/mtr_run_list_pg.do";
    document.frm.submit();
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
    </form>
    
    <div class="container">
		<div id="cont_body">
		 <div class="content">
			 <div class="top_cont">
				<h3 class="tit01">멘토링 관리</h3>
				<div class="point">
					※ 멘토링 활동에 대한 멘토의 인정시간을 부여합니다.
				</div>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>멘토링&nbsp; &#62;</span>
					<span class="h">멘토링관리</span>
				</div><!--//location-->
			</div>
			 <div class="sub_cont">
				<div class="result_info">
					<ul >
						<li>
						<label for="p_year" style = "line-height:32px;">요청년도  : </label>
							<div class="demo-section k-header style01" id="p_year" >
							<select id="yyyy" style="width:120px;" accesskey="w" ></select>
							</div>
							 <style scoped>
								.demo-section.style01 {width:120px;}
								.k-input {padding-left:5px;}
							</style>       
						</li>  
					</ul>
				</div><!--//result_info-->
				
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
<script type="text/x-kendo-template"  id="cmop_detail_template">
<input type="hidden" name="mentorId" id="mentorId" />
<input type="hidden" name="menteeId" id="menteeId" />
<div class="tit">멘토링 완료 </div>
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
				<input type="text"  id="mtrStart" disabled data-bind="value:MTR_ST_DT" style="width:125px;border:none;" title="멘토링 기간 시작"/> ~ 
					<input type="text" id="mtrEnd" disabled data-bind="value:MTR_ED_DT" style="width:125px;border:none;" title="멘토링 기간 끝"/>
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
				<div >
                        <div id="plan-file-gird" ></div>
				</div>
				
			</dd>
		</dl>
		<dl>
			<dt> 훈련보고서</dt>
			<dd style="padding-bottom:100px;">
				<div >
                        <div id="report-file-gird" ></div>
				</div>
				<div class="btn_btm2">
					<button class="k-button" style="width:100px;" id="mtrApprovel" onclick="apprReq('Y');">최종확정처리</button>
					<!--<button class="k-button" style="width:75px;" id="mtrNotApprovel" onclick="apprReq('N');">미승인</button>-->
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
</body>
</html>