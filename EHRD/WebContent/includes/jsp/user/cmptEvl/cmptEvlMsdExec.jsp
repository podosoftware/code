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
    <style>
    .wrapper {text-align: center !important;}
    .balSlider {width: 820px !important;margin-left:-100px !important;}
    .balSlider .k-slider-selection {width:820px !important;display: none !important;}
    .k-slider-horizontal .k-draghandle {top:-6px !important;width:20px !important;height:20px !important;border:none !important;border-radius:0 !important;box-shadow:none !important;}
    .k-slider-horizontal .k-draghandle img {border:0 !important;}
    .k-slider-selection {box-shadow:none !important;}
    .k-draghandle {background:url("<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/handle.png") no-repeat !important;}
    .k-button {margin: 0 2px 0 2px !important;}
    .k-tick .k-first {display:none !important;}
    
    </style>
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
			
            //로딩바 선언..
            loadingDefine();
            
            //역량진단 보기목록 조회(공통코드)
            var dataSource_example = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "C115" };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            VALUE : { type: "String" },
                            TEXT : { type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
            dataSource_example.fetch(function(){
            	if(dataSource_example.data().length>0){
            		$.each(dataSource_example.data(), function(i,e){
            			if(this.VALUE == "1"){
            				$("#p_exam1").html(this.TEXT);
            			}else if(this.VALUE == "2"){
            				$("#p_exam2").html(this.TEXT);
                        }else if(this.VALUE == "3"){
                        	$("#p_exam3").html(this.TEXT);
                        }else if(this.VALUE == "4"){
                        	$("#p_exam4").html(this.TEXT);
                        }else if(this.VALUE == "5"){
                        	$("#p_exam5").html(this.TEXT);
                        }
            		});
            	}
            });

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
            
            //피진단자 조회..
            var dataSource_exedUserList = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_exed_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  RUN_NUM : RUNNUM };
                    }
                },
                schema: {
                    data: "items"
                },
                serverFiltering: false,
                serverSorting: false});
            
            //피진단자  방향별로 구분하여 화면 세팅
            dataSource_exedUserList.fetch(function(){
                if(dataSource_exedUserList.data().length>0){
                    var r1 = ""; //자가
                    var r2 = ""; //상사
                    var r3 = ""; //동료
                    var r4 = ""; //부하
                    var r1_cnt = 0; //자가 갯수
                    var r2_cnt = 0; //상사 갯수
                    var r3_cnt = 0; //동료 갯수
                    var r4_cnt = 0; //부하 갯수
                    
                    $.each(dataSource_exedUserList.data(), function(i, e) {
                    	var grade = "";
                    	if(this.GRADE_NM){
                    		grade = this.GRADE_NM;
                    	}
                        if(this.RUNDIRECTION_CD == "1"){
                            r1 += "<li><p>"+this.NAME+"</p><p>"+grade+"</p></li>";
                            r1_cnt += 1;
                        }else if(this.RUNDIRECTION_CD == "2"){
                            r2 += "<li><p>"+this.NAME+"</p><p>"+grade+"</p></li>";
                            r2_cnt += 1;
                        }else if(this.RUNDIRECTION_CD == "3"){
                            r3 += "<li><p>"+this.NAME+"</p><p>"+grade+"</p></li>";
                            r3_cnt += 1;
                        }else if(this.RUNDIRECTION_CD == "4"){
                            r4 += "<li><p>"+this.NAME+"</p><p>"+grade+"</p></li>";
                            r4_cnt += 1;
                        }
                    });
                    $("#user_g02").html(r1);
                    $("#user_g02").attr("style", "width:"+(70*r1_cnt)+"px;");
                    $("#user_g04").html(r2);
                    $("#user_g04").attr("style", "width:"+(70*r2_cnt)+"px;");
                    $("#user_g03").html(r3);
                    $("#user_g03").attr("style", "width:"+(70*r3_cnt)+"px;");
                    $("#user_g01").html(r4);
                    $("#user_g01").attr("style", "width:"+(70*r4_cnt)+"px;");
                    
                }
            });
            

            //피진단자 모두의 진단문항 조회.. --> 문항조회시 진단시작일시가 같이 업데이트됨...
            var dataSource_bhvList = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_msd_bhv_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  RUN_NUM : RUNNUM };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                        	CMPNUMBER : { type: "number" },
                        	BHV_INDC_NUM : { type: "number" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
            dataSource_bhvList.fetch(function(){
                //총문항 
                $("#tNum").text(dataSource_bhvList.data().length);
                setDiagno();
            });
            
            //피진단자의 문항 응답정보 조회
            var dataSource_bhvResponse= new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_msd_bhv_response_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  RUN_NUM : RUNNUM };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            CMPNUMBER : { type: "number" },
                            BHV_INDC_NUM : { type: "number" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
            dataSource_bhvResponse.fetch(function(){
                var posNum = 0;
                var isScoreNull = false;
                
                $.each(dataSource_bhvResponse.data(), function(i, e) {
                    if(this.SCORE==null || this.SCORE=="" || this.SCORE=="0"){
                        //최초 화면 로딩 후 진단해야할 문항 찾아서 화면 세팅..
                        $("#currBhvIndcNum").val(this.RNUM-1);
                        
                        //점수가 없는 문항을 찾아냄... 
                        isScoreNull = true;
                        //console.log(i+'===========================');
                        
                        setDiagno();
                        
                        //피진단자가 많아서 스크롤이 생긴 경우 진단해야하는 피진단자를 중앙정렬 처리..
                        var scrollContentOffset = $("#userWrap").offset().top;
                        if($("#section"+this.USERID_EXED)){
                        	var selectContentOffset = $("#section"+this.USERID_EXED).offset().top-160;
                            var distance = selectContentOffset - scrollContentOffset;
                            $(".q_wrap").animate({
                                scrollTop: distance 
                            }, 400);
                        }
                        
                        return false;
                    }else{
                        posNum = this.RNUM;
                        //console.log('=== '+posNum+'===========================');
                    }
                    
                });
                
                if(!isScoreNull){
                    //모든 항목에 점수가 부여된 경우 마지막페이지 보여줌...
                    $("#currBhvIndcNum").val( Number(posNum)-1 );
                    setDiagno();
                }
            });
            
            //문항 번호에 맞는 화면 세팅..
            var setDiagno = function(e){
                if(dataSource_bhvList.data() && dataSource_bhvList.data().length>0 && dataSource_bhvResponse.data() && dataSource_bhvResponse.data().length>0){
                    var index = $("#currBhvIndcNum").val();
                    $("#eNum").text(Number(index)+1);
                    //if(dataSource_bhvList.data()[index].RNUM!=null){
                        $("#p_bhv_indicator").html( dataSource_bhvList.data()[index].RNUM+". "+dataSource_bhvList.data()[index].BHV_INDICATOR );
                    //}else{
                    //    $("#p_bhv_indicator").html( dataSource_bhvList.data()[index].BHV_INDICATOR );
                    //}
                    
                    //역량번호, 행동지표번호 HIDDEN에 세팅.
                    $("#CMPNUMBER").val(dataSource_bhvList.data()[index].CMPNUMBER);
                    $("#BHV_INDC_NUM").val(dataSource_bhvList.data()[index].BHV_INDC_NUM);
                    
                    //응답정보 FILTERING
                    dataSource_bhvResponse.filter({
                        logic : "and",
                        filters : [
                         {field : "CMPNUMBER", operator: "eq", value: Number(dataSource_bhvList.data()[index].CMPNUMBER) },
                         {field : "BHV_INDC_NUM", operator: "eq", value: Number(dataSource_bhvList.data()[index].BHV_INDC_NUM) }
                        ]
                    });
                    
                    
                    var userListHtml = "";
                    $(".user_val").remove();
                    $.each(dataSource_bhvResponse.view(), function(i,e){
                    	if(this.CMPNUMBER == 999999999 && this.BHV_INDC_NUM == 999999999){
                    		//부하직원에게 의견작성하기..
                    		userListHtml = "<dl class=\"user_val\">";
                    		userListHtml+= "    <dt>";
                            if(this.RUNDIRECTION_CD == "1"){
                                userListHtml += "    <div class=\"b02\">";
                            }else if(this.RUNDIRECTION_CD == "2"){
                                userListHtml += "    <div class=\"b04\">";
                            }else if(this.RUNDIRECTION_CD == "3"){
                                userListHtml += "    <div class=\"b03\">";
                            }else if(this.RUNDIRECTION_CD == "4"){
                                userListHtml += "    <div class=\"b01\">";
                            }
                            userListHtml += "        <span>"+this.NAME+"</span></div>";
                            userListHtml += "    </dt>";
                            userListHtml += "    <dd id=\"section"+this.USERID_EXED+"\">";
                            var opn = "";
                            if(this.SCORE){
                                opn = this.SCORE;
                            }
                            userListHtml += "        <textarea id=\"ta"+this.USERID_EXED+"\" rows=\"3\" cols=\"5\" class=\"textarea_input\">"+opn+"</textarea>";
                            userListHtml += "    </dd>";
                            userListHtml += "</dl>";

                            $("#userWrap").append(userListHtml);
                            
                            //진단 의견 입력 시 데이터소스 값 변경..
                            $("#ta"+this.USERID_EXED).bind("keyup", function(){
                                var userExed = this.id.replace("ta", "");
                                var arr = $.grep(dataSource_bhvResponse.view(), function (e) {
                                    return e.CMPNUMBER == $("#CMPNUMBER").val() && e.BHV_INDC_NUM == $("#BHV_INDC_NUM").val() && e.USERID_EXED == userExed;
                                });
                            	arr[0].SCORE = this.value;
                            });
                            
                    	}else{
                    		//진단하기..
	                    	userListHtml  = "<dl class=\"user_val\">";
	                    	userListHtml+= "    <dt>";
	                   		if(this.RUNDIRECTION_CD == "1"){
	                   			userListHtml += "    <div class=\"b02\"><span>"+this.NAME+"</span></div>";
	                        }else if(this.RUNDIRECTION_CD == "2"){
	                        	userListHtml += "    <div class=\"b04\"><span>"+this.NAME+"</span></div>";
	                        }else if(this.RUNDIRECTION_CD == "3"){
	                        	userListHtml += "    <div class=\"b03\"><span>"+this.NAME+"</span></div>";
	                        }else if(this.RUNDIRECTION_CD == "4"){
	                        	userListHtml += "    <div class=\"b01\"><span>"+this.NAME+"</span></div>";
	                        }
	                    	userListHtml += "    </dt>";
	                    	userListHtml += "    <dd>";
	                    	userListHtml += "        <div id=\"section"+this.USERID_EXED+"\" class=\"demo-section k-header\" style=\"width:100%;margin-top:11px !important;margin-bottom:10px !important;\">";
	                    	userListHtml += "            <div class=\"wrapper\">";
	                    	userListHtml += "                <input id=\"slider_"+this.USERID_EXED+"\" class=\"balSlider\" style=\"width:760px\" value=\""+this.SCORE+"\" />";
	                    	userListHtml += "            </div>";
	                    	userListHtml += "        </div>";
	                    	userListHtml += "    </dd>";
	                    	userListHtml += "</dl>";
                        
	                    	$("#userWrap").append(userListHtml);
	                    	
	                    	var slider = $("#slider_"+this.USERID_EXED).kendoSlider({
	                    		increaseButtonTitle: "Right",
	                            decreaseButtonTitle: "Left",
	                            min:0,
	                            max: 5,
	                            smallStep: 1,
	                            largeStep: 1,
	                            showButtons: false,
	                            tooltip:{enabled:false},
	                            change:function(){
	                            	var score = this.value();
	                            	var userExed = this.element[0].id.replace("slider_", "");
	                            	var res = $.grep(dataSource_bhvResponse.view(), function (e) {
	                                    return e.CMPNUMBER == $("#CMPNUMBER").val() && e.BHV_INDC_NUM == $("#BHV_INDC_NUM").val() && e.USERID_EXED == userExed;
	                                });
	                            	//점수 세팅..
	                            	res[0].SCORE = score;

	                            	//다음 문항으로 중앙정렬...
	                                var scrollContentOffset = $("#userWrap").offset().top;
	                                var selectContentOffset = $("#section"+userExed).offset().top-60;
	                                var distance = selectContentOffset - scrollContentOffset;

	                                $(".q_wrap").animate({
	                                    scrollTop: distance 
	                                }, 400);
	                                
	                                //모든 피진단자에 점수 체크 시 자동 다음문항으로 이동
	                                var isEnd = true;
	                                $.each(dataSource_bhvResponse.view(), function(i,e){
	                                    if(this.SCORE==null || this.SCORE == 0){
	                                    	isEnd = false;
	                                    	return false;
	                                    }
	                                });
	                                if(isEnd){
	                                	//약간의 시간을 두고 다음문항으로 넘어가야 슬라이더의 점수 포인터가 찍힌후 넘어 감..
	                                	setTimeout(function(){
	                                		$("#nextBhv").click();
	                                	}, 300);
	                                	isEnd = false;
	                                }
	                            }
	                    	}).data("kendoSlider");
	                    	
                        }
                    });
                    
                    
                }
            };
           
            
            //이전문항 버튼 클릭
            $("#beforeBhv").click(function(){
                var curNum = $("#currBhvIndcNum").val();
                //alert(Number(curNum));
                if(Number(curNum)>0){
                    $("#currBhvIndcNum").val(Number(curNum)-1);
                    setDiagno();
                }else{
                	alert("첫문항입니다.");
                }
                
            });
            
            //다음문항 버튼 클릭
            $("#nextBhv").click(function(){
                var curNum = $("#currBhvIndcNum").val();
                //alert(Number(curNum));
                var isnext = true;
                if(Number(curNum) < (Number($("#tNum").text())-1)){
                	$.each(dataSource_bhvResponse.view(), function(i,e){
                		if(this.SCORE==null || this.SCORE == 0){
                			alert(this.NAME+"님의 점수가 입력되지 않았습니다.");
                			
                            //입력해야하는 문항으로 이동
                            var scrollContentOffset = $("#userWrap").offset().top;
                            var selectContentOffset = $("#section"+this.USERID_EXED).offset().top-160; // -160 
                            var distance = selectContentOffset - scrollContentOffset;

                            $(".q_wrap").animate({
                                scrollTop: distance 
                            }, 400);
                            
                            isnext = false;
                            return false;
                		}
                	});
                	
                	if(isnext){
                		$("#currBhvIndcNum").val(Number(curNum)+1);
                        setDiagno();
                        
                        $(".q_wrap").animate({
                            scrollTop: 0 
                        }, 0);
                	}
                    
                }else{
                	alert("마지막 문항입니다.");
                }
            });
		
            //이전화면으로 이동.
            $("#beforeStep").click(function(){
            	if(confirm("이전화면으로 이동하시겠습니까?")){
            		$("#RUN_NUM").val(RUNNUM);
                    document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_basic_info.do";
                    document.frm.submit();
            	}
            });
          
            //임시저장 
            $("#tmpSaveBtn").click(function(){
            	if(confirm("진단내용을 임시저장하시겠습니까?")){
            		
            		var params = {
                            ANSWER_LIST :  dataSource_bhvResponse.data() 
                    };

                    //로딩바생성.
                    loadingOpen();
                    
                    $.ajax({
                       type : 'POST',
                       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_save.do?output=json",
                       data : { item: kendo.stringify( params ), RUN_NUM : RUNNUM, EVL_COMPLETE_FLAG : "N" },
                       complete : function( response ){
                    	   //로딩바 제거
                    	   loadingClose();
                    	   
                    	   var obj = eval("(" + response.responseText + ")");
                            if(obj.error){
                                alert("ERROR=>"+obj.error.message);
                            }else{
                                if(obj.saveCount > 0){
                                    alert("저장되었습니다.");
                                }else{
                                    alert("저장에 실패 하였습니다.");
                                }
                            }
                
                           if(event.preventDefault){
                               event.preventDefault();
                           } else {
                               event.returnValue = false;
                           }
                       },
                       error: function( xhr, ajaxOptions, thrownError){
                    	    //로딩바 제거
                           loadingClose();
                           
                           if(xhr.status==403){
                               alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                               sessionout();
                           }else{
                               alert('xrs.status = ' + xhr.status + '\n' + 
                                       'thrown error = ' + thrownError + '\n' +
                                       'xhr.statusText = '  + xhr.statusText );
                           }
                           
                           if(event.preventDefault){
                               event.preventDefault();
                           } else {
                               event.returnValue = false;
                           };
                       },
                       dataType : "json"
                   });
                    
            		
            	}
            });
            

            //진단완료하기
            $("#cmpltSaveBtn").click(function(){
            	var isCmplt = true;
            	var array = dataSource_bhvResponse.data();
                if(array.length>0){
                    for(var i=0; i < array.length; i++){
                        if( (array[i].BHV_INDC_NUM!=999999999 && ( array[i].SCORE==null || array[i].SCORE == 0) ) || ( array[i].BHV_INDC_NUM==999999999 && (array[i].SCORE==null || array[i].SCORE=="") ) ){
                        	var msg = "";
                        	if(array[i].RNUM){
                        		msg = array[i].RNUM+"번 문항의 "+array[i].NAME+"님이 입력되지 않았습니다.";
                                $("#currBhvIndcNum").val(array[i].RNUM-1);
                        	}else{
                        		msg = array[i].NAME+"님의 의견을 작성해주세요.";
                                $("#currBhvIndcNum").val( Number($("#tNum").text())-1 );
                        	}
                        	
                            alert( msg );
                            isCmplt = false;;
                            setDiagno();
                            
                            //피진단자가 많아서 스크롤이 생긴 경우 진단해야하는 피진단자를 중앙정렬 처리..
                            var scrollContentOffset = $("#userWrap").offset().top;
                            var selectContentOffset = $("#section"+array[i].USERID_EXED).offset().top-160;
                            var distance = selectContentOffset - scrollContentOffset;

                            $(".q_wrap").animate({
                                scrollTop: distance 
                            }, 400);
                                                        
                            break;  
                        }
                    }
                }else{
                    alert("응답정보가 존재하지않습니다.");
                    return false;
                }
                
                if(!isCmplt){
                	return false;
                }
            	
                if(confirm("진단을 완료하시겠습니까?")){
                    var params = {
                            ANSWER_LIST :  dataSource_bhvResponse.data() 
                    };

                    //로딩바생성.
                    loadingOpen();
                    
                    $.ajax({
                       type : 'POST',
                       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_save.do?output=json",
                       data : { item: kendo.stringify( params ), RUN_NUM : RUNNUM, EVL_COMPLETE_FLAG : "Y" },
                       complete : function( response ){

                           //로딩바 제거
                          loadingClose();
                           
                           
                           var obj = eval("(" + response.responseText + ")");
                            if(obj.error){
                                alert("ERROR=>"+obj.error.message);
                            }else{
                                if(obj.saveCount > 0){
                                	
                                    alert("진단이 완료되었습니다.");
                                    document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_run_pg.do";
                                    document.frm.submit();

                                   if(event.preventDefault){
                                       event.preventDefault();
                                   } else {
                                       event.returnValue = false;
                                   }
                                }else{
                                    alert("실패 하였습니다.");
                                }
                            }

                       },
                       error: function( xhr, ajaxOptions, thrownError){

                           //로딩바 제거
                          loadingClose();
                           
                          if(xhr.status==403){
                              alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                              sessionout();
                          }else{
                              alert('xrs.status = ' + xhr.status + '\n' + 
                                      'thrown error = ' + thrownError + '\n' +
                                      'xhr.statusText = '  + xhr.statusText );
                          }
                          
                           if(event.preventDefault){
                               event.preventDefault();
                           } else {
                               event.returnValue = false;
                           }
                       },
                       dataType : "json"
                   });
                    
                    
                }
            });
            
            //세션 out 안되도록 일정 시간마다 서버 호출.. 3분마다 
            setInterval(function(){
            	$.ajax({
                    type : 'POST',
                    url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_continue_func.do?output=json",
                    data : { },
                    complete : function( response ){
                    },
                    error: function( xhr, ajaxOptions, thrownError){
                    },
                    dataType : "json"
                });
            }, 180000);

		}
	}]);       

  //부하직원 의견 입력 function
    function setOpnValue(userid){
        var array = $('#targetConfirmGrid').data('kendoGrid').dataSource.data();            
        
        var res = $.grep(array, function (e) {
            return e.USERID == userid;
        });
        
        res[0].FAIL_REASON = $("#reason_"+userid).val();
    }
  
  
