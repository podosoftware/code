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
<%

kr.podosoft.ws.service.kpi.action.ajax.KPIServiceAction action = (kr.podosoft.ws.service.kpi.action.ajax.KPIServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
List yearList = action.getItems();
List items1 = action.getItems1();
long companyid = action.getUser().getCompanyId();
long tgUserid = action.getUser().getUserId();

%>
<html decorator="subpage">
<head>
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
                    
<script type="text/javascript">	
var runListDataSource;
var gridDataSource;
var runClass;
var currentStsCode;
var kpiAddFlag = "N"; //지표추가 여부

    yepnope([{
        load: [ 
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js',     
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js' 
        ],
		complete: function() {
			kendo.culture("ko-KR");               

			$("#TG_USERID").val(<%=tgUserid%>);

			var options = [];
            var date = new Date(); 
            var year = date.getFullYear(); 
            <% 
            if(yearList!=null && yearList.size()>0){
                for(int i=0; i<yearList.size(); i++){
                    Map map = (Map)yearList.get(i);
            %>
            options.push({"YYYY":<%=map.get("YYYY")%>, "TEXT":<%=map.get("YYYY")%>+"년"});
            <%
                }
            }else{
            %>
            options.push({"YYYY":year, "TEXT":year+"년"});
            <%
            }
            %>
            
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
            //var tabStrip = $("#tabstrip").kendoTabStrip().data("kendoTabStrip");
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
            
            $("#apprReqBtn").hide();
            $("#savePrfBtn").hide();
            $("#addKpiBtn").hide();
            $("#addKpiLabel").hide();
            
            runListDataSource = new kendo.data.DataSource({
                type: "json",
                    transport:{
                        read: { url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/otc_run_list.do?output=json", type:"POST" }
                    },
                    schema:{
                        data: "items",
                        model: {
                            fields: {
                                YYYY: { type: "string" },
                                RUN_NUM: { type: "int" },
                                RUN_NAME: { type: "string" }
                            }
                        }
                    },
                    serverFiltering: false,
                    serverSorting: false
            });
            
            //평가년도 콤보박스
            $("#yyyy").kendoComboBox({
                dataTextField: "TEXT",
                dataValueField: "YYYY",
                dataSource: options,
                filter: "contains",
                suggest: true,
                width: 100,
                change: function() {
                    if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
                        runListDataSource.filter({
                            "field":"YYYY",
                            "operator":"eq",
                            "value":$("#yyyy").val()
                        });
                    }else{
                        runListDataSource.filter({});
                    }
                    $("#runList").data("kendoComboBox").select(0);
                    $("#grid").data("kendoGrid").dataSource.read();
                    runClass = $("#runList").data("kendoComboBox").dataItem();
                    
                    if($("#runList").val()!=null && $("#runList").val()!=""){
                    	getCurrentSts();
                    }
                    
                 }
            });
            $("#yyyy").data("kendoComboBox").select(0);
            
            $("#runList").kendoComboBox({
                dataTextField: "RUN_NAME",
                dataValueField: "RUN_NUM",
                dataSource: runListDataSource,
                filter: "contains",
                suggest: true ,
                width: 250,
                change: function(dataItem){
                    runClass = this.dataItem(this.select());
                    
                    $("#grid th[data-field=SCLS_ST]").html("S<br>"+runClass.SCLASS);
                    $("#grid th[data-field=ACLS_ST]").html("A<br>"+runClass.ACLASS);
                    $("#grid th[data-field=BCLS_ST]").html("B<br>"+runClass.BCLASS);
                    $("#grid th[data-field=CCLS_ST]").html("C<br>"+runClass.CCLASS);
                    $("#grid th[data-field=DCLS_ST]").html("D<br>"+runClass.DCLASS);
                    
                    if($("#runList").val()!=""){
                    	$("#grid").data("kendoGrid").dataSource.read();
                    	if($("#runList").val()!=null && $("#runList").val()!=""){
                            getCurrentSts();
                    	}
                    }else{
                    	$("#grid").data("kendoGrid").dataSource.remove();
                    }
                }
            });
            
            //화면 로딩후 평가목록 패치시 실행..
            runListDataSource.fetch(function(){
            	
            	if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
                    runListDataSource.filter({
                        "field":"YYYY",
                        "operator":"eq",
                        "value":$("#yyyy").val()
                    });
                    if(runListDataSource.data().length>0){
                        $("#runList").data("kendoComboBox").select(0);
                        runClass = $("#runList").data("kendoComboBox").dataItem();
                    }else{
                    	alert("대상자로 설정된 성과평가가 존재하지 않습니다.\n교육운영자에게 문의해주세요.");
                    }
                }
            	openWindow();
            	
            	if($("#runList").val()!=null && $("#runList").val()!=""){
                    getCurrentSts();
            	}

                tabStrip.select(0);
            });
          
            //고객사가 KPI지표를 추가할 수있는 권한이 있는지 체크.
            $.ajax({
                type : 'POST',
                url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_kpi_add_check.do?output=json",
                data : {},
                complete : function( response ){
                    var obj  = eval("(" + response.responseText + ")");
                    kpiAddFlag = obj.statement;
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
            data : { RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val() },
            complete : function( response ){
                	try{
	                		
	                	if(response.responseText){
		                		
			            	var obj  = eval("(" + response.responseText + ")");
			                
			                currentStsCode = obj.statement;
			                
			                var sts = "";
			                //평가 현상태 조회
			                if(obj.statement == "1"){
			                	sts ="목표 승인 요청 중입니다.";
			                	$("#apprReqBtn").hide();
			                	$("#savePrfBtn").hide();
			                    $("#addKpiBtn").hide();
			                    $("#addKpiLabel").hide();
			                    
			                }else if(obj.statement == "2"){
			                    sts = "실적 승인을 요청 중입니다.";
			                    $("#apprReqBtn").hide();
			                    $("#savePrfBtn").hide();
			                    $("#addKpiBtn").hide();
			                    $("#addKpiLabel").hide();
			                }else if(obj.statement == "3"){
			                	sts = "목표설정단계로 전기설적, 당기목표와 우선순위(1~10까지)를 적은 후 승인 요청합니다.";
			                	$("#apprReqBtn").show();
			                	$("#apprReqLabel").text("목표승인요청");
			                	$("#savePrfBtn").hide();
			                    $("#addKpiBtn").show();
			                    $("#addKpiLabel").show();
			                }else if(obj.statement == "4"){
			                	sts = "실적 등록 단계로 등록을 클릭하여 지표별 실적을 등록 후 부서장님에게 승인 요청합니다.";
			                	$("#apprReqBtn").show();
			                	$("#apprReqLabel").text("실적승인요청");
			                	$("#savePrfBtn").show();
			                    $("#addKpiBtn").hide();
			                    $("#addKpiLabel").hide();
			                }else if(obj.statement == "5"){
			                	sts = "평가를 완료하였습니다.";
			                	$("#apprReqBtn").hide();
			                	$("#savePrfBtn").hide();
			                    $("#addKpiBtn").hide();
			                    $("#addKpiLabel").hide();
			                	
			                	//현상태 데이터와 그리드 데이터 중 먼저 도착한 데이터의 값에 따라 적용..
			                	$("#evlTotalScoreUl").show();
			                	if($('#grid').data('kendoGrid').dataSource.data().length>0){
			                		$("#evlTotalScore").text( $('#grid').data('kendoGrid').dataSource.data()[0].EVL_TOTAL_SCORE );
			                	}
			                	
			                }else{
			                	$("#apprReqBtn").hide();
			                	$("#savePrfBtn").hide();
			                }
			                
			                $("#otcEvlSts").text(sts);
	
	                    }

                    }catch(e){
                        alert("catch err: "+e);
                    }
            },
            error: function( xhr, ajaxOptions, thrownError){                                
            },
            dataType : "json"
        });
    }
    
    function openWindow(){
    	var sclass = "";
    	var aclass = "";
    	var bclass = "";
    	var cclass = "";
    	var dclass = "";
    	if(runClass!=null && runClass!="undefined" &&  runClass!=""){
    		sclass = runClass.SCLASS;
    		aclass = runClass.ACLASS;
    		bclass = runClass.BCLASS;
    		cclass = runClass.CCLASS;
    		dclass = runClass.DCLASS;
    	}
    	
        $("#grid").empty();
        $("#grid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/otc_user_map_list.do?output=json", type:"POST" },
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
                    locked: true,
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
                    attributes:{"class":"table-cell", style:"text-align:left"} ,
                    locked: true
                },
                { field:"KPI_NM", title: "지표명", width:250, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left;  text-decoration: underline;"} ,
                    locked: true,
                    template: function (dataItem){
                    	var fontS = "";
                    	var fontE = "";
                    	if(dataItem.USEFLAG=="N"){
                    		fontS = "<font color='red'>";
                    		fontE = "</font>";
                    	}
                    	
                    	return "<a href='javascript:void();' onclick='javascript:fn_ArithInfo("+dataItem.KPI_NO+"); return false;' >"+fontS+dataItem.KPI_NM+"("+dataItem.UNIT_NM+")"+fontE+"</a>"
                    }
                    //template: "<a href='javascript:void();' onclick='javascript:fn_ArithInfo(#=KPI_NO#); return false;' >#=KPI_NM# (#=UNIT_NM#)</a>"
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
                    template: function(dataItem){
                    	var befPrf = "";
                        if(dataItem.BEF_PRF!=null) befPrf= dataItem.BEF_PRF;
                        var sts = "";
                        var color = "";
                        if(dataItem.CMPT_EVL_CMPL_FLAG!="3") { sts= "readOnly"; color="background-color:#eeeeee;"; }
                        
                    	return "<input type='text' id='bef_prf_"+dataItem.RNUM+"' name='bef_prf_"+dataItem.RNUM+"' value='"+befPrf+"' onkeyup='setKpiValue(\"bef_prf\", "+dataItem.RNUM+", this);  ' class='k-input input_95' style='text-align:center; "+color+" ' "+sts+" />";
                    }
                    //template: "<input type=\"text\" id=\"bef_prf_#:RNUM#\" name=\"bef_prf_#:RNUM#\" value=\"# if(BEF_PRF != null){##:BEF_PRF## }#\" onkeyup=\"setKpiValue('bef_prf', #:RNUM#)\" class=\"k-input input_95\" style=\"text-align:center; \" # if(CMPT_EVL_CMPL_FLAG != 3){#readOnly# }# />"
                 },
                { field:"NOW_TARG", title: "당기목표",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template: function(dataItem){
                        var nowTarg = "";
                        if(dataItem.NOW_TARG!=null) nowTarg= dataItem.NOW_TARG;
                        var sts = "";
                        var color = "";
                        if(dataItem.CMPT_EVL_CMPL_FLAG!="3") { sts= "readOnly"; color="background-color:#eeeeee;"; }
                        
                        return "<input type='text' id='now_targ_"+dataItem.RNUM+"' name='now_targ_"+dataItem.RNUM+"' value='"+nowTarg+"' onkeyup='setKpiValue(\"now_targ\", "+dataItem.RNUM+", this);  ' class='k-input input_95' style='text-align:center; "+color+" ' "+sts+" />";
                    }
                    //template: "<input type=\"text\" id=\"now_targ_#:RNUM#\" name=\"now_targ_#:RNUM#\" value=\"# if(NOW_TARG != null){##:NOW_TARG## }#\" onkeyup=\"setKpiValue('now_targ', #:RNUM#)\" class=\"k-input input_95\" style=\"text-align:center; \" />"
                },
                { field:"NOW_PRF", title: "당기실적",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}
                },
                { field:"PRIO", title: "우선<br>순위",  width:60, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template: function(dataItem){
                        var prio = "";
                        if(dataItem.PRIO!=null) prio= dataItem.PRIO;
                        var sts = "";
                        var color = "";
                        if(dataItem.CMPT_EVL_CMPL_FLAG!="3") { sts= "readOnly"; color="background-color:#eeeeee;"; }
                        
                        return "<input type='text' id='prio_"+dataItem.RNUM+"' name='prio_"+dataItem.RNUM+"' value='"+prio+"' onkeyup='setKpiValue(\"prio\", "+dataItem.RNUM+", this); ' class='k-input input_95' style='text-align:center; "+color+" ' "+sts+" />";
                    }
                    //template: "<input type=\"text\" id=\"prio_#:RNUM#\" name=\"prio_#:RNUM#\" value=\"# if(PRIO != null){##:PRIO## }#\" onkeyup=\"setKpiValue('prio', #:RNUM#)\" class=\"k-input input_95\" maxChar=\"2\" style=\"text-align:center; \" />"
                },/*
                { field:"DIFF", title: "난이도",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },*/
                { field:"SCLS_ST", title: "S<br>"+sclass,  width:100, 
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
                { field:"ACLS_ST", title: "A<br>"+aclass,  width:100, 
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
                { field:"BCLS_ST", title: "B<br>"+bclass,  width:100, 
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
                { field:"CCLS_ST", title: "C<br>"+cclass,  width:100, 
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
                { field:"DCLS_ST", title: "D<br>"+dclass,  width:100, 
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
                { title: "실적등록",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template : function(dataItem){
                    	
                    	if(dataItem.USEFLAG == "Y"){
                    		
                    		var btnLabel = "";
	                    	if(dataItem.CMPT_EVL_CMPL_FLAG == "1"){
	                            return "-";
	                        }else if(dataItem.CMPT_EVL_CMPL_FLAG == "2"){
	                        	btnLabel = "열람";
	                        }else if(dataItem.CMPT_EVL_CMPL_FLAG == "3"){
	                        	return "-";
	                        }else if(dataItem.CMPT_EVL_CMPL_FLAG == "4"){
	                            if(dataItem.NCNT==0){
	                            	btnLabel = "등록";
	                            }else{
	                            	btnLabel = "등록완료";
	                            }
	                        }else if(dataItem.CMPT_EVL_CMPL_FLAG == "5"){
	                        	btnLabel = "열람";
	                        }else{
	                        	return "-";
	                        }
	                    	
	                    	return "<input type='button' class='k-button' style='width:45' value='"+btnLabel+"' onclick='fn_prfMgmt("+dataItem.KPI_NO+");'/>";

                        }else{
                        	return "-";
                        }
	                    	
                    }
                },
                { field:"DEL", title: "삭제",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} ,
                    template:function(dataItem){
                    	if(dataItem.USEFLAG == 'N'){
                    		return "삭제됨";
                    	}else{
                    		
	                    	if(dataItem.STS=="3"){
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
                    //template : "<input type='button' class='k-button k-i-cancel' style='width:45' value='삭제' onclick='fn_kpiRemove(#:KPI_NO#);'/>"
                }
            ],
            filterable: false,
            sortable: false, pageable: false, height: 420,
            dataBound:function(e){
            	//현상태 데이터와 그리드 데이터 중 먼저 도착한 데이터의 값에 따라 적용..
            	if(currentStsCode && currentStsCode == "5"){
                    $("#evlTotalScoreUl").show();
                    if($('#grid').data('kendoGrid').dataSource.data().length>0){
                        $("#evlTotalScore").text( $('#grid').data('kendoGrid').dataSource.data()[0].EVL_TOTAL_SCORE );
                    }
                }else{
                	$("#evlTotalScoreUl").hide();
                }
            	//alert(currentStsCode);
            }
        });
        
        // 저장 버튼 클릭
        $("#saveKpiBtn").click( function (){
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
            
            var isConfirm = confirm("저장하시겠습니까?");
            if(isConfirm){
                var params = {
                        LIST :  $('#grid').data('kendoGrid').dataSource.data() 
                };
                
                $.ajax({
                   type : 'POST',
                   url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/save_kpi_user.do?output=json",
                   data : { item: kendo.stringify( params ), RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val(), REG_TYPE_CD: "2" },
                   complete : function( response ){
                       var obj  = eval("(" + response.responseText + ")");
                       if(obj.saveCount != 0){
                           $('#grid').data('kendoGrid').dataSource.read();
                           alert("저장되었습니다.");  
                       }else{
                           alert("저장에 실패 하였습니다.");
                       }                           
                   },
                   error: function( xhr, ajaxOptions, thrownError){                                
                   },
                   dataType : "json"
               });     
           }
        });
        
		//승인요청 버튼 클릭
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
		        if(array[i].USEFLAG == "Y"){
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
		    }
		    
		    var isConfirm = confirm("승인요청하시겠습니까?");
		    if(isConfirm){
		    	var saveDiv = "";
		    	if(currentStsCode=="3"){
		    		//목표승인요청
		    		saveDiv = "T";
		    	}else if(currentStsCode=="4"){
		    		//실적승인요청
		    		saveDiv = "P";
		    	}
		    	
		        var params = {
		                LIST :  $('#grid').data('kendoGrid').dataSource.data() 
		        };
		        
		        $.ajax({
		           type : 'POST',
		           url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/save_appr_req_user.do?output=json",
		           data : { item: kendo.stringify( params ), RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val(), SAVE_DIV: saveDiv },
		           complete : function( response ){
		               var obj  = eval("(" + response.responseText + ")");
		               if(obj.saveCount != 0){
		            	   //현상태 재 조회
		            	   if($("#runList").val()!=null && $("#runList").val()!=""){
		            		    getCurrentSts();
		            	   }
		            	   //그리드 재 조회
		            	   $('#grid').data('kendoGrid').dataSource.read();
		                   
		                   alert("승인요청 하였습니다.");  
		               }else{
		                   alert("승인요청 작업이 실패 하였습니다.");
		               }                           
		           },
		           error: function( xhr, ajaxOptions, thrownError){                                
		           },
		           dataType : "json"
		       });     
		   }
		});
        
		
		//지표추가 버튼 클릭
        $("#addKpiBtn").click( function(){
            
            $("#jkRnum").val(-1);
            
            if( !$("#kpiList-window").data("kendoWindow") ){
                $("#kpiList-window").kendoWindow({
                    width:"1000px",
                    minHeight:"400px",
                    resizable : true,
                    title : "KPI검색",
                    modal: true,
                    visible: false
                });
            
            
                $("#kpiListGrid").empty();
                $("#kpiListGrid").kendoGrid({
                    dataSource: {
                        type: "json",
                        transport: {
                            read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/kpi_user_use_list.do?output=json", type:"POST" },
                            parameterMap: function (options, operation){
                                 return { };
                            }
                        },
                        schema: {
                             data: "items",
                             model: {
                                 fields: {
                                        KPI_NO : { type: "number" },
                                        KPI_NM : { type: "string" },
                                        KPI_TYPE_NM : { type: "string" },
                                        MEA_EVL_CYC_NM : { type: "string" },
                                        EVL_TYPE_NM : { type: "string" },
                                        EVL_HOW_NM : { type: "string" },
                                        UNIT_NM : { type: "string" },
                                        RNUM : { type: "number" }
                                    }
                             }
                        },
                        serverPaging: false, serverFiltering: false, serverSorting: false
                    },
                    columns: [
                        { field:"KPI_TYPE_NM", title: "지표유형", filterable: true, width:100, 
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:left"} 
                         },
                         { field:"KPI_NM", title: "지표명", filterable: true, width: 300,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:left"} 
                         },
                         { field:"MEA_EVL_CYC_NM", title: "관리주기", filterable: true,  width:100, 
                             headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                             attributes:{"class":"table-cell", style:"text-align:center"} 
                          },
                          { field:"EVL_TYPE_NM", title: "Characteristic", filterable: true, width:100, 
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                           },
                         { field:"EVL_HOW_NM", title: "관리유형", filterable: true,  width:100, 
                             headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                             attributes:{"class":"table-cell", style:"text-align:center"} 
                          },
                          { field:"UNIT_NM", title: "단위", filterable: true,  width:100, 
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:center"} 
                           },
                           {
                               title: "선택", filterable: false, width: 100,
                               headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                               attributes:{"class":"table-cell", style:"text-align:center"} ,
                               template: function(dataItem){
                                   
                                   return "<input type='button' class='k-button k-i-close' style='size:20' value='선택' onclick='fn_selectKpi(\""+dataItem.KPI_NO+"\", \""+dataItem.MEA_EVL_CYC+"\");'/>";
                               }
                           }
                    ],
                     filterable: {
                         extra : false,
                         messages : {filter : "필터", clear : "초기화"},
                         operators : { 
                             string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
                             number : { eq : "같음", gte : "이상", lte : "이하"}
                         }
                     },
                     sortable: true, pageable: false, height: 380
                 });
                
                //지표를 생성할 수 있는 권한이 있는지 확인하여 처리
                if(kpiAddFlag=="Y"){
                	
                	//지표생성 버튼 클릭 - 추가할 지표가 없는 경우 사용자가 직접 지표를 등록하여 추가함.
                    $("#regKpiBtn").click(function(){
                    	//지표 추가 팝업 닫고.. 
                    	$("#kpiList-window").data("kendoWindow").close();
                    	
                    	//지표를 생성하는 팝업 호출한다.
                    	if( !$("#kpiReg-window").data("kendoWindow") ){
	                    	$("#kpiReg-window").kendoWindow({
	                            width:"650px",
	                            minHeight:"500px",
	                            resizable : true,
	                            title : "개인지표등록",
	                            modal: true,
	                            visible: false
	                        });
	                    	
	                    	var dataSource_unit = new kendo.data.DataSource({
	                            type: "json",
	                            transport: {
	                                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
	                                parameterMap: function (options, operation){  
	                                  return {  STANDARDCODE : "C110" };
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
	                        
	                       var dataSource_type = new kendo.data.DataSource({
	                            type: "json",
	                            transport: {
	                                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
	                                parameterMap: function (options, operation){  
	                                  return {  STANDARDCODE : "C106" };
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
	                        
	                       
	                       var dataSource_meaEvlCyc = new kendo.data.DataSource({
	                           type: "json",
	                           transport: {
	                               read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_commonCode_list.do?output=json", type:"POST" },
	                               parameterMap: function (options, operation){  
	                                 return {  STANDARDCODE : "C107" };
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
	                       
	                    	$("#kpiUnit").kendoDropDownList({
	                            dataTextField: "TEXT",
	                            dataValueField: "VALUE",
	                            dataSource: dataSource_unit,
	                            filter: "contains",
	                            suggest: true,
	                            placeholder : "" ,
	                        });
	                        
	                       $("#kpiType").kendoDropDownList({
	                           dataTextField: "TEXT",
	                           dataValueField: "VALUE",
	                           dataSource: dataSource_type,
	                           filter: "contains",
	                           suggest: true,
	                           placeholder : "" ,
	                       });
	                       
	                      $("#kpiMeaEvlCyc").kendoDropDownList({
	                          dataTextField: "TEXT",
	                          dataValueField: "VALUE",
	                          dataSource: dataSource_meaEvlCyc,
	                          filter: "contains",
	                          suggest: true,
	                          placeholder : "" ,
	                      });
	                      
	                      //설명보기 팝업 호출
	                      $("#explainBtn").click(function(){
	                          if( !$("#kpiExplain-window").data("kendoWindow") ){
	                              $("#kpiExplain-window").kendoWindow({
	                                  width:"650px",
	                                  resizable : true,
	                                  title : "개인지표등록설명",
	                                  modal: false,
	                                  visible: false
	                              });
	                          }
	                          $("#kpiExplain-window").data("kendoWindow").center();
	                          $("#kpiExplain-window").data("kendoWindow").open();   
	                      });

                          //지표생성 팝업의 저장버튼클릭 시.
                          $("#saveKpiRegBtn").click(function(){

                              if($("#kpiName").val()=="") {
                                  alert("지표명을 입력해 주십시오.");
                                  $("#kpiName").focus();
                                  return false;
                              }
                              if($("#kpiType").val()=="") {
                                  alert("지표유형을 선택해주세요");
                                  $("#kpiType").focus();
                                  return false;
                              }  
                              if($("#kpiMeaEvlCyc").val()=="") {
                                  alert("관리주기를 선택해주세요");
                                  $("#kpiMeaEvlCyc").focus();
                                  return false;
                              } 
                              if($(':radio[id="evlType"]:checked').val()==null) {
                                  alert("Characteristic을 체크해주세요");
                                  $(':radio[id="evlType"]').focus();
                                  return false;
                              }
                              if($(':radio[id="evlHow"]:checked').val()==null) {
                                  alert("관리유형을 체크해주세요");
                                  $(':radio[id="evlHow"]').focus();
                                  return false;
                              }
                              if($("#kpiUnit").val()=="") {
                                  alert("단위를 선택해주세요");
                                  $("#kpiUnit").focus();
                                  return false;
                              }
                              
                              var isSave = confirm("저장하시겠습니까?");
                              if(isSave){
                                  var params = {
                                      KPINUMBER : $("#kpiNumber").val(),
                                      KPINAME : $("#kpiName").val(),
                                      KPITYPE : $("#kpiType").val(), 
                                      MEAEVLCYC : $("#kpiMeaEvlCyc").val(), 
                                      EVLTYPE : $(':radio[id="evlType"]:checked').val(),
                                      EVLHOW : $(':radio[id="evlHow"]:checked').val(),
                                      UNIT : $("#kpiUnit").val(), 
                                      CAP : $("#cap").val(),
                                      TARGET : $("#target").val(),
                                      THRESHOLD : $("#threshold").val(),
                                      TARGET_SET_WRNT : $("#targetSetWrnt").val(),
                                      DATASOURCE : $("#dataSource").val(),
                                      MGMT_DEPT : $("#mgmtDept").val() 
                                  };
                                  
                                  $.ajax({
                                      type : 'POST',
                                      url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/ca_user_kpi_save.do?output=json",
                                      data : { item: kendo.stringify( params ), RUN_NUM : $("#runList").val() },
                                      complete : function( response ){
                                          var obj  = eval("(" + response.responseText + ")");
                                          if(obj.error){
                                        	  alert("ERROR:"+obj.error.message);
                                          }else{
                                        	  
	                                          if(obj.saveCount != 0){
	                                              $("#grid").data("kendoGrid").dataSource.read();     

	                                              alert("저장되었습니다.");  

	                                              $("#kpiReg-window").data("kendoWindow").close();
	                                              
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
                              
                          });
                          
	                      //지표생성 팝업의 취소버튼클릭 시.
	                      $("#cencelKpiRegBtn").click(function(){
	                    	  $("#kpiReg-window").data("kendoWindow").close();
	                      });
                    	}
                    	
                    	$("#kpiReg-window").data("kendoWindow").center();
                        $("#kpiReg-window").data("kendoWindow").open();
                    	
                    });

                }else{
                	$("#regKpiArea").hide();
                }               
            }else{
                $('#kpiListGrid').data('kendoGrid').dataSource.read();
            }
            
            $("#kpiList-window").data("kendoWindow").center();
            $("#kpiList-window").data("kendoWindow").open();
            
        });
		
    }
    

    //kpi 지표 삭제..
    function fn_kpiRemove(kpiNo){

        var array = $('#grid').data('kendoGrid').dataSource.data();
        var res = $.grep(array, function (e) {
            return e.KPI_NO == kpiNo;
        });
        
        if(res[0].NOW_PRF && res[0].NOW_PRF > 0){
            alert("당기실적이 있는 지표는 삭제할 수 없습니다.");
            return false;
        }
        
        if(confirm("삭제하시겠습니까? \n확인을 클릭하시면 다른 지표의 저장되지 않은 입력한 값이 삭제됩니다.")){

            $.ajax({
                type : 'POST',
                url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/del_kpi_map.do?output=json",
                data : { RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val(), KPI_NO : kpiNo },
                complete : function( response ){
                    var obj  = eval("(" + response.responseText + ")");
                    if(obj.error){
                    	alert("ERROR:"+obj.error.message);
                    }else{
                        if(obj.saveCount > 0){
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
    
    function fn_selectKpi(kpiNo, mea_evl_cyc){
        //이미 추가된 지표인지 체크
        var array = $('#grid').data('kendoGrid').dataSource.data();
        for(var i=0; i<array.length; i++){
            //alert(array[i].KPI_NO+","+kpiNo);
            if(array[i].KPI_NO!=null && array[i].KPI_NO!=""){
                if(array[i].KPI_NO == kpiNo){
                    alert("이미 추가된 지표입니다.");
                    return;
                }
            }
        }
        //alert(runClass.EVL_PRD_CD+","+mea_evl_cyc);
        //상반기, 하반기 성과평가인 경우 관리주기 주기가 연단위인 지표는 설정하지 못하도록 제어..
        if(runClass.EVL_PRD_CD=="1" || runClass.EVL_PRD_CD=="2"){
            if(mea_evl_cyc == "4"){
                var div;
                if(runClass.EVL_PRD_CD=="1"){
                    div = "상반기";
                }else{
                    div = "하반기";
                }
                alert("성과평가의 기간이 "+div+"로 설정되어있기 때문에\n관리주기가 연단위인 지표는 매핑할 수 없습니다.");
                return false;
            }
        }
        
        $.ajax({
            type : 'POST',
            url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/add_kpi_self_user_map.do?output=json",
            data : { RUN_NUM : $("#runList").val(), TG_USERID : $("#TG_USERID").val(), KPI_NO : kpiNo },
            complete : function( response ){
                var obj  = eval("(" + response.responseText + ")");
                if(obj.error){
                	alert("ERROR:"+obj.error.message);
                }else{
                	if(obj.saveCount > 0){
                        $('#grid').data("kendoGrid").dataSource.read();
                        $("#kpiList-window").data("kendoWindow").close();
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
            $("#savePrfBtn").click(function(){
            	var array = $('#otcPrfGrid').data('kendoGrid').dataSource.data();            
                
            	//월별 등록해야할 실적 모두 입력했는지 체크..
            	for(var i=1; i<=12; i++){
            		if($("#prf"+i).length>0 && !$("#prf"+i).attr("readOnly")){
            			//alert(array[0].get("PRF_"+i));
            			if(array[0].get("PRF_"+i) == null || array[0].get("PRF_"+i).length == 0){
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
                       url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/kpi/save_user_prf.do?output=json",
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
        var runInfo = $("#runList").data("kendoComboBox").dataItem();
        var runEvlPeriod = runInfo.EVL_PRD_CD; //성과평가 평가기준기간 ( 1:상반기, 2:하반기 3:연 )
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
            title: "달성율",
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
                    if((dataItem.STS_1!=null && dataItem.STS_1!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"01")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                    if((dataItem.STS_2!=null && dataItem.STS_2!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"02")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                    if((dataItem.STS_3!=null && dataItem.STS_3!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"03")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
                    if(kpiEvlPeriod==1 || kpiEvlPeriod==2){
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
                    if((dataItem.STS_4!=null && dataItem.STS_4!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"04")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                    if((dataItem.STS_5!=null && dataItem.STS_5!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"05")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                    if((dataItem.STS_6!=null && dataItem.STS_6!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"06")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                    if((dataItem.STS_7!=null && dataItem.STS_7!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"07")) )  { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                    if((dataItem.STS_8!=null && dataItem.STS_8!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"08")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                    if((dataItem.STS_9!=null && dataItem.STS_9!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"09")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                    if((dataItem.STS_10!=null && dataItem.STS_10!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"10")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                    if((dataItem.STS_11!=null && dataItem.STS_11!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"11")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                    if((dataItem.STS_12!=null && dataItem.STS_12!="") || (Number(dataItem.YYYYMM) < Number(dataItem.YYYY+"12")) ) { sts= "readOnly"; color="background-color:#eeeeee;"; }
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
                        var myWindow = window.open(windowUrl, "_blank", "toolbar=no, scrollbars=no, resizable=no, top=500, left=500, width=405, height=250");
                    }                           
                });
                $('button.custom-button-delete').click( function(e){
                    
                    alert ("delete");
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
                	handleCallbackUploadResult();
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
	    <input type="hidden" name="RUN_NUM" id="RUN_NUM" />
	    <input type="hidden" name="TG_USERID" id="TG_USERID" />
	    <input type="hidden" name="JOB" id="JOB" />
	    <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" />
	    <input type="hidden" name="KPI_NO" id="KPI_NO" />
	    <input type="hidden" name="objectId" id="objectId" />
        <input type="hidden" name="jkRnum" id="jkRnum" />
	</form>
	<div id="content">
		<div class="cont_body">
			<div class="title">성과관리</div>
			<div class="top"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_top02.gif" alt=""/></div>
			<div class="middle">성과평가의 목적은 순위 매기기나 단순 결과의 측정이 아니며, 조직 및 개인의 “성과향상”에 있습니다. <br>
이를 위해서는 결과측정 및 실적입력에만 몰두할 것이 아니라, <br>ⅰ) 부서 및 개인의 성과가 조직목표에 부합하도록 하고,<br> 
ⅱ) 향후 개선을 위한 현재 성과의 원인 파악에 집중해야 합니다.
            </div>
			<div class="bottom"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom02.gif" alt=""/></div>
			<div class="table_tin">
                <ul>
                    <li class="line"><label for="searchType">평가 년도</label> : 
                                    <select name="yyyy" width="80" id="yyyy"></select></li>
                    <li><label for="searchType1">평가명</label> : <select name="runList" class="in_select" id="runList"></select></li>
                </ul>
                <ul>
                    <li class="line1">현상태 : <span id="otcEvlSts"></span></li>
                </ul>
                <ul id="evlTotalScoreUl" style="display:none;">
                    <li class="line1">최종점수 : <span id="evlTotalScore"></span></li>
                </ul>
            </div>
            
			<div class="table_zone">
			     <div id="tabstrip" style="border-style:none;"></div>
				<div id="grid" style="height:100%; "></div>
			</div>
			
			<div style="text-align:right; padding-top:10px;">
			<span id="addKpiLabel">※ 위 목록에 없는 성과를 추가하고자 할 경우 “지표추가＂를 클릭하십시오.</span>
                        <!-- <button id="saveKpiBtn" class="k-button" >저장</button> -->
                        <button id="addKpiBtn" class="k-button" >지표추가</button>
                        <button id="apprReqBtn" class="k-button" ><span id="apprReqLabel"></span></button>
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
	        <div style="float:left;width:100%;margin-top:10px;min-height:70px;">
	           <div id="otcPrfGrid" ></div>
	           * 실적, 달성율은 부서장의 실적승인을 득해야 적용됩니다.
	        </div>
	        
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
    
    <!-- KPI검색 팝업 -->
    <div id="kpiList-window" style="display:none;">
        <div id="regKpiArea">
	        <div style="float:left;"><span >※ 추가하고자 하는 지표가 없을 경우 지표를 생성하십시오.</span></div>
	        <div style="text-align:right;"><button id="regKpiBtn" class="k-button" >지표생성</button></div>
        </div>
        <div id="kpiList-window-selecter" style="padding-top:5px;">
            <div id="kpiListGrid"></div>
        </div>
    </div>

    <!-- kpi지표 생성 팝업 -->
    <div id="kpiReg-window" style="display:none; overflow-y:auto; height:500px;">
        <div style="text-align:right;">
            <button id="explainBtn" class="k-button">설명보기</button>
        </div>
        <table class="tabular" id="tabular" style="width:100%; margin-top: 5px;" >
            <tr>
                <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 지&nbsp&nbsp표&nbsp&nbsp명 <span style="color:red">*</span></td>
                <td class="subject"><input type="text" class="k-textbox" id="kpiName" style="width:97%;" onKeyUp="chkNull(this);" />           
                </td>
            </tr>               
            <tr>
                <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 지표유형 <span style="color:red">*</span></td>
                <td class="subject"><input type="text" id="kpiType" style="width:96%; text-align:left"></select>
                </td>
            </tr>
            <tr>
                <td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리주기 <span style="color:red">*</span></td>
                <td class="subject"><input type="text" id="kpiMeaEvlCyc" style="width:96%; text-align:left"></select></td>
            </tr>
            <tr>
                <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Characteristic <span style="color:red">*</span></td> 
                <td class="subject"><input type="radio" id="evlType" name="evlType"  value="1"/> 정량</input>
                <span style="padding-left:70px"><input type="radio" id="evlType" name="evlType"  value="2"/> 정성</input>
            </tr>       
            <tr>
                <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리유형 <span style="color:red">*</span></td> 
                <td class="subject"><input type="radio" id="evlHow" name="evlHow"  value="1" /> 합계</input>
                &nbsp&nbsp&nbsp&nbsp<input type="radio" id="evlHow" name="evlHow"  value="2"/> 평균</input>
                &nbsp&nbsp&nbsp&nbsp<input type="radio" id="evlHow" name="evlHow"  value="3"/> 누적</input></td>
            </tr>                   
            <tr>
                <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 단위 <span style="color:red">*</span></td>
                <td class="subject"><input type="text" id="kpiUnit" style="width:80px; text-align:left"></select></td>
            </tr>
             <tr>
                <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Cap </td>
                <td class="subject"><input type="text" class="k-textbox" id="cap" style="width:97%;" onKeyUp="chkNull(this), chkNum (this);" />           
                </td>
            </tr>
             <tr>
                <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Target </td>
                <td class="subject"><input type="text" class="k-textbox" id="target" style="width:97%;" onKeyUp="chkNull(this), chkNum (this);" />         
                </td>
            </tr>   
             <tr>
                <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Threshold </td>
                <td class="subject"><input type="text" class="k-textbox" id="threshold" style="width:97%;" onKeyUp="chkNull(this), chkNum (this);" />           
                </td>
            </tr>
            <tr>
                <td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Target 설정근거 </td>
                <td class="subject"><textarea cols="40" rows="4"  type="text" id="targetSetWrnt" style="width:96%;" ></textarea></td>
            </tr>
            <tr>
                <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Data Source </td>
                <td class="subject"><input type="text" class="k-textbox" id="dataSource" style="width:97%;" onKeyUp="chkNull(this);" />            
                </td>                       
            </tr>
            <tr>
                <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리부서 </td>
                <td class="subject"><input type="text" class="k-textbox" id="mgmtDept" style="width:97%;" onKeyUp="chkNull(this);" />           
                </td>                       
            </tr>
        </table>
                
        <div style="text-align:right; margin-top: 5px; margin-bottom: 20px; ">
            <button id="saveKpiRegBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
            <button id="cencelKpiRegBtn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>
        </div>
    </div>

	<!-- kpi 지표등록 설명 팝업 -->
    <div id="kpiExplain-window" style="display:none;">
        <table class="tabular" id="tabular" style="width:100%; margin-top: 5px;" >
            <colgroup>
                <col style="width:120px">
                <col style="width:500px">
            </colgroup>
            <thread>
                <tr style="height:55px;">
                    <th class="subject" style="background-color: #e3e3e3; border-color: #C5C5C5; border-style: solid; border-width: 1px 1px 1px 1px; text-align:center;">항목</th>
                    <th class="subject" style="background-color: #e3e3e3; border-color: #C5C5C5; border-style: solid; border-width: 1px 1px 1px 1px; text-align:center;">설명</th>
                </tr>
            </thread>
            <tr>
                <td width="100px" class="subject"  > 지&nbsp&nbsp표&nbsp&nbsp명 </td>
                <td class="subject">지표의 이름을 적습니다.</td>
            </tr>               
            <tr>
                <td width="100px" class="subject"  > 지표유형 </td>
                <td class="subject">회사에서 정해놓은 지표의 유형을 선택합니다. 임직원 개개인이 추가할 수 없으며 추가를 원할 시 운영자에게 문의해 주시기 바랍니다.</td>
            </tr>
            <tr>
                <td width="100px"  class="subject" > 관리주기 </td>
                <td class="subject">지표에 대한 실적을 등록하는 주기를 선택합니다.</td>
            </tr>
            <tr>
                <td width="100px" class="subject"  > Characteristic </td> 
                <td class="subject">지표의 성격이 정량적인 것인지 정성적인 것인지를 선택합니다.</td>
            </tr>       
            <tr>
                <td width="100px" class="subject"  > 관리유형 </td> 
                <td class="subject">. 합계 – 등록한 실적들의 총합<br>
. 평균 – 등록한 실적들의 평균<br>
. 누적 – 가장 나중에 등록한 실적</td>
            </tr>                   
            <tr>
                <td width="100px" class="subject"  > 단위 </td>
                <td class="subject">지표의 단위를 선택합니다</td>
            </tr>
        </table>
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

.tabular td {
	padding: 15px;
	text-align: center;
	border-top: 1px solid #dfdfdf;
    border-bottom: 1px solid #dfdfdf;
    border-right: 1px solid #dfdfdf;
	border-left: 1px solid #dfdfdf;
}
.tabular td.subject {
    text-align: left;
}
</style>
            
</body>
</html>