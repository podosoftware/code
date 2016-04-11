<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%
kr.podosoft.ws.service.kpi.action.ajax.KPIMgmtAction action = (kr.podosoft.ws.service.kpi.action.ajax.KPIMgmtAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
List yearList = (List)action.getItems();
%>
<html decorator="operatorSubpage">
<head>
	<title>직원별 KPI 관리</title>
	<script type="text/javascript">
	var runListDataSource;
	var gridDataSource;
	var sClassNm;
	var kpiIndex = 0;
	var fileCount = 0;
	var runClass;
	var userData;
	
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
            //브라우저 resize 이벤트 dispatch..
            $(window).resize();
            /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
            /*
	        var options = [];
            var date = new Date(); 
            var year = date.getFullYear(); 
            <% 
            if(yearList!=null && yearList.size()>0){
                for(int i=0; i<yearList.size(); i++){
                	Map map = (Map)yearList.get(i);
            %>
            options.push({"YYYY":<%=map.get("YYYY")%>, "TEXT":<%=map.get("YYYY")%>+"년"});
            <%
                }
            }else{
            %>
            options.push({"YYYY":year, "TEXT":year+"년"});
            <%
            }
            %>
	        */
	        var yyyyDataSource = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/evl_year_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){ 
                     return { EVL_TYPE: "2" };
                    }        
                },
                schema: {
                    data: "items",
                    model: {
                           fields: {
                               TEXT : { type: "string" },
                               YYYY: { type: "string" }
                           }
                       }
                }
            });
            var runListDataSource = new kendo.data.DataSource({
                type: "json",
                    transport:{
                        read: { url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/kpi_run_list.do?output=json", type:"POST" }
                    },
                    schema:{
                        data: "items",
                        model: {
                            fields: {
                                YYYY: { type: "string" },
                                RUN_NUM: { type: "int" },
                                RUN_NAME: { type: "string" }
                            }
                        }
                    },
                    serverFiltering: false,
                    serverSorting: false
            });
            
	        //평가년도 콤보박스
	        $("#yyyy").kendoComboBox({
                dataTextField: "TEXT",
                dataValueField: "YYYY",
                dataSource: yyyyDataSource,
                filter: "contains",
                suggest: true,
                index: 0,
                width: 100,
                change: function() {
                	if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
	                	runListDataSource.filter({
	                        "field":"YYYY",
	                        "operator":"eq",
	                        "value":$("#yyyy").val()
	                    });
                	}else{
                		runListDataSource.filter({});
                	}
                	$("#runList").data("kendoComboBox").select(0);
                	runClass = $("#runList").data("kendoComboBox").dataItem();
                	getGridDataSource();
                 },
                 dataBound:function(e){
                     if(yyyyDataSource.data().length>0){
                    	 if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
                             runListDataSource.filter({
                                 "field":"YYYY",
                                 "operator":"eq",
                                 "value":$("#yyyy").val()
                             });
                         }else{
                             runListDataSource.filter({});
                         }
                     }
                 }
            });
	        //$("#yyyy").data("kendoComboBox").select(0);
	        
	        $("#runList").kendoComboBox({
                dataTextField: "RUN_NAME",
                dataValueField: "RUN_NUM",
                dataSource: runListDataSource,
                filter: "contains",
                suggest: true ,
                index: 0,
                width: 250,
                change: function(dataItem){
                	runClass = this.dataItem(this.select());
                	
                	getGridDataSource();
                },
                dataBound:function(e){
                    $("#runList").data("kendoComboBox").select(0);
                    runClass = this.dataItem(this.select());
                    $("#grid").data("kendoGrid").dataSource.read();
                }
            });
	        
	        //화면 로딩후 평가목록 패치시 실행..
	        runListDataSource.fetch(function(){
	        	if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
		        	runListDataSource.filter({
	                    "field":"YYYY",
	                    "operator":"eq",
	                    "value":$("#yyyy").val()
	                });
	        		$("#runList").data("kendoComboBox").select(0);
                    runClass = $("#runList").data("kendoComboBox").dataItem();
                    
                    getGridDataSource();
		        	
		        }
            });
	        
	        //grid 세팅
	        $("#grid").empty();
	        $("#grid").kendoGrid({
	        	   dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/kpi_user_list.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){ 
	                           return { RUN_NUM :  $("#runList option:selected").val() };
	                       }
	                   },
	                   schema: {
	                       total: "totalItemCount",
	                       data: "items",
	                          model: {
	                              fields: {
	                                  CHK : { type: "boolean" },
	                                  USERID : { type: "int" },
	                                  DVS_NAME : { type: "string"},
	                                  NAME : { type: "string" },
	                                  EMPNO : { type: "string" },
	                                  JOB_NM : { type: "string" },
	                                  LEADERSHIP_NM: { type: "string" },
	                                  SETTING_FLAG: { type: "string" },
	                                  EVL_TOTAL_SCORE: {type: "int" },
	                                  RNUM : { type: "int" }
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
	                        field:"CHK",
	                        title: "선택",
	                        filterable: false,
	                        sortable: false,
	                        width:50,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:center"} ,
	                        headerTemplate: "선택<br><input type='checkbox' onchange='allSelect(this);' />",
	                        template: "<div style=\"text-align:center\"><input type=\"checkbox\" onchange='cokclick(this, #:USERID#)' #:CHK# /></div>"
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
	                        field: "",
	                        title: "목표관리",
                            filterable: false,
	                        width:200,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:center"}, 
	                        template: "<input type='button' class='k-button k-i-close' style='size:20' value='목표관리' onclick='fn_tgMgmt(#:USERID#);'/><input type='button' class='k-button k-i-close' style='size:20' value='초기화' onclick='fn_tgInitMgmt(#:USERID#, \"#:SETTING_FLAG#\");'/>"
	                    },
                        {
                            field: "SETTING_FLAG", 
                            title: "관리상태", 
                            filterable: true,
                            width:100,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template: function(dataItem){
                            	if(dataItem.SETTING_FLAG=="Y"){
                            		return "설정됨";
                            	}else{
                            		return "";
                            	}
                            }
                        },
                        {
                            field: "EVL_TOTAL_SCORE", 
                            title: "최종점수", 
                            filterable: false,
                            width:100,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"}
                        },
                        {
                            field: "CMPT_EVL_CMPL_FLAG", 
                            title: "평가상태", 
                            filterable: false,
                            width:100,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template: function(dataItem){
                                if(dataItem.CMPT_EVL_CMPL_FLAG=="1"){
                                    return "목표승인요청";
                                }else if(dataItem.CMPT_EVL_CMPL_FLAG=="2"){
                                    return "실적승인요청";
                                }else if(dataItem.CMPT_EVL_CMPL_FLAG=="3"){
                                    return "목표설정";
                                }else if(dataItem.CMPT_EVL_CMPL_FLAG=="4"){
                                    return "실적등록";
                                }else if(dataItem.CMPT_EVL_CMPL_FLAG=="5"){
                                    return "평가완료";
                                }else{
                                	return "";
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
	                sortable: true,
	                pageable: { refresh:false, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
	                selectable: false
	            });
	            
	        //검색버튼 클릭
// 	        $("#searchBtn").click(function(){
// 	        	getGridDataSource();
// 	        });
	        
	        //안내 메일 발송 버튼 클릭 시..
	        $("#mailBtn").click( function(){
	        	var gridData = $('#grid').data('kendoGrid').dataSource.data();
	        	//console.log("--------"+gridData.length);
	        	var isCnt =  0;
	        	for(var i=0; i<gridData.length; i++){
	        		if(gridData[i].CHK=="checked"){
	        			isCnt = isCnt+1;
	        		}
	        	}
	        	if(isCnt==0){
	        		alert("메일 발송 대상을 체크해주세요.");
	        		return false;
	        	}
	            var isDel = confirm("메일을 발송 하시겠습니까?");
                if(isDel){ 
                    var params = {                              
                            LIST :  $('#grid').data('kendoGrid').dataSource.data(),                                                 
                    };
                     
                    $.ajax({
                        type : 'POST',
                        url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/info_mail_send.do?output=json",
                        data : { RUN_NUM :  $("#runList").val(), item: kendo.stringify( params )},
                        complete : function( response ){
                            var obj  = eval("(" + response.responseText + ")");
                            if(obj.saveCount != 0){
                                alert("메일이 발송되었습니다");   
                            }else{
                                alert("메일이 발송에 실패 하였습니다.");
                            }                           
                        },
                        error: function( xhr, ajaxOptions, thrownError){             
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
	        });
	        
	        //엑셀업로드 버튼 클릭 시..
	        $("#uploadBtn").click( function(){
	        	if($("#runList option:selected").val() ==""){
                    alert("성과평가를 선택해주세요.");
                    return false;
                }
	        	
	        	fileCount = 0;
                $('#excel-upload-window').data("kendoWindow").center();      
                $("#excel-upload-window").data("kendoWindow").open();
               
            });
            
	        //엑셀업로드 창 
            if( !$("#excel-upload-window").data("kendoWindow") ){
                $("#excel-upload-window").kendoWindow({
                    width:"500px",
                    minWidth:"500px",
                    resizable : false,
                    title : "엑셀 업로드",
                    modal: true,
                    visible: false
                });
             }
            //파일업로드 객체 
            if( ! $("files").data("kendoUpload") ){   
                $("#files").kendoUpload({
                    multiple : false,
                    showFileList : true,
                    localization : { select: '파일 선택'
                     },
                     async: {                      
                        autoUpload: false
                    },
                    onSelect: function () {
                    	
                    }
                });                     
            }
            
            $("#windowUploadBtn").click( function() {
            	if($("#runList option:selected").val() ==""){
                    alert("성과평가를 선택해주세요.");
                    return false;
                }
            	
            	if(confirm("선택하신 파일로 업로드를 하시겠습니까?")){
            		document.uploadForm.RUN_NUM.value=$("#runList option:selected").val();
            		document.uploadForm.submit();
            		$("#excel-upload-window").data("kendoWindow").close();
            	}
            });
            
        }
    }]);   
    
    //전체선택/해제
    function allSelect(checkbox){
    	var grid = $("#grid").data("kendoGrid");
        
    	if(checkbox.checked){
    		$.each(grid.dataSource.data(), function(){
    			this.CHK = "checked";
    		});
    	}else{
    		$.each(grid.dataSource.data(), function(){
                this.CHK = "";
            });
    	}
    	grid.refresh();
    }
    
    //체크박스 체크된 데이터 세팅
    function cokclick(checkbox, userid) {
    	var data = $("#grid").data("kendoGrid").dataSource.view();
    	
    	//userid 와 같은 데이터를 배열로 리턴함..
    	var res = $.grep(data, function (e) {
    	    return e.USERID == userid;
    	});
    	
    	if(checkbox.checked){
    		res[0].CHK = "checked";
    	}else{
    		res[0].CHK = "";
    	}
    	 
    
    }
    //검색버튼 func
    function getGridDataSource(){
    	if($("#runList option:selected").val() ==""){
            alert("12성과평가를 선택해주세요.");
            return false;
        }
    	//alert($("#runList option:selected").val()+'--');
    	$("#grid").data("kendoGrid").dataSource.read();
    }
    
    //목표관리
    function fn_tgMgmt(tgUserid){
    	//alert(tgUserid);
        //$("#popupComapnyId").val(companyid);
        if($("#runList").val()==null || $("#runList").val()==""){
        	alert("관리할 성과평가가 선택되지 않았습니다.");
        	return false;
        }
        
        $("#TG_USERID").val(tgUserid);
        
        var dataGird = $("#grid").data("kendoGrid").dataSource.view();
        
        //userid 와 같은 데이터를 배열로 리턴함..
        var resGrid = $.grep(dataGird, function (e) {
            return e.USERID == tgUserid;
        });
        
        userData = resGrid[0];
        
        if( !$("#kpiMgmt-window").data("kendoWindow") ){
            $("#kpiMgmt-window").kendoWindow({
                width:"1200px",
                height:"520px",
                resizable : true,
                title : "KPI관리",
                modal: true,
                visible: false
            });
        
        
            $("#kpiMgmtGrid").empty();
            $("#kpiMgmtGrid").kendoGrid({
                dataSource: {
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/kpi_user_map_list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){
                             return { RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val() };
                        }
                    },
                    schema: {
                         data: "items",
                         model: {
                             fields: {
                                    KPI_NO : { type: "number" },
                                    KPI_TYPE_NM: { type:"string"},
                                    KPI_NM : { type: "string" },
                                    BEF_PRF: { type: "number"},
                                    NOW_TARG: { type: "number" },
                                    NOW_PRF: { type: "number" },
                                    PRIO: { type: "number" }, 
                                    WEI: { type: "number" },
                                    EVLCLS:{ type: "string" },
                                    UNIT_NM: {type: "string" }
                                }
                         }
                    },
                    serverPaging: false, serverFiltering: false, serverSorting: false
                },
                toolbar: [
                {
                    template: $("#kpimgmtToolbarTemplate").html()
                }],
                columns: [
                    {
                        field:"REG_TYPE_CD", title: "등록유형", width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem){
                            if(dataItem.REG_TYPE_CD=="1"){
                                return "회사";
                            }else if(dataItem.REG_TYPE_CD=="2"){
                                return "개인";
                            }else {
                            	return "";
                            }
                        }
                    },
                    { field:"KPI_TYPE_NM", title: "지표유형", width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"}
                    },
                    { field:"KPI_NM", title: "지표명", width:250, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"} ,
                        template: function(dataItem){
                        	var fontS = "";
                            var fontE = "";
                            if(dataItem.USEFLAG=="N"){
                                fontS = "<font color='red'>";
                                fontE = "</font>";
                            }
                            
                        	if(dataItem.UNIT_NM!=null && dataItem.UNIT_NM!=""){
                        		return fontS+dataItem.KPI_NM+" ("+dataItem.UNIT_NM+")"+fontE;
                        	}else{
                        		return fontS+dataItem.KPI_NM+fontE;
                        	} 
                        }
                    },
                    { title: "검색", width: 80,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template : function(data){
                        	if(data.USEFLAG == "Y" || data.KPI_NO == -1){
                        		return "<input type='button' class='k-button k-i-close' style='width:45' value='검색' onclick='fn_kpiSelect("+data.KPI_NO+");'/>";
                        	}else{
                        		return "";
                        	}
                        	
                        }
                    },
                    { field:"BEF_PRF", title: "전기실적", width: 100,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template: function(data){                        	
                        	var befPrf = "";
                            if(data.BEF_PRF!=null) befPrf= data.BEF_PRF;
                            var sts = "";
                            var color = "";
                            if(data.USEFLAG != "Y") { sts= "readOnly"; color="background-color:#eeeeee;"; }
                            
                            return "<input type='text' id='bef_prf_"+data.RNUM+"' name='bef_prf_"+data.RNUM+"' value='"+befPrf+"' onkeyup='setKpiValue(\"bef_prf\", "+data.RNUM+", this);  ' class='k-input input_95' style='text-align:center; "+color+" ' "+sts+" />";
                        } 
                     },
                    { field:"NOW_TARG", title: "당기목표",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template: function(dataItem){
                        	var nowTarg = "";
                            if(dataItem.NOW_TARG!=null) nowTarg= dataItem.NOW_TARG;
                            var sts = "";
                            var color = "";
                            if(dataItem.USEFLAG != "Y") { sts= "readOnly"; color="background-color:#eeeeee;"; }
                            
                            return "<input type='text' id='now_targ_"+dataItem.RNUM+"' name='now_targ_"+dataItem.RNUM+"' value='"+nowTarg+"' onkeyup='setKpiValue(\"now_targ\", "+dataItem.RNUM+", this);  ' class='k-input input_95' style='text-align:center; "+color+" ' "+sts+" />";
                            //return "<input type=\"text\" id=\"now_targ_#:RNUM#\" name=\"now_targ_#:RNUM#\" value=\"# if(NOW_TARG != null){##:NOW_TARG## }#\" onkeyup=\" setKpiValue('now_targ', #:RNUM#, this);\" class=\"k-input input_95\" />";
                        }
                    },
                    { field:"NOW_PRF", title: "당기실적",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    { field:"PRIO", title: "우선순위",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template: function(dataItem){
                            var prio = "";
                            if(dataItem.PRIO!=null) prio= dataItem.PRIO;
                            var sts = "";
                            var color = "";
                            if(dataItem.USEFLAG != "Y") { sts= "readOnly"; color="background-color:#eeeeee;"; }
                            
                            return "<input type='text' id='prio_"+dataItem.RNUM+"' name='prio_"+dataItem.RNUM+"' value='"+prio+"' onkeyup='setKpiValue(\"prio\", "+dataItem.RNUM+", this); ' class='k-input input_95' style='text-align:center; "+color+" ' "+sts+" />";
                        }
                        //template: "<input type=\"text\" id=\"prio_#:RNUM#\" name=\"prio_#:RNUM#\" value=\"# if(PRIO != null){##:PRIO## }#\" onkeyup=\" setKpiValue('prio', #:RNUM#, this);\" class=\"k-input input_95\" />"
                    },
                    { field:"WEI", title: "가중치<br>(%)",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    { field:"SCLS_ST", title: "S등급",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template: function(dataItem){
                        	if(dataItem.SCLS_ST!=null){
                        		return dataItem.SCLS_ST+"이상";
                        	}else{
                        		return "";
                        	}
                        }
                    },
                    { field:"ACLS_ST", title: "A등급<br>",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}  ,
                        template: function(dataItem){
                        	var acls = "";
                            if(dataItem.ACLS_ST!=null){
                            	acls = dataItem.ACLS_ST+"이상";
                            }
                            if(dataItem.ACLS_ED!=null){
                                acls += "<br>"+dataItem.ACLS_ED+"미만";
                            }
                            return acls;
                        }
                    },
                    { field:"BCLS_ST", title: "B등급<br>",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}  ,
                        template: function(dataItem){
                            var bcls = "";
                            if(dataItem.BCLS_ST!=null){
                                bcls = dataItem.BCLS_ST+"이상";
                            }
                            if(dataItem.BCLS_ED!=null){
                                bcls += "<br>"+dataItem.BCLS_ED+"미만";
                            }
                            return bcls;
                        }
                    },
                    { field:"CCLS_ST", title: "C등급<br>",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}  ,
                        template: function(dataItem){
                            var ccls = "";
                            if(dataItem.CCLS_ST!=null){
                                ccls = dataItem.CCLS_ST+"이상";
                            }
                            if(dataItem.CCLS_ED!=null){
                                ccls += "<br>"+dataItem.CCLS_ED+"미만";
                            }
                            return ccls;
                        }
                    },
                    { field:"DCLS_ST", title: "D등급<br>",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}  ,
                        template: function(dataItem){
                            var dcls = "";
                            if(dataItem.DCLS_ED!=null){
                                dcls += dataItem.DCLS_ED+"미만";
                            }
                            return dcls;
                        }
                    },
                    { field:"EVLCLS", title: "현등급",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    { field:"DEL", title: "삭제",  width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template:function(dataItem){
                            if(dataItem.USEFLAG == 'N'){
                                return "소속부서장에 의해 삭제됨";
                            }else{
                                
                                //if(dataItem.STS=="3"){
                                //    if(dataItem.REG_TYPE_CD=="2"){
                                        return "<input type='button' class='k-button k-i-cancel' style='width:45' value='삭제' onclick='fn_kpiRemove("+dataItem.KPI_NO+");'/>";
                                //    }else{
                                //        return "-";
                                //    }
                                    
                                //}else{
                                //    return "-";
                                //}

                            }
                        }
                        //template : "<input type='button' class='k-button k-i-cancel' style='width:45' value='삭제' onclick='fn_kpiRemove(#:KPI_NO#);'/>"
                    }
                ],
                dataBound: function(e) {
                    //$(".amount").kendoNumericTextBox();
                    if($('#kpiMgmtGrid').data('kendoGrid').dataSource.data()!=null){
                    	kpiIndex = $('#kpiMgmtGrid').data('kendoGrid').dataSource.data().length;
                    }else{
                    	kpiIndex = 0;
                    }
                	
                },
                filterable: false,
                sortable: false, pageable: false, height: 420//,
                //rowTemplate: kendo.template($('#row-template').html())
            });
            
        
            //사용 역량 저장 버튼 클릭
            $("#saveKpiBtn").click( function (){

                //평가완료된 사용자는 지표 추가 못한다..
                if(userData.CMPT_EVL_CMPL_FLAG == "5"){
                    alert("평가가 완료되어 저장할 수 없습니다.");
                    return false;
                }
                
            	//지표설정 체크
            	var array = $('#kpiMgmtGrid').data('kendoGrid').dataSource.data();
                for(var i=0; i<array.length; i++){
                    if(array[i].KPI_NO==null || array[i].KPI_NO=="" || array[i].KPI_NO==-1){
                        alert(i+"번째 항목의 지표가 설정되지 않았습니다.");
                        return;
                    }
                    if(array[i].USEFLAG == "Y"){
                    	
	                    if(array[i].BEF_PRF==null || array[i].BEF_PRF==""){
	                        alert("전기실적은 필수입력입니다.");
	                        return;
	                    }
	                    if(array[i].NOW_TARG==null || array[i].NOW_TARG==""){
	                        alert("당기목표는 필수입력입니다.");
	                        return;
	                    }
	                    if(array[i].PRIO==null || array[i].PRIO==""){
	                        alert("우선순위는 필수입력입니다.");
	                        return;
	                    }

                    }
                }
                
                var isConfirm = confirm("저장하시겠습니까?");
                if(isConfirm){
                    var params = {
                            LIST :  $('#kpiMgmtGrid').data('kendoGrid').dataSource.data() 
                    };
                    
                    $.ajax({
                       type : 'POST',
                       url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/save_kpi_user.do?output=json",
                       data : { item: kendo.stringify( params ), RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val(), REG_TYPE_CD: "1" },
                       complete : function( response ){
                           var obj  = eval("(" + response.responseText + ")");
                           if(obj.saveCount != 0){
                               $('#kpiMgmtGrid').data('kendoGrid').dataSource.read();
                               $('#grid').data('kendoGrid').dataSource.read();
                               alert("저장되었습니다.");  
                           }else{
                               alert("저장에 실패 하였습니다.");
                           }                           
                       },
                       error: function( xhr, ajaxOptions, thrownError){
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
            });
            
            //취소버튼 클릭
            $("#cancel-kpi-btn").click(  function() {
                $("#kpiMgmt-window").data("kendoWindow").close();
            });
            

            //지표추가 버튼 클릭
            $("#addKpiBtn").click( function(){
            	//alert("add");
            	
            	//평가완료된 사용자는 지표 추가 못한다..
            	if(userData.CMPT_EVL_CMPL_FLAG == "5"){
            		alert("평가가 완료되어 지표를 추가할 수 없습니다.");
            		return false;
            	}
            	
            	var array = $('#kpiMgmtGrid').data('kendoGrid').dataSource.data();
            	for(var i=0; i<array.length; i++){
            		if(array[i].KPI_NO==null || array[i].KPI_NO=="" || array[i].KPI_NO==-1){
            			alert("검색버튼을 클릭하여 지표를 먼저 선택해주세요.");
            			return;
            		}
            	}
            	
            	$("#kpiMgmtGrid").data("kendoGrid").dataSource.insert({
            		RNUM: kpiIndex,
            		KPI_NO:-1, 
            		KPI_TYPE_NM:"", 
            		KPI_NM:"",
            		BEF_PRF:null, 
            		NOW_TARG:null,
            		PRIO:null,
            		WEI:null,
            		UNIT_NM: ""
            	});
            	
            	kpiIndex = kpiIndex +1;
            	
            	//자동으로 지표검색 팝업 호출
            	fn_kpiSelect(-1);
            });
            

            //목표 관리 가이드 창 
            if( !$("#tgmtGuide-window").data("kendoWindow") ){
                $("#tgmtGuide-window").kendoWindow({
                    width:"800px",
                    height: "500px",
                    resizable : true,
                    title : "목표 관리 가이드",
                    modal: false,
                    visible: false
                });
             }
          
            //목표 관리 가이드 버튼 클릭
            $("#guideBtn").click( function(){
                $('#tgmtGuide-window').data("kendoWindow").center();      
                $("#tgmtGuide-window").data("kendoWindow").open();
            });

            
            
        }else{
            $('#kpiMgmtGrid').data('kendoGrid').dataSource.read();
        }

        $("#kpiMgmt-window").data("kendoWindow").resize();
        
        $("#kpiMgmtGrid th[data-field=SCLS_ST]").html("S등급<br>"+runClass.SCLASS);
        $("#kpiMgmtGrid th[data-field=ACLS_ST]").html("A등급<br>"+runClass.ACLASS);
        $("#kpiMgmtGrid th[data-field=BCLS_ST]").html("B등급<br>"+runClass.BCLASS);
        $("#kpiMgmtGrid th[data-field=CCLS_ST]").html("C등급<br>"+runClass.CCLASS);
        $("#kpiMgmtGrid th[data-field=DCLS_ST]").html("D등급<br>"+runClass.DCLASS);
        
        //대상자 정보 세팅
        //$("#userInfoLabel").text(companyname);
        $.ajax({
            type : 'POST',
            url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/kpi_use_info.do?output=json",
            data : { TG_USERID : $("#TG_USERID").val() },
            complete : function( response ){
                var obj  = eval("(" + response.responseText + ")");
                
                if(obj.items != null){
                	var tgStr = obj.items[0].NAME;
                	if(obj.items[0].DVS_NAME!=null ){
                		tgStr += " / "+obj.items[0].DVS_NAME;
                	}
                	if(obj.items[0].LEADERSHIP_NAME !=null){
                		tgStr += " / "+obj.items[0].LEADERSHIP_NAME;
                	}
                    $("#kpiUserInfo").text("※ 대상자 : "+tgStr);
                }else{
                	$("#kpiUserInfo").text("※ 대상자 정보 조회에 실패 하였습니다" );
                    alert("대상자 정보 조회에 실패 하였습니다.");
                }                           
            },
            error: function( xhr, ajaxOptions, thrownError){
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

        $("#kpiMgmt-window").data("kendoWindow").center();
        $("#kpiMgmt-window").data("kendoWindow").open();
        
        
    }
    
    //목표관리 초기화
    function fn_tgInitMgmt(tgUserid, settingFlag){
        if($("#runList").val()==null || $("#runList").val()==""){
            alert("관리할 성과평가가 선택되지 않았습니다.");
            return false;
        }
        
        $("#TG_USERID").val(tgUserid);
        
        if(settingFlag!="Y"){
        	alert("목표설정이 되어있지 않습니다.");
        	return false;
        }
        if(confirm("설정된 값을 초기화 하시겠습니까?\n확인을 클릭하시면 설정된 지표 내용이 모두 삭제됩니다.")){
        	$.ajax({
                type : 'POST',
                url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/init_kpi_map.do?output=json",
                data : { RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val() },
                complete : function( response ){
                    var obj  = eval("(" + response.responseText + ")");
                    if(obj.saveCount != 0){
                        $('#grid').data("kendoGrid").dataSource.read();
                    }else{
                        alert("초기화를 실패 하였습니다.");
                    } 
                },
                error: function( xhr, ajaxOptions, thrownError){                                
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
    
    //kpi value 셋팅
    function setKpiValue(column, rows, obj){
    	var array = $('#kpiMgmtGrid').data('kendoGrid').dataSource.data();            
        
    	if(column == "bef_prf"){
    		if(chkNoNull(obj) && isNumber(obj)){
    			array[rows].BEF_PRF = $("#bef_prf_"+rows).val();
    		}else{
    			array[rows].BEF_PRF = null;
    		}
    	}else if(column == "now_targ"){
    		if(chkNoNull(obj) && isNumber(obj)){
                array[rows].NOW_TARG = $("#now_targ_"+rows).val();
    		}else{
    			array[rows].NOW_TARG = null;
    		}
    	}else if(column == "prio"){
    		if(chkNoNull(obj) && chkNum(obj)){
                array[rows].PRIO = $("#prio_"+rows).val();
    		}else{
    			array[rows].PRIO = null;
    		}
    	}
    }
    
    //kpi 지표 삭제..
    function fn_kpiRemove(kpiNo){

        //평가완료된 사용자는 지표 추가 못한다..
        if(userData.CMPT_EVL_CMPL_FLAG == "5"){
            alert("평가가 완료되어 삭제할 수 없습니다.");
            return false;
        }
        
    	var array = $('#kpiMgmtGrid').data('kendoGrid').dataSource.data();
    	var res = $.grep(array, function (e) {
            return e.KPI_NO == kpiNo;
        });
        
    	
    	
    	if(res[0].NOW_PRF && res[0].NOW_PRF > 0){
    		alert("당기실적이 있는 지표는 삭제할 수 없습니다.");
    		return false;
    	}
    	if(res[0].KPI_NO == -1){
    		$('#kpiMgmtGrid').data('kendoGrid').dataSource.remove(res[0]);
        }else{
			if(confirm("삭제하시겠습니까? \n확인을 클릭하시면 설정된 지표의 모든 내용이 삭제됩니다.")){
	    		
		        var length = array.length;
		
		        //var item, i;
		        for(var i=0; i<length; i++){
		        	//alert(array[i].KPI_NO +","+ kpiNo);
					if(array[i].KPI_NO == kpiNo){
					    $('#kpiMgmtGrid').data('kendoGrid').dataSource.remove(array[i]);
					    if(kpiNo != -1){
						    $.ajax({
					            type : 'POST',
					            url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/del_kpi_map.do?output=json",
					            data : { RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val(), KPI_NO : kpiNo },
					            complete : function( response ){
					                var obj  = eval("(" + response.responseText + ")");
					                if(obj.saveCount != 0){
					                    $('#kpiMgmtGrid').data("kendoGrid").dataSource.read();
					                    $('#grid').data("kendoGrid").dataSource.read();
					                }else{
					                    alert("저장에 실패 하였습니다.");
					                }                           
					            },
					            error: function( xhr, ajaxOptions, thrownError){                                
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
					    break;
					}
		        }
		        $('#kpiMgmtGrid').data('kendoGrid').refresh();
	        }
        }
    }
    
    function fn_kpiSelect(kpiNo){
    	//alert(kpiNo);
    	$("#jkRnum").val(kpiNo);
    	var array = $('#kpiMgmtGrid').data('kendoGrid').dataSource.data();
    	var res = $.grep(array, function (e) {
            return e.KPI_NO == kpiNo;
        });
    	
        if(res[0].KPI_NO!=null && res[0].KPI_NO!="" &&  res[0].KPI_NO!="-1"){
        	alert("이미 지표설정이 완료된 데이터입니다.\n변경이 필요한 경우 삭제 후 다시 설정해주세요.");
        	return false;
        }
        
        if( !$("#kpiList-window").data("kendoWindow") ){
            $("#kpiList-window").kendoWindow({
                width:"1000px",
                minHeight:"400px",
                resizable : true,
                title : "KPI검색",
                modal: true,
                visible: false
            });
        
        
            $("#kpiListGrid").empty();
            $("#kpiListGrid").kendoGrid({
                dataSource: {
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/kpi_use_list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){
                             return { };
                        }
                    },
                    schema: {
                         data: "items",
                         model: {
                             fields: {
                                    KPI_NO : { type: "number" },
                                    KPI_NM : { type: "string" },
                                    KPI_TYPE_NM : { type: "string" },
                                    MEA_EVL_CYC_NM : { type: "string" },
                                    EVL_TYPE_NM : { type: "string" },
                                    EVL_HOW_NM : { type: "string" },
                                    UNIT_NM : { type: "string" },
                                    RNUM : { type: "number" }
                                }
                         }
                    },
                    serverPaging: false, serverFiltering: false, serverSorting: false
                },
                columns: [
                    { field:"KPI_TYPE_NM", title: "지표유형", filterable: true, width:100, 
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"} 
                     },
                     { field:"KPI_NM", title: "지표명", filterable: true, width: 300,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"} 
                     },
                     { field:"MEA_EVL_CYC_NM", title: "관리주기", filterable: true,  width:100, 
                         headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                         attributes:{"class":"table-cell", style:"text-align:center"} 
                      },
                      { field:"EVL_TYPE_NM", title: "Characteristic", filterable: true, width:100, 
                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                          attributes:{"class":"table-cell", style:"text-align:left"} 
                       },
                     { field:"EVL_HOW_NM", title: "관리유형", filterable: true,  width:100, 
                         headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                         attributes:{"class":"table-cell", style:"text-align:center"} 
                      },
                      { field:"UNIT_NM", title: "단위", filterable: true,  width:100, 
                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                          attributes:{"class":"table-cell", style:"text-align:center"} 
                       },
                       {
                    	   title: "선택", filterable: false, width: 100,
                    	   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                           attributes:{"class":"table-cell", style:"text-align:center"} ,
                           template: function(dataItem){
                        	   
                        	   return "<input type='button' class='k-button k-i-close' style='size:20' value='선택' onclick='fn_selectKpi(\""+dataItem.KPI_NO+"\", \""+dataItem.MEA_EVL_CYC+"\");'/>";
                           }
                       }
                ],
                 filterable: {
                     extra : false,
                     messages : {filter : "필터", clear : "초기화"},
                     operators : { 
                         string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
                         number : { eq : "같음", gte : "이상", lte : "이하"}
                     }
                 },
                 sortable: true, pageable: false, height: 380
             });
            
        }else{
            $('#kpiListGrid').data('kendoGrid').dataSource.read();
        }
        
        $("#kpiList-window").data("kendoWindow").center();
        $("#kpiList-window").data("kendoWindow").open();
        
    }

    function fn_selectKpi(kpiNo, mea_evl_cyc){
    	//이미 추가된 지표인지 체크
    	var array = $('#kpiMgmtGrid').data('kendoGrid').dataSource.data();
        for(var i=0; i<array.length; i++){
            //alert(array[i].KPI_NO+","+kpiNo);
            if(array[i].KPI_NO!=null && array[i].KPI_NO!=""){
                if(array[i].KPI_NO == kpiNo){
                	alert("이미 추가된 지표입니다.");
                	return;
                }
            }
        }
        //alert(runClass.EVL_PRD_CD+","+mea_evl_cyc);
        //상반기, 하반기 성과평가인 경우 관리주기 주기가 연단위인 지표는 설정하지 못하도록 제어..
    	if(runClass.EVL_PRD_CD=="1" || runClass.EVL_PRD_CD=="2"){
    		if(mea_evl_cyc == "4"){
    			var div;
    			if(runClass.EVL_PRD_CD=="1"){
    				div = "상반기";
    			}else{
    				div = "하반기";
    			}
    			alert("성과평가가 "+div+"로 설정되어있기 때문에\n관리주기가 연단위인 지표는 매핑할 수 없습니다.");
    			return false;
    		}
    	}
    	
        $.ajax({
            type : 'POST',
            url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/add_kpi_user_map.do?output=json",
            data : { RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val(), KPI_NO : kpiNo },
            complete : function( response ){
                var obj  = eval("(" + response.responseText + ")");
                if(obj.saveCount != 0){
                	$('#kpiMgmtGrid').data("kendoGrid").dataSource.read();
                	$('#grid').data("kendoGrid").dataSource.read();
                	$("#kpiList-window").data("kendoWindow").close();
                }else{
                    alert("저장에 실패 하였습니다.");
                }                           
            },
            error: function( xhr, ajaxOptions, thrownError){                                
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
    
    //엑셀다운로드
    function excelDownLoad(){
    	if($("#runList").val()==null || $("#runList").val()==""){
    		alert("성과평가를 선택해주세요.");
    		return false;
    	}
    	frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/kpi_user_map_list_excel.do?RUN_NUM="+$("#runList").val();
    	frm.submit();
    }
    //엑셀 템플릿 다운로드
    function excelTemplateDownLoad(){
        frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/KPI_SETTING_TEMPLATE.xls";
        frm.submit();
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
            <div class="title mt30">직원별KPI관리</div>
            <div class="table_tin01">
                <ul>
                    <li>
                        <label for="yyyy" >평가명</label> : 
                        <select id="yyyy" style="width:100px;"></select>
                        <select id="runList" style="width:350px;"></select>
<!--                         <button id="searchBtn" class="k-button" >검색</button> -->

                    </li>
<!--                     <li class="mt10"> -->
<!--                         <label for="runList" >성과평가</label> :  -->
                        
<!--                     </li> -->
                </ul>
            </div>
            
	        <div class="table_zone" >
                <div class="table_btn">
	                <button id="mailBtn" class="k-button" >안내메일발송</button>&nbsp;
	                <a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp;
	                <button id="uploadBtn" class="k-button" >엑셀업로드</button>&nbsp;
	                <a class="k-button"  href="javascript:excelDownLoad()" >엑셀 다운로드</a>
	            </div>
	            <div class="table_list">
	                <div id="grid" ></div>
	            </div>
	        </div>
	    </div>
    </div>

	           
                
<script type="text/x-kendo-template" id="kpimgmtToolbarTemplate">
    <div style="position: relative;">
        <div style="width: 50%; text-align: left; float: left;"><span id="kpiUserInfo"></span></div>
        <div style="width: 50%; text-align: right; float: left" >
            <button id="guideBtn" class="k-button">목표 관리 가이드</button>
            <button id="addKpiBtn" class="k-button" >지표 추가</button>
        </div>
    <div>
</script>
    
    <!-- KPI관리 팝업 -->
    <div id="kpiMgmt-window" style="display:none; overflow-y: hidden;">
        <div style="position: relative;">
	        <span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> <b>지표추가</b> 버튼을 통해 지표를 선택하면 자동 저장됩니다.<br>
	        <span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 화면 하단의 <b>저장</b> 버튼은 전기실적, 당기목표, 우선순위 등을 저장합니다.
	        <div id="kpiMgmtGrid" ></div>
	        <div style="height:10px;"></div>
	        <div style="text-align:center">
	                 <button id="saveKpiBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>
	                 <a class="k-button" id="cancel-kpi-btn"><span class="k-icon k-i-cancel"></span>닫기</a>
	        </div>
        </div>
    </div>
    
    <!-- 목표 관리 가이드 팝업 -->
    <div id="tgmtGuide-window" style="display:none;">
		<div class="pop03">
		    <div class="title01">
		        <span class="icon_b">목표관리 ( Management  by  Objectives )</span>
		        <ul>
		            <li>- 목표관리는 일정기간 동안의 구성원의 업무목표가  조직의 상위목표에 기여할 수 있도록 리더와 구성원이 합의에 의하여 직무 및 업무목표를 계획하는 방법임</li>
		            <li>- 목표관리는 리더와 구성원이 합의에 의해서 목표를 수립함</li>
		            <li>- 목표관리는 상호 협의, 합의, 및 위임에 초점을 둠</li>
		            <li>- 리더와 구성원은 상호 성과평가기준을 분명히 이해함</li>
		        </ul>
		    </div>
		    <div class="title01">
		        <span class="icon_b">목표설정의 원칙</span>
		        <ul>
		            <li>- Cascading 원칙: 상위목표와 연계된 목표를 설정한다.</li>
		            <li>- 협의의 원칙: 설정한 목표는 반드시 상사와 합의과정을 거쳐 확정되어야 한다.</li>
		            <li>- 조정의 원칙: 사업환경, 외부환경이 변화하여 목표의 변경이 필요한 경우 상사와 협의를 통하여 목표를 조정하여야 한다.</li>
		            <li>- SMART 원칙: 목표는 반드시 SMART하게 수립되어져야 한다.</li>
		        </ul>
		        <ul>
		            <li class="con_blue"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/images/popup/con01.gif" alt="구체적일것SPECIFIC" />: 행동에 영향을 줄 수 있도록 구체적으로 설계되어야 한다</li>
		            <li class="con_blue"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/images/popup/con02.gif" alt="측정가능할것MEASURABLE" />: 목표를 측정할 수 있도록 설계되어야 한다</li>
		            <li class="con_blue"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/images/popup/con03.gif" alt="성취가능할것ACHIEVABLE" />: 현실적이고 실현 가능하며 실행 가능하고 받아들일 수 있어야 한다</li>
		            <li class="con_blue"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/images/popup/con04.gif" alt="결과지향적일것RESULT-ORIENTED" />: 구체적 성과와 관련되어야 한다</li>
		            <li class="con_blue"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/images/popup/con05.gif" alt="시간한정적일것TIME-SPECIFIC" />: 시간제한을 가지고 있어야 한다</li>
		        </ul>
		    </div>
		    <div class="title02">
		        <span class="icon_b">년간 목표관리 Process</span>
		        <div class="con_bg">
		            <ul class="box01">
		                <li>- 중.장기 경영계획의 검토<span style="padding-left:20px">- 상위조직의 중.장기 계획</span></li>
		                <li>- 핵심성공요인(CSF)<span style="padding-left:45px">- 상위조직의 핵심목표</span></li>
		                <li>- 고객 및 경쟁사 관련자료<span style="padding-left:20px">- 전년도 업무목표 및 관리</span></li>
		                <li>- 문제점 및 대책<span style="padding-left:72px">- 기본사항의 달성도 평가</span></li>
		            </ul>
		            <p class="box02">주요 Issue의 선정 및<br />우선순위 분류</p>
		            <p class="box03">Breakthrough<br />Issues의 결정</p>
		            <p class="box04">Non-<br />Breakthrough<br />Issues의 결정</p>
		            <p class="box05">핵심목표(Obi&Goal)<br />추진전략, 평가 기준,<br />실행계획의 수립</p>
		            <p class="box06">관린의 기본사항,<br />하위조직의 목표,<br />기타 등으로 구분</p>
		            <p class="box07">의견교환 및 실행계획 수립</p>
		            <p class="box08">수립된 목표(Breakthrough &<br />Buz Fundamental)의<br />주기적인 검토</p>
		            <p class="box09">점검결과</p>
		            <p class="box10">문제점의 분석,<br />대책 수립 및 실시</p>
		            <p class="box11">문서화 및<br />표준화</p>
		    </div>
		</div>
    </div>
    </div>
    <!-- KPI검색 팝업 -->
    <div id="kpiList-window" style="display:none;">
        <div id="kpiList-window-selecter">
            <div id="kpiListGrid"></div>
        </div>
    </div>
        
    <!-- 엑셀업로드 창 -->
    <div id="excel-upload-window" style="display: none; width: 500px;">
        <form id="uploadForm" name="uploadForm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/kpi_user_map_excel_upload.do?">
            <input type="hidden" name="RUN_NUM" id="RUN_NUM" />
            ※ 템플릿을 다운 받아 직원별KPI정보를 작성 후 업로드 하세요<br>
            ※ 템플릿의 빨간색 열은 필수 입력, 노란색은 선택입력 사항입니다.<br>
            ※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.<br>
            <div>
                <input name="files" id="files" type="file" /> </br>
                <div style="text-align: right;">
                    <a class="k-button"  href="javascript:excelTemplateDownLoad()" >템플릿 다운로드</a>&nbsp
                    <input type="button" value="엑셀 업로드" class="k-button" id="windowUploadBtn" />
                </div>
            </div>
        </form>
    </div>
    
</body>
</html>