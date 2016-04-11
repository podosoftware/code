<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%

kr.podosoft.ws.service.kpi.action.ajax.KPIMgmtAction action = (kr.podosoft.ws.service.kpi.action.ajax.KPIMgmtAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
//List yearList = (List)action.getItems();
%>
<html decorator="operatorSubpage">
<head>
	<title></title>
	<script type="text/javascript">
	//var runListDataSource;
	var yearListDataSource;
	var sClassNm;
	var kpiIndex = 0;
	var fileCount = 0;
	
    yepnope([{
        load: [ 
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
                'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css',
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
            
            /* 브라우저 height 에 따라 resize() 스타일 적용..  START !!! */
            $(window).bind('resize', function () { 
            	var winHeight;
                if (window.innerHeight) {
                    winHeight =window.innerHeight;
                }else{
                    if(document.documentElement.clientHeight){
                        winHeight = document.documentElement.clientHeight;
                    }else{
                        winHeight = 400;
                        alert("현재 브라우저는 resize를 제공하지 않습니다.");
                    }
                }

            	var gridElement = $("#grid");
            	gridOtherHeight = $("#grid").offset().top + $("#footer").outerHeight() + 30; //
            	gridElement.height(winHeight - gridOtherHeight);
            	
                dataArea = gridElement.find(".k-grid-content"),
                gridHeight = gridElement.innerHeight(),
                otherElements = gridElement.children().not(".k-grid-content"),
                otherElementsHeight = 0;
                otherElements.each(function(){
                    otherElementsHeight += $(this).outerHeight();
                });
                dataArea.height(gridHeight - otherElementsHeight);

            });
            /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
            
            
            var date = new Date(); 
            var year = date.getFullYear(); 
            
            var yearlist= [];
            
            for(var i=2014; i<year+2; i++){
            	yearlist.push({ text: i+"년", value: i});
            }

	        //평가년도 콤보박스
	        $("#year").kendoComboBox({
                dataTextField: "text",
                dataValueField: "value",
                dataSource: yearlist,
                filter: "contains",
                suggest: true,
                width: 100,
                change: function() {
                	if($("#year").val()!=null && $("#year").val()!=""){
                		$("#grid").data("kendoGrid").dataSource.read();
                		//filterData( $(':radio[id="typeCd"]:checked').val() );
                	}else{

                	}
                	//$("#runList").data("kendoComboBox").select(0);
                 },
                 dataBound:function(){
                	 $("#year").data("kendoComboBox").value(year);
                	 if($("#grid").data("kendoGrid")){
                		 $("#grid").data("kendoGrid").dataSource.read();
                         //filterData( $(':radio[id="typeCd"]:checked').val() ); 
                	 }
                	 
                 }
            });
	        
	        //grid 세팅
	        $("#grid").empty();
	        $("#grid").kendoGrid({
	        	   dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/user_job_suit_result.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){ 
	                           return {YYYY: $("#year").val(),  USERID :  $("#userid").val() };
	                       }
	                   },
	                   schema: {
	                       total: "totalItemCount",
	                       data: "items",
	                          model: {
	                              fields: {
	                            	  RNUM : {type:"number"},
	                            	  JOBLDR_NAME : { type: "string" },
	                            	  EVL_SCO : { type: "number" },
	                            	  EFLAG : { type: "string"}
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
                             field: "RNUM",
                             title: "번호",
                             filterable: false,
                             width: 100,
                             headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                             attributes:{"class":"table-cell", style:"text-align:center"} 
                         },
	                    {
	                    	field:"JOBLDR_NAME",
	                        title: "직무명",
	                        filterable: true,
                            width:200,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:left;"}
	                    },
	                    {
	                        field:"EVL_SCO",
	                        title: "적합도 점수",
	                        filterable: true,
	                        width:120,
	                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                        attributes:{"class":"table-cell", style:"text-align:center"} 
	                    },
                        {
                            field: "",
                            title: "신뢰도",
                            filterable: true,
                            width: 160,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"} 
                        },
	                    {
	                        field: "EFLAG", 
	                        title: "현직무여부", 
                            filterable: true,
	                        width:160,
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
	                selectable: false
	            });
	            
	        
	        $("#search").click(function(){
	        	          $("#user-window-selecter-grid").empty();
	                      
	                      $("#user-window-selecter-grid").kendoGrid({
	                         dataSource: {
	                             type: "json",
	                             transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/target_user_list.do?output=json", type:"POST" },
	                                 parameterMap: function (options, operation){   
	                                    return { };
	                                  } 
	                            },
	                             schema: {
	                                  data: "items",
	                                  model: {
	                                      fields: {
	                                          USERID : { type: "number", editable:false },
	                                          NAME : { type: "string", editable:false },
	                                          DVS_NAME : { type: "string", editable:false },
	                                          EMPNO : { type: "String", editable:false },
	                                          JOB_NAME : { type: "String", editable:false },
	                                          LEADERSHIP_NAME : { type: "String", editable:false }
	                                      }
	                                  }
	                             },
	                         },
	                         columns: [
	                              { 
	                                  field:"DVS_NAME", title: "부서", filterable: true, width:150,
	                                  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                                  attributes:{"class":"table-cell", style:"text-align:left"} 
	                              },
	                              { 
	                                field:"NAME", title: "성명", filterable: true, width:100 ,
	                                  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                                  attributes:{"class":"table-cell", style:"text-align:left"} 
	                              },
	                              { 
	                                field:"EMPNO", title: "교직원번호", filterable: true, width:80,
	                                  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                                  attributes:{"class":"table-cell", style:"text-align:left"} 
	                              },
	                              { 
	                                  field:"JOB_NAME", title: "직무", filterable: true, width:80,
	                                  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                                  attributes:{"class":"table-cell", style:"text-align:left"} 
	                              },
	                              { 
	                                  field:"LEADERSHIP_NAME", title: "리더십", filterable: true, width:80,
	                                  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                                  attributes:{"class":"table-cell", style:"text-align:left"} 
	                              },
	                              { 
	                                field: "button", title: " ", filterable:false, width:80,
	                                  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                                  attributes:{"class":"table-cell", style:"text-align:center"},
	                                  template: function(data){
	                                	  
	                                	  return "<input id='userSelBtn' type='button' class='k-button k-i-close' style='size:20' value='선택' onclick='fn_selectUser("+data.USERID+");'/>"
	                                  }
	                              }
	                         ],
	                         filterable: {
	                              extra : false,
	                              messages : {filter : "필터", clear : "초기화"},
	                              operators : { 
	                                  string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
	                                  number : { contains : "포함", startswith : "시작값", eq : "동일값" }
	                              }
	                          }, 
	                          height: 370
	                      });
	                      
	                  
	                
	                  if( !$("#user-window").data("kendoWindow") ){
	                      $("#user-window").kendoWindow({
	                        width:"650px",
	                          minHeight:"400px",
	                          resizable : true,
	                          title : "직원검색",
	                          modal: true,
	                          visible: false
	                      });
	                   }
	                  
	                  $("#user-window").data("kendoWindow").center();
	                  $("#user-window").data("kendoWindow").open();
	              
	        });
	        
	        //브라우저 resize 이벤트 dispatch..
            $(window).resize();
        }
    }]);   
    
    
    function fn_selectUser(userid){
    	var array = $('#user-window-selecter-grid').data('kendoGrid').dataSource.data();
        var user = $.grep(array, function (e) {
            return e.USERID == userid;
        });
        
    	var name=user[0].NAME;
    	var id=user[0].USERID;
    	var dept=user[0].DVS_NAME;
    	var empno=user[0].EMPNO;
    	var job=user[0].JOB_NAME;
    	var ldr =user[0].LEADERSHIP_NAME;
    	
    	$("#user_Nm").val(name);
    	$("#userNm").val(name);
        $("#userid").val(id);
        $("#userinfo").text(dept+" / "+name+"("+empno+") /  "+ldr+" / "+job);
        
        $("#grid").data("kendoGrid").dataSource.read();
        
        $("#user-window").data("kendoWindow").close();
    }
    
    
    //엑셀다운로드
    function excelDownLoad(){
    	var yy = $("#year").data("kendoComboBox");
        if(yy.value()==""){
        	alert("평가년도를 선택해주세요.");
        	return;
        }
    	if($("#userid").val()==""){
        	alert("직원을 선택해주세요.");
        	return;
        }
        frm.YYYY.value = yy.value();
    	frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/user_job_suit_result_excel.do";
    	frm.submit();
    }
    
    </script>

</head>
<body >
<form name="frm" id="frm" method="post" >
    <input type="hidden" name="companyid" id="companyid" value="<%=action.getUser().getCompanyId()%>"/>
    <input type="hidden" name="JOB_NAME" id="JOB_NAME" />
    <input type="hidden" name="JOB_NUM" id="JOB_NUM" />
    <input type="hidden" name="YYYY" id="YYYY" />
    <input type="hidden" id="userid" name="userid" >
    <input type="hidden" id="userNm" name="userNm" >
</form>

    <div id="content">
        <div class="cont_body">
            <div class="title mt30">직원별 직무 적합도</div>
            <div class="table_tin01">
                <div class="px">※  직원별 직무 적합도는 해당 직원에게 적합한 직무가 무엇인지를 보여줍니다.</div>
                <ul>
                    <li >
                        <label for="year" >평가년도</label>
                        <select id="year" style="width:100px;"></select>
<!--                         <select id="runList" style="width:350px;"></select> -->
                        
                    </li>
                    <li class="line">
                        <label for="year" >직원선택</label>
                        <input type="text" id="user_Nm" name="user_Nm" class="k-input" style="width:150px; " readOnly> <button id="search" class="k-button" ><span></span>찾 기</button>
                    </li>
                </ul>
            </div>
            
	        <div class="table_zone" >
	            <div style="width:100%; text-align:right">
	                   <div style="float:left; margin-left: 15px; margin-top: 10px; ">
	                        <span id="userinfo"></span>
	                    </div>
                    <a class="k-button"  href="javascript:excelDownLoad()" >엑셀 다운로드</a>
                </div>
	            <div class="table_list">
	                <div id="grid" ></div>
	            </div>
	        </div>
	    </div>
    </div>

    <div id="user-window" style="display:none;">
        <div id="user-window-selecter">
            <div id="user-window-selecter-grid"></div>
        </div>
    </div>
        
</body>
</html>