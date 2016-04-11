<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="java.util.*"%>
<%--
사용자 > 교육훈련 > 나의강의실
--%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}

kr.podosoft.ws.service.em.action.EmMainAction  action = (kr.podosoft.ws.service.em.action.EmMainAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

Map<String,Object> yearMap = (Map<String,Object>)request.getAttribute("item");
int minYear = Integer.parseInt(yearMap.get("MIN_YYYY").toString());
int maxYear = Integer.parseInt(yearMap.get("MAX_YYYY").toString());
int nowYear = Integer.parseInt(yearMap.get("YYYY").toString());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage"   >
<head>
<style>
    .k-grid-content {height: 464px;}
</style>
<title></title>
<script type="text/javascript">
var dataSource_list1;
var dataSource_list2;
var detailId;
var tud = <%=action.getUser().getUserId()%>;

yepnope([{
    load: [
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.<%=theme%>.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/front-ui_mpva.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js'
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
       	
       	$("#yyyy").data("kendoDropDownList").value("<%= nowYear%>");
        
        dataSource_list1 = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/select-es-list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){ 
                    return { type : "1" };
                }
            },
            schema: {
            	total: "totalItemCount",
                data: "items",
                model: {
                    fields: {
                    	EDU_TP : { type: "int" } ,
                    	SUBJECT_NUM : { type: "int" } ,
                 	   	OPEN_NUM  : { type: "int" },
                 	   	SUBJECT_NAME : { type : "string" },
                 	   	TRAINING_NM : {type:"string"},
                 	   	YYYY : {type:"int"},
                 	   	CHASU : {type:"string"},
                 	   	EDU_PERIOD : { type:"string" },
                 	   	DEPT_DESIGNATION_YN : { type:"string"},
                 	   	VETER_ASSE_REQ_YN : { type: "string" },
                 	   	ATTEND_STATE_NM : { type: "string" },
                 	   	REQ_NUM : { type: "int" },
                 	   	REQ_STS_NM : { type: "string" },
                 	   	RECOG_TIME : {type:"string"},
                 	   	CANCEL_YN : { type:"string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false,
			pageSize: 30,
			requestEnd : function(e) {
				if(e.type == "read") {
					if(e.response.totalItemCount!=null && e.response.totalItemCount > 0) {
						dataSource_list1.filter({
		                      "field" : "YYYY",
		                      "operator" : "eq",
		                      "value" : Number($("#yyyy").val())
		               	});
					}
				}
			},
            error : function(e) {
                if(e.xhr.status==403){
                   alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                   sessionout();
                }else{
                   alert('xhr.status = ' + e.xhr.status + '\n' +  'xhr.statusText = '  + e.xhr.statusText );
                }
            }
		});
        
        dataSource_list2 = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/select-es-list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){ 
                    return { type : "2" };
                }
            },
            schema: {
            	total: "totalItemCount",
                data: "items",
                model: {
                    fields: {
                    	EDU_TP : { type: "int" } ,
                    	SUBJECT_NUM : { type: "int" } ,
                 	   	OPEN_NUM  : { type: "int" },
                 	   	SUBJECT_NAME : { type : "string" },
                 	   	TRAINING_NM : {type:"string"},
                 	   	YYYY : {type:"int"},
                 	   	CHASU : {type:"string"},
                 	   	EDU_PERIOD : { type:"string" },
                 	   	DEPT_DESIGNATION_YN : { type:"string"},
                 	   	VETER_ASSE_REQ_YN : { type: "string" },
                 	   	ATTEND_STATE_NM : { type: "string" },
                 	   	REQ_NUM : { type: "int" },
                 	   	REQ_STS_NM : { type: "string" },
                 	   	RECOG_TIME : {type:"string"},
                 	   	CANCEL_YN : { type:"string" }
                    }
                }
            },
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
            }
		});
        
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
        
        //탭 정의...
        $("#tabstrip").kendoTabStrip({
			animation:  {
				open: {
					effects: "fadeIn"
				}
			},
			activate: onActivateTabstrip // 탭이 변경되면 스크롤이 화면상단으로 옮겨지면서 메뉴 재조정 필요.
		});
        
        function onActivateTabstrip(e){
            navigation.scroll(); //메뉴위치 재설정
            
            if(e.item.innerText == "학습현황"){
            	detailId = "#details1";
            }else{
            	detailId = "#details2";
            }
        }

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

		$("#grid1").kendoGrid({
			dataSource: dataSource_list1,
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
				template: "<a href=\"javascript:void(0);\" onclick=\"javascript:fn_eudnInfoOpen(1, ${OPEN_NUM}, ${EDU_TP});\" >${SUBJECT_NAME}</a>",
				width : 350
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
			},{
				field: "ATTEND_STATE_NM",
				headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				attributes : {"class":"table-cell", style:"text-align:center"},
				title: "수강상태",
				width:100
			},{
                field: "APL_DIV_NM",
                headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                attributes : {"class":"table-cell", style:"text-align:center"},
                title: "신청구분",
                width:150
            },{
				field: "REQ_STS_NM",
                headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                attributes : {"class":"table-cell", style:"text-align:center"},
				title: "승인현황",
				width:110,
                template: function(data){
                	// 결재번호가 있고 결재상태가 '0'이 아닐경우 결재정보 팝업버튼 생성
                	if(typeof data.REQ_NUM!="undifined" && data.REQ_NUM>0){
                		if(data.REQ_STS_CD!="0") {
							return "<a class=\"k-button\" onclick=\"javascript: fn_apprOpen("+data.REQ_NUM+")\" >"+data.REQ_STS_NM+"</a>";
                		} else {
                			return "";
                		}
                    } else {
                    	if(data.REQ_STS_NM){
                    		return data.REQ_STS_NM;
                    	}else{
                    		return "";
                    	}
                    }
                }
			}]
		});
	

        $("#splitter2").kendoSplitter({
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
        
		$("#grid2").kendoGrid({
			dataSource: dataSource_list2,
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
				template: "<a href=\"javascript:void(0);\" onclick=\"javascript:fn_eudnInfoOpen(2, ${OPEN_NUM}, ${EDU_TP});\" >${SUBJECT_NAME}</a>",
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
			}]
		});

        /* 상세영역 생성 */
        $("#details1").show().html(kendo.template($("#template").html()));
        $("#details2").show().html(kendo.template($("#template").html()));
		
		/* 수강취소버튼 Click Event */
		$("#details1 #cancelEduBtn").click(function(){ fn_eduCancel("#details1"); });
		$("#details2 #cancelEduBtn").click(function(){ fn_eduCancel("#details2"); });
		
		/* 닫기버튼 Click Event */
		$("#details1 #closeBtn").click(function(){ $("#splitter1").data("kendoSplitter").toggle("#detail_pane1",false); });
		$("#details2 #closeBtn").click(function(){ $("#splitter2").data("kendoSplitter").toggle("#detail_pane2",false); });
		
        /* 학습연계역량 저장 */
        $("#details1 #saveCmpnumber").click(function(){ fn_cmpnumberSave("#details1"); });
        
        //학습연계역량
        $("#details1 #dtl_cmpnumber").kendoComboBox({
            dataTextField: "TEXT",
            dataValueField: "VALUE",
            //dataSource: compDataSource,
            suggest: true,
            placeholder : "학습에 도움이 된 역량을 선택해주세요." 
        });
        
        $("#details2 #cmpnumberDL").hide();
        $("#details2 #attFileDL").hide();
        
        //교육자료 파일업로드
        var objectType = 7 ; //교육이력증빙자료
        if( !$("#my-file-gird").data('kendoGrid') ) {
            $("#my-file-gird").kendoGrid({
                dataSource: {
                    type: 'json',
                    transport: {
                        read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json', type: 'POST' },      
                        destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
                        parameterMap: function (options, operation){
                            if (operation != "read" && options) {                                                                                                                           
                                return { objectType: objectType, objectId:$(detailId+" #objectId").val(), attachmentId :options.attachmentId };                                                                   
                            }else{
                                 return { objectType: objectType, objectId:$(detailId+" #objectId").val(), startIndex: options.skip, pageSize: options.pageSize };
                            }
                        }
                    },
                    schema: {
                        model: Attachment,
                        data : "targetAttachments"
                    },
                },
                pageable: false,
                height: 140,
                selectable: false,
                columns: [
                    { 
                        field: "name", 
                        title: "파일명",  
                        width: "250px",
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"} ,
                        template: '#= name #' 
                   },/*
                   { 
                       field: "size",
                       title: "크기(byte)", 
                       format: "{0:##,###}", 
                       width: "100px" 
                   },*/
                   { 
                       width: "160px" , 
                       template: function(dataItem){
                    	   var str = '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>';
                    	   if($("#dtl_attend_state_code").val()=="1" || $("#dtl_attend_state_code").val()=="2"){
                    		   str += '<button style="width:60px; min-width: 50px;" class="k-button" onclick="deleteFile('+dataItem.attachmentId+')">삭제</button>';
                    	   }
                           return str;
                       } 
                   }
                ]/*,
                dataBound: function(e) {
                    var ver = getInternetExplorerVersion();
                    
                    if($("#my-file-gird").data('kendoGrid').dataSource.data().length > 0){
                        if( ( ver > -1) && ( ver < 10 ) ){
                            $('#openUploadWindow').attr("disabled",true);
                        }else{
                            $("#upload-file").data("kendoUpload").disable();
                        }
                    }else{
                        if( ( ver > -1) && ( ver < 10 ) ){
                            $('#openUploadWindow').removeAttr("disabled");
                        }else{
                            $("#upload-file").data("kendoUpload").enable();
                        }
                    }
                }*/
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
                        var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $(detailId+" #objectId").val(),
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
                        e.data = {objectType: objectType, objectId:$(detailId+" #objectId").val()};                                                                                                                    
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


        
		// 필수이수현황 조회
		fn_getTaskEdu();
    }
 
}]);

