<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<title>경북대학교</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="stylesheet" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/css/sub_mpva.css" type="text/css" />
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/jquery.easing.1.3.js"></script>
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/common.js"></script>

<script type="text/javascript"> 

    yepnope([{
        load: [ 
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js' 
        ],
        complete: function() {
            kendo.culture("ko-KR");               
            openwindow();
            
        }
    }]);       
    
    //그리드 세팅.
    function openwindow() {
        //grid 세팅
        $("#grid").empty();
        $("#grid").kendoGrid({
               dataSource: {
                    type: "json",
                    transport: {
                        read: { url:"/service/cam/cmpt_evl_run_list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){ 
                            return {  startIndex: options.skip, pageSize: options.pageSize  };
                        }        
                    },
                    schema: {
                        total: "totalItemCount",
                        data: "items",
                           model: {
                               fields: {
                                   RUN_NUM  : { type: "int" },
                                   YYYY : { type: "int" },
                                   RUN_NAME : { type : "string" },
                                   TG_USERID : {type:"int"},
                                   RUN_START : {type:"string"},
                                   RUN_END : { type:"string" },
                                   USERID : { type:"int"},
                                   CMPL_FLAG : { type : "string" },
                                   CMPL_DATE : { type : "string" },
                                   CMD : { type : "string" },
                                   ONE_USERID : { type : "int" },
                                   ONE_NAME : { type : "string" },
                                   ONE_CMPL_FLAG : { type : "string" },
                                   ONE_CMPL_DATE : {type : "string" },
                                   TWO_USERID : { type : "int" },
                                   TWO_NAME : { type : "string" },
                                   TWO_CMPL_FLAG : { type : "string" },
                                   TWO_CMPL_DATE : {type : "string" },
                                   EVL_ANALY : { type : "string" }
                               }
                           }
                    },
                    pageSize: 20,
                    serverPaging: false,
                    serverFiltering: false,
                    serverSorting: false
                },
                columns: [
                    {
                        field:"YYYY",
                        title: "해당년도",
                        width: 80,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    {
                        field:"RUN_NAME",
                        title: "평가명",
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        title: "평가기간",
                        width:200,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                            //return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.COMPANYID+");' >"+dataItem.COMPANYNAME+"</a>"
                            return dataItem.RUN_START+" ~ "+dataItem.RUN_END;
                        } 
                    },
                    {
                        title: "자가평가",
                        width:180,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template: function (dataItem) {
                            if(dataItem.SELF_CMPL_FLAG == "Y"){
                                if(dataItem.ONE_START_DATE == null || dataItem.ONE_START_DATE == ""){
                                    //재평가하기
                                    if(dataItem.EVL_CMD == "평가하기"){
                                        return "<input type='button' class='k-button' value='재평가하기' onclick='fn_evlExec(1, "+dataItem.RUN_NUM+","+dataItem.TG_USERID+");'/>"+"<br>"+dataItem.SELF_CMPL_DATE;
                                    }else{
                                        return "[완료]<br>"+dataItem.SELF_CMPL_DATE;
                                    }
                                }else{
                                    //평가 못함
                                    return "[완료]<br>"+dataItem.SELF_CMPL_DATE;
                                }   
                            }else{
                                //평가하기
                                if(dataItem.EVL_CMD == "평가하기"){
                                    return "<input type='button' class='k-button' value='평가하기' onclick='fn_evlExec(2, "+dataItem.RUN_NUM+","+dataItem.TG_USERID+");'/>";
                                }else{
                                    return dataItem.EVL_CMD;
                                }
                            }
                        }
                    },
                    {
                        title: "1차평가자",
                        width:180,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                            if(dataItem.ONE_USERID!=null){
                                if(dataItem.ONE_CMPL_FLAG=="Y"){
                                    return dataItem.ONE_NAME+"[완료]<br>"+dataItem.ONE_CMPL_DATE;
                                }else{
                                    if(dataItem.EVL_CMD == "평가하기"){
                                        return dataItem.ONE_NAME+"[대기]";
                                    }else{
                                        return dataItem.ONE_NAME+"["+dataItem.EVL_CMD+"]";
                                    }
                                }
                            }else{
                                return "-";
                            }
                        }
                    },
                    {
                        title: "2차평가자",
                        width:180,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                            if(dataItem.TWO_USERID!=null){
                                if(dataItem.TWO_CMPL_FLAG=="Y"){
                                    return dataItem.TWO_NAME+"[완료]<br>"+dataItem.TWO_CMPL_DATE;
                                }else{
                                    if(dataItem.EVL_CMD == "평가하기"){
                                        return dataItem.TWO_NAME+"[대기]";
                                    }else{
                                        return dataItem.TWO_NAME+"["+dataItem.EVL_CMD+"]";
                                    }
                                }
                            }else{
                                return "-";
                            }
                        }
                    },
                    {
                        title: "분석평가",
                        width:80,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                            var self = false;
                            var one = false;
                            var two = false;
                            
                            if(dataItem.SELF_CMPL_FLAG=="Y"){
                                self = true;
                            }
                            if(dataItem.ONE_USERID != null){
                                if(dataItem.ONE_CMPL_FLAG=="Y"){
                                    one = true;
                                }
                            }else{
                                one = true;
                            }
                            if(dataItem.TWO_USERID != null){
                                if(dataItem.TWO_CMPL_FLAG=="Y"){
                                    two = true;
                                }
                            }else{
                                two = true;
                            }
                            
                            if(dataItem.EVL_CMD == "평가종료" && self && one && two){
                                return "<input type='button' class='k-button' value='열람' onclick='fn_analy("+dataItem.RUN_NUM+","+dataItem.TG_USERID+","+dataItem.JOB+","+dataItem.LEADERSHIP+");return false;'/>";
                            }else{
                                return "대기";
                            }
                        }
                    }
                ],
                pageable: { refresh:false, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
                filterable: false,
                sortable: true,
                height: 470
            });

    }
    
    //분석 버튼 
    function fn_analy(runNum, useridExed, job, leadership) {
        $("#RUN_NUM").val(runNum);
        $("#TG_USERID").val(useridExed);
        $("#JOB").val(job);
        $("#LEADERSHIP").val(leadership);
        
        document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_analysis_cmpt.do"
        document.frm.submit();
    }
  
    // 고객사정보 상세보기.
    function fn_evlExec(runDiv, runNum, tgUserid){
        //alert(runNum);
        var str = "";
        if(runDiv==1){
            str = "이미 평가를 완료하였습니다. 재평가하시겠습니까?";
        }else{
            str = "평가하시겠습니까?";
        }
        var isConfirm = confirm(str);
        if(isConfirm){
            $("#RUN_NUM").val(runNum);
            $("#TG_USERID").val(tgUserid);
            
            document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_self_exec.do";
            document.frm.submit();
        }

        if(event.preventDefault){
            event.preventDefault();
        } else {
            event.returnValue = false;
        }
    }
