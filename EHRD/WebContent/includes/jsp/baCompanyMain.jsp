<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="mpvaSubpage">
<head>
	<title>고객사관리</title>
	<script type="text/javascript">
	
	var isRgstNo = false; //사업자등록번호 중복확인 체크값
	var isCstmId = false; //고객사ID 중복확인 체크값
	var detailMode = "NEW"; 
	
    yepnope([{
        load: [
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
                'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.default.min.css',
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
            
	        // area splitter
	        var splitter = $("#splitter").kendoSplitter({
	            orientation : "horizontal",
	            panes : [ {
	            	collapsible : true,
	                min : "300px"
	            }, 
	            {
	                collapsible : true,
	                collapsed : true,
	                min : "700px"
	            } ]
	        });
            

	        
	        //grid 세팅
	        $("#grid").empty();
	        $("#grid").kendoGrid({
	        	   dataSource: {
	        		    type: "json",
	                    transport: {
	                    	read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba-company-list.do?output=json", type:"POST" },
	                        parameterMap: function (options, operation){ 
	                        	return {  startIndex: options.skip, pageSize: options.pageSize  };
	                        }        
	                    },
	                    schema: {
	                        total: "totalItemCount",
	                        data: "items",
	                           model: {
	                               fields: {
	                                   COMPANYID : { type: "int" },
	                                   COMPANYNAME : { type: "string" },
	                                   RGST_NO : { type: "string" },
	                                   CTRT_ST_DT : { type: "string" },
	                                   CTRT_ED_DT : { type: "string" },
	                                   CMPT_INFO_ADD_YN : { type: "string" },
	                                   KPI_ADD_YN: { type: "string" },
	                                   CSTM_ID : { type: "string" },
	                                   USERID : { type: "string" },
	                                   NAME : { type: "string" },
	                                   EMPNO : { type: "string" },
	                                   HOME_PG_TYPE : { type: "string" },
	                                   USE_YN : { type: "string" },
	                                   LOGO_FILE_NO : { type: "string" },
	                                   MN_CMT : { type: "string" }
	                               }
	                           }
	                    },
	                    pageSize: 15,
	                    serverPaging: false,
	                    serverFiltering: false,
	                    serverSorting: false
	                },
	                columns: [
	                    {
	                    	field:"COMPANYNAME",
	                        title: "고객사명",
	                        width: 200,
	                        filterable: true,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:left; text-decoration: underline;"},
	                        template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${COMPANYID});' >${COMPANYNAME}</a>"
	                    },
	                    {
	                        field:"CSTM_ID",
	                        title: "고객사ID",
	                        filterable: true,
	                        width:80,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:center"} 
	                    },
	                    {
	                        field: "NAME",
	                        title: "관리자정보",
	                        width:100,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:left"} 
	                    },
                        {
                            field: "USE_YN",
                            title: "사용여부",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"} 
                        },
	                    {
	                        field: "", 
	                        title: "역량관리", 
	                        width:100,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template: "<input type='button' class='k-button k-i-close' style='size:20' value='역량관리' onclick='fn_cmptMgmt(\"${COMPANYID}\", \"${COMPANYNAME}\");'/>"
	                    },
	                    {
	                        field: "",
	                        title: "KPI관리",
	                        width:100,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:center"}, 
	                        template: "<input type='button' class='k-button k-i-close' style='size:20' value='KPI관리' onclick='fn_kpiMgmt(\"${COMPANYID}\", \"${COMPANYNAME}\");'/>"
	                    },
	                    {
	                        field: "",
	                        title: "관리자로그인",
	                        width:100,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:center"} ,
	                        template: "<input type='button' class='k-button k-i-close' style='size:20' value='로그인' onclick='fn_mngLogin(\"${CSTM_ID}\", \"${COMPANYID}\", \"${EMPNO}\");'/>"
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
	                pageable: false,
	                selectable: false  
	            });
	            
	            //상세화면 세팅
	            $('#details').show().html(kendo.template($('#template').html()));
	               
	            //화면 정의...
	            defineView();
        }
    }]);   
    
    // 고객사정보 상세보기.
    function fn_detailView(companyid){
    	var grid = $("#grid").data("kendoGrid");
        var data = grid.dataSource.data();

        var selectedCell;
        for(var i = 0; i<data.length; i++) {
            var dataItem = data[i];
            if(companyid == dataItem.COMPANYID){
            	selectedCell = dataItem;
            	
            	var selectRow =  {
                        MODE : "mod",
                        COMPANYID: selectedCell.COMPANYID,                 
                        COMPANYNAME :selectedCell.COMPANYNAME,         
                        RGST_NO: selectedCell.RGST_NO,   
                        CTRT_ST_DT: selectedCell.CTRT_ST_DT,
                        CTRT_ED_DT: selectedCell.CTRT_ED_DT,
                        CMPT_INFO_ADD_YN: selectedCell.CMPT_INFO_ADD_YN,           
                        KPI_ADD_YN : selectedCell.KPI_ADD_YN,          
                        CSTM_ID : selectedCell.CSTM_ID,   
                        USERID : selectedCell.USERID,       
                        NAME: selectedCell.NAME,     
                        EMPNO : selectedCell.EMPNO,
                        EMAIL : selectedCell.EMAIL,
                        PHONE : selectedCell.PHONE,
                        HOME_PG_TYPE: selectedCell.HOME_PG_TYPE,
                        USE_YN: selectedCell.USE_YN,
                        LOGO_FILE_NO: selectedCell.LOGO_FILE_NO,
                        MN_CMT: selectedCell.MN_CMT,
                        FILE_NAME: selectedCell.FILE_NAME, 
                        FILE_SIZE: selectedCell.FILE_SIZE, 
                        CONTENT_TYPE: selectedCell.CONTENT_TYPE,
                        MN_CMT : selectedCell.MN_CMT
                    };
                       
                    $("#splitter").data("kendoSplitter").expand("#detail_pane");
                       
                    // show detail 
                    $('#details').show().html(kendo.template($('#template').html()));
                       
                    // detail binding data
                    kendo.bind( $("#tabular"), selectRow );
                       
                    $('input:radio[id=cmpt_info_add_yn]:input[value='+selectedCell.CMPT_INFO_ADD_YN+']').attr("checked", true);//역량정보추가여부
                    $('input:radio[id=kpi_add_yn]:input[value='+selectedCell.KPI_ADD_YN+']').attr("checked", true);//kpi추가여부
                    $('input:radio[id=home_pg_type]:input[value='+selectedCell.HOME_PG_TYPE+']').attr("checked", true);//홈페이지유형
                    $('input:radio[id=useFlag]:input[value='+selectedCell.USE_YN+']').attr("checked", true);//사용여부
                          
                    defineView();
                    
                    var files = [
                         { name: selectedCell.FILE_NAME, size: selectedCell.FILE_SIZE, extension: ".doc" }
                         //{ name: "file2.jpg", size: 600, extension: ".jpg" },
                         //{ name: "file3.xls", size: 720, extension: ".xls" },
                     ];
                    /*$("#logofile").kendoUpload({
                        files: files
                    });*/
                       
                    //관리자 암호 입력란 hide처리
                    $("#pwdTr").hide();
                    $("#repwdTr").hide();
                    
                    //사업자등록번호 중복확인 버튼 hide
                    $("#rgstDupBtn").hide();
                    isRgstNo = true;
                    
                    //고객사id 중복확인 버튼 hide
                    $("#cidDupBtn").hide();
                    isCstmId = true;
                    
                    $('#name').attr('readonly', 'readonly');
                    $('#email').attr('readonly', 'readonly');
                    $('#phone').attr('readonly', 'readonly');
                    
                    //상세화면 모드
                    detailMode = "MOD";
                    
                    break;
                    
            } // end if
        } // end for
        
        // template에서 호출된 함수에 대한 이벤트 종료 처리.
        if(event.preventDefault){
            event.preventDefault();
        } else {
            event.returnValue = false;
        } 
    }
    
    //역량관리 팝업
    function fn_cmptMgmt(companyid, companyname){
    	$("#popupComapnyId").val(companyid);
    	
        if( !$("#cmptMgmt-window").data("kendoWindow") ){
            $("#cmptMgmt-window").kendoWindow({
                width:"650px",
                minHeight:"400px",
                resizable : true,
                title : "역량관리",
                modal: true,
                visible: false
            });
        
	        $("#cmptMgmt-window-selecter-grid").empty();
	        $("#cmptMgmt-window-selecter-grid").kendoGrid({
	            dataSource: {
	                type: "json",
	                transport: {
	                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba-company-cmptuse_list.do?output=json", type:"POST" },
	                    parameterMap: function (options, operation){
	                    	 return { COMPANYID : $("#popupComapnyId").val() }
	                    }
	                },
	                schema: {
	                     data: "items",
	                     model: {
	                         fields: {
	                                CMPNUMBER : { type: "number" },
	                                CMPNAME : { type: "string" },
	                                CMPGROUP_STRING : { type: "string" },
	                                CMPGROUP_S_STRING : { type: "string" },
	                                CHK : { type: "string" }
	                            }
	                     }
	                },
	                serverPaging: false, serverFiltering: false, serverSorting: false
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
					    headerTemplate: "선택<br><input type='checkbox' onchange='allCmpSelect(this);' />",
					    template:"<div style=\"text-align:center\"><input type=\"checkbox\" onclick=\"modifyChk(this, #: RNUM #)\" #: CHK #/></div>" 
					},
					{ field:"CMPGROUP_STRING", title: "역량군(대)", filterable: true, width:150, 
	                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    attributes:{"class":"table-cell", style:"text-align:center"} 
		             },
	                { field:"CMPGROUP_S_STRING", title: "역량군(소)", filterable: true, width:150, 
	                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                 },
		             { field:"CMPNAME", title: "역량", filterable: true, 
	                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    attributes:{"class":"table-cell", style:"text-align:center"} 
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
	        
	        //사용역량 취소버튼 클릭
	        $("#cancel-cmpt-btn").bind("click",  function() {
	            $("#cmptMgmt-window").data("kendoWindow").close();
	        });
	        
	        //사용 역량 저장 버튼 클릭
	        $("#saveCmptBtn").click( function (){
	            var isConfirm = confirm("저장하시겠습니까?");
	            if(isConfirm){
	                var params = {
	                        LIST :  $('#cmptMgmt-window-selecter-grid').data('kendoGrid').dataSource.data() 
	                };

	                $.ajax({
	                   type : 'POST',
	                   url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba-company-cmptuse_save.do?output=json",
	                   data : { item: kendo.stringify( params ), COMPANYID : $("#popupComapnyId").val() },
	                   complete : function( response ){
	                       var obj  = eval("(" + response.responseText + ")");
	                       if(obj.saveCount != 0){
	                           $('#cmptMgmt-window-selecter-grid').data('kendoGrid').dataSource.read();
	                           alert("저장되었습니다.");  
	                       }else{
	                           alert("저장에 실패 하였습니다.");
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
        }else{
        	$('#cmptMgmt-window-selecter-grid').data('kendoGrid').dataSource.read();
        }
        
        $("#cmptMgmt-window").data("kendoWindow").center();
        $("#cmptMgmt-window").data("kendoWindow").open();
        
        //회사명 세팅
        $("#companyNameCmptLabel").text(companyname);
        
        
    }

    //kpi관리
    function fn_kpiMgmt(companyid, companyname){
    	$("#popupComapnyId").val(companyid);
    	
        if( !$("#kpiMgmt-window").data("kendoWindow") ){
            $("#kpiMgmt-window").kendoWindow({
                width:"800px",
                minHeight:"400px",
                resizable : true,
                title : "KPI관리",
                modal: true,
                visible: false
            });
        
        
	        $("#kpiMgmt-window-selecter-grid").empty();
	        $("#kpiMgmt-window-selecter-grid").kendoGrid({
	            dataSource: {
	                type: "json",
	                transport: {
	                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba-company-kpiuse_list.do?output=json", type:"POST" },
	                    parameterMap: function (options, operation){
	                         return { COMPANYID : $("#popupComapnyId").val() }
	                    }
	                },
	                schema: {
	                     data: "items",
	                     model: {
	                         fields: {
	                                KPI_NO : { type: "number" },
	                                KPI_NM : { type: "string" },
	                                KPIGROUP_STRING : { type: "string" },
	                                KPIPGROUP_S_STRING : { type: "string" },
	                                EVL_TYPE_STRING : { type: "string" },
	                                EVL_HOW_STRING : { type: "string" },
	                                UNIT_STRING : { type: "string" },
	                                CHK : { type: "string" },
	                                RNUM : { type: "number" }
	                            }
	                     }
	                },
	                serverPaging: false, serverFiltering: false, serverSorting: false
	            },
	            columns: [
	                {
	                    field:"CHK",
	                    title: "선택",
	                    filterable: false,
	                    sortable: false,
	                    width:50,
	                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    headerTemplate: "선택<br><input type='checkbox' onchange='allKpiSelect(this);' />",
	                    attributes:{"class":"table-cell", style:"text-align:center"} ,
	                    template:"<div style=\"text-align:center\"><input type=\"checkbox\" onclick=\"modifyKpiChk(this, #: RNUM #)\" #: CHK #/></div>" 
	                },
	                { field:"KPIGROUP_STRING", title: "지표대분류", filterable: true, width:100, 
	                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    attributes:{"class":"table-cell", style:"text-align:left"} 
	                 },
	                { field:"KPIGROUP_S_STRING", title: "지표소분류", filterable: true, width:100, 
	                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    attributes:{"class":"table-cell", style:"text-align:left"} 
	                 },
	                 { field:"KPI_NM", title: "지표명", filterable: true, width: 400,
	                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    attributes:{"class":"table-cell", style:"text-align:left"} 
	                 },
	                 { field:"EVL_HOW_STRING", title: "관리유형", filterable: true,  width:100, 
	                     headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                     attributes:{"class":"table-cell", style:"text-align:center"} 
	                  },
	                  { field:"UNIT_STRING", title: "단위", filterable: true,  width:100, 
	                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                      attributes:{"class":"table-cell", style:"text-align:center"} 
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
        
	        //사용 역량 저장 버튼 클릭
	        $("#saveKpiBtn").click( function (){
	            var isConfirm = confirm("저장하시겠습니까?");
	            if(isConfirm){
	                var params = {
	                        LIST :  $('#kpiMgmt-window-selecter-grid').data('kendoGrid').dataSource.data() 
	                };

	                $.ajax({
	                   type : 'POST',
	                   url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba-company-kpiuse_save.do?output=json",
	                   data : { item: kendo.stringify( params ), COMPANYID : $("#popupComapnyId").val() },
	                   complete : function( response ){
	                       var obj  = eval("(" + response.responseText + ")");
	                       if(obj.saveCount != 0){
	                           $('#kpiMgmt-window-selecter-grid').data('kendoGrid').dataSource.read();
	                           alert("저장되었습니다.");  
	                       }else{
	                           alert("저장에 실패 하였습니다.");
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
	        
	        //사용역량 취소버튼 클릭
	        $("#cancel-kpi-btn").click(  function() {
	            $("#kpiMgmt-window").data("kendoWindow").close();
	        });
        }else{
        	$('#kpiMgmt-window-selecter-grid').data('kendoGrid').dataSource.read();
        }
        

        
        //회사명 세팅
        $("#companyNameKpiLabel").text(companyname);
        
        $("#kpiMgmt-window").data("kendoWindow").center();
        $("#kpiMgmt-window").data("kendoWindow").open();
        
    }
	//var upload = $("#logofile").data("kendoUpload");

	//역량관리 - 사용할 역량 체크박스 체크/해제 시..
    function modifyChk(checkbox, rows){
        var array = $('#cmptMgmt-window-selecter-grid').data('kendoGrid').dataSource.data();
        
        if(checkbox.checked == true){
            array[rows].CHK = 'checked';
        }else{
            array[rows].CHK = '';
        }
    }
	
    //역량관리 전체선택/해제
    function allCmpSelect(checkbox){
    	var grid = $("#cmptMgmt-window-selecter-grid").data("kendoGrid");
        
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
	
	
	
	//KPI관리 - 사용할 KPI 체크박스 체크/해제 시..
	function modifyKpiChk(checkbox, rows){
        var array = $('#kpiMgmt-window-selecter-grid').data('kendoGrid').dataSource.data();
        
        if(checkbox.checked == true){
            array[rows].CHK = 'checked';
        }else{
            array[rows].CHK = '';
        }
    }
	
    //KPI관리 전체선택/해제
    function allKpiSelect(checkbox){
    	var grid = $("#kpiMgmt-window-selecter-grid").data("kendoGrid");
        
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
    
    
    //화면 정의
	function defineView(){
		//계약시작일
		if( ! $("#ctrt_st_dt").data("kendoDatePicker") ){  
	        var start = $("#ctrt_st_dt").kendoDatePicker({
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
		}

        //계약종료일
        if( ! $("#strt_ed_dt").data("kendoDatePicker")){
	        var end = $("#ctrt_ed_dt").kendoDatePicker({
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
        }

        start.max(end.value());
        end.min(start.value());
        
        /*
        @@@ 첨부파일 세팅 방법 @@@
        object_type = 3 (고정된 값)
        object_id 값은 해당 업무 테이블의 pk가 unique하다면 해당컬럼의 값으로 처리해도됨. 그렇지 않다면 pk의 조합으로 처리해야함.
        
        object_id = 회사번호+실시번호+평가대상자+지표번호
           예 ) 회사번호 1, 실시번호 7, 평가대상자 1500, 지표번호 10 => 17150010
           
        */
        var objectType = 3 ;
        
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
                        template: '#= name # <button style="width:60px; min-width: 50px;" class="k-button" onclick="deleteFile(#=attachmentId#)">삭제</button>' 
                   },
                   { 
                       field: "size",
                       title: "크기(byte)", 
                       format: "{0:##,###}", 
                       width: "100px" 
                   }
                ],
                dataBound: function(e) {
                	var ver = getInternetExplorerVersion();
                    
                	if($("#my-file-gird").data('kendoGrid').dataSource.data().length > 0){
                		if( ( ver > -1) && ( ver < 10 ) ){
                			$('#openUploadWindow').attr("disabled",true);
                        }else{
                        	$("#upload-file").data("kendoUpload").disable();
                        }
                		//getUpload().disable();
                    }else{
                        if( ( ver > -1) && ( ver < 10 ) ){
                        	$('#openUploadWindow').removeAttr("disabled");
                        }else{
                        	$("#upload-file").data("kendoUpload").enable();
                        }
                    	//getUpload().enable();
                    }
                    
                }
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
                        var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#objectId").val() +"&fileType=img" ;
                        var myWindow = window.open(windowUrl, "_blank", "toolbar=no, scrollbars=yes, resizable=yes, top=500, left=500, width=405, height=250");
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
                            }else{
	                        	if(value.extension != ".JPG" && value.extension != ".jpg" 
	                                      && value.extension != ".GIF" && value.extension != ".gif" 
	                                          && value.extension != ".BMP" && value.extension != ".bmp"
	                                              && value.extension != ".PNG" && value.extension != ".png") {
	                                e.preventDefault();
	                                alert("이미지 파일만 선택해주세요.");
	                            }
                            }
                        });
                    }
                    
                });
                $("#my-file-upload").removeClass('hide');
            }
        }
        
        /*
        if( !$('#upload-file').data('kendoUpload') ){
            $("#upload-file").kendoUpload({
                showFileList : false,
                width : 150,
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
                	      if(value.extension != ".JPG" && value.extension != ".jpg" 
                	    		  && value.extension != ".GIF" && value.extension != ".gif" 
                	    			  && value.extension != ".BMP" && value.extension != ".bmp"
                	    				  && value.extension != ".PNG" && value.extension != ".png") {
                	        e.preventDefault();
                	        alert("이미지 파일만 선택해주세요.");
                	      }
                	    });
                }
            });
            $("#upload-file").removeClass('hide');
        }
        */
        
        // dtl cancel btn add click event
        $("#cencelBtn").click( function(){
            kendo.bind( $("#tabular"),  null );
                
            $("#splitter").data("kendoSplitter").toggle("#list_pane", true);
            $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
        });
        

    	// dtl del btn add click event
       	$("#delBtn").click( function(){
       	    
        	var isDel = confirm("삭제 하시겠습니까?");
            if(isDel){
        		var params = {
        			COMPANYID : $("#comapnyId").val(),
        			FLAG : "4",
         		};
        		
        		$.ajax({
        			type : 'POST',
					url:"/admin/ca/ca_common_del.do?output=json",
					data : { item: kendo.stringify( params ) },
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
						if(obj.saveCount != 0){
							//목록 화면 refresh,
                        	$("#grid").data("kendoGrid").dataSource.read();
                        	//화면 접고,
                        	$("#cencelBtn").click();
							alert("삭제되었습니다.");	
						}else{
							alert("삭제에 실패 하였습니다.");
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
        
        //저장버튼 클릭 시
        $("#saveBtn").click( function(){
            if($("#companyname").val()=="") {
                alert("고객사명은 필수입니다.");
                $("#companyname").focus();
                return false;
            }
            if($("#rgst_no").val()=="") {
                alert("사업자등록번호는 필수입니다.");
                $("#rgst_no").focus();
                return false;
            }
            if(!isRgstNo){
                alert("사업자등록번호의 중복체크는 필수입니다.");
                return false;
            }
            if($("#ctrt_st_dt").val()=="" || $("#ctrt_ed_dt").val()==""){
                alert("계약기간은 필수입니다.");
                $("#ctrt_st_dt").focus();
                return false;
            }
            if(!ex_date("계약시작일","ctrt_st_dt")){
                $("#ctrt_st_dt").focus();
                return false;
            }
            if(!ex_date("계약종료일","ctrt_ed_dt")){
                $("#ctrt_ed_dt").focus();
                return false;
            }
            if($("#cstm_id").val()=="") {
                alert("고객사ID는 필수입니다.");
                $("#cstm_id").focus();
                return false;
            }
            if($("#cstm_id").val().length < 2){
                alert("고객사 ID를 최소 2자 이상 입력해주세요.");
                return false;
            }
            if($("#cstm_id").val().toLowerCase() == "www" ){
                alert($("#cstm_id").val()+"는 사용할 수 없는 고객사 ID입니다.");
                return false;
            }
            if(!isCstmId){
                alert("고객사ID의 중복체크는 필수입니다.");
                return false;
            }
            if(detailMode=="NEW"){
	            if($("#pwd").val()=="") {
	                alert("관리자 암호는 필수입니다.");
	                $("#pwd").focus();
	                return false;
	            }
	            if($("#repwd").val()=="") {
	                alert("관리자 암호확인을 필수입니다.");
	                $("#repwd").focus();
	                return false;
	            }
	            if($("#pwd").val() != $("#repwd").val()) {
	                alert("입력한 암호확인이 일치하지 않습니다..");
	                return false;
	            }
            }
            if($("#name").val()=="") {
                alert("관리자 성명은 필수입니다.");
                $("#name").focus();
                return false;
            }
            if($("#email").val()=="") {
                alert("관리자 이메일은 필수입니다.");
                $("#email").focus();
                return false;
            }

            if(!f_checkEmail($("#email").val())) {
                alert("관리자 이메일 형식이 올바르지 않습니다.");
                $("#email").focus();
                return false;
            }
            
            if($("#phone").val()=="") {
                alert("관리자 연락처는 필수입니다.");
                $("#phone").focus();
                return false;
            }
            if(!chkPhone("관리자연락처", "phone")){
            	$("#phone").focus();
            	return false;
            }
            if($("#my-file-gird").data('kendoGrid').dataSource.data().length !=  1){
                alert("고객사로고 파일을 업로드해주세요.");
                return false;
            }
            
            var isDel = confirm("고객사정보를 저장하시겠습니까?");
            if(isDel == true){
                    var params = {
                    		COMPANYID : $("#comapnyId").val(),
                            COMPANYNAME : $("#companyname").val(),
                            RGST_NO : $("#rgst_no").val(),
                            CTRT_ST_DT : $("#ctrt_st_dt").val(),
                            CTRT_ED_DT : $("#ctrt_ed_dt").val(),
                            CMPT_INFO_ADD_YN : $(':radio[id="cmpt_info_add_yn"]:checked').val(),
                            KPI_ADD_YN : $(':radio[id="kpi_add_yn"]:checked').val(),
                            CSTM_ID : $("#cstm_id").val().toLowerCase(),
                            USERID : $("#userid").val(),
                            EMPNO : $("#empno").val(),
                            PWD : $("#pwd").val(),
                            NAME : $("#name").val(),
                            EMAIL : $("#email").val(),
                            PHONE : $("#phone").val(),
                            HOME_PG_TYPE : $(':radio[id="home_pg_type"]:checked').val(),
                            USEFLAG : $(':radio[id="useFlag"]:checked').val(),
                            //LOGO_FILEID: $('#logo_fileid').val(),
                            MN_CMT : $("#mn_cmt").val(),
                            OBJECTID : $("#objectId").val()
                        };
                    
                    $.ajax({
                            type : 'POST',
                            url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba_company_save.do?output=json",
                            data : { item: kendo.stringify( params )},
                            complete : function( response ){
                                var obj  = eval("(" + response.responseText + ")");
                                if(obj.saveCount != 0){
                                	//목록 화면 refresh,
                                	$("#grid").data("kendoGrid").dataSource.read();
                                	//화면 접고,
                                	$("#cencelBtn").click();
                                    alert("저장되었습니다.");  
                                }else{
                                    alert("저장에 실패 하였습니다.");
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
       

        //사업자등록번호 변경 시
        $("#rgst_no").change(function(){
            isRgstNo = false;
            $("#rgstDupBtn").show();
        });
        
        //사업자등록번호 중복확인 버튼 클릭
        $("#rgstDupBtn").click(function(){
            if($("#rgst_no").val() == ""){
                alert("사업자등록번호를 입력해주세요.");
                return false;
            }
            if($("#rgst_no").val().length < 10){
                alert("사업자등록번호를 10자로 입력해주세요.");
                return false;
            }
            
            var params = {
                    RGST_NO : $("#rgst_no").val() 
            };
            $.ajax({
                type : 'POST',
                url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba_rgstno_dupcheck.do?output=json",
                data : { item: kendo.stringify( params ) },
                complete : function( response ){
                    var obj  = eval("(" + response.responseText + ")");
                    if(obj.totalItemCount == 0){
                        alert("사용가능합니다."); 
                        isRgstNo = true;
                        $("#rgstDupBtn").hide();
                    }else{
                        alert("이미 등록된 사업자등록번호입니다.");
                        isRgstNo = false;
                        $("#rgstDupBtn").show();
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
        });
        

        //고객사id 변경 시
        $("#cstm_id").change(function(){
            isCstmId = false;
            $("#cidDupBtn").show();
        });
        
        //고객사id 중복확인 버튼 클릭 시
        $("#cidDupBtn").click(function(){
            if($("#cstm_id").val() == ""){
                alert("고객사 ID를 입력해주세요.");
                return false;
            }
            if($("#cstm_id").val().length < 2){
                alert("고객사 ID를 최소 2자 이상 입력해주세요.");
                return false;
            }
            if($("#cstm_id").val().toLowerCase() == "www" ){
                alert($("#cstm_id").val()+"는 사용할 수 없는 고객사 ID입니다.");
                return false;
            }
            
            var params = {
                    CSTM_ID : $("#cstm_id").val().toLowerCase() 
            };
            $.ajax({
                type : 'POST',
                url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba_cstmid_dupcheck.do?output=json",
                data : { item: kendo.stringify( params ) },
                complete : function( response ){
                    var obj  = eval("(" + response.responseText + ")");
                    if(obj.totalItemCount == 0){
                        alert("사용가능합니다."); 
                        isCstmId = true;
                        $("#cidDupBtn").hide();
                    }else{
                        alert("이미 등록된 ID입니다.");
                        isCstmId = false;
                        $("#cidDupBtn").show();
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
        });
        

        // 추가버튼 클릭 시
        $("#newBtn").click( function(){
            $("#splitter").data("kendoSplitter").expand("#detail_pane");
            
            kendo.bind( $("#tabular"),  null );
            
            //관리자 암호 입력란 show처리
            $("#pwdTr").show();
            $("#repwdTr").show();
            
            //사업자등록번호 중복확인 버튼 show
            $("#rgstDupBtn").show();
            //고객사id 중복확인 버튼 show
            $("#cidDupBtn").show();
            
            //계약기간 초기화
            $("#ctrt_st_dt").val("");
            $("#ctrt_ed_dt").val("");
            
            $('input:radio[id=cmpt_info_add_yn]:input[value=N]').attr("checked", true);//역량정보추가여부
            $('input:radio[id=kpi_add_yn]:input[value=N]').attr("checked", true);//kpi추가여부
            $('input:radio[id=home_pg_type]:input[value=A]').attr("checked", true);//홈페이지유형
            $('input:radio[id=useFlag]:input[value=Y]').attr("checked", true);//사용여부
            
            //첨부파일 그리드 초기화
            $("#my-file-gird").data('kendoGrid').dataSource.data([]);
            //첨부파일 임시objectid 세팅(랜덤 정수로 ...)
            var ranval = Math.floor(Math.random()*1000000000); 
            //alert(ranval);
            $("#objectId").val(ranval);
            
            $('#name').removeAttr('readonly');
            $('#email').removeAttr('readonly');
            $('#phone').removeAttr('readonly');
             
            //상세화면 모드
            detailMode = "NEW";
            
            
            $("#delBtn").hide();
            
        });

        //총괄관리자 정보 조회 및 수정.
        $("#ttAdminBtn").click( function(){
        	if( !$("#ttAdmin-window").data("kendoWindow") ){
                $("#ttAdmin-window").kendoWindow({
                    width:"400px",
                    minHeight:"200px",
                    resizable : true,
                    title : "총괄관리자 정보",
                    modal: true,
                    visible: false
                });
            
                //총괄관리자 저장 버튼 클릭 
                $("#saveTtadminBtn").click( function(){
                	if($("#tt_empno").val()=="") {
                        alert("교직원번호은 필수입니다.");
                        $("#tt_empno").focus();
                        return false;
                    }
                    /*if($("#tt_empno").val().length < 2){
                        alert("교직원번호은 최소 2자 이상 입력해주세요.");
                        $("#tt_empno").focus();
                        return false;
                    }*/
                	if($("#tt_name").val()=="") {
                        alert("성명은 필수입니다.");
                        $("#tt_name").focus();
                        return false;
                    }

                    if($("#tt_phone").val()=="") {
                        alert("연락처는 필수입니다.");
                        $("#phone").focus();
                        return false;
                    }
                    
                    if(!chkPhone("연락처", "tt_phone")){
                        $("#tt_phone").focus();
                        return false;
                    }
                    
                    if($("#tt_email").val()=="") {
                        alert("이메일은 필수입니다.");
                        $("#tt_email").focus();
                        return false;
                    }

                    if(!f_checkEmail($("#tt_email").val())) {
                        alert("이메일 형식이 올바르지 않습니다.");
                        $("#tt_email").focus();
                        return false;
                    }
                    
                    var issave = confirm("총괄관리자 정보를 저장하시겠습니까?");
                    if(issave == true){
                            var params = {
                            		USERID : $("#tt_userid").val(),
                                    EMPNO : $("#tt_empno").val(),
                                    NAME : $("#tt_name").val(),
                                    EMAIL : $("#tt_email").val(),
                                    PHONE : $("#tt_phone").val(),
                                };
                            
                            $.ajax({
                                    type : 'POST',
                                    url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba-mpvaadmin-save.do?output=json",
                                    data : { item: kendo.stringify( params )},
                                    complete : function( response ){
                                        var obj  = eval("(" + response.responseText + ")");
                                        if(obj.saveCount == 1){
                                            alert("저장되었습니다.");  
                                        }else{
                                            alert("저장에 실패 하였습니다.");
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
                
                //총괄관리자 닫기 버튼
                $("#cancel-ttadmin-btn").click( function(){
                	$("#ttAdmin-window").data("kendoWindow").close();
                });
                
                //비밀번호 변경
                $("#change-password-btn").bind('click', function(){
                    if($("#tt_userid").val()=="") {
                    	alert("총괄관리자의 사용자 번호가 존재하지 않습니다.");
                    	return false;
                    }
                    

                    if( !$("#change-password-window").data("kendoWindow") ){        
                        $("#change-password-window").kendoWindow({
                            width:"400px",
                            minWidth:"250px",
                            minHeight:"150px",
                            resizable : false,
                            title: "비밀번호 변경",
                            modal: true,
                            visible: false
                        });
                        

                        $("#update-password-btn").click( function(){
                            
                            if($('#search-text2').val()==""){
                                alert ('비밀번호 확인을 해주세요.') ;
                                return false;
                            }
                            
                            if($('#search-text1').val() != $('#search-text2').val()){
                                alert ('비밀번호가 다릅니다.');
                                $('#search-text2').val("");
                                return false;
                            }
                            
                            if($('#search-text1').val().length<8){
                                alert ('비밀번호는 최소 8 자리 이상으로 입력하여 주십시오.') ;
                                $('#search-text1').val("");
                                $('#search-text2').val("");
                                return false;
                            }
                               
                            var isDel = confirm("비밀번호를 변경하시겠습니까?");
                             if(isDel){
                            
                            $.ajax({
                                type : 'POST',
                                url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/save-mpvaadmin-pwd.do?output=json",
                                data : { NEW_PWD : $('#search-text1').val() },
                                success : function( response ){
                                    
                                    alert("저장되었습니다.");
                                    
                                    $("#search-text1").val("");
                                    $("#search-text2").val("");
                                    $("#change-password-window").data("kendoWindow").close();                                                                               
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
                        
                    
                        $("#close-update-window-btn").click( function() {
                            $("#change-password-window").data("kendoWindow").close();     
                            $("#search-text1").val("");
                            $("#search-text2").val("");
                        });
                    }
                    $('#change-password-window').data("kendoWindow").center();      
                    $("#change-password-window").data("kendoWindow").open();
                    $("#search-text1").focus();
                    
                    /*
                    if( !$("#pwd-window").data("kendoWindow") ){
                        $("#pwd-window").kendoWindow({
                            width:"340px",
                            height: "200px",
                            resizable : true,
                            title : "비밀번호 변경",
                            modal: true,
                            visible: false
                        });

                        //저장버튼 클릭
                        $("#savePwdBtn").click(  function() {
                        	if($("#pwd").val()==""){
                                alert("현재 비밀번호를 입력해주세요.");
                                return false;
                            }
                            if($("#newpwd").val()==""){
                                alert("새비밀번호를 입력해주세요.");
                                return false;
                            }
                            if($("#newpwdC").val()==""){
                                alert("새비밀번호 확인를 입력해주세요.");
                                return false;
                            }
                            if($("#newpwd").val().length < 8){
                                alert("비밀번호는 8자리 이상 입력해주세요.");
                                return false;
                            }
                            if($("#newpwd").val() != $("#newpwdC").val()){
                                alert("새비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                                return false;
                            }
                            
                            if(confirm("비밀번호를 변경하시겠습니까?")){
                                
                                $.ajax({
                                    type : 'POST',
                                    url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/save-my-pwd.do?output=json",
                                    data : { OLD_PWD : $("#pwd").val(), NEW_PWD : $("#newpwd").val() },
                                    complete : function( response ){
                                        if(response.responseText){
                                            var obj  = eval("(" + response.responseText + ")");
                                            if(obj!=null){
                                                if(obj.statement!=null){
                                                    
                                                    if(obj.statement=="Y"){
                                                        alert("비밀번호가 변경되었습니다.");
                                                        $("#pwd-window").data("kendoWindow").close();
                                                    }else if(obj.statement=="N"){
                                                        alert("비밀번호 변경이 실패하였습니다.");
                                                    }else{
                                                        alert("비밀번호를 정확하게 입력해주세요.");
                                                    }
                                                    
                                                }
                                                
                                                if(event.preventDefault){
                                                    event.preventDefault();
                                                } else {
                                                    event.returnValue = false;
                                                };
                                            }
                                        }
                                    },
                                    error: function( xhr, ajaxOptions, thrownError){
                                        alert('xrs.status = ' + xhr.status + '\n' + 
                                                 'thrown error = ' + thrownError + '\n' +
                                                 'xhr.statusText = '  + xhr.statusText + '\n' );
                                        
                                        if(event.preventDefault){
                                            event.preventDefault();
                                        } else {
                                            event.returnValue = false;
                                        };
                                    },
                                    dataType : "json"
                                });
                            }
                        });
                        //취소버튼 클릭
                        $("#cancelPwdBtn").click(  function() {
                            $("#pwd-window").data("kendoWindow").close();
                        });
                    }

                    $("#pwd-window").data("kendoWindow").center();
                    $("#pwd-window").data("kendoWindow").open();
                    */
                });
                
                
            }else{
                //$('#ttAdmin-window-selecter-grid').data('kendoGrid').dataSource.read();
            }
            
        	
        	
        	$.ajax({
                type : 'POST',
                url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba-mpvaadmin-info.do?output=json",
                data : {},
                complete : function( response ){
                    var obj  = eval("(" + response.responseText + ")");
                    
                    if(obj.items != null){
                        
                        if(obj.items[0].USERID!=null ){
                            $("#tt_userid").val(obj.items[0].USERID);
                        }
                        if(obj.items[0].EMPNO!=null ){
                            $("#tt_empno").val(obj.items[0].EMPNO);
                        }
                        if(obj.items[0].NAME !=null){
                        	$("#tt_name").val(obj.items[0].NAME);
                        }
                        if(obj.items[0].PHONE !=null){
                            $("#tt_phone").val(obj.items[0].PHONE);
                        }
                        if(obj.items[0].EMAIL!=null){
                            $("#tt_email").val(obj.items[0].EMAIL);
                        }
                        
                    }else{
                        alert("정보 조회에 실패 하였습니다.");
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
        	
            $("#ttAdmin-window").data("kendoWindow").center();
            $("#ttAdmin-window").data("kendoWindow").open();
        });
        
        
	} //end function..
	
	//숫자만 입력
	function numbersonly(e, decimal) {
	    var key;
	    var keychar;
	
	    if (window.event) {  //익스와 파폭 체크 !
	        key = window.event.keyCode;
	    } else if (e) {
	        key = e.which;
	    } else {
	        return true;
	    }
	    keychar = String.fromCharCode(key);
	
	    if ((key == null) || (key == 0) || (key == 8) || (key == 9) || (key == 13) || (key == 27)) {
	        return true;
	    } else if ((("0123456789").indexOf(keychar) > -1)) {
	        return true;
	    } else if (decimal && (keychar == ".")) {
	        return true;
	    } else
	        return false;
	}
	

    function handleCallbackUploadResult(){
        $("#my-file-gird").data('kendoGrid').dataSource.read();             
    }

    function getInternetExplorerVersion() {    
        var rv = -1; // Return value assumes failure.    
        if (navigator.appName == 'Microsoft Internet Explorer') {        
             var ua = navigator.userAgent;        
             var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");        
             if (re.exec(ua) != null)            
                 rv = parseFloat(RegExp.$1);    
            }    
        return rv; 
   }

	function attachClickHandler(e)
	{
	    if($("#my-file-gird").data('kendoGrid').dataSource.data().length > 0){
	    	alert("기 등록된 로고를 삭제 후 다시 업로드 해주세요.");
	    	return false;
	    }
	}
	
    //첨부파일 삭제.
    function deleteFile (attachmentId){
        if(confirm("첨부파일을 삭제 하시겠습니까?")){
            $.ajax({
                type : 'POST',
                url : '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json' ,
                data:{ attachmentId : attachmentId },
                success : function(response){
                	handleCallbackUploadResult();
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
    }
    
    
    //고객사운영자 로그인
    function fn_mngLogin(cstm_id, companyid, empno){
    	if(cstm_id==null || cstm_id==""){
    		alert("고객사 교직원번호가 존재하지 않습니다.");
    		return false;
    	}
    	if(companyid==null || companyid==""){
            alert("고객사번호가 존재하지 않습니다.");
            return false;
        }
    	if(cstm_id==null || cstm_id==""){
            alert("관리자 교직원번호가 존재하지 않습니다.");
            return false;
        }
    	//window.open("http://"+cstm_id+".mpvasystem.co.kr/accounts/sso/ssologin.do?ssoflag=Y&companyid="+companyid+"&empno="+empno, "mpvasystem")
    	window.open("http://localhost:8080/accounts/sso/ssologin.do?ssoflag=Y&companyid="+companyid+"&empno="+empno, "mpvasystem")
    }
    
    </script>

</head>
<body >
    <div id="content">
        <div class="cont_body">
            <div class="title mt30">고객사관리</div>
            <div class="table_zone" >
                <div class="table_btn">
                    <button id="ttAdminBtn" class="k-button" >총괄관리자 정보</button>
                    <a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba_company_list_excel.do" >엑셀 다운로드</a>&nbsp
                    <button id="newBtn" class="k-button" ><span class="k-icon k-i-plus"></span>추가</button>
                </div>
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
	
	<script type="text/x-kendo-template" id="template"> 
        <form id="frm" name="frm" method="post" enctype="multipart/form-data" onsubmit="return false;" >
            <input type="hidden" id="popupComapnyId" />
            
    	    <table class="tabular" id="tabular" summary="" width="100%" cellspacing="0" cellpadding="0">
                <tr>
                    <td colspan="2" style="font-size:16px;">
                        <strong>&nbsp; 고객사관리 </strong>
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 고객사명 <span style="color:red">*</span></td> 
                    <td class="subject">
                        <input type="text" class="k-textbox" id="companyname" data-bind="value:COMPANYNAME" style="width:95%;" onKeyUp="chkNull(this);" />
                        <input type="hidden" id="comapnyId" data-bind="value:COMPANYID" style="border:none" />
                        <input type="hidden" id="cudMode" data-bind="value:MODE" style="border:none" />
                        <input type="hidden" name="objectId" id="objectId" data-bind="value:COMPANYID"/>
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사업자등록번호 <span style="color:red">*</span></td> 
                    <td class="subject">
                        <input type="text" class="k-textbox" id="rgst_no" data-bind="value:RGST_NO" style="width:200px; ime-mode:disabled;" onKeyUp="chkNull(this); chkNum(this);" maxLength="10"/>
                        <button id="rgstDupBtn" class="k-button">중복확인</button>
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 계약기간 <span style="color:red">*</span></td> 
                    <td class="subject">
                        <input type="text" id="ctrt_st_dt" data-bind="value:CTRT_ST_DT" style="width:120px; border:none"  /> ~
                        <input type="text" id="ctrt_ed_dt" data-bind="value:CTRT_ED_DT" style="width:120px; border:none"  />
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 역량정보추가여부</td> 
                    <td class="subject">
                        <input type="radio" id="cmpt_info_add_yn" name="cmpt_info_add_yn"  value="Y" checked="checked" />Y</input>
                        <input type="radio" id="cmpt_info_add_yn" name="cmpt_info_add_yn"  value="N"/>N</input>
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> KPI추가여부</td> 
                    <td class="subject">
                        <input type="radio" id="kpi_add_yn" name="kpi_add_yn"  value="Y" checked="checked" />Y</input>
                        <input type="radio" id="kpi_add_yn" name="kpi_add_yn"  value="N"/>N</input>
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 고객사ID <span style="color:red">*</span></td> 
                    <td class="subject">
                        <input type="text" class="k-textbox" id="cstm_id" data-bind="value:CSTM_ID" style="width:200px; ime-mode:disabled;" onKeyUp="chkNull(this); isEng(this); " maxLength="20"/>
                        <button id="cidDupBtn" class="k-button">중복확인</button>
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리자 교직원번호 <span style="color:red">*</span></td> 
                    <td class="subject">
                        <input type="hidden" id="userid"  data-bind="value:USERID" />
                        <input type="text" class="k-textbox" id="empno" data-bind="value:CSTM_ID" style="width:200px;" readOnly />
                        고객사ID와 동일하게 자동입력됨.
                    </td>
                </tr>
                <tr id="pwdTr">
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리자 암호 <span style="color:red">*</span></td> 
                    <td class="subject">
                        <input type="password" class="k-textbox" id="pwd" data-bind="value:PASSWORD" style="width:200px;"  /> 영문과 숫자로만 입력해주세요.
                    </td>
                </tr>
                <tr id="repwdTr">
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리자 암호확인 <span style="color:red">*</span></td> 
                    <td class="subject">
                        <input type="password" class="k-textbox" id="repwd" style="width:200px;"  />
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리자 성명 <span style="color:red">*</span></td> 
                    <td class="subject">
                        <input type="text" class="k-textbox" id="name" data-bind="value:NAME" style="width:200px;" maxLength="10" />
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리자 이메일 <span style="color:red">*</span></td> 
                    <td class="subject">
                        <input type="email" class="k-textbox" id="email" data-bind="value:EMAIL" style="width:200px;" maxLength="100" onKeyUp="chkNull(this); isEng(this);"  />
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리자 연락처 <span style="color:red">*</span></td> 
                    <td class="subject">
                        <input type="text" class="k-textbox" id="phone" data-bind="value:PHONE" style="width:200px; ime-mode:disabled;" maxLength="12" onKeyUp="chkNull(this); chkNum (this);"  />
                                '-' 제외
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 홈페이지유형</td> 
                    <td class="subject">
                        <input type="radio" id="home_pg_type" name="home_pg_type"  value="A" checked="checked" />A type</input> <span class="orange01">&nbsp;</span>
                        <input type="radio" id="home_pg_type" name="home_pg_type"  value="B"/>B type</input> <span class="green01">&nbsp;</span>
                        <input type="radio" id="home_pg_type" name="home_pg_type"  value="C" />C type</input> <span class="blue01">&nbsp;</span>
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 회사코멘트</td> 
                    <td class="subject">
                        <input type="text" class="k-textbox" id="mn_cmt" data-bind="value:MN_CMT" style="width:100%;" maxLength="50" />
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 고객사로고 <span style="color:red">*</span></td> 
                    <td class="subject">
                        
                        <div id="my-file-upload" class="hide"></div>
                        <div id="my-file-gird"></div>

                        * 로고는 세로를 최대 40 픽셀 이하로 해야하며, 배경을 투명하게 제작하시고 png파일로 업로드 해야 합니다. 사이즈가 맞지 않으면 로고가 깨져서 보일 수 있습니다.
                    </td>
                </tr>
                <tr>
                    <td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부</td> 
                    <td class="subject">
                        <input type="radio" id="useFlag" name="useFlag"  value="Y" checked="checked" />사용</input> &nbsp; <input type="radio" id="useFlag" name="useFlag"  value="N"/>미사용</input>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: right">
                        <button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
						<button id="delBtn" class="k-button">삭제</button>&nbsp;
                        <button id="cencelBtn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>
                    </td>
                </tr>

		    </table>
        </form>
    </script>
    
    <script type="text/x-kendo-tmpl" id="fileupload-template">
        <input name="upload-file" id="upload-file" type="file"/>
    </script>
<style>    
#my-file-gird{
    min-height: 100px;              
    width : 100%;
}
</style>
        <!-- 역량관리 팝업 -->
        <div id="cmptMgmt-window" style="display:none;">
            ※ 고객사별 역량을 관리합니다.<br>
            ※ 해당 고객사에서 사용할 역량을 선택 후 저장을 클릭하십시오.<br><br>
                ▪ 고객사명 :  <span id="companyNameCmptLabel"></span>
            <div id="cmptMgmt-window-selecter">
                <div id="cmptMgmt-window-selecter-grid"></div>
            </div>

            <table width="100%" cellspacing="0" cellpadding="0">
                 <tr>
                    <td align="center">
                     <button id="saveCmptBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>
                     <a class="k-button" id="cancel-cmpt-btn"><span class="k-icon k-i-cancel"></span>닫기</a>
                    </td>
                 </tr>
             </table>
        </div>
        
        <!-- KPI관리 팝업 -->
        <div id="kpiMgmt-window" style="display:none;">
            ※ 고객사별 KPI를을 관리합니다.<br>
            ※ 해당 고객사에서 사용할 KPI를선택 후 저장을 클릭하십시오.<br><br>
                ▪ 고객사명 :  <span id="companyNameKpiLabel"></span>
            <div id="kpiMgmt-window-selecter">
                <div id="kpiMgmt-window-selecter-grid"></div>
            </div>

            <table width="100%" cellspacing="0" cellpadding="0">
                 <tr>
                    <td align="center">
                     <button id="saveKpiBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>
                     <a class="k-button" id="cancel-kpi-btn"><span class="k-icon k-i-cancel"></span>닫기</a>
                    </td>
                 </tr>
             </table>
        </div>
        
        <!-- 총괄관리자 정보 팝업 -->
        <div id="ttAdmin-window" style="display:none;">
            <table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
                <tr style="height:40px;">
                    <td ><label for="tt_empno" class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;번 <span style="color:red">*</span></label></td>
                    <td >
                        <input type="hidden" id="tt_userid" name="tt_userid" />
                        <input class="k-textbox" id="tt_empno" style="width:80%; ime-mode:disabled;" onKeyUp="chkNull(this); isEng(this);" maxLength="20" />
                    </td>
                </tr>
                <tr style="height:40px;">
                    <td  style="width:80px;"><label class="right inline required" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명 <span style="color:red">*</span></label></td>
                    <td >
                        <input class="k-textbox" id="tt_name" onKeyUp="chkNull(this);" maxlength="15" style="width:100px;">
                    <button id="change-password-btn" class="k-button">비밀번호변경</button>
                    </td>
                </tr>
                <tr style="height:40px;">
                    <td ><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 연&nbsp;락&nbsp;처 <span style="color:red">*</span></label></td> 
                    <td  colspan="2"><input class="k-textbox" id="tt_phone" maxlength="11" style="width:110px;ime-mode:disabled;" onkeyup="chkNull(this); chkNum (this);">
                        &nbsp;ex)&nbsp;0212345678 "-" 없이 입력
                    </td>
                </tr>
                <tr style="height:40px;">
                    <td ><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 이&nbsp;메&nbsp;일 <span style="color:red">*</span></label></td> 
                    <td  colspan="2"><input type="email" class="k-textbox" id="tt_email" onKeyUp="chkNull(this);" style="width:80%;ime-mode:disabled;" /></td>
                </tr>
            </table>
            <table width="100%" cellspacing="0" cellpadding="0">
                 <tr style="height:40px;">
                    <td align="center">
                     <button id="saveTtadminBtn" class="k-button"><span class="k-icon k-i-plus"></span> 저장</button>
                     <a class="k-button" id="cancel-ttadmin-btn"><span class="k-icon k-i-cancel"></span> 닫기</a>
                    </td>
                 </tr>
             </table>
        </div>
        
        <div id="change-password-window" style="display:none; width:370px;">
        <table class="tabular" width="100%">
            <tbody>
                <tr>
                    <td>새 비밀번호</td>
                    <td><input type="password"  id="search-text1" validationMessage="비밀번호를 입력하여 주세요."  class="k-textbox" style="width:200px;" /></td>
                </tr>
                <tr>
                    <td>새 비밀번호 확인</td>
                    <td><input type="password"  id="search-text2" class="k-textbox" validationMessage="비밀번호를 입력하여 주세요." style="width:200px;" /></td>
                </tr>
                <tr>
                    <td colspan=2 class="right">
                    <br/>
                    <a class="k-button" id="update-password-btn"><span class="k-icon k-i-plus"></span>저장</a> &nbsp;  
                    <a class="k-button" id="close-update-window-btn"><span class="k-icon k-i-cancel"></span>취소</a></td>
                </tr>
            </tbody>
        </table>
    </div>
        <!-- 비밀번호 변경 -->
		<div id="pwd-window" style="display:none;">
		    <div class="layer_cont">
		        <div class="layer_text">
		            <div class="sub_title01"><span>현재 비밀번호</span><input type="password" class="k-textbox" id="pwd" style="width:150px; height:22px; padding:0 0 0 0;"  /></div>
		            <div class="sub_title01"><span>새비밀번호</span><input type="password" class="k-textbox" id="newpwd" style="width:150px; height:22px; padding:0 0 0 0;"  /></div>
		            <div class="sub_title01"><span>새비밀번호 확인</span><input type="password" class="k-textbox" id="newpwdC" style="width:150px; height:22px; padding:0 0 0 0;"  /></div>
		        </div>
		        <div style="text-align:center">
		            <button id="savePwdBtn" class="k-button" >확인</button>
		            <button id="cancelPwdBtn" class="k-button" >취소</button>
		        </div>
		    </div>
		</div>
</body>
</html>