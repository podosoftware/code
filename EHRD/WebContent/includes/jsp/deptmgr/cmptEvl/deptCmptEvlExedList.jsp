<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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
    height: 50px;
}

</style>
<%

kr.podosoft.ws.service.ca.action.ajax.CAServiceAction action = (kr.podosoft.ws.service.ca.action.ajax.CAServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

List list = action.getItems();
Map map = (Map)list.get(0);

String operatorNm = "";
String operatorPhone = "";
String strTel = "";
List list1 = action.getItems1();
if(list1 !=null && list1.size() > 0){
	Map map1 = (Map)list1.get(0);
	operatorNm = map1.get("NAME").toString();
	operatorPhone = map1.get("DEC_PHONE").toString();
	//out.pring(operatorPhone);
	if(operatorPhone!=null && operatorPhone.length()>0){
		strTel = operatorPhone;
	    String[] strDDD = {"02" , "031", "032", "033", "041", "042", "043",
	                         "051", "052", "053", "054", "055", "061", "062",
	                         "063", "064", "010", "011", "012", "013", "015",
	                         "016", "017", "018", "019", "070"};
	    
	    if (strTel.length() < 9) {
	        
	    } else if (strTel.substring(0,2).equals(strDDD[0])) {
	        strTel = strTel.substring(0,2) + '-' + strTel.substring(2, strTel.length()-4)
	             + '-' + strTel.substring(strTel.length() -4, strTel.length());
	    } else {
	        for(int i=1; i < strDDD.length; i++) {
	            if (strTel.substring(0,3).equals(strDDD[i])) {
	                strTel = strTel.substring(0,3) + '-' + strTel.substring(3, strTel.length()-4)
	                 + '-' + strTel.substring(strTel.length() -4, strTel.length());
	            }
	        }
	    }
	}
}
%>
<script type="text/javascript">	
//현재 세션의 사용자 번호
var exUserid = '<%=action.getUser().getUserId()%>';
var exCmd = '<%=map.get("EVL_CMD")%>';

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
                        read: { url:"/deptmgr/ca/dept_cmpt_evl_exed_list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){ 
                            return { RUN_NUM: <%=map.get("RUN_NUM")%>  };
                        }        
                    },
                    schema: {
                        total: "totalItemCount",
                        data: "items",
                           model: {
                               fields: {
                            	   RNUM : {type : "int" },
                            	   COMPANYID : { type : "int" },
                                   RUN_NUM  : { type: "int" },
                                   USERID_EXED : { type : "int" },
                                   USERID : { type : "int" },
                                   NAME : { type : "string" },
                                   EMPNO : { type : "string" },
                                   DIVISION : { type : "string" },
                                   DVS_NAME : { type : "string" },
                                   JOB_NM : { type : "string" },
                                   LEADERSHIP_NM : { type : "string" },
                                   SELF_CMPL_FLAG : { type : "string" },
                                   SELF_CMPL_DATE : { type : "string" },
                                   ONE_USERID : { type : "int" },
                                   ONE_NAME : { type : "string" },
                                   ONE_CMPL_FLAG : { type : "string" },
                                   ONE_CMPL_DATE : { type : "string" },
                                   ONE_START_DATE : { type : "string" },
                                   TWO_USERID : { type : "int" },
                                   TWO_NAME : { type : "string" },
                                   TWO_CMPL_FLAG : { type : "string" },
                                   TWO_CMPL_DATE : { type : "string" },
                                   TWO_START_DATE : { type : "string" }
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
                        field:"RNUM",
                        title: "번호",
                        width: 60,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    {
                    	field:"DVS_NAME",
                        title: "부서명",
                        width: 150,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"}
                    },
                    {
                        field:"NAME",
                        title: "피평가자(교직원번호, 직무, 계층)",
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"},
                        template: function (dataItem) {
                        	var val = dataItem.NAME+" ( ";
                        	if(dataItem.EMPNO!=null){
                        		val = val + dataItem.EMPNO;
                        	}else{
                        		val = val + "-";
                        	}
                        	val = val + ", ";
                        	if(dataItem.JOB_NM!=null){
                                val = val + dataItem.JOB_NM;
                            }else{
                                val = val + "-";
                            }
                            val = val + ", ";
                        	if(dataItem.LEADERSHIP_NM!=null){
                                val = val + dataItem.LEADERSHIP_NM;
                            }else{
                                val = val + "-";
                            }
                            
                        	val = val + " )";
                        	return val;
                        }
                    },
                    {
                        title: "자가",
                        width: 170,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                            if(dataItem.SELF_CMPL_FLAG == "Y"){
                                return "[완료]<br>"+dataItem.SELF_CMPL_DATE;
                            }else if(dataItem.SELF_START_DATE!=null && dataItem.SELF_START_DATE != ""){
                            	return "[평가중]";
                            }else{
                                return "[미실시]";
                            }
                        }
                    },
                    {
                        title: "1차평가",
                        width: 170,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                        	if(dataItem.ONE_USERID!=null){
	                            if(dataItem.ONE_USERID == exUserid){
	                            	if(dataItem.SELF_CMPL_FLAG == "Y"){
	                            		if(dataItem.ONE_CMPL_FLAG == "Y"){
	                            			if(dataItem.TWO_START_DATE == null || dataItem.TWO_START_DATE == ""){
	                            				//재평가하기
	                            				if(exCmd == "평가하기"){
	                            				    return "<input type='button' class='k-button' value='재평가하기' onclick='fn_evlExec(1, "+dataItem.RUN_NUM+","+dataItem.USERID_EXED+", 1);'/>"+"<br>"+dataItem.ONE_CMPL_DATE;
	                            				}else{
	                            					return dataItem.ONE_NAME+"[완료]<br>"+dataItem.ONE_CMPL_DATE;
	                            				}
	                            			}else{
	                            				//평가 못함
	                            				return dataItem.ONE_NAME+"[완료]<br>"+dataItem.ONE_CMPL_DATE;
	                            			}   
	                            		}else{
	                            			//평가하기
	                            			if(exCmd == "평가하기"){
	                            			    return "<input type='button' class='k-button' value='평가하기' onclick='fn_evlExec(2, "+dataItem.RUN_NUM+","+dataItem.USERID_EXED+", 1);'/>";
	                            			}else{
	                                            return exCmd;
	                                        }
	                            		}
	                            	}else{
	                            		return "진단대기";
	                            	}
	                            }else{
	                            	var oneReturn=dataItem.ONE_NAME;
	                            	if(dataItem.ONE_CMPL_FLAG=="Y"){
	                            		oneReturn = oneReturn + "[완료]<br>"+dataItem.ONE_CMPL_DATE;
	                            	}else{
	                            		oneReturn = oneReturn+"<br>[미실시]";
	                            	}	
	                            	return oneReturn;
	                            }
                            }else{
                                return "-";
                            }
                        }
                    },
                    {
                        title: "2차평가",
                        width: 170,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
	                        if(dataItem.TWO_USERID!=null){
	                        	if(dataItem.TWO_USERID == exUserid){
	                                if(dataItem.SELF_CMPL_FLAG == "Y"){
	                                    if(dataItem.ONE_CMPL_FLAG == "Y"){
	                                    	if(dataItem.TWO_CMPL_FLAG == "Y"){
	                                    		//재평가하기
	                                    		if(exCmd == "평가하기"){
	                                    		    return "<input type='button' class='k-button' value='재평가하기' onclick='fn_evlExec(1, "+dataItem.RUN_NUM+","+dataItem.USERID_EXED+", 2);'/>"+"<br>"+dataItem.TWO_CMPL_DATE;
	                                    		}else{
	                                    			return dataItem.TWO_NAME + "[완료]<br>"+dataItem.TWO_CMPL_DATE;
	                                    		}
	                                    	}else{
	                                    		//평가하기
	                                    		if(exCmd == "평가하기"){
	                                    		    return "<input type='button' class='k-button' value='평가하기' onclick='fn_evlExec(2, "+dataItem.RUN_NUM+","+dataItem.USERID_EXED+", 2);'/>";
	                                    		}else{
	                                    			return exCmd;
	                                    		}
	                                    	}
	                                    }else{
	                                    	return "진단대기";
	                                    }
	                                }else{
	                                    return "진단대기";
	                                }
	                            }else{
	                                var twoReturn=dataItem.TWO_NAME;
	                                if(dataItem.TWO_CMPL_FLAG=="Y"){
	                                	twoReturn = twoReturn + "[완료]<br>"+dataItem.TWO_CMPL_DATE;
	                                }else{
	                                	twoReturn = twoReturn+"<br>[미실시]";
	                                }   
	                                return twoReturn;
	                            }
	                        }else{
	                        	return "-";
	                        }
                        }
                    },
                    {
                        title: "분석",
                        width: 100,
                        filterable: true,
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
                            
                        	if(exCmd == "평가종료" && self && one && two){
                                return "<input type='button' class='k-button' value='열람' onclick='fn_analy("+dataItem.RUN_NUM+","+dataItem.USERID_EXED+","+dataItem.JOB+","+dataItem.LEADERSHIP+");return false;'/>";
                            }else{
                                return "[대기]";
                            }
                        }
                    }
                ],
                pageable: { refresh:false, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
                filterable: false,
                sortable: false,
                height: 470,
                dataBound:function(){
                	gridCellStyleChange();

                }
            });

        $("#grid").data("kendoGrid").dataSource.fetch(function(){
            
            //분석 컬럼 HIDE 처리
            if(exCmd != '평가종료'){
                $("#grid").data("kendoGrid").hideColumn(6);
            }
        	
        });
        
        $("#listBtn").click(function(){
            document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_run_pg.do";
            document.frm.submit();
        });
    }
    
    //자신이 평가해야할 cell의 배경색을 변경해준다.
    function gridCellStyleChange(){
  
	//alert("1");
		var grid = $("#grid").data("kendoGrid");
		var data = grid.dataSource.data();
		$.each(data, function(i, row) {
			var one = row.ONE_USERID;
			var two = row.TWO_USERID;
			if (one == exUserid) {
				$('tr[data-uid="' + row.uid + '"] td:nth-child(5)').css("background-color", "yellow");
			}
			if (two == exUserid) {
				$('tr[data-uid="' + row.uid + '"] td:nth-child(6)').css("background-color", "yellow");
			}
		});
	}

	//분석 버튼 
	function fn_analy(runNum, useridExed, job, leadership) {
		$("#RUN_NUM").val(runNum);
        $("#TG_USERID").val(useridExed);
        $("#JOB").val(job);
        $("#LEADERSHIP").val(leadership);
        
        document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_analysis_cmpt.do"
        document.frm.submit();
	}

	// 평가하기 버튼
	function fn_evlExec(evlDiv, runNum, exedUserid, rundirectionCd) {
		//alert(runNum);
		var str;
		if (evlDiv == 1) {
			str = "이미 평가를 완료하였습니다.재평가하시겠습니까?";
		} else {
			str = "평가하시겠습니까?";
		}

		if (confirm(str)) {
			$("#RUN_NUM").val(runNum);
			$("#USERID_EXED").val(exedUserid);
			$("#RUNDIRECTION_CD").val(rundirectionCd);
            
			document.frm.submit();
		}

		if (event.preventDefault) {
			event.preventDefault();
		} else {
			event.returnValue = false;
		}
	}
	
