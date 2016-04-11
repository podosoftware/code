<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>대상자 관리</title>	
	<script type="text/javascript">               
	var rungargetDataSource;
	var notRungargetDataSource;
	var dataSource_run;
	
	yepnope([ {
        load : [
                'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
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
            		
                  var splitterElement = $("#splitter");
                  //스플릿터 top 위치와 footer 높이, padding 30을 합한 높이를 윈도우창 사이즈에서 빼줌.
                  splitterOtherHeight = $("#splitter").offset().top + $("#footer").outerHeight() + 15; //
                  splitterElement.height(winHeight - splitterOtherHeight);
                  
                  //splitterOtherWidth = $("#splitter").offset().top + $("#footer").outerHeight() + 15; //
                  //splitterElement.height(winHeight - splitterOtherHeight);
                  
                  //그리드 사이즈 재조정..
                  //var gridElement = $("#grid");
                  //gridElement.height(splitterElement.outerHeight()-2);
                  
                  
                  //그리드 리사이즈
                  /*var runElement = $("#runTargetGrid"); // 대상자
                  runElement.height(splitterElement.outerHeight()-170);
                  runDataArea = runElement.find(".k-grid-content"),
                  runGridHeight = runElement.innerHeight(),
                  runDataArea.height(runGridHeight - 55);
                  
                  
                  var notRunElement = $("#notRunTargetGrid"); // 미대상자
                  notRunElement.height(splitterElement.outerHeight()-170);
                  notRunDataArea = notRunElement.find(".k-grid-content"),
                  notRunGridHeight = notRunElement.innerHeight(),
                  notRunDataArea.height(notRunGridHeight - 55); 
                  */
                  
  	              //var listElement=$(".table_zone");
					
  	              //listElement.height(listElemet.hegith()-50);
  	              
                  
                  
                  //var gridElement = $("#runDiv");
                  //gridElement.height(listElement.outerHeight()/3-50);
                  
                  //var gridElement = $("#insertRunDiv");
                  //gridElement.height(listElement.outerHeight()/3-100);
                  
                  //var gridElement = $("#deleteRunDiv");
                  //gridElement.height(listElement.outerHeight()/3-100);
                  

          	    //로딩바 선언..
                  loadingDefine();
              });
              var yyyyDataSource = new kendo.data.DataSource({
                  type: "json",
                  transport: {
                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/evl_year_list.do?output=json", type:"POST" },
                      parameterMap: function (options, operation){ 
                       return { EVL_TYPE: "1" };
                      }        
                  },
                  schema: {
                      data: "items",
                      model: {
                             fields: {
                                 TEXT : { type: "string" },
                                 YYYY: { type: "string" }
                             }
                         }
                  }
              });
              
              
            //평가년도 콤보박스
            $("#yyyy").kendoDropDownList({
                dataTextField: "TEXT",
                dataValueField: "YYYY",
                dataSource: yyyyDataSource,
                filter: "contains",
                suggest: true,
                index: 0,
                width: 100,
                change: function() {
                    runFilter();
                 },
                 dataBound:function(e){
                     if(yyyyDataSource.data().length>0){
                         runFilter();
                     }
                 }
            }).data("kendoDropDownList");
            //평가년도에 해당하는 실시목록
        	  dataSource_run = new kendo.data.DataSource({
                  type: "json",
                  transport: {
                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_diagnosis_obj_list.do?output=json", type:"POST" },
                      parameterMap: function (options, operation){	
                      	return {} ;
                      } 		
                  },
                  schema: {
                  	data: "items1",
                  	id : "VALUE",
                  	model: { 
                  		SELF_WEIGHT : { type: "string" } ,
	                    VALUE : { type: "string" }, 
	                    TEXT : { type: "string" },
	                    YYYY: { type: "string" },
	                    R_PERIOD : { type:"string" }
                  	}
                  },
                  serverFiltering: false,
	              serverSorting: false
     		 });
        	  
        	  $("#runNumber").kendoDropDownList({
					dataTextField : "TEXT",
					dataValueField : "VALUE",
					dataSource : dataSource_run,
					suggest : true,
					index : 0,
					change : function() {
			  			// 필터를 사용할 경우 필터 초기화 ,필터의 초기화 버튼 이벤트를 발생 
			  			$("form.k-filter-menu button[type='reset']").trigger("click");
			  			$("#runTargetGrid").data("kendoGrid").dataSource.read();
			  			$("#notRunTargetGrid").data("kendoGrid").dataSource.read();
			  		    $("#upload_run_num").val($("#runNumber").val());
			  		    
					},
					dataBound:function(){
	                    $("#runNumber").data("kendoDropDownList").select(0);
	  	  			    $("#runTargetGrid").data("kendoGrid").dataSource.read();
		  			    $("#notRunTargetGrid").data("kendoGrid").dataSource.read();
		  			    $("#upload_run_num").val($("#runNumber").val());
		  			    
		            }
				});

	          $('#grid').show().html(kendo.template($('#template').html())); // 미대상자 대상자 목록 출력

	          //미 대상자 목록
	        $("#notRunTargetGrid").kendoGrid({
              	dataSource: {
                       type: "json",
                       transport: {
                           read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_target_list.do?output=json", type:"POST" },
                           parameterMap: function (options, operation){
                        		var sortField = "";
                            	var sortDir = "";
                            	if (options.sort && options.sort.length>0) {
                            		sortField = options.sort[0].field;
                            		sortDir = options.sort[0].dir;
                                } 
                        	   return {
                                	RUN_NUM : $("#runNumber").val(),
                                	MOD : "NOTRUN",
                                	startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter) 
                                };
                           }
                       },
                       schema: {
                       	total : "totalItemCount",
                            data: "items3",
                            model: {
                           	 fields : {
                           		 	COMPANYID : {
	  	                                type : "number",
	  	                                editable : false
	  	                            },
	  	                          	USERID : {
	  	                                type : "string",
	  	                                editable : false
	  	                            },
	  	                          	DIVISION : {
	  	                                type : "string",
	  	                                editable : false
	  	                            },
	  	                         	JOB : {
	  	                                type : "string",
	  	                                editable : false
	  	                            },
	  	                          	LEADERSHIP : {
	  	                                type : "string",
	  	                                editable : false
	  	                            },
      	                        }
                            }
                       },
                       pageSize : 30,
                       serverPaging : true,
                       serverFiltering : true,
                       serverSorting : true,
                       requestEnd : function () {
                           $('.notRunSelect_all').removeAttr('checked');
                       }
                   },
                   columns : [
                              {
      							field : "USEFLAG",
      							title : "선택 <input type =checkbox class=notRunSelect_all onclick=javascript:user_alert();>",
      							filterable : false,
      							sortable : false,
      							width : 60,
      							headerAttributes : {
      							    "class" : "table-header-cell",
      							    style : "text-align:center"
      							},
      							attributes : {
      							    "class" : "table-cell",
      							    style : "text-align:center"
      							},
      							template : "<div style=\"text-align:center\"><input type=\"checkbox\" name=\"notRunCheck_${USERID}\" data=\"${USERID}\" id=\"notRunCheck\" class=\"notRunSelect_chk\" onclick=\"noUserCheck(this, #:USERID#)\" /></div>"
                              },
      						{
                                  field : "NAME",
                                  title : "성명",
                                 // width : 150,
                                  headerAttributes : {
                                      "class" : "table-header-cell",
                                      style : "text-align:center"
                                  },
                                  attributes : {
                                      "class" : "table-cell",
                                      style : "text-align:center"
                                  }
                              },
                              {
                                  field : "EMPNO",
                                  title : "교직원번호",
                                  //width : 200,
                                  headerAttributes : {
                                      "class" : "table-header-cell",
                                      style : "text-align:center"
                                  },
                                  attributes : {
                                      "class" : "table-cell",
                                      style : "text-align:center"
                                  }
                              },
                              {
                                  field : "DVS_NAME",
                                  title : "부서",
                                 // width : 200,
                                  headerAttributes : {
                                      "class" : "table-header-cell",
                                      style : "text-align:center"
                                  },
                                  attributes : {
                                      "class" : "table-cell",
                                      style : "text-align:center"
                                  }
                              },
                              {
                                  field : "GRADE_DIV_NM",
                                  title : "직렬",
                                  //width : 200,
                                  headerAttributes : {
                                      "class" : "table-header-cell",
                                      style : "text-align:center"
                                  },
                                  attributes : {
                                      "class" : "table-cell",
                                      style : "text-align:center"
                                  }
                              },
                              {
                                  field : "GRADE_NM",
                                  title : "직급",
                                  //width : 200,
                                  headerAttributes : {
                                      "class" : "table-header-cell",
                                      style : "text-align:center"
                                  },
                                  attributes : {
                                      "class" : "table-cell",
                                      style : "text-align:center"
                                  }
                              },
                              {
                                  field : "LEADERSHIP_NAME",
                                  title : "계급",
                                  //width : 200,
                                  headerAttributes : {
                                      "class" : "table-header-cell",
                                      style : "text-align:center"
                                  },
                                  attributes : {
                                      "class" : "table-cell",
                                      style : "text-align:center"
                                  }
                              },
                              {
                                  field : "JOB_NAME",
                                  title : "직무",
                                 // width : 200,
                                  headerAttributes : {
                                      "class" : "table-header-cell",
                                      style : "text-align:center"
                                  },
                                  attributes : {
                                      "class" : "table-cell",
                                      style : "text-align:center"
                                  }
                              }
                            ],
                            filterable : {
               	                extra : false,
               	                messages : {
               	                    filter : "필터",
               	                    clear : "초기화"
               	                },
               	                operators : {
               	                    string : {
               	                        contains : "포함",
               	                        startswith : "시작문자",
               	                        eq : "동일단어"
               	                    },
               	                    number : {
               	                        eq : "같음",
               	                        gte : "이상",
               	                        lte : "이하"
               	                    }
               	                }
               	            },
                   sortable : true,
                   pageable : true,
                   resizable : true,
                   reorderable : true,
                   selectable: "row",
                   scrollable : true,
                   editable : false,
                   pageable : {
       	            refresh : false,
       	            pageSizes : [10,20,30,3000],
       	            buttonCount : 10
       	        	}
                   
               });

              //대상자 목록
              rungargetDataSource = $("#runTargetGrid").kendoGrid({
  	            dataSource : {
  	                type : "json",
  	                transport : {
  	                    read : {
  	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_target_list.do?output=json",
  	                        type : "POST"
  	                    },
  	                    parameterMap : function(options, operation) {
  	                    	var sortField = "";
                        	var sortDir = "";
                        	if (options.sort && options.sort.length>0) {
                        		sortField = options.sort[0].field;
                        		sortDir = options.sort[0].dir;
                            }
  	                    	return {
  	                        	RUN_NUM : $("#runNumber").val(),
  	                        	MOD : "RUN",
  	                        	startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter) 
  	                        };
  	                    }
  	                },
  	                schema : {
  	                	total : "totalItemCount",
  	                    data : "items3",
  	                    model : {
  	                        fields : {
  	                        	COMPANYID : {
  	                                type : "number",
  	                                editable : false
  	                            },
  	                          	USERID : {
  	                                type : "string",
  	                                editable : false
  	                            },
  	                          	DIVISION : {
  	                                type : "string",
  	                                editable : false
  	                            },
  	                         	JOB : {
  	                                type : "string",
  	                                editable : false
  	                            },
  	                            LEADERSHIP : {
  	                                type : "string",
  	                                editable : false
  	                            },
  	                            
  	                        }
  	                    }
  	                },
                    pageSize : 30,
                    serverPaging : true,
                    serverFiltering : true,
                    serverSorting : true,
                    requestEnd : function () {
                        $('.runSelect_all').removeAttr('checked');
                    }
  	            },
	  	          filterable : {
	 	                extra : false,
	 	                messages : {
	 	                    filter : "필터",
	 	                    clear : "초기화"
	 	                },
	 	                operators : {
	 	                    string : {
	 	                        contains : "포함",
	 	                        startswith : "시작문자",
	 	                        eq : "동일단어"
	 	                    },
	 	                    number : {
	 	                        eq : "같음",
	 	                        gte : "이상",
	 	                        lte : "이하"
	 	                    }
	 	                }
	 	            },
	 	          
                  sortable : true,
                  pageable : true,
                  resizable : true,
                  reorderable : true,
                  scrollable : true,
                  editable : false,
                  selectable: "row",
                  pageable : {
      	            refresh : false,
      	            pageSizes : [10,20,30,3000],
      	            buttonCount : 10
      	            
      	          },
                  columns : [
                             {
     							field : "USEFLAG",
     							title : "선택  <input type =checkbox class=runSelect_all onclick=javascript:user_alert();>",
     							filterable : false,
     							sortable : false,
     							width : 60,
     							headerAttributes : {
     							    "class" : "table-header-cell",
     							    style : "text-align:center"
     							},
     							attributes : {
     							    "class" : "table-cell",
     							    style : "text-align:center"
     							},
     							template : "<div style=\"text-align:center\"><input type=\"checkbox\" name=\"runCheck_${USERID}\" data=\"${USERID}\" id=\"runCheck\" class=\"runSelect_chk\" onclick=\"yesUserCheck(this, #:USERID#)\"/></div>"
                             },
     						{
                                 field : "NAME",
                                 title : "성명",
                                // width : 150,
                                 headerAttributes : {
                                     "class" : "table-header-cell",
                                     style : "text-align:center"
                                 },
                                 attributes : {
                                     "class" : "table-cell",
                                     style : "text-align:center"
                                 }
                             },
                             {
                                 field : "EMPNO",
                                 title : "교직원번호",
                                // width : 200,
                                 headerAttributes : {
                                     "class" : "table-header-cell",
                                     style : "text-align:center"
                                 },
                                 attributes : {
                                     "class" : "table-cell",
                                     style : "text-align:center"
                                 }
                             },
                             {
                                 field : "DVS_NAME",
                                 title : "부서",
                                // width : 200,
                                 headerAttributes : {
                                     "class" : "table-header-cell",
                                     style : "text-align:center"
                                 },
                                 attributes : {
                                     "class" : "table-cell",
                                     style : "text-align:center"
                                 }
                             },
                             {
                                 field : "GRADE_DIV_NM",
                                 title : "직렬",
                                 //width : 200,
                                 headerAttributes : {
                                     "class" : "table-header-cell",
                                     style : "text-align:center"
                                 },
                                 attributes : {
                                     "class" : "table-cell",
                                     style : "text-align:center"
                                 }
                             },
                             {
                                 field : "GRADE_NM",
                                 title : "직급",
                               //  width : 200,
                                 headerAttributes : {
                                     "class" : "table-header-cell",
                                     style : "text-align:center"
                                 },
                                 attributes : {
                                     "class" : "table-cell",
                                     style : "text-align:center"
                                 }
                             },
                             {
                                 field : "LEADERSHIP_NAME",
                                 title : "계급",
                               //  width : 200,
                                 headerAttributes : {
                                     "class" : "table-header-cell",
                                     style : "text-align:center"
                                 },
                                 attributes : {
                                     "class" : "table-cell",
                                     style : "text-align:center"
                                 }
                             },
                             {
                                 field : "JOB_NAME",
                                 title : "직무",
                                // width : 200,
                                 headerAttributes : {
                                     "class" : "table-header-cell",
                                     style : "text-align:center"
                                 },
                                 attributes : {
                                     "class" : "table-cell",
                                     style : "text-align:center"
                                 }
                             }
                           ],
  	                dataBound:function(){}
  	        });
            
  		  	
            $(window).resize();
	  		function runFilter(){
	  	        if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
	  	            $("#runNumber").data("kendoDropDownList").dataSource.filter({
	  	                "field":"YYYY",
	  	                "operator":"eq",
	  	                "value":Number($("#yyyy").val())
	  	            });
	  	        }else{
	  	            $("#runNumber").data("kendoDropDownList").dataSource.filter({});
	  	        }
	  	    }

	  		$("#cencelBtn").click( function(){
	  			$("#runTargetGrid").data("kendoGrid").dataSource.read();
	  			$("#notRunTargetGrid").data("kendoGrid").dataSource.read();
	  			
	        });
	  		
	  		//엑셀업로드 버튼 클릭.
            $("#excelUploadBtn").click(function() {
            	if($("#runNumber").val() == null || $("#runNumber").val() == "" ){
        			alert("선택된 진단이 없습니다.");
        			return false;
        		}
            	
                var dataRun = dataSource_run.data();
                var res = $.grep(dataRun, function (e) {
                    return e.VALUE == $("#runNumber").val();
                });
                
                if(res[0] != null){
                    if(res[0].RUN_START_YN == 'N'){
                        alert("설정한 내용을 변경할 수 없습니다.실시 시작일을 확인해 주십시오.");
                        return false;
                    }
                }
                
                $('#excel-upload-window').data("kendoWindow").center();
                $("#excel-upload-window").data("kendoWindow").open();
            });

            //엑셀파일업로드 팝업창 정의.. 상단에서 jquery.form.min.js 파일로드 해야함. 
            if (!$("#excel-upload-window").data("kendoWindow")) {
                $("#excel-upload-window").kendoWindow({
                    width : "340px",
                    minWidth : "340px",
                    resizable : false,
                    title : "상시학습관리 엑셀 업로드",
                    modal : true,
                    visible : false
                });
                
                //업로드 버튼 이벤트
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
                        },
                        success: function(reponseText, statusText){
                            //로딩바 제거.
                            loadingClose();
							
                            if(reponseText ){
                                //결과값을 json으로 파싱
                                var myObj = JSON.parse(reponseText);
                                alert("-대상자 업로드 결과-\n"+myObj.statement);
                            }else{
                                //작업 실패.
                                alert("작업이 실패하였습니다.");
                            }
                            
                            //그리드 다시 읽고,
                            //$("#grid").data("kendoGrid").dataSource.read();
                            $("#notRunTargetGrid").data("kendoGrid").dataSource.read();
	 						$("#runTargetGrid").data("kendoGrid").dataSource.read();
	 						
                            //업로드 객체 초기화
                            $("#openUploadFile").parents(".k-upload").find(".k-upload-files").remove();
                            $("input[name=openUploadFile]").each(function(e){
                                var inputFile =  $("input[name=openUploadFile]")[e];
                                if($(inputFile)){
                                    if( $(inputFile).id  != "openUploadFile"){
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
                
                $("#openUploadFile").kendoUpload({
                    multiple : false,
                    showFileList : true,
                    localization : {
                        select : '파일 선택'
                    },
                    async : {
                        autoUpload : false
                    },
                    select: function(e){
                        $.each(e.files, function(index, value) {
                            if( value.extension.toLowerCase() != ".xls" && value.extension.toLowerCase() != ".xlsx" ) {
                                
                                e.preventDefault();
                                alert("엑셀파일만 선택해주세요.");
                            }
                        });
                    }
                });
            }
            
	  		//대상자 전체 선택
	  		$('.runSelect_all').bind('click' , function(){
	  			 var chk = $(this).is(':checked');
	  			 var array = $('#runTargetGrid').data('kendoGrid').dataSource.view();
	  			 //var isSel=confirm("선택한 사용자가 많을경우 시간이 다소 걸릴수 있습니다.");
	  			 //if(isSel){
		  			 if(chk){ 
		  				 $('.runSelect_chk').attr('checked' , true); //전체선택
		  				 for(var i=0 ; i < array.length ; i++ ){ 
		  					// 전체선택 된것중 체크된것 (필터를 사용하였을 경우에 대비해 if문 추가)
		  					//if (array[i].USERID == $(":checkbox[name='runCheck_" + array[i].USERID+ "']:checked").attr("data")) {
		  					 	array[i].USEFLAG = "N";
		  					//}
		  				 }
		  			 }else {
		  				 $('.runSelect_chk').attr('checked' , false);
		  				 for(var i=0 ; i < array.length ; i++ ){
		  					//if (array[i].USERID == $(":checkbox[name='runCheck_" + array[i].USERID+ "']:checked").attr("data")) {
		  						array[i].USEFLAG = "Y";
		  					//}
		  				 }
		  			 }
	  			//}else{$(this).attr('checked' , false);} 
	  		});
	  		
	  		$('.notRunSelect_all').bind('click' , function(){
	  			 var chk = $(this).is(':checked');
	  			 var array = $('#notRunTargetGrid').data('kendoGrid').dataSource.view();
	  			 //var isSel=confirm("선택한 사용자가 많을경우 시간이 다소 걸릴수 있습니다.");
	  			 //if(isSel){
		  			 if(chk){
		  				 $('.notRunSelect_chk').attr('checked' , true);
		  				 for(var i=0 ; i < array.length ; i++ ){
		  					// 전체선택 된것중 체크된것 (필터를 사용하였을 경우에 대비해 if문 추가)
		  					//if (array[i].USERID == $(":checkbox[name='notRunCheck_" + array[i].USERID+ "']:checked").attr("data")) {
		  					 	array[i].USEFLAG = "Y";
		  					//}
		  				 }
		  			 }else{
		  				 $('.notRunSelect_chk').attr('checked' , false);
		  				 for(var i=0 ; i < array.length ; i++ ){
		  					//if (array[i].USERID == $(":checkbox[name='runCheck_" + array[i].USERID+ "']:checked").attr("data")) {
		  						array[i].USEFLAG = "N";
		  					//}
		  				 }
		  			 }
	  			//}else{$(this).attr('checked' , false);}
	  		});
          }
      }]);   
        
	</script>
	<script type="text/javascript">
	function user_alert(){
		//alert("선택대상자가 많을경우 시간이 다소 걸릴수 있습니다.");
	}
	//엑셀다운로드
	function excelDown(button){
		if($("#runNumber").val() == null || $("#runNumber").val() == "" ){
			alert("선택된 진단이 없습니다.");
			return false;
		}
		
		button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_object_list_excel.do?runNum=" + $("#runNumber").val();
	}
	
	// 미대상자 그리드 체크박스 클릭 시..
	function noUserCheck(checkbox, userid){
	    var array = $('#notRunTargetGrid').data('kendoGrid').dataSource.data();
	    var res = $.grep(array, function (e) {
	        return e.USERID == userid;
	    });

	    if (checkbox.checked == true) {
	        res[0].USEFLAG = "Y";
	    } else {
	        res[0].USEFLAG = '';
	    }
	}
	//대상자 체크박스 클릭시
	function yesUserCheck(checkbox, userid){
        var array = $('#runTargetGrid').data('kendoGrid').dataSource.data();
        var res = $.grep(array, function (e) {
            return e.USERID == userid;
        });	
        if (checkbox.checked == true) {
            res[0].USEFLAG = "N";
        } else {
            res[0].USEFLAG = '';
        }
    }
	
	//row 저장 
	function insertRow(mod){
		var dataRun = dataSource_run.data();
		var rows;
		var noRes;

		if($("#runNumber").val() == null || $("#runNumber").val() == "" ){
			alert("선택된 진단이 없습니다.");
			return false;
		}
   		var res = $.grep(dataRun, function (e) {
   			return e.VALUE == $("#runNumber").val();
        });
   		
		if(res[0] != null){
	   		if(res[0].RUN_START_YN == 'N'){
	   			alert("설정한 내용을 변경할 수 없습니다.실시 시작일을 확인해 주십시오.");
	   			return false;
	   		}
		}
   		
   		if(mod == "in"){ // 추가일경우 미대상자의 체크된 값을 가져와 처리
   			rows= $("#notRunTargetGrid").data("kendoGrid").dataSource.data();
   			noRes  = $.grep(rows, function(e) {
	             return e.USEFLAG == "Y";
	     	});
   			if(noRes.length == 0){
   				alert("선택된 사용자가 존재하지 않습니다.");
   				return false;
   			}
   		}
   		else if(mod=="out"){ // 삭제일경우 대상자의 체크된 값을 가져와 처리
   			rows = $("#runTargetGrid").data("kendoGrid").dataSource.data();
   			noRes  = $.grep(rows, function(e) {
	             return e.USEFLAG == "N";
	     	});
   			if(noRes.length == 0){
   				alert("선택된 사용자가 존재하지 않습니다.");
   				return false;
   			}
   		}
   		var isDel="";
   		if(mod == "in"){
   			isDel = confirm("선택한 사용자를 추가하시겠습니까?");
   		}else if(mod=="out"){
   			isDel = confirm("선택한 사용자를 삭제하시겠습니까?");
   		}

	 	if(isDel){
	 		//로딩바생성.
         	loadingOpen();
	 		var params = {
            	    LIST1 : noRes
                    //LIST2 : $('#notRunTargetGrid').data('kendoGrid').dataSource.data()  
            };
       		$.ajax({
       			type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_target_save.do?output=json",
					data : { 
						item: kendo.stringify( params ),
						RUN_NUM : $("#runNumber").val()
					},
					
					complete : function( response ){
						//로딩바 제거.
                    loadingClose();
						var obj  = eval("(" + response.responseText + ")");
						if(obj.saveCount != 0){
							$('.notRunSelect_all').attr('checked' , false);
							$('.runSelect_all').attr('checked' , false);
							$("#notRunTargetGrid").data("kendoGrid").dataSource.read();
	 						$("#runTargetGrid").data("kendoGrid").dataSource.read();
	 						$("form.k-filter-menu button[type='reset']").trigger("click");
	 						
	 						if(mod == "in"){
	 				   			alert("추가되었습니다.");
	 				   		}else if(mod=="out"){
	 				   			alert("삭제되었습니다.");
	 				   		}
						}else{
							if(mod == "in"){
	 				   			alert("추가에 실패하였습니다.");
	 				   		}else if(mod=="out"){
	 				   			alert("삭제에 실패하였습니다.");
	 				   		}
						}							
					},
					error: function( xhr, ajaxOptions, thrownError){	
					 	//로딩바 제거.
                    loadingClose();
                    
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
	}
	
	</script>
	
</head>
<body>
	<div id="excel-upload-window" style="display:none; width:340px;">
	        <form id="excelForm" name="excelForm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca-cmpt-obj-excel-upload.do?output=json" enctype="multipart/form-data" >
	        		※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
	           <div>
	               <input name="openUploadFile" id="openUploadFile" type="file" />
	               <input type="hidden" name="upload_run_num" id="upload_run_num" />
	               <br>
	               <div style="text-align: right;">
	                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/ca_cmpt_upload_obj_template.xls" class="k-button" >템플릿다운로드</a>
	                    <input type="submit" value="실행" class="k-button" id="uploadBtn"/>
	               </div>
	           </div>
	       </form>
	   </div>
	<!-- START MAIN CONTNET -->
	
	    <div id="content" >
        <div class="cont_body" >
            <div class="title mt30">대상자 관리</div>
			<div class="table_tin01">
                <div class="px">※ 미대상자 목록에서 선택 후 대상자 목록에서 추가합니다.  (엑셀업로드는 선택된 진단만 업로드(업데이트)됩니다.)</div>
            </div>
            <div class="table_zone"  style="margin-top: 0px;">
               <div>
	                <ul>
	                    <li class="mt10" style="line-height:40px; position: relative; ">
	                        <label for="runNumber" >진단 선택:</label>
	                        <select id="yyyy" style="width:100px;"></select>
	                        <select id="runNumber" style="width:350px;"></select>
	                        
	                        <div style="position: absolute; top: 7px; right: 0;">
                                <a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp;
			                    <a id="excelDownloadBtn" class="k-button" onclick="excelDown(this)" >엑셀 다운로드</a>&nbsp;
			                    <button id="excelUploadBtn" class="k-button" >엑셀 업로드</button>&nbsp;  
	                        </div>
	                	</li>
	                </ul>
                </div>
                
                <div class="table_list">
                    <div id="splitter" style="width:100%; height: 100%; border:none;">
                        <div id="list_pane">
                            <div id="grid" ></div>
                        </div>
                    </div>
                </div>
                
                <script type="text/x-kendo-template"  id="template">                   
				<div  style="float: center;width:100%;height:10%;">
				 	▶  미대상자 목록<br>
	            	<div id="notRunTargetGrid" style="min-height:200px; height: 350px;"></div>
						<div id="runDiv" style="text-align:center; /*min-height:100px;*/ padding-top: 10px;"">
							<button id="insertRun" onclick ="insertRow('in')" class="k-button" style="align:left;width:200px;height:50px;margin-right: 500px;" > 추가 ▼ </button>
							<button id="deleteRun" onclick ="insertRow('out')" class="k-button" style="width:200px;height:50px;" > 삭제 ▲ </button>
						</div>
	            		<!--<div style="text-align: center; padding : 10px;font-size:20px"></div>-->
					</div>
				<div style="width:100%; height:85%; float:center;text-align:center;"></div>
				<div style = "float:center;width:100%;height:10%;">
					▶ 대상자 목록<br>
	            	<div id="runTargetGrid" style="min-height:200px; height: 350px;"></div>
	            	<div style="text-align:right;margin-top:10px"></div>
				</div>	
	            </script>
	            
<%--
<script type="text/x-kendo-template"  id="template">                   
<div  style="float: left;width:45%;height:100%;">
▶  미대상자 목록<br/>
<div id="notRunTargetGrid" style="min-height:250px;"></div>
<div style="text-align: center; padding : 10px;font-size:20px"></div>
</div>
<div style="width:9%; height:100%; float:left;text-align:center;">
<div id="runDiv" style="min-height:50px;"></div>
<div id="insertRunDiv" style="min-height:100px;"> <button id="insertRun" onclick ="insertRow('in')" class="k-button" > 추가 ▶ </button></div><br/>
<div id="deleteRunDiv" style="min-height:100px;"> <button id="deleteRun" onclick ="insertRow('out')" class="k-button" > 삭제 ◀ </button></div>
</div>
<div style = "float:right;width:45%;height:100%;">
▶ 대상자 목록<br/>
<div id="runTargetGrid" style="min-height:250px;"></div>
<div style="text-align:right;margin-top:10px"></div>
</div>	
</script>
--%>
	            
				</div>
        		</div>
	        </div>
    
	<!-- END MAIN CONTENT  --> 	

</body>
</html>