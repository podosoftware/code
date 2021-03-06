<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}
%>
<html decorator="subpage">
<head>
<title></title>
<style>
.k-grid-content { height: 417px; }

</style>
<%

kr.podosoft.ws.service.ca.action.ajax.CAServiceAction action = (kr.podosoft.ws.service.ca.action.ajax.CAServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();


%>
<script type="text/javascript">	

var runNum = "<%=request.getParameter("RUN_NUM")%>";
var tgUserid = "<%=request.getParameter("TG_USERID")%>";
var job = "<%=request.getParameter("JOB")%>";
var leadership = "<%=request.getParameter("LEADERSHIP")%>";
var uName = "<%=action.getUser().getName()%>";
var cmptDataSource; //역량평가 점수
var growCmptDataSource; //평가 역량목록
var growDataSource; //역량성장도 분석데이터.

var cmptList = []; //역량목록
var myscoreList = []; //내점수
var ascoreList = []; //전사
var lscoreList = []; //동일계층
var jscoreList = []; //동일직급

var seriesList = []; //차트 라인 series
var chartAttributeList = {
    labels: null,
    field: "",
    name: ""
}

/*
 레이더 차트를 위해서 추가되어야하는
*/

yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.<%=theme%>.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
    ],
	complete: function() {
		kendo.culture("ko-KR"); 
		
		//평가기본정보
		var evlDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"/deptmgr/ca/dept_cmpt_evl_run_info.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {
                        RUN_NUM: runNum,
                        TG_USERID: tgUserid
                    };
                }
            },
            schema: {
                data: "items",
                total: "totalItemCount",
                model: {
                    fields: {
                    	YYYY : { type: "int" },
                    	RUN_NUM : { type: "int" },
                    	RUN_NAME : { type: "string" },
                    	RUN_START : { type: "string" },
                    	RUN_END : { type: "string" },
                    	CMPT_EVL_CMPL_DATE : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
		//역량평가기본정보 fetch 시..
		evlDataSource.fetch(function(){
			var view = evlDataSource.view();
			if(view.length>0){
				$("#evl_YYYY").text(view[0].YYYY);
				$("#evl_RUN_NAME").text(view[0].RUN_NAME);
				$("#evl_RUN_START").text(view[0].RUN_START);
				$("#evl_RUN_END").text(view[0].RUN_END);
				$("#evl_CMPT_EVL_CMPL_DATE").text(view[0].CMPT_EVL_CMPL_DATE);
				
                $("#rst_evl_run_name").text(view[0].RUN_NAME);
			}
		});

        //피평가자 정보
        var exedUserDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"/deptmgr/ca/dept_cmpt_evl_user_exed_info.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {
                        TG_USERID: tgUserid
                    };
                }
            },
            schema: {
                data: "items1",
                model: {
                    fields: {
                        LEADERSHIP_NM : { type: "string" },
                        NAME : { type: "string" },
                        EMPNO : { type: "string" },
                        DVS_NAME : { type: "string" },
                        JOB_NM : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
        //피평가자 정보 fetch 시..
        exedUserDataSource.fetch(function(){
            var view = exedUserDataSource.view();
            if(view.length>0){
                var strVal = "";
                if(view[0].NAME!=null){
                    strVal = view[0].NAME;
                    //$("#rst_tg_name").text(view[0].NAME);
                }
                if(view[0].EMPNO!=null){
                    strVal = strVal+" / "+view[0].EMPNO;
                }
                if(view[0].JOB_NM!=null){
                    strVal = strVal+" / "+view[0].JOB_NM;
                }
                if(view[0].LEADERSHIP_NM!=null){
                    strVal = strVal+" / "+view[0].LEADERSHIP_NM;
                }
                $("#evlUserExed").text(strVal);
            }
        });
        
        //평가역량목록 
        growCmptDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"/deptmgr/ca/dept_cmpt_evl_analysis_cmpt_grow_list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {
                        TG_USERID: tgUserid
                    };
                }
            },
            schema: {
                data: "items",
                model: {
                    fields: {
                        CMPNUMBER : { type: "int" },
                        CMPNAME : { type: "string" },
                        RNUM : { type: "int" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
        //평가역량목록 fetch 시..
        growCmptDataSource.fetch(function(){
            var view = growCmptDataSource.view();
            if(view.length>0){
                //역량성장도 데이터 조회
                growDataSource = new kendo.data.DataSource({
                    type: "json",
                    transport: {
                        read: { url:"/deptmgr/ca/dept_cmpt_evl_analysis_cmpt_grow_analysis.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){    
                            return {
                                TG_USERID: tgUserid
                            };
                        }
                    },
                    schema: {
                        data: "items"
                    },
                    serverFiltering: false,
                    serverSorting: false
                });
                
                
                growDataSource.fetch(function(){
                    var cmptview = growCmptDataSource.view();
                    var view = growDataSource.view();
                    //alert(view.length);
                    
                    var plusC = "";
                    var minusC = "";
                    var pcnt = 0;
                    var mcnt = 0;
                    for(var i=0; i<cmptview.length; i++){
                        chartAttributeList = new Array();
                        chartAttributeList.field        = "SCORE_B" + i;
                        chartAttributeList.name     = cmptview[i].CMPNAME;
                        chartAttributeList.type     = "line";
                        
                        seriesList.push(chartAttributeList);
                        
                        //+성장 , -성장 역량 조회.
                        var tmp = "SCORE_B"+i;
                        
                        if(view[view.length-1].get(tmp) - view[view.length-2].get(tmp) < 0){
                        	if(mcnt==0){
                        		minusC = ""+cmptview[i].CMPNAME+"";
                        	}else{
                        		minusC = minusC + ", " +cmptview[i].CMPNAME+"";
                        	}
                        	mcnt++;
                        }else if(view[view.length-1].get(tmp) - view[view.length-2].get(tmp) > 0){
                        	if(pcnt==0){
                        		plusC = ""+cmptview[i].CMPNAME+"";
                            }else{
                            	plusC = plusC + ", " +cmptview[i].CMPNAME+"";
                            }
                        	pcnt++;
                        }
                    }
                    
                    
                    $("#barchart").kendoChart({
                        chartArea: {
                            width: 1060,
                            height: 470
                        },
                        dataSource : growDataSource,
                        legend: {
                         position : "left",   
                         labels : {
                             //font: "15px sans-serif"
                         }
                        },
                        seriesDefaults: {
                            type: "column"  //bar, column
                        },
                        series : seriesList,
                        valueAxis: {
                            max: 100,
                            min: 0,
                            line: {
                                visible: false
                            },
                            minorGridLines: {
                                visible: false
                            },
                            axisCrossingValue: 0
                        },
                        categoryAxis: {
                            field: "RUN_NAME",
                            majorGridLines: {
                                visible: false
                            },
                            line: {
                                visible: true
                            },
                            labels:{
                                rotation: -10
                            }
                        },
                        tooltip: {
                            visible: true,
                            template: "#= series.name #: #= value #"
                        }
                    });
                    
                    
                    //평가 설명 문구 세팅
                    //$("#b_run_name").text(view[view.length-2].RUN_NAME);
                    //$("#n_run_name").text(view[view.length-1].RUN_NAME);
                    
                    if(plusC != "" || minusC != ""){
                    	if(plusC!=""){
                            plusC = plusC + " ";
                        }else{
                            plusC = " - ";
                        }

                        if(minusC!=""){
                            minusC = minusC + " ";
                        }else{
                            minusC = " - ";
                        }
                    }else{
                    	plusC = " - ";
                    }
                    
                    
                    $("#plus_cmpt").text(plusC);
                    $("#minus_cmpt").text(minusC);
                });
            }
        });
        
        
        $("#listBtn").click(function(){
        	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_exed_pg.do";
        	document.frm.submit();
        });
	}
}]);       
    

