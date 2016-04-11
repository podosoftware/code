<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="main">
<head>
	<title>커뮤니티 관리</title>
	<script type="text/javascript">

       function openwindow(selectYear) {
    	    $("#grid").empty();
	       	$("#grid").kendoGrid({
	               dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"/mgmt/brd/brd-mgmt-list.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){	
	                       	return {  startIndex: options.skip, pageSize: options.pageSize, year : selectYear  };
	                       } 		
	                   },
	                   schema: {
	                   	total: "totalItemCount",
	                   	data: "items",
	                       model: {
	                           fields: {
	                        	   BOARD_CODE : { type: "int" },
	                        	   BOARD_NUM : { type: "int" },
	                        	   SEQ : { type: "int" },
	                        	   SUBJECT_NAME : { type: "string" },
	                        	   CHASU : { type: "string" },
	                        	   BOARD_CONTENT : { type: "string" },
	                        	   CREATETIME: { type: "string" },
	                        	   NAME : { type: "string" },
	                        	   FILE_NUM : { type: "string" }
	                           }
	                       }
	                   },
	                   pageSize: 15,
	                   serverPaging: false,
	                   serverFiltering: false,
	                   serverSorting: false,
	                   change: function(e) {  
	                	   $("#totalCount").html(this.total());
		               }
	               },
	               height: 330,
	               filterable: false,
	               sortable: false,
	               pageable: false,
	               columns: [
	                   {
	                       field:"SEQ",
	                       title: "번호",
						   width:50
	                   },
	                   {
	                       field: "SUBJECT_NAME",
	                       title: "과정명",
						   width:200
	                   },
	                   {
	                       field: "CHASU",
	                       title: "차수",
	                       width:50
	                   },
	                   {
	                       field: "BOARD_CONTENT",
	                       title: "커뮤니티 글",
	                       width:300
	                   },
	                   {
	                       field: "CREATETIME",
	                       title: "작성일",
	                       width:100
	                   },
	                   {
	                       field: "NAME",
	                       title:  "작성자",
	                       width:80
	                   }
	               ],
	               filterable: true,
	               sortable: true,
	               pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
	               selectable: 'row',
	               height: 500,
	               change: function(e) {                    
		            	 var selectedCells = this.select();				
		                 var selectedCell = this.dataItem( selectedCells );         
						
		     			  if( !$("#detail-comunity-window").data("kendoWindow") ){		
		     			    	$("#detail-comunity-window").kendoWindow({
		     			    		width:"320px",
		     			    		minWidth:"320px",
		     			    		minHeight:"300px",
		     			    		resizable : false,
		                             modal: true,
		                             visible: false
		     			    	});
		     			   }
		     			    $("#detail_creater").val(selectedCell.NAME);
		                 	$('#detail_content').val(selectedCell.BOARD_CONTENT);
		     				$('#detail-comunity-window').data("kendoWindow").center();      
		     		    	$("#detail-comunity-window").data("kendoWindow").open();

		     		    	// create ComboBox from input HTML element
			         	    $("#detail_file").kendoListView({
			         	        dataSource: {
			                        type: "json",
			                        transport: {
			                            read: { url:"/mgmt/brd/brd-file-list.do?output=json", type:"POST" },
			                            parameterMap: function (options, operation){	
			                            	return {  FILE_NUM : selectedCell.FILE_NUM };
			                            } 		
			                   },
			                   schema: {
			                   	data: "items",
			                       model: {
			                           fields: {
			                        	   TEXT : { type: "String" }
			                           }
			                       }
			                   }},
			                   template: kendo.template($("#template").html())
			         	    });
		     		    	
			         	   // 커뮤니티 상세보기 삭제
			      			$("#idchk-ok-btn").click( function(){
			      				$.ajax({
			             			type : 'POST',
			     					url:"/mgmt/brd/brd-community-delete.do?output=json",
			     					data : { BOARD_CODE : selectedCell.BOARD_CODE, BOARD_NUM : selectedCell.BOARD_NUM },
			     					complete : function( response ){
			     						var obj  = eval("(" + response.responseText + ")");
			     						if(obj.saveCount != 0){
			     							alert("삭제되었습니다.");	
			     							$("#detail-comunity-window").data("kendoWindow").close();
			     							openwindow($("#yearSelect").val());	
			     						}else{
			     							alert("삭제에 실패 하였습니다.");
			     						}							
			     					},
			     					error: function( xhr, ajaxOptions, thrownError){								
			     					},
			     					dataType : "json"
			     				});		
			                  });
		          }
	               
	           });

	       }
       
		   
	</script>
	<script type="text/javascript">               
        yepnope([{
       	  load: [ 
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css',
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.default.min.css',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
       	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
       	 	'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
      	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js' 
          ],
          complete: function() {  
        	  
        	// 커뮤니티 상세보기 팝업창 취소
  			$("#idchk-cancel-btn").click( function() {	
              	$("#detail-comunity-window").data("kendoWindow").close();
              	 
              } );
        	
  			// create ComboBox from input HTML element
     	    $("#yearSelect").kendoComboBox({
     	        dataTextField: "TEXT",
     	        dataValueField: "VALUE",
     	        dataSource: {
	                    type: "json",
	                    transport: {
	                        read: { url:"/mgmt/brd/brd_current_year_list.do?output=json", type:"POST" }
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
                },
     	        filter: "contains",
     	        suggest: true,
     	        index: 0,
     	        change: function(e){
     	        	openwindow($("#yearSelect").val());
     	        },
     	        dataBound:function(e){
     	        	 openwindow($("#yearSelect").val());
     	        }
     	    });

        	 


          }
      }]);   
	</script>
</head>
<body class="cf">
	<!-- START MAIN CONTNET -->
	<div id="container" class="cf">
		<div style="overflow:hidden;">
			<div style="text-align: left; float:left;">년도 : <select id="yearSelect"></select></div>
			<div style="float: right; margin-top:6px;">총 개수 : <span id="totalCount"></span></div>
		</div>
			<section class="content">
				<div id="grid"></div>
			</section>
	</div>
	<div id="detail-comunity-window" style="display:none; width:500px;">
			<table class="tabular" width="100%">
					<tr>
						<td>작성자 : <input type="text" id="detail_creater" style="border: none;"  readonly="readonly"/></td>
					</tr>
					<tr>
						<td><textarea cols="" rows="10" id="detail_content"  class="k-textbox"  style="width: 100%"></textarea></td>
					</tr>
					<tr>
						<td><div id="detail_file"  class="twit">
						</div></td>
					</tr>
			</table>
			<div style="text-align: right;">
				<button id="idchk-ok-btn" class="k-button">삭제</button>
				<button id="idchk-cancel-btn" class="k-button">취소</button>
			</div>
	</div>
	<!-- END MAIN CONTENT  --> 	
	<footer>
  	</footer>
  	<script type="text/x-kendo-tmpl" id="template">
        <div>
			<a href='/mgmt/brd/file_download.do?output=&FILE_NUM=#:FILE_NUM#&SEQ_NUM=#:SEQ_NUM#' target="_parent" title="파일다운로드">#:TEXT#</a>
        </div>
    </script>
</body>
</html>