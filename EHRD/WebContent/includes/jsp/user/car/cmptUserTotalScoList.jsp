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

                //console.log('==========================='+yyyy.value());
                //console.log(dataSource_runlist.view().length+'===========================');
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
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/cmpt_user_total_sco_list.do?output=json", type:"POST" },
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
                           fields: {
                        	   DVS_NAME : { type : "string" },
                        	   NAME : { type : "string" },
                        	   EMPNO : { type: "string" } , 
                        	   GRADE_NM : { type: "string" } , 
                        	   JOB_NAME : { type: "string" } , 
                        	   LEADERSHIP_NAME : { type: "string" } , 
                        	   EVL_TOTAL_SCORE_NUMB : { type: "number" } 
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
                pageSizes : [10,20,30]
            },
            columns: [
            {
                field: "DVS_NAME",
                title: "부서",
                width:180,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            }, 
            {
                field: "NAME",
                title: "성명",
                width:150,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center; text-decoration: underline;"},
                template:function(data){
                	if(data.EVL_TOTAL_SCORE!=null && data.EVL_TOTAL_SCORE!=""){
                		return "<a href=\"javascript:void(0);\" onclick=\"javascript: fn_diagnoAnaly("+data.RUN_NUM+", "+data.USERID+", "+data.JOB+", "+data.LEADERSHIP+");\" >"+data.NAME+"</a>";
                	}else{
                		return "<a href=\"javascript:void(0);\" onclick=\"javascript: alert('진단결과가 존재하지 않습니다.'); \" >"+data.NAME+"</a>";
                	}
                	
                }
            }, 
            {
                field: "EMPNO",
                title: "교직원번호",
                width: 100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "GRADE_NM",
                title: "직급",
                width: 120,
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
                field: "LEADERSHIP_NAME",
                title: "계급",
                width: 120,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "EVL_TOTAL_SCORE_NUMB",
                title: "전체평점",
                width: 80,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            }]
        }).data("kendoGrid");
        
        
    }
    
}]);

//사용자별 역량진단 분석화면 이동
function fn_diagnoAnaly(runNum, useridExed, job, leadership) {
    $("#RUN_NUM").val(runNum);
    $("#TG_USERID").val(useridExed);
    $("#JOB").val(job);
    $("#LEADERSHIP").val(leadership);
    
    document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/car_analysis_cmpt.do"
    document.frm.submit();
}

//엑셀다운로드
function excelDownload(button){
    if($("#runList").val()==null || $("#runList").val()==""){
       alert("진단을 선택해주세요.");
       return false;
   }
   button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/cmpt_user_total_sco_excel_list.do?runNum="+$("#runList").val();
}


</script>
    <style scoped>
    .demo-section {width:120px;}
    .demo-section2 {    width:250px;}
    </style>    
    
    </head>
<body>
    <form id="frm" name="frm"  method="post" >
        <input type="hidden" name="RUN_NUM" id="RUN_NUM" />
        <input type="hidden" name="TG_USERID" id="TG_USERID" />
        <input type="hidden" name="JOB" id="JOB" />
        <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" />
    </form>
    
    <div class="container">
        <div id="cont_body">
         <div class="content">
            <div class="top_cont">
                <h3 class="tit01">종합진단결과</h3>
                <div class="point">
                    ※ 피진단자들의 진단 결과를 열람할 수 있습니다. <br/>※ 진단자 성명을 클릭 시 세부 진단 결과를 열람할 수 있습니다.
                </div>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>역량진단결과&nbsp; &#62;</span>
                    <span class="h">종합진단결과</span>
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
                    <div class="btn">
                        <a class="k-button"  onclick="excelDownload(this)" >엑셀 다운로드</a>
                    </div>
                </div><!--//result_info-->
                <div id="grid" class="mt15" style="height:550px;"></div>

             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div><!--//container-->
</body>
</html>