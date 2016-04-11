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
                
                $("#rst_evl_run_name").text(view[0].RUN_NAME);
            }
        });
        
        //역량분석데이터소스
        cmptDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_cmpt_analysis.do?output=json", type:"POST" },
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
            
        	//역량별 진단점수 row 
        	var rows = [];
        	var entryArray = [];
        	var columns = [];
        	entryArray.push("취득점수");
        	
        	columns.push({
                field: "entries[0]",
                title: "역량명",
                width:150,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"}
            });
        	
            var view = cmptDataSource.view();
            
            if(view.length>0){
            	
                //$("#rst_tg_name").text(uName);
                
                //상대적 부족역량 1,2,3
                //var weak1="", weak2="", weak3="";
                //전사 대비 부족역량 1,2,3
                //var a_weak1="", a_weak2="", a_weak3="";
                //동일직무 대비 부족역량 1,2,3
                //var j_weak1="", j_weak2="", j_weak3="";
                //동일계층 대비 부족역량 1,2,3
                //var l_weak1="", l_weak2="", l_weak3="";
                
                for(var i=0; i<view.length; i++){
                    var item = view[i];
                    
                    //상대적 부족역량 1,2,3
                    //if(item.RANK_R == "1") weak1 = item.CMPNAME;
                    //if(item.RANK_R == "2") weak2 = item.CMPNAME;
                    //if(item.RANK_R == "3") weak3 = item.CMPNAME;
                    
                    //전사 대비 부족역량 1,2,3
                    //if(item.RANK_A == "1") a_weak1 = item.CMPNAME;
                    //if(item.RANK_A == "2") a_weak2 = item.CMPNAME;
                    //if(item.RANK_A == "3") a_weak3 = item.CMPNAME;

                    //동일직무 대비 부족역량 1,2,3
                    //if(item.RANK_J == "1") j_weak1 = item.CMPNAME;
                    //if(item.RANK_J == "2") j_weak2 = item.CMPNAME;
                    //if(item.RANK_J == "3") j_weak3 = item.CMPNAME;

                    //동일계층 대비 부족역량 1,2,3
                    //if(item.RANK_L == "1") l_weak1 = item.CMPNAME;
                    //if(item.RANK_L == "2") l_weak2 = item.CMPNAME;
                    //if(item.RANK_L == "3") l_weak3 = item.CMPNAME;
                    
                    
                    //역량별진단점수 row set
                    entryArray.push(item.SCORE);
                    var entryIndex = "entries["+(i+1)+"]";
                    var entryValue =  item.SCORE;
                    //alert(entryArray[i+1]);
                    columns.push({
                        field: entryIndex,
                        title: item.CMPNAME,
                        width:120,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template:"<button onclick=\"filterData("+item.CMPNUMBER+"); return false;\" class=\"k-button\" >"+entryValue+"</button>"//" <a href='javascript:void();' onclick='javascript:filterData("+item.CMPNUMBER+");' ><ins>"+entryValue+"</ins></a>"
                    });
                    
                }
                /*
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
                */
                //=====================================
                //역량별진단점수 그리드 세팅 START
                //=====================================
                
                //역량별진단점수 row
                rows.push(kendo.observable({
                    entries: entryArray
                }));
                
                var viewModel = kendo.observable({
                    gridRows: rows
                });
	            
	            var configuration = {
	                editable: false,
	                sortable: false,
	                scrollable: true,
	                columns: columns
	            };
	               
                $("#cmptgrid").empty();
	            $("#cmptgrid").kendoGrid(configuration);
	
	            kendo.bind($('#example'), viewModel);
                
            }else{
                //역량진단 - 역량별 분석 결과 데이터가 존재 하지 않음...
                alert("역량진단 분석결과가  존재하지 않습니다.");
            }
        });
        
        //추천교육 목록 데이터소스
        var recommEduDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_recomm_edu_list.do?output=json", type:"POST" },
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
                    	RNUM : { type: "int" },
                    	CMPNUMBER : { type: "int" },
                        CMPNAME : { type: "string" },
                        SUBJECT_NUM : { type: "int" }, 
                        SUBJECT_NAME: { type: "string" },
                        TRAINING_NAME: { type: "string" },
                        INSTITUTE_NAME : { type: "string" }
                    }
                }
            },
            pageSize: 15,
            serverPaging: false,
            serverFiltering: false,
            serverSorting: false
        });
      
        
        
        //grid 세팅
        $("#grid").empty();
        $("#grid").kendoGrid({
            dataSource: recommEduDataSource,
            columns: [
                {
                    field:"RNUM",
                    title: "번호",
                    width: 80,
                    filterable: false,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}
                },
                {
                    field:"CMPNAME",
                    title: "역량명",
                    width: 150,
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left"} 
                },
                {
                    field:"SUBJECT_NAME",
                    title: "교육명",
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left"} ,
                    template:"<a href='javascript:void();' onclick='javascript:viewEdu(${SUBJECT_NUM}); return false;' ><ins>${SUBJECT_NAME}</ins></a>"
                },
                {
                    field:"TRAINING_NAME",
                    title: "교육유형",
                    width: 150,
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                {
                    field:"INSTITUTE_NAME",
                    title: "교육기관",
                    width: 150,
                    filterable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left"} 
                }/*,
                {
                    field:"SCORE",
                    title: "바로가기",
                    width:120,
                    filterable: false,
                    sortable: false,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"},
                    template: function (dataItem) {
                        //return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.COMPANYID+");' >"+dataItem.COMPANYNAME+"</a>"
                        return "<input type='button' class='k-button k-i-close' style='size:20' value='바로가기' onclick='fn_link("+dataItem.SUBJECT_NUM+"); return false;'/>";
                    } 
                }*/
            ],
            pageable: { refresh:false, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
            filterable: true,
            filterable: {
                extra : false,
                messages : {filter : "필터", clear : "초기화"},
                operators : { 
                 string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
                 number : { eq : "같음", gte : "이상", lte : "이하"}
                }
               },
            sortable: true,
            height: 430
        });
        
        
        $("#listBtn").click(function(){
            document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/car/cmpt_user_total_sco_list_pg.do";
            document.frm.submit();
        });
        
        
        $("#edugrid").empty();
        $("#edugrid").kendoGrid({
            columns: [
                {
                    field:"CHASU",
                    title: "차수",
                    width: 100,
                    filterable: false,
                    sortable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                {
                    field:"EDU_STIME",
                    title: "기간",
                    filterable: false,
                    sortable: true,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"},
                    template: function (dataItem) {
                        //return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.COMPANYID+");' >"+dataItem.COMPANYNAME+"</a>"
                        return dataItem.EDU_STIME+" ~ "+dataItem.EDU_ETIME;
                    } 
                }
            ],
            pageable: false,
            filterable: false,
            sortable: true,
            height: 130
        });
    }
}]);       
  

