<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>CNP컨설팅</title>
    <link href="/styles/common/common.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        #login_wrap{width: 600px;  border: 1px solid #d5d5d5;  font-family: "BM_NANUMGOTHIC"; position: absolute; top:50%; left:50%; margin-left: -300px; margin-top: -146px;}
        #login_wrap .title_container{border-bottom: 3px solid #fa7c01; padding: 17px}
        #login_wrap .kcss_txt{ float: right; font-size: 14px; color:#272727; margin-top: 3px; width: 333px; border-left: 1px solid #c7c7c7; padding-left: 27px;}
        #login_wrap .kcss_txt > img{ float: left; margin-right: 8px; }
        #login_wrap .login_fild_container{padding: 21px 0 29px 0; width: 480px; margin: auto;}
        #login_wrap .login_fild_container .login_txt{text-align: center; line-height: 1.3em; margin-bottom:36px; color: #555555; font-size: 14px; padding-left: 20px;}
        #login_wrap table.fild_form th{text-align: right; padding-right: 10px; color: #555; font-size: 16px; font-weight: normal; font-size: 15px\0IE8+9;}
        #login_wrap table.fild_form td{padding: 1px 0;}
        #login_wrap .name_fild{border: 1px solid #e0e0e0; width:258px; height:20px; padding-left: 10px; margin-right: 3px;}
        #login_wrap .bottom_txt{text-align: center; padding-top: 1px; font-size: 13px; color:#222; }
    </style>
<script type="text/javascript">
	function loginEvnt() {
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
						$("form[name='fm1']").attr("action", "/accounts/sso/login.do").submit();
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

	yepnope([{
		load: [
			'/js/jquery/1.9.1/jquery.min.js'
		],
		complete: function() {
			$("#login").click(function() {
				loginEvnt();
			});
		}
	}]);
</script>
</head>
<body>
    <div id="login_wrap">
        <div class="title_container">
            <span class="kcss_txt"><img src="/images/icon_book.png" alt="Book 아이콘"/>CNP컨설팅 총괄관리자 페이지 입니다.</span><span><img src="/images/top/logo01.gif" alt="로고" width="100" height="22"/></span>
        </div>
        <div class="login_fild_container">
            <p class="login_txt">안전한 사이트 관리를 위해 사용자 로그인이 필요합니다.<br />
                    사번과 비밀번호 정보를 입력해 주세요.
            </p>
            <form name="fm1" method="POST" accept-charset="utf-8" id="login-form">
            <input type="hidden" id="output" name="output" value="json" />
            <table class="fild_form" summary="로그인을 위한 사번과 비밀번호 입력테이블입니다.">
                <colgroup>
                    <col width="100"/>
                    <col width="254"/>
                    <col width="73"/>
                </colgroup>
                <tr>
                    <th>사번</th>
                    <td><input type="text" id="empno" name="empno" value="1" class="name_fild" tabindex="1" onkeypress="login2();"/></td>
                    <td rowspan="3"><a href="#"><img id="login" src="/images/btn_system_login.png" alt="로그인" tabindex="4" onkeypress="login2();"/></a></td>
                </tr>
                <tr>
                    <th>비밀번호</th>
                    <td><input type="text" id="passwd" name="passwd" value="1" class="name_fild" maxlength="11" onkeypress="chkNumber(this);login2();" style="ime-mode:disabled" tabindex="2" /></td>
                </tr>
                <!-- <tr>
                    <th>이메일</th>
                    <td><input type="text" id="mail" name="mail" class="name_fild" onkeypress="login2();" tabindex="3" /></td>
                </tr> -->
            </table>
            </form>
            <!-- <p class="bottom_txt">* 핸드폰번호는 숫자만 입력해 주세요.</p> -->
        </div>
    </div>
</body>
</html>