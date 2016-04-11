<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 
이사랑 교육결과 조회 및 엑셀다운로드 용 팝업
thlim@podosw.com
Sync. 2014.12.10
--%>
<%
boolean syncPageRoleChk = request.isUserInRole("ROLE_SYSTEM");

/* 관리자만 호출가능 */
if(!syncPageRoleChk) {
%>
<script type="text/javascript">
var fn_syncEdursltPopup = function() {
	alert('교육운영자만 이용이 가능합니다.');
};
</script>
<%
} else {
%>
<script type="text/javascript">
var fn_syncEdursltPopup = function() {
	if( !$("#sync_edurslt_window").data("kendoWindow") ){
	    $("#sync_edurslt_window").kendoWindow({
	        width:"1200px",
	        height:"600px",
	        resizable : true,
	        title : "이사람연동 엑셀다운로드",
	        modal: true,
	        visible: false
	    });
	    
	    var syncFdate = $("#sync_fdate").kendoDatePicker({
            format: "yyyy-MM-dd",
            change: function(e) {                    
                var startDate = syncFdate.value(),
                endDate = syncTdate.value();

                if (startDate) {
                    startDate = new Date(startDate);
                    startDate.setDate(startDate.getDate());
                    syncTdate.min(startDate);
                } else if (endDate) {
                	syncFdate.max(new Date(endDate));
                } else {
                    endDate = new Date();
                    syncFdate.max(endDate);
                    syncTdate.min(endDate);
                }
                         
             }
        }).data("kendoDatePicker");

        var syncTdate = $("#sync_tdate").kendoDatePicker({
            format: "yyyy-MM-dd",
            change: function(e) {                    
                var endDate = syncTdate.value(),
                 startDate = syncFdate.value();
         
                 if (endDate) {
                     endDate = new Date(endDate);
                     endDate.setDate(endDate.getDate());
                     syncFdate.max(endDate);
                 } else if (startDate) {
                	 syncTdate.min(new Date(startDate));
                 } else {
                     endDate = new Date();
                     syncFdate.max(endDate);
                     syncTdate.min(endDate);
                 }
            }
        }).data("kendoDatePicker");

        syncFdate.value(new Date(now.getFullYear(), now.getMonth(), 1));
        syncTdate.value(new Date(now.getFullYear(), now.getMonth()+1, 0));
        syncFdate.max(syncTdate.value());
        syncTdate.min(syncFdate.value());
	
	    $("#sync_edurslt_grid").empty();
	    
	    $("#sync_edurslt_grid").kendoGrid({
	        dataSource: {
	            type: "json",
	            transport: {
	                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/sync_edurslt_list.do?output=json", type:"POST" },
	                parameterMap: function (options, operation){
	                    var sortField = "";
	                    var sortDir = "";
	                    if (options.sort && options.sort.length>0) {
	                        sortField = options.sort[0].field;
	                        sortDir = options.sort[0].dir;
	                    }
	                    return { 
	                        startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter),
	                        syncFdate : $("#sync_fdate").val(),
	                        syncTdate : $("#sync_tdate").val()
	                    };  
	                }
	            },
	            schema: {
	            	total : "totalItemCount",
	                 data: "items",
	                 model: {
	                     fields: {
	                    	 COL02 : { type: "string" },
	                    	 COL03 : { type: "string" },
	                    	 COL07 : { type: "string" },
	                    	 COL08 : { type: "string" },
	                    	 COL09 : { type: "string" },
	                    	 COL10 : { type: "string" },
	                    	 COL11 : { type: "string" },
	                    	 COL12 : { type: "string" },
	                    	 COL13 : { type: "string" },
	                    	 COL14 : { type: "string" },
	                    	 COL15 : { type: "number" },
	                    	 COL16 : { type: "number" },
	                    	 COL17 : { type: "number" },
	                    	 COL18 : { type: "number" },
	                    	 COL19 : { type: "string" },
	                    	 COL20 : { type: "string" },
	                    	 COL21 : { type: "string" },
	                    	 COL22 : { type: "string" },
	                    	 COL23 : { type: "string" },
	                    	 COL24 : { type: "string" },
	                    	 COL25 : { type: "string" },
	                    	 COL27 : { type: "string" },
	                    	 COL28 : { type: "string" },
	                    	 COL29 : { type: "string" },
	                    	 COL30 : { type: "string" },
	                    	 COL31 : { type: "string" },
	                    	 COL32 : { type: "string" },
	                    	 COL33 : { type: "string" }
	                        }
	                 }
	            },
	            pageSize : 30,
	            serverPaging: true, serverFiltering: true, serverSorting: true
	        },
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
	        columns: [
				{
				    field : "COL02",
				    title : "소속",
				    width : "250px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:left" }
				},
				{
				    field : "COL03",
				    title : "직급코드",
				    width : "110px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center;" }
				},
				{
				    field : "COL07",
				    title : "성명",
				    width : "150px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL08",
				    title : "인정직급코드",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL09",
				    title : "부처지정학습",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL11",
				    title : "학습종류",
				    width : "110px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL12",
				    title : "시작일자",
				    width : "150px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL13",
				    title : "종료일자",
				    width : "150px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL14",
				    title : "제목",
				    width : "300px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:left" }
				},
				{
				    field : "COL15",
				    title : "실적시간(시간)",
				    width : "140px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL16",
				    title : "실적시간(분)",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL17",
				    title : "인정시간(시간)",
				    width : "140px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL18",
				    title : "인정시간(분)",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},/*
				{
				    field : "COL19",
				    title : "필수여부",
				    width : "150px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},*/
				{
				    field : "COL20",
				    title : "학습방법",
				    width : "110px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL21",
				    title : "교육시간구분",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL22",
				    title : "교육기관구분",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL23",
				    title : "교육기관코드",
				    width : "150px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL24",
				    title : "교육기관명",
				    width : "200px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL25",
				    title : "내용",
				    width : "300px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:left" }
				},
				{
				    field : "COL27",
				    title : "평정점",
				    width : "110px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL28",
				    title : "입력자",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL29",
				    title : "입력일시",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL30",
				    title : "수정자",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL31",
				    title : "수정일시",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL32",
				    title : "교직원번호",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "COL33",
				    title : "연동구분",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				}
	        ],
	        sortable : true,
	        pageable : true,
	        resizable : true,
	        reorderable : true,
	        pageable : {
	            refresh : false,
	            pageSizes : [10,20,30],
	            buttonCount: 5
	        },
	        height: 500
	    });
	    
	}else{
		$("#sync_edurslt_grid").data("kendoGrid").dataSource.read();
	}
	
	$("#sync_edurslt_window").data("kendoWindow").center();
	$("#sync_edurslt_window").data("kendoWindow").open();
};

