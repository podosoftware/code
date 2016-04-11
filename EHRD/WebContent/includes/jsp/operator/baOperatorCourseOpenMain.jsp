<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page pageEncoding="UTF-8" isErrorPage="true"%>
<html decorator="operatorSubpage">
<head>
<title>차수관리</title>
<script type="text/javascript">

var dataSource_training ;
var dataSource_deptDesignation;
var dataSource_perfAsseSbjCd;
var dataSource_officeTimeCd;
var dataSource_eduinsDivCd;
var dataSource_alwStdCd1 ;
var dataSource_alwStdCd2 ;
var dataSource_alwStdCd ;

var now = new Date();
var isChasuDup = false;
var isaddChasuDup = false;
var detailSelected=null;

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
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/jquery.form.min.js'
                
        ],
        complete : function() {
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
                
                //탭 사이즈 재조정
                var tabStripElement = $("#tabstrip").kendoTabStrip();
                var expandContentDivs = function(divs) {
	                divs.height(gridElement.innerHeight()-90);
	            };
	            var resizeAll = function() {
	                expandContentDivs(tabStripElement.children(".k-content")); 
	            };
                
	            resizeAll();
	            
            });
            /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
            
            //로딩바선언
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
            //엑셀다운로드 버튼 클릭
            $("#excelDownloadBtn").click(function(){
                if(searchSdate.value() && searchEdate.value()){
                	frm.SEARCHSDATE.value = $("#searchSdate").val();
                	frm.SEARCHEDATE.value = $("#searchEdate").val();
                	frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-open-list-excel.do";
                    frm.submit();
                }else{
                    alert("교육 시작일과 종료일을 모두 입력해주세요.");
                }
            });
            //엑셀업로드 버튼 클릭.
            $("#excelUploadBtn").click(function() {
                $('#excel-upload-window').data("kendoWindow").center();
                $("#excel-upload-window").data("kendoWindow").open();
            });

            //차수 엑셀파일업로드 팝업창 정의.. 상단에서 jquery.form.min.js 파일로드 해야함. 
			if (!$("#excel-upload-window").data("kendoWindow")) {
                $("#excel-upload-window").kendoWindow({
                    width : "340px",
                    minWidth : "340px",
                    resizable : false,
                    title : "차수 엑셀 업로드",
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
                        },
                        success: function(reponseText, statusText){
                            //로딩바 제거.
                            loadingClose();

                            if(reponseText ){
                                //결과값을 json으로 파싱
                                var myObj = JSON.parse(reponseText);
                                alert("-차수 업로드 결과-\n"+myObj.statement);
                            }else{
                                //작업 실패.
                                alert("작업이 실패하였습니다.");
                            }
                            //그리드 다시 읽고,
                            $("#grid").data("kendoGrid").dataSource.read();
                            
                            //업로드 객체 초기화
                            $("#openUploadFile").parents(".k-upload").find(".k-upload-files").remove();
                            $("input[name=openUploadFile]").each(function(e){
                                var inputFile =  $("input[name=openUploadFile]")[e];
                                if($(inputFile)){
                                    if( $(inputFile).id  != "openUploadFile"){
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
                $("#openUploadFile").kendoUpload({
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
            //교육기간
			var searchSdate = $("#searchSdate").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {                    
                    var startDate = this.value(),
                    endDate = searchEdate.value();
                    if (startDate) {
                        startDate = new Date(startDate);
                        startDate.setDate(startDate.getDate());
                        searchEdate.min(startDate);
                    } else if (endDate) {
                    	this.max(new Date(endDate));
                    } else {
                        endDate = new Date();
                        this.max(endDate);
                        searchEdate.min(endDate);
                    }
                             
                 }
            }).data("kendoDatePicker");
            var searchEdate = $("#searchEdate").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {                    
                    var endDate = this.value(),
                     startDate = searchSdate.value();
                     if (endDate) {
                         endDate = new Date(endDate);
                         endDate.setDate(endDate.getDate());
                         searchSdate.max(endDate);
                     } else if (startDate) {
                    	 this.min(new Date(startDate));
                     } else {
                         endDate = new Date();
                         searchSdate.max(endDate);
                         this.min(endDate);
                     }
                }
            }).data("kendoDatePicker");

            searchSdate.value(new Date(now.getFullYear(), now.getMonth(), 1));
            searchEdate.value(new Date(now.getFullYear(), now.getMonth()+1, 0));
            searchSdate.max(searchEdate.value());
            searchEdate.min(searchSdate.value());
            
            $("#searchDiv").kendoDropDownList({
                width: 100
            });            
            
            //검색버튼 클릭
            $("#searchBtn").click(function(){
            	if(searchSdate.value() && searchEdate.value()){
            		$("#grid").data("kendoGrid").dataSource.read();
            	}else{
            		alert("교육 시작일과 종료일을 모두 입력해주세요.");
            	}
            });
            
            // show detail 
            $('#details').show().html(kendo.template($('#template').html()));  
            //탭 생성.
            var tabstrip = $("#tabstrip").kendoTabStrip({
            	animation:  {
                    open: {
                        effects: "fadeIn"
                    }
                }
            }).data("kendoTabStrip");
	        //차수관리 그리드
	        $("#grid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-open-list.do?output=json",
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
                            	startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter), SEARCHSDATE: $("#searchSdate").val(), SEARCHEDATE: $("#searchEdate").val(), SEARCHDIV : $("#searchDiv").val() 
                            };  
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        id : "OPEN_NUM",
	                        fields : {
	                            SUBJECT_NUM : { type : "number"},
	                            SUBJECT_NAME : {type : "string"},
	                            TRAINING_CODE : {type : "string"},
	                            TRAINING_STRING : {type : "string"},
	                            DEPT_DESIGNATION_YN : {type : "string"},
	                            //DEPT_DESIGNATION_CD : {type : "string"},
	                            //DEPT_DESIGNATION_STRING : {type : "string"},
	                            INSTITUTE_NAME : {type : "string"},
	                            RECOG_TIME_H : {type : "number"},
	                            RECOG_TIME_M : {type : "number"},
	                            CHASU_NUMB: {type : "number"}
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
						    field : "DEL_YN",
						    title : "선택 <input type='checkbox' id='allchkbox' onclick='javascript: allCheck(this);'>",
						    filterable : false,
						    sortable : false,
						    width : 60,
						    headerAttributes : {"class" : "table-header-cell", style : "text-align:center"},
						    attributes : {"class" : "table-cell", style : "text-align:center"},
						    template : function(data){
						    	
						    	return "<div style=\"text-align:center\"><input type=\"checkbox\" onclick=\"modifyYnFlag(this, "+data.OPEN_NUM+")\" "+(data.DEL_YN == 'Y' ? "checked":"") +"></div>";
						    } 
						    	
					    }, {
	                        field : "TRAINING_STRING",
	                        title : "학습유형",
	                        width : "120px",
	                        headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
	                    },{
                            field : "INSTITUTE_NAME",
                            title : "교육기관",
                            width : "120px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
	                        field : "SUBJECT_NAME",
	                        title : "과정명",
	                        width : "300px",
	                        headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:left;text-decoration: underline;"},
	                        template: function(data){
	                        	var subjectName = data.SUBJECT_NAME;
                                if(data.CLOSING_YN == 'Y'){
                                    subjectName = "<font color='red'>"+data.SUBJECT_NAME+" (폐강)</font>";
                                }
                                return "<a href='javascript:void();' onclick='javascript: fn_detailView("+data.SUBJECT_NUM+", "+data.OPEN_NUM+");' >"+subjectName+"</a>";
	                        }
	                    },{
                            field : "YYYY",
                            title : "개설연도",
                            width : "110px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "SUBJECT_NUM_NUMB",
                            title : "과정번호",
                            width : "110px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "OPEN_NUM_NUMB",
                            title : "개설번호",
                            width : "110px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "CHASU_NUMB",
                            title : "차수",
                            width : "90px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "EDU_PERIOD",
                            title : "교육기간",
                            width : "180px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "RECOG_TIME_NM",
                            title : "인정시간",
                            width : "110px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
	                        field : "DEPT_DESIGNATION_YN",
	                        title : "부처지정학습",
	                        width : "140px",
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
	        }).data("kendoGrid");
	
	        //일괄삭제 버튼 클릭 시
	        $("#allDelBtn").click(function(){
	        	var gridData = $("#grid").data("kendoGrid").dataSource.data();
	            
	            var userArr = new Array();
	            for(var i=0; i<gridData.length; i++){
	                if(gridData[i].DEL_YN=="Y"){
	                    userArr.push(gridData[i].OPEN_NUM);
	                }
	            }
	            if(userArr==null || userArr.length==0){
	                alert("삭제할 과정을 체크해주세요.");
	                return false;
	            }

	            if(confirm("선택한 과정을 일괄 삭제 하시겠습니까?")) { 
	                //로딩바생성
	                loadingOpen();
	                
	                $.ajax({
	                    type : 'POST',
	                    url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/several-del-sbjct-open-info.do?output=json",
	                    data : {
	                        item: userArr.join(',')
	                    },
	                    complete : function( response ){
	                        //로딩바 제거
	                        loadingClose();
	                        
	                        var obj  = eval("(" + response.responseText + ")");
	                        if(obj.error==null){
	                            if(obj.saveCount > 0){
	                                alert("삭제되었습니다");   

	                                $("#grid").data("kendoGrid").dataSource.read();
	                                $('#allchkbox').removeAttr('checked');
	                            }else{
	                                alert("실패 하였습니다.");
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
	        });
	        
	        //차수추가버튼 클릭 이벤트
	        $("#newBtn").click(function() {
	            $("#splitter").data("kendoSplitter").expand("#detail_pane");
	            //과정검색 버튼 보이기
	            $("#subjectSearchBtn").show();
	            //차수추가버튼 숨기기
	            $("#addChasuBtn").hide();
	            //폐강처리버튼 숨기기
	            $("#closeBtn").hide();
	            //삭제버튼 숨기기
	            $("#delBtn").hide();
	            //과정검색 버튼 보이기
	            $("#subjectSearchBtn").show();
	            //차수중복검사 버튼 보이기.
	            $("#dup-btn").show();
	            
	            kendo.bind($(".tabular"), null);
	            
	            detailSelected = null;
                
	            //상시학습유형 초기화
	            dataSource_alwStdCd2.filter({ field: "VALUE", operator: "eq", value: "" });
                dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
	            
	            //과정정보 탭으로 이동..
	            var tabStrip = $("#tabstrip").kendoTabStrip({
	            	animation:  {
	                    open: {
	                        effects: "fadeIn"
	                    }
	                }
	            }).data("kendoTabStrip");
				tabStrip.select(0);
                
	            //달력 초기화..(교육기간, 신청기간)
	            var eduSdate = $("#EDU_STIME").data("kendoDatePicker");
	            var eduEdate = $("#EDU_ETIME").data("kendoDatePicker");
	            
				eduSdate.min(new Date(1900, 0, 1)); // Setting defaults
				eduSdate.max(new Date(2099, 11, 31));
				eduEdate.min(new Date(1900, 0, 1));
				eduEdate.max(new Date(2099, 11, 31));
                
				var applySdate = $("#APPLY_STIME").data("kendoDatePicker");
                var applyEdate = $("#APPLY_ETIME").data("kendoDatePicker");
                
                applySdate.min(new Date(1900, 0, 1)); // Setting defaults
                applySdate.max(new Date(2099, 11, 31));
                applyEdate.min(new Date(1900, 0, 1));
                applyEdate.max(new Date(2099, 11, 31));
                
	            //개설년도 현재연도로 초기화
	            yyyy.value(now.getFullYear());
	            //차수 초기화
	            chasu.value(1);
	            
	            //교육자료 첨부파일 그리드 초기화
	            $("#my-file-gird").data('kendoGrid').dataSource.data([]);
	            //첨부파일 임시objectid 세팅(랜덤 정수로 ...)
	            var ranval = Math.floor(Math.random()*1000000000); 
	            $("#objectId").val(ranval);
	            
	        });
	        
	     	//취소버튼 클릭 이벤트
            $("#cancel-btn").click(function() {
                kendo.bind($(".tabular"), null);
                // 상세영역 비활성화
                $("#splitter").data("kendoSplitter").collapse("#detail_pane");
            });

            //과정검색 버튼 클릭 
			$("#subjectSearchBtn").click(function(){
				if( !$("#subjectList-window").data("kendoWindow") ){
                    $("#subjectList-window").kendoWindow({
                        width:"1200px",
                        height:"480px",
                        resizable : true,
                        title : "과정검색",
                        modal: true,
                        visible: false
                    });
                
                    $("#subjectSearchGrid").empty();
                    $("#subjectSearchGrid").kendoGrid({
                        dataSource: {
                            type: "json",
                            transport: {
                                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-use-list.do?output=json", type:"POST" },
                                parameterMap: function (options, operation){
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
                            schema: {
                            	total : "totalItemCount",
                                 data: "items",
                                 model: {
                                     fields: {
                                            SUBJECT_NUM : { type: "number" },
                                            TRAINING_STRING: { type:"string"},
                                            SUBJECT_NAME : { type: "string" },
                                            DEPT_DESIGNATION_YN: { type: "string"},
                                            DEPT_DESIGNATION_STRING: { type: "string" },
                                            INSTITUTE_NAME: { type: "string" },
                                            RECOG_TIME_H: { type: "number" }
                                        }
                                 }
                            },
                            pageSize : 30,
                            serverPaging: true, serverFiltering: true, serverSorting: true
                        },
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
                        columns: [{
                        		title: "선택", width: 80,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"} ,
                                template : function(data){
                                    return "<input type='button' class='k-button k-i-close' style='width:45' value='선택' onclick='fn_SelectSubject("+data.SUBJECT_NUM+");'/>";
                                }
                            },{
							    field : "TRAINING_STRING",
							    title : "학습유형",
							    width : "120px",
							    headerAttributes : {"class" : "table-header-cell", style : "text-align:center"},
							    attributes : {"class" : "table-cell",style : "text-align:center"}
							},{
							    field : "SUBJECT_NAME",
							    title : "과정명",
							    width : "300px",
							    headerAttributes : {"class" : "table-header-cell", style : "text-align:center"},
							    attributes : {"class" : "table-cell",style : "text-align:left"}
							},{
							    field : "DEPT_DESIGNATION_YN",
							    title : "부처지정학습",
							    width : "140px",
							    headerAttributes : {"class" : "table-header-cell", style : "text-align:center"},
							    attributes : {"class" : "table-cell",style : "text-align:center"}
							},{
                                field : "PERF_ASSE_SBJ_STRI",
                                title : "기관성과평가필수교육",
                                width : "150px",
                                headerAttributes : {"class" : "table-header-cell", style : "text-align:center"},
							    attributes : {"class" : "table-cell",style : "text-align:center"}
                            },{
							    field : "INSTITUTE_NAME",
							    title : "교육기관",
							    width : "130px",
							    headerAttributes : {"class" : "table-header-cell", style : "text-align:center"},
							    attributes : {"class" : "table-cell",style : "text-align:center"}
							},{
							    field : "RECOG_TIME",
							    title : "인정시간",
							    width : "110px",
							    headerAttributes : {"class" : "table-header-cell", style : "text-align:center"},
							    attributes : {"class" : "table-cell",style : "text-align:center"}
							}],
                        sortable : true,
                        pageable : true,
                        resizable : true,
                        reorderable : true,
                        pageable : {
                            refresh : false,
                            pageSizes : [10,20,30],
                            buttonCount: 5
                        },
                        height: 440
                    });
                }
                $("#subjectList-window").data("kendoWindow").center();
                $("#subjectList-window").data("kendoWindow").open();
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
                schema: {data: "items",model: { fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" }
				}}},
                serverFiltering: false,
                serverSorting: false});
            //지정학습종류 데이터소스
            dataSource_deptDesignation = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA04", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {data: "items",model: { fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" }
				}}},
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
                schema: {data: "items",model: { fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" }
				}}},
                serverFiltering: false,
                serverSorting: false});
            //교육시간구분 데이터소스
            dataSource_officeTimeCd = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA07", ADDVALUE: "=== 선택 ===" };
                    }
                },
                schema: {data: "items",model: { fields: {
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
                schema: {data: "items",model: { fields: {
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
                schema: {data: "items",model: { fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" }
				}}},
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
                schema: {data: "items",model: { fields: {
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
                schema: {data: "items",model: { fields: {
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
                schema: {data: "items",model: { fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" },
                    P_VALUE : {type: "String" }
				}}},
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
			//교육기관
			/* var instituteCd = $("#select_nm").kendoDropDownList({
					dataTextField: "TEXT",
					dataValueField: "VALUE",
					dataSource: dataSource_instituteCd,
					filter: "contains",
					suggest: true
			}).data("kendoDropDownList"); */
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
			
			//지정학습종류
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
			//교육시간구분
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
                suggest: true
            }).data("kendoDropDownList");

            //개설년도
            var yyyy = $("#yyyy").kendoNumericTextBox({
                format: "",
                min: 2000,
                max: 2100,
                step: 1
            }).data("kendoNumericTextBox");
            //개설년도 초기값 설정.
            yyyy.value(now.getFullYear());
            //차수
            var chasu = $("#chasu").kendoNumericTextBox({
                format: "",
                min: 1,
                max: 100,
                step: 1, 
                change: function(){
                	isChasuDup = false;
                	$("#dup-btn").show();
                }
            }).data("kendoNumericTextBox");
            //개설년도 초기값 설정.
            chasu.value(1);
            //교육시작일
            var eduSdate = $("#EDU_STIME").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {                    
                    var startDate = this.value();
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
            var eduEdate = $("#EDU_ETIME").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {                    
                    var endDate = this.value();
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
            //신청시작일
            var applySdate = $("#APPLY_STIME").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {
                    var startDate = this.value();
                    var endDate = applyEdate.value();
                    if (startDate) {
                        startDate = new Date(startDate);
                        startDate.setDate(startDate.getDate());
                        applyEdate.min(startDate);
                    } else if (endDate) {
                    	this.max(new Date(endDate));
                    } else {
                        endDate = new Date();
                        this.max(endDate);
                        applyEdate.min(endDate);
                    }
                 }
            }).data("kendoDatePicker");
            //신청종료일
            var applyEdate = $("#APPLY_ETIME").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {                    
                    var endDate = this.value(),
                     startDate = applySdate.value();
             
                     if (endDate) {
                         endDate = new Date(endDate);
                         endDate.setDate(endDate.getDate());
                         applySdate.max(endDate);
                     } else if (startDate) {
                    	 this.min(new Date(startDate));
                     } else {
                         endDate = new Date();
                         applySdate.max(endDate);
                         this.min(endDate);
                     }
                }
            }).data("kendoDatePicker");

            //취소마감일
            var cancelEdate = $("#CANCEL_ETIME").kendoDatePicker({
                format: "yyyy-MM-dd"
            }).data("kendoDatePicker");
            //모집정원
            var applicant = $("#APPLICANT").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 9999,
                step: 1
            }).data("kendoNumericTextBox");
            //교육일수
            var eduDays = $("#EDU_DAYS").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 999,
                step: 0.5
            }).data("kendoNumericTextBox");
            
			//차수추가 버튼 클릭시.
			$("#addChasuBtn").click(function(){

				if( !$("#addSubjectOpen-window").data("kendoWindow") ){
					$("#addSubjectOpen-window").kendoWindow({
                    	width:"500px",
                        height:"540px",
                        resizable : true,
                        title : "차수추가",
                        modal: true,
                        visible: false
                    });
                    //개설년도
                    var addyyyy = $("#addyyyy").kendoNumericTextBox({
                        format: "",
                        min: 2000,
                        max: 2100,
                        step: 1
                    }).data("kendoNumericTextBox");
                    //개설년도 초기값 설정.
                    addyyyy.value(now.getFullYear());
                    //차수
                    var addchasu = $("#addchasu").kendoNumericTextBox({
                        format: "",
                        min: 1,
                        max: 100,
                        step: 1, 
                        change: function(){
                            $("#adddup-btn").show();
                            isaddChasuDup = false;
                        }
                    }).data("kendoNumericTextBox");
                    //개설년도 초기값 설정.
                    addchasu.value(1);
                    //교육시작일
                    var addeduSdate = $("#addEDU_STIME").kendoDatePicker({
                        format: "yyyy-MM-dd",
                        change: function(e) {                    
                            var addstartDate = this.value(),
                            addendDate = addeduEdate.value();
                            if (addstartDate) {
                            	addstartDate = new Date(addstartDate);
                            	addstartDate.setDate(addstartDate.getDate());
                            	addeduEdate.min(addstartDate);
                            } else if (addendDate) {
                            	this.max(new Date(addendDate));
                            } else {
                            	addendDate = new Date();
                            	this.max(addendDate);
                            	addeduEdate.min(addendDate);
                            } 
                         }
                    }).data("kendoDatePicker");
                    //교육종료일
                    var addeduEdate = $("#addEDU_ETIME").kendoDatePicker({
                        format: "yyyy-MM-dd",
                        change: function(e) {                    
                            var addendDate = this.value(),
                            addstartDate = addeduSdate.value();
                             if (addendDate) {
                            	 addendDate = new Date(addendDate);
                            	 addendDate.setDate(addendDate.getDate());
                            	 addeduSdate.max(addendDate);
                             } else if (addstartDate) {
                            	 this.min(new Date(addstartDate));
                             } else {
                            	 addendDate = new Date();
                            	 addeduSdate.max(addendDate);
                            	 this.min(addendDate);
                             }
                        }
                    }).data("kendoDatePicker");

                    //신청시작일
                    var addapplySdate = $("#addAPPLY_STIME").kendoDatePicker({
                        format: "yyyy-MM-dd",
                        change: function(e) {                    
                            var addstartDate = this.value(),
                            addendDate = addapplyEdate.value();
                            if (addstartDate) {
                            	addstartDate = new Date(addstartDate);
                            	addstartDate.setDate(addstartDate.getDate());
                            	addapplyEdate.min(addstartDate);
                            } else if (addendDate) {
                            	this.max(new Date(addendDate));
                            } else {
                            	addendDate = new Date();
                            	this.max(addendDate);
                            	addapplyEdate.min(addendDate);
                            } 
                         }
                    }).data("kendoDatePicker");

                    //신청종료일
                    var addapplyEdate = $("#addAPPLY_ETIME").kendoDatePicker({
                        format: "yyyy-MM-dd",
                        change: function(e) {                    
                            var addendDate = this.value(),
                            addstartDate = addapplySdate.value();
                             if (addendDate) {
                            	 addendDate = new Date(addendDate);
                            	 addendDate.setDate(addendDate.getDate());
                            	 addapplySdate.max(addendDate);
                             } else if (addstartDate) {
                            	 this.min(new Date(addstartDate));
                             } else {
                            	 addendDate = new Date();
                            	 addapplySdate.max(addendDate);
                            	 this.min(addendDate);
                             }
                        }
                    }).data("kendoDatePicker");

                    //취소마감일
                    var addcancelEdate = $("#addCANCEL_ETIME").kendoDatePicker({
                        format: "yyyy-MM-dd"
                    }).data("kendoDatePicker");

                    //모집정원
                    var addapplicant = $("#addAPPLICANT").kendoNumericTextBox({
                        format: "",
                        min: 0,
                        max: 9999,
                        step: 1
                    }).data("kendoNumericTextBox");

                    //교육일수
                    var addeduDays = $("#addEDU_DAYS").kendoNumericTextBox({
                        format: "",
                        min: 0,
                        max: 999,
                        step: 0.5
                    }).data("kendoNumericTextBox");
                    
                    //차수추가 팝업 - 중복검사 
                    $("#adddup-btn").click(function(){
                        if( $("#dtl-subjectNum").val() == ""){
                            alert("과정을 선택해주세요.");
                            return false;
                        }else if($("#addyyyy").val() == ""){
                            alert("개설년도를 입력해주세요.");
                            return false;
                        }else if($("#addchasu").val() == ""){
                            alert("차수를 입력해주세요");
                            return false;
                        }

                        //로딩바 생성.
                        loadingOpen();
                        
                        $.ajax({
                            type : 'POST',          
                            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/chk-chasu.do?output=json",
                            data : {
                                subjectNum : $("#dtl-subjectNum").val(),
                                YYYY : $("#addyyyy").val(),
                                CHASU : $("#addchasu").val()
                            },
                            complete : function( response ){
                                //로딩바 제거.
                                loadingClose();
                                
                                var obj  = eval("(" + response.responseText + ")");
                                if(!obj.error){
                                    if(obj.saveCount == 0){
                                        isaddChasuDup = true;
                                        $("#adddup-btn").hide();
                                        alert("사용가능한 차수입니다.");
                                        
                                    }else{
                                        isaddChasuDup = false;
                                        $("#adddup-btn").show();
                                        if(confirm("이미 존재하는 차수입니다.\n그래도 사용하시겠습니까?")){
                                            isaddChasuDup = true;
                                            $("#adddup-btn").hide();
                                        }
                                    }
                                }                       
                            },
                            error : function(xhr, ajaxOptions, thrownError) { 
                                //로딩바 제거.
                                loadingClose();
                                
                            },
                            dataType : "json"
                        });
                    });
                    
                    //차수추가 팝업창의 저장버튼 클릭 시
                    $("#addsave-btn").bind('click', function() {
		                if ($("#SUBJECT_NAME").val() == "") {
		                    alert("과정명을 입력해주세요.");
		                    tabstrip.select(0);
		                    $("#SUBJECT_NAME").focus();
		                    return false;
		                }
		                if(addyyyy.value()==null || addyyyy.value()==""){
		                    alert("개설년도를 입력해주세요.");
		                    addyyyy.focus();
		                    return false;
		                }
		                if(addchasu.value()==null || addchasu.value()==""){
		                    alert("차수를 입력해주세요.");
		                    addchasu.focus();
		                    return false;
		                }
		                if(!isaddChasuDup){
		                    alert("차수 중복검사를 실행해주세요.");
		                    $("#adddup-btn").focus();
		                    return false;
		                }
		                if(addeduSdate.value()==null || addeduSdate.value()=="" || addeduEdate.value()==null || addeduEdate.value()==""){
		                    alert("교육기간을 모두 입력해주세요.");
		                    if(addeduSdate.value()==null || addeduSdate.value()==""){
		                    	addeduSdate.open();
		                    }else{
		                    	addeduEdate.open();
		                    }
		                    return false;
		                }
		                if(addapplySdate.value()==null || addapplySdate.value()=="" || addapplyEdate.value()==null || addapplyEdate.value()==""){
		                    alert("신청기간을 모두 입력해주세요.");
		                    if(addapplySdate.value()==null || addapplySdate.value()==""){
		                    	addapplySdate.open();
		                    }else{
		                    	addapplyEdate.open();
		                    }
		                    return false;
		                }
		                if(addcancelEdate.value()==null || addcancelEdate.value()==""){
		                    alert("취소마감일을 입력해주세요.");
		                    addcancelEdate.open();
		                    return false;
		                }
		                //교육기관 컨트롤
	                	var institute_name  = "";
	                    if(instituteCd.value()=="Z"){
	                    	institute_name = $("#input_nm").val();
	                    }else{
	                    	institute_name = instituteCd.text();
	                    }
		                if (confirm("차수정보를 저장하시겠습니까?")) {
		                    //로딩바생성
		                    loadingOpen();
		                    
		                    $.ajax({
		                        type : 'POST',          
		                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-sbjct-open-info.do?output=json",
		                        data : {
		                        	//과정정보
		                        	subjectNum : $("#dtl-subjectNum").val(),
		                            OPEN_NUM : "",
		                            TRAINING_CODE : removeNullStr(trainingCode.value()),
		                            SUBJECT_NAME : $("#SUBJECT_NAME").val(),
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
		                            //차수정보
		                            YYYY : addyyyy.value(),
		                            CHASU : addchasu.value(),
		                            EDU_STIME : $("#addEDU_STIME").val(),
		                            EDU_ETIME : $("#addEDU_ETIME").val(),
		                            APPLY_STIME : $("#addAPPLY_STIME").val(),
		                            APPLY_ETIME : $("#addAPPLY_ETIME").val(),
		                            CANCEL_ETIME : $("#addCANCEL_ETIME").val(),
		                            APPLICANT : addapplicant.value(),
		                            EDU_DAYS : addeduDays.value(),
		                            EDU_HOUR_H : eduHourH.value(),
		                            EDU_HOUR_M : eduHourM.value()
		                        },
		                        complete : function( response ){
		                            //로딩바 제거
		                            loadingClose();
		                            var obj  = eval("(" + response.responseText + ")");
		                            if(!obj.error){
		                                if(obj.saveCount > 0){         
		                                    // 차수목록 read
		                                    $("#grid").data("kendoGrid").dataSource.read();
		                                    kendo.bind($(".addChasuPop"), null);
		                                    $("#addSubjectOpen-window").data("kendoWindow").close();
		                                    alert("저장되었습니다.");  
		                                }else{
		                                    alert("저장에 실패 하였습니다. 교육운영자에게 문의해주세요.");
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
		                                alert('xrs.status = ' + xhr.status + '\n' + 
		                                        'thrown error = ' + thrownError + '\n' +
		                                        'xhr.statusText = '  + xhr.statusText );
		                            }
		                        },
		                        dataType : "json"
		                    });
		
		                }
		            });
		                    
                    //차수추가 팝업창의 취소버튼 클릭 시
                    $("#addcancel-btn").click(function() {
                        kendo.bind($(".addChasuPop"), null);

                        $("#addSubjectOpen-window").data("kendoWindow").close();
                    });
                }else{
                	//달력 초기화..(교육기간, 신청기간)
                    var addeduSdate = $("#addEDU_STIME").data("kendoDatePicker");
                    var addeduEdate = $("#addEDU_ETIME").data("kendoDatePicker");
                    
                    addeduSdate.min(new Date(1900, 0, 1)); // Setting defaults
                    addeduSdate.max(new Date(2099, 11, 31));
                    addeduEdate.min(new Date(1900, 0, 1));
                    addeduEdate.max(new Date(2099, 11, 31));
                    
                    var addapplySdate = $("#addAPPLY_STIME").data("kendoDatePicker");
                    var addapplyEdate = $("#addAPPLY_ETIME").data("kendoDatePicker");
                    
                    addapplySdate.min(new Date(1900, 0, 1)); // Setting defaults
                    addapplySdate.max(new Date(2099, 11, 31));
                    addapplyEdate.min(new Date(1900, 0, 1));
                    addapplyEdate.max(new Date(2099, 11, 31));
                    
                    var addcancelEdate = $("#addCANCEL_ETIME").data("kendoDatePicker");
                    
                    addeduSdate.value("");
                    addeduEdate.value("");
                    addapplySdate.value("");
                    addapplyEdate.value("");
                    addcancelEdate.value("");
                }
                
                //팝업창 차수추가 항목 데이터 바인딩..
                kendo.bind($(".addChasuPop"), detailSelected);
                $("#addSubjectOpen-window").data("kendoWindow").center();
                $("#addSubjectOpen-window").data("kendoWindow").open();
            });
            
            //삭제버튼 이벤트
            $("#delBtn").click( function() {
                var isDel = confirm("차수를 삭제 하시겠습니까?\n삭제 후에는 관련된 모든 정보를 조회하실 수 없습니다.");
                if (isDel) {
                    //로딩바 생성.
                    loadingOpen();
                    
                    $.ajax({
                        type : 'POST',
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/del-sbjct-open-info.do?output=json",
                        data : {
                        	SUBJECT_NUM : $("#dtl-subjectNum").val(),
                        	OPEN_NUM : $("#dtl-openNum").val()
                        },
                        complete : function(response) {
                            //로딩바 제거.
                            loadingClose();
                            
                            var obj = eval("(" + response.responseText + ")");
                            if (obj.saveCount != 0) {
                                // 상세영역 활성화
                                $("#splitter").data("kendoSplitter").expand("#detail_pane");

                                // 과정상세정보 호출
                                $("#grid").data("kendoGrid").dataSource.read();

                                kendo.bind($(".tabular"),null);

                                // 상세영역 비활성화
                                $("#splitter").data("kendoSplitter").toggle("#list_pane",true);
                                $("#splitter").data("kendoSplitter").toggle("#detail_pane",false);

                                alert("삭제되었습니다.");
                            } else {
                                alert("삭제를 실패 하였습니다.");
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

            //폐강처리 버튼 클릭 시
            $("#closeBtn").bind("click", function(){
            	if(detailSelected.CLOSING_YN=="Y"){
            		alert("이미 폐강된 차수입니다.");
            		return false;
            	}
            	var isClose = confirm("해당 차수를 정말 폐강처리하시겠습니까?\n수강생이 있으면 자동 취소처리 됩니다.");
                if (isClose) {
                    //로딩바 생성.
                    loadingOpen();
                    
                    $.ajax({
                        type : 'POST',
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/close-sbjct-open-info.do?output=json",
                        data : {
                        	SUBJECT_NUM : $("#dtl-subjectNum").val(), OPEN_NUM : $("#dtl-openNum").val()
                        },
                        complete : function(response) {
                            //로딩바 제거.
                            loadingClose();
                            
                            var obj = eval("(" + response.responseText + ")");
                            if(obj.error){
                            	alert("ERROR:"+obj.error.message);
                            }else{
	                            if (obj.saveCount != 0) {
	                                // 차수목록 호출
	                                $("#grid").data("kendoGrid").dataSource.read();
	
	                                kendo.bind($(".tabular"),null);
	
	                                // 상세영역 비활성화
                                    $("#splitter").data("kendoSplitter").collapse("#detail_pane");
	
	                                alert("폐강 되었습니다.");
	                            } else {
	                                alert("폐강처리를 실패 하였습니다.");
	                            }
                            }
                        },
                        error : function(xhr, ajaxOptions,  thrownError) {
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
            	if(detailSelected != null && detailSelected.CLOSING_YN=="Y"){
                    alert("이미 폐강된 차수입니다.");
                    return false;
                }
                if ($("#SUBJECT_NAME").val() == "") {
                    alert("과정명을 입력해주세요.");
                    tabstrip.select(0);
                    $("#SUBJECT_NAME").focus();
                    return false;
                }
                if(yyyy.value()==null || yyyy.value()==""){
                	alert("개설년도를 입력해주세요.");
                	tabstrip.select(1);
                	yyyy.focus();
                	return false;
                }
                if(chasu.value()==null || chasu.value()==""){
                	alert("차수를 입력해주세요.");
                	tabstrip.select(1);
                    chasu.focus();
                    return false;
                }
                if(!isChasuDup){
                	alert("차수 중복검사를 실행해주세요.");
                    tabstrip.select(1);
                    $("#dup-btn").focus();
                	return false;
                }
                if(eduSdate.value()==null || eduSdate.value()=="" || eduEdate.value()==null || eduEdate.value()==""){
                	alert("교육기간을 모두 입력해주세요.");
                	tabstrip.select(1);
                	if(eduSdate.value()==null || eduSdate.value()==""){
                		eduSdate.open();
                	}else{
                		eduEdate.open();
                	}
                    return false;
                }
                if(applySdate.value()==null || applySdate.value()=="" || applyEdate.value()==null || applyEdate.value()==""){
                    alert("신청기간을 모두 입력해주세요.");
                    tabstrip.select(1);
                    if(applySdate.value()==null || applySdate.value()==""){
                    	applySdate.open();
                    }else{
                    	applyEdate.open();
                    }
                    return false;
                }
                if(cancelEdate.value()==null || cancelEdate.value()==""){
                    alert("취소마감일을 입력해주세요.");
                    tabstrip.select(1);
                    cancelEdate.open();
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
				//교육기관 컨트롤
            	var institute_name  = "";
                if(instituteCd.value()=="Z"){
                	institute_name = $("#input_nm").val();
                }else{
                	institute_name = instituteCd.text();
                }
                if (confirm("차수정보를 저장하시겠습니까?")) {
                	//로딩바생성
                	loadingOpen();
                	
                    $.ajax({
                        type : 'POST',          
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-sbjct-open-info.do?output=json",
                        data : {
                        	//과정정보
                        	subjectNum : $("#dtl-subjectNum").val(),
                            OPEN_NUM : $("#dtl-openNum").val(),
                            TRAINING_CODE : removeNullStr(trainingCode.value()),
                            SUBJECT_NAME : $("#SUBJECT_NAME").val(),
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
                            //차수정보
                            YYYY : yyyy.value(),
                            CHASU : chasu.value(),
                            EDU_STIME : $("#EDU_STIME").val(),
                            EDU_ETIME : $("#EDU_ETIME").val(),
                            APPLY_STIME : $("#APPLY_STIME").val(),
                            APPLY_ETIME : $("#APPLY_ETIME").val(),
                            CANCEL_ETIME : $("#CANCEL_ETIME").val(),
                            APPLICANT : applicant.value(),
                            EDU_DAYS : eduDays.value(),
                            EDU_HOUR_H : eduHourH.value(),
                            EDU_HOUR_M : eduHourM.value(),
                            OBJECTID : $("#objectId").val(),
                            EVL_CMPL : $("#EVL_CMPL").val()
                        },
                        complete : function( response ){
                        	//로딩바 제거
                        	loadingClose();
                        	
                            var obj  = eval("(" + response.responseText + ")");
                            if(!obj.error){
                            	if(obj.saveCount > 0){         
                                    // 상세영역 활성화
                                    $("#splitter").data("kendoSplitter").expand("#detail_pane");
                                    // 차수목록 read
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
                        	//로딩바 제거
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
            
            //차수 중복검사 
            $("#dup-btn").click(function(){
            	if( $("#dtl-subjectNum").val() == ""){
            		alert("과정을 선택해주세요.");
            		return false;
            	}else if($("#yyyy").val() == ""){
            		alert("개설년도를 입력해주세요.");
            		return false;
            	}else if($("#chasu").val() == ""){
            		alert("차수를 입력해주세요");
            		return false;
            	}
                //로딩바 생성.
                loadingOpen();
            	
                $.ajax({
                    type : 'POST',          
                    url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/chk-chasu.do?output=json",
                    data : {
                        subjectNum : $("#dtl-subjectNum").val(),
                        YYYY : $("#yyyy").val(),
                        CHASU : $("#chasu").val()
                    },
                    complete : function( response ){
                        //로딩바 제거.
                        loadingClose();
                        
                        var obj  = eval("(" + response.responseText + ")");
                        if(!obj.error){
                            if(obj.saveCount == 0){
                            	isChasuDup = true;
                                $("#dup-btn").hide();
                                alert("사용가능한 차수입니다.");
                            }else{
                            	isChasuDup = false;
                            	$("#dup-btn").show();
                            	if(confirm("이미 존재하는 차수입니다.\n그래도 사용하시겠습니까?")){
                            		isChasuDup = true;
                                    $("#dup-btn").hide();
                            	}
                            }
                        }                       
                    },
                    error : function(xhr, ajaxOptions, thrownError) { 
                        //로딩바 제거.
                        loadingClose();
                    },
                    dataType : "json"
                });
            });
            
          	//교육 시간
            var eduHourH = $("#EDU_HOUR_H").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 999,
                step: 1
            }).data("kendoNumericTextBox");
          	//교육 분
            var eduHourM = $("#EDU_HOUR_M").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 59,
                step: 1
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
            
            //교육자료 파일업로드
            var objectType = 1 ;
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
            var template = null;
            if( ( ver > -1) && ( ver < 10 ) ){
                if( $('#my-file-upload').text().length == 0  ) {
                    template = kendo.template('<button id="openUploadWindow" name="openUploadWindow">파일 업로드 하기</button>');
                    $('#my-file-upload').html(template({}));
                    $('#openUploadWindow').kendoButton({
                        click: function(e){
                        	var width = 380;
                            var height = 220;
                            var left = (screen.width - width) / 2;
                            var top = (screen.height - height) / 2;
                            
                            var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#objectId").val() +"&fileType=doc",
                            myWindow = window.open(windowUrl, "_blank", "toolbar=no, scrollbars=yes, resizable=yes, top="+top+", left="+left+", width="+width+", height="+height);
                        }
                    });
                    $('button.custom-button-delete').click( function(e){
                        alert ("delete");
                    });
                    $("#my-file-upload").removeClass('hide');
                }                   
            }else{                  
                if( $('#my-file-upload').text().length == 0  ) {
                    template = kendo.template($("#fileupload-template").html());
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
                                }
                            });
                        }
                        
                    });
                    $("#my-file-upload").removeClass('hide');
                }
            }
            
            //상세화면의 항목중 비활성화 처리해야할 것들 처리.. -------------------------------------------
            trainingCode.enable(false);
            //eduHourH.enable(false);
            //eduHourM.enable(false);
            //recogTimeH.enable(false);
            //recogTimeM.enable(false);
            alwStdCd1.enable(false);
            alwStdCd2.enable(false);
            alwStdCd.enable(false);
            //perfAsseSbjCd.enable(false);
            //officeTimeCd.enable(false);
            //eduinsDivCd.enable(false);
            //deptDesignationCd.enable(false);
            //$("input:radio[id='deptDesignationY']").attr("disabled", true);
        	//$("input:radio[id='deptDesignationN']").attr("disabled", true);
            //instituteCd.enable(false);
            $("#input_nm").enable(false);
            //----------------------------------------------------------------------------------------------------
          //브라우저 resize 이벤트 dispatch..
            $(window).resize();
        }
    }]);
</script>

<script type="text/javascript">
	//과정검색 팝업에서 과정 선택 시.
	function fn_SelectSubject(subjectNum){
    var grid = $("#subjectSearchGrid").data("kendoGrid");
    var data = grid.dataSource.data();
    var res = $.grep(data, function (e) {
        return e.SUBJECT_NUM == subjectNum;
    });
    var selectedCell = res[0];
    /* if(selectedCell.INSTITUTE_CODE=="Z"){
		$("#input_nm").val(selectedCell.INSTITUTE_NAME);
		$("#input_nm").show();
	}else{
		$("#input_nm").hide();
	} */
    if(selectedCell.INSTITUTE_CODE=="Z"){
		$("#input_nm").enable(true);
		$("#input_nm").val(selectedCell.INSTITUTE_NAME);
	}else{
		$("#input_nm").enable(false);
		$("#input_nm").val("");
	}
    //과정명 세팅
    $("#dtl-subjectNum").val(subjectNum);
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
	                $('input:radio[name=deptDesignationYn]:input[value='+selectedCell.DEPT_DESIGNATION_YN+']').attr("checked", true);
	                var selectRow = new Object();
	                $.each(response.items, function(idx, item) {
	                    $.each(item,function(key,val){
	                        selectRow[key] = val;
	                    });
	                });
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
	                
	                //개설년도 현재연도로 초기화
	                selectRow.YYYY = now.getFullYear();
	                //차수 초기화
	                selectRow.CHASU = 1;
	                //상세데이터 바인딩..
	                kendo.bind($(".tabular"), selectRow);
	                
	                $("#subjectList-window").data("kendoWindow").close();
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
	}

	// 상세보기.
	function fn_detailView(subjectNum, openNum){
	    var grid = $("#grid").data("kendoGrid");
	    var data = grid.dataSource.data();
	    var res = $.grep(data, function (e) {
	        return (e.SUBJECT_NUM == subjectNum && e.OPEN_NUM == openNum);
	    });
	    var selectedCell = res[0];
	    /* if(selectedCell.INSTITUTE_CODE=="Z"){
			$("#input_nm").val(selectedCell.INSTITUTE_NAME);
			$("#input_nm").show();
		}else{
			$("#input_nm").hide();
		} */
	    if(selectedCell.INSTITUTE_CODE=="Z"){
			$("#input_nm").enable(true);
			$("#input_nm").val(selectedCell.INSTITUTE_NAME);
		}else{
			$("#input_nm").enable(false);
			$("#input_nm").val("");
		}
	    
	    //과정명 세팅
		$("#dtl-subjectNum").val(selectedCell.SUBJECT_NUM);
		$("#dtl-openNum").val(selectedCell.OPEN_NUM);
		// 상세영역 활성화
		$("#splitter").data("kendoSplitter").expand("#detail_pane");
		//과정검색 버튼 숨기기
		$("#subjectSearchBtn").hide();
		//차수추가버튼 숨기기
        $("#addChasuBtn").show();
        //폐강처리버튼 숨기기
        $("#closeBtn").show();
        //삭제버튼 보이기
	    $("#delBtn").show();
	    //중복검사 버튼 숨기기
	    $("#dup-btn").hide();
	    isChasuDup = true;
		//로딩바 생성.
		loadingOpen();
	       
	    $.ajax({
            type : 'POST',
            dataType : 'json',
            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-open-info.do?output=json",
            data : {
                subjectNum : selectedCell.SUBJECT_NUM, openNum: selectedCell.OPEN_NUM
            },
            success : function(response) {
                //로딩바 제거.
                loadingClose();
                
                if (response.items != null) {
                    $('input:radio[name=deptDesignationYn]:input[value='+selectedCell.DEPT_DESIGNATION_YN+']').attr("checked", true);
                    var selectRow = new Object();
                    $.each(response.items, function(idx, item) {
                        $.each(item,function(key,val){
                            selectRow[key] = val;
                        });
                    });
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
                    detailSelected = selectRow;
                    //$("#select_nm").val(selectRow.INSTITUTE_CODE);
                    //kendoDatePicker min, max 세팅.
                    var eduSdate = $("#EDU_STIME").data("kendoDatePicker") ;//;
                    var eduEdate = $("#EDU_ETIME").data("kendoDatePicker") ;//;
                    var startDate = selectRow.EDU_STIME;
                    var endDate = selectRow.EDU_ETIME;

                    if (startDate) {
                        //startDate = new Date(startDate);
                        //startDate.setDate(startDate.getDate());
                        eduEdate.min(startDate);
                    } 
                    if (endDate) {
                        eduSdate.max(endDate);
                    } 
                    
                    var applySdate = $("#APPLY_STIME").data("kendoDatePicker") ;//;
                    var applyEdate = $("#APPLY_ETIME").data("kendoDatePicker") ;//;
                    var astartDate = selectRow.APPLY_STIME;
                    var aendDate = selectRow.APPLY_ETIME;

                    if (astartDate) {
                        //astartDate = new Date(astartDate);
                        //astartDate.setDate(astartDate.getDate());
                        applyEdate.min(astartDate);
                    } 
                    if (aendDate) {
                    	applySdate.max(aendDate);
                    } 
                    //상세데이터 바인딩..
                    kendo.bind($(".tabular"), selectRow);
                    //첨부파일 리로드..
                    $("#objectId").val(selectedCell.OPEN_NUM);
                    handleCallbackUploadResult();
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
	
	// 전체선택..
	function allCheck(checkbox){
	    var array = $("#grid").data("kendoGrid").dataSource.view();
	    $.each(array, function(i,e){
	        if(checkbox.checked == true){
	            e.DEL_YN = "Y";
	        }else{
	            e.DEL_YN = "N";
	        }
	    });
	    $("#grid").data("kendoGrid").refresh();
	}

	// 체크박스 체크..
	function modifyYnFlag(checkbox, id){
	    var item = $("#grid").data("kendoGrid").dataSource.get(id);
	    if(checkbox.checked == true){
	        item.DEL_YN = 'Y';
	    }else{
	        item.DEL_YN = "N";
	        
	        // 전체선택 버튼 해제
	        $('#allchkbox').removeAttr('checked');
	    }
	}      

	
</script>	
<script type="text/javascript">
    // 첨부파일 함수
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
</script>
</head>
<body>
<form name="frm" id="frm" method="post" >
	<input type="hidden"  id="SEARCHSDATE" name="SEARCHSDATE" />
	<input type="hidden"  id="SEARCHEDATE" name="SEARCHEDATE" />
</form>
    <!-- START MAIN CONTENT  -->
        <div id="content">
            <div class="cont_body">
                <div class="title mt30">차수관리</div>
                <div class="table_tin01">
	                <div class="px">※  과정관리에서 추가된 과정을 개설할 수 있습니다.</div>
	                <div class="px">※  교육시작일 기준으로 검색을 하여 개설된 정보를 열람할 수 있습니다.</div>
                    <ul>
	                    <li style="position:relative;">
	                        <select id="searchDiv" style="width:100px;" >
	                           <option value="EDU_STIME" >교육시작일</option>
	                           <option value="EDU_ETIME" >교육종료일</option>
	                           <option value="APPLY_STIME" >신청시작일</option>
	                           <option value="APPLY_ETIME" >신청종료일</option>
	                        </select> :
	                        <input type="text" id="searchSdate" style="width:140px; "  /> ~
                            <input type="text" id="searchEdate" style="width:140px; "  />
                            <button id="searchBtn" class="k-button" style="width: 60px;">검색</button>
                            <a href="javascript:void(0);" id="excelDownloadBtn" class="k-button" style="position:absolute;right:287px;">엑셀다운로드</a>
                            <button id="excelUploadBtn" class="k-button" style="position:absolute;right:204px;">엑셀업로드</button>
                            <button id="allDelBtn" class="k-button"  style="position:absolute;right:117px;"><span class="k-icon k-si-minus"></span>일괄삭제</button>
                            <button id="newBtn" class="k-button"  style="position:absolute;right:30px;"><span class="k-icon k-si-plus"></span>차수추가</button>
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
                                <div id="details"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
                                       
<script type="text/x-kendo-template"  id="template"> 
	<div id="tabstrip">
		<ul>
			<li class="k-state-active">과정정보</li>
			<li>차수정보</li>
			<li>교육자료</li>
		</ul>
	<div style="overflow-y:auto;">
		<!-- 과정정보 -->
		<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td class="subject" style="width:100px;"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 과 정 명 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input type="hidden" id="dtl-subjectNum" data-bind="value:SUBJECT_NUM" />
                    <input class="k-textbox" id="SUBJECT_NAME" data-bind="value:SUBJECT_NAME"  style="width:80%;" onKeyUp="chkNull(this);"/>&nbsp;<button id="subjectSearchBtn" class="k-button">과정검색</button>
                    <BR>* 차수추가는 과정검색 버튼을 클릭하여 과정을 선택한 후 진행해주세요.
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 학습유형 <span style="color:red">*</span></label></td>
                <td class="subject">
                        <select id="TRAINING_CODE" data-bind="value:TRAINING_CODE" style="width:200px;" ></select>
                </td>
            </tr>
			<tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 상시학습종류 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <select id="alwStdCd1" data-bind="value:ALW_STD_CD1" style="width:100%; max-width:360px;" ></select><br>
                    <select id="alwStdCd2" data-bind="value:ALW_STD_CD2" style="width:100%; max-width:360px;" ></select><br>
                    <select id="alwStdCd" data-bind="value:ALW_STD_CD" style="width:100%; max-width:360px;" ></select>
                </td>
            </tr>
			<tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육시간 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input id="EDU_HOUR_H" data-bind="value:EDU_HOUR_H" style="width:80px;" /> 시간
                    <input id="EDU_HOUR_M" data-bind="value:EDU_HOUR_M" style="width:80px;" /> 분
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 인정시간 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input id="RECOG_TIME_H" data-bind="value:RECOG_TIME_H" style="width:80px;" /> 시간
                    <input id="RECOG_TIME_M" data-bind="value:RECOG_TIME_M" style="width:80px;" /> 분
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
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기관 <span style="color:red">*</span></label></td>
                <td class="subject">
					<select id="select_nm" data-bind="value:INSTITUTE_CODE" style="width:200px;" ></select><br/>
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
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 부처지정학습 </label></td>
                <td class="subject">
                    <input type="radio" name="deptDesignationYn"  id="deptDesignationY"   value="Y" /> 예</input>
                    <span style="padding-left:40px"><input type="radio" name="deptDesignationYn" id="deptDesignationN"  value="N"/></span> 아니오</input></td>
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
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 평가 및 수료기준</label></td>
                <td class="subject">
                    <textarea class="k-textbox" id="EVL_CMPL" data-bind="value:EVL_CMPL" rows="5"  style="width:100%;"></textarea>
                </td>
            </tr>
        </table>
	</div>

	<div style="overflow-y:auto;">
		<!-- 차수정보 -->
        <table class="tabular" id="tabular1" width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 개설년도 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input type="hidden" id="dtl-openNum" data-bind="value:OPEN_NUM" />
                    <input type="hidden" name="objectId" id="objectId"/>
                    <input id="yyyy" data-bind="value:YYYY" style="width:73px;" />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 차수 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input id="chasu" data-bind="value:CHASU" style="width:60px;" onKeyUp="chkNull(this); chkNum(this);"/>&nbsp;<button id="dup-btn" class="k-button">중복검사</button>
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기간 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input id="EDU_STIME" data-bind="value:EDU_STIME" style="width:140px;" /> ~
                    <input id="EDU_ETIME" data-bind="value:EDU_ETIME" style="width:140px;" />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 신청기간 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input id="APPLY_STIME" data-bind="value:APPLY_STIME" style="width:140px;" /> ~
                    <input id="APPLY_ETIME" data-bind="value:APPLY_ETIME" style="width:140px;" />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 취소마감일 <span style="color:red">*</span></label></td>
                <td class="subject">
                    <input id="CANCEL_ETIME" data-bind="value:CANCEL_ETIME" style="width:140px;" />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 모집정원 </label></td>
                <td class="subject">
                    <input id="APPLICANT" data-bind="value:APPLICANT" style="width:80px;" onKeyUp="chkNull(this); chkNum(this);"/>명
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육일수</label></td>
                <td class="subject">
                    <input id="EDU_DAYS" data-bind="value:EDU_DAYS" style="width:80px;" onKeyUp="chkNull(this); chkNum(this);"/>일
                </td>
            </tr>
        </table>
	</div>
	<div style="overflow-y:auto;">
		<!-- 교육자료 -->
		<div id="my-file-upload" class="hide"></div>
		<div id="my-file-gird"></div>
	</div>
</div>

	<div style="text-align:right;margin-top:10px">
		<button id="addChasuBtn" class="k-button">차수추가</button>&nbsp;
		<button id="closeBtn" class="k-button">폐강처리</button>&nbsp;
		<button id="save-btn" class="k-button">저장</button>&nbsp;
		<button id="delBtn" class="k-button">삭제</button>&nbsp;
		<button id="cancel-btn" class="k-button">취소</button>&nbsp;&nbsp;
	</div>
</script>

    <!-- 과정검색 팝업 -->
    <div id="subjectList-window" style="display:none; overflow-y: hidden;">
        <div style="position: relative;">
            <span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> ※ 개설할 과정을 검색 후 선택하시면 됩니다<br>
            <div id="subjectSearchGrid" ></div>
        </div>
    </div>
    
    <!-- 교육자료 첨부파일 template -->
    <script type="text/x-kendo-tmpl" id="fileupload-template">
        <input name="upload-file" id="upload-file" type="file"/>
    </script>
    
    
    <!-- 차수추가 팝업 -->
    <div id="addSubjectOpen-window" style="display:none; overflow-y: hidden;">
        <div class="table_list" style="position: relative;">
            <table class="addChasuPop" id="addChasuPop" width="100%" cellspacing="0" cellpadding="0">
	            <tr>
	                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 개설년도 <span style="color:red">*</span></label></td>
	                <td class="subject">
	                    <input id="addyyyy" data-bind="value:YYYY" style="width:73px;" />
	                </td>
	            </tr>
	            <tr>
	                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 차수 <span style="color:red">*</span></label></td>
	                <td class="subject">
	                    <input id="addchasu" data-bind="value:CHASU" style="width:60px;" onKeyUp="chkNull(this); chkNum(this);"/>&nbsp;<button id="adddup-btn" class="k-button">중복검사</button>
	                </td>
	            </tr>
	            <tr>
	                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기간 <span style="color:red">*</span></label></td>
	                <td class="subject">
	                    <input id="addEDU_STIME"  style="width:140px;" /> ~
	                    <input id="addEDU_ETIME"  style="width:140px;" />
	                </td>
	            </tr>
	            <tr>
	                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 신청기간 <span style="color:red">*</span></label></td>
	                <td class="subject">
	                    <input id="addAPPLY_STIME"  style="width:140px;" /> ~
	                    <input id="addAPPLY_ETIME"  style="width:140px;" />
	                </td>
	            </tr>
	            <tr>
	                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 취소마감일 <span style="color:red">*</span></label></td>
	                <td class="subject">
	                    <input id="addCANCEL_ETIME"  style="width:140px;" />
	                </td>
	            </tr>
	            <tr>
	                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 모집정원 </label></td>
	                <td class="subject">
	                    <input id="addAPPLICANT" data-bind="value:APPLICANT" style="width:80px;" onKeyUp="chkNull(this); chkNum(this);"/>명
	                </td>
	            </tr>
	            <tr>
	                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육일수</label></td>
	                <td class="subject">
	                    <input id="addEDU_DAYS" data-bind="value:EDU_DAYS" style="width:80px;" onKeyUp="chkNull(this); chkNum(this);"/>일
	                </td>
	            </tr>
	        </table>
	        <div style="text-align:center;margin-top:10px">
                    <button id="addsave-btn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
                    <button id="addcancel-btn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>
                </div>
        </div>
    </div>
    
    <div id="excel-upload-window" style="display:none; width:340px;">
        <form id="excelForm" name="excelForm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-open-excel-upload.do?output=json" enctype="multipart/form-data" >
        ※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
           <div>
               <input name="openUploadFile" id="openUploadFile" type="file" />
               <div style="text-align: right;">
                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/subject_open_upload_template.xls" class="k-button" >차수템플릿다운로드</a>
                    <input type="submit" value="실행" class="k-button" id="uploadBtn"/>
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