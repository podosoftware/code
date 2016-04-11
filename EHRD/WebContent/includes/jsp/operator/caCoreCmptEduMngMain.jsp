<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>핵심역량교육실적관리</title>
<style type="text/css">
</style>
<%
//총괄관리자 권한 여부..
boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
//고객사운영자 권한 여부..
boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
//부서장 권한 여부..
boolean isManager = request.isUserInRole("ROLE_MANAGER");
%>
<script type="text/javascript"> 
var dataSource_divisionList;
var dataSource_gradeList;
var resultList;
var gradeList;
var appResList;
var dataSource_compgroup;
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
                  
	              	//스플릿터 사이즈 재조정..
	              	var splitterElement = $("#splitter");
	              	//스플릿터 top 위치와 footer 높이, padding 30을 합한 높이를 윈도우창 사이즈에서 빼줌.
	              	splitterOtherHeight = $("#splitter").offset().top + $("#footer").outerHeight() + 30; //
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
              //브라우저 resize 이벤트 dispatch..
              $(window).resize();
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
        	
  	      	
  	      	
        	  // list call
        	$("#grid").empty();
        	$("#grid").kendoGrid({
                dataSource: {
                    type: "json",
                    transport: {
                    	 read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/core_cmpt_edu_mng_list.do?output=json", type:"POST" },
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
                     total: "totalItemCount",
                    	data: "items3",
                        model: {
                            fields: {
                            	COMPANYID : { type: "int" },
                            	MJR_CMPT_EDU_PRF_SEQ : { type: "int" },
                            	USERID : { type: "int" },
                            	DIVISIONID : { type: "string" },
                            	GRADE_NM : { type: "string" }
                            }
                        }
                    },
                    pageSize: 30, serverPaging: true, serverFiltering: true, serverSorting: true
                },
                columns: [
                    {
                        field:"ROWNUMBER",
                        title: "연번",
                        filterable: false,
 					    width:20,
 					    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
 	                    attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field: "EVL_NM",
                        title: "평가종류",
 					    width:80,
 					    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                    },
                    {
                        field: "NAME",
                        title: "성명",
 					    width: 50,
 					    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center;text-decoration: underline;"} ,
                        template: function (dataItem) {
                            return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.MJR_CMPT_EDU_PRF_SEQ+");' >"+dataItem.NAME+"</a>";
                        }
                    },
                    {
                        field: "DVS_NAME",
                        title: "현재소속",
                        width: 50,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field: "GRADE_NM",
                        title: "현재직급",
                        width: 50,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field: "EMP_STS_NM",
                        title: "재직상태",
                        width: 30,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field: "THEN_DVS_NM",
                        title: "당시소속",
                        width: 50,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field: "THEN_GRADE_NM",
                        title: "당시직급",
                        width: 50,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field: "EVL_RST",
                        title: "평가결과",
                        width: 30,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field: "EVL_DT",
                        title: "평가일",
                        width: 40,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field: "EDU_PERIOD",
                        title: "사전교육기간",
                        width: 70,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    }
                ],
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
                    pageSizes : [10,20,30],
                    buttonCount : 5
    	        	}
         });
        	//엑셀업로드 버튼 클릭.
            $("#excelUploadBtn").click(function() {
                $('#excel-upload-window').data("kendoWindow").center();
                $("#excel-upload-window").data("kendoWindow").open();
            });

            //엑셀파일업로드 팝업창 정의.. 상단에서 jquery.form.min.js 파일로드 해야함. 
            if (!$("#excel-upload-window").data("kendoWindow")) {
                $("#excel-upload-window").kendoWindow({
                    width : "340px",
                    minWidth : "340px",
                    resizable : false,
                    title : "상시학습관리 엑셀 업로드",
                    modal : true,
                    visible : false
                });
                
                //업로드 버튼 이벤트
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
                                alert("-과정 업로드 결과-\n"+myObj.statement);
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
       	
       	$('#details').show().html(kendo.template($('#template').html()));
      
       	selectBoxControl(); //셀렉트 박스 부분 호출
        numTexBox(); // 날짜 컨트롤
       	// list new btn add click event
      	$("#newBtn").click( function(){
      		
      		kendo.bind($(".tabular"), null);
      		$("#splitter").data("kendoSplitter").expand("#detail_pane");

			$("#delBtn").hide();
			
      	});

      	
		//부서 트리뷰 호출
        $("#deptPopupTreeview").kendoTreeView({
            dataTextField: ["DVS_NAME"],
            dataSource: new kendo.data.HierarchicalDataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-dept-list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){  
                      return {  USEFLAG : "Y" };
                    }         
               },
               schema: {
                   data: "items",
                   model: {
                       fields: {
                           DIVISIONID : { type: "String" },
                           DVS_NAME : { type: "String" },
                         items : { DIVISIONID : { type: "String" }, DVS_NAME : { type: "String" } }
                       },
                       children: "items"
                   }
               },
               serverFiltering: false,
               serverSorting: false}),
	           loadOnDemand: false,
	           change : function (e){
	               var selectedCells = this.select();               
	               var selectedCell = this.dataItem( selectedCells );
	               
	               $("#dtl-dvsid").val(selectedCell.DIVISIONID);
	               $("#dtl-dvs_name").val(selectedCell.DVS_NAME);
	               
	               $("#dept-window").data("kendoWindow").close();
	           }
        });
     
      }

  }]);   

	</script>
	<script type="text/javascript">
	function selectBoxControl(){
        //당시직급
		dataSource_gradeList = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {  STANDARDCODE : "BA15", ADDVALUE: "=== 선택 ===" };
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
      //당시직급
     gradeList = $("#gradeSelect").kendoDropDownList({
             dataTextField: "TEXT",
             dataValueField: "VALUE",
             dataSource: dataSource_gradeList,
             filter: "contains",
             suggest: true
         }).data("kendoDropDownList");
        
     resultList = [{ TEXT: "==선택==", VALUE: "" },{ TEXT: "통과", VALUE: "통과" },{ TEXT: "미통과", VALUE: "미통과" }];
     appResList = $("#appResSelect").kendoDropDownList({
            dataTextField: "TEXT",
            dataValueField: "VALUE",
            dataSource: resultList,
            filter: "contains",
            suggest: true
         }).data("kendoDropDownList");

	}
	function empTreeView(){
		//부서검색 버튼 클릭 시 팝업 창 호출
     	if( !$("#dept-window").data("kendoWindow") ){     

             $("#dept-window").kendoWindow({
                 width:"350px",
                 //minWidth:"250px",
                 resizable : true,
                 title : "부서검색",
                 modal: true,
                 visible: false
             });
          }
         $("#dept-window").data("kendoWindow").center();
         $("#dept-window").data("kendoWindow").open();
	}
	//임직원  추가
	function fn_empInsert(userId,mod){
		var array;
		array = $('#findEmp').data('kendoGrid').dataSource.data();
		var res = $.grep(array, function (e) {
			return e.USERID == userId;
		});
		
		$("#empText").val(res[0].NAME);
		$("#userId").val(res[0].USERID);

		$("#pop04").data("kendoWindow").close();

	}
	
	 function numTexBox(){ //날짜 및 숫자입력 텍스트박스 제어
		 	
	       	var resSco = $("#evlSco").kendoNumericTextBox({
		      		 format: "",
		              min: 0,
		              max: 100,
		              step: 1
		         }).data("kendoNumericTextBox");
	       	
		 var start = $("#eduStart").kendoDatePicker({
			   format: "yyyy-MM-dd",
			   change: function(e) {                    
				   var startDate = start.value(),
                 endDate = end.value();

                 if (startDate) {
                     startDate = new Date(startDate);
                     startDate.setDate(startDate.getDate());
                     end.min(startDate);
                 } else if (endDate) {
                     start.max(new Date(endDate));
                 } else {
                     endDate = new Date();
                     start.max(endDate);
                     end.min(endDate);
                 }
	               			
	           	}
         }).data("kendoDatePicker");

         var end = $("#eduEnd").kendoDatePicker({
      	   format: "yyyy-MM-dd",
      	   change: function(e) {                    
      		   var endDate = end.value(),
	       	        startDate = start.value();
	       	
	       	        if (endDate) {
	       	            endDate = new Date(endDate);
	       	            endDate.setDate(endDate.getDate());
	       	            start.max(endDate);
	       	        } else if (startDate) {
	       	            end.min(new Date(startDate));
	       	        } else {
	       	            endDate = new Date();
	       	            start.max(endDate);
	       	            end.min(endDate);
	       	        }
      	   }
         }).data("kendoDatePicker");
         
         var open = $("#evlDt").kendoDatePicker({
			   format: "yyyy-MM-dd",
			   
         }).data("kendoDatePicker");
         
         start.max(end.value());
         end.min(start.value());
     }

	// 상세보기.
    function fn_detailView(cmptSeq){
    	//$("#grid").data("kendoGrid").dataSource.read(); 
    	
    	var grid = $("#grid").data("kendoGrid");
        var data = grid.dataSource.data();
        
        var res = $.grep(data, function (e) {
	        return e.MJR_CMPT_EDU_PRF_SEQ == cmptSeq;
	    });
	
	    var selectedCell = res[0];
	    
	    var selectedCell;
        for(var i = 0; i<data.length; i++) {
            var dataItem = data[i];
            if(cmptSeq == dataItem.MJR_CMPT_EDU_PRF_SEQ){
            	selectedCell = dataItem;	            	
                  
             var selectRow =  {
            		MJR_CMPT_EDU_PRF_SEQ: selectedCell.MJR_CMPT_EDU_PRF_SEQ,
            		USERID : selectedCell.USERID,
            		DIVISIONID : selectedCell.DIVISIONID,
            		EVL_NM: selectedCell.EVL_NM,     
            		NAME: selectedCell.NAME,
            		DVS_NAME :selectedCell.DVS_NAME, 
            		GRADE_NM: selectedCell.GRADE_NM,             
            		EMP_STS_CD: selectedCell.EMP_STS_CD,           
            		EMP_STS_NM : selectedCell.EMP_STS_NM,           
            		THEN_DVS_NM: selectedCell.THEN_DVS_NM,   
            		THEN_GRADE_NM: selectedCell.THEN_GRADE_NM,
            		GRADE_NUM: selectedCell.GRADE_NUM,
            		EVL_RST: selectedCell.EVL_RST,
            		EVL_SCO: selectedCell.EVL_SCO,
            		EVL_DT: selectedCell.EVL_DT,
            		EDU_ST_DT: selectedCell.EDU_ST_DT,
            		EDU_ED_DT: selectedCell.EDU_ED_DT,
            		EDU_PERIOD: selectedCell.EDU_PERIOD
           	 };
       
          	 // 상세영역 활성화
             $("#splitter").data("kendoSplitter").expand("#detail_pane");
             
             // show detail 
             $('#details').show().html(kendo.template($('#template').html()));        
             selectBoxControl();
             numTexBox();
             kendo.bind( $(".tabular"), selectRow );
                 
           //브라우저 resize 이벤트 dispatch..
             $(window).resize();
            	break;
            } // end if
        } // end for

        if(event.preventDefault){
            event.preventDefault();
        } else {
            event.returnValue = false;
        } 
    }
 	// 저장버튼 클릭 시.
    function fn_save(){

        if ($("#evlNm").val() == "") {
            alert("평가종류를 입력해주세요.");
            $("#evlNm").focus();
            return false;
        }
        if ($("#empText").val() == "") {
            alert("성명을 입력해주세요.");
            $("#empText").focus();
            return false;
        }
        if ($("#dtl-dvs_name").val() == "") {
            alert("당시소속을 입력해주세요.");
            $("#dtl-dvs_name").focus();
            return false;
        }
        if (gradeList.select()==0) {
            alert("당시직급을 입력해주세요.");
            $("#gradeSelect").focus();
            return false;
        }
    	
        if($("#eduStart").val() != ""){
	        if(ex_date("사전교육기간 시작일", "eduStart")==false){
	    		return;
	    	}
        }
        if($("#eduEnd").val() != ""){
		    if(ex_date("사전교육기간 종료일", "eduEnd")==false){
	    		return;
	    	}
        }

        if (confirm("핵심역량교육실적을 저장하시겠습니까?")) {
        	//로딩바생성.
        	loadingOpen();
        	
            var params = {

            };
    	
            $.ajax({
                type : 'POST',          
                url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_core_cmpt_edu_mng_save.do?output=json",
                data : {
                	item: kendo.stringify( params ), 
                	MJR_CMPT_EDU_PRF_SEQ : $("#MJR_CMPT_EDU_PRF_SEQ").val(),
                	USERID : $("#userId").val(),
                    DIVISIONID : $("#dtl-dvsid").val(),
                    GRADE_NM : removeNullStr(gradeList.value()),
                    EVL_RST : removeNullStr(appResList.value()),
                    EVL_SCO : $("#evlSco").val(),
                    EVL_DT : $("#evlDt").val(),
                    EVL_ST_DT : $("#eduStart").val(),
                    EVL_ED_DT : $("#eduEnd").val(),
                    EVL_NM : $("#evlNm").val()
                },
                complete : function( response ){
                	//로딩바 제거.
                    loadingClose();
                    
                    var obj  = eval("(" + response.responseText + ")");
                    if(!obj.error){
                    	if(obj.saveCount > 0){         
                            
                            // 상세영역 활성화
                            $("#splitter").data("kendoSplitter").expand("#detail_pane");
                        
                            // 교욱실적관리 목록 read
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
 	}
 // 저장버튼 클릭 시.
    function fn_delete(){
	 if (confirm("핵심역량교육실적을 삭제하시겠습니까?")) {
        	//로딩바생성.
        	loadingOpen();
            var params = {
            };
            $.ajax({
                type : 'POST',          
                url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_core_cmpt_edu_mng_del.do?output=json",
                data : {
                	item: kendo.stringify( params ), 
                	MJR_CMPT_EDU_PRF_SEQ : $("#MJR_CMPT_EDU_PRF_SEQ").val()
                },
                complete : function( response ){
                	//로딩바 제거.
                    loadingClose();
                    
                    var obj  = eval("(" + response.responseText + ")");
                    if(!obj.error){
                    	if(obj.saveCount > 0){         
                            
                            // 상세영역 활성화
                            $("#splitter").data("kendoSplitter").expand("#detail_pane");
                        
                            // 교욱실적관리 목록 read
                            $("#grid").data("kendoGrid").dataSource.read();
                            
                            kendo.bind( $(".tabular"),  null );
                        
                            // 상세영역 비활성화
                            $("#splitter").data("kendoSplitter").collapse("#detail_pane");
                            
                            alert("삭제되었습니다.");  
                        }else{
                            alert("삭제에 실패 하였습니다. 교육운영자에게 문의해주세요.");
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
 	}
    //취소버튼 클릭
	function fn_cencle(){
	 	kendo.bind( $(".tabular"),  null );
	    $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
	}
	</script>
</head>
<body>
	<!-- START MAIN CONTNET -->
	
	<div id="content">
        <div class="cont_body">
            <!-- 상위 부서 선택 팝업 -->
	        <div id="dept-window" style="display: none;">
		        <div style="width: 100%">
		          <table style="width: 100%">
		            <tr>
		                <td>
		                    <div id="deptPopupTreeview"   style="width: 100%; height: 200px; "></div>
		                </td>
		            </tr>
		          </table>
		        </div>
		    </div>
	        <div class="title mt30">핵심역량교육실적관리</div>
            <div class="table_tin01">
                <div class="px">※ 핵심역량교육실적 정보에 대한 관리가 가능합니다.</div>
                <div class="px">※ 추가를 클릭하여 핵심역량교육실적을 등록하십시오.</div>
                
            </div>
            <div class="table_zone" >
                <div class="table_btn">
                		<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp;
						<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/core_cmpt_edu_mng_excel.do" >엑셀 다운로드</a>&nbsp;
						<button id="excelUploadBtn" class="k-button" >엑셀 업로드</button>&nbsp;
			    		<button id="newBtn" class="k-button" ><span class="k-icon k-i-plus"></span>추가</button>
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
	
	<!-- END MAIN CONTENT  --> 	 
	<footer>
  	</footer>
	 	<script type="text/x-kendo-template"  id="template"> 
			<div>
				<table class="tabular" id="tabular"  cellspacing="0" cellpadding="0" style="width:99.9%">
					<tr width="120px"><td colspan="2" style="font-size:16px;"><strong>핵심역량교육실적</strong>
						<input type="hidden" id="userId" data-bind="value:USERID" style="border:none" readonly="readonly" />
						<input type="hidden" id="MJR_CMPT_EDU_PRF_SEQ" data-bind="value:MJR_CMPT_EDU_PRF_SEQ" style="border:none" readonly="readonly" />
					</td></tr>
					<tr>
				    	<td width="110px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 평가종류<span style="color:red">*</span></td> 
				    	<td class="subject"><input type="text" class="k-textbox" id="evlNm" data-bind="value:EVL_NM" style="width:310px;" onKeyUp="chkNull(this); "  /></td>
			    	</tr>
					<tr>
						<td width="110px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명<span style="color:red">*</span></td> 
						<td class="subject">
							<input type="text" id="empText" class="k-textbox" style="width:305px"; data-bind="value:NAME" readonly/>
							<button  class="k-button wid60 ie7_left" onclick="empPop('emp');"> 찾기</button>
						</td>
					</tr>
				    <tr>
						<td class="subject"><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 당시소속 <span style="color:red">*</span></label></td>
						<td class="subject" colspan="2"><input class="k-textbox" id="dtl-dvs_name" placeholder="" data-bind="value:THEN_DVS_NM" size="40" style="width:305px;" readonly />
							<input type="hidden" id="dtl-dvsid" data-bind="value:DIVISIONID"  />
				        	<button id="deptSearchBtn" class="k-button" onclick="empTreeView();"> 찾기</button>
				        </td>
					</tr>
					
					<tr>
						<td class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 당시직급 <span style="color:red">*</span></td>
						<td  class="subject">
							<select id="gradeSelect" data-bind="value:GRADE_NUM" style="width:310px;" accesskey="w" ></select>
						</td>
					</tr>
					<tr>
						<td class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 평가결과</td>
						<td  class="subject">
							<select id="appResSelect" data-bind="value:EVL_RST" style="width:310px;" accesskey="w" ></select>
						</td>
					</tr>
					<tr>
				    	<td width="110px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 평가점수</td> 
				    	<td class="subject"><input type="number"  id="evlSco" data-bind="value:EVL_SCO" style="width:150px; border:none;" onKeyUp="chkNull(this); "  /></td>
			    	</tr>
					<tr>
				    	<td width="110px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 평가일</td>
				    	<td class="subject"><input type="text"  id="evlDt" data-bind="value:EVL_DT" style="width:150px; border:none" onKeyUp="chkNull(this); "  /></td>
			    	</tr>
					<tr>
				    	<td width="110px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사전교육기간<span style="color:red">*</span></td>
				    	<td class="subject"><input type="text" id="eduStart" data-bind="value:EDU_ST_DT" style="width:150px; border:none;"  /> ~
							 <input type="text" id="eduEnd" data-bind="value:EDU_ED_DT" style="width:150px; border:none"  /></td>
			    	</tr>
				</table>

			</div>
			<div style="text-align:right;margin-top:10px">
                <button id="saveBtn" class="k-button" onclick="fn_save();"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
			    <button id="delBtn" class="k-button" onclick="fn_delete();">삭제</button>&nbsp;
			    <button id="cencelBtn" class="k-button" onclick="fn_cencle();"></span>취소</button>
            </div>	
			
	 		</script>
	 		<div id="excel-upload-window" style="display:none; width:340px;">
	        <form id="excelForm" name="excelForm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/core-cmpt-edu-excel-upload.do?output=json" enctype="multipart/form-data" >
	        		※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
	           <div>
	               <input name="openUploadFile" id="openUploadFile" type="file" />
	               <br>
	               <div style="text-align: right;">
	                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/core_cmpt_upload_edu_template.xls" class="k-button" >템플릿다운로드</a>
	                    <input type="submit" value="실행" class="k-button" id="uploadBtn"/>
	               </div>
	           </div>
	       </form>
	   </div>
<%@ include file="/includes/jsp/user/common/findEmployeePopup.jsp"  %>
	
</body>
</html>