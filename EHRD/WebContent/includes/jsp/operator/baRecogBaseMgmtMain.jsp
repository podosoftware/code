<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>교육이수기준관리</title>
<style type="text/css">
	#tabstrip {
        margin: 0px auto;
        height: 100%;
    }
</style>
<script type="text/javascript">               
    yepnope([{
        load: [ 
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js', 
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js'
            ],
        complete: function() {            
              
	        kendo.culture("ko-KR"); 

            //로딩바선언
            loadingDefine();
            
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

				var userGridElement = $("#userGrid");
				userGridOtherHeight = $("#userGrid").offset().top + 20;
				userGridElement.height(winHeight - userGridOtherHeight);
              
				userdataArea = userGridElement.find(".k-grid-content"),
				userGridHeight = userGridElement.innerHeight(),

				userdataArea.height(userGridHeight - 80);
				
	        });

            //브라우저 resize 이벤트 dispatch..
            $(window).resize();
            
	        /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
	        

            //부처지정학습구분 공통코드 조회.
            var dataSource_deptDesignation = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_common_code.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA04" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "string" },
                            TEXT : { type: "string" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
            
            //직급별 이수시간 설정데이터 조회.
            var dataSource_gradeRecogTime = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/grade-recog-base-time-list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return { };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            CHECKED : { type: "string" },
                            GRADE_CD : { type: "string" },
                            GRADE_NM : { type: "string" },
                            TT_CMP_TIME_H : { type: "number" },
                            TT_CMP_TIME_M : { type: "number" }
                        }
                    }
                },
                pageSize : 999,
                serverPaging : false,
                serverFiltering : false,
                serverSorting : false});
	        

            //기관성과평가필수교육 공통코드 조회.
            var dataSource_perfAsse = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_common_code.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA11" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "string" },
                            TEXT : { type: "string" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
	        

            //기관성과평가 필수교육 이수시간 설정데이터 조회.
            var dataSource_perfAsseRecogTime = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/perfasse-recog-base-time-list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return { };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                        	CHECKED : { type: "string" },
                        	DEPT_STND_CD : { type: "string" },
                        	DEPT_STND_NM : { type: "string" }
                        }
                    }
                },
                pageSize : 999,
                serverPaging : false,
                serverFiltering : false,
                serverSorting : false});
            
            
            //기준년도 
            var now = new Date();
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

            
            //부서원별 이수시간 조회 구분값.
            //var userSearchDiv = "YEAR";
            
            //부서원별 이수시간 조회 - 부처지정학습 코드 조회.
            var dataSource_userDivdeptDesignation = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/get-user-dept-designation-code.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  YYYY : removeNullStr( $("#searchYyyy").val() )  };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "string" },
                            TEXT : { type: "string" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false,
                change: function(){
                	userGridDefine();
                }
            });
            //최초화면 로딩시 데이터 패치..
            dataSource_userDivdeptDesignation.fetch();

            //부서원별 이수시간 조회 - 기관성과평가 필수교육 코드 조회.
            var dataSource_userPerfAsse = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/get-user-perf-asse-code.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  YYYY : removeNullStr( $("#searchYyyy").val() )  };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "string" },
                            TEXT : { type: "string" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false,
                change: function(){
                	userGridDefine();
                }
            });
          //최초화면 로딩시 데이터 패치..
            dataSource_userPerfAsse.fetch();
            
            //부서원별 관리 그리드 정의
            var userGridDefine = function(e){
            	$("#userGrid").empty();
            	
            	if(dataSource_userDivdeptDesignation.data().length>0 && dataSource_userPerfAsse.data().length>0){
            		
            		var userGridColumns = []; 
            		userGridColumns.push(
                            {
                                   field : "NAME",
                                   title : "성명",
                                   width : "100px",
                                   headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                   attributes : { "class" : "table-cell", style : "text-align:center" }
                               }
                    );
                    userGridColumns.push(
                            {
                                   field : "DVS_NAME",
                                   title : "부서",
                                   width : "150px",
                                   headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                   attributes : { "class" : "table-cell", style : "text-align:left" }
                               }
                    );
            		userGridColumns.push(
                            {
                                   field : "GRADE_DIV_NM",
                                   title : "직렬",
                                   width : "120px",
                                   headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                   attributes : { "class" : "table-cell", style : "text-align:left" }
                               }
                    );
                    userGridColumns.push(
                            {
                                   field : "GRADE_NM",
                                   title : "직급",
                                   width : "120px",
                                   headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                   attributes : { "class" : "table-cell", style : "text-align:left" }
                               }
                    );
            		userGridColumns.push(
                            {
                                   field : "TT_CMP_TIME_H",
                                   title : "총이수시간",
                                   width : "135px",
                                   filterable: false,
                                   sortable: true,
                                   headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                   attributes : { "class" : "table-cell", style : "text-align:center" },
                                   template: function(data){
                                    var hh = "";
                                    var mm = "";
                                       if(data.TT_CMP_TIME_H != null && data.TT_CMP_TIME_H != ""){
                                        hh = data.TT_CMP_TIME_H;
                                       }
                                       if(data.TT_CMP_TIME_M){
                                           mm = data.TT_CMP_TIME_M;
                                       }
                                       return "<input id=\"userTTH"+data.GRADE_CD+"\" style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+hh+"\" onkeypress=\"return numbersonly(event, false, this, 3); \" onchange=\"setUserRecogTime( this, '"+data.USERID+"', 'TT_CMP_TIME_H' );\" />시간 <input id=\"userTTM"+data.GRADE_CD+"\" style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+mm+"\" onkeypress=\"return numbersonly(event, false, this, 2, 59); \" onchange=\"setUserRecogTime( this, '"+data.USERID+"', 'TT_CMP_TIME_M' );\" />분";
                                   }
                               }
                    );
                    
            		//부처지정구분 코드 컬럼 추가
                    $.each(dataSource_userDivdeptDesignation.data(), function(i,e){
                        var label = this.TEXT;
                        var value = this.VALUE;
                           
                        userGridColumns.push(
                                   {
                                       field : "DD_H"+value,
                                       title : label,
                                       width : "135px",
                                       filterable: false,
                                       sortable: true,
                                       headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                       attributes : { "class" : "table-cell", style : "text-align:center" },
                                       template: function(data){
                                           var hh = "";
                                           var mm = "";
                                           if(data["DD_H"+value]){
                                               hh = data["DD_H"+value];
                                           }
                                           if(data["DD_M"+value]){
                                               mm = data["DD_M"+value];
                                           }
                                           return "<input id=\"userDDH"+data.USERID+"_"+value+"\" style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+hh+"\" onkeypress=\"return numbersonly(event, false, this, 3); \" onchange=\"setUserRecogTime( this, '"+data.USERID+"', 'DD_H"+value+"' );\" />시간 <input id=\"userDDM"+data.USERID+"_"+value+"\" style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+mm+"\" onkeypress=\"return numbersonly(event, false, this, 2, 59); \" onchange=\"setUserRecogTime( this, '"+data.USERID+"', 'DD_M"+value+"' );\"  />분";
                                       }
                                   }
                        );
                    });
            		
            		//기관성과평가 필수교육 코드 컬럼 추가.
                    $.each(dataSource_userPerfAsse.data(), function(i,e){
                        var label = this.TEXT;
                        var value = this.VALUE;
                           
                        userGridColumns.push(
                                   {
                                       field : "PD_H"+value,
                                       title : label,
                                       width : "135px",
                                       filterable: false,
                                       sortable: true,
                                       headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                       attributes : { "class" : "table-cell", style : "text-align:center" },
                                       template: function(data){
                                           var hh = "";
                                           var mm = "";
                                           if(data["PD_H"+value]){
                                               hh = data["PD_H"+value];
                                           }
                                           if(data["PD_M"+value]){
                                               mm = data["PD_M"+value];
                                           }
                                           return "<input style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+hh+"\" onkeypress=\"return numbersonly(event, false, this, 3); \" onchange=\"setUserRecogTime( this, '"+data.USERID+"', 'PD_H"+value+"' );\" />시간 <input style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+mm+"\" onkeypress=\"return numbersonly(event, false, this, 2, 59); \" onchange=\"setUserRecogTime( this, '"+data.USERID+"', 'PD_M"+value+"' );\"  />분";
                                       }
                                   }
                        );
                    });
                    
                    //부서원별 이수시간 그리드 생성
                    $("#userGrid").kendoGrid({
                        dataSource : {
                            type: "json",
                            transport: {
                                read: { 
                                	url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/user-recog-base-time-list.do?output=json", 
                                	type: "POST",
                                	dataType: "json"
                                },
                                parameterMap: function (options, operation){
                                	var sortField = "";
                                	var sortDir = "";
                                	if (options.sort && options.sort.length>0) {
                                		sortField = options.sort[0].field;
                                		sortDir = options.sort[0].dir;
                                    }
                                    return { 
                                    	startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter), YYYY : removeNullStr( $("#searchYyyy").val() ) 
                                    };
                                }
                            },
                            schema: {
                                total : "totalItemCount",
                                data: "items",
                                model: {
                                    fields: {
                                        NAME : { type: "string" },
                                        DVS_NAME : { type: "string" },
                                        GRADE_NM : { type: "string" }
                                    }
                                }
                            },
                            pageSize : 30,
                            serverPaging : true,
                            serverFiltering : true,
                            serverSorting : true},
                        columns : userGridColumns,
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
                        pageable : false,
                        resizable : true,
                        reorderable : true,
                        selectable: "row",
                        pageable : {
                            refresh : false
                            //pageSizes : [10,20,30]  
                        }
                        
                    });
                    
            	}else{
            		if(dataSource_userDivdeptDesignation.data().length ==0 && dataSource_userPerfAsse.data().length == 0){
            			alert($("#searchYyyy").val()+"년도의 설정된 이수시간이 존재하지 않습니다.\n기준에 의한 이수시간을 생성하시려면 부서원별기준생성 버튼을 클릭해주세요.");
            		}
            	}
            };
            
            //년도별 부서원 이수시간 검색 버튼 클릭 시..
            $("#yyyySearchBtn").click(function(){
            	dataSource_userDivdeptDesignation.read();
            	dataSource_userPerfAsse.read();
            });
            
            //저장버튼 클릭 시.
            $("#saveUserBtn").click(function(){
            	//alert($("#searchYyyy").val());
            	if($("#searchYyyy").val()<now.getFullYear()){
            		alert($("#searchYyyy").val()+"년도에 해당하는 데이터를 수정합니다.");
            	}
            	var isSave = confirm("변경한 내용을 저장하시겠습니까?");
                if (isSave) {
                    
                    //로딩바 생성.
                    loadingOpen();

                    var params = {
                            LIST :  $("#userGrid").data("kendoGrid").dataSource.data(),
                            YYYY : $("#searchYyyy").val()
                    };
                    
                    $.ajax({
                        type : 'POST',
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-user-recog-time.do?output=json",
                        data : {
                            item: kendo.stringify( params ), YYYY: $("#searchYyyy").val()
                        },
                        complete : function(response) {
                            //로딩바 제거.
                            loadingClose();
                            
                            var obj = eval("(" + response.responseText + ")");
                            if(obj.error){
                                alert("ERROR=>"+obj.error.message);
                            }else{
                                if (obj.saveCount > 0) {
                                    alert("저장 되었습니다.");
                                    
                                    dataSource_userDivdeptDesignation.read();
                                    dataSource_userPerfAsse.read();
                                } else {
                                    alert("저장을 실패 하였습니다.");
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
            
            //부서원별 기준생성 버튼 클릭 시..
            $("#recogTimeCreatBtn").click(function(){
            	if($("#searchYyyy").val()<now.getFullYear()){
            		alert("이전 년도는 수정할 수 없습니다.");
            		return false;
            	}
                var msg = "";
                if(dataSource_userDivdeptDesignation.data().length ==0 && dataSource_userPerfAsse.data().length == 0){
                	msg = $("#searchYyyy").val()+"년의 이수시간을 기준에 의해 생성하시겠습니까?";
                }else{
                	msg = $("#searchYyyy").val()+"년의 설정된 이수시간을 \n기준에 의한 데이터로 초기화 하시겠습니까? \n직급과 소속 부서의 기준에 의해 전직원의 이수시간이 일괄 변경됩니다.";
                }
                var isSave = confirm(msg);
                if (isSave) {
                    
                    //로딩바 생성.
                    loadingOpen();

                    $.ajax({
                        type : 'POST',
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-all-user-recog-time.do?output=json",
                        data : {
                            YYYY : $("#searchYyyy").val()
                        },
                        complete : function(response) {
                            //로딩바 제거.
                            loadingClose();
                            
                            var obj = eval("(" + response.responseText + ")");
                            if(obj.error){
                                alert("ERROR=>"+obj.error.message);
                            }else{
                                if (obj.saveCount > 0) {
                                    alert("생성 되었습니다.");
                                    
                                    dataSource_userDivdeptDesignation.read();
                                    dataSource_userPerfAsse.read();
                                } else {
                                    alert("저장을 실패 하였습니다.");
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
            
            //직급별 이수시간 기준 관리
            $("#gradeBasicMgmtBtn").click(function(){
                
            	if( !$("#grade-window").data("kendoWindow") ){
                    $("#grade-window").kendoWindow({
                        width:"1100px",
                        height:"500px",
                        resizable : true,
                        title : "직급별 이수시간 기준 관리",
                        modal: true,
                        visible: false,
                        resize: onGradeResize
                    });
                         
                    dataSource_deptDesignation.fetch(function(){
                        if(dataSource_deptDesignation.data().length>0){
                            //테이블 헤더 세팅.
                            $("#deptTr1").append("<td style=\"border: 1px solid; border-color: #CCCCCC; width:450px;\" colspan=\"2\">부처지정학습</td>");
           
                            $.each(dataSource_deptDesignation.data(), function(i,e){
	                             var label = this.TEXT;
	                             var value = this.VALUE;
	                             //$("#deptTr2").append("<td style=\"border: 1px solid; border-color: #CCCCCC; width:150px;\" >"+label+"</td>");
	                             $("#deptTr3").append("<td style=\"border: 1px solid; border-color: #CCCCCC; width:150px;\" ><input type=\"text\" style=\"width:60px; text-align:center; ime-mode:disabled; \" id=\"db_h"+value+"\" onkeypress=\"return numbersonly(event, false, this, 3); \"/>시간 <input type=\"text\" style=\"width:60px; text-align:center; ime-mode:disabled; \" id=\"db_m"+this.VALUE+"\" onkeypress=\"return numbersonly(event, false, this, 2, 59); \" />분</td>");
                            });
                            gradeGridDefine();
                        }
                    });

                    dataSource_gradeRecogTime.fetch(function(){
                     gradeGridDefine();
                    });
                    
                    //직급별 이수시간 입력 그리드 정의
                    var gradeGridDefine = function(e){
                     
                        if(dataSource_deptDesignation.data().length>0 && dataSource_gradeRecogTime.data().length>0){
                            var gradeGridColumns = []; 
                            
                            //선택 체크박스 컬럼 추가.
                            gradeGridColumns.push(
                                 {
                                        field : "CHECKED",
                                        title : "선택",
                                        width : "60px",
                                        filterable: false,
                                        sortable: false,
                                        headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                        attributes : { "class" : "table-cell", style : "text-align:center" },
                                        headerTemplate: "<input id=\"gradeAllChkBox\" type=\"checkbox\" onclick=\"gradeAllCheck(this);\" />",
                                        template: function(data){
                                         return "<input type=\"checkbox\" onclick=\"gradeCheck(this, "+data.GRADE_CD+")\" "+data.CHECKED+"/>";
                                        }
                                    }
                            );
                            gradeGridColumns.push(
                                 {
                                        field : "GRADE_NM",
                                        title : "직급",
                                        width : "180px",
                                        headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                        attributes : { "class" : "table-cell", style : "text-align:left" }
                                    }
                            );
                            gradeGridColumns.push(
                                    {
                                           field : "CD_VALUE1",
                                           title : "직급구분",
                                           width : "180px",
                                           headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                           attributes : { "class" : "table-cell", style : "text-align:left" }
                                       }
                               );
                            gradeGridColumns.push(
                                 {
                                        field : "TT_CMP_TIME_H",
                                        title : "총이수시간",
                                        width : "150px",
                                        filterable: false,
                                        sortable: false,
                                        headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                        attributes : { "class" : "table-cell", style : "text-align:center" },
                                        template: function(data){
                                         var hh = "";
                                         var mm = "";
                                            if(data.TT_CMP_TIME_H != null && data.TT_CMP_TIME_H != ""){
                                             hh = data.TT_CMP_TIME_H;
                                            }
                                            if(data.TT_CMP_TIME_M){
                                                mm = data.TT_CMP_TIME_M;
                                            }
                                            return "<input id=\"gradeTTH"+data.GRADE_CD+"\" style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+hh+"\" onkeypress=\"return numbersonly(event, false, this, 3); \" onchange=\"setGradeRecogTime( this, '"+data.GRADE_CD+"', 'TT_CMP_TIME_H' );\" />시간 <input id=\"gradeTTM"+data.GRADE_CD+"\" style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+mm+"\" onkeypress=\"return numbersonly(event, false, this, 2, 59); \" onchange=\"setGradeRecogTime( this, '"+data.GRADE_CD+"', 'TT_CMP_TIME_M' );\" />분";
                                        }
                                    }
                            );
                         
                            $.each(dataSource_deptDesignation.data(), function(i,e){
                                var label = this.TEXT;
                                var value = this.VALUE;
                                
                                gradeGridColumns.push(
                                        {
                                            field : "DD_H"+value,
                                            title : label,
                                            width : "150px",
                                            filterable: false,
                                            sortable: false,
                                            headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                            attributes : { "class" : "table-cell", style : "text-align:center" },
                                            template: function(data){
                                                var hh = "";
                                                var mm = "";
                                                if(data["DD_H"+value]){
                                                    hh = data["DD_H"+value];
                                                }
                                                if(data["DD_M"+value]){
                                                    mm = data["DD_M"+value];
                                                }
                                                return "<input id=\"gradeDDH"+data.GRADE_CD+"_"+value+"\" style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+hh+"\" onkeypress=\"return numbersonly(event, false, this, 3); \" onchange=\"setGradeRecogTime( this, '"+data.GRADE_CD+"', 'DD_H"+value+"' );\" />시간 <input id=\"gradeDDM"+data.GRADE_CD+"_"+value+"\" style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+mm+"\" onkeypress=\"return numbersonly(event, false, this, 2, 59); \" onchange=\"setGradeRecogTime( this, '"+data.GRADE_CD+"', 'DD_M"+value+"' );\"  />분";
                                            }
                                        }
                                );
                            });
                         
                            //직급별 이수시간 그리드 생성
	                        var gradeGrid = $("#gradeGrid").kendoGrid({
	                            dataSource : dataSource_gradeRecogTime,
	                            columns : gradeGridColumns,
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
	                            pageable : false,
	                            dataBound:function(){
	                            	onGradeResize();
	                            }
	                        }).data("kendoGrid");
                            
	                    }
                     
                     
                    };
                    
                    
                    //직급별 이수시간 일괄적용 버튼 클릭 시..
                    $("#allAdjBtn").click(function(){
                     
	                     var gradeArray = $("#gradeGrid").data("kendoGrid").dataSource.data();
	                     var checkCnt = 0;
	                     $.each(gradeArray, function(i, e){
	                            if(e.CHECKED == "checked"){
	                             checkCnt ++;
	                            }
	                     });
	                     if(checkCnt==0){
	                         alert("일괄적용할 직급을 선택해주세요.");
	                         return false;
	                     }
                     
	                     $.each(gradeArray, function(i, e){
	                         if(e.CHECKED == "checked"){
	                             //연간 총이수시간
	                             var tb_h = "";
	                             var tb_m = "";
	                             if($("#tb_h").val()){ tb_h = $("#tb_h").val(); }
	                                if($("#tb_m").val()){ tb_m = $("#tb_m").val(); }
	                             
	                             e.TT_CMP_TIME_H = tb_h;
	                             $("#gradeTTH"+e.GRADE_CD).val(tb_h);
	                             e.TT_CMP_TIME_M = tb_m;
	                                $("#gradeTTM"+e.GRADE_CD).val(tb_m);
	                                
	                                //부처지정학습 이수시간
	                                $.each(dataSource_deptDesignation.data(), function(j,f){
	                                 var db_h = "";
	                                    var db_m = "";
	                                    if($("#db_h"+f.VALUE).val()){ db_h = $("#db_h"+f.VALUE).val(); }
	                                    if($("#db_m"+f.VALUE).val()){ db_m = $("#db_m"+f.VALUE).val(); }
	                                 
	                                   e["DD_H"+f.VALUE] = db_h;
	                                   $("#gradeDDH"+e.GRADE_CD+"_"+f.VALUE).val( db_h );
	           
	                                      e["DD_M"+f.VALUE] = db_m;
	                                      $("#gradeDDM"+e.GRADE_CD+"_"+f.VALUE).val( db_m );
	                                });
	                         }
	                     });
                   });
                   
                    
                   //직급별이수시간 저장 버튼 클릭
                   $("#saveGradeBtn").click(function(){

                       var isSave = confirm("저장 하시겠습니까?");
                       if (isSave) {
                           
                           //로딩바 생성.
                           loadingOpen();
                           
                           var params = {
                                   LIST :  $("#gradeGrid").data("kendoGrid").dataSource.data()  
                           };
                           
                           $.ajax({
                               type : 'POST',
                               url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-grade-recog-time.do?output=json",
                               data : {
                                   item: kendo.stringify( params )
                               },
                               complete : function(response) {
                                   //로딩바 제거.
                                   loadingClose();
                                   
                                   var obj = eval("(" + response.responseText + ")");
                                   if(obj.error){
                                       alert("ERROR=>"+obj.error.message);
                                   }else{
                                       if (obj.saveCount > 0) {
                                           $("#gradeGrid").data("kendoGrid").dataSource.read();
                                           $("input:checkbox[id='gradeAllChkBox']").attr("checked", false);
                                           alert("저장 되었습니다.");
                                           
                                       } else {
                                           alert("저장을 실패 하였습니다.");
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
                   
            	}else{
            		dataSource_gradeRecogTime.read();
            	}
            	
                $("#grade-window").data("kendoWindow").center();
                $("#grade-window").data("kendoWindow").open();
            });
            
            
            //기관성과평가필수교육별 이수시간 기준 관리
            $("#perfBasicMgmtBtn").click(function(){

            	if( !$("#perf-window").data("kendoWindow") ){
                    $("#perf-window").kendoWindow({
                        width:"1100px",
                        height:"140px",
                        resizable : true,
                        title : "기관성과평가필수교육별 이수시간 기준 관리",
                        modal: true,
                        visible: false,
                        resize: onPerfResize
                    });
                    
                    dataSource_perfAsse.fetch(function(){
                        perfAsseGridDefine();
                    });

                    dataSource_perfAsseRecogTime.fetch(function(){
                        perfAsseGridDefine();
                    });

                    //기관성과평가 필수교육 이수시간 입력 그리드 정의
                    var perfAsseGridDefine = function(e){
                        if(dataSource_perfAsse.data().length>0 && dataSource_perfAsseRecogTime.data().length>0){
                            var perfAsseGridColumns = []; 
                            
                            perfAsseGridColumns.push(
                                    {
                                           field : "DEPT_STND_NM",
                                           title : "부서기준",
                                           width : "120px",
                                           headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                           attributes : { "class" : "table-cell", style : "text-align:left" }
                                       }
                            );
                            
                            $.each(dataSource_perfAsse.data(), function(i,e){
                                var label = this.TEXT;
                                var value = this.VALUE;
                                   
                                perfAsseGridColumns.push(
                                           {
                                               field : "PD_H"+value,
                                               title : label,
                                               width : "150px",
                                               filterable: false,
                                               sortable: false,
                                               headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                                               attributes : { "class" : "table-cell", style : "text-align:center" },
                                               template: function(data){
                                                   var hh = "";
                                                   var mm = "";
                                                   if(data["PD_H"+value]){
                                                       hh = data["PD_H"+value];
                                                   }
                                                   if(data["PD_M"+value]){
                                                       mm = data["PD_M"+value];
                                                   }
                                                   return "<input style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+hh+"\" onkeypress=\"return numbersonly(event, false, this, 3); \" onchange=\"setPerfAsseRecogTime( this, '"+data.DEPT_STND_CD+"', 'PD_H"+value+"' );\" />시간 <input style=\"width:35px; text-align:left; ime-mode:disabled; \" type=\"text\" value=\""+mm+"\" onkeypress=\"return numbersonly(event, false, this, 2, 59); \" onchange=\"setPerfAsseRecogTime( this, '"+data.DEPT_STND_CD+"', 'PD_M"+value+"' );\"  />분";
                                               }
                                           }
                                );
                            });

                            //기관성과평가 필수교육 이수시간 그리드 생성
                            var perfAsseGrid = $("#perfAsseGrid").kendoGrid({
                                dataSource : dataSource_perfAsseRecogTime,
                                columns : perfAsseGridColumns,
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
                                pageable : false
                            }).data("kendoGrid");

                        }
                    };
                    

                    //기관성과평가 필수교육 이수기준 점수 저장..
                    $("#savePerfAsseBtn").click(function(){
                        var isSave = confirm("저장 하시겠습니까?");
                        if (isSave) {
                            
                            //로딩바 생성.
                            loadingOpen();
                            
                            var params = {
                                    LIST :  $("#perfAsseGrid").data("kendoGrid").dataSource.data()  
                            };
                            
                            $.ajax({
                                type : 'POST',
                                url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-perfasse-recog-time.do?output=json",
                                data : {
                                    item: kendo.stringify( params )
                                },
                                complete : function(response) {
                                    //로딩바 제거.
                                    loadingClose();
                                    
                                    var obj = eval("(" + response.responseText + ")");
                                    if(obj.error){
                                        alert("ERROR=>"+obj.error.message);
                                    }else{
                                        if (obj.saveCount > 0) {
                                            $("#perfAsseGrid").data("kendoGrid").dataSource.read();
                                            alert("저장 되었습니다.");
                                            
                                        } else {
                                            alert("저장을 실패 하였습니다.");
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
                    
                    $("#perf-window").resize();
            	}else{
            		dataSource_perfAsseRecogTime.read();
                }
                 
                
                $("#perf-window").data("kendoWindow").center();
                $("#perf-window").data("kendoWindow").open();
            });

            //직급별 이수시간 기준관리 팝업 resize event..
            var onGradeResize = function(e){
            	//직급별이수시간 관리 그리드의 리사이즈 처리..
            	var gradeGridElement = $("#gradeGrid");
                gradeGridElement.height($("#grade-window").innerHeight() - 160);
                gradedataArea = gradeGridElement.find(".k-grid-content"),
                gradeGridHeight = gradeGridElement.innerHeight(),
                gradedataArea.height(gradeGridHeight - 34);
            };
            
            //기관성과평가필수교육별 이수시간 기준관리 팝업 resize event..
            var onPerfResize = function(e){
                //기관성과평가필수교육별이수시간 관리 그리드의 리사이즈 처리..
                var perfGridElement = $("#perfAsseGrid");
                perfGridElement.height($("#perf-window").innerHeight() - 55);
                perfdataArea = perfGridElement.find(".k-grid-content"),
                perfGridHeight = perfGridElement.innerHeight(),
                perfdataArea.height(perfGridHeight - 34);
            };
            


        }
    
    }]);
        
    //엑셀다운로드.. 부서원별 이수시간을 엑셀로 다운로드함..
    function excelDown(button){
	    button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/user-recog-base-time-excel.do?YYYY="+removeNullStr( $("#searchYyyy").val() );
	}
    
    function singleSave(userid){
        
        if($("#runNumber").val()==null || $("#runNumber").val()==""){
            alert("평가를 선택해주세요.");
            return false;
        }
          
        var isDel = confirm(""+name+"님의 데이터를 저장 하시겠습니까?                                        "+name+"님 이외에 저장되지 않은 설정값들은 초기화됩니다.                                                                                                                  ※전체 저장을 원하시면 상단의 저장 버튼을 이용해주세요.  ");
        if(isDel){
            var params = {
                DIVISIONID  : dvsId,
                USERID  : userid,
                JOB : job,
                LEADERSHIP: ldr,
                SELF_WEIGHT : $("#selfWeight_"+userid+"").val(),
                COL_USERID : $("#colUserId_"+userid+"").val().replace("null",""), 
                COL_WEIGHT : $("#colWeight_"+userid+"").val(),
                SUB_USERID : $("#subUserId_"+userid+"").val().replace("null",""), 
                SUB_WEIGHT : $("#subWeight_"+userid+"").val(),
                ONE_USERID : $("#oneUserId_"+userid+"").val().replace("null",""), 
                ONE_WEIGHT : $("#oneWeight_"+userid+"").val(), 
                TWO_USERID : $("#twoUserId_"+userid+"").val().replace("null",""),
                TWO_WEIGHT : $("#twoWeight_"+userid+"").val(),
                RUN_NUM : $("#runNumber").val(),
                CHECKFLAG : $("#singleChkFlag_"+userid+"").val()
            };
            
            $.ajax({
                type : 'POST',
                url:"<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/operator/ca/cmpt_single_target_save_v2.do?output=json",
				data : {
					item : kendo.stringify(params)
				},
				complete : function(response) {
					var obj = eval("(" + response.responseText
							+ ")");
					if (obj.saveCount != 0) {
						setDataSource('N');
						alert("저장되었습니다.");
					} else {
						alert("저장에 실패 하였습니다.");
					}
				},
				error : function(xhr, ajaxOptions, thrownError) {
					alert('xrs.status = ' + xhr.status + '\n'
							+ 'thrown error = ' + thrownError
							+ '\n' + 'xhr.statusText = '
							+ xhr.statusText + '\n세션이 종료되었습니다.');
					sessionout();
				},
				dataType : "json"
			});
			}
		}

		//직급별 이수시간 그리드 전체선택 클릭 시..
		function gradeAllCheck(checkbox) {

			var array = $("#gradeGrid").data("kendoGrid").dataSource.view();
			$.each(array, function(i, e) {
				if (checkbox.checked == true) {
					e.CHECKED = "checked";
				} else {
					e.CHECKED = "";
				}
			});
			$("#gradeGrid").data("kendoGrid").refresh();
		}

		//직급별 이수시간 그리드 체크박스 클릭 시..
		function gradeCheck(checkbox, gradeCd) {
			var array = $('#gradeGrid').data('kendoGrid').dataSource.data();
			var res = $.grep(array, function(e) {
				return e.GRADE_CD == gradeCd;
			});

			if (checkbox.checked == true) {
				res[0].CHECKED = "checked";
			} else {
				res[0].CHECKED = '';
			}
		}

		//직급별 이수시간 입력 시..
		function setGradeRecogTime(obj, gradeCd, column) {
			var array = $('#gradeGrid').data('kendoGrid').dataSource.data();
			var res = $.grep(array, function(e) {
				return e.GRADE_CD == gradeCd;
			});
			res[0][column] = obj.value;
		}

		//기관성과평가 필수교육 이수시간 입력 시..
		function setPerfAsseRecogTime(obj, deptStndCd, column) {
			var array = $('#perfAsseGrid').data('kendoGrid').dataSource.data();
			var res = $.grep(array, function(e) {
				return e.DEPT_STND_CD == deptStndCd;
			});
			res[0][column] = obj.value;
		}
		
		//부서원 이수시간 입력시..
		function setUserRecogTime(obj, userid, column){
			var array = $('#userGrid').data('kendoGrid').dataSource.data();
            var res = $.grep(array, function(e) {
                return e.USERID == userid;
            });
            res[0][column] = obj.value;
		}
	</script>

	
</head>
<body>
	
	<div id="content">
        <div class="cont_body">
            <div class="title mt30">교육이수기준관리</div>
            <div class="table_tin01">
                <div class="px">※ 부서원들의 이수 시간을 관리할 수 있습니다.</div>
            </div>
            <div class="table_zone" >
            
                <ul>
                    <li style="position:relative;">기준년도: 
                        <select id="searchYyyy">
                        </select>
                        <button id="yyyySearchBtn" class="k-button">조회</button>
                   
                        <button id="perfBasicMgmtBtn" class="k-button" style="position:absolute;right:408px;">기관성과평가필수교육별기준관리</button>
                        <button id="gradeBasicMgmtBtn" class="k-button" style="position:absolute;right:303px;">직급별기준관리</button>
                        <a id="lst-excel-btn" class="k-button" onclick="excelDown(this)" style="position:absolute;right:191px;">엑셀 다운로드</a>
                        <button id="recogTimeCreatBtn" class="k-button" style="position:absolute;right:60px;">부서원별기준생성</button>
                        <button id="saveUserBtn" class="k-button" style="position:absolute;right:0;"><span class="k-icon k-i-plus"></span>저장</button>
                    </li>
                </ul>
                  
                <div class="table_list">
                    <div id="userGrid" ></div>
                </div>
                				
            </div>
            
            

	    </div>
    </div>
    
    <div id="grade-window" style="display: none;">
	    <div id="gradeRecogTimeDiv">
		    Step1. 기준시간 셋팅 > Step2. 해당직급선택 > Step3. 일괄적용 클릭 > Step4. 저장
		    <div style="padding-top:10px; ">
		       <table style="text-align: center;" >
		           <tr style="background-color: #F5F5F6;" id="deptTr1">
		               <td style="border: 1px solid; border-color: #CCCCCC; width:150px;" rowspan="2">
		                   년간 총 이수시간
		               </td>
		           </tr>
		           <tr style="background-color: #F5F5F6;" id="deptTr2" >
		           </tr>
		           <tr id="deptTr3">
		               <td style="border: 1px solid; border-color: #CCCCCC; width:150px;" >
		               	<input type="text" class="time_hh" style="width:60px; text-align:center; ime-mode:disabled;" id="tb_h" onkeypress="return numbersonly(event, false, this, 3); "/>시간
		               	<input type="text" class="time_mm" style="width:60px; text-align:center; ime-mode:disabled;" id="tb_m" onkeypress="return numbersonly(event, false, this, 2, 59); "/>분
	               	</td>
		           </tr>
		       </table>
		    </div>
		    <div class="table_btn" style="padding-top: 5px;">
		        <button id="allAdjBtn" class="k-button">일괄적용</button>
		        <button id="saveGradeBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>
		    </div>
		    <div class="table_list">
		        <div id="gradeGrid" ></div>
		    </div>
	    </div>
    </div>

    <div id="perf-window" style="display:none;" >
        <div class="table_list">
            <div id="perfAsseGrid" ></div>
        </div>
        <div class="table_btn" style="padding-top: 5px;">
            <button id="savePerfAsseBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>
        </div>    
    </div>
    
</body>
</html>