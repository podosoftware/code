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
                
                //$("#rst_evl_run_name").text(view[0].RUN_NAME);
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
        
        //역량별 분석 데이터소스
        /*cmptDataSource = new kendo.data.DataSource({
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
        });*/
        //역량별 분석 정보 fetch 시..
        /*cmptDataSource.fetch(function(){
            
            var view = cmptDataSource.view();
            if(view.length>0){
                //$("#rst_tg_name").text(uName);
                
                //상대적 부족역량 1,2,3
                var weak1="", weak2="", weak3="";
                //전사 대비 부족역량 1,2,3
                var a_weak1="", a_weak2="", a_weak3="";
                //동일직무 대비 부족역량 1,2,3
                var j_weak1="", j_weak2="", j_weak3="";
                //동일계층 대비 부족역량 1,2,3
                var l_weak1="", l_weak2="", l_weak3="";
                
                for(var i=0; i<view.length; i++){
                    var item = view[i];
                    
                    //상대적 부족역량 1,2,3
                    if(item.RANK_R == "1") weak1 = item.CMPNAME;
                    if(item.RANK_R == "2") weak2 = item.CMPNAME;
                    if(item.RANK_R == "3") weak3 = item.CMPNAME;
                    
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

                }
                
                //상대적 부족역량 세팅
                var r_weak = "";
                if(weak1!="") r_weak = r_weak + "\""+weak1+"\"";
                if(weak2!="") r_weak = r_weak + ", " + "\"" + weak2 + "\"";
                if(weak3!="") r_weak = r_weak + ", " + "\"" + weak3 + "\"";
                $("#r_weak_cmpt").text( r_weak + "");

                //전사 대비 부족역량 세팅
                var a_weak = "";
                if(a_weak1!=""){
                    a_weak = "\""+a_weak1+"\"";
                    if(a_weak2!="") a_weak = a_weak + ", " + "\"" + a_weak2 + "\"";
                    if(a_weak3!="") a_weak = a_weak + ", " + "\"" + a_weak3 + "\"";
                    a_weak = a_weak + " 이 ";
                }else{
                    a_weak = "상대적으로 약한 역량이 없으며 ";
                }
                $("#a_weak_cmpt").text( a_weak );

                //동일 직무 대비 부족역량 세팅
                var j_weak = "";
                if(j_weak1!=""){
                    j_weak = "\""+j_weak1+"\"";
                    if(j_weak2!="") j_weak = j_weak + ", " + "\"" + j_weak2 + "\"";
                    if(j_weak3!="") j_weak = j_weak + ", " + "\"" + j_weak3 + "\"";
                    j_weak = j_weak + " 이 ";
                }else{
                    j_weak = "상대적으로 약한 역량이 없으며 ";
                }
                $("#j_weak_cmpt").text( j_weak );

                //동일 계층 대비 부족역량 세팅
                var l_weak = "";
                if(l_weak1!=""){
                    l_weak = "\""+l_weak1+"\"";
                    if(l_weak2!="") l_weak = l_weak + ", " + "\"" + l_weak2 + "\"";
                    if(l_weak3!="") l_weak = l_weak + ", " + "\"" + l_weak3 + "\"";
                    l_weak = l_weak + " 역량이 상대적으로 약합니다. ";
                }else{
                    l_weak = "상대적으로 약한 역량이 없습니다. ";
                }
                $("#l_weak_cmpt").text( l_weak );
            }else{
                //역량평가 - 역량별 분석 결과 데이터가 존재 하지 않음...
                alert("역량평가 분석결과가  존재하지 않습니다.");
            }
            

        });*/
        
        //평가자 코멘트 데이터소스
        var userCmtDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"/deptmgr/ca/dept_cmpt_evl_user_cmt_analysis.do?output=json", type:"POST" },
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
      
        //grid 세팅
        $("#grid").empty();
        $("#grid").kendoGrid({
            dataSource: userCmtDataSource,
            columns: [
                {
                    field:"CMPNAME",
                    title: "역량",
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left"}
                },
                {
                    field:"ONE_CMT",
                    title: "1차평가자",
                    width: 400,
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left"} 
                },
                {
                    field:"TWO_CMT",
                    title: "2차평가자",
                    width: 400,
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left"} 
                }
            ],
            pageable: false,//{ refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
            filterable: false,
            sortable: true,
            height: 498
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
                    <li class="line"><a href="javascript:void();" onclick="goPage(1); return false;"class="tab01">역량별 분석</a></li>
                    <li><a href="javascript:void();" onclick="goPage(2); return false;"class="tab01">역량성장도</a></li>
                    <li><a href="javascript:void();" onclick="goPage(3); return false;" class="tab01">추천 교육</a></li>
                    <li class="on">코멘트</li>
                </ul>
            </div>
            <div class="tab_box">
                각 역량에 대한 상사의 의견입니다. 타인의 피드백은 다른 사람 눈에 비춰진 자신의 모습을 보여주는 거울과 같은 역할을 합니다. <br>피드백을 면밀히 성찰하여 역량개발의 기회로 삼으시기 바랍니다.
                <!-- 
                <span id="rst_tg_name"></span>님의 <span id="rst_evl_run_name"></span> 결과 <span>상대적으로</span> <span id="r_weak_cmpt"></span> 이, <span>전사 대비</span>  <span id="a_weak_cmpt"></span>, <span>동일 직무 대비</span> <span id="j_weak_cmpt"></span> 마지막으로 <span>동일 계층 대비</span> <span id="l_weak_cmpt"></span> 
                 -->
            </div>
            
            <div id="graph_list">
                <!-- 테이블차트 -->
                <div id="grid" style="width:100%;"></div>
            </div>

            <div align="right" style="width:100%; height: 40px;">
                <button id="listBtn" class="k-button"  style="position:relative; top:25%;">목록</button>
            </div>
        </div>
        <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/>
    </div>
</body>
</html>