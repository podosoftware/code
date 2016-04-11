<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page pageEncoding="UTF-8" isErrorPage="true"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
//총괄관리자 권한 여부..
boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
//고객사운영자 권한 여부..
boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
//부서장 권한 여부..
boolean isManager = request.isUserInRole("ROLE_MANAGER");
%>

<html decorator="operatorSubpage">
<head>
<title>핵심인재관리</title>
<script type="text/javascript">

var dataSource_training ;
var dataSource_deptDesignation;
var dataSource_perfAsseSbjCd;
var dataSource_officeTimeCd;
var dataSource_eduinsDivCd;
var dropdownlist_deptDesignationCd;
var dataSource_alwStdCd1 ;
var dataSource_alwStdCd2 ;
var dataSource_alwStdCd ;
var now = new Date();

    yepnope([ {
        load : [ 'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
                'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js', 
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js', 
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js', 
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/jquery.form.min.js'
        ],
        complete : function() {
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
                
                //스플릿터 사이즈 재조정..
                var splitterElement = $("#splitter");
                //스플릿터 top 위치와 footer 높이, padding 30을 합한 높이를 윈도우창 사이즈에서 빼줌.
                splitterOtherHeight = $("#splitter").offset().top + $("#footer").outerHeight() + 15; //
                splitterElement.height(winHeight - splitterOtherHeight);
                
                //그리드 사이즈 재조정..
                var gridElement = $("#grid");
                gridElement.height(splitterElement.outerHeight()-2);
                
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
          
            //로딩바 선언..
            loadingDefine();
            
            // area splitter
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
            
            //기준년도 
            //var now = new Date();
            var maxYyyy = now.getFullYear()+1;
            var arrYyyy = [];
            for(var i=maxYyyy; i>=2004; i--){
            	arrYyyy.push({VALUE: i, TEXT:(i+"년")});
            }
            var dataSource_searchYyyy = new kendo.data.ObservableArray( arrYyyy );
            
            var searchYyyy = $("#searchYyyy").kendoDropDownList({
                dataTextField: "TEXT",
                dataValueField: "VALUE",
                dataSource: dataSource_searchYyyy,
                filter: "contains",
                suggest: true,
                dataBound:function(e){
                	this.value(now.getFullYear());
                }
            }).data("kendoDropDownList");

            //검색버튼 클릭
            $("#yyyySearchBtn").click(function(){
            	if(searchYyyy.value()){
            		//alert(searchYyyy.value());
            		$("#grid").data("kendoGrid").dataSource.read();
            	}else{
            		alert("연도를 선택해주세요.")
            	}
            });
            
            // show detail 
            $('#details').show().html(kendo.template($('#template').html()));
    
	        //핵심인재관리 목록 그리드 생성
	        $("#grid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                	read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/cdp/get_core_person_manage_list.do?output=json",
	                        type : "POST"
	                    },
	                    parameterMap : function(options, operation) {
	                    	return { year : searchYyyy.value()}
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        id : "MJR_TLNT_SEQ",
	                        fields : {
	                        	MJR_TLNT_SEQ : { type : "number" },
	                            USERID : { type : "number" },
	                            RESULT : { type : "number" }
	                        }
	                    }
	                },
	                pageSize : 30,
	                serverPaging : false,
	                serverFiltering : false,
	                serverSorting : false
	            },
	            columns : [
	                    {
	                        field : "NAME",
	                        title : "성명",
	                        width : "100px",
	                        headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                        attributes : { "class" : "table-cell", style : "text-align:center;text-decoration: underline;" },
	                        template: function(data){
	                        	var name = data.NAME;
	                        	//if(data.USEFLAG == 'N'){
	                        	name = "<font color='blue'>"+data.NAME+"</font>";
	                        	//}
	                        	return "<a href='javascript:void();' onclick='javascript: fn_detailView("+data.MJR_TLNT_SEQ+");' >"+name+"</a>";
	                        } 	                        
	                    },
	                    {
	                        field : "EMPNO",
	                        title : "교직원번호",
	                        width : "80px",
	                        headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                        attributes : { "class" : "table-cell", style : "text-align:center" }
	                    },
	                    {
	                        field : "DVS_NAME",
	                        title : "부서",
	                        width : "150px",
	                        headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                        attributes : { "class" : "table-cell", style : "text-align:center" }
	                    },
	                    {
	                        field : "GRADE_NM",
	                        title : "직급",
	                        width : "100px",
	                        headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                        attributes : { "class" : "table-cell", style : "text-align:center" }
	                    },
	                    {
	                        field : "MJR_TLNT_DIV_CD_NM",
	                        title : "핵심인재구분",
	                        width : "80px",
	                        headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                        attributes : { "class" : "table-cell", style : "text-align:center" }
	                    },
	                    {
	                        field : "ALW_STD_CD_NM",
	                        title : "상시학습종류",
	                        width : "100px",
	                        headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                        attributes : { "class" : "table-cell", style : "text-align:center" }
	                    },
	                    {
	                        field : "SBJ_NM",
	                        title : "제목",
	                        width : "200px",
	                        headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                        attributes : { "class" : "table-cell", style : "text-align:center" }
	                    },
	                    {
	                        field : "EDU_PERIOD",
	                        title : "교육기간",
	                        width : "150px",
	                        headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                        attributes : { "class" : "table-cell", style : "text-align:center" }
	                    },
	                    {
	                        field : "RECOG_TIME",
	                        title : "인정시간",
	                        width : "80px",
	                        headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                        attributes : { "class" : "table-cell", style : "text-align:center" }
	                    }  
	                    ],
	            filterable : {
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
	            sortable : true,
	            pageable : true,
	            resizable : true,
	            reorderable : true,
	            selectable: "row",
	            pageable : {
	                refresh : false,
	                pageSizes : false,
	                messages : {
	                    display : ' {1} / {2}'
	                }
	            }
	        });
	        
	

	        //엑셀파일업로드 팝업창 정의.. 상단에서 jquery.form.min.js 파일로드 해야함. 
	        if (!$("#excel-upload-window").data("kendoWindow")) {
	            $("#excel-upload-window").kendoWindow({
	                width : "340px",
	                minWidth : "340px",
	                resizable : false,
	                title : "핵심인재관리 엑셀 업로드",
	                modal : true,
	                visible : false
	            });
	            
	            
	            //과정 업로드 버튼 이벤트
	            $("#uploadBtn").click(function() {
	            	$("#excelForm").ajaxForm({
	            		data : $(this).serialize(),
                        cache: false,
                        type : 'POST',
                        iframe : true,
                        dataType : 'html',
                        contentType:"text/html; charset=UTF-8",
	                    beforeSubmit: function(data,frm, opt){
	                    	if(data.length>0){
	                    		if(confirm("선택한 엑셀파일을 업로드하시겠습니까?")){
                                    //로딩바생성.
                                    loadingOpen();
                                    
                                    return true;
                                }else{
                                    return false;
                                }
	                    	}else{
	                    		alert("업로드할 엑셀 파일을 선택해주세요.");
                                return false;
	                    	}
	                    	/*
	                        if(data.length>0){
	                        	var fileValue = data[0].value;
	                        	if(fileValue && fileValue.name != ""){
	                        		if( fileValue.name.toLowerCase().indexOf(".xls")>-1 || fileValue.name.toLowerCase().indexOf(".xlsx")>-1){
	                        			if(confirm("선택한 엑셀파일을 업로드하시겠습니까?")){
	                        				//로딩바생성.
	                                        loadingOpen();
	                                        
	                                        return true;
	                        			}else{
	                        				return false;
	                        			}
	                                    
	                        		}else{
	                        			alert("엑셀 파일만 선택해주세요.");
	                                    return false;
	                        		}
	                        	}else{
	                        		alert("업로드할 엑셀 파일을 선택해주세요.");
	                        		return false;
	                        	}
	                        }else{
	                        	alert("업로드할 엑셀 파일을 선택해주세요.");
	                        	return false;
	                        }
	                    	*/
	                    },
	                    success: function(reponseText, statusText){
	                        //로딩바 제거.
	                        loadingClose();

	                    	if(reponseText){
	                    		 //결과값을 json으로 파싱
                                var myObj = JSON.parse(reponseText);
	                    		alert("-사용자 업로드 결과-\n"+myObj.statement);
	                    	}else{
	                    		//작업 실패.
	                    		alert("작업이 실패하였습니다.");
	                    	}
	                        
	                        //그리드 다시 읽고,
	                        $("#grid").data("kendoGrid").dataSource.read();
	                        
	                        //업로드 객체 초기화
	                        $("#userUploadFile").parents(".k-upload").find(".k-upload-files").remove();
	                        $("input[name=userUploadFile]").each(function(e){
	                        	var inputFile =  $("input[name=userUploadFile]")[e];
	                        	if($(inputFile)){
	                        		if($(inputFile).id != "userUploadFile"){
	                        			//프로그래밍한 input file이 아닌 자동  추가된 input file은 제거
	                        			$(inputFile).remove();  
	                        		}
	                        	}
	                        });
	                        
	                        //팝업 닫기.
	                        $("#excel-upload-window").data("kendoWindow").close();
	                    },
	                    error: function(e){
	                        alert("ERROR:"+e);
	                    }
	                });
	            });
	            
	            $("#userUploadFile").kendoUpload({
	                multiple : false,
	                showFileList : true,
	                localization : {
	                    select : '파일 선택'
	                },
	                async : {
	                    autoUpload : false
	                }
	            });
	        }  	        
	
// 	        //엑셀 업&다운로드는 추후 검토..
// 	        $("#excelUploadBtn").click(function() {
// 	        	$('#excel-upload-window').data("kendoWindow").center();
// 	            $("#excel-upload-window").data("kendoWindow").open();
// 	        });
	        

	        

	        //등록 버튼 클릭 이벤트
	        $("#newBtn").click(function() {
	        	
	        	
	        	//$("lastdiv").scrollTop(0);
	        	

	            $("#splitter").data("kendoSplitter").expand("#detail_pane");

	            //$("#delBtn").hide();
	            
	            $("#findBt").show();
		        $("#delBt").show();
	        	$("#findBt").focus();
	            
	            kendo.bind($(".tabular"), null);
	            
	            //상시학습유형 초기화
	            dataSource_alwStdCd2.filter({ field: "VALUE", operator: "eq", value: "" });
                dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
	            
	            $('input:radio[id=deptDesignationYn]:input[value=N]').attr("checked", true);//부처지정여부
	            $('input:radio[id=mjrRlntDivCdYn]:input[value=N]').attr("checked", true);//인재구분
	            $('input:radio[id=useFlag]:input[value=N]').attr("checked", true);//사용여부
	            $('input:radio[id=passYn]:input[value=N]').attr("checked", true);//사용여부
	            

	            $("#cancel-btn").click(function() {
                    kendo.bind($(".tabular"), null);

                    // 상세영역 비활성화
                    $("#splitter").data("kendoSplitter").collapse("#detail_pane");
                });
	            
	            //교육자료 첨부파일 그리드 초기화
	            $("#my-file-gird").data('kendoGrid').dataSource.data([]);
	            //첨부파일 임시objectid 세팅(랜덤 정수로 ...)
	            var ranval = Math.floor(Math.random()*1000000000); 
	            $("#objectId").val(ranval);

	            fn_deptDesignation();

	        });
	        
            //학습유형 데이터소스
            dataSource_training = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA03", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});

            //지정학습구분 데이터소스
            dataSource_deptDesignation = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA04", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});

            //기관성과평가필수교육과정 데이터소스
            dataSource_perfAsseSbjCd = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA11", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
            
            //업무시간구분 데이터소스
            dataSource_officeTimeCd = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA07", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
            
            //교육기관구분 데이터소스
            dataSource_eduinsDivCd = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA05", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
          
            //상시학습유형 데이터소스
            dataSource_alwStdCd1 = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/alw-std-type.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  LEVEL : "1" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" },
                            P_VALUE : {type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
            
            dataSource_alwStdCd2 = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/alw-std-type.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  LEVEL : "2" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" },
                            P_VALUE : {type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
            dataSource_alwStdCd = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/alw-std-type.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  LEVEL : "3" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" },
                            P_VALUE : {type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});

            dataSource_alwStdCd2.fetch(function(){
            	dataSource_alwStdCd2.filter({ field: "VALUE", operator: "eq", value: "" });
            	dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
            });
            dataSource_alwStdCd.fetch(function(){
                dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
            }); 
            
            //학습유형 
            var trainingCode = $("#TRAINING_CODE").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_training,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
            
            //지정학습구분
            var deptDesignationCd = $("#deptDesignationCd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_deptDesignation,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
            
            //기관성과평가필수교육과정
            var perfAsseSbjCd = $("#perfAsseSbjCd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_perfAsseSbjCd,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
            
            //업무시간구분
            var officeTimeCd = $("#officeTimeCd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_officeTimeCd,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");

            //교육기관구분
            var eduinsDivCd = $("#eduinsDivCd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_eduinsDivCd,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");

            
            //상시학습종류
             var alwStdCd1 = $("#alwStdCd1").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_alwStdCd1,
                 filter: "contains",
                 suggest: true,
                 change:function(){
                	 if(alwStdCd1.value()==""){
                		 alwStdCd2.value("");
                		 alwStdCd.value("");

                		 alwStdCd2.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                		 alwStdCd.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                	 }else{
                		 alwStdCd2.dataSource.filter({
               				 logic: "or",
               			        filters: [
               			               { field: "P_VALUE", operator: "contains", value:  alwStdCd1.value()},
               			               { field: "VALUE", operator: "eq", value: "" }
               			       ]
                		 });
                         alwStdCd.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                	 }
                 }
             }).data("kendoDropDownList");
            
            var alwStdCd2 = $("#alwStdCd2").kendoDropDownList({
                dataTextField: "TEXT",
                dataValueField: "VALUE",
                dataSource: dataSource_alwStdCd2,
                filter: "contains",
                suggest: true,
                change:function(){
                    if(alwStdCd2.value()==""){
                        alwStdCd.value("");

                        alwStdCd.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                    }else{
                        alwStdCd.dataSource.filter({
                            logic: "or",
                               filters: [
                                      { field: "P_VALUE", operator: "contains", value:  alwStdCd2.value()},
                                      { field: "VALUE", operator: "eq", value: "" }
                              ]
                        });
                    }
                }
            }).data("kendoDropDownList");
            
            var alwStdCd = $("#alwStdCd").kendoDropDownList({
                dataTextField: "TEXT",
                dataValueField: "VALUE",
                dataSource: dataSource_alwStdCd,
                filter: "contains",
                suggest: true
            }).data("kendoDropDownList");
            
            //교육시작일
            var eduSdate = $("#EDU_ST_DT").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {                    
                    var startDate = eduSdate.value(),
                    endDate = eduEdate.value();

                    if (startDate) {
                        startDate = new Date(startDate);
                        startDate.setDate(startDate.getDate());
                        eduEdate.min(startDate);
	                }else if(!eduEdate.value()){   // You said both
	                	eduEdate.min(new Date(1900, 0, 1)); // Setting defaults
	                	eduEdate.max(new Date(2099, 11, 31));
	                   this.min(new Date(1900, 0, 1));
	                   this.max(new Date(2099, 11, 31));
	                }
                 }
            }).data("kendoDatePicker");

            //교육종료일
            var eduEdate = $("#EDU_ED_DT").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {                    
                    var endDate = eduEdate.value(),
                     startDate = eduSdate.value();
             
                    if (endDate) {
                        endDate = new Date(endDate);
                        endDate.setDate(endDate.getDate());
                        eduSdate.max(endDate);
                    }else if(!eduSdate.value()){
                    	eduSdate.min(new Date(1900, 0, 1)); // Setting defaults
                    	eduSdate.max(new Date(2099, 11, 31));
                       this.min(new Date(1900, 0, 1));
                       this.max(new Date(2099, 11, 31));
	                }
                }
            }).data("kendoDatePicker");     
            
            //해당년도
            var yyyy = $("#YYYY").kendoNumericTextBox({
                format: "",
                min: 2000,
                max: 2100,
                step: 1
            }).data("kendoNumericTextBox");
            //개설년도 초기값 설정.
            //yyyy.value(now.getFullYear());
            
			
            // 저장버튼 클릭 시.
            $("#save-btn").bind('click', function() {
            	
            	// 인재명
                if($('#name').val() == ""){
                	alert("인재명을 입력해주세요.");
                    $("#name").focus();
                    return false;
                }
            	
            	// 인재구분
            	if ($(':radio[id="mjrRlntDivCdYn"]:checked').val() == "") {
               		alert("인재구분을 선택해주세요.");
                    return false;
                }
            	
            	// 성적
            	if($('#RESULT').val() == ""){
                	alert("성적을 입력해주세요.");
                    $("#RESULT").focus();
                    return false;
                }
            	
            	// 등수
            	if($('#RANKING').val() == ""){
                	alert("등수를 입력해주세요.");
                    $("#RANKING").focus();
                    return false;
                }
            	
				// 학습유형            	
            	if(trainingCode.select()==0){
                	alert("학습유형을 선택해주세요");
                	return false;
                }
            	
            	// 과정명
                if ($("#SBJ_NM").val() == "") {
                    alert("과정명을 입력해주세요.");
                    $("#SBJ_NM").focus();
                    return false;
                }
            	
            	// 실적시간
            	if ( perfTimeH.value() == null && perfTimeM.value() == null ) {
                    alert("실적시간을 입력해주세요.");
                    perfTimeH.focus();
                    return false;
                }
            	
            	// 인정시간
                if ( recogTimeH.value() == null && recogTimeM.value() == null ) {
                    alert("인정시간을 입력해주세요.");
                    recogTimeH.focus();
                    return false;
                }
            	
            	// 상시학습종류
                if((alwStdCd1.select()>0 || alwStdCd2.select()>0) && alwStdCd.select()==0){
                	alert("상시학습종류를 3차까지 선택해주세요.");
                	if(alwStdCd2.select()==0){
                		alwStdCd2.focus();
                	}else{
                		alwStdCd.focus();
                	}
                	return false;
                }
            	
            	// 부처지정 및 지정학습구분
                if ($(':radio[id="deptDesignationYn"]:checked').val() == "Y") {
                	if(deptDesignationCd.select()==0){
                		alert("지정학습구분을 선택해주세요.");
                		deptDesignationCd.focus();
                        return false;
                	}
                }
                
                if (confirm("핵심인재를 등록하시겠습니까?")) {
                	//로딩바생성.
                	loadingOpen();
                	
                	var _MJR_TLNT_DIV_CD = "";
                	
                	// 인재구분
                	if ($(':radio[id="mjrRlntDivCdYn"]:checked').val() == "Y") {
                		_MJR_TLNT_DIV_CD = "1";
                	}else{
                		_MJR_TLNT_DIV_CD = "2";
                	}
            
                    $.ajax({
                        type : 'POST',          
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/cdp/save-mjr-tlnt-userInfo.do?output=json",
                        data : {
                        	//item: kendo.stringify( params ), 
                        	MJR_TLNT_SEQ : $("#dtl-mjrTlntSeq").val(),
                        	USERID : $("#userid").val(),
                        	NAME : $('#name').val(),
                        	MJR_TLNT_DIV_CD : _MJR_TLNT_DIV_CD, //인재구분(Y:1 N:2)
                        	RESULT : $("#RESULT").val(), // 성적
                        	RANKING : $("#RANKING").val(), // 등수
                        	TRAINING_CODE : removeNullStr(trainingCode.value()), // 학습유형
                            SUBJECT_NAME : $("#SBJ_NM").val(), // 과정명
                            PERF_TIME_H : perfTimeH.value(), // 실적시간(H)
                            PERF_TIME_M : perfTimeM.value(), // 실적시간(M)
                            RECOG_TIME_H : recogTimeH.value(), // 인정시간(H)
                            RECOG_TIME_M : recogTimeM.value(), // 인정시간(M)
                            CONTENTS : $("#CONTENTS").val(), // 내용
                            ALW_STD_CD : removeNullStr(alwStdCd.value()), //상시학습종류
                            DEPT_DESIGNATION_YN : $(':radio[id="deptDesignationYn"]:checked').val(), // 부처지정
                            DEPT_DESIGNATION_CD : removeNullStr(deptDesignationCd.value()), // 지정학습구분
                            PERF_ASSE_SBJ_CD : removeNullStr(perfAsseSbjCd.value()), // 기관성과평가
                            OFFICETIME_CD : removeNullStr(officeTimeCd.value()), // 업무시간구분
                            EDUINS_DIV_CD : removeNullStr(eduinsDivCd.value()), // 교육기관구분
                            INSTITUTE_NM : $("#INSTITUTE_NM").val(), // 교육기관
                            PASS_YN : $(':radio[id="passYn"]:checked').val(), // 통과여부
                            USEFLAG : $(':radio[id="useFlag"]:checked').val(), // 사용여부
                            EDU_ST_DT : $("#EDU_ST_DT").val(),
                            EDU_ED_DT : $("#EDU_ED_DT").val(),
                            YYYY : yyyy.value(),
                            OBJECTID : $("#objectId").val()
                        },
                        complete : function( response ){
                        	//로딩바 제거.
                            loadingClose();
                            
                            var obj  = eval("(" + response.responseText + ")");
                            if(!obj.error){
                            	if(obj.saveCount > 0){         
                                    
                                    // 상세영역 활성화
                                    $("#splitter").data("kendoSplitter").expand("#detail_pane");
                                
                                    // 과정목록 read
                                    $("#grid").data("kendoGrid").dataSource.read();
                                
                                    kendo.bind( $(".tabular"),  null );
                                
                                    // 상세영역 비활성화
                                    $("#splitter").data("kendoSplitter").collapse("#detail_pane");
                                    
                                    alert("저장되었습니다.");  
                                }else{
                                    alert("저장에 실패 하였습니다. 교육운영자에게 문의해주세요.");
                                }   
                            }else{
                            	alert("ERROR: "+obj.error.message);
                            }                       
                        },
                        error : function(xhr, ajaxOptions, thrownError) { 
                            //로딩바 제거.
                            loadingClose();
                            
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

            
            // dtl cancel btn add click event
            $("#cancel-btn").click(function() {
                kendo.bind($(".tabular"), null);

                // 상세영역 비활성화
                $("#splitter").data("kendoSplitter").collapse("#detail_pane");
                
            });

            var recogTimeH = $("#RECOG_TIME_H").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 999,
                step: 1
            }).data("kendoNumericTextBox")
            
            var recogTimeM = $("#RECOG_TIME_M").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 59,
                step: 1
            }).data("kendoNumericTextBox")
            
            var perfTimeH = $("#PERF_TIME_H").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 999,
                step: 1
            }).data("kendoNumericTextBox")
            
            var perfTimeM = $("#PERF_TIME_M").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 59,
                step: 1
            }).data("kendoNumericTextBox")
            
            //var recogTimeM = $("#RECOG_TIME_M").kendoDropDownList().data("kendoDropDownList");

            $("input[name='deptDesignationYn']").click(function(){
                fn_deptDesignation();
            });
            
          //var recogTimeM = $("#RECOG_TIME_M").kendoDropDownList().data("kendoDropDownList");

            //교육자료 첨부파일 구성
            /*
            @@@ 첨부파일 세팅 방법 @@@
            object_type = 1 (고정된 값 ==> 공통코드에서 확인해야함...)
            object_id 값은 해당 업무 테이블의 pk가 unique하다면 해당컬럼의 값으로 처리해도됨. 그렇지 않다면 pk의 조합으로 처리해야함.
            
            object_id = 회사번호+실시번호+평가대상자+지표번호
               예 ) 회사번호 1, 실시번호 7, 평가대상자 1500, 지표번호 10 => 17150010
               
            */
            var objectType = 7 ;
            
            if( !$("#my-file-gird").data('kendoGrid') ) {
                $("#my-file-gird").kendoGrid({
                    dataSource: {
                        type: 'json',
                        transport: {
                            read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json', type: 'POST' },      
                            destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
                            parameterMap: function (options, operation){
                                if (operation != "read" && options) {                                                                                                                           
                                    return { objectType: objectType, objectId:$("#objectId").val(), attachmentId :options.attachmentId };                                                                   
                                }else{
                                     return { objectType: objectType, objectId:$("#objectId").val(), startIndex: options.skip, pageSize: options.pageSize };
                                }
                            }
                        },
                        schema: {
                            model: Attachment,
                            data : "targetAttachments"
                        },
                    },
                    pageable: false,
                    height: 90,
                    selectable: false,
                    columns: [
                        { 
                            field: "name", 
                            title: "파일명",  
                            width: "320px",
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:left"} ,
                            template: '#= name #' 
                       },
                       { 
                           field: "size",
                           title: "크기(byte)", 
                           format: "{0:##,###}", 
                           width: "100px" 
                       },
                       { 
                           width: "160px" , 
                           template: function(dataItem){
                               return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>'+
                               '<button style="width:60px; min-width: 50px;" class="k-button" onclick="deleteFile('+dataItem.attachmentId+')">삭제</button>';
                           } 
                       }
                    ]
                });
            }else{
                handleCallbackUploadResult();
            }
            
            var ver = getInternetExplorerVersion();
            if( ( ver > -1) && ( ver < 10 ) ){
                if( $('#my-file-upload').text().length == 0  ) {
                    var template = kendo.template('<button id="openUploadWindow" name="openUploadWindow">파일 업로드 하기</button>');
                    $('#my-file-upload').html(template({}));
                    $('#openUploadWindow').kendoButton({
                        click: function(e){
                            var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#objectId").val() +"&fileType=doc" ;
                            myWindow = window.open(windowUrl, "_blank", "toolbar=no, scrollbars=yes, resizable=yes, top=500, left=500, width=405, height=250");
                        }                           
                    });
                    $('button.custom-button-delete').click( function(e){
                        alert ("delete");
                    });
                    $("#my-file-upload").removeClass('hide');
                }                   
            }else{                  
                if( $('#my-file-upload').text().length == 0  ) {
                    var template = kendo.template($("#fileupload-template").html());
                    $('#my-file-upload').html(template({}));
                }                   
                if( !$('#upload-file').data('kendoUpload') ){                       
                    $("#upload-file").kendoUpload({
                        showFileList : false,
                        width : 500,
                        multiple : false,
                        localization:{ select : '파일 선택' , statusUploaded: "완료.", statusFailed : "업로드 실패." },
                        async: {
                            saveUrl:  '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?output=json',                               
                            autoUpload: true
                        },
                        upload: function (e) {                                       
                            e.data = {objectType: objectType, objectId:$("#objectId").val()};                                                                                                                    
                        },
                        error : function (e){                           
                        },
                        success : function(e){                          
                            handleCallbackUploadResult();
                        },
                        select: function(e){
                            $.each(e.files, function(index, value) {
                                if(value.size>10485760){
                                    e.preventDefault();
                                    alert("파일 사이즈는 10M로 제한되어 있습니다.");
                                }/*else{
                                    if(value.extension != ".JPG" && value.extension != ".jpg" 
                                              && value.extension != ".GIF" && value.extension != ".gif" 
                                                  && value.extension != ".BMP" && value.extension != ".bmp"
                                                      && value.extension != ".PNG" && value.extension != ".png") {
                                        e.preventDefault();
                                        alert("이미지 파일만 선택해주세요.");
                                    }
                                }*/
                            });
                        }
                        
                    });
                    $("#my-file-upload").removeClass('hide');
                }
            }            
            
            
                   
            
            
          //브라우저 resize 이벤트 dispatch..
            $(window).resize();
            
            
        }
    } ]);
