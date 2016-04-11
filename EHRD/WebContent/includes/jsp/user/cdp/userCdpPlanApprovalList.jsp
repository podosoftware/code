<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
kr.podosoft.ws.service.cdp.action.CdpServiceAction action = (kr.podosoft.ws.service.cdp.action.CdpServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
%>
<html decorator="subpage"   >
<head>
<title></title>

<script type="text/javascript"> 

yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'           
    ],
    complete: function() {
        kendo.culture("ko-KR"); 
        
        
      	//로딩바 선언..
        //loadingDefine();
        
        //경력개발계획 년도 데이터소스
        var dataSource_yyyy = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_run_yyyy_list_cdp.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {};
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            YYYY : { type: "number" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
        dataSource_yyyy.fetch(function(){
        	yyyy.select(0); 
        	runListFilter();
        });
        
        //경력개발계획 실시목록 데이터소스
        var dataSource_runlist = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_run_history_list_cdp.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {};
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            YYYY : { type: "number" },
                            RUN_NUM : { type: "number" }, 
                            RUN_NAME : { type: "string" }, 
                            PERIOD_FLAG  : { type: "string" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
        dataSource_runlist.fetch(function(){
        	runListFilter();
        });      
        
        
        //진단이력 필터링
        var runListFilter = function(){
        	//년도와 이력 모두 존재하면 filtering
        	if(dataSource_yyyy!=null && dataSource_yyyy.data().length>0 && dataSource_runlist!=null && dataSource_runlist.data().length>0){
        		var tmpYear = 0;
        		if(yyyy.value()==null || yyyy.value()==undefined || yyyy.value() == ""){
        			tmpYear = dataSource_yyyy.data()[0].YYYY;
        		}else{
        			tmpYear = yyyy.value();
        		}
        		dataSource_runlist.filter({
                    "field":"YYYY",
                    "operator":"eq",
                    "value": Number(tmpYear)
                });

        		//console.log('==========================='+yyyy.value());
                //console.log(dataSource_runlist.view().length+'===========================');
        		gridRead();
        	}
        };
        
        
        //진단년도
        var yyyy = $("#yyyy").kendoDropDownList({
                 dataTextField: "YYYY_TEXT",
                 dataValueField: "YYYY",
                 dataSource: dataSource_yyyy,
                 filter: "contains",
                 suggest: true,
                 change: function(){
                	 runListFilter();
                 }
             }).data("kendoDropDownList");
        

        //진단목록
        var runList = $("#runList").kendoDropDownList({
                 dataTextField: "RUN_NAME",
                 dataValueField: "RUN_NUM",
                 dataSource: dataSource_runlist,
                 filter: "contains",
                 suggest: true,
                 change: function(){
                	 gridRead();
                 }
             }).data("kendoDropDownList");
        
        var gridRead = function(){
        	grid.dataSource.read();
        };
        
        
        //$("#grid").empty();
        var grid = $("#grid").kendoGrid({
               dataSource: {
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_approval_list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){ 
                            return { runNum: runList.value() };
                        }
                    },
                    schema: {
                        total: "totalItemCount",
                        data: "items",
                           model: {
                               fields: {
                                   RUN_NUM  : { type: "int" },
                                   RUN_NAME : {type:"string"},
                                   REQ_NUM : { type : "int" },
                                   REQ_USERID : {type:"int"},
                                   REQ_NAME : {type:"string"},
                                   EMPNO : { type:"string" },
                                   DVS_NAME : { type:"string"},
                                   DVS_FULLNAME : { type:"string"},
                                   GRADE_NM : { type:"string"},
                                   REQ_STS_CD_NAME : { type:"string"},
                                   POPUP_FLAG : { type:"string"},
                                   REQ_LINE_SEQ : {type:"int"}
                               }
                           }
                    },
                    pageSize: 20,
                    serverPaging: false,
                    serverFiltering: false,
                    serverSorting: false
                },
                height: 550,
                selectable: "multiple", // 한줄 선택 / 셀선택 multiple cell
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
                /*pageable : {
                    refresh : false,
                    pageSizes : false,
                    messages : {
                        display : ' {1} / {2}'
                    }
                },*/
                pageable: {
                    //refresh: true,
                    pageSizes: true,
                    buttonCount: 5
                },
                //columnMenu: true,
                columns: [
                    {
                        field:"DVS_NAME",
                        title: "부서명",
                        width: 200,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    {
                        field:"DVS_FULLNAME",
                        title: "전체부서명",
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"}
                    },
                    {
                        field:"REQ_NAME",
                        title: "요청자",
                        width: 150,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center; text-decoration: underline;"},
                        template:function(data){
                        	if(data.POPUP_FLAG!=null && data.POPUP_FLAG!="" && data.POPUP_FLAG =="POPUP_Y"){
                        		return "<a href=\"javascript:void(0);\" onclick=\"javascript: fn_cdpApprOpen("+data.RUN_NUM+", "+data.REQ_USERID+", "+data.REQ_NUM+", "+data.REQ_LINE_SEQ+", "+data.REQ_STS_CD+")\" >"+data.REQ_NAME+"</a>";
                        	}else{
                        		return "<a href=\"javascript:void(0);\" onclick=\"javascript: alert('이전 결재자가 아직 승인대기중입니다.'); \" >"+data.REQ_NAME+"</a>";
                        	}
                        	
                        }                        
                    },
                    {
                        field:"EMPNO",
                        title: "교직원번호",
                        width: 100,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field:"GRADE_NM",
                        title: "직급",
                        width: 150,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        field:"REQ_STS_CD_NAME",
                        title: "승인현황",
                        width: 150,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    }          
                ]
            }).data("kendoGrid");
        
    }
    
}]);


