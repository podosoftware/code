<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
filename : userCdpPlanStateList.jsp
note : 경력개발계획 > 계획수립현황
role : 총괄관리자, 부서장
--%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage">
<head>
<title></title>
<script type="text/javascript"> 
yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.<%=theme%>.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'        
    ],
    complete: function() {
        kendo.culture("ko-KR");
        
      	//로딩바 선언..
        loadingDefine();
        
        //경력개발계획 년도 데이터소스
        var dataSource_yyyy = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_run_yyyy_list_cdp.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {};
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            YYYY : { type: "number" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
        dataSource_yyyy.fetch(function(){
        	yyyy.select(0); 
        	runListFilter();
        });
        
        //경력개발계획 실시목록 데이터소스
        var dataSource_runlist = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_run_history_list_cdp.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {};
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            YYYY : { type: "number" },
                            RUN_NUM : { type: "number" }, 
                            RUN_NAME : { type: "string" }, 
                            PERIOD_FLAG  : { type: "string" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
        dataSource_runlist.fetch(function(){
        	runListFilter();
        });      
        
        
        //진단이력 필터링
        var runListFilter = function(){
        	//년도와 이력 모두 존재하면 filtering
        	if(dataSource_yyyy!=null && dataSource_yyyy.data().length>0 && dataSource_runlist!=null && dataSource_runlist.data().length>0){
        		var tmpYear = 0;
        		if(yyyy.value()==null || yyyy.value()==undefined || yyyy.value() == ""){
        			tmpYear = dataSource_yyyy.data()[0].YYYY;
        		}else{
        			tmpYear = yyyy.value();
        		}
        		dataSource_runlist.filter({
                    "field":"YYYY",
                    "operator":"eq",
                    "value": Number(tmpYear)
                });
        		gridRead();
        	}
        };
        
        //진단년도
        var yyyy = $("#yyyy").kendoDropDownList({
                 dataTextField: "YYYY_TEXT",
                 dataValueField: "YYYY",
                 dataSource: dataSource_yyyy,
                 filter: "contains",
                 suggest: true,
                 change: function(){
                	 runListFilter();
                 }
             }).data("kendoDropDownList");
        

        //진단목록
        var runList = $("#runList").kendoDropDownList({
                 dataTextField: "RUN_NAME",
                 dataValueField: "RUN_NUM",
                 dataSource: dataSource_runlist,
                 filter: "contains",
                 suggest: true,
                 change: function(){
                	 gridRead();
                 }
             }).data("kendoDropDownList");
        
        var gridRead = function(){
        	grid.dataSource.read();
        };

        var grid = $("#grid").kendoGrid({
               dataSource: {
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_state_list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){ 
                            return { runNum: runList.value() };
                        }        
                    },
                    schema: {
                        total: "totalItemCount",
                        data: "items",
                           model: {
                        	   id : 'USERID',
                               fields: {
                                   RUN_NUM  : { type: "int" },
                                   RUN_NAME : { type : "string" },
                                   USERID : {type:"int"},
                                   NAME : {type:"string"},
                                   EMPNO : { type:"string" },
                                   DVS_NAME : { type:"string"},
                                   DVS_FULLNAME : { type:"string"},
                                   GRADE_NM : { type:"string"},
                                   EVL_CMD : { type:"string"},
                                   CHECKFLAG : { type: "string" }
                               }
                           }
                    },
                    pageSize: 20,
                    serverPaging: false,
                    serverFiltering: false,
                    serverSorting: false
                },
                height: 550,
                groupable: false,
                selectable: "multiple",
                filterable:{
                    extra : false,
                    messages : { filter : "필터", clear : "초기화" },
                    operators : {
                        string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
                        number : { eq : "같음", gte : "이상", lte : "이하" }
                    }
                },    
                sortable: true,
                resizable: true,
                reorderable: true,
                pageable: {
                	refresh : false,
                    pageSizes : [10,20,30]
                },
                columns: [
					{
					    field: "",
					    title: "선택",
					    width: 60,
					    filterable:false,
					    sortable: false,
					    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
					    attributes:{"class":"table-cell", style:"text-align:center"},
					    headerTemplate: "선택<br><input type=\"checkbox\" id='allchkbox' onchange=\"modifyAllCheck(this);\" />",
					    template:"<div style=\"text-align:center\"><input type=\"checkbox\" onclick=\"modifyYnFlag(this, #: USERID #)\" #: CHECKFLAG #\></div>" 
					},
                    {
                        field:"DVS_NAME",
                        title: "부서명",
                        width: 150,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    {
                        field:"DVS_FULLNAME",
                        title: "전체부서명",
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"}
                    },
                    {
                        field:"NAME",
                        title: "성명",
                        width: 150,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center; text-decoration: underline;"},
                        template:function(data){
                        	return "<a href=\"javascript:void(0);\" onclick=\"javascript: fn_cdpApprOpen2("+data.RUN_NUM+", "+data.USERID+","+data.REQ_STS_CD+","+data.REQ_NUM+")\" >"+data.NAME+"</a>";
                        }
                    },
                    {
                        field:"EMPNO",
                        title: "교직원번호",
                        width: 100,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field:"GRADE_NM",
                        title: "직급",
                        width: 150,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field:"EVL_CMD2",
                        title: "상태",
                        width: 150,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    /*{
                        title: "상태",
                        width:180,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template: function (data) {
                            if(data.EVL_CMD=="계획대기"){
                                return "<button class=\"k-button\" onclick=\"javascript:alert('아직 계획이 시작하지 않았습니다'); \" >계획대기</button>";
                            }else if(data.EVL_CMD=="계획중"){
                            	if(data.USERID==null || data.USERID==""){
                            		return "<button class=\"k-button\"  onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" >계획실시</button>";
                            	}else{
                            		if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
                            			return "<button class=\"k-button\" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" >계속계획</button>";
                            		}else{
                            			if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
                            				return "<button class=\"k-button\" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" >계속계획</button>";
                            			}else if(data.REQ_STS_CD=="1"){ //승인요청상태
                            				return "<button class=\"k-button\" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" >승인대기</button>";
                                        }else if(data.REQ_STS_CD=="2"){ //승인상태
                                        	return "<button class=\"k-button\" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" >승인</button>";
                                        }else if(data.REQ_STS_CD=="3"){ //반려상태
                                        	return "<button class=\"k-button\" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" >반려</button>";
                                        }
                            		}
                            	}
                            }else if(data.EVL_CMD=="계획종료"){
                            	if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
                                    return "미작성";
                                }else{
                                    if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
                                        return "미작성";
                                    }else if(data.REQ_STS_CD=="1"){ //승인요청상태
                                        return "<button class=\"k-button\" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" >승인대기</button>";
                                    }else if(data.REQ_STS_CD=="2"){ //승인상태
                                        return "<button class=\"k-button\" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" >승인</button>";
                                    }else if(data.REQ_STS_CD=="3"){ //반려상태
                                        return "<button class=\"k-button\" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" >반려</button>";
                                    }
                                }
                            }
                            return "";
                        }
                    },*/
                    {
                    	title: "승인현황",
                    	width: 100,
                    	headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function(data){
                        	if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
                                return "";
                            }else{
                                if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
                                    return "";
                                }else{ //승인요청상태
                                    return "<button class=\"k-button\" onclick=\"javascript: fn_apprOpen("+data.REQ_NUM+")\" >승인현황</button>";
                                }
                            }
                        }
                    }                
                ]
            }).data("kendoGrid");
    }
    
}]);

