<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}

kr.podosoft.ws.service.car.action.CarServiceAction action = (kr.podosoft.ws.service.car.action.CarServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage"   >
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
                serverSorting: false});
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
        	    grid.dataSource.read();
        	}
        }
        
        //직무목록 데이터소스
        var dataSource_joblist = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/get_job_leadership_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return { JOBLDR_FLAG: "J" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                        	JOBLDR_NUM : { type: "number" },
                        	JOBLDR_NAME : { type: "string" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
        
        //계급목록 데이터소스
        var dataSource_leadershiplist = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/get_job_leadership_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return { JOBLDR_FLAG: "L" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            JOBLDR_NUM : { type: "number" },
                            JOBLDR_NAME : { type: "string" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});

        
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
                	 //gridRead();
                 }
             }).data("kendoDropDownList");
        

        //직무목록
        var carjobList = $("#carjobList").kendoDropDownList({
                 dataTextField: "JOBLDR_NAME",
                 dataValueField: "JOBLDR_NUM",
                 dataSource: dataSource_joblist,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");

        //계급목록
        var leadershipList = $("#leadershipList").kendoDropDownList({
                 dataTextField: "JOBLDR_NAME",
                 dataValueField: "JOBLDR_NUM",
                 dataSource: dataSource_leadershiplist,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
        
        //검색버튼 클릭 시..
        $("#dataSearchBtn").click(function(){
        	grid.dataSource.read();
        });
        
        //직무별응답현황 그리드
        var grid = $("#grid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/cmpt_job_leadership_sco_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){ 
                        return { runNum: runList.value(), JOB_NUM: removeNullStr($("#carjobList").val()), LEADERSHIP_NUM: removeNullStr($("#leadershipList").val()) };
                    }        
                },
                schema: {
                    total: "totalItemCount",
                    data: "items",
                       model: {
                           fields: {
                        	   JOB_NM : { type : "string" }, 
                        	   LEADERSHIP_NM : { type : "string" }, 
                        	   CMPNAME : { type : "string" },
                        	   CMPGROUP_NM : { type: "string" } , 
                        	   SCORE : { type: "number" } 
                           }
                       }
                },
                pageSize: 30,
                serverPaging: false,
                serverFiltering: false,
                serverSorting: false
            },
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
            resizable: true,
            reorderable: true,
            pageable : {
                refresh : false,
                pageSizes : [10,20,30]
            },
            columns: [
            {
                field: "JOB_NM",
                title: "직무명",
                width:200,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "LEADERSHIP_NM",
                title: "계급명",
                width:200,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            }, 
            {
                field: "CMPNAME",
                title: "역량명",
                width: 200,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "CMPGROUP_NM",
                title: "역량군",
                width: 200,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "SCORE",
                title: "평점",
                width: 100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            }]
        }).data("kendoGrid");
        
        
    }
    
}]);


//엑셀다운로드
function excelDownload(button){
    if($("#runList").val()==null || $("#runList").val()==""){
       alert("진단을 선택해주세요.");
       return false;
   }
   button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/cmpt_job_leadership_sco_excel_list.do?runNum="+$("#runList").val()+"&JOB_NUM="+removeNullStr($("#carjobList").val())+"&LEADERSHIP_NUM="+removeNullStr($("#leadershipList").val());
}


</script>
    <style scoped>
    .demo-section {width:120px;}
    .demo-section2 {    width:250px;}
    </style>    
    
    </head>
<body>

    <div class="container">
        <div id="cont_body">
         <div class="content">
            <div class="top_cont">
                <h3 class="tit01">역량별직무/계급현황</h3>
                <div class="point">
                    ※ 역량별 직무와 계급들의 취득 점수를 열람할 수 있습니다.<br/>※ 상세 정보는 역량별점수 메뉴에서 볼 수 있습니다. <span><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/cmpt_user_sco_list_pg.do"> [바로가기]</a></span>
                </div>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>역량진단결과&nbsp; &#62;</span>
                    <span class="h">역량별직무/계급현황</span>
                </div><!--//location-->
            </div>
             <div class="sub_cont">
                
                <div class="result_info">
                    <ul>
                        <li class="fir">
                        <label for="p_year">진단선택  : </label>
                            <div class="demo-section k-header style01" id="p_year">
                                <select id="yyyy" style="width: 120px" accesskey="w"></select>
                            </div>
                             <style scoped>
                                .demo-section.style01 {width:120px;}
                                .k-input {padding-left:5px;}
                            </style>       
                        </li>  
                        <li>
                            <label for="p_name" class="blind" >진단명 : </label>
                            <div class="demo-section k-header style02" id="p_name">
                                <select id="runList"  style="width: 250px" accesskey="w"></select>
                            </div>
                             <style scoped>
                                .demo-section.style02 {width:250px;}
                                .k-input {padding-left:5px;}
                            </style>    
                        </li>
                    </ul>
                    
                </div><!--//result_info-->
                <div class="result_info mt15">
                    <ul>
                        <li>
                        <label for="p_select01">직무선택  : </label>
                            <div class="demo-section k-header style03" id="p_select01">
                                <select id="carjobList" style="width: 200px" accesskey="w"></select>
                            </div>
                             <style scoped>
                                .demo-section.style03 {width:200px;}
                                .k-input {padding-left:5px;}
                            </style>       
                        </li>  
                        <li>
                            <label for="p_select02" class="ml10">계급선택 : </label>
                            <div class="demo-section k-header style03" id="p_select02">
                                <select id="leadershipList"  style="width: 200px" accesskey="w"></select>
                            </div>
                             <style scoped>
                                .demo-section.style03 {width:200px;}
                                .k-input {padding-left:5px;}
                            </style>    
                        </li>
                        <li>
                            <button id="dataSearchBtn" class="k-button k-primary" style="margin-left:5px;">검색</button>
                        </li>
                    </ul>
                    <div class="btn">
                        <a class="k-button" onclick="excelDownload(this)" >엑셀 다운로드</a>
                    </div>
                </div>
                <div id="grid" class="mt15" style="height:550px;"></div>

             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div><!--//container-->
</body>
</html>