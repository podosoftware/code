<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title></title>
	<script type="text/javascript">

	var dataSource = null;
	
	   function buttonEvent(){
           		
	   }
	
       function openwindow() {
    	    $("#grid").empty();
	       	$("#grid").kendoGrid({
	               dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_admin_list.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){	
	                       	return { JOBFLAG : "ALL" };
	                       } 		
	                   },
	                   schema: {
	                   	data: "items",
	                       model: {
	                           fields: {
	                        	   COMPANYID : { type: "int" }, 
	                        	   JOBLDR_NUM : { type: "int" },
	                        	   JOBLDR_NAME : { type: "string" },
	                        	   JOBLDR_COMMENT : { type: "string" },
	                        	   MAIN_TASK : { type: "string" },
	                        	   JOBLDR_FLAG : { type: "string" },
	                        	   USEFLAG : { type: "string" },
	                        	   RUN_DATE : { type: "string" },
	                        	   CNT: { type: "string" },
	                        	   RUN_STATE : { type: "string" }
	                           }
	                       }
	                   }
	               },
	               columns: [
	                   {
	                       field:"JOBLDR_FLAG_NAME",
	                       title: "구분",
	                       filterable: true,
						    width:30,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },
	                   {
	                       field: "JOBLDR_NAME",
	                       title: "직무/계층명",
						   width:50,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:left"} 
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
	               selectable: 'row',
	               height: 500,
	               change: function(e) {                    
	            	 var selectedCells = this.select();				
	                 var selectedCell = this.dataItem( selectedCells ); 
	                 var selectRow =  {
	                		JOBLDR_NUM: selectedCell.JOBLDR_NUM,
	                		JOBLDR_NAME: selectedCell.JOBLDR_NAME,                 
	                		JOBLDR_COMMENT :selectedCell.JOBLDR_COMMENT, 
	                		MAIN_TASK :selectedCell.MAIN_TASK,
	                		USEFLAG: selectedCell.USEFLAG,   
	                 		RUN_START: selectedCell.RUN_START,             
	                 		RUN_END: selectedCell.RUN_END,           
	                 		RUN_DATE : selectedCell.RUN_DATE,          
	                 		CNT: selectedCell.CNT,   
	                 		RUN_STATE: selectedCell.RUN_STATE          			
	               			
	               	 };
	                 
	                 
	                 
	                 $("#splitter").data("kendoSplitter").expand("#detail_pane");
	                 
	                 // show detail 
	                 //$('#saveData').show().html(kendo.template($('#template').html()));             

	                 
		         	 // save btn add click event
		          	 buttonEvent();		          	
		          	
	              	 // detail binding data
	                 //kendo.bind( $(".tabular"), selectRow );
	              	 $("#jobLdrNum").val(selectRow.JOBLDR_NUM);
						
	              	setDataSource();
	                 openwindow2(dataSource);
	                 $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//사용여부
	                 $("#grid2").data("kendoGrid").refresh();
	              	 
	               }
	               
	           });	      

	       }       
       
       
       function setDataSource(){
			
			$("#allCheck").attr("checked", false);
			
			
			dataSource = new kendo.data.DataSource({
		           type: "json",
		           transport: {
		               read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_cmpt_mapp_list.do?output=json", type:"POST" },
		               parameterMap: function (options, operation){	
		               	return {  jobLdrNum: $("#jobLdrNum").val() };
		               } 		
		           },
		           schema: {
		           	data: "items",
		               model: {
		                   fields: {
		                	   CHECKFLAG : { type: "string" },
		                	   CMPNUMBER : { type: "int" },
		                	   COMPANYID : { type: "int" },
		                	   CMPGROUP : { type: "string" },
		                	   CMPGROUP_S : { type: "string" },
		                	   CMPNAME : { type: "string" },
		                	   CMPDEFINITION : { type: "string" },
		                	   KNOWLEDGE: { type: "string" },
		                	   SKILL : { type: "string" },
		                	   ATTITUDE : { type: "string" },
		                	   BSNS_REQR_LEVEL : { type: "string" },
		                	   USEFLAG : { type: "string" },
		                	   CMPGROUP_STRING : { type: "string" },
		                       CMPGROUP_S_STRING : { type: "string" },
		                	   USEFLAG_STRING : { type: "string" },
		                	   CREATETIME_STRING : { type: "string" },
		                	   MODIFYTIME_STRING : { type: "string" }
		                   }
		               }
		           },
		           serverPaging: false,
		           serverFiltering: false,
		           serverSorting: false
				 });
	       	
	       	 openwindow2(dataSource);		
		}
       
       function openwindow2(dataSource) {
    	   $("#grid2").empty();		
			
	       	$("#grid2").kendoGrid({
	               dataSource: dataSource,
	               columns: [
	                   {
	                       field:"CMPGROUP_STRING",
	                       title: "역량군",
	                       filterable: true,
						    width:100,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },	  
	                   {
	                       field:"CMPNAME",
	                       title: "역량",
	                       filterable: true,
						    width:100,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"}
	                   },		                   
	                   {
		                      field:"CHECKFLAG",
		                      title: "선택",
		                      filterable: true,
						      width:50,
						   	  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						   	  attributes:{"class":"table-cell", style:"text-align:center"} ,
							  template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag(this, #: ROWNUMBER #)\" #: CHECKFLAG #/></div>" 
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
	               //height: 500,
	               change: function(e) {                    
	            	 var selectedCells = this.select();				
	                 var selectedCell = this.dataItem( selectedCells ); 
	                 var selectRow =  {
	                 		COMPANYID: selectedCell.COMPANYID,                 
	                 		CMPNUMBER :selectedCell.CMPNUMBER,         
	               			STN_CODENAME: selectedCell.STN_CODENAME,   
	               			CMPGROUP: selectedCell.CMPGROUP,
	               			CMPGROUP_S: selectedCell.CMPGROUP_S,
	               			CMPNAME: selectedCell.CMPNAME,           
	               			CMPDEFINITION : selectedCell.CMPDEFINITION,          
	               			KNOWLEDGE: selectedCell.KNOWLEDGE,   
	               			SKILL: selectedCell.SKILL,       
	               			ATTITUDE: selectedCell.ATTITUDE,     
	               			BSNS_REQR_LEVEL: selectedCell.BSNS_REQR_LEVEL,     
	               			USEFLAG: selectedCell.USEFLAG,
	               			CMPGROUP_STRING: selectedCell.CMPGROUP_STRING,
	               			CMPGROUP_S_STRING: selectedCell.CMPGROUP_S_STRING,
	               			USEFLAG_STRING: selectedCell.USEFLAG_STRING,
	               			CREATETIME: selectedCell.CREATETIME_STRING,
	               			MODIFYTIME: selectedCell.MODIFYTIME_STRING	               			
	               	 };                         				              
	                 
	                 $("#splitter").data("kendoSplitter").expand("#detail_pane");	                 
	                               
		         	 // save btn add click event
		          	 buttonEvent();
		          	
	              	 // detail binding data
	                 kendo.bind( $(".tabular2"), selectRow );
	                 $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//사용여부
	              	 
	               }
	               
	           });
	       }     
       
       
       function modifyYnFlag(checkbox, rows){
 			var array = dataSource.data();
 			
 			if(checkbox.checked == true){
 				array[rows].CHECKFLAG = "checked=\"1\"";
 			}else{
 				array[rows].CHECKFLAG = 'N';
 			}

 	   }
        
        function modifyAllCheck(checkbox){
 			var array =  dataSource.view();
 			
 			if(checkbox.checked == true){
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = "checked=\"1\"";
 				}
 			}else{
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = 'N';
 				}
 			} 			
 			$("#grid2").data("kendoGrid").refresh();			
 	   }   
       
      
	</script>
	<script type="text/javascript">               
        yepnope([{
       	  load: [ 
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.default.min.css',
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
       	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
       	 	'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
      	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js', 
       	 '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js'
          ],
          complete: function() {  


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
                  
                 //그리드2 사이즈 재조정..
                  var gridElement2 = $("#grid2");
                  gridElement2.height(splitterElement.outerHeight()-2);
                  
                  dataArea2 = gridElement2.find(".k-grid-content"),
                  gridHeight2 = gridElement2.innerHeight(),
                  otherElements2 = gridElement2.children().not(".k-grid-content"),
                  otherElementsHeight2 = 0;
                  otherElements2.each(function(){
                      otherElementsHeight2 += $(this).outerHeight();
                  });
                  dataArea2.height(gridHeight2 - otherElementsHeight2);
              });
              /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
              
              
        	// area splitter
  			var splitter = $("#splitter").kendoSplitter({
  				orientation : "horizontal",
  				panes : [ {
  					collapsible : true,
  					min : "30%",
  					size: "50%"
  				}, {
  					collapsible : true,
  					collapsed : true,
  					min : "30%",
  					size: "50%"
  					
  				} ]
  			});
        	  
  			
  			 
        	
        	  // list call
        	  openwindow();	
        	  setDataSource();	       	  
        	 
        	  
				// show detail 
       			$("#splitter").data("kendoSplitter").expand("#detail_pane");
				//$('#saveData').show().html(kendo.template($('#template').html()));  	         	  
        	  
				//브라우저 resize 이벤트 dispatch..
	              $(window).resize();
				
				
	              $("#excelUBtn").click( function(){
	  		        $('#excel-upload-window').data("kendoWindow").center();      
	  		        $("#excel-upload-window").data("kendoWindow").open();
	  		        $("#runNum").val($("#runNumber").val());
	  		    });
	  		   
	  		   if( !$("#excel-upload-window").data("kendoWindow") ){		

	  		    	$("#excel-upload-window").kendoWindow({
	  		    		width:"340px",
	  		    		minWidth:"340px",
	  		    		resizable : false,
	  		    		title : "엑셀 업로드",
	                     modal: true,
	                     visible: false
	  		    	});
	  			 }   	   
	  		   
	  		   if( ! $("files").data("kendoUpload") ){	
	  				$("#files").kendoUpload({
	  	     			multiple : false,
	  	     			showFileList : true,
	  	     			localization : { select: '파일 선택'
	  	     			 },
	  	     			 async: {					   
	  					    autoUpload: false
	  				    },
	  				    
	  	     		});						
	  			}
	  		   
	  		   $("#uploadBtn").click( function() {
	  			  	  
	  		        $("#excel-upload-window").data("kendoWindow").close();
	  		         
	  		      });
				
				
	      		//save btn add click event
	           	  $("#saveBtn").click( function(){
	           		
	           			var isDel = confirm("매핑정보를 저장하시겠습니까?");
	    				 	 if(isDel){         
	    				 		 
	    	             		var params = {	             				
	    	             			LIST :  $('#grid2').data('kendoGrid').dataSource.data()	             			             			
	    	  	           		};
	    	             		
	    	             		$.ajax({
	    	             			type : 'POST',
	    	     					data : { item: kendo.stringify( params ), jobLdrNum : $("#jobLdrNum").val()},
	    	     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_cmpt_mapp_save.do?output=json",
	    	     					complete : function( response ){
	    	     						var obj  = eval("(" + response.responseText + ")");
	    	     						if(obj.saveCount != 0){
	    	     							$("#grid2").data("kendoGrid").dataSource.read();
	    	     							alert("저장되었습니다.");	
	    	     						}else{
	    	     							alert("저장에 실패 하였습니다.");
	    	     						}							
	    	     					},
	    	     					error: function( xhr, ajaxOptions, thrownError){
	    	     						alert('xrs.status = ' + xhr.status + '\n' + 
	    	     		                        'thrown error = ' + thrownError + '\n' +
	    	     		                        'xhr.statusText = '  + xhr.statusText + '\n세션이 종료되었습니다.' );
	    	     		            	sessionout();
	    	     					},
	    	     					dataType : "json"
	    	     				});		
	    				 	}
	              	});	
	              
          }
      }]);         	

	</script>
