<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<script type="text/javascript">	

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
			openwindow();
			
		}
	}]);       
    
    //그리드 세팅.
    function openwindow() {
    	//grid 세팅
        $("#grid").empty();
        $("#grid").kendoGrid({
               dataSource: {
                    type: "json",
                    transport: {
                        read: { url:"/deptmgr/cam/dept_cmpt_evl_run_list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){ 
                            return {  startIndex: options.skip, pageSize: options.pageSize  };
                        }        
                    },
                    schema: {
                        total: "totalItemCount",
                        data: "items",
                           model: {
                               fields: {
                                   RUN_NUM  : { type: "int" },
                                   YYYY : { type: "string" },
                                   RUN_NAME : { type : "string" },
                                   RUN_START : {type:"string"},
                                   RUN_END : { type:"string" },
                                   T_CNT : { type: "int" },
                                   C_CNT : { type: "int" },
                                   EVL_CMD : { type:"string"}
                               }
                           }
                    },
                    pageSize: 20,
                    serverPaging: false,
                    serverFiltering: false,
                    serverSorting: false
                },
                columns: [
                    {
                        field:"YYYY",
                        title: "해당년도",
                        width: 150,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    {
                        field:"RUN_NAME",
                        title: "평가명",
                        filterable: false,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"}
                    },
                    {
                    	field:"RUN_START",
                        title: "평가기간",
                        filterable: false,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                            return dataItem.RUN_START+" ~ "+dataItem.RUN_END;
                        } 
                    },
                    {
                        field:"T_CNT",
                        title: "참여인원",
                        width: 100,
                        filterable: false,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    {
                        field:"C_CNT",
                        title: "완료인원",
                        width: 100,
                        filterable: false,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    {
                        title: "평가하기",
                        width:180,
                        filterable: false,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template: function (dataItem) {
                            if(dataItem.EVL_CMD == "평가하기"){
                                return "<input type='button' class='k-button k-i-close' style='size:20' value='평가하기' onclick='fn_evlExec("+dataItem.RUN_NUM+");return false;'/>"
                            }else{
                                return dataItem.EVL_CMD;
                            }
                        }
                    },
                    {
                        title: "평가분석",
                        width:180,
                        filterable: false,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                        	if(dataItem.EVL_CMD == "평가종료"){
                        		return "<input type='button' class='k-button k-i-close' style='size:20' value='분석' onclick='fn_analy("+dataItem.RUN_NUM+");return false;'/>"
                        	}else{
                        		return "분석";
                        	}
                        }
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
    
    //분석 버튼 
    function fn_analy(runNum){
    	//alert(runNum);
    	
    	$("#RUN_NUM").val(runNum);
        document.frm.submit();
    }
    
    // 평가하기 버튼
    function fn_evlExec(runNum){
    	//alert(runNum);
    	//var str = "평가하시겠습니까?";
    	//if(confirm(str)){
    		$("#RUN_NUM").val(runNum);
    		document.frm.submit();
        //}

    	if(event.preventDefault){
            event.preventDefault();
        } else {
            event.returnValue = false;
        }
    }
</script>

</head>
<body>
	<form id="frm" name="frm"  method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/cam/dept_cmpt_evl_exed_pg.do">
	    <input type="hidden" name="RUN_NUM" id="RUN_NUM" />
	</form>
	<div id="content">
		<div class="cont_body">
                <div class="title">부서원 역량평가</div>
                <div class="top"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_top02.gif" alt=""/></div>
                <div class="middle">역량평가의 목적은 순위 매기기나 단순 결과의 측정이 아니며, “인재육성”에 있습니다.  <br>
 구성원의 강/약점을 파악하여 피드백을 제공하고, 보상 및 육성과의 연계를 통해 조직의 인재육성을 지향합니다.
</div>
                <div class="bottom"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom02.gif" alt=""/></div>
                <div class="px">※ 평가기간 중에는 [평가하기]를 클릭하여 1차 혹은 2차 평가를 진행하십시오.<br/>※ 평가가 완료되면 [분석]을 클릭하시어 결과를 열람하십시오.</div>
                <div class="table_zone">
                    <div id="grid" style="height:100%; "></div>
                </div>
		</div>
		<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/>
	</div>
</body>
</html>