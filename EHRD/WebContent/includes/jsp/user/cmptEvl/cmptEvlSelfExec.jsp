<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}
%>
<html decorator="subpage">
<head>
<title></title>
<style type="text/css">
.k-grid thead tr{
    height: 50px;
}
.k-grid tbody tr{
    height: 70px;
}
</style>
<%

kr.podosoft.ws.service.cam.action.CAMServiceAction action = (kr.podosoft.ws.service.cam.action.CAMServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
List list = action.getItems();
String head1 = "";
String head2 = "";
String head3 = "";
String head4 = "";
String head5 = "";
if(list!=null && list.size()>0){
	for(int i=0; i<list.size(); i++){
		Map map = (Map)list.get(i);
		if(map.get("VALUE").equals("1")){
			head1 = map.get("TEXT").toString();
		}else if(map.get("VALUE").equals("2")){
			head2 = map.get("TEXT").toString();
        }else if(map.get("VALUE").equals("3")){
        	head3 = map.get("TEXT").toString();
        }else if(map.get("VALUE").equals("4")){
        	head4 = map.get("TEXT").toString();
        }else if(map.get("VALUE").equals("5")){
        	head5 = map.get("TEXT").toString();
        }
	}
}

%>
<script type="text/javascript">

//현재 세션의 사용자 번호
var exUserid = '<%=action.getUser().getUserId()%>';
var RUNNUM = '<%=request.getParameter("RUN_NUM")%>';

	yepnope([{
        load: [ 
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js' 
        ],
        complete: function() {
            kendo.culture("ko-KR");    

            //로딩바 선언..
            loadingDefine();
            
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
                	var obj = dataSource_exedUserList.data()[0];
                	var grade = "";
                    if(obj.GRADE_NM){
                        grade = obj.GRADE_NM;
                    }
                    var name = "";
                    if(obj.NAME){
                        name = obj.NAME;
                    }
                    var empno = "";
                    if(obj.EMPNO){
                        empno = obj.EMPNO;
                    }
                    var jobNm = "";
                    if(obj.JOB_NM){
                        jobNm = obj.JOB_NM;
                    }
                    var leaderNm = "";
                    if(obj.LEADERSHIP_NM){
                        leaderNm = obj.LEADERSHIP_NM;
                    }
                    
                    $("#userExedInfo").text(name +" / "+grade+" / "+jobNm+" / "+leaderNm);
                }
            });
            
            var dataSource = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_self_exec_bhvlist.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){ 
                        return {  RUN_NUM: RUNNUM,  TG_USERID: exUserid };
                    }
                },
                schema: {
                    total: "totalItemCount",
                    data: "items",
                       model: {
                           fields: {
                               RNUM  : { type: "int" },
                               CMPNAME : {type:"string"},
                               CMPNUMBER: {type:"int"},
                               BHV_INDC_NUM: { type:"int" },
                               BHV_INDICATOR: { type:"string"},
                               B1:{ type:"string"},
                               B2:{ type:"string"},
                               B3:{ type:"string"},
                               B4:{ type:"string"},
                               B5:{ type:"string"},
                               SCORE:{ type:"int" }
                           }
                       }
                },
                pageSize: 500,
                serverPaging: false,
                serverFiltering: false,
                serverSorting: false
            });

            //grid 세팅
            $("#grid").empty();
            $("#grid").kendoGrid({
            	dataSource:dataSource,   
                    columns: [
                        {
                            field:"RNUM",
                            title: "번호",
                            width: 80,
                            filterable: true,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            editable:false
                        },
                        {
                            field:"CMPNAME",
                            title: "역량명",
                            width: 150,
                            filterable: true,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"} 
                        },
                        {
                            field:"BHV_INDICATOR",
                            title: "진단문항",
                            filterable: true,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:left"}
                        },
                        {
                        	field:"B5",
                            title: "<%=head5%>",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center; white-space: normal"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template:"<div style=\"text-align:center\"><input type=\"radio\" value=\"5\" name=\"bhv_#:BHV_INDC_NUM #\" id=\"bhv_#:BHV_INDC_NUM #\" onclick=\"selectRadioValue(this.id, #: BHV_INDC_NUM #)\" #: B5 # /></div>" 
                        },
                        {
                        	field:"B4",
                            title: "<%=head4%>",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center; white-space: normal"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template:"<div style=\"text-align:center\"><input type=\"radio\" value=\"4\" name=\"bhv_#:BHV_INDC_NUM #\" id=\"bhv_#:BHV_INDC_NUM #\" onclick=\"selectRadioValue(this.id, #: BHV_INDC_NUM #)\" #: B4 # /></div>" 
                        },
                        {
                        	field:"B3",
                            title: "<%=head3%>",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center; white-space: normal"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template:"<div style=\"text-align:center\"><input type=\"radio\" value=\"3\" name=\"bhv_#:BHV_INDC_NUM #\" id=\"bhv_#:BHV_INDC_NUM #\" onclick=\"selectRadioValue(this.id, #: BHV_INDC_NUM #)\" #: B3 # /></div>" 
                        },
                        {
                        	field:"B2",
                            title: "<%=head2%>",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center; white-space: normal"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template:"<div style=\"text-align:center\"><input type=\"radio\" value=\"2\" name=\"bhv_#:BHV_INDC_NUM #\" id=\"bhv_#:BHV_INDC_NUM #\" onclick=\"selectRadioValue(this.id, #: BHV_INDC_NUM #)\" #: B2 #  /></div>" 
                        },
                        {
                        	field:"B1",
                            title: "<%=head1%>",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center; white-space: normal"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template:"<div style=\"text-align:center\"><input type=\"radio\" value=\"1\" name=\"bhv_#:BHV_INDC_NUM #\" id=\"bhv_#:BHV_INDC_NUM #\" onclick=\"selectRadioValue(this.id, #: BHV_INDC_NUM #)\" #: B1 # /></div>" 
                        }
                    ],
                    pageable: false, //{ refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
                    filterable: false,
                    sortable: false,
                    editable: false,
                    height: 520,
                    dataBound: function(){
                    	selectRadioValue(null, null);
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

            
          //임시저장 클릭 시
            $("#tmpSaveBtn").bind("click",  function() {
                if(confirm("임시저장하시겠습니까?")){
                	var params = {
                            ANSWER_LIST :  $('#grid').data('kendoGrid').dataSource.data() 
                    };

                    //로딩바생성.
                    loadingOpen();

                    $.ajax({
                       type : 'POST',
                       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_save.do?output=json",
                       data : { item: kendo.stringify( params ), RUN_NUM : $("#RUN_NUM").val(), TG_USERID : $("#TG_USERID").val(), EVL_COMPLETE_FLAG : "N" },
                       complete : function( response ){
                           //로딩바 제거
                           loadingClose();
                           
                    	   if(response.responseText){
	                           var obj  = eval("(" + response.responseText + ")");
	                           if(obj.error){
	                                alert("ERROR=>"+obj.error.message);
	                            }else{
	                               if(obj.saveCount != 0){
		                               alert("저장되었습니다.");
		                           }else{
		                               alert("저장에 실패 하였습니다.");
		                           }
		                       }
                    	   }
                           if(event.preventDefault){
                               event.preventDefault();
                           } else {
                               event.returnValue = false;
                           }
                       },
                       error: function( xhr, ajaxOptions, thrownError){
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
                
                if(event.preventDefault){
                    event.preventDefault();
                } else {
                    event.returnValue = false;
                };
            });
          
            //완료버튼 클릭 시
            $("#saveBtn").bind("click",  function() {
            	if(evlChk()){
	                if(confirm("진단을 완료하시겠습니까?")){
	                	var params = {
	                			ANSWER_LIST :  $('#grid').data('kendoGrid').dataSource.data() 
	                    };

	                    //로딩바생성.
	                    loadingOpen();

	                    $.ajax({
	                       type : 'POST',
	                       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_save.do?output=json",
	                       data : { item: kendo.stringify( params ), RUN_NUM : $("#RUN_NUM").val(), EVL_COMPLETE_FLAG : "Y" },
	                       complete : function( response ){
	                           //로딩바 제거
	                           loadingClose();
	                           
	                           var obj  = eval("(" + response.responseText + ")");
                               if(obj.error){
                                   alert("ERROR=>"+obj.error.message);
                               }else{
		                           if(obj.saveCount != 0){
		                               alert("진단이 완료되었습니다.");
		                               location.href = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_run_pg.do";
		                           }else{
		                               alert("저장에 실패 하였습니다.");
		                           }                           
                               }
	                       },
	                       error: function( xhr, ajaxOptions, thrownError){                                
	                    	   if(xhr.status==403){
	                               alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
	                               sessionout();
	                           }else{
	                               alert('xrs.status = ' + xhr.status + '\n' + 
	                                       'thrown error = ' + thrownError + '\n' +
	                                       'xhr.statusText = '  + xhr.statusText );
	                           }
	                       },
	                       dataType : "json"
	                   });
	                }
            	}
            });
            
        }
    }]);   
	
	//진단완료 여부 체크
	function evlChk(){
		var array = $('#grid').data('kendoGrid').dataSource.data();
		if(array.length>0){
			if($("#tNum").text() != $("#eNum").text()){
				for(var i=0; i < array.length; i++){
		            if(array[i].SCORE==null || array[i].SCORE == 0){
		                alert((i+1)+"번 문항을 체크하지 않았습니다.");
                        
                        var scrollContentOffset = $("#grid").find("tbody").offset().top;
                        var selectContentOffset = $("#bhv_"+array[i].BHV_INDC_NUM).offset().top-220;
                        var distance = selectContentOffset - scrollContentOffset;

                        //animate our scroll
                        $("#grid").find(".k-grid-content").animate({
                            scrollTop: distance 
                        }, 400);
                        
		                break;
		            }
		        }
				return false;
			}else {
				return true
			}
		}else{
			alert("진단문항이 존재하지않습니다.");
			return false;
		}
	}
    
	//문항별 보기 선택 시..
    function selectRadioValue(radioButtoniD, bhvIndcNum){
    	var array = $('#grid').data('kendoGrid').dataSource.data();

        var res = $.grep(array, function (e) {
            return e.BHV_INDC_NUM == bhvIndcNum;
        });
        
        if(res!=null && res.length>0){
            res[0].SCORE = $(':radio[id="'+radioButtoniD+'"]:checked').val();
        }

		//체크된 문항수를 그리드 상단 안내문구에 적용..
		var checkCnt = 0;
		//다음 체크할 문항의 행동지표번호 
		var nextBhvNum = "";
        for(var i=0; i < array.length; i++){
        	if(array[i].SCORE!=null && array[i].SCORE != 0){
        		checkCnt++;
        		nextBhvNum = array[i].BHV_INDC_NUM;
        	}
        }
        $("#tNum").text(array.length);
        $("#eNum").text(checkCnt);
        
        if(bhvIndcNum!=null && bhvIndcNum>0){
        	//다음 체크할 문항 중앙 정렬...
            var scrollContentOffset = $("#grid").find("tbody").offset().top;
            var selectContentOffset = $("#bhv_"+bhvIndcNum).offset().top-160;
            var distance = selectContentOffset - scrollContentOffset;

            //animate our scroll
            $("#grid").find(".k-grid-content").animate({
                scrollTop: distance 
            }, 400);
        }else if(nextBhvNum!=null && nextBhvNum!=""){
        	var scrollContentOffset = $("#grid").find("tbody").offset().top;
            var selectContentOffset = $("#bhv_"+nextBhvNum).offset().top-160;
            var distance = selectContentOffset - scrollContentOffset;

            //animate our scroll
            $("#grid").find(".k-grid-content").animate({
                scrollTop: distance 
            }, 400);
        }
                
    }
    
    // 고객사정보 상세보기.
    function fn_evlExec(runNum){
    	alert(runNum);
    	
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
        <input type="hidden" name="RUN_NUM" id="RUN_NUM"  value="<%=request.getParameter("RUN_NUM")%>"/>
        <input type="hidden" name="TG_USERID" id="TG_USERID" value=""/>
        <input type="hidden" name="ANSWER_LIST" id="ANSWER_LIST" />
        <input type="hidden" name="EVL_COMPLETE_FLAG" id="EVL_COMPLETE_FLAG" />
    </form>

    <div class="container">
        <div id="cont_body">
         <div class="content">
             <div class="top_cont">
                <h3 class="tit01">진단실시</h3>
                <div class="d_step b02">
                    <strong>STEP02. 현수준진단</strong>
                    <div class="des">
                        역량진단의 2 단계인 현수준 진단입니다.<br/>
                        문항을 읽어 보고 피진단자들의 수준에 해당하는 척도에 체크를 하십시오.
                    </div>
                </div>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>역량진단&nbsp; &#62;</span>
                    <span>진단실시&nbsp; &#62;</span>
                    <span class="h">현수준진단</span>
                </div><!--//location-->
            </div>
             <div class="sub_cont">
                
                <h4 class="mt30">역량진단안내</h4>
                <dl class="Info02">
                    <dt class="fir"><span>진단명</span></dt>
                    <dd class="d01"><span id="runName">&nbsp;</span></dd>
                    <dt><span>진단유형</span></dt>
                    <dd class="d01"><span id="runDirType">&nbsp;</span></dd>
                    <dt class="fir"><span>진단실시기간</span></dt>
                    <dd class="d01"><span id="runPeriod">&nbsp;</span></dd>
                    <dt><span>피진단자</span></dt>
                    <dd class="d01"><span id="userExedInfo">&nbsp;</span></dd>
                </dl>
                <div class="answer_state">
                    <p>총 <span id="tNum" ></span>문항 중 <span id="eNum"></span>문항에 대해 응답하셨습니다.</p>
                </div>
                
                 <div id="example" class="mt10">
                    <div id="grid"></div>
                </div>
                <div class="btn_right">
                    <a href="javascript:void(0);"><img id="beforeStep" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_back.gif"" alt="이전" /></a>
                    <a href="javascript:void(0);"><img id="tmpSaveBtn" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_tempSave.gif"" alt="임시저장" /></a>
                    <a href="javascript:void(0); "><img id="saveBtn" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/btn/btn_end.gif"" alt="진단완료하기" /></a>
                </div>
                
             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div><!--//container-->
    
</body>
</html>