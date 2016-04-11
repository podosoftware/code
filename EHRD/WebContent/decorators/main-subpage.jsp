<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="architecture.common.user.User" %>
<%@ page import="architecture.user.util.SecurityHelper"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
String userNm = "";
String userId_sub = "";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}
if(httpsession !=null && httpsession.getAttribute("USER_NAME")!=null){
    userNm = httpsession.getAttribute("USER_NAME").toString();
}

//총괄관리자 권한 여부..
boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
//고객사운영자 권한 여부..
boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
//부서장 권한 여부..
boolean isManager = request.isUserInRole("ROLE_MANAGER");
User user = SecurityHelper.getUser();       
String menuStr = architecture.ee.web.util.ServletUtils.getServletPath(request);

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head> 
		<title><decorator:title default="경북대학교" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<!-- explorer버전을 pc의 최신버전으로 띄우도록 처리 -->
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta http-equiv="Pragma" content="no-cache">
		<meta http-equiv="Expires" content="-1">
		<link rel="stylesheet" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/css/sub_mpva.css" type="text/css" />
		<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
        <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.js"></script>
        <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.7.2/jquery.min.js"></script>
        <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js"></script>
        <script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/jquery.easing.1.3.js"></script>
		<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/common.js"></script>
        
        <script type="text/javascript">
        var isManager_sub = <%=isManager%>; //부서장
		var isSystem_sub =  <%=isSystem%>;  //총괄 관리자 
		
   function appCount_sub(){
   	
   	$.ajax({
           type : 'POST',
           dataType : 'json',
           url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/main_edu_app_cnt.do?output=json",
           data : {
           },
           success : function(response) {
               //var selectRow = new Object();
           	if (response.items1 != null) {
               	var item = response.items1;
                   $("#appCnt_sub").html(item[0].ENTRUST_CNT);

               }
           },
           error : function(xhr, ajaxOptions, thrownError) { 
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
           }
       });
   	
   }
		 
        function logout(){
            if(confirm("로그아웃하시겠습니까?")){
                document.logout.submit();
            }
        }
        
        function sessionout(){
            document.logout.submit();
        }
        
        //로딩바 정의
        function loadingDefine(){
            //로딩바윈도우
            if( !$("#loading-window").data("kendoWindow") ){
                winElement = $("#loading-window").kendoWindow({
                    width:"215px",
                    height:"73px",
                    minHeight:"60px",
                    resizable : false,
                    title : false,
                    modal: true,
                    visible: false
                });
                
                winElement.animation = { open: { effects: "fadeIn"  }, close: { effects: "fadeIn", reverse: true} };
                winElement.css("overflow", "hidden !important");
            }
        }
        
        //로딩바 생성...
      function loadingOpen(){
          $("#loading-window").data("kendoWindow").center();
          $("#loading-window").data("kendoWindow").open();
          winElement.append(loadingElement());
      }
      //로딩바 제거..
      function loadingClose(){
          winElement.find(".k-loading-mask").remove();
          $("#loading-window").data("kendoWindow").close();
      }

      //로딩바 
      function loadingElement() {
          return $("<img class=\"k-loading-mask\" src=\"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/loading.gif\" />");
      }
  
    //부서원직무관리 팝업
      function job_admin_sub(userId){
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
		$("#topSubJobList").kendoDropDownList({
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
          				return "<button id='changeJob' class='k-button' onclick='changeJob("+data.USERID+","+data.JOB+");'>변경</button>";
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
        			userId: '<%=userId_sub%>'
        		},
        		success : function(response){
        			if(response.items1 != null && response.items1.length > 0){
        				$("#jobDetailGrid").data("kendoGrid").dataSource.data(response.items1);
        			}else{
        				//alert("else \n"+JSON.stringify(response.items));
        				//DisplayNoResultsFound($('#detailGrid'));
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
      	        var jobNum = $("#topSubJobList").data("kendoDropDownList");
      	        if(jobNum.value()<0){alert("변경할 직무을 선택하세요.");return false;}
      	        var isDel = confirm("직무을 변경 하시겠습니까?");
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
      	                        job_admin_sub();
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

        $("#topSubJobList").data("kendoDropDownList").value(userJob);
        
      	$("#window_jobList").data("kendoWindow").center();
      	$("#window_jobList").data("kendoWindow").open();
      }
        </script>
		<decorator:head />
	</head>
<body onload="<decorator:getProperty property="body.onload" />">
<form id="logout" name="logout" method="POST"  action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/logout"></form>
<div id="wrap">
    <div id="header_wrap">
        <div class="header">
            <div class="gnb">
				<% if(isSystem){ %><div class="admin" ><a href="<%=architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_operator_main.do" class="topadmin">ADMIN</a> 
                <div style="display:inline-block;margin-left:5px;cursor:pointer;" onClick="fn_changeEduMng()" ></div></div>
                <% }else if(isManager){ %><div class="admin"><a href="javascript:job_admin_sub()" class="topadmin">부서원 직무관리</a></div><% } %>
                <h1><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/main.do"><img alt="경북대학교" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/top/top_logo.gif" style="height:40px;"></a></h1>
                <ul class="top_link">
                    <li class="mr15"><strong><%=userNm%></strong>님 안녕하세요!</li>
                    <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/main.do" class="tophome">HOME</a></li>
                    <li class="last"><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/logout" class="toplogin">LOGOUT</a></li>
				</ul>
            </div><!--//gnb-->
            <div class="nav-area">
                <div class="nav">
                    <h2 class="blind">상단메뉴</h2>
                    <ul>
                         <li class="m01 <% if(menuStr.indexOf("/service/cam/")>-1){ out.println("on"); } %>" ><a href="javascript:void(0);">역량진단</a>
                            <ul class="sub-nav">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_run_pg.do">역량진단</a></li>
                                <!-- <li><a href="#">진단하기</a></li>
                                <li><a href="#">진단분석</a></li> -->
                            </ul>
                        </li>
                        <% if(isSystem || isOperator || isManager){ %>
                        <li class="<% if(menuStr.indexOf("/service/car/")>-1){ out.println("on"); } %>"><a href="javascript:void(0);">역량진단결과</a>
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
                        <li class="<% if(menuStr.indexOf("/service/cdp/cdp_run_list_pg")>-1 || menuStr.indexOf("/service/cdp/cdp_plan_state_list_pg")>-1){ out.println("on"); } %>"><a href="javascript:void(0);">경력개발계획</a>
                             <ul class="sub-nav">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_run_list_pg.do">계획수립</a></li>
                                <% if(isSystem || isOperator || isManager){ %>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_state_list_pg.do">계획수립현황</a></li>
                                <% } %>
                            </ul>
                         </li>
                        <li class="<% if(menuStr.indexOf("/service/em/")>-1 || menuStr.indexOf("/service/emapply/")>-1|| menuStr.indexOf("/service/emalw/")>-1 ||menuStr.indexOf("/service/emadmin/")>-1 )  { out.println("on"); } %>"><a href="javascript:void(0);">교육훈련</a>
                             <ul class="sub-nav">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/em/my-class-main.do">나의강의실</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emapply/sbjct-apply-main.do">교육신청</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/main.do">상시학습</a></li>
                                <% if(isSystem || isOperator){ %>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emadmin/my-class-admin-main.do">상시학습관리</a></li>
                                <%} %>
                              </ul>
                         </li>
                        <% if(isSystem || isOperator || isManager){ %>
                        <li class="<% if(menuStr.indexOf("/deptmgr/sbjct/")>-1){ out.println("on"); } %>"><a href="javascript:void(0);">교육훈련결과</a>
                            <ul class="sub-nav">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/ba-edu-result-main.do">부서원교육현황</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/ba-alw-edu-result-main.do">부서원상시학습달성현황</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/ptmtn-edu-rslt-main.do">승진기준달성현황</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_state_rate_list_pg.do">계획대비실행율</a></li>
                            </ul>
                         </li>
                         <%} %>
                        <li class="<% if(menuStr.indexOf("/service/ca/")>-1){ out.println("on"); } %>"><a href="javascript:void(0);">게시판</a>
                             <ul class="sub-nav">
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_notice_main.do">공지사항</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_qna_main.do">질문과답변</a></li>
                                <li><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_edu_info_main.do">교육안내</a></li>
                             </ul>
                        </li>
                        <li class="<% if(menuStr.indexOf("/service/cdp/cdp_plan_approval_list_pg")>-1 || menuStr.indexOf("/service/sbjct/ba-edu-recomm-appr-main")>-1 || menuStr.indexOf("/service/sbjct/ba-edu-appr-main")>-1){ out.println("on"); } %>"><a href="javascript:void(0);">승인하기</a>
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
    <input type="hidden" id="change_userId_sub" name="change_userId_sub"/>
	<input type="hidden" id="insert_userId_sub" name="insert_userId_sub"/>
	<input type="hidden" id="divisionId_sub" name="divisionId_sub"/>
	<input type="hidden" id="userId_sub" name="userId_sub" value="<%=userId_sub%>"/>
	<input type="hidden" id="changeUserId" name="changeUserId"/>
	<input type="hidden" id="changeUserJob" name="changeUserJob"/>
	
	<div id="window_job_admin" style="display:none">
			<div class="tit"></div>
			<div>
				<div id="jobDetailGrid" style="overflow-y:auto; margin:10px 10px;" ></div>
				<div style="margin:10px 10px">
				</div>
			</div>
	</div>
	<div id="window_jobList" style="display:none">
		<select id="topSubJobList"></select>&nbsp;
		<button id="job_change" class="k-button">확인</button>
	</div>
    <!-- 본문영역 -->
    <decorator:body />
    <!-- 본문영역 끝 -->
		
<div id="footerWrap">
		<div class="footer">
				<div class="foot_txt">
					<address>702-701 대구광역시 북구 대학로 80 경북대학교</address>
					<p>Copyright(c) 2015 Kyungpook National University. All rights reserved.</p>
				</div>
		</div>
	</div>
</div>	


<!-- 로딩바 -->
<div id="loading-window" style="display:none; overflow:hidden;"></div>

	</body>
</html>