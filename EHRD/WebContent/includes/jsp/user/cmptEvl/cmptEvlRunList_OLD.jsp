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
                        read: { url:"/service/cam/cmpt_evl_run_list.do?output=json", type:"POST" },
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
                                   YYYY : { type: "int" },
                                   RUN_NAME : { type : "string" },
                                   TG_USERID : {type:"int"},
                                   RUN_START : {type:"string"},
                                   RUN_END : { type:"string" },
                                   USERID : { type:"int"},
                                   CMPL_FLAG : { type : "string" },
                                   CMPL_DATE : { type : "string" },
                                   CMD : { type : "string" },
                                   ONE_USERID : { type : "int" },
                                   ONE_NAME : { type : "string" },
                                   ONE_CMPL_FLAG : { type : "string" },
                                   ONE_CMPL_DATE : {type : "string" },
                                   TWO_USERID : { type : "int" },
                                   TWO_NAME : { type : "string" },
                                   TWO_CMPL_FLAG : { type : "string" },
                                   TWO_CMPL_DATE : {type : "string" },
                                   EVL_ANALY : { type : "string" }
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
                        width: 80,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    {
                        field:"RUN_NAME",
                        title: "평가명",
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
                    {
                        title: "평가기간",
                        width:200,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                            //return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.COMPANYID+");' >"+dataItem.COMPANYNAME+"</a>"
                            return dataItem.RUN_START+" ~ "+dataItem.RUN_END;
                        } 
                    },
                    {
                        title: "자가평가",
                        width:180,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template: function (dataItem) {
                        	if(dataItem.SELF_CMPL_FLAG == "Y"){
                                if(dataItem.ONE_START_DATE == null || dataItem.ONE_START_DATE == ""){
                                    //재평가하기
                                    if(dataItem.EVL_CMD == "평가하기"){
                                        return "<input type='button' class='k-button' value='재평가하기' onclick='fn_evlExec(1, "+dataItem.RUN_NUM+","+dataItem.TG_USERID+");'/>"+"<br>"+dataItem.SELF_CMPL_DATE;
                                    }else{
                                        return "[완료]<br>"+dataItem.SELF_CMPL_DATE;
                                    }
                                }else{
                                    //평가 못함
                                    return "[완료]<br>"+dataItem.SELF_CMPL_DATE;
                                }   
                            }else{
                                //평가하기
                                if(dataItem.EVL_CMD == "평가하기"){
                                    return "<input type='button' class='k-button' value='평가하기' onclick='fn_evlExec(2, "+dataItem.RUN_NUM+","+dataItem.TG_USERID+");'/>";
                                }else{
                                    return dataItem.EVL_CMD;
                                }
                            }
                        }
                    },
                    {
                        title: "1차평가자",
                        width:180,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                        	if(dataItem.ONE_USERID!=null){
	                            if(dataItem.ONE_CMPL_FLAG=="Y"){
	                                return dataItem.ONE_NAME+"[완료]<br>"+dataItem.ONE_CMPL_DATE;
	                            }else{
	                            	if(dataItem.EVL_CMD == "평가하기"){
		                            	return dataItem.ONE_NAME+"[대기]";
	                            	}else{
	                            		return dataItem.ONE_NAME+"["+dataItem.EVL_CMD+"]";
	                            	}
	                            }
                        	}else{
                        		return "-";
                        	}
                        }
                    },
                    {
                        title: "2차평가자",
                        width:180,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                        	if(dataItem.TWO_USERID!=null){
                                if(dataItem.TWO_CMPL_FLAG=="Y"){
                                    return dataItem.TWO_NAME+"[완료]<br>"+dataItem.TWO_CMPL_DATE;
                                }else{
                                    if(dataItem.EVL_CMD == "평가하기"){
                                        return dataItem.TWO_NAME+"[대기]";
                                    }else{
                                        return dataItem.TWO_NAME+"["+dataItem.EVL_CMD+"]";
                                    }
                                }
                            }else{
                                return "-";
                            }
                        }
                    },
                    {
                        title: "분석평가",
                        width:80,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                        	var self = false;
                        	var one = false;
                        	var two = false;
                        	
                        	if(dataItem.SELF_CMPL_FLAG=="Y"){
                        		self = true;
                        	}
                        	if(dataItem.ONE_USERID != null){
                                if(dataItem.ONE_CMPL_FLAG=="Y"){
                                	one = true;
                                }
                            }else{
                            	one = true;
                            }
                        	if(dataItem.TWO_USERID != null){
                                if(dataItem.TWO_CMPL_FLAG=="Y"){
                                    two = true;
                                }
                            }else{
                                two = true;
                            }
                            
                        	if(dataItem.EVL_CMD == "평가종료" && self && one && two){
                        		return "<input type='button' class='k-button' value='열람' onclick='fn_analy("+dataItem.RUN_NUM+","+dataItem.TG_USERID+","+dataItem.JOB+","+dataItem.LEADERSHIP+");return false;'/>";
                        	}else{
                        		return "대기";
                        	}
                        }
                    }
                ],
                pageable: { refresh:false, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
                filterable: false,
                sortable: true,
                height: 470
            });

    }
    
    //분석 버튼 
    function fn_analy(runNum, useridExed, job, leadership) {
    	$("#RUN_NUM").val(runNum);
        $("#TG_USERID").val(useridExed);
        $("#JOB").val(job);
        $("#LEADERSHIP").val(leadership);
        
        document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_analysis_cmpt.do"
        document.frm.submit();
    }
  
    // 고객사정보 상세보기.
    function fn_evlExec(runDiv, runNum, tgUserid){
    	//alert(runNum);
    	var str = "";
    	if(runDiv==1){
    		str = "이미 평가를 완료하였습니다. 재평가하시겠습니까?";
    	}else{
    		str = "평가하시겠습니까?";
    	}
    	var isConfirm = confirm(str);
    	if(isConfirm){
    		$("#RUN_NUM").val(runNum);
    		$("#TG_USERID").val(tgUserid);
    		
    		document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/cmpt_evl_self_exec.do";
    		document.frm.submit();
        }

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
	    <input type="hidden" name="RUN_NUM" id="RUN_NUM" />
	    <input type="hidden" name="TG_USERID" id="TG_USERID" />
	    <input type="hidden" name="JOB" id="JOB" />
	    <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" />
	</form>
	<div id="content">
		<div class="cont_body">
			<div class="title">역량평가</div>
			<div class="top"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_top02.gif" alt=""/></div>
			<div class="middle">역량평가의 목적은 순위 매기기나 단순 결과의 측정이 아니며, “인재육성”에 있습니다.  <br>
 역량평가를 통해 자신의 강·약점을 정확히 파악하여 이를 보완하는 과정을 통해 역량향상의 토대를 마련하시기 바랍니다.
</div>
			<div class="bottom"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom02.gif" alt=""/></div>
			<div class="px">※ 자가, 1차, 2차 평가가 완료되면 평가 분석을 볼 수 있습니다.</div>
			<div class="table_zone">
				<div id="grid" style="height:100%; "></div>
			</div>
		</div>
		<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/>
	</div>
</body>
</html>