function fn_cdpApprOpen2(runNum, reqUserid, reqStsCd, reqNum){
	if(reqStsCd!='2'){
		alert("계획이 완료된 건이 아닙니다.");
		return false;
	}
	cdpPlanOpen(runNum, reqUserid, reqNum);
	
	//reqApprCompleteCallbackFunc = fn_afterReqCancel;
}

function fn_apprOpen(reqNum){
	//승인현황 팝업 호출.
	apprStsOpen(1, reqNum);
	//승인취소 처리 후 callback 함수 정의
	reqCancelCompleteCallbackFunc = fn_afterReqCancel;
}

//승인요청 취소후 처리
function fn_afterReqCancel(){
	$("#grid").data("kendoGrid").dataSource.read();
}

function fn_planExec(runNum, yyyy){
	$("#rn").val(runNum);
    $("#year").val(yyyy);

    document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/user_cdp_exec_pg.do"
    document.frm.submit();
}

//엑셀다운로드
function excelDownload(button){
   button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_state_list_excel.do?RUN_NUM="+$("#runList").val()+"&RUN_NAME="+ $("#runList").data("kendoDropDownList").text();
}

//교육계획 엑셀다운로드
function eduPlanExcelDownload(button){
	button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_edu_plan_state_list_excel.do?RUN_NUM="+$("#runList").val()+"&RUN_NAME="+ $("#runList").data("kendoDropDownList").text();
}
//전체선택..
function modifyAllCheck(checkbox){
    var array = $("#grid").data("kendoGrid").dataSource.view();
    $.each(array, function(i,e){
    	if(checkbox.checked == true){
            e.CHECKFLAG = "checked";
        }else{
            e.CHECKFLAG = "";
        }
    });
    $("#grid").data("kendoGrid").refresh();         
}

