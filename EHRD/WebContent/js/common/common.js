/**
 * COMMON 공통 유틸(밸류데이션 등)
 */

/*HTML 벨류데이션(입력시 숫자만 허용,입력글자수 제한)
 * 사용방법 *
 * input type="text" onkeypress="return numbersonly(event, false, this, 13, 59)" style='ime-mode:disabled'/>
 * 13은 입력글자 제한수  style='ime-mode:disabled'로 한글 막기는 부가 컨트롤
 */
function numbersonly(e, decimal, obj, len, max) { 
    var key; 
    var keychar; 
 
   if (window.event) { 
      key = window.event.keyCode; 
   } else if (e) { 
      key = e.which; 
   } else { 
      return true; 
   } 
 
   keychar = String.fromCharCode(key);
 
   if ((key == null) || (key == 0) || (key == 8) || (key == 9) || (key == 13) || (key == 27)) { 
      return true;
   } else if (obj.value.length >= len){  //숫자제한부분
      return false;
   } else if ((("0123456789").indexOf(keychar) > -1)) { 
	   if(max && Number(obj.value+keychar) > max){
		   return false;
	   }else{
		   return true;    
	   }
   } else if (decimal && (keychar == ".")) { 
	   if(max && Number(obj.value+keychar) > max){
		   return false;
	   }else{
		   return true;    
	   } 
   } else {
      return false;
  }
 
}

//숫자만 입력되도록 처리
function chkNum(obj){
	var word = obj.value ;
	var str = "1234567890";

	for(i = 0 ; i < word.length ; i++ ){
		if( str.indexOf(word.charAt(i)) < 0 ){
			alert("숫자만 입력하십시오.");
			obj.value = "" ;
			obj.focus();
			return false ;
		}
	}
	return true;
}

//숫자형태인지 체크
function isNumber(obj){
	if(isNaN(obj.value)){
		alert("숫자 형식이 올바르지 않습니다.");
		obj.value = "" ;
		obj.focus();
		return false;
	}
	return true;
}
//첫글자 공백 불가 처리
function chkNull(obj){
	var word = obj.value ;
	var str = /[\s]/g ;
	if(word.length>0){
		if( str.test( word.substring(0, 1) ) == true ){
			alert('첫글자는 공백을 입력할 수 없습니다.');
			obj.value = "" ;
			obj.focus();
			return false;
		}
	}
	return true;
}

//모든공백 불가 처리
function chkNoNull(obj){
	var word = obj.value ;
	var str = /[\s]/g ;
	if( str.test( word ) == true ){
		alert('공백을 입력할 수 없습니다.');
		obj.value = "" ;
		obj.focus();
		return false;
	} 
	return true;
}

//영문여부 체크
function isEng(obj) {
	var str = obj.value;
    for(var i=0;i<str.length;i++){                 
        achar = str.charCodeAt(i);                  
        if( achar > 255 ){ 
        	alert('한글을 사용할 수 없습니다.');
			obj.value = "" ;
			obj.focus();
			return false;
        } 
    }
} 

//날짜입력시 validation 체크 후 yyyy-mm-dd형식으로 반환
//년도범위 체크(2014-12-33경우 에러발생), 문자열 체크, 2014-03-31 입력가능
function ex_date(str, obj){
	var dateVal = $("#"+obj).val();
	var yy,mm,dd;
	var isNum = /^[0-9]+$/;
	var errCode = 0;
	var endDay = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	
	 if (!dateVal) {
		 return false; //입력값이 없는 경우는 Pass
	 }
	 //Validation Logic for Date..
	 yy = dateVal.substr(0,4);
	 mm = dateVal.substr(5,2);
	 dd = dateVal.substr(8,2);
	  
	 if (yy%1000 != 0 && yy%4 == 0) endDay[1] = 29;   // 윤년
     if (dd > endDay[mm-1] || dd < 1) errCode = 1;        // 날짜 체크
     if (mm < 1 || mm > 12) errCode = 1;          // 월 체크
     if (mm%1 != 0 || yy%1 != 0 || dd%1 != 0) errCode = 1;   // 정수 체크
	 
	 dateVal = yy+"-"+mm+"-"+dd;    
	 if (errCode == 1 || dateVal.length != 10){
		 alert("정확한 날짜("+str+")를 입력해 주십시오.\n현재입력값:"+$("#"+obj).val()+"(날짜형식:YYYY-MM-DD) ");
	  $("#"+obj).val("");
	  return false;
	 }
	 $("#"+obj).val(dateVal);
	 return true;
}


