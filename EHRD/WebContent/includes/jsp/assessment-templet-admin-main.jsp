<%@page import="java.util.Enumeration"%>
<%@ taglib prefix="s" uri="/struts-tags"%> 
<%@ page  pageEncoding="UTF-8"  isErrorPage="true"
         import="java.util.Locale, java.io.*,
                 architecture.common.exception.Codeable,
                 architecture.common.util.I18nTextUtils,
                 architecture.ee.util.OutputFormat,
                 architecture.ee.web.util.WebApplicationHelper,
                 architecture.ee.web.util.ParamUtils,
                 architecture.ee.web.struts2.util.ActionUtils" %>
            
<html decorator="main">
    <head>
        <title>템플릿문항 관리</title>
        <script type="text/javascript">  
           	var question = new Array();
           	var minu_value = 0;
           	var select_value = 0;
			var select_templet_num = {TEMPLET_NUM:1};
			var templet_data;
			var item = new Array();
          
			
           
        </script>

        <script type="text/javascript">

function fn_checkRadioYN(val){
	if(val == 'N'){
  		$('input:radio[id=pop-useflag]:input[value=Y]').attr("checked", false);
	}else{
		$('input:radio[id=pop-useflag]:input[value=N]').attr("checked", false);
	}
}
function fn_templetValue(templetNum){
			
	$.ajax({
  			type : 'POST',
		url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/mgmt/assessment/templet-avg-value.do?output=json",
		dataType : "json",
		data : { templetNum: templetNum },
		success : function( response ){	
			
			$("#test-avg-value").val(response.templetAvgValue);
			fn_getQuestionList(select_templet_num);
		},
		error: function( xhr, ajaxOptions, thrownError){
		}
	});
}
function fn_getQuestionList(templetNum){
	$("#question-grid").empty();
	$("#question-grid").kendoGrid({
				dataSource: {
                      type: "json",
                      transport: {
       	                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/mgmt/assessment/templet-question-list.do?output=json", type:"POST" },
                              parameterMap: function (options, operation){	
                        		  return {  startIndex: options.skip, pageSize: options.pageSize, templet_num: templetNum };
                          } 		
                      },
                      schema: {
                      	total: "totalTemlitcount",                    	
                      	data: "questions",
                        model: {
                        	id:"QSTN_NUM",
                        	fields:{
                        		TEMPLET_NUM : { editable:false, type: "number" },
                              	QSTN_NUM : { editable:false, type: "number" },
                              	TEST_ORDER: { editable:false, type: "string" },
                              	QUESTION: {  editable:false, type: "string" },
                              	TEST_VALUE: { editable:true, type: "number", defaultValue:"0" }
                        	}
                        }
                      },
                      pageSize: 10,
                      serverPaging: false,
                      serverFiltering: false,
                      serverSorting: false
                  },
            columns : [
			    { field:"QSTN_NUM", title: "번호", width:8, editable:false },
                { field:"QUESTION", title: "문항", width:70, editable:false },
                { field:"TEST_VALUE", title: "가중치", width:12 , editable:true},
				{ command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 15 }],
            editable:true,
            selectable:true,
            batch: false,
            height: 160,
            pageable: false
            
        });
}

function fn_getQuestion(){
	
	
}
function fn_templet_question_mapping(item){
	
	$.ajax({
		type : 'POST',
		url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/mgmt/assessment/inset-question-save.do?output=json",
		dataType : "json",
		data : { item: kendo.stringify( item ) },
		success : function( response ){	
			fn_templetValue(select_templet_num);
			fn_getQuestionList(select_templet_num);
		},
		error: function( xhr, ajaxOptions, thrownError){
		}
		
	 
	});
}

