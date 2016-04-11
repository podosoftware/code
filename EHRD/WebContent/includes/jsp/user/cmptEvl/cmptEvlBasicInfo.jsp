<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
kr.podosoft.ws.service.cam.action.CAMServiceAction action = (kr.podosoft.ws.service.cam.action.CAMServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

%>

<html decorator="subpage">
<head>
<title></title>

<script type="text/javascript">	
//현재 세션의 사용자 번호
var exUserid = '<%=action.getUser().getUserId()%>';
var RUNNUM = '<%=request.getParameter("RUN_NUM")%>';

    yepnope([{
        load: [ 
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
        ],
		complete: function() {
			kendo.culture("ko-KR");               
			

            //진단 기본정보
            var dataSource_runinfo = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_run_info_exe.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  RUN_NUM : RUNNUM };
                    }
                },
                schema: {
                    data: "items"
                },
                serverFiltering: false,
                serverSorting: false});
			
            dataSource_runinfo.fetch(function(){
            	if(dataSource_runinfo.data().length>0){
            		$("#runName").text(dataSource_runinfo.data()[0].RUN_NAME);
                    $("#runDirType").text(dataSource_runinfo.data()[0].DIAGNO_DIR_TYPE_NM);
                    $("#runPeriod").text(dataSource_runinfo.data()[0].RUN_START+"~"+dataSource_runinfo.data()[0].RUN_END);
            	}
            });

            //개인정보확인
            var dataSource_userinfo = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_user_exed_info.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return { TG_USERID : exUserid };
                    }
                },
                schema: {
                    data: "items1"
                },
                serverFiltering: false,
                serverSorting: false});
            
            dataSource_userinfo.fetch(function(){
                if(dataSource_userinfo.data().length>0){
                    $("#userinfo").text(dataSource_userinfo.data()[0].NAME+" / "+dataSource_userinfo.data()[0].EMPNO+" / "+dataSource_userinfo.data()[0].DVS_NAME+" / "+dataSource_userinfo.data()[0].GRADE_NM);
                    var job = "";
                    if(dataSource_userinfo.data()[0].JOB_NM){
                    	job = dataSource_userinfo.data()[0].JOB_NM;
                    }
                    var leader = "";
                    if(dataSource_userinfo.data()[0].LEADERSHIP_NM){
                    	leader = dataSource_userinfo.data()[0].LEADERSHIP_NM
                    }
                    var userMsg = "";
                    if(job!="" && leader != ""){
                    	userMsg = job + " / "+ leader;
                    }else {
                    	userMsg = job + " " + leader;
                    }
                    $("#userjob").text(userMsg);
                    //$("#runDirType").text(dataSource_userinfo.data()[0].DIAGNO_DIR_TYPE_NM);
                    //$("#runPeriod").text(dataSource_userinfo.data()[0].RUN_START+"~"+dataSource_runinfo.data()[0].RUN_END);
                }
            });
            
			
            var grid = $("#grid").kendoGrid({
                dataSource: {
                     type: "json",
                     transport: {
                         read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_exed_list.do?output=json", type:"POST" },
                         parameterMap: function (options, operation){ 
                             return { RUN_NUM: RUNNUM  };
                         }        
                     },
                     schema: {
                         total: "totalItemCount",
                         data: "items",
                            model: {
                                fields: {
                                    RNUM : {type : "int" },
                                    COMPANYID : { type : "int" },
                                    RUN_NUM  : { type: "int" },
                                    USERID_EXED : { type : "int" },
                                    NAME : { type : "string" },
                                    EMPNO : { type : "string" },
                                    DIVISION : { type : "string" },
                                    DVS_NAME : { type : "string" },
                                    JOB_NM : { type : "string" },
                                    LEADERSHIP_NM : { type : "string" },
                                    GRADE_NM : { type : "string" },
                                    RUNDIRECTION_NM : {type : "string" }
                                }
                            }
                     },
                     pageSize: 10,
                     serverPaging: false,
                     serverFiltering: false,
                     serverSorting: false
                 },
                 columns: [
                     {
                         field:"NAME",
                         title: "성명",
                         width: 100,
                         filterable: true,
                         headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                         attributes:{"class":"table-cell", style:"text-align:center"}
                     },/*
                     {
                         field:"EMPNO",
                         title: "교직원번호",
                         width: 100,
                         filterable: true,
                         headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                         attributes:{"class":"table-cell", style:"text-align:center"}
                     },*/
                     {
                         field:"DVS_NAME",
                         title: "부서",
                         width: 100,
                         filterable: true,
                         headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                         attributes:{"class":"table-cell", style:"text-align:left"}
                     },
                     {
                         field:"GRADE_NM",
                         title: "직급",
                         width: 100,
                         filterable: true,
                         headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                         attributes:{"class":"table-cell", style:"text-align:left"}
                     },
                     {
                         field:"JOB_NM",
                         title: "직무",
                         width: 100,
                         filterable: true,
                         headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                         attributes:{"class":"table-cell", style:"text-align:left"}
                     },
                     {
                         field:"LEADERSHIP_NM",
                         title: "계급",
                         width: 100,
                         filterable: true,
                         headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                         attributes:{"class":"table-cell", style:"text-align:left"}
                     },
                     {
                         field:"RUNDIRECTION_NM",
                         title: "평가구분",
                         width: 100,
                         filterable: true,
                         headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                         attributes:{"class":"table-cell", style:"text-align:center"}
                     }
                 ],
                 pageable: { refresh:false, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
                 filterable: false,
                 sortable: false,
                 height: 400
             }).data("kendoGrid");
			

            //이전화면으로 이동.
            $("#beforeStep").click(function(){
                if(confirm("이전화면으로 이동하시겠습니까?")){
                    $("#RUN_NUM").val(RUNNUM);
                    document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_run_pg.do";
                    document.frm.submit();

                    if(event.preventDefault){
                        event.preventDefault();
                    } else {
                        event.returnValue = false;
                    }
                }
            });
        
            
            //진단 시작 버튼 클릭 
            $("#evlStartBtn").bind("click", function(){
            	if(dataSource_runinfo.data()[0].DIAGNO_DIR_TYPE_CD == "1"){
            		$("#RUN_NUM").val(RUNNUM);
                    
            		//자가진단인 경우
                    document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_self_exec.do";
                    document.frm.submit();
                    
                    if(event.preventDefault){
                        event.preventDefault();
                    } else {
                        event.returnValue = false;
                    }
            	}else{
            		//다면진단인 경우
            		$("#RUN_NUM").val(RUNNUM);
            		
            		document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_msd_exec.do";
                    document.frm.submit();
                    
                    if(event.preventDefault){
                        event.preventDefault();
                    } else {
                        event.returnValue = false;
                    }
            	}
            });
            
            $("#listBtn").click(function(){
                document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_run_pg.do";
                document.frm.submit();
            });
            
            
		}
	}]);       

    
    
	// 평가하기 버튼( 1명만 평가하는 경우..)
	function fn_evlExec(evlDiv, runNum, exedUserid, rundirectionCd) {
		//alert(exedUserid);
		var str;
		if (evlDiv == 1) {
			str = "이미 평가를 완료하였습니다.재평가하시겠습니까?";
		} else {
			str = "평가하시겠습니까?";
		}

		if (confirm(str)) {
			$("#RUN_NUM").val(runNum);
			$("#TG_USERID").val(exedUserid);
			$("#RUNDIRECTION_CD").val(rundirectionCd);
			$("#f_page").val("E");
            
            
			document.frm.submit();
		}

		if (event.preventDefault) {
			event.preventDefault();
		} else {
			event.returnValue = false;
		}
	}
	
	
