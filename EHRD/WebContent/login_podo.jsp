<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%
    /* if (request != null)
    {
        response.sendRedirect("/dmInfo/urlInfo.do");
        return;
    }  */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  decorator="homepage" >
<head>    
<title></title>
<link rel="stylesheet" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/css/main.css" type="text/css"/>


<script type="text/javascript">
//개발서버 적용여부.. (운영서버와 개발서버 간의 로그인 절차가 dev값(Y / N)에 따라 달라짐. ) 
var dev = "Y"; 

   yepnope([{
      load: [ 
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.9.1/jquery.min.js'
      ],
        complete: function() {
        	$("#login").click(function(){
        		loginEvnt();
        	});
            
            
        }
    }]);
   
    function loginEvnt() {

            var chkUrl = "";
            if(dev=="Y"){
                chkUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/accounts/sso/loginchk.do?dev=Y";
            }else{
                chkUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/accounts/sso/loginchk.do";
            }
            $.ajax({
                type: "POST",
                url: chkUrl,
                dataType: 'json',
                data: $("form[name=fm1]").serialize(),
                success : function( response ) {
                    if( response.error ) {
                        if(response.error =="No data"){
                            //개발용.. 사번 비번 미입력 시..
                            alert("사번과 비밀번호를 입력해주세요.");
                        }else if(response.error == "SSO Cookie not exist"){
                            //운영서버용.. sso토큰 정보가 없을 시.. 통합로그인 페이지로 이동..
                            location.href="http://hi.knu.ac.kr";
                        }else if(response.error == "No user data"){
                            alert("시스템에 등록되지 않은 사용자입니다. 교육운영자에게 문의해주세요.");
                        }else if(response.error == "rejected user"){
                            alert("사용이 거부된 사용자입니다. 교육운영자에게 문의해주세요.");
                        }else{
                            alert(response.error);
                        }
                    } else {
                        var loginUrl = "";
                        if(dev=="Y"){
                            loginUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/accounts/sso/login.do?dev=Y";
                        }else{
                            loginUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/accounts/sso/login.do";
                        }
                        $("form[name='fm1'] #output").val("");
                        $("form[name='fm1']").attr("action", loginUrl).submit();
                    }
                },
                error: function( xhr, ajaxOptions, thrownError){                                
                    $("form[name='fm1']")[0].reset();
                    alert("잘못된 접근입니다."+'xrs.status = ' + xhr.status + '\n' + 
                            'thrown error = ' + thrownError + '\n' +
                            'xhr.statusText = '  + xhr.statusText + '\n' );
                }
            });
        
    }
    
    function login2() {
        if(event.keyCode==13) {
            loginEvnt();
        }
    }
    
    
    </script>
    

</head>
<body class="login_back">
<div id="wrap">
    <div id="content2">
        <div class="login">
            <h1 class="logo"><!--a href="#">
            <img src="/images/top/top_logo.gif" style="width:101px; height:20px;" id="logoLoc" alt="경북대학교" /></a--></h1>
            <div class="loginArea">
                <div class="bg_top"></div>
                <div class="bg_cen">
                    <form name="fm1" method="POST" accept-charset="utf-8" id="login-form">
                    <input type="hidden" id="output" name="output" value="json" />
                    <input type="hidden" id="msg" name="msg" />
                    
                    <table class="fild_form" summary="로그인을 위한 사번과 비밀번호 입력테이블입니다.">
                    <p class="inp01 mb15">
                        <input type = "hidden" id = "companyid" name="companyid" >
                        <span class="tit"><label for="p_num"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/login/t_num.gif" alt="사번" /></label></span>
                        <span class="txt"><input type="text"  class="pw_num" id="empno" name="empno" onkeypress="login2();" value="knuadmin" /></span>
                    </p>
                    <p class="inp01">
                        <span class="tit"><label for="p_pw"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/login/t_pw.gif" alt="비밀번호" /></label></span>
                        <span class="txt"><input type="password"  class="pw_num" id="passwd" name="passwd" onkeypress="login2();" value="1" /></span>
                    </p>
                    <div class="btn_login"><a href="#"><img id="login" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/login/btn_login.gif" alt="로그인"  /></a></div>
                    
                    </table>
                    </form>
                </div>
                <div class="bg_btm"></div>
            </div>
        </div>
    </div><!--//content2-->
    
</div>
</body>
</html>