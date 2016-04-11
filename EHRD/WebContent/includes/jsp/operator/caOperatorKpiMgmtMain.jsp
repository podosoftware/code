<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>성과관리</title>
	
	<script type="text/javascript">

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
          
              
              var dataSource_unit = new kendo.data.DataSource({
                  type: "json",
                  transport: {
                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
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
              
             var dataSource_type = new kendo.data.DataSource({
                  type: "json",
                  transport: {
                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                      parameterMap: function (options, operation){  
                        return {  STANDARDCODE : "C106" };
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
              
             
             var dataSource_meaEvlCyc = new kendo.data.DataSource({
                 type: "json",
                 transport: {
                     read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                     parameterMap: function (options, operation){  
                       return {  STANDARDCODE : "C107" };
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
             
              // list call
              openwindow();
              
              
              
        	  $("#kpiUnit").kendoComboBox({
                  dataTextField: "TEXT",
                  dataValueField: "VALUE",
                  dataSource: dataSource_unit,
                  filter: "contains",
                  suggest: true,
                  placeholder : "" ,
              });
         	  
         	 $("#kpiType").kendoComboBox({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_type,
                 filter: "contains",
                 suggest: true,
                 placeholder : "" ,
             });
         	 
         	$("#kpiMeaEvlCyc").kendoComboBox({
                dataTextField: "TEXT",
                dataValueField: "VALUE",
                dataSource: dataSource_meaEvlCyc,
                filter: "contains",
                suggest: true,
                placeholder : "" ,
            });      
              
               // list new btn add click event
               $("#newBtn").click( function(){
                    
                   $("#splitter").data("kendoSplitter").expand("#detail_pane");
                   
                   // show detail 
                   $('#details').show().html(kendo.template($('#template').html()));
                    
                   kendo.bind( $(".tabular"),  null );                    
  
                    
                   
                   $("#kpiUnit").kendoComboBox({
                       dataTextField: "TEXT",
                       dataValueField: "VALUE",
                       dataSource: dataSource_unit,
                       filter: "contains",
                       suggest: true,
                       placeholder : "" ,
                   });
                   
                   $("#kpiType").kendoComboBox({
                       dataTextField: "TEXT",
                       dataValueField: "VALUE",
                       dataSource: dataSource_type,
                       filter: "contains",
                       suggest: true,
                       placeholder : "" ,
                   });
                   
                   $("#kpiMeaEvlCyc").kendoComboBox({
                       dataTextField: "TEXT",
                       dataValueField: "VALUE",
                       dataSource: dataSource_meaEvlCyc,
                       filter: "contains",
                       suggest: true,
                       placeholder : "" ,
                   });  
                   
                   $("#evlHowDetailArea").hide();
                   
                    $('input:radio[id=useFlag]:input[value=Y]').attr("checked", true);//사용여부
                    
                    buttonEvent();
                    
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
	
	
	// 고객사정보 상세보기.
    function fn_detailView(kpiNumber){
		
          var dataSource_unit = new kendo.data.DataSource({
              type: "json",
              transport: {
                  read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
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
          
         var dataSource_type = new kendo.data.DataSource({
              type: "json",
              transport: {
                  read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                  parameterMap: function (options, operation){  
                    return {  STANDARDCODE : "C106" };
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
          
         
         var dataSource_meaEvlCyc = new kendo.data.DataSource({
             type: "json",
             transport: {
                 read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                 parameterMap: function (options, operation){  
                   return {  STANDARDCODE : "C107" };
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
		
    	var grid = $("#grid").data("kendoGrid");
        var data = grid.dataSource.data();

        var selectedCell;
        for(var i = 0; i<data.length; i++) {
            var dataItem = data[i];
            if(kpiNumber == dataItem.KPI_NO){
            	selectedCell = dataItem;
            	                
                var selectRow =  {
                		MODE : "mod",
                		COMPANYID: selectedCell.COMPANYID,                 
                		KPI_NO :selectedCell.KPI_NO, 
              			KPI_NM: selectedCell.KPI_NM,           
              			KPI_TYPE : selectedCell.KPI_TYPE,   
              			EVL_TYPE : selectedCell.EVL_TYPE,
              			MEA_EVL_CYC : selectedCell.MEA_EVL_CYC,
              			EVL_HOW: selectedCell.EVL_HOW,
              			EVL_HOW_STRING: selectedCell.EVL_HOW_STRING,  
              			UNIT : selectedCell.UNIT,    
              			CAP : selectedCell.CAP,  
              			TARGET : selectedCell.TARGET,  
              			THRESHOLD : selectedCell.THRESHOLD,  
              			TARGET_SET_WRNT : selectedCell.TARGET_SET_WRNT,
              			DATASOURCE : selectedCell.DATASOURCE,
              			MGMT_DEPT : selectedCell.MGMT_DEPT,
              			USEFLAG: selectedCell.USEFLAG,
              			CREATETIME: selectedCell.CREATETIME_STRING,
              			MODIFYTIME: selectedCell.MODIFYTIME_STRING,
              			ADD_FLAG : selectedCell.ADD_FLAG,
              			REG_TYPE_CD : selectedCell.REG_TYPE_CD,
              			REG_TYPE_CD_STRING: selectedCell.REG_TYPE_CD_STRING,
              			CREATER : selectedCell.CREATER,
              			NAME : selectedCell.NAME
              	 };
                
                $("#splitter").data("kendoSplitter").expand("#detail_pane");
                
                // show detail 
				 $('#details').show().html(kendo.template($('#template').html()));
                            
               
	         	 // dtl save btn add click event
	          	 buttonEvent();
	          	
	          	 $("#evlHowArea").hide();
	          	 
             	 // detail binding data
                kendo.bind( $(".tabular"), selectRow );
             	 
                
                $("#kpiUnit").kendoComboBox({
                    dataTextField: "TEXT",
                    dataValueField: "VALUE",
                    dataSource: dataSource_unit,
                    filter: "contains",
                    suggest: true,
                    placeholder : "" ,
                });
                
                $("#kpiType").kendoComboBox({
                    dataTextField: "TEXT",
                    dataValueField: "VALUE",
                    dataSource: dataSource_type,
                    filter: "contains",
                    suggest: true,
                    placeholder : "" ,
                });
                
                $("#kpiMeaEvlCyc").kendoComboBox({
                    dataTextField: "TEXT",
                    dataValueField: "VALUE",
                    dataSource: dataSource_meaEvlCyc,
                    filter: "contains",
                    suggest: true,
                    placeholder : "" ,
                });  
             	 
                
                
                
                $('input:radio[id=evlType]:input[value='+selectedCell.EVL_TYPE+']').attr("checked", true);//Characteristic
                $('input:radio[id=evlHow]:input[value='+selectedCell.EVL_HOW+']').attr("checked", true);//관리유형
                $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//사용여부
                
                $("#delBtn").show();
                
                if($(':radio[id="regTypeCd"]:checked').val()==1){
                    $("#createrTr").hide();
                    $("#changeTypeBtn").hide();
                }else{
                    $("#createrTr").show();
                    $("#changeTypeBtn").show();
                }
                
                
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
	                    $("#changeTypeBtn").show();
	                    $("#regTypeCd").show();
					}else if(obj.statement == 'N'){
						$("#newBtn").hide();
						$("#changeTypeBtn").hide();
                        $("#regTypeCd").hide();
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
	
    function buttonEvent(){
    	
    	// dtl del btn add click event
       	$("#delBtn").click( function(){
       	    
        	var isDel = confirm("삭제 하시겠습니까?");
            if(isDel){
        		var params = {
        			KPINUMBER : $("#kpiNumber").val(),
        			FLAG : "13",
         		};
        		
        		$.ajax({
        			type : 'POST',
					url:"/operator/ca/ca_common_del.do?output=json",
					data : { item: kendo.stringify( params ) },
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
						if(obj.saveCount != 0){
							$("#grid").data("kendoGrid").dataSource.read();		
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
    	
    	//회사지표로 사용하기.
    	$("#changeTypeBtn").click(function(){
    		var isDel = confirm("회사지표로 사용하시겠습니까?");
            if(isDel){
                var params = {
                    KPINUMBER : $("#kpiNumber").val()
                };
                
                $.ajax({
                    type : 'POST',
                    url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_kpi_change_regtype_save.do?output=json",
                    data : { item: kendo.stringify( params ) },
                    complete : function( response ){
                        var obj  = eval("(" + response.responseText + ")");
                        if(obj.saveCount > 0){
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
    	})
    	
		// dtl save btn add click event
       	$("#saveBtn").click( function(){
       	  
        	if($("#kpiName").val()=="") {
        		alert("지표명을 입력해 주십시오.");
        		return false;
        	}
        	if($("#kpiType").val()=="") {
        		alert("지표유형을 선택해주세요");
        		return false;
        	}  
        	if($("#kpiMeaEvlCyc").val()=="") {
        		alert("관리주기를 선택해주세요");
        		return false;
        	} 
        	if($(':radio[id="evlType"]:checked').val()==null) {
        		alert("Characteristic을 체크해주세요");
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
        	
        	var isDel = confirm("성과정보를 저장하시겠습니까?");
            if(isDel){
        		var params = {
        			KPINUMBER : $("#kpiNumber").val(),
                    KPINAME : $("#kpiName").val(),
                    KPITYPE : $("#kpiType").val(), 
                    MEAEVLCYC : $("#kpiMeaEvlCyc").val(), 
                    EVLTYPE : $(':radio[id="evlType"]:checked').val(),
                    EVLHOW : $(':radio[id="evlHow"]:checked').val(),
                    UNIT : $("#kpiUnit").val(), 
                    CAP : $("#cap").val(),
                    TARGET : $("#target").val(),
                    THRESHOLD : $("#threshold").val(),
                    TARGET_SET_WRNT : $("#targetSetWrnt").val(),
                    DATASOURCE : $("#dataSource").val(),
                    MGMT_DEPT : $("#mgmtDept").val(),
        			USEFLAG : $(':radio[id="useFlag"]:checked').val() 
         		};
        		
        		$.ajax({
        			type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_kpi_save.do?output=json",
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
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_kpi_list.do?output=json", type:"POST" },
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
	                        	   KPI_NM : { type: "string" },
	                        	   KPI_TYPE : { type: "string" },
	                        	   EVL_TYPE : { type: "string" },
	                        	   MEA_EVL_CYC : { type: "string" },
	                        	   EVL_HOW: { type: "string" },
	                        	   UNIT : { type: "string" },
	                        	   USEFLAG : { type: "string" },
	                        	   USEFLAG_STRING : { type: "string" },
	                        	   EVL_HOW_STRING : { type: "string" },
	                        	   KPI_TYPE_STRING : { type: "string" },
	                        	   MEA_EVL_CYC_STRING : { type: "string" },
	                        	   UNIT_STRING : { type: "string" },
	                        	   ADD_FLAG : { type: "string" }
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
	                       field: "KPI_NO",
	                       filterable:false,
	                       title: "지표번호",
						   width:80,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						   attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },
	                   {
	                       field: "KPI_NM", 
	                       title: "지표명",
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:left;text-decoration: underline;"},
	                       template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${KPI_NO});' >${KPI_NM}</a>"
	                   },
	                   {
	                       field: "KPI_TYPE_STRING",
	                       title: "지표유형",
						   width:100,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:left"} 
	                   },
	                   {
	                       field: "MEA_EVL_CYC_STRING",
	                       title: "관리주기",
						   width:100,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:left"} 
	                   },
	                   {
	                       field: "UNIT_STRING",
	                       title: "단위",
						   width:80,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:left"} 
	                   },
                       {
                           field: "NAME",
                           title: "등록자",
                           width:80,
                           headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                           attributes:{"class":"table-cell", style:"text-align:left"} 
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
	               pageable: {  pageSizes:false,  messages: { display: ' {1} / {2}' }  }
	           });	   
	       	
	       	$("#grid").data('kendoGrid').dataSource.fetch(function(){
	       		var rtc  = $(':radio[id="regTypeCd"]:checked').val();
	            filterData(rtc);
	        });
	       	
	       	
	       }     
 
       
       //회사지표 or 개인입력지표 필터링
       function filterData(cn){
    	    var grid = $("#grid").data('kendoGrid');
    	    
   	        grid.dataSource.filter({
   	            "field":"REG_TYPE_CD",
   	            "operator":"eq",
   	            "value":cn
   	        });
   	        
			if(cn == 1){
                $("#grid").data("kendoGrid").hideColumn(5);
			}else{
				$("#grid").data('kendoGrid').showColumn(5);
			}
   	    }
       
	</script>
	
</head>
<body>

	<!-- START MAIN CONTNET -->
	<div id="content">
        <div class="cont_body">
            <div class="title mt30">성과관리</div>
            <div class="table_zone" >
                <div class="table_btn">
                    <div style="float:left; margin-left: 15px; margin-top: 10px; ">
                        <input type="radio" value="1" id="regTypeCd" name="regTypeCd" checked onclick="filterData(1);"> 회사지표 <input type="radio" value="2" id="regTypeCd" name="regTypeCd" style="margin-left:15px;" onclick="filterData(2);"> 개인입력지표
                    </div>
                    <div>
                        <a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_operator_kpi_list_excel.do" >엑셀 다운로드</a>&nbsp
                        <button id="newBtn" class="k-button" ><span class="k-icon k-i-plus"></span>추가</button>
                    </div>
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
	<!-- 개발중 -->
	<script type="text/x-kendo-template" id="template">
					<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
					<tr><td colspan="2" style="font-size:16px;"> <strong>&nbsp; 성과관리 </strong>
						<input type="hidden" id="comapnyId" data-bind="value:COMPANYID" style="border:none" readonly="readonly" />
			    		<input type="hidden" id="kpiNumber" data-bind="value:KPI_NO" style="border:none" readonly="readonly" />
						<input type="hidden" id="cudMode" data-bind="value:MODE" style="border:none" readonly="readonly" />
					</td></tr>
                    <tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 지&nbsp&nbsp표&nbsp&nbsp명 <span style="color:red">*</span></td>
				    	<td class="subject"><input type="text" class="k-textbox" id="kpiName" data-bind="value:KPI_NM" style="width:97%;" onKeyUp="chkNull(this);" />			
						</td>
						
			    	</tr>				
					<tr>
                        <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 지표유형 <span style="color:red">*</span></td>
                        <td class="subject"><input type="text" id="kpiType" data-bind="value:KPI_TYPE" style="width:96%; text-align:left"></select><BR>
						※ 지표유형은 기본관리 -> 공통코드관리에서 카테고리를 지표유형(성과평가)로 선택하시어 등록하시면 됩니다.
						</td>
                    </tr>
					<tr>
                        <td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리주기 <span style="color:red">*</span></td>
                        <td class="subject"><input type="text" id="kpiMeaEvlCyc" data-bind="value:MEA_EVL_CYC" style="width:96%; text-align:left"></select></td>
                    </tr>
					<tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Characteristic <span style="color:red">*</span></td> 
				    	<td class="subject"><input type="radio" id="evlType" name="evlType"  value="1"/> 정량</input>
					 	<span style="padding-left:70px"><input type="radio" id="evlType" name="evlType"  value="2"/> 정성</input></td>
			    	</tr>		
					<tr id="evlHowArea">
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리유형 <span style="color:red">*</span></td> 
				    	<td class="subject"><input type="radio" id="evlHow" name="evlHow"  value="1" /> 합계</input>
					 	&nbsp&nbsp&nbsp&nbsp<input type="radio" id="evlHow" name="evlHow"  value="2"/> 평균</input>
						&nbsp&nbsp&nbsp&nbsp<input type="radio" id="evlHow" name="evlHow"  value="3"/> 누적</input></td>
			    	</tr>	
				    <tr id="evlHowDetailArea">
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리유형</td> 
						<td class="subject"><input type="text" id="createTime" data-bind="value:EVL_HOW_STRING" style="border:none" readonly="readonly" /></td>
			    	</tr>					
					<tr>
                        <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 단위</td>
                        <td class="subject"><input type="text" id="kpiUnit" data-bind="value:UNIT" style="width:80px; text-align:left"></input></td>
                    </tr>
					 <tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Cap </td>
				    	<td class="subject"><input type="text" class="k-textbox" id="cap" data-bind="value:CAP" style="width:97%;" onKeyUp="chkNull(this), chkNum (this);" />			
						</td>
			    	</tr>
					 <tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Target </td>
				    	<td class="subject"><input type="text" class="k-textbox" id="target" data-bind="value:TARGET" style="width:97%;" onKeyUp="chkNull(this), chkNum (this);" />			
						</td>
			    	</tr>	
					 <tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Threshold </td>
				    	<td class="subject"><input type="text" class="k-textbox" id="threshold" data-bind="value:THRESHOLD" style="width:97%;" onKeyUp="chkNull(this), chkNum (this);" />			
						</td>
			    	</tr>
					<tr>
				    	<td width="100px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Target 설정근거 </td>
				    	<td class="subject"><textarea cols="40" rows="4"  type="text" id="targetSetWrnt" data-bind="value:TARGET_SET_WRNT" style="width:96%;" ></textarea></td>
			    	</tr>
					<tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> Data Source </td>
				    	<td class="subject"><input type="text" class="k-textbox" id="dataSource" data-bind="value:DATASOURCE" style="width:97%;" onKeyUp="chkNull(this);" />			
						</td>						
			    	</tr>
					<tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 관리부서 </td>
				    	<td class="subject"><input type="text" class="k-textbox" id="mgmtDept" data-bind="value:MGMT_DEPT" style="width:97%;" onKeyUp="chkNull(this);" />			
						</td>						
			    	</tr>
			    	<tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부</td> 
				    	<td class="subject"><input type="radio" id="useFlag" name="useFlag"  value="Y" /> 사용</input>
					 	<span style="padding-left:70px"><input type="radio" id="useFlag" name="useFlag"  value="N"/> 미사용</input></td>
			    	</tr>
			    	<tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 등&nbsp&nbsp록&nbsp&nbsp일</td> 
				    	<td class="subject"><input type="text" id="createTime" data-bind="value:CREATETIME" style="border:none" readonly="readonly" /></td>
			    	</tr>
                    <tr id="createrTr">
                        <td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 등&nbsp&nbsp록&nbsp&nbsp자</td> 
                        <td class="subject"><input type="text" id="creatername" data-bind="value:NAME" style="border:none" readonly="readonly" /></td>
                    </tr>
			    	<tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 마지막 수정일</td> 
				    	<td class="subject"><input type="text" id="modifyTime" data-bind="value:MODIFYTIME" style="border:none" readonly="readonly" /></td>
			    	</tr>
			    	<tr>
			    		<td colspan="2" align="right">
							<div style="text-align: right;">
			    			   <button id="changeTypeBtn" class="k-button">회사지표로사용</button>&nbsp;
                               <button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
							   <button id="delBtn" class="k-button">삭제</button>&nbsp;
			    			   <button id="cencelBtn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>
							</div>
			    		</td>			    	
			    	</tr>
				</table>
		</script>			
		    
</body>
</html>