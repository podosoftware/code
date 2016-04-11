<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
filename : baCmmMain.jsp
note : 공통 > 공통코드관리
 --%>
<html decorator="operatorSubpage">
<head>
<title>공통코드 관리</title>
	<script type="text/javascript">
	var standardCode = "";
	// 직무관리 상세보기.
    function fn_detailView(rows){
		
        //카테고리
   	    var codeCategoryDS = new kendo.data.DataSource({
              type: "json",
              transport: {
                  read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/brd_category_list.do?output=json", type:"POST" },
                  parameterMap: function (options, operation) {
                  		return { }; 
                  }
         },
         schema: {
			data: "items",
            model: { fields: { VALUE : { type: "String" }, TEXT : { type: "String" } } }
         },
         serverFiltering: false,
         serverSorting: false});
    	  
          
   	    //부모카테고리
  	  	var categoryParentDS = new kendo.data.DataSource({
              type: "json",
              transport: {
                  read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/brd_category_parent_list.do?output=json", type:"POST" },
                  parameterMap: function (options, operation) {
                  		return { };
                  }
         },
         schema: {
			data: "items",
            model: { fields: { VALUE : { type: "String" }, TEXT : { type: "String" } } }
         },
         serverFiltering: false,
         serverSorting: false});
    	       	  
   	    
		//부모코드
  	  var categoryParentCodeDS = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/brd_category_parent_code_list.do?output=json", type:"POST" },
                parameterMap: function (options, operation) {
                		return { parentStandardCode: $("#dtl-parentstandardcode").val() };
                }
       },
       schema: {
			data: "items",
          model: { fields: { VALUE : { type: "String" }, TEXT : { type: "String" } } }
       },
       serverFiltering: false,
       serverSorting: false}); 
		
   	    
    	
    	var grid = $("#grid").data("kendoGrid");
        var data = grid.dataSource.data();

        var selectedCell;
        for(var i = 0; i<data.length; i++) {
            var dataItem = data[i];
            if(rows == dataItem.ROWNUMBER){
            	selectedCell = dataItem;
   				var selectRow =  {
					MODE: "mod",
               		COMPANYID: selectedCell.COMPANYID,                 
               		STANDARDCODE :selectedCell.STANDARDCODE,         
               		STN_CODENAME :selectedCell.STN_CODENAME,         
               		COMMONCODE: selectedCell.COMMONCODE,   
               		CMM_CODENAME: selectedCell.CMM_CODENAME,             
               		CD_STARTVALUE: selectedCell.CD_STARTVALUE,           
               		CD_ENDVALUE : selectedCell.CD_ENDVALUE,          
               		CD_VALUE1 : selectedCell.CD_VALUE1,          
               		CD_VALUE2 : selectedCell.CD_VALUE2,   
               		CD_VALUE3 : selectedCell.CD_VALUE3,
               		CD_VALUE4 : selectedCell.CD_VALUE4,
               		CD_VALUE5 : selectedCell.CD_VALUE5,
               		PARENT_STANDARDCODE: selectedCell.PARENT_STANDARDCODE,
               		PARENT_COMMONCODE: selectedCell.PARENT_COMMONCODE,
               		USEFLAG: selectedCell.USEFLAG,
                    //SUBELEMENT_NUM: selectedCell.SUBELEMENT_NUM,
                	CREATETIME: selectedCell.CREATETIME,
                	MODIFYTIME: selectedCell.MODIFYTIME
				};
    				
  				// 상세영역 활성화
  				$("#splitter").data("kendoSplitter").expand("#detail_pane");
  				$("#detail_pane").show();
				$("#checkValue").val("Y");
  	         	$("#checkBtn").show();
  	         	$("#dtl-code").attr('readonly',false);
  	         	        	         	     
				// detail binding data
				kendo.bind( $(".tabular"), selectRow );
 
  	         	// create ComboBox from input HTML element
  	         	$("#dtl-parentstandardcode").kendoComboBox({
         	        dataTextField: "TEXT",
         	        dataValueField: "VALUE",
         	        dataSource: categoryParentDS,
         	        filter: "contains",
         	        suggest: true,
         	        placeholder : "" ,
         	        change: function() {
         	        	$("#dtl-parentcommoncode").kendoComboBox({
    	         	        dataTextField: "TEXT",
    	         	        dataValueField: "VALUE",
    	         	        dataSource: categoryParentCodeDS,
    	         	        filter: "contains",
    	         	        suggest: true,
    	         	      	placeholder : "" 
    	         	     });
         	        	
         	        	$("#dtl-parentcommoncode").data("kendoComboBox").value("");
	                },
	                index: 0
				});
  	         	    
 	         	// create ComboBox from input HTML element
				$("#dtl-parentcommoncode").kendoComboBox({
         	        dataTextField: "TEXT",
         	        dataValueField: "VALUE",
         	        dataSource: categoryParentCodeDS,
         	        filter: "contains",
         	        suggest: true,
         	      	placeholder : "" ,
         	        index: 0
         	    });
  	              	 
                $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//사용여부
  	                 
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

	function openwindow() {
		$("#grid").empty();
		
		$("#grid").kendoGrid({
			dataSource: {
				type: "json",
				transport: {
					read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-list.do?output=json", type:"POST" },
					parameterMap: function (options, operation){
						return {  
							//startIndex: options.skip, pageSize: options.pageSize  
						};
					}
				},
				schema: {
					total: "totalItemCount",
					data: "items",
					model: {
						id : 'ROWNUMBER',
						fields: {
							COMPANYID : { type: "int" },
							STANDARDCODE : { type: "string" },
							STN_CODENAME : { type: "string" },
							COMMONCODE : { type: "string" },
							CMM_CODENAME : { type: "string" },
							CD_STARTVALUE : { type: "string" },
							CD_ENDVALUE : { type: "string" },
							CD_VALUE1 : { type: "string" },
							CD_VALUE2 : { type: "string" },
							CD_VALUE3 : { type: "string" },
							CD_VALUE4 : { type: "string" },
							CD_VALUE5 : { type: "string" },
							PARENT_STANDARDCODE : { type: "string" },
							PARENT_COMMONCODE : { type: "string" },
							USEFLAG : { type: "string" },
							CREATETIME : { type: "string" },
							MODIFYTIME : { type: "string" },
							ROWNUMBER : { type: "string" }
						}
					}
				},
				pageSize: 30, serverPaging: false, serverFiltering: false, serverSorting: false
			},
			columns: [
				{ field:"STN_CODENAME", title: "카테고리", filterable: true, width:"120px",
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
					attributes:{"class":"table-cell", style:"text-align:left"} },
				{ field:"COMMONCODE", title: "코드", filterable: true, width:"100px",
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
					attributes:{"class":"table-cell", style:"text-align:left"} },
				{ field:"CMM_CODENAME", title: "코드명", filterable: true, width:"200px",
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
					attributes:{"class":"table-cell", style:"text-align:left;text-decoration: underline;"},
					template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${ROWNUMBER});' >${CMM_CODENAME}</a>"
				},
				{ field: "USEFLAG_STRING", title: "사용여부", width:"80px",
					headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
					attributes:{"class":"table-cell", style:"text-align:left"} },
			],
			filterable: {
				extra : false,
				messages : {filter : "필터", clear : "초기화"},
				operators : { 
					string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
					number : { eq : "같음", gte : "이상", lte : "이하"}
				}
			}, 
			sortable: true, pageable: true,
			pageable: { pageSizes:false,  messages: { display: ' {1} / {2}' }  }
	
		});
	}
</script>
<script type="text/javascript">               
	yepnope([{
		load: [ 
  			'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
			'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
       	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
       	 	'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
      	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js',
      	  	'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',
      	  	'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.js'
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
  				panes : [
					{ collapsible : true, 
						min : "500px" 
					}, 
					{ collapsible : true, 
						collapsed : true, 
						min : "500px" 
					}
  				]
  			});
              
            //카테고리
       	    var codeCategoryDS = new kendo.data.DataSource({
                type: "json",
                 transport: {
					read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/brd_category_list.do?output=json", type:"POST" }
             	},
             	schema: {
					data: "items",
                	model: { fields: { VALUE : { type: "String" }, TEXT : { type: "String" } } }
             	},
             	serverFiltering: false,
             	serverSorting: false
			});
        	  
              
       	    //부모카테고리
      	  	var categoryParentDS = new kendo.data.DataSource({
                type: "json",
                transport: {
                	read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/brd_category_parent_list.do?output=json", type:"POST" }
             	},
             	schema: {
					data: "items",
                	model: { fields: { VALUE : { type: "String" }, TEXT : { type: "String" } } }
             	},
             	serverFiltering: false,
             	serverSorting: false
			});
       	    
			//부모코드
			var categoryParentCodeDS = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/brd_category_parent_code_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation) {
                    		return { parentStandardCode: $("#dtl-parentstandardcode").val() };
                    }
	           	},
	           	schema: {
					data: "items",
	              	model: { fields: { VALUE : { type: "String" }, TEXT : { type: "String" } } }
	           	},
	           	serverFiltering: false,
	           	serverSorting: false
           	}); 
        	          	  
        	// list call
			openwindow();

            // create ComboBox from input HTML element
       	    $("#dtl-standardcode").kendoComboBox({
       	        dataTextField: "TEXT",
       	        dataValueField: "VALUE",
       	        dataSource: codeCategoryDS,
       	        filter: "contains",
       	        suggest: true,
       	        index: 0,
       	        change: function() {
       	        	$("#checkValue").val("N");
				}
			});
              
			// create ComboBox from input HTML element
     	   	$("#dtl-parentstandardcode").kendoComboBox({
				dataTextField: "TEXT",
     	        dataValueField: "VALUE",
     	        dataSource: categoryParentDS,
     	        filter: "contains",
     	        suggest: true,
     	        placeholder : "" ,
     	        change: function() {
     	        	//부모카테고리 변경시 부모코드 재조회
     	        	var categoryParentCodeDS = new kendo.data.DataSource({
  	                  	type: "json",
  	                  	transport: {
  	                      	read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/brd_category_parent_code_list.do?output=json", type:"POST" },
  	                      	parameterMap: function (options, operation) {
  	                      		return { parentStandardCode: $("#dtl-parentstandardcode").val() };
  	             	        }
  	            		 },
  	            		 schema: {
  							data: "items",
  	            		    model: { fields: { VALUE : { type: "String" }, TEXT : { type: "String" } } }
  	           	 	 	},
  	           	 	 	serverFiltering: false,
  	           	 	 	serverSorting: false
					});

					$("#dtl-parentcommoncode").kendoComboBox({
         	        	dataTextField: "TEXT",
         	        	dataValueField: "VALUE",
         	        	dataSource: categoryParentCodeDS,
         	        	filter: "contains",
         	        	suggest: true,
         	      		placeholder : "" 
         	     	});     	        	
				},
	            index: 0
			});

        	 
             
	   /*
	   ###############buttonEvent#################
	   */
	          
		// dtl save btn add click event
		$("#checkBtn").click( function(){
   			var code = $("#dtl-code").val();
   		   	
   			if($("#dtl-standardcode").val()=="" ) {
     			alert("카테고리를 입력해주세요.");
     			return false;
      		}
    			
       		if(code=="") {
       			alert("코드를 입력해주세요.");
       			return false;
       		}
       		
       		if(code.substring(0,1)==0){
       			alert("코드는 0으로 시작될 수 없습니다 Ex)01,002,0003 불가");
       			return false;
       		}
       		
       		$.ajax({
       			type : 'POST',
       			dataType : "json",
       			url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_code_check.do?output=json",
       			data : { STANDARDCODE: $("#dtl-standardcode").val(), CHECKCODE: $("#dtl-code").val() },
 				success : function( response ){
 					if(response.checkFlag == 'Y') {
 						$("#checkValue").val("Y");
 						alert("사용하실 수 있는 코드입니다.");
 					} else {
 						alert("이 코드는 사용하실 수 없습니다.");
 						$("#checkValue").val("N");
  						$("#dtl-code").val("");
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
 				}
   			});
   		});
             
             
		// list new btn add click event
		$("#new-btn").click( function(){
       	  	$("#checkBtn").show();
       	  	$("#dtl-code").attr('readonly',false);
       		 			  	
		  	$("#checkValue").val("N");

		  	kendo.bind( $(".tabular"), null ); 

       	    // create ComboBox from input HTML element
       	    $("#dtl-parentcommoncode").kendoComboBox({
       	        dataTextField: "TEXT",
       	        dataValueField: "VALUE",
       	        dataSource: categoryParentCodeDS,
       	        filter: "contains",
       	        suggest: true,
       	      	placeholder : "" ,
       	        index: 0
       	    });

       	    $("#dtl-mode").val("add");
       	    $("#dtl-parentstandardcode").data("kendoComboBox").value("");
       	    $("#dtl-parentcommoncode").data("kendoComboBox").value("");
       	    
       	    $('input:radio[id=useFlag]:input[value=Y]').attr("checked", true);//사용여부
       	    
       	 	// 상세영역 활성화
			$("#splitter").data("kendoSplitter").expand("#detail_pane");
			$("#detail_pane").show();
       	    
			$("#delBtn").hide();
		});
			
 			
	    	// dtl del btn add click event
	       	$("#delBtn").click( function(){
	        	var isDel = confirm("삭제 하시겠습니까?");
	            if(isDel){
	        		var params = {
	        			standardcode : $("#dtl-standardcode").val(),
	        			code : $("#dtl-code").val(),
	        			FLAG : "9",
	         		};
	        		
	        		$.ajax({
	        			type : 'POST',
						url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_del.do?output=json",
						data : { item: kendo.stringify( params ) },
						complete : function( response ){
							var obj  = eval("(" + response.responseText + ")");
							if(obj.saveCount != 0){
								$("#grid").data('kendoGrid').dataSource.read();
								
					      		kendo.bind( $(".tabular"),  null );
					      		
					      		// 상세영역 비활성화
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
			$("#save-btn").click( function(){
	       		if($("#dtl-standardcode").val()=="" ) {
	       			alert("카테고리를 입력해주세요.");
	       			return false;
	       		}else if( $("#dtl-code").val()==""){
	       			alert("코드를 입력해주세요");
	       			return false;
	       		}else if($("#checkValue").val() == "N"){
	       			alert("코드 중복체크를 해주세요.");
	       			return false;
	       		}else if($("#dtl-codename").val() == ""){
	       			alert("코드명을 입력해주세요.");
	       			return false;
	       		}
				
				var isDel = confirm("공통코드를 저장하시겠습니까?");
				if(isDel){
		       		var params = {
		       			mode : $("#dtl-mode").val(),
						standardcode : $("#dtl-standardcode").val(),
						code : $("#dtl-code").val(),
						codename : $("#dtl-codename").val(),
						svalue : $("#dtl-svalue").val(),
						evalue : $("#dtl-evalue").val(),
						value1 : $("#dtl-value1").val(),
						value2 : $("#dtl-value2").val(),
						value3 : $("#dtl-value3").val(),
						value4 : $("#dtl-value4").val(),
						value5 : $("#dtl-value5").val(),
						parentstandardcode : $("#dtl-parentstandardcode").val(),
						parentcommoncode : $("#dtl-parentcommoncode").val(),
						useflag : $(':radio[id="useFlag"]:checked').val()
		            };
		       		
		       		$.ajax({
		       			type : 'POST',
						url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-setdata.do?output=json",
						data : { params: kendo.stringify( params ) },
						success : function( response ){
							$("#grid").data('kendoGrid').dataSource.read();
							
				      		kendo.bind( $(".tabular"),  null );
				      		
				      		// 상세영역 비활성화
				      		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
				      		$("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
							
							alert("저장되었습니다.");
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
	     	$("#cencel-btn").click( function(){
	      		kendo.bind( $(".tabular"),  null );
	      		 
	      		$("#dtl-mode").val("");
	      		
	      		// 상세영역 비활성화
	      		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
	      		$("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
	      	});
			
		}
      }]); 
	</script>
	<script>
		function numberEnglishsOnly(e,obj){
			//alert(obj.value);
			 if(event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46 ) return;
			 
			 obj.value = obj.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/g, '');
		}
	</script>
</head>
<body>
	<div id="content">
        <div class="cont_body">
            <div class="title mt30">공통코드관리</div>
            <div class="table_zone" >
                <div class="table_btn">
                    <button id="new-btn" class="k-button"><span class="k-icon k-i-plus"></span>등록</button>
                </div>
                <div class="table_list">
		            <div id="splitter" style="width:100%; height: 100%; border:none;">
		                <div id="list_pane">
						    <div id="grid" ></div>
						</div>
							<div id="detail_pane" style="display: none">
								<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
				                    <tr><td colspan="2" style="font-size:16px;">
				                        <strong>&nbsp; 공통코드관리 </strong>
										<input type="hidden" id="dtl-comapnyid" data-bind="value:COMPANYID" readonly="readonly" />
							    		<input type="hidden" id="dtl-mode" data-bind="value:MODE" readonly="readonly" />
							    		<input type="hidden" id="checkValue" value="N" readonly="readonly" />
									</td></tr>
									<tr>
								    	<td class="subject" width="100px"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 카테고리 <span style="color:red">*</span></td>
										<td class="subject"><select id="dtl-standardcode" data-bind="value:STANDARDCODE" style="width:80%;"></select></td>
							    	</tr>
									<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 코드 <span style="color:red">*</span></td>
										<td class="subject"><input type= "text" id="dtl-code" data-bind="value:COMMONCODE" onKeypress ="return numberEnglishsOnly(event,this)"  onKeyup ="return numberEnglishsOnly(event,this)" style='ime-mode:disabled;width:150px;' />
											<button id="checkBtn" class="k-button">중복검사</button>
										</td>
									</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 코드명 <span style="color:red">*</span></td>
								    	<td class="subject"><input type="text" id="dtl-codename" data-bind="value:CMM_CODENAME" style="width:80%;" onKeyUp="chkNull(this);"/></td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 범위시작값</td>
								    	<td class="subject"><input type="text" id="dtl-svalue" data-bind="value:CD_STARTVALUE" style="width:80%;" onKeyUp="chkNull(this);"/></td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 범위종료값</td>
								    	<td class="subject"><input type="text" id="dtl-evalue" data-bind="value:CD_ENDVALUE" style="width:80%;" onKeyUp="chkNull(this);"/></td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 값1</td> 
								    	<td class="subject"><input type="text" id="dtl-value1" data-bind="value:CD_VALUE1" style="width:80%;" onKeyUp="chkNull(this);"/><br>
								    	※ 카테고리가 '공통역량군'의 경우 'Y'를 넣어 주셔야 합니다.<br>
								    	※ 카테고리가 '상시학습종류'인 경우 인정시간 가중치(숫자만)를 입력해주세요.
								    	</td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 값2</td> 
								    	<td class="subject"><input type="text" id="dtl-value2" data-bind="value:CD_VALUE2" style="width:80%;" onKeyUp="chkNull(this);"/><br>
                                        ※ 카테고리가 '상시학습종류'인 경우 연간최대인정시간(숫자만)을 입력해주세요.</td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 값3</td> 
								    	<td class="subject"><input type="text" id="dtl-value3" data-bind="value:CD_VALUE3" style="width:80%;" onKeyUp="chkNull(this);"/><br>
                                        ※ 카테고리가 '상시학습종류'인 경우 코멘트를 입력해주세요.</td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 값4</td> 
								    	<td class="subject"><input type="text" id="dtl-value4" data-bind="value:CD_VALUE4" style="width:80%;" onKeyUp="chkNull(this);"/><br>
                                        ※ 카테고리가 '상시학습종류'인 경우 '이사람'의 상시학습종류코드(7자리코드)를 입력해주세요.</td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 값5</td> 
								    	<td class="subject"><input type="text" id="dtl-value5" data-bind="value:CD_VALUE5" style="width:80%;" onKeyUp="chkNull(this);"/><br>
                                        ※ 카테고리가 '상시학습종류'인 경우 인정시간 자동계산여부(Y/N)을 입력해주세요.</td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 부모카테고리</td> 
								    	<td class="subject"><select id="dtl-parentstandardcode" data-bind="value:PARENT_STANDARDCODE" style="width:80%"></select></td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 부모코드</td> 
								    	<td class="subject"><input type="text" id="dtl-parentcommoncode" data-bind="value:PARENT_COMMONCODE" style="width:80%"></select></td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부</td> 
								    	<td class="subject"><input type="radio" name="useFlag"  id="useFlag" value="Y" >사용
									 		<input type="radio" name="useFlag" id="useFlag" value="N">미사용
									 	</td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 등록일</td> 
								    	<td class="subject"><input type="text" id="dtl-credate" data-bind="value:CREATETIME" style="border:none" readonly="readonly"/></td>
							    	</tr>
							    	<tr>
								    	<td class="subject"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 수정일</td> 
								    	<td class="subject"><input type="text" id="dtl-moddate" data-bind="value:MODIFYTIME" style="border:none" readonly="readonly" /></td>
							    	</tr>
								</table>
								<table width="100%">
									<tr><td style="text-align:right">
										<button id="save-btn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
										<button id="delBtn" class="k-button">삭제</button>&nbsp;
							    		<button id="cencel-btn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>&nbsp;&nbsp;
									</td></tr>
							</table>
						</div>
		            </div>
		        </div>
	        </div>
        </div>
	</div>

	<!-- END MAIN CONTENT  --> 	
	<footer>
  	</footer>
</body>
</html>