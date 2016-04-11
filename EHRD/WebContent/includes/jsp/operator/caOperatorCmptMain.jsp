<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>역량관리</title>
	</style>
	<script type="text/javascript">

	
	var dataSource_cmpgroup = null;
	
        yepnope([{
        	 load : [ 'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
      	            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
      	            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
      	            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
      	            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js', 
      	            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
      	            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
      	            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js', 
      	            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',
      	            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
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
            
              
              dataSource_cmpgroup = new kendo.data.HierarchicalDataSource({
                  type: "json",
                  transport: {
                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpgroup_list.do?output=json", type:"POST" },
                      parameterMap: function (options, operation){  
                        return {  USEFLAG : $(':radio[id="useFlagSearch"]:checked').val() };
                      }         
             },
             schema: {
                 data: "items",
                 model: {
                     fields: {
                       VALUE : { type: "String" },
                       TEXT : { type: "String" },
                       P_VALUE : { type: "String" },
                       USEFLAG : { type: "String" },
                       CMM_CODENAME : { type: "String" },
                       STANDARDCODE : { type:"String" },
                       items : { VALUE : { type: "String" }, TEXT : { type: "String" }, P_VALUE : { type: "String"}, CMM_CODENAME :{type:"String"}, STANDARDCODE : { type:"String" } }
                     },
                     children: "items"
                 }
             },
             serverFiltering: false,
             serverSorting: false});
              
              // list call
              openwindow(dataSource);
              
//               $("#cmpgroupBtn").click(function(){
//             	  $("#cmpgroup-window").data("kendoWindow").center();
//             	  $("#cmpgroup-window").data("kendoWindow").open();
            	  
            	  
//               });
              
//               $("#useFlagSearch").click(function(){
//             	  $("#cmpgroupTreeview").data("kendoTreeView").dataSource.read();

//               });
              
//               if( !$("#cmpgroup-window").data("kendoWindow") ){

//                   $("#cmpgroup-window").kendoWindow({
//                       width:"600px",
//                       minWidth:"600px",
//                       resizable : false,
//                       title : "역량군관리",
//                       modal: true,
//                       visible: false
//                   });
//                }
           
              
//               //역량군 목록 트리뷰
//               $("#cmpgroupTreeview").kendoTreeView({
//                   dataTextField: "TEXT",
//                   dataSource: dataSource_cmpgroup,
//                   loadOnDemand: false,
//                   change : function (e){
//                 	  var selectedCells = this.select();               
//                       var selectedCell = this.dataItem( selectedCells );
//                       //alert(selectedCell.VALUE+","+selectedCell.TEXT+","+selectedCell.P_VALUE);
//                       /*var selectrow = {
//                     		  CMPGROUP:selectedCell.VALUE,
//                     		  P_CMPGROUP:selectedCell.P_VALUE,
//                     		  CMPGROUP_NAME:selectedCell.CMM_CODENAME,
//                     		  STANDARDCODE:selectedCell.STANDARDCODE
//                       };*/
//                       //kendo.bind( $("#mgmtcg"), selectrow ); //table과 데이터 바인딩처리
                      
//                       $("#mgmt-cmpGroup").val(selectedCell.VALUE);
//                       $("#mgmt-standardcode").val(selectedCell.STANDARDCODE);
//                       $("#mgmt-p_cmpGroup").data("kendoComboBox").value(selectedCell.P_VALUE);
//                       $("#mgmt-cmpGroupName").val(selectedCell.CMM_CODENAME);
//                       $('input:radio[id=mgmt-cmpGroupUseFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//역량군 사용여부
//                       $('input:radio[id=mgmtmode]:input[value=mod]').attr("checked", true); //역량군 추가/수정 여부
                      
//                   }
//               });
              
                         
//               //역량군관리 팝업 - 상위역량군 콤보박스
//               $("#mgmt-p_cmpGroup").kendoComboBox({
//                   dataTextField: "TEXT",
//                   dataValueField: "VALUE",
//                   dataSource: dataSource,
//                   filter: "contains",
//                   suggest: true,
//                  placeholder : "선택 상위역량군..." 
//               });
              
//               //역량군관리 팝업 - 저장버튼 클릭
//               $("#cmpgroup-save-btn").click( function(){
            
// 		            if($("#mgmt-cmpGroupName").val()=="") {
// 		                alert("역량군명을 입력해 주십시오.");
// 		                return false;
// 		            }
// 		            if($(':radio[id="mgmt-cmpGroupUseFlag"]:checked').val()==""){
// 		            	alert("사용여부를 선택해 주십시오.");
//                         return false;
// 		            }
// 		            //alert($("#mgmt-standardcode").val());
		            
// 		            //수정모드일 경우 아래 사항이 체크되어야한다.
// 		            //1. 역량군(대)는 상위역량군을 선택하면 안된다.
// 		            //2. 역량군(소)는 상위역량군을 필수로 선택해야한다.
// 		            //카테고리코드가 역량군(대), (소) 가 각가 다르게 insert 되기 때문..
// 		            if($("#mgmt-standardcode").val() == "C102"){
// 		            	if($("#mgmt-p_cmpGroup").val() != ""){
// 		            		alert("역량군(대)는 상위역량군을 선택할 수 없습니다.");
// 		            		return false;
// 		            	}
// 		            }
// 		            if($("#mgmt-standardcode").val() == "C103"){
// 		            	if($("#mgmt-p_cmpGroup").val() == ""){
//                             alert("역량군(소)는 상위역량군이 필수입니다..");
//                             return false;
//                         }
// 		            }
		            
// 		            var isSave = confirm("역량군정보를 저장하시겠습니까?");
// 		            if(isSave){
// 		            	var scode = "";
// 		            	var pScode = "";
// 	                    if($("#mgmt-p_cmpGroup").val()!=""){
// 	                    	//상위역량군코드가 있으면 역량군(소)를 입력하는 것.
// 		            		scode = "C103";
// 		            		pScode = "C102";
// 		            	}else{
// 		            		//상위역량군코드가 없으면 역량군(대)를 입력하는것.
// 		            		scode = "C102";
// 		            	}
// 		            	var params = {
// 		                  COMMONCODE: $("#mgmt-cmpGroup").val(),
// 		                  STANDARDCODE: scode,
// 		                  CMM_CODENAME: $("#mgmt-cmpGroupName").val(),
// 		                  USEFLAG: $(':radio[id="mgmt-cmpGroupUseFlag"]:checked').val(),
// 	                      PARENT_COMMONCODE: $("#mgmt-p_cmpGroup").val(),
// 	                      PARENT_STANDARDCODE: pScode
// 		                };
		                
// 		                $.ajax({
// 		                    type : 'POST',
// 		                    url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_cmpgroup_save.do?output=json",
// 		                    data : { item: kendo.stringify( params ) },
// 		                    complete : function( response ){
// 		                        var obj  = eval("(" + response.responseText + ")");
// 		                        if(obj.saveCount != 0){
// 		                            openwindow(dataSource);
// 		                            filterUseFlag();
// 		                            dataSource.read();
// 		                            alert("저장되었습니다.");  
// 		                        }else{
// 		                            alert("저장에 실패 하였습니다.");
// 		                        }                           
// 		                    },
// 		                    error: function( xhr, ajaxOptions, thrownError){                                
// 		                    },
// 		                    dataType : "json"
// 		                });     
// 		            }
// 		        });
              
               // list new btn add click event
               $("#newBtn").click( function(){
                    
                   $("#splitter").data("kendoSplitter").expand("#detail_pane");
                   
                   // show detail 
                   $('#details').show().html(kendo.template($('#template').html()));
                    
                   kendo.bind( $(".tabular"),  null );
                    
                   $("#bhvTR").hide();
                   
                   $("#cmpGroup").kendoDropDownList({
                        dataTextField: "TEXT",
                        dataValueField: "VALUE",
                        dataSource: dataSource,
                        filter: "contains",
                        suggest: true,
                        placeholder : "" ,
                        change: function() {                            
                         }
                    });                    
                 
                   
                    $('input:radio[id=useFlag]:input[value=Y]').attr("checked", true);//사용여부
                    
                    buttonEvent(dataSource);                
                   
                    $("#delBtn").hide();
              });
          }
      }]);   
        

        function disabledExceptNum(obj){
            if ((event.keyCode> 47) && (event.keyCode < 58)){
                event.returnValue=true;
            } else { 
                event.returnValue=false;
            }
        }
        

    </script>
	<script type="text/javascript">
	
	// 상세보기.
    function fn_detailView(cmpNumber){
		
    	var dataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {  STANDARDCODE : "C102" };
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
        
          
          dataSource_cmpgroup = new kendo.data.HierarchicalDataSource({
              type: "json",
              transport: {
                  read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpgroup_list.do?output=json", type:"POST" },
                  parameterMap: function (options, operation){  
                    return {  USEFLAG : $(':radio[id="useFlagSearch"]:checked').val() };
                  }         
         },
         schema: {
             data: "items",
             model: {
                 fields: {
                   VALUE : { type: "String" },
                   TEXT : { type: "String" },
                   P_VALUE : { type: "String" },
                   USEFLAG : { type: "String" },
                   CMM_CODENAME : { type: "String" },
                   STANDARDCODE : { type:"String" },
                   items : { VALUE : { type: "String" }, TEXT : { type: "String" }, P_VALUE : { type: "String"}, CMM_CODENAME :{type:"String"}, STANDARDCODE : { type:"String" } }
                 },
                 children: "items"
             }
         },
         serverFiltering: false,
         serverSorting: false});		
		
    	var grid = $("#grid").data("kendoGrid");
        var data = grid.dataSource.data();

        var selectedCell;
        for(var i = 0; i<data.length; i++) {
            var dataItem = data[i];
            if(cmpNumber == dataItem.CMPNUMBER){
            	selectedCell = dataItem;
            	
            	var selectRow =  {
                 		MODE : "mod",
                 		COMPANYID: selectedCell.COMPANYID,                 
                 		CMPNUMBER :selectedCell.CMPNUMBER,         
               			STN_CODENAME: selectedCell.STN_CODENAME,   
               			CMPGROUP: selectedCell.CMPGROUP,
               			CMPNAME: selectedCell.CMPNAME,           
               			CMPDEFINITION : selectedCell.CMPDEFINITION,          
               			KNOWLEDGE: selectedCell.KNOWLEDGE,   
               			SKILL: selectedCell.SKILL,       
               			ATTITUDE: selectedCell.ATTITUDE,     
               			BSNS_REQR_LEVEL: selectedCell.BSNS_REQR_LEVEL,     
               			USEFLAG: selectedCell.USEFLAG,
               			USEFLAG_STRING: selectedCell.USEFLAG_STRING,
               			CREATETIME: selectedCell.CREATETIME_STRING,
               			MODIFYTIME: selectedCell.MODIFYTIME_STRING
               			
               	 };
                 
                 $("#splitter").data("kendoSplitter").expand("#detail_pane");
                 
                 // show detail 
				 $('#details').show().html(kendo.template($('#template').html()));
	        	
                 $("#bhvGrid").kendoGrid({
						dataSource: {
							transport: { 
								read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmtp_operator_bhv_list.do?output=json', type:'post' },
						 		parameterMap: function (options, operation){			
						 			return { CMPNUMBER: selectedCell.CMPNUMBER};
								}
							},						
							batch: true, 
							schema: {
								data: "items",
								model: {
									fields: {
										BHV_INDICATOR : { editable:false, type: "string"}
		                             }
			                     }
							},
							error:handleKendoAjaxError
						},
						columns: [
								{ title: "행동지표",   
								  field: "BHV_INDICATOR", 
								   width: 300,
								   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
				                   attributes:{"class":"table-cell", style:"text-align:left;text-decoration: underline;"}
								}
						],
 					   editable : true,
 						navigatable: true,
 						height: 250
               });
                 
                // create ComboBox from input HTML element
         	    $("#cmpGroup").kendoDropDownList({
         	        dataTextField: "TEXT",
         	        dataValueField: "VALUE",
         	        dataSource: dataSource,
         	        filter: "contains",
         	        suggest: true,
                    placeholder : "" ,
         	       change: function() {
                      
         	       }
         	    });         
         	 
                
	         	 // dtl save btn add click event
	          	 buttonEvent(dataSource);
	          	
	          	    
              	 // detail binding data
                 kendo.bind( $(".tabular"), selectRow );
              	 
                 $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//사용여부
                 
                                   
                 //dataSource_s.filter({});
                    
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
			url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_add_check.do?output=json",
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
				alert('xrs.status = ' + xhr.status + '\n' + 
                        'thrown error = ' + thrownError + '\n' +
                        'xhr.statusText = '  + xhr.statusText + '\n세션이 종료되었습니다.' );
            	sessionout();
			},
			dataType : "json"
		});	

	}
	
    function buttonEvent(dataSource){
    	
    	// dtl del btn add click event
       	$("#delBtn").click( function(){
       	    
        	var isDel = confirm("삭제 하시겠습니까?");
            if(isDel){
        		var params = {
        			CMPNUMBER : $("#cmpNumber").val(),
        			FLAG : "11",
         		};
        		
        		$.ajax({
        			type : 'POST',
					url:"/operator/ca/ca_common_del.do?output=json",
					data : { item: kendo.stringify( params ) },
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
						if(obj.saveCount != 0){
							openwindow(dataSource);		
							kendo.bind( $(".tabular"),  null );
				        		
				        	$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
				            $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
							alert("삭제되었습니다.");	
						}else{
							alert("삭제를 실패 하였습니다.");
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
    	
		// dtl save btn add click event
       	$("#saveBtn").click( function(){
       	    
        	if(removeNullStr($("#cmpGroup").val())=="" || $("#cmpName").val()=="") {
        		alert("역량군과 역량명을 입력해 주십시오.");
        		return false;
        	}
        	
        	var isDel = confirm("역량정보를 저장하시겠습니까?");
            if(isDel){
        		var params = {
        			CMPNUMBER : $("#cmpNumber").val(),
        			CMPGROUP : removeNullStr($("#cmpGroup").val()),
                    CMPNAME : $("#cmpName").val(),
        			CMPDEFINITION : $("#cmpDefinition").val(),
        			USEFLAG : $(':radio[id="useFlag"]:checked').val() 
         		};
        		
        		$.ajax({
        			type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_cmpt_save.do?output=json",
					data : { item: kendo.stringify( params ) },
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
						if(obj.saveCount != 0){
							openwindow(dataSource);		
							kendo.bind( $(".tabular"),  null );
				        		
				        	$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
				            $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
							
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
			
      	// dtl cancel btn add click event
       	$("#cencelBtn").click( function(){
        	kendo.bind( $(".tabular"),  null );
        		 
        	$("#cudMode").val()=="";
        		
        	$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
            $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
        });
			
    }
	
       function openwindow(dataSource) {
    	    $("#grid").empty();
	       	$("#grid").kendoGrid({
	               dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_operator_list.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){	
	                       	return {  startIndex: options.skip, pageSize: options.pageSize  };
	                       } 		
	                   },
	                   schema: {
	                   	total: "totalItemCount",
	                   	data: "items",
	                       model: {
	                           fields: {
	                        	   COMPANYID : { type: "int" },
	                        	   CMPNUMBER : { type: "int" },
	                        	   CMPGROUP : { type: "string" },
	                        	   CMPNAME : { type: "string" },
	                        	   CMPDEFINITION : { type: "string" },
	                        	   KNOWLEDGE: { type: "string" },
	                        	   SKILL : { type: "string" },
	                        	   ATTITUDE : { type: "string" },
	                        	   BSNS_REQR_LEVEL : { type: "string" },
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
		                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },
	                   {
	                       field: "CMPNAME",
	                       title: "역량",
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						   width:250,
	                       attributes:{"class":"table-cell", style:"text-align:left;text-decoration: underline;"},
	                        template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${CMPNUMBER});' >${CMPNAME}</a>"
	                   },
	                   {
	                       field: "USEFLAG_STRING",
	                       title: "사용여부",
	                       width:100,
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
	               selectable: "row",
	               pageable : {
                       refresh : false,
                       pageSizes :[10,20,30]
                   },
	               change: function(e) {                                        
                 
	               }
	               
	           });
	       	
	       	

	       }
       
//        //역량군코드 목록 조회
//        function filterUseFlag(){
//     	   $("#cmpgroupTreeview").data("kendoTreeView").dataSource.read();
//        }
       
//        //역량군 추가 라디오버튼 클릭시 역량군입력영역 화면 초기화
//        function addCmpgroup(){
//     	   $("#mgmt-cmpGroup").val("");
//            $("#mgmt-standardcode").val("");
//            $("#mgmt-p_cmpGroup").data("kendoComboBox").value("");
//            $("#mgmt-cmpGroupName").val("");
//            $('input:radio[id=mgmt-cmpGroupUseFlag]:input[value=Y]').attr("checked", true);//역량군 사용여부
//            //$('input:radio[id=mgmtmode]:input[value=new]').attr("checked", true);
//        }
		   
	</script>
	
</head>
<body>
	<!-- START MAIN CONTNET -->
	
	
	<div id="content">
        <div class="cont_body">
            <div class="title mt30">역량관리</div>
            <div class="table_zone" >
                <div class="table_btn">
                         <a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_cmpt_list_excel.do" >엑셀 다운로드</a>&nbsp
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
					<tr><td colspan="2" style="font-size:16px;"> <strong>&nbsp; 역량관리 </strong>
						<input type="hidden" id="comapnyId" data-bind="value:COMPANYID" style="border:none" readonly="readonly" />
			    		<input type="hidden" id="cmpNumber" data-bind="value:CMPNUMBER" style="border:none" readonly="readonly" />
						<input type="hidden" id="cudMode" data-bind="value:MODE" style="border:none" readonly="readonly" />
					</td></tr>
					<tr>
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 역량군 <span style="color:red">*</span></td>
				    	<td class="subject"><input type = "text" id="cmpGroup" data-bind="value:CMPGROUP" style="width:97%;"></select><BR>
						※ 역량군 추가는 공통 -> 공통코드관리에서 카테고리를 역량군으로 선택해 등록하시면 됩니다.
						</td>
			    	</tr>			    	
                    <tr>
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 역&nbsp&nbsp량&nbsp&nbsp명 <span style="color:red">*</span></td>
				    	<td class="subject"><input type="text" id="cmpName" data-bind="value:CMPNAME" style="width:96%;" onKeyUp="chkNull(this);" /></td>
			    	</tr>
			    	<tr>
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 역량정의</td>
				    	<td class="subject"><textarea cols="40" rows="4"  type="text" id="cmpDefinition" data-bind="value:CMPDEFINITION" style="width:96%;" ></textarea></td>
			    	</tr>
					<!--<tr>
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 기업요구수준</td>
						<td class="subject"><input   id="bsnsReqrLevel" data-bind="value:BSNS_REQR_LEVEL"  value="0" /></td>
			    	</tr>-->
					<tr id="bhvTR">
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 행동지표</td>
				    	<td class="subject"><div id="bhvGrid" style="width:98%;"></div></td>
			    	</tr>
			    	<tr>
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부</td> 
				    	<td class="subject"><input type="radio" id="useFlag" name="useFlag"  value="Y" /> 사용</input>
					 	<span style="padding-left:70px"><input type="radio" id="useFlag" name="useFlag"  value="N"/> 미사용</input></span></td>
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
			    		<td colspan="2" style="text-align: right;border-right:none;">
							<div style="text-align: right;">
			    			   <button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
								<button id="delBtn" class="k-button">삭제</button>&nbsp;
			    			   <button id="cencelBtn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>
							</div>
			    		</td>			    	
			    	</tr>
				</table>
		</script>

<!-- 	<div id="cmpgroup-window" style="display: none;"> -->
<!-- 	       ※ 추가 시 상위역량군을 선택하지 않으면 '역량군(대)'가 추가됩니다.<br> -->
<!-- 	       ※ 추가 시 상위역량군을 선택하면 '역량군(소)'가 추가됩니다.<br> -->
<!--            ※ 수정 시 왼쪽의 역량군명을 클릭하세요.<br><br> -->
<!-- 		<div style="width: 250px"> -->
<!-- 		  <input type="radio" id="useFlagSearch" name="useFlagSearch"  value="Y" checked="checked" onclick="filterUseFlag();"/>사용</input> -->
<!--           <input type="radio" id="useFlagSearch" name="useFlagSearch"  value="ALL" onclick="filterUseFlag();"/>전체</input> -->
<!--           <table class="tabular" style="width: 250px;"> -->
<!--             <tr> -->
<!--                 <td> -->
<!--                     <div id="cmpgroupTreeview"   style="height: 200px; "></div> -->
<!--                 </td> -->
<!--             </tr> -->
<!-- 		  </table> -->
<!-- 		</div> -->
<!-- 		<div id="lst-add-cnslr-window-outer"> -->
<!-- 			<table class="tabular" id="mgmtcg" style="width: 450px;"> -->
<!-- 			 <tr> -->
<!--                     <td style="width: 100px; height: 25px"> -->
<!--                        <input type="radio" id="mgmtmode" name="mgmtmode"  value="new" checked="checked" onclick="addCmpgroup();"/>추가</input> -->
<!--                         <input type="radio" id="mgmtmode" name="mgmtmode"  value="mod" onclick=""/>수정</input> -->
<!--                     </td> -->
<!--                     <td></td> -->
<!--                 </tr> -->
<!-- 				<tr> -->
<!-- 					<td style="width: 100px; height: 25px"> -->
<!-- 					   <label class="right inline required">▶상위역량군</label> -->
<!-- 					</td> -->
<!-- 					<td> -->
<!-- 					   <input type="hidden" id="mgmt-cmpGroup" data-bind="value:VALUE" style="border:none" readonly="readonly" /> -->
<!-- 					   <input type="hidden" id="mgmt-standardcode" data-bind="value:STANDARDCODE" style="border:none" /> -->
<!-- 					   <select id="mgmt-p_cmpGroup" data-bind="value:P_CMPGROUP" style="width:97%; text-align:center"></select> -->
<!-- 					</td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!-- 					<td><label class="right inline required">▶역량군명</label></td> -->
<!-- 					<td><input class="k-textbox" id="mgmt-cmpGroupName" data-bind="value:CMPGROUP_NAME" maxlength="20" size="40" style="width: 100px;" /></td> -->
<!-- 				</tr> -->
<!-- 				<tr> -->
<!--                     <td><label class="right inline required">▶사용여부</label></td> -->
<!--                     <td><input type="radio" id="mgmt-cmpGroupUseFlag" name="mgmt-cmpGroupUseFlag"  value="Y" />사용</input> -->
<!--                         <input type="radio" id="mgmt-cmpGroupUseFlag" name="mgmt-cmpGroupUseFlag"  value="N"/>미사용</input></td> -->
<!--                 </tr> -->
<!-- 			</table> -->
<!-- 			<table style="width: 450px;"> -->
<!-- 				<tr> -->
<!-- 					<td align="right"><br> -->
<!-- 						<button id="cmpgroup-save-btn" class="k-button"> -->
<!-- 							<span class="k-icon k-i-plus"></span>저장 -->
<!-- 						</button></td> -->
<!-- 				</tr> -->
<!-- 			</table> -->
<!-- 		</div> -->
<!-- 	</div> -->
    
    
</body>
</html>