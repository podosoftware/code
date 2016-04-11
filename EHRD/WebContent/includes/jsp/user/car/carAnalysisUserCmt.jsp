<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}

String jobNum = "";
if(request.getAttribute("JOB") == null || request.getAttribute("JOB").equals("")){
    jobNum = "0";
}else{
    jobNum = request.getAttribute("JOB").toString();
}
String leaderNum = "";
if(request.getAttribute("LEADERSHIP")==null || request.getAttribute("LEADERSHIP").equals("")){
    leaderNum = "0";
}else{
    leaderNum = request.getAttribute("LEADERSHIP").toString();
}
%>
<html decorator="subpage">
<head>
<title></title>
<style>
.k-grid-content { height: 417px; }

</style>
<%

kr.podosoft.ws.service.car.action.CarServiceAction action = (kr.podosoft.ws.service.car.action.CarServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

String tgUserInfo  = "";
if(request.getAttribute("NAME")!=null){
    tgUserInfo = request.getAttribute("NAME").toString();
}
if(request.getAttribute("GRADE_NM")!=null){
    tgUserInfo = tgUserInfo + " " + request.getAttribute("GRADE_NM");
}
tgUserInfo = tgUserInfo + " (";
if(request.getAttribute("JOB_NAME")!=null){
    tgUserInfo = tgUserInfo + request.getAttribute("JOB_NAME");
}
tgUserInfo = tgUserInfo + " / ";
if(request.getAttribute("LEADERSHIP_NAME")!=null){
    tgUserInfo =  tgUserInfo + request.getAttribute("LEADERSHIP_NAME");
}
tgUserInfo = tgUserInfo + ")";
%>
<script type="text/javascript"> 

var runNum = "<%=request.getParameter("RUN_NUM")%>";
var tgUserid = "<%=request.getParameter("TG_USERID")%>";
var job = "<%=jobNum%>";
var leadership = "<%=leaderNum%>";
var uName = "<%=request.getAttribute("NAME")%>";

var cmptDataSource;

/*
 레이더 차트를 위해서 추가되어야하는
*/

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
        
        //진단기본정보
        var evlDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_run_info.do?output=json", type:"POST" },
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
        //역량진단기본정보 fetch 시..
        evlDataSource.fetch(function(){
            var view = evlDataSource.view();
            if(view.length>0){
                $("#evl_YYYY").text(view[0].YYYY);
                $("#evl_RUN_NAME").text(view[0].RUN_NAME);
                $("#evl_RUN_START").text(view[0].RUN_START);
                $("#evl_RUN_END").text(view[0].RUN_END);
                $("#evl_DIAGNO_DIR_TYPE_NM").text(view[0].DIAGNO_DIR_TYPE_NM);
                
                //$("#rst_evl_run_name").text(view[0].RUN_NAME);
            }
        });
        
        //진단자 코멘트 데이터소스
        var userCmtDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_user_cmt_analysis.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {
                        RUN_NUM: runNum,
                        TG_USERID: tgUserid
                    };
                }
            },
            schema: {
                data: "items",
                model: {
                    fields: {
                        CMPNAME : { type: "String" },
                        ONE_CMT : { type: "string" },
                        TWO_CMT : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
        //
        userCmtDataSource.fetch(function(){
        	if(userCmtDataSource.data() && userCmtDataSource.data().length>0){
        		
        		$.each(userCmtDataSource.data(), function(i,e){
	        		var opn = "";
	        		if(this.EVL_OPN!=null && this.EVL_OPN!=""){
	        			opn = this.EVL_OPN.replace(/(?:\r\n|\r|\n)/g, '<br/>');
	        		}else{
	        			opn = "내용없음.";
	        		}
	        		$('#graph_list').append( "<b>"+this.NAME+": </b>"+opn+"<br/>");
	        	});
        		
        	}else{
        		$('#graph_list').append( "상사의 코멘트가 존재하지 않습니다.<br/>" );
            }
            
        });
      
        
        $("#listBtn").click(function(){
            document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/cmpt_user_total_sco_list_pg.do";
            document.frm.submit();
        });
    }
}]);       
  

