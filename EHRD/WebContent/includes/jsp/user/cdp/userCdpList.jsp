<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
kr.podosoft.ws.service.cdp.action.CdpServiceAction action = (kr.podosoft.ws.service.cdp.action.CdpServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
%>
<html decorator="subpage"   >
<head>
<title></title>

<script type="text/javascript"> 

yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.bootstrap.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
    ],
    complete: function() {
        kendo.culture("ko-KR"); 
        
        
        $("#grid").empty();
        $("#grid").kendoGrid({
               dataSource: {
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_run_list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){ 
                            return {  };
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
                                   USERID : { type:"int"}
                               }
                           }
                    },
                    pageSize: 6,
                    serverPaging: false,
                    serverFiltering: false,
                    serverSorting: false
                },
                //pageable: { refresh:false, pageSizes:false  },
                //groupable: false,
                sortable: true,
                resizable: true,
                reorderable: true,
                height: 550,
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
                        title: "계획명",
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left; "} ,
                        template: function (data) {
                            if(data.EVL_CMD=="계획대기"){
                                return "<a href=\"javascript: void(0); \" onclick=\"javascript:alert('아직 계획이 시작하지 않았습니다'); \" style=\"text-decoration: underline;\" >"+data.RUN_NAME+"</a>";
                            }else if(data.EVL_CMD=="계획중"){
                                if(data.USERID==null || data.USERID==""){
                                    return "<a href=\"javascript: void(0); \"  onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\"  style=\"text-decoration: underline;\" >"+data.RUN_NAME+"</a>";
                                }else{
                                    if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
                                        return "<a href=\"javascript: void(0); \" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\"  style=\"text-decoration: underline;\" >"+data.RUN_NAME+"</a>";
                                    }else{
                                        if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
                                            return "<a href=\"javascript: void(0); \" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" style=\"text-decoration: underline;\"  >"+data.RUN_NAME+"</a>";
                                        }else if(data.REQ_STS_CD=="1"){ //승인요청상태
                                            return "<a href=\"javascript: void(0); \" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" style=\"text-decoration: underline;\"  >"+data.RUN_NAME+"</a>";
                                        }else if(data.REQ_STS_CD=="2"){ //승인상태
                                            return "<a href=\"javascript: void(0); \" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\"  style=\"text-decoration: underline;\" >"+data.RUN_NAME+"</a>";
                                        }else if(data.REQ_STS_CD=="3"){ //반려상태
                                            return "<a href=\"javascript: void(0); \" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" style=\"text-decoration: underline;\"  >"+data.RUN_NAME+"</a>";
                                        }
                                    }
                                }
                            }else if(data.EVL_CMD=="계획종료"){
                                if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
                                    return ""+data.RUN_NAME+"";
                                }else{
                                    if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
                                        return ""+data.RUN_NAME+"";
                                    }else if(data.REQ_STS_CD=="1"){ //승인요청상태
                                        return "<a href=\"javascript: void(0); \" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" style=\"text-decoration: underline;\"  >"+data.RUN_NAME+"</a>";
                                    }else if(data.REQ_STS_CD=="2"){ //승인상태
                                        return "<a href=\"javascript: void(0); \" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" style=\"text-decoration: underline;\"  >"+data.RUN_NAME+"</a>";
                                    }else if(data.REQ_STS_CD=="3"){ //반려상태
                                        return "<a href=\"javascript: void(0); \" onclick=\"javascript: fn_planExec("+data.RUN_NUM+", "+data.YYYY+")\" style=\"text-decoration: underline;\"  >"+data.RUN_NAME+"</a>";
                                    }
                                }
                            }
                            return data.RUN_NAME;
                        }
                    },
                    {
                        title: "계획기간",
                        width:240,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                            return dataItem.RUN_START+" ~ "+dataItem.RUN_END;
                        } 
                    },
                    {
                        title: "계획여부",
                        width:180,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template: function (data) {
                            if(data.EVL_CMD=="계획대기"){
                                return "계획대기";
                            }else if(data.EVL_CMD=="계획중"){
                            	if(data.USERID==null || data.USERID==""){
                            		return "계획실시";
                            	}else{
                            		if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
                            			return "계속계획";
                            		}else{
                            			if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
                            				return "계속계획";
                            			}else if(data.REQ_STS_CD=="1"){ //승인요청상태
                            				return "승인대기";
                                        }else if(data.REQ_STS_CD=="2"){ //승인상태
                                        	return "승인";
                                        }else if(data.REQ_STS_CD=="3"){ //반려상태
                                        	return "미승인";
                                        }
                            		}
                            	}
                            }else if(data.EVL_CMD=="계획종료"){
                            	if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
                                    return "미작성";
                                }else{
                                    if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
                                        return "미작성";
                                    }else if(data.REQ_STS_CD=="1"){ //승인요청상태
                                        return "승인대기";
                                    }else if(data.REQ_STS_CD=="2"){ //승인상태
                                        return "승인";
                                    }else if(data.REQ_STS_CD=="3"){ //반려상태
                                        return "미승인";
                                    }
                                }
                            }
                            return "";
                        }
                    },
                    {
                    	title: "승인현황",
                    	width: 100,
                    	headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function(data){
                        	if(data.REQ_STS_CD==null || data.REQ_STS_CD==""){
                                return "";
                            }else{
                                if(data.REQ_STS_CD=="0"){ //승인요청을 회수한경우..
                                    return "";
                                }else{ //승인요청상태
                                	//요청 취소 가능 여부 체크
                                	var cancelAbleYn =  "Y";
                                	if(data.REQ_STS_CD == "2" || data.REQ_STS_CD == "3"){
                                		//승인요청건에 대해 최종 처리가 되기전엔 취소가능하도록 함.
                                		cancelAbleYn =  "N";
                                	}
                                    return "<button class=\"k-button\" onclick=\"javascript: fn_apprOpen( "+data.REQ_NUM+", '"+cancelAbleYn+"' )\" >승인현황</button>";
                                }
                            }
                        }
                    }
                ]

            });
    }
}]);

