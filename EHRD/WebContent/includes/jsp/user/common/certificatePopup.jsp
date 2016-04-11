<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script type="text/javascript">
		
function printGrid(subNum,openNum,userId) {
    var pCmpltNum=""; //수료번호
	var pDvs=""; //소속
    var pName=""; //이름
    var pGradeNm=""; //직급
    var pSubNm=""; //과정명
    var pSdate=""; //시작일
    var pEdate=""; //종료일
    var pRecog=""; //인정시간
    var pTrainingCd="";//학습유형
    var pDate="";//날짜
	  
	$.ajax({
       type : 'POST',
       dataType : 'json',
       url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/sbjct/edu-certificate-print.do?output=json",
       data : {
           SUBJECT_NUM : subNum,
           OPEN_NUM : openNum,
           USERID : userId
       },
       success : function(response) {

           //로딩바 제거.
           
           
           if (response.items != null) {
				var item = response.items;
        	    pCmpltNum= item[0].CMPLT_NUM; //수료번호
        		pDvs=item[0].DVS_FULLNAME; //소속
        	    pName=item[0].NAME; //이름
        	    pGradeNm=item[0].GRADE_NM; //직급
        	    pSubNm=item[0].SUBJECT_NAME; //과정명
        	    pSdate=item[0].EDU_STIME; //시작일
        	    pEdate=item[0].EDU_ETIME; //종료일
        	    pRecog=item[0].RECOG_TIME_H; //인정시간
        	    pTrainingCd=item[0].TRAINING_CODE; //학습유형
        	    pDate = item[0].TIME; //현날짜

    		       win = window.open('', '', 'width=1000, height=800,scrollbars = yes');
    		       doc = win.document.open();
    		       var htmlStart =
    		           '<!DOCTYPE html>' +
    		           '<html>' +
    		           '<head>' +
    		           '<meta charset="utf-8" />' +
    		           '<title></title>' +
    		           '<style>' +
    		           '* {margin:0; padding:0;}' +
    		           'body {' +
    		           	'color: #565656;' +
    		           	'font-family: Dotum, 돋움, sans-serif;' +
    		           	'font-size: 12.5px;' +
    		           	'line-height: 17px;}' +
    		           /* Reset */
    		           'body,div,dl,dt,dd,ul,ol,li,p,' +
    		           'h1,h2,h3,h4,h5,h6,' +
    		           'form,fieldset,legend,input,label,button,textarea,select,' +
    		           'table,caption,thead,tfoot,tbody,tr,th,td,' +
    		           'address,img,span,em,strong,pre {margin:0; padding:0;}' +
    		           'html,body {width:100%; height:100%;}' +
    		           'table {border-collapse:collapse; border-spacing:0; width:100%;}' +
    		           'table td {word-break: break-all;}' +
    		           'legend,hr,caption {visibility:hidden; overflow:hidden; width:0; height:0; font-size:0; line-height:0;}' +
    		           'legend,hr {overflow: hidden; position:absolute; top:0; left:0;}' +
    		           'ul,ol,li {list-style: none;}' +
    		           /*------------------------------------------------------------------------------*/

    		           '.dwrap {padding:0px 0px 0px 0px;width:750px;}' +
    		           '.docWrap {width:585px;padding:60px 0px 0px 120px;}' +
    		           '.docWrap h1 {padding:100px 45px 140px 0;text-align:center;font-size:55px;letter-spacing:0.6em;font-family:Gungsuh;}' +
    		           '.num {font-family:Gungsuh;font-size:16px;font-weight:bold;}' +
    		           'p.num span {margin:0 5px 0 0px;font-weight:normal;}' +
    		           '.c_info {font-family:Gungsuh;font-size:22px;line-height:24px;}' +
    		           '.c_info li {margin-bottom:15px;}' +
    		           '.c_info li span {display:inline-block;*display:inline;*zoom:1;}' +
    		           '.c_info li span.tit {width:105px;}' +
    		           '.c_info li span.tit2 {width:195px;}' +
    		           '.c_info li span.txt {width:400px;vertical-align:middle;line-height:30px;padding-left:20px;}' +
    		           '.c_info li span.txt2 {width:px;vertical-align:middle;line-height:30px;padding-left:20px;}' +
    		           '.c_prove {width:80%;text-align:center;font-family:Gungsuh;font-size:22px;line-height:30px;margin-top:80px;}' +
    		           '.c_date {font-family:Gungsuh;font-size:18px;line-height:18px;margin:100px 0 50px 0;font-weight:bold;text-align:right;padding-right:75px;}' +
    		           '.c_confirm{margin:0 auto;padding-top:15px;padding-right:75px;padding-bottom:10px;text-align:center;font-family:Gungsuh;font-weight:bold;font-size:45px;line-height:45px;letter-spacing:-0.1em;}' +
    		           '.c_point{margin:50px 0 0px 0;text-align:center;font-family:Gungsuh;font-size:18px;font-weight:bold;padding-right:75px;}' +
    		        '</style>' +
    		        '</head>' +
    		        '<body>'+
    		        '<div class="dwrap">'+
    		    	'<div class="docWrap">'+
    		    		'<p class="num">제 <span>'+pCmpltNum+'</span>호</p>'+
    		    		'<h1>수료증</h1>'+
    		    		'<ul class="c_info">'+
    		    			'<li><span class="tit">소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속 :</span><span class="txt">'+pDvs+' </span></li>'+
    		    			'<li><span class="tit">직위[급] :</span><span class="txt">'+pGradeNm+'</span></li>'+
    		    			'<li><span class="tit">성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명 :</span><span class="txt">'+pName+'</span></li>'+
    		    			'<li><span class="tit">과&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;정 :</span><span class="txt">('+pTrainingCd+')'+pSubNm+'</span></li>'+
    		    			'<li><span class="tit">기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;간 :</span><span class="txt">'+pSdate+' ~ '+pEdate+'</span></li>'+
    		    			'<li><span class="tit2">상시학습인정시간 :</span><span class="txt2">'+pRecog+'시간</span></li>'+
    		    		'</ul>'+
    		    		'<div class="c_prove">위 사람은 경북대학교에서 소정의 교육과정을 마쳤으므로 이 증을 수여합니다.</div>'+
    		    		'<div class="c_date">'+pDate+'</div>'+
    		    		'<div class="c_confirm">경북대학교장</div>'+
    		    		'<p class="c_point">본 수료증은 교육수료 증명용도로만 사용가능합니다.</p>'+
    		    	'</div>'+
    		   		'</div>';
        		var htmlEnd =
        		        '</body>'+
        		        '</html>';
        		doc.write(htmlStart + htmlEnd);
        		doc.close();
        		win.print();
           }
           loadingClose();
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
	</script>