// 체크박스 체크..
function modifyYnFlag(checkbox, id){
    var item = $("#grid").data("kendoGrid").dataSource.get(id);
    if(checkbox.checked == true){
    	item.CHECKFLAG = 'checked';
    }else{
    	item.CHECKFLAG = "";
    	
    	// 전체선택 버튼 해제
    	$('#allchkbox').removeAttr('checked');
    }
}

//독려 메일 발송
function mailEncourageSend(){
    var gridData = $("#grid").data("kendoGrid").dataSource.view();
    
    var userArr = new Array();
    for(var i=0; i<gridData.length; i++){
        if(gridData[i].CHECKFLAG=="checked"){
        	userArr.push(gridData[i].USERID);
        }
    }
    if(userArr==null || userArr.length==0){
        alert("메일 발송 대상을 체크해주세요.");
        return false;
    }
    
    if(confirm("메일을 발송 하시겠습니까?")) { 
        //로딩바생성
        loadingOpen();
        
        $.ajax({
            type : 'POST',
            url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/encourage_mail_send.do?output=json",
            data : {
            	rnum : $("#runList").data("kendoDropDownList").value(),
            	rname : $("#runList").data("kendoDropDownList").text(), 
            	item: userArr.join(','),
            	type : 'CDP'
            },
            complete : function( response ){
                //로딩바 제거
                loadingClose();
                
                var obj  = eval("(" + response.responseText + ")");
                if(obj.error==null){
                    if(obj.saveCount > 0){
                        alert("메일이 발송되었습니다");   
                    }else{
                        alert("메일이 발송에 실패 하였습니다.");
                    }
                }else{
                    alert("error:"+obj.error.message);
                }                    
            },
            error: function( xhr, ajaxOptions, thrownError){    
                //로딩바 제거
                loadingClose();

                if(xhr.status==403){
                    alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                    sessionout();
                }else{
                	alert('xrs.status = '+xhr.status+'\n'+'thrown error = '+thrownError+'\n'+'xhr.statusText = '+xhr.statusText);
                }
            },
            dataType : "json"
        });     
     }
}

