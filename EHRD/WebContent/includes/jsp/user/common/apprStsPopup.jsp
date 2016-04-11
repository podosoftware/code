<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    
<script type="text/javascript">

    var reqCancelCompleteCallbackFunc;
    
	/*
	승인현황 조회
	param reqTypeCd 승인요청구분  
			1 - 경력개발계획
			2 - 교육생승인요청
			3 - 상시학습이력승인요청
			4 - 멘토링 생성요청
			5 - 멘토링 완료요청
			6 - 추천순위 승인요청
	param reqNum 승인요청번호
	param cancelBtnVisible 요청취소버튼 visible = Y/N
	*/
	function apprStsOpen(reqTypeCd, reqNum, cancelAbleYn){
		if(reqNum==undefined || reqNum == null || reqNum == ""){
			alert("승인요청번호가 존재하지 않습니다.");
			return false;
		}
		
		$("#reqNum").val(reqNum);

        if (!$("#apprSts-window").data("kendoWindow")) {
            $("#apprSts-window").kendoWindow({
                width : "338px",
                title : "승인 현황",
                modal: true,
                visible: false
            });
            //요청 취소버튼 클릭 시.
            
	        $("#apprStsCancelBtn").click(function(){
	            
	        	if(confirm("요청취소 하시겠습니까?")){ //승인요청건이 회수처리 됨..
	        		$.ajax({
	                    type : 'POST',
	                    url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cancel_appr_req.do?output=json",
	                    data : { 
	                    	REQ_TYPE_CD : reqTypeCd, REQ_NUM : $("#reqNum").val(), 
	                    },
	                    complete : function( response ){
	                        
	                        var obj = eval("(" + response.responseText + ")");
	                         if(obj.error){
	                             alert("ERROR=>"+obj.error.message);
	                         }else{
	                             if(obj.saveCount > 0){
	                                 alert("취소 되었습니다.");
	                                 $("#apprSts-window").data("kendoWindow").close();
	                                 
	                                 //승인요청건 취소 완료 후 각 업무단에서 처리할 함수 callback..
	                                 if(reqCancelCompleteCallbackFunc){
	                                	 reqCancelCompleteCallbackFunc($("#reqNum").val());
	                                 }
	                                 
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
	                        };
	                    },
	                    dataType : "json"
	                });
	        	}
	        });
	        
            //승인현황 확인버튼 클릭 시..
            $("#apprStsOkBtn").click(function(){
                $("#apprSts-window").data("kendoWindow").close();
            });
        }
        
        //요청취소버튼 활성화여부 
        if( cancelAbleYn && cancelAbleYn ==  "Y"){
        	//$("#apprStsCancelBtn").attr("style", "display:;");
        	$("#apprStsCancelBtn").show();
        } else {
        	$("#apprStsCancelBtn").hide();
        }
        
		//승인현황 초기화.
		//$("#apprStsStepUl").html("");
		
		//승인현황 데이터소스
		var dataSource_apprStsList = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_appr_sts_list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return { REQ_NUM : $("#reqNum").val() };
                }
            },
            schema: {
                data: "items",
                model: {
                    fields: {
                    	REQ_LINE_SEQ : { type: "number" },
                    	APPR_USERID : { type: "number" },
                    	REQ_STS_CD: { type: "String" },
                    	REQ_STS_NM: { type: "String" },
                    	REQ_STS_DTIME : { type: "String" },
                    	REQ_REMARKS : { type: "string" },
                    	APPR_USERNM : { type: "string" }, 
                    	GRADE_NM : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false});
		
		//승인현황 조회.
		dataSource_apprStsList.read();
		
		//승인현황 데이터소스 변경시..
		dataSource_apprStsList.bind("change", function(){
			var apprStsHtml = "";
			$.each(dataSource_apprStsList.data(), function(i,e){
				var time = "";
				if(e.REQ_STS_DTIME){
					time = e.REQ_STS_DTIME;
				}else{
					time = "-";
				}
				
				var innerClass = "";
				if(i==0){
					innerClass = "green";
					
					//첫번째 승인자가 미처리상태인 경우 요청취소 버튼 활성화
					//if(e.REQ_STS_CD=="1"){
					//    $("#apprStsCancelBtn").attr("style", "display:;");
					//}
				}else if(i==1){
                    innerClass = "pink";
				}else{
                    innerClass = "purple";
                }
				
				var stsNm = "";
				if(e.REQ_STS_NM){
					stsNm = e.REQ_STS_NM;
				}
				
				var remarks = "";
				if(e.REQ_REMARKS){
					remarks = e.REQ_REMARKS;
				}
				var gradeNm = "";
				if(e.GRADE_NM){
					gradeNm = "("+e.GRADE_NM+")";
				}

				if(i>0){
					apprStsHtml+="<li class=\"arrow\"><img alt=\"다음단계\" src=\"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_arrow04.png\"></a></li>";
				}
				apprStsHtml+="<li>";
				apprStsHtml+="    <ul class=\"inner "+innerClass+"\">";
				apprStsHtml+="        <li class=\"fir\">";
				apprStsHtml+="            <p>"+(i+1)+"차승인자 "+e.APPR_DIV_NM+"</p>";
				apprStsHtml+="            <p class=\"tit\">"+e.APPR_USERNM+gradeNm+"</p>";
				//apprStsHtml+="            <p>"+time+"</p>";
				apprStsHtml+="        </li>";
				apprStsHtml+="        <li class=\"sec\">";
				apprStsHtml+="            <div class=\"comm\">";
				apprStsHtml+="                처리상태: "+stsNm+"<br/>";
				apprStsHtml+="            <p>처리일시: "+time+"</p>";
				apprStsHtml+="                <!--<textarea class=\"k-textbox comment\" cols=\"5\" rows=\"2\" readOnly >"+remarks+"</textarea>-->";
				apprStsHtml+="            </div>";
				apprStsHtml+="            <!--<div class=\"a_state green\">승인 요청 취소</div>-->";
				apprStsHtml+="        </li>";
				apprStsHtml+="    </ul>";
				apprStsHtml+="</li>";

			});
			
			$("#apprStsStepUl").html(apprStsHtml);
		});
		
		$("#apprSts-window").data("kendoWindow").center();
		$("#apprSts-window").data("kendoWindow").open();
	}
	
