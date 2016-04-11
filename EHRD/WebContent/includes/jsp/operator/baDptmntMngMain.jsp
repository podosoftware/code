<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page pageEncoding="UTF-8" isErrorPage="true"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
//총괄관리자 권한 여부..
boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
//고객사운영자 권한 여부..
boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
//부서장 권한 여부..
boolean isManager = request.isUserInRole("ROLE_MANAGER");
%>
     
<html decorator="operatorSubpage">
<head>
	<title>조직관리</title>
	
	<script type="text/javascript">
	
	
		//var dataSource_empStsCd;
		var ds_dept_popup = null;
		//var empStsCd = null;
		
		yepnope([{
       	  	load: [ 
    			'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
    			'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
   				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
   				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
  				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js'
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
                    
                	//스플릿터 사이즈 재조정..
                	var splitterElement = $("#splitter");
                	//스플릿터 top 위치와 footer 높이, padding 30을 합한 높이를 윈도우창 사이즈에서 빼줌.
                	splitterOtherHeight = $("#splitter").offset().top + $("#footer").outerHeight() + 30; //
                    splitterElement.height(winHeight - splitterOtherHeight);
                    
                    //그리드 사이즈 재조정..
                    var gridElement = $("#grid");
                    gridElement.height(splitterElement.outerHeight()-2);
                    
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
                
                //로딩바 선언..
            	loadingDefine();
          		
          	    // area splitter
          	    var splitter = $("#splitter").kendoSplitter({
                    orientation : "horizontal",
                    panes : [ {
                        collapsible : true,
                        min : "500px"
                    }, {
                        collapsible : true,
                        collapsed : true,
                        min : "500px"
                    } ]
                });
                
                
				$('#details').show().html(kendo.template($('#template').html()));
                
                
              	//부서장 초기화
              	//$("#managerArea").hide();
              	//$("#delBtn").hide();
         	   	$("#dvs_manager").val("");
         	   	$("#dvs_manager_nm").val("");
                
         	   	var gridRead = function(){
               		grid.dataSource.read();
              	 };
              	 
                $("#grid").empty();
            	
            	// 그리드 생성
            	var grid = $("#grid").kendoGrid({
                    dataSource: {
                        type: "json",
                        transport: {
                            read: { 
                            		url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-dept-mng-list.do?output=json", 
                            		type:"POST" 
                           	},
                            parameterMap: function (options, operation){	
                            	var sortField = "";
                                var sortDir = "";
                                
                                if (options.sort && options.sort.length>0) {
                                    sortField = options.sort[0].field;
                                    sortDir = options.sort[0].dir;
                                }
                                
                                return { 
                                	USEFLAG : "A"//$(':radio[id="useFlagSearch"]:checked').val()
                                };
                            } 		
                        },
                        schema: {
                        	total: "totalItemCount",
                        	data: "items",
                            model: {
                            	fields: {
                                	LVL : { type: "number" },
                                	DIVISIONID : { type: "string" },
                                	DVS_NAME : { type: "string" },
                                	DVS_MANAGER : { type: "string" },
                                	DVS_MANAGER_NM : { type: "string" },
                                	DVS_FULLNAME : { type: "string" },
                                	HIGH_DVSID : { type: "string" },
                                	DVS_MANAGER_STRING : { type: "string" },
                                	CHILDREN_CNT : { type: "string" },
                                	HIGH_DVSID_NAME : { type: "string" },
                                	USEFLAG : { type: "string" },
                                	DEPT_STND_CD : { type: "string" },
                                	DEPT_STND_CD_NM : { type: "string" }
                                }
                            }
                        },
                        pageSize: 30, 
                        serverPaging: false, 
                        serverFiltering: false, 
                        serverSorting: false,
                    },
                    columns: [
                        { field:"DIVISIONID", title: "부서코드", width:"100px",
    						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
    						attributes:{"class":"table-cell", style:"text-align:center"} },
    				    { field: "DVS_NAME", title: "부서", width:"100px",
    						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
    						attributes:{"class":"table-cell", style:"text-align:left;text-decoration: underline;"},
    						template: "<a href=\"javascript:void();\" onclick=\"javascript: fn_detailView('${DIVISIONID}'); return false;\" >${DVS_NAME}</a>"	
    				    },
                        { field: "DVS_FULLNAME", title: "부서전체명", width:"200px",
    						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
    						attributes:{"class":"table-cell", style:"text-align:left"} },
    				    { field:"LVL", title: "LEVEL ", width:"80px",
    						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
    						attributes:{"class":"table-cell", style:"text-align:center"} },
                        { field: "HIGH_DVSID", title: "상위부서코드", width:"120px",
    						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
    						attributes:{"class":"table-cell", style:"text-align:center"} },
                        { field: "HIGH_DVSID_NAME", title: "상위부서", width:"120px",
    						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
    						attributes:{"class":"table-cell", style:"text-align:left"} },
                        /*{ field: "DEPT_STND_CD_NM", title: "부서기준", width:"100px",
    						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
    						attributes:{"class":"table-cell", style:"text-align:center"} },*/
                        { field: "DVS_MANAGER_NM", title: "부서장", width:"80px",
    						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
    						attributes:{"class":"table-cell", style:"text-align:center"} },
   						{ field: "USEFLAG", title: "사용여부", width:"100px",
                               headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                               attributes:{"class":"table-cell", style:"text-align:center"} }
                    ],
                    filterable: {
    					extra : false,
    					messages : {filter : "필터", clear : "초기화"},
    					operators : { 
    						string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
    						number : { eq : "같음", gte : "이상", lte : "이하"}
    					}
    				},
                    sortable: true,
                    pageable : true,
    	            resizable : true,
    	            reorderable : true,
                    selectable: "row",
                    pageable : {
    	                refresh : false,
                        pageSizes : [10,20,30],
                        buttonCount: 5
    	            }
                }); //end gird               
            	
                
                //부서기준 데이터소스
                /*dataSource_empStsCd = new kendo.data.DataSource({
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){    
                            return {  STANDARDCODE : "BA20", ADDVALUE: "=== 선택 ===" };
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
                    serverSorting: false
				});		
                dataSource_empStsCd.fetch(function(){ });
                */
                
                //부서기준
                /*empStsCd = $("#empStsCd").kendoDropDownList({
                     dataTextField: "TEXT",
                     dataValueField: "VALUE",
                     dataSource: dataSource_empStsCd,
                     filter: "contains",
                     suggest: true
                 }).data("kendoDropDownList");*/
                
                 //트리형태의 조직 조회..
                 $("#deptSearchBtn").click(function(){
                     if( !$("#dept-window").data("kendoWindow") ){
                         
                         $("#dept-window").kendoWindow({
                             width:"370px",
                             title : "트리형태 부서조회",
                             resizable: true,
                             modal: true,
                             visible: false
                         });
                         //부서검색트리 정의
                         $("#deptPopupTreeview").kendoTreeView({
                             dataTextField: ["DVS_NAME"],
                             dataSource: new kendo.data.HierarchicalDataSource({
                                 type: "json",
                                 transport: {
                                     read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get-dept-list.do?output=json", type:"POST" },
                                     parameterMap: function (options, operation){  
                                       return {  USEFLAG : "Y" };
                                     }         
                                },
                                schema: {
                                    data: "items",
                                    model: {
                                        fields: {
                                            DIVISIONID : { type: "String" },
                                            DVS_NAME : { type: "String" },
                                            HIGH_DVSID : { type: "String" },
                                          items : { DIVISIONID : { type: "String" }, DVS_NAME : { type: "String" }, HIGH_DVSID : { type: "String"} }
                                        },
                                        children: "items"
                                    }
                                },
                                serverFiltering: false,
                                serverSorting: false}),
                            loadOnDemand: false
                         });
                         
                      }
                     $("#dept-window").data("kendoWindow").center();
                     $("#dept-window").data("kendoWindow").open();
                     
                 });
                 
                
                //브라우저 resize 이벤트 dispatch..
                $(window).resize();
                
          	}//end complate
        
      	}]); //end yepnope
		
		// 저장
		function deptSave(){
			
			//var grid = $("#grid").data("kendoGrid");
	   	    //var data = grid.dataSource.data();
			
            var isConfirm = confirm("부서정보를 저장하시겠습니까?");
            if(isConfirm){
                var params = {
                		DIVISIONID : $("#divisionid").val(),
                		HIGH_DVSID : $("#high_dvsid").val(),
                		DVS_NAME : $("#dvs_name").val(),
                		DVS_MANAGER : $("#dvs_manager").val(),
                		//DEPT_STND_CD : empStsCd.value(),
                	    USEFLAG : $(':radio[id="useFlag"]:checked').val() 
                };
                
                $.ajax({
                    type : 'POST',
                    url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_dept_save.do?output=json",
                    data : { item: kendo.stringify( params ) },
                    complete : function( response ){
                        var obj  = eval("(" + response.responseText + ")");
                        if(obj.saveCount != 0){
                        	//filterUseFlag();
                        	//$("#deptPopupTreeview").data("kendoTreeView").dataSource.read();
                        	//$("#grid").kendoGrid().dataSource.read();
                        	//grid.dataSource.read();
                        	$("#grid").data("kendoGrid").dataSource.read();
                        	kendo.bind( $(".tabular"), null );
                            $("#splitter").data("kendoSplitter").toggle("#list_pane", true);
                      		$("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
                            alert("저장되었습니다.");  
                            
                        }else{
                            alert("저장에 실패 하였습니다.");
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
        
        // 부서장 초기화
        /*function managerSet(){
        	$("#dvs_manager").val("");
         	$("#dvs_manager_nm").val("");
        }*/
        
        // 부서장 검색
        function managerSearch(){
        	//부서장 선택 폼
            
            $("#lst-add-user-window-selecter-grid").empty();
            
            $("#lst-add-user-window-selecter-grid").kendoGrid({
               dataSource: {
                   type: "json",
                   transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_user-list-popup.do?output=json", type:"POST" },
                       parameterMap: function (options, operation){ 
                           return {  DIVISIONID : $("#divisionid").val(), HIGH_DVSID : $("#high_dvsid").val() };
                       }
                   },
                   schema: {
                        total: "totalItemCount",
                        data: "items",
                        model: {
                            id : "USERID",
                            fields: {
                                USERID : { type: "number", editable:false },
                                NAME : { type: "string", editable:false },
                                DVS_NAME : { type: "string", editable:false },
                                EMPNO : { type: "String", editable:false }
                            }
                        }
                   },
                   pageSize: 15, serverPaging: false, serverFiltering: false, serverSorting: false
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
                        template: "<input type='button' class='k-button k-i-close' style='size:20' value='선택' onclick='fn_selectUser(\"${USERID}\",\"${NAME}\");'/>"
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
                sortable: true,
                resizable: true,
                pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  }, 
                height: 370
            });
        
    	
	        if( !$("#lst-add-user-window").data("kendoWindow") ){
	            $("#lst-add-user-window").kendoWindow({
	            	width:"650px",
	                minHeight:"400px",
	                resizable : true,
	                title : "사용자검색",
	                modal: true,
	                visible: false
	            });
	         }
	        
	        $("#lst-add-user-window").data("kendoWindow").center();
	        $("#lst-add-user-window").data("kendoWindow").open();        	
        }
		
        // 취소버튼 클릭
		function cancelBt(){
			
			$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
      		$("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
		}
		
		//부서장 선택
		function fn_selectUser(id, name){
			$("#dvs_manager_nm").val(name);
			$("#dvs_manager").val(id);
            
			$("#lst-add-user-window").data("kendoWindow").close();
		}
		
	    // 상세보기.
	   	function fn_detailView(dvsId){
	   	
	   	    var grid = $("#grid").data("kendoGrid");
	   	    var data = grid.dataSource.data();
	   	    
	   	    var res = $.grep(data, function (e) {
	   	        return e.DIVISIONID == dvsId;
	   	    });
	   	
	   	    var selectedCell = res[0];
	   	    
	   		// 상세영역 활성화
	   		//$("#splitter").data("kendoSplitter").expand("#detail_pane");
	   		
	   		// show detail 
            $("#splitter").data("kendoSplitter").expand("#detail_pane");
            
            
            
          	//상세데이터 바인딩.. (그리드에서 선택한 로우의 대한 데이타를 상세보기 항목에 바인드시켜준다.)
            kendo.bind($("#tabular"), selectedCell);
          	
          	//alert(selectedCell.DIVISIONID+ " / " +selectedCell.DVS_NAME);

	   	}		
	        
		
	</script>
</head>
<body>
    <div id="content">
        <div class="cont_body">
            <div class="title mt30">조직관리</div>
            <div class="table_zone" >
                <div class="table_btn">
                    <button button id="deptSearchBtn" class="btn_style02 k-button" >트리형태 부서조회</button>
                    <a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_dept_list_excel.do" >엑셀 다운로드</a>&nbsp;
                </div>
                <div class="table_list">
				    <!-- START MAIN CONTNET -->
				    <div id="splitter" style="width:100%; height: 100%; border:none;">
				            <div id="list_pane">
				            	<div id="grid" ></div>
				            </div>
				            <div id="detail_pane">
				                <div id="details"></div>
				            </div>
				    </div>
				    <!-- END MAIN CONTENT  --> 
				</div><!-- END table_list  -->
            </div><!-- END table_zone  -->
        </div><!-- END cont_body  -->
    </div><!-- END content  -->
  	
 	<script type="text/x-kendo-template" id="template"> 
		<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2" style="font-size:16px;">
					<strong>&nbsp; 조직관리 상세 </strong>
				</td>
			</tr>
			<tr>
				<td class="subject" style="width: 100px; height: 25px">
					<label class="right inline required">
						<span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 상위부서
					</label>
				</td>
				<td class="subject">
				   <input type="hidden" id="divisionid" data-bind="value:DIVISIONID"  />
				   <input type="hidden" id="high_dvsid" data-bind="value:HIGH_DVSID" />
				   <!--<input class="k-textbox" id="high_dvsid_name" placeholder="" data-bind="value:HIGH_DVSID_NAME" maxlength="20" size="40" style="width: 250px;" readOnly />-->
				   <!--<button id="deptSearchBtn" class="k-button"><span class="k-icon k-i-plus"></span>검색</button>-->
				   <span data-bind="text:HIGH_DVSID_NAME"></span>	
				</td>
			</tr>
			<tr>
				<td class="subject">
					<label class="right inline required">
						<span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 부서명
					</label>
				</td>
				<td class="subject">
					<!--<input class="k-textbox" id="dvs_name" placeholder="" data-bind="value:DVS_NAME" maxlength="20" size="40" style="width: 250px;" onKeyUp="chkNull(this);"/>-->
					<span data-bind="text:DVS_NAME"></span>	
				</td>
				
			</tr>
			
			<tr id = "managerArea">
				<td class="subject" width="100px">
					<span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 부서장
				</td>
				<td class="subject">
                    <span data-bind="text:DVS_MANAGER_NM"></span> 
					
				</td>
			</tr>
			<!--<tr>
				<td class="subject">
					<label class="right inline required">
						<span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 부서기준
					</label>
				</td>
				<td class="subject">
					<select id="empStsCd" data-bind="value:DEPT_STND_CD" style="width:200px;" ></select>
				</td>
			</tr>-->
			<tr>
				<td class="subject" width="100px"   ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부</td> 
				<td class="subject">
					<input type="radio" id="useFlag" name="useFlag"  value="Y" checked="checked" /> 사용
					<span style="padding-left:70px">
					<input type="radio" id="useFlag" name="useFlag"  value="N"/> 미사용</span>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="right" style="border-right:none;border-bottom:none;border-left:none;">
					<div style="text-align: right;">
					   <!--<button id="saveBtn" onclick="deptSave()" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
					   <button id="delBtn" class="k-button">삭제</button>&nbsp;-->
					   <button id="cencelBtn" onclick="cancelBt();" class="k-button">닫기</button>
					</div>
				</td>                   
			</tr>
		</table>
	</script>
        
	    <!-- 부서장 선택 -->
        <div id="lst-add-user-window" style="display:none;">
            <div id="lst-add-user-window-selecter">
                <div id="lst-add-user-window-selecter-grid"></div>
            </div>
	    </div>
    
<div id="dept-window" style="display: none;">
    * 사용중인 부서만 조회됩니다.
    <div style="width: 100%">
      <table style="width: 100%;">
        <tr>
            <td>
                <div id="deptPopupTreeview"   style="width: 100%; height: 230px; "></div>
            </td>
        </tr>
      </table>
    </div>
</div>

    </body>
</html>