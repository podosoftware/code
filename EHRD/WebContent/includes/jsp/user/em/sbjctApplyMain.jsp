<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="java.util.*"%>
<%--
사용자 > 교육훈련 > 교육신청
--%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}

kr.podosoft.ws.service.em.action.EmApplyMainAction  action = (kr.podosoft.ws.service.em.action.EmApplyMainAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

Map<String,Object> yearMap = (Map<String,Object>)request.getAttribute("item");
int nowYear = Integer.parseInt(yearMap.get("YYYY").toString());
String srchFrom = yearMap.get("SRCH_FROM").toString();
String srchTo = yearMap.get("SRCH_TO").toString();
//나의 역량진단 목록
List<Map<String,Object>> items = (List<Map<String,Object>>)request.getAttribute("items"); 
String camTitleStr = ""; // 진단명
String camRunNum = ""; // 진단번호
if(items!=null && items.size()>0) {
	Map<String,Object> map = items.get(0);
	camTitleStr = map.get("RUN_NAME") + "(" + map.get("RUN_DATE") + ")";
	camRunNum = map.get("RUN_NUM").toString();
} else {
	camTitleStr = "※ 진단정보가 존재하지 않습니다.";
}
//나의 경력개발계획 목록
/*List<Map<String,Object>> items1 = (List<Map<String,Object>>)request.getAttribute("items1"); 
String cdpTitleStr = ""; // CDP명
String cdpRunNum = ""; // CDP번호
if(items1!=null && items1.size()>0) {
	Map<String,Object> map = items1.get(0);
	cdpTitleStr = map.get("RUN_NAME") + "(" + map.get("RUN_DATE") + ")";
	cdpRunNum = map.get("RUN_NUM").toString();
} else {
	cdpTitleStr = "※ 계획정보가 존재하지 않습니다.";	
}*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage"   >
<head>
<title></title>
<script type="text/javascript">
var dataSource_list1;
var dataSource_list3;
var sdateFrom1 = null;
//var sdateFrom2 = null;
var sdateFrom3 = null;
var sdateTo1 = null;
//var sdateTo2 = null;
var sdateTo3 = null;
var tUserid = <%=action.getUser().getUserId()%>;
yepnope([{
    load: [
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.<%=theme%>.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
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
        
        fn_selectCarList('<%=camRunNum%>');
        
        /* 교육시작일 Datepicker 생성 */
        sdateFrom1 = $('#sdate_from1').kendoDatePicker({
        	format: "yyyy-MM-dd",
        	change : fn_changeSdateFrom1
        }).data("kendoDatePicker");
        sdateTo1 = $('#sdate_to1').kendoDatePicker({
        	format: "yyyy-MM-dd",
        	change : fn_changeSdateTo1
        }).data("kendoDatePicker");
        /*sdateFrom2 = $('#sdate_from2').kendoDatePicker({
        	format: "yyyy-MM-dd",
        	change : fn_changeSdateFrom2
        }).data("kendoDatePicker");
        sdateTo2 = $('#sdate_to2').kendoDatePicker({
        	format: "yyyy-MM-dd",
        	change : fn_changeSdateTo2
        }).data("kendoDatePicker");*/
        sdateFrom3 = $('#sdate_from3').kendoDatePicker({
        	format: "yyyy-MM-dd",
        	change : fn_changeSdateFrom3
        }).data("kendoDatePicker");
        sdateTo3 = $('#sdate_to3').kendoDatePicker({
        	format: "yyyy-MM-dd",
        	change : fn_changeSdateTo3
        }).data("kendoDatePicker");
        
        fn_changeSdateFrom1();
        fn_changeSdateTo1();
        fn_changeSdateFrom3();
        fn_changeSdateTo3();
        
        /* 역량진단 Tab Gride DataSoure */
        dataSource_list1 = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emapply/select-so-list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){ 
                	var sortField = "";
                    var sortDir = "";
                    if (options.sort && options.sort.length>0) {
                        sortField = options.sort[0].field;
                        sortDir = options.sort[0].dir;
                    }
                	return { 
                    	startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter),
                    	type : "1",
                    	runNum : $('#cam_run_num').val(),
                    	fromDate : $('#sdate_from1').val(), 
                    	toDate : $('#sdate_to1').val()
                    };
                }
            },
            schema: {
            	total: "totalItemCount",
                data: "items",
                model: {
                    fields: {
                    	SUBJECT_NUM : { type: "int" } ,
                 	   	OPEN_NUM  : { type: "int" },
                 	   	SUBJECT_NAME : { type : "string" },
                 	   	TRAINING_NM : {type:"string"},
                 	   	YYYY : {type:"int"},
                 	   	CHASU : {type:"string"},
                 	   	EDU_PERIOD : { type:"string" },
                 	   	DEPT_DESIGNATION_YN : { type:"string"},
                 	   	VETER_ASSE_REQ_YN : { type: "string" },
                 	    APPLY_NM : { type: "string" },
                 	   	REQ_NUM : { type: "int" },
                 	   	REQ_STS_NM : { type: "string" },
                 	   	RECOG_TIME : {type:"string"},
                 	    APPLY_CD : { type:"string" }
                    }
                }
            },
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true,
			pageSize: 30,
			error : function(e) {
				//alert(e.status);
				if(e.xhr.status==403){
	               alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
	               sessionout();
	            }else{
	               alert('xhr.status = ' + e.xhr.status + '\n' +  'xhr.statusText = '  + e.xhr.statusText );
	            }
			}
		});
        
        //일반신청 데이터소스
        dataSource_list3 = new kendo.data.DataSource({
            type: "json",
            transport: {
            	read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emapply/select-so-list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){ 
                	var sortField = "";
                    var sortDir = "";
                    if (options.sort && options.sort.length>0) {
                        sortField = options.sort[0].field;
                        sortDir = options.sort[0].dir;
                    }
                    return {
                    	startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter),
                    	type : "3",
                    	fromDate : $('#sdate_from3').val(), 
                    	toDate : $('#sdate_to3').val()
                    };
                }
            },
            schema: {
            	total: "totalItemCount",
                data: "items",
                model: {
                    fields: {
                    	SUBJECT_NUM : { type: "int" } ,
                 	   	OPEN_NUM  : { type: "int" },
                 	   	SUBJECT_NAME : { type : "string" },
                 	   	TRAINING_NM : {type:"string"},
                 	   	YYYY : {type:"int"},
                 	   	CHASU : {type:"string"},
                 	   	EDU_PERIOD : { type:"string" },
                 	   	DEPT_DESIGNATION_YN : { type:"string"},
                 	   	VETER_ASSE_REQ_YN : { type: "string" },
                 	    APPLY_NM : { type: "string" },
                 	   	REQ_NUM : { type: "int" },
                 	   	REQ_STS_NM : { type: "string" },
                 	   	RECOG_TIME : {type:"string"},
                 	    APPLY_CD : { type:"string" }
                    }
                }
            },
            serverPaging: true,
            serverFiltering: true,
            serverSorting: true,
			pageSize: 30,
			error : function(e) {
				//alert(e.status);
                if(e.xhr.status==403){
                    alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                    sessionout();
                 }else{
                    alert('xhr.status = ' + e.xhr.status + '\n' +  'xhr.statusText = '  + e.xhr.statusText );
                 }
			}
		});
        
        //역량진단을 통한 그리드
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
				field: "CMPNAME",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
                title: "역량명",
				width:150
			}, {
				field: "TRAINING_NM",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
                title: "학습유형",
				width:120
			}, {
				field: "SUBJECT_NAME", title: "과정명",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left;text-decoration: underline;" },
				template: "<a href='javascript:void();' onclick='fn_sbjctInfoOpen(1, ${OPEN_NUM}); return false;' >${SUBJECT_NAME}</a>",
				width:350
			}, {
				field: "CHASU",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
				title: "차수",
				width:80
			}, {
				field: "EDU_PERIOD",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
                title: "교육기간",
				width:200
			}, {
                field: "APPLY_PERIOD",
                headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                attributes : {"class":"table-cell", style:"text-align:center"},
                title: "신청기간",
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
				field: "APPLY_NM",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
				title: "신청가능여부",
				width:130
			}]
		});
	
        //일반신청 그리드
		$("#grid3").kendoGrid({
			dataSource: dataSource_list3,
			height: 540,
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
				field: "TRAINING_NM",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
                title: "학습유형",
				width:120
			}, {
				field: "SUBJECT_NAME", title: "과정명",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left;text-decoration: underline;" },
				template: "<a href='javascript:void();' onclick='fn_sbjctInfoOpen(3, ${OPEN_NUM}); return false;' >${SUBJECT_NAME}</a>",
				width:350
			}, {
				field: "CHASU",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
				title: "차수",
				width:80
			}, {
				field: "EDU_PERIOD",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
                title: "교육기간",
				width:200
			}, {
                field: "APPLY_PERIOD",
                headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                attributes : {"class":"table-cell", style:"text-align:center"},
                title: "신청기간",
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
				field: "APPLY_NM",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
				title: "신청가능여부",
				width:130
			}]
		});
	
		var tabstrip = $("#tabstrip").kendoTabStrip({
			animation:  {
				open: {
					effects: "fadeIn"
				}
			},
            activate: onActivateTabstrip // 탭이 변경되면 스크롤이 화면상단으로 옮겨지면서 메뉴 재조정 필요.
		});

        function onActivateTabstrip(e){
            navigation.scroll(); //메뉴위치 재설정
        }
        
		//역량진단 탭 화면 분할
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

		//일반신청 탭 화면 분할
        $("#splitter3").kendoSplitter({
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
        
        /* 검색버튼 Click Event */
        $('#srchBtn1').click(function(){ dataSource_list1.read(); });
		$('#srchBtn3').click(function(){ dataSource_list3.read(); });
        
        /* 상세영역 생성 */
        $('#details1').show().html(kendo.template($('#template').html()));
        $('#details3').show().html(kendo.template($('#template').html()));
		
		/* 수강신청버튼 Click Event */
		$('#details1 #applySbjctBtn').click(function(){ fn_applySbjct('#details1'); });
		$('#details3 #applySbjctBtn').click(function(){ fn_applySbjct('#details3'); });
		
		/* 닫기버튼 Click Event */
		$('#details1 #closeBtn').click(function(){ $("#splitter1").data('kendoSplitter').toggle("#detail_pane1",false); });
		$('#details3 #closeBtn').click(function(){ $("#splitter3").data('kendoSplitter').toggle("#detail_pane3",false); });
		
		// 현재년도 교육이수현황 조회
		//fn_getTaskEdu();
		

        /* 첨부파일 */
        $("#details1 #my-file-gird").kendoGrid({
            dataSource: {
                type: 'json',
                transport: {
                    read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json', type: 'POST' },      
                    destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
                    parameterMap: function (options, operation){
                        return { objectType: "1", objectId:$("#details1 #dtl_open_num").val(), startIndex: options.skip, pageSize: options.pageSize };
                    }
                },
                schema: {
                    model: Attachment,
                    data : "targetAttachments"
                },
            },
            pageable: false,
            height: 120,
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
                   width: "95px" , 
                   template: function(dataItem){
                       return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>';
                   } 
               }
            ]
        });
        $("#details3 #my-file-gird").kendoGrid({
            dataSource: {
                type: 'json',
                transport: {
                    read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json', type: 'POST' },      
                    destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
                    parameterMap: function (options, operation){
                        return { objectType: "1", objectId:$("#details3 #dtl_open_num").val(), startIndex: options.skip, pageSize: options.pageSize };
                    }
                },
                schema: {
                    model: Attachment,
                    data : "targetAttachments"
                },
            },
            pageable: false,
            height: 120,
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
                   width: "95px" , 
                   template: function(dataItem){
                       return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>';
                   } 
               }
            ]
        });
    }
 
}]);

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
						
						html2 = "<table class=\"table_type02\">";
						html2 += "<colgroup>";
						html2 += "<col style=\"width:180px\"/>";
						$.each(obj.items1, function(i, e) {
							if(i>0) {
								// 첫행은 총시간이므로 제외
								html2 += "<col style=\"width:*\" />";
								colspanCnt++;
							}
						});
						html2 += "</colgroup>";
						html2 += "<thead>";
						html2 += "<tr>";
						html2 += "<th rowspan=\"2\" class=\"fir\"></th>";
						html2 += "<th rowspan=\"2\" class=\"fir\">총시간</th>";
						html2 += "<th colspan=\"'+colspanCnt+'\" class=\"fir\">부처지정학습 </th>";
						html2 += "</tr>";
						html2 += "<tr>";
						$.each(obj.items1, function(i, e) {
							if(i>0) {
								// 첫행은 총시간이므로 제외
								html2 += "<th><span class=\"blue\">"+e.LABEL+"</span></th>";
							}
						});
						html2 += "</tr>";
						html2 += "</thead>";
						html2 += "<tbody>";
						html2 += "<tr>";
						html2 += "<td>필수시간(H)</td>";
						$.each(obj.items1, function(i, e) {
							html2 += "<td>"+e.REQ_TIME+"</td>";
						});
						html2 += "</tr>";
						html2 += "<tr>";
						html2 += "<td>이수시간(H)</td>";
						$.each(obj.items1, function(i, e) {
							html2 += "<td>"+e.TAKE_TIME+"</td>";
						});
						html2 += "</tr>";
						html2 += "</tbody>";
						html2 += "</table>";
					} else {
						html2 = '※ 현재 설정된 필수 이수 현황이 존재 하지 않습니다.';
					}
				}
				
				$('#req_task_stt_list').append(html2);
				
				if(obj.items2!=null) {
					if(obj.items2.length>0) {
						html3 = "<table class=\"table_type02\">";
						html3 += "<colgroup>";
						html3 += "<col style=\"width:180px\"/>";
						$.each(obj.items2, function(i, e) {
							html3 += "<col style=\"width:*\" />";
						});
						html3 += "</colgroup>";
						html3 += "<thead>";
						html3 += "<tr>";
						html3 += "<th></th>";
						$.each(obj.items2, function(i, e) {
							html3 += "<th>"+e.LABEL+"</th>";	
						});
						html3 += "</tr>";
						html3 += "</thead>";
						html3 += "<tbody>";
						html3 += "<tr>";
						html3 += "<td>필수시간(H)</td>";
						$.each(obj.items2, function(i, e) {
							html3 += "<td>"+e.REQ_TIME+"</td>";
						});
						html3 += "</tr>";
						html3 += "<tr>";
						html3 += "<td>이수시간(H)</td>";
						$.each(obj.items2, function(i, e) {
							html3 += "<td>"+e.TAKE_TIME+"</td>";
						});
						html3 += "</tr>";
						html3 += "</tbody>";
						html3 += "</table>";
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

/* 역량진단 결과목록 조회 */
var fn_selectCarList = function(run_num) {
	var html = '';
	$('#car_list').empty();
	
	//if(run_num!=null && run_num!="") {
		$.ajax({
	        type : 'POST',
	        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emapply/select-mcs-list.do?output=json",
	        data : { 
	        	runNum : run_num
	        },
	        complete : function( response ){
	            var obj = eval("(" + response.responseText + ")");
	             if(obj.error){
	                 alert("ERROR=>"+obj.error.message);
	             }else{

					if(obj.items!=null) {
						if(obj.items.length > 0) {
							html = "<table class=\"table_type02\">";
							html += "<colgroup>";
							html += "<col style=\"width:100px\"/>";
							$.each(obj.items, function(i, e) {
								html += "<col style=\"width:*\" />";
							});
							html += "</colgroup>";
							html += "<thead>";
							html += "<tr>";
							html += "<th>역량명</th>";
							$.each(obj.items, function(i, e) {
								html += "<th style=\"width: 100px;\">"+e.CMPNAME+"</th>";	
							});
							html += "</tr>";
							html += "</thead>";
							html += "<tbody>";
							/*
							html += "<tr>";
							html += "<td>요구수준</td>";
							$.each(obj.items, function(i, e) {
								html += "<td>"+e.BRL_SCR+"</td>";
							});
							html += "</tr>";
							*/
							html += "<tr>";
							//html += "<td>취득점수(GAP)</td>";
							html += "<td>취득점수</td>";
							$.each(obj.items, function(i, e) {
								//html += "<td>"+e.MY_SCR+'('+e.GAP+')</td>";
								var myScore = "";
								if(e.MY_SCR){
									myScore = e.MY_SCR+"점";
								}else{
									myScore  = "-";
								}
								html += "<td>"+myScore+"</td>";
							});
							html += "</tr>";
							
							//매핑과정보기 버튼..
							html += "<tr>";
                            html += "<td><button onclick=\"filterData(-1); return false;\" class=\"k-button\" >전체보기</button></td>";
                            $.each(obj.items, function(i, e) {
                                html += "<td><button onclick=\"filterData('"+e.CMPNAME+"'); return false;\" class=\"k-button\" >과정보기</button></td>";
                            });
                            html += "</tr>";
                            
							html += "</tbody>";
							html += "</table>";
						} else {
							html = '※ 역량진단 결과정보가 존재 하지 않습니다.';
						}
					}
					
					$('#car_list').append(html);
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
	//} else {
	//	html = '※ 역량진단 결과정보가 존재 하지 않습니다.';
	//	$('#car_list').append(html);
	//}
};

//역량별 교육과정 목록 filter
var filterData = function (cn){
    var educmptgridDatasource = $("#grid1").data('kendoGrid').dataSource;
    if(cn==-1){
        educmptgridDatasource.filter({});
    }else{
        educmptgridDatasource.filter({
            "field":"CMPNAME",
            "operator":"eq",
            "value":cn
        });
    }
}

/* 역량진단 교육시작일 검색 시작값 변경 시 */
var fn_changeSdateFrom1 = function() {
	var startDate = sdateFrom1.value();
    var endDate = sdateTo1.value();

    if (startDate) {
        startDate = new Date(startDate);
        startDate.setDate(startDate.getDate());
        sdateTo1.min(startDate);
    } else if (endDate) {
    	sdateFrom1.max(new Date(endDate));
    } else {
        endDate = new Date();
        sdateFrom1.max(endDate);
        sdateTo1.min(endDate);
    }
};
/* 경력개발계획 교육시작일 검색 시작값 변경 시 */
/*var fn_changeSdateFrom2 = function() {
	var startDate = sdateFrom2.value();
    var endDate = sdateTo2.value();

    if (startDate) {
        startDate = new Date(startDate);
        startDate.setDate(startDate.getDate());
        sdateTo2.min(startDate);
    } else if (endDate) {
    	sdateFrom2.max(new Date(endDate));
    } else {
        endDate = new Date();
        sdateFrom2.max(endDate);
        sdateTo2.min(endDate);
    }
};*/
/* 일반신청 교육시작일 검색 시작값 변경 시 */
var fn_changeSdateFrom3 = function() {
	var startDate = sdateFrom3.value();
    var endDate = sdateTo3.value();

    if (startDate) {
        startDate = new Date(startDate);
        startDate.setDate(startDate.getDate());
        sdateTo3.min(startDate);
    } else if (endDate) {
    	sdateFrom3.max(new Date(endDate));
    } else {
        endDate = new Date();
        sdateFrom3.max(endDate);
        sdateTo3.min(endDate);
    }
};
/* 역량진단 교육시작일 검색 종료값 변경 시 */
var fn_changeSdateTo1 = function() {
    var startDate = sdateFrom1.value();
    var endDate = sdateTo1.value();

    if (endDate) {
        endDate = new Date(endDate);
        endDate.setDate(endDate.getDate());
        sdateFrom1.max(endDate);
    } else if (startDate) {
    	sdateTo1.min(new Date(startDate));
    } else {
        endDate = new Date();
        sdateFrom1.max(endDate);
        sdateTo1.min(endDate);
    }
};
/* 경력개발계획 교육시작일 검색 종료값 변경 시 */
/*var fn_changeSdateTo2 = function() {
    var startDate = sdateFrom2.value();
    var endDate = sdateTo2.value();

    if (endDate) {
        endDate = new Date(endDate);
        endDate.setDate(endDate.getDate());
        sdateFrom2.max(endDate);
    } else if (startDate) {
    	sdateTo2.min(new Date(startDate));
    } else {
        endDate = new Date();
        sdateFrom2.max(endDate);
        sdateTo2.min(endDate);
    }
};*/
/* 일반신청 교육시작일 검색 종료값 변경 시 */
var fn_changeSdateTo3 = function() {
    var startDate = sdateFrom3.value();
    var endDate = sdateTo3.value();

    if (endDate) {
        endDate = new Date(endDate);
        endDate.setDate(endDate.getDate());
        sdateFrom3.max(endDate);
    } else if (startDate) {
    	sdateTo3.min(new Date(startDate));
    } else {
        endDate = new Date();
        sdateFrom3.max(endDate);
        sdateTo3.min(endDate);
    }
};

/* 교육 신청 */
var _page_id = '';
var _open_num = '';
var fn_applySbjct = function(page_id) {
	_page_id = page_id;
	_open_num = $(page_id + ' #dtl_open_num').val();
		
	// 신청가능 과정여부 판단
	if($(_page_id + ' #dtl_apply_cd').val()=='01') {
		alert('신청중인 과정입니다.');
		return;
	} else if($(_page_id + ' #dtl_apply_cd').val()=='02') {
		alert('수강중인 과정입니다.');
		return;
	} else if($(_page_id + ' #dtl_apply_cd').val()=='05') {
		alert('수료한 과정입니다.');
		return;
	} else if($(_page_id + ' #dtl_apply_cd').val()=='10') {
        alert('신청기간이 아닙니다.');
        return;
    }  /*else if($(_page_id + ' #dtl_apply_cd').val()=='05') {
		//alert('본 과정은 "http://www.ooo.go.kr" 에서 신청 가능 합니다.');
		var html = '';
		
		if($('#dtl_sample_url').val()==null || $('#dtl_sample_url').val()=="") {
			html += '본 과정은 외부망에서 신청가능한 과정이지만 연결 URL이 존재하지 않습니다.<br>';
			html += '교육운영자에게 문의하세요.<br>';
		} else {
			html += '본 과정은 아래의 주소에서 신청하셔야 합니다(외부망)<br>';
			html += $('#dtl_sample_url').val();
		}
		html += '<br>';
		
		openAlterWindow(html);
		return;
	}*/
	

    //상시학습종류별 연간인정시간 체크
    $.ajax({
        type : 'POST',
        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/year_recog_limit_check.do?output=json",
        data : {
            asOpenSeq : _open_num,
            tUserid : tUserid,
            eduDiv : "1",
            yyyy : $(_page_id + " #dtl_yyyy").val(),
            recogTimeH : $(_page_id + " #dtl_recog_time_h").val(),
            recogTimeM : $(_page_id + " #dtl_recog_time_m").val(),
            alwStdCd : removeNullStr( $(_page_id + " #dtl_alw_std_cd").val() )
        },
        complete : function( response ){
            var obj = eval("(" + response.responseText + ")");
            if(obj.error){
                 alert("ERROR=>"+obj.error.message);
            } else {
            	var adMsg = "";
                if( $(_page_id + ' #dtl_training_cd').val()=='C' ){
                    adMsg = "\n사이버교육은 개별 교육 사이트에서 신청하시기 바랍니다.";
                }
                
                 if(obj.statement!="") {
                     var msg = obj.statement.replace(/<br>/g, "\n");
                     
                     if(!confirm("선택된 과정은 연간 최대 인정시간 제한으로 아래와 같이 인정시간이 적용됩니다.\n\n"+msg+"\n\n그래도 해당 과정을 수강신청 하시겠습니까?"+adMsg)) return;
                 } else {

                	 if(!confirm("해당 과정을 수강신청 하시겠습니까?"+adMsg)) return;
                 }


                 // 결재필요 과정여부 판단
                 if( $(_page_id + ' #dtl_training_cd').val()=='A' || 
                     $(_page_id + ' #dtl_training_cd').val()=='B' ||
                     $(_page_id + ' #dtl_training_cd').val()=='D'
                     ) {
                     
                     // 결재창 오픈
                     apprReqOpen();
                     apprReqCallBackFunc = fn_saveEduAppl;
                 } else {
                     fn_saveEduAppl();
                 }
                 
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

/* 수강신청정보 등록 */
var fn_saveEduAppl = function() {
	var appr_list = null;
	
	if( $(_page_id + ' #dtl_training_cd').val()=='A' || 
		$(_page_id + ' #dtl_training_cd').val()=='B' ||
		$(_page_id + ' #dtl_training_cd').val()=='D'
		) {
		if($("#apprReqUserGrid").data("kendoGrid")){
			appr_list = $("#apprReqUserGrid").data("kendoGrid").dataSource.data();
		} else {
			alert('승인자 정보가 없습니다. 승인자를 선택해주세요.');
			return;
		}
	}
	
	$.ajax({
        type : 'POST',
        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emapply/update-sbjct-apply.do?output=json",
        data : {
        	openNum : _open_num,
        	apprList : kendo.stringify( appr_list )
        },
        complete : function( response ){
            var obj = eval("(" + response.responseText + ")");
             if(obj.error){
                 alert("ERROR=>"+obj.error.message);
             }else{
            	 if(obj.statement=='Y') {
            		alert("신청되었습니다.");
            		
            		// 교육신청정보 등록 후 목록 재호출
            		if(_page_id=='#details1'){
            			dataSource_list1.read();
            			
            			//상세화면 재조회
            			fn_sbjctInfoOpen(1, _open_num);
            		}else if(_page_id=='#details3'){
            			dataSource_list3.read();

                        //상세화면 재조회
                        fn_sbjctInfoOpen(3, _open_num);
            		}
            		
            	 } else {

                     if(obj.statement=="01"){
                    	 alert("이미 신청중인 과정입니다.");
                     }else if(obj.statement=="02"){
                         alert("이미 수강중인 과정입니다.");
                     }else if(obj.statement=="05"){
                         alert("이미 수료한 과정입니다.");
                     }else if(obj.statement=="09"){
                         alert("승인요청정보가 존재하지 않습니다. 교육운영자에게 문의해주세요.");
                     }else if(obj.statement=="10"){
                         alert("신청기간이 아닙니다.");
                     }else {
                         alert("교육신청에 실패하였습니다");
                     }
            		 
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
};

/* 결재창 팝업 열기 */
var fn_apprOpen = function(reqNum){
	//승인현황 팝업 호출.
	apprStsOpen(1, reqNum);
	//승인취소 처리 후 callback 함수 정의
	reqCancelCompleteCallbackFunc = fn_afterEduCancel;
};

/* 교육상세 열기 */
var fn_sbjctInfoOpen = function(tab_page, open_num) {
	
	var detailId = '';
	var splitterId = '';
	var detailPanelId = '';
	var cmMapHtml = '';
	var cmpltStndHtml = '';
	 
	if(tab_page==1) {
		detailId = '#details1';
		splitterId = '#splitter1';
		detailPanelId  = '#detail_pane1';
	} /*else if(tab_page==2) {
		detailId = '#details2';
		splitterId = '#splitter2';
		detailPanelId  = '#detail_pane2';
 	} */else if(tab_page==3) {
 		detailId = '#details3';
		splitterId = '#splitter3';
		detailPanelId  = '#detail_pane3';
 	}
	
	//$(detailId + ' #applySbjctBtn').hide(); // 수강신청 버튼 숨김
	
	if(open_num!=null) {
		$.ajax({
	        type : 'POST',
	        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emapply/select-so-dtl.do?output=json",
	        data : { 
	        	openNum : open_num
	        },
	        complete : function( response ){
	            var obj = eval("(" + response.responseText + ")");
	             if(obj.error){
	                 alert("ERROR=>"+obj.error.message);
	             } else {
	            	// 상세창 열기
	            	if(obj.item.cm_map_list != null) {
	            		$.each(obj.item.cm_map_list, function(i, e) {
	            			cmMapHtml += "<p class=\"bold\">"+e.CMPNM+"</p>";
	            		});
	            	}
	            	
					if(obj.item.cmplt_stnd_list != null) {
						if(obj.item.cmplt_stnd_list.length>0){
							$.each(obj.item.cmplt_stnd_list, function(i, e) {
	                            cmpltStndHtml += "<tr><th scope=\"row\">"+e.CMPLT_STND_NM+"</th><td style=\"text-align: center; \">"+e.WEI+"</td></tr>";
	                        });
						}else{
							cmpltStndHtml += "<tr><td colspan=\"2\" style=\"text-align: center; \">데이터가 존재하지 않습니다.</td></tr>";
						}
					}
	            	
             		$(splitterId).data("kendoSplitter").expand(detailPanelId);
             		kendo.bind($(detailPanelId).children(), obj.item); // 과정개설 상세정보 바인딩
	            	
             		//alert($(detailPanelId + " #dtl_alw_std_cd").val());
             		
	            	// 역량맵핑정보 셋팅
             		$(detailPanelId+' #cm_map_list').empty();
             		$(detailPanelId+' #cm_map_list').append(cmMapHtml);
             		
             		// 수료기준정보 셋팅
             		$(detailPanelId+' #cmplt_stnd_list').empty();
             		$(detailPanelId+' #cmplt_stnd_list').append(cmpltStndHtml);
	            	
	            	//if(obj.item.APPLY_CD=='00') $(detailId + '#applySbjctBtn').show(); // 수강신청 버튼 보임
             		  
                    //첨부파일 재 조회.
                    $(detailPanelId+" #my-file-gird").data('kendoGrid').dataSource.read(); 
                    
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
		alert('과정정보가 없습니다.');
	}
};

/* 알림창 열기 */
var openAlterWindow = function(txt) {
	var alert_window = $("#alert-window");
	if (!alert_window.data("kendoWindow")) {
		alert_window.kendoWindow({
            width: "400px",
            title: "알림",
            modal: true,
            visible: false
        });
	}
	
	$('#alert_window_noti').html(txt);
	
	alert_window.data("kendoWindow").open();
	alert_window.data("kendoWindow").center();
};
/* 알림창 닫기 */
var closeAlterWindow = function() {
	$("#alert-window").data('kendoWindow').close();	
}
</script>

<style scoped>
	#tabstrip {width: 1220px;}
	.k-link {font-weight:bold;}
	.demo-section.style01 {width:120px;}
	.k-input {padding-left:5px;}
</style>
		
</head>
<body>
	<div class="container">
		<div id="cont_body">
		 <div class="content">
			<div class="top_cont">
				<h3 class="tit01">교육신청</h3>
				<div class="point">※ 듣고자 하는 교육을 신청할 수 있습니다.<br/>※ 신청 후엔 “나의 강의실＂에서 신청한 교육의 정보를 열람할 수 있습니다.</div>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>교육훈련&nbsp; &#62;</span>
					<span class="h">교육신청</span>
				</div><!--//location-->
			</div>
			&nbsp;
			 <div class="sub_cont" >
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
				<div >
					<div id="tabstrip">
						<ul>
							<li class="k-state-active">역량진단</li>
							<!-- <li>경력개발계획</li> -->
							<li>일반신청</li>
						</ul>
						<div class="tab_cont">
							<ul class="select_Area03 mt10">
								<li class="tit">진단명</li>
								<li class="txt"><%=camTitleStr%><input type='hidden' id='cam_run_num' value='<%=camRunNum%>'></li>
							</ul>
							 <!-- <p class="point2 mt10">※ 역량별 취득 점수 클릭 시 해당 역량을 개발하기 위한 과정이 검색됩니다.</p> -->
							<div id="car_list" class="mt10"></div>
							<ul class="select_Area03 mt15">
								<li class="tit">교육시작일</li>
								<li>
									<input id="sdate_from1" value="<%=srchFrom%>" style="width:120px;" /> ~ <input id="sdate_to1" value="<%=srchTo%>" style="width:120px;" />
									&nbsp;&nbsp;<button id="srchBtn1" class="k-button" style="width:60px;">검색</button>
								</li>
							</ul>
							 <p class="point2 mt15">※ 과정명을 클릭하면 과정의 상세 정보를 열람할 수 있으며, 수강 신청을 할 수 있습니다.</p>
							 <div id="splitter1" style="width:100%; height: 545px; border:none;" class="mt10 mb10 ie7_sp">
								<div id="list_pane1">
									<div id="grid1"></div>
								</div>
								<div id="detail_pane1">
									<div id="details1"></div>
								</div>
							</div>
						</div><!--//tab_cont1-->
						
						<!-- <div class="tab_cont">
							<ul class="select_Area03 mt10 mb10">
								<li class="tit" >계획명</li>
								<li class="txt"><%//=cdpTitleStr%><input type='hidden' id='cdp_run_num' value='<%//=cdpRunNum%>'></li>
							</ul>
							<ul class="select_Area03">
					
								<li class="tit">교육시작일</li>
								<li>
									<input id="sdate_from2" value="<%=srchFrom%>" style="width:120px;" /> ~ <input id="sdate_to2" value="<%=srchTo%>" style="width:120px;" />
									&nbsp;&nbsp;<button id="srchBtn2" class="k-button" style="width:60px;">검색</button>
								</li>
							</ul>
							<p class="point2 mt10">※ 과정명을 클릭하면 과정의 상세 정보를 열람할 수 있으며, 수강 신청을 할 수 있습니다.</p>
							 <div id="splitter2" style="width:1180px; height: 545px; border:none;" class="mt10 mb10">
								<div id="list_pane2">
									<div id="grid2" ></div>
								</div>
								<div id="detail_pane2">
									<div id="details2"></div>
								</div>
							</div>
						</div> --><!--//tab_cont2-->
						<div class="tab_cont">
							<ul class="select_Area03 mt10">
								<li class="tit">교육시작일</li>
								<li>
									<input id="sdate_from3" value="<%=srchFrom%>" style="width:120px;" /> ~ <input id="sdate_to3" value="<%=srchTo%>" style="width:120px;" />
									&nbsp;&nbsp;<button id="srchBtn3" class="k-button" style="width:60px;">검색</button>
								</li>
							</ul>
							<p class="point2 mt10">※ 과정명을 클릭하면 과정의 상세 정보를 열람할 수 있으며, 수강 신청을 할 수 있습니다.</p>
							 <div id="splitter3" style="width:1180px; height: 545px; border:none;" class="mt10 mb10">
								<div id="list_pane3">
									<div id="grid3"></div>
								</div>
								<div id="detail_pane3">
									<div id="details3"></div>
								</div>
							</div>
						</div><!--//tab_cont3-->
					</div>
				</div>
			 </div><!--//sub_cont-->                
		 </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->

<script type="text/x-kendo-template" id="template">
	<div id="tabular" class="detail_Info">
		<input type="hidden" id="dtl_open_num" data-bind="value:OPEN_NUM" />
		<input type="hidden" id="dtl_apply_cd" data-bind="value:APPLY_CD" />
		<input type="hidden" id="dtl_sample_url" data-bind="value:SAMPLE_URL" />
		<input type="hidden" id="dtl_training_cd" data-bind="value:TRAINING_CODE" />
        <input type="hidden" id="dtl_yyyy" data-bind="value:YYYY" />
        <input type="hidden" id="dtl_recog_time_h" data-bind="value:RECOG_TIME_H" />
        <input type="hidden" id="dtl_recog_time_m" data-bind="value:RECOG_TIME_M" />
        <input type="hidden" id="dtl_alw_std_cd" data-bind="value:ALW_STD_CD" />


		<div class="tit">과정상세정보</div>
		<div class="dl_scroll">
			<div class="dl_wrap">
				<dl>
					<dt class="fir">학습유형</dt>
					<dd class="fir"><span data-bind="text:TRAINING_NM"></span>&nbsp;</dd>
				</dl>
				<dl>
					<dt>과정명</dt>
					<dd><span data-bind="text:SUBJECT_NAME"></span>&nbsp;</dd>
				</dl>
				<dl>
                    <dt class="noline">상시학습종류</dt>
                    <dd class="line"><span data-bind="text:ALW_STD_NM"></span>&nbsp;</dd>
                </dl>
                <dl >
					<dt class="noline">기수</dt>
					<dd class="line"><span data-bind="text:CHASU"></span>&nbsp;</dd>
				</dl>
				<dl>
					<dt>교육기간</dt>
					<dd><span data-bind="text:EDU_PERIOD"></span>&nbsp;</dd>
				</dl>
				<dl>
					<dt>신청기간</dt>
					<dd><span data-bind="text:APPLY_PERIOD"></span>&nbsp;</dd>
				</dl>
				<dl>
					<dt>취소마감일</dt>
					<dd><span data-bind="text:CANCEL_EDATE"></span>&nbsp;</dd>
				</dl>
				<dl>
					<dt>모집정원</dt>
					<dd><span data-bind="text:APPLICANT"></span>명</dd>
				</dl>
				<dl>
					<dt>교육일수</dt>
					<dd><span data-bind="text:EDU_DAYS"></span>일</dd>
				</dl>
				<dl>
					<dt>교육시간</dt>
					<dd><span data-bind="text:EDU_HOUR_H"></span>시간 <span data-bind="text:EDU_HOUR_M"></span>분</dd>
				</dl>
				<dl>
					<dt>인정시간</dt>
					<dd><span data-bind="text:RECOG_TIME_H"></span>시간 <span data-bind="text:RECOG_TIME_M"></span>분</dd>
				</dl>
				<dl>
					<dt>목적</dt>
					<dd>
						<textarea cols="10" rows="5" class="textarea03" style="width:100%;" readonly="readonly" data-bind="value:EDU_OBJECT"/></textarea>
					</dd>
				</dl>
				<dl>
					<dt class="mt5">대상</dt>
					<dd>
						<textarea cols="10" rows="5" class="textarea03 mt5" style="width:100%;" readonly="readonly" data-bind="value:EDU_TARGET"/></textarea>
					</dd>
				</dl>
				<dl>
					<dt class="mt5">내용</dt>
					<dd>
						<textarea cols="10" rows="5" class="textarea03 mt5" style="width:100%;" readonly="readonly" data-bind="value:COURSE_CONTENTS"/></textarea>
					</dd>
				</dl>
				<dl>
					<dt>부처지정학습</dt>
					<dd><span data-bind="text:DEPT_DESIGNATION_YN"></span>&nbsp;</dd>
				</dl>
				<dl style="display:none;" >
					<dt>지정학습종류</dt>
					<dd><span data-bind="text:DEPT_DESIGNATION_NM"></span>&nbsp;</dd>
				</dl>
				<dl>
					<dt>기관성과평가</dt>
					<dd><span data-bind="text:PERF_ASSE_SBJ_NM"></span>&nbsp;</dd>
				</dl>
                <dl>
                    <dt>교육시간구분</dt>
                    <dd><span data-bind="text:OFFICETIME_NM"></span>&nbsp;</dd>
                </dl>
                <dl>
                    <dt class="noline">교육기관구분</dt>
                    <dd class="line"><span data-bind="text:EDUINS_DIV_NM"></span>&nbsp;</dd>
                </dl>
                <dl>
                    <dt class="noline">교육기관</dt>
                    <dd class="line"><span data-bind="text:INSTITUTE_NAME"></span>&nbsp;</dd>
                </dl>
				<!--<dl>
					<dt>필수여부</dt>
					<dd><span data-bind="text:REQUIRED_YN"></span></dd>
				</dl>-->
				<dl>
					<dt class="noline">맵핑역량</dt>
					<dd id="cm_map_list" class="line">&nbsp;</dd>
				</dl>
				<dl>
					<dt class="noline">수료기준</dt>
					<dd class="line">
						<div class="t_wrap">
							<table class="table_type04">
								<colgroup>
									<col style="width:190px" />
									<col style="width:190px" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">기준</th>
										<th scope="col">가중치(%)</th>
									</tr>
								</thead>
								<tbody id="cmplt_stnd_list">
																	
								</tbody>
							</table>
                            <span data-bind="text:EVL_CMPL"></span>
						</div>
					</dd>
				</dl>
                <dl>
                    <dt class="noline">첨부파일</dt>
                    <dd id="attachFiles" class="line">
                        <div id="my-file-gird"></div>
                    </dd>
                </dl>
				<div class="btn_top">
					<button id="applySbjctBtn" class="k-button k-primary" style="width:88px;">수강신청</button>
					<button id="closeBtn" class="k-button" style="width:88px;">닫기</button>
				</div>
			</div>
		</div>
	</div>
</script>

<%@ include file="/includes/jsp/user/common/apprReqPopup.jsp"  %>

<div id="alert-window" style="display: none;">
    <div id="alert_window_noti">
    
    </div>
    <div class="btn_center mt20">
        <button class="k-button k-primary" style="width:110px;" onclick='closeAlterWindow();'>닫기</button>
    </div>
</div>
</body>
</html>