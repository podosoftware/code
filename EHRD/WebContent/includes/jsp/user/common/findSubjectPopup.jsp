<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript">
var fsp_callBackFunction; // 과정선택 시 실행할 function 명

var findSubjectList = function() {
	if( !$("#subjectList-window").data("kendoWindow") ){
	    $("#subjectList-window").kendoWindow({
	        width:"1200px",
	        height:"480px",
	        resizable : true,
	        title : "과정검색",
	        modal: true,
	        visible: false
	    });
	
	    $("#subjectSearchGrid").empty();
	    
	    $("#subjectSearchGrid").kendoGrid({
	        dataSource: {
	            type: "json",
	            transport: {
	                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-use-list.do?output=json", type:"POST" },
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
	            	total : "totalItemCount",
	                 data: "items",
	                 model: {
	                     fields: {
	                            SUBJECT_NUM : { type: "number" },
	                            TRAINING_STRING: { type:"string"},
	                            SUBJECT_NAME : { type: "string" },
	                            DEPT_DESIGNATION_YN: { type: "string"},
	                            DEPT_DESIGNATION_STRING: { type: "string" },
	                            INSTITUTE_NAME: { type: "string" },
	                            RECOG_TIME_H: { type: "number" }
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
	            { title: "선택", width: 80,
	                headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                attributes:{"class":"table-cell", style:"text-align:center"} ,
	                template : function(data){
	                    return "<input type='button' class='k-button k-i-close' style='width:45' value='선택' onclick='fn_SelectSubject("+data.SUBJECT_NUM+");'/>";
	                }
	            },
				{
				    field : "TRAINING_STRING",
				    title : "학습유형",
				    width : "120px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "SUBJECT_NAME",
				    title : "과정명",
				    width : "300px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:left;" }
				},
				{
				    field : "DEPT_DESIGNATION_YN",
				    title : "지정학습",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "DEPT_DESIGNATION_STRING",
				    title : "지정학습구분",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
	            {
	                field : "PERF_ASSE_SBJ_STRI",
	                title : "기관성과평가필수교육",
	                width : "150px",
	                headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                attributes : { "class" : "table-cell", style : "text-align:center" }
	            },
				{
				    field : "INSTITUTE_NAME",
				    title : "교육기관",
				    width : "130px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
				    attributes : { "class" : "table-cell", style : "text-align:center" }
				},
				{
				    field : "RECOG_TIME",
				    title : "인정시간",
				    width : "100px",
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
	        height: 440
	    });
	    
	}
	
	$("#subjectList-window").data("kendoWindow").center();
	$("#subjectList-window").data("kendoWindow").open();
};

var fn_SelectSubject = function(subject_num) {

    //로딩바 생성.
   loadingOpen();
    
    $.ajax({
        type : 'POST',
        dataType : 'json',
        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-info.do?output=json",
        data : {
            subjectNum : subject_num
        },
        success : function(response) {
            //로딩바 제거.
            loadingClose();

            if (response.items != null && response.items.length>0) {
            	if(fsp_callBackFunction)
            		fsp_callBackFunction(response.items[0]);
            }
            
			$("#subjectList-window").data("kendoWindow").close();
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
        }
    });
};
</script>
<!-- 과정검색 팝업 -->
<div id="subjectList-window" style="display:none; overflow-y: hidden;">
	<div style="position: relative;">
		<span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> ※과정을 검색 후 선택하시면 됩니다<br>
        <div id="subjectSearchGrid" ></div>
	</div>
</div>