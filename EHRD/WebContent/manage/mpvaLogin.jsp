<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  decorator="homepage" >
<head>    
<title></title>
<link rel="stylesheet" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/css/main.css" type="text/css"/>


<script type="text/javascript">

var domain = "<%=request.getServerName()%>";
var subString = domain.indexOf(".");
var subDomain = "mpva";

   yepnope([{
      load: [ 
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.9.1/jquery.min.js'
      ],
        complete: function() {
            $("#login").click(function() {
                loginEvnt();
            });
            
        }
    }]);
   
	function loginEvnt() {
		if($("#companyId").val()==""){
			alert("잘못된 URL접근입니다. 교육운영자에게 문의해주세요.");
			return false;
		}
		if( $("#empno").val()!="" &&  $("#passwd").val()!="") {
			$.ajax({
				type: "POST",
				url: "/accounts/sso/loginchk.do",
				dataType: 'json',
				data: $("form[name=fm1]").serialize(),
				success : function( response ) {
					if( response.error ) {
						if(response.error == "No user data"){
							alert("입력한 사번 정보가 잘못되었습니다.");
						}else if(response.error == "rejected user"){
		                       alert("사용이 거부된 사용자입니다.");
		                   }else if(response.error == "invalid password"){
		                       alert("비밀번호 정보가 잘못되었습니다.");
		                   }
						//alert("입력한 사번, 비밀번호정보가 잘못되었습니다.");
					} else {								
						$("form[name='fm1'] #output").val("");
						$("form[name='fm1']").attr("action", "/accounts/sso/mpvaLogin.do").submit();
					}                                 
				},
				error: function( xhr, ajaxOptions, thrownError){         				        
					$("form[name='fm1']")[0].reset();
					alert("잘못된 접근입니다.");
				}
			});
		} else {
			alert("사번, 비밀번호정보를 입력해주세요.");
		}
		
	}
	
	function login2() {
		if(event.keyCode==13) {
			loginEvnt();
		}
	}
	
	function chkNumber(obj) {
		if(event.keyCode >= 48 && event.keyCode <= 57) {
			return true;
		} else {
			event.returnValue = false;
		}
	}
	
	</script>
	
	<script type="text/javascript">
 
</script>
</head>
<body class="login_back">
<div id="wrap">
	<div id="content2">
		<div class="login">
			<h1 class="logo"><a href="#">
			<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/top/logo01.png" style="width:101px; height:20px;" id="logoLoc" alt="경북대학교" /></a></h1>
			<div class="loginArea">
				<div class="bg_top"></div>
				<div class="bg_cen">
					<form name="fm1" method="POST" accept-charset="utf-8" id="login-form">
            		<input type="hidden" id="output" name="output" value="json" />
            		<table class="fild_form" summary="로그인을 위한 사번과 비밀번호 입력테이블입니다.">
					<p class="inp01 mb15">
						<input type = "hidden" id = "companyid" name="companyid" value="1" >
						<span class="tit"><label for="p_num"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/login/t_num.gif" alt="사번" /></label></span>
						<span class="txt"><input type="text"  class="pw_num" id="empno" name="empno" onkeypress="login2();" /></span>
					</p>
					<p class="inp01">
						<span class="tit"><label for="p_pw"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/login/t_pw.gif" alt="비밀번호" /></label></span>
						<span class="txt"><input type="password"  class="pw_num" id="passwd" name="passwd" onkeypress="login2();"/></span>
					</p>
					<div class="btn_login"><a href="#"><img id="login" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/login/btn_login.gif" alt="로그인"  /></a></div>
					<div class="loginInfo">
						<p class="info">경북대학교의 총괄관리자를 위한 로그인 페이지입니다.</p>
						
					</div>
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