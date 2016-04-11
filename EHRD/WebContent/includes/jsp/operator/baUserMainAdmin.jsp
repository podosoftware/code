<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page pageEncoding="UTF-8"  isErrorPage="true" %>            
<html decorator="operatorSubpage">
<head>
	<title>사용자 관리</title>
		
	<script type="text/javascript">
	
	var isEmpNo = false; //아이디 중복확인 체크값
	
	var eduManageFlag = false; // 그룹권한부여 탭에서 교육운영자가 포함되어 있을 경우 true
	
	// 사용자관리 상세보기.
    function fn_detailView(userId){
		
		
    	var grid = $("#grid").data("kendoGrid");
        var data = grid.dataSource.data();

        var selectedCell;
        for(var i = 0; i<data.length; i++) {
            var dataItem = data[i];
            if(userId == dataItem.USERID){
            	selectedCell = dataItem;	            	
                  
               	
               	$("#dtl-userId").val(selectedCell.USERID);
               	
               	$.ajax({
         			type : 'POST',
 					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/user-info.do?output=json",
 					data : { userid : selectedCell.USERID },
 					success : function( response ){
 						
 						if(response.items!=null) {
 							var selectRow = new Object();
 		                  	selectRow["MODE"] = "mod";

 		                  	$.each(response.items,function(idx,item) {
 		                  		$.each(item,function(key,val) {
 		    						selectRow[key] = val;
 		                  		});
 		    				});
 		                     		                     		                  	
 		                  	kendo.bind( $("#tabular"),  selectRow );
 		                  	
 		                  	$("#dtl-dvsid").val(selectRow.EDU_DIVISIONID);
 	                        $("#dtl-dvs_name").val(selectRow.EDU_DVS_NAME);
 		                  	
 		                  	$('#detail_pane').find(".tabstrip").show();
 						} else {
 							kendo.bind( $("#tabular"), null);
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
               	
                 $("#change-password-btn").show(); // 비밀번호변경 버튼 활성화
					$('#dtl-password-area').hide();
					$('#dtl-add-info-txt').hide();
					$('#check-id-btn').hide();
					isEmpNo = true;
					
					$('#dtl-empNo').attr('readonly',true);
					
             	
             	// 선택 사용자의 그룹정보
               	getSelectUserRole();

//                	//  학사행정의 사용자 정보는 변경불가
//                	if(selectedCell.IS_EXTERNAL=="0") {
//                		$('#save-btn').show();
//                		//$('#cencel-btn').show();
//                		//$('#check-id-btn').show();
//                		$('#check-user-btn').show();
//                		$('#user-group-box').show();
//                		$('#dtl-add-info-txt').show();
//                	} else {
//                		$('#save-btn').hide();
//                		//$('#cencel-btn').hide();
//                		//$('#check-id-btn').hide();
//                		$('#check-user-btn').hide();
//                		$('#user-group-box').hide();
//                		$('#dtl-add-info-txt').hide();
//                	}
               	
              	// show detail 
                	$("#splitter").data("kendoSplitter").expand("#detail_pane");
              		$("#detail_pane").show();
             		$('input:radio[id=dtl-useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//사용여부
                 
                    break;
                    
            } // end if
        } // end for
        
        
      	// BUTTON : 비밀번호변경
      	
      	$("#change-password-btn").bind('click', function(){
		    if($("#dtl-empNo").val()=="") return false;
		    
		    if( !$("#change-password-window").data("kendoWindow") ){
		    	$("#change-password-window").kendoWindow({
		    		width:"400px",
		    		minWidth:"250px",
		    		minHeight:"150px",
		    		resizable : false,
                    title: "비밀번호 변경",
                    modal: true,
                    visible: false
		    	});
		    	
		    	// POPUP BUTTON : 비밀번호변경 저장
		        
		        $("#update-password-btn").click( function(){
		            
		            
		            if($('#search-text2').val()==""){
		                alert ('비밀번호 확인을 해주세요.') ;
		                return false;
		            }
		            
		            if($('#search-text1').val() != $('#search-text2').val()){
		                alert ('비밀번호가 다릅니다.');
		                $('#search-text2').val("");
		                return false;
		            }
		            
		            if($('#search-text1').val().length<8){
		                alert ('비밀번호는 최소 8 자리 이상으로 입력하여 주십시오.');
		                $('#search-text1').val("");
		                $('#search-text2').val("");
		                return false;
		            }
		               
		            var updateUser = new User({
		                password:$('#search-text1').val(),
		                empNo: $("#dtl-empNo").val() ,
		                userId: $("#dtl-userId").val(),
		                companyid: $("#dtl-companyid").val() 
		            });
		            
		            var isDel = confirm("비밀번호를 저장하시겠습니까?");
		             if(isDel){ 
		            
		            $.ajax({
		                type : 'POST',
		                url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/user-password-update.do?output=json",
		                data : { item: kendo.stringify( updateUser ) },
		                success : function( response ){
		                    
		                    alert("저장되었습니다.");
		                    
		                    $("#search-text1").val("");
		                    $("#search-text2").val("");
		                    $("#change-password-window").data("kendoWindow").close();                                                                               
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
		        
		    
		        // POPUP BUTTON : 비밀번호변경 취소
		        
		        $("#close-update-window-btn").click( function() {
		            $("#change-password-window").data("kendoWindow").close();     
		            $("#search-text1").val("");
		            $("#search-text2").val("");
		        });
			} 										
			$('#change-password-window').data("kendoWindow").center();      
	    	$("#change-password-window").data("kendoWindow").open();
	    	$("#search-text1").focus();
       	});
        
        // template에서 호출된 함수에 대한 이벤트 종료 처리.
        if(event.preventDefault){
            event.preventDefault();
        } else {
            event.returnValue = false;
        }
     }

	
        function initDtlArea() {
        	
        	//아이디 중복체크 확인
			$("#check-id-btn").click( function(){
				if($('#dtl-empNo').val().length<1){
					alert ('교직원번호을 입력해주세요.') ;
					return false;
				} 

			    $.ajax({
					type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/chk-userid.do?output=json",
					data : { tmpId: $('#dtl-empNo').val() },
					success : function( response ){
						if(response.statement=="Y") {
// 							$('#chk-userid-result-txt').html("사용가능한 아이디 입니다.&nbsp;<a class='k-button' href=\"#\" onclick=\"applyId()\"><span class='k-icon k-i-plus'></span>적용</a>");
							alert("사용가능합니다."); 
	                        isEmpNo = true;
	                        $("#check-id-btn").hide();
						} else {
							alert("사용불가능한 교직원번호 입니다.");
							$('#dtl-empNo').val("");
							isEmpNo = false;
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
            });
        	
	        
	        $("#dtl-empNo").change(function(){
	        	isEmpNo = false;
	            $("#check-id-btn").show();
	        });
        	
        	//부서검색 버튼 클릭 시 팝업 창 호출
                $("#deptSearchBtn").click(function(){
                	
                	if( !$("#dept-window").data("kendoWindow") ){     

                        $("#dept-window").kendoWindow({
                            width:"350px",
                            //minWidth:"300px",
                            resizable : true,
                            title : "부서검색",
                            modal: true,
                            visible: false
                        });
                         
                        
                     }
                	
                    $("#dept-window").data("kendoWindow").center();
                    $("#dept-window").data("kendoWindow").open();
                    
                });
        	
        	
        		//부서 트리뷰 호출
                $("#deptPopupTreeview").kendoTreeView({
                    dataTextField: ["DVS_NAME"],
                    dataSource: new kendo.data.HierarchicalDataSource({
                        type: "json",
                        transport: {
                            read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba-dept-list.do?output=json", type:"POST" },
                            parameterMap: function (options, operation){  
                              return {  USEFLAG : "Y" };
                            }         
	                   },
	                   schema: {
	                       data: "items",
	                       model: {
	                           fields: {
	                               DIVISIONID : { type: "String" },
	                               DVS_NAME : { type: "String" },
	                             items : { DIVISIONID : { type: "String" }, DVS_NAME : { type: "String" } }
	                           },
	                           children: "items"
	                       }
	                   },
	                   serverFiltering: false,
	                   serverSorting: false}),
                   loadOnDemand: false,
                   change : function (e){
                       var selectedCells = this.select();               
                       var selectedCell = this.dataItem( selectedCells );
                       
                       $("#dtl-dvsid").val(selectedCell.DIVISIONID);
                       $("#dtl-dvs_name").val(selectedCell.DVS_NAME);
                       
                       $("#dept-window").data("kendoWindow").close();
                   }
                });
        	
        	
        	// 직무선택 박스
        	$("#dtl-job").kendoDropDownList({
                dataTextField: "LABEL", dataValueField:"DATA",
                dataSource: {
                    type: "json",
                    transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/get-user-job-list.do?output=json", type:"POST" },
                    	parameterMap: function (options, operation){    
                        return {  JOBLDRFLAG : "J" };	
                    	}
                    },
                    schema: {
                    	total: "totalItemCount",
                    	data: "items",
                        model: { id:"DATA", fields:{ LABEL:{ type:"string" }, DATA:{ type:"number" } } }
                    }
                },
                placeholder : "" ,
                filter: "contains"
            });
        	
        	// 리더쉽선택 박스
        	/*$("#dtl-ldr").kendoDropDownList({
                dataTextField: "LABEL", dataValueField:"DATA",
                dataSource: {
                    type: "json",
                    transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/get-user-Ldr-list.do?output=json", type:"POST" },
                    	parameterMap: function (options, operation){    
                        return {  JOBLDRFLAG : "L" };	
                    	}
                    },
                    schema: {
                    	total: "totalItemCount",
                    	data: "items",
                        model: { id:"DATA", fields:{ LABEL:{ type:"string" }, DATA:{ type:"number" } } }
                    }
                },
                placeholder : "" ,
                filter: "contains"
            });*/
        	// BUTTON : ID중복체크
        	
//           	$("#check-id-btn").bind('click', function(){
// 			    if( !$("#chk-userid-window").data("kendoWindow") ){
// 			    	$("#chk-userid-window").kendoWindow({
// 			    		width:"220px",
// 			    		minWidth:"150px",
// 			    		minHeight:"150px",
// 			    		resizable : false,
//                         title: "아이디 중복체크",
//                         modal: true,
//                         visible: false
// 			    	});
// 				}
// 			    $("#search-id-txt").val("");
//             	$('#chk-userid-result-txt').html("");
// 				$('#chk-userid-window').data("kendoWindow").center();      
// 		    	$("#chk-userid-window").data("kendoWindow").open();
// 		    	$("#search-id-txt").focus();
//            	});
        	
        	// 사용자 중복체크
        	$("#check-user-btn").bind('click', function(){
			    if( !$("#chk-user-window").data("kendoWindow") ){
			    	$("#chk-user-window").kendoWindow({
			    		width:"400px",
			    		minWidth:"350px",
			    		minHeight:"150px",
			    		resizable : false,
                        title: "사용자 중복체크",
                        modal: true,
                        visible: false
			    	});
				}
			    $("#srch-nm-txt").val("");
			    $("#srch-phn-txt").val("");
            	$('#chk-user-result-txt').html("");
				$('#chk-user-window').data("kendoWindow").center();      
		    	$("#chk-user-window").data("kendoWindow").open();
		    	$("#search-nm-txt").focus();
           	});
          	

        	
        	
        	// BUTTON : 취소
           	$("#cencel-btn").click( function(){
          		$("#dtl-email").val("");
          		$(':text').val('');
          		
        		// 상세영역 비활성화
          		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
          		$("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
          	});
          	
	    	// dtl del btn add click event
	       	$("#delBtn").click( function(){
	       	    
	        	var isDel = confirm("삭제 하시겠습니까?");
	            if(isDel){
	        		var params = {
	        			userId: $("#dtl-userId").val(),
	        			FLAG : "8",
	         		};
	        		
	        		$.ajax({
	        			type : 'POST',
						url:"/operator/ca/ca_common_del.do?output=json",
						data : { item: kendo.stringify( params ) },
						complete : function( response ){
							var obj  = eval("(" + response.responseText + ")");
							if(obj.saveCount != 0){
								$("#grid").data("kendoGrid").dataSource.read();
				          		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
				          		$("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
								kendo.bind( $("#tabular"), null);
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
        	
           	// BUTTON : 저장
          	$("#save-btn").click( function(){
				
          		if($("#dtl-job").val().length<1){
          			alert("직무를 선택하십시오.");
          			return false;
          		}
          		/*
          		if($("#dtl-ldr").val().length<1){
          			alert("계급을 선택하십시오.");
          			return false;
          		}
          		*/
          		//alert($("#dtl-mode").val());
          		if(confirm("사용자 정보를 저장 하시겠습니까?")) {
          
	        		var updateUser = {
	        			mode : $("#dtl-mode").val(),
						Id: "",
						empNo: $("#dtl-empNo").val(),
						userId: $("#dtl-userId").val(),
						companyid: $("#dtl-companyid").val(),
						name: $("#dtl-name").val(),
						job: $("#dtl-job").val(),
						//ldr: $("#dtl-ldr").val(),
						//useFlag: $(':radio[id="dtl-useFlag"]:checked').val(),
					};
	        		
	        	
	        		$.ajax({
	        			type : 'POST',
						url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/user-update.do?output=json",
						data : { item: kendo.stringify( updateUser ) },
						success : function( response ){
							$("#grid").data("kendoGrid").dataSource.read();
			          		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
			          		$("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
							kendo.bind( $("#tabular"), null);
							
							if(response.saveCount > 0){
								alert("저장되었습니다.");
							}else{
								alert("실패했습니다.");
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
        	
			// 사용자정보 상세 그룹/권한 TAB ADD EVENT 
         	var user_tabs = $('#detail_pane').find(".tabstrip").kendoTabStrip({
         		animation:{
         			close : {duration:150, effects:"fadeOut"},
         			open : {duration:150, effects:"fadeIn"}
         		}
         	});
			
         	// 상세영역 그룹멀티셀렉터 선택
           	$("#user-group-select").kendoMultiSelect({
           		placeholder: "그룹을 선택하세요.",
           		dataTextField: "LABEL", dataValueField: "DATA",
                   filter: "contains",
                   autoBind: false,
                   dataSource: {
                       type: "json",
                       serverFiltering: true,
                       transport: { read: { url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/get-groups.do?output=json", type:"POST" } },
                       schema: {
                       	total: "totalItemCount",
                       	data: "items",
                           model: {
                           	id : "DATA",
                               fields: { LABEL : { type: "string" }, DATA : { type: "number" } }
                           }
                       }
                   },
                   change : function(e) {
                	   
                   		var multiSelect = $("#user-group-select").data("kendoMultiSelect");			                        		
	               		var flag = false;
	               		$.each(multiSelect.value(), function(index, row){  
	               			
	               			var item =  multiSelect.dataSource.get(row);
	               			if(item.DATA == '2'){
	               				flag = true;
	               			}
	               		});
	               		
	               		if(flag){
							$("#dvsdiv").show();
               				eduManageFlag = true;
						}else{
							$("#dvsdiv").hide();
               				eduManageFlag = false;
						}
                   }
           	});
        
        	// 그룹권한부여 저장
        	$("#role-save-btn").click( function(){
        		
        		// 그룹권한 중 교육운영자가 있을 경우
        		if(eduManageFlag){
        			if($("#dtl-dvs_name").val() == ""){
        				alert("담당부서를 입력해주세요.");
                        $("#deptSearchBtn").focus();
                        return false;
        			}
        		}
        		
        		var multiSelect = $("#user-group-select").data("kendoMultiSelect");			                        		
        		var list = new Array();
        		$.each(multiSelect.value(), function(index, row){  
        			var item =  multiSelect.dataSource.get(row);
        			list.push(item);			                        			
        		});
       		
        		if(list!=null && list.length>0) {
        			if(confirm("선택한 그룹권한을 저장하시겠습니까?")) {
		            	$.ajax({
				            dataType : "json",
							type : 'POST',
							url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/set-user-groups.do?output=json",
							data : { userId: $("#dtl-userId").val(), items: kendo.stringify( list ), eduManager: eduManageFlag , divisionid : $("#dtl-dvsid").val()},
							success : function( response ){		
								if(response.statement=="Y") {
									$("#grid").data("kendoGrid").dataSource.read();
					          		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
					          		$("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
									kendo.bind( $("#tabular"), null);
									alert("저장되었습니다.");
								} else {
									alert("저장에 실패하였습니다.");
								}
							},
							error : function( xhr, ajaxOptions, thrownError){
								//alert("저장에 실패하였습니다.");
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
						multiSelect.readonly(false);
        			}
        		} else {
        			alert("그룹권한은 최소 1개이상 선택해야합니다.");
        		}
            });
        	// 그룹권한부여 취소
        	$("#role-cancel-btn").click( function() {
        		//getSelectUserRole();
        		
        		// 상세영역 비활성화
        		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
          		$("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
            });
        	
        	$('input:radio[id=dtl-useFlag]:input[value=Y]').attr("checked", true);//사용여부
        }
				
        function initLstArea() {
        	// 그리드 초기화, 그리드 생성 후 초기화하지 않을 경우 재생성된 그리드의 로우셀렉터가 정상작동하지 않음.
        	$("#grid").empty();
        	
        	// 그리드 생성
        	$("#grid").kendoGrid({
                dataSource: {
                    type: "json",
                    transport: {
                        read: { 
                        		url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/user-list.do?output=json", 
                        		type:"POST" 
                       	},
                        parameterMap: function (options, operation){	
                        	var sortField = "";
                            var sortDir = "";
                            
                            if (options.sort && options.sort.length>0) {
                                sortField = options.sort[0].field;
                                sortDir = options.sort[0].dir;
                            }
                            
                        	if(operation != "read" && options) {
                      		  return {  startIndex: options.skip, pageSize: options.pageSize, item: kendo.stringify( options ), sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter) };  
                      	  	} else {
                      		  //return {  startIndex: options.skip, pageSize: options.pageSize  };
                      		  return {  startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter) };
                      	  	}
                        } 		
                    },
                    schema: {
                    	total: "totalItemCount",
                    	data: "items",
                        model: {
                        	id : "USERID",
                            fields: {
                            	RNUM : { type: "number" },
                              	COMPANYID : { type: "number" },
                          	  	USERID : { type: "number" },
                          	  	ID : { type: "string" },
                          		EMPNO : { type: "string" },
                          	  	DIVISIONID : { type: "string" },
                          	  	DVS_NAME : { type: "string" },
                          	  	JOB : { type: "number" },
                          	  	NAME : { type: "string" },
                          	  	EMAIL : { type: "string" },
                          		PHONE : { type: "string" },
                          		CELLPHONE: { type: "string" },
                          		ZIPCODE : { type: "string" },
                          		ADDRESS1 : { type: "string" },
                          		ADDRESS2 : { type: "string" },
                          		ROLE_STR : { type: "string" },
                          		IS_EXTERNAL : { type: "string" },
                          		LEADERSHIP : { type: "string" },
                          		GRADE_NM : { type: "string" },
                          		EMP_STS_CD_NM : { type: "string" },
                          		USEFLAG : { type: "string" }
                            }
                        }
                    },
                    pageSize: 30, 
                    serverPaging: true, 
                    serverFiltering: true, 
                    serverSorting: true
                },
                columns: [
				    { field:"RNUM", title: "번호", filterable: false, width:"40px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:center"} },
				    { field: "NAME", title: "성명", width:"100px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:center; text-decoration: underline;"},
						template: "<a href='javascript:void();' onclick='javascript: fn_detailView(${USERID});' >${NAME}</a>"	
				    },
                    { field:"EMPNO", title: "교직원번호", width:"120px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:left"} },
                    { field: "DVS_NAME", title: "부서", width:"150px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:left"} },
                    { field: "EMP_STS_CD_NM", title: "재직상태", width:"100px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:center"} },
                    { field: "GRADE_NM", title: "직급", width:"100px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:center"} },
					{ field: "GRADE_DIV_NM", title: "직렬", width:"100px",
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} },
                    { field: "JOB_NAME", title: "직무", width:"100px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:left"} },
					{ field: "LEADERSHIP_NAME", title: "계급", width:"90px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:left"} },
					{ field: "PHONE", title: "연락처", width:"115px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:center"} },	
					{ field: "USEFLAG_STRING", title: "사용여부", width:"90px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:center"} },
                    { field: "ROLE_STR", title: "권한", width:"100px",
						headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						attributes:{"class":"table-cell", style:"text-align:left"} }
                ],
                filterable: {
					extra : false,
					messages : {filter : "필터", clear : "초기화"},
					operators : { 
						string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
						number : { eq : "같음", gte : "이상", lte : "이하"}
					}
				},
                sortable: true,
                pageable : true,
	            resizable : true,
	            reorderable : true,
                selectable: "row",
                pageable : {
	                refresh : false,
                    pageSizes : [10,20,30],
                    buttonCount: 5
	            }
            });
        }
        
     	// 선택 사용자의 권한목록 호출
        function getSelectUserRole() {
        	var multiSelect = $("#user-group-select").data("kendoMultiSelect");
     		
        	if(multiSelect!=null) {
	        	$.ajax({
	          		dataType : "json",
	    			type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/get-user-groups.do?output=json",
					data : {
						userId : $("#dtl-userId").val()
					},
					success : function( response ) {
						if(response.items!=null) {
							var selectedRoleIDs = "";
							
							var showDvs =false; // 교육운영자 권한이 있을 경우 체크
							
							$.each(response.items,function(idx,row){
								if( selectedRoleIDs == "" ){
	                			    selectedRoleIDs =  selectedRoleIDs + row.DATA ;
	                			}else{
	                				selectedRoleIDs = selectedRoleIDs + "," + row.DATA;
	                			}
								
								// 교육운영자 권한이 있을 경우에 true 
								if(row.DATA == '2'){
									showDvs = true;
								}
							});
							
							// 교육운영자 권한이 있을 경우 show() or hide()
							if(showDvs){
								$("#dvsdiv").show();
								eduManageFlag = true;
							}else{
								$("#dvsdiv").hide();
								eduManageFlag = false;
							}
							
							multiSelect.value( selectedRoleIDs.split(",") );
						} else {
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
					}
				});
        	}
        }
     	
     	function initPopupArea() {
     		
			// POPUP BUTTON : 중복체크 취소 
			$("#idchk-cancel-btn").click( function() {	
            	$("#chk-userid-window").data("kendoWindow").close();
            	$("#search-id-txt").val("");
            	$('#chk-userid-result-txt').html("");
            });
     		
     	

        	
        	
     		// POPUP BUTTON : 중복체크 확인
			$("#userchk-ok-btn").click( function(){
				if($('#srch-nm-txt').val().length<1){
					alert ('성명을 입력해주세요.') ;
					$('#srch-nm-txt').val("");
					return false;
				}
				if($('#srch-phn-txt').val().length<10){
					alert ('핸드폰번호를 입력해주세요.') ;
					$('#srch-phn-txt').val("");
					return false;
				} 

			    $.ajax({
					type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/chk-user.do?output=json",
					data : { 
						tmpNm: $('#srch-nm-txt').val(), 
						tmpPhn : $('#srch-phn-txt').val()
					},
					success : function( response ){
						if(response.statement=="Y") {
							$('#chk-user-result-txt').html("사용가능한 사용자입니다.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class='k-button' href=\"#\" onclick=\"applyUser()\"><span class='k-icon k-i-plus'></span>적용</a>");
						} else {
							$('#chk-user-result-txt').html("사용이 불가능한 사용자입니다.");
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
            });
        
			// POPUP BUTTON : 중복체크 취소 
			$("#userchk-cancel-btn").click( function() {	
            	$("#chk-user-window").data("kendoWindow").close();
            	$("#srch-nm-txt").val("");
            	$("#srch-phn-txt").val("");
            	$('#chk-user-result-txt').html("");
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
                     '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js', 
                     '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/jquery.form.min.js'
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
              
               //로딩바 선언..
            loadingDefine();
        	  
        	// area splitter
			var splitter = $("#splitter").kendoSplitter({
   				orientation : "horizontal",
   				panes : [ {
   					collapsible : true, min : "500px"
   				}, {
   					collapsible : true, collapsed : true, min : "500px"
   				} ]
   			});
        	
        	// 리스트영역 이벤트 초기화
			initLstArea();
			
			// 상세영역 이벤트 초기화
           	initDtlArea();
			
// 			initPopupArea();
			

			
			
			// 핸드폰
			$('#srch-phn-txt').bind("keypress",function(){
				if(event.keyCode >= 48 && event.keyCode <= 57) return true;
				else event.returnValue = false;
			});
			// 전화
			$('#dtl-phone').bind("keypress",function(){
				if(event.keyCode >= 48 && event.keyCode <= 57) return true;
				else event.returnValue = false;
			});		
			

	        //엑셀파일업로드 팝업창 정의.. 상단에서 jquery.form.min.js 파일로드 해야함. 
	        if (!$("#excel-upload-window").data("kendoWindow")) {
	            $("#excel-upload-window").kendoWindow({
	                width : "340px",
	                minWidth : "340px",
	                resizable : false,
	                title : "엑셀 업로드",
	                modal : true,
	                visible : false
	            });
	            
	            
	            //과정 업로드 버튼 이벤트
	            $("#uploadBtn").click(function() {
	            	$("#excelForm").ajaxForm({
	            		data : $(this).serialize(),
                        cache: false,
                        type : 'POST',
                        iframe : true,
                        dataType : 'html',
                        contentType:"text/html; charset=UTF-8",
	            		beforeSubmit: function(data,frm, opt){
	            			if(data.length>0){
                                if(confirm("선택한 엑셀파일을 업로드하시겠습니까?")){
                                    //로딩바생성.
                                    loadingOpen();
                                    
                                    return true;
                                }else{
                                    return false;
                                }
                            }else{
                                alert("업로드할 엑셀 파일을 선택해주세요.");
                                return false;
                            }
	                        //alert("전송전");
	                        /*
	                        if(data.length>0){
	                        	var fileValue = data[0].value;
	                        	if(fileValue && fileValue.name != ""){
	                        		if( fileValue.name.toLowerCase().indexOf(".xls")>-1 || fileValue.name.toLowerCase().indexOf(".xlsx")>-1){
	                        			if(confirm("선택한 엑셀파일을 업로드하시겠습니까?")){
	                        				//로딩바생성.
	                                        loadingOpen();
	                                        
	                                        return true;
	                        			}else{
	                        				return false;
	                        			}
	                                    
	                        		}else{
	                        			alert("엑셀 파일만 선택해주세요.");
	                                    return false;
	                        		}
	                        	}else{
	                        		alert("업로드할 엑셀 파일을 선택해주세요.");
	                        		return false;
	                        	}
	                        }else{
	                        	alert("업로드할 엑셀 파일을 선택해주세요.");
	                        	return false;
	                        }*/
	                    },
	                    success: function(reponseText, statusText){
	                        //로딩바 제거.
	                        loadingClose();

	                    	if(reponseText){
	                    		//결과값을 json으로 파싱
                                var myObj = JSON.parse(reponseText);
	                    		alert("-사용자 업로드 결과-\n"+myObj.statement);
	                    	}else{
	                    		//작업 실패.
	                    		alert("작업이 실패하였습니다.");
	                    	}
	                        
	                        //그리드 다시 읽고,
	                        $("#grid").data("kendoGrid").dataSource.read();
	                        
	                        //업로드 객체 초기화
	                        $("#userUploadFile").parents(".k-upload").find(".k-upload-files").remove();
	                        $("input[name=userUploadFile]").each(function(e){
	                        	var inputFile =  $("input[name=userUploadFile]")[e];
	                        	if($(inputFile)){
	                        		if($(inputFile).id != "userUploadFile"){
	                        			//프로그래밍한 input file이 아닌 자동  추가된 input file은 제거
	                        			$(inputFile).remove();  
	                        		}
	                        	}
	                        });
	                        
	                        //팝업 닫기.
	                        $("#excel-upload-window").data("kendoWindow").close();
	                    },
	                    error: function(e){
	                        alert("ERROR:"+e);
	                    }
	                });
	            });
	            
	            $("#userUploadFile").kendoUpload({
	                multiple : false,
	                showFileList : true,
	                localization : {
	                    select : '파일 선택'
	                },
	                async : {
	                    autoUpload : false
	                }
	            });
	        }   
			
	        
         }
      	}]);
        
        function applyId() {
        	$('#dtl-empNo').val($('#search-id-txt').val());
        	$('#chk-userid-window').data('kendoWindow').close();
        }
        
        function applyUser() {
        	$('#dtl-name').val($('#srch-nm-txt').val());
        	$('#dtl-cellphone').val($('#srch-phn-txt').val());
        	$('#chk-user-window').data('kendoWindow').close();
        }
        
        
	    //과정 엑셀 업로드 팝업 호출..
        function excelUpLoad(){
            $('#excel-upload-window').data("kendoWindow").center();
            $("#excel-upload-window").data("kendoWindow").open();
        }
        
     
        
	</script>
</head>
<body>

    <div id="content">
        <div class="cont_body">
            <div class="title mt30">사용자관리</div>
            <div class="table_zone" >
                <div class="table_btn">
                	<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp;
                	<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/ba_user_list_excel.do" >엑셀 다운로드</a>&nbsp;
                	<a class="k-button"  href="javascript: excelUpLoad()" >직무정보 엑셀업로드</a>
                </div>
                <div class="table_list">
		            <div id="splitter" style="width:100%; height: 100%; border:none">
		                <div id="list_pane">
						    <div id="grid" ></div>
						</div>
						<div id="detail_pane" style = "display: none">
							<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">				
			                    <tr><td colspan="2" style="font-size:16px;">
                        			<strong>&nbsp; 사용자관리 상세</strong>
									<input type="hidden" id="dtl-companyid" data-bind="value:COMPANYID" />
							    	<input type="hidden" id="dtl-userId" data-bind="value:USERID" />
									<input type="hidden" id="dtl-mode" data-bind="value:MODE" />
									
								</td>
								</tr>
								<tr style="display:none;">
								    <td colspan="3" >
									<div class="alert-box alert" id="dtl-add-info-txt" style="width:100%">
										교직원번호은 "중복체크" 를 통해 등록합니다.
									</div>
								</td>
								</tr>
								<tr id="dtl-empNo-area">
									<td class="subject"><label for="dtl-empNo" class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;번 </label></td>
								    <td class="subject" colspan="2">
										<span data-bind="text:EMPNO"></span>
										<button id="check-id-btn" class="k-button">중복체크</button>
									</td>
							    </tr>
							    <tr id="dtl-password-area">
							    	<td class="subject"><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 비밀번호 </label></td> 
							    	<td class="subject" colspan="2"><input type="password" class="k-textbox" id="dtl-password" data-bind="value:PASSWORD" maxlength="13" style="width:100px;ime-mode:disabled;  "/></td>
							    </tr>
							    <tr>
							    	<td class="subject" style="width:80px;"><label class="right inline required" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명 </label></td>
							    	<td class="subject">
										<span data-bind="text:NAME"></span>
							    	</td>
							    </tr>
							    <tr>
							    	<td class="subject"><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 핸&nbsp;드&nbsp;폰 </label></td> 
							    	<td class="subject">
							    	<span data-bind="text:CELLPHONE"></span>	
							    	</td>
							    </tr>
							    <tr>
							    	<td class="subject"><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 연&nbsp;락&nbsp;처 </label></td> 
							    	<td class="subject" colspan="2">
							    	<span data-bind="text:PHONE"></span>	
							    	</td>
							    </tr>
								<tr id="dtl-dept-area">
									<td class="subject"><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 부&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서 </label></td>
									<td class="subject" colspan="2">
										<span data-bind="text:DVS_NAME"></span>	
				                    </td>
								</tr>
								<tr>
							    	<td class="subject"><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 직&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;급 </label></td> 
							    	<td class="subject">
							    	<span data-bind="text:GRADE_NM"></span>	
							    	</td>
							    </tr>
								<tr>
							    	<td class="subject"><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 직&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;무 </label></td> 
							    	<td class="subject" colspan="2"><input type="text" id="dtl-job" data-bind="value:JOB" style="width:80%;"></td>
							    </tr>
							    
							    <tr> 
							    	<td class="subject"><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 계&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;급 </label></td>
							    	<td class="subject" colspan="2">
							    	    <!-- <input type="text" id="dtl-ldr"  data-bind="value:LEADERSHIP" style="width:80%;"> -->
							    	    <span data-bind="text:LEADERSHIP_NM"></span><br>
							    	    *  계급은 직급에 의해 자동 설정됩니다. 역량진단관리>계급관리 메뉴에서 확인할 수 있습니다.
							    	</td>
							    </tr>
								<tr>
							    	<td class="subject"><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 이&nbsp;메&nbsp;일 </label></td> 
							    	<td class="subject" colspan="2">
							    		<span data-bind="text:EMAIL"></span>	
							    	</td>
							    </tr>
							    <tr>
							    	<td class="subject"><label class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 재직상태 </label></td> 
							    	<td class="subject">
							    	<span data-bind="text:EMP_STS_CD_NM"></span>	
							    	</td>
							    </tr>
							    <tr>
								   	<td class="subject" width="100px"   ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부</td> 
								    <td class="subject">
								        <span data-bind="text:USEFLAG_STRING"></span>
								        <!-- <input type="radio" name="useFlag"  id="dtl-useFlag"  value="Y" /> 사용</input>
									<span style="padding-left:70px"><input type="radio" name="useFlag" id="dtl-useFlag"  value="N" /> 미사용</input></span> -->
									</td>
							    </tr>
							</table>
							<table width="100%">
					    		<tr><td style="text-align:right;border-right:none;">
									<button id="save-btn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
									<button id="cencel-btn" class="k-button"><span class="k-icon k-i-cancel"></span>취소</button>&nbsp;&nbsp;
								</td></tr>
					    	</table>
							<br>
							<div id="user-group-box" class="tabstrip"> 
								<ul><li class="k-state-active"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 그룹권한부여</li></ul>
								<div style="height:120px">
									<select id="user-group-select" multiple="multiple" data-placeholder="Select attendees..."></select>
									<div id="dvsdiv" style="padding-top:10px;">
 							    		<label id="dtl-dvs_name_title" class="right inline required"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육운영담당부서 : &nbsp;</label>
 							    		<input type="hidden" id="dtl-dvsid" data-bind="value:EDU_DIVISIONID"  />
										<input class="k-textbox" id="dtl-dvs_name" placeholder="" data-bind="value:EDU_DVS_NAME" size="40" style="width: 50%;" readOnly />	
	                        			<button id="deptSearchBtn" class="k-button" sytle="visibility:hidden"><span class="k-icon k-i-plus"></span>검색</button>
									</div>
									<div style="padding-top:10px; text-align:right;">
											<button id="role-save-btn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
											<button id="role-cancel-btn" class="k-button"><span class="k-icon k-i-cancel"></span>취소</button>
									</div>
								</div>
							</div>
						</div>
		            </div>
		        </div>
	        </div>
        </div>
    </div>

	

	
	<div id="change-password-window" style="display:none; width:400px;">
		<table class="tabular" width="100%">
			<tbody>
				<tr>
					<td>새 비밀번호</td>
					<td><input type="password"  id="search-text1" validationMessage="비밀번호를 입력하여 주세요."  class="k-textbox" style="width:200px;" /></td>
				</tr>
				<tr>
					<td>새 비밀번호 확인</td>
					<td><input type="password"  id="search-text2" class="k-textbox" validationMessage="비밀번호를 입력하여 주세요." style="width:200px;" /></td>
				</tr>
				<tr>
					<td colspan=2 style="text-align:center; ">
					<br/>
					<a class="k-button" id="update-password-btn"><span class="k-icon k-i-plus"></span>저장</a> &nbsp;  
					<a class="k-button" id="close-update-window-btn"><span class="k-icon k-i-cancel"></span>취소</a></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div id="chk-userid-window" style="display:none; width:210px;">
		<table class="tabular">
			<tr><td>
				<div>
					아이디 : <input type="text" style='ime-mode:disabled; width:150px;' id="search-id-txt" maxlength="20" validationMessage="사용하려는 교직원번호를 입력하세요." class="k-textbox"  />
				</div>
				<br>
				<div class="alert-box alert" id="chk-userid-result-txt"></div>
			</td></tr>
			<tr><td>
			</td></tr>
			<tr><td>
					<br>
					<br>
					<div style="float: right">
					<a class="k-button" id="idchk-ok-btn"><span class="k-icon k-i-plus"></span>확인</a> &nbsp;  
					<a class="k-button" id="idchk-cancel-btn"><span class="k-icon k-i-cancel"></span>취소</a>
					</div>
			</td></tr>
		</table>
	</div>
	
	<div id="chk-user-window" style="display:none; width:400px;">
		<table class="tabular">
			<tr><td>
				성&nbsp;&nbsp;&nbsp;&nbsp;명 : <input type="text" id="srch-nm-txt" validationMessage="성명 입력하세요." class="k-textbox" style="width:100px;" ><br>
			<tr><td>
				핸드폰 : <input type="text" id="srch-phn-txt" validationMessage="핸드폰번호를 입력하세요." maxlength="11" class="k-textbox" style="width:100px;ime-mode:disabled" >
					ex) 01012345678, "-" 없이 입력하세요.<br>
			</td></tr>
			<tr><td>
				<div style="float: right">
					<a class="k-button" id="userchk-ok-btn"><span class="k-icon k-i-plus"></span>확인</a> &nbsp;  
					<a class="k-button" id="userchk-cancel-btn"><span class="k-icon k-i-cancel"></span>취소</a>
				</div>
				<br>
			</td></tr>
			<tr><td>
				<div class="alert-box alert" id="chk-user-result-txt"></div>
			</td></tr>
		</table>
	</div>
	
	<!-- 상위 부서 선택 팝업 -->
        <div id="dept-window" style="display: none;">
	        <div style="width: 100%">
	          <table style="width: 100%;">
	            <tr>
	                <td>
	                    <div id="deptPopupTreeview"   style="width: 100%; height: 200px; "></div>
	                </td>
	            </tr>
	          </table>
	        </div>
	    </div>
	    
    <div id="excel-upload-window" style="display:none; width:340px;">
        <form id="excelForm" name="excelForm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/baUser/upload_user_list_excel.do?output=json" enctype="multipart/form-data" >
        ※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
           <div>
               <input name="userUploadFile" id="userUploadFile" type="file" />
               </br>
               <div style="text-align: right;">
                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/user_upload_template.xls" class="k-button" >템플릿다운로드</a>
                    <input type="submit" value="실행" class="k-button" id="uploadBtn"/>
               </div>
           </div>
       </form>
   </div>

  	<footer>
  	</footer>   
</body>
</html>