</script>

</head>
<body>
	<form id="frm" name="frm"  method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/ca/dept_cmpt_evl_exec.do">
	    <input type="hidden" name="RUN_NUM" id="RUN_NUM" />
	    <input type="hidden" name="USERID_EXED" id="USERID_EXED" />
	    <input type="hidden" name="RUNDIRECTION_CD" id="RUNDIRECTION_CD" />
        <input type="hidden" name="TG_USERID" id="TG_USERID" />
        <input type="hidden" name="JOB" id="JOB" />
        <input type="hidden" name="LEADERSHIP" id="LEADERSHIP" />
	</form>
	<div id="content">
		<div class="cont_body">
                                <div class="title">부서원 역량평가 <% if(map.get("EVL_CMD").equals("평가종료")){ %>분석<% } %></div>
                <div class="table_tin">
                    <ul>
                        <li class="line">해당 년도 : <%=map.get("YYYY") %>
                        <li>평가명 : <%=map.get("RUN_NAME") %></li>
                    </ul>
                    <ul>
                        <li class="line">참여인원 : <%=map.get("T_CNT") %>명 <% if(map.get("EVL_CMD").equals("평가종료")){ %>중 <b><%=map.get("C_CNT")%>명</b> 평가 완료<% } %></li>
                        <li>평가 기간 : <%=map.get("RUN_START") %> ~ <%=map.get("RUN_END") %></li>
                    </ul>
                </div>
                <% if(!map.get("EVL_CMD").equals("평가종료")){ %>
                <div class="px pt10">※ 피평가자 혹은 1차 평가자까지 평가가 완료되어야 평가를 진행할 수 있습니다.<br/>※ 평가 시 문의사항은 담당자(<%=operatorNm %> <%=strTel %>)에게 문의해주세요.</div>
                <% } %>
                <div class="table_zone">
                    <div id="grid" style="height:100%; "></div>
                </div>
                
                <div style="float:right;display:table; padding-top:10px;">
                    <button id="listBtn" class="k-button" >목록</button>
                </div>
		</div>
		<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/line/line_bottom01.gif" alt=""/>
	</div>
</body>

</html>