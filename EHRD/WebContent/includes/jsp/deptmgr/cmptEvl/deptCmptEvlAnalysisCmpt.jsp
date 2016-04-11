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
var cmptDataSource;

var cmptList = []; //역량목록
var myscoreList = []; //내점수
var ascoreList = []; //전사
var lscoreList = []; //동일계층
var jscoreList = []; //동일계층

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
				//$("#evl_CMPT_EVL_CMPL_DATE").text(view[0].CMPT_EVL_CMPL_DATE);
				
                $("#rst_evl_run_name").text(view[0].RUN_NAME);
                $("#rst_evl_score").text(view[0].EVL_TOTAL_SCORE);
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
                	$("#rst_tg_name").text(view[0].NAME);
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
        
		//역량분석데이터소스
		cmptDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"/deptmgr/ca/dept_cmpt_evl_cmpt_analysis.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {
                    	RUN_NUM: runNum,
                    	TG_USERID: tgUserid,
                    	JOB: job,
                    	LEADERSHIP: leadership
                    };
                }
            },
            schema: {
                data: "items",
                total: "totalItemCount",
                model: {
                    fields: {
                    	COMPANYID : { type: "int" },
                    	CMPNUMBER : { type: "int" },
                    	CMPNAME : { type: "String" },
                    	SCORE : { type: "int" },
                    	SCORE_A : { type: "int" },
                    	SCORE_J : { type: "int" },
                    	SCORE_L : { type: "int" },
                    	RANK_R : { type: "int" },
                    	RANK_A : { type: "int" },
                    	GAP_A : { type: "int" },
                    	RANK_J : { type: "int" },
                    	GAP_J : { type: "int" },
                    	RANK_L : { type: "int" },
                    	GAP_L : { type: "int" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
        //역량별 분석 정보 fetch 시..
        cmptDataSource.fetch(function(){
        	
        	var view = cmptDataSource.view();
            if(view.length>0){
            	//$("#rst_tg_name").text(uName);
            	
            	//상대적 부족역량 1,2,3
            	var weak1="", weak2="", weak3="", weak4="", weak5="";
            	//전사 대비 부족역량 1,2,3
            	var a_weak1="", a_weak2="", a_weak3="";
            	//동일직무 대비 부족역량 1,2,3
            	var j_weak1="", j_weak2="", j_weak3="";
            	//동일계층 대비 부족역량 1,2,3
            	var l_weak1="", l_weak2="", l_weak3="";

                //순위별 역량갯수
                var wcnt1 = 0, wcnt2 = 0, wcnt3 = 0, wcnt4 = 0, wcnt5 = 0;
            	for(var i=0; i<view.length; i++){
            		var item = view[i];
            		
                    //상대적 부족역량 1,2,3,4,5
                    //역량 결과 갯수에 따라서 부족역량 제시 갯수 다르게 처리함..
                    //진단역량 1개   1개 역량만 진단하셔서 부족역량을 제시할 수 없습니다' 결과 제시
                    //진단역량 2~3개   가장 낮은 역량 1개 제시
                    //진단역량 4~6개   가장 낮은 역량 2개 제시
                    //진단역량 7~10개  가장 낮은 역량 3개 제시
                    //진단역량 11~15개 가장 낮은 역량 4개 제시
                    //진단역량 16개 이상 가장 낮은 역량 5개 제시

                    if(item.RANK_R == "1"){
                           if(weak1==""){
                               weak1 = item.CMPNAME;
                           }else{
                               weak1 = weak1 + ", " + item.CMPNAME;
                           }
                           wcnt1 = wcnt1 + 1;
                       }
                    if(item.RANK_R == "2"){
                           if(weak2==""){
                               weak2 = item.CMPNAME;
                           }else{
                               weak2 = weak2 + ", " + item.CMPNAME;
                           }
                           wcnt2 = wcnt2 + 1;
                       }
                    if(item.RANK_R == "3"){
                           if(weak3==""){
                               weak3 = item.CMPNAME;
                           }else{
                               weak3 = weak3 + ", " + item.CMPNAME;
                           }
                           wcnt3 = wcnt3 + 1;
                       }
                    if(item.RANK_R == "4"){
                           if(weak4==""){
                               weak4 = item.CMPNAME;
                           }else{
                               weak4 = weak4 + ", " + item.CMPNAME;
                           }
                           wcnt4 = wcnt4 + 1;
                       }
                    if(item.RANK_R == "5"){
                           if(weak5==""){
                               weak5 = item.CMPNAME;
                           }else{
                               weak5 = weak5 + ", " + item.CMPNAME;
                           }
                           wcnt5 = wcnt5 + 1;
                   }
                    
            		//전사 대비 부족역량 1,2,3
            		if(item.RANK_A == "1") a_weak1 = item.CMPNAME;
                    if(item.RANK_A == "2") a_weak2 = item.CMPNAME;
                    if(item.RANK_A == "3") a_weak3 = item.CMPNAME;

                    //동일직무 대비 부족역량 1,2,3
                    if(item.RANK_J == "1") j_weak1 = item.CMPNAME;
                    if(item.RANK_J == "2") j_weak2 = item.CMPNAME;
                    if(item.RANK_J == "3") j_weak3 = item.CMPNAME;

                    //동일계층 대비 부족역량 1,2,3
                    if(item.RANK_L == "1") l_weak1 = item.CMPNAME;
                    if(item.RANK_L == "2") l_weak2 = item.CMPNAME;
                    if(item.RANK_L == "3") l_weak3 = item.CMPNAME;
                    
                    //레이더 차트 데이터 세팅..
                    cmptList.push(item.CMPNAME);
                    myscoreList.push(item.SCORE);
                    ascoreList.push(item.SCORE_A);
                    lscoreList.push(item.SCORE_L);
                    jscoreList.push(item.SCORE_J);
            	}
            	
            	//상대적 부족역량 세팅
            	var r_weak = "";
            	if(view.length <= 1){
                    r_weak = "1개 역량만 진단하셔서 부족역량을 제시할 수 없습니다";
                }else if(view.length <= 3){
                    if(wcnt1==3){
                        r_weak = "진단하신 역량은 모두 같은 수준입니다";
                    }else if(wcnt1==2){
                        r_weak = "진단하신 역량의 반 이상이 같은 수준으로 도출되어 부족역량을 제시할 수 없습니다";
                    }else{
                        if(weak1!="") r_weak = r_weak + ""+weak1+"";
                    }
                }else if(view.length <= 6){
                    if(wcnt1==view.length){
                        r_weak = "진단하신 역량은 모두 같은 수준입니다";
                    }else if(wcnt1>=view.length/2){
                        r_weak = "진단하신 역량의 반 이상이 같은 수준으로 도출되어 부족역량을 제시할 수 없습니다";
                    }else{
                        if(wcnt1+wcnt2 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                            if(weak2!="") r_weak = r_weak + ", " + weak2 + "";
                        }else if(wcnt1 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                        }
                    }
                }else if(view.length <= 10){
                    if(wcnt1==view.length){
                        r_weak = "진단하신 역량은 모두 같은 수준입니다";
                    }else if(wcnt1>=view.length/2){
                        r_weak = "진단하신 역량의 반 이상이 같은 수준으로 도출되어 부족역량을 제시할 수 없습니다";
                    }else{
                        if(wcnt1+wcnt2+wcnt3 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                            if(weak2!="") r_weak = r_weak + ", " + weak2 + "";
                            if(weak3!="") r_weak = r_weak + ", " + weak3 + "";
                        }else if(wcnt1+wcnt2 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                            if(weak2!="") r_weak = r_weak + ", " + weak2 + "";
                        }else if(wcnt1 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                        }
                    }
                }else if(view.length <= 15){
                    if(wcnt1==view.length){
                        r_weak = "진단하신 역량은 모두 같은 수준입니다";
                    }else if(wcnt1>=view.length/2){
                        r_weak = "진단하신 역량의 반 이상이 같은 수준으로 도출되어 부족역량을 제시할 수 없습니다";
                    }else{
                        if(wcnt1+wcnt2+wcnt3+wcnt4 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                            if(weak2!="") r_weak = r_weak + ", " + weak2 + "";
                            if(weak3!="") r_weak = r_weak + ", " + weak3 + "";
                            if(weak4!="") r_weak = r_weak + ", " + weak4 + "";
                        }else if(wcnt1+wcnt2+wcnt3 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                            if(weak2!="") r_weak = r_weak + ", " + weak2 + "";
                            if(weak3!="") r_weak = r_weak + ", " + weak3 + "";
                        }else if(wcnt1+wcnt2 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                            if(weak2!="") r_weak = r_weak + ", " + weak2 + "";
                        }else if(wcnt1 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                        }
                    }
                }else{
                    if(wcnt1==view.length){
                        r_weak = "진단하신 역량은 모두 같은 수준입니다";
                    }else if(wcnt1>=view.length/2){
                        r_weak = "진단하신 역량의 반 이상이 같은 수준으로 도출되어 부족역량을 제시할 수 없습니다";
                    }else{
                        if(wcnt1+wcnt2+wcnt3+wcnt4+wcnt5 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                            if(weak2!="") r_weak = r_weak + ", " + weak2 + "";
                            if(weak3!="") r_weak = r_weak + ", " + weak3 + "";
                            if(weak4!="") r_weak = r_weak + ", " + weak4 + "";
                            if(weak5!="") r_weak = r_weak + ", " + weak5 + "";
                        }else if(wcnt1+wcnt2+wcnt3+wcnt4 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                            if(weak2!="") r_weak = r_weak + ", " + weak2 + "";
                            if(weak3!="") r_weak = r_weak + ", " + weak3 + "";
                            if(weak4!="") r_weak = r_weak + ", " + weak4 + "";
                        }else if(wcnt1+wcnt2+wcnt3 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                            if(weak2!="") r_weak = r_weak + ", " + weak2 + "";
                            if(weak3!="") r_weak = r_weak + ", " + weak3 + "";
                        }else if(wcnt1+wcnt2 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                            if(weak2!="") r_weak = r_weak + ", " + weak2 + "";
                        }else if(wcnt1 < view.length/2){
                            if(weak1!="") r_weak = r_weak + ""+weak1+"";
                        }
                    }
                }
            	//if(weak1!="") r_weak = r_weak + ""+weak1+"";
            	//if(weak2!="") r_weak = r_weak + ", " + "" + weak2 + "";
            	//if(weak3!="") r_weak = r_weak + ", " + "" + weak3 + "";
            	$("#r_weak_cmpt").text( r_weak + "");

                //전사 대비 부족역량 세팅
                var a_weak = "";
                if(a_weak1!=""){
                	a_weak = ""+a_weak1+"";
                	if(a_weak2!="") a_weak = a_weak + ", " + "" + a_weak2 + "";
                    if(a_weak3!="") a_weak = a_weak + ", " + "" + a_weak3 + "";
                    a_weak = a_weak + " ";
                }else{
                	a_weak = " - ";
                }
                $("#a_weak_cmpt").text( a_weak );

                //동일 직무 대비 부족역량 세팅
                var j_weak = "";
                if(j_weak1!=""){
                    j_weak = ""+j_weak1+"";
                    if(j_weak2!="") j_weak = j_weak + ", " + "" + j_weak2 + "";
                    if(j_weak3!="") j_weak = j_weak + ", " + "" + j_weak3 + "";
                    j_weak = j_weak + " ";
                }else{
                    j_weak = "- ";
                }
                $("#j_weak_cmpt").text( j_weak );

                //동일 계층 대비 부족역량 세팅
                var l_weak = "";
                if(l_weak1!=""){
                    l_weak = ""+l_weak1+"";
                    if(l_weak2!="") l_weak = l_weak + ", " + "" + l_weak2 + "";
                    if(l_weak3!="") l_weak = l_weak + ", " + "" + l_weak3 + "";
                    l_weak = l_weak + " ";
                }else{
                    l_weak = " - ";
                }
                $("#l_weak_cmpt").text( l_weak );
            }else{
            	//역량평가 - 역량별 분석 결과 데이터가 존재 하지 않음...
            	alert("역량평가 분석결과가  존재하지 않습니다.");
            }
            
            
        });
		
        //grid 세팅
        $("#grid").empty();
        $("#grid").kendoGrid({
            dataSource: cmptDataSource,
            columns: [
                {
                    field:"CMPNAME",
                    title: "역량",
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}
                },
                {
                    field:"SCORE_L",
                    title: "동일계층",
                    width: 150,
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                {
                    field:"SCORE_J",
                    title: "동일직무",
                    width: 150,
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                {
                    field:"SCORE_A",
                    title: "전사",
                    width: 150,
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                {
                	field:"SCORE",
                    title: "내점수(전사대비)",
                    width:150,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"},
                    template: function (dataItem) {
                        //return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.COMPANYID+");' >"+dataItem.COMPANYNAME+"</a>"
                        return dataItem.SCORE+" ( "+dataItem.GAP_A+" )";
                    } 
                }
            ],
            pageable: false,//{ refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
            filterable: false,
            sortable: true,
            height: 449
        });
        
        
        $("#raderchart").kendoChart({
        	theme:"bootstrap",
            chartArea: {
                width: 1060,
                height: 440
            },
            dataSource : cmptDataSource,
            legend: {
                position: "left"
            },
            seriesDefaults: {
                type: "radarArea"
            },
            series: [{
                name: "내점수",
                data: myscoreList//,
                //color : "blue"
            }, {
                name: "전사",
                data: ascoreList//,
                //color : "yellow"
            }, {
                name: "동일계층",
                data: lscoreList
            }, {
                name: "동일직무",
                data: jscoreList
            } ],
            categoryAxis: {
                categories: cmptList,
                majorGridLines: {
                    visible: false
                }
            },
            valueAxis: {
            	max: 100,
                labels: {
                    format: "{0}"
                },
                line: {
                    visible: false
                }
            }
        });
        
        
        $("#barchart").kendoChart({
        	theme:"bootstrap",
            chartArea: {
        		width: 1060,
                height: 440
            },
            dataSource : cmptDataSource,
            legend: {
             position : "top",   
             labels : {
                 font: "15px sans-serif"
             }
            },
            seriesDefaults: {
                type: "column"  //bar, column
            },
            series : [  
                      {
                          labels: {
                              visible: true,
                              background: "white"
                          },
                          field: "SCORE",
                          name: "내점수"//,
                          //color : "blue"
                      },
                      {
                          labels: {
                              visible: true,
                              background: "white"
                          },
                          field: "SCORE_A",
                          name: "전사"//,
                          //color : "yellow"
                      },
                      {
                          labels: {
                              visible: true,
                              background: "white"//,                                    
                              //template: "#= series.name #: #= value #"
                          },
                          field: "SCORE_L",
                          name: "동일계층"
                      }, 
                      {
                          labels: {
                              visible: true,
                              background: "white"
                          },
                          field: "SCORE_J",
                          name: "동일직무"
                      }
              ],
            valueAxis: {
                max: 100,
                line: {
                    visible: false
                },
                minorGridLines: {
                    visible: false
                },
                axisCrossingValue: 0
            },
            categoryAxis: {
                field: "CMPNAME",
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
        
        $("#listBtn").click(function(){
        	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_exed_pg.do";
        	document.frm.submit();
        });
        
        //역량평가 결과 출력
        $("#printBtn").click(function(){
            window.open('<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_print.do?RUN_NUM='+$("#RUN_NUM").val()+'&TG_USERID='+$("#TG_USERID").val()+'&JOB='+$("#JOB").val()+'&LEADERSHIP='+$("#LEADERSHIP").val(), '', 'scrollbars=yes, width=740, height=500');
        });
	}
}]);       
    

//탭별 화면전환..
function goPage(pageNum) {
    if(pageNum==1){
    	//역량별분석
    	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_analysis_cmpt.do";
    	document.frm.submit();
    }else if(pageNum==2){
    	//역량성장도
    	$.ajax({
            type : 'POST',
            url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_grow_list_cnt.do?output=json",
            data : { TG_USERID : $("#TG_USERID").val() },
            complete : function( response ){
                var obj  = eval("(" + response.responseText + ")");
                if(obj.totalItemCount < 2){
                    alert("평가를 한번 밖에 받지 않아 역량 성장도를 제시할 수 없습니다. 한번 더 평가 받으시면 이전 평가결과와 비교하여 성장도 확인이 가능합니다.");
                    return false;
                }else{
                	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_analysis_cmpt_grow.do";
                    document.frm.submit();
                }                           
            },
            error: function( xhr, ajaxOptions, thrownError){
            	alert('xrs.status = ' + xhr.status + '\n' + 
                        'thrown error = ' + thrownError + '\n' +
                        'xhr.statusText = '  + xhr.statusText + '\n' );
            },
            dataType : "json"
        });
    }else if(pageNum==3){
    	//추천교육
    	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_analysis_cm_edu.do";
    	document.frm.submit();
    }else if(pageNum==4){
    	//코멘트
    	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_analysis_user_cmt.do";
    	document.frm.submit();
    }
    
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
                    <li class="line on">역량별 분석</li>
                    <li><a href="javascript:void();" onclick="goPage(2); return false;"class="tab01">역량성장도</a></li>
                    <li><a href="javascript:void();" onclick="goPage(3); return false;" class="tab01">추천 교육</a></li>
                    <li><a href="javascript:void();" onclick="goPage(4); return false;"class="tab01">코멘트</a></li>
                </ul>
            </div>
            <div class="tab_box">
                <u><span id="rst_tg_name" ></span></u>님의 <u><span id="rst_evl_run_name"></span></u> 결과 최종점수는 <u><span id="rst_evl_score"></span>점</u> 입니다. 진단자가 보유한 각 역량의 수준을 비교하여 강약점으로 나타난 역량을 우선 확인하시기 바랍니다.  그리고 각 역량을 전사, 동일 계층, 동일 직무 직원들의 평균 수준과 각각 비교해 보시기 바랍니다. 진단자 본인의 다른 역량과 비교에서 강점으로 나타난 역량일지라도 다른 직원과의 상대적 비교에서는 약점으로 나타날 수 있습니다.<br><br>  
                <span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 진단자 역량수준 비교결과 부족 역량: <u><span id="r_weak_cmpt"></span></u><br>
                <span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 전사 직원대비 부족 역량: <u><span id="a_weak_cmpt"></span></u><br>
                <span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 동일 계층 직원대비 부족역량: <u><span id="l_weak_cmpt"></span></u><br>
                <span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 동일 직무 직원대비 부족역량: <u><span id="j_weak_cmpt"></span></u>
                <!-- 
                <span id="rst_tg_name"></span>님의 <span id="rst_evl_run_name"></span> 결과 <span>상대적으로</span> <span id="r_weak_cmpt"></span> 이, <span>전사 대비</span>  <span id="a_weak_cmpt"></span>, <span>동일 직무 대비</span> <span id="j_weak_cmpt"></span> 마지막으로 <span>동일 계층 대비</span> <span id="l_weak_cmpt"></span>
                 --> 
            </div>
            
            <div id="graph_list">
                <ul id="graph_tab">
                    <li><a href="#graph1" class="tab"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_re.gif" alt="레이더차트" /></a>
                        <div id="graph1" class="line">
                            <!-- 레이더차트 -->
                            <table style="width:1060px;" >
                                <tr>
                                    <td>
                                    <div id="raderchart" style="width:100%;"></div>
                                    </td>
                                </tr>
                            </table>
                            
                        </div>
                    </li>
                    <li><a href="#graph2" class="tab"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_ba.gif" alt="바차트" /></a>
                        <div id="graph2" class="line">
                            <!-- 바차트 -->
                            <div id="barchart" style="width:100%;"></div>
                        </div>
                    </li>
                    <li><a href="#graph3" class="tab"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_te.gif" alt="테이블차트" /></a>
                        <div id="graph3" class="line" >
                            <!-- 테이블차트 -->
                             <div id="grid" style="width:100%;"></div>
                        </div>
                    </li>
                </ul>
                <script type="text/javascript">
                    initTabMenu("graph_tab");
                    document.getElementById("graph_tab").style.display="block";
                    
                    function initTabMenu(tabContainerID) {
                        var tabContainer = document.getElementById(tabContainerID);
                        var tabAnchor = tabContainer.getElementsByTagName("a");
                        var i = 0;

                        for(i=0; i<tabAnchor.length; i++) {
                            if (tabAnchor.item(i).className == "tab") {
                                var thismenu = tabAnchor.item(i);
                            } else {
                                continue;
                            }

                            thismenu.container = tabContainer;
                            thismenu.targetEl = document.getElementById(tabAnchor.item(i).href.split("#")[1]);
                            thismenu.targetEl.style.display = "none";
                            thismenu.imgEl = thismenu.getElementsByTagName("img").item(0);
                            if (thismenu.imgEl) {
                                thismenu.onfocus = function () {
                                    this.onclick();
                                }
                            }
                            thismenu.onclick = tabMenuClick;

                            if (!thismenu.container.first) {
                                thismenu.container.first = thismenu;
                            }
                        }

                        tabContainer.first.onclick();
                    }

                    function tabMenuClick() {
                        var currentmenu = this.container.current;
                        if (currentmenu != this) {
                            if (currentmenu) {
                                currentmenu.targetEl.style.display = "none";
                                if (currentmenu.imgEl) {
                                    currentmenu.imgEl.src = currentmenu.imgEl.src.replace("_on.gif", ".gif");
                                }
                            }

                            this.targetEl.style.display = "block";
                            if (this.imgEl) {
                                this.imgEl.src = this.imgEl.src.replace(".gif", "_on.gif");
                            }
                            this.container.current = this;
                        }
                        return false;
                    }

                </script>
            </div>

            <div align="right" style="width:100%; height: 40px;">
                <button id="printBtn" class="k-button"  style="position:relative; top:25%;">출력</button>
                <button id="listBtn" class="k-button"  style="position:relative; top:25%;">목록</button>
            </div>
		</div>
		<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/>
	</div>
</body>
</html>