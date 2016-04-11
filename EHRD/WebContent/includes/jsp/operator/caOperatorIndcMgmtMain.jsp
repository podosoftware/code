<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>행동지표관리</title>

	</style>
	<script type="text/javascript">
	
		var checkFirstClick = 'Y'; 
		
		// 상세보기.
	    function fn_detailView(row, bhv_num){
	    	//역량군(대) 콤보박스 datasource
      	  var dataSource = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){	
                    	return {  STANDARDCODE : "C102", ADDVALUE: "=== 선택 ==="};
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
 
      	  
      	  
      	//역량 콤보박스 datasource
      	  var compDataSource = new kendo.data.DataSource({
                 type: "json",
                 transport: {
                     read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_competency_combo_list.do?output=json", type:"POST" },
                     parameterMap: function (options, operation){	
                     	return { };
                     } 		
            },
            schema: {
            	data: "items",
                model: {
                    fields: {
                 	   VALUE : { type: "String" },
                 	   TEXT : { type: "String" },
                 	   CMPGROUP : { type : "String" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false});
			
	    	var grid = $("#grid").data("kendoGrid");
	        var data = grid.dataSource.data();			
	        
	        
	        var selectedCell;
	        for(var i = 0; i<data.length; i++) {
	            var dataItem = data[i];
	            if(row == dataItem.ROWNUMBER){
	            	selectedCell = dataItem;	 
	                 var selectRow =  {
	                 		COMPANYID: selectedCell.COMPANYID,                 
	                 		CMPGROUP :selectedCell.CMPGROUP,             
	                 		CMPNUMBER: selectedCell.CMPNUMBER,   
	                 		BHV_INDC_NUM: selectedCell.BHV_INDC_NUM,             
	                 		BHV_INDICATOR: selectedCell.BHV_INDICATOR,           
	                 		CMPGROUP_STRING : selectedCell.CMPGROUP_STRING,              
	                 		CMPNAME: selectedCell.CMPNAME,   
	                 		USEFLAG: selectedCell.USEFLAG,       
	                 		USEFLAG_STRING: selectedCell.USEFLAG_STRING,
	                 		CREATETIME: selectedCell.CREATETIME_STRING,
	                 		MODIFYTIME: selectedCell.MODIFYTIME_STRING,
//	                 		SUBELEMENT_NUM: selectedCell.SUBELEMENT_NUM,
	                 		CNST_BHV_INDC_NUM: selectedCell.CNST_BHV_INDC_NUM,
	                 		SOCIAL_ADVISABLE_FLAG: selectedCell.SOCIAL_ADVISABLE_FLAG,
	               	 };
	                 
	                 checkFirstClick = 'N';
	                 

	                   $("#splitter").data("kendoSplitter").expand("#detail_pane");
	                 
	              		// show detail 
	                 	$('#details').show().html(kendo.template($('#template').html()));
	                 
	                    
		                // create ComboBox from input HTML element
		         	    var cmpGroupList = $("#cmpGroup").kendoDropDownList({
		         	        dataTextField: "TEXT",
		         	        dataValueField: "VALUE",
		         	        dataSource: dataSource,
		         	        suggest: true,
		         	        enable : false,
		         	        placeholder : "" ,
		         	        change: function() {
		         	        	changeCmpGroup();
	  	               	 	}
		         	    });
		                
		                var changeCmpGroup = function (){
		                	compDataSource.filter({field : "CMPGROUP", operator: "eq", value: removeNullStr($("#cmpGroup").val()) });
                            $("#cmpNumber").data("kendoDropDownList").value("");
		                };
		         	   
		         	   // create ComboBox from input HTML element
		         	    var cmpNumberList = $("#cmpNumber").kendoDropDownList({
		         	        dataTextField: "TEXT",
		         	        dataValueField: "VALUE",
		         	        dataSource: compDataSource,
		         	        suggest: true,
		         	        enable : false,
		         	        change: function() {
	  	               	 	}
		         	    });
		         	   
			         	 // dtl save btn add click event
			          	 buttonEvent(dataSource, compDataSource);
	                 	 $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//사용여부
          	   			
	                      
	                        // add by lsm :: 행동지표에 계급을 추가로 mapping 하기 위한 처리
	                        initDtlArea(bhv_num);
	                         
	                 	// detail binding data
		                kendo.bind( $(".tabular"), selectRow );
	                 	
		                compDataSource.filter({field : "CMPGROUP", operator: "eq", value: selectedCell.CMPGROUP });
	                 	
		                $("#delBtn").show();

	                    break;                  
	                    
	                 		
		                 
	            } // end if
	        } // end for
			
         	
	        // template에서 호출된 함수에 대한 이벤트 종료 처리.
	        if(event.preventDefault){
	            event.preventDefault();
	        } else {
	            event.returnValue = false;
	        } 
		}
		
		function addCheck(){	      	     	    	    		
    		$.ajax({
    			type : 'POST',
				url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_kpi_add_check.do?output=json",
				data : {},
				complete : function( response ){
					var obj  = eval("(" + response.responseText + ")");
					if(obj.statement == 'Y'){			
						$("#newBtn").show();					
					}else if(obj.statement == 'N'){
						$("#newBtn").hide();
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
		
	   function buttonEvent(dataSource, compDataSource){
		   
	    	// dtl del btn add click event
	       	$("#delBtn").click( function(){
	       	    
	        	var isDel = confirm("삭제 하시겠습니까?");
	            if(isDel){
	        		var params = {
	        			CMPNUMBER : $("#cmpNumber").val(),
	        			BHVINDCNUM : $("#bhvIndcNum").val(),
	        			FLAG : "12",
	         		};
	        		
	        		$.ajax({
	        			type : 'POST',
						url:"/operator/ca/ca_common_del.do?output=json",
						data : { item: kendo.stringify( params ) },
						complete : function( response ){
							var obj  = eval("(" + response.responseText + ")");
							if(obj.saveCount != 0){
								$("#grid").data('kendoGrid').dataSource.read();	
     							kendo.bind( $(".tabular"),  null );
     			         		 
     			         		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
     			                $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
								alert("삭제되었습니다.");	
							}else{
								alert("삭제를 실패 하였습니다.");
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
	       	});
		   
		   
		// dtl save btn add click event
       	  $("#saveBtn").click( function(){
       		  
       		if(removeNullStr($("#cmpGroup").val())=="") {
      			alert("역량군을 선택해주십시오.");
      			return false;
  			}
       		  
       		if(removeNullStr($("#cmpNumber").val())=="") {
     			alert("역량을 선택해주십시오.");
     			return false;
     		}
       	  
            if($("#bhvIndicator").val()=="") {
                alert("행동지표를 입력해주십시오.");
                return false;
            }
            
       		  
       			var isDel = confirm("행동지표를 저장하시겠습니까?");
				 	 if(isDel){

	             		
// 	             		if(kendo.stringify($('#exampleGrid').data('kendoGrid').dataSource.data()) == "[]"){
// 	             			alert("보기문항을 추가해주십시오.");
// 	             			return false;
// 	             		}

                        var multiSelect = $("#bhid_ldr").data("kendoMultiSelect");
                        var bhid_list = new Array();
                        $.each(multiSelect.value(), function(index, row){
                            var bhid_item = multiSelect.dataSource.get(row);
                            bhid_list.push(bhid_item);
                        });

	             		var params = {
	             			CMPNUMBER : removeNullStr($("#cmpNumber").val()),
	             			BHVINDCNUM : $("#bhvIndcNum").val(), 
	             			BHVINDICATOR : $("#bhvIndicator").val(),
	             			//SUBELEMENT_NUM : $("#subelementNum").val(),
	             			USEFLAG : $(':radio[id="useFlag"]:checked').val(),
// 	             			EXAMPLE_LIST :  $('#exampleGrid').data('kendoGrid').dataSource.data() 
	  	           		};	
	             		
	             		$.ajax({
	             			type : 'POST',
	             			dataType : "json",
	     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_indc_save.do?output=json",
	     					data : { item:   kendo.stringify(params), bhidItem: kendo.stringify(bhid_list)},
	     					complete : function( response ){
	     						var obj  = eval("(" + response.responseText + ")");
	     						if(obj.saveCount != 0){
	     							$("#grid").data('kendoGrid').dataSource.read();	
	     							kendo.bind( $(".tabular"),  null );
	     			         		 
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
	     				});		
				 	}
          	});
		
       	
			
       		// dtl cancel btn add click event
        	$("#cencelBtn").click( function(){
         		kendo.bind( $(".tabular"),  null );
         		 
         		$("#cudMode").val()=="";
         		 
         		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
                $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
         	});
			
	   }
	
       function openwindow(dataSource, compDataSource) {
    	    $("#grid").empty();
    	    
	       	$("#grid").kendoGrid({
	               dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_indc_list.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){	
	                       	return {  };
	                       } 		
	                   },
	                   schema: {
	                   	total: "totalItemCount",
	                   	data: "items",
	                       model: {
	                           fields: {
	                        	   COMPANYID : { type: "int" },
	                        	   CMPGROUP : { type: "string" },
	                        	   CMPNUMBER : { type: "int" },
	                        	   BHV_INDC_NUM : { type: "int" },
	                        	   BHV_INDICATOR : { type: "string" },
	                        	   CMPGROUP_STRING: { type: "string" },
	                        	   CMPNAME : { type: "string" },
	                        	   USEFLAG : { type: "string" },
	                        	   USEFLAG_STRING : { type: "string" },
	                        	   CREATETIME_STRING : { type: "string" },
	                        	   MODIFYTIME_STRING : { type: "string" }
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
	                       field:"CMPGROUP_STRING",
	                       title: "역량군",
	                       filterable: true,
						    width:100,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						    align:"center"
	                   },	                   
	                   {
	                       field: "CMPNAME",
	                       title: "역량",
	                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						   width:100
	                   },
	                   {
	                       field: "BHV_INDICATOR",
	                       title: "행동지표",
	                       width : 200,
	                       height:50,
	                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:left; text-decoration: underline;"},
	                       template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${ROWNUMBER},${BHV_INDC_NUM});' >${BHV_INDICATOR}</a>"
	                   },
	                   {
	                       field: "USEFLAG_STRING",
	                       title: "사용여부",
	                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       width : 100
	                   }
	               ],
	               filterable: true,
	               selectable: 'row',
	               filterable: {
	           	      extra : false,
	           	      messages : {filter : "필터", clear : "초기화"},
	           	      operators : { 
	           	       string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
	           	       number : { eq : "같음", gte : "이상", lte : "이하"}
	           	      }
	           	     },
	               batch: false,
	     	       sortable: true,        
	     	       pageable : {
                      refresh : false,
                      pageSizes :[10,20,30]
                   },
	               change: function(e) {				
	                 	
	               }
	               
	           });
	     	//상세화면 세팅
            $('#details').show().html(kendo.template($('#template').html()));
	       }
       
       function initDtlArea(bhvNum){
           //alert("here~!"+bhvNum);
           
            // 상세영역 그룹멀티셀렉터 초기화
            $("#bhid_ldr").kendoMultiSelect({
                placeholder: "계급을 선택하세요.",
                dataTextField: "LABEL", dataValueField: "DATA",
                  filter: "contains",
                  autoBind: false,
                  dataSource: {
                      type: "json",
                      serverFiltering: true,
                      transport: { read: { url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/get-ldr-list.do?output=json", type:"POST" } },
                      schema: {
                        total: "totalItemCount",
                        data: "items",
                          model: {
                            id : "DATA",
                              fields: { LABEL : { type: "string" }, DATA : { type: "number" } }
                          }
                      }
                  }
            });    
            
            
            var multiSelect = $("#bhid_ldr").data("kendoMultiSelect");
            
            $.ajax({
                type: "POST",
                url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/get-bhid-ldr-list.do?output=json",
                data: { BHID_NUM : bhvNum },        
                complete:function(response){
                    if(response.responseText!=null){
                        var selectedRoleIDs = "";
                        var obj = new Object();
                        
                        obj = JSON.parse(response.responseText);
                        
                        $.each(obj.items,function(idx,item){
                            if(selectedRoleIDs == ""){
                                selectedRoleIDs = selectedRoleIDs + item.DATA;
                            }else{
                                selectedRoleIDs = selectedRoleIDs + "," + item.DATA;
                            }
                        });
                        
                        multiSelect.value( selectedRoleIDs.split(","));
                    }else{
                        multiSelect.value("");
                        
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
                dataType:"json"
            });
       }
       
	</script>
	<script type="text/javascript">               
        yepnope([{
        	load : [ 'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
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
              //브라우저 resize 이벤트 dispatch..
              $(window).resize();
              /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */  
        	  
        	  addCheck();
        	  
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
        	  
        	  //역량군(대) 콤보박스 datasource
        	  var dataSource = new kendo.data.DataSource({
								                  type: "json",
								                  transport: {
								                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
								                      parameterMap: function (options, operation){	
								                      	return {  STANDARDCODE : "C102", ADDVALUE: "=== 선택 ===" };
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
        	 
        	  
        	  
        	//역량 콤보박스 datasource
        	  var compDataSource = new kendo.data.DataSource({
										                  type: "json",
										                  transport: {
										                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_competency_combo_list.do?output=json", type:"POST" },
										                      parameterMap: function (options, operation){	
										                      	return { };
										                      } 		
										             },
										             schema: {
										             	data: "items",
										                 model: {
										                     fields: {
										                  	   VALUE : { type: "String" },
										                  	   TEXT : { type: "String" },
										                  	   CMPGROUP : { type : "String" }
										                     }
										                 }
										             },
										             serverFiltering: false,
										             serverSorting: false});
        	  
        	//하위요소 콤보박스 datasource
//         	var subelementDataSource = new kendo.data.DataSource({
// 									                  type: "json",
// 									                  transport: {
// 									                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmtp_subelement_list.do?output=json", type:"POST" },
// 									                      parameterMap: function (options, operation){	
// 									                      	return {CMPNUMBER:"" };
// 									                      } 		
// 									             },
// 									             schema: {
// 									             	data: "items",
// 									                 model: {
// 									                     fields: {
// 									                  	   VALUE : { type: "String" },
// 									                  	   TEXT : { type: "String" },
// 									                  	   CMPNUMBER  : { type: "String" }
// 									                     }
// 									                 }
// 									             },
// 									             serverFiltering: false,
// 									             serverSorting: false});
        	  
        	 
        	  
        	  // list call
        	  openwindow(dataSource, compDataSource);
        	  
        	  
        	  $("#excelBtn").click( function(){
        		  $.ajax({
          			type : 'POST',
      				url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_indc_list_excel.do?output=",
      				dataType : "json",
      				success : function (examples){
      				}
              	 });
        	  });        	  
             
        	  
        	   // list new btn add click event
        	   $("#newBtn").click( function(){
	        		 
        		   $("#splitter").data("kendoSplitter").expand("#detail_pane");
        		   
	        		// show detail 
					$('#details').show().html(kendo.template($('#template').html()));
	        		
					 kendo.bind( $(".tabular"),  null );
					 
					 buttonEvent(dataSource, compDataSource);
					
					
					$("#cmpGroup").kendoDropDownList({
	          	        dataTextField: "TEXT",
	          	        dataValueField: "VALUE",
	          	        dataSource: dataSource,
	          	        suggest: true,
	          	     	placeholder : "" ,
	          	     	filter: "contains",
	         	        change: function() {
	         	        	compDataSource.filter({field : "CMPGROUP", operator: "eq", value: removeNullStr($("#cmpGroup").val()) });
	         	        	$("#cmpNumber").data("kendoDropDownList").value("");
  	               	 	}
	          	    });
					compDataSource.filter({field : "CMPGROUP", operator: "eq", value: "" });
					
					$("#cmpNumber").kendoDropDownList({
	          	        dataTextField: "TEXT",
	          	        dataValueField: "VALUE",
	          	        dataSource: compDataSource,
	          	        suggest: true,
	          	        change: function() {
	               	 	}
	          	    });
					
		            $("#bhid_ldr").kendoMultiSelect({
		                placeholder: "계급을 선택하세요.",
		                dataTextField: "LABEL", dataValueField: "DATA",
		                  filter: "contains",
		                  autoBind: false,
		                  dataSource: {
		                      type: "json",
		                      serverFiltering: true,
		                      transport: { read: { url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/get-ldr-list.do?output=json", type:"POST" } },
		                      schema: {
		                        total: "totalItemCount",
		                        data: "items",
		                          model: {
		                            id : "DATA",
		                              fields: { LABEL : { type: "string" }, DATA : { type: "number" } }
		                          }
		                      }
		                  }
		            }); 

	         	   // create ComboBox from input HTML element
	         	    /*$("#subelementNum").kendoComboBox({
	         	        dataTextField: "TEXT",
	         	        dataValueField: "VALUE",
	         	        dataSource: subelementDataSource,
	         	        suggest: true,
	         	        index: 0
	         	    });*/
	         	   
	         	   /*if(checkFirstClick == 'N'){
		         	   subelementDataSource.filter({field : "CMPNUMBER", operator: "", value: $("#cmpNumber option:selected").val() });
	   	        		$("#subelementNum").data("kendoComboBox").select(0);
	         	   }*/

					
// 					 $("#exampleGrid").kendoGrid({
// 							dataSource: {
// 								transport: { 
// 									read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_indc_exam_list.do?output=json', type:'post' },
// 							 		parameterMap: function (options, operation){			
// 								 		return { CMPNUMBER: 0, BHV_INDC_NUM: 0};
// 									}
// 								},						
// 								batch: true, 
// 								schema: {
// 									data: "subItems",
// 									model: {
// 										fields: {
// 											EXM_ORDER : { editable:true, type: "number",  validation: { required: false, min: 1, max:100} },
// 											EXAMPLE : { editable:true, type: "string" },
// 											EXM_SCORE: { editable:true, type: "number", validation: { required: false, min: 1, max:100} }
// 			                             }
// 				                     }
// 								},
// 								error:handleKendoAjaxError
// 							},
// 							columns: [
// 								{ title: "순번", field: "EXM_ORDER" },
// 								{ title: "보기",   field: "EXAMPLE" },
// 								{ title: "배점",   field: "EXM_SCORE" },
// 								{ command:  { name: "destroy", text:"삭제" },  title: "&nbsp;", width: 80 }
// 							],
// 							editable: {
// 							     confirmation: "삭제하시겠습니까?"
// 							},
// 							navigatable: true,
// 							height: 250,
// 							toolbar: [
// 								{ name: "create", text: "추가" },
// 								{ name: "cancel", text: "초기화" }
// 							],				     
// 							change: function(e) {
// 							}
//                     });
					 
					 checkFirstClick = 'N';
					
					 $('input:radio[id=useFlag]:input[value=Y]').attr("checked", true);//사용여부
					 
					 
					 $("#delBtn").hide();
        	  });
          }
      }]);   
	</script>
</head>
<body>
	<!-- START MAIN CONTNET -->
	
	<div id="content">
        <div class="cont_body">
            <div class="title mt30">행동지표관리</div>
            <div class="table_zone" >
                <div class="table_btn">
					<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_indc_list_excel.do" >엑셀 다운로드</a>&nbsp;
		    		<button id="newBtn" class="k-button" ><span class="k-icon k-i-plus"></span>추가</button>
                </div>
                <div class="table_list">
		            <div id="splitter" style="width:100%; height: 100%; border:none;">
		                <div id="list_pane">
						    <div id="grid" ></div>
						</div>
						<div id="detail_pane">
							<div id="details"></div>
		                </div>
		            </div>
		        </div>
	        </div>
        </div>
    </div>

	<!-- END MAIN CONTENT  --> 	
	<footer>
  	</footer>
	
	 	<script type="text/x-kendo-template" id="template"> 
				<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
					<tr><td colspan="2" style="font-size:16px;"> <strong>&nbsp; 행동지표관리 </strong>
						<input type="hidden" id="comapnyId" data-bind="value:COMPANYID" style="border:none" readonly="readonly" />
						<input type="hidden" id="bhvIndcNum" data-bind="value:BHV_INDC_NUM" style="border:none" readonly="readonly" />
					</td></tr>
					<tr>
				    	<td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 역량군 <span style="color:red">*</span></td>
						<td class="subject"><input type = "text" id="cmpGroup" data-bind="value:CMPGROUP" style="width:97%"></select></td>
			    	</tr>
					<tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 역&nbsp&nbsp&nbsp&nbsp량 <span style="color:red">*</span></td>
						<td class="subject"><input type = "text" id="cmpNumber" data-bind="value:CMPNUMBER" style="width:97%"></select></td>
			    	</tr>
			    	<tr>
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 행동지표</td>
				    	<td class="subject"><textarea rows="4"  type="text" id="bhvIndicator" data-bind="value:BHV_INDICATOR" style=" width:96%;" /></td>
			    	</tr>
			    	<tr>
                        <td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 계급맵핑</td>
                        <td class="subject">
                            <select id="bhid_ldr" multiple="multiple" data-placeholder="계급을 선택하세요."></select>
                       </td>
                    </tr>
                    <tr>
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부</td> 
				    	<td class="subject"><input type="radio" name="useFlag"  id="useFlag"   value="Y" /> 사용</input>
					 	<span style="padding-left:70px"><input type="radio" name="useFlag" id="useFlag"  value="N"/> 미사용</input></span></td>
			    	</tr>
			    	<tr>
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 등&nbsp&nbsp록&nbsp&nbsp일</td> 
				    	<td class="subject"><input type="text" id="createTime" data-bind="value:CREATETIME" style="border:none" readonly="readonly" /></td>
			    	</tr>
			    	<tr>
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 마지막 수정일</td> 
				    	<td class="subject"><input type="text" id="modifyTime" data-bind="value:MODIFYTIME" style="border:none" readonly="readonly" /></td>
			    	</tr>
			    	<tr>
			    		<td colspan="2" style="text-align:right;border-right:none;">
			    			<button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
							<button id="delBtn" class="k-button">삭제</button>&nbsp;
			    			<button id="cencelBtn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>
			    		</td>			    	
			    	</tr>
				</table>
	 		</script>
	
</body>
</html>