// 독려 SMS 발송 
function smsEncourageSend(){
    var gridData = $("#grid").data("kendoGrid").dataSource.view();
    
    var userArr = new Array();
    for(var i=0; i<gridData.length; i++){
        if(gridData[i].CHECKFLAG=="checked"){
        	userArr.push(gridData[i].USERID);
        }
    }
    if(userArr==null || userArr.length==0){
        alert("SMS 발송 대상을 체크해주세요.");
        return false;
    }
    
    if(confirm("SMS을 발송 하시겠습니까?")) { 
        //로딩바생성
        loadingOpen();
        
        $.ajax({
            type : 'POST',
            url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/encourage_sms_send.do?output=json",
            data : {
            	rnum : $("#runList").data("kendoDropDownList").value(),
            	rname :  $("#runList").data("kendoDropDownList").text(), 
            	item: userArr.join(','),
            	type : 'CDP'
            },
            complete : function( response ){
                //로딩바 제거
                loadingClose();
                
                var obj  = eval("(" + response.responseText + ")");
                if(obj.error==null){
                    if(obj.saveCount > 0){
                        alert("SMS가 발송되었습니다");   
                    }else{
                        alert("SMS 발송에 실패 하였습니다.");
                    }
                }else{
                    alert("error : "+obj.error.message);
                }                    
            },
            error: function( xhr, ajaxOptions, thrownError){    
                //로딩바 제거
                loadingClose();

                if(xhr.status==403){
                    alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                    sessionout();
                }else{
                	alert('xrs.status = '+xhr.status+'\n'+'thrown error = '+thrownError+'\n'+'xhr.statusText = '+xhr.statusText);
                }
            },
            dataType : "json"
        });     
     }
}
</script>
    <style scoped>
    .demo-section {width:120px;}
    .demo-section2 {width:250px;}
    </style>
</head>
<body>
    <form id="frm" name="frm" method="post" >
        <input type="hidden" name="rn" id="rn" />
        <input type="hidden" name="tu" id="tu" />
        <input type="hidden" name="year" id="year" />
    </form>
    
	<div class="container">
		<div id="cont_body">
		 <div class="content">
			 <div class="top_cont">
				<h3 class="tit01">계획수립현황</h3>
				<div class="point">
					※ 임직원들의 경력개발수립 현황을 열람할 수 있습니다.
				</div>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>경력개발계획&nbsp; &#62;</span>
					<span class="h">계획수립현황</span>
				</div><!--//location-->
			</div>
			 <div class="sub_cont">				
				<div class="result_info">
					<ul>
						<li>
						<label for="p_year">계획선택  : </label>
							<div class="demo-section k-header style01" id="p_year">
								<select id="yyyy" style="width: 120px" accesskey="w"></select>
							</div>
							 <style scoped>
								.demo-section.style01 {width:120px;}
								.k-input {padding-left:5px;}
							</style>       
						</li>  
						<li>
							<label for="p_name " class="blind">평가명 : </label>
							<div class="demo-section k-header style02" id="p_name">
								<select id="runList"  style="width: 250px" accesskey="w"></select>
							</div>
							 <style scoped>
								.demo-section.style02 {width:250px;}
								.k-input {padding-left:5px;}
							</style>    
						</li>
					</ul>
                    <div class="btn">
                    	<a class="k-button" onclick="smsEncourageSend()" >SMS발송</a>
                        <a class="k-button" onclick="mailEncourageSend()" >독려메일발송</a>
                        <a class="k-button"  onclick="eduPlanExcelDownload(this)" >교육계획 엑셀다운로드</a>
                        <a class="k-button"  onclick="excelDownload(this)" >엑셀 다운로드</a>
                    </div>					
				</div><!--//result_info-->
				<div id="grid" class="mt15" style="height:550px;"></div>

			 </div><!--//sub_cont-->
		 </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->
<%@ include file="/includes/jsp/user/common/apprStsPopup.jsp"  %>
<%@ include file="/includes/jsp/user/cdp/userCdpPlanPopup.jsp"  %>
</body>
</html>