</script>
</head>
<body>
    <form id="frm" name="frm"  method="post" >
        <input type="hidden" name="RUN_NUM" id="RUN_NUM" />
        <input type="hidden" name="TG_USERID" id="TG_USERID" />
        <input type="hidden" name="JOB" id="JOB" />
        <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" />
    </form>
    
	<div class="wrap">
		<div id="header_wrap">
			<div class="header">
				<div class="gnb">
					<h1>
						<a href="#"><img alt="경북대학교"
							src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/top/top_logo.gif"></a>
					</h1>
					<ul class="top_link">
						<li><a href="#" class="tophome">HOME</a></li>
						<li class="last"><a href="#" class="toplogin">LOGIN</a></li>
					</ul>
				</div>
				<!--//gnb-->
				<div class="nav-area">
					<div class="nav">
						<h2 class="blind">상단메뉴</h2>
						<ul>
							<li class="m01"><a href="#">역량진단</a>
								<ul class="sub-nav">
									<li><a href="#">역량진단목록</a></li>
									<li><a href="#">진단하기</a></li>
									<li><a href="#">진단분석</a></li>
								</ul></li>
							<li><a href="#">역량진단결과</a>
								<ul class="sub-nav">
									<li><a href="#">진단실시현황</a></li>
									<li><a href="#">소속별응답현황분석</a></li>
									<li><a href="#">직무별응답현황분석</a></li>
									<li><a href="#">역량별직무/계급점수</a></li>
									<li><a href="#">역량별점수</a></li>
									<li><a href="#">종합진단결과</a></li>
								</ul></li>
							<li><a href="#">경력개발계획</a>
								<ul class="sub-nav">
									<li><a href="#">계획수립</a></li>
									<li><a href="#">계획수립현황</a></li>
									<li><a href="#">계획승인</a></li>
								</ul></li>
							<li><a href="#">교육훈련</a>
								<ul class="sub-nav">
									<li><a href="#">나의강의실</a></li>
									<li><a href="#">교육신청</a></li>
									<li><a href="#">외부학습</a></li>
								</ul></li>
							<li><a href="#">교육훈련결과</a>
								<ul class="sub-nav">
									<li><a href="#">교육승인</a></li>
									<li><a href="#">임직원교육현황</a></li>
									<li><a href="#">부서원상시학습달성현황</a></li>
									<li><a href="#">승진기준달성현황</a></li>
								</ul></li>
							<li><a href="#">멘토링</a>
								<ul class="sub-nav">
									<li><a href="#">멘토링</a></li>
									<li><a href="#">멘토링승인</a></li>
								</ul></li>
							<li><a href="#">게시판</a>
								<ul class="sub-nav last_line">
									<li><a href="#">공지사항</a></li>
									<li><a href="#">질문과답변</a></li>
									<li><a href="#">교육안내</a></li>
								</ul></li>
						</ul>
					</div>
					<!--//nav-->
				</div>
				<!--//nav-area-->
			</div>
			<!--//header-->
			<div class="sub_nav_bg"></div>
		</div>
		<!--//header_wrap-->
		<div class="container">
			<div id="cont_body">
				<div class="content">
					<div class="sub_cont">
						<h3 class="tit01">역량진단</h3>
						<p class="des">
							역량진단은 진단자에게 우선적으로 개발이 요구되는 역량을 알려주어 본인에게 최적화된 자기개발계획 수립을 가이드하기 위한
							목적을 가지고 있습니다. <br /> 따라서 자기 진단 시에는 되고 싶은 내가 아닌….
						</p>
						<h4 class="mt30">역량 진단 목록</h4>
						<div id="grid" class="mt15"></div>
						<h4 class="mt40">역량 진단 절차 안내</h4>
						<ol class="method_Info">
							<li class="fir">
								<dl>
									<dt>기본정보확인</dt>
									<dd>
										<span>역량진단 안내</span> <span class="cen">개인정보 확인</span> <span>진단대상자
											목록</span>
									</dd>
								</dl>
							</li>
							<li class="last">
								<dl>
									<dt>현수준 진단</dt>
									<dd>
										<span>문항을 읽고 피진단자들의 레벨 체크</span>
									</dd>
								</dl>
							</li>
						</ol>
					</div>
					<!--//sub_cont-->
				</div>
				<!--//content-->
			</div>
			<!--//cont_body-->
		</div>
		<!--//container-->
		<div id="footerWrap">
			<div class="footer">
				<div class="foot_txt">
					<address>339-012 세종특별자치시 도움4로 9 대표전화 : 1577-0606</address>
					<p>Copyright ⓒ 2014.Ministry of patriots & veterans Affairs.ALL
						Rights RESERVED.</p>
				</div>

			</div>
		</div>

	</div>
	<!--//wrap-->
</body>
</html>