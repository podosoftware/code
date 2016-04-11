<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
filename : assmExctStsList.jsp
note : 역량진단결과 > 진단실시현황
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
        
        //진단년도 데이터소스
        var dataSource_yyyy = new kendo.data.DataSource({
	        type: "json",
	        transport: {
	            read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/get_run_yyyy_list.do?output=json", type:"POST" },
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
	        serverSorting: false
		});
        dataSource_yyyy.fetch(function(){
        	yyyy.select(0);
        	runListFilter();
        });
        
        //진단목록 데이터소스
        var dataSource_runlist = new kendo.data.DataSource({
	        type: "json",
	        transport: {
	            read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/get_run_history_list.do?output=json", type:"POST" },
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
	        serverSorting: false
		});
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
        }
        
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
        
        //진단실시현황 그리드
        var grid = $("#grid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/get_assm_exct_sts_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){ 
                        var sortField = "";
                        var sortDir = "";
                        if (options.sort && options.sort.length>0) {
                            sortField = options.sort[0].field;
                            sortDir = options.sort[0].dir;
                        }
                        return { 
                            startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter), runNum: runList.value()
                        };
                    }        
                },
                schema: {
                    total: "totalItemCount",
                    data: "items",
                       model: {
                    	   id : 'USERID',
                           fields: {
                        	   RUN_NUM  : { type: "number" },
                               CHECKFLAG : { type: "string" },
                               EMPNO : { type : "string" },
                               USERID : {type:"number"},
                               NAME : {type:"string"},
                               DVS_NAME : {type:"string"},
                               LEADERSHIP_NAME : { type:"string" },
                               JOB_NAME : { type:"string"},
                               GRADE_NM : { type: "string" },
                               STATE : { type: "string" },
                               T_CNT : { type: "number" },
                               C_CNT : { type: "number" }
                           }
                       }
                },
                pageSize: 30,
                serverPaging: true,
                serverFiltering: true,
                serverSorting: true
            },
            height: 550,
            groupable: false,
            filterable:{
                extra : false,
                messages : { filter : "필터", clear : "초기화" },
                operators : {
                    string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
                    number : { eq : "같음", gte : "이상", lte : "이하" }
                }
            },
            sortable: true,
            pageable : true,
            resizable: true,
            reorderable: true,
            selectable: "row",
            pageable : {
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
                field: "DVS_NAME",
                title: "부서",
                width:120,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            }, 
            {
                field: "NAME",
                title: "진단자",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            }, 
            {
                field: "EMPNO",
                title: "교직원번호",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            }, 
            {
                field: "GRADE_NM",
                title: "직급",
                width: 140,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "LEADERSHIP_NAME",
                title: "계급",
                width: 100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "JOB_NAME",
                title: "직무",
                width: 120,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "STATE",
                title: "상태",
                width: 80,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "T_CNT",
                title: "진단현황",
                width: 140,
                filterable:false,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}, 
                template: function(data){
                	return data.T_CNT+"명 중 "+data.C_CNT+"명 완료";
                }
            },
            {
                title: "상태변경",
                width: 160,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(data){
                    if(data.STATE == "완료"){
                        return "<input type=\"button\" class=\"k-button k-i-close\" style=\"width:45\" value=\"초기화\" onclick=\"fn_diagInit('I', "+data.USERID+");\"/>"+
                        "<input type=\"button\" class=\"k-button k-i-close\" style=\"width:45\" value=\"임시저장\" onclick=\"fn_diagInit('T', "+data.USERID+");\"/>";
                    }else{
                        return "";
                    }
                }
            }]
        }).data("kendoGrid");

    }
    
}]);

// 전체선택..
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

//초기화 버튼 클릭..
function fn_diagInit(div, userid){
	var runItem = $("#runList").data("kendoDropDownList").dataItem();
    
    if(runItem!=null){
        if( runItem.PERIOD_FLAG != "I" ){
        	alert("역량진단기간이 아닙니다.");
        	return false;
        }
        
        var msg = "";
        if(div=="I"){
        	msg = "진단한 내용을 모두 삭제하고 초기화 하시겠습니까?";
        }else{
        	msg = "재진단이 가능한 상태로 변경하시겠습니까?\n진단내용은 삭제되지 않습니다.";
        }
        if (confirm(msg)) {
            //로딩바생성
            loadingOpen();
            
            $.ajax({
                type : 'POST',          
                url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/change_assm_sts.do?output=json",
                data : {
                	RUN_NUM : runItem.RUN_NUM,
                	USERID : userid,
                	EVL_FLAG : div
                },
                complete : function( response ){
                    //로딩바 제거
                    loadingClose();
                    
                    var obj  = eval("(" + response.responseText + ")");
                    if(!obj.error){
                        if(obj.saveCount > 0){         
                            $("#grid").data("kendoGrid").dataSource.read();
                            
                            alert("변경 되었습니다.");  
                        }else{
                            alert("변경 실패 하였습니다. 교육운영자에게 문의해주세요.");
                        }   
                    }else{
                        alert("ERROR: "+obj.error.message);
                    }                       
                },
                error : function(xhr, ajaxOptions, thrownError) { 
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
}

//엑셀다운로드
function excelDownload(button){
    if($("#runList").val()==null || $("#runList").val()==""){
       alert("진단을 선택해주세요.");
       return false;
   }
   button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/assm_exct_sts_excel_list.do?RUN_NUM="+$("#runList").val()+"&RUN_NAME="+ $("#runList").data("kendoDropDownList").text();
}

// 독려 메일 발송
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
            	type : 'CAR'
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
            	type : 'CAR'
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

</script>
<style scoped>
	.demo-section {width:120px;}
    .demo-section2 {width:250px;}
</style>        
</head>
<body>
    <div class="container">
        <div id="cont_body">
         <div class="content">
             <div class="top_cont">
                <h3 class="tit01">진단실시현황</h3>
                <div class="point">
                    ※ 진단 실시 별 진단자들의 진단 현황을 열람할 수 있습니다.<br/>※ 완료한 진단에 대해 재진단을 실시하고자 할 경우 “초기화” 또는 "임시저장" 버튼을 클릭하시면 됩니다.
                </div>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>역량진단결과&nbsp; &#62;</span>
                    <span class="h">진단실시현황</span>
                </div><!--//location-->
            </div>
             <div class="sub_cont">
                
                <div class="result_info">
                    <ul>
                        <li class="fir">
                        <label for="p_year">진단 선택  : </label>
                            <div class="demo-section k-header style01" id="p_year">
                                <select id="yyyy" style="width: 120px" accesskey="w"></select>
                            </div>
                             <style scoped>
                                .demo-section.style01 {width:120px;}
                                .k-input {padding-left:5px;}
                            </style>       
                        </li>  
                        <li>
                            <label for="p_name" class="blind">진단명 : </label>
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
                        <a class="k-button" onclick="excelDownload(this)" >엑셀 다운로드</a>
                    </div>
                </div><!--//result_info-->
                <div id="grid" class="mt15" style="height:550px;"></div>

             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div><!--//container-->
</body>
</html>