//년월 입력시 validation 체크 후 yyyy-mm형식으로 반환
//년도범위 체크(2014-13경우 에러발생), 문자열 체크, 2014-03 입력가능
function ex_month(str, obj){
	var dateVal = $("#"+obj).val();
	var yy,mm;
	var isNum = /^[0-9]+$/;
	var errCode = 0;
	
	 if (!dateVal) {
		 return false; //입력값이 없는 경우는 Pass
	 }
	 //Validation Logic for Date..
	 yy = dateVal.substr(0,4);
	 mm = dateVal.substr(5,2);
	  
   if (mm < 1 || mm > 12) errCode = 1;          // 월 체크
   if (mm%1 != 0 || yy%1 != 0) errCode = 1;   // 정수 체크
	 
	 dateVal = yy+"-"+mm;    
	 if (errCode == 1 || dateVal.length != 7){
		 alert("정확한 날짜("+str+")를 입력해 주십시오.\n현재입력값:"+$("#"+obj).val()+"(날짜형식:YYYY-MM) ");
	  $("#"+obj).val("");
	  return false;
	 }
	 $("#"+obj).val(dateVal);
	 return true;
}

/*-------------------------------------------------------------------------
f_checkEmail(strEmail)
Spec     : 이메일형식 체크
Argument : string
Return   : Boolean
Example  : if(!f_checkEmail( $("#email").val()) ) 
-------------------------------------------------------------------------*/
function f_checkEmail(strEmail) {
	var arrMatch = strEmail.match(/^(\".*\"|[A-Za-z0-9_-]([A-Za-z0-9_-]|[\+\.])*)@(\[\d{1,3}(\.\d{1,3}){3}]|[A-Za-z0-9][A-Za-z0-9_-]*(\.[A-Za-z0-9][A-Za-z0-9_-]*)+)$/);
	if (arrMatch == null) {
		return false;
	}
	return true;
}

/*-------------------------------------------------------------------------
chkPhone(str, objPhone)
Spec     : 전화번호 형식 체크
Argument : string, object
Return   : Boolean
Example  : if(!chkPhone("관리자연락처", "phone")){
-------------------------------------------------------------------------*/
function chkPhone(str, obj)
{
 var reTel = /^0(2|31|33|32|42|43|41|53|54|55|52|51|63|61|62|64)[0-9][\d]{1,3}[\d]{4}$/;
 var rePhone = /^0(11|16|17|18|19|10)[0-9][\d]{1,3}[\d]{4}$/;

 if($("#"+obj).val()!="")
 {
  if(!($("#"+obj).val().match(reTel) || $("#"+obj).val().match(rePhone)))
  {
   alert(str+' 형식이 잘못되었습니다. (xxxxxxxxxxx)');
   $("#"+obj).focus();
   return false;
  }
 }
 return true;
}

/*---------------------------------------------------
string 'null' 제거 함수
----------------------------------------------------*/
function removeNullStr(str){
	if(str!=null){
		str = str.replace("null", "");
	}
	return str;
}


/*---------------------------------------------------
 * 브라우저 체크 - ie는 버전, 그 이외는 -1 리턴됨.
 ----------------------------------------------------*/
function getInternetExplorerVersion() {    
    var rv = -1; // Return value assumes failure.    
    if (navigator.appName == 'Microsoft Internet Explorer') {        
         var ua = navigator.userAgent;        
         var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");        
         if (re.exec(ua) != null)            
             rv = parseFloat(RegExp.$1);    
        }    
    return rv; 
}


/*---------------------------------------------------
 * 반올림
 ----------------------------------------------------*/
function round(num,ja) { 
    ja=Math.pow(10, ja);
    return Math.round(num * ja) / ja; 
} 
