<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
메뉴 : 교육훈련 상시학습
 --%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="java.util.*"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}

kr.podosoft.ws.service.em.action.EmAlwMainAction action = (kr.podosoft.ws.service.em.action.EmAlwMainAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
String gradeNum = action.getUser().getProfile().get("GRADE_NUM")+"";

Map<String,Object> yearMap = (Map<String,Object>)request.getAttribute("item");
int minYear = Integer.parseInt(yearMap.get("ALW_MIN_YYYY").toString());
int maxYear = Integer.parseInt(yearMap.get("MAX_YYYY").toString());
int nowYear = Integer.parseInt(yearMap.get("YYYY").toString());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage"   >
<head>
<title></title>
<script type="text/javascript">
var dataSource_list1;
var page_mode = 'dtl'; // page 상태(dtl/reg/mod)
var instituteCode;
var curGradeNum = '<%=gradeNum%>'; //현직급
var tUserid = <%=action.getUser().getUserId()%>;
yepnope([{
    load: [
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.<%=theme%>.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/front-ui_mpva.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
    ],
    complete: function() {
        kendo.culture("ko-KR"); 

        //로딩바 선언..
        loadingDefine();
        
     	// 검색년도 생성
        var yearList = new Array();
        var obj = null;
		<% for(;maxYear>=minYear; maxYear--) { %>
		obj = new Object();
		obj.text = '<%=maxYear%>';
		obj.value = '<%=maxYear%>';
		yearList.push(obj);
		<% } %>
        $("#yyyy").kendoDropDownList({
            dataTextField: "text",
            dataValueField: "value",
            dataSource: yearList,
            index: 0,
            change: fn_yyyyOnChange
        });
        $('#yyyy').data('kendoDropDownList').value('<%= nowYear%>');
        
        /* Tab Gride DataSoure */
        dataSource_list1 = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/select-list.do?output=json", type:"POST" }
            },
            schema: {
            	total: "totalItemCount",
                data: "items",
                model: {
                    fields: {
                    	ALW_STD_NM : { type: "string" } ,
                 	   	ASSEQ  : { type: "int" },
                 	   	SUBJECT_NM : { type : "string" },
                 	   	TRAINING_NM : {type:"number"},
                 	   	YYYY : {type:"int"},
                 	   	EDU_PERIOD : { type:"string" },
                 	   	DEPT_DESIGNATION_YN : { type:"string"},
                 	   	REQ_NUM : { type: "int" },
                 	   	REQ_STS_NM : { type: "string" },
                 	   	RECOG_TIME : {type:"string"}
                    }
                }
            },
            serverPaging: false,
            serverFiltering: false,
            serverSorting: false,
			pageSize: 30,
            error : function(e) {
                //alert(e.status);
                if(e.xhr.status==403){
                   alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                   sessionout();
                }else{
                   alert('xhr.status = ' + e.xhr.status + '\n' +  'xhr.statusText = '  + e.xhr.statusText );
                }
            },
			requestEnd : function(e) {
				if(e.type == "read") {
					if(e.response.totalItemCount!=null && e.response.totalItemCount > 0) {
						dataSource_list1.filter({
					           "field" : "YYYY",
					           "operator" : "eq",
					           "value" : Number($('#yyyy').val())
					    });
					}
				}
			}
		});
        
		$("#grid1").kendoGrid({
			dataSource: dataSource_list1,
			height: 535,
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
			resizable: true,
			reorderable: true,
			selectable: true,
			change : function(arg) {
				
			},
			pageable : {
                refresh : false,
                pageSizes : [10,20,30],
                buttonCount: 5
            },
			columns: [{
				field: "ALW_STD_NM",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:left"},
                title: "상시학습종류",
				width:200
			}, {
				field: "SUBJECT_NM", title: "과정명",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left;text-decoration: underline;" },
				template: "<a href='javascript:void(0);' onclick='fn_sbjctInfoOpen(${ASSEQ}, \"dtl\", \"dtl\");return false;' >${SUBJECT_NM}</a>",
				width:300
			}, {
				field: "EDU_PERIOD",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
                title: "교육기간",
				width:200
			}, {
				field: "RECOG_TIME",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
				title: "인정시간",
				width:120
			}, {
				field: "DEPT_DESIGNATION_YN",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
				title: "부처지정학습",
				width:130
			}, {
				field: "REQ_STS_NM",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
				title: "승인현황",
				width:110,
                template: function(data){
                	// 결재번호가 있고 결재상태가 '0'이 아닐경우 결재정보 팝업버튼 생성
                	if(typeof data.REQ_NUM!='undifined' && data.REQ_NUM>0){
                		if(data.REQ_STS_CD!="0") {
							return "<a class=\"k-button\" onclick=\"fn_apprOpen("+data.REQ_NUM+", '"+data.CANCEL_YN+"'); return false;\" >"+data.REQ_STS_NM+"</a>";
                		} else {
                			return data.REQ_STS_NM;
                		}
                    } else {
                    	return data.REQ_STS_NM;
                    }
                }
			}]
		});

		$("#splitter1").kendoSplitter({
            orientation : "horizontal",
            panes : [ {
                collapsible : true,
                min : "500px"
            }, {
                collapsible : true,
                collapsed : true,
                min : "500px"
            } ]
        });

        /* 상세영역 생성 */
        $('#details1').show().html(kendo.template($('#template').html()));
        
      	/* 학습유형 데이터소스 */
        dataSource_training = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
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
            serverSorting: false
		});

        /* 지정학습구분 데이터소스 */
        dataSource_deptDesignation = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
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
            serverSorting: false
		});

        /* 기관성과평가필수교육과정 데이터소스 */
        dataSource_perfAsseSbjCd = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
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
            serverSorting: false
		});
        
        /* 업무시간구분 데이터소스 */
        dataSource_officeTimeCd = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
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
            serverSorting: false
		});
        
        /* 교육기관구분 데이터소스 */
        dataSource_eduinsDivCd = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
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
            serverSorting: false
		});
        
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
      

        //역량 콤보박스 datasource
        var compDataSource = new kendo.data.DataSource({
               type: "json",
               transport: {
                   read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_my_competency_combo_list.do?output=json", type:"POST" },
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
        
      
        /* 상시학습유형 1 데이터소스 */
        dataSource_alwStdCd1 = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/alw-std-type.do?output=json", type:"POST" },
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
            serverSorting: false
		});
        /* 상시학습유형 2 데이터소스 */
        dataSource_alwStdCd2 = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/alw-std-type.do?output=json", type:"POST" },
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
            serverSorting: false
		});
        /* 상시학습유형 3 데이터소스 */
        dataSource_alwStdCd = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/alw-std-type.do?output=json", type:"POST" },
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
            serverSorting: false
		});
		/* 상시학습종류 Level 2 초기화 */
        dataSource_alwStdCd2.fetch(function(){
        	dataSource_alwStdCd2.filter({ field: "VALUE", operator: "eq", value: "" });
        	dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
        });
        /* 상시학습종류 Level 3 초기화 */
        dataSource_alwStdCd.fetch(function(){
            dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
        }); 
        

        /* 직급 데이터소스 */
        dataSource_gradeNum = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
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
            serverSorting: false
        });
        
        /* 학습유형 */ 
        $("#dtl_training_code").kendoDropDownList({
             dataTextField: "TEXT",
             dataValueField: "VALUE",
             dataSource: dataSource_training,
             filter: "contains",
             suggest: true
        }).data("kendoDropDownList");
        
        /* 지정학습구분 */
        $("#dtl_dept_designation_cd").kendoDropDownList({
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

        
        /* 기관성과평가필수교육과정 */
        $("#dtl_perf_asse_sbj_cd").kendoDropDownList({
             dataTextField: "TEXT",
             dataValueField: "VALUE",
             dataSource: dataSource_perfAsseSbjCd,
             filter: "contains",
             suggest: true
        }).data("kendoDropDownList");
        
        /* 업무시간구분 */
        $("#dtl_office_time_cd").kendoDropDownList({
             dataTextField: "TEXT",
             dataValueField: "VALUE",
             dataSource: dataSource_officeTimeCd,
             filter: "contains",
             suggest: true
         }).data("kendoDropDownList");

        /* 교육기관구분 */
        $("#dtl_eduins_div_cd").kendoDropDownList({
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
        
        
        /* 상시학습종류 Level 1 */
        $("#dtl_alw_std_cd1").kendoDropDownList({
             dataTextField: "TEXT",
             dataValueField: "VALUE",
             dataSource: dataSource_alwStdCd1,
             filter: "contains",
             suggest: true,
             change:function(){
            	 if( removeNullStr($("#dtl_alw_std_cd1").val())==""){
            		 $("#dtl_alw_std_cd2").val("");
            		 $("#dtl_alw_std_cd").val("");

            		 dataSource_alwStdCd2.filter({ field: "VALUE", operator: "eq", value: "" });
            		 dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
            	 }else{
            		 dataSource_alwStdCd2.filter({
           				 logic: "or",
           			        filters: [
           			               { field: "P_VALUE", operator: "contains", value:  $("#dtl_alw_std_cd1").val()},
           			               { field: "VALUE", operator: "eq", value: "" }
           			       ]
            		 });
            		 dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
            	 }
             }
        }).data("kendoDropDownList");
        
        // 상시학습종류 Level 2
        $("#dtl_alw_std_cd2").kendoDropDownList({
            dataTextField: "TEXT",
            dataValueField: "VALUE",
            dataSource: dataSource_alwStdCd2,
            filter: "contains",
            suggest: true,
            change:function(){
                if( removeNullStr($("#dtl_alw_std_cd2").val())=="" ){
                    $("#dtl_alw_std_cd").val("");

                    dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
                }else{
                	dataSource_alwStdCd.filter({
                        logic: "or",
                           filters: [
                                  { field: "P_VALUE", operator: "contains", value: $("#dtl_alw_std_cd2").val()},
                                  { field: "VALUE", operator: "eq", value: "" }
                          ]
                    });
                }
            }
        }).data("kendoDropDownList");
        
        // 상시학습종류 Level 3
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
        
        /* 학습기간 시작일 */
        $("#dtl_edu_start").kendoDatePicker({
   		   format: "yyyy-MM-dd",
   		   change: function(e) {                    
   			   	var startDate = $("#dtl_edu_start").val();
   	         	var endDate = $("#dtl_edu_end").val();

   	         	if (startDate ) {
   	            	//startDate = new Date(startDate);
   	            	//startDate.setDate(startDate.getDate());
   	          		$("#dtl_edu_end").data('kendoDatePicker').min(startDate);
   	         	} /*else if (endDate) {
   	        		$("#dtl_edu_start").data('kendoDatePicker').max(new Date(endDate));
   	         	} else {
   	             	endDate = new Date();
   	          		$("#dtl_edu_start").data('kendoDatePicker').max(endDate);
   	          		$("#dtl_edu_end").data('kendoDatePicker').min(endDate);
   	         	}*/
   	  		}
   	  	}).data("kendoDatePicker");
		/* 학습기간 종료일 */
   	  	$("#dtl_edu_end").kendoDatePicker({
   		   format: "yyyy-MM-dd",
   		   change: function(e) {
   				var startDate = $("#dtl_edu_start").val();
   			   	var endDate = $("#dtl_edu_end").val();
   	    	
				if (endDate) {
					//endDate = new Date(endDate);
  	    	        //endDate.setDate(endDate.getDate());
  	    	      	$("#dtl_edu_start").data('kendoDatePicker').max(endDate);
  	    	    } /*else if (startDate) {
  	    	    	$("#dtl_edu_end").data('kendoDatePicker').min(new Date(startDate));
  	    	    } else {
  	    	        endDate = new Date();
  	    	      	$("#dtl_edu_start").data('kendoDatePicker').max(endDate);
  	    	      	$("#dtl_edu_end").data('kendoDatePicker').min(endDate);
  	    	    }*/
			}
   	  	}).data("kendoDatePicker");
		
	   	$("#dtl_yyyy").kendoNumericTextBox({
	         format: "",
	         min: 2000,
	         max: 9999,
	         step: 1
	    }).data("kendoNumericTextBox");
		
	   	//인정시간_시간
	   	var recogTimeH = $("#dtl_recog_time_h").kendoNumericTextBox({
	         format: "",
	         min: 0,
	         max: 9999,
	         step: 1
	    }).data("kendoNumericTextBox");
	    //인정시간_분
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
	         max: 9999,
	         step: 1,
             change: function(){
                 var data=alwStdCd.dataItem();
                 if(data.get("CD_VALUE5")=="Y"){
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
		
        /* 직급 */ 
        var dtlGradeNum = $("#dtl_grade_num").kendoDropDownList({
             dataTextField: "TEXT",
             dataValueField: "VALUE",
             dataSource: dataSource_gradeNum,
             filter: "contains",
             suggest: true
        }).data("kendoDropDownList");
        
   		/* 부처지정 여부가 예/아니오에 따라 지정학습구분 
   		$('#details1 input:radio[name="dtl_dept_designation_yn"]').change(function(){
   			if($('#details1 input:radio[name="dtl_dept_designation_yn"]:checked').val()=="Y"){
   	            $("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").enable();
   	        }else{
   	        	$("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").select(0);
   	            $("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").enable(false);
   	        }
   		});*/
   		
   		/* 첨부파일 영역생성 */
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
                                return { objectType: objectType, objectId:$("#dtl_object_id").val(), attachmentId :options.attachmentId };                                                                   
                            }else{
                                 return { objectType: objectType, objectId:$("#dtl_object_id").val(), startIndex: options.skip, pageSize: options.pageSize };
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
                       template: function(dataItem) {
                    	   if(page_mode == 'dtl') {
                    		   return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>';
                    	   } else {
                    		   return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>'+
                               '<button style="width:60px; min-width: 50px;" class="k-button" onclick="deleteFile('+dataItem.attachmentId+')">삭제</button>';   
                    	   }
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
                            
                        var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#dtl_object_id").val() +"&fileType=doc" ;
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
                        e.data = {objectType: objectType, objectId:$("#dtl_object_id").val()};                                                                                                                    
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
                
                $("#drag_cmt").show();
            }
        }
        
		/* 상시학습등록 버튼 Click Event */
		$('#regBtn').click(function() {
			page_mode = 'reg';
			$('#dtl_title').text('상시학습 등록');
			
			var obj = new Object();

			// 기본정보 초기화
			obj.YYYY = '<%=nowYear%>'; // 해당년도 초기화
			obj.EDU_HOUR_H = '0';
			obj.EDU_HOUR_M = '0';
			obj.RECOG_TIME_H = '0';
			obj.RECOG_TIME_M = '0';
			obj.DEPT_DESIGNATION_YN = 'N';
			
            kendo.bind($('#detail_pane1').children(), obj);
            
            $('#detail_pane1 input:radio[name=dtl_dept_designation_yn]:input[value=N]').attr("checked", true); // 지정학습

            $('#detail_pane1 input:radio[name=dtl_required_yn]:input[value=N]').attr("checked", true); // 필수여부
            
            /*
            if($('#details1 input:radio[name="dtl_dept_designation_yn"]:checked').val()=="Y"){
                $("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").enable();
            }else{
            	$("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").select(0);
                $("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").enable(false);
            }
			*/
			
            
            // 첨부파일 임시 objectid 세팅
	        var ranval = Math.floor(Math.random()*1000000000); 
	        $("#details1 #dtl_object_id").val(ranval);

			// 업로드 영역 활성화
			$("#details1 #drag_report").show();
			// 파일목록 활성화
			$("#details1 #my-file-gird").show();
			// 첨부파일 초기화
	        $("#details1 #my-file-gird").data('kendoGrid').dataSource.data([]);
			
	        $('#details1 #saveBtn').show();
	        $('#details1 #cancelBtn').hide();	        
	        $('#details1 #deleteBtn').hide();
	        
			// 상세창 열기
	        $('#splitter1').data("kendoSplitter").expand('#detail_pane1');
			
	        //교육기관명 입력 제어.
	        fn_dtl_institute_name_disable();
	        
	        $("#autoTime").hide();
            
	        //직급을 현직급이 선택되도록 처리
	        if(curGradeNum){
	        	dtlGradeNum.value(curGradeNum);
	        }
	        

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
             
            
		});
		
		//학습역량
        var cmptCombo = $("#details1 #dtl_cmpnumber").kendoComboBox({
            dataTextField: "TEXT",
            dataValueField: "VALUE",
            dataSource: compDataSource,
            suggest: true,
            placeholder : "학습에 도움이 된 역량을 선택해주세요."
        }).data("kendoComboBox");
        cmptCombo.options.filter = "contains";

		/* 승인요청 버튼 Click Event */
		$('#details1 #saveBtn').click(function(){ fn_saveEvent(); });
		/* 요청취소 버튼 Click Event */
		$('#details1 #cancelBtn').click(function(){ fn_cancelEvent(); }); 
		/* 과정검색 버튼  Click Event */
		$('#details1 #subjectSearchBtn').click(function(){ 
			findSubjectList();
			fsp_callBackFunction = fn_fsp_callBackFunction;
		});
		/* 닫기버튼 Click Event */
		$('#details1 #closeBtn').click(function(){ 
			$("#splitter1").data('kendoSplitter').toggle("#detail_pane1",false);
			page_mode = 'dtl'; // 페이지 상태변경
		});
		
		/* 삭제버튼 Click Event */
		$("#details1 #deleteBtn").click(function() { fn_deleteEvent(); });
		
		// 현재년도 교육이수현황 조회
		//fn_getTaskEdu();
    }
 
}]);


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


/* 과정검색 적용 시 작동하는 Fucntion */
var fn_fsp_callBackFunction = function(obj) {

	if(obj!=null) {
        obj.YYYY = '<%=nowYear%>'; // 해당년도

        if(page_mode=='mod') {
        	// 수정 시
        	obj.OBJECTID = $('#dtl_object_id').val(); // 파일ID 셋팅
        } else {
        	// 등록 시
        	// 첨부파일 임시 objectid 생성
        	var ranval = Math.floor(Math.random()*1000000000);
        	obj.OBJECTID = ranval; // 파일ID 셋팅
        }
        
        kendo.bind($('#detail_pane1').children(), obj); // 상세정보 바인딩
        
        $('#detail_pane1 input:radio[name=dtl_required_yn]:input[value='+obj.REQUIRED_YN+']').attr("checked", true); // 필수여부
		

        $('#detail_pane1 input:radio[name=dtl_dept_designation_yn]:input[value='+obj.DEPT_DESIGNATION_YN+']').attr("checked", true); // 지정학습
        
        /*
 		if($('#details1 input:radio[name="dtl_dept_designation_yn"]:checked').val()=="Y"){
            $("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").enable();
        }else{
        	$("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").select(0);
            $("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").enable(false);
        }
 		*/
 		
     	// 상시학습종류 Level2
     	dataSource_alwStdCd2.filter({
            logic: "or",
            filters: [
               { field: "P_VALUE", operator: "eq", value:  obj.ALW_STD_CD1},
               { field: "VALUE", operator: "eq", value: "" }
            ]
        });
     	// 상시학습종류 Level3
        dataSource_alwStdCd.filter({ 
			logic: "or",
            filters: [
              { field: "P_VALUE", operator: "eq", value:  obj.ALW_STD_CD2},
              { field: "VALUE", operator: "eq", value: "" }
            ]
        });
	} else {
		kendo.bind($('#detail_pane1').children(), null); // 상세정보 바인딩
	}
};

/* 검색년도 변경 시 목록 필터링 */
var fn_yyyyOnChange = function() {
	dataSource_list1.filter({
           "field" : "YYYY",
           "operator" : "eq",
           "value" : Number($('#yyyy').val())
    });
	
	// 상세 숨기기
	$("#splitter1").data('kendoSplitter').toggle("#detail_pane1",false);
	
	//fn_getTaskEdu();
};

/* 이수현황 조회 */
var fn_getTaskEdu = function() {
	$.ajax({
        type : 'POST',
        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/select-te-list.do?output=json",
        data : { 
        	year : '<%=nowYear%>'				
        },
        complete : function( response ){
            var obj = eval("(" + response.responseText + ")");
             if(obj.error){
                 alert("ERROR=>"+obj.error.message);
             }else{
            	var html2 = '';
            	var html3 = '';
            	
            	$('#req_task_stt').empty();
            	$('#pa_task_stt').empty();
            	$('#req_task_stt').removeClass('yes');
            	$('#req_task_stt').removeClass('no');
            	$('#pa_task_stt').removeClass('yes');
            	$('#pa_task_stt').removeClass('no');
            	$('#req_task_stt_list').empty();
            	$('#pa_task_stt_list').empty();
            	 
                if(obj.item!=null) {
                	if(obj.item.SCR_CHK1=='Y') {
                		$('#req_task_stt').text('이수');
                		$('#req_task_stt').addClass('yes');
                	} else {
                		$('#req_task_stt').text('미이수');
                		$('#req_task_stt').addClass('no');
                	}
                	
                	if(obj.item.SCR_CHK2=='Y') {
                		$('#pa_task_stt').text('이수');
                		$('#pa_task_stt').addClass('yes');
                	} else {
                		$('#pa_task_stt').text('미이수');
                		$('#pa_task_stt').addClass('no');
                	}
                }
                
				if(obj.items1!=null) {
					if(obj.items1.length > 0) {
						var colspanCnt = 0;
						
						html2 = '<table class="table_type02">';
						html2 += '<colgroup>';
						html2 += '<col style="width:180px"/>';
						$.each(obj.items1, function(i, e) {
							if(i>0) {
								// 첫행은 총시간이므로 제외
								html2 += '<col style="width:*" />';
								colspanCnt++;
							}
						});
						html2 += '</colgroup>';
						html2 += '<thead>';
						html2 += '<tr>';
						html2 += '<th rowspan="2" class="fir"></th>';
						html2 += '<th rowspan="2" class="fir">총시간</th>';
						html2 += '<th colspan="'+colspanCnt+'" class="fir">부서지정학습 </th>';
						html2 += '</tr>';
						html2 += '<tr>';
						$.each(obj.items1, function(i, e) {
							if(i>0) {
								// 첫행은 총시간이므로 제외
								html2 += '<th><span class="blue">'+e.LABEL+'</span></th>';
							}
						});
						html2 += '</tr>';
						html2 += '</thead>';
						html2 += '<tbody>';
						html2 += '<tr>';
						html2 += '<td>필수시간(H)</td>';
						$.each(obj.items1, function(i, e) {
							html2 += '<td>'+e.REQ_TIME+'</td>';
						});
						html2 += '</tr>';
						html2 += '<tr>';
						html2 += '<td>이수시간(H)</td>';
						$.each(obj.items1, function(i, e) {
							html2 += '<td>'+e.TAKE_TIME+'</td>';
						});
						html2 += '</tr>';
						html2 += '</tbody>';
						html2 += '</table>';
					} else {
						html2 = '※ 현재 설정된 필수 이수 현황이 존재 하지 않습니다.';
					}
				}
				
				$('#req_task_stt_list').append(html2);
				
				if(obj.items2!=null) {
					if(obj.items2.length>0) {
						html3 = '<table class="table_type02">';
						html3 += '<colgroup>';
						html3 += '<col style="width:180px"/>';
						$.each(obj.items2, function(i, e) {
							html3 += '<col style="width:*" />';
						});
						html3 += '</colgroup>';
						html3 += '<thead>';
						html3 += '<tr>';
						html3 += '<th></th>';
						$.each(obj.items2, function(i, e) {
							html3 += '<th>'+e.LABEL+'</th>';	
						});
						html3 += '</tr>';
						html3 += '</thead>';
						html3 += '<tbody>';
						html3 += '<tr>';
						html3 += '<td>필수시간(H)</td>';
						$.each(obj.items2, function(i, e) {
							html3 += '<td>'+e.REQ_TIME+'</td>';
						});
						html3 += '</tr>';
						html3 += '<tr>';
						html3 += '<td>이수시간(H)</td>';
						$.each(obj.items2, function(i, e) {
							html3 += '<td>'+e.TAKE_TIME+'</td>';
						});
						html3 += '</tr>';
						html3 += '</tbody>';
						html3 += '</table>';
					} else {
						html3 = '※ 현재 설정된 기관성과평가 이수 현황이 존재 하지 않습니다.';
					}
				}
            	
				$('#pa_task_stt_list').append(html3);
             }
        },
        error: function( xhr, ajaxOptions, thrownError){
           // 로딩바 제거
           //loadingClose();
            
           if(xhr.status==403){
               alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
               sessionout();
           }else{
               alert('xrs.status = ' + xhr.status + '\n' + 
                       'thrown error = ' + thrownError + '\n' +
                       'xhr.statusText = '  + xhr.statusText );
           }
           
            if(event.preventDefault){
                event.preventDefault();
            } else {
                event.returnValue = false;
            };
        },
        dataType : "json"
    });
};

/* 상시학습등록 */
var fn_saveEvent = function() {
	// 벨리데이션 체크 시작
	
    if( $("#dtl_subject_nm").val() == "" ) {
        alert("과정명을 입력해주세요.");
        $("#dtl_subject_nm").focus();
        return false;
    }

    if($('#dtl_yyyy').val()==""){
        alert("해당년도를 입력해주세요.");
        $('#dtl_yyyy').focus();
        return false;
    }

    if( removeNullStr($('#dtl_alw_std_cd1').val())=='' || 
        removeNullStr($('#dtl_alw_std_cd2').val())=='' || 
        removeNullStr($('#dtl_alw_std_cd').val())==''){
        
        alert("상시학습종류를 3차까지 선택해주세요.");
        
        if( removeNullStr($('#dtl_alw_std_cd1').val())=='') {
            $('#dtl_alw_std_cd1').focus();
        } else if( removeNullStr($('#dtl_alw_std_cd2').val())=="" ){
            $('#dtl_alw_std_cd2').focus();
        }else{
            $('#dtl_alw_std_cd').focus();
        }
        return false;
    }

    if( $("#dtl_edu_start").val() == "" ){
        alert("학습기간 시작일을 입력하세요.");
        $("#dtl_edu_start").focus();
        return;
    }
    
    if( $("#dtl_edu_end").val() == "" ){
        alert("학습기간 종료일을 입력하세요.");
        $("#dtl_edu_end").focus();
        return;
    }
    
    if(ex_date("학습기간 시작일", "dtl_edu_start")==false){
        return;
    }
    
    if(ex_date("학습기간 종료일", "dtl_edu_end")==false){
        return;
    }

    
    if( $('#dtl_edu_hour_h').val() == "" && $('#dtl_edu_hour_m').val() == "" ) {
        alert("실적시간을 입력해주세요.");
        $('#dtl_recog_time_h').focus();
        return false;
    }
    

    if( $('#dtl_recog_time_h').val() == "" && $('#dtl_recog_time_m').val() == "" ) {
        alert("인정시간을 입력해주세요.");
        $('#dtl_recog_time_h').focus();
        return false;
    }

    if( removeNullStr($('#dtl_grade_num').val()) == '' ){
        alert("인정직급을 선택해주세요");
        $('#dtl_grade_num').focus();
        return false;
    }
    
    if( $("#dtl_tt_get_sco").val() == "" ) {
        //alert("취득점수를 입력해주세요.");
        //$("#dtl_tt_get_sco").focus();
        //return false;
    }
    
    // 내용 필수 체크
    if( $("#dtl_edu_cont").val() == "") {
    	alert("내용을 입력해주세요.");
    	$("#dtl_edu_cont").focus();
    	return false;
    }
    
    if(!$(':radio[name="dtl_dept_designation_yn"]:checked').val() || $(':radio[name="dtl_dept_designation_yn"]:checked').val()==null){
        alert("부처지정학습을 선택해주세요");
        return false;
    }
    
    /*
    if( removeNullStr($('#dtl_dept_designation_cd').val())==''){
        alert("지정학습종류를 선택해주세요.");
        $('dtl_dept_designation_cd').focus();
        return false;
    }
    */
    if( removeNullStr($('#dtl_training_code').val()) == '' ){
        alert("학습유형을 선택해주세요");
        $('#dtl_training_code').focus();
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
    
	// 벨리데이션 체크 종료
	
    //상시학습종류별 연간인정시간 체크
    $.ajax({
        type : 'POST',
        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/year_recog_limit_check.do?output=json",
        data : {
        	asOpenSeq : $("#dtl_asseq").val(),
            tUserid : tUserid,
            eduDiv : "2",
            yyyy : $("#dtl_yyyy").val(),
            recogTimeH : $("#dtl_recog_time_h").val(),
            recogTimeM : $("#dtl_recog_time_m").val(),
            alwStdCd : removeNullStr( $("#dtl_alw_std_cd").val() )
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
                	 if(!confirm("상시학습 정보를 등록하시겠습니까?")) return;
                 }
                 // 결재창 오픈
                 apprReqOpen();
                 apprReqCallBackFunc = fn_saveInf;
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
	
    
	
};

/* 상시학습정보 등록 */
var fn_saveInf = function() {
	var appr_list = null;
	
	if($("#apprReqUserGrid").data("kendoGrid")){
		appr_list = $("#apprReqUserGrid").data("kendoGrid").dataSource.data();
	} else {
		alert('승인자 정보가 없습니다. 승인자를 선택해주세요.');
		return;
	}
	var instituteNm = ""
	if(instituteCode.value() == "Z"){
		instituteNm =  $("#dtl_institute_name").val();
	}else{
		instituteNm = instituteCode.text();
	}
	//alert(instituteCode.value()+","+instituteNm);
    
	var cmp = $("#dtl_cmpnumber").data("kendoComboBox");
	var cmpVal;
	if(cmp.select() < 0){
		cmpVal = "";
	}else{
		cmpVal = cmp.value();
	}
	//로딩바생성.
   	loadingOpen();
	
	$.ajax({
        type : 'POST',
        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/insert-alw-inf.do?output=json",
        data : {
        	mod : page_mode,
        	asseq : page_mode=='mod' ? $("#dtl_asseq").val() : '',
        	objectid : $("#dtl_object_id").val(),
            trainingCode : removeNullStr( $("#dtl_training_code").val() ),
            subjectNm : $("#dtl_subject_nm").val(),
            ttGetSco : $("#dtl_tt_get_sco").val(),
            yyyy : $("#dtl_yyyy").val(),
            eduStime : $("#dtl_edu_start").val(),
            eduEtime : $("#dtl_edu_end").val(),
            eduHourH : $("#dtl_edu_hour_h").val(),
            eduHourM : $("#dtl_edu_hour_m").val(),
            recogTimeH : $("#dtl_recog_time_h").val(),
            recogTimeM : $("#dtl_recog_time_m").val(),
            eduCont : $("#dtl_edu_cont").val(),
            alwStdCd : removeNullStr( $("#dtl_alw_std_cd").val() ),
            deptDesignationYn : $(':radio[name="dtl_dept_designation_yn"]:checked').val(),
            deptDesignationCd : removeNullStr( $("#dtl_dept_designation_cd").val() ),
            perfAsseSbjCd : removeNullStr( $("#dtl_perf_asse_sbj_cd").val() ),
            officeTimeCd : removeNullStr( $("#dtl_office_time_cd").val() ),
            eduinsDivCd : removeNullStr( $("#dtl_eduins_div_cd").val() ),
            instituteCode : removeNullStr( $("#dtl_institute_code").val() ),
            instituteName : instituteNm,
            requiredYn : $(':radio[name="dtl_required_yn"]:checked').val(),
        	apprList : kendo.stringify( appr_list ),
        	gradeNum : $("#dtl_grade_num").val(),
        	cmpnumber : cmpVal
        },
        complete : function( response ){
        	// 로딩바 제거
            loadingClose();
        	
            var obj = eval("(" + response.responseText + ")");
            if(obj.error){
                 alert("ERROR=>"+obj.error.message);
            } else {
            	 if(obj.statement=='Y') {
            		alert("등록되었습니다.");

            		dataSource_list1.read(); // 등록 후 목록 재호출
            		$("#splitter1").data('kendoSplitter').toggle("#detail_pane1",false); // 상세창 닫기
            		page_mode = 'dtl'; // 페이지 상태변경
            		
            	 } else {
            		 alert("등록에 실패하였습니다.");
            	 }
             }
        },
        error: function( xhr, ajaxOptions, thrownError){
           // 로딩바 제거
           loadingClose();
            
           if(xhr.status==403){
               alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
               sessionout();
           }else{
               alert('xrs.status = ' + xhr.status + '\n' + 
                       'thrown error = ' + thrownError + '\n' +
                       'xhr.statusText = '  + xhr.statusText );
           }
           
            if(event.preventDefault){
                event.preventDefault();
            } else {
                event.returnValue = false;
            };
        },
        dataType : "json"
    });
};

/* 상시학습 요청취소 */
var fn_cancelEvent = function() {
	if(confirm("승인요청을 취소 하시겠습니까?")){
		loadingOpen();
		$.ajax({
            type : 'POST',          
            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/cencle-alw-req.do?output=json",
            data : {
            	alwSeq : $("#dtl_asseq").val(),
            	reqNum : $("#dtl_req_num").val()
            },
            complete : function( response ){
            	//로딩바 제거.
                loadingClose();
                
                var obj  = eval("(" + response.responseText + ")");
                if(!obj.error){
                	if(obj.saveCount > 0){         
                        // 목록 재조회
                        $("#grid1").data("kendoGrid").dataSource.read();
                        // 상세 재조회
                        fn_sbjctInfoOpen($("#dtl_asseq").val(), 'dtl', 'dtl');
                        
                        alert("승인요청이 취소되었습니다.");  
                    }else{
                        alert("승인요청취소에 실패하였습니다.");
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
};

/* 상시학습 삭제 */
var fn_deleteEvent = function() {
	if(confirm("해당 학습을 삭제 하시겠습니까?")){
		loadingOpen();
		$.ajax({
            type : 'POST',          
            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/del-alw-req.do?output=json",
            data : {
            	alwSeq : $("#dtl_asseq").val()
            },
            complete : function( response ){
            	//로딩바 제거.
                loadingClose();
                
                var obj  = eval("(" + response.responseText + ")");
                if(!obj.error){
                	if(obj.saveCount > 0){         
                        // 상세영역 활성화
                        $("#grid1").data("kendoGrid").dataSource.read();
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
};

/* 엑셀다운로드 */
var fn_excelDownload = function(button){
   	button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/down-list-excel.do?year="+$('#yyyy').val();
};

/* 결재창 팝업 열기 */
var fn_apprOpen = function(reqNum, cTf){
	//승인현황 팝업 호출.
	apprStsOpen(3, reqNum, cTf);
	//승인취소 처리 후 callback 함수 정의
	reqCancelCompleteCallbackFunc = fn_afterEduCancel;
};

/* 승인취소 후 호출Fucntion */
var fn_afterEduCancel = function() {
	dataSource_list1.read(); // 목록 재호출
	fn_sbjctInfoOpen($('#dtl_asseq').val(), 'mod', 'list'); // 상세페이지 재호출
};

/* 상세정보 열기 */
var fn_sbjctInfoOpen = function(seq, pmode, page) {
	
	$('#detail_pane1 #saveBtn').hide(); // 승인요청 버튼 숨김
	$('#detail_pane1 #cancelBtn').hide(); // 승인요청취소 버튼 숨김
	$('#detail_pane1 #deleteBtn').hide(); // 삭제 버튼 숨김 
	
	if(seq!=null) {
		$.ajax({
	        type : 'POST',
	        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/select-dtl.do?output=json",
	        data : { 
	        	asSeq : seq
	        },
	        complete : function( response ){
	            var obj = eval("(" + response.responseText + ")");
	             if(obj.error){
	                 alert("ERROR=>"+obj.error.message);
	             } else {
					$('#dtl_title').text('상시학습 정보');
					
					// 상세창 열기
             		if(page=='dtl') $('#splitter1').data("kendoSplitter").expand('#detail_pane1');
             		
             		$('#detail_pane1 input:radio[name=dtl_dept_designation_yn]:input[value='+obj.item.DEPT_DESIGNATION_YN+']').attr("checked", true); // 부처지정학습여부
             		$('#detail_pane1 input:radio[name=dtl_required_yn]:input[value='+obj.item.REQUIRED_YN+']').attr("checked", true); // 필수여부
					
             		/*
             		if($('#details1 input:radio[name="dtl_dept_designation_yn"]:checked').val()=="Y"){
           	            $("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").enable();
           	        }else{
           	        	$("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").select(0);
           	            $("#details1 #dtl_dept_designation_cd").data("kendoDropDownList").enable(false);
           	        }
             		*/
             		
                 	// 상시학습종류 Level2
                 	dataSource_alwStdCd2.filter({
                        logic: "or",
                        filters: [
                           { field: "P_VALUE", operator: "eq", value:  obj.item.ALW_STD_CD1},
                           { field: "VALUE", operator: "eq", value: "" }
                        ]
                    });
                 	// 상시학습종류 Level3
		            dataSource_alwStdCd.filter({ 
						logic: "or",
		                filters: [
                          { field: "P_VALUE", operator: "eq", value:  obj.item.ALW_STD_CD2},
                          { field: "VALUE", operator: "eq", value: "" }
		                ]
		            });

		            var recogTimeH = $("#dtl_recog_time_h").data("kendoNumericTextBox");
                    var recogTimeM = $("#dtl_recog_time_m").data("kendoNumericTextBox");
                    
                    if(obj.item.ALW_STD_CD4=="Y"){
                        
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
                    
                    var startDate = obj.item.EDU_STIME;
                    var endDate = obj.item.EDU_ETIME;

                    if (startDate) {
                        //startDate = new Date(startDate);
                        //startDate.setDate(startDate.getDate());
                        end.min(startDate);
                    } 
                    if (endDate) {
                        start.max(endDate);
                    } 
                    
                    kendo.bind($('#detail_pane1').children(), obj.item); // 상세정보 바인딩
                    
                    //교육기관명 세팅
                    if(obj.item.INSTITUTE_CODE == "Z"){
                    	fn_dtl_institute_name_able();
                    }else{
                    	fn_dtl_institute_name_disable();
                        $("#dtl_institute_name").val("");
                    }

                    
					handleCallbackUploadResult();

	            	if(obj.item.ALW_STS=='DTL') {
	            		page_mode = 'dtl'; // 페이지 상태변경
	            		$('#details1 #cancelBtn').show(); // 승인요청취소버튼 보임
						$("#details1 #drag_report").hide(); // 업로드 영역 비활성화
						$("#details1 #my-file-gird").show(); // 파일목록 활성화
	            	} 
	            	else if(obj.item.ALW_STS=='MOD') {
	            		page_mode = 'mod'; // 페이지 상태변경
	            		$('#details1 #saveBtn').show(); // 승인요청버튼 보임
	            		$('#details1 #deleteBtn').show(); // 삭제버튼 보임
						$("#details1 #drag_report").show(); // 업로드 영역 활성화
						$("#details1 #my-file-gird").show(); // 파일목록 활성화
	            	}
	             }
	        },
	        error: function( xhr, ajaxOptions, thrownError){
	           // 로딩바 제거
	           //loadingClose();
	            
	           if(xhr.status==403){
	               alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
	               sessionout();
	           }else{
	               alert('xrs.status = ' + xhr.status + '\n' + 
	                       'thrown error = ' + thrownError + '\n' +
	                       'xhr.statusText = '  + xhr.statusText );
	           }
	           
	            if(event.preventDefault){
	                event.preventDefault();
	            } else {
	                event.returnValue = false;
	            };
	        },
	        dataType : "json"
	    });
		
	} else {
		alert('상시학습정보가 없습니다.');
	}
};

//첨부파일 함수 시작 =================================================================================================
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

<style scoped>
	#tabstrip {width: 1220px;}
	.k-link {font-weight:bold;}
	.demo-section.style01 {width:120px;}
	.k-input {padding-left:5px;}
	.k-dropzone {position: relative; width : 378px;height: 32px;}
    .k-upload-empty{width : 399px;height: 32px;}
    #my-file-upload{width : 399px;height: 32px;}
    #my-file-gird{min-height : 70px;}
</style>
		
</head>
<body>
	<div class="container">
		<div id="cont_body">
		 <div class="content">
			<div class="top_cont">
				<h3 class="tit01">상시학습</h3>
				<div class="point">※ 내가 신청한 교육들의 현황을 열람할 수 있습니다.</div>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>교육훈련&nbsp; &#62;</span>
					<span class="h">상시학습</span>
				</div><!--//location-->
			</div>
			 <div class="sub_cont">
				 <!-- <div class="state_wrap">
					<dl class="accordion">
						<dt class="ico_plus">
							<span class="satisfy_tit">필수 이수 현황</span>
							<span class="satisfy_txt mr140">
								<span id="req_task_stt"></span> 
							</span>
							<span class="satisfy_tit">기관성과평가 이수 현황</span>
							<span class="satisfy_txt">
								<span id="pa_task_stt"></span>
							</span>
						</dt>
						<dd>
							<h5>필수 이수 현황</h5>
							<div class="table_wp02" id="req_task_stt_list" >
								
							</div>
							<p class="point">※ 부처지정학습은 총시간의 40%이며, 40% 중 25%는 국정철학및공직관이며 15%는 직무역량과정이여야 합니다. </p>
							<h5>기관성과평가 이수 현황</h5>
							<div class="table_wp02" id="pa_task_stt_list" >
								
							</div>
						</dd>
					</dl>
				</div> --><!--//state_wrap-->
				<div class="result_info">
					<ul>
						<li>
						<label for="p_year">년도선택  : </label>
							<div class="demo-section k-header style01" id="p_year">
								<select id="yyyy" style="width: 120px" accesskey="w"></select>
							</div>
						</li>  
					</ul>
					<div class="btn">
						<a class="k-button" onclick="fn_excelDownload(this)">엑셀 다운로드</a>
						<a class="k-button" id="regBtn">상시학습등록</a>
					</div>
				</div><!--//result_info-->
				<div id="splitter1" style="width:100%; height: 545px; border:none;" class="mt10 mb10 ie7_sp">
					<div id="list_pane1">
						<div id="grid1"></div>
					</div>
					<div id="detail_pane1">
						<div id="details1"></div>
					</div>
				</div>
			 </div><!--//sub_cont-->                
		 </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->

<script type="text/x-kendo-template" id="template">
<div id="tabular" class="detail_Info">
	<div class="tit" id="dtl_title">상시학습 </div>
	<div class="dl_scroll" >
		<div class="dl_wrap" >
			<input type="hidden" id="dtl_asseq" data-bind="value:ASSEQ" />
			<input type="hidden" id="dtl_req_num" data-bind="value:REQ_NUM" />
			<input type="hidden" id="dtl_object_id" data-bind="value:OBJECTID"/>
			<dl>
				<dt class="fir"> 과정명 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/> </dt>
				<dd class="fir">
              		<input class="k-textbox" id="dtl_subject_nm" data-bind="value:SUBJECT_NAME" style="width:330px;" onKeyUp="chkNull(this);"/>
					<button id="subjectSearchBtn" class="k-button" style="display:none;">과정검색</button>
				</dd>
			</dl>
			<dl style="line-height:32px;">
				<dt> 해당년도 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/> </dt>
				<dd>
					<input id="dtl_yyyy" data-bind="value:YYYY" style="width:80px;" />
				</dd>
			</dl>
			<dl style="line-height:32px;">
                <dt>학습기간 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/></dt>
                <dd>
                    <input id="dtl_edu_start" style="width:120px;" title="학습시작일 " data-bind="value:EDU_STIME" />    ~
                    <input id="dtl_edu_end" style="width:120px;" title="학습종료일" data-bind="value:EDU_ETIME" />
                </dd>
            </dl>
            <dl>
                <dt>상시학습종류 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/></dt>
                <dd>
                    <select id="dtl_alw_std_cd1" data-bind="value:ALW_STD_CD1" accesskey="w" style="width:100%;" itle="상시학습 대분류 선택"></select><br>
                    <select id="dtl_alw_std_cd2" data-bind="value:ALW_STD_CD2" accesskey="w" style="width:100%;margin-top:10px;" title="상시학습 중분류 선택"></select><br>
                    <select id="dtl_alw_std_cd" data-bind="value:ALW_STD_CD" accesskey="w" style="width:100%;margin-top:10px;" title="상시학습 소분류 선택"></select><br>
                    <span style="color:blue">※ 인정시간기준 : </span><span id="alwStd_cm" style="color:blue" data-bind="text:ALW_STD_CD3" />
                </dd>
            </dl>
            <dl style="line-height:32px;">
				<dt >실적시간 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/> </dt>
				<dd>
					<input id="dtl_edu_hour_h" style="width:100px;" title="시간 입력 " data-bind="value:EDU_HOUR_H"/> 시간 
					<input id="dtl_edu_hour_m" style="width:80px;" title="분 입력 " data-bind="value:EDU_HOUR_M"/> 분
				</dd>
			</dl>
			<dl style="line-height:32px;">
				<dt>인정시간 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/> </dt>
				<dd>
					<input id="dtl_recog_time_h" data-bind="value:RECOG_TIME_H" style="width:100px;" /> 시간
                    <input id="dtl_recog_time_m" data-bind="value:RECOG_TIME_M" style="width:80px;" /> 분<br>
                    <span id="autoTime" style="color:red">※ 상시학습종류와 교육시간을 입력하면 자동 계산됩니다.</span>
				</dd>
			</dl>
            <dl>
                <dt>인정직급 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/> </dt>
                <dd>
                    <select id="dtl_grade_num" style="width: 250px" accesskey="w" data-bind="value:GRADE_NUM" style="width:200px;" ></select>
                </dd>
            </dl>
			<dl>
                <dt>취득점수 </dt>
                <dd>
                    <input class="k-textbox" id="dtl_tt_get_sco" data-bind="value:TT_GET_SCO" style="width:73px;" onKeyUp="chkNull(this);" onkeypress="return numbersonly(event, false, this, 3, 100)" /> 점
                </dd>
            </dl>
            <dl>
				<dt>내용 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/> </dt>
				<dd>
					<textarea class="textarea03 mt5" id="dtl_edu_cont" data-bind="value:COURSE_CONTENTS" style="width:400px;height:100px" title="교육의 내용"/></textarea>
				</dd>
			</dl>
            <dl style="display:none;">
                <dt>지정학습종류 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/> </dt>
                <dd>
                    <select id="dtl_dept_designation_cd" data-bind="value:DEPT_DESIGNATION_CD" style="width:250px;" accesskey="w" ></select>
                </dd>
            </dl>
			<dl>
				<dt>부처지정학습 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/> </dt>
				<dd>
					<input type="radio" name="dtl_dept_designation_yn" id="dtl_dept_designation_yn" value="Y" title="지정학습 선택" /><label class="depart">예</label>
              		<input type="radio" name="dtl_dept_designation_yn" id="dtl_dept_designation_yn" value="N" title="미지정학습 선택" /><label class="nodepart"> 아니오</label> 
				</dd>
			</dl>
			<dl>
                <dt>학습유형 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/> </dt>
                <dd>
                    <select id="dtl_training_code" style="width: 250px" accesskey="w" data-bind="value:TRAINING_CODE" style="width:200px;" ></select>
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
			<dl style="display:none;">
				<dt>필수여부 </dt>
				<dd>
					<input type="radio" name="dtl_required_yn" id="dtl_required_yn" value="Y" title="필수여부 선택" /><label class="depart">예</label>
              		<input type="radio" name="dtl_required_yn" id="dtl_required_yn" value="N" title="필수여부 선택" /><label class="nodepart"> 아니오</label> 
				</dd>
			</dl>
			<dl>
				<dt> 교육기관명  <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/></dt>
				<dd>
                    <select id="dtl_institute_code" data-bind="value:INSTITUTE_CODE" style="width:100%;" ></select><br>
                    <input class="k-textbox inp_style03" id="dtl_institute_name" data-bind="value:INSTITUTE_NAME" style="width: 100%; margin-top:10px;" onKeyUp="chkNull(this);"/><br>
                    ※ '기타'인 경우 교육기관명을 입력하세요
                </dd>
			</dl>
            <dl>
                <dt class="noline">학습 역량 <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_vital.gif" alt="필수"/></dt>
                <dd class="line">
                    <select id="dtl_cmpnumber" style="width: 100%" accesskey="w" data-bind="value:CMPNUMBER" ></select>
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
						<button class="k-button" id="saveBtn">승인요청</button>
						<button class="k-button" id="cancelBtn">승인요청취소</button>
						<button class="k-button" id="deleteBtn">삭제</button>
						<button class="k-button" id="closeBtn">닫기</button>
					</div>
				</dd>
			</dl>
		</div>
	</div><!--//dl_scroll-->
</div>
</script>

<!-- 상시학습관리 증빙자료 첨부파일 template -->
<script type="text/x-kendo-tmpl" id="fileupload-template">
	<input name="upload-file" id="upload-file" type="file"/>
</script>
<%@ include file="/includes/jsp/user/common/findSubjectPopup.jsp"  %>
<%@ include file="/includes/jsp/user/common/apprReqPopup.jsp"  %>
<%@ include file="/includes/jsp/user/common/apprStsPopup.jsp"  %>
</body>
</html>