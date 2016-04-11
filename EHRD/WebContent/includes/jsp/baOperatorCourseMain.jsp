<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page pageEncoding="UTF-8" isErrorPage="true"%>
<html decorator="operatorSubpage">
<head>
<title>과정정보관리</title>
<script type="text/javascript">
var qstnPoolIndex = 0;
	// 역량매핑정보 적용
	function setCmMap() {
		
		var params = {
     			LIST :  $('#sbjctMapGrid').data('kendoGrid').dataSource.data(),
     			LIST2 : $('#sbjctOpenGrid').data('kendoGrid').dataSource.data()  
        };
		
		$.ajax({
			type : 'POST',			
			url : "/mgmt/ca/save-sbjct-cm-map.do?output=json",
			data : {item: kendo.stringify( params ), subjectNum : $("#dtl-subjectNum").val(),
						SUBJECT_NAME : $("#SUBJECT_NAME").val(),
						TRAINING_CODE : $(':radio[id="TRAINING_CODE"]:checked').val(),
						INSTITUTE_NAME : $("#INSTITUTE_NAME").val(),
						EDU_TARGET : $("#EDU_TARGET").val(),
						EDU_OBJECT : $("#EDU_OBJECT").val(),
						COURSE_CONTENTS : $("#COURSE_CONTENTS").val(),
						USEFLAG : $(':radio[id="useFlag"]:checked').val()
					},
			complete : function( response ){
					var obj  = eval("(" + response.responseText + ")");
					if(obj.saveCount != 0){			
						
						// 상세영역 활성화
						$("#splitter").data("kendoSplitter").expand("#detail_pane");
						
						// 과정상세정보 호출
						$("#grid").data("kendoGrid").dataSource.read();
						
						//과정매핑상세정보 호출
						$("#sbjctMapGrid").data("kendoGrid").dataSource.read();
						
						alert("저장되었습니다.");	
					}else{
						alert("저장에 실패 하였습니다.");
					}							
				},
					error : function(xhr, ajaxOptions, thrownError) { 
				},
			dataType : "json"
		});
	}
	
	function newCmMap() {

		
		$.ajax({
			type : 'POST',			
			url : "/mgmt/ca/save-sbjct-cm-detail.do?output=json",
			data : {	subjectNum : $("#dtl-subjectNum").val(),
						SUBJECT_NAME : $("#SUBJECT_NAME").val(),
						TRAINING_CODE : $(':radio[id="TRAINING_CODE"]:checked').val(),
						INSTITUTE_NAME : $("#INSTITUTE_NAME").val(),
						EDU_TARGET : $("#EDU_TARGET").val(),
						EDU_OBJECT : $("#EDU_OBJECT").val(),
						COURSE_CONTENTS : $("#COURSE_CONTENTS").val(),
						USEFLAG : $(':radio[id="useFlag"]:checked').val()
					},
			complete : function( response ){
					var obj  = eval("(" + response.responseText + ")");
					if(obj.saveCount != 0){			
						
						// 상세영역 활성화
						$("#splitter").data("kendoSplitter").expand("#detail_pane");
						
						// 과정상세정보 호출
						$("#grid").data("kendoGrid").dataSource.read();
						
						$("#sbjctOpenGrid").data("kendoGrid").dataSource.read();
						
						//과정매핑상세정보 호출
						$("#sbjctMapGrid").data("kendoGrid").dataSource.read();
						
						alert("저장되었습니다.");	
					}else{
						alert("저장에 실패 하였습니다.");
					}							
				},
					error : function(xhr, ajaxOptions, thrownError) { 
				},
			dataType : "json"
		});
	}
	
	// detail area data call
	function callDetailEvent(val1, val2, val3) {
	
		$.ajax({
			type : 'POST',
			dataType : 'json',
			url : "/mgmt/sbjct/sbjct-info.do?output=json",
			data : {
				subjectNum : val1
			},
			success : function(response) {
				if (response.items != null) {
					$('input:radio[id=TRAINING_CODE]:input[value='+val2+']').attr("checked", true);
					$('input:radio[id=useFlag]:input[value='+val3+']').attr("checked", true);
					var selectRow = new Object();
					$.each(response.items, function(idx, item) {
	                  	$.each(item,function(key,val){
	    					selectRow[key] = val;
	    				});
					});
                  	
                  	kendo.bind($("#tabular"), selectRow);
                  	

				}
			},
			error : function(xhr, ajaxOptions, thrownError) { }
		});
		
		
	}

