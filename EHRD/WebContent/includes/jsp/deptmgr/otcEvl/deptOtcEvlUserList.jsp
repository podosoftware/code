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

<%

kr.podosoft.ws.service.kpi.action.ajax.KPIServiceAction action = (kr.podosoft.ws.service.kpi.action.ajax.KPIServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
List yearList = action.getItems();
List items1 = action.getItems1();
long tgUserid = action.getUser().getUserId();

%>
<script type="text/javascript">	
var runListDataSource;

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
            
            runListDataSource = new kendo.data.DataSource({
                type: "json",
                    transport:{
                        read: { url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_otc_run_list.do?output=json", type:"POST" }
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
                    
                    if($("#runList").val()!=""){
                    	$("#grid").data("kendoGrid").dataSource.read();
                    	
                    }else{
                    	$("#grid").data("kendoGrid").dataSource.remove();
                    }
                },
                dataBound:function(){
                	
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
                        
                    }else{
                        alert("대상자로 설정된 성과평가가 존재하지 않습니다.\n교육운영자에게 문의해주세요.");
                    }
                }
                openWindow();
            	
            	
            });
          
			
		}
	}]);       
    
    function openWindow(){
    	
        $("#grid").empty();
        $("#grid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_otc_user_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){
                         return { RUN_NUM : $("#runList").val() };
                    }
                },
                schema: {
                	total: "totalItemCount",
                    data: "items",
                    model: {
                        fields: {
                            RNUM : { type: "number" },
                            DVS_NAME: { type: "string"},
                            NAME: { type: "string" },
                            EMPNO: { type: "string" },
                            JOB_NM: { type: "string" }, 
                            LEADERSHIP_NM: { type: "string" },
                            EVL_TOTAL_SCORE:{ type: "number" },
                            CMPT_EVL_CMPL_FLAG:{ type: "string" }
                        }
                    }
                },
                pageSize: 20,
                serverPaging: false, serverFiltering: false, serverSorting: false
            },
            columns: [
                { field:"RNUM", title: "번호", width:80, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                { field:"DVS_NAME", title: "부서명", width:200, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left"} 
                },
                { field:"NAME", title: "이름", width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center; text-decoration: underline;"},
                    template: function (dataItem) {
                        return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.RUN_NUM+", "+dataItem.USERID+");' >"+dataItem.NAME+"</a>";
                    }
                },
                { field:"EMPNO", title: "교직원번호",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}
                },
                { field:"JOB_NM", title: "직무",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"}
                },
                { field:"LEADERSHIP_NM", title: "계층",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                { field:"EVL_TOTAL_SCORE", title: "최종점수",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                },
                { field:"EVL_STS", title: "현상태",  width:100, 
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:center"} 
                }
            ],
            filterable: true,
            filterable: {
               extra : false,
               messages : {filter : "필터", clear : "초기화"},
               operators : { 
                string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
                number : { eq : "같음", gte : "이상", lte : "이하"}
               }
              },
            sortable: true,
            pageable: { refresh:false, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
            height: 470
            
        });
        
    }
    
    //대상자 지표세팅 및 실적 확인 화면으로 이동
    function fn_detailView(runNum, userid){
    	$("#RUN_NUM").val(runNum);
        $("#TG_USERID").val(userid);
        document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/kpi/dept_otc_service_info.do";
        document.frm.submit();
    }
    
</script>

</head>
<body>
	<form id="frm" name="frm"  method="post" >
	    <input type="hidden" name="RUN_NUM" id="RUN_NUM" />
	    <input type="hidden" name="TG_USERID" id="TG_USERID" />
	    <input type="hidden" name="JOB" id="JOB" />
	    <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" />
	</form>
	<div id="content">
		<div class="cont_body">
			<div class="title">부서원 성과 실적 승인</div>
			<div class="top"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_top02.gif" alt=""/></div>
			<div class="middle">성과평가의 목적은 순위 매기기나 단순 결과의 측정이 아니며, 조직 및 개인의 “성과향상”에 있습니다.<br> 
이를 위해서는 <br>ⅰ) 부서 및 개인의 성과가 조직목표에 부합하도록 하고, <br>ⅱ) 성과 부진 및 성공요인 파악에 집중하며, 
<br>ⅲ) 육성, 보상과의 연계를 통한 실질적 동기를 부여하며, <br>ⅳ) 평가 과정상 Communication 활성화에 집중해야 합니다.
            </div>
			<div class="bottom"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom02.gif" alt=""/></div>
			<div class="table_tin">
                <ul>
                    <li class="line"><label for="searchType">평가 년도</label> : 
                                    <select name="yyyy" width="80" id="yyyy"></select></li>
                    <li><label for="searchType1">평가명</label> : <select name="runList" class="in_select" id="runList"></select></li>
                </ul>
            </div>
            
			<div class="table_zone">
			    <div id="grid" style="height:100%; "></div>
			</div>
			
		</div>
		<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/>
	</div>
	

</body>
</html>