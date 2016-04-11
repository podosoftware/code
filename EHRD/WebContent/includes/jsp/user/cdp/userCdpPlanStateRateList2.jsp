<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}

kr.podosoft.ws.service.cdp.action.CdpServiceAction action = (kr.podosoft.ws.service.cdp.action.CdpServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage"   >
<head>
<title></title>

<script type="text/javascript"> 

yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.<%=theme%>.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'           
    ],
    complete: function() {
        kendo.culture("ko-KR"); 
        
        
      	//로딩바 선언..
        loadingDefine();
      	
        //기준년도 
        var now = new Date();
        var maxYyyy = now.getFullYear()+1;
        var arrYyyy = [];
        for(var i=maxYyyy; i>=2014; i--){
            arrYyyy.push({VALUE: i, TEXT:(i+"년")});
        }
        var dataSource_searchYyyy = new kendo.data.ObservableArray( arrYyyy );
        
        var searchYyyy = $("#searchYyyy").kendoDropDownList({
            dataTextField: "TEXT",
            dataValueField: "VALUE",
            dataSource: dataSource_searchYyyy,
            filter: "contains",
            suggest: true,
            dataBound:function(e){
                this.value(now.getFullYear());
            },
            change: function(e){
            	
            	// 상세영역 비활성화
                $("#splitter").data("kendoSplitter").collapse("#detail_pane");
            	
            	$("#grid").data("kendoGrid").dataSource.read();
            	
            	
            }
        }).data("kendoDropDownList");
        
      
        // area splitter
		var splitter = $("#splitter").kendoSplitter({
			orientation : "horizontal",
			panes : [ {
				collapsible : true,
				min : "300px"
			}, {
				collapsible : true,
				collapsed : true,
				min : "700px"
			} ]
		});
        
        
		// kendoGrid : no data 처리
        function DisplayNoResultsFound(grid) {
	  	    // 그리드에서 열 수를 가져온다.
	  	    var dataSource = grid.data("kendoGrid").dataSource;
	  	    var colCount = grid.find('.k-grid-header colgroup > col').length;

	  	    // 결과가 없을 경우 표시 행을 배치한다.
	  	    if (dataSource._view.length == 0) {
	  	        grid.find('.k-grid-content tbody')
	  	            .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" style="text-align:center"><b>검색 데이타가 없습니다.</b></td></tr>');
	  	    }
			/* 
			// 표시되는 행 수를 가져온다.
	  	    var rowCount = grid.find('.k-grid-content tbody tr').length;

	  	    // rows가 적은 경우 페이지 크기는 누락된 행의 수에 추가 
	  	    if (rowCount < dataSource._take) {
	  	        var addRows = dataSource._take - rowCount;
	  	        for (var i = 0; i < addRows; i++) {
	  	            grid.find('.k-grid-content tbody').append('<tr class="kendo-data-row"><td>&nbsp;</td></tr>');
	  	        }
	  	    }*/
	  	}

		$("#grid").kendoGrid({
			dataSource : {
                type : "json",
                transport : {
                    read : {
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_state_rate_list.do?output=json",
                        type : "POST"
                    },
                    parameterMap : function(options, operation) { 
                        var sortField = "";
                        var sortDir = "";
                        if (options.sort && options.sort.length>0) {
                            sortField = options.sort[0].field;
                            sortDir = options.sort[0].dir;
                        }
                        return { 
                            startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter), YYYY: removeNullStr( searchYyyy.value() )
                        };  
                    }
                },
                schema : {
                    total : "totalItemCount",
                    data : "items",
                    model : {
                        id : "USERID",
                        fields : {
                        	ID : { type : "string" },
                        	EMPNO : { type : "string" },
                        	USERID : {type:"int"},
                        	NAME : { type : "string" },
                        	DVS_NAME : { type : "string" },
                        	DVS_FULLNAME : { type : "string" }, 
                        	GRADE_NM : { type : "string" },
                            AVG_RATE : { type : "string" },
                        	YEAR : { type : "int" }
                        }
                    }
                },
                /*change: function(e){
             	   alert(JSON.stringify(e.items));
                },*/
                pageSize : 30,
                serverPaging : true,
                serverFiltering : true,
                serverSorting : true,
                error : function(e) {
                    //alert(e.status);
                    if(e.xhr.status==403){
                       alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                       sessionout();
                    }else{
                       alert('xhr.status = ' + e.xhr.status + '\n' +  'xhr.statusText = '  + e.xhr.statusText );
                    }
                }
            },
            /*dataBound : function(){
            	DisplayNoResultsFound($('#grid'));
            },*/
			columns : [ {
				field : "DVS_NAME",
				title : "부서명",
                width : "140px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
			}, {
				field : "DVS_FULLNAME",
				title : "전체부서명",
                width : "200px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:left" }
			}, {
				field : "NAME",
				title : "성명",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center; text-decoration: underline;" },
                template : function(data){
                	
                	return "<a href=\"javascript:void();\" onclick=\"javascript: fn_detailView('"+data.YEAR+"', '"+data.USERID+"'); \" >"+data.NAME+"</a>";
                }
			}, {
				field : "EMPNO",
				title : "교직원번호",
                width : "120px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
			}, {
				field : "GRADE_NM",
				title : "직급",
                width : "120px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
			}, {
                field : "AVG_RATE",
                title : "실행율(%)",
                width : "120px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            } ],
			filterable : {
                   extra : false,
                   messages : {
                       filter : "필터",
                       clear : "초기화"
                   },
                   operators : {
                       string : {
                           contains : "포함",
                           startswith : "시작문자",
                           eq : "동일단어"
                       },
                       number : {
                           eq : "같음",
                           gte : "이상",
                           lte : "이하"
                       }
                   }
               },
               height : 543,
               sortable : true,
               pageable : true,
               resizable : true,
               reorderable : true,
               selectable: "row",
               pageable : {
                   refresh : false,
                   pageSizes : [10,20,30],
                   buttonCount: 5
               }
		});
		
		/*
		$("#grid").data("kendoGrid").dataSource.originalFilter = $("#grid").data("kendoGrid").dataSource.filter;
		
		$("#grid").data("kendoGrid").dataSource.filter = function(){
			if(arguments.length > 0){
				this.trigger("filtering", arguments);
			}
			
			var result = $("#grid").data("kendoGrid").dataSource.originalFilter.apply(this, arguments);
			
			alert(JSON.stringify(result));
			
			return result;
		};
		*/
		
        // show detail 
        $('#detail_pane').show().html(kendo.template($('#detailTemplate').html()));        

        //상세페이지의 취소버튼 클릭 시..
        $("#cancelBtn").click(function(){
        	kendo.bind($(".detail_Info"), null);

            // 상세영역 비활성화
            $("#splitter").data("kendoSplitter").collapse("#detail_pane");
        });
        
	}

}]);


