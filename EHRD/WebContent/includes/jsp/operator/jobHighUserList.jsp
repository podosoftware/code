<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%

kr.podosoft.ws.service.kpi.action.ajax.KPIMgmtAction action = (kr.podosoft.ws.service.kpi.action.ajax.KPIMgmtAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
//List yearList = (List)action.getItems();
%>
<html decorator="operatorSubpage">
<head>
	<title></title>
	<script type="text/javascript">
	//var runListDataSource;
	var yearListDataSource;
	var sClassNm;
	var kpiIndex = 0;
	var fileCount = 0;
	
    yepnope([{
        load: [ 
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
                'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
               '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
               '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
               '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js',     
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
              '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js' 
        ],
        complete: function() {
            kendo.culture("ko-KR");     
            
            /* 브라우저 height 에 따라 resize() 스타일 적용..  START !!! */
            $(window).bind('resize', function () { 
            	var winHeight;
                if (window.innerHeight) {
                    winHeight =window.innerHeight;
                }else{
                    if(document.documentElement.clientHeight){
                        winHeight = document.documentElement.clientHeight;
                    }else{
                        winHeight = 400;
                        alert("현재 브라우저는 resize를 제공하지 않습니다.");
                    }
                }

            	var gridElement = $("#grid");
            	gridOtherHeight = $("#grid").offset().top + $("#footer").outerHeight() + 30; //
            	gridElement.height(winHeight - gridOtherHeight);
            	
                dataArea = gridElement.find(".k-grid-content"),
                gridHeight = gridElement.innerHeight(),
                otherElements = gridElement.children().not(".k-grid-content"),
                otherElementsHeight = 0;
                otherElements.each(function(){
                    otherElementsHeight += $(this).outerHeight();
                });
                dataArea.height(gridHeight - otherElementsHeight);

            });
            /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
            
            var date = new Date(); 
            var year = date.getFullYear(); 
            
            var yearlist= [];
            
            for(var i=2014; i<year+2; i++){
                yearlist.push({ text: i+"년", value: i});
            }
            
	        //평가년도 콤보박스
	        $("#year").kendoComboBox({
                dataTextField: "text",
                dataValueField: "value",
                dataSource: yearlist,
                filter: "contains",
                suggest: true,
                width: 100,
                change: function() {
                	if($("#year").val()!=null && $("#year").val()!=""){
                		$("#grid").data("kendoGrid").dataSource.read();
                		filterData( $(':radio[id="typeCd"]:checked').val() );
                	}else{

                	}
                	//$("#runList").data("kendoComboBox").select(0);
                	
                 },
                 dataBound:function(){
                     $("#year").data("kendoComboBox").value(year);
                	 if($("#grid").data("kendoGrid")){
                		 $("#grid").data("kendoGrid").dataSource.read();
                         filterData( $(':radio[id="typeCd"]:checked').val() ); 
                	 }
                	 
                 }
            });
	        
	        
	        // 직무선택 박스
            $("#dtl-job").kendoComboBox({
                dataTextField: "LABEL", dataValueField:"DATA",
                dataSource: {
                    type: "json",
                    transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/get-user-job-list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){    
                        return {  JOBLDRFLAG : "J" };   
                        }
                    },
                    schema: {
                        total: "totalItemCount",
                        data: "items",
                        model: { id:"DATA", fields:{ LABEL:{ type:"string" }, DATA:{ type:"number" } } }
                    }
                },
                placeholder : "" ,
                filter: "contains",
                change: function(dataItem){
                    if($("#dtl-job").val()==""){
                        
                    }else{
                        $("#grid").data("kendoGrid").dataSource.read();
                        filterData( $(':radio[id="typeCd"]:checked').val() );
                    }
                },
                dataBound:function(){
                	$("#dtl-job").data("kendoComboBox").select(0);
                	if($("#grid").data("kendoGrid")){
                		$("#grid").data("kendoGrid").dataSource.read();
                        filterData( $(':radio[id="typeCd"]:checked').val() );
                	}
                    
                }
            });
	     
	        //grid 세팅
	        $("#grid").empty();
	        $("#grid").kendoGrid({
	        	   dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/job_high_user_result.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){ 
	                           return {YYYY: $("#year").val(),  JOB_NUM :  $("#dtl-job").val() };
	                       }
	                   },
	                   schema: {
	                       total: "totalItemCount",
	                       data: "items",
	                          model: {
	                              fields: {
	                            	  RNUM : {type:"number"},
	                            	  DVS_NAME : { type: "string" },
	                                  NAME : { type: "string" },
	                                  EMPNO : { type: "string"},
	                                  JOB: {type:"int"},
	                                  JOBLDR_NAME : { type: "string" },
	                                  KPI_SCORE: { type: "number" }
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
                             field: "RNUM",
                             title: "번호",
                             filterable: false,
                             width: 100,
                             headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                             attributes:{"class":"table-cell", style:"text-align:left"} 
                         },
	                    {
	                    	field:"DVS_NAME",
	                        title: "부서",
	                        filterable: true,
                            width:200,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:left;"}
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
	                        field:"NAME",
	                        title: "성명",
	                        filterable: true,
	                        width:120,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:left"} 
	                    },
                        {
                            field: "JOBLDR_NAME",
                            title: "현직무",
                            filterable: true,
                            width: 160,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:left"} 
                        },
	                    {
	                        field: "KPI_SCORE", 
	                        title: "점수", 
                            filterable: true,
	                        width:160,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
	                    },
                        {
                            field: "", 
                            title: "신뢰도",
                            filterable: false,
                            width:100,
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
	                selectable: false
	            });
	            
	        
	        //브라우저 resize 이벤트 dispatch..
            $(window).resize();
        }
    }]);   
    
    
    //엑셀다운로드
    function excelDownLoad(){
    	var yy = $("#year").data("kendoComboBox");
        if(yy.value()==""){
        	alert("평가년도를 선택해주세요.");
        	return;
        }
    	var job = $("#dtl-job").data("kendoComboBox");
        if(job.value()==""){
        	alert("직무를 선택해주세요.");
        	return;
        }
        frm.JOB_NUM.value = job.value();
        frm.JOB_NAME.value = job.text();
        frm.yyyy.value = yy.value();
    	frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/job_high_user_result_excel.do";
    	frm.submit();
    }
    

    //회사지표 or 개인입력지표 필터링
    function filterData(cd){
    	var no = $("#dtl-job").val();
         var grid = $("#grid").data('kendoGrid');
         
         if(cd == 1){
        	 grid.dataSource.filter({
                 "field":"JOB",
                 "operator":"neq",
                 "value": Number(no)
             });
         }else{
        	 grid.dataSource.filter({
                 "field":"JOB",
                 "operator":"eq",
                 "value": Number(no)
             });
         }
         
         
     }
    </script>