</script>

</head>
<body>
	<form id="frm" name="frm"  method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_msd_self_exec.do">
	    <input type="hidden" name="currBhvIndcNum" id="currBhvIndcNum" />
	    <input type="hidden" name="RUN_NUM" id="RUN_NUM" />
	    <input type="hidden" name="USERID_EXED" id="USERID_EXED" />
	    <input type="hidden" name="RUNDIRECTION_CD" id="RUNDIRECTION_CD" />
        <input type="hidden" name="CMPNUMBER" id="CMPNUMBER" />
        <input type="hidden" name="BHV_INDC_NUM" id="BHV_INDC_NUM" />
        <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" />
        <input type="hidden" name="f_page" id="f_page" />
	</form>
	
    <div class="container">
        <div id="cont_body">
         <div class="content">
             <div class="top_cont mb30">
                <h3 class="tit01">진단실시</h3>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>역량진단&nbsp; &#62;</span>
                    <span>진단실시&nbsp; &#62;</span>
                    <span class="h">다면진단</span>
                </div><!--//location-->
            </div>
             <div class="sub_cont">
                
                <div class="d_question">
                    <div class="d_info">
                        <dl>
                            <dt>역량진단안내</dt>
                            <dd><span id="runName">&nbsp;</span></dd>
                            <dd><span id="runPeriod">&nbsp;</span></dd>
                            <dd><span id="runDirType">&nbsp;</span></dd>
                        </dl>
        
                        <table class="table_type01 mt15">
                            <caption>피진단자 안내</caption>
                            <colgroup>
                                <col style="width:35px"/>
                                <col style="width:*">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th colspan="2">피진단자 </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th>부하</th>
                                    <td>
                                        <div class="u_wrap">
                                            <ul class="user g01" id="user_g01">
