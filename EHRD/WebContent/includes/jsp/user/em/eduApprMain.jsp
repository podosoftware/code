<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}

kr.podosoft.ws.service.ba.action.admin.BaMgmtSubjectAction action = (kr.podosoft.ws.service.ba.action.admin.BaMgmtSubjectAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage"   >
<head>
<title></title>

<script type="text/javascript">

var page_mode = 'mod'; // page 상태(dtl/reg/mod) : 상세/등록/수정

var dataSource_training ;
var dataSource_deptDesignation;
var dataSource_perfAsseSbjCd;
var dataSource_officeTimeCd;
var dataSource_eduinsDivCd;
var dataSource_alwStdCd1 ;
var dataSource_alwStdCd2 ;
var dataSource_alwStdCd ;

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
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'           
    ],
    complete: function() {
        kendo.culture("ko-KR"); 
        
        
        //로딩바 선언..
        loadingDefine();
        
        //기준년도 
        var now = new Date();
        var maxYyyy = now.getFullYear()+1;
        var arrYyyy = [];
        for(var i=maxYyyy; i>=2014; i--){
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
            },
            change: function(e){
                $("#grid").data("kendoGrid").dataSource.read();
            }
        }).data("kendoDropDownList");
        
      
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
        
        $("#grid").kendoGrid({
            dataSource : {
                type : "json",
                transport : {
                    read : {
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/edu-appr-list.do?output=json",
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
                            startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter), YYYY: removeNullStr( searchYyyy.value() )
                        };  
                    }
                },
                schema : {
                    total : "totalItemCount",
                    data : "items",
                    model : {
                        id : "REQ_NUM",
                        fields : {
                            EDU_DIV : { type : "string" },
                            DVS_NAME : { type : "string" },
                            DVS_FULLNAME : { type : "string" }, 
                            NAME : { type : "string" },
                            GRADE_NM : { type : "string" },
                            SUBJECT_NUM : { type : "number" },
                            COMPANYID : { type : "number" },
                            OPEN_NUM : { type : "number" },
                            YYYY : { type : "number" },
                            CHASU :  { type : "number" },
                            SUBJECT_NAME : { type : "string" },
                            TRAINING_NM : { type : "string" },
                            EDU_PERIOD : { type : "string" },
                            DEPT_DESIGNATION_YN_NM : { type : "string" },
                            RECOG_TIME : { type : "string" },
                            REQ_NUM : { type : "number" },
                            LAST_REQ_STS_CD : { type : "string" },
                            REQ_LINE_SEQ : { type : "number" },
                            REQ_STS_CD : { type : "string" },
                            REQ_STS_NM: { type : "string" },
                            REQ_USERID : { type : "number" },
                            LAST_REQ_LINE_SEQ : { type : "number" }
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
            columns : [ {
                field : "EDU_DIV_NM",
                title : "승인요청구분",
                width : "140px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }, {
                field : "DVS_FULLNAME",
                title : "요청자부서명",
                width : "180px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left" }
            }, {
                field : "NAME",
                title : "요청자",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center; text-decoration: underline;" },
                template : function(data){
                    
                    return "<a href=\"javascript:void();\" onclick=\"javascript: fn_detailView('"+data.EDU_DIV+"', "+data.REQ_NUM+", "+data.OPEN_NUM+", "+data.USERID+");\" >"+data.NAME+"</a>";
                }
            }, {
                field : "SUBJECT_NAME",
                title : "과정명",
                width : "320px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left" }
            }, {
                field : "EDU_PERIOD",
                title : "교육기간",
                width : "190px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }, {
                field : "TRAINING_NM",
                title : "학습유형",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }, /*{
                field : "RECOG_TIME",
                title : "인정시간",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }, ){
                field : "DEPT_DESIGNATION_YN_NM",
                title : "부처지정유무",
                width : "130px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }, */{
                field : "REQ_STS_NM",
                title : "승인상태",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
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
               height : 543,
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
        
        // show detail 
        $('#detail_pane').show().html(kendo.template($('#detailTemplate').html()));        

        //상세페이지의 취소버튼 클릭 시..
        $("#cancelBtn").click(function(){
            kendo.bind($(".detail_Info"), null);

            // 상세영역 비활성화
            $("#splitter").data("kendoSplitter").collapse("#detail_pane");
        });
        
        
        
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
        
        
        // 상세페이지의 수정버튼 클릭시.. ----------------------------------------------------------------------------
        if( !$("#edu-edit-window").data("kendoWindow") ){
            $("#edu-edit-window").kendoWindow({
                width:"700px",
                height:"600px",
                resizable : true,
                title : "교육승인 수정",
                modal: true,
                visible: false
            });
            
            
            //개설년도(추가)
            var dtl_yyyy = $("#dtl_yyyy").kendoNumericTextBox({
                format: "",
                min: 1980,
                max: now.getFullYear() + 1,
                step: 1
            }).data("kendoNumericTextBox");
            //개설년도 초기값 설정.
            dtl_yyyy.value(now.getFullYear());
            
            
            // 학습기간(추가)
            numTexBox(); //날짜 타입
            
            var start = $("#dtl_edu_start").data("kendoDatePicker") ;
            var end = $("#dtl_edu_end").data("kendoDatePicker") ;            
            var startDate = "1900-01-01";
            var endDate = "2999-01-01";
            if (startDate) {
                end.min(startDate);
            } 
            if (endDate) {
                start.max(endDate);
            }
            
            
          //상시학습종류
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
            /* dataSource_alwStdCd2.fetch(function(){
                dataSource_alwStdCd2.filter({ field: "VALUE", operator: "eq", value: "" });
                dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
            }); */
            /* 상시학습종류 Level 3 초기화 */
            /* dataSource_alwStdCd.fetch(function(){
                dataSource_alwStdCd.filter({ field: "VALUE", operator: "eq", value: "" });
            }); */
          
            
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
            
            
            // 실적시간(추가)
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
            
            // 인정직급(추가)
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
            /* 인정직급 */ 
            var dtlGradeNum = $("#dtl_grade_num").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_gradeNum,
                 filter: "contains",
                 suggest: true
            }).data("kendoDropDownList");
            
            // 부처지정학습구분(추가)
            $(':input:radio[name=dtl_dept_designation_yn]:input[value=N]').attr("checked", true); // 지정학습

            $('#detail_pane1 input:radio[name=dtl_required_yn]:input[value=N]').attr("checked", true); // 필수여부
        
           
            
            // 학습유형(추가)
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
            /* 학습유형 */ 
            var trainingCode = $("#dtl_training_code").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_training,
                 filter: "contains",
                 suggest: true
            }).data("kendoDropDownList");
            
            //지정학습구분 데이터소스
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
                serverSorting: false});
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
            
            // 기관성과평가(추가)
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
            /* 기관성과평가필수교육과정 */
            var perfAsseSbjCd = $("#dtl_perf_asse_sbj_cd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_perfAsseSbjCd,
                 filter: "contains",
                 suggest: true
            }).data("kendoDropDownList");
            
            
            // 업무시간구분(추가)
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
            /* 업무시간구분 */
            var officeTimeCd = $("#dtl_office_time_cd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_officeTimeCd,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
            
            
            // 교육기관구분(추가)
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
            /* 교육기관구분 */
            var eduinsDivCd = $("#dtl_eduins_div_cd").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_eduinsDivCd,
                 filter: "contains",
                 suggest: true
            }).data("kendoDropDownList");
            
            
            // 교육기관명(추가)
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
            
            
            // 학습역량(추가)
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
            // 학습역량
            var cmptCombo = $("#dtl_cmpnumber").kendoComboBox({
                dataTextField: "TEXT",
                dataValueField: "VALUE",
                dataSource: compDataSource,
                suggest: true,
                placeholder : "학습에 도움이 된 역량을 선택해주세요."
            }).data("kendoComboBox");
            cmptCombo.options.filter = "contains";
            
            
            // 첨부파일 관리 시작 (팝업영역)==========================================================
            /* 첨부파일 영역생성 */
            var objectType = 6 ;
            if( !$("#myFileGird").data('kendoGrid') ) {
                $("#myFileGird").kendoGrid({
                    dataSource: {
                        type: 'json',
                        transport: {
                            read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json', type: 'POST' },      
                            destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
                            parameterMap: function (options, operation){
                                if (operation != "read" && options) {                                                                                                                           
                                    return { objectType: objectType, objectId:$("#dtl-object-id-pop").val(), attachmentId :options.attachmentId };                                                                   
                                }else{
                                     return { objectType: objectType, objectId:$("#dtl-object-id-pop").val(), startIndex: options.skip, pageSize: options.pageSize };
                                }
                            }
                        },
                        schema: {
                            model: Attachment,
                            data : "targetAttachments"
                        },
                    },
                    pageable: false,
                    width: 480,
                    height: 115,
                    selectable: false,
                    columns: [
                        { 
                            field: "name", 
                            title: "파일명",  
                            width: "280px",
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:left"} ,
                            template: '#= name #' 
                       },
                       { 
                           width: "180px" , 
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
                                
                            var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#dtl-object-id-pop").val() +"&fileType=doc" ;
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
                            e.data = {objectType: objectType, objectId:$("#dtl-object-id-pop").val()};                                                                                                                    
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
            
            // 업로드 영역 활성화
            $("#drag_report").show();
            // 파일목록 활성화
            $("#myFileGird").show();
            // 첨부파일 관리 종료 (팝업영역)==========================================================
            

            // 수정팝업 승인버튼 클릭시..
            $("#appReqPopupBtn").click(function() {
                
                var reqNum = $("#dtl-reqNum").val();
                
                var grid = $("#grid").data("kendoGrid");
                var data = grid.dataSource.data();
                
                var res = $.grep(data, function (e) {
                    return (e.REQ_NUM == reqNum);
                });

                var selectedCell = res[0];
                
                $("#dtl-eduDiv-pop").val(selectedCell.EDU_DIV); //교육 구분  S 교육과정, A 상시학습
                $("#dtl-openNum-pop").val(selectedCell.OPEN_NUM); //개설번호 or 상시학습번호
                $("#dtl-userid-pop").val(selectedCell.REQ_USERID); //사용자번호
                $("#dtl-reqNum-pop").val(selectedCell.REQ_NUM); //승인요청번호
                $("#dtl-lastReqLineSeq-pop").val(selectedCell.LAST_REQ_LINE_SEQ); //총 승인자 라인 수
                $("#dtl-reqLineSeq-pop").val(selectedCell.REQ_LINE_SEQ); //승인자 순번               
                $("#dtl-division-id-pop").val(selectedCell.DIVISIONID);
                $("#dtl-job-pop").val(selectedCell.JOB);
                $("#dtl-leadership-pop").val(selectedCell.LEADERSHIP);
                
                var alwStdSeq = $("#dtl-openNum-pop").val();
                var tUserid = $("#dtl-userid-pop").val();
                
                var stsCd = "2";        // 승인버튼이 눌렀을때 승인 : 2, 미승인 : 3
                
                // validation check
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
                
                if ( dtlGradeNum.select() == 0 ) {
                    alert("인정직급을 선택해주세요.");
                    dtlGradeNum.focus();
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
                
                if($("#dtl_cmpnumber").data("kendoComboBox").select()<0){
                    alert("학습역량을 선택해주세요");
                    $('#dtl_cmpnumber').focus();
                    return false;
                }
                
                
                
                // 상시학습종류별 연간인정시간 체크
                $.ajax({
                    type : 'POST',
                    url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/year_recog_limit_check.do?output=json",
                    data : {
                        asOpenSeq : alwStdSeq,
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
                                 if(!confirm("선택된 상시학습종류의 연간 최대 인정시간 제한으로 아래와 같이 인정시간이 적용됩니다.\n\n"+msg+"\n\n그래도 상시학습 정보를 승인하시겠습니까?")) return;
                             } else {
                                 if(!confirm("상시학습 정보를 승인하시겠습니까?")) return;
                             }
                             
                            // 상시학습정보 수정 & 승인
                            //로딩바생성.
                            loadingOpen();
                       
                            var instituteNm = ""
                            if(instituteCode.value() == "Z"){
                                instituteNm =  $("#dtl_institute_name").val();
                            }else{
                                instituteNm = instituteCode.text();
                            }
                            
                             var cmp = $("#dtl_cmpnumber").data("kendoComboBox");   // 학습역량
                             var cmpVal;
                             if(cmp.select() < 0){
                                 cmpVal = "";
                             }else{
                                 cmpVal = cmp.value();
                             }
                             
                            $.ajax({
                                type : 'POST',
                                url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/save-cls-apply-req-popup.do?output=json", 
                                data : {
                                    /* item: kendo.stringify( params ), */ 
                                    EDU_DIV : "A",
                                    openNum: alwStdSeq,
                                    ALW_STD_SEQ : alwStdSeq,
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
                                    CMPNUMBER : cmpVal,
                                    GRADE_NUM : removeNullStr(dtlGradeNum.value()),
                                    TT_GET_SCO : $("#dtl_tt_get_sco").val(),
                                    DIVISIONID : $("#dtl-division-id-pop").val(),
                                    JOB : $("#dtl-job-pop").val(),
                                    LEADERSHIP : $("#dtl-leadership-pop").val(),
                                    reqStsCd : stsCd,
                                    userid : tUserid,
                                    lastReqLineSeq : $("#dtl-lastReqLineSeq-pop").val(),
                                    reqLineSeq : $("#dtl-reqLineSeq-pop").val(),
                                    reqNum : $("#dtl-reqNum-pop").val()
                                },
                                complete : function( response ){
                                    //로딩바 제거.
                                    loadingClose();
                                    
                                    var obj  = eval("(" + response.responseText + ")");
                                    if(!obj.error){
                                        if(obj.saveCount > 1){
                                            
                                            // 팝업창 닫기
                                            $("#edu-edit-window").data("kendoWindow").close();
                                            
                                            // 상세영역 활성화
                                            $("#splitter").data("kendoSplitter").expand("#detail_pane");
                                        
                                            // 상시학습 목록 read
                                            $("#grid").data("kendoGrid").dataSource.read();
                                            
                                            kendo.bind($(".detail_Info"), null);

                                            // 상세영역 비활성화
                                            $("#splitter").data("kendoSplitter").collapse("#detail_pane");
                                        
                                            
                                            //yyyyDataSource.read();
                                            
                                            alert("승인되었습니다.");  
                                        }else{
                                            alert("승인에 실패 하였습니다. 교육운영자에게 문의해주세요.");
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
            
            // 수정팝업 닫기버튼 클릭시..
            $("#cancelPopupBtn").click(function() {
                $("#edu-edit-window").data("kendoWindow").close();
            });
                
        }   // 팝업 최초 오픈 종료             
        
        $("#editBtn").click(function() {

            //교육기관명 초기화
            fn_dtl_institute_name_disable();
            
            // 상세페이지 데이터 호출 
            fn_popupInfoOpen($("#dtl-eduDiv").val(), $("#dtl-reqNum").val(), $("#dtl-openNum").val(), $("#dtl-userid").val());
                    
            // popup창 열기
            $("#edu-edit-window").data("kendoWindow").center();
            $("#edu-edit-window").data("kendoWindow").open();
        
        }); // 수정버튼 클릭 end---------------------------------------------------------------------------------
        
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
        
        //미승인버튼 클릭 시..
        $("#rtBtn, #cfBtn").click(function(e){

            var msg = "";
            
            var stsCd = "";
            if(e.target.id=="rtBtn"){
                //alert($("#dtl-eduDiv").val());
                if($("#dtl-eduDiv").val()=="A"){
                    msg = "해당 건을 미승인 처리하시겠습니까?";
                }else{
                    msg = "해당 건을 미승인 처리하시겠습니까?\n확인버튼을 클릭하시면 교육신청건은 자동 취소처리되며 목록에서 사라집니다.";
                }
                
                stsCd = "3";
            }else{
                msg = "해당 건을 승인 처리하시겠습니까?";
                stsCd = "2";
            }
            if (confirm(msg)) {
                //로딩바생성.
                loadingOpen();
                
        
                $.ajax({
                    type : 'POST',          
                    url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/save-cls-apply-req.do?output=json",
                    data : {
                        EDU_DIV : $("#dtl-eduDiv").val(), 
                        openNum: $("#dtl-openNum").val(), 
                        userid : $("#dtl-userid").val(),
                        reqNum : $("#dtl-reqNum").val(), 
                        reqStsCd : stsCd, 
                        lastReqLineSeq: $("#dtl-lastReqLineSeq").val(), 
                        reqLineSeq: $("#dtl-reqLineSeq").val()
                    },
                    complete : function( response ){
                        //로딩바 제거.
                        loadingClose();
                        
                        var obj  = eval("(" + response.responseText + ")");
                        if(!obj.error){
                            if(obj.saveCount > 0){         
                                // 과정목록 read
                                $("#grid").data("kendoGrid").dataSource.read();
                                
                                kendo.bind( $("#tabular"),  null );
                            
                                // 상세영역 비활성화
                                $("#splitter").data("kendoSplitter").collapse("#detail_pane");
                                
                                alert("처리되었습니다.");  
                            }else{
                                alert("실패 하였습니다. 교육운영자에게 문의해주세요.");
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
        
        
        
    }

}]);

/* 상세정보 열기 팝업*/
var fn_popupInfoOpen = function(eduDiv, reqNum, openNum, userid) {
    
    var grid = $("#grid").data("kendoGrid");
    var data = grid.dataSource.data();
    
    var res = $.grep(data, function (e) {
        return (e.REQ_NUM == reqNum);
    });

    var selectedCell = res[0];
    
    $("#dtl-eduDiv-pop").val(selectedCell.EDU_DIV); //교육 구분  S 교육과정, A 상시학습
    $("#dtl-openNum-pop").val(selectedCell.OPEN_NUM); //개설번호 or 상시학습번호
    $("#dtl-userid-pop").val(selectedCell.REQ_USERID); //사용자번호
    $("#dtl-reqNum-pop").val(selectedCell.REQ_NUM); //승인요청번호
    $("#dtl-lastReqLineSeq-pop").val(selectedCell.LAST_REQ_LINE_SEQ); //총 승인자 라인 수
    $("#dtl-reqLineSeq-pop").val(selectedCell.REQ_LINE_SEQ); //승인자 순번
    
    if(reqNum != null) {
        $.ajax({
            type : 'POST',            
            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/edu-detail-info.do?output=json",
            data : {
                EDU_DIV : $("#dtl-eduDiv-pop").val(), subjectNum : selectedCell.SUBJECT_NUM, openNum: selectedCell.OPEN_NUM, USERID : userid
            },
            success  : function( response ){
                
                if (response.items != null) {
                    var selectRow = new Object();
                    $.each(response.items, function(idx, item) {
                        $.each(item,function(key,val){
                            selectRow[key] = val;
                        });
                    });
                    
                    $('input:radio[id=dtl_dept_designation_yn]:input[value='+selectRow.DEPT_DESIGNATION_YN+']').attr("checked", true);
                    //상세데이터 바인딩..
                    kendo.bind($("#tabular"), selectRow);
                    
                    handleCallbackUploadResult();
                    
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
  $("#myFileGird").data('kendoGrid').dataSource.read();             
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
//첨부파일 함수 종료 =================================================================================================

//상세보기.
function fn_detailView(eduDiv, reqNum, openNum, userid){

    var grid = $("#grid").data("kendoGrid");
    var data = grid.dataSource.data();
    
    var res = $.grep(data, function (e) {
        return (e.REQ_NUM == reqNum);
    });

    var selectedCell = res[0];
    
    $("#dtl-eduDiv").val(selectedCell.EDU_DIV); //교육 구분  S 교육과정, A 상시학습
    $("#dtl-openNum").val(selectedCell.OPEN_NUM); //개설번호 or 상시학습번호
    $("#dtl-userid").val(selectedCell.REQ_USERID); //사용자번호
    $("#dtl-reqNum").val(selectedCell.REQ_NUM); //승인요청번호
    $("#dtl-lastReqLineSeq").val(selectedCell.LAST_REQ_LINE_SEQ); //총 승인자 라인 수
    $("#dtl-reqLineSeq").val(selectedCell.REQ_LINE_SEQ); //승인자 순번
    
    $("#dtl_eduDivNm").text(selectedCell.EDU_DIV_NM); //승인요청구분
    
    // 상세영역 활성화
    $("#splitter").data("kendoSplitter").expand("#detail_pane");

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
                field : "GRADE_NM",
                title : "인정직급",
                width : "180px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left" }
            }
    );
    
    if(eduDiv == "A"){
        userGridColumns.push(
                {
                    field : "TT_GET_SCO_NUMB",
                    title : "수료점수",
                    width : "100px",
                    headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                    attributes : { "class" : "table-cell", style : "text-align:center" }
                }
        );
    }

    $("#userGrid").empty();
    $("#userGrid").kendoGrid({
        columns : userGridColumns,
        filterable : false,
        height : 64,
        sortable : true,
        pageable : false,
        resizable : false,
        reorderable : true,
        selectable: "row"
    });
    

    //수강자 목록 초기화.
    $("#userGrid").data("kendoGrid").dataSource.data([]);
    
    
    //상세정보 control
    if(eduDiv == "S"){
        //교육과정
        $("#detailChasuDl").show();
        $("#detailApplyTimeDl").show();
        //$("#detailCancelTimeDl").show();
        $("#detailApplicantDl").show();
        $("#detailDaysDl").show();
        $("#attachFileDl").hide();
        $("#detailCmpnameDl").hide();
        
        $("#userinfoDt").html("교육신청자");
        
        var ds = new kendo.data.DataSource({
            data: [{NAME: selectedCell.NAME, GRADE_NM:selectedCell.GRADE_NM}]
        });
        $("#userGrid").data("kendoGrid").setDataSource( ds );

    }else{
        //상시학습
        $("#detailChasuDl").hide();
        $("#detailApplyTimeDl").hide();
        //$("#detailCancelTimeDl").hide();
        $("#detailApplicantDl").hide();
        $("#detailDaysDl").hide();
        $("#attachFileDl").show();
        $("#detailCmpnameDl").show();
        
        $("#userinfoDt").html("교육수료자");
        
    }

    
    //승인버튼 control
    if(selectedCell.REQ_STS_CD == "1"){
        //승인대기
        $("#rtBtn").show(); //미승인버튼
        $("#cfBtn").show(); //승인버튼
        $("#reqStsSpan").attr("style", "display: none;");
        $("#reqStsEm").attr("style", "display: none;");
        
        if($("#dtl-eduDiv").val() == "A" ) {        // 승인요청구분 : 상시학습 : A 일때
            $("#editBtn").show();       // 수정버튼
        }else {
            $("#editBtn").hide();
        }
        
    }else{
        $("#rtBtn").hide(); //미승인버튼
        $("#cfBtn").hide(); //승인버튼
        $("#editBtn").hide(); // 수정버튼

        $("#reqStsSpan").attr("style", "display: ;");
        $("#reqStsEm").attr("style", "display: ;");
        $("#reqStsEm").text(selectedCell.REQ_STS_NM);
        
    }
    
    
    //로딩바 생성.
    //loadingOpen();
       
    $.ajax({
        type : 'POST',
        dataType : 'json',
        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/edu-detail-info.do?output=json",
        data : {
            EDU_DIV : $("#dtl-eduDiv").val(), subjectNum : selectedCell.SUBJECT_NUM, openNum: selectedCell.OPEN_NUM, USERID : userid
        },
        success : function(response) {

            //로딩바 제거.
            //loadingClose();
            
            if (response.items != null) {
                var selectRow = new Object();
                $.each(response.items, function(idx, item) {
                    $.each(item,function(key,val){
                        selectRow[key] = val;
                    });
                });
                
                //상세데이터 바인딩..
                kendo.bind($(".detail_Info"), selectRow);
                
            }
            
            if (response.items2 != null) {
                $("#userGrid").data("kendoGrid").dataSource.data( response.items2 );
                
                //상시학습 교육수료자가 1명만 들어감. .. 연간최대인정시간 계산 프로세스가 추가되면서 변경됨..
                if($("#userGrid").data("kendoGrid").dataSource.data().length > 0){
                    $("#dtl-userid").val($("#userGrid").data("kendoGrid").dataSource.data()[0].USERID);
                }
            }
            
            //alert($("#dtl-userid").val());
            
            if( !$("#attachFileGrid").data('kendoGrid') ) {
                $("#attachFileGrid").kendoGrid({
                    dataSource: {
                        type: 'json',
                        transport: {
                            read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json', type: 'POST' },      
                            destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
                            parameterMap: function (options, operation){
                                if (operation != "read" && options) {                                                                                                                           
                                    return { objectType: 6, objectId:$("#dtl-openNum").val(), attachmentId :options.attachmentId };                                                                   
                                }else{
                                     return { objectType: 6, objectId:$("#dtl-openNum").val(), startIndex: options.skip, pageSize: options.pageSize };
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
                            width: "250px",
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:left"} ,
                            template: '#= name #' 
                       },
                       { 
                           width: "100px" , 
                           template: function(dataItem) {
                               return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>';   
                           } 
                       }
                    ]
                });
            }else{
                $("#attachFileGrid").data('kendoGrid').dataSource.read();
            }
        },
        error : function(xhr, ajaxOptions, thrownError) { 
            //로딩바 제거.
            //loadingClose();
            
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

function excelDownLoad(button){
    button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/edu-appr-list-excel.do?YYYY=" + $("#searchYyyy").val();
}

</script>
    <style scoped>
    .demo-section.style01 {width:120px;}
    .k-input {padding-left:5px;}
    
    #my-file-upload{width : 399px;height: 32px;}
    #myFileGird{width: 480px; min-height : 70px;}
    </style>   
         
    </head>
<body>

    
    <div class="container">
        <div id="cont_body">
         <div class="content">
            <div class="top_cont">
                <h3 class="tit01">교육승인</h3>
                <div class="point">
                    ※ 나에게 올라온 상시 및 외부 학습에 대한 요청 현황을 열람하고 승인을 해 줍니다. <br/> ※ 요청자 이름 클릭 시 교육의 상세 내용을 열람할 수 있습니다.
                </div>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>승인하기&nbsp; &#62;</span>
                    <span class="h">교육승인</span>
                </div><!--//location-->
            </div>
             <div class="sub_cont">
            
                <div class="result_info">
                    <ul>
                        <li>
                        <label for="p_year">요청년도  : </label>
                            <div class="demo-section k-header style01" id="p_year">
                                <select id="searchYyyy" style="width: 120px" > </select>
                            </div>
                        </li>  
                    </ul>
                    <div class="btn">
                        <a class="k-button" onclick="javascript: excelDownLoad(this)">엑셀 다운로드</a>
                    </div>
                </div><!--//result_info-->
                <div id="splitter" style="width:1220px; height: 545px; border:none;" class="mt10 mb10">
                    <div id="list_pane">
                        <div id="grid"></div>
                    </div>
                    <div id="detail_pane">
                    
                    </div><!--//detail_pane-->
                </div>
                
             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div><!--//container-->


                    <script type="text/x-kendo-template"  id="detailTemplate"> 
                        <div class="detail_Info">
                            <div class="tit">상세정보 <span id="reqStsSpan" class="state" style="display: none;">처리상태: <em id="reqStsEm" style="display: none;">미승인</em></span></div>
                            <div class="dl_wrap">
                                <div class="btn_top">
                                    <button id="rtBtn" class="k-button k-primary" style="width:70px;">미승인</button>
                                    <button id="cfBtn" class="k-button k-primary" style="width:70px;">승인</button>
                                    <button id="editBtn" class="k-button k-primary" style="width:70px;">수정</button>
                                    <button id="cancelBtn" class="k-button" style="width:70px;">닫기</button>
                                    
                                    <input type="hidden" id="dtl-openNum" />
                                    <input type="hidden" id="dtl-eduDiv" />
                                    <input type="hidden" id="dtl-reqNum" />
                                    <input type="hidden" id="dtl-reqLineSeq" />
                                    <input type="hidden" id="dtl-lastReqLineSeq" />
                                    <input type="hidden" id="dtl-userid" />
                    
                                </div>
                                <dl>
                                    <dt class="fir">승인요청구분</dt>
                                    <dd class="fir"><span id="dtl_eduDivNm" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 과정명 </dt>
                                    <dd><span data-bind="text:SUBJECT_NAME" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt id="userinfoDt">교육신청자 </dt>
                                    <dd ><div id="userGrid"></div></dd>
                                </dl>
                                <dl >
                                    <dt >상시학습종류 </dt>
                                    <dd ><span data-bind="text:ALW_STD_NM1" /> - <span data-bind="text:ALW_STD_NM2" /> - <span data-bind="text:ALW_STD_NM" />&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt>교육기간  </dt>
                                    <dd><span data-bind="text:EDU_STIME" ></span> ~ <span data-bind="text:EDU_ETIME" ></span>&nbsp;</dd>
                                </dl>
                                <dl id="detailApplyTimeDl">
                                    <dt>신청기간   </dt>
                                    <dd><span data-bind="text:APPLY_STIME" ></span> ~ <span data-bind="text:APPLY_ETIME" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt>교육시간  </dt>
                                    <dd><span data-bind="text:EDU_HOUR_H" ></span>시간 <span data-bind="text:EDU_HOUR_M" ></span>분&nbsp;</dd>
                                </dl>
                                <dl >
                                    <dt >인정시간 </dt>
                                    <dd ><span data-bind="text:RECOG_TIME_H" ></span>시간 <span data-bind="text:RECOG_TIME_M" ></span>분&nbsp;</dd>
                                </dl>
                                <dl >
                                    <dt >내용 </dt>
                                    <dd ><span data-bind="text:COURSE_CONTENTS" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt >학습유형</dt>
                                    <dd ><span data-bind="text:TRAINING_STRING" ></span>&nbsp;</dd>
                                </dl>
                                <dl id="detailChasuDl">
                                    <dt> 기수</dt>
                                    <dd><span data-bind="text:CHASU" ></span>&nbsp;</dd>
                                </dl>
                                <!--<dl id="detailCancelTimeDl">
                                    <dt>취소마감일 </dt>
                                    <dd><span data-bind="text:CANCEL_ETIME" ></span>&nbsp;</dd>
                                </dl>
                                <dl id="detailApplicantDl">
                                    <dt>모집정원  </dt>
                                    <dd><span data-bind="text:APPLICANT" ></span>명&nbsp;</dd>
                                </dl>-->
                                <dl id="detailDaysDl">
                                    <dt>교육일수  </dt>
                                    <dd><span data-bind="text:EDU_DAYS" ></span>일&nbsp;</dd>
                                </dl>
                                <dl >
                                    <dt >부처지정학습 </dt>
                                    <dd ><span data-bind="text:DEPT_DESIGNATION_NM" ></span>&nbsp;</dd>
                                </dl>
                                <dl >
                                    <dt class="line">기관성과평가필수교육 </dt>
                                    <dd class="noline"><span data-bind="text:PERF_ASSE_SBJ_NM" ></span>&nbsp;</dd>
                                </dl>
                                <dl >
                                    <dt >업무시간구분 </dt>
                                    <dd ><span data-bind="text:OFFICETIME_NM" ></span>&nbsp;</dd>
                                </dl>
                                <dl >
                                    <dt class="last6">교육기관 </dt>
                                    <dd class="last6"><span data-bind="text:INSTITUTE_NAME" ></span>&nbsp;</dd>
                                </dl>
                                <dl id="detailCmpnameDl">
                                    <dt>관련역량  </dt>
                                    <dd><span data-bind="text:CMPNAME" ></span>&nbsp;</dd>
                                </dl>
                                <dl id="attachFileDl">
                                    <dt >첨부파일 </dt>
                                    <dd ><div id="attachFileGrid"></div></dd>
                                </dl>

                            </div>
                        </div>
                    </script>
                    
<!-- 교육승인 상세정보 수정 -->
<div id="edu-edit-window" style="display:none; width:700px;">
    
    <div class="dl_wrap"  id="tabular">
        <input type="hidden" id="dtl-openNum-pop" />
        <input type="hidden" id="dtl-eduDiv-pop" />
        <input type="hidden" id="dtl-reqNum-pop" />
        <input type="hidden" id="dtl-reqLineSeq-pop" />
        <input type="hidden" id="dtl-lastReqLineSeq-pop" />
        <input type="hidden" id="dtl-userid-pop" />
        <input type="hidden" id="dtl-object-id-pop" data-bind="value:OBJECTID"/>
        <input type="hidden" id="dtl-division-id-pop" />
        <input type="hidden" id="dtl-job-pop" />
        <input type="hidden" id="dtl-leadership-pop" />
                
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
                   <select id="dtl_alw_std_cd1" data-bind="value:ALW_STD_CD1"  style="width:100%;" itle="상시학습 대분류 선택"></select><br>
                   <select id="dtl_alw_std_cd2" data-bind="value:ALW_STD_CD2"  style="width:100%;margin-top:10px;" title="상시학습 중분류 선택"></select><br>
                   <select id="dtl_alw_std_cd" data-bind="value:ALW_STD_CD"  style="width:100%;margin-top:10px;" title="상시학습 소분류 선택"></select><br>
                   <span style="color:blue">※ 인정시간기준 : </span><span id="alwStd_cm" style="color:blue" data-bind="text:ALW_STD_CD3" ></span>
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
                   <select id="dtl_grade_num" style="width: 250px"  data-bind="value:GRADE_NUM" style="width:200px;" ></select>
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
                   <select id="dtl_dept_designation_cd" data-bind="value:DEPT_DESIGNATION_CD" style="width:250px;"  ></select>
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
                <select id="dtl_training_code" style="width: 250px"  data-bind="value:TRAINING_CODE" style="width:200px;" ></select>
            </dd>
        </dl>
        <dl>
            <dt>기관성과평가</dt>
            <dd>
                <select id="dtl_perf_asse_sbj_cd" data-bind="value:PERF_ASSE_SBJ_CD" style="width:250px;" ></select>
            </dd>
        </dl>
        <dl>
            <dt>업무시간구분</dt>
            <dd>
                <select id="dtl_office_time_cd" data-bind="value:OFFICETIME_CD" style="width:250px;" ></select>
            </dd>
        </dl>
        <dl>
            <dt>교육기관구분</dt>
            <dd>
                <select id="dtl_eduins_div_cd" data-bind="value:EDUINS_DIV_CD" style="width:250px;" ></select>
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
                <select id="dtl_cmpnumber" style="width: 100%"  data-bind="value:CMPNUMBER" ></select>
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
                    <div id="myFileGird" ></div>
                </div>
                <div class="btn_btm2">
                    <button class="k-button" style="width:75px;" id="appReqPopupBtn">승인</button>                                        
                    <button class="k-button" style="width:75px;" id="cancelPopupBtn">닫기</button>
                </div>
            </dd>
        </dl>       
    </div>
        
</div>             

<!-- 상시학습관리 증빙자료 첨부파일 template -->
<script type="text/x-kendo-tmpl" id="fileupload-template">
    <input name="upload-file" id="upload-file" type="file"/>
</script>         

</body>
</html>