<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
//총괄관리자 권한 여부..
boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
//부서장 권한 여부..
boolean isManager = request.isUserInRole("ROLE_MANAGER");

kr.podosoft.ws.service.common.action.ajax.MainAction action = (kr.podosoft.ws.service.common.action.ajax.MainAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

//현재 년도, 월
Calendar cal = Calendar.getInstance();
int year = cal.get(cal.YEAR);
String menuStr = architecture.ee.web.util.ServletUtils.getServletPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html decorator="homepage" >
<head>
<title>경북대학교</title>

<script type="text/javascript">
var cmptList = []; //역량목록
var myscoreList = []; //내점수
var yyyy = '<%=year%>';
var menuDataSource;

yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.bootstrap.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/jquery.easing.1.3.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/common.js'
           
    ],
    complete: function() {
        kendo.culture("ko-KR"); 
        
        initMenu();
        navigation.scroll();
		//계획대비 실행율
    	var userDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/cdp_plan_state_rate.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return{YYYY : yyyy};
                }
            },
            schema: {
                data: "items1",
                model: {
                    fields: {
                    	EMPNO : { type: "string" },
                    	ID : { type: "string" },
                    	USERID: { type: "string" },
                    	NAME: { type: "string" },
                    	DIVISIONID: { type: "number" },
                    	DVS_NAME: { type: "string" },
                    	DVS_FULLNAME: { type: "string" },
                    	GRADE_NM: { type: "string" },
                    	AVG_RATE: { type: "float" },
                    	YEAR: { type: "number" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
		
    	userDataSource.fetch(function(){
    		var view = userDataSource.view();
   			var str = "<div id='raderchart'></div><p class='btn_more01'><a onClick=cdpPlanDetail()  style=cursor:pointer;>상세보기</a></p><div class=states style=margin-top:-10px; importent!><p class=per><span id=TIME_PER2></span>%</p></div>";
   			var rvr;
   			if(view.length>0 && view){rvr = view[0].R_AVG_RATE;}else{rvr=0;}
   			$("#diagPer").text(rvr);
   			if(rvr>0){
	   			$("#diagArea").append(str);
				$("#TIME_PER2").text(Math.round(rvr));
	    			$("#raderchart").kendoChart({
	    				chartArea: {
	    	                width: 300,
	    	                height: 190
	    	            },
	    	            legend: {
	                        position: "left",
	                        visible: true
	                    },
	                    dataSource: {
	                        data: [{
	    		                "source": "",
	    		                "percentage": Math.round(100-rvr) 
	    		            }, {
	    		                "source": "실행율",
	    		                "percentage": Math.round(rvr) ,
	    		                "explode": true
	    		            }]
	                    },
	                    series: [{
	                        type: "donut",
	                        field: "percentage",
	                        categoryField: "source",
	                        explodeField: "explode"
	                    }],
	                    seriesColors: ["#dddddd", "#42a7ff"],
	                    tooltip: {
	        				visible: true,
	        				format: "{0}",
	        				template: "#= value #%"
	                    }
	    	        });
    		}else{
    			var str ="<div class='no_data' style='display:hidden;padding-top: 0px;height: 205px;margin-left: 20px;'></div><p class='btn_more01'><a></a></p>"; 
    			$("#diagArea").append(str);
    			//$(".no_data").show()
    		}
    	});

		//연간상시학습 이수현황 데이터
		var yearDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/alw-edu-list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return{
                    	YYYY: yyyy
                    };
                }
            },
            schema: {
                data: "items1",
                model: {
                    fields: {
                    	TOT_LABEL : { type: "string" },
                    	TOT_STANDARD_TIME : { type: "string" },
                    	DEPT_STANDARD_LABEL : { type: "string" },
                    	DEPT_STANDARD_TIME : { type: "string" },
                    	ALW_RECOG_TIME : { type: "string" },
                    	DEPT_RECOG_TIME : { type: "string" },
                    	TOT_RECOG_TIME : { type: "string" },
                    	TOT_RATE : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
		//연간상시학습 이수현황
		yearDataSource.fetch(function(){
			var view = yearDataSource.view();
			if(view.length > 0){
				if(view[0].TOT_RATE>0){
					$("#TIME_PER").text(view[0].TOT_RATE);
					$("#DD0_REQ_TIME").text(view[0].TOT_STANDARD_TIME);
					$("#DD0_TAKE_TIME").text(view[0].TOT_RECOG_TIME);
					$("#perValue").val(view[0].TOT_RATE);
					per_img();
				}else{
					$("#TIME_PER").text("0");
					$("#DD0_REQ_TIME").text(view[0].TOT_STANDARD_TIME);
					$("#DD0_TAKE_TIME").text("0");
					$("#perValue").val("0");
					per_img();
				}
			}else{
				$("#TIME_PER").text(0);
				$("#DD0_REQ_TIME").text(0);
				$("#DD0_TAKE_TIME").text(0);
				$("#perValue").val(0);
				per_img();
			}
		//부처지정학습 이수현황 데이터
		var tst;
		var dst;
		var trt;
		var drt;
		var timeData = yearDataSource.view();
		if(timeData && timeData.length>0){
			tst = timeData[0].TOT_STANDARD_TIME;
			dst = timeData[0].DEPT_STANDARD_TIME;
			trt = timeData[0].TOT_RECOG_TIME;
			drt = timeData[0].DEPT_RECOG_TIME;
		}else{
			tst=0;
			dst=0;
			trt=0;
			drt=0;
		}
		//부처지정학습 이수현황 그래프
		$(".bar_graph").kendoChart({
        	chartArea: {
        		width: 280,
                height: 240,
                background: "#6C8697",
            },
            legend: {
	            position : "top",   
	            labels : {
					font: "12px sans-serif",
				}
            },
            seriesDefaults: {
                type: "column",
                spacing:0.5,
                gap:1.5,
                labels: {
                    visible: true,
                    background: "transparent"
                }
            },
            series: [
	             {data:[{
	                "category": "필수시간",
		            "value": tst,
		            "color": "#dddddd"
		        }, {
					"category": "이수시간",
		            "value": dst,
		            "color": "#dddddd"
		        }]}, 
		        {data:[{
					"category": "필수시간",
		            "value": trt,
		            "color": "#42a7ff"
		        }, {
					"category": "이수시간",
		            "value": drt,
		            "color": "#42a7ff"
		        }]}
            ],
            valueAxis: {
                max: 100,
                min: 0,
                minorGridLines: {
                    visible: false
                },
                axisCrossingValue: 0
            },
            categoryAxis: {
            	majorGridLines: {
                    visible: false
                },
                line: {
                    visible: false
                }
            },
            tooltip: {
				visible: true,
				format: "{0}",
				template: "#= value #"
            }
		});
		
	});
		


        
        $("#undo2").click(function(){
            
            if (!$("#window2").data("kendoWindow")) {
                $("#window2").kendoWindow({
                    width: "1060px",
                    title: "경북대학교 인재육성체계",
	                modal: true,
	                visible: false
                });
            }
            $("#window2").data("kendoWindow").center();
            $("#window2").data("kendoWindow").open();
        });
        
		document.getElementsByTagName('body')[0].className = 'js';
        $('.tabMenu .tab a').bind('click focusin',function(){
            $('.tabMenu .wrap').removeClass('on');
            $(this).parent().parent().addClass('on');
        });
        
		//승인요청/처리현황>교육
		var alwEduAppDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/edu-app-data.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return{
                		yyyy: yyyy
                    };
                }
            },
            schema: {
                data: "items2",
                model: {
                    fields: {
                    	CNT : { type: "string" },
                    	REQ_STS_CD : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
		var myEduAppDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/edu-app-data.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return{
                		yyyy: yyyy
                    };
                }
            },
            schema: {
                data: "items1",
                model: {
                    fields: {
                    	CNT : { type: "string" },
                    	REQ_STS_CD : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
		
		alwEduAppDataSource.fetch(function(){
			var view = alwEduAppDataSource.view();
			if(view.length>0){
				//if(view[0].REQ_STS_CD=="1"){
					$("#alwSumCnt").val(view[0].CNT);
					$("#ALW_EDU_CNT").text(view[0].CNT); 
				//}else if(view[0].REQ_STS_CD=="2"){
				//	$("#ALW_EDU_CNT").text(view[0].CNT);
				//}
			}else{
				$("#alwSumCnt").val("0");
				$("#ALW_EDU_CNT").text("0");
			}
		});
		myEduAppDataSource.fetch(function(){
			var view = myEduAppDataSource.view();
			if(view.length>0){
				//if(view[0].REQ_STS_CD=="1"){
					$("#mySumCnt").val(view[0].CNT);
					$("#MY_EDU_CNT").text(view[0].CNT); //나의 교육요청건수 (나의강의실)
					<% if(isSystem){ %>
					$("#RECOMM_EDU_CNT").text(view[0].CMFM_CNT); //추천순위 필요한 과정 수 (교육운영자만)
					<% } %>
					
				//}else if(view[0].REQ_STS_CD=="2"){
				//	$("#MY_EDU_CNT").text(view[0].CNT);
				//}
			}else{
				$("#MY_EDU_CNT").text("0"); //나의 교육요청건수 (나의강의실)
				$("#mySumCnt").val("0");
				<% if(isSystem){ %>
				$("#RECOMM_EDU_CNT").text("0"); //추천순위 필요한 과정 수 (교육운영자만
				<% } %>
			}
		});
		
		//승인요청/처리현황>경력개발계획
		var cdpAppDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/cdp-app-data.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return;
                }
            },
            schema: {
                data: "items1",
                total: "totalItemCount",
                model: {
                    fields: {
                    	CNT : { type: "string" },
                    	REQ_STS_CD : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
		
		cdpAppDataSource.fetch(function(){
			var view = cdpAppDataSource.view();
			if(view.length>0){
				//if(view[0].REQ_STS_CD=="1"){
					$("#CDP_REST_CNT").text(view[0].CNT);
				//}else {
				//	$("#CDP_REST_CNT").text("0");
				//}
			}else{
					$("#CDP_REST_CNT").text("0");
			}	
		});
		
		//승인요청/처리현황>경력개발계획
		var cdpAppCntDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/cdp-app-cnt-data.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return;
                }
            },
            schema: {
                data: "items1",
                total: "totalItemCount",
                model: {
                    fields: {
                    	CNT : { type: "string" },
                    	REQ_STS_CD : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
		
		cdpAppCntDataSource.fetch(function(){
			var view = cdpAppCntDataSource.view();
			if(view.length>0){
				//if(view[0].REQ_STS_CD=="1"){
					$("#CDP_SUM_CNT").text(view[0].CNT);
				//}else{
				//	$("#CDP_SUM_CNT").text(view[0].CNT);
				//}
			}else{
					$("#CDP_SUM_CNT").text("0");
			}	
		});
		
		
		//승인처리현황>교육추천승인
        var eduRecommAppCntDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/edu-recomm-app-cnt-data.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return{
                        yyyy: yyyy
                    };
                }
            },
            schema: {
                data: "items1",
                total: "totalItemCount",
                model: {
                    fields: {
                        CNT : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
        eduRecommAppCntDataSource.fetch(function(){
            var view = eduRecommAppCntDataSource.view();
            if(view.length>0){
                $("#EDU_RECOMM_CNT").text(view[0].CNT);
            }else{
                    $("#EDU_RECOMM_CNT").text("0");
            }   
        });
        
		//승인요청/처리현황>교육승인
		var eduAppCntDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/edu-app-cnt-data.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return{
                        yyyy: yyyy
                    };
                }
            },
            schema: {
                data: "items1",
                total: "totalItemCount",
                model: {
                    fields: {
                    	CNT : { type: "string" },
                    	REQ_STS_CD : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
		eduAppCntDataSource.fetch(function(){
			var view = eduAppCntDataSource.view();
			if(view.length>0){
				//if(view[0].REQ_STS_CD=="1"){
					$("#EDU_CNT").text(view[0].CNT);
				//}else{
				//	$("#EDU_CNT").text(view[0].CNT);
				//}
			}else{
					$("#EDU_CNT").text("0");
			}	
		});
	var dataSource_jobList = new kendo.data.DataSource({
	        type: "json",
	        transport: {
	            read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/job_admin_list.do?output=json", type:"POST" },
	            parameterMap: function (options, operation){
	                return {};
	            }
	        },
	        schema: {
	            data: "items1",
	            model: {
	                fields: {
	                    JOBLDR_NUM : { type: "number" },
	                    JOBLDR_NAME : { type: "String" }
	                }
	            }
	        },
	        serverFiltering: false,
	        serverSorting: false});
	
	dataSource_jobList.fetch(function(){
		var view = dataSource_jobList.view();
		$("#jobList").kendoDropDownList({
	        dataTextField: "JOBLDR_NAME",
	        dataValueField: "JOBLDR_NUM",
	        dataSource: dataSource_jobList,
	        filter: "contains",
	        suggest: true,
	        index: 0,
	        change: function(){
	        	
	        }
	    }).data("kendoDropDownList");
	});
	
	//승인요청/처리현황 교육 처리할건수 SUM
	sum_cnt();
	fn_quickMenu();
	}
}]);
</script>

<script type="text/javascript">

//메인하단 quick_menu 데이터 소스
function fn_quickMenu(){
	menuDataSource = new kendo.data.DataSource({
        type: "json",
        transport: {
            read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/quick-menu-data.do?output=json", type:"POST" },
            parameterMap: function (options, operation){    
                return;
            }
        },
        schema: {
            data: "items1",
            total: "totalItemCount",
            model: {
                fields: {
                	MENU_NUM : { type: "string" },
                	MENU_NM : { type: "string" },
                	LINK_URL : { type: "string" },
                	ICON_PATH : { type: "string" },
                	MENU_POS_NUM : { type: "string" }
                }
            }
        },
        serverFiltering: false,
        serverSorting: false
    });

	
	menuDataSource.fetch(function(){
		var view = menuDataSource.view();
		var url = '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>';
		var html1;
		var html2;

		if(view.length>0){
			for(var i=0;i<view.length; i++){
				if(view[i].MENU_POS_NUM != null &&view[i].MENU_POS_NUM !=""){
					var icon_path = url+view[i].ICON_PATH;
					html1="<a href="+url+view[i].LINK_URL+">";
					html1+="<span class=img><img src="+icon_path+" /></span>";
					html1+="</a>";
					html1+="<span class=tit>"+view[i].MENU_NM+"</span>";
					html1+="<span class=btn_delete onClick=btn_delete("+i+"); style=display:none; ><input type=image src="+url+"/images/main/btn_delete.png alt=삭제/></span>";
					$("#li_0"+i).html(html1);
					$("#MENU_NUM").val(view[i].MENU_NUM+",");
					$("#li_0"+i).attr("onmouseover","btn_delete_show(this)");
					$("#li_0"+i).attr("onmouseleave","btn_delete_hide(this)");
					$("#del_img_0"+i).val("li_0"+i);
				}else{
					html2="<a href=\"javascript:addMenu("+i+")\" >";
					html2+="<span class=\"img\"><img src=\""+url+"/images/main/no_icon.png\" /></span>";       
					html2+="<span class=\"tit\">&nbsp;</span>";
					html2+="<span class=\"btn_delete\">&nbsp;</span>";
					html2+="</a>";
					$("#li_0"+i).html(html2);
					$("#li_0"+i).attr("class","no_img");
				}
			}
		}
	});
}

function selMenu(menuNum){
	var pos_num = $("#menu_pos_num").val();
	var menu_num = menuNum;

	//if(){
		$.ajax({
		       type : 'POST',
		       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/quick-menu-sel.do?output=json",
		       data : { 
		    	   MENU_NUM : menu_num,
		    	   MENU_POS_NUM : pos_num
		       },
		       complete : function( response ){
		    	   var obj = eval("(" + response.responseText + ")");
		            if(obj.error){
		                alert("ERROR=>"+obj.error.message);
		            }else{
		                if(obj.saveCount > 0){
							$("#window_quick").data("kendoWindow").close();
							
							fn_quickMenu();
		                   if(event.preventDefault){
		                       event.preventDefault();
		                   } else {
		                       event.returnValue = false;
		                   }
		                }else{
		                    alert("이미 등록되어있는 메뉴입니다.");
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
		           if(event.preventDefault){
		               event.preventDefault();
		           } else {
		               event.returnValue = false;
		           };
		       },
		       dataType : "json"
		});
}
	
//부서원직무관리 팝업
function job_admin(userId){
	if( !$("#window_job_admin").data("kendoWindow") ){
		$("#window_job_admin").kendoWindow({
			width:"700px",
			height:"400px",
			resizable : true,
			title : "부서원 직무관리",
			modal: true,
			visible: false
		});
	}
	var detailGridColumn = [];
    detailGridColumn.push(
            {
                field : "NAME",
                title : "이름",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }
    );
    detailGridColumn.push(
            {
            	field : "GRADE_NM",
                title : "직급명",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }
    );
    detailGridColumn.push(
            {
                field : "EMPNO",
                title : "교직원번호",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }
    );
    detailGridColumn.push(
            {
            	field : "JOBLDR_NAME",
                title : "현재직무",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }
    );
    detailGridColumn.push(
            {
                title : "",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" },
                template: function(data){
    				return "<button id='changeJob' class='k-button' onclick='changeJob("+data.USERID+","+data.JOB+");'>변경</button>"
				}
            }
    );
    
    $("#jobDetailGrid").empty();
    $("#jobDetailGrid").kendoGrid({
        columns : detailGridColumn,
        filterable : false,
        height : 350,
        sortable : true,
        pageable : false,
        resizable : false,
        reorderable : true,
        selectable: "row"
    });
    
  //상세보기 그리드 데이타 초기화.
    $("#jobDetailGrid").data("kendoGrid").dataSource.data([]);
  	
  	$.ajax({
  		type: 'POST',
  		dataType : 'json',
  		url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/job_admin.do?output=json",
  		data : {
  			userId: <%=action.getUser().getUserId()%>
  		},
  		success : function(response){
  			if(response.items1 != null && response.items1.length > 0){
  				$("#jobDetailGrid").data("kendoGrid").dataSource.data(response.items1);
  			}else{
  				//alert("else \n"+JSON.stringify(response.items));
  				DisplayNoResultsFound($('#jobDetailGrid'));
  			}
  		},
  		error : function(xhr, ajaxOptions, thrownError){
  			if(xhr.status == 403){
  				alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
  				sessionout();
  			}else{
  				alert('xrs.status = ' + xhr.status + '\n' + 
                        'thrown error = ' + thrownError + '\n' +
                        'xhr.statusText = '  + xhr.statusText );
  			}	
  		}
  	});
  	
	$("#window_job_admin").data("kendoWindow").center();
	$("#window_job_admin").data("kendoWindow").open();
}

function DisplayNoResultsFound(grid) {
    // 그리드에서 열 수를 가져온다.
    var dataSource = grid.data("kendoGrid").dataSource;
    var colCount = grid.find('.k-grid-header colgroup > col').length;

    // 결과가 없을 경우 표시 행을 배치한다.
    if (dataSource._view.length == 0) {
        grid.find('.k-grid-content tbody')
            .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" style="text-align:center"><b>검색 데이타가 없습니다.</b></td></tr>');
    }
    /* 
    // 표시되는 행 수를 가져온다.
    var rowCount = grid.find('.k-grid-content tbody tr').length;

    // rows가 적은 경우 페이지 크기는 누락된 행의 수에 추가 
    if (rowCount < dataSource._take) {
        var addRows = dataSource._take - rowCount;
        for (var i = 0; i < addRows; i++) {
            grid.find('.k-grid-content tbody').append('<tr class="kendo-data-row"><td>&nbsp;</td></tr>');
        }
    }*/
}
        
function changeJob(userId,userJob){
	$("#changeUserId").val(userId);	
	$("#changeUserJob").val(userJob);	
	if( !$("#window_jobList").data("kendoWindow") ){
		$("#window_jobList").kendoWindow({
			width:"270px",
			height:"55px",
			resizable : true,
			title : "직무목록",
			modal: true,
			visible: false
		});
		//변경 버튼
	   $("#job_change").click(function(){
	        var jobNum = $("#jobList").data("kendoDropDownList");
	        if(jobNum.value()<0){alert("변경할 직무를 선택하세요.");return false;}
	        var isDel = confirm("직무를 변경 하시겠습니까?");
	        if (isDel) {
	            $.ajax({
	                dataType : "json",
	                type : 'POST',
	                url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/set_job_admin.do?output=json",
	                data : {
	                	setUserJob: jobNum.value(), userId: $("#changeUserId").val(), userJob : $("#changeUserJob").val()
	                },
	                complete : function(response) {
	                    var obj = eval("(" + response.responseText + ")");
	                    if (obj.saveCount > 0) {
	                        alert("변경되었습니다.");
	                        $("#window_jobList").data("kendoWindow").close();
	                        job_admin();
	                      } else {
	                          alert("변경을 실패 하였습니다.");
	                      }
	                    if(obj.error){
	                        alert("ERROR=>"+obj.error.message);
	                    }
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
	                }
	            });
	        }
	    });
	}
	
	$("#jobList").data("kendoDropDownList").value(userJob);
	
	$("#window_jobList").data("kendoWindow").center();
	$("#window_jobList").data("kendoWindow").open();
}


//계획대비 실행율 상세보기
function cdpPlanDetail(userId){
	if( !$("#window_cdpPlan").data("kendoWindow") ){
		$("#window_cdpPlan").kendoWindow({
			width:"600px",
			height:"300px",
			resizable : true,
			title : "역량별 실행율 상세정보 ",
			modal: true,
			visible: false
		});
	}
	var detailGridColumn = [];
	    
	detailGridColumn.push(
	        {
	            field : "CMPNAME",
	            title : "역량",
	            width : "150px",
	            headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
	            attributes : { "class" : "table-cell", style : "text-align:center" }
	        }
	);
	detailGridColumn.push(
	        {
	        	field : "PLAN_TIME",
	            title : "계획시간",
	            width : "100px",
	            headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
	            attributes : { "class" : "table-cell", style : "text-align:center" }
	        }
	);
	detailGridColumn.push(
	        {
	        	field : "RUN_TIME",
	            title : "실적시간",
	            width : "100px",
	            headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
	            attributes : { "class" : "table-cell", style : "text-align:center" }
	        }
	);
	detailGridColumn.push(
	        {
	        	field : "RATE",
	            title : "실행율(%)",
	            width : "120px",
	            headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
	            attributes : { "class" : "table-cell", style : "text-align:center" }
	        }
	);
    
    $("#detailGrid").empty();
    $("#detailGrid").kendoGrid({
        columns : detailGridColumn,
        filterable : false,
        height : 200,
        sortable : true,
        pageable : false,
        resizable : false,
        reorderable : true,
        selectable: "row"
    });
    
  	//상세보기 그리드 데이타 초기화.
    $("#detailGrid").data("kendoGrid").dataSource.data([]);
  	
  	
  	$.ajax({
  		type: 'POST',
  		dataType : 'json',
  		url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_state_rate_detail.do?output=json",
  		data : {
  			YYYY : yyyy, SELECT_USER: <%=action.getUser().getUserId()%>
  		},
  		success : function(response){
  			//alert(JSON.stringify(response.items));
  			
  			if(response.items != null && response.items.length > 0){
  				//alert("if \n"+JSON.stringify(response.items));
  				$("#cdp_year").text(yyyy);
  				$("#detailGrid").data("kendoGrid").dataSource.data(response.items);
  			}else{
  				//alert("else \n"+JSON.stringify(response.items));
  				DisplayNoResultsFound($('#detailGrid'));
  			}
  		},
  		error : function(xhr, ajaxOptions, thrownError){
  			if(xhr.status == 403){
  				alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
  				sessionout();
  			}else{
  				alert('xrs.status = ' + xhr.status + '\n' + 
                        'thrown error = ' + thrownError + '\n' +
                        'xhr.statusText = '  + xhr.statusText );
  			}	
  		}
  	});
	$("#window_cdpPlan").data("kendoWindow").center();
	$("#window_cdpPlan").data("kendoWindow").open();
}

function addMenu(i){
	if( !$("#window_quick").data("kendoWindow") ){
		$("#window_quick").kendoWindow({
			width:"1060px",
			height:"604px",
			resizable : true,
			title : "메뉴 추가",
			modal: true,
			visible: false
		});
	}
	$("#window_quick").data("kendoWindow").center();
	$("#window_quick").data("kendoWindow").open();
	$("#menu_pos_num").val(i+1);
}

//메뉴삭제
function btn_delete(i){
	var MENU_POS_NUM= i+1;
	var isDel = confirm("메뉴를 삭제 하시겠습니까?");
	if(isDel){
		$.ajax({
		       type : 'POST',
		       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/quick-menu-del.do?output=json",
		       data : { 
		    	   MENU_POS_NUM : MENU_POS_NUM
		       },
		       complete : function( response ){
		           var obj = eval("(" + response.responseText + ")");
		            if(obj.error){
		                alert("ERROR=>"+obj.error.message);
		            }else{
		                if(obj.saveCount > 0){
		                		alert("삭제가 완료되었습니다.");
		                		fn_quickMenu();
		                   if(event.preventDefault){
		                       event.preventDefault();
		                   } else {
		                       event.returnValue = false;
		                   }
		                }else{
		                    alert("삭제에 실패 하였습니다.");
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
		           if(event.preventDefault){
		               event.preventDefault();
		           } else {
		               event.returnValue = false;
		           };
		       },
		       dataType : "json"
		   });
	}
}
function btn_delete_show(obj){
	$(obj).find(".btn_delete").show();
}
function btn_delete_hide(obj){
	$(obj).find(".btn_delete").hide();
}
function sum_cnt(){
	var myCnt = $("#mySumCnt").val();
	var alwCnt = $("#alwSumCnt").val();
	var sumCnt = eval(myCnt)+eval(alwCnt);
}

function per_img(){
	var perValue = $("#perValue").val();
	var url = '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>';
	var per_img = "<img src="+url+"/images/main/"+perValue+"p.png />";
	$(".per_img").append(per_img);
}

function fn_changeEduMng(mod){
		 if( !$("#pop05").data("kendoWindow") ){
           $("#pop05").kendoWindow({
               width:"800px",
               height:"550px",
               resizable : true,
               title : "교육담당자 변경 요청",
               modal: true,
               visible: false
           });
        }
		
		fn_eduChangeReq();
		
        $("#pop05").data("kendoWindow").center();
        $("#pop05").data("kendoWindow").open();
}

function fn_eduChangeReq(){
	
	$("#chEduReq").kendoGrid({
    	dataSource: {
             type: "json",
             transport: {
                 read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/edu_change_list.do?output=json", type:"POST" },
                 parameterMap: function (options, operation){
                	  return { REQ_DIV_CD : 1 };
                 }
             },
             schema: {
             	total : "totalItemCount",
                  data: "items1",
                  model: {
                 	 fields : {
                 			USERID : {
                                type : "number",
                                editable : false
                            },
                            GRADE_NUM: {
                                type : "string",
                                editable : false
                            },
                            DIVISIONID : {
                                type : "string",
                                editable : false
                            },
                            USEFLAG : {
                                type : "string",
                                editable : false
                            },
                            
                        }
                  }
             },
             pageSize : 30,
             serverPaging : false,
             serverFiltering : false,
             serverSorting : false
         },
         columns : [
					{
                        field : "ROWNUMBER",
                        title : "순번",
                        width : 50,
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
                        field : "NOW_NAME",
                        title : "현재교육운영자",
                        width : 70,
                        headerAttributes : {
                            "class" : "table-header-cell",
                            style : "text-align:center"
                        },
                        attributes : {
                            "class" : "table-cell",
                            style : "text-align:center"
                        },
                    },
                    {
                        field : "DVS_FULLNAME",
                        title : "담당부서",
                        width : 120,
                        headerAttributes : {
                            "class" : "table-header-cell",
                            style : "text-align:center"
                        },
                        attributes : {
                            "class" : "table-cell",
                            style : "text-align:center"
                        },
                    },
                    {
                        field : "CHANGE_NAME",
                        title : "변경할 교육담당자",
                        width : 75,
                        headerAttributes : {
                            "class" : "table-header-cell",
                            style : "text-align:center"
                        },
                        attributes : {
                            "class" : "table-cell",
                            style : "text-align:center"
                        },
                    },
                    {
						field : "",
						title : "선택",
						filterable : false,
						sortable : false,
						width : 130,
						headerAttributes : {
						    "class" : "table-header-cell",
						    style : "text-align:center"
						},
						attributes : {
						    "class" : "table-cell",
						    style : "text-align:center"
						},
					    template : "<button id='changeApp_${USERID}' class='k-button' onclick='eduInsertApp(\"${USERID}\",\"${REQ_DIV_CD}\",\"${REQ_USERID}\");'>승인</button> <button  id='chCencleApp_${USERID}' class='k-button' onclick='eduDeleteApp(\"${USERID}\",\"${REQ_USERID}\");'>취소</button>"
                    },
                  ],
                filterable: false,
              	height: 200,
              	sortable : false,
	            pageable : false,
	            resizable : true,
	            reorderable : true
     	});
}
</script>

<script type="text/javascript">
	var initMenu = function() {
		
		var tabMenu = $("#tabMenu ul>li>a");   
		var tabSubMenu = $("#tabSubMenu>div");
	
	    // 모든 서브메뉴 안보이게  
	    tabSubMenu.hide();    
	
	    // 탭메뉴 a 를 클릭했을때   
	    tabMenu.on("click", function(e){     
	        // 클릭한 메뉴가 몇번째 메뉴인지 가져옴  
	        var idx = tabMenu.index($(this));         
	        
	        // 모든 서브메뉴 안보이게        
	            tabSubMenu.hide();        
	            // 서브메뉴중에서 클릭한 메뉴에 해당하는 서브메뉴만 보이게
	            tabSubMenu.eq(idx).show();        
	            
	            // 현재 on 이미지를 off 이미지로 변경     
	            tabMenu.find("img.on").removeClass("on").toggle();     
	            // 클릭한 탭 이미지만 on 이미지로 변경     
	            $(this).find("img").addClass("on").toggle({to:"on"});    
	    });     
	    
	    $.fn.toggle = function(opt){       
	        var base = {    
	             to : null,           
	             on : "_on.png",           
	             off : ".png"      
	            };     
	        $.extend(base, opt);     
	        
	        this.each(function(){           
	            var el = $(this);          
	
	            if(!el.is("img")) return;                  
	            
	            var src = conv = el.attr("src");                      
	            // to 옵션이 있을때       
	            if( base.to ){                
	                if( base.to=="on" && (src.indexOf(base.on)<0) ) conv = src.replace(base.off,base.on);           
	                else if( base.to=="off" ) conv = src.replace(base.on,base.off);     
	                }           
	            // to 옵션이 없으면 토글 처리          
	                else{               
	                    conv = (src.indexOf(base.on) < 0) ? src.replace(base.off,base.on) : src.replace(base.on,base.off);            
	                    }        
	                el.attr("src", conv);            
	                el.data("orgimg", conv);        
	            });                 
	        return this;    
	        };    
	        // 페이지 로딩시 맨 첫번째 메뉴 튀어나와 있게 함.    
	        tabMenu.eq(0).click();
	         /*마우스 오버시에도 적용되게 할때
	    tabMenu.on("click", function(e){    
	        var idx = tabMenu.index($(this));   
	         
	            tabSubMenu.hide();    
	            tabSubMenu.eq(idx).show();    
	
	            tabMenu.find("img.on").removeClass("on").toggle();   
	            $(this).find("img").addClass("on").toggle({to:"on"});
	        }).on("mouseover", function(){   
	            // 마우스 오버됬을때 클릭한것처럼 동작   
	            $(this).click();
	        });*/
	};
</script>

	<style>
			 #window_emp{padding:30px !important;}
			 .k-window-title {font-size:13px !important;}
			 .k-pager-wrap>.k-link {padding : 0px 0}
			 .k-picker-wrap .k-select, .k-numeric-wrap .k-select, .k-dropdown-wrap .k-select {padding-top : 0px}
	</style>
</head>
<body>
<form id="frm" name="frm"  method="post" >
	<input type="hidden" name="perValue" id="perValue"/>
	<input type="hidden" name="mySumCnt" id="mySumCnt"/>
	<input type="hidden" name="alwSumCnt" id="alwSumCnt"/>
	<input type="hidden" name="JOB" id="JOB"/>
	<input type="hidden" name="LEADERSHIP" id="LEADERSHIP"/>
	<input type="hidden" name="RUN_NUM" id="RUN_NUM"/>
	<input type="hidden" name="MENU_NUM" id="MENU_NUM"/>
	<input type="hidden" id="menu_pos_num" name="menu_pos_num"/>
	<input type="hidden" id="change_userId" name="change_userId"/>
	<input type="hidden" id="insert_userId" name="insert_userId"/>
	<input type="hidden" id="divisionId" name="divisionId"/>
	<input type="hidden" id="userId" name="userId"/>
	<input type="hidden" id="changeUserId" name="changeUserId"/>
	<input type="hidden" id="changeUserJob" name="changeUserJob"/>
</form>

<div class="wrap">
	<div id="header_wrap">
		<div class="header">
			<div class="gnb">
                <% if(isSystem){ %>
                	<div class="admin" ><a href="<%=architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_operator_main.do" class="topadmin">ADMIN</a> 
                		<div style="display:inline-block;margin-left:5px;cursor:pointer;" onClick="fn_changeEduMng()" ></div>
                	</div>
                <% }else if(isManager){ %>
                	<div class="admin"><a href="javascript:job_admin()" class="topadmin">부서원 직무관리</a></div>
                <% } %>
                <h1><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/main.do">
                	<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/top/top_logo.gif" style="height:40px;" alt="경북대학교"/>
                </a></h1>
                <ul class="top_link">
                    <li class="mr15"><strong><%=action.getUser().getName()%></strong>님 안녕하세요!</li>
                    <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/main.do" class="tophome">HOME</a></li>
                    <li class="last"><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/logout" class="toplogin">LOGOUT</a></li>
                  </ul>
            </div><!--//gnb-->
			<div class="nav-area">
				<div class="nav">
                    <h2 class="blind">상단메뉴</h2>
                    <ul>
                        <li class="m01 <% if(menuStr.indexOf("/service/cam/cmpt_evl_run_pg")>-1){ out.println("on"); } %>"><a href="javascript:void(0); ">역량진단</a>
                            <ul class="sub-nav">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_run_pg.do">역량진단</a></li>
                            </ul>
                        </li>
                        <% if(isSystem || isManager){ %>
                        <li><a href="javascript:void(0); ">역량진단결과</a>
                            <ul class="sub-nav">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/assm_exct_sts_pg.do">진단실시현황</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/division_exec_sts_pg.do">소속별응답현황</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/job_exec_sts_pg.do">직무별응답현황</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/cmpt_job_leadership_sco_pg.do">역량별직무/계급점수</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/cmpt_user_sco_list_pg.do">역량별점수</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/cmpt_user_total_sco_list_pg.do">종합진단결과</a></li>
                            </ul>
                        </li>
                        <% } %>
                        <li><a href="javascript:void(0);">경력개발계획</a>
                             <ul class="sub-nav">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_run_list_pg.do">계획수립</a></li>
                                <% if(isSystem || isManager){ %>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_state_list_pg.do">계획수립현황</a></li>
                                <% } %>
                            </ul>
                         </li>
                        <li><a href="javascript:void(0);">교육훈련</a>
                             <ul class="sub-nav">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/my-class-main.do">나의강의실</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emapply/sbjct-apply-main.do">교육신청</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/main.do">상시학습</a></li>
                                <% if(isSystem){ %>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/my-class-admin-main.do">상시학습관리</a></li>
                                <%} %>
                              </ul>
                         </li>
                        <% if(isSystem || isManager){ %>
                        <li><a href="javascript:void(0);">교육훈련결과</a>
                            <ul class="sub-nav">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/ba-edu-result-main.do">부서원교육현황</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/ba-alw-edu-result-main.do">부서원상시학습달성현황</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/ptmtn-edu-rslt-main.do">승진기준달성현황</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_state_rate_list_pg.do">계획대비실행율</a></li>
                            </ul>
                         </li>
                        <%} %>
                        <li><a href="javascript:void(0);">게시판</a>
                             <ul class="sub-nav ">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_notice_main.do">공지사항</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_qna_main.do">질문과답변</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_edu_info_main.do">교육안내</a></li>
                             </ul>
                        </li>
                        <li><a href="javascript:void(0);">승인하기</a>
                             <ul class="sub-nav last_line">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_approval_list_pg.do">경력개발계획승인</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/ba-edu-appr-main.do">교육승인</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/ba-edu-recomm-appr-main.do">교육추천승인(인사)</a></li>
                             </ul>
                        </li>
                    </ul>
                </div><!--//nav-->
			</div><!--//nav-area-->
		</div><!--//header-->
		<div class="sub_nav_bg"></div>
	</div><!--//header_wrap-->
	<div class="container">
		<div id="contents">
			<div class="main_cont">
				<ul class ="main_top">
					<li class="col01 fir">
						<h3>계획대비 실행율</h3>
							<div  id="diagArea" >

							</div>
					</li>
					<li class="col01">
						<h3>연간상시학습 이수현황</h3>
						<div class="states">
							<p class="per_img">
							</p>
							<p class="per"><span id="TIME_PER"></span>%</p>
							<p class="des"><span id="DD0_REQ_TIME"></span>시간중 <span id="DD0_TAKE_TIME"></span>시간이수</p>
						</div>
						<p class="btn_more01"><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/my-class-main.do">나의강의실</a></p>
					</li>
					<li class="col02"><h3>부처지정학습 이수현황</h3>
						<p class='btn_more02'><a>필수시간</a><b>이수시간</b></p>
						<div class="bar_graph" style="margin:0 0 0 20px;">
						</div>
					</li>
					<li class="col03">
						<h3>승인 요청/처리 현황</h3>
						<div class="table_wp">
							<table class="state">
								<caption>승인요청/처리현황</caption>
								<colgroup>
									<col style="width: 106px"/>
									<col style="width: 90px"/>
									<col style="width: 87px"/>
								</colgroup>
								<thead>
									<tr>
										<th class="bg"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/bg_table.gif" alt="" /></th>
										<th>요청건수</th>
										<th>처리할건수</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th rowspan="2">교육</th>
										<td>
											<p class="go">
												<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/my-class-main.do"><span id="MY_EDU_CNT"></span> 건 <br/>나의강의실</a>
											</p>
										</td>
										<td >
											<p class="go">
												<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/ba-edu-appr-main.do"  >
												<span id="EDU_CNT"></span> 건 <br/>교육승인</a>
											</p>
										</td>
									</tr>
									<tr>	
										<td>
											<p class="go">
												<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/main.do"><span id="ALW_EDU_CNT"></span> 건 <br/>상시학습</a>
											</p>
										</td>
										<td >
                                            <p class="go">
                                                <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/ba-edu-recomm-appr-main.do"  >
                                                <span id="EDU_RECOMM_CNT"></span> 건 <br/>교육추천승인<br>(인사)</a>
                                            </p>
                                        </td>
									</tr>
									<% if(isSystem){ %>
									<tr style="height:40px;">
									<% }else{ %>
									<tr style="height:60px;">
									<% } %>
										<th>경력개발계획</th>
										<td>
											<p class="go">
												<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_run_list_pg.do"><span id="CDP_SUM_CNT"></span> 건 <br/>계획수립</a>
											</p>
										</td>
										<td>
											<p class="go">
												<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_approval_list_pg.do"><span id="CDP_REST_CNT"></span> 건 <br/>계획승인</a>
											</p>
										</td>
									</tr>
									<% if(isSystem){ %>
									<tr style="height:30px;">
                                        <th>추천순위필요과정</th>
                                        <td colspan="2">
                                            <p class="go">
                                                <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/ba-cource-open-run-main.do"><span id="RECOMM_EDU_CNT"></span> 건 (운영관리)</a>
                                            </p>
                                        </td>
                                    </tr>
                                    <% } %>
								</tbody>
							</table>
						</div>
					</li>
				</ul><!--//main_top-->
				<div class="main_btm">
					<div class="quick_menu">
						<ul>
							<li id=li_00>
							</li>
							<li id=li_01>
							</li>
							<li id=li_02>
							</li>
							<li id=li_03>
							</li>
							<li id=li_04>
							</li>
							<li id=li_05>
							</li>
							<li id=li_06>
							</li>
							<li id=li_07>
							</li>
						</ul>
					</div><!--//quick_menu-->
					<div class="bgArea" style="width:320px;height:298px;"> 
					   <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/bg_main.jpg" width="320" height="231" alt="경북대학교 이미지" />
					   <p style="position:absolute;bottom:10px;left:100px;">
                            <a href="javascript:void(0); "><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/btn_go.png"  id="undo2" style="" alt="경북대학교 인재육성체계 바로가기" />
                                <style>
                                   #window2.k-window-content{padding:20px 30px 30px 30px !important;min-height:680px !important;}
                                   #window2.k-window-title {font-size:13px !important;}
                                </style>
                            </a>
                       </p>
					</div><!--//bgArea-->
				</div><!--//main_btm-->
			</div><!--//main_cont-->
		</div><!--//contents--->
	</div><!--//container-->
	<div id="footerWrap">
		<div class="footer">
				<div class="foot_txt">
					<address>702-701 대구광역시 북구 대학로 80 경북대학교</address>
					<p>Copyright(c) 2015 Kyungpook National University. All rights reserved.</p>
				</div>
		</div>
	</div>
</div><!--//wrap-->
<style>
#raderchart {padding-left: 15px;}
#p.per {position:absolut;padding-bottom: 10px;}
#TIME_PER2 {padding-left: 80px;}
</style>
	<!--팝업 코딩 시작-->
	
	<div id="window_quick" style="display:none;">
		<div class="menu_add">
			<ul>
				<li>
					<div class="rline">
						<em>[역량진단]</em>
						<a href="javascript:selMenu(1)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/1.png" /></span>
								<span class="stit">역량진단</span>
							</span>
						</a>
					</div>
				</li>
				<% if(isSystem || isManager){ %>
				<li>
					<div>
						<em>[역량진단 결과]</em>
						<a href="javascript:selMenu(2)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/2.png" /></span>
								<span class="stit">진단실시현황</span>
							</span>
						</a>
					</div>
				</li>
				<li>
					<div>
						<em>&nbsp;</em>
						<a href="javascript:selMenu(3)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/3.png" /></span>
								<span class="stit">소속별응답현황</span>
							</span>
						</a>
					</div>
				</li>
				<li>
					<div>
						<em>&nbsp;</em>
						<a href="javascript:selMenu(4)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/4.png" /></span>
								<span class="stit">직무별응답현황</span>
							</span>
						</a>
					</div>
				</li>
				<li>
					<div>
						<em>&nbsp;</em>
						<a href="javascript:selMenu(5)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/5.png" /></span>
								<span class="stit">역량별직무/계급점수</span>
							</span>
						</a>
					</div>
				</li>
				<li>
					<div>
						<em>&nbsp;</em>
						<a href="javascript:selMenu(6)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/6.png" /></span>
								<span class="stit">역량별점수</span>
							</span>
						</a>
					</div>
				</li>
				<li>
					<div class="rline">
						<em>&nbsp;</em>
						<a href="javascript:selMenu(7)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/7.png" /></span>
								<span class="stit">종합진단결과</span>
							</span>
						</a>
					</div>
				</li>
				<%} %>
				<li>
					<div class=" last">
						<em>[경력개발계획]</em>
						<a href="javascript:selMenu(8)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/8.png" /></span>
								<span class="stit">계획수립</span>
							</span>
						</a>
					</div>
				</li>
				<% if(isSystem || isManager){ %>
				<li>
					<div class="rline">
						<em>&nbsp;</em>
						<a href="javascript:selMenu(9)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/9.png" /></span>
								<span class="stit">계획수립현황</span>
							</span>
						</a>
					</div>
				</li>
				<%} %>
				<li>
					<div>
						<em>[교육훈련]</em>
						<a href="javascript:selMenu(10)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/10.png" /></span>
								<span class="stit">나의강의실</span>
							</span>
						</a>
					</div>
				</li>
				<li>
					<div>
						<em>&nbsp;</em>
						<a href="javascript:selMenu(11)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/11.png" /></span>
								<span class="stit">교육신청</span>
							</span>
						</a>
					</div>
				</li>
				<li>
					<div class="rline">
						<em>&nbsp;</em>
						<a href="javascript:selMenu(12)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/12.png" /></span>
								<span class="stit">상시학습</span>
							</span>
						</a>
					</div>
				</li>
				<% if(isSystem){ %>
				<li>
					<div class="rline">
						<em>&nbsp;</em>
						<a href="javascript:selMenu(13)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/13.png" /></span>
								<span class="stit">상시학습관리</span>
							</span>
						</a>
					</div>
				</li>
				<%} %>
				<% if(isSystem || isManager){ %>
				<li>
					<div>
						<em>[교육훈련결과]</em>
						<a href="javascript:selMenu(14)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/14.png" /></span>
								<span class="stit">부서원교육현황</span>
							</span>
						</a>
					</div>
				</li>
				<li>
					<em>&nbsp;</em>
					<a href="javascript:selMenu(15)">
						<span class="des">
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/15.png" /></span>
							<span class="stit">부서원상시학습달성현황</span>
						</span>
					</a>
				</li>
				<li>
					<em>&nbsp;</em>
					<a href="javascript:selMenu(16)">
						<span class="des">
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/16.png" /></span>
							<span class="stit">승진기준달성현황</span>
						</span>
					</a>
				</li>
				<li>
					<div class="rline">
						<em>&nbsp;</em>
						<a href="javascript:selMenu(17)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/17.png" /></span>
								<span class="stit">계획대비 실행율</span>
							</span>
						</a>
					</div>
				</li>
				<%} %>
				<li class="noline">
					<div >
						<em>[게시판]</em>
						<a href="javascript:selMenu(18)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/18.png" /></span>
								<span class="stit">공지사항</span>
							</span>
						</a>
					</div>
				</li>
				<li class="noline">
					<div>
						<em>&nbsp;</em>
						<a href="javascript:selMenu(19)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/19.png" /></span>
								<span class="stit">질문과답변</span>
							</span>
						</a>
					</div>
				</li>
				<li class="noline">
					<div class="rline">
						<em>&nbsp;</em>
						<a href="javascript:selMenu(20)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/20.png" /></span>
								<span class="stit">교육안내</span>
							</span>
						</a>
					</div>
				</li>
				<li class="noline">
					<div>
						<em>[승인하기]</em>
						<a href="javascript:selMenu(21)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/21.png" /></span>
								<span class="stit">경력개발계획승인</span>
							</span>
						</a>
					</div>
				</li>
				<li class="noline">
					<div>
						<em>&nbsp;</em>
						<a href="javascript:selMenu(23)">
							<span class="des">
								<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/23.png" /></span>
								<span class="stit">교육승인</span>
							</span>
						</a>
					</div>
				</li>
			</ul>
		</div><!--//menu_add-->
	</div>

	<div id="window_cdpPlan" style="display:none">
			<div class="tit"></div>
			<div>
				<div style="margin:10px 10px; font-weight:bold; color:black">
				▶  <span id="cdp_year"></span>&nbsp;년도 실행율(%)  
				</div>
				
				<div id="detailGrid" style="overflow-y:auto; margin:10px 10px;" ></div>
				
				<div style="margin:10px 10px">
				</div>
			</div>
	</div>
	
	<div id="window_job_admin" style="display:none">
			<div class="tit"></div>
			<div>
				<div id="jobDetailGrid" style="overflow-y:auto; margin:10px 10px;" ></div>
				<div style="margin:10px 10px">
				</div>
			</div>
	</div>
	<div id="window_jobList" style="display:none">
		<select id="jobList"></select>&nbsp;
		<button id="job_change" class="k-button">확인</button>
	</div>
	<!--//팝업코딩끝-->
	
    <div id="window2"  style="display:none">
        <div class="tabMenu">
            <div class="wrap on">
                <div class="tab"><a href="javascript:void(0);">인재육성체계도</a></div>
                <div class="cnt">
                    <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/tab_cont01.jpg" alt="" />
                </div>
            </div>
            <div class="wrap">
                <div class="tab"><a href="javascript:void(0);">新 인재상</a></div>
                <div class="cnt">
                    <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/tab_cont02.jpg" alt="" />
                </div>
            </div>
            <div class="wrap">
                <div class="tab"><a href="javascript:void(0);">역량</a></div>
                <div class="cnt">
                    <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/tab_cont03.jpg" alt="" />
                </div>
            </div>
        </div>
    </div><!--//window2 -->
<!--20150422 팝업 내용 수정 시작-->
    <style> 
    .js .tabMenu{position:relative;}
    .js .tabMenu .wrap{float: left;}
    .js .tabMenu .tab{float:left;margin-right:5px;position: relative;z-index:2;}
    .js .tabMenu .tab a{width: 200px;height: 31px;background: #dcdcdc;font-weight:bold;color:#555555;display: block;text-align: center;text-decoration: none;padding-top:9px;}
    .js .tabMenu .cnt{width: 998px;position: absolute;left:0;top:50px;z-index:1;background: #fff;display:none;}
    .js .tabMenu .wrap.on .tab a{height:31px;padding-top:9px;background: #4685d3;color:#fff;font-weight:bold;}
    .js .tabMenu .wrap.on .cnt{display:block;}
    </style>
<!--//20150422 팝업 끝-->

</body>
</html>