//교육과정 상세보기 팝업
function viewEdu(subjectNum){
    //alert(subjectNum);
    //레이어 팝업 초기화
    $("#eduTitle").text("asdfasd");
    $("#eduTrainnng").text("");
    $("#eduInstitute").text("");
    $("#eduCourseContents").text("");
    $("#eduEduObject").text("");
    $("#eduEduTarget").text("");
    
    $("#SUBJECT_NUM").val(subjectNum);
    $("#edugrid").data('kendoGrid').dataSource.data();
    
    //showHide('pop1',1);
    if( !$("#pop1-window").data("kendoWindow") ){
        $("#pop1-window").kendoWindow({
            width:"586px",
            height: "580px",
            resizable : true,
            title : "교육과정 상세 보기",
            modal: false,
            visible: false
        });
    }
    $.ajax({
        type : 'POST',
        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_recomm_edu_detail_info.do?output=json",
        data : { SUBJECT_NUM : subjectNum },
        complete : function( response ){
            if(response.responseText){
                var obj  = eval("(" + response.responseText + ")");
                if(obj!=null){
                	if(obj.items!=null){
                		if(obj.items[0].SUBJECT_NAME!=null){
                			$("#eduTitle").text(obj.items[0].SUBJECT_NAME);
                		}
                		
                		if(obj.items[0].TRAINING_NAME!=null){
                			$("#eduTrainnng").text(obj.items[0].TRAINING_NAME);
                		}
                        
                        if(obj.items[0].INSTITUTE_NAME!=null){
                        	$("#eduInstitute").text(obj.items[0].INSTITUTE_NAME);
                        }
                        
                        if(obj.items[0].COURSE_CONTENTS!=null){
                        	$("#eduCourseContents").text(obj.items[0].COURSE_CONTENTS);
                        }
                        
                        if(obj.items[0].EDU_OBJECT!=null){
                        	$("#eduEduObject").text(obj.items[0].EDU_OBJECT);
                        }
                        
                        if(obj.items[0].EDU_TARGET!=null){
                        	$("#eduEduTarget").text(obj.items[0].EDU_TARGET);
                        }
                        
                	}
                	
                	if(obj.items1!=null){
                		$("#edugrid").data('kendoGrid').dataSource.data(obj.items1);
                	}
                	
                	if(event.preventDefault){
                        event.preventDefault();
                    } else {
                        event.returnValue = false;
                    };
                }
            }
        },
        error: function( xhr, ajaxOptions, thrownError){
            alert('xrs.status = ' + xhr.status + '\n' + 
                     'thrown error = ' + thrownError + '\n' +
                     'xhr.statusText = '  + xhr.statusText + '\n' );
            
            if(event.preventDefault){
                event.preventDefault();
            } else {
                event.returnValue = false;
            };
        },
        dataType : "json"
    });
    
    $("#pop1-window").data("kendoWindow").center();
    $("#pop1-window").data("kendoWindow").open();
    
}