//탭별 화면전환..
function goPage(pageNum) {
    if(pageNum==1){
        //역량별분석
        document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/car_analysis_cmpt.do";
        document.frm.submit();
    }else if(pageNum==2){
        //역량성장도
    	$.ajax({
            type : 'POST',
            url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_grow_list_cnt.do?output=json",
            data : { TG_USERID : $("#TG_USERID").val() },
            complete : function( response ){
                var obj  = eval("(" + response.responseText + ")");
                if(obj.totalItemCount < 2){
                    alert("진단을 한번 밖에 받지 않아 역량 성장도를 제시할 수 없습니다. 한번 더 진단 받으시면 이전 진단결과와 비교하여 성장도 확인이 가능합니다.");
                    return false;
                }else{
                    document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/car_analysis_cmpt_grow.do";
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
        document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/car_analysis_cm_edu.do";
        document.frm.submit();
    }else if(pageNum==4){
        //코멘트
        document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/car_analysis_user_cmt.do";
        document.frm.submit();
    }
    
}

</script>

</head>
<body>
    <form id="frm" name="frm"  method="post" >
        
        <input type="hidden" name="RUN_NUM" id="RUN_NUM" value="<%=request.getParameter("RUN_NUM")%>"/>
        <input type="hidden" name="TG_USERID" id="TG_USERID" value="<%=request.getParameter("TG_USERID")%>"/>
        <input type="hidden" name="JOB" id="JOB" value="<%=request.getAttribute("JOB")%>" />
        <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" value="<%=request.getAttribute("LEADERSHIP")%>"/>
        
    </form>
    
    <div class="container">
        <div id="cont_body">
         <div class="content">
            <div class="top_cont">
                <h3 class="tit01">종합진단결과 - 개인별결과</h3>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>역량진단결과&nbsp; &#62;</span>
                    <span class="h">종합진단결과</span>
                </div><!--//location-->
            </div>
             <div class="sub_cont">
                
                    <div class="table_tin">
                        <ul>
                            <li class="line" style="width:1000px;">대상자 : <%=tgUserInfo%></li>
                        </ul>
                        <ul>
                            <li class="line">진단 년도 : <span id="evl_YYYY"></span>년</li>
                            <li>진단명 : <span id="evl_RUN_NAME"></span></li>
                        </ul>
                        <ul>
                            <li class="line">진단 기간 : <span id="evl_RUN_START"></span> ~ <span id="evl_RUN_END"></span></li>
                            <li>진단유형 : <span id="evl_DIAGNO_DIR_TYPE_NM"></span></li>
                        </ul>
                    </div>
                     <div class="tab_menu">
                        <ul>
                            <li class="line"><a href="javascript:void();" onclick="goPage(1); return false;"class="tab01">역량별 분석</a></li>
                            <li><a href="javascript:void();" onclick="goPage(2); return false;"class="tab01">역량성장도</a></li>
                            <li><a href="javascript:void();" onclick="goPage(3); return false;" class="tab01">추천 교육</a></li>
                            <li class="on">코멘트</li>
                        </ul>
                    </div>
                    <div class="tab_box">
                        다음은 상사의 의견입니다. 타인의 피드백은 다른 사람 눈에 비춰진 자신의 모습을 보여주는 거울과 같은 역할을 합니다. <br>피드백을 면밀히 성찰하여 역량개발의 기회로 삼으시기 바랍니다.
                    </div>
                    
                    <div id="graph_list">
<!--                         <div id="grid" style="width:100%;"></div> -->
                    </div>

                    <div align="right" style="width:100%; height: 40px;">
                        <button id="listBtn" class="k-button"  style="position:relative; top:25%;">목록</button>
                    </div>


             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div>
    
    
</body>
</html>