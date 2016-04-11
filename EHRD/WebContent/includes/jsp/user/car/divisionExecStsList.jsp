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
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/get_division_exec_sts_list.do?output=json", type:"POST" },
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
                        	   DVS_FULLNAME : { type : "string" }, 
                        	   MANAGER_NAME : { type : "string" },
                        	   TCNT_NUMB : { type: "number" } , 
                        	   YCNT_NUMB : { type: "number" } , 
                        	   NCNT_NUMB : { type: "number" } , 
                        	   YRATE_NUMB : { type: "number" } 
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
                width:120,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            }, 
            {
                field: "DVS_FULLNAME",
                title: "전체부서명",
                width:180,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:left"}
            }, 
            {
                field: "MANAGER_NAME",
                title: "부서장",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            }, 
            {
                field: "TCNT_NUMB",
                title: "총인원",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            }, 
            {
                field: "YCNT_NUMB",
                title: "완료인원",
                width: 100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "NCNT_NUMB",
                title: "미완료인원",
                width: 100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            },
            {
                field: "YRATE_NUMB",
                title: "완료율(%)",
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
   button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/division_exec_sts_excel_list.do?runNum="+$("#runList").val()+"&RUN_NAME="+ $("#runList").data("kendoDropDownList").text();
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
                <h3 class="tit01">소속별응답현황</h3>
                <div class="point">
                    ※ 소속별 진단대상자수, 응답자, 미응답자 및 응답률을 볼 수 있습니다.<br/>※ 상세 정보는 진단실시현황 메뉴에서 볼 수 있습니다. <span><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/assm_exct_sts_pg.do"> [바로가기]</a></span>
                </div>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>역량진단결과&nbsp; &#62;</span>
                    <span class="h">소속별응답현황</span>
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