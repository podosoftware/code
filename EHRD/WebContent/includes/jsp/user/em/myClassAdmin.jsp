<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}

kr.podosoft.ws.service.em.action.EmMainAction action = (kr.podosoft.ws.service.em.action.EmMainAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

//총괄관리자 권한 여부..
boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
//고객사운영자 권한 여부..
boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
//부서장 권한 여부..
boolean isManager = request.isUserInRole("ROLE_MANAGER");

%>
<html decorator="subpage">
<head>
<title></title>
<style>
    .k-dropzone {
        position: relative; 
        width : 378px;
        height: 32px;
    }
    .k-upload-empty{
     	width : 399px;
        height: 32px;
    }
    #my-file-upload{
    	width : 399px;
        height: 32px;
    }
    #my-file-gird{
    	min-height : 70px;
    }
    .k-upload-empty{
   	 width : 330px;
    }
</style>

<script type="text/javascript">
var loginUserInfo= <%=action.getUser().getUserId()%>;
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

yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.<%=theme%>.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
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
                var splitterElement = $("#splitter4");
                
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
          
            //로딩바 선언..
            loadingDefine();
            
            
          // show detail 
          $('#detail_info').show().html(kendo.template($('#template').html()));      
          //년도 받아오기
           var yyyyDataSource = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/alw_year_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){ 
                     return { };
                    }        
                },
                schema: {
                    data: "items",
                    model: {
                           fields: {
                               YYYY: { type: "string" }
                           }
                       }
                }
            });
            
          //요청년도 콤보박스
          var yyyy = $("#yyyy").kendoDropDownList({
              dataTextField: "TEXT",
              dataValueField: "YYYY",
              dataSource: yyyyDataSource,
              filter: "contains",
              suggest: true,
              index: 0,
              width: 120,
              change: function() {
                  //runFilter();
            	  $("#grid").data("kendoGrid").dataSource.read();
               },
               dataBound:function(e){
                   if(yyyyDataSource.data().length>0){
                       //runFilter();
                	   $("#grid").data("kendoGrid").dataSource.read();
                   }
               }
          }).data("kendoDropDownList");
          
          //요청 년도 필터
          function runFilter(){
    	        if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
    	            $("#grid").data("kendoGrid").dataSource.filter({
    	                "field":"YYYY",
    	                "operator":"eq",
    	                "value":Number($("#yyyy").val())
    	            });
    	        }else{
    	            $("#grid").data("kendoDropDownList").dataSource.filter({});
    	        }
    	    }
         
          
          
          
            // area splitter
            var splitter = $("#splitter4").kendoSplitter({
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

            //개설년도
            var dtl_yyyy = $("#dtl_yyyy").kendoNumericTextBox({
                format: "",
                min: 1980,
                max: now.getFullYear() + 1,
                step: 1
            }).data("kendoNumericTextBox");
            //개설년도 초기값 설정.
            dtl_yyyy.value(now.getFullYear());
          
          //취득점수
            var TT_GET_SCO = $("#TT_GET_SCO").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 100000,
                step: 1
            }).data("kendoNumericTextBox");
            
            //역량 콤보박스 datasource
            var compDataSource = new kendo.data.DataSource({
                   type: "json",
                   transport: {
                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_competency_combo_list.do?output=json", type:"POST" },
                       parameterMap: function (options, operation){   
                          return { };
                       }      
              },
              schema: {
                  data: "items",
                  model: {
                      fields: {
                         VALUE : { type: "String" },
                         TEXT : { type: "String" },
                         CMPGROUP : { type : "String" }
                      }
                  }
              },
              serverFiltering: false,
              serverSorting: false});
            
	        //상시학습 목록 그리드 생성
	        $("#grid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/alw-admin-list.do?output=json",
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
                            	startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter), year: removeNullStr(yyyy.value())
                            };
	                    }
	                    
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        id : "SUBJECT_NUM",
	                        fields : {
	                            SUBJECT_NUM : {
	                                type : "number"
	                            },
	                            SUBJECT_NM : {
	                                type : "string"
	                            },
	                            TRAINING_CODE : {
	                                type : "string"
	                            },
	                            TRAINING_STRING : {
	                                type : "string"
	                            },
	                            DEPT_DESIGNATION_YN : {
	                                type : "string"
	                            },
	                            DEPT_DESIGNATION_CD : {
	                                type : "string"
	                            },
	                            DEPT_DESIGNATION_STRING : {
	                                type : "string"
	                            },
	                            INSTITUTE_NAME : {
	                                type : "string"
	                            },
	                            RECOG_TIME_H : {
	                                type : "number"
	                            },
	                            RECOG_TIME_M : {
	                                type : "number"
	                            }
	                        }
	                    }
	                },
	                pageSize : 30,
	                serverPaging : true,
	                serverFiltering : true,
	                serverSorting : true,
	                error : function(e) {
	                    //alert(e.status);
	                    if(e.xhr.status==403){
	                       alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
	                       sessionout();
	                    }else{
	                       alert('xhr.status = ' + e.xhr.status + '\n' +  'xhr.statusText = '  + e.xhr.statusText );
	                    }
	                }
	            },
	            columns : [
                        {
                            field : "NAME",
                            title : "학습자",
                            width : "90px",
                            filterable: true,
                            headerAttributes : {
                                "class" : "table-header-cell",
                                style : "text-align:center"
                            },
                            attributes : {
                                "class" : "table-cell",
                                style : "text-align:center"
                            },
                            template: function(data){
                                var cnt = data.PER_CNT;
                                var name = "";
                                if(data.NAME){
                                    name = data.NAME;
                                }
                                if(cnt > 0 ){
                                    return name+" 외 " +cnt+"명";
                                }else{
                                    return name;
                                }
                            } 
                        },
	                    {
	                        field : "SUBJECT_NM",
	                        title : "제목",
	                        width : "250px",
	                        filterable: true,
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:left;text-decoration: underline;"
	                        },
	                        template: function(data){
	                        	var subjectName = data.SUBJECT_NM;
	                        	if(data.USEFLAG == 'N'){
	                        		subjectName = "<font color='red'>"+data.SUBJECT_NM+"</font>";
	                        	}
	                        	return "<a href='javascript:void();' onclick='javascript: fn_detailView("+data.ALW_STD_SEQ+");' >"+subjectName+"</a>";
	                        } 
	                    },
                        {
                            field : "EDU_PERIOD",
                            title : "학습기간",
                            width : "190px",
                            filterable: true,
                            headerAttributes : {
                                "class" : "table-header-cell",
                                style : "text-align:center"
                            },
                            attributes : {
                                "class" : "table-cell",
                                style : "text-align:center"
                            }
                        },
                        {
                            field : "ALW_STD_STRING",
                            title : "상시학습종류",
                            width : "150px",
                            filterable: true,
                            headerAttributes : {
                                "class" : "table-header-cell",
                                style : "text-align:center"
                            },
                            attributes : {
                                "class" : "table-cell",
                                style : "text-align:left"
                            }
                        },
	                    {
	                        field : "INSTITUTE_NAME",
	                        title : "교육기관",
	                        width : "130px",
	                        filterable: true,
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        }
	                    },
	                    {
	                        field : "RECOG_TIME_H",
	                        title : "인정시간",
	                        width : "100px",
	                        filterable: true,
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        },
	                        template : function(data) {
	                            return data.RECOG_TIME_H + "시간"
	                                    + data.RECOG_TIME_M + "분";
	                        }
	                    },
	                    {
	                        field : "DEPT_DESIGNATION_YN",
	                        title : "부처지정학습",
	                        width : "130px",
	                        filterable: true,
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        }
	                    },
	                    {
	                        field: "REQ_STS_NM",
	                        title: "승인여부",
	                        width:100,
	                        filterable: true,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:center"}
	                    },	                   
	                    {
	                        field: "REQ_STS_CD",
	                        title: "승인상태",
	                        width:100,
	                        filterable: true,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:center"},
	                        template: function(data){
	                        	if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
	                                return "";
	                            }else{
	                                if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
	                                    return "";
	                                }else{ //승인요청상태
	                                	var cancelAbleYn =  "N";
	                                	//if(data.REQ_STS_CD == "2" || data.REQ_STS_CD == "3"){
	                                		//승인요청건에 대해 최종 처리가 되기전엔 취소가능하도록 함.
	                                	//	cancelAbleYn =  "N";
	                                	//}
	                                	if(data.REQ_NUM !=undefined && data.REQ_NUM != null && data.REQ_NUM != ""){
	                                   		return "<button id='apprOpenBtn' class=\"k-button\" onclick=\"javascript:fn_apprOpen("+data.REQ_NUM+","+data.REQ_STS_CD+",'"+cancelAbleYn+"')\" >승인현황</button>";
	                                	}else{
	                                		return "";
	                                	}
	                                }
	                            }
	                        }
	                    },
	                    
	               ],
	               height: 550,
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
	                   pageSizes : [10,20,30]
	   	        	}
	        });
	        
	        empList(); // 임직원 그리드
	        numTexBox(); //날짜 타입
	        //$("#saveBtn").hide(); //저장버튼 숨김
	        //$("#cencleReqBtn").hide(); //승인취소 숨김
	        
	       

	        //상시학습 등록 버튼 클릭 이벤트
	        $("#newBtn").click(function() {
				
	        	//$("#saveBtn").hide();
				//$("#cencleReqBtn").hide();
				$("#deleteBtn").hide();
				//$("#appReqBtn").show();
				$("#empInsertPop").show();
				$("#subjectSearchBtn").show();
				
				$("#empUpdatePop").hide();//인정직급수정
				
				<%//if (isSystem){%>
				//$("#saveBtn").show();
				//$("#appReqBtn").hide();
				<%//}%>
				
				
	            $("#splitter4").data("kendoSplitter").expand("#detail_pane4");

	            //디테일 영역 초기화
	            var obj = new Object();

	            // 기본정보 초기화
	            obj.EDU_HOUR_H = '0';
	            obj.EDU_HOUR_M = '0';
	            obj.RECOG_TIME_H = '0';
	            obj.RECOG_TIME_M = '0';
	            obj.DEPT_DESIGNATION_YN = 'N';
	            
	            kendo.bind($('#tabular'), obj);
	            
	            //부서원 정보 초기화
	            empList();
	            
	            //첨부파일 초기화
	            $("#my-file-gird").data('kendoGrid').dataSource.data([]);
	            //첨부파일 임시objectid 세팅(랜덤 정수로 ...)
	            var ranval = Math.floor(Math.random()*1000000000); 
	            $("#objectId").val(ranval);
	            
	            //개설년도 현재연도로 초기화
	            dtl_yyyy.value(now.getFullYear());
	          
	            //상시학습유형 초기화
	            dataSource_alwStdCd2.filter({ field: "VALUE", operator: "eq", value: "" });
                dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
	            
	            $('input:radio[id=dtl_dept_designation_yn]:input[value=N]').attr("checked", true);//부처지정여부
	            
	            $('input:radio[id=requiredYn]:input[value=N]').attr("checked", true);//필수여부

                var start = $("#dtl_edu_start").data("kendoDatePicker") ;
                var end = $("#dtl_edu_end").data("kendoDatePicker") ;
                
                var startDate = "1900-01-01";
                var endDate = "2999-01-01";

                if (startDate) {
                    //startDate = new Date(startDate);
                    //startDate.setDate(startDate.getDate());
                    end.min(startDate);
                } 
                if (endDate) {
                    start.max(endDate);
                } 
                 
                
	            //부처지정여부 컨트롤.
	            //fn_deptDesignation();
	            
	            //교육기관명 입력 제어.
	            fn_dtl_institute_name_disable();
	            
	            $("#autoTime").hide();
	            
	            $("#reqStsSpan").attr("style", "display: none;");
                $("#reqStsEm").attr("style", "display: none;");
                

	        });
	        
	        $("#cancelBtn").click(function() {
                kendo.bind($("#tabular"), null);
                // 상세영역 비활성화
                $("#splitter4").data("kendoSplitter").collapse("#detail_pane4");
            });
	        
	        //부서원 추가버튼 클릭 시
	        $("#empInsertPop").click(function(){
	        	var emp = $("#empList").data("kendoGrid");
	        	if(emp.dataSource.data().length==0){
	        		empPop('alwEmp');
	        	}else{
	        		alert("이미 추가되었습니다.");
	        	}
	        });
	        
	      //인정직급 수정버튼 클릭 시
	        $("#empUpdatePop").click(function(){
	        	var emp = $("#empList").data("kendoGrid");
	     
	        		empUpdatePop('alwEmp');
	        	
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
          
            //교육기관 데이터소스
            dataSource_instituteCd = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA22", ADDVALUE: "" };
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
            var trainingCode = $("#dtl_training_code").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_training,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
            
            //지정학습종류
            var deptDesignationCd = $("#dtl_dept_designation_cd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_deptDesignation,
                 filter: "contains",
                 suggest: true,
                 change:function(){
                     if(this.value()=="004" || removeNullStr(this.value())==""){
                         $('input:radio[name=dtl_dept_designation_yn]:input[value=N]').attr("checked", true); // 지정학습
                      }else{
                         $('input:radio[name=dtl_dept_designation_yn]:input[value=Y]').attr("checked", true); // 지정학습
                     }
                 }
             }).data("kendoDropDownList");

            //지정학습 라디오버튼 비활성화 처리.
            //$('input:radio[name=dtl_dept_designation_yn]:input[value=N]').attr("disabled", true); 
            //$('input:radio[name=dtl_dept_designation_yn]:input[value=Y]').attr("disabled", true); 

            //기관성과평가필수교육과정
            var perfAsseSbjCd = $("#dtl_perf_asse_sbj_cd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_perfAsseSbjCd,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
            
            //업무시간구분
            var officeTimeCd = $("#dtl_office_time_cd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_officeTimeCd,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");

            //교육기관구분
            var eduinsDivCd = $("#dtl_eduins_div_cd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_eduinsDivCd,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");


            //교육기관
            instituteCode = $("#dtl_institute_code").kendoComboBox({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_instituteCd,
                 filter: "contains",
                 suggest: true,
                 placeholder : "=== 선택 ===", 
                 change:function(){
                     if(this.value()=="Z"){
                         fn_dtl_institute_name_able();
                     }else{
                         fn_dtl_institute_name_disable();
                     }
                     $('#dtl_institute_name').val("");
                 }
             }).data("kendoComboBox");
            instituteCode.options.filter = "contains";

            //교육기관명 초기화
            fn_dtl_institute_name_disable();
            
            //상시학습종류
             var dtl_alw_std_cd1 = $("#dtl_alw_std_cd1").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_alwStdCd1,
                 filter: "contains",
                 suggest: true,
                 change:function(){
                	 if(dtl_alw_std_cd1.value()==""){
                		 dtl_alw_std_cd2.value("");
                		 alwStdCd.value("");

                		 dtl_alw_std_cd2.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                		 alwStdCd.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                	 }else{
                		 dtl_alw_std_cd2.dataSource.filter({
               				 logic: "or",
               			        filters: [
               			               { field: "P_VALUE", operator: "contains", value:  dtl_alw_std_cd1.value()},
               			               { field: "VALUE", operator: "eq", value: "" }
               			       ]
                		 });
                         alwStdCd.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                	 }
                 }
             }).data("kendoDropDownList");
            
            var dtl_alw_std_cd2 = $("#dtl_alw_std_cd2").kendoDropDownList({
                dataTextField: "TEXT",
                dataValueField: "VALUE",
                dataSource: dataSource_alwStdCd2,
                filter: "contains",
                suggest: true,
                change:function(){
                    if(dtl_alw_std_cd2.value()==""){
                        alwStdCd.value("");

                        alwStdCd.dataSource.filter({ field: "VALUE", operator: "eq", value: "" });
                    }else{
                        alwStdCd.dataSource.filter({
                            logic: "or",
                               filters: [
                                      { field: "P_VALUE", operator: "contains", value:  dtl_alw_std_cd2.value()},
                                      { field: "VALUE", operator: "eq", value: "" }
                              ]
                        });
                    }
                }
            }).data("kendoDropDownList");
            
            var alwStdCd = $("#dtl_alw_std_cd").kendoDropDownList({
                dataTextField: "TEXT",
                dataValueField: "VALUE",
                dataSource: dataSource_alwStdCd,
                filter: "contains",
                suggest: true,
                change: function(){
                    var data=this.dataItem();
                    $("#alwStd_cm").text(data.get("CD_VALUE3")==null ? "":data.get("CD_VALUE3"));
                    if(data.get("CD_VALUE5")=="Y"){
                        $("#autoTime").show();
                        $("#dtl_recog_time_h").val("");
                        $("#dtl_recog_time_m").val("");

                        //recogTimeH.enable(false);
                        //recogTimeM.enable(false);

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

                        //recogTimeH.enable(true);
                        //recogTimeM.enable(true);
                    }
                }
            }).data("kendoDropDownList");
            $("#autoTime").hide();
            

            //학습역량
            var cmptCombo = $("#dtl_cmpnumber").kendoComboBox({
                dataTextField: "TEXT",
                dataValueField: "VALUE",
                dataSource: compDataSource,
                suggest: true,
                placeholder : "학습에 도움이 된 역량을 선택해주세요."
            }).data("kendoComboBox");
            cmptCombo.options.filter = "contains";
            
            
            $("#appReqBtn").bind('click', function(){
        		
				var empData = $('#empList').data('kendoGrid').dataSource.data();
				if(empData.length == 0){
                    alert("부서원을 선택해주세요.");
                    return;
                }else{
                    for(var i=0 ; i< empData.length; i++){
                        if( !empData[i].TT_GET_SCO || empData[i].TT_GET_SCO == ""){
                            alert("취득점수를 입력해주세요.");
                            $("#TT_GET_SCO"+empData[i].USERID).focus();
                            return false;
                        }
                    }
                }
                if ($("#dtl_subject_nm").val() == "") {
                    alert("과정명을 입력해주세요.");
                    $("#dtl_subject_nm").focus();
                    return false;
                }

                if(dtl_yyyy.value()==null || dtl_yyyy.value()==""){
                    alert("해당년도를 입력해주세요.");
                    dtl_yyyy.focus();
                    return false;
                }

                if($("#dtl_edu_start").val() == ""){
                    alert("학습기간 시작일을 입력하세요.");
                    $("#dtl_edu_start").focus();
                    return false;
                }
                if($("#dtl_edu_end").val() == ""){
                    alert("학습기간 종료일을 입력하세요.");
                    $("#dtl_edu_end").focus();
                    return false;
                }
                
                if(ex_date("학습기간 시작일", "dtl_edu_start")==false){
                    return;
                }
                if(ex_date("학습기간 종료일", "dtl_edu_end")==false){
                    return;
                }

                if(dtl_alw_std_cd1.select()==0){
                    alert("상시학습종류를 선택해주세요.");
                    dtl_alw_std_cd1.focus();
                    return false;
                }
                
                if((dtl_alw_std_cd1.select()>0 || dtl_alw_std_cd2.select()>0) && alwStdCd.select()==0){
                    alert("상시학습종류를 3차까지 선택해주세요.");
                    if(dtl_alw_std_cd2.select()==0){
                        dtl_alw_std_cd2.focus();
                    }else{
                        alwStdCd.focus();
                    }
                    return false;
                }

                if ( eduHourH.value() == null && eduHourM.value() == null ) {
                    alert("실적시간을 입력해주세요.");
                    eduHourH.focus();
                    return false;
                }
                
                if ( recogTimeH.value() == null && recogTimeM.value() == null ) {
                    alert("인정시간을 입력해주세요.");
                    recogTimeH.focus();
                    return false;
                }
               
                if(!$(':radio[id="dtl_dept_designation_yn"]:checked').val() || $(':radio[id="dtl_dept_designation_yn"]:checked').val()==null){
                	alert("부처지정학습을 선택해주세요");
                	return false;
                }
                /*if(deptDesignationCd.select()==0){
                    alert("지정학습종류를 선택해주세요.");
                    deptDesignationCd.focus();
                    return false;
                }*/
                
                if(trainingCode.select()==0){
                    alert("학습유형을 선택해주세요");
                    trainingCode.focus();
                    return false;
                }

                if( removeNullStr($('#dtl_institute_code').val()) == '' ){
                    alert("교육기관명을 선택해주세요");
                    $('#dtl_institute_code').focus();
                    return false;
                }

                if( removeNullStr($('#dtl_institute_code').val()) == 'Z' && $("#dtl_institute_name").val() == ""){
                    alert("교육기관명을 입력해주세요");
                    $('#dtl_institute_name').focus();
                    return false;
                }
                
        		//승인요청 팝업호출.
        		apprReqOpen();
        		apprReqCallBackFunc = apprReqExec;
            }); 
         

        	//승인요청 처리 콜백 함수..
        	var apprReqExec = function(cmpltFlag){
        		
        		var apprReqDataSource = null;
        		if($("#apprReqUserGrid").data("kendoGrid")){
        			apprReqDataSource = $("#apprReqUserGrid").data("kendoGrid").dataSource.data();
        		}

               	//로딩바생성.
               	loadingOpen();
               	
                var params = {
                	    LIST :  $('#empList').data('kendoGrid').dataSource.data(),
                	 	APPR_LINE :  apprReqDataSource //승인경로 
                };

                var instituteNm = "";
                if(instituteCode.value() == "Z"){
                    instituteNm =  $("#dtl_institute_name").val();
                }else{
                    instituteNm = instituteCode.text();
                }
        
                $.ajax({
                    type : 'POST',          
                    url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/save-alw-req.do?output=json",
                    data : {
                   	    item: kendo.stringify( params ), 
                   	    ALW_STD_SEQ : $("#alw_std_seq").val(),
                        TRAINING_CODE : removeNullStr(trainingCode.value()),
                        SUBJECT_NM : $("#dtl_subject_nm").val(),
                        RECOG_TIME_H : recogTimeH.value(),
                        RECOG_TIME_M : recogTimeM.value(),
                        EDU_CONT : $("#dtl_edu_cont").val(),
                        EDU_HOUR_H : $("#dtl_edu_hour_h").val(),
                        EDU_HOUR_M : $("#dtl_edu_hour_m").val(),
                        YYYY : $("#dtl_yyyy").val(),
                        EDU_STIME : $("#dtl_edu_start").val(),
                        EDU_ETIME : $("#dtl_edu_end").val(),
                        ALW_STD_CD : removeNullStr(alwStdCd.value()),
                        INSTITUTE_NAME : instituteNm,
                        INSTITUTE_CODE : $("#dtl_institute_code").val(),
                        DEPT_DESIGNATION_YN : $(':radio[id="dtl_dept_designation_yn"]:checked').val(),
                        DEPT_DESIGNATION_CD : removeNullStr(deptDesignationCd.value()),
                        PERF_ASSE_SBJ_CD : removeNullStr(perfAsseSbjCd.value()),
                        OFFICETIME_CD : removeNullStr(officeTimeCd.value()),
                        EDUINS_DIV_CD : removeNullStr(eduinsDivCd.value()),
                        //TT_GET_SCO : $("#TT_GET_SCO").val(),
                        OBJECTID : $("#objectId").val(),
                        REQUIRED_YN : $(':radio[id="requiredYn"]:checked').val()
                        
                    },
                    complete : function( response ){
                    	//로딩바 제거.
                        loadingClose();
                        
                        var obj  = eval("(" + response.responseText + ")");
                        if(!obj.error){
                        	if(obj.saveCount > 0){         
                                
                                // 상세영역 활성화
                                $("#splitter4").data("kendoSplitter").expand("#detail_pane4");
                            
                                // 상시학습 목록 read
                                $("#grid").data("kendoGrid").dataSource.read();
                                
                                kendo.bind( $(".tabular"),  null );
                            
                                // 상세영역 비활성화
                                $("#splitter4").data("kendoSplitter").collapse("#detail_pane4");
                                
                                alert("승인요청되었습니다.");  
                            }else{
                                alert("승인요청에 실패 하였습니다. 교육운영자에게 문의해주세요.");
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
        	
            // 저장버튼 클릭 시.
            $("#saveBtn").bind('click', function() {
                var tUserid = "";
            	var empData = $('#empList').data('kendoGrid').dataSource.data();
        		if(empData.length == 0){
        			alert("부서원을 선택해주세요.");
        			return;
        		}else{
        			//for(var i=0 ; i< empData.length; i++){
        				//tUserid = empData[0].USERID;
        				
        				if( !empData[0].TT_GET_SCO || empData[0].TT_GET_SCO == ""){
        					empData[0].TT_GET_SCO = "0";
        				//	alert("취득점수를 입력해주세요.");
        				//	$("#TT_GET_SCO"+empData[0].USERID).focus();
                        //    return false;
        				}
        			//}
        		}
                if ($("#dtl_subject_nm").val() == "") {
                    alert("과정명을 입력해주세요.");
                    $("#dtl_subject_nm").focus();
                    return false;
                }

                if(dtl_yyyy.value()==null || dtl_yyyy.value()==""){
                    alert("해당년도를 입력해주세요.");
                    dtl_yyyy.focus();
                    return false;
                }

                if($("#dtl_edu_start").val() == ""){
                    alert("학습기간 시작일을 입력하세요.");
                    $("#dtl_edu_start").focus();
                    return false;
                }
                if($("#dtl_edu_end").val() == ""){
                    alert("학습기간 종료일을 입력하세요.");
                    $("#dtl_edu_end").focus();
                    return false;
                }
                
                if(ex_date("학습기간 시작일", "dtl_edu_start")==false){
                    return;
                }
                if(ex_date("학습기간 종료일", "dtl_edu_end")==false){
                    return;
                }

                if(dtl_alw_std_cd1.select()==0){
                    alert("상시학습종류를 선택해주세요.");
                    dtl_alw_std_cd1.focus();
                    return false;
                }
                
                if((dtl_alw_std_cd1.select()>0 || dtl_alw_std_cd2.select()>0) && alwStdCd.select()==0){
                    alert("상시학습종류를 3차까지 선택해주세요.");
                    if(dtl_alw_std_cd2.select()==0){
                        dtl_alw_std_cd2.focus();
                    }else{
                        alwStdCd.focus();
                    }
                    return false;
                }

                if ( eduHourH.value() == null && eduHourM.value() == null ) {
                    alert("실적시간을 입력해주세요.");
                    eduHourH.focus();
                    return false;
                }
                
                if ( recogTimeH.value() == null && recogTimeM.value() == null ) {
                    alert("인정시간을 입력해주세요.");
                    recogTimeH.focus();
                    return false;
                }
                
                if ( $("#dtl_edu_cont").val() == "" ) {
                	alert("내용을 입력해주세요.");
                	$("#dtl_edu_cont").focus();
                	return false;
                }

                if(!$(':radio[id="dtl_dept_designation_yn"]:checked').val() || $(':radio[id="dtl_dept_designation_yn"]:checked').val()==null){
                    alert("부처지정학습을 선택해주세요");
                    return false;
                }
                /*
                if(deptDesignationCd.select()==0){
                    alert("지정학습종류를 선택해주세요.");
                    deptDesignationCd.focus();
                    return false;
                }
                */
        		if(trainingCode.select()==0){
                	alert("학습유형을 선택해주세요");
                	trainingCode.focus();
                	return false;
                }
                
                if($("#dtl_institute_code").data("kendoComboBox").select()<0){
        	        alert("교육기관명을 선택해주세요");
        	        $('#dtl_institute_code').focus();
        	        return false;
        	    }

        	    if( removeNullStr($('#dtl_institute_code').val()) == 'Z' && $("#dtl_institute_name").val() == ""){
        	        alert("교육기관명을 입력해주세요");
        	        $('#dtl_institute_name').focus();
        	        return false;
        	    }
        	    
        	    if($("#dtl_cmpnumber").data("kendoComboBox").select()<0){
        	    	alert("학습역량을 선택해주세요");
                    $('#dtl_cmpnumber').focus();
                    return false;
        	    }

        	    //상시학습종류별 연간인정시간 체크
        	    $.ajax({
        	        type : 'POST',
        	        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/year_recog_limit_check.do?output=json",
        	        data : {
        	            asOpenSeq : $("#alw_std_seq").val(),
        	            tUserid : tUserid,
        	            eduDiv : "2",
        	            yyyy : $("#dtl_yyyy").val(),
        	            recogTimeH : recogTimeH.value(),
        	            recogTimeM : recogTimeM.value(),
        	            alwStdCd : removeNullStr(alwStdCd.value())
        	        },
        	        complete : function( response ){
        	            var obj = eval("(" + response.responseText + ")");
        	            if(obj.error){
        	                 alert("ERROR=>"+obj.error.message);
        	            } else {
        	                 if(obj.statement!="") {
        	                     var msg = obj.statement.replace(/<br>/g, "\n");
        	                     if(!confirm("선택된 상시학습종류의 연간 최대 인정시간 제한으로 아래와 같이 인정시간이 적용됩니다.\n\n"+msg+"\n\n그래도 상시학습 정보를 등록하시겠습니까?")) return;
        	                 } else {
        	                     if(!confirm("상시학습 정보를 저장하시겠습니까?")) return;
        	                 }
        	                 

       	                    //로딩바생성.
       	                    loadingOpen();
       	                    
       	                    var params = {
       	                            LIST :  $('#empList').data('kendoGrid').dataSource.data(),
       	                    };

       	                    var instituteNm = ""
       	                    if(instituteCode.value() == "Z"){
       	                        instituteNm =  $("#dtl_institute_name").val();
       	                    }else{
       	                        instituteNm = instituteCode.text();
       	                    }
       	                    
       	                     var cmp = $("#dtl_cmpnumber").data("kendoComboBox");
       	                     var cmpVal;
	       	                 if(cmp.select() < 0){
	       	                     cmpVal = "";
	       	                 }else{
	       	                     cmpVal = cmp.value();
	       	                 }
	       	                 
       	                    $.ajax({
       	                        type : 'POST',          
       	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/save-alw-info.do?output=json",
       	                        data : {
       	                            item: kendo.stringify( params ), 
       	                            ALW_STD_SEQ : $("#alw_std_seq").val(),
       	                            TRAINING_CODE : removeNullStr(trainingCode.value()),
       	                            SUBJECT_NM : $("#dtl_subject_nm").val(),
       	                            RECOG_TIME_H : recogTimeH.value(),
       	                            RECOG_TIME_M : recogTimeM.value(),
       	                            EDU_CONT : $("#dtl_edu_cont").val(),
       	                            EDU_HOUR_H : $("#dtl_edu_hour_h").val(),
       	                            EDU_HOUR_M : $("#dtl_edu_hour_m").val(),
       	                            YYYY : $("#dtl_yyyy").val(),
       	                            EDU_STIME : $("#dtl_edu_start").val(),
       	                            EDU_ETIME : $("#dtl_edu_end").val(),
       	                            ALW_STD_CD : removeNullStr(alwStdCd.value()),
       	                            INSTITUTE_NAME : instituteNm,
       	                            INSTITUTE_CODE : $("#dtl_institute_code").val(),
       	                            DEPT_DESIGNATION_YN : $(':radio[id="dtl_dept_designation_yn"]:checked').val(),
       	                            DEPT_DESIGNATION_CD : removeNullStr(deptDesignationCd.value()),
       	                            PERF_ASSE_SBJ_CD : removeNullStr(perfAsseSbjCd.value()),
       	                            OFFICETIME_CD : removeNullStr(officeTimeCd.value()),
       	                            EDUINS_DIV_CD : removeNullStr(eduinsDivCd.value()),
       	                            OBJECTID : $("#objectId").val(),
       	                            REQUIRED_YN : $(':radio[id="requiredYn"]:checked').val(),
       	                            CMPNUMBER : cmpVal
       	                        },
       	                        complete : function( response ){
       	                            //로딩바 제거.
       	                            loadingClose();
       	                            
       	                            var obj  = eval("(" + response.responseText + ")");
       	                            if(!obj.error){
       	                                if(obj.saveCount > 1){
       	                                    
       	                                    // 상세영역 활성화
       	                                    $("#splitter4").data("kendoSplitter").expand("#detail_pane4");
       	                                
       	                                    // 상시학습 목록 read
       	                                    $("#grid").data("kendoGrid").dataSource.read();
       	                                    
       	                                    kendo.bind( $(".tabular"),  null );
       	                                
       	                                    // 상세영역 비활성화
       	                                    $("#splitter4").data("kendoSplitter").collapse("#detail_pane4");
       	                                    
       	                                    yyyyDataSource.read();
       	                                    
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
        	    
  
            });
            
            // dtl cancel btn add click event
            $("#cancel-btn").click(function() {
                kendo.bind($(".tabular"), null);
                // 상세영역 비활성화
                $("#splitter4").data("kendoSplitter").collapse("#detail_pane4");
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
                        columns: [
                            { title: "선택", width: 80,
                                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                attributes:{"class":"table-cell", style:"text-align:center"} ,
                                template : function(data){
                                    return "<input type='button' class='k-button k-i-close' style='width:45' value='선택' onclick='fn_SelectSubject("+data.SUBJECT_NUM+");'/>";
                                }
                            },
							{
							    field : "TRAINING_STRING",
							    title : "학습유형",
							    width : "120px",
							    headerAttributes : {
							        "class" : "table-header-cell",
							        style : "text-align:center"
							    },
							    attributes : {
							        "class" : "table-cell",
							        style : "text-align:center"
							    }
							},
							{
							    field : "SUBJECT_NAME",
							    title : "과정명",
							    width : "300px",
							    headerAttributes : {
							        "class" : "table-header-cell",
							        style : "text-align:center"
							    },
							    attributes : {
							        "class" : "table-cell",
							        style : "text-align:left;"
							    }
							},
							{
							    field : "DEPT_DESIGNATION_YN",
							    title : "부처지정유무",
							    width : "130px",
							    headerAttributes : {
							        "class" : "table-header-cell",
							        style : "text-align:center"
							    },
							    attributes : {
							        "class" : "table-cell",
							        style : "text-align:center"
							    }
							},
							{
							    field : "DEPT_DESIGNATION_STRING",
							    title : "지정학습구분",
							    width : "130px",
							    headerAttributes : {
							        "class" : "table-header-cell",
							        style : "text-align:center"
							    },
							    attributes : {
							        "class" : "table-cell",
							        style : "text-align:center"
							    }
							},
                            {
                                field : "PERF_ASSE_SBJ_STRI",
                                title : "기관성과평가필수교육",
                                width : "150px",
                                headerAttributes : {
                                    "class" : "table-header-cell",
                                    style : "text-align:center"
                                },
                                attributes : {
                                    "class" : "table-cell",
                                    style : "text-align:center"
                                }
                            },
							{
							    field : "INSTITUTE_NAME",
							    title : "교육기관",
							    width : "130px",
							    headerAttributes : {
							        "class" : "table-header-cell",
							        style : "text-align:center"
							    },
							    attributes : {
							        "class" : "table-cell",
							        style : "text-align:center"
							    }
							},
							{
							    field : "RECOG_TIME",
							    title : "인정시간",
							    width : "100px",
							    headerAttributes : {
							        "class" : "table-header-cell",
							        style : "text-align:center"
							    },
							    attributes : {
							        "class" : "table-cell",
							        style : "text-align:center"
							    }
							}
                        ],
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
            
            var recogTimeH = $("#dtl_recog_time_h").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 999,
                step: 1
            }).data("kendoNumericTextBox");
            
            var recogTimeM = $("#dtl_recog_time_m").kendoNumericTextBox({
                format: "",
                min: 0,
                max: 59,
                step: 1
            }).data("kendoNumericTextBox");
          //교육시간_시간
            var eduHourH = $("#dtl_edu_hour_h").kendoNumericTextBox({
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
          //교육시간_분
            var eduHourM = $("#dtl_edu_hour_m").kendoNumericTextBox({
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
			
            $("input[name='dtl_dept_designation_yn']").click(function(){
                //fn_deptDesignation();
            });
            
            $("#deleteBtn").click(function(){
            	if(confirm("해당 학습을 삭제 하시겠습니까?")){
            		loadingOpen();
            		$.ajax({
        	            type : 'POST',          
        	            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/del-alw-req.do?output=json",
        	            data : {
        	            	alwSeq : $("#alw_std_seq").val()
        	            },
        	            complete : function( response ){
        	            	//로딩바 제거.
        	                loadingClose();
        	                
        	                var obj  = eval("(" + response.responseText + ")");
        	                if(!obj.error){
        	                	if(obj.saveCount > 0){         
        	                        // 상세영역 활성화
        	                        $("#grid").data("kendoGrid").dataSource.read();
        	                        alert("삭제되었습니다.");  
        	                    }else{
        	                        alert("삭제에 실패하였습니다.");
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
            
            $("#cencleReqBtn").click(function(){
            	if(confirm("승인요청을 취소 하시겠습니까?")){
            		loadingOpen();
            		$.ajax({
        	            type : 'POST',          
        	            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/cencle-alw-req.do?output=json",
        	            data : {
        	            	alwSeq : $("#alw_std_seq").val(),
        	            	reqNum : $("#reqNum").val()
        	            },
        	            complete : function( response ){
        	            	//로딩바 제거.
        	                loadingClose();
        	                
        	                var obj  = eval("(" + response.responseText + ")");
        	                if(!obj.error){
        	                	if(obj.saveCount > 0){         
        	                        // 상세영역 활성화
        	                        alert("승인요청이 취소되었습니다.");  
        	                        $("#grid").data("kendoGrid").dataSource.read();
        	                        $("#splitter4").data("kendoSplitter").collapse("#detail_pane4");
        	                    }else{
        	                        alert("설정에 실패하였습니다.");
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
                                alert("-상시학습 업로드 결과-\n"+myObj.statement);
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
          
          //브라우저 resize 이벤트 dispatch..
            $(window).resize();
            /*
            @@@ 첨부파일 세팅 방법 @@@
            object_type = 1 (고정된 값 ==> 공통코드에서 확인해야함...)
            object_id 값은 해당 업무 테이블의 pk가 unique하다면 해당컬럼의 값으로 처리해도됨. 그렇지 않다면 pk의 조합으로 처리해야함.
            
            object_id = 회사번호+실시번호+평가대상자+지표번호
                           예 ) 회사번호 1, 실시번호 7, 평가대상자 1500, 지표번호 10 => 17150010
               
            */
          var objectType = 6 ;
            
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
                    height: 115,
                    selectable: false,
                    columns: [
                        { 
                            field: "name", 
                            title: "파일명",  
                            width: "120px",
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
                        	var width = 380;
                            var height = 220;
                            var left = (screen.width - width) / 2;
                            var top = (screen.height - height) / 2;
                            
                            var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#objectId").val() +"&fileType=doc" ;
                            myWindow = window.open(windowUrl, "_blank", "toolbar=no, scrollbars=yes, resizable=yes, top="+top+", left="+left+", width="+width+", height="+height);
                        }                           
                    });
                    $('button.custom-button-delete').click( function(e){
                        alert ("delete");
                    });
                    $("#my-file-upload").removeClass('hide');
                    $("#drag_cmt").hide();
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
                    
                    $("#drag_cmt").show();
                }
            }
        } 
    } 
]);



//교육기관명 비활성화
var fn_dtl_institute_name_disable = function(){
    $('#dtl_institute_name').attr('readonly', 'readonly');
    $('#dtl_institute_name').attr('style', 'width: 100%; margin-top:10px; background-color:#e0e0e0;');
}

//교육기관명 활성화
var fn_dtl_institute_name_able = function(){
    $('#dtl_institute_name').removeAttr('readonly');
    $('#dtl_institute_name').attr('style', 'width: 100%; margin-top:10px; background-color:#ffffff');
}

</script>

<script type="text/javascript">
	//엑셀다운로드
	function excelDown(button){
		 button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/alw-list-excel.do?YYYY=" + $("#yyyy").val();
	}

    function fn_apprOpen(reqNum,reqType_cd ,cencleYn){
    	
    	//승인현황 팝업 호출.
		apprStsOpen(3, reqNum, cencleYn );
		//승인취소 처리 후 callback 함수 정의
		reqCancelCompleteCallbackFunc = fn_afterReqCancel;
	}
	//승인요청 취소후 처리
	function fn_afterReqCancel(){
		//그리드 내용 refresh.
		$("#grid").data("kendoGrid").dataSource.read();
		document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/my-class-admin-main.do";
	    document.frm.submit();
		
	}
	//과정검색 팝업에서 과정 선택 시.
	function fn_SelectSubject(subjectNum){

	    var grid = $("#subjectSearchGrid").data("kendoGrid");
	    var data = grid.dataSource.data();
	    
	    var res = $.grep(data, function (e) {
	        return e.SUBJECT_NUM == subjectNum;
	    });

	    var selectedCell = res[0];

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
	                $('input:radio[id=dtl_dept_designation_yn]:input[value='+selectedCell.DEPT_DESIGNATION_YN+']').attr("checked", true);
	                $('input:radio[id=veterAsseReqYn]:input[value='+selectedCell.VETER_ASSE_REQ_YN+']').attr("checked", true);
	                $('input:radio[id=requiredYn]:input[value='+selectedCell.REQUIRED_YN+']').attr("checked", true);
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
	                
	                selectRow.SUBJECT_NM = selectRow.SUBJECT_NAME;
	                selectRow.TRAINING_CD = selectRow.TRAINING_CODE;
	                selectRow.EDU_CONT = selectRow.COURSE_CONTENTS;
	                selectRow.YYYY = now.getFullYear();
	                selectRow.ALW_STD_SEQ = $("#alw_std_seq").val();
	                //상세데이터 바인딩..
	                kendo.bind($("#tabular"), selectRow);

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
	function numTexBox(){ //날짜 및 숫자입력 텍스트박스 제어

  	  var start = $("#dtl_edu_start").kendoDatePicker({
  		   format: "yyyy-MM-dd",
  		   change: function(e) {                    
  			   var startDate = start.value(),
  	         endDate = end.value();

  	         if (startDate) {
  	             //startDate = new Date(startDate);
  	             //startDate.setDate(startDate.getDate());
  	             end.min(startDate);
  	         } /*else if (endDate) {
  	             start.max(new Date(endDate));
  	         } else {
  	             endDate = new Date();
  	             start.max(endDate);
  	             end.min(endDate);
  	         }*/
  	            			
  	  	}
  	  }).data("kendoDatePicker");

  	  var end = $("#dtl_edu_end").kendoDatePicker({
  		   format: "yyyy-MM-dd",
  		   change: function(e) {                    
  			   var endDate = end.value(),
  	    	        startDate = start.value();
  	    	
  	    	        if (endDate) {
  	    	            //endDate = new Date(endDate);
  	    	            //endDate.setDate(endDate.getDate());
  	    	            start.max(endDate);
  	    	        } /*else if (startDate) {
  	    	            end.min(new Date(startDate));
  	    	        } else {
  	    	            endDate = new Date();
  	    	            start.max(endDate);
  	    	            end.min(endDate);
  	    	        }*/
	  		   }
	  	  }).data("kendoDatePicker");
  	   
	  	  start.max(end.value());
	  	  end.min(start.value());
  	}
  
	//부서원 추가
	function fn_empInsert(userId,mod){
		var popArray;
		var empArray;
		var overlap = true;
		popArray = $('#findEmp').data('kendoGrid').dataSource.data();
		
		for(var i = 0 ; i < popArray.length ; i++){
			popArray[i].TT_GET_SCO="";	
		}
		
		
		var res = $.grep(popArray, function (e) {
			return e.USERID == userId;
		});
		
		empArray = $($('#empList')).data('kendoGrid').dataSource.data();
		
		
		for(var i = 0 ; i < empArray.length ; i++){
			if(empArray[i].USERID == res[0].USERID ){
				overlap = false;
				break;
			}else{
				overlap = true;
			}	
		}

		if(mod == "alwEmp" && overlap == true){
			$($('#empList')).data('kendoGrid').dataSource.insert(res[0]);
			$("#pop04").data("kendoWindow").close();
		}else{
			alert("이미 선택된 임직원입니다.");
			return;
		}
	}
	
	//부서원 삭제 (ROW 삭제)
	function fn_empDel(userId){
		if(userId != null && userId != "" ){
			isDel = confirm("부서원을 삭제 하시겠습니까?");
		}
		if(isDel){
			var array;
			array = $('#empList').data('kendoGrid').dataSource.data();
			var res = $.grep(array, function (e) {
				return e.USERID == userId;
			});
			
		    $($('#empList')).data('kendoGrid').dataSource.remove(res[0]);
		 }
	}
	
	//인정직급 수정
	function fn_empUpdate(commoncode){
		if(confirm("인정직급을 수정 하시겠습니까?")){	
		 $.ajax({
                type : 'POST',          
                url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/update-grade-info.do?output=json",
                data : {
                    
                    ALW_STD_SEQ : $("#alw_std_seq").val(),
                    GRADE_NUM : commoncode
                },
                complete : function( response ){
                    //로딩바 제거.
                    loadingClose();
                    
                    var obj  = eval("(" + response.responseText + ")");
                    if(!obj.error){
                        if(obj.saveCount > 0){
                            
                        	empList('2'); // 임직원 그리드
                        	$("#pop05").data("kendoWindow").close();
                            alert("저장되었습니다.");  
                        }else{
                            alert("저장에 실패 하였습니다.");
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
	
	function empList(appVal){
		$("#empList").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/alw_emp_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){	
                    	return { alwStdSeq : $("#alw_std_seq").val()   };
                    } 		
                },
                schema: {
                	data: "items",
                    model: {
                        fields: {
                        	ALW_STD_SEQ : { type: "int" },
                        	NAME : { type: "string" },
                        	USERID : { type: "string" }
                        }
                    }
                },
                serverPaging:false, serverFiltering:false, serverSorting:false
            },
            columns: [
                {
                    field:"NAME",
                    title: "성명",
                    width: "80px",
                    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                attributes:{"class":"table-cell", style:"text-align:center;"},
                },
                {
                    field:"GRADE_NM",
                    title: "인정직급",
                    width:"100px",
                    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                attributes:{"class":"table-cell", style:"text-align:center"} ,
                },
                {
                    field:"TT_GET_SCO",
                    title: "취득점수",
                    width:"80px",
                    filterable: true,
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                attributes:{"class":"table-cell", style:"text-align:center"},
	                template: function(dataItem){
	                	var uid = dataItem.USERID;
	                	var tgs = "";
	                	if(dataItem.TT_GET_SCO!=null && dataItem.TT_GET_SCO!="null"){
	                		tgs = dataItem.TT_GET_SCO;
	                	}
	                	return "<input class=\"k-textbox\" id=\"TT_GET_SCO"+uid+"\" value=\""+tgs+"\" style=\"width:50px;\" onkeyup=\"setValue('"+uid+"',this);\" >";
	                }
                },
                {
                    title : "삭제",
                    filterable : false,
                    sortable : false,
                    width : "70px",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                    attributes : {"class" : "table-cell", style : "text-align:center"},
                    template: function(dataItem){
                 		if(appVal != 2){
                 			return "<button id=\"empDel\" class=\"k-button\" style=\"min-width:50px\" onclick=\"javascript: fn_empDel("+dataItem.USERID+");\">삭제</button>";
                 		}else{
                 			return "";
                 		}
                  	}
                }
            ],
            filterable: false,
        	pageSize: 99999,
      	    height: 74,
   			groupable: false,
   			sortable: false,
   			resizable: true,
   			reorderable: true,
   			pageable: false
        });
	}
	        
    //부처지정 여부가 예/아니오에 따라 지정학습구분 컨트롤..
    function fn_deptDesignation(){
        if($(':radio[id="dtl_dept_designation_yn"]:checked').val()=="Y"){
            $("#dtl_dept_designation_cd").data("kendoDropDownList").enable();
        }else{
        	$("#dtl_dept_designation_cd").data("kendoDropDownList").select(0);
            $("#dtl_dept_designation_cd").data("kendoDropDownList").enable(false);
        }
    }
    
	 function setValue(userid,obj){
		var word = obj.value ;
		if(obj.value!=""){
			var reg1 = /^(\d{1,10})([.]\d{0,2}?)?$/;
			if( !reg1.test(word)){
				alert("숫자 형식이 잘못되었습니다.");
				obj.value = "";
				obj.focus();
				return false ;
			}
		}
		var array = $('#empList').data('kendoGrid').dataSource.data();            

        var res = $.grep(array, function (e) {
            return e.USERID == userid;
        });
        res[0].TT_GET_SCO = obj.value;
	 }
		 
	 
	// 상세보기.
	function fn_detailView(alw_cd){
		
	    var grid = $("#grid").data("kendoGrid");
	    var data = grid.dataSource.data();
	    
	    var res = $.grep(data, function (e) {
	        return e.ALW_STD_SEQ == alw_cd;
	    });
	
	    var selectedCell = res[0];	
		$("#alw_std_seq").val(selectedCell.ALW_STD_SEQ);
	
		// 상세영역 활성화
		$("#splitter4").data("kendoSplitter").expand("#detail_pane4");
		
	    //로딩바 생성.
	    loadingOpen();    
	    $.ajax({
            type : 'POST',
            dataType : 'json',
            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/alw-admin-info.do?output=json",
            data : {
                alwStdSeq : selectedCell.ALW_STD_SEQ,
                reqNum : selectedCell.REQ_NUM
            },
            success : function(response) {

                //로딩바 제거.
                loadingClose();
                
                if (response.items != null) {

                    $("#delBtn").show();
                    //$("#cencleReqBtn").hide(); //승인요청취소 버튼 숨김
                    //$("#appReqBtn").hide(); //승인요청 버튼 생성
                    $("#deleteBtn").show();
                    
                    $("#empInsertPop").show();
                    $("#subjectSearchBtn").show();
                    
                    $("#empUpdatePop").hide();//인정직급수정
                    
                    var selectRow = new Object();
                    $.each(response.items, function(idx, item) {
                        $.each(item,function(key,val){
                            selectRow[key] = val;
                        });
                    });
                    
                    $('input:radio[id=dtl_dept_designation_yn]:input[value='+selectRow.DEPT_DESIGNATION_YN+']').attr("checked", true);
                    $('input:radio[id=requiredYn]:input[value='+selectRow.REQUIRED_YN+']').attr("checked", true);
                    
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
                    

                    var recogTimeH = $("#dtl_recog_time_h").data("kendoNumericTextBox");
                    var recogTimeM = $("#dtl_recog_time_m").data("kendoNumericTextBox");
                    
                    if(selectRow.ALW_STD_CD4=="Y"){
                        
                        $("#autoTime").show();

                        //recogTimeH.enable(false);
                        //recogTimeM.enable(false);
                    }else{

                        $("#autoTime").hide();
                        
                        //recogTimeH.enable(true);
                        //recogTimeM.enable(true);
                    }
                    

                    //kendoDatePicker min, max 세팅.
                    var start = $("#dtl_edu_start").data("kendoDatePicker") ;
                    var end = $("#dtl_edu_end").data("kendoDatePicker") ;
                    
                    var startDate = selectRow.EDU_STIME;
                    var endDate = selectRow.EDU_ETIME;

                    if (startDate) {
                        //startDate = new Date(startDate);
                        //startDate.setDate(startDate.getDate());
                        end.min(startDate);
                    } 
                    if (endDate) {
                        start.max(endDate);
                    } 
                     
                    
                    //상세데이터 바인딩..
                    kendo.bind($("#tabular"), selectRow);
                    

                    //교육기관명 세팅
                    if(selectRow.INSTITUTE_CODE == "Z"){
                        fn_dtl_institute_name_able();
                    }else{
                        fn_dtl_institute_name_disable();
                        $("#dtl_institute_name").val("");
                    }
                    
                    //부처지정여부 컨트롤.
                    //fn_deptDesignation();
                    
                    empList(selectRow.REQ_STS_CD); // 임직원 그리드

                    //첨부파일 리로드..
                    $("#objectId").val(selectedCell.ALW_STD_SEQ);
                    handleCallbackUploadResult();
                    
                    //마지막 결재자가 승인전이면 요청 취소 할수 있음 
                    if(selectRow.LAST_REQ_STS == 1 && selectRow.REQ_STS_CD !=0 ){ 
                    	//$("#cencleReqBtn").show();
                    }
                    
                    //승인이 된 경우 숨김
                    if(selectRow.REQ_STS_CD == "2"){
                    	//$("#cencleReqBtn").hide();
                    	$("#empInsertPop").hide();
                    	$("#subjectSearchBtn").hide();
                    	$("#saveBtn").show();
                    	 $("#empUpdatePop").show();//인정직급수정
                    }else if(selectRow.REQ_STS_CD == "3"){
                        //$("#cencleReqBtn").hide();
                        $("#empInsertPop").hide();
                        $("#subjectSearchBtn").hide();
                        $("#saveBtn").hide();
                    }else{
                    	$("#saveBtn").show();
                    }

                    $("#reqStsSpan").attr("style", "display: ;");
                    $("#reqStsEm").attr("style", "display: ;");
                    $("#reqStsEm").text(selectRow.REQ_STS_NM);
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
	    <%//if (isSystem){%>
	    	//$("#saveBtn").show();	
	    <%//}%>
	    

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
   
    
    // 첨부파일 함수 종료 =================================================================================================

</script>

</head>
<body>
<!-- 과정검색 팝업 -->
    <div id="subjectList-window" style="display:none; overflow-y: hidden;">
        <div style="position: relative;">
            <span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> ※ 개설할 과정을 검색 후 선택하시면 됩니다<br>
            <div id="subjectSearchGrid" ></div>
        </div>
    </div>
    <!-- 상위 부서 선택 팝업 -->
   <div id="dept-window" style="display: none;">
       <div style="width: 250px">
         <table style="width: 250px;">
           <tr>
               <td>
                   <div id="deptPopupTreeview"   style="width: 100%; height: 200px; "></div>
               </td>
           </tr>
         </table>
       </div>
    </div>
            
    <div class="container">
		<div id="cont_body">
		 <div class="content">
			 <div class="top_cont">
				<h3 class="tit01">상시학습관리</h3>
				<div class="point">
					※ 상시학습을 관리합니다. 
				</div>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>교육훈런&nbsp; &#62;</span>
					<span class="h">상시학습관리 </span>
				</div><!--//location-->
			</div>
			 <div class="sub_cont">
				<div class="result_info">
					<ul>	
					<li>
						<label for="p_year" style = "line-height:32px;">년도선택  : </label>
							<div class="emo-section k-header style01" id="p_year" >
							<select id="yyyy" style="width:120px;" accesskey="w" ></select>
							</div>
							 <style scoped>
								.demo-section.style01 {width:120px;}
								.k-input {padding-left:5px;}
							</style>       
						</li>
					</ul>  
					<%-- <a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp; --%>
            		<div class="btn">
            		<a id="lst-excel-btn" class="k-button" onclick="excelDown(this)" >엑셀 다운로드</a>&nbsp;
            			<%if(isSystem ==true){ %>
                    	<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp;
                    	<button id="excelUploadBtn" class="k-button" >엑셀 업로드</button>&nbsp;
                    	<%} %>
                    	<button id="newBtn" class="k-button" ><span class="k-icon k-i-plus"></span>상시학습등록</button>
					</div>
				</div><!--//btn_right-->
				 <div class="table_list">
                       <div id="splitter4" style="width:100%; height: 545px; border:none;" class="mt10 mb10 ie7_sp">
                            <div id="list_pane">
                                <div id="grid" ></div>
                            </div>
                            <div id="detail_pane4">
                                <div id="detail_info" class="detail_Info">
									
                                </div>
                            </div>
                        </div>
                    </div>
			 </div><!--//sub_cont-->
		 </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->
		
                                       
<script type="text/x-kendo-template"  id="template">
    <div class="tit">상시학습 <span id="reqStsSpan" class="state" style="display: none;">승인여부: <em id="reqStsEm" style="display: none;">미승인</em></span></div>
	<div class="dl_scroll" >
		<div class="dl_wrap"  id="tabular">
			<input type="hidden" id="alw_std_seq" data-bind="value:ALW_STD_SEQ" />
			<input type="hidden" id="reqNum" data-bind="value:REQ_NUM" />  
			<input type="hidden" name="objectId" id="objectId"/>
			<dl>
				<dt class="fir">부서원 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/> </dt>
				<dd class="fir">
					<div style="width: 100%;" id="empList"></div>
					<button class="k-button ie7_left" id="empInsertPop" style="margin-top: 5px;">부서원추가</button><button class="k-button ie7_left" id="empUpdatePop" style="margin-top: 5px;">인정직급수정</button><br>취득점수: 평가가 없는 경우 '0'입력, 평가가 있는 경우 점수 입력 및 증빙
				</dd>
			</dl>
			<dl>
                <dt> 과정명 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/> </dt>
                <dd>
                        <input class="k-textbox" id="dtl_subject_nm" data-bind="value:SUBJECT_NM"  style="width:250px;" onKeyUp="chkNull(this);"/>
                        <button id="subjectSearchBtn" class="k-button">과정검색</button>
                </dd>
            </dl>
            <dl>
                <dt> 해당년도 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/> </dt>
                <dd>
                    <input  id="dtl_yyyy" data-bind="value:YYYY" style="width:73px;border:none;" />
                </dd>
            </dl>
            <dl>
                <dt>학습기간 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/></dt>
                <dd>
                    <input type="text" class="" id="dtl_edu_start" style="width:115px;border:none;" title="학습시작일 " data-bind="value:EDU_STIME"/> ~
                    <input type="text" class="" id="dtl_edu_end" style="width:115px;border:none;" title="학습종료일" data-bind="value:EDU_ETIME"/>
                </dd>
            </dl>
            <dl>
                <dt>상시학습종류 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/></dt>
                <dd>
                    <select id="dtl_alw_std_cd1" data-bind="value:ALW_STD_CD1" accesskey="w" style="width:100%;" itle="상시학습 대분류 선택"></select><br>
                    <select id="dtl_alw_std_cd2" data-bind="value:ALW_STD_CD2" accesskey="w" style="width:100%;margin-top:10px;" title="상시학습 중분류 선택"></select><br>
                    <select id="dtl_alw_std_cd" data-bind="value:ALW_STD_CD" accesskey="w" style="width:100%;margin-top:10px;" title="상시학습 소분류 선택"></select><br>
                    <span style="color:blue">※ 인정시간기준 : </span><span id="alwStd_cm" style="color:blue" data-bind="text:ALW_STD_CD3" ></span>
                </dd>
            </dl>
            <dl>
                <dt >실적시간  <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/></dt>
                <dd>
                    <input type="text" id="dtl_edu_hour_h" style="width:100px;border:none;" title="시간 입력 " data-bind="value:EDU_HOUR_H"/> 시간 
                    <input type="text" id="dtl_edu_hour_m" style="width:100px;border:none;" title="분 입력 " data-bind="value:EDU_HOUR_M"/> 분
                </dd>
            </dl>
            <dl>
                <dt>인정시간 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/> </dt>
                <dd>
                    <input id="dtl_recog_time_h" data-bind="value:RECOG_TIME_H" style="width:100px;border:none;" />시간
                    <input id="dtl_recog_time_m" data-bind="value:RECOG_TIME_M" style="width:100px;border:none;" /> 분<br>
                    <span id="autoTime" style="color:red">※ 상시학습종류와 교육시간을 입력하면 자동 계산됩니다.</span>
                </dd>
            </dl>
            <dl>
				<dt>내용 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/></dt>
				<dd>
					<textarea class="textarea03 mt5" id="dtl_edu_cont" data-bind="value:EDU_CONT" rows="5" cols="10" style="width:100%;" title="교육의 내용"/></textarea>
				</dd>
			</dl>
			<dl style="display:none;" >
                <dt>지정학습종류 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/></dt>
                <dd>
                    <select id="dtl_dept_designation_cd" data-bind="value:DEPT_DESIGNATION_CD" style="width:250px;" accesskey="w" ></select>
                </dd>
            </dl>
            <dl>
				<dt>부처지정학습 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/> </dt>
				<dd>
						<input type="radio" name="dtl_dept_designation_yn" id="dtl_dept_designation_yn"   value="Y" title="부처지정" /><label class="depart">예</label>
              			<input type="radio" name="dtl_dept_designation_yn" id="dtl_dept_designation_yn"  value="N" title="부처미지정" /><label class="nodepart"> 아니오</label> 
				</dd>
			</dl>
			<dl>
                <dt >학습유형 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/> </dt>
                <dd >
                    <select id="dtl_training_code" style="width: 250px" accesskey="w" data-bind="value:TRAINING_CD" style="width:200px;" ></select>
                </dd>
            </dl>
            <dl>
				<dt>기관성과평가</dt>
				<dd>
					<select id="dtl_perf_asse_sbj_cd" data-bind="value:PERF_ASSE_SBJ_CD" style="width:250px;" accesskey="w"></select>
				</dd>
			</dl>
			<dl>
				<dt>업무시간구분</dt>
				<dd>
					<select id="dtl_office_time_cd" data-bind="value:OFFICETIME_CD" style="width:250px;" accesskey="w"></select>
				</dd>
			</dl>
			<dl>
				<dt>교육기관구분</dt>
				<dd>
					<select id="dtl_eduins_div_cd" data-bind="value:EDUINS_DIV_CD" style="width:250px;" accesskey="w"></select>
				</dd>
			</dl>
            <dl>
                <dt> 교육기관명 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/></dt>
                <dd>
                    <select id="dtl_institute_code" data-bind="value:INSTITUTE_CODE" style="width:100%;" ></select><br>
                    <input class="k-textbox inp_style03" id="dtl_institute_name" data-bind="value:INSTITUTE_NAME" style="width: 100%; margin-top:10px;" onKeyUp="chkNull(this);"/><br>
                    ※ '기타'인 경우 교육기관명을 입력하세요
                </dd>
            </dl>
            <dl style="display:none;" >
                <dt>필수여부 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif""  alt="필수"/> </dt>
                <dd>
                        <input type="radio" name="requiredYn"  id="requiredYn"   value="Y" title="필수여부" /><label class="depart">예</label>
                        <input type="radio" name="requiredYn" id="requiredYn"  value="N" title="필수여부" /><label class="nodepart"> 아니오</label> 
                </dd>
            </dl>
            <dl>
                <dt class="noline">학습 역량 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/></dt>
                <dd class="line">
                    <select id="dtl_cmpnumber" accesskey="w" data-bind="value:CMPNUMBER" style="width:100%;" ></select>
                </dd>
            </dl>
            <dl>
				<dt class="last3"> 증빙자료</dt>
				<dd class="last3">
					<div class="drag_Area" id="drag_report">
						<div class="info" id="drag_cmt">업로드할 파일은 아래의 파일선택 버튼을 클릭하여 직접 선택하거나, <br/>아래의 영역에 파일를 끌어서 놓기(Drag & Drop)를 하세요</div>
						<div class="area">
								<div id="my-file-upload" class="hide"></div>
						</div>
					</div>
					<div class="table_wp03">
	                        <div id="my-file-gird" ></div>
					</div>
					<div class="btn_btm2">
						<!--<button class="k-button" style="width:75px;" id="appReqBtn">승인요청</button>
						<button class="k-button" style="width:100px;" id="cencleReqBtn">승인요청취소</button>-->
						<button class="k-button" style="width:75px;" id="saveBtn">저장</button>
						<button class="k-button" style="width:75px;" id="deleteBtn">삭제</button>
						<button class="k-button" style="width:75px;" id="cancelBtn">취소</button>
					</div>
				</dd>
			</dl>
		</div>
	</div><!--//dl_scroll-->
</script>

<div id="excel-upload-window" style="display:none; width:340px;">
	        <form id="excelForm" name="excelForm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/em-admin-class-excel-upload.do?output=json" enctype="multipart/form-data" >
	        		※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
	           <div>
	               <input name="openUploadFile" id="openUploadFile" type="file" />
	               <br>
	               <div style="text-align: right;">
	                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/em_admin_upload_class_template.xls" class="k-button" >템플릿다운로드</a>
	                    <input type="submit" value="실행" class="k-button" id="uploadBtn"/>
	               </div>
	           </div>
	       </form>
	   </div>
<!-- 상시학습관리 증빙자료 첨부파일 template -->
    <script type="text/x-kendo-tmpl" id="fileupload-template">
        <input name="upload-file" id="upload-file" type="file"/>
    </script>
<%@ include file="/includes/jsp/user/common/findEmployeePopup.jsp"  %>
<%@ include file="/includes/jsp/user/common/apprStsPopup.jsp"  %>
<%@ include file="/includes/jsp/user/common/apprReqPopup.jsp"  %>
</body>
</html>