function fn_main(){
	$("#templet-grid").empty();
 	  var selectedTemplet = new Templet();
	  $("#templet-grid").kendoGrid({
  		dataSource: {
              type: "json",
              transport: {
                  read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/mgmt/assessment/select-templet-list-admin.do?output=json", type:"POST" },
                  destroy: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/mgmt/assessment/del-templet-save.do?output=json", type:"POST",
                	  complete : function(response){
                		  if(eval("("+response.responseText+")").count == 0){
                			  alert("삭제되었습니다.");
                			  fn_getQuestionList("");
                		  }else if(eval("("+response.responseText+")").count > 0){
                			  alert("사용하고 있는 템플릿입니다.");
                			  fn_main();
                		  }
                	  }  
                  },
                  parameterMap: function (options, operation){	
                	  if(operation != "read" && options) {
                		  return {  startIndex: options.skip, pageSize: options.pageSize, item: kendo.stringify( options ) };  
                	  }else {
                		  return {  startIndex: options.skip, pageSize: options.pageSize  };
                	  }
                  }		
              },
              schema: {
              	total: "totalTemlitcount",                    	
              	data: "items",
                model:Templet
              },
              pageSize: 12,
              serverPaging: false,
              serverFiltering: false,
              serverSorting: false
          },
          columns: [
			{ field:"TEMPLET_NUM", title: "번호", filterable: true, width:13 },
            { field:"TEMPLET_NAME", title: "템플릿명", filterable: true, width:40 },                    
            { field: "LEVEL_DIFFICULTY_STRING", title: "난이도", width:13 },
            { field: "SOLVE_TIME", title: "풀이시간-분", width:13 },
            { command: [ { name: "destroy", text:"삭제" }  ], title: "&nbsp;", width: "30px" }], 
          filterable: true,
          editable: "inline",
          selectable: 'row',
          height: 551,
          batch: false,
	      sortable: true,        
          pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  }, 
          change: function() { 
			
        	var selectedCells = this.select();	
        	var selectedCell = this.dataItem( selectedCells ); 
        	var selectRow =  {
        			TEMPLET_NUM: selectedCell.TEMPLET_NUM,                 
        			TEMPLET_NAME :selectedCell.TEMPLET_NAME,         
        			LEVEL_DIFFICULTY: selectedCell.LEVEL_DIFFICULTY,   
        			SOLVE_TIME: selectedCell.SOLVE_TIME         
           	 };
          	
          	if( selectedCells.length > 0){                  		
          		var selectedCell = this.dataItem( selectedCells );                  		
          		if( selectedCell.TEMPLET_NUM > 0 && selectedCell.TEMPLET_NUM != selectedTemplet.TEMPLET_NUM ){
          			selectedTemplet.TEMPLET_NUM = selectedCell.TEMPLET_NUM;
          			selectedTemplet.TEMPLET_NAME = selectedCell.TEMPLET_NAME;
          			selectedTemplet.LEVEL_DIFFICULTY = selectedCell.LEVEL_DIFFICULTY;
          			selectedTemplet.SOLVE_TIME = selectedCell.SOLVE_TIME;
          		}
          	}	
              select_templet_num = selectedCell.TEMPLET_NUM; 
              $("#question-grid").data("kendoGrid").destroy();
              fn_templetValue(select_templet_num);
              
              kendo.bind( $(".tabular"), selectRow );
              
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
       	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
      	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js', 
      	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.templet.js', 
      	  	'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js'
          ],
          complete: function() {  
			  
        	  var dataSource = new kendo.data.DataSource({
                  type: "json",
                  transport: {
                      read: { url:"/mgmt/ca/ca_commonCode_list.do?output=json", type:"POST" },
                      parameterMap: function (options, operation){	
                      	return {  STANDARDCODE : "C203"};
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
             serverSorting: false});
        	  
        	  $("#levelDifficulty").kendoComboBox({
        	        dataTextField: "TEXT",
        	        dataValueField: "VALUE",
        	        dataSource: dataSource,
        	        filter: "contains",
        	        suggest: true,
        	        index: 0
        	   });
        	  
        	  fn_getQuestionList(0);
        	  fn_main();
        	  $('#solveTime').live("keyup",function(event){
        		  var thisObj = $(this);

        		  thisObj .css('imeMode','disabled');

        		  var value = thisObj.val().match(/[^0-9]/g);

        		  if(value!=null) {
        			  thisObj.val(thisObj.val().replace(/[^0-9]/g,''));
        		  }

       		  });
              
        	  $("#grid").kendoGrid({
        			dataSource: {
        	            type: "json",
        	            transport: {
        	                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/mgmt/assessment/question-list.do?output=json", type:"POST" },
        	                parameterMap: function (options, operation){	
        	                	return {  startIndex: options.skip, pageSize: options.pageSize};
        	                } 		
        	            },
        	            schema: {
        	            	total: "totalItemCount",     	
        	            	data: "questions",
        	                model: {
        	                    fields: {
        	                  	QSTN_NUM : { type: "int" },
        	                  	QSTN_CLASS: { type: "QSTN_CLASS" },
        	                  	QUESTION: { type: "string" },
        	                  	QSTN_TYPE: { type: "string" }
        	                    }
        	                }
        	            },
        	            pageSize: 5,
        	            serverPaging: false,
        	            serverFiltering: false,
        	            serverSorting: false
        	        },
        	        height: 250,
        	        pageable: false,
        	        columns: [
        			     { field:"QSTN_NUM", title: "번호", filterable: true, width:13 },
        				 { field: "QSTN_TYPE", title: "문제유형", width:20 },
        	             { field:"QUESTION", title: "문항", filterable: true, width:120 },
        	             ],
        	        filterable: false,
        	        sortable: true,
        	        pageable: { refresh:true, pageSizes:false,  messages: { display: ' {1} / {2}' }  },
        	        selectable: 'row',
        	        height: 200,
        	        change: function() { 
        	           	var selectedCells = this.select();				
                      	var selectedCell = this.dataItem( selectedCells );
    					
                      	// 문항추가
                      	var chkTf = true;
                      	
                      	// 중복체크
                      	var obj = $('#question-grid').data('kendoGrid').dataSource.data();
                      	$.each(obj, function(idx, el) {
                      		$.each(el, function(key, value) {
                      			if(key=="QSTN_NUM" && value == selectedCell.QSTN_NUM) {
                      				chkTf = false;
                      				
                      				return false;
                      			}
                      		});
                      	});

                      	if(chkTf) {
                      		var obj = {
                      			QSTN_NUM :  selectedCell.QSTN_NUM,
                      			QUESTION :  selectedCell.QUESTION
                      		}	
                      		
                      		$("#question-grid").data("kendoGrid").dataSource.add(obj);
                      	}
        	           	
//         	           	item = {templetNum:select_templet_num,qstn_num:selectedCell.QSTN_NUM };
//         	           	fn_templet_question_mapping(item);
        	        }
        	        
        	    });
        	  
        	  $("#templet-value-save").click(function(){
        		  
                	var obj = $('#question-grid').data('kendoGrid').dataSource.data();
                	
                	var avgWeight = Math.floor(100/obj.length);

                	$.each(obj, function(idx, el) {
                		$("#question-grid").data("kendoGrid").dataSource.data()[idx].TEST_VALUE = avgWeight;
                	});
                	
                	if( obj.length*avgWeight != 100){
                		$("#question-grid").data("kendoGrid").dataSource.data()[obj.length-1].TEST_VALUE = avgWeight +1;	
                	}
                	
                	$('#question-grid').data('kendoGrid').saveChanges();
                	
      		   });
        	  
        	  $("#save-templet-window-btn").click( function(){
        		   
        			//가중치가 100인지 검사(가중치는 반드시 100이 되어야한다.)
             		var weight = 0;
             		
             		var obj = $('#question-grid').data('kendoGrid').dataSource.data();
             		
             		$.each(obj, function(idx, el) {
             			weight = weight + $("#question-grid").data("kendoGrid").dataSource.data()[idx].TEST_VALUE;
                	});
             		
             		$("#test-avg-value").val(weight);
             		
         			var isDel = confirm("템플릿을 저장하시겠습니까?");
  				 	 if(isDel){
  	             		if($("#templeteName").val()=="") {
  	             			alert("템플릿명를 입력해주십시오.");
  	             			return false;
  	             		}
  	             		
  	             		if(kendo.stringify($('#question-grid').data('kendoGrid').dataSource.data()) == "[]"){
  	             			alert("문항을 추가해주십시오.");
  	             			return false;
  	             		}

  	             		if(weight != 100){
  	             			alert("가중치의 합은 100이여야 합니다.");
  	             			return false;
  	             		}
  	             		
  	             		var params = {
 	             			TEMPLETNUM : $("#templetNum").val(),
 	             			TEMPLETENAME : $("#templeteName").val(),
 	             			LEVELDIFFICULTY : $("#levelDifficulty").val(),
 	             			SOLVETIME : $("#solveTime").val(),
	             			QUESTION_LIST :  $('#question-grid').data('kendoGrid').dataSource.data() 
	  	           		};	
	             		
	             		$.ajax({
	             			type : 'POST',
	     					url:"/mgmt/assessment/test_templete_save.do?output=json",
	     					data : { item:   kendo.stringify(params)},
	     					complete : function( response ){
	     						var obj  = eval("(" + response.responseText + ")");
	     						if(obj.totalItemCount != 0){
	     							fn_main();
	     							alert("저장되었습니다.");	
	     						}else{
	     							alert("저장에 실패 하였습니다.");
	     						}										
	     					},
	     					error: function( xhr, ajaxOptions, thrownError){								
	     					},
	     					dataType : "json"
	     				});		
  				 	}
            	});
        	  
        	// list new btn add click event
       	   $("#newBtn").click( function(){
       		   $("#test-avg-value").val("");	
       		   $("#question-grid").empty();
    		    fn_getQuestionList(0);
			    kendo.bind( $(".tabular"),  null );
					
       	  	});
        	  
          }
		
        	
      }]);   
        </script>
  
    </head>
    <body class="cf"> 
    
	<!-- START MAIN CONTENT -->
  <div id="container" class="cf">  
    <article class="span6">
    	<section class="content">    		
			<div id="templet-grid"></div></br>
			<table width="100%" cellspacing="0" cellpadding="0">
				<tr><td align="right">
		    		<button id="newBtn" class="k-button" ><span class="k-icon k-i-plus"></span>추가</button>
		    	</td></tr>
			</table>
    	</section>
    </article>
     <article class="span6">
    	<section class="content">
    		<div id="create-templet-window" >	
    		<script language="javascript">
    		function disabledExceptNum(obj){
    			if ((event.keyCode> 47) && (event.keyCode < 58)){
    		        event.returnValue=true;
    		    } else { 
    		        event.returnValue=false;
    		    }
    		}
    		</script>	
    			<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
    				
					<tr>
				    	<td width="80px" >▶ 템플릿명</td>
						<td>:&nbsp&nbsp
							<input style="width: 90%" class="k-textbox" id="templeteName" data-bind="value:TEMPLET_NAME"  />
							<input style="width: 90%" type="hidden" class="k-textbox" id="templetNum" data-bind="value:TEMPLET_NUM"  />
							</td>
			    	</tr>
			    	<tr>
				    	<td width="80px" >▶ 난&nbsp&nbsp이&nbsp&nbsp도</td>
						<td>:&nbsp&nbsp<select id="levelDifficulty" data-bind="value:LEVEL_DIFFICULTY" style="width:100px; text-align:center"/></td>
			    	</tr>
			    	<tr>
				    	<td width="80px" >▶ 풀이시간</td>
						<td>:&nbsp&nbsp<input type="text" style="ime-mode:disabled;" class="k-textbox" id="solveTime" data-bind="value:SOLVE_TIME"  onkeypress="javascript:disabledExceptNum(this)"/>&nbsp&nbsp초</td>
			    	</tr>
				</table> 				   	
			</div>
    		<table>
    			<tr>
    				<td align="center" class="alert-box alert">템플릿별 가중치 :<input class="k-textbox" type=text id=test-avg-value readonly="readonly" >
    					
    				</td>
    			
    				<td align="right">
    					<a class="k-button" id="templet-value-save"><span class="k-icon k-i-plus"></span>가중치균등적용</a>
    				</td>
    			</tr>
    		</table>
    		<div class="k-content">
    		<div id="question-grid"></div>
    		</div>
    		<div id="grid"></div>
    	</section>
    </article> 
	<div style="text-align: right;">
		<br/>
		<a class="k-button" id="save-templet-window-btn"><span class="k-icon k-i-plus"></span>저장</a>
	</div>	
  <!-- END MAIN CONTENT -->
  <!-- START FOOTER -->
  <footer>  
  </footer>			
 
    </body>
</html>