//상세보기.
function fn_detailView(year, userid){
	
	//alert("### year, userid" + year + " / "+ userid);
	
	var grid = $("#grid").data("kendoGrid");
	var data = grid.dataSource.get(userid); // .data();
    /*
    var res = $.grep(data, function (e) {
        return (e.userid == userid);
    });
    */
    
    
    $("#select-userid").val(userid); //선택 사용자
    
    
    kendo.bind($(".detail_Info"), data);
    
	//$("#detailGrid").data("kendoGrid").dataSource.read();
    
    // 상세영역 활성화
    $("#splitter").data("kendoSplitter").expand("#detail_pane");
    
    var detailGridColumn = [];
    
    detailGridColumn.push(
            {
                field : "CMPNAME",
                title : "역량",
                width : "150px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }
    );
    detailGridColumn.push(
            {
            	field : "PLAN_TIME",
                title : "계획시간",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }
    );
    detailGridColumn.push(
            {
            	field : "RUN_TIME",
                title : "실적시간",
                width : "100px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }
    );
    detailGridColumn.push(
            {
            	field : "RATE",
                title : "실행율(%)",
                width : "120px",
                headerAttributes : { "class" : "table-header-cell",  style : "text-align:center" },
                attributes : { "class" : "table-cell", style : "text-align:center" }
            }
    );
    
    $("#detailGrid").empty();
    $("#detailGrid").kendoGrid({
        columns : detailGridColumn,
        filterable : false,
        height : 390,
        sortable : true,
        pageable : false,
        resizable : false,
        reorderable : true,
        selectable: "row"
    });
    
  	//상세보기 그리드 데이타 초기화.
    $("#detailGrid").data("kendoGrid").dataSource.data([]);
  	
  	
  	$.ajax({
  		type: 'POST',
  		dataType : 'json',
  		url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_state_rate_detail.do?output=json",
  		data : {
  			YYYY : year, SELECT_USER: userid
  		},
  		success : function(response){
  			
  			//alert(JSON.stringify(response.items));
  			
  			if(response.items != null && response.items.length > 0){
  				//alert("if \n"+JSON.stringify(response.items));
  				$("#detailGrid").data("kendoGrid").dataSource.data(response.items);
  			}else{
  				//alert("else \n"+JSON.stringify(response.items));
  				DisplayNoResultsFound($('#detailGrid'));
  			}
  		},
  		error : function(xhr, ajaxOptions, thrownError){
  			if(xhr.status == 403){
  				alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
  				sessionout();
  			}else{
  				alert('xrs.status = ' + xhr.status + '\n' + 
                        'thrown error = ' + thrownError + '\n' +
                        'xhr.statusText = '  + xhr.statusText );
  			}	
  		}
  	});
  	
  	function DisplayNoResultsFound(grid) {
  	    // 그리드에서 열 수를 가져온다.
  	    var dataSource = grid.data("kendoGrid").dataSource;
  	    var colCount = grid.find('.k-grid-header colgroup > col').length;

  	    // 결과가 없을 경우 표시 행을 배치한다.
  	    if (dataSource._view.length == 0) {
  	        grid.find('.k-grid-content tbody')
  	            .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" style="text-align:center"><b>검색 데이타가 없습니다.</b></td></tr>');
  	    }
		/* 
		// 표시되는 행 수를 가져온다.
  	    var rowCount = grid.find('.k-grid-content tbody tr').length;

  	    // rows가 적은 경우 페이지 크기는 누락된 행의 수에 추가 
  	    if (rowCount < dataSource._take) {
  	        var addRows = dataSource._take - rowCount;
  	        for (var i = 0; i < addRows; i++) {
  	            grid.find('.k-grid-content tbody').append('<tr class="kendo-data-row"><td>&nbsp;</td></tr>');
  	        }
  	    }*/
  	}
  	
  	
 	// template에서 호출된 함수에 대한 이벤트 종료 처리.
    if (event.preventDefault) {
        event.preventDefault();
    } else {
        event.returnValue = false;
    }
    

}

function excelDownLoad(button){
    button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_state_rate_list_excel.do?YYYY=" + $("#searchYyyy").val();
}

</script>
    <style scoped>
    .demo-section.style01 {width:120px;}
    .k-input {padding-left:5px;}
    </style>   
         
    </head>
<body>

	<div>
		<input type="hidden" id="select-userid" name="select-userid" />							
	</div>
    
	<div class="container">
        <div id="cont_body">
         <div class="content">
            <div class="top_cont">
                <h3 class="tit01">계획대비 실행율</h3>
                <div class="point">
                    ※ 임직원들의 경력개발계획 대비 실행율을 열람할 수 있습니다. <br>
                    ※ 성명을 클릭하면 상세조회를 할 수 있습니다.
                </div>
                <div class="location">
                    <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
                    <span>경력개발계획&nbsp; &#62;</span>
					<span class="h">계획대비실행율</span>
                </div><!--//location-->
            </div>
             <div class="sub_cont">
            
                <div class="result_info">
                    <ul>
                        <li>
                        <label for="p_year">계획년도  : </label>
                            <div class="demo-section k-header style01" id="p_year">
                                <select id="searchYyyy" style="width: 120px" accesskey="w"> </select>
                            </div>
                        </li>  
                    </ul>
                    <div class="btn">
                        <a class="k-button" onclick="javascript: excelDownLoad(this)">엑셀 다운로드</a>
                    </div>
                </div><!--//result_info-->
                
                <div id="splitter" style="width:1220px; height: 545px; border:none;" class="mt10 mb10">
                    <div id="list_pane">
                        <div id="grid"></div>
                    </div>
                    <div id="detail_pane">
                    
                    </div><!--//detail_pane-->
                </div>
                
             </div><!--//sub_cont-->
         </div><!--//content-->
        </div><!--//cont_body-->
    </div><!--//container-->


	<script type="text/x-kendo-template"  id="detailTemplate">  
		<div class="detail_Info" style="height:90%">
		
			<div class="tit">역량별 실행율 상세정보 </div>
			
			<div>
			
				<div style="margin:10px 10px; font-weight:bold; color:black">
				▶  <span data-bind="text:YEAR" ></span>&nbsp;년도 최종 실행율(%)  
									&nbsp; : &nbsp; <span data-bind="text:AVG_RATE" style="color:red; font-weight:bold"></span>&nbsp; 달성
				</div>
				
				<div id="detailGrid" style="overflow-y:auto; margin:10px 10px;" ></div>
				
				<div style="margin:10px 10px">
					<br>
					<button id="cancelBtn" class="k-button" style="width:88px;float: right;">닫기</button>
				</div>
				
			</div>
			
		</div><!-- end detail_Info -->
	</script>
</body>
</html>