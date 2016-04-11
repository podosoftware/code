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

yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.<%=theme%>.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
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
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/edu-recomm-appr-list.do?output=json",
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
			columns : [ 
			{
				field : "INSTITUTE_NAME",
				title : "교육기관",
                width : "180px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left" }
			}, {
				field : "SUBJECT_NAME",
				title : "과정명",
                width : "320px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left; text-decoration: underline;" },
                template : function(data){
                    return "<a href=\"javascript:void();\" onclick=\"javascript: fn_detailView('"+data.EDU_DIV+"', "+data.REQ_NUM+", "+data.OPEN_NUM+", "+data.USERID+");\" >"+data.SUBJECT_NAME+"</a>";
                }
			}, {
                field : "APPLY_NUMB",
                title : "신청인원",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center; " }
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

        //미승인버튼 클릭 시..
		$("#rtBtn, #cfBtn").click(function(e){

			var msg = "";
			
			var stsCd = "";
			if(e.target.id=="rtBtn"){
				msg = "해당 건을 미승인 처리하시겠습니까?";
				
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
                    url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/save-cls-recomm-req.do?output=json",
                    data : {
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
                                
                                kendo.bind( $(".tabular"),  null );
                            
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
    $("#dtl-userid").val(selectedCell.USERID); //사용자번호
    $("#dtl-reqNum").val(selectedCell.REQ_NUM); //승인요청번호
    $("#dtl-lastReqLineSeq").val(selectedCell.LAST_REQ_LINE_SEQ); //총 승인자 라인 수
    $("#dtl-reqLineSeq").val(selectedCell.REQ_LINE_SEQ); //승인자 순번
    
    
    // 상세영역 활성화
    $("#splitter").data("kendoSplitter").expand("#detail_pane");

    var userGridColumns = []; 
    userGridColumns.push(
            {
                field : "RECOMM_RANKING",
                title : "추천순위",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }
    );
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
                field : "DVS_FULLNAME",
                title : "부서",
                width : "200px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left" }
            }
    );
    userGridColumns.push(
            {
            	field : "GRADE_NM",
                title : "직급",
                width : "180px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left" }
            }
    );
    
    $("#userGrid").empty();
    $("#userGrid").kendoGrid({
        columns : userGridColumns,
        filterable : false,
        height : 350,
        sortable : true,
        pageable : false,
        resizable : false,
        reorderable : true,
        selectable: "row"
    });
    

    //수강자 목록 초기화.
    $("#userGrid").data("kendoGrid").dataSource.data([]);
    
    
    //상세정보 control
    
    
    //승인버튼 control
    if(selectedCell.REQ_STS_CD == "1"){
    	//승인대기
    	$("#rtBtn").show(); //미승인버튼
    	$("#cfBtn").show(); //승인버튼
    	$("#reqStsSpan").attr("style", "display: none;");
    	$("#reqStsEm").attr("style", "display: none;");
    	
    }else{
    	$("#rtBtn").hide(); //미승인버튼
        $("#cfBtn").hide(); //승인버튼

        $("#reqStsSpan").attr("style", "display: ;");
        $("#reqStsEm").attr("style", "display: ;");
        $("#reqStsEm").text(selectedCell.REQ_STS_NM);
        
    }
    
    
    //로딩바 생성.
    //loadingOpen();
       
    $.ajax({
        type : 'POST',
        dataType : 'json',
        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/edu-recomm-detail-info.do?output=json",
        data : {
        	subjectNum : selectedCell.SUBJECT_NUM, openNum: selectedCell.OPEN_NUM, USERID : userid
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
            	//if($("#userGrid").data("kendoGrid").dataSource.data().length > 0){
            	//	$("#dtl-userid").val($("#userGrid").data("kendoGrid").dataSource.data()[0].USERID);
            	//}
            }
            
            //alert($("#dtl-userid").val());
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
    button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/edu-recomm-appr-list-excel.do?YYYY=" + $("#searchYyyy").val();
}

</script>
    <style scoped>
    .demo-section.style01 {width:120px;}
    .k-input {padding-left:5px;}
    </style>   
         
    </head>
<body>

    
	<div class="container">
        <div id="cont_body">
         <div class="content">
            <div class="top_cont">
                <h3 class="tit01">교육추천승인(인사)</h3>
                <div class="point">
                    ※ 나에게 올라온 교육추천승인 대한 요청 현황을 열람하고 승인을 해 줍니다. <br/> ※ 요청자 이름 클릭 시 교육의 상세 내용과 교육 신청자정보를 열람할 수 있습니다.
                </div>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>승인하기&nbsp; &#62;</span>
                    <span class="h">교육추천승인(인사)</span>
                </div><!--//location-->
            </div>
             <div class="sub_cont">
            
                <div class="result_info">
                    <ul>
                        <li>
                        <label for="p_year">요청년도  : </label>
                            <div class="demo-section k-header style01" id="p_year">
                                <select id="searchYyyy" style="width: 120px" accesskey="w"> </select>
                            </div>
                        </li>  
                    </ul>
                    <!-- <div class="btn">
                        <a class="k-button" onclick="javascript: excelDownLoad(this)">엑셀 다운로드</a>
                    </div> -->
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
                                    <button id="rtBtn" class="k-button k-primary" style="width:88px;">미승인</button>
                                    <button id="cfBtn" class="k-button k-primary" style="width:88px;">승인</button>
                                    <button id="cancelBtn" class="k-button" style="width:88px;">닫기</button>
                                    
                                    <input type="hidden" id="dtl-openNum" />
                                    <input type="hidden" id="dtl-eduDiv" />
                                    <input type="hidden" id="dtl-reqNum" />
                                    <input type="hidden" id="dtl-reqLineSeq" />
                                    <input type="hidden" id="dtl-lastReqLineSeq" />
                                    <input type="hidden" id="dtl-userid" />
                    
                                </div>
                                <dl>
                                    <dd style="height: 35px;" >&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 과정명 </dt>
                                    <dd><span data-bind="text:SUBJECT_NAME" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt>교육신청자 </dt>
                                    <dd ><div id="userGrid"></div></dd>
                                </dl>
                                <dl >
                                    <dt >상시학습종류 </dt>
                                    <dd ><span data-bind="text:ALW_STD_NM1" /> - <span data-bind="text:ALW_STD_NM2" /> - <span data-bind="text:ALW_STD_NM" />&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt class="mt5">내용</dt>
                                    <dd>
                                        <textarea cols="10" rows="5" class="textarea03 mt5" style="width:100%;" readonly="readonly" data-bind="value:COURSE_CONTENTS"/></textarea>
                                    </dd>
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
                                <dl>
                                    <dt >학습유형</dt>
                                    <dd ><span data-bind="text:TRAINING_STRING" ></span>&nbsp;</dd>
                                </dl>
                                <dl id="detailChasuDl">
                                    <dt> 기수</dt>
                                    <dd><span data-bind="text:CHASU" ></span>&nbsp;</dd>
                                </dl>
                                
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
                                <dl >
                                    <dt class="last6">관련역량 </dt>
                                    <dd class="last6"><span data-bind="text:CMPNAMES" ></span>&nbsp;</dd>
                                </dl>

                            </div>
                        </div>
                    </script>
</body>
</html>