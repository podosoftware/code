<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
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
<style>
<!--
    #my-file-gird{
        min-height: 150px;              
        width : 600px;
    }
    
    #my-file-upload{ 
        width : 300px;
    }
    .k-dropzone {
        border: 2px dashed #d4d4d4;
        background-color: #f7f7f7;
        position: relative; 
        text-align: center;
        padding: 34px 34px 40px 10px;
        -webkit-border-radius: 18px;
        -moz-border-radius: 18px;
        border-radius: 18px;
        margin: 20px 0 0 0;
    }       
    
    .k-upload.k-header {
        border-color: transparent;
    }
    
    .k-button.k-upload-button {
        min-width: 120px;
        float: right;
    }               
-->
</style>
<head>

<%

kr.podosoft.ws.service.kpi.action.ajax.KPIServiceAction action = (kr.podosoft.ws.service.kpi.action.ajax.KPIServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
List items = action.getItems();
List items1 = action.getItems1();
List items2 = action.getItems2();
long companyid = action.getUser().getCompanyId();

String tgUserid = request.getParameter("TG_USERID");
String tgInfo = "";

Map runMap = new HashMap();
if(items!=null && items.size()>0){
	runMap = (Map)items.get(0);
}
Map tgMap = new HashMap();
if(items2!=null && items2.size()>0){
	tgMap = (Map)items2.get(0);
	if(tgMap.get("DVS_NAME")!=null){
		tgInfo = (String)tgMap.get("DVS_NAME");
	}
	if(tgMap.get("NAME")!=null){
        tgInfo += " / "+(String)tgMap.get("NAME");
    }
    if(tgMap.get("JOB_NM")!=null){
        tgInfo += " / "+(String)tgMap.get("JOB_NM");
    }
    if(tgMap.get("LEADERSHIP_NM")!=null){
        tgInfo += " / "+(String)tgMap.get("LEADERSHIP_NM");
    }
}


%>
<script type="text/javascript">	
var runListDataSource;
var gridDataSource;
var runClass;
var currentStsCode;

    yepnope([{
        load: [ 
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js' ,     
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js' 
        ],
		complete: function() {
			kendo.culture("ko-KR");               

			$("#TG_USERID").val(<%=tgUserid%>);

            //탭 생성...
            var tabArr = [];
            tabArr[0] = "";
            var tabStrip = $("#tabstrip").kendoTabStrip({
            	select: function(e){
            		var x = e.item;
                    var index= $(x).index();
            		//alert($(e.item).index());
            		filterData(tabArr[index]);
            	}
            }).data("kendoTabStrip");
            
            tabStrip.append({
                text:"전체"
            });
            
            <% 
            if(items1!=null && items1.size()>0){
                for(int i=0; i<items1.size(); i++){
                    Map map = (Map)items1.get(i);
            %>
            tabArr[<%=i+1%>] = "<%=map.get("VALUE")%>";
            tabStrip.append({
                text:"<%=map.get("TEXT")%>"
            });
            <%
                }
            }
            %>
            
           openWindow();
           getCurrentSts();

           tabStrip.select(0);
           
			
		}
	}]);       
    
    function filterData(kpiType){
        var gridDatasource = $("#grid").data('kendoGrid').dataSource;
        
        if(kpiType==null || kpiType == ""){
            gridDatasource.filter({});
        }else{
            gridDatasource.filter({
                "field":"KPI_TYPE",
                "operator":"eq",
                "value":kpiType
            });
        }
    }
    
    //성과평가 현상태 조회
    function getCurrentSts(){
    	$("#otcEvlSts").text("");
    	$.ajax({
            type : 'POST',
            url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/otc_evl_user_sts.do?output=json",
            data : { RUN_NUM : <%=runMap.get("RUN_NUM") %>, TG_USERID : <%=tgUserid%> },
            complete : function( response ){
            	try{
	            		
	                var obj  = eval("(" + response.responseText + ")");
	                
	                currentStsCode = obj.statement;
	                //alert(obj.statement);
	                
	                $("#delKpiLabel").hide();
	                var sts = "";
	                //평가 현상태 조회
	                if(obj.statement == "1"){
	                	sts ="부서원이 작성한 전기설적, 당기목표와 우선순위(1~10까지)를 확인 및 수정 후 목표승인을 합니다";
	                	$("#apprReqBtn").show();
	                	$("#apprReqLabel").text("목표승인");
	                	$("#tgRtBtn").show();
	                	$("#saveCmplBtn").hide();
	                	$("#regStateChangeBtn").hide();
	                	$("#delKpiLabel").show();
	                }else if(obj.statement == "2"){
	                    sts = "검토 버튼을 클릭하여 부서원이 등록한 실적을 확인 및 수정 후 실적승인을 합니다";
	                    $("#apprReqBtn").show();
	                    $("#apprReqLabel").text("실적승인");
	                    $("#tgRtBtn").hide();
	                    $("#saveCmplBtn").show();
                        $("#regStateChangeBtn").hide();
	                }else if(obj.statement == "3"){
	                	sts = "부서원이 목표를 설정하고 있습니다.";
	                	$("#apprReqBtn").hide();
	                	$("#tgRtBtn").hide();
	                    $("#saveCmplBtn").hide();
                        $("#regStateChangeBtn").hide();
	                }else if(obj.statement == "4"){
	                	sts = "부서원이 실적을 등록하고 있습니다.";
	                	$("#apprReqBtn").hide();
	                	$("#tgRtBtn").hide();
	                    $("#saveCmplBtn").hide();
                        $("#regStateChangeBtn").hide();
	                }else if(obj.statement == "5"){
	                	sts = "평가를 완료하였습니다.";
	                	$("#apprReqBtn").hide();
	                    $("#tgRtBtn").hide();
	                    $("#saveCmplBtn").hide();
                        $("#regStateChangeBtn").show();
	                }else{
	                	$("#apprReqBtn").hide();
	                    $("#tgRtBtn").hide();
	                    $("#saveCmplBtn").hide();
                        $("#regStateChangeBtn").hide();
	                }
	                
	                $("#otcEvlSts").text(sts);
            	}catch(e){
            		alert(e);
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
    
    function openWindow(){
    	
        $("#grid").empty();
        $("#grid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/otc_dept_user_map_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){
                         return { RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val() };
                    }
                },
                schema: {
                     data: "items",
                     model: {
                         fields: {
                                KPI_NO : { type: "number" },
                                KPI_TYPE_NM: { type:"string"},
                                KPI_NM : { type: "string" },
                                BEF_PRF: { type: "number"},
                                NOW_TARG: { type: "number" },
                                NOW_PRF: { type: "number" },
                                PRIO: { type: "number" }, 
                                WEI: { type: "number" },
                                EVLCLS:{ type: "string" },
                                DIFF:{ type: "number" }
                                
                            }
                     }
                },
                serverPaging: false, serverFiltering: false, serverSorting: false
            },
            columns: [
                {
                    field:"REG_TYPE_CD", title: "등록유형", width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template: function (dataItem){
                        if(dataItem.REG_TYPE_CD=="1"){
                            return "회사";
                        }else if(dataItem.REG_TYPE_CD=="2"){
                            return "개인";
                        }
                    }
                },
                { field:"KPI_TYPE_NM", title: "지표유형", width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left"} 
                },
                { field:"KPI_NM", title: "지표명", width:250, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left;  text-decoration: underline;"} ,
                    template:function(data){
                    	var kn = data.KPI_NM+" ("+data.UNIT_NM+")";
                    	if(data.CMPT_EVL_CMPL_FLAG == "2"){
                            if(data.QCNT==0){
                                //실적승인요청건이 없을경우..
                            }else{
                            	//실적승인요청건이 있을경우.. 하이라이트 처리.
                            	kn = "<b>"+data.KPI_NM+" ("+data.UNIT_NM+")</b>";
                            }
                        }
                    	return "<a href='javascript:void();' onclick='javascript:fn_ArithInfo("+data.KPI_NO+"); return false;' >"+kn+"</a>";
                    }
                    //template: 
                    //template: function(dataItem){
                    //    return dataItem.KPI_NM+" ("+dataItem.UNIT_NM+")";
                    //}
                },
                { field:"MEA_EVL_CYC_NM", title: "관리주기", width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                { field:"BEF_PRF", title: "전기실적", width: 100,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template: "<input type=\"text\" id=\"bef_prf_#:RNUM#\" name=\"bef_prf_#:RNUM#\" value=\"# if(BEF_PRF != null){##:BEF_PRF## }#\" onkeyup=\" setKpiValue('bef_prf', #:RNUM#, this)\" class=\"k-input input_95\" style=\"text-align:center; \" />"
                 },
                { field:"NOW_TARG", title: "당기목표",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template: "<input type=\"text\" id=\"now_targ_#:RNUM#\" name=\"now_targ_#:RNUM#\" value=\"# if(NOW_TARG != null){##:NOW_TARG## }#\" onkeyup=\" setKpiValue('now_targ', #:RNUM#, this)\" class=\"k-input input_95\" style=\"text-align:center; \" />"
                },
                { field:"NOW_PRF", title: "당기실적",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}
                },
                { field:"PRIO", title: "우선<br>순위",  width:60, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template: "<input type=\"text\" id=\"prio_#:RNUM#\" name=\"prio_#:RNUM#\" value=\"# if(PRIO != null){##:PRIO## }#\" onkeyup=\" setKpiValue('prio', #:RNUM#, this)\" class=\"k-input input_95\" maxChar=\"2\" style=\"text-align:center; \" />"
                },/*
                { field:"DIFF", title: "난이도",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },*/
                { field:"SCLS_ST", title: "S등급<br><%=runMap.get("SCLASS")%>",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template: function(dataItem){
                        if(dataItem.SCLS_ST!=null){
                            return dataItem.SCLS_ST+"이상";
                        }else{
                            return "";
                        }
                    }
                },
                { field:"ACLS_ST", title: "A등급<br><%=runMap.get("ACLASS")%>",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}  ,
                    template: function(dataItem){
                        var acls = "";
                        if(dataItem.ACLS_ST!=null){
                            acls = dataItem.ACLS_ST+"이상";
                        }
                        if(dataItem.ACLS_ED!=null){
                            acls += "<br>"+dataItem.ACLS_ED+"미만";
                        }
                        return acls;
                    }
                },
                { field:"BCLS_ST", title: "B등급<br><%=runMap.get("BCLASS")%>",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}  ,
                    template: function(dataItem){
                        var bcls = "";
                        if(dataItem.BCLS_ST!=null){
                            bcls = dataItem.BCLS_ST+"이상";
                        }
                        if(dataItem.BCLS_ED!=null){
                            bcls += "<br>"+dataItem.BCLS_ED+"미만";
                        }
                        return bcls;
                    }
                },
                { field:"CCLS_ST", title: "C등급<br><%=runMap.get("CCLASS")%>",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}  ,
                    template: function(dataItem){
                        var ccls = "";
                        if(dataItem.CCLS_ST!=null){
                            ccls = dataItem.CCLS_ST+"이상";
                        }
                        if(dataItem.CCLS_ED!=null){
                            ccls += "<br>"+dataItem.CCLS_ED+"미만";
                        }
                        return ccls;
                    }
                },
                { field:"DCLS_ST", title: "D등급<br><%=runMap.get("DCLASS")%>",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}  ,
                    template: function(dataItem){
                        var dcls = "";
                        if(dataItem.DCLS_ED!=null){
                            dcls += dataItem.DCLS_ED+"미만";
                        }
                        return dcls;
                    }
                },
                { field:"EVLCLS", title: "현등급",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}
                },
                { title: "실적확인",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template : function(dataItem){
                    	var btnLabel = "";
                    	if(dataItem.CMPT_EVL_CMPL_FLAG == "1"){
                            return "-";
                        }else if(dataItem.CMPT_EVL_CMPL_FLAG == "2"){
                        	if(dataItem.QCNT==0){
                        		btnLabel = "확인";
                        	}else{
                        		btnLabel = "검토";
                        	}
                        }else if(dataItem.CMPT_EVL_CMPL_FLAG == "3"){
                        	return "-";
                        }else if(dataItem.CMPT_EVL_CMPL_FLAG == "4"){
                        	if(dataItem.NCNT==0){
                                btnLabel = "열람";
                            }else{
                                btnLabel = "검토";
                            }
                        }else if(dataItem.CMPT_EVL_CMPL_FLAG == "5"){
                        	btnLabel = "검토";
                        }else{
                        	return "-";
                        }
                    	
                    	return "<input type='button' class='k-button' style='width:45' value='"+btnLabel+"' onclick='fn_prfMgmt("+dataItem.KPI_NO+");'/>";
                    }
                },
                { field:"DEL", title: "삭제",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template:function(dataItem){
                        if(dataItem.STS=="1"){
                            if(dataItem.REG_TYPE_CD=="2"){
                                return "<input type='button' class='k-button k-i-cancel' style='width:45' value='삭제' onclick='fn_kpiRemove("+dataItem.KPI_NO+");'/>";
                            }else{
                                return "-";
                            }
                            
                        }else{
                            return "-";
                        }
                    }
                }
            ],
            filterable: false,
            sortable: false, pageable: false, height: 450
        });
        
        //목록 버튼 클릭 시..
        $("#listBtn").click( function(){
        	document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_otc_service_list.do";
            document.frm.submit();
        });
        
        //실적등록상태변경
        $("#regStateChangeBtn").click( function(){
            var isConfirm = confirm("이미 평가가 완료된 상태입니다.\n정말로 실적등록상태로 변경 하시겠습니까?");
            if(isConfirm){
                
                $.ajax({
                   type : 'POST',
                   url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/save_appr_dept_user.do?output=json",
                   data : { RUN_NUM : $("#RUN_NUM").val(), TG_USERID : $("#TG_USERID").val(), SAVE_DIV: "RTCM" },
                   complete : function( response ){
                        var obj  = eval("(" + response.responseText + ")");
                        if(obj.saveCount != 0){
                            //현상태 재 조회
                            getCurrentSts();
                             $('#grid').data('kendoGrid').dataSource.read();
                            alert("실적등록상태로 변경 되었습니다."); 
                        }else{
                            alert("작업이 실패 하였습니다.");
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
        });
        
        // 평가완료 버튼 클릭
        $("#saveCmplBtn").click( function (){
            //지표설정 체크
            var array = $('#grid').data('kendoGrid').dataSource.data();
            if(array==null || array.length==0){
                alert("저장할 지표가 존재하지 않습니다.");
                return false;
            }
            for(var i=0; i<array.length; i++){
                if(array[i].KPI_NO==null || array[i].KPI_NO=="" || array[i].KPI_NO==-1){
                    alert(i+"번째 항목의 지표가 설정되지 않았습니다.");
                    return;
                }
            }
            
            var isConfirm = confirm("평가완료 하시겠습니까?\n완료하시기 전에 실적데이터 검토를 필히 하시길 바랍니다.");
            if(isConfirm){
                var params = {
                        LIST :  $('#grid').data('kendoGrid').dataSource.data() 
                };
                
                //관리유형이 '평균'인 지표를 실적등록했는지 체크 후 완료 처리
                $.ajax({
                   type : 'POST',
                   url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/chk_otc_avg_kpi_user.do?output=json",
                   data : { item: kendo.stringify( params ), RUN_NUM : $("#RUN_NUM").val(), TG_USERID : $("#TG_USERID").val() },
                   complete : function( response ){
                        var obj  = eval("(" + response.responseText + ")");
                        if(obj.items != null && obj.items.length>0){
                            //평균으로 계산되는 실적 미등록한 지표가 존재함.
                        	alert("실적이 등록되지 않은 지표가 존재합니다.\n지표명: "+obj.items[0].KPI_NM);
                        }else{
                        	//평가 완료 처리..
                            $.ajax({
                               type : 'POST',
                               url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/save_appr_dept_user.do?output=json",
                               data : { item: kendo.stringify( params ), RUN_NUM : $("#RUN_NUM").val(), TG_USERID : $("#TG_USERID").val(), SAVE_DIV: "CMPL" },
                               complete : function( response ){
                                    var obj  = eval("(" + response.responseText + ")");
                                    if(obj.saveCount != 0){
                                        //현상태 재 조회
                                        getCurrentSts();
                                         $('#grid').data('kendoGrid').dataSource.read();
                                        alert("평가완료 되었습니다."); 
                                    }else{
                                        alert("평가완료 작업이 실패 하였습니다.");
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
                    },
                    error: function( xhr, ajaxOptions, thrownError){     
                    	alert('xrs.status = ' + xhr.status + '\n' + 
                                'thrown error = ' + thrownError + '\n' +
                                'xhr.statusText = '  + xhr.statusText + '\n' );
                    },
                    dataType : "json"
                });     
                   
            }
        });
        
        //목표반려 버튼 클릭
        $("#tgRtBtn").click( function (){
        	var isConfirm = confirm("목표요청을 반려처리 하시겠습니까?");
            if(isConfirm){
                var saveDiv = "RT";
                
                $.ajax({
                   type : 'POST',
                   url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/save_appr_dept_user.do?output=json",
                   data : {RUN_NUM : $("#RUN_NUM").val(), TG_USERID : $("#TG_USERID").val(), SAVE_DIV: saveDiv },
                   complete : function( response ){
                       var obj  = eval("(" + response.responseText + ")");
                       if(obj.saveCount != 0){
                           //현상태 재 조회
                           getCurrentSts();
                           //그리드 재 조회
                           $('#grid').data('kendoGrid').dataSource.read();
                           
                           alert("반려되었습니다.");  
                       }else{
                           alert("반려처리가 실패하였습니다.");
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
        });
        
		//목표승인 or 실적승인 버튼 클릭
		$("#apprReqBtn").click( function (){
		    //지표설정 체크
		    var array = $('#grid').data('kendoGrid').dataSource.data();
		    if(array==null || array.length==0){
                alert("저장할 지표가 존재하지 않습니다.");
                return false;
		    }
		    for(var i=0; i<array.length; i++){
		        if(array[i].KPI_NO==null || array[i].KPI_NO=="" || array[i].KPI_NO==-1){
		            alert(i+"번째 항목의 지표가 설정되지 않았습니다.");
		            return false;
		        }
		        
		        if(array[i].BEF_PRF==null){
		        	alert("전기실적은 필수입력 항목입니다.");
                    return false;
		        }
		        
		        if(array[i].NOW_TARG==null){
		        	alert("당기목표는 필수입력 항목입니다.");
                    return false;
		        }
		        
		        if(array[i].PRIO==null){
		        	alert("우선순위는 필수입력 항목입니다.");
		        	return false;
		        }
		    }
		    
		    var isConfirm = confirm("승인하시겠습니까?");
		    if(isConfirm){
		    	var saveDiv = "";
		    	if(currentStsCode=="1"){
		    		//목표승인
		    		saveDiv = "TC";
		    	}else if(currentStsCode=="2"){
		    		//실적승인
		    		saveDiv = "PC";
		    	}
		    	
		        var params = {
		                LIST :  $('#grid').data('kendoGrid').dataSource.data() 
		        };
		        
		        $.ajax({
		           type : 'POST',
		           url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/save_appr_dept_user.do?output=json",
		           data : { item: kendo.stringify( params ), RUN_NUM : $("#RUN_NUM").val(), TG_USERID : $("#TG_USERID").val(), SAVE_DIV: saveDiv },
		           complete : function( response ){
		               var obj  = eval("(" + response.responseText + ")");
		               if(obj.saveCount != 0){
		            	   //현상태 재 조회
		            	   getCurrentSts();
		            	   //그리드 재 조회
		            	   $('#grid').data('kendoGrid').dataSource.read();
		                   
		                   alert("승인되었습니다.");  
		               }else{
		                   alert("승인실패하였습니다.");
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
		});
        
    }
    

    //kpi 지표 삭제..
    function fn_kpiRemove(kpiNo){
        if(confirm("삭제하시겠습니까?")){

	          $.ajax({
	              type : 'POST',
	              url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/del_dept_kpi_map.do?output=json",
	              data : { RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val(), KPI_NO : kpiNo },
	              complete : function( response ){
	                  var obj  = eval("(" + response.responseText + ")");
	                  if(obj.error){
	                      alert("ERROR:"+obj.error.message);
	                  }else{
	                      if(obj.saveCount != 0){
	                          //$('#kpiMgmtGrid').data("kendoGrid").dataSource.read();
	                          $('#grid').data("kendoGrid").dataSource.read();
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
    
    //산식 / CFS 조회
    function fn_ArithInfo(kpiNo){
        
        if( !$("#arith-window").data("kendoWindow") ){
            $("#arith-window").kendoWindow({
                width:"570px",
                height: "460px",
                resizable : true,
                title : "추가정보",
                modal: true,
                visible: false
            });
        }
        
        var array = $('#grid').data('kendoGrid').dataSource.data();
        var res = $.grep(array, function (e) {
            return e.KPI_NO == kpiNo;
        });
        
        $("#arithKpiNm").text(res[0].KPI_NM+" ("+res[0].UNIT_NM+")" );
        $("#arithCap").text(" - ");
        $("#arithTarget").text(" - ");
        $("#arithThreshold").text(" - ");
        $("#arithTargetSetWrnt").text(" - ");
        $("#arithDataSource").text(" - ");
        $("#arithMgmtDept").text(" - ");
        
        $.ajax({
            type : 'POST',
            url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/otc_arith_cfs_info.do?output=json",
            data : { KPI_NO : kpiNo },
            complete : function( response ){
                if(response.responseText){
                    var obj  = eval("(" + response.responseText + ")");
                    if(obj!=null){
                        if(obj.items!=null){

                            if(obj.items[0].CAP!=null){
                                $("#arithCap").text(obj.items[0].CAP);
                            }
                            if(obj.items[0].TARGET!=null){
                                $("#arithTarget").text(obj.items[0].TARGET);
                            }
                            if(obj.items[0].THRESHOLD!=null){
                                $("#arithThreshold").text(obj.items[0].THRESHOLD);
                            }
                            if(obj.items[0].TARGET_SET_WRNT!=null){
                                $("#arithTargetSetWrnt").text(obj.items[0].TARGET_SET_WRNT);
                            }
                            if(obj.items[0].DATASOURCE!=null){
                                $("#arithDataSource").text(obj.items[0].DATASOURCE);
                            }
                            if(obj.items[0].MGMT_DEPT!=null){
                                $("#arithMgmtDept").text(obj.items[0].MGMT_DEPT);
                            }
                            
                        }
                        
                        if(event.preventDefault){
                            event.preventDefault();
                        } else {
                            event.returnValue = false;
                        };
                    }
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
        
        $("#arith-window").data("kendoWindow").center();
        $("#arith-window").data("kendoWindow").open();
    }
    
    //kpi value 셋팅
    function setKpiValue(column, rows, obj){
    	
        var array = $('#grid').data('kendoGrid').dataSource.data();            
        
        if(column == "bef_prf"){
        	if(chkNoNull(obj) && isNumber(obj)){
	                
	        	if($("#bef_prf_"+rows).val()==""){
	        		array[rows].BEF_PRF = null;
	        	}else{
	        		array[rows].BEF_PRF = $("#bef_prf_"+rows).val();
	        	}
            }else{
            	array[rows].BEF_PRF = null;
            }
        }else if(column == "now_targ"){
        	if(chkNoNull(obj) && isNumber(obj)){
	        	if($("#now_targ_"+rows).val()==""){
	        		array[rows].NOW_TARG = null;
	        	}else{
	        		array[rows].NOW_TARG = $("#now_targ_"+rows).val();
	        	}
        	}else{
        		array[rows].NOW_TARG = null;
        	}
        }else if(column == "prio"){
        	if(chkNoNull(obj) && chkNum(obj)){
	        	if($("#prio_"+rows).val()==""){
	        		array[rows].PRIO = null;
	        	}else{
	        		array[rows].PRIO = $("#prio_"+rows).val();
	        	}
        	}else{
        		array[rows].PRIO = null;
        	}
        }
    }
  
    //실적등록 팝업
    function fn_prfMgmt(kpiNo){
        //alert(tgUserid);
        //$("#popupComapnyId").val(companyid);
        if($("#runList").val()==null || $("#runList").val()==""){
            alert("실적 관리할 성과평가가 선택되지 않았습니다.");
            return false;
        }
        
        //지표정보 세팅
        var data = $("#grid").data("kendoGrid").dataSource.view();
        var res = $.grep(data, function (e) {
            return e.KPI_NO == kpiNo;
        });

        //지표번호
        $("#KPI_NO").val(res[0].KPI_NO);
        
        if( !$("#otcPrf-window").data("kendoWindow") ){
            $("#otcPrf-window").kendoWindow({
                width:"1000px",
                height: "570px",
                resizable : true,
                title : "실적 등록/열람",
                modal: true,
                visible: false
            });
            
            //실적등록/열람 저장버튼 클릭 시..
            //부서장이 저장할 경우 바로 승인처리되며 실적, 달성율 등이 계산됨..
            $("#savePrfBtn").click(function(){
               var array = $('#otcPrfGrid').data('kendoGrid').dataSource.data();            
                
                //월별 등록해야할 실적 모두 입력했는지 체크..
                for(var i=1; i<=12; i++){
                    if($("#prf"+i).length>0 && !$("#prf"+i).attr("readOnly")){
                        //alert(array[0].get("PRF_"+i));
                        if(array[0].get("PRF_"+i) == null || array[0].get("PRF_"+i).length == 0 ){
                            alert(i+"월 실적을 입력해주세요.");
                            $("#prf"+i).focus();
                            return false;
                        }
                    }
                }
                
            	var isConfirm = confirm("저장하시겠습니까?");
                if(isConfirm){
                    var params = {
                            LIST :  $('#otcPrfGrid').data('kendoGrid').dataSource.data() 
                    };
                    
                    $.ajax({
                       type : 'POST',
                       url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/save_dept_user_prf.do?output=json",
                       data : { item: kendo.stringify( params ), RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val(), KPI_NO : $("#KPI_NO").val() },
                       complete : function( response ){
                           var obj  = eval("(" + response.responseText + ")");
                           if(obj.saveCount != 0){
                               $('#otcPrfGrid').data('kendoGrid').dataSource.read();
                               $('#grid').data('kendoGrid').dataSource.read();
                               alert("저장되었습니다.");  
                           }else{
                               alert("저장에 실패 하였습니다.");
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
            });
            
            //취소버튼 클릭
            $("#cancelPrfBtn").click(  function() {
                $("#otcPrf-window").data("kendoWindow").close();
            });
        }
        
        //실적등록 grid 컬럼 정의
        var columns = [];
        var runEvlPeriod = "<%=runMap.get("EVL_PRD_CD")%>"; //성과평가 평가기준기간 ( 1:상반기, 2:하반기 3:연 )
        var kpiEvlPeriod = res[0].MEA_EVL_CYC; //지표기준의 관리주기 ( 1: 월, 2: 분기, 3: 반기, 4: 연 )
        var otcPrfGridHeight = 85;
        columns.push({
            field: "NOW_TARG",
            title: "목표",
            width:100,
            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
            attributes:{"class":"table-cell", style:"text-align:right"}
        });
        columns.push({
            field: "NOW_PRF",
            title: "실적",
            width:100,
            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
            attributes:{"class":"table-cell", style:"text-align:right"}
        });
        columns.push({
            field: "ACHR",
            title: "달성율(%)",
            width:100,
            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
            attributes:{"class":"table-cell", style:"text-align:right"}
        });
        //상반기 또는 연 평가일 경우 
        if(runEvlPeriod==1 || runEvlPeriod==3){
        	columns.push({
                field: "PRF_1",
                title: "1월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_1!=null) prf= dataItem.PRF_1;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"01") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1){
                    	return "<input type='text' id='prf1' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(1, this)' "+sts+" />";
                    }else{
                    	return "-";
                    }
                    
                }
            });
            columns.push({
                field: "PRF_2",
                title: "2월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_2!=null) prf= dataItem.PRF_2;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"02") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1){
                        return "<input type='text' id='prf2' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(2, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
            columns.push({
                field: "PRF_3",
                title: "3월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_3!=null) prf= dataItem.PRF_3;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"03") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1 || kpiEvlPeriod==2 ){
                        return "<input type='text' id='prf3' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(3, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
            columns.push({
                field: "PRF_4",
                title: "4월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_4!=null) prf= dataItem.PRF_4;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"04") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1){
                        return "<input type='text' id='prf4' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(4, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
            columns.push({
                field: "PRF_5",
                title: "5월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_5!=null) prf= dataItem.PRF_5;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"05") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1){
                        return "<input type='text' id='prf5' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(5, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
            columns.push({
                field: "PRF_6",
                title: "6월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_6!=null) prf= dataItem.PRF_6;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"06") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1 || kpiEvlPeriod==2 || kpiEvlPeriod==3){
                        return "<input type='text' id='prf6' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(6, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
        }
        //하반기 또는 연 평가일 경우
        if(runEvlPeriod==2 || runEvlPeriod==3){
        	columns.push({
                field: "PRF_7",
                title: "7월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_7!=null) prf= dataItem.PRF_7;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"07") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1){
                        return "<input type='text' id='prf7' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(7, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
            columns.push({
                field: "PRF_8",
                title: "8월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_8!=null) prf= dataItem.PRF_8;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"08") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1){
                        return "<input type='text' id='prf8' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(8, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
            columns.push({
                field: "PRF_9",
                title: "9월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_9!=null) prf= dataItem.PRF_9;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"09") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1 || kpiEvlPeriod==2){
                        return "<input type='text' id='prf9' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(9, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
            columns.push({
                field: "PRF_10",
                title: "10월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_10!=null) prf= dataItem.PRF_10;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"10") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1){
                        return "<input type='text' id='prf10' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(10, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
            columns.push({
                field: "PRF_11",
                title: "11월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_11!=null) prf= dataItem.PRF_11;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"11") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1){
                        return "<input type='text' id='prf11' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(11, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
            columns.push({
                field: "PRF_12",
                title: "12월",
                width:100,
                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                attributes:{"class":"table-cell", style:"text-align:center"},
                template: function(dataItem){
                    var prf = "";
                    if(dataItem.PRF_12!=null) prf= dataItem.PRF_12;
                    var sts = "";
                    var color = "";
                    if( Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"12") ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1 || kpiEvlPeriod==2 || kpiEvlPeriod==3 || kpiEvlPeriod==4){
                        return "<input type='text' id='prf12' value='"+prf+"' class='k-input input_95' style='text-align:center; "+color+"' onkeyup='setValue(12, this)' "+sts+" />";
                    }else{
                        return "-";
                    }
                }
            });
        }
        
        //상반기 하반기 평가인 경우 그리드 높이를 스크롤 제외한 높이로 설정
        if(runEvlPeriod==1 || runEvlPeriod==2){
        	otcPrfGridHeight = 68;
        }
        
        
        $("#otcPrfGrid").empty();
        $("#otcPrfGrid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/otc_month_prf.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){
                         return { RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val(), KPI_NO: $("#KPI_NO").val() };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            NOW_TARG : { type: "number" },
                            NOW_PRF: { type:"number" },
                            ACHR : { type: "number" },
                            BEF_PRF: { type: "number" },
                            NOW_TARG: { type: "number" },
                            NOW_PRF: { type: "number" },
                            PRIO: { type: "number" }, 
                            WEI: { type: "number" },
                            EVLCLS:{ type: "string" },
                            UNIT_NM: {type: "string" }
                        }
                    }
                },
                serverPaging: false, serverFiltering: false, serverSorting: false
            },
            columns: columns,
            dataBound: function(e) {
                
            },
            filterable: false,
            scrollable: true,
            sortable: false, 
            pageable: false, 
            height: otcPrfGridHeight
        });
            
        
        //지표유형
        if(res[0].KPI_TYPE_NM!=null)
            $("#kpiTypeNm").text(res[0].KPI_TYPE_NM); 
        //지표
        
        //관리주기
        if(res[0].MEA_EVL_CYC_NM!=null)
            $("#meaEvlCycNm").text(res[0].MEA_EVL_CYC_NM); 
        //지표명
        if(res[0].KPI_NM!=null)
            $("#kpiNm").text(res[0].KPI_NM+ ((res[0].UNIT_NM!=null) ? ("(" + res[0].UNIT_NM + ")"):"")); 
        //현등급
        if(res[0].EVLCLS!=null)
            $("#evlCls").text(res[0].EVLCLS); 
        //관리유형
        if(res[0].EVL_HOW_NM!=null)
            $("#evlHowNm").text(res[0].EVL_HOW_NM);
        

        /*
        @@@ 첨부파일 세팅 방법 @@@
        object_type = 1 (고정된 값)
        object_id 값은 해당 업무 테이블의 pk가 unique하다면 해당컬럼의 값으로 처리해도됨. 그렇지 않다면 pk의 조합으로 처리해야함.
        
        object_id = 회사번호+실시번호+평가대상자+지표번호
           예 ) 회사번호 1, 실시번호 7, 평가대상자 1500, 지표번호 10 => 17150010
           
        */
        var objectType = 1 ;
        $("#objectId").val('<%=companyid%>'+$("#runList").val()+'<%=tgUserid%>'+$("#KPI_NO").val());
        
        if( !$("#my-file-gird").data('kendoGrid') ) {
            $("#my-file-gird").kendoGrid({
                dataSource: {
                    type: 'json',
                    transport: {
                        read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/list-my-attachement.do?output=json', type: 'POST' },      
                        destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
                        parameterMap: function (options, operation){
                            if (operation != "read" && options) {                                                                                                                           
                                return { objectType: objectType, objectId:$("#objectId").val(), attachmentId :options.attachmentId };                                                                   
                            }else{
                                 return { objectType: objectType, objectId:$("#objectId").val(), startIndex: options.skip, pageSize: options.pageSize };
                            }
                        }
                    },
                    schema: {
                        model: Attachment,
                        data : "targetAttachments"
                    },
                },
                pageable: false,
                height: 200,
                selectable: false,
                columns: [
                    { 
                        field: "name", 
                        title: "파일",  
                        width: "320px" , 
                        template: '#= name #' 
                   },
                    //{ field: "contentType", title:"contentType", width: "100px" },
                    { 
                        field: "size",
                        title: "크기(byte)", 
                        format: "{0:##,###}", 
                        width: "100px" 
                    },
                    { 
                        width: "160px" , 
                        template: function(dataItem){
                            return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>'+
                            '<button style="width:60px; min-width: 50px;" class="k-button" onclick="deleteFile('+dataItem.attachmentId+')">삭제</button>';
                        } 
                    }
                ]
            });
        }else{
            handleCallbackUploadResult();
        }
        
        var ver = getInternetExplorerVersion();
        if( ( ver > -1) && ( ver < 10 ) ){
            if( $('#my-file-upload').text().length == 0  ) {
                var template = kendo.template('<button id="openUploadWindow" name="openUploadWindow">파일 업로드 하기</button>');
                $('#my-file-upload').html(template({}));
                $('#openUploadWindow').kendoButton({
                    click: function(e){
                        var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#objectId").val() ;
                        myWindow = window.open(windowUrl, "_blank", "toolbar=no, scrollbars=no, resizable=no, top=500, left=500, width=405, height=250");
                    }                           
                });
                $('button.custom-button-delete').click( function(e){
                    
                    //alert ("delete");
                });
                $("#my-file-upload").removeClass('hide');
            }                   
        }else{                  
            if( $('#my-file-upload').text().length == 0  ) {
                var template = kendo.template($("#fileupload-template").html());
                $('#my-file-upload').html(template({}));
            }                   
            if( !$('#upload-file').data('kendoUpload') ){                       
                $("#upload-file").kendoUpload({
                    showFileList : false,
                    width : 500,
                    multiple : false,
                    localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.', statusUploaded: "완료.", statusFailed : "업로드 실패." },
                    async: {
                        saveUrl:  '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do?output=json',                               
                        autoUpload: true
                    },
                    upload: function (e) {                                       
                        e.data = {objectType: objectType, objectId:$("#objectId").val()};                                                                                                                    
                    },
                    error : function (e){                           
                    },
                    success : function(e){                          
                        handleCallbackUploadResult();
                    },
                    select: function(e){
                        $.each(e.files, function(index, value) {
                            if(value.size>10485760){
                                e.preventDefault();
                                alert("파일 사이즈는 10M로 제한되어 있습니다.");
                            }else{
                                $.each(e.files, function(index, value) {
                                    if(value.extension != ".HWP" && value.extension != ".hwp" 
                                        && value.extension != ".DOC" && value.extension != ".doc" 
                                        && value.extension != ".PPT" && value.extension != ".ppt" 
                                        && value.extension != ".XLS" && value.extension != ".xls"
                                        && value.extension != ".PDF" && value.extension != ".pdf" 
                                        && value.extension != ".DOCX" && value.extension != ".docx" 
                                        && value.extension != ".PPTX" && value.extension != ".pptx" 
                                        && value.extension != ".XLSX" && value.extension != ".xlsx"
                                        && value.extension != ".TXT" && value.extension != ".txt"
                                        && value.extension != ".ZIP" && value.extension != ".zip"
                                        && value.extension != ".JPG" && value.extension != ".jpg" 
                                        && value.extension != ".JPEG" && value.extension != ".jpeg" 
                                        && value.extension != ".GIF" && value.extension != ".gif" 
                                        && value.extension != ".BMP" && value.extension != ".bmp"
                                        && value.extension != ".PNG" && value.extension != ".png") {
                                        
                                        e.preventDefault();
                                        alert("업로드가 허용된 형식의 파일만 선택해주세요.\n가능한 파일확장자:hwp, doc, ppt, xls, pdf, docx, pptx, xlsx, txt, zip, jpg, jpeg, gif, bmp, png");
                                    }
                                });
                            }
                        });
                    }
                });
                $("#my-file-upload").removeClass('hide');
            }
        }
        
        
        $("#otcPrf-window").data("kendoWindow").center();
        $("#otcPrf-window").data("kendoWindow").open();
        
    }
    

    function handleCallbackUploadResult(){
        $("#my-file-gird").data('kendoGrid').dataSource.read();             
    }
    
    //첨부파일 삭제.
    function deleteFile (attachmentId){
        if(confirm("첨부파일을 삭제 하시겠습니까?")){
            $.ajax({
                type : 'POST',
                url : '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json' ,
                data:{ attachmentId : attachmentId },
                success : function(response){
                    $("#my-file-gird").data('kendoGrid').dataSource.read(); 
                },
                dataType : "json"
            });
        }
    }
    
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
    
    //실적 value 셋팅
    function setValue(index, obj){
        var array = $('#otcPrfGrid').data('kendoGrid').dataSource.data();            
        
        if(index == 1){
        	if(chkNoNull(obj) && isNumber(obj)){
        	    array[0].PRF_1 = $("#prf1").val();
        	}else{
        		array[0].PRF_1 = null;
        	}
        }else if(index == 2){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_2 = $("#prf2").val();
            }else{
                array[0].PRF_2 = null;
            }
        }else if(index == 3){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_3 = $("#prf3").val();
            }else{
                array[0].PRF_3 = null;
            }
        }else if(index == 4){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_4 = $("#prf4").val();
            }else{
                array[0].PRF_4 = null;
            }
        }else if(index == 5){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_5 = $("#prf5").val();
            }else{
                array[0].PRF_5 = null;
            }
        }else if(index == 6){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_6 = $("#prf6").val();
            }else{
                array[0].PRF_6 = null;
            }
        }else if(index == 7){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_7 = $("#prf7").val();
            }else{
                array[0].PRF_7 = null;
            }
        }else if(index == 8){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_8 = $("#prf8").val();
            }else{
                array[0].PRF_8 = null;
            }
        }else if(index == 9){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_9 = $("#prf9").val();
            }else{
                array[0].PRF_9 = null;
            }
        }else if(index == 10){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_10 = $("#prf10").val();
            }else{
                array[0].PRF_10 = null;
            }
        }else if(index == 11){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_11 = $("#prf11").val();
            }else{
                array[0].PRF_11 = null;
            }
        }else if(index == 12){
        	if(chkNoNull(obj) && isNumber(obj)){
                array[0].PRF_12 = $("#prf12").val();
            }else{
                array[0].PRF_12 = null;
            }
        }
    }
    
</script>

</head>
<body>
	<form id="frm" name="frm"  method="post" >
	    <input type="hidden" name="RUN_NUM" id="RUN_NUM" value="<%=runMap.get("RUN_NUM")%>"/>
	    <input type="hidden" name="runList" id="runList" value="<%=runMap.get("RUN_NUM")%>"/>
        <input type="hidden" name="TG_USERID" id="TG_USERID" value="<%=tgUserid%>"/>
	    <input type="hidden" name="JOB" id="JOB" />
	    <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" />
	    <input type="hidden" name="KPI_NO" id="KPI_NO" />
        <input type="hidden" name="objectId" id="objectId" />
	</form>
	<div id="content">
		<div class="cont_body">
			<div class="title">부서원 성과 실적 승인</div>
			<div class="table_tin">
                <ul>
                    <li class="line">부서원 : <%=tgInfo %></li>
                </ul>
                <ul>
                    <li class="line">평가 년도 : <%=runMap.get("YYYY") %>년</li>
                    <li>평가명 : <%=runMap.get("RUN_NAME") %></li>
                </ul>
                <ul>
                    <li class="line1">현상태 : <span id="otcEvlSts"></span></li>
                </ul>
            </div>
            
			<div class="table_zone">
			     <div id="tabstrip" style="border-style:none;"></div>
			     <div id="grid" style="height:100%; "></div>
			</div>
			
			<div style="text-align:left; padding-top:10px;">
			     <div style="width:30%; text-align:left; float:left">
			            <button id="saveCmplBtn" class="k-button" >평가완료</button>
                        <button id="regStateChangeBtn" class="k-button" >실적등록상태변경</button>
                        &nbsp;
			     </div>
			     <div style="width:70%; text-align:right; float:left">
			             <span id="delKpiLabel">※ 등록유형이 “개인”것은 임직원이 직접 입력한 것으로 삭제 가능합니다.</span>
			            <button id="apprReqBtn" class="k-button" ><span id="apprReqLabel"></span></button>
                        <button id="tgRtBtn" class="k-button" >목표반려</button>
                        <button id="listBtn" class="k-button" >목록</button>
			     </div>
                 
            </div>
		</div>
		<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/>
	</div>
	

    <!-- 실적등록/열람 팝업 -->
    <div id="otcPrf-window" style="display:none;">
        <div style="float:left;padding:30px 30px 40px 30px;width:930px;">
	        <ul style="float:left;width:930px;">
	            <li style="float:left;background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_cir02.gif) no-repeat 0 9px;padding-left:18px;line-height:30px;font-weight:bold;">지 표 명 : <span id="kpiNm"></span></li>
	        </ul>
	        <ul style="float:left;width:930px;">
	            <li style="float:left;background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_cir02.gif) no-repeat 0 9px;padding-left:18px;line-height:30px;font-weight:bold; width:330px;">지표유형 : <span id="kpiTypeNm"></span></li>
	            <li style="float:left;background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_cir02.gif) no-repeat 0 9px;padding-left:18px;line-height:30px;font-weight:bold;">관리유형 : <span id="evlHowNm"></span></li>
	        </ul>
	        <ul style="float:left;width:930px;">
	            <li style="float:left;background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_cir02.gif) no-repeat 0 9px;padding-left:18px;line-height:30px;font-weight:bold; width:330px;">관리주기 : <span id="meaEvlCycNm"></span></li>
	            <li style="float:left;background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_cir02.gif) no-repeat 0 9px;padding-left:18px;line-height:30px;font-weight:bold;">현 등 급 : <span id="evlCls"></span></li>
	        </ul>
	        <div style="float:left;width:100%;margin-top:10px;min-height:70px;"><div id="otcPrfGrid" ></div></div>
	        
	        <div style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_cir02.gif) no-repeat 0 9px;padding-left:18px;line-height:30px;font-weight:bold;display:inline-block;">증빙 파일</div>
            <div class="file">
                <ul>
	                <li style="width:300px;float:left;">
	                   <div id="my-file-upload" class="hide"></div>
	                    <!-- <div id="my-file-upload">   
	                        <small> 업로드할 파일은 아래의 파일선택 버튼을 클릭하여 직접 선택하거나, 아래의 영역에 파일를 끌어서 놓기(Drag & Drop)를 하세요. </small>
	                        <input name="upload-file" id="upload-file" type="file" class="hide"/>
	                    </div> -->
	                </li>
	                <li style="width:600px;float:left;padding-left:25px;">
	                    <div id="my-file-gird"></div>
	                    
                        <script type="text/x-kendo-tmpl" id="fileupload-template">
                            <small> 업로드할 파일은 아래의 파일선택 버튼을 클릭하여 직접 선택하거나, 아래의 영역에 파일를 끌어서 놓기(Drag & Drop)를 하세요. </small>
                            <input name="upload-file" id="upload-file" type="file"/>
                            <p></p>
                        </script>
	                </li>
                </ul>
            </div>
            
            <div style="float:right;display:table; padding-top:10px;">
	            <button id="savePrfBtn" class="k-button" >저장</button>&nbsp;
	            <button id="cancelPrfBtn" class="k-button" >닫기</button>
	        </div>
	    </div>
        
    </div>
    
    <!-- 지표별 산식 / CFS 조회 -->
    <div id="arith-window" style="display:none;">
        <div class="layer_cont">
            <div class="layer_text">
                <div class="sub_title01"><span style="width:100px;">지표명 </span> <p id="arithKpiNm"></p></div>
                <div class="sub_title01"><span style="width:100px;">Cap </span> <p id="arithCap"></p></div>
                <div class="sub_title01"><span style="width:100px;">Target </span> <p id="arithTarget"></p></div>
                <div class="sub_title01"><span style="width:100px;">Threshold </span> <p id="arithThreshold"></p></div>
                <div class="sub_title01">Target 설정근거</div>
                <div class="top01"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_top03.gif" alt=""/></div>
                <div class="middle01"><span id="arithTargetSetWrnt"></span></div>
                <div class="bottom01"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom03.gif" alt=""/></div>
                <div class="sub_title01"><span style="width:100px;">Data Source </span> <p id="arithDataSource"></p></div>
                <div class="sub_title01"><span style="width:100px;">관리부서 </span> <p id="arithMgmtDept"></p></div>
                
            </div>
        </div>
    </div>

<style>
.layer_cont .layer .close{float:right;margin-top:5px;}
.layer_cont{float:left;width:500px;}
.layer_cont .layer_text{position:relative;width:530px;margin-top:0px;padding:0 20px 10px 10px;}
.layer_cont .layer_text .sub_title{width:530px;border-bottom:1px solid #d4d4d4;font-weight:bold;color:#2eb398;font-size:16px;padding:15px 0;}
.layer_cont .layer_text .sub_btn{position:absolute;top:10px;right:30px;}
.layer_cont .layer_text .sub_title01{margin-top:20px;background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_cir02.gif) no-repeat 0 5px;padding-left:18px;font-weight:bold;}
.layer_cont .layer_text .sub_title01 span{float:left;width:73px;}

.layer_cont .layer_text .top01{width:535px;margin-top:10px;}
.layer_cont .layer_text .bottom01{width:530px;}
.layer_cont .layer_text .middle01{width:493px;border-left:1px solid #dfdfdf;border-right:1px solid #dfdfdf;padding:15px 20px;min-height:50px;}
.layer_cont .layer_text .text_table{width:530px;margin-top:10px;min-height:110px;}
</style>


</body>
</html>