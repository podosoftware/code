<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}
%>

<html decorator="subpage">
<head>
	<title></title>
	<script type="text/javascript">
	var runListDataSource;
	var gridDataSource;
	var sClassNm;
	var kpiIndex = 0;
	var fileCount = 0;
	
    yepnope([{
        load: [ 
               'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
               'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
               '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
               '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
               '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
               '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
               '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
        ],
        complete: function() {
            kendo.culture("ko-KR");    
            
            var yearListDataSource = new kendo.data.DataSource({
                type: "json",
                    transport:{
                        read: { url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_tt_year_list.do?output=json", type:"POST" }
                    },
                    schema:{
                        data: "items",
                        model: {
                            fields: {
                                EVL_YYYY: { type: "string" },
                                TEXT: { type: "string" }
                            }
                        }
                    },
                    serverFiltering: false,
                    serverSorting: false
            });
            
            var runListDataSource = new kendo.data.DataSource({
                type: "json",
                    transport:{
                        read: { url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_tt_run_list.do?output=json", type:"POST" }
                    },
                    schema:{
                        data: "items",
                        model: {
                            fields: {
                            	EVL_YYYY: { type: "string" }, 
                            	TT_EVL_NO: { type: "number" },
                            	TT_EVL_NM: { type: "string" },
                            	EVL_TARG_CNT: { type: "string" },
                            	PUBL_YN: { type: "string" }
                            }
                        }
                    },
                    serverFiltering: false,
                    serverSorting: false
            });
            
	        //평가년도 콤보박스
	        $("#yyyy").kendoComboBox({
                dataTextField: "TEXT",
                dataValueField: "EVL_YYYY",
                dataSource: yearListDataSource,
                filter: "contains",
                suggest: true,
                width: 100,
                change: function() {
                	if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
	                	runListDataSource.filter({
	                        "field":"EVL_YYYY",
	                        "operator":"eq",
	                        "value":$("#yyyy").val()
	                    });
                	}else{
                		runListDataSource.filter({});
                	}
                	//$("#runList").data("kendoComboBox").select(0);
                	
                 }
            });
	        $("#yyyy").data("kendoComboBox").select(0);
	        
	        $("#runList").kendoComboBox({
                dataTextField: "TT_EVL_NM",
                dataValueField: "TT_EVL_NO",
                dataSource: runListDataSource,
                filter: "contains",
                suggest: true ,
                width: 250,
                change: function(dataItem){
                	if($("#runList").val()==""){
                		
                        $("#runGrid").data("kendoGrid").dataSource.data([]);
                        $("#grid").data("kendoGrid").dataSource.data([]);
                        
                        ttEvlInfoSet();
                        
                		alert("선택된 종합평가가 없습니다.");
                	}else{
                		$("#runGrid").data("kendoGrid").dataSource.read();
                		$("#grid").data("kendoGrid").dataSource.read();

                		ttEvlInfoSet();
                	}
                },
                dataBound:function(){
                	if(runListDataSource!=null && runListDataSource.data().length>0){
                		$("#runList").data("kendoComboBox").select(0);
                		
                		$("#runGrid").data("kendoGrid").dataSource.read();
                        $("#grid").data("kendoGrid").dataSource.read();
                	}
                	
                    ttEvlInfoSet();
                }
            });
	        
	        $("#runGrid").empty();
            $("#runGrid").kendoGrid({
                   dataSource: {
                       type: "json",
                       transport: {
                           read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_tt_run_set_info.do?output=json", type:"POST" },
                           parameterMap: function (options, operation){ 
                               return { TT_EVL_NO :  $("#runList option:selected").val() };
                           }
                       },
                       schema: {
                           data: "items",
                              model: {
                                  fields: {
                                      OTC1 : { type: "string" },
                                      OTC2 : { type: "string"},
                                      CMPT1 : { type: "string"},
                                      CMPT2 : { type: "string"}
                                  }
                              }
                       },
                       pageSize: 30,
                       serverPaging: false,
                       serverFiltering: false,
                       serverSorting: false
                   },
                   columns: [
                        {
                            field: "OTC1", 
                            title: "성과-1", 
                            filterable: false,
                            width:250,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center; height:18px;"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
                        },
                        {
                            field: "CMPT1", 
                            title: "역량-1", 
                            filterable: false,
                            width:250,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
                        },
                        {
                            field: "OTC2", 
                            title: "성과-2", 
                            filterable: false,
                            width:250,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
                        },
                        {
                            field: "CMPT2", 
                            title: "역량-2", 
                            filterable: false,
                            width:250,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
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
                    sortable: false,
                    pageable: false,
                    selectable: false,
                    scrollable: false,
                    height: 67
                });
            
	        //grid 세팅
	        $("#grid").empty();
	        $("#grid").kendoGrid({
	        	   dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_tt_run_result.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){ 
	                           return { TT_EVL_NO :  $("#runList option:selected").val() };
	                       }
	                   },
	                   schema: {
	                       total: "totalItemCount",
	                       data: "items",
	                          model: {
	                              fields: {
	                            	  DVS_NAME : { type: "string" },
	                                  NAME : { type: "string" },
	                                  EMPNO : { type: "string"},
	                                  TT_SCO : { type: "string" },
	                                  OTC1_SCO : { type: "string" },
	                                  OTC2_SCO : { type: "string"},
	                                  CMPT1_SCO : { type: "string"},
	                                  CMPT2_SCO : { type: "string"},
	                                  JOB_NM : { type: "string" },
	                                  LEADERSHIP_NM: { type: "string" }
	                              }
	                          }
	                   },
	                   pageSize: 30,
	                   serverPaging: false,
	                   serverFiltering: false,
	                   serverSorting: false
	               },
	               columns: [
	                    {
	                    	field:"DVS_NAME",
	                        title: "부서명",
	                        filterable: true,
                            width:200,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:left;"}
	                    },
	                    {
	                        field:"NAME",
	                        title: "이름",
	                        filterable: true,
	                        width:120,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:left"} 
	                    },
	                    {
	                        field: "EMPNO",
	                        title: "교직원번호",
                            filterable: true,
	                        width: 100,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:left"} 
	                    },
                        {
                            field: "JOB_NM",
                            title: "직무",
                            filterable: true,
                            width: 160,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:left"} 
                        },
	                    {
	                        field: "LEADERSHIP_NM", 
	                        title: "계층", 
                            filterable: true,
	                        width:160,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:left"}
	                    },
                        {
                            field: "TT_SCO", 
                            title: "종합평가",
                            filterable: false,
                            width:100,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
                        },
                        {
                            field: "OTC1_SCO", 
                            title: "성과-1<br>(가중치)", 
                            filterable: false,
                            width:120,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
                        },
                        {
                            field: "CMPT1_SCO", 
                            title: "역량-1<br>(가중치)", 
                            filterable: false,
                            width:120,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
                        },
                        {
                            field: "OTC2_SCO", 
                            title: "성과-2<br>(가중치)", 
                            filterable: false,
                            width:120,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
                        },
                        {
                            field: "CMPT2_SCO", 
                            title: "역량-2<br>(가중치)", 
                            filterable: false,
                            width:120,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
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
	                sortable: true,
	                pageable: { refresh:false, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
	                selectable: false,
	                height: 460
	            });
	        

        }
    }]);   
    
    
    //엑셀다운로드
    function excelDownLoad(){
    	if($("#runList").val()==null || $("#runList").val()==""){
    		alert("종합평가를 선택해주세요.");
    		return false;
    	}
    	frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_tt_run_result_excel.do?TT_EVL_NO="+$("#runList").val();
    	frm.submit();
    }
    
    //선택된 종합평가 정보 세팅
    function ttEvlInfoSet(){
    	$("#createtime").text("");
    	$("#evlTargCnt").text("");
    	
    	var runItem = $("#runList").data("kendoComboBox").dataItem();
    	
    	if(runItem!=null){
    		//var publ = runItem.PUBL_YN == "Y" ? " (공개)":" (비공개)";
            
            $("#createtime").text("평가 생성일 : "+runItem.CREATETIME);
            $("#evlTargCnt").text("평가 대상자 : "+runItem.EVL_TARG_CNT+"명");
    	}
    }
    
    </script>

</head>
<body >
<form name="frm" id="frm" method="post" >
    <input type="hidden" name="companyid" id="companyid" value=""/>
    <input type="hidden" name="TG_USERID" id="TG_USERID" />
    <input type="hidden" name="jkRnum" id="jkRnum" />
</form>

    <div id="content">
        <div class="cont_body">
            <div class="title">종합평가</div>
            <div class="table_tin" style="margin-top:10;">
                <ul>
                    <li style="width:100%">
                        <label for="yyyy" >평가년도</label> : 
                        <select id="yyyy" ></select>
                        <select id="runList" ></select>
                        <span id="createtime" style="padding-left:50px;"></span>
                        <span id="evlTargCnt" style="padding-left:50px;"></span>
                    </li>
                </ul>
            </div>
            <div class="px" style="margin-top:20;">※ 종합평가는 년도 기준으로 여러 번 있을 수 있으며, 종합평가 생성은 시스템 운영자가 할 수 있습니다.</div>
                
	        <div class="table_zone" style="margin-top:0;">
	            <div style="width:100%; text-align:right">
                    <a class="k-button"  href="javascript:excelDownLoad()" >엑셀 다운로드</a>
                </div>
	            <div id="runGrid" style="top:5px;"></div>
                <div class="table_list" >
	                <div id="grid" style="top:10px;"></div>
	            </div>
	        </div>
	    </div>
    </div>

</body>
</html>