</script>
<script type="text/javascript">

// 상세보기.
function fn_detailView(subjectNum){
	var grid = $("#grid").data("kendoGrid");
    var data = grid.dataSource.data();

    var selectedCell;
    for(var i = 0; i<data.length; i++) {
        var dataItem = data[i];
        if(subjectNum == dataItem.SUBJECT_NUM){
        	selectedCell = dataItem;	
             
				if(selectedCell!=null && selectedCell.SUBJECT_NUM!=null) {
					$("#dtl-subjectNum").val(selectedCell.SUBJECT_NUM);
				
					// 상세영역 활성화
				
					$("#splitter").data("kendoSplitter").expand("#detail_pane");
					// 과정상세정보 호출
					$("#sbjctOpenGrid").data("kendoGrid").dataSource.read();
				
					//과정매핑상세정보 호출
					$("#sbjctMapGrid").data("kendoGrid").dataSource.read();
				
					$("#save-btn").show();
					$("#new-save-btn").hide();
					$("#sbjctOpenGridArea").show();
			     	$("#sbjctMapGridArea").show();
				
					callDetailEvent(selectedCell.SUBJECT_NUM, selectedCell.TRAINING_CODE, selectedCell.USEFLAG);
					

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

//문항 Pool 삭제
function singleDel(chasu, suvNo, rows, year){
	alert(rows);
		if (rows == "0"){
		
			var data = $("#sbjctOpenGrid").data("kendoGrid").dataSource.data();
		
			for(var i = 0; i<data.length; i++) {
	            var dataItem = data[i];
	            if(chasu == dataItem.CHASU){
            	
	            	$("#sbjctOpenGrid").data("kendoGrid").dataSource.remove(dataItem);
            	
	            }
			}
		}else{		
		$.ajax({
    			type : 'POST',
					url:"/mgmt/ca/del-sbjct-open.do?output=json",
					data : { SUBJECT_NUM: suvNo, YEAR: year, CHASU: chasu  },
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
						if(obj.saveCount != 0){	
							$('#sbjctOpenGrid').data("kendoGrid").dataSource.read();
						}else{
							alert("삭제 실패 하였습니다.");
						}							
					},
					error: function( xhr, ajaxOptions, thrownError){								
					},
					dataType : "json"
				});	
		}
		
   }	

	
	/*
	* INIT LIST AREA
	*/
	function initListArea() {
		$("#grid").empty();

		// 그리드 생성
		$("#grid").kendoGrid({
			dataSource : {
				type : "json",
				transport : {
					read : { url : "/mgmt/sbjct/sbjct-list.do?output=json", type:"POST" },
					parameterMap : function(options, operation) {
						var _year;
                    	if($("#year-combobox").data("kendoComboBox")!=null) _year = $("#year-combobox").data("kendoComboBox").value();
						return { startIndex:options.skip, pageSize:options.pageSize, year:_year };
					}
				},
				schema : {
					total : "totalItemCount",
					data : "items",
					model : {
						id : "SUBJECT_NUM",
						fields : {
							SUBJECT_NUM : { type : "string" },
							SUBJECT_NAME : { type : "string" },
							CM_LIST : { type : "string" },
							OPEN_STR : { type : "string" },
							TRAINING_STR : { type : "string" },
							EDU_DAY : { type : "number" },
							EDU_HOUR : { type : "number" },
							MAIN_CMNUM : { type : "number" },
							SUB_CMNUM : { type : "number" }
						}
					}
				},
				pageSize:30, serverPaging:false, serverFiltering:false, serverSorting:false
			},
			columns : [ 
				{ field : "SUBJECT_NAME", title:"교육명", width:"350px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:left"},
						template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${SUBJECT_NUM});' >${SUBJECT_NAME}</a>"
				},
				{ field : "TRAINING_STRING", title:"교육유형", width:"200px", 
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:center"} },
				{ field : "INSTITUTE_NAME", title:"교육기관", width:"80px", 
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:center"} },
			    { field : "USEFLAG", title:"사용여부", width:"80px", 
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:center"} }
			],
			filterable: {
				extra : false,
				messages : {filter : "필터", clear : "초기화"},
				operators : { 
					string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
					number : { eq : "같음", gte : "이상", lte : "이하"}
				}
			}, 
			sortable:true, pageable:true,
			pageable : { refresh : false, pageSizes : false, messages : { display : ' {1} / {2}' } },		
// 			change : function(e) {
// 				var selectedCells = this.select();
// 				var selectedCell = this.dataItem(selectedCells);
				
// 				if(selectedCell!=null && selectedCell.SUBJECT_NUM!=null) {
// 					$("#dtl-subjectNum").val(selectedCell.SUBJECT_NUM);
					
// 					// 상세영역 활성화
					
// 					$("#splitter").data("kendoSplitter").expand("#detail_pane");
// 					// 과정상세정보 호출
// 					$("#sbjctOpenGrid").data("kendoGrid").dataSource.read();
					
// 					//과정매핑상세정보 호출
// 					$("#sbjctMapGrid").data("kendoGrid").dataSource.read();
					
// 					$("#save-btn").show();
// 					$("#new-save-btn").hide();
// 					$("#sbjctOpenGridArea").show();
// 			     	$("#sbjctMapGridArea").show();
					
// 					callDetailEvent(selectedCell.SUBJECT_NUM, selectedCell.TRAINING_CODE, selectedCell.USEFLAG);
// 				}
// 			}
		});
		
		
		
		$("#year-combobox").kendoComboBox({
            dataTextField: "LABEL", dataValueField:"DATA",
            dataSource: {
                type: "json",
                transport: { read: { url:"/mgmt/sbjct/sbjct-year-list.do?output=json", type:"POST" } },
                schema: {
                	total: "totalItemCount",
                	data: "items",
                    model: { id:"DATA", fields:{ LABEL:{ type:"string" }, DATA:{ type:"number" } } }
                }
            },
            filter: "contains",
            index : 0
        });
		
     	  $("#uploadBtn").click( function() {	
            	$("#excel-upload-window").data("kendoWindow").close();
            	 
            } );
      	  
      	  
      	  if( !$("#excel-upload-window").data("kendoWindow") ){		

			    	$("#excel-upload-window").kendoWindow({
			    		width:"320px",
			    		minWidth:"320px",
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
		
	   	 $("#excelUploadBtn").click( function(){
			 $('#excel-upload-window').data("kendoWindow").center();      
	    	 $("#excel-upload-window").data("kendoWindow").open();
			
		 });
			
		$("#year-combobox").data("kendoComboBox").bind("change", function(){
			var _year;
        	if($("#year-combobox").data("kendoComboBox")!=null) _year = $("#year-combobox").data("kendoComboBox").value();
			
			$("#lst-excel-btn").removeAttr("href");
          	$("#lst-excel-btn").attr("href", "/mgmt/sbjct/sbjct-list-excel.do?year=" + _year);
		});
		
		$("#lst-excel-btn").attr("href", "/mgmt/sbjct/sbjct-list-excel.do?year=");
		
		
	 	   // list new btn add click event
	 	   $("#newBtn").click( function(){
	 		   
	 		    $("#splitter").data("kendoSplitter").expand("#detail_pane");
		 		   
		     	$("#sbjctOpenGridArea").hide();
		     	$("#sbjctMapGridArea").hide();
		     	
		     	$("#save-btn").hide();
		     	$("#new-save-btn").show();
		     	
		     	
				 kendo.bind( $(".tabular"),  null );
						
						
				 $('input:radio[id=useFlag]:input[value=Y]').attr("checked", true);//사용여부
						 
		 	  });
		
	}

	
	/*  
	* INIT DETAIL AREA
	*/
    function modifyYnFlag(checkbox, rows){
			var array = $('#sbjctMapGrid').data('kendoGrid').dataSource.data();
			
			if(checkbox.checked == true){
				array[rows].CHECKFLAG = "checked=\"1\"";
			}else{
				array[rows].CHECKFLAG = 'N';
			}

	   }
	
	
	
	function initDetailArea() {
		
		// add event : running button
		$("#save-btn").bind('click', function() {
			if (confirm("역량매핑을 적용하시겠습니까?")) setCmMap();
		});
	
		// add event : running button
		$("#new-save-btn").bind('click', function() {
			if (confirm("역량매핑을 적용하시겠습니까?")) newCmMap();
		});
		
		$("#sbjctOpenGrid").empty();
		$("#sbjctOpenGrid").kendoGrid({
			dataSource : {
				type : "json",
				transport : {
					read : { url : "/mgmt/sbjct/sbjct-open-list.do?output=json", type : "POST" },
					parameterMap : function(options, operation) {
						var _year;
                    	if($("#year-combobox").data("kendoComboBox")!=null) _year = $("#year-combobox").data("kendoComboBox").value();
                    	
						return { subjectNum:$("#dtl-subjectNum").val(), year:_year }; 
					}
				},
				schema : {
					total : "totalItemCount",
					data : "items",
					model : {
						id : "CHASU", // the identifier of the model
						fields : { 
							CHASU : { type : "string", editable : false },
							EDU_STIME : { type : "string" },
							EDU_ETIME : { type : "string" },
							YEAR : { type : "string", editable : false },
							SUBJECT_NUM : { type : "string", editable : false },
							ROWNUMBER : { type : "string", editable : false },
						}
					}
				}
			},
			height:200, scrollable:true, sortable:true, filterable:false, pageable:false,
			columns : [ 
			    { field : "CHASU", title : "차수", width:50, headerAttributes:{"class":"table-header-cell", style:"text-align:center"}, attributes:{"class":"table-cell", style:"text-align:center"} },
			    { field : "YEAR", title : "연도", width:50, headerAttributes:{"class":"table-header-cell", style:"text-align:center"}, attributes:{"class":"table-cell", style:"text-align:center"} },
			    { field : "EDU_STIME", title : "시작일", headerAttributes:{"class":"table-header-cell", style:"text-align:center"}, attributes:{"class":"table-cell", style:"text-align:center"},
// 			    	template: function (dataItem) {
                    //return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.COMPANYID+");' >"+dataItem.COMPANYNAME+"</a>"
//                     return dataItem.EDU_STIME+" ~ "+dataItem.EDU_ETIME;
//                     return "<input type='text' id='runStart' value='1' style='width:150px; border:none' />";
//                 	}	
// 			    	template: kendo.template($("#timeTemplate").html())
			    },
			    { field : "EDU_ETIME", title : "종료일", headerAttributes:{"class":"table-header-cell", style:"text-align:center"}, attributes:{"class":"table-cell", style:"text-align:center"},
// 			    	template: function (dataItem) {
                    //return "<a href='javascript:void();' onclick='javascript:fn_detailView("+dataItem.COMPANYID+");' >"+dataItem.COMPANYNAME+"</a>"
//                     return dataItem.EDU_STIME+" ~ "+dataItem.EDU_ETIME;
//                     return "<input type='text' id='runStart' value='1' style='width:150px; border:none' />";
//                 	}	
// 			    	template: kendo.template($("#timeTemplate").html())
			    },
                { 
                    title: "삭제", filterable: false, width:90,
                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                    attributes:{"class":"table-cell", style:"text-align:left"},
                    template: kendo.template($("#qstnDelTemplate").html())
                },
			    
			],
	          dataBound: function(e) {
	               if($('#sbjctOpenGrid').data('kendoGrid').dataSource.data()!=null){
	               	qstnPoolIndex = $('#sbjctOpenGrid').data('kendoGrid').dataSource.data().length;
	               }else{
	             	qstnPoolIndex = 0;
	               }
	        },
			editable : true,
			toolbar: [
	        {template: $("#qstnPoolToolbarTemplate").html()}
	        ]
		});
		
		$("#sbjctMapGrid").empty();
		$("#sbjctMapGrid").kendoGrid({
			dataSource : {
				type : "json",
				transport : {
					read : { url : "/mgmt/sbjct/sbjct-cm-map-list.do?output=json", type : "POST" },
					parameterMap : function(options, operation) {
						return { subjectNum:$("#dtl-subjectNum").val()}; 
					}
				},
				schema : {
					total : "totalItemCount",
					data : "items",
					model : {
						fields : { 
							CMPNUMBER : { type : "number", editable : false },
							ROWNUMBER : { type : "string", editable : false },
							CHECKFLAG : { type : "string", editable : false }
						}
					}
				}
			},
			height:200, scrollable:true, sortable:true, filterable:false, pageable:false,
			columns : [ 
			    { field : "CMPGROUP_STRING", title : "역량군", width:80, headerAttributes:{"class":"table-header-cell", style:"text-align:center"}, attributes:{"class":"table-cell", style:"text-align:center"} },
			    { field : "CMPNAME", title : "역량명", headerAttributes:{"class":"table-header-cell", style:"text-align:center"}, attributes:{"class":"table-cell", style:"text-align:center"} },
                {
                    field:"CHECKFLAG",
                    title: "선택",
                    filterable: true,
				      width:40,
				   	  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
				   	  attributes:{"class":"table-cell", style:"text-align:center"},
					  template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag(this, #: ROWNUMBER #)\" #: CHECKFLAG #/></div>" 
                }
			],
			editable : false
		});
		
		
        //차수추가 버튼 클릭
        $("#addQstnPool").click( function(){ 
        	$("#sbjctOpenGrid").data("kendoGrid").dataSource.add({            		
        		CHASU : qstnPoolIndex+1,
        		EDU_STIME : "",
        		EDU_ETIME : "",
        		YEAR : $("#year-combobox").data("kendoComboBox").value(),
        		ROWNUMBER :"0",
        		SUBJECT_NUM : $("#dtl-subjectNum").val()
        	});
        	
        	$("#sbjctOpenGrid").data("kendoGrid").refresh();
        }); 
		
		
		// dtl cancel btn add click event
     	$("#cencel-btn").click( function(){
      		kendo.bind( $(".tabular"),  null );
      		
      		// 상세영역 비활성화
      		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
      		$("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
      	});
		
		

	}
</script>
<script type="text/javascript">
	yepnope([ {
		load : [ 'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
				'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.default.min.css',
				'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js', 
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js', 
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js' 
		],
		complete : function() {
			
			
			
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
			
			// INIT LIST AREA
			initListArea();
			
			// INIT DETAIL AREA
			initDetailArea();
			
		}
	} ]);
</script>
</head>
<body>

	<div id="excel-upload-window" style="display: none; width: 320px;">
		<form method="post" action="/mgmt/sbjct/sbjct-excel_upload.do?" >
	       <div>
	           <input name="files" id="files" type="file" />
	           </br>
	           <div style="text-align: right;">
	           		<input type="submit" value="엑셀 업로드" class="k-button" id="uploadBtn"/>
	           </div>
	       </div>
	   </form>
   </div>
   
	<!-- START MAIN CONTENT  -->
	
		<div id="content">
	        <div class="cont_body">
	            <div class="title mt30">과정관리</div>
	            <div class="table_zone">
	                <div class="table_btn">	                		
	                		<button id="excelUploadBtn" class="k-button" >엑셀 업로드</button>
							<a id="lst-excel-btn" class="k-button"  >엑셀다운로드</a>
							<button id="newBtn" class="k-button" ><span class="k-icon k-i-plus"></span>추가</button>
	                </div>
	                <div class="table_list">
			            <div id="splitter" style="width:100%; height: 100%; border:none;">
			                <div id="list_pane">
							    <div id="grid" ></div>
							</div>
								<div id="detail_pane">
									<div id="details">
										<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
											<tr>
												<td class="subject" colspan="2">
													<strong>&nbsp; 과정정보상세</strong>
													<input type="hidden" id="dtl-subjectNum" data-bind="value:SUBJECT_NUM" />
												</td>
											</tr>
											<tr>
												<td class="subject" style="width:100px;"><label class="right inline required">교육명</label></td>
												<td class="subject"><input class="k-textbox" id="SUBJECT_NAME" data-bind="value:SUBJECT_NAME"  style="width:100%;" /></td>
											</tr>
											<tr>
												<td class="subject"><label class="right inline required">교육유형</label></td>
												<td class="subject">
														<input type="radio" id="TRAINING_CODE" name="TRAINING_CODE"  value="1" />온라인</input>
											 			<input type="radio" id="TRAINING_CODE" name="TRAINING_CODE"  value="2" />오프라인</input>
												</td>
											</tr>
											<tr>
												<td class="subject"><label class="right inline required">학습기관</label></td>
												<td class="subject"><input class="k-textbox" id="INSTITUTE_NAME" data-bind="value:INSTITUTE_NAME"  /></td>
											</tr>			
											<tr>
												<td class="subject"><label class="right inline required">학습대상</label></td>
												<td class="subject"><textarea class="k-textbox" id="EDU_TARGET" data-bind="value:EDU_TARGET" rows="5"  style="width:100%;"></textarea></td>
											</tr>
											<tr>
												<td class="subject"><label class="right inline required">학습목표</label></td>
												<td class="subject"><textarea class="k-textbox" id="EDU_OBJECT" data-bind="value:EDU_OBJECT" rows="5"  style="width:100%;"></textarea></td>
											</tr>
											<tr>
												<td class="subject"><label class="right inline required">학습개요</label></td>
												<td class="subject"><textarea class="k-textbox" id="COURSE_CONTENTS" data-bind="value:COURSE_CONTENTS" rows="5"  style="width:100%;"></textarea></td>
											</tr>
											<tr id = "sbjctOpenGridArea" height="100">
												<td class="subject"><label class="right inline required">차수정보</label></td>
												<td class="subject"><div id="year-combobox"></div><div id="sbjctOpenGrid"></div></td>
											</tr>
											<!-- 
											<tr>
												<td><label class="right inline required">샘플URL</label></td>
												<td><a href="" data-bind="value:SAMPLE_URL" style="border:none;"></a></td>
											</tr>
											-->
											<tr id = "sbjctMapGridArea">
												<td class="subject"><label class="right inline required">역량정보</label></td>
												<td class="subject"><div id="sbjctMapGrid"></div></td>
											</tr>
											<tr>
												<td class="subject"><label class="right inline required">사용여부</label></td>
												<td class="subject">
													<input type="radio" name="useFlag"  id="useFlag"   value="Y" />사용</input>
											 		<input type="radio" name="useFlag" id="useFlag"  value="N"/>미사용</input>
												</td>
											</tr>
										</table>
										<table width="100%">
											<tr><td style="text-align:right">
												<button id="save-btn" class="k-button"><span class="k-icon k-i-close"></span>저장</button>
												<button id="new-save-btn" class="k-button"><span class="k-icon k-i-close"></span>저장</button>
												<button id="cencel-btn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>&nbsp;&nbsp;
											</td></tr>
										</table>
									</div>
								</div>
			            </div>
			        </div>
		        </div>
	        </div>
	    </div>


		<script type="text/x-kendo-template" id="qstnPoolToolbarTemplate">
    		<div class="toolbar" style="text-align: left;">
        		<button id="addQstnPool" class="k-button" >문항 추가</button>
    		</div>
		</script>
		
		<script id="qstnDelTemplate" type="text/x-kendo-tmpl">

			<button id ="singleDel" class="k-button" onclick="singleDel(#:CHASU#, #:SUBJECT_NUM#, #:ROWNUMBER#, #:YEAR#)"><span class="k-icon k-i-plus"></span>삭제</button>

		</script>
		
		 <script id="timeTemplate" type="text/x-kendo-tmpl">
			
		
				<input type="text" id="runStart"  data-bind="value:#:EDU_STIME#"  style="width:80px; border:none"  /> ~ <input type="text" id="runEnd"  data-bind="value:#:EDU_ETIME#" style="width:80px; border:none"  />
	

		</script>
	<!-- END MAIN CONTNET -->
	<footer> </footer>
</body>
</html>