<!--                                                 <li> -->
<!--                                                     <p>유저</p> -->
<!--                                                     <p>2350</p> -->
<!--                                                 </li> -->
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>본인</th>
                                    <td>
                                        <div class="u_wrap">
                                            <ul class="user g02" id="user_g02">
<!--                                                 <li> -->
<!--                                                     <p>유저</p> -->
<!--                                                     <p>2350</p> -->
<!--                                                 </li> -->
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>동료</th>
                                    <td>
                                        <div class="u_wrap">
                                            <ul class="user g03" id="user_g03">
<!--                                                 <li> -->
<!--                                                     <p>유저</p> -->
<!--                                                     <p>2350</p> -->
<!--                                                 </li> -->
                                            </ul>
                                        </div>  
                                    </td>
                                </tr>
                                <tr>
                                    <th>상사</th>
                                    <td>
                                        <div class="u_wrap">
                                            <ul class="user g04" id="user_g04">
<!--                                                 <li> -->
<!--                                                     <p>유저</p> -->
<!--                                                     <p>2350</p> -->
<!--                                                 </li> -->
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div><!--//d_info-->
                    <div class="diag_Area">
                        <h4 class="tit">Question <span class="txt">다음의 문항을 읽고 전단지에 맞는 레벨을 선택하여 체크해주시기 바랍니다</span><span class="state"><span id="eNum"></span>/<span id="tNum" ></span></span></h4>
                        <div class="ques_txt">
                            <div class="bg_top"></div>
                            <div class="bg_cen">
                                <p id="p_bhv_indicator"></p>
                            </div>
                            <div class="bg_btm"></div>
                        </div>
                        
                        <div class="ques_Area">
                            <dl class="top">
                                <dt>진단자<span>diagnostician</span></dt>
                                <dd>
                                    <ol>
                                        <li class="fir p01">
                                            <p><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/1.png" alt="점수 척도를 나타내는 숫자 1"/></p>
                                            <p class="txt" id="p_exam1"></p>
                                        </li>
                                        <li class="p02">
                                            <p><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/2.png" alt="점수 척도를 나타내는 숫자 2"/></p>
                                            <p class="txt" id="p_exam2"></p>
                                        </li>
                                        <li class="p03">
                                            <p><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/3.png" alt="점수 척도를 나타내는 숫자 3"/></p>
                                            <p class="txt" id="p_exam3"></p>
                                        </li>
                                        <li class="p04">
                                            <p><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/4.png" alt="점수 척도를 나타내는 숫자 4"/></p>
                                            <p class="txt" id="p_exam4"></p>
                                        </li>
                                        <li class="last p05">
                                            <p><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/5.png" alt="점수 척도를 나타내는 숫자 5"/></p>
                                            <p class="txt" id="p_exam5"></p>
                                        </li>
                                    </ol>
                                </dd>
                            </dl>
                            <div class="q_wrap">
                                <div id="userWrap">
                                
                                </div>
                            </div>
                            
                        </div><!--//ques_Area-->
                        <div class="btn_right">
                            <!-- <div class="b_left"> -->
                            <div style="position: absolute; left: 442px;" >
                                <a href="javascript:void(0);"><img id="beforeBhv" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_pre_q.gif"" alt="이전문항" /></a>
                                <a href="javascript:void(0);"><img id="nextBhv" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_next_q.gif"" alt="다음문항" /></a>
                            </div>
                            <a href="javascript:void(0);"><img id="beforeStep" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_back.gif"" alt="이전" /></a>
                            <a href="javascript:void(0);"><img id="tmpSaveBtn" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_tempSave.gif"" alt="임시저장" /></a>
                            <a href="javascript:void(0);"><img id="cmpltSaveBtn" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_end.gif"" alt="진단완료하기" /></a>
                        </div>
                    </div><!--//diag_Area-->
                </div><!--//d_question-->
                
                
                
             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div><!--//container-->


            <script id="rowTemplate" type="text/x-kendo-tmpl">
                <dl class="user_val">
                    <dt class="b01">
                        <span>#:NAME#<br>#:GRADE_NM#</span>
                    </dt>
                </dl>
                <dl>
                    <dd>
                        <div class="demo-section k-header" style="width: 760px;">
                            <div class="wrapper">
                                <input class="balSlider#:USERID_EXED#" value="#:SCORE#" />
                            </div>
                        </div>
                    </dd>
                </dl>
            </script>
</body>

</html>