<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="mpvaSubpage">
<head>
	<title>KPI관리</title>
	<script type="text/javascript">
	
	var dataSource_kpigroup = null;
	
        yepnope([{
          load: [ 
            'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
                'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.default.min.css',
                'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css',
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
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "C104" };
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
            
              
              var dataSource_s = new kendo.data.DataSource({
                  type: "json",
                  transport: {
                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_commonCode_list.do?output=json", type:"POST" },
                      parameterMap: function (options, operation){  
                        return {  STANDARDCODE : "C105" };
                      }         
             },
             schema: {
                data: "items",
                 model: {
                     fields: {
                       VALUE : { type: "String" },
                       TEXT : { type: "String" },
                       P_VALUE : { type: "String" }
                     }
                 }
             },
             serverFiltering: false,
             serverSorting: false});
              
              var dataSource_unit = new kendo.data.DataSource({
                  type: "json",
                  transport: {
                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_commonCode_list.do?output=json", type:"POST" },
                      parameterMap: function (options, operation){  
                        return {  STANDARDCODE : "C110" };
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
              
              
              dataSource_kpigroup = new kendo.data.HierarchicalDataSource({
                  type: "json",
                  transport: {
                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_kpigroup_list.do?output=json", type:"POST" },
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
              openwindow();
              
              $("#uploadBtn").click( function() {
            	  
                  $("#excel-upload-window").data("kendoWindow").close();
                   
                });
              
              $("#kpigroupBtn").click(function(){
            	  $("#kpigroup-window").data("kendoWindow").center();
            	  $("#kpigroup-window").data("kendoWindow").open();
            	  
            	  
              });
              
//               $("#useFlagSearch").click(function(){
//             	  $("#kpigroupTreeview").data("kendoTreeView").dataSource.read();

//               });
              
              if( !$("#kpigroup-window").data("kendoWindow") ){

                  $("#kpigroup-window").kendoWindow({
                      width:"600px",
                      minWidth:"600px",
                      resizable : false,
                      title : "지표분류관리",
                      modal: true,
                      visible: false
                  });
               }
              
              $("#excelUBtn").click( function(){
                  $('#excel-upload-window').data("kendoWindow").center();      
                  $("#excel-upload-window").data("kendoWindow").open();
                 
              });
              
              if( !$("#excel-upload-window").data("kendoWindow") ){     

                  $("#excel-upload-window").kendoWindow({
                      width:"400px",
                      minWidth:"100px",
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
              
              //지표 목록 트리뷰
              $("#kpigroupTreeview").kendoTreeView({
                  dataTextField: "TEXT",
                  dataSource: dataSource_kpigroup,
                  loadOnDemand: false,
                  change : function (e){
                	  var selectedCells = this.select();               
                      var selectedCell = this.dataItem( selectedCells );
                      
                      $("#mgmt-kpiGroup").val(selectedCell.VALUE);
                      $("#mgmt-standardcode").val(selectedCell.STANDARDCODE);
                      $("#mgmt-p_kpiGroup").data("kendoComboBox").value(selectedCell.P_VALUE);
                      $("#mgmt-kpiGroupName").val(selectedCell.CMM_CODENAME);
                      $('input:radio[id=mgmt-kpiGroupUseFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//지표 사용여부
                      $('input:radio[id=mgmtmode]:input[value=mod]').attr("checked", true); //지표 추가/수정 여부
                      
                  }
              });
              
              //엑셀 업로드 팝업에서 지표 코드를 참조할 수 있도록 제공되는 treeveiw 정의
              $("#kpigroupRefTreeview").kendoTreeView({
                  dataTextField: "TEXT",
                  dataSource: {
                      type: "json",
                      transport: {
                          read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_kpigroup_list.do?output=json", type:"POST" },
                          parameterMap: function (options, operation){  
                            return {  USEFLAG : "Y" };
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
                 serverSorting: false
                 },
                 loadOnDemand: false
              });
              
              
              //지표관리 팝업 - 상위지표 콤보박스
              $("#mgmt-p_kpiGroup").kendoComboBox({
                  dataTextField: "TEXT",
                  dataValueField: "VALUE",
                  dataSource: dataSource,
                  filter: "contains",
                  suggest: true,
                 placeholder : "선택 상위지표..." 
              });
              
              //지표관리 팝업 - 저장버튼 클릭
              $("#kpigroup-save-btn").click( function(){
            	  
            	  
		            if($("#mgmt-kpiGroupName").val()=="") {
		                alert("지표명을 입력해 주십시오.");
		                return false;
		            }
		            if($(':radio[id="mgmt-kpiGroupUseFlag"]:checked').val()==""){
		            	alert("사용여부를 선택해 주십시오.");
                        return false;
		            }
		            //alert($("#mgmt-standardcode").val());
		            
		            //수정모드일 경우 아래 사항이 체크되어야한다.
		            //1. 지표(대)는 상위지표을 선택하면 안된다.
		            //2. 지표(소)는 상위지표을 필수로 선택해야한다.
		            //카테고리코드가 지표(대), (소) 가 각가 다르게 insert 되기 때문..
		            if($("#mgmt-standardcode").val() == "C104"){
		            	if($("#mgmt-p_kpiGroup").val() != ""){
		            		alert("지표(대)는 상위지표을 선택할 수 없습니다.");
		            		return false;
		            	}
		            }
		            if($("#mgmt-standardcode").val() == "C105"){
		            	if($("#mgmt-p_kpiGroup").val() == ""){
                            alert("지표(소)는 상위지표이 필수입니다..");
                            return false;
                        }
		            }
		            
		            if($("#mgmt-p_kpiGroup").val() ==""){
	                      var data =   dataSource.data();
	                      
	                      for(var i = 0; i<data.length; i++) {
	                          var dataItem = data[i];
	                          if(dataItem.TEXT == $("#mgmt-kpiGroupName").val()){
	                        	  if(dataItem.USEFLAG == $(':radio[id="mgmt-kpiGroupUseFlag"]:checked').val()){
	                          	
	                        	alert("사용지표명중 동일한 지표명이 있습니다.");
	      		                return false;
	                              
	                                  break;
	                        	  }
	                          } // end if
	                      } // end for
	                 }
	            	  
	                  
	                  dataSource_s.filter({field : "P_VALUE", operator: "eq", value: $("#mgmt-p_kpiGroup").val() });
	                  
	                  var data_s = dataSource_s.data();
	                  
	                  
	                  for(var i = 0; i<data_s.length; i++) {
	                      var dataItem = data_s[i];
	                      
	                     if(dataItem.P_VALUE == $("#mgmt-p_kpiGroup").val()){
	                    	if(dataItem.USEFLAG == $(':radio[id="mgmt-kpiGroupUseFlag"]:checked').val()){
		                      if(dataItem.TEXT == $("#mgmt-kpiGroupName").val()){
		                      	
		                    	alert("사용지표명중 동일한 지표명이 있습니다.");
		  		                return false;
		                          
		                              break;
		                      	}
	                    	}
	                      } // end if
	                  } // end for
		            
		            var isSave = confirm("지표정보를 저장하시겠습니까?");
		            if(isSave){
		            	var scode = "";
		            	var pScode = "";
	                    if($("#mgmt-p_kpiGroup").val()!=""){
	                    	//상위지표코드가 있으면 지표(소)를 입력하는 것.
		            		scode = "C105";
		            		pScode = "C104";
		            	}else{
		            		//상위지표코드가 없으면 지표(대)를 입력하는것.
		            		scode = "C104";
		            	}
		            	var params = {
		                  COMMONCODE: $("#mgmt-kpiGroup").val(),
		                  STANDARDCODE: scode,
		                  CMM_CODENAME: $("#mgmt-kpiGroupName").val(),
		                  USEFLAG: $(':radio[id="mgmt-kpiGroupUseFlag"]:checked').val(),
	                      PARENT_COMMONCODE: $("#mgmt-p_kpiGroup").val(),
	                      PARENT_STANDARDCODE: pScode
		                };
		                
		                $.ajax({
		                    type : 'POST',
		                    url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_kpigroup_save.do?output=json",
		                    data : { item: kendo.stringify( params ) },
		                    complete : function( response ){
		                        var obj  = eval("(" + response.responseText + ")");
		                        if(obj.saveCount != 0){
		                            openwindow();
		                            filterUseFlag();
		                            dataSource.read();
		                            dataSource_s.read();
		                            dataSource_unit.read();
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
            /*
            ##########buttonEvent###########3
            */
              // list new btn add click event
              $("#newBtn").click( function(){
                   
                  $("#splitter").data("kendoSplitter").expand("#detail_pane");
                  
                  // show detail 
                  $('#details').show().html(kendo.template($('#template').html()));
                   
                  kendo.bind( $(".tabular"),  null );
                   
                  
                  $("#kpiGroup").kendoComboBox({
	         	        dataTextField: "TEXT",
	         	        dataValueField: "VALUE",
	         	        dataSource: dataSource,
	         	        filter: "contains",
	         	        suggest: true,
	                    placeholder : "" ,
	         	       change: function() {
	         	    	  if($("#kpiGroup").val() != ""){
                            dataSource_s.filter({field : "P_VALUE", operator: "", value: $("#kpiGroup").val() });
                        }else{
                            dataSource_s.filter({});
                        }
                        $("#kpiGroup_s").data("kendoComboBox").value("");
                        
	         	       }
	         	    });	 
                   
                  $("#kpiGroup_s").kendoComboBox({
                      dataTextField: "TEXT",
                      dataValueField: "VALUE",
                      dataSource: dataSource_s,
                      filter: "contains",
                      suggest: true,
                      placeholder : "" ,
                  });
                  
                  $("#kpiUnit").kendoComboBox({
                      dataTextField: "TEXT",
                      dataValueField: "VALUE",
                      dataSource: dataSource_unit,
                      filter: "contains",
                      suggest: true,
                      placeholder : "" ,
                  });
                  
                   $('input:radio[id=useFlag]:input[value=Y]').attr("checked", true);//사용여부
                   
                   buttonEvent(dataSource, dataSource_s);
                   
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
    function fn_detailView(kipNumber){
		
    	 var dataSource = new kendo.data.DataSource({
             type: "json",
             transport: {
                 read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_commonCode_list.do?output=json", type:"POST" },
                 parameterMap: function (options, operation){    
                     return {  STANDARDCODE : "C104" };
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
         
           
           var dataSource_s = new kendo.data.DataSource({
               type: "json",
               transport: {
                   read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_commonCode_list.do?output=json", type:"POST" },
                   parameterMap: function (options, operation){  
                     return {  STANDARDCODE : "C105" };
                   }         
          },
          schema: {
             data: "items",
              model: {
                  fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" },
                    P_VALUE : { type: "String" }
                  }
              }
          },
          serverFiltering: false,
          serverSorting: false});
           
           var dataSource_unit = new kendo.data.DataSource({
               type: "json",
               transport: {
                   read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_commonCode_list.do?output=json", type:"POST" },
                   parameterMap: function (options, operation){
                     return {  STANDARDCODE : "C110" };
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
           
           
           dataSource_kpigroup = new kendo.data.HierarchicalDataSource({
               type: "json",
               transport: {
                   read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_kpigroup_list.do?output=json", type:"POST" },
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
            if(kipNumber == dataItem.KPI_NO){
            	selectedCell = dataItem;
            	
                var selectRow =  {
                		MODE : "mod",
                		COMPANYID: selectedCell.COMPANYID,                 
                		KPI_NO :selectedCell.KPI_NO, 
              			KPIGROUP: selectedCell.KPIGROUP,
              			KPIGROUP_S: selectedCell.KPIGROUP_S,
              			KPI_NM: selectedCell.KPI_NM,           
              			KPI_TYPE : selectedCell.KPI_TYPE,          
              			EVL_HOW: selectedCell.EVL_HOW,   
              			UNIT : selectedCell.UNIT,    
              			USEFLAG: selectedCell.USEFLAG,
              			CREATETIME: selectedCell.CREATETIME_STRING,
              			MODIFYTIME: selectedCell.MODIFYTIME_STRING
              			
              	 };
                
					$("#splitter").data("kendoSplitter").expand("#detail_pane");
                
                // show detail 
				 $('#details').show().html(kendo.template($('#template').html()));
                
	    	    $("#kpiGroup").kendoComboBox({
	    	        dataTextField: "TEXT",
	    	        dataValueField: "VALUE",
	    	        dataSource: dataSource,
	    	        filter: "contains",
	    	        suggest: true,
	               placeholder : "" ,
	    	       change: function() {
	    	    	  if($("#kpiGroup").val() != ""){
	                     dataSource_s.filter({field : "P_VALUE", operator: "", value: $("#kpiGroup ").val() });
	                 }else{
	                     dataSource_s.filter({});
	                 }
	                 $("#kpiGroup_s").data("kendoComboBox").value("");
	                 
	    	       }
	    	    });	         	   
	           
	    	   
	    	    dataSource_s.filter({field : "P_VALUE", operator: "", value:selectedCell.KPIGROUP });
	    	    
	    	   $("#kpiGroup_s").kendoComboBox({
	              dataTextField: "TEXT",
	              dataValueField: "VALUE",
	              dataSource: dataSource_s,
	              filter: "contains",
	              suggest: true,
	              placeholder : "" ,
	          });
	    	   
               $("#kpiUnit").kendoComboBox({
                   dataTextField: "TEXT",
                   dataValueField: "VALUE",
                   dataSource: dataSource_unit,
                   filter: "contains",
                   suggest: true,
                   placeholder : "" ,
               });
                
	          	
	          	  // dtl save btn add click event
	          	 buttonEvent(dataSource, dataSource_s);
	          	 
             	 // detail binding data
                kendo.bind( $(".tabular"), selectRow );
             	 
                $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//관리유형
                $('input:radio[id=evlHow]:input[value='+selectedCell.EVL_HOW+']').attr("checked", true);//사용여부
                
                //그리드 클릭 시 지표(대)는 data binding으로 자동 selected 되지만 지표(소)는 지표(대)의 값으로 filter되고나서 selected 되어야하기때문에 한번더 filter를 해준다.
//                 if($("#kpiGroup option:selected").val()!=""){
//                	 dataSource_s.filter({field : "P_VALUE", operator: "", value: $("#kpiGroup option:selected").val() });
//                 }
                
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
	
	
    function buttonEvent(dataSource, dataSource_s){
    	
    	// dtl del btn add click event
       	$("#delBtn").click( function(){
       	    
        	var isDel = confirm("삭제 하시겠습니까?");
            if(isDel){
        		var params = {
        			KPINUMBER : $("#kpiNumber").val(),
        			FLAG : "3",
         		};
        		
        		$.ajax({
        			type : 'POST',
					url:"/admin/ca/ca_common_del.do?output=json",
					data : { item: kendo.stringify( params ) },
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
						if(obj.saveCount != 0){
							openwindow();		
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
    	
       	// dtl save btn add click event
      	$("#saveBtn").click( function(){
      	  
       	if($("#kpiGroup").val()=="" || $("#kpiName").val()=="") {
       		alert("지표와 지표명을 입력해 주십시오.");
       		return false;
       	}
       	if($(':radio[id="evlHow"]:checked').val()==null) {
       		alert("관리유형을 체크해주세요");
       		return false;
       	}
       	if($("#kpiUnit").val()==null) {
       		alert("단위를 선택해주세요");
       		return false;
       	}       	  
       	
       	var isDel = confirm("지표정보를 저장하시겠습니까?");
           if(isDel){
       		var params = {
       			KPINUMBER : $("#kpiNumber").val(),
       			KPIGROUP : $("#kpiGroup").val(),
       			KPIGROUP_S : $("#kpiGroup_s").val(),
                KPINAME : $("#kpiName").val(),                    
                EVLHOW : $(':radio[id="evlHow"]:checked').val(),
                UNIT : $("#kpiUnit").val(), 
       			USEFLAG : $(':radio[id="useFlag"]:checked').val() 
        		};
       		
       		$.ajax({
       			type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_kpi_save.do?output=json",
					data : { item: kendo.stringify( params ) },
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
						if(obj.saveCount != 0){	
							$("#grid").data("kendoGrid").dataSource.read();
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

	
       function openwindow() {
    	    $("#grid").empty();
	       	$("#grid").kendoGrid({
	               dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_kpi_list.do?output=json", type:"POST" },
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
	                        	   KPI_NO : { type: "int" },
	                        	   KPIGROUP : { type: "string" },
	                        	   KPIGROUP_S : { type: "string" },
	                        	   KPI_NM : { type: "string" },
	                        	   KPI_TYPE : { type: "string" },
	                        	   EVL_HOW: { type: "string" },
	                        	   UNIT : { type: "string" },
	                        	   USEFLAG : { type: "string" },
	                        	   KPIGROUP_STRING : { type: "string" },
	                        	   KPIGROUP_S_STRING : { type: "string" },
	                        	   USEFLAG_STRING : { type: "string" },
	                        	   EVL_HOW_STRING : { type: "string" },
	                        	   KPI_TYPE_STRING : { type: "string" },
	                        	   UNIT_STRING : { type: "string" }
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
	                       field:"KPIGROUP_STRING",
	                       title: "지표대분류",
	                       filterable: true,
						    width:80,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },
	                   {
                           field:"KPIGROUP_S_STRING",
                           title: "지표소분류",
                           filterable: true,
                            width:80,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"} 
                       },
	                   {
	                       field: "KPI_NM",
	                       title: "지표명",
						   width:210,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:left;text-decoration: underline;"},
	                       template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${KPI_NO});' >${KPI_NM}</a>"
	                   },
	                   {
	                       field: "EVL_HOW_STRING",
	                       title: "관리유형",
						   width:70,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:center"},
	    			    	template: function (dataItem) {
	    			    		if (dataItem.EVL_HOW_STRING == null){
	    			    			return "";
	    			    		}else{
	                        		return dataItem.EVL_HOW_STRING+" &nbsp; [코드 : "+dataItem.EVL_HOW +"]";
	    			    		}
	                    	}	
	                   },
	                   {
	                       field: "UNIT_STRING",
	                       title: "단위",
						   width:70,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:center"},
	                       template: function (dataItem) {
	    			    		if (dataItem.UNIT_STRING == null){
	    			    			return "";
	    			    		}else{
	                        		return dataItem.UNIT_STRING+" &nbsp; [코드 : "+dataItem.UNIT +"]";
	    			    		}
	                    	}	
	                   },
	                   {
	                       field: "USEFLAG_STRING",
	                       title: "사용여부",
	                       width:60,
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
	               pageable: {  pageSizes:false,  messages: { display: ' {1} / {2}' }  }
	               
	           });
	          
	       }
       
       //지표코드 목록 조회
       function filterUseFlag(){
    	   $("#kpigroupTreeview").data("kendoTreeView").dataSource.read();
       }
       
       //지표 추가 라디오버튼 클릭시 지표입력영역 화면 초기화
       function addKpigroup(){
    	   $("#mgmt-kpiGroup").val("");
           $("#mgmt-standardcode").val("");
           $("#mgmt-p_kpiGroup").data("kendoComboBox").value("");
           $("#mgmt-kpiGroupName").val("");
           $('input:radio[id=mgmt-kpiGroupUseFlag]:input[value=Y]').attr("checked", true);//지표 사용여부
           //$('input:radio[id=mgmtmode]:input[value=new]').attr("checked", true);
       }
		   
	</script>
	
</head>
<body>

    <div id="content">
        <div class="cont_body">
            <div class="title mt30">KPI관리</div>
            <div class="table_zone" >
                <div class="table_btn">
                    <button id="kpigroupBtn" class="k-button" >지표분류관리</button>&nbsp;
                    	<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_common_excel.do" >엑셀 코드모음</a>&nbsp;
                    	<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_kpi_list_excel.do" >엑셀 다운로드</a>&nbsp;
                        <button id="excelUBtn" class="k-button" >엑셀 업로드</button>&nbsp;
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
					<tr><td colspan="2" style="font-size:16px;">
                        <strong>&nbsp; KPI관리 </strong>
                    
						<input type="hidden" id="comapnyId" data-bind="value:COMPANYID" style="border:none" readonly="readonly" />
			    		<input type="hidden" id="kpiNumber" data-bind="value:KPI_NO" style="border:none" readonly="readonly" />
						<input type="hidden" id="cudMode" data-bind="value:MODE" style="border:none" readonly="readonly" />
					</td></tr>
					<tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 지표대분류 <span style="color:red">*</span></td>
				    	<td class="subject"><input type="text" id="kpiGroup" data-bind="value:KPIGROUP" style="width:97%; text-align:center"></select></td>
			    	</tr>
			    	<tr>
                        <td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 지표소분류</td>
                        <td class="subject"><input type="text" id="kpiGroup_s" data-bind="value:KPIGROUP_S" style="width:97%; text-align:center"></select></td>
                    </tr>
                    <tr>
				    	<td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 지&nbsp&nbsp표&nbsp&nbsp명 <span style="color:red">*</span></td>
				    	<td class="subject"><input type="text" class="k-textbox" id="kpiName" data-bind="value:KPI_NM" onKeyUp="chkNull(this)"; style="width:97%;"  /></td>
			    	</tr>				
					<tr id="evlHowArea">
				    	<td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리유형 <span style="color:red">*</span></td> 
				    	<td class="subject"><input type="radio" id="evlHow" name="evlHow"  value="1" />합계</input>
					 	<input type="radio" id="evlHow" name="evlHow"  value="2"/>평균</input>
						<input type="radio" id="evlHow" name="evlHow"  value="3"/>누적</input></td>
			    	</tr>			
					<tr>
                        <td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 단&nbsp&nbsp위</td>
                        <td class="subject"><input type="text" id="kpiUnit" data-bind="value:UNIT" style="width:80px; text-align:center"></select></td>
                    </tr>
			    	<tr>
				    	<td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부</td> 
				    	<td class="subject"><input type="radio" id="useFlag" name="useFlag"  value="Y" />사용</input>
					 	<input type="radio" id="useFlag" name="useFlag"  value="N"/>미사용</input></td>
			    	</tr>
			    	<tr>
				    	<td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 등&nbsp&nbsp록&nbsp&nbsp일</td> 
				    	<td class="subject"><input type="text" id="createTime" data-bind="value:CREATETIME" style="border:none" readonly="readonly" /></td>
			    	</tr>
			    	<tr>
				    	<td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 마지막 수정일</td> 
				    	<td class="subject"><input type="text" id="modifyTime" data-bind="value:MODIFYTIME" style="border:none" readonly="readonly" /></td>
			    	</tr>
			    	<tr>
			    		<td colspan="2" align="right">
							<div style="text-align: right;">
			    			   <button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
								<button id="delBtn" class="k-button">삭제</button>&nbsp;
			    			   <button id="cencelBtn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>
							</div>
			    		</td>			    	
			    	</tr>
				</table>
		</script>

	<div id="kpigroup-window" style="display: none;">
	       ※ 추가 시 상위지표를 선택하지 않으면 '지표대분류'가 추가됩니다.<br>
	       ※ 추가 시 상위지표를 선택하면 '지표소분류'가 추가됩니다.<br>
           ※ 수정 시 왼쪽의 지표명을 클릭하세요.<br><br>
		<div style="width: 250px;float:left;">
		  <input type="radio" id="useFlagSearch" name="useFlagSearch"  value="Y" checked="checked" onclick="filterUseFlag();"/>사용</input>
          <input type="radio" id="useFlagSearch" name="useFlagSearch"  value="ALL" onclick="filterUseFlag();"/>전체</input>
          <table class="tabular" style="width: 250px;">
            <tr>
                <td>
                    <div id="kpigroupTreeview"   style="height: 200px; "></div>
                </td>
            </tr>
		  </table>
		</div>
		<div id="lst-add-cnslr-window-outer" style="width:320px;float:left;margin-left:10px;">
			<table class="tabular" id="mgmtcg" style="width: 320px;">
			 <tr>
                    <td style="width: 100px; height: 25px">
                       <input type="radio" id="mgmtmode" name="mgmtmode"  value="new" checked="checked" onclick="addKpigroup();"/>추가</input>
                        <input type="radio" id="mgmtmode" name="mgmtmode"  value="mod" onclick=""/>수정</input>
                    </td>
                    <td></td>
                </tr>
				<tr>
					<td style="width: 100px; height: 30px">
					   <label class="right inline required">▶지표대분류</label>
					</td>
					<td style="width: 100px; height: 30px">
					   <input type="hidden" id="mgmt-kpiGroup" data-bind="value:VALUE" style="border:none" readonly="readonly" />
					   <input type="hidden" id="mgmt-standardcode" data-bind="value:STANDARDCODE" style="border:none" />
					   <select id="mgmt-p_kpiGroup" data-bind="value:P_CMPGROUP" style="width:97%; text-align:center"></select>
					</td>
				</tr>
				<tr>
					<td style="width: 100px; height: 30px"><label class="right inline required">▶지표명</label></td>
					<td><input class="k-textbox" id="mgmt-kpiGroupName" data-bind="value:CMPGROUP_NAME" maxlength="20" size="40" style="width: 100px;" /></td>
				</tr>
				<tr>
                    <td style="width: 100px; height: 30px"><label class="right inline required">▶사용여부</label></td>
                    <td><input type="radio" id="mgmt-kpiGroupUseFlag" name="mgmt-kpiGroupUseFlag"  value="Y" />사용</input>
                        <input type="radio" id="mgmt-kpiGroupUseFlag" name="mgmt-kpiGroupUseFlag"  value="N"/>미사용</input></td>
                </tr>
			</table>
		</div>
			<div style="width:550px;text-align:right;float:left">
				<button id="kpigroup-save-btn" class="k-button">
					<span class="k-icon k-i-plus"></span>저장
				</button>
			</div>
	</div>

	<div id="excel-upload-window" style="display: none; width: 400px;">
        <form method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/admin/ca/ca_kpi_excel_upload.do?">
            <!-- ※ 템플릿을 다운 받아 지표정보를 작성 후 업로드 하세요<br> -->
            ※ 지표 코드는 아래 내용을 참고하여 작성하세요<br><BR>
            ※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.       
            <div>
                <input name="files" id="files" type="file" /> </br>
                <div style="text-align: right;">
                    <input type="submit" value="엑셀 업로드" class="k-button" id="uploadBtn" />
                </div>
                <div id="kpigroupRefTreeview"   style="height: 200px; "></div>
            </div>
        </form>
    </div>
    
    
</body>
</html>