//역량별 교육과정 목록 filter
function filterData(cn){
	var gridDatasource = $("#grid").data('kendoGrid').dataSource;
    
	if(cn==null || cn == ""){
		gridDatasource.filter({});
	}else{
	    gridDatasource.filter({
	        "field":"CMPNUMBER",
	        "operator":"eq",
	        "value":cn
	    });
	}
}


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

//교육상세 팝업 show and hide...
function showHide(id,param) { 
	if (param==0) { 
		document.getElementById(id).style.display="none";
		$("#SUBJECT_NUM").val("");
	} else { 
		   document.getElementById(id).style.display="block"; 
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
        
        <input type="hidden" name="SUBJECT_NUM" id="SUBJECT_NUM" />
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
                            <li class="line"><a href="javascript:void(0);" onclick="goPage(1); return false;"class="tab01">역량별 분석</a></li>
                            <li><a href="javascript:void(0);" onclick="goPage(2); return false;"class="tab01">역량성장도</a></li>
                            <li class="on">추천 교육</li>
                            <li><a href="javascript:void(0);" onclick="goPage(4); return false;"class="tab01">코멘트</a></li>
                        </ul>
                    </div>
                    <div class="tab_box">
                        부족하게 도출된 역량을 개발할 수 있는 교육과정을 추천합니다. <br/>각 추천 교육과정의 교육목표와 내용을 확인하시고 적합하다고 판단되는 교육과정을 수강하시기 바랍니다. 
                    </div>
                    
                    <div id="graph_list">
                        <!-- 테이블차트 -->
                        <div id="example" class="k-content" style="width: 1062px; height: 100px;">
                            <div id="cmptgrid" data-bind="source: gridRows" style="width: 1175px; height: 90px;"></div>
                        </div>
                        
                        <div style="height:35px;">
                            <button onclick="filterData(); return false;" class="k-button" >전체보기</button>
                        </div>
                        <div id="grid" style="width:100%;"></div>
                    </div>
                    <div align="right" style="width:100%; height: 40px;">
                        <button id="listBtn" class="k-button"  style="position:relative; top:25%;">목록</button>
                    </div>


                    <!-- 레이어 1 -->
<!--             <div id="pop1" class="pop01"> -->
            <div id="pop1-window" style="display:none;">
                <div class="layer_cont">
                    <div class="layer_text">
                        <div style="width:530px;border-bottom:1px solid #d4d4d4;font-weight:bold;font-size:16px;padding:15px 0;"><span id="eduTitle"></span></div>
                        <!-- <div class="sub_btn"><a href="javascript:fn_link();"><button class="k-button"  >바로가기</button></a></div> -->
                        <div class="sub_title01"><span>교육 유형 :</span> <p id="eduTrainnng"></p></div>
                        <div class="sub_title01"><span>교육 기관 :</span> <p id="eduInstitute"></p></div>
                        <div class="sub_title01">학습개요</div>
                        <div class="top01"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_top03.gif" alt=""/></div>
                        <div class="middle01"><span id="eduCourseContents"></span></div>
                        <div class="bottom01"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom03.gif" alt=""/></div>
                        <div class="sub_title01">학습목표</div>
                        <div class="top01"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_top03.gif" alt=""/></div>
                        <div class="middle01"><span id="eduEduObject"></span></div>
                        <div class="bottom01"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom03.gif" alt=""/></div>
                        <div class="sub_title01">학습대상</div>
                        <div class="top01"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_top03.gif" alt=""/></div>
                        <div class="middle01"><span id="eduEduTarget"></span></div>
                        <div class="bottom01"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom03.gif" alt=""/></div>
                        <div class="sub_title01">학습기간</div>
                        <div class="text_table"><div id="edugrid" ></div></div>
                    </div>
                </div>
            </div>
            <!-- 레이어 1 끝 -->
            <style>
            <!--
.layer_cont .layer .close{float:right;margin-top:5px;}
.layer_cont{float:left;width:500px;}
.layer_cont .layer_text{position:relative;width:530px;margin-top:0px;padding:0 20px 10px 10px;}
.layer_cont .layer_text .sub_title{width:530px;border-bottom:1px solid #d4d4d4;font-weight:bold;color:#2eb398;font-size:16px;padding:15px 0;}
.layer_cont .layer_text .sub_btn{position:absolute;top:10px;right:30px;}
.layer_cont .layer_text .sub_title01{margin-top:20px;background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_cir02.gif) no-repeat 0 5px;padding-left:18px;font-weight:bold;}
.layer_cont .layer_text .sub_title01 span{float:left;width:73px;}

.layer_cont .layer_text .top01{width:535px;margin-top:10px;}
.layer_cont .layer_text .bottom01{width:530px;}
.layer_cont .layer_text .middle01{width:493px;border-left:1px solid #dfdfdf;border-right:1px solid #dfdfdf;padding:15px 20px;min-height:50px;}
.layer_cont .layer_text .text_table{width:530px;margin-top:10px;min-height:110px;}

    #cmptgrid   
    {   
       overflow-x:hidden !important;   
    }  

            -->
            </style>

             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div>
    
    
</body>
</html>