</head>
<body>

<div id="excel-upload-window" style="display:none; width:340;">
		<form method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_cmpt_mapp_upload.do?" >
		※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
	       <div>
	       	   <input type="hidden" id="runNum" name="runNum" value="">
	           <input name="files" id="files" type="file" />
	           </br>
	           <div style="text-align: right;">
	           		<input type="submit" value="엑셀 업로드" class="k-button" id="uploadBtn"/>
	           </div>
	       </div>
	   </form>
   </div>


<form id="frm" name="frm" >
    <input type="hidden" id="jobLdrNum" name="jobLdrNum" />
</form>

    <div id="content">
        <div class="cont_body">
            <div class="title mt30">역량매핑</div>
            <div class="table_zone" >
                <div class="table_btn">
                	<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp;
                	<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_cmpt_mapp_excel.do" >엑셀 다운로드</a>&nbsp;
                	<button id="excelUBtn" class="k-button" >엑셀 업로드</button>&nbsp;
                    <input id="allCheck"  type="checkbox" onchange="modifyAllCheck(this)"> 전체선택/전체해지&nbsp;
                    <button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>
                </div>
                <div class="table_list">
                    <div id="splitter" style="width:100%; height: 100%; border:none;">
                        <div id="list_pane">
                            <div id="grid"></div>
                        </div>
                        <div id="detail_pane">
                            
	                        <div id="grid2"></div>                                      
	                        <div id="saveData"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
            
			<!-- START MAIN CONTNET 
			<div id="splitter" style="height:100%;">
					<div id="list_pane">
						
					</div>
					<div id="list_pane2">
					   				
					</div>
			</div>-->
	<!-- END MAIN CONTENT  
	 	<script type="text/x-kendo-template"  id="template"> 
		
				<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
					<tr>
										
					</tr>
			    	<tr>
			    		<td colspan="2" align="right">
							<div style="text-align: right;">
			    			   &nbsp;
							</div>
			    		</td>			    	
			    	</tr>
				</table>
	 		</script>-->    
    
</body>
</html>