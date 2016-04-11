<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
	<head>
	   <meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<title></title>
	</head>
	<body>	
	
	 <strong><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/logout">logout</strong></a><br>
        <strong><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/mainpg.do">메인페이지</a></strong> <br>  
		<strong><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_run_pg.do">역량평가</a></strong> <br>	
		<strong><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/otc_service_list.do">성과관리</a></strong> <br> 
		<strong><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_main.do">일반게시판</a></strong> <br>    
        
		<p><font size="10">총괄관리자</font></p>
		
		<p><font size="5" color="red">역량풀관리</font></p>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_cmpt_main.do">역량관리</a></strong><br>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_indc_main.do">행동지표관리</a></strong><br>
        <p><font size="5" color="red">KPI풀관리</font></p>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_kpi_main.do">KPI관리</a></strong><br>
        <p><font size="5" color="red">고객사관리</font></p>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ba/ba-company-main.do">고객사관리</a></strong><br><br>
        
        <p><font size="10">고객사관리자</font></p>  
        
        <p><font size="5" color="red">기본관리</font></p>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_admin_main.do">직무관리</a></strong><br>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_ldr_admin_main.do">리더십관리</a></strong><br>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-dept-main.do">부서관리</a></strong><br>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/user-main.do">직원관리</a></strong><br>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-main.do">공통코드관리</a></strong><br>
        <strong> ▶ <a href="<%= request.getContextPath() %>/mgmt/sbjct/sbjct-main.do">과정관리</a></strong><br>
        <p><font size="5" color="red">평가지표관리</font></p>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_operator_main.do">역량관리</a></strong><br>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_indc_main.do">행동지표관리</a></strong><br>                
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_cmpt_mapp_main.do">역량매핑관리</a></strong><br>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_kpi_main.do">성과관리</a></strong><br>        
        <p><font size="5" color="red">평가관리</font></p>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_admin_main.do">평가생성/관리</a></strong><br>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/kpi_user_mgmt_list.do">직원별 KPI관리</a></strong><br>        
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_target_main.do">역량평가자설정</a></strong><br>
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_statistics_main.do">평가현황열람</a></strong><br>  
        <p><font size="5" color="red">종합평가</font></p>  
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/tt_evl_main.do">종합평가</a></strong><br> 
        <p><font size="5" color="red">종합평가</font></p>  
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/tt_evl_main.do">종합평가</a></strong><br> 
        <p><font size="5" color="red">설문관리</font></p>  
        <strong> ▶ <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_main.do">설문관리</a></strong><br> 
        
        <p><font size="10">부서장</font></p> 
        
        <strong><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_run_pg.do">부서원 역량평가</a></strong><br>
        <strong><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_otc_service_list.do">부서원 성과평가</a></strong><br>
        <strong><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_tt_evl_main.do">종합평가</a></strong><br>
        <br>
    </body>
</html>