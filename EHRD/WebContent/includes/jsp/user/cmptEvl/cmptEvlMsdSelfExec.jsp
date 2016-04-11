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
.k-grid tbody tr{
    height: 70px;
}

</style>
<%
String runNum = request.getAttribute("RUN_NUM")+"";
String tgUserid = request.getAttribute("TG_USERID")+"";
String f_page = request.getParameter("f_page")+"";

kr.podosoft.ws.service.ca.action.ajax.CAServiceAction action = (kr.podosoft.ws.service.ca.action.ajax.CAServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
List list = action.getItems();
Map map = (Map)list.get(0);

List list1 = action.getItems1();
Map map1 = (Map)list1.get(0);

%>
<script type="text/javascript">
 var f_page = "<%=f_page%>";
 
	yepnope([{
        load: [ 
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js' 
        ],
        complete: function() {
            kendo.culture("ko-KR");    
            
            var dataSource = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"/service/ca/cmpt_evl_self_exec_bhvlist.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){ 
                        return {  RUN_NUM: <%=runNum%>,  TG_USERID: <%=tgUserid%> };
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
            
            //데이터 패치 시 상단 응답 문구 적용..
            dataSource.fetch(function(){
            	selectRadioValue(null, null);
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
                            attributes:{"class":"table-cell", style:"text-align:center"} ,
                            template: "<a href=\"javascript:void();\" onclick=\"javascript:fn_cmptView(#:CMPNUMBER#);\" >#:CMPNAME#</a>"
                        },
                        {
                            field:"BHV_INDICATOR",
                            title: "평가문항",
                            filterable: true,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:left"}
                        },
                        {
                        	field:"B5",
                            title: "<%=map1.get("SC")%>",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center;overflow: visible; white-space: normal;"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template:"<div style=\"text-align:center\"><input type=\"radio\" value=\"5\" name=\"bhv_#:BHV_INDC_NUM #\" id=\"bhv_#:BHV_INDC_NUM #\" onclick=\"selectRadioValue(this.id, #: RNUM #)\" #: B5 # /></div>" 
                        },
                        {
                        	field:"B4",
                            title: "<%=map1.get("AC")%>",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center;overflow: visible; white-space: normal;"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template:"<div style=\"text-align:center\"><input type=\"radio\" value=\"4\" name=\"bhv_#:BHV_INDC_NUM #\" id=\"bhv_#:BHV_INDC_NUM #\" onclick=\"selectRadioValue(this.id, #: RNUM #)\" #: B4 # /></div>" 
                        },
                        {
                        	field:"B3",
                            title: "<%=map1.get("BC")%>",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center;overflow: visible; white-space: normal;"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template:"<div style=\"text-align:center\"><input type=\"radio\" value=\"3\" name=\"bhv_#:BHV_INDC_NUM #\" id=\"bhv_#:BHV_INDC_NUM #\" onclick=\"selectRadioValue(this.id, #: RNUM #)\" #: B3 # /></div>" 
                        },
                        {
                        	field:"B2",
                            title: "<%=map1.get("CC")%>",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center;overflow: visible; white-space: normal;"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template:"<div style=\"text-align:center\"><input type=\"radio\" value=\"2\" name=\"bhv_#:BHV_INDC_NUM #\" id=\"bhv_#:BHV_INDC_NUM #\" onclick=\"selectRadioValue(this.id, #: RNUM #)\" #: B2 #  /></div>" 
                        },
                        {
                        	field:"B1",
                            title: "<%=map1.get("DC")%>",
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center;overflow: visible; white-space: normal;"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
                            template:"<div style=\"text-align:center\"><input type=\"radio\" value=\"1\" name=\"bhv_#:BHV_INDC_NUM #\" id=\"bhv_#:BHV_INDC_NUM #\" onclick=\"selectRadioValue(this.id, #: RNUM #)\" #: B1 # /></div>" 
                        }
                    ],
                    pageable: false, //{ refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
                    filterable: false,
                    sortable: false,
                    editable: false,
                    height: 470
                });
            
            
            //취소버튼 클릭 시
            $("#cancelBtn").bind("click",  function() {
            	if(confirm("평가를 취소하시겠습니까?")){
            		if(f_page == "E"){
                        document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_msd_exed_pg.do";
                    }else{
                        document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_msd_run_pg.do";
                    }
                    document.frm.submit();
            	}
            });
          //임시저장 클릭 시
            $("#tmpSaveBtn").bind("click",  function() {
                if(confirm("임시저장하시겠습니까?")){
                	var params = {
                            ANSWER_LIST :  $('#grid').data('kendoGrid').dataSource.data() 
                    };

                    $.ajax({
                       type : 'POST',
                       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_save.do?output=json",
                       data : { item: kendo.stringify( params ), RUN_NUM : $("#RUN_NUM").val(), TG_USERID : $("#TG_USERID").val(), EVL_COMPLETE_FLAG : "N" },
                       complete : function( response ){
                    	   if(response.responseText){
	                           var obj  = eval("(" + response.responseText + ")");
	                           if(obj!=null){
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
                    	   alert('xrs.status = ' + xhr.status + '\n' + 
                    	            'thrown error = ' + thrownError + '\n' +
                    	            'xhr.statusText = '  + xhr.statusText + '\n' );
                    	   
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
	                if(confirm("평가를 완료하시겠습니까?")){
	                	var params = {
	                			ANSWER_LIST :  $('#grid').data('kendoGrid').dataSource.data() 
	                    };

	                    $.ajax({
	                       type : 'POST',
	                       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_save.do?output=json",
	                       data : { item: kendo.stringify( params ), RUN_NUM : $("#RUN_NUM").val(), TG_USERID : $("#TG_USERID").val(), EVL_COMPLETE_FLAG : "Y" },
	                       complete : function( response ){
	                           var obj  = eval("(" + response.responseText + ")");
	                           if(obj.saveCount != 0){
	                               alert("평가가 완료되었습니다.");
	                               if(f_page == "R"){
	                                   document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_msd_run_pg.do";
	                               }else{
	                            	   document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_msd_exed_pg.do";
	                               }
                                   document.frm.submit();
	                           }else{
	                               alert("저장에 실패 하였습니다.");
	                           }                           
	                       },
	                       error: function( xhr, ajaxOptions, thrownError){                                
	                       },
	                       dataType : "json"
	                   });
	                }
            	}
            });
          
          
          //피평가자 정보
            var exedUserDataSource = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"/service/ca/cmpt_evl_user_exed_info.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {
                            TG_USERID: <%=tgUserid%>
                        };
                    }
                },
                schema: {
                    data: "items1",
                    model: {
                        fields: {
                            LEADERSHIP_NM : { type: "string" },
                            NAME : { type: "string" },
                            EMPNO : { type: "string" },
                            DVS_NAME : { type: "string" },
                            JOB_NM : { type: "string" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false
            });
            //피평가자 정보 fetch 시..
            exedUserDataSource.fetch(function(){
                var view = exedUserDataSource.view();
                if(view.length>0){
                    var strVal = "";
                    if(view[0].NAME!=null){
                        strVal = view[0].NAME;
                    }
                    if(view[0].EMPNO!=null){
                        strVal = strVal+" / "+view[0].EMPNO;
                    }
                    if(view[0].JOB_NM!=null){
                        strVal = strVal+" / "+view[0].JOB_NM;
                    }
                    if(view[0].LEADERSHIP_NM!=null){
                        strVal = strVal+" / "+view[0].LEADERSHIP_NM;
                    }
                    $("#evlUserExed").text(strVal);
                }
            });
            
            
            //역량정의 조회 팝업
            if( !$("#cmpt-window").data("kendoWindow") ){
                $("#cmpt-window").kendoWindow({
                    width:"400px",
                    height: "250px",
                    resizable : true,
                    title : "역량정의",
                    modal: false,
                    visible: false
                });
             }
            
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
	
	//평가완료 여부 체크
	function evlChk(){
		var array = $('#grid').data('kendoGrid').dataSource.data();
		if(array.length>0){
			if($("#tNum").text() != $("#eNum").text()){
				for(var i=0; i < array.length; i++){
		            if(array[i].SCORE==null || array[i].SCORE == 0){
		                alert((i+1)+"번 문항을 체크하지 않았습니다.");
                        
                        var scrollContentOffset = $("#grid").find("tbody").offset().top;
                        var selectContentOffset = $("#bhv_"+array[i].BHV_INDC_NUM).offset().top-28;
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
			alert("평가문항이 존재하지않습니다.");
			return false;
		}
	}
    
	//문항별 보기 선택 시..
    function selectRadioValue(radioButtoniD, rows){
    	var array = $('#grid').data('kendoGrid').dataSource.data();
    	
		if(radioButtoniD!=null && rows!=null){
	        array[rows-1].SCORE = $(':radio[id="'+radioButtoniD+'"]:checked').val();
		}
		
		//체크된 문항수를 그리드 상단 안내문구에 적용..
		var checkCnt = 0;
        for(var i=0; i < array.length; i++){
        	if(array[i].SCORE!=null && array[i].SCORE != 0){
        		checkCnt++;
        	}
        }
        $("#tNum").text(array.length);
        $("#eNum").text(checkCnt);
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
    

    //역량정의 조회 팝업
    function fn_cmptView(cmpnumber){
        var array = $('#grid').data('kendoGrid').dataSource.data();
        
        var res = $.grep(array, function (e) {
            return e.CMPNUMBER == cmpnumber;
        });
        
        $("#cmptNm").text("역량 : "+res[0].CMPNAME);
        $("#cmptDf").text("정의 : "+res[0].CMPDEFINITION);

        
        $('#cmpt-window').data("kendoWindow").center();      
        $("#cmpt-window").data("kendoWindow").open();
        
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
        <input type="hidden" name="RUN_NUM" id="RUN_NUM"  value="<%=request.getAttribute("RUN_NUM")%>"/>
        <input type="hidden" name="TG_USERID" id="TG_USERID" value="<%=request.getAttribute("TG_USERID")%>"/>
        <input type="hidden" name="ANSWER_LIST" id="ANSWER_LIST" />
        <input type="hidden" name="EVL_COMPLETE_FLAG" id="EVL_COMPLETE_FLAG" />
    </form>
        <!-- 본문영역 -->
        <div id="content">
            <div class="cont_body">
                <div class="title">역량 평가 실시</div>
                <div class="table_tin">
                    <ul>
                        <li class="line">평가 년도 : <%=map.get("YYYY")%>년
                        <li>평가명 : <%=map.get("RUN_NAME")%> </li>
                    </ul>
                    <ul>
                        <li class="line">평가 기간 : <%=map.get("RUN_START")%> ~ <%=map.get("RUN_END")%></li>
                        <li>피 평가자 : <b><span id="evlUserExed"></span></b></li>
                    </ul>
                </div>
                <div class="top"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_top02.gif" alt=""/></div>
                <div class="middle1">총 <span id="tNum" ></span> 문항 중 <span id="eNum"></span> 문항에 대해 응답하셨습니다.</div>
                <div class="bottom"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom02.gif" alt=""/></div>
                <div class="table_zone">
                    <div id="grid" ></div>
                </div>
                
                <div style="float:right;display:table; padding-top:10px;">
                    <button id="tmpSaveBtn" class="k-button" ><span class="k-icon k-i-plus"></span>임시저장</button>&nbsp;
                    <button id="saveBtn" class="k-button" ><span class="k-icon k-i-plus"></span>완료</button>&nbsp;
                    <button id="cancelBtn" class="k-button" ><span class="k-icon k-i-cancel"></span>취소</button>
                </div>
            </div>
            <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/>
        </div>
        <!-- 본문영역 끝 -->

    <!-- 역량정의 팝업 -->
    <div id="cmpt-window" style="display:none;">
        <div>
            <span id="cmptNm">역량: </span>
        </div>
        <div>
            <span id="cmptDf">정의: </span>
        </div>
    </div>
    
</body>
</html>