<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page pageEncoding="UTF-8" isErrorPage="true"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<html decorator="operatorSubpage">
<head>
<title>과정관리</title>
<script type="text/javascript">

var dataSource_training ;
//var dataSource_deptDesignation;
var dataSource_perfAsseSbjCd;
var dataSource_officeTimeCd;
var dataSource_eduinsDivCd;
var dataSource_alwStdCd1 ;
var dataSource_alwStdCd2 ;
var dataSource_alwStdCd ;

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
          
          //탭 사이즈 재조정
                
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
                
                var expandContentDivs = function(divs) {
	                divs.height(gridElement.innerHeight()-90);
	            };
	            var resizeAll = function() {
	                expandContentDivs($("#tabstrip").children(".k-content")); 
	            };
                
	            resizeAll();
	            
	            //탭내부의 그리드 리사이즈
                //1. 역량매핑 그리드
	            var compElement = $("#sbjctMapGrid");
	            compElement.height($("#tabstrip").children(".k-content").height()-2);
                
                compdataArea = compElement.find(".k-grid-content"),
                compgridHeight = compElement.innerHeight(),
                compdataArea.height(compgridHeight - 55);
                //2. 수료기준 그리드
                var cmpltElement = $("#cmpltStndGrid");
                cmpltElement.height($("#tabstrip").children(".k-content").height()-182);
                
                cmpltdataArea = cmpltElement.find(".k-grid-content"),
                cmpltgridHeight = cmpltElement.innerHeight(),
                cmpltdataArea.height(cmpltgridHeight - 175);

            });
            /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
          
            //로딩바 선언..
            loadingDefine();
            
            
            
            // area splitter
            $("#splitter").kendoSplitter({
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

            // show detail 
            $('#details').show().html(kendo.template($('#template').html()));
            $("#input_nm").enable(false);
	        //교육과정 목록 그리드 생성
	        $("#grid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-list.do?output=json",
	                        type : "POST"
	                    },
	                    parameterMap : function(options, operation) {
                            var sortField = "";
                            var sortDir = "";
                            if (options.sort && options.sort.length>0) {
                                sortField = options.sort[0].field;
                                sortDir = options.sort[0].dir;
                            }
                            return { 
                                startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter)
                            };
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        id : "SUBJECT_NUM",
	                        fields : {
	                            SUBJECT_NUM : {type : "number"},
	                            SUBJECT_NAME : {type : "string"},
	                            TRAINING_CODE : {type : "string"},
	                            TRAINING_STRING : {type : "string"},
	                            DEPT_DESIGNATION_YN : {type : "string"},
	                            //DEPT_DESIGNATION_CD : {type : "string"},
	                            //DEPT_DESIGNATION_STRING : {type : "string"},
	                            ALW_STD_NM1 : {type : "string"},
	                            ALW_STD_NM2 : {type : "string"},
	                            ALW_STD_NM : {type : "string"},
	                            INSTITUTE_NAME : {type : "string"},
	                            EDU_HOUR_H : {type : "number"},
	                            EDU_HOUR_M : {type : "number"},
	                            RECOG_TIME_H : {type : "number"},
	                            RECOG_TIME_M : {type : "number"}
	                        }
	                    }
	                },
	                pageSize : 30,
	                serverPaging : true,
	                serverFiltering : true,
	                serverSorting : true
	            },
	            columns : [
						{
							field : "SUBJECT_NUM_NUMB",
						    title : "과정번호",
						    width : "110px",
						    headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
						    attributes : {"class" : "table-cell",style : "text-align:center"}
						},{
	                        field : "TRAINING_STRING",
	                        title : "학습유형",
	                        width : "120px",
	                        headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
						    attributes : {"class" : "table-cell",style : "text-align:center"}
	                    },{
	                        field : "SUBJECT_NAME",
	                        title : "과정명",
	                        width : "200px",
	                        headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:left;text-decoration: underline;"},
	                        template: function(data){
	                        	var subjectName = data.SUBJECT_NAME;
	                        	if(data.USEFLAG == 'N'){
	                        		subjectName = "<font color='red'>"+data.SUBJECT_NAME+"</font>";
	                        	}
	                        	return "<a href='javascript:void();' onclick='javascript: fn_detailView("+data.SUBJECT_NUM+");' >"+subjectName+"</a>";
	                        } 
	                    },{
	                    	field : "ALW_STD_NM",
                            title : "상시학습종류",
                            width : "400px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
						    attributes : {"class" : "table-cell",style : "text-align:left"},
	                        template: function(data){
	                        	var nm1 = data.ALW_STD_NM1;
	                        	var nm2 = data.ALW_STD_NM2;
	                        	var nm = data.ALW_STD_NM;
	                        	if(nm!=null){
	                        		return nm1+" > "+nm2+" > "+nm;
	                        	}else{
	                        		return "";
	                        	}
	                        } 
	                    },{
	                        field : "DEPT_DESIGNATION_YN",
	                        title : "부처지정학습",
	                        width : "140px",
	                        headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
						    attributes : {"class" : "table-cell",style : "text-align:center"}
	                    },{
	                        field : "INSTITUTE_NAME",
	                        title : "교육기관",
	                        width : "110px",
	                        headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
						    attributes : {"class" : "table-cell",style : "text-align:center"}
	                    },{
	                        field : "RECOG_TIME_NM",
	                        title : "인정시간",
	                        width : "110px",
	                        headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
						    attributes : {"class" : "table-cell",style : "text-align:center"}
	                    } ],
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
	                pageSizes : [10,20,30],
	                buttonCount: 5
	            }
	        });
	
	        //과정 엑셀 업로드 팝업 호출..
            $("#excelUploadBtn").click(function() {
                $('#excel-upload-window').data("kendoWindow").center();
                $("#excel-upload-window").data("kendoWindow").open();
            });

	        //과정 엑셀파일업로드 팝업창 정의.. 상단에서 jquery.form.min.js 파일로드 해야함. 
	        if (!$("#excel-upload-window").data("kendoWindow")) {
	            $("#excel-upload-window").kendoWindow({
	                width : "340px",
	                minWidth : "340px",
	                resizable : false,
	                title : "과정 엑셀 업로드",
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
	                    beforeSubmit: function(data, frm, opt){
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
	                    },
	                    success: function(reponseText, statusText){
	                        //로딩바 제거.
	                        loadingClose();

	                    	if(reponseText ){
	                    		//결과값을 json으로 파싱
	                    		var myObj = JSON.parse(reponseText);
	                    		alert("-과정 업로드 결과-\n"+myObj.statement);
	                    	}else{
	                    		//작업 실패.
	                    		alert("작업이 실패하였습니다.");
	                    	}
	                        
	                        //그리드 다시 읽고,
	                        $("#grid").data("kendoGrid").dataSource.read();
	                        
	                        //업로드 객체 초기화
	                        $("#subjectUploadFile").parents(".k-upload").find(".k-upload-files").remove();
                            $("input[name='subjectUploadFile']").each(function(e){
                            	var inputFile =  $("input[name='subjectUploadFile']")[e];
                            	//이하 inputFile을 $로 감쌈.. 안감싸면 ie9이하버전에서 인식 못함..
                            	if($(inputFile)){ 
                            		if($(inputFile).id != "subjectUploadFile"){
                            			//프로그래밍한 input file이 아닌 자동  추가된 input file은 제거
                            			$(inputFile).remove();  
                            		}
                            	}
                            });
	                        
                            //팝업 닫기.
	                        $("#excel-upload-window").data("kendoWindow").close();
	                    },
	                    complete : function(jqXHR, textStatus) {
	                    	
	                    },
	                    error: function(e){
	                        alert("ERROR:"+e);
	                    }
	                });
            	});
	            
	            //엑셀파일만 선택하도록 처리됨.
	            $("#subjectUploadFile").kendoUpload({
                    multiple : false,
                    showFileList : true,
                    localization : {
                        select : '파일 선택'
                    },
                    async : {
                        autoUpload : false
                    },
                    select: function(e){
                        $.each(e.files, function(index, value) {
                            if( value.extension.toLowerCase() != ".xls" && value.extension.toLowerCase() != ".xlsx") {
                                
                                e.preventDefault();
                                alert("엑셀파일만 선택해주세요.");
                            }
                        });
                    }
                });
	        }
	        

            //역량매핑 엑셀 업로드 팝업 호출..
            $("#excelCmMappingUploadBtn").click(function() {
                $('#excel-cmmapping-upload-window').data("kendoWindow").center();
                $("#excel-cmmapping-upload-window").data("kendoWindow").open();
            });
            
            //역량매핑 엑셀파일업로드 팝업창 정의.. 상단에서 jquery.form.min.js 파일로드 해야함. 
            if (!$("#excel-cmmapping-upload-window").data("kendoWindow")) {
                $("#excel-cmmapping-upload-window").kendoWindow({
                    width : "340px",
                    minWidth : "340px",
                    resizable : false,
                    title : "역량매핑 엑셀 업로드",
                    modal : true,
                    visible : false
                });
                
                //역량매핑 업로드 버튼 이벤트
                $("#uploadCmmappingBtn").click(function() {
                    $("#excelCmmappingForm").ajaxForm({
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
                        },
                        success: function(reponseText, statusText){
                            //로딩바 제거.
                            loadingClose();

                            if(reponseText ){
                                //결과값을 json으로 파싱
                                var myObj = JSON.parse(reponseText);
                                alert("-역량매핑 업로드 결과-\n"+myObj.statement);
                            }else{
                                //작업 실패.
                                alert("작업이 실패하였습니다.");
                            }
                            
                            //그리드 다시 읽고,
                            $("#grid").data("kendoGrid").dataSource.read();
                            
                            //업로드 객체 초기화
                            $("#subjectCmmappingUploadFile").parents(".k-upload").find(".k-upload-files").remove();
                            $("input[name=subjectCmmappingUploadFile]").each(function(e){
                                var inputFile =  $("input[name=subjectCmmappingUploadFile]")[e];
                                if($(inputFile)){
                                    if($(inputFile).id != "subjectCmmappingUploadFile"){
                                        //프로그래밍한 input file이 아닌 자동  추가된 input file은 제거
                                        $(inputFile).remove();  
                                    }
                                }
                            });
                            
                            //팝업 닫기.
                            $("#excel-cmmapping-upload-window").data("kendoWindow").close();
                        },
                        error: function(e){
                            alert("ERROR:"+e);
                        }
                    });
                });
                //엑셀파일만 선택하도록 처리됨.
                $("#subjectCmmappingUploadFile").kendoUpload({
                    multiple : false,
                    showFileList : true,
                    localization : {
                        select : '파일 선택'
                    },
                    async : {
                        autoUpload : false
                    },
                    select: function(e){
                        $.each(e.files, function(index, value) {
                            if( value.extension.toLowerCase() != ".xls" && value.extension.toLowerCase() != ".xlsx" ) {
                                
                                e.preventDefault();
                                alert("엑셀파일만 선택해주세요.");
                            }
                        });
                    }
                });
            }
	        
	        //과정목록 엑셀 다운로드..
	        $("#lst-excel-btn").attr("href","<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-list-excel.do");

	        //과정추가 버튼 클릭 이벤트 START
	        $("#newBtn").click(function() {

	            $("#splitter").data("kendoSplitter").expand("#detail_pane");
	            kendo.bind($(".tabular"), null);
	            
	            //교육기관명 초기화
	            $("#input_nm").val("");
	            
	           //평가 및 수료기준 텍스트
                $("#EVL_CMPL").val("");
	          
	            //상시학습유형 초기화
	            dataSource_alwStdCd2.filter({ field: "VALUE", operator: "eq", value: "" });
                dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
	            
	            $('input:radio[id=deptDesignationYn]:input[value=N]').attr("checked", true);//부처지정여부
	            $('input:radio[id=requiredYn]:input[value=N]').attr("checked", true);//필수여부
                $('input:radio[id=useFlag]:input[value=Y]').attr("checked", true);//사용여부

	            //탭이동  
	            var tabStrip = $("#tabstrip").kendoTabStrip({
	            	animation:  {
	                    open: {
	                        effects: "fadeIn"
	                    }
	                },
	                activate: function (e){
	                    if(e.item.innerText == "과정정보"){
	                        
	                    }else if(e.item.innerText == "역량매핑"){
	                        //$(window).resize();
	                      $("#sbjctMapGrid .k-grid-content").attr("style", "height: "+($("#sbjctMapGrid").innerHeight() -35)+"px;");
	                    }else if(e.item.innerText == "수료기준"){
	                        //$(window).resize();
	                      $("#cmpltStndGrid .k-grid-content").attr("style", "height: "+($("#cmpltStndGrid").innerHeight() - 35)+"px;");
	                    }
	                }
	            }).data("kendoTabStrip");
				tabStrip.select(0);
                
	            //역량매핑정보 초기화
	            $("#sbjctMapGrid").data("kendoGrid").dataSource.read();
                //수료기준 정보 초기화
                $("#cmpltStndGrid").data("kendoGrid").dataSource.read();
	        });//과정추가 버튼 클릭 이벤트 END
	        
            //학습유형 데이터소스
            dataSource_training = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA03", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {data: "items",model: {fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" }
				}}},
                serverFiltering: false,
                serverSorting: false});
            //지정학습종류 데이터소스
            /*dataSource_deptDesignation = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA04", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {data: "items",model: {fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" }
				}}},
                serverFiltering: false,
                serverSorting: false});*/
            //기관성과평가필수교육과정 데이터소스
            dataSource_perfAsseSbjCd = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA11", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {data: "items",model: {fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" }
				}}},
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
                schema: {data: "items",model: {fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" }
				}}},
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
                schema: {data: "items",model: {fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" }
				}}},
                serverFiltering: false,
                serverSorting: false});
      
          	//교육기관 데이터소스
            dataSource_instituteCd = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA22", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {data: "items",model: {fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" }
				}}},
                serverFiltering: false,
                serverSorting: false});
          
            //상시학습종류 데이터소스
            dataSource_alwStdCd1 = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/alw-std-type.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  LEVEL : "1" };
                    }
                },
                schema: {data: "items",model: {fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" },
					P_VALUE : {type: "String" }
				}}},
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
                schema: {data: "items",model: {fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" },
					P_VALUE : {type: "String" }
				}}},
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
                schema: {data: "items",model: {fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" },
					P_VALUE : {type: "String" },
					CD_VALUE1 : {type: "String" },	//가중치
					CD_VALUE2 : {type: "String" },	//연간인정시간
					CD_VALUE3 : {type: "String" },	//코멘트
					CD_VALUE4 : {type: "String" },	//상시학습코드
					CD_VALUE5 : {type: "String" }	//자동계산여부
				}}},
                serverFiltering: false,
                serverSorting: false});
			//상시학습종류 필터
            dataSource_alwStdCd2.fetch(function(){
            	dataSource_alwStdCd2.filter({ field: "VALUE", operator: "eq", value: "" });
            	dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
            });
            dataSource_alwStdCd.fetch(function(){
                dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
            }); 
            
            //탭 생성.
            $("#tabstrip").kendoTabStrip({
            	animation:  {
                    open: {
                        effects: "fadeIn"
                    }
                },
                activate: function onActivate(e){
                    if(e.item.innerText == "과정정보"){
                        
                    }else if(e.item.innerText == "역량매핑"){
                        //$(window).resize();
                        $("#sbjctMapGrid .k-grid-content").attr("style", "height: "+($("#sbjctMapGrid").innerHeight() - 35)+"px;");
                    }else if(e.item.innerText == "수료기준"){
                        //$(window).resize();
                        $("#cmpltStndGrid .k-grid-content").attr("style", "height: "+($("#cmpltStndGrid").innerHeight() - 35)+"px;");
                    }
                }
            });

            //학습유형 
            var trainingCode = $("#TRAINING_CODE").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_training,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
            
            //지정학습종류
            /*var deptDesignationCd = $("#deptDesignationCd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_deptDesignation,
                 filter: "contains",
                 suggest: true,
                 change:function(){
                	 $("input:radio[id='deptDesignationY']").attr("disabled", false); 
            		 $("input:radio[id='deptDesignationN']").attr("disabled", false);
                	 if(this.value()=="004"){
                		 $("input:radio[id='deptDesignationN']").attr("checked", true); 
                		 $("input:radio[id='deptDesignationY']").attr("disabled", true); 
                		 $("input:radio[id='deptDesignationN']").attr("disabled", true); 
                	 }else{
                		 $("input:radio[id='deptDesignationY']").attr("checked", true); 
                		 $("input:radio[id='deptDesignationY']").attr("disabled", true); 
                		 $("input:radio[id='deptDesignationN']").attr("disabled", true); 
                	 }
                 }
             }).data("kendoDropDownList");
            */
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

            //교육기관
            var instituteCd = $("#select_nm").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_instituteCd,
                 filter: "contains",
                 suggest: true,
                 change:function(){
                	 if(this.value()=="Z"){
                		 $("#input_nm").enable(true);
                	 }else{
                		 $("#input_nm").val("");
                		 $("#input_nm").enable(false);
                		 
                	 }
                 }
             }).data("kendoDropDownList");
            
            //상시학습종류
             var alwStdCd1 = $("#alwStdCd1").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_alwStdCd1,
                 filter: "contains",
                 suggest: true,
                 change:function(){
                	 if(this.value()==""){
                		 alwStdCd2.value("");
                		 alwStdCd.value("");

                		 alwStdCd2.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                		 alwStdCd.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                	 }else{
                		 alwStdCd2.dataSource.filter({
               				 logic: "or",
               			        filters: [
               			               { field: "P_VALUE", operator: "contains", value:  this.value()},
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
                    if(this.value()==""){
                        alwStdCd.value("");

                        alwStdCd.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                    }else{
                        alwStdCd.dataSource.filter({
                            logic: "or",
                               filters: [
                                      { field: "P_VALUE", operator: "contains", value:  this.value()},
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
                suggest: true,
                change: function(){
                	var data=this.dataItem();
                	
                	var tmpStr = "";
                	if(data.get("CD_VALUE3")){
                		tmpStr = data.get("CD_VALUE3");
                	}
                	$("#alwStd_cm").text(tmpStr);
                	if(data.get("CD_VALUE5")=="Y"){
                		$("#autoTime").show();
                		$("#RECOG_TIME_H").val("");
                		$("#RECOG_TIME_M").val("");
                   		//recogTimeH.readonly(true);
                   		//recogTimeM.readonly(true);
                   		$.ajax({
	                        type : 'POST',
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/ba_autotime.do?output=json",
	                        data : {
	                        	hour: eduHourH.value(),
	                        	min: eduHourM.value(),
								weight:data.get("CD_VALUE1")
	                        },
	                        complete : function(response) {
	                            var obj = eval("(" + response.responseText + ")");
                            	recogTimeH.value(obj.items[0].autoHour);
                            	recogTimeM.value(obj.items[0].autoMin);
	                        },
	                        error : function(xhr, ajaxOptions, thrownError) {
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
                	}else{
                		$("#autoTime").hide();
                   		//recogTimeH.readonly(false);
                   		//recogTimeM.readonly(false);
                	}
                }
            }).data("kendoDropDownList");
            
            //교육 시간
            var eduHourH = $("#EDU_HOUR_H").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 999,
                step: 1,
                change: function(){
                	var data=alwStdCd.dataItem();
                	if(alwStdCd.dataItem().get("CD_VALUE5")=="Y"){
                		$.ajax({
                	        type : 'POST',
                	        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/ba_autotime.do?output=json",
                	        data : {
                	        	hour: this.value(),
	                        	min: eduHourM.value(),
								weight:data.get("CD_VALUE1")
                	        },
                	        complete : function(response) {
                	            var obj = eval("(" + response.responseText + ")");
                	            recogTimeH.value(obj.items[0].autoHour);
                	        	recogTimeM.value(obj.items[0].autoMin);
                	        },
                	        error : function(xhr, ajaxOptions, thrownError) {
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
            }).data("kendoNumericTextBox");
            //교육 분
            var eduHourM = $("#EDU_HOUR_M").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 59,
                step: 1,
                change: function(){
                	var data=alwStdCd.dataItem();
                	if(data.get("CD_VALUE5")=="Y"){
	                    $.ajax({
	                        type : 'POST',
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/ba_autotime.do?output=json",
	                        data : {
	                        	hour: eduHourH.value(),
	                        	min: this.value(),
								weight:data.get("CD_VALUE1")
	                        },
	                        complete : function(response) {
	                            var obj = eval("(" + response.responseText + ")");
	                            recogTimeH.value(obj.items[0].autoHour);
                            	recogTimeM.value(obj.items[0].autoMin);
	                        },
	                        error : function(xhr, ajaxOptions, thrownError) {
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
            }).data("kendoNumericTextBox");
            //인정 시간
            var recogTimeH = $("#RECOG_TIME_H").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 999,
                step: 1
            }).data("kendoNumericTextBox");
            //인정 분
            var recogTimeM = $("#RECOG_TIME_M").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 59,
                step: 1
            }).data("kendoNumericTextBox");
            
            //역량매핑 그리드
            $("#sbjctMapGrid").kendoGrid({
                dataSource : {
                    type : "json",
                    transport : {
                        read : {
                            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-cm-map-list.do?output=json",
                            type : "POST"
                        },
                        parameterMap : function(options, operation) {
                            return {
                                subjectNum : $("#dtl-subjectNum").val()
                            };
                        }
                    },
                    schema : {
                        total : "totalItemCount",
                        data : "items",
                        model : {
                            fields : {
                                CMPNUMBER : {type : "number",editable : false},
                                ROWNUMBER : {type : "string",editable : false},
                                CHECKFLAG : {type : "string",editable : false}
                            }
                        }
                    }
                },
                scrollable : true,
                sortable : true,
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
                pageable : false,
                editable : false,
                columns : [
                        {
                            field : "CHECKFLAG",
                            title : "선택",
                            filterable : false,
                            sortable : false,
                            width : 60,
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"},
                            template : "<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag(this, #: CMPNUMBER #)\" #: CHECKFLAG #/></div>"
                        },{
                            field : "CMPGROUP_STRING",
                            title : "역량군",
                            width : 150,
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "CMPNAME",
                            title : "역량명",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:left"}
                        },{
                            field : "JOBLDR_NAME",
                            title : "관련 직무/계급",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:left"}
                        } ],
            });
            
            //수료기준 그리드
            $("#cmpltStndGrid").kendoGrid({
                dataSource : {
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-cmplt-stnd.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){    
                            return {  SUBJECT_NUM : $("#dtl-subjectNum").val() };
                        }
                    },
                    schema: {
                        data: "items",
                        model: {
                            fields: {
                            	CODE : { type: "String" },
                            	LABEL : { type: "String" },
                            	WEI : { type:"number" }
                            }
                        }
                    },
                    serverFiltering: false,
                    serverSorting: false
                },
                scrollable : true,
                sortable : true,
                filterable : false,
                pageable : false,
                editable : false,
                columns : [
                        {
                            field : "LABEL",
                            title : "기준",
                            filterable : false,
                            sortable : false,
                            width : 350,
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "WEI",
                            title : "가중치",
                            filterable : false,
                            sortable : false,
                            width : 160,
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"},
                            template: function(dataItem){
                            	var wei = "";
                            	if(dataItem.WEI){
                            		wei = dataItem.WEI;
                            	}
                                return "<input type='text' id='wei_"+dataItem.CODE+"' value='"+wei+"' class='k-input input_95' style='text-align:center; ' onkeyup='setValue("+dataItem.CODE+", this);' />";
                                   
                            }
                        } ]
            });

            //삭제버튼 이벤트
            $("#delBtn").click( function() {
                var isDel = confirm("삭제 하시겠습니까?");
                if (isDel) {
                	//로딩바생성.
                    loadingOpen();
                	
                    var params = {
                        subjectNum : $("#dtl-subjectNum").val(),
                        FLAG : "10",
                    };

                    $.ajax({
                        type : 'POST',
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_del.do?output=json",
                        data : {
                            item : kendo.stringify(params)
                        },
                        complete : function(response) {
                        	//로딩바 제거.
                            loadingClose();
                        	
                            var obj = eval("(" + response.responseText + ")");
                            if(obj.error){
                            	alert("ERROR==>"+obj.error.message);
                            }else{
	                            if (obj.saveCount != 0) {
	                                // 상세영역 활성화
	                                $("#splitter").data("kendoSplitter").expand("#detail_pane");
	                                // 과정상세정보 호출
	                                $("#grid").data("kendoGrid").dataSource.read();
	                                //과정매핑상세정보 호출
	                                $("#sbjctMapGrid").data("kendoGrid").dataSource.read();
	
	                                kendo.bind($(".tabular"),null);
	                                // 상세영역 비활성화
	                                $("#splitter").data("kendoSplitter").toggle("#list_pane",true);
	                                $("#splitter").data("kendoSplitter").toggle("#detail_pane",false);
	
	                                alert("삭제되었습니다.");
	                            } else {
	                                alert("삭제를 실패 하였습니다.");
	                            }
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
            
            // 저장버튼 클릭 시.
            $("#save-btn").bind('click', function() {
                if(trainingCode.select()==0){
                	alert("학습유형을 선택해주세요");
                	trainingCode.focus();
                	return false;
                }
                if ($("#SUBJECT_NAME").val() == "") {
                    alert("과정명을 입력해주세요.");
                    $("#SUBJECT_NAME").focus();
                    return false;
                }
                if((alwStdCd1.select()==0 || alwStdCd2.select()==0) || alwStdCd.select()==0){
	                if(alwStdCd1.select()==0){
	                	alert("상시학습종류를 1차를 선택해주세요.");
	                	alwStdCd1.focus();
	                }else if(alwStdCd2.select()==0){
	                	alert("상시학습종류를 2차를 선택해주세요.");
	                	alwStdCd2.focus();
	                }else{
	                	alert("상시학습종류를 3차를 선택해주세요.");
	                	alwStdCd.focus();
	                }
                	return false;
                }
                if ( eduHourH.value() == null && eduHourM.value() == null ) {
                    alert("교육시간을 입력해주세요.");
                    eduHourH.focus();
                    return false;
                }
                if ( recogTimeH.value() == null && recogTimeM.value() == null ) {
                    alert("인정시간을 입력해주세요.");
                    recogTimeH.focus();
                    return false;
                }
                
                /*if (deptDesignationCd.select()==0) {
                		alert("지정학습종류을 선택해주세요.");
                		deptDesignationCd.focus();
                        return false;
                }*/
                if (instituteCd.select()==0){
                    alert("교육기관을 선택하세요.");
                    instituteCd.focus();
                    return false;
                }else{
                    if(instituteCd.value()=="Z" && $("#input_nm").val()==""){
                    	alert("교육기관명을 입력하세요.");
                        $("#input_nm").focus();
                        return false;
                    }
                }
                
                var institute_name  = "";
                if(instituteCd.value()=="Z"){
                	institute_name = $("#input_nm").val();
                }else{
                	institute_name = instituteCd.text();
                }

                //수료기준 가중치 합계 체크..
                var array = $('#cmpltStndGrid').data('kendoGrid').dataSource.data();
                var wei_sum = 0;
                for(var i=0; i<array.length; i++){
                	var wei = 0;
                	if(array[i].WEI){
                		wei = array[i].WEI;
                	}
                	wei_sum = wei_sum + Number(wei);
                }
                if(wei_sum>100){
                	alert("수료기준 가중치의 합이 100을 넘을 수 없습니다.");
                	return false;
                }
                
                if (confirm("과정정보를 저장하시겠습니까?")) {
                	//로딩바생성.
                	loadingOpen();
                	
                    var params = {
                    	    LIST :  $('#sbjctMapGrid').data('kendoGrid').dataSource.data(),
                            LIST2 : $('#cmpltStndGrid').data('kendoGrid').dataSource.data()  
                    };
            
                    $.ajax({
                        type : 'POST',          
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-sbjct-info.do?output=json",
                        data : {
                        	item: kendo.stringify( params ), 
                        	subjectNum : $("#dtl-subjectNum").val(),
                            TRAINING_CODE : removeNullStr(trainingCode.value()),
                            SUBJECT_NAME : $("#SUBJECT_NAME").val(),
                            EDU_HOUR_H : eduHourH.value(),
                            EDU_HOUR_M : eduHourM.value(),
                            RECOG_TIME_H : recogTimeH.value(),
                            RECOG_TIME_M : recogTimeM.value(),
                            EDU_TARGET : $("#EDU_TARGET").val(),
                            EDU_OBJECT : $("#EDU_OBJECT").val(),
                            COURSE_CONTENTS : $("#COURSE_CONTENTS").val(),
                            ALW_STD_CD : removeNullStr(alwStdCd.value()),
                            INSTITUTE_CODE : instituteCd.value(),
                            INSTITUTE_NAME : institute_name,
                            DEPT_DESIGNATION_YN : $(':radio[name="deptDesignationYn"]:checked').val(),
                            //DEPT_DESIGNATION_CD : removeNullStr(deptDesignationCd.value()),
                            PERF_ASSE_SBJ_CD : removeNullStr(perfAsseSbjCd.value()),
                            OFFICETIME_CD : removeNullStr(officeTimeCd.value()),
                            EDUINS_DIV_CD : removeNullStr(eduinsDivCd.value()),
                            REQUIRED_YN : $(':radio[id="requiredYn"]:checked').val(),
                            USEFLAG : $(':radio[id="useFlag"]:checked').val(),
                            EVL_CMPL : $("#EVL_CMPL").val()
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

            //취소버튼 이벤트
            $("#cancel-btn").click(function() {
                kendo.bind($(".tabular"), null);
                // 상세영역 비활성화
                $("#splitter").data("kendoSplitter").collapse("#detail_pane");
            });
			//브라우저 resize 이벤트 dispatch..
			$(window).resize();

        }
	}]);

</script>

<script type="text/javascript">
	function setValue(cmpltStndCd, obj){
	    var array = $('#cmpltStndGrid').data('kendoGrid').dataSource.data();            
	    var res = $.grep(array, function (e) {
            return e.CODE == cmpltStndCd;
        });
        if(chkNoNull(obj) && isNumber(obj)){
            res[0].WEI = $("#wei_"+cmpltStndCd).val();
        }else{
            res[0].WEI = null;
        }
	}
	function setAutoTime(){
		
	}	
	//상세보기
	function fn_detailView(subjectNum){
	    var grid = $("#grid").data("kendoGrid");
	    var data = grid.dataSource.data();
	    var res = $.grep(data, function (e) {
	        return e.SUBJECT_NUM == subjectNum;
	    });
	    var selectedCell = res[0];
	    
		// 상세영역 활성화
		$("#splitter").data("kendoSplitter").expand("#detail_pane");
		$("#dtl-subjectNum").val(selectedCell.SUBJECT_NUM);
	    $("#delBtn").show();
	    //지정학습 컨트롤
	    //$("input:radio[id='deptDesignationY']").attr("disabled", true); 
		//$("input:radio[id='deptDesignationN']").attr("disabled", true); 
		
		if(selectedCell.ALW_STD_CD4=='Y'){
		    $("#autoTime").show();
		}else{
	    	$("#autoTime").hide();
		}
	    //로딩바 생성.
	    loadingOpen();
	    
	    $.ajax({
            type : 'POST',
            dataType : 'json',
            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-info.do?output=json",
            data : {
                subjectNum : selectedCell.SUBJECT_NUM
            },
            success : function(response) {

                //로딩바 제거.
                loadingClose();
                
                if (response.items != null) {
				    //교육기관 컨트롤
					if(selectedCell.INSTITUTE_CODE=="Z"){
						$("#input_nm").enable(true);
						$("#input_nm").val(selectedCell.INSTITUTE_NAME);
					}else{
						$("#input_nm").enable(false);
						$("#input_nm").val("");
					}
				    
                    $('input:radio[name=deptDesignationYn]:input[value='+selectedCell.DEPT_DESIGNATION_YN+']').attr("checked", true);
                    $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);
                    var selectRow = new Object();
                    $.each(response.items, function(idx, item) {
                        $.each(item,function(key,val){
                            selectRow[key] = val;
                        });
                    });
                    
                    //상시학습종류 컨트롤
                    dataSource_alwStdCd2.filter({
                             logic: "or",
                                filters: [
                                       { field: "P_VALUE", operator: "eq", value:  selectRow.ALW_STD_CD1},
                                       { field: "VALUE", operator: "eq", value: "" }
					]});
                    dataSource_alwStdCd.filter({
                        logic: "or",
                        filters: [
                               { field: "P_VALUE", operator: "eq", value:  selectRow.ALW_STD_CD2},
                               { field: "VALUE", operator: "eq", value: "" }
					]});
                    
                    if(selectRow.ALW_STD_CD4=="Y"){
                        $("#autoTime").show();
                    }else{
                        $("#autoTime").hide();
                    }
                    
                   	/*var recogTimeH = $("#RECOG_TIME_H").data("kendoNumericTextBox");
                   	var recogTimeM = $("#RECOG_TIME_M").data("kendoNumericTextBox");
                    if(selectRow.ALW_STD_CD4=="Y"){
                    	$("#autoTime").show();
                    	recogTimeH.readonly();
                    	recogTimeM.readonly();
                    }else{
                    	$("#autoTime").hide();
                    	recogTimeH.readonly(false);
                    	recogTimeM.readonly(false);
                    }*/
                    //상세데이터 바인딩..
                    kendo.bind($("#tabular"), selectRow);
                    
                    //평가 및 수료기준 텍스트
                    $("#EVL_CMPL").val(selectRow.EVL_CMPL);
                    
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
	    
	    //역량매핑정보 조회
	    $("#sbjctMapGrid").data("kendoGrid").dataSource.read();
	    //수료기준정보 조회
	    $("#cmpltStndGrid").data("kendoGrid").dataSource.read();
	    
		// template에서 호출된 함수에 대한 이벤트 종료 처리.
		if (event.preventDefault) {
			event.preventDefault();
		} else {
			event.returnValue = false;
		}
	}//상세보기 END

    //역량매핑정보 변경 이벤트.
	function modifyYnFlag(checkbox, cmpnumber) {
		var array = $('#sbjctMapGrid').data('kendoGrid').dataSource.data();
		var res = $.grep(array, function (e) {
            return e.CMPNUMBER == cmpnumber;
        });
    
		if (checkbox.checked == true) {
			res[0].CHECKFLAG = "checked";
		} else {
			res[0].CHECKFLAG = '';
		}
	}
</script>
</head>
<body>

    <!-- START MAIN CONTENT  -->

        <div id="content">
            <div class="cont_body">
                <div class="title mt30">과정관리</div>
                <div class="table_zone">
                    <div class="table_btn">                         
                    		<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp;
                    		<a id="lst-excel-btn" class="k-button"  >엑셀다운로드</a>&nbsp;
                            <button id="excelUploadBtn" class="k-button" >과정엑셀업로드</button>&nbsp;
                            <button id="excelCmMappingUploadBtn" class="k-button" >역량매핑엑셀업로드</button>&nbsp;
                            <button id="newBtn" class="k-button" ><span class="k-icon k-i-plus"></span>과정추가</button>
                    </div>
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

                <div id="tabstrip">
                    <ul>
                        <li class="k-state-active">
                            과정정보
                        </li>
                        <li>
                            역량매핑
                        </li>
                        <li>
                            수료기준
                        </li>
                    </ul>
                    <div style="overflow-y:auto;">
		<!-- 과정정보 -->
		<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td class="subject" ><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 학습유형 <span style="color:red">*</span></label></td>
                <td class="subject"><select id="TRAINING_CODE" data-bind="value:TRAINING_CODE" style="width:200px;" ></select>
                </td>
            </tr>
            <tr>
                <td class="subject" style="width:100px;"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 과 정 명 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input type="hidden" id="dtl-subjectNum" data-bind="value:SUBJECT_NUM" />
                    <input class="k-textbox" id="SUBJECT_NAME" data-bind="value:SUBJECT_NAME"  style="width:100%;" onKeyUp="chkNull(this);"/>
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 상시학습종류 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <select id="alwStdCd1" data-bind="value:ALW_STD_CD1" style="width:100%; max-width:360px;"" ></select><br>
                    <select id="alwStdCd2" data-bind="value:ALW_STD_CD2" style="width:100%; max-width:360px;"" ></select><br>
                    <select id="alwStdCd" data-bind="value:ALW_STD_CD" style="width:100%; max-width:360px;" ></select></br>
					<span style="color:blue">※ 인정시간기준 : </span><span id="alwStd_cm" data-bind="text:ALW_STD_CD3" style="width:300px; border:none; color:blue" />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육시간 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input id="EDU_HOUR_H" data-bind="value:EDU_HOUR_H" style="width:80px;" /> 시간
                    <input id="EDU_HOUR_M" data-bind="value:EDU_HOUR_M" style="width:80px;" />분
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 인정시간 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input id="RECOG_TIME_H" data-bind="value:RECOG_TIME_H" style="width:80px;" /> 시간
                    <input id="RECOG_TIME_M" data-bind="value:RECOG_TIME_M" style="width:80px;" /> 분</br>
					<span id="autoTime" style="color:red; display:none;">※ 상시학습종류와 교육시간을 모두 입력하면 자동 계산됩니다.</span>
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 목적</label></td>
                <td class="subject"><textarea class="k-textbox" id="EDU_OBJECT" data-bind="value:EDU_OBJECT" rows="5"  style="width:100%;"></textarea></td>
            </tr>           
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 대상</label></td>
                <td class="subject"><textarea class="k-textbox" id="EDU_TARGET" data-bind="value:EDU_TARGET" rows="5"  style="width:100%;"></textarea></td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 내용</label></td>
                <td class="subject"><textarea class="k-textbox" id="COURSE_CONTENTS" data-bind="value:COURSE_CONTENTS" rows="5"  style="width:100%;"></textarea></td>
            </tr>
            <!--<tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 지정학습종류 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <select id="deptDesignationCd" data-bind="value:DEPT_DESIGNATION_CD" style="width:200px;" ></select>
                </td>
            </tr>-->
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 부처지정학습 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input type="radio" name="deptDesignationYn" id="deptDesignationY" value="Y"/> 예</input><span style="padding-left:40px">
					<input type="radio" name="deptDesignationYn" id="deptDesignationN" value="N"/></span> 아니오</input>
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기관 <span style="color:red">*</span></label></td>
                <td class="subject">
					<select id="select_nm" data-bind="value:INSTITUTE_CODE" style="width:200px;" ></select></br>
					<input class="k-textbox" id="input_nm" style="width:300;"/><span style="color:red"><br>※ 기타를 선택할 경우 교육기관명을 입력하세요.</span>
				</td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기관구분</label></td>
                <td class="subject">
                    <select id="eduinsDivCd" data-bind="value:EDUINS_DIV_CD" style="width:200px;" ></select>
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 기관성과평가필수교육과정</label></td>
                <td class="subject">
                    <select id="perfAsseSbjCd" data-bind="value:PERF_ASSE_SBJ_CD" style="width:200px;" ></select>
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육시간구분</label></td>
                <td class="subject">
                    <select id="officeTimeCd" data-bind="value:OFFICETIME_CD" style="width:200px;" ></select>
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 과정사용여부</label></td>
                <td class="subject">
                    <input type="radio" name="useFlag"  id="useFlag"   value="Y" /> 예</input>
                    <span style="padding-left:40px"><input type="radio" name="useFlag" id="useFlag"  value="N"/></span> 아니오</input></td>
                </td>
            </tr>
		</table>

                    </div>
                    <div>
                        <!-- 역량매핑 -->
                        <div id="sbjctMapGrid"></div>
                    </div>
                    <div>
                        <!-- 수료기준 -->
                        <div id="cmpltStndGrid"></div>
                        <div style="padding-top: 10px;">
                            <span style="background:url(/ehrd/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 평가 및 수료기준 <textarea class="k-textbox" id="EVL_CMPL" rows="5"  style="width:100%;"></textarea>
                        </div>
                    </div>
                </div>
                <div style="text-align:right;margin-top:10px">
                    <button id="save-btn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>
                    &nbsp;<button id="delBtn" class="k-button">삭제</button>&nbsp;
                    <button id="cancel-btn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>&nbsp;&nbsp;
                </div>
        
</script>

	<div id="excel-upload-window" style="display:none; width:340px;">
        <form id="excelForm" name="excelForm" method="post"  
        action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-excel-upload.do?output=json" enctype="multipart/form-data" >
		※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
           <div>
               <input name="subjectUploadFile" id="subjectUploadFile" type="file" />
               <div style="text-align: right;">
                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/subject_upload_template.xls" class="k-button" >과정템플릿다운로드</a>
                    <input type="submit" value="실행" class="k-button" id="uploadBtn"/>
               </div>
           </div>
       </form>
	</div>
   
	<div id="excel-cmmapping-upload-window" style="display:none; width:340px;">
        <form id="excelCmmappingForm" name="excelCmmappingForm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-cmmapping-excel-upload.do?output=json" enctype="multipart/form-data" >
		※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
           <div>
               <input name="subjectCmmappingUploadFile" id="subjectCmmappingUploadFile" type="file" />
               <div style="text-align: right;">
                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/subject_cmmapping_upload_template.xls" class="k-button" >역량매핑템플릿다운로드</a>
                    <input type="submit" value="실행" class="k-button" id="uploadCmmappingBtn"/>
               </div>
           </div>
       </form>
	</div>

<style scoped>
	#tabstrip {
	    margin: 0px auto;
	    height: 100%;
	}
</style>

</body>
</html>