//탭별 화면전환..
function goPage(pageNum) {
    if(pageNum==1){
    	//역량별분석
    	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_analysis_cmpt.do";
    }else if(pageNum==2){
    	//역량성장도
    	
    }else if(pageNum==3){
    	//추천교육
    	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_analysis_cm_edu.do";
    }else if(pageNum==4){
    	//코멘트
    	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_analysis_user_cmt.do";
    }
    document.frm.submit();
}

</script>

</head>
<body>
	<form id="frm" name="frm"  method="post" >
	    <input type="hidden" name="RUN_NUM" id="RUN_NUM" value="<%=request.getParameter("RUN_NUM")%>"/>
	    <input type="hidden" name="TG_USERID" id="TG_USERID" value="<%=request.getParameter("TG_USERID")%>"/>
	    <input type="hidden" name="JOB" id="JOB" value="<%=request.getParameter("JOB")%>" />
	    <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" value="<%=request.getParameter("LEADERSHIP")%>"/>
	    
	</form>
	<div id="content">
		<div class="cont_body">
			<div class="title">부서원 역량 평가 분석</div>
            <div class="table_tin">
                <ul>
                    <li class="line">평가 년도 : <span id="evl_YYYY"></span>년
                    <li>평가 기간 : <span id="evl_RUN_START"></span> ~ <span id="evl_RUN_END"></span></li>
                </ul>
                <ul>
                    <li class="line">피 평가자 : <b><span id="evlUserExed"></span></b></li>
                    <li></li>
                </ul>
            </div>
            <div class="tab_menu">
                <ul>
                    <li class="line"><a href="javascript:void();" onclick="goPage(1); return false;"class="tab01">역량별 분석</a></li>
                    <li class="on">역량성장도</li>
                    <li><a href="javascript:void();" onclick="goPage(3); return false;" class="tab01">추천 교육</a></li>
                    <li><a href="javascript:void();" onclick="goPage(4); return false;"class="tab01">코멘트</a></li>
                </ul>
            </div>
            <div class="tab_box">
                이전 평가결과와 최근 평가결과를 비교하여 각 역량의 성장도를 확인하시기 바랍니다. 제시된 역량과 관련된 교육훈련을 받거나 성장을 위한 별도의 노력을 했음에도 역량의 성장이 없다면 원인을 파악한 뒤 해결책을 고민하실 필요가 있습니다.<br><br> 
                <span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 역량 성장도 높은 역량: <u><span id="plus_cmpt"></span></u><br>
                <span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 역량 성장도 낮은 역량: <u><span id="minus_cmpt"></span></u>
                <!-- 
                <span id="rst_tg_name"></span>님은 <span id="b_run_name"></span> 대비 <span id="n_run_name"></span> 에서<br><span id="plus_cmpt"></span><span id="minus_cmpt"></span>
                 -->
            </div>
            
            <div id="graph_list">
                <!-- 바차트 -->
                <div id="barchart" style="width:100%;"></div>
                
            </div>

            <div align="right" style="width:100%; height: 40px;">
                <button id="listBtn" class="k-button"  style="position:relative; top:25%;">목록</button>
            </div>
		</div>
		<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/>
	</div>
</body>
</html>