</script>
<style scoped>
	#apprSts-window .k-window-title {font-size:13px;font-weight:bold;}
	#apprSts-window .k-content {padding:28px !important}/*팝업 내부 콘텐츠 간격*/
</style>
<!--팝업 코딩 시작-->
<div id="apprSts-window" style="display: none;">
<input type="hidden" name="reqNum" id="reqNum" />

    <ul class="pop_step" id="apprStsStepUl" style="margin:20px 0 0 0;">
        <li>
            <ul class="inner green">
                <li class="fir">
                    <p>&nbsp;</p>
                    <p class="tit">&nbsp;</p>
                    <p>&nbsp;</p>
                </li>
                <li class="sec">
                    <div class="comm">
                        &nbsp;<br/>
                       <!--  <textarea class="k-textbox comment" cols="5" rows="2"></textarea> -->
                    </div>
                    <!--<div class="a_state green">승인 요청 취소</div>-->
                </li>
            </ul>
        </li>
        <li class="arrow"><img alt="다음단계" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_arrow04.png"></a></li>
        <li>
            <ul class="inner pink">
                <li class="fir">
                    <p>&nbsp;</p>
                    <p class="tit">&nbsp;</p>
                    <p>&nbsp;</p>
                </li>
                <li class="sec">
                    <div class="comm">
                        &nbsp;<br/>
                        <!-- <textarea class="k-textbox comment" cols="5" rows="2"></textarea> -->
                    </div>
                    <!-- <div class="a_state pink">승인 요청 취소</div>-->
                </li>
            </ul>
        </li>
        <li class="arrow"><img alt="다음단계" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_arrow04.png"></a></li>
        <li>
            <ul class="inner purple">
                <li class="fir">
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                </li>
                <li class="sec">
                    <div class="comm">
                        &nbsp;<br/>
                      <!--   <textarea class="k-textbox comment" cols="5" rows="2"></textarea> -->
                    </div>
                    <!--<div class="a_state purple">승인 요청 취소</div>-->
                </li>
            </ul>
        </li>
    </ul>
    <div class="btn_center mb20">
        <button id="apprStsCancelBtn" class="k-button k-primary" style="width:110px; display: none;">요청취소</button>
        <button id="apprStsOkBtn" class="k-button" style="width:55px;">확인</button>
    </div>
</div><!--//apprSts-window-->