function fn_apprOpen(reqNum, cancelAbleYn){
	//승인현황 팝업 호출.
	apprStsOpen(1, reqNum, cancelAbleYn);
	//승인취소 처리 후 callback 함수 정의
	reqCancelCompleteCallbackFunc = fn_afterReqCancel;
}

//승인요청 취소후 처리
function fn_afterReqCancel(){
	//그리드 내용 refresh.
	$("#grid").data("kendoGrid").dataSource.read();
}

function fn_planExec(runNum, yyyy){
	$("#rn").val(runNum);
    $("#year").val(yyyy);
    document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/user_cdp_exec_pg.do"
    document.frm.submit();
}
</script>
</head>
<body>
    <form id="frm" name="frm"  method="post" >
        <input type="hidden" name="rn" id="rn" />
        <input type="hidden" name="tu" id="tu" <%=action.getUser().getUserId() %>/>
        <input type="hidden" name="year" id="year" />
    </form>
    
    <div class="container">
        <div id="cont_body">
         <div class="content">
            <div class="top_cont">
                <h3 class="tit01">계획수립</h3>
                <div class="point">※ 경력개발계획은 경력 목표를 설정하고, 이를 달성하기 위해 경력관리와 목표달성을 위함입니다.<br/>※ 경력목표수립과 교육계획수립으로 구성되어 있습니다.</div>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>경력개발계획&nbsp; &#62;</span>
                    <span class="h">계획수립</span>
                </div><!--//location-->
            </div>
             <div class="sub_cont">
                
                <h4 class="mt30">경력개발계획 목록</h4>
                <div id="grid" class="mt15" style="height:550px;"></div>
                <h4 class="mt40">경력개발  절차안내</h4>
                <ol class="method_Info b2">
                    <li class="fir">
                        <dl>
                            <dt>경력목표수립</dt>
                            <dd>
                                <span>올해/장기목표</span>
                                <span class="cen2">희망직무/부서</span>
                                <span>자격증,어학 취득</span>
                            </dd>
                        </dl>
                    </li>
                    <li class="arr"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_arrow02.gif" alt=""/></li>
                    <li class="cen">
                        <dl>
                            <dt>교육계획수립</dt>
                            <dd>
                                <span class="fir2">나의이수시간</span>
                                <span>기관성과평가필수교육</span>
                            </dd>
                        </dl>
                    </li>
                    <li class="arr"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_arrow02.gif" alt=""/></li>
                    <li class="last2">
                        <dl>
                            <dt>계획승인요청</dt>
                            <dd>
                                <span class="fir">승인요청선지정</span>
                                <span>계획에 대한 승인요청</span>
                            </dd>
                        </dl>
                    </li>
                </ol>
             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div><!--//container-->

<%@ include file="/includes/jsp/user/common/apprStsPopup.jsp"  %>

</body>
</html>