function fn_cdpApprOpen(runNum, reqUserid, reqNum, req_lineSeq, reqStsCd){
	cdpApprOpen(runNum, reqUserid, reqNum, req_lineSeq, reqStsCd);
	reqApprCompleteCallbackFunc = fn_afterReqCancel;
}

//사용자별 역량진단 분석화면 이동
function fn_diagnoAnaly(runNum, useridExed, job, leadership) {
    $("#RUN_NUM").val(runNum);
    $("#TG_USERID").val(useridExed);
    $("#JOB").val(job);
    $("#LEADERSHIP").val(leadership);
    
    document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/car_analysis_cmpt.do"
    document.frm.submit();
}

function fn_apprOpen(reqNum){
	
	//승인현황 팝업 호출.
	apprStsOpen(1, reqNum);
	//승인취소 처리 후 callback 함수 정의
	reqCancelCompleteCallbackFunc = fn_afterReqCancel;
}

//승인요청 취소후 처리
function fn_afterReqCancel(){
	//그리드 내용 refresh.
	
	$("#grid").data("kendoGrid").dataSource.read();
	
}

function fn_planExec(runNum, yyyy){
	$("#rn").val(runNum);
    $("#year").val(yyyy);

    document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/user_cdp_exec_pg.do"
    document.frm.submit();
}

//엑셀다운로드
function excelDownload(button){
    //if($("#runList").val()==null || $("#runList").val()==""){
    //   alert("엑셀다운로드 클릭");
    //   return false;
   //}
   button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_approval_list_excel.do?RUN_NUM="+$("#runList").val()+"&RUN_NAME="+ $("#runList").data("kendoDropDownList").text();
}



</script>
    <style scoped>
    .demo-section {width:120px;}
    .demo-section2 {    width:250px;}
    </style>    
         
    </head>
<body>
    <form id="frm" name="frm"  method="post" >
        <input type="hidden" name="rn" id="rn" />
        <input type="hidden" name="tu" id="tu" value="<%=action.getUser().getUserId()%>" />
        <input type="hidden" name="year" id="year" />
    </form>
    
	<div class="container">
		<div id="cont_body">
		 <div class="content">
			<div class="top_cont">
				<h3 class="tit01">경력개발계획승인</h3>
				<div class="point">
					※ 나에게 올라온 경력개발수립 요청 현황을 열람하고 승인을 해줍니다. <br/> ※ 요청자 이름 클릭 시 경력개발계획의 상세 내용을 열람할 수 있습니다.
				</div>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>승인하기&nbsp; &#62;</span>
					<span class="h">계획승인</span>
				</div><!--//location-->
			</div>
			 <div class="sub_cont">
				<div class="result_info">
					<ul>
						<li>
						<label for="p_year">계획선택  : </label>
							<div class="demo-section k-header style01" id="p_year">
								<select id="yyyy" style="width: 120px" ></select>
							</div>
							 <style scoped>
								.demo-section.style01 {width:120px;}
								.k-input {padding-left:5px;}
							</style>          
						</li>  
						<li>
							<label for="p_name " class="blind">평가명 : </label>
							<div class="demo-section k-header style02" id="p_name">
								<select id="runList"  style="width: 250px" ></select>
							</div>
							 <style scoped>
								.demo-section.style02 {width:250px;}
								.k-input {padding-left:5px;}
							</style>    
						</li>
					</ul>
					<div class="btn">
						<a class="k-button"  onclick="excelDownload(this)" >엑셀 다운로드</a>
					</div>
				</div><!--//result_info-->
				<div id="grid" class="mt15"></div>

			 </div><!--//sub_cont-->
		 </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->

<%@ include file="/includes/jsp/user/common/apprStsPopup.jsp"  %>
<%@ include file="/includes/jsp/user/cdp/userCdpApprPopup.jsp"  %>

</body>
</html>