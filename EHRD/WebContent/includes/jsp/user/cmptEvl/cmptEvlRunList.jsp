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
<title>경북대학교</title>
<script type="text/javascript"> 
var now = new Date();
var mon = "";
var day = "";
if((now.getMonth()+1)<10){
	mon = "0"+(now.getMonth()+1);
}else{
	mon = now.getMonth()+1;
}
if((now.getDate())<10){
	day = "0"+(now.getDate());
}else{
	day = now.getDate();
}
var nowDay= now.getFullYear()+"-"+mon+"-"+day;

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
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_run_list.do?output=json", type:"POST" },
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
                                   EVL_ANALY : { type : "string" }
                               }
                           }
                    },
                    pageSize: 30,
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
                        title: "진단명",
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"} 
                    },
                    {
                        title: "진단기간",
                        width:240,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"},
                        template: function (dataItem) {
                            return dataItem.RUN_START+" ~ "+dataItem.RUN_END;
                        } 
                    },
                    {
                        field:"DIAGNO_DIR_TYPE_NM",
                        title: "진단유형",
                        width:140,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },
                    {
                        title: "진단여부",
                        width:180,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} ,
                        template: function (data) {
                        	if(data.EVL_CMD=="진단대기"){
                        		return "<button class=\"k-button\" onclick=\"javascript:alert('아직 진단이 시작하지 않았습니다'); \" >진단대기</button>";
                        	}else if(data.EVL_CMD=="진단중"){
                        		if(data.EXEC_T_SUM > 0){
                        			if(data.EXEC_T_SUM > data.EXEC_C_CNT){
                        				//진단 미실시....
                                        return "<button class=\"k-button\" onclick=\"javascript: fn_diagnoExec("+data.RUN_NUM+")\" >진단실시</button>";
                                    }else{
                                    	//진단 완료....
                                    	if(data.EXED_C_CNT > 0){
                                    		//내 결과가 존재 한다면..
                                    		if(nowDay>=data.RESULT_OPEN_DATE){
                                                return "<button class=\"k-button\" onclick=\"javascript: fn_diagnoAnaly("+data.RUN_NUM+")\" >결과보기</button>";
                                            }else{
                                                return "<button class=\"k-button\" onclick=\"javascript:alert('"+data.RESULT_OPEN_DATE+" 이후에 열람이 가능합니다'); \" >진단완료</button>";
                                            }
                                    	}else{
                                    		return "진단완료";
                                    	}
                                    }
                        		}else{
                        			//진단 완료.... 
                                    if(data.EXED_C_CNT > 0){
                                        //내 결과가 존재 한다면..
                                        if(nowDay>=data.RESULT_OPEN_DATE){
                                            return "<button class=\"k-button\" onclick=\"javascript: fn_diagnoAnaly("+data.RUN_NUM+")\" >결과보기</button>";
                                        }else{
                                        	return "진단중";
                                        }
                                    }else{
                                    	return "진단중";
                                    }
                        		}
                            }else if(data.EVL_CMD=="진단종료"){
                            	//진단 완료....
                                if(data.EXED_C_CNT > 0){
                                    //내 결과가 존재 한다면..
                                    if(nowDay>=data.RESULT_OPEN_DATE){
                                        return "<button class=\"k-button\" onclick=\"javascript: fn_diagnoAnaly("+data.RUN_NUM+")\" >결과보기</button>";
                                    }else{
                                    	return "<button class=\"k-button\" onclick=\"javascript:alert('"+data.RESULT_OPEN_DATE+" 이후에 열람이 가능합니다'); \" >진단완료</button>";
                                    }
                                }else{
                                    return "진단종료";
                                }
                            }
                        	
                        }
                    }
                ],
                pageable: { refresh:false, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
                filterable: false,
                sortable: true,
                height: "350px"
            });

    }
    
    //진단실시..
    function fn_diagnoExec(run_num){
    	$("#RUN_NUM").val(run_num);
        
        document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_basic_info.do";
        document.frm.submit();
    }
    
    //분석 버튼 
    function fn_diagnoAnaly(runNum, useridExed, job, leadership) {
        $("#RUN_NUM").val(runNum);
        $("#TG_USERID").val(useridExed);
        $("#JOB").val(job);
        $("#LEADERSHIP").val(leadership);
        
        document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cam/cmpt_evl_analysis_cmpt.do"
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
    
        <div class="container">
            <div id="cont_body">
                <div class="content">
                    <div class="top_cont">
		                <h3 class="tit01">역량진단</h3>
		                <div class="point">
		                    ※ 역량진단은 개발이 요구되는 역량을 알려주어 최적화된 자기개발을 하기 위함입니다. <br/>※ 진단 시 실제행동에 가까운 쪽으로 응답하셔야 효과적인 역량개발에 도움이 됩니다.
		                </div>
		                <div class="location">
		                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
		                    <span>역량진단&nbsp; &#62;</span>
		                    <span class="h">목록</span>
		                </div><!--//location-->
		            </div>
                    <div class="sub_cont">
                        <h4 class="mt30">역량 진단 목록</h4>
                        <div id="grid" class="mt15" style="height:350px;"></div>
                        <!-- <h4 class="mt40">역량 진단 절차 안내</h4>
                        <ol class="method_Info">
                            <li class="fir">
                                <dl>
                                    <dt>기본정보확인</dt>
                                    <dd>
                                        <span>역량진단 안내</span> <span class="cen">개인정보 확인</span> <span>진단대상자
                                            목록</span>
                                    </dd>
                                </dl>
                            </li>
                            <li class="last">
                                <dl>
                                    <dt>현수준 진단</dt>
                                    <dd>
                                        <span>문항을 읽고 피진단자들의 레벨 체크</span>
                                    </dd>
                                </dl>
                            </li>
                        </ol> -->
                    </div>
                    <!--//sub_cont-->
                </div>
                <!--//content-->
            </div>
            <!--//cont_body-->
        </div>
        <!--//container-->
</body>
</html>