/* 검색년도 변경 시 목록 필터링 */
var fn_yyyyOnChange = function() {
	dataSource_list1.filter({
           "field" : "YYYY",
           "operator" : "eq",
           "value" : Number($("#yyyy").val())
    });
	
	// 상세 숨기기
	$("#splitter1").data("kendoSplitter").toggle("#detail_pane1",false);
	
	fn_getTaskEdu();
};

/* 이수현황 조회 */
var fn_getTaskEdu = function() {
	$.ajax({
        type : "POST",
        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/select-te-list.do?output=json",
        data : { 
        	year : $("#yyyy").val()					
        },
        complete : function( response ){
            var obj = eval("(" + response.responseText + ")");
             if(obj.error){
                 alert("ERROR=>"+obj.error.message);
             }else{
            	var html2 = "";
            	var html3 = "";
            	
            	$("#req_task_stt").empty();
            	$("#pa_task_stt").empty();
            	$("#req_task_stt").removeClass("yes");
            	$("#req_task_stt").removeClass("no");
            	$("#pa_task_stt").removeClass("yes");
            	$("#pa_task_stt").removeClass("no");
            	$("#req_task_stt_list").empty();
            	$("#pa_task_stt_list").empty();
            	$("#va_task_stt_time").empty();
            	$("#va_task_stt").removeClass("yes");
            	$("#va_task_stt").removeClass("no");
            	$("#va_task_stt").empty();
            	 
                if(obj.item!=null) {
                	if(obj.item.SCR_CHK1=="Y") {
                		$("#req_task_stt").text("이수");
                		$("#req_task_stt").addClass("yes");
                	} else {
                		$("#req_task_stt").text("미이수");
                		$("#req_task_stt").addClass("no");
                	}
                	
                	if(obj.item.SCR_CHK2=="Y") {
                		$("#pa_task_stt").text("이수");
                		$("#pa_task_stt").addClass("yes");
                	} else {
                		$("#pa_task_stt").text("미이수");
                		$("#pa_task_stt").addClass("no");
                	}
                	
                	$("#va_task_stt_time").html("승진 대비 이수 실적 &nbsp;: &nbsp;필수시간 - "+ obj.item.VA_REQ_TIME+"  /  이수시간 - "+obj.item.VA_TAKE_TIME);
                	
                	if(obj.item.SCR_CHK3=="Y") {
                		$("#va_task_stt").text("충족");
                		$("#va_task_stt").addClass("yes");
                	} else {
                		$("#va_task_stt").text("미충족");
                		$("#va_task_stt").addClass("no");
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
						html2 += "<th rowspan=\"1\" class=\"fir\"></th>";
						html2 += "<th rowspan=\"1\" class=\"fir\">총시간</th>";
						html2 += "<th colspan="+colspanCnt+" class=\"fir\">부처지정학습 </th>";
						html2 += "</tr>";
						/*html2 += "<tr>";
						$.each(obj.items1, function(i, e) {
							if(i>0) {
								// 첫행은 총시간이므로 제외
								html2 += "<th><span class=\"blue\">"+e.LABEL+"</span></th>";
							}
						});
						html2 += "</tr>";*/
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
						html2 = "※ 현재 설정된 필수 이수 현황이 존재 하지 않습니다.";
					}
				}
				
				$("#req_task_stt_list").append(html2);
				
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
						html3 = "※ 현재 설정된 기관성과평가 이수 현황이 존재 하지 않습니다.";
					}
				}
            	
				$("#pa_task_stt_list").append(html3);
             }
        },
        error: function( xhr, ajaxOptions, thrownError){
           // 로딩바 제거
           //loadingClose();
            
           if(xhr.status==403){
               alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
               sessionout();
           }else{
               alert("xrs.status = " + xhr.status + "\n" + 
                       "thrown error = " + thrownError + "\n" +
                       "xhr.statusText = "  + xhr.statusText );
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

/* 엑셀다운로드 */
var fn_excelDownload = function(type, button){
	if(type==1) {
		// 학습현황
   		button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/down-es-list-excel.do?year="+$("#yyyy").val();
	} else {
		// 보훈직무필수교육
   		button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/down-vare-list-excel.do";
   	}
};

/* 학습연계 역량 저장 */
var fn_cmpnumberSave  =  function(page_id){
	
    var open_num = $(page_id + " #dtl_open_num").val();
    var cmp = $(page_id+" #dtl_cmpnumber").data("kendoComboBox");
    //alert(cmp.select());
    if(cmp.select() < 0){
    	alert("역량을 선택해주세요.");
    	return false;
    }
    
    if(!confirm("저장하시겠습니까?")) return;
    
    $.ajax({
        type : "POST",
        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/update-edu-cmpnumber.do?output=json",
        data : { 
            openNum : open_num,
            cmpnumber: cmp.value(),
            div : detailId=="#details1" ? "1" : "2"
        },
        complete : function( response ){
            var obj = eval("(" + response.responseText + ")");
             if(obj.error){
                 alert("ERROR=>"+obj.error.message);
             }else{
                 if(obj.saveCount>0) {
                    alert("저장되었습니다.");
                    
                 } else {
                     alert("실패하였습니다. 교육운영자에게 문의해주세요.");
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
               alert("xrs.status = " + xhr.status + "\n" + 
                       "thrown error = " + thrownError + "\n" +
                       "xhr.statusText = "  + xhr.statusText );
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

/* 교육 취소 */
var fn_eduCancel = function(page_id) {
	var open_num = $(page_id + " #dtl_open_num").val();
	
	if($(page_id + " #dtl_cancel_yn").val()!="Y") {
		alert("수강취소가 불가능합니다.");
		return;
	}
	
	if(!confirm("수강 취소하시겠습니까?")) return;
	
	$.ajax({
        type : "POST",
        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/update-edu-cncl.do?output=json",
        data : { 
        	openNum : open_num
        },
        complete : function( response ){
            var obj = eval("(" + response.responseText + ")");
             if(obj.error){
                 alert("ERROR=>"+obj.error.message);
             }else{
            	 if(obj.statement=="Y") {
            		alert("취소처리되었습니다.");
            		// 교육신청정보 취소 후 목록 재호출
            		if(page_id=="#details1"){ 
            			dataSource_list1.read();
            			$("#splitter1").data("kendoSplitter").toggle("#detail_pane1",false);
            		}
            		else if(page_id=="#details2"){
            			dataSource_list2.read();
            			$("#splitter2").data("kendoSplitter").toggle("#detail_pane2",false);
            		}
            		
            	 } else {
            		 alert("취소처리에 실패하였습니다.");
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
               alert("xrs.status = " + xhr.status + "\n" + 
                       "thrown error = " + thrownError + "\n" +
                       "xhr.statusText = "  + xhr.statusText );
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

//승인요청 취소후 처리
var fn_afterEduCancel = function(){
    
};

/* 교육상세 열기 */
var fn_eudnInfoOpen = function(tab_page, open_num, edu_type) {
	var splitterId = "";
	var detailPanelId = "";
	var cmMapHtml = "";
	var cmpltStndHtml = "";

	// 상세창 열기
	if(tab_page==1) {
		detailId = "#details1";
		splitterId = "#splitter1";
		detailPanelId  = "#detail_pane1";
	} else if(tab_page==2) {
		detailId = "#details2";
		splitterId = "#splitter2";
		detailPanelId  = "#detail_pane2";
	}
	
	if(open_num!=null) {
		$("#dtl_open_num").val(open_num);
		
		$.ajax({
	        type : "POST",
	        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/select-es-dtl.do?output=json",
	        data : { 
	        	openNum : open_num,
	        	eduTp : edu_type
	        },
	        complete : function( response ){
	            var obj = eval("(" + response.responseText + ")");
	             if(obj.error){
	                 alert("ERROR=>"+obj.error.message);
	             } else {
	            	$(splitterId).data("kendoSplitter").expand(detailPanelId);
	             	
	             	//var dtlCmpnumber = $(detailId+" #dtl_cmpnumber").data("kendoComboBox");
	             	
	             	/* 일반교육 or 상싱학습에 따른 화면 제어 */
	             	
                    //학습역량 초기화.
                    $("#details1 #dtl_cmpnumber").data("kendoComboBox").dataSource.data([]);
                    $("#cmpText").text("");
                    $("#recogText").text("");
                    
             		if(obj.item.EDU_TP == "2") {
             			// 상시학습
             			$(detailPanelId + " dl[edu_tp]").hide();            			
             			$(detailId+" #cancelEduBtn").hide(); // 수강취소 버튼 숨김
             			
             			$("#details1 #attFileDL").hide();
             			
             			//학습역량 세팅
             			if(obj.item.CMPNUMBER){
             				$("#details1 #dtl_cmpnumber").data("kendoComboBox").dataSource.add({ TEXT: obj.item.CMPNAME, VALUE: obj.item.CMPNUMBER});
             			}
                        
             			
                        $(detailId+" #saveCmpnumber").hide();
                        //dtlCmpnumber.placeholder = "";
                        //dtlCmpnumber.enable(false);
             		} else {
             			// 일반교육
             			$(detailPanelId + " dl[edu_tp]").show();
             			
             			if(obj.item.cm_map_list != null) {
             				if(obj.item.cm_map_list.length>0){
			            		$.each(obj.item.cm_map_list, function(i, e) {
			            			cmMapHtml += "<p class=\"bold\">"+e.CMPNM+"</p>";
			            			
			            			//매핑된 역량을 학습역량 목록으로 세팅
		                            $("#details1 #dtl_cmpnumber").data("kendoComboBox").dataSource.add({ TEXT: e.CMPNM, VALUE: e.CMPNUMBER});
			            		});
                            }else{
                            	$("#cmpText").text("※ 해당과정에 매핑된 역량이 존재하지 않습니다. 교육운영자에게 문의해주세요.");
                            }
		            	}else{
		            		$("#cmpText").text("※ 해당과정에 매핑된 역량이 존재하지 않습니다. 교육운영자에게 문의해주세요.");
		            	}
		            	
						if(obj.item.cmplt_stnd_list != null) {
							$.each(obj.item.cmplt_stnd_list, function(i, e) {
								cmpltStndHtml += "<tr><th scope=\"row\">"+e.CMPLT_STND_NM+"</th><td style=\"text-align: center\">"+e.WEI+"</td></tr>";
		            		});
		            	}

		            	// 역량맵핑정보 셋팅
	             		$(detailPanelId+" #cm_map_list").empty();
	             		$(detailPanelId+" #cm_map_list").append(cmMapHtml);
	             		
	             		// 수료기준정보 셋팅
	             		$(detailPanelId+" #cmplt_stnd_list").empty();
	             		$(detailPanelId+" #cmplt_stnd_list").append(cmpltStndHtml);
		            	 
		            	if(obj.item.CANCEL_YN=="Y"){
                            $(detailId+" #cancelEduBtn").show(); // 수강취소 버튼 보임
                        }else{
                        	$(detailId+" #cancelEduBtn").hide(); // 수강취소 버튼 숨김
                        }
		            	
		            	var oid = tud+""+obj.item.OPEN_NUM;
		            	//alert(oid);
		            	$(detailId+" #objectId").val(oid);
		            	
		            	$("#details1 #attFileDL").show();
		            	
		            	//증빙자료 조회.
		            	handleCallbackUploadResult()
		            	
		            	var ver = getInternetExplorerVersion();
		            	//수료처리 전까지는 증빙서류 제출할 수 있음.
                        if(obj.item.ATTEND_STATE_CODE == "1" || obj.item.ATTEND_STATE_CODE == "2"){

                            if( ( ver > -1) && ( ver < 10 ) ){
                                $('#openUploadWindow').removeAttr("disabled");
                            }else{
                                $("#upload-file").data("kendoUpload").enable();
                            }
                            
                            $("#recogText").text("※ 수료처리가 되면 인정시간이 부여됩니다.");
		            	}else{
		            		
		            		if( ( ver > -1) && ( ver < 10 ) ){
                                $('#openUploadWindow').attr("disabled",true);
                            }else{
                                $("#upload-file").data("kendoUpload").disable();
                            }
		            	}

                        $(detailId+" #saveCmpnumber").show();
                        
                        //dtlCmpnumber.enable(true);
             		}
	             	
             		kendo.bind($(detailPanelId).children(), obj.item); // 상세정보 바인딩
                    
	             }
	        },
	        error: function( xhr, ajaxOptions, thrownError){
	           // 로딩바 제거
	           //loadingClose();
	            
	           if(xhr.status==403){
	               alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
	               sessionout();
	           }else{
	               alert("xrs.status = " + xhr.status + "\n" + 
	                       "thrown error = " + thrownError + "\n" +
	                       "xhr.statusText = "  + xhr.statusText );
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
		alert("학습정보가 없습니다.");
	}

	
};

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
			<div class="top_cont mb30">
				<h3 class="tit01">나의 강의실</h3>
				<div class="point">
                    ※ 교육신청 및 등록 현황을 열람할 수 있습니다.
                </div>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>교육훈련&nbsp; &#62;</span>
					<span class="h">나의강의실</span>
				</div><!--//location-->
			</div>
			 <div class="sub_cont tab_sub_cont" style="padding: 0 0 30px 30px;">
				<div  >
				<div id="tabstrip">
					<ul>
						<li class="k-state-active">학습현황</li>
						<li>승진교육이수현황</li>
					</ul>
					<div class="sub_cont tab_sub_cont">
						<div class="result_info">
							<ul>
								<li>
								<label for="p_year"> 년도선택  : </label>
									<div class="demo-section k-header style01" id="p_year">
										<select id="yyyy" style="width: 120px" accesskey="w"></select>
									</div>       
								</li>  
							</ul>
						</div>
						 <div class="state_wrap">
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
									<h5>필수 이수 상세</h5>
									<div class="table_wp02" id="req_task_stt_list" >
										
									</div>
									<p class="point" style="margin: 14px 0 25px;">※ 부처지정학습은 총시간의 40%입니다. </p>
									<h5>기관성과평가 이수 상세</h5>
									<div class="table_wp02" id="pa_task_stt_list" >
										
									</div>
								</dd>
							</dl>
						</div>
						<div class="btn_right">
							<a class="k-button" onclick="fn_excelDownload(1, this)">엑셀다운로드</a>
						</div>
						<div id="splitter1" style="width:100%; height: 545px; border:none;" class="mt10 mb10 ie7_sp">
							<div id="list_pane1">
								<div id="grid1"></div>
							</div>
							<div id="detail_pane1">
								<div id="details1"></div>
							</div>
						</div>
					</div><!--//tab_cont1-->
					<div class="sub_cont tab_sub_cont">
                        <div class="point mt20 f_color1">※ 승진을 위한 교육 이수 실적입니다. </div>
                        <div class="state_wp2">
                            <ul class="ico_plus" style="cursor:default; ">
                                <li class="satisfy_tit2" id="va_task_stt_time">승진 대비 이수 실적 &nbsp;: &nbsp; </li>
                                <li class="satisfy_txt ml150">
                                    <span id="va_task_stt">충족</span> 
                                </li>
                            </ul>
                            <div class="point mt20 f_color1">※ 현 직급 임용일 기준 연간 80 시간 이상 이수해야 함. <br/> ※ 월 기준 15일 이전은 1개월 인정하고 15일 이후면 1개월 인정안 함.   </div>
                            <p class="f_color1" style="margin-left:17px;">즉, 현 직급 임용일이 2012년 12월 14일이고 현재가 2014년 9월 14일이라면 2012년 12월부터 2014년 8월까지의 월수(21개월)가 기준이 되고 21개월/12개월*80=140 시간이 승진을 위한 최고 이수 시간이 됨.(휴직 등 예외 기간에 대한 계산은 안되어 있으므로 , 정확한 시간은 교육운영자에게 문의해주세요.)</p>
                            
                        </div>
                        
						<div class="btn_right" style="margin-top: 5px;">
							<a class="k-button" onclick="fn_excelDownload(2, this)">엑셀다운로드</a>
						</div>
						<div id="splitter2" style="width:1180px; height: 545px; border:none;" class="mt10 mb10">
							<div id="list_pane2">
								<div id="grid2"></div>
							</div>
							<div id="detail_pane2">
								<div id="details2"></div>
							</div>
						</div>
					</div><!--//tab_cont2-->
				</div><!--//tabstrip-->
				</div>
			 </div><!--//sub_cont-->
		 </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->

<script type="text/x-kendo-template" id="template">
	<div id="tabular" class="detail_Info">
		<input type="hidden" id="dtl_open_num" data-bind="value:OPEN_NUM" />
		<input type="hidden" id="dtl_cancel_yn" data-bind="value:CANCEL_YN" />
        <input type="hidden" id="dtl_attend_state_code" data-bind="value:ATTEND_STATE_CODE" />
		<div class="tit">학습상세정보</div>
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
				<dl edu_tp="not_alw">
					<dt>기수</dt>
					<dd><span data-bind="text:CHASU"></span>&nbsp;</dd>
				</dl>
				<dl>
					<dt>교육기간</dt>
					<dd><span data-bind="text:EDU_PERIOD"></span>&nbsp;</dd>
				</dl>
				<dl edu_tp="not_alw">
					<dt>신청기간</dt>
					<dd><span data-bind="text:APPLY_PERIOD"></span>&nbsp;</dd>
				</dl>
				<dl edu_tp="not_alw">
					<dt>취소마감일</dt>
					<dd><span data-bind="text:CANCEL_EDATE"></span>&nbsp;</dd>
				</dl>
                <dl>
                    <dt>수강상태</dt>
                    <dd><span data-bind="text:ATTEND_STATE_NM"></span>&nbsp;</dd>
                </dl>
				<dl edu_tp="not_alw">
					<dt>모집정원</dt>
					<dd><span data-bind="text:APPLICANT"></span>명</dd>
				</dl>
				<dl edu_tp="not_alw">
					<dt>교육일수</dt>
					<dd><span data-bind="text:EDU_DAYS"></span>일</dd>
				</dl>
				<dl>
					<dt>교육시간</dt>
					<dd><span data-bind="text:EDU_HOUR_H"></span>시간 <span data-bind="text:EDU_HOUR_M"></span>분</dd>
				</dl>
				<dl>
					<dt>인정시간</dt>
					<dd><span data-bind="text:RECOG_TIME_H"></span>시간 <span data-bind="text:RECOG_TIME_M"></span>분 <span id="recogText" /></dd>
				</dl>
				<dl edu_tp="not_alw">
					<dt>목적</dt>
					<dd>
						<textarea cols="10" rows="5" class="textarea03" style="width:100%;" readonly="readonly" data-bind="value:EDU_OBJECT"/></textarea>
					</dd>
				</dl>
				<dl edu_tp="not_alw" >
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
					<dt class="noline">상시학습종류</dt>
					<dd class="line"><span data-bind="text:ALW_STD_NM"></span>&nbsp;</dd>
				</dl>
				<dl style="display:none; ">
					<dt>지정학습구분</dt>
					<dd><span data-bind="text:DEPT_DESIGNATION_NM"></span>&nbsp;</dd>
				</dl>
				<dl>
                    <dt>부처지정학습</dt>
                    <dd><span data-bind="text:DEPT_DESIGNATION_YN"></span>&nbsp;</dd>
                </dl>
                <dl>
					<dt>기관성과평가</dt>
					<dd><span data-bind="text:PERF_ASSE_SBJ_NM"></span>&nbsp;</dd>
				</dl>
                <dl>
                    <dt>업무시간구분</dt>
                    <dd><span data-bind="text:OFFICETIME_NM"></span>&nbsp;</dd>
                </dl>
                <dl>
                    <dt>교육기관구분</dt>
                    <dd><span data-bind="text:EDUINS_DIV_NM"></span>&nbsp;</dd>
                </dl>
                <dl>
                    <dt class="noline">교육기관명</dt>
                    <dd class="line"><span data-bind="text:INSTITUTE_NAME"></span>&nbsp;</dd>
                </dl>
				<dl style="display:none; " >
					<dt>필수여부</dt>
					<dd><span data-bind="text:REQUIRED_YN"></span></dd>
				</dl>
				<dl edu_tp="not_alw">
					<dt class="noline">맵핑역량</dt>
					<dd id="cm_map_list" class="line"></dd>
				</dl>
				<dl edu_tp="not_alw">
					<dt class="noline"  >취득점수</dt>
					<dd class="line" >
						<div class="t_wrap">
							<table class="table_type04 ">
								<colgroup>
									<col style="width:190px" />
									<col style="width:190px" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">기준</th>
										<th scope="col">점수</th>
									</tr>
								</thead>
								<tbody id="cmplt_stnd_list">
									
								</tbody>
							</table>
						</div>
					</dd>
				</dl>
                <dl id="attFileDL" >
                    <dt class="noline">증빙자료제출</dt>
                    <dd class="line">
                        <input type="hidden" name="objectId" id="objectId"/>
                        <div id="my-file-upload" class="hide"></div>
                        <div id="my-file-gird"></div><!--증빙자료는 업로드만 하면 됩니다(따로 저장할 필요 없음)-->
                    </dd>
                </dl>
                <dl id="cmpnumberDL" class="mb30">
                    <dt class="noline">학습 역량</dt>
                    <dd class="line">
                        <select id="dtl_cmpnumber" style="width: 300px" accesskey="w" data-bind="value:CMPNUMBER" ></select>
                        <button id="saveCmpnumber" class="k-button k-primary" style="width:88px;">저장</button><br><span id="cmpText" />
                    </dd>
                </dl>
				<div class="btn_top">
					<button id="cancelEduBtn" class="k-button k-primary" style="width:88px;">수강취소</button>
					<button id="closeBtn" class="k-button" style="width:88px;">닫기</button>
				</div>
			</div>
		</div>
	</div>
</script>

    
    <!-- 교육자료 첨부파일 template -->
    <script type="text/x-kendo-tmpl" id="fileupload-template">
        <input name="upload-file" id="upload-file" type="file"/>
    </script>
    
    
<%@ include file="/includes/jsp/user/common/apprStsPopup.jsp"  %>

</body>
</html>