</script>

</head>
<body>
	<form id="frm" name="frm"  method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_msd_self_exec.do">
	    <input type="hidden" name="RUN_NUM" id="RUN_NUM" />
	    <input type="hidden" name="USERID_EXED" id="USERID_EXED" />
	    <input type="hidden" name="RUNDIRECTION_CD" id="RUNDIRECTION_CD" />
        <input type="hidden" name="TG_USERID" id="TG_USERID" />
        <input type="hidden" name="JOB" id="JOB" />
        <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" />
        <input type="hidden" name="f_page" id="f_page" />
	</form>
	
	<div class="container">
        <div id="cont_body">
         <div class="content">
             <div class="top_cont">
                <h3 class="tit01">진단실시</h3>
                <div class="d_step b01">
                    <strong>STEP01. 기본정보확인</strong>
                    <div class="des">
                        역량진단의 1 단계인 기본정보확인입니다.<br/>
                        역량진단실시 내용, 개인 정보 및 피진단자들을 확인 후 진단을 실시 하십시오.
                    </div>
                </div>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>역량진단&nbsp; &#62;</span>
                    <span>진단실시&nbsp; &#62;</span>
                    <span class="h">기본정보확인</span>
                </div><!--//location-->
            </div>
             <div class="sub_cont">
                <h4 class="mt30">역량진단안내</h4>
                <dl class="Info01 mb40">
                    <dt class="fir">진단명</dt>
                    <dd class="d01"><span id="runName"></span></dd>
                    <dt>진단유형</dt>
                    <dd class="d02"><span id="runDirType"></span></dd>
                    <dt>진단실시기간</dt>
                    <dd><span id="runPeriod"></span></dd>
                </dl>
                <h4 class="mt30">개인정보확인</h4>
                <dl class="Info01">
                    <dt class="fir">성명/교직원번호/부서/직급</dt>
                    <dd class="d03"><span id="userinfo"></span></dd>
                    <dt>직무/계급</dt>
                    <dd class=""><span id="userjob"></span></dd>
                </dl>
                <h4 class="mt40">피진단자목록</h4>
                 <div id="example" class="mt15">
                    <div id="grid" style="height:400px;"></div>
                </div>
                <div class="btn_right">
                    <a href="javascript:void(0);"><img id="beforeStep" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_back.gif"" alt="이전" /></a>
                    <a href="javascript:void(0);"><img id="evlStartBtn" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_start01.gif"" alt="진단시작"  /></a>
                    <!--<input type ="image"  src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_start01.gif"  title="진단시작"/>-->
                </div>
                
             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div><!--//container-->
    

</body>

</html>