<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>    
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>CNP 컨설팅 비밀번호 찾기 화면</title>
<link rel="stylesheet" href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/css/main.css" type="text/css"/>

<script type="text/javascript">

//개발서버 적용여부.. (운영서버와 개발서버 간의 로그인 절차가 dev값(Y / N)에 따라 달라짐. ) 
var dev = "N"; 

var domain = "<%=request.getServerName()%>";
domain = domain.replace("cnpsystem.co.kr","");
var subString = domain.indexOf(".");

var subDomain = domain.substring( 0, subString);

if(dev=="Y"){
    subDomain  = "cnp";
}

yepnope([{
    load: [ 
          '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.9.1/jquery.min.js'
    ],
      complete: function() {
    	  
			
			$.ajax({
			    type : 'POST',
			    async : false,
			    url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/dmInfo/getDomain.do",
			    data : { SUB_DOMAIN :  subDomain},
			    complete : function( response ){
			        var obj  = eval("(" + response.responseText + ")");
			        
			        if(obj.items != null){
			            $("#companyid").val(obj.items[0].COMPANYID);
			            //로고 세팅
			            $("#logoLoc").attr({
			                src: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/dmInfo/image_view.do?companyId="+obj.items[0].COMPANYID ,
			                alt: obj.items[0].COMPANYNAME
			            });
			             
			        }
			    },
			    error: function( xhr, ajaxOptions, thrownError){                                
			    },
			    dataType : "json"
			}); 
			
	      }
	}]);

function searchPwd(){
	var frm = document.frm;
	if(frm.empno.value==""){
		alert("사번을 입력해주세요.");
		frm.empno.fucus();
		return false;
	}
	if(frm.name.value==""){
        alert("이름을입력해주세요.");
        frm.name.fucus();
        return false;
    }
	if(frm.email.value==""){
        alert("이메일을입력해주세요.");
        frm.email.fucus();
        return false;
    }
    if(!f_checkEmail(frm.email.value) ){
        alert("이메일 형식이 올바르지 않습니다.");
        return false;
    }
    
    $.ajax({
        type : 'POST',
        async : false,
        url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/dmInfo/getPwdSearch.do",
        data : { empno :  frm.empno.value, name : frm.name.value, email: frm.email.value, companyid: frm.companyid.value},
        complete : function( response ){
            var obj  = eval("(" + response.responseText + ")");
            
            if(obj.error==null){
            	
	            if(obj.statement != null){
	            	if(obj.statement == "SUCCESS"){
	            		alert("임시비밀번호가 메일로 발송되었습니다.\n로그인 후 비밀번호를 변경해주세요.");
	            	}else if(obj.statement == "NoUserData"){
	            		alert("요청된 사번, 이름, 이메일의 사용자가 존재하지 않습니다.\n교육운영자에게 문의해주세요.");
	            	}else if(obj.statement == "NoFromMail"){
	            		alert("발신 정보가 존재하지 않습니다.\n교육운영자에게 문의해주세요.");
	            	}
	            }else{
	                alert("비밀번호 찾기 기능에 문제가 발생하였습니다.\n교육운영자에게 문의해주세요..");
	            }                           

            }else{
            	alert("error = "+ obj.error.message);
            }
        },
        error: function( xhr, ajaxOptions, thrownError){                                
        	alert('xrs.status = ' + xhr.status + '\n' + 
                    'thrown error = ' + thrownError + '\n' +
                    'xhr.statusText = '  + xhr.statusText + '\n' );
        },
        dataType : "json"
    }); 
}
</script>
</head>
<body class="login_back">
<form name="frm" id="frm" method="POST" >
<input type="hidden" id="companyid" name="companyid" />
<div id="wrap">
    <div id="content2">
        <div class="login">
            <h1 class="logo"><a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/"><img style="width:101px; height:20px;" id="logoLoc" alt="CNP컨설팅" /></a></h1>
            <div class="pwArea">
                <div class="bg_top"></div>
                <div class="bg_cen">
                    <h2>비밀번호 찾기</h2>
                    <ul>
                        <li>사번, 이름과 이메일을 입력하십시오</li>
                        <li>입력한 이메일로 임시 비밀 번호를 전송해 드리겠습니다.</li>
                        <li>메일 수신이 안되는 경우 운영자에게 문의하시기 바랍니다.</li>
                    </ul>
                    <div class="pw_wrap">
                        <p class="inp01 mb15">
                            <span class="tit"><label for="p_num"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/login/t_num.gif" alt="사번" /></label></span>
                            <span class="txt"><input type="text"  class="pw_num" id="empno" name="empno" /></span>
                        </p>
                        <p class="inp01 mb15">
                            <span class="tit"><label for="p_pw"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/login/t_nm.gif" alt="이름" /></label></span>
                            <span class="txt"><input type="text"  class="pw_num" id="name" name="name" /></span>
                        </p>
                        <p class="inp01">
                            <span class="tit"><label for="p_email"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/login/t_email.gif" alt="이메일" /></label></span>
                            <span class="txt"><input type="text"  class="pw_num" id="email" name="email" /></span>
                        </p>
                        <p class="btn_search"><a href="javascript:searchPwd();"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/login/btn_search.gif" alt="찾기" /></a></p>
                    </div>
                </div>
                <div class="bg_btm"></div>
            </div>
        </div>

    </div><!--//content2-->
    
</div>
</form>
</body>
</html>