var fn_syncEdursltDownExcel = function(button) {
	if($("#sync_fdate").val()!='' && $("#sync_tdate").val()!=''){
		button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/sync_edurslt_list_excel.do?syncFdate=" + $("#sync_fdate").val() + "&syncTdate=" + $("#sync_tdate").val() + "&pageSize=3000";
	}else{
		alert("검색 시작일과 종료일을 모두 입력해주세요.");
	}
};

var fn_srchSyncEdursltGrid = function() {
	$('#sync_edurslt_grid').data('kendoGrid').dataSource.read();
};

</script>
<!-- 과정검색 팝업 -->
<div id="sync_edurslt_window" style="display:none; overflow-y: hidden;">
	<div style="position: relative;">
		<div class="sub_cont">
			<div class="result_info">
				<div class="tab_cont">
					<label for="yyyy" >검색기준일</label> : 
					<input type="text" id="sync_fdate" style="width:120px; "  /> ~
					<input type="text" id="sync_tdate" style="width:120px; "  />
					<button class="k-button" style="width: 60px;" onclick="fn_srchSyncEdursltGrid();">검색</button>
				</div>
				<div class="btn">
					<a class="k-button" onclick="fn_syncEdursltDownExcel(this)" >엑셀 다운로드</a>
				</div>
			</div>
			<div id="sync_edurslt_grid" class="mt15" ></div>	
		</div>
	</div>
</div>
<% } %>