</script>

<script type="text/javascript">

	        
    //부처지정 여부가 예/아니오에 따라 지정학습구분 컨트롤..
    function fn_deptDesignation(){
        if($(':radio[id="deptDesignationYn"]:checked').val()=="Y"){
            $("#deptDesignationCd").data("kendoDropDownList").enable();
        }else{
        	$("#deptDesignationCd").data("kendoDropDownList").select(0);
            $("#deptDesignationCd").data("kendoDropDownList").enable(false);
        }
    }
    
    function mentoNmDel(){
    	$("#name").val("");
    }
    
    
		
	//인재 추가
	function fn_empInsert(userId,mod){
		var array;
		array = $('#findEmp').data('kendoGrid').dataSource.data();
		var res = $.grep(array, function (e) {
			return e.USERID == userId;
		});
		
		$("#name").val(res[0].NAME);
		$("#userid").val(res[0].USERID);
		
		$("#pop04").data("kendoWindow").close();

	}	

	// 상세보기.
	function fn_detailView(seq){
	
	    var grid = $("#grid").data("kendoGrid");
	    var data = grid.dataSource.data();
	    
	    var res = $.grep(data, function (e) {
	        return e.MJR_TLNT_SEQ == seq;
	    });
	
	    var selectedCell = res[0];
	    
		$("#dtl-mjrTlntSeq").val(selectedCell.MJR_TLNT_SEQ);
		
		$("#findBt").hide();
		$("#delBt").hide();
		
		$("#name").attr("readonly","readonly");
		
	
		// 상세영역 활성화
		$("#splitter").data("kendoSplitter").expand("#detail_pane");
		
	    //로딩바 생성.
	    loadingOpen();
	    
	    $.ajax({
            type : 'POST',
            dataType : 'json',
            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/cdp/get_core_person_manage_user_detail.do?output=json",
            data : {
                mjrTlntSeq : selectedCell.MJR_TLNT_SEQ
            },
            success : function(response) {

                //로딩바 제거.
                loadingClose();
                
                if (response.items != null) {
                	
                    var selectRow = new Object();
                    $.each(response.items, function(idx, item) {
                        $.each(item,function(key,val){
                            selectRow[key] = val;
                        });
                    });
                    
                  	$('input:radio[id=mjrRlntDivCdYn]:input[value='+selectRow.MJR_TLNT_DIV_YN+']').attr("checked", true); // 핵심인재구분
                    $('input:radio[id=deptDesignationYn]:input[value='+selectRow.DEPT_DESIGNATION_YN+']').attr("checked", true); // 부처지정
                    $('input:radio[id=useFlag]:input[value='+selectRow.USEFLAG+']').attr("checked", true); // 사용여부
                    $('input:radio[id=passYn]:input[value='+selectRow.PASS_YN+']').attr("checked", true); // 통과여부
                    
                    
                    //상시학습유형 컨트롤
                    dataSource_alwStdCd2.filter({
                             logic: "or",
                                filters: [
                                       { field: "P_VALUE", operator: "eq", value:  selectRow.ALW_STD_CD1},
                                       { field: "VALUE", operator: "eq", value: "" }
                               ]
                         });
                    dataSource_alwStdCd.filter({ 
                        logic: "or",
                        filters: [
                               { field: "P_VALUE", operator: "eq", value:  selectRow.ALW_STD_CD2},
                               { field: "VALUE", operator: "eq", value: "" }
                        ] 
                        
                    });
                    
                    //상세데이터 바인딩..
                    kendo.bind($("#tabular"), selectRow);
                    
                  //첨부파일 리로드..
                    $("#objectId").val(selectedCell.MJR_TLNT_SEQ);
                    handleCallbackUploadResult();
                    
                    //부처지정여부 컨트롤.
                    fn_deptDesignation();
                    
                }
            },
            error : function(xhr, ajaxOptions, thrownError) { 
                //로딩바 제거.
                loadingClose();
                
                if(xhr.status==403){
                    alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                    sessionout();
                }else{
                    alert('xrs.status = ' + xhr.status + '\n' + 
                            'thrown error = ' + thrownError + '\n' +
                            'xhr.statusText = '  + xhr.statusText );
                }
            }
        });
        
		// template에서 호출된 함수에 대한 이벤트 종료 처리.
		if (event.preventDefault) {
			event.preventDefault();
		} else {
			event.returnValue = false;
		}

	}
	
    // 첨부파일 함수 시작 =================================================================================================
    function handleCallbackUploadResult(){
        $("#my-file-gird").data('kendoGrid').dataSource.read();             
    }

    //첨부파일 삭제.
    function deleteFile (attachmentId){
        if(confirm("첨부파일을 삭제 하시겠습니까?")){

            //로딩바 생성.
            loadingOpen();
            
            $.ajax({
                type : 'POST',
                url : '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json' ,
                data:{ attachmentId : attachmentId },
                success : function(response){
                    //로딩바 제거.
                    loadingClose();
                	
                    handleCallbackUploadResult();
                },
                error: function( xhr, ajaxOptions, thrownError){
                    //로딩바 제거.
                    loadingClose();
                    
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
	
	//엑셀다운로드
	function excelDownload(button){
		//alert($("#searchYyyy").val());
		
	   button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/cdp/core_person_manage_list_excel.do?SELECTED_YEAR="+$("#searchYyyy").val();
	}	
	
	function excelUpload(button){
		$('#excel-upload-window').data("kendoWindow").center();
        $("#excel-upload-window").data("kendoWindow").open();
	}


</script>

</head>
<body>


    <div id="excel-upload-window" style="display:none; width:340px;">
        <form id="excelForm" name="excelForm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/upload_core_person_list_excel.do?output=json" enctype="multipart/form-data" >
        ※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
           <div>
               <input name="userUploadFile" id="userUploadFile" type="file" />
               </br>
               <div style="text-align: right;">
                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/core_person_manage_upload_template.xls" class="k-button" >템플릿다운로드</a>
                    <input type="submit" value="실행" class="k-button" id="uploadBtn"/>
               </div>
           </div>
       </form>
   </div>
   
    <!-- START MAIN CONTENT  -->
    
        <div id="content">
            <div class="cont_body">
                <div class="title mt30">핵심인재관리</div>
                
                <div class="table_tin01">
                    <ul>
	                    <li style="position:relative;">
	                        <label for="YYYY" >교육시작일</label> : 
	                        <select id="searchYyyy"></select>
                			<button id="yyyySearchBtn" class="k-button">조회</button>
                            
                            <a class="k-button" style="position:absolute;right:290px;" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp;
	                        <a class="k-button" style="position:absolute;right:205px;" onclick="excelUpload(this)" >엑셀 업로드</a>&nbsp;
	                        <a class="k-button" style="position:absolute;right:110px;" onclick="excelDownload(this)" >엑셀 다운로드</a>&nbsp;
	                        <button id="newBtn" class="k-button" style="position:absolute;right:50px;" ><span class="k-icon k-i-plus"></span>등록</button>
	                    </li>
	                </ul>
	            </div>                
                
                <div class="table_zone">
                    <div class="table_list">
                        <div id="splitter" style="width:100%; height: 100%; border:none;">
                            <div id="list_pane">
                                <div id="grid" ></div>
                            </div>
                            <div id="detail_pane">
                                <div id="details">

                                </div>
	                       </div>
	                  	</div>
                    </div>
                </div>
            </div>
        </div>

                                       
    	<script type="text/x-kendo-template"  id="template"> 

			<div>
				<div>
					<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
				        <tr>
							<td colspan="2" style="font-size:16px;">
				            	<strong>&nbsp; 핵심인재등록 </strong>
							</td>
						</tr>
						<tr>
							<td class="subject">
								<label class="right inline required">
									<input type="hidden" id="dtl-mjrTlntSeq" data-bind="value:MJR_TLNT_SEQ" />
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 인재명 
									<span style="color:red">*</span>
								</label>
							</td>
							<td class="subject">
								<input type="hidden" name="objectId" id="objectId"/>
								<input type="hidden" id="userid" data-bind="value:USERID"/>
								<input type="text" id="name" data-bind="value:NAME" class="k-textbox inp_style02" disabled style="width:270px;margin-right:1px;" title="인재명"/>
								<button id="findBt"  class="k-button wid60 ie7_left" onclick="empPop('');">찾기</button>
								<button id="delBt"  onclick="mentoNmDel()" class="k-button  wid60">삭제</button>
							</td>
						</tr>
						
						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 인재구분 
									<span style="color:red">*</span>
								</label>
							</td>
							<td class="subject">
								<input type="radio" name="mjrRlntDivCdYn"  id="mjrRlntDivCdYn"   value="Y" /> 기본</input>
								<span style="padding-left:40px"><input type="radio" name="mjrRlntDivCdYn" id="mjrRlntDivCdYn"  value="N"/></span> 심화</input> 
							</td>
						</tr>
						
						<tr>
							<td class="subject" style="width:100px;">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 성적 
									<span style="color:red">*</span>
								</label>
							</td>
							<td class="subject">
								<input type="hidden" id="dtl-result" data-bind="value:RESULT" />
								<input class="k-textbox" id="RESULT" data-bind="value:RESULT"  style="width:30%;" onKeyUp="chkNull(this);"/>
							</td>                
						</tr>
						
						<tr>
							<td class="subject" style="width:100px;">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 등수 
									<span style="color:red">*</span>
								</label>
							</td>
							<td class="subject">
								<input type="hidden" id="dtl-ranking" data-bind="value:RANKING" />
								<input class="k-textbox" id="RANKING" data-bind="value:RANKING"  style="width:30%;" onKeyUp="chkNull(this);"/>
							</td>                
						</tr>	

						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 학습유형 
									<span style="color:red">*</span>
								</label>
							</td>
							<td class="subject">
								<select id="TRAINING_CODE" data-bind="value:TRAINING_CODE" style="width:200px;" ></select>
							</td>
						</tr>	

						<tr>
							<td class="subject" style="width:100px;">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 과 정 명 
									<span style="color:red">*</span>
								</label>
							</td>
							<td class="subject">
								<input class="k-textbox" id="SBJ_NM" data-bind="value:SBJ_NM"  style="width:100%;" onKeyUp="chkNull(this);"/>
							</td>
						</tr>		

            			<tr>
                			<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기간 
								</label>
							</td>
                			<td class="subject">
                    			<input id="EDU_ST_DT" data-bind="value:EDU_ST_DT" style="width:120px;" /> ~
                    			<input id="EDU_ED_DT" data-bind="value:EDU_ED_DT" style="width:120px;" /> &nbsp &nbsp 해당년도 : &nbsp
								<input id="YYYY" data-bind="value:YYYY" style="width:100px;" /> 	
                			</td>
            			</tr>
						
						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 실적시간 
									<span style="color:red">*</span>
								</label>
							</td>
							<td class="subject">
								<input id="PERF_TIME_H" data-bind="value:PERF_TIME_H" style="width:80px;" />시간
								<input id="PERF_TIME_M" data-bind="value:PERF_TIME_M" style="width:80px;" />
								<!--<select id="RECOG_TIME_M" data-bind="value:RECOG_TIME_M" style="width:60px; text-align:center;" >
									<option value="0">0</option>
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="30">30</option>
									<option value="40">40</option>
									<option value="50">50</option>
									<option value="60">60</option>
								</select>-->분
							</td>
						</tr>	

						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 인정시간 
									<span style="color:red">*</span>
								</label>
							</td>
							<td class="subject">
								<input id="RECOG_TIME_H" data-bind="value:RECOG_TIME_H" style="width:80px;" />시간
								<input id="RECOG_TIME_M" data-bind="value:RECOG_TIME_M" style="width:80px;" />
								<!--<select id="RECOG_TIME_M" data-bind="value:RECOG_TIME_M" style="width:60px; text-align:center;" >
									<option value="0">0</option>
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="30">30</option>
									<option value="40">40</option>
									<option value="50">50</option>
									<option value="60">60</option>
								</select>-->분
							</td>
						</tr>			
						
						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 내용
								</label>
							</td>
							<td class="subject">
								<textarea class="k-textbox" id="CONTENTS" data-bind="value:CONTENTS" rows="5"  style="width:100%;"></textarea>
							</td>
						</tr>           

						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 상시학습종류
								</label>
							</td>
							<td class="subject">
								<select id="alwStdCd1" data-bind="value:ALW_STD_CD1" style="width:200px;" ></select><br>
								<select id="alwStdCd2" data-bind="value:ALW_STD_CD2" style="width:200px;" ></select><br>
								<select id="alwStdCd" data-bind="value:ALW_STD_CD" style="width:200px;" ></select>
							</td>
						</tr>
						
						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 부처지정 
									<span style="color:red">*</span>
								</label>
							</td>
							<td class="subject">
								<input type="radio" name="deptDesignationYn"  id="deptDesignationYn"   value="Y" /> 예</input>
								<span style="padding-left:40px"><input type="radio" name="deptDesignationYn" id="deptDesignationYn"  value="N"/></span> 아니오</input> <span style="padding-left:40px">※ 부처지정학습일 경우 "예"를 선택합니다.</span></td>
							</td>
						</tr>	

						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 지정학습구분
								</label>
							</td>
							<td class="subject">
								<select id="deptDesignationCd" data-bind="value:DEPT_DESIGNATION_CD" style="width:200px;" ></select>
							</td>
						</tr>			
						
						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 기관성과평가
								</label>
							</td>
							<td class="subject">
								<select id="perfAsseSbjCd" data-bind="value:PERF_ASSE_SBJ_CD" style="width:200px;" ></select>
							</td>
						</tr>
						
						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 업무시간구분
								</label>
							</td>
							<td class="subject">
								<select id="officeTimeCd" data-bind="value:OFFICETIME_CD" style="width:200px;" ></select>
							</td>
						</tr>
						
						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기관구분
								</label>
							</td>
							<td class="subject">
								<select id="eduinsDivCd" data-bind="value:EDUINS_DIV_CD" style="width:200px;" ></select>
							</td>
						</tr>
						
						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기관 
								</label>
							</td>
							<td class="subject">
								<input class="k-textbox" id="INSTITUTE_NM" data-bind="value:INSTITUTE_NM" style="width:50%;" onKeyUp="chkNull(this);"/>
							</td>
						</tr>

						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 통과여부 
								</label>
							</td>
							<td class="subject">
								<input type="radio" name="passYn"  id="passYn"   value="Y" /> 통과</input>
								<span style="padding-left:40px"><input type="radio" name="passYn" id="passYn"  value="N"/></span> 탈락</input> 
							</td>
						</tr>

						<tr>
							<td class="subject">
								<label class="right inline required">
									<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부 
								</label>
							</td>
							<td class="subject">
								<input type="radio" name="useFlag"  id="useFlag"   value="Y" /> 사용</input>
								<span style="padding-left:40px"><input type="radio" name="useFlag" id="useFlag"  value="N"/></span> 미사용</input> 
							</td>
						</tr>
					</table>
				</div>
			</div>

			<div style="overflow-y:auto;">
            	<!-- 증빙자료 -->
            	<div id="my-file-upload" class="hide"></div>
            	<div id="my-file-gird" style="height:80px; min-height: 150px; width:99%;" ></div>
            </div>

            <div style="text-align:right;margin-top:10px">
            	<button id="save-btn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>
                &nbsp;
                <button id="cancel-btn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>&nbsp;&nbsp;
            </div>
	</script>
	
    <!-- 교육자료 첨부파일 template -->
    <script type="text/x-kendo-tmpl" id="fileupload-template">
        <input name="upload-file" id="upload-file" type="file"/>
    </script>	
	
<%@ include file="/includes/jsp/user/common/findEmployeePopup.jsp"  %>   
 
</body>
</html>