</head>
<body >
<form name="frm" id="frm" method="post" >
    <input type="hidden" name="companyid" id="companyid" value="<%=action.getUser().getCompanyId()%>"/>
    <input type="hidden" name="JOB_NAME" id="JOB_NAME" />
    <input type="hidden" name="JOB_NUM" id="JOB_NUM" />
    <input type="hidden" name="yyyy" id="yyyy" />
</form>

    <div id="content">
        <div class="cont_body">
            <div class="title mt30">직무별 고성과자</div>
            <div class="table_tin01">
                <div class="px">※  직무별 고성과자는 선택한 직무에 높은 성과를 가진 직원순으로 보여줍니다.</div>
                <ul>
                    <li >
                        <label for="year" >평가년도</label>
                        <select id="year" style="width:100px;"></select>
<!--                         <select id="runList" style="width:350px;"></select> -->
                        
                    </li>
                    <li class="line">
                        <label for="year" >직무선택</label>
                        <select id="dtl-job" style="width:350px;"></select>
                    </li>
                </ul>
            </div>
            
	        <div class="table_zone" >
	            <div style="width:100%; text-align:right">
	                   <div style="float:left; margin-left: 15px; margin-top: 10px; ">
	                        선택직무와 현직무 <input type="radio" value="1" id="typeCd" name="typeCd" checked onclick="filterData(1);"> 같지않음 <input type="radio" value="2" id="typeCd" name="typeCd" style="margin-left:15px;" onclick="filterData(2);"> 같음
	                    </div>
                    <a class="k-button"  href="javascript:excelDownLoad()" >엑셀 다운로드</a>
                </div>
	            <div class="table_list">
	                <div id="grid" ></div>
	            </div>
	        </div>
	    </div>
    </div>

</body>
</html>