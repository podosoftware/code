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
	<title>종합평가</title>
	<script type="text/javascript">
	var runListDataSource;
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
            
            yearListDataSource = new kendo.data.DataSource({
                type: "json",
                    transport:{
                        read: { url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/tt_year_list.do?output=json", type:"POST" }
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
            
            runListDataSource = new kendo.data.DataSource({
                type: "json",
                    transport:{
                        read: { url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/tt_run_list.do?output=json", type:"POST" }
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
                    ttEvlInfoSet();
                }
            });
	        
	        //화면 로딩후 평가목록 패치시 실행..
	        /*runListDataSource.fetch(function(){
	        	if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
		        	runListDataSource.filter({
	                    "field":"EVL_YYYY",
	                    "operator":"eq",
	                    "value":$("#yyyy").val()
	                });
		        	if(runListDataSource.data().length>0){
		        		$("#runList").data("kendoComboBox").select(0);
	                    
		        	}
		        	
		        }
            });*/
	        
	        $("#runGrid").empty();
            $("#runGrid").kendoGrid({
                   dataSource: {
                       type: "json",
                       transport: {
                           read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/tt_run_set_info.do?output=json", type:"POST" },
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
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/tt_run_result.do?output=json", type:"POST" },
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
	                selectable: false
	            });
	            
	        //검색버튼 클릭
	        $("#searchBtn").click(function(){
	        	getGridDataSource();
	        });
	        
	        //종합평가공개 버튼 클릭 시
	        $("#publBtn").click(function(){
	        	if($("#runList").val()==null || $("#runList").val()==""){
	                alert("종합평가를 선택해주세요.");
	                return false;
	            }
	        	
	        	var runItem = $("#runList").data("kendoComboBox").dataItem();
	        	if(runItem.PUBL_YN=="Y"){
	        		alert("이미 공개된 평가 입니다.");
                    return false;
	        	}
	        	
	        	if(confirm(runItem.TT_EVL_NM+"의 결과를 공개 하시겠습니까?\n확인 클릭 시 부서장님들에게 종합결과가 공개됩니다.")){
	                $.ajax({
	                    type : 'POST',
	                    url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/tt_evl_public.do?output=json",
	                    data : { TT_EVL_NO : $("#runList").val() },
	                    complete : function( response ){
	                        var obj  = eval("(" + response.responseText + ")");
	                        if(obj.saveCount != 0){
	                            //$('#grid').data("kendoGrid").dataSource.read();
	                            runListDataSource.read();
	                            
	                        	alert("종합평가가 공개되었습니다.");
	                        	
	                        	
	                        }else{
	                            alert("실패 하였습니다.");
	                        } 
	                    },
	                    error: function( xhr, ajaxOptions, thrownError){         
	                    	alert('xrs.status = ' + xhr.status + '\n' + 
	                                'thrown error = ' + thrownError + '\n' +
	                                'xhr.statusText = '  + xhr.statusText + '\n세션이 종료되었습니다.' );
	                    	sessionout();
	                    },
	                    dataType : "json"
	                });
	            }
	        });
	        
	        //종합평가생성 버튼 클릭 시
            $("#newBtn").click(function(){
            	
            	if( !$("#ttMgmt-window").data("kendoWindow") ){
            		var winElement = $("#ttMgmt-window").kendoWindow({
                        width:"1000px",
                        minHeight:"600px",
                        resizable : true,
                        title : "종합평가생성",
                        modal: true,
                        visible: false
                    });
                    
                    var options = [];
                    var date = new Date(); 
                    var year = date.getFullYear(); 
                    for(var i=year; i>=year-5; i--){
                    	options.push({"YYYY":i, "TEXT":i+"년"});
                    }
                    $("#evlyyyy").kendoComboBox({
                        dataTextField: "TEXT",
                        dataValueField: "YYYY",
                        dataSource: options,
                        filter: "contains",
                        suggest: true,
                        width: 100,
                        change: function() {
                        	var weiGrid = $("#weiMgmtGrid").data("kendoGrid");
                            if($("#evlyyyy").val()!=null && $("#evlyyyy").val()!=""){
                            	weiGrid.dataSource.read();
                            }else{
                            	weiGrid.dataSource.data([]);
                            }
                         }
                    });
                    
                    //가중치
                    $("#weiMgmtGrid").empty();
                    $("#weiMgmtGrid").kendoGrid({
                        dataSource: {
                            type: "json",
                            transport: {
                                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/tt_year_run_list.do?output=json", type:"POST" },
                                parameterMap: function (options, operation){
                                     return { YYYY : $("#evlyyyy").val() };
                                }
                            },
                            schema: {
                                 data: "items",
                                 model: {
                                     fields: {
                                            RUN_NUM : { type: "number" },
                                            RUN_NAME: { type:"string", editable:false},
                                            EVL_TYPE_NM : { type: "string", editable:false },
                                            RNUM: { type: "number", editable:false}, 
                                            WEI_APL_TARG: {  defaultValue: { WEI_APL_TARG: "", WEI_APL_TARG_NM: ""}  },
                                            WEI_APL_TARG_NM: {type:"string"},
                                            WEI: { type: "number"}
                                        }
                                 }
                            },
                            serverPaging: false, serverFiltering: false, serverSorting: false
                        },
                        columns: [
                            { field:"RNUM", title: "번호", width:100, 
                                filterable: false,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"} 
                            },
                            { field:"EVL_TYPE_NM", title: "평가구분", width:100, 
                                filterable: false,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"} 
                            },
                            { field:"RUN_NAME", title: "평가명", width:400, 
                                filterable: false,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:left"} 
                            },
                            { field:"WEI_APL_TARG", title: "가중치적용대상", width:150, 
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"} ,
                                editor: weiAplTargEditor,
                                template: "#=WEI_APL_TARG.WEI_APL_TARG_NM#"
                                //template:"<select data-bind='value:WEI_APL_TARG' data-role='combobox' ></select>"
                                //template:function(dataItem){
                                //	return "<select class='k-widget k-combobox k-header'><option value=''>선택</option><option value='1'>성과-1</option><option value='2'>성과-2</option><option value='3'>역량-1</option><option value='4'>역량-2</option></select>";
                                //}
                            },
                            { field:"WEI", title: "가중치", width:150, 
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"}// ,
                                //template: "<input data-bind='value: WEI' data-role='numerictextbox'>"
                            }
                        ],
                        dataBound: function() {
                            var rows = this.tbody.children();
                            var dataItems = this.dataSource.view();
                            for (var i = 0; i < dataItems.length; i++)  {
                              kendo.bind(rows[i], dataItems[i]);
                            }
                        },
                        filterable: false,
                        editable:true,
                        sortable: false, pageable: false, height: 190
                    });
                    
                    
                    //대상자 목록
                    $("#ttMgmtGrid").empty();
                    $("#ttMgmtGrid").kendoGrid({
                        dataSource: {
                            type: "json",
                            transport: {
                                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/tt_user_list.do?output=json", type:"POST" },
                                parameterMap: function (options, operation){
                                     return { };
                                }
                            },
                            schema: {
                            	 total:"totalItemCount",
                                 data: "items",
                                 model: {
                                     fields: {
                                            USERID : { type: "number", editable:false },
                                            DVS_NAME: { type:"string", editable:false},
                                            NAME : { type: "string", editable:false },
                                            EMPNO: { type: "string", editable:false },
                                            JOB_NM: { type: "string", editable:false },
                                            LEADERSHIP_NM: { type: "string", editable:false },
                                            OTC1: { type: "number" }, 
                                            OTC2: { type: "number" },
                                            CMPT1:{ type: "number" },
                                            CMPT2: {type: "number" }
                                        }
                                 }
                            },
                            pageSize: 30,
                            serverPaging: false, serverFiltering: false, serverSorting: false
                        },
                        columns: [
                            { field:"DVS_NAME", title: "부서명", width:140, 
                                filterable: false,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:left"} 
                            },
                            { field:"NAME", title: "이름", width:80, 
                                filterable: false,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"} 
                            },
                            { field:"EMPNO", title: "교직원번호", width:80, 
                                filterable: false,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:left"} 
                            },
                            { field:"JOB_NM", title: "직무", width:120, 
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:left"} 
                            },
                            { field:"LEADERSHIP_NM", title: "계층", width:120, 
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:left"} 
                            },
                            {
                                field: "OTC1", 
                                title: "성과-1", 
                                filterable: false,
                                width:80,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"}//,
                                //template: "<input data-bind='value: OTC1' data-role='numerictextbox'>"
                            },
                            {
                                field: "CMPT1", 
                                title: "역량-1", 
                                filterable: false,
                                width:80,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"}//,
                                //template: "<input data-bind='value: CMPT1' data-role='numerictextbox'>"
                            },
                            {
                                field: "OTC2", 
                                title: "성과-2", 
                                filterable: false,
                                width:80,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"}//,
                                //template: "<input data-bind='value: OTC2' data-role='numerictextbox'>"
                            },
                            {
                                field: "CMPT2", 
                                title: "역량-2", 
                                filterable: false,
                                width:80,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"}//,
                                //template: "<input data-bind='value: CMPT2' data-role='numerictextbox'>"
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
                        dataBound: function() {
                            var rows = this.tbody.children();
                            var dataItems = this.dataSource.view();
                            for (var i = 0; i < dataItems.length; i++)  {
                              kendo.bind(rows[i], dataItems[i]);
                            }
                        },
                        sortable: true,
                        pageable: { refresh:false, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
                        selectable: false, 
                        editable:true,
                        height: 270
                    });
                    
                    //적용버튼 클릭 시, 가중치가 대상 직원에게 일괄 적용됨.
                    $("#applyBtn").click(function(){
                    	//가중치그리드
                    	var weiGrid = $("#weiMgmtGrid").data("kendoGrid").dataSource.data();
                    	if(weiGrid.length==0){
                    		alert("적용할 평가목록이 존재하지 않습니다.");
                    		return false;
                    	}
                    	var isChk = false;
                    	var otc1 = null;
                    	var otc2 = null;
                    	var cmpt1 = null;
                    	var cmpt2 = null;
                    	var ocnt1 = 0;
                    	var ocnt2 = 0;
                    	var ccnt1 = 0;
                    	var ccnt2 = 0;
                    	for(var i=0; i<weiGrid.length; i++){
                    		if(weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="1" || weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="2" || weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="3" || weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="4"){
                    			isChk = true;
                    			if(weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="1"){
                    				if(weiGrid[i].WEI!=null){
                    					otc1 = weiGrid[i].WEI;
                    				}
                    				ocnt1 = ocnt1+1;
                    			}
                    			if(weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="2"){
                                    if(weiGrid[i].WEI!=null){
                                    	otc2 = weiGrid[i].WEI;
                                    }
                                    ocnt2 = ocnt2+1;
                                }
                    			if(weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="3"){
                                    if(weiGrid[i].WEI!=null){
                                    	cmpt1 = weiGrid[i].WEI;
                                    }
                                    ccnt1 = ccnt1+1;
                                }
                    			if(weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="4"){
                                    if(weiGrid[i].WEI!=null){
                                    	cmpt2 = weiGrid[i].WEI;
                                    }
                                    ccnt2 = ccnt2+1;
                                }
                    		}
                    	}
                    	if(isChk){
                    		if(ocnt1>1){
                    			alert("성과-1이 중복선택되었습니다.");
                    			return false;
                    		}
                            if(ocnt2>1){
                                alert("성과-2가 중복선택되었습니다.");
                                return false;
                            }
                            if(ccnt1>1){
                                alert("역량-1이 중복선택되었습니다.");
                                return false;
                            }
                            if(ccnt2>1){
                                alert("역량-2가 중복선택되었습니다.");
                                return false;
                            }
                    		var weiSum = otc1+otc2+cmpt1+cmpt2;
                    		if(weiSum != 100){
                    			alert("가중치의 합이 100(현재 "+weiSum+")이어야 합니다.");
                    			return false;
                    		}
                    		//필터된 데이터만 가중치 값 적용..
                    		var userGrid = $("#ttMgmtGrid").data("kendoGrid").dataSource;
                    		var filters = userGrid.filter();
                    		var allData = userGrid.data();
                    		var query = new kendo.data.Query(allData);
                    		var data = query.filter(filters).data;
                    		
                            for(var j=0; j<data.length; j++){
                            	data[j].OTC1 = otc1;
                            	data[j].OTC2 = otc2;
                                data[j].CMPT1 = cmpt1;
                                data[j].CMPT2 = cmpt2;
                            }
                            $("#ttMgmtGrid").data("kendoGrid").refresh();
                    	}else{
                    		alert("평가목록 중 가중치적용대상이 선택된 평가가 없습니다.");
                    	}
                    });
                
                    //저장 버튼 클릭
                    $("#saveBtn").click( function (){
                    	if($("#evlyyyy").val()==""){
                    		alert("평가년도를 선택해주세요.");
                    		return false;
                    	}
                    	if($("#ttEvlNm").val()==""){
                            alert("종합평가명 입력해주세요.");
                            return false;
                        }
                    	
                    	//평가별가중치 체크
                    	var weiGrid = $("#weiMgmtGrid").data("kendoGrid").dataSource.data();
                        if(weiGrid.length==0){
                            alert("가중치적용대상 평가목록이 존재하지 않습니다.");
                            return false;
                        }
                        var isChk = false;
                        var otc1 = null;
                        var otc2 = null;
                        var cmpt1 = null;
                        var cmpt2 = null;
                        for(var i=0; i<weiGrid.length; i++){
                            if(weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="1" || weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="2" || weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="3" || weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="4"){
                                isChk = true;
                                if(weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="1"){
                                    if(weiGrid[i].WEI!=null){
                                        otc1 = weiGrid[i].WEI;
                                    }
                                }
                                if(weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="2"){
                                    if(weiGrid[i].WEI!=null){
                                        otc2 = weiGrid[i].WEI;
                                    }
                                }
                                if(weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="3"){
                                    if(weiGrid[i].WEI!=null){
                                        cmpt1 = weiGrid[i].WEI;
                                    }
                                }
                                if(weiGrid[i].WEI_APL_TARG.WEI_APL_TARG=="4"){
                                    if(weiGrid[i].WEI!=null){
                                        cmpt2 = weiGrid[i].WEI;
                                    }
                                }
                            }
                        }
                        if(isChk){
                            var weiSum = otc1+otc2+cmpt1+cmpt2;
                            if(weiSum != 100){
                                alert("평가별 가중치의 합이 100(현재 "+weiSum+")이어야 합니다.");
                                return false;
                            }
                        }else{
                            alert("평가목록 중 가중치적용대상이 선택된 평가가 없습니다.");
                            return false;
                        }
                    	
                        //지표설정 체크
                        var userGrid = $('#ttMgmtGrid').data('kendoGrid').dataSource.data();
                        var u_otc1 = null;
                        var u_otc2 = null;
                        var u_cmpt1 = null;
                        var u_cmpt2 = null;
                        var u_sum = null;
                        var u_msg = "";
                        var u_cnt = 0;
                        for(var i=0; i<userGrid.length; i++){
                        	u_otc1 = userGrid[i].OTC1;
                        	u_otc2 = userGrid[i].OTC2;
                        	u_cmpt1 = userGrid[i].CMPT1;
                        	u_cmpt2 = userGrid[i].CMPT2;
                        	
                        	u_sum = u_otc1 + u_otc2 + u_cmpt1 + u_cmpt2;
                        	
                            if(u_sum!=100){
                            	if(u_cnt<=5){
                            		if(u_cnt==0){
                                        u_msg = userGrid[i].NAME;
                                    }else{
                                        u_msg = u_msg + ", " + userGrid[i].NAME;
                                    }
                            	}	
                            	
                                u_cnt++;
                            }
                        }
                        if(u_cnt>0){
                        	u_msg = u_msg + " 님 등을 포함한 "+u_cnt+"명의 가중치 합이 100으로 설정되어야 합니다.";
                        	alert(u_msg);
                        	return false;
                        }
                        
                        var isConfirm = confirm("종합평가를 생성하시겠습니까?");
                        if(isConfirm){
                        	//로딩바 생성...
                        	winElement.append(loadingElement());


                            var params = {
                                    TLIST :  $('#ttMgmtGrid').data('kendoGrid').dataSource.data(),
                                    WLIST :  $('#weiMgmtGrid').data('kendoGrid').dataSource.data()
                            };
                            
                            $.ajax({
                               type : 'POST',
                               url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/save_tt_evl.do?output=json",
                               data : { item: kendo.stringify( params ), EVLYYYY : $("#evlyyyy").val(), TT_EVL_NM : $("#ttEvlNm").val() },
                               complete : function( response ){
                            	   //로딩바 제거..
                            	   winElement.find(".k-loading-mask").remove();
                            	   
                                   var obj  = eval("(" + response.responseText + ")");
                                   if(obj.saveCount != 0){
                                       //종합평가목록 재검색..
                                       yearListDataSource.read();
                                	   runListDataSource.read();
                                	   
                                       alert("생성되었습니다.");
                                       $("#ttMgmt-window").data("kendoWindow").close();
                                       
                                   }else{
                                       alert("저장에 실패 하였습니다.");
                                   }                           
                               },
                               error: function( xhr, ajaxOptions, thrownError){
                            	    //로딩바 제거..
                                   winElement.find(".k-loading-mask").remove();
                                   alert('xrs.status = ' + xhr.status + '\n' + 
                                           'thrown error = ' + thrownError + '\n' +
                                           'xhr.statusText = '  + xhr.statusText + '\n세션이 종료되었습니다.' );
                               	sessionout();
                                   
                               },
                               dataType : "json"
                           });     
                       }
                    });
                    
                    //취소버튼 클릭
                    $("#cancel-btn").click(  function() {
                        $("#ttMgmt-window").data("kendoWindow").close();
                    });
                    
                    
                }else{
                	$("#evlyyyy").data("kendoComboBox").value(null);
                	$("#ttEvlNm").val("");
                	$('#weiMgmtGrid').data('kendoGrid').dataSource.read();
                    $('#ttMgmtGrid').data('kendoGrid').dataSource.read();
                }


                $("#ttMgmt-window").data("kendoWindow").center();
                $("#ttMgmt-window").data("kendoWindow").open();
                
                
            });

            //종합평가삭제 버튼 클릭 시
            $("#delBtn").click(function(){
            	
                if($("#runList").val()==null || $("#runList").val()==""){
                    alert("종합평가를 선택해주세요.");
                    return false;
                }
                
                var runItem = $("#runList").data("kendoComboBox").dataItem();
                
                if(confirm(runItem.TT_EVL_NM+"의 결과를 삭제 하시겠습니까?\n삭제 시 결과데이터는 복구되지 않습니다.")){
                    $.ajax({
                        type : 'POST',
                        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/del_tt_evl.do?output=json",
                        data : { TT_EVL_NO : $("#runList").val() },
                        complete : function( response ){
                            var obj  = eval("(" + response.responseText + ")");
                            if(obj.saveCount != 0){
                                //콤보박스 그리드 내용 refresh...
                                yearListDataSource.read();
                                runListDataSource.read();
                                
                                $("#runGrid").data("kendoGrid").dataSource.data([]);
                                $("#grid").data("kendoGrid").dataSource.data([]);
                                
                                //$("#runList").data("kendoComboBox").select(null);
                                $("#yyyy").data("kendoComboBox").value(null);
                                $("#runList").data("kendoComboBox").value(null);
                                
                                alert("삭제되었습니다.");
                            }else{
                                alert("실패 하였습니다.");
                            } 
                        },
                        error: function( xhr, ajaxOptions, thrownError){     
                        	alert('xrs.status = ' + xhr.status + '\n' + 
                                    'thrown error = ' + thrownError + '\n' +
                                    'xhr.statusText = '  + xhr.statusText + '\n세션이 종료되었습니다.' );
                        	sessionout();
                        },
                        dataType : "json"
                    });
                }
            });
            
	        //브라우저 resize 이벤트 dispatch..
            $(window).resize();
        }
    }]);   
    
    //가중치적용대상 콤보박스 editor
    function weiAplTargEditor(container, options) {
    	var ds = null;
        if(options.model.EVL_TYPE_NM=="역량"){
            ds = [{WEI_APL_TARG_NM:"역량-1",WEI_APL_TARG:"3"},
                  {WEI_APL_TARG_NM:"역량-2",WEI_APL_TARG:"4"}];
        }else if(options.model.EVL_TYPE_NM=="성과"){
            ds = [{WEI_APL_TARG_NM:"성과-1",WEI_APL_TARG:"1"},
                  {WEI_APL_TARG_NM:"성과-2",WEI_APL_TARG:"2"}];
        }else{
        	alert("평가구분이 \"역량\" 또는 \"성과\"로 설정 되어있지 않습니다.");
        }
    	$('<input data-text-field="WEI_APL_TARG_NM" data-value-field="WEI_APL_TARG" data-bind="value:' + options.field + '"/>')
            .appendTo(container)
            .kendoComboBox({
                autoBind: false,
                dataSource: ds,
                placeholder: "선택"
            });
    }
    
    //엑셀다운로드
    function excelDownLoad(){
    	if($("#runList").val()==null || $("#runList").val()==""){
    		alert("종합평가를 선택해주세요.");
    		return false;
    	}
    	frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/tt_run_result_excel.do?TT_EVL_NO="+$("#runList").val();
    	frm.submit();
    }
    
    //선택된 종합평가 정보 세팅
    function ttEvlInfoSet(){
    	$("#createtime").text("");
    	$("#evlTargCnt").text("");
    	
    	var runItem = $("#runList").data("kendoComboBox").dataItem();
    	
    	if(runItem!=null){
    		var publ = runItem.PUBL_YN == "Y" ? " (공개)":" (비공개)";
            
            $("#createtime").text("평가 생성일 : "+runItem.CREATETIME);
            $("#evlTargCnt").text("평가 대상자 : "+runItem.EVL_TARG_CNT+"명"+ publ);
    	}
    }
    
    //로딩바 ... 평가 생성하는데 직원이 많을경우 시간이 오래 소요됨.. 
    function loadingElement() {
        return $("<div class='k-loading-mask'><span class='k-loading-text'>Loading...</span><div class='k-loading-image'/><div class='k-loading-color'/></div>");
    }
    </script>

</head>
<body >
<form name="frm" id="frm" method="post" >
    <input type="hidden" name="companyid" id="companyid" value="<%=action.getUser().getCompanyId()%>"/>
    <input type="hidden" name="TG_USERID" id="TG_USERID" />
    <input type="hidden" name="jkRnum" id="jkRnum" />
</form>

    <div id="content">
        <div class="cont_body">
            <div class="title mt30">종합평가</div>
            <div class="table_tin01">
                <div class="px">※  종합평가는 년도 기준으로 여러 번 생성 가능합니다. 종합평가 공개 시 부서장들에게 공개 됩니다.</div>
                <ul>
                    <li>
                        <label for="yyyy" >평가년도</label> : 
                        <select id="yyyy" style="width:100px;"></select>
                        <select id="runList" style="width:350px;"></select>
                        <span id="createtime" style="padding-left:50px;"></span>
                        <span id="evlTargCnt" style="padding-left:50px;"></span>
                    </li>
                </ul>
            </div>
            
	        <div class="table_zone" >
	            <div style="width:100%; text-align:right">
                    <a class="k-button"  href="javascript:excelDownLoad()" >엑셀 다운로드</a>&nbsp
                    <button id="publBtn" class="k-button" >종합평가공개</button>
                    <button id="newBtn" class="k-button" >종합평가생성</button>
                    <button id="delBtn" class="k-button" >종합평가삭제</button>
                </div>
	            <div id="runGrid" style="top:5px;"></div>
                <div class="table_list">
	                <div id="grid" ></div>
	            </div>
	        </div>
	    </div>
    </div>

    <!-- KPI관리 팝업 -->
    <div id="ttMgmt-window" style="display:none;">
        ※ 직무와 계층별 가중치를 다르게 하여 종합평가 점수를 생성할 수 있습니다.
        <div class="mt10">
            <ul>
                <li>
                    <label for="evlyyyy" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 평가년도 선택<span style="color:red">*</span></label> : 
                    <select id="evlyyyy" ></select>
                    
                    <label for="ttEvlNm" style="padding-left:20px;"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 종합평가명<span style="color:red">*</span></label> : 
                    <input type="text" id="ttEvlNm" style="width:250px;" class="k-input" />
                </li>
            </ul>
        </div>
        <div class="mt10"><b>평가별 가중치</b>(가중치적용대상 평가별 가중치의 합계는 100이 되어야 합니다.)</div>
        <div id="weiMgmtGrid" class="mt10"></div>
        <div style="text-align:center" class="mt10">
            <button id="applyBtn" class="k-button"><span class="k-icon k-i-arrow-s"></span>적용</button>
        </div>
        <div class="mt10"><b>직원별 가중치</b>(직원당 가중치의 합계는 100이 되어야 합니다.)</div>
        <div id="ttMgmtGrid" class="mt10"></div>
        <div style="text-align:right; " class="mt10">
            
	        <button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>
	        <a class="k-button" id="cancel-btn"><span class="k-icon k-i-cancel"></span>취소</a>
        </div>
    </div>
    
    
<style>
.k-window .k-loading-mask
{
    top:0;
    left:0;
    width:100%;
    height:100%;
    z-index:2;
}
</style>
</body>
</html>