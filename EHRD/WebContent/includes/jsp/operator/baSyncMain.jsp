<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="architecture.ee.web.util.ParamUtils" %>
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
                'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
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
            
            
            //로딩바 선언..
            loadingDefine();
          
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
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-sync-list.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){ 
	                            var sortField = "";
	                            var sortDir = "";
	                            if (options.sort && options.sort.length>0) {
	                                sortField = options.sort[0].field;
	                                sortDir = options.sort[0].dir;
	                            }
	                            return { 
	                                startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter)
	                            };
	                       }
	                   },
	                   schema: {
	                       total: "totalItemCount",
	                       data: "items",
	                          model: {
	                              fields: {
	                            	  SYNC_SEQ : {type:"number"},
	                            	  SYNC_NM : { type: "string" },
	                            	  SYNC_DTIME_DATE : { type: "string" },
	                            	  AUTO_EXED_YN : { type: "string"},
	                            	  SUCCESS_YN: { type: "string"}
	                              }
	                          }
	                   },
	                   pageSize: 30,
	                   serverPaging: true,
	                   serverFiltering: true,
	                   serverSorting: true
	               },
	               columns: [
                             { 
                                 field:"SYNC_SEQ", title: "순번", filterable: false, width:100,
                                 headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                 attributes:{"class":"table-cell", style:"text-align:center"} 
                             },
                             { 
                               field:"SYNC_NM", title: "동기화유형", filterable: true, width:120 ,
                                 headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                 attributes:{"class":"table-cell", style:"text-align:center"} 
                             },
                             { 
                               field:"SYNC_DTIME", title: "실행일시", filterable: true, width:150 ,
                                 headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                 attributes:{"class":"table-cell", style:"text-align:center"} 
                             },
                             { 
                               field:"AUTO_EXED_YN", title: "자동여부", filterable: true, width:100,
                                 headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                 attributes:{"class":"table-cell", style:"text-align:center"} 
                             },
                             { 
                                 field:"SUCCESS_YN", title: "성공여부", filterable: true, width:100,
                                 headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                 attributes:{"class":"table-cell", style:"text-align:center"} 
                             },
                             { 
                                 title: "메세지", filterable: false, sotrable: false, width:80,
                                 headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                 attributes:{"class":"table-cell", style:"text-align:center"},
                                 template: function(data){
                                     return "<input id='userSelBtn' type='button' class='k-button k-i-close' style='size:20' value='확인' onclick='fn_select("+data.SYNC_SEQ+");'/>"
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
	                sortable : true,
	                pageable : true,
	                resizable : true,
	                reorderable : true,
	                selectable: "row",
	                pageable : {
	                    refresh : false,
	                    pageSizes : [10,20,30]
	                }
	            });
	            
	        //메세지 조회 팝업
	        if( !$("#msg-window").data("kendoWindow") ){
                $("#msg-window").kendoWindow({
                  width:"400px",
                    height:"300px",
                    resizable : true,
                    title : "실행 메세지",
                    modal: true,
                    visible: false
                });
             }
	        
	        //수동동기화 실행
	        $("#exec-btn").click(function(){
	        	if( !$("#exec-window").data("kendoWindow") ){
	                $("#exec-window").kendoWindow({
	                  width:"400px",
	                    height:"175px",
	                    resizable : true,
	                    title : "수동동기화 실행",
	                    modal: true,
	                    visible: false
	                });
	                
	                $("#execGrid").kendoGrid({
                        dataSource: {
                            type: "json",
                            transport: {
                                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                                parameterMap: function (options, operation){    
                                    return {  STANDARDCODE : "BA24"};
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
                            serverSorting: false},
                        columns: [
                             { 
                                 field:"TEXT", title: "동기화 유형", filterable: false, width:150,
                                 headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                 attributes:{"class":"table-cell", style:"text-align:center"} 
                             },
                             { 
                                 title: "수동동기화 실행", filterable: true, width:120,
                                 headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                                 attributes:{"class":"table-cell", style:"text-align:center"},
                                 template: function(data){
                                     return "<input id='userSelBtn' type='button' class='k-button k-i-close' style='size:20' value='실행' onclick='fn_exec("+data.VALUE+");'/>"
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
                         height: 150
                     });
	             }
	        	
	            $("#exec-window").data("kendoWindow").center();
	            $("#exec-window").data("kendoWindow").open();
	        });
	        
	        
	        //브라우저 resize 이벤트 dispatch..
            $(window).resize();
        }
    }]);   
    
    //메세지 확인.
    function fn_select(seq){
    	var array = $('#grid').data('kendoGrid').dataSource.data();
        var res = $.grep(array, function (e) {
            return e.SYNC_SEQ == seq;
        });
        
        $("#msgSpan").text(res[0].EXEC_MSG);
        
        $("#msg-window").data("kendoWindow").center();
        $("#msg-window").data("kendoWindow").open();
      
    }
    
    //수동동기화 실시.
    function fn_exec(syncCd){
        
        //alert(syncCd);
        var syncNm = "";
        if(syncCd==1){
        	syncNm = "부서정보 동기화";
        }else if(syncCd==2){
        	syncNm = "직급정보 동기화";
        }else if(syncCd==3){
        	syncNm = "사용자정보 동기화";
        }
        if (confirm(syncNm+"를 실행하시겠습니까?")) {
            //로딩바생성.
            loadingOpen();
            
            $.ajax({
                type : 'POST',          
                url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/exec_sync_job.do?output=json",
                data : {
                	syncCode : syncCd
                },
                complete : function( response ){
                    //로딩바 제거.
                    loadingClose();
                    
                    var obj  = eval("(" + response.responseText + ")");
                    if(!obj.error){
                        if(obj.statement == "Y"){
                            
                            // 목록 read
                            $("#grid").data("kendoGrid").dataSource.read();
                        
                            alert("성공 하였습니다.\n"+obj.msg);
                        }else{
                            alert("실패 하였습니다.\n"+obj.msg);
                        }   
                    }else{
                        alert("ERROR: "+obj.error.message);
                    }                       
                },
                error : function(xhr, ajaxOptions, thrownError) { 
                    //로딩바 제거.
                    loadingClose();
                    
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

    
    </script>

</head>
<body >

    <div id="content">
        <div class="cont_body">
            <div class="title mt30">동기화 관리</div>

            
	        <div class="table_zone" >
	           <div class="table_btn">
                    <button id="exec-btn" class="k-button"><span class="k-icon k-i-plus"></span>수동동기화 실행</button>
                </div>
	            <div class="table_list">
	                <div id="grid" ></div>
	            </div>
	        </div>
	    </div>
    </div>

    <!-- 메세지 확인 팝업 -->
    <div id="msg-window" style="display:none;">
        <span id="msgSpan"></span>
    </div>
    
    <!-- 수동동기화 실행 팝업 -->    
    <div id="exec-window" style="display:none;">
        <div id="execGrid" ></div>
    </div>
</body>
</html>