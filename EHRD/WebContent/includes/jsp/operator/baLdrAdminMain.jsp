<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>계급관리</title>
	
	</style>
	
	<script type="text/javascript">               
	yepnope([ {
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
                  

                  //탭 사이즈 재조정
                  var tabStripElement = $("#tabstrip").kendoTabStrip({
		            	animation:  {
		                    open: {
		                        effects: "fadeIn"
		                    }
		                }
		            });
                  var expandContentDivs = function(divs) {
                      divs.height(gridElement.innerHeight()-90);
                  }
                  var resizeAll = function() {
                      expandContentDivs(tabStripElement.children(".k-content")); 
                  }
                  
                  resizeAll();
                  
                  //탭내부의 그리드 리사이즈
                  var compElement = $("#compMapGrid"); // 역량목록
  	              var indcElement = $("#indcMapGrid"); // 행동지표
  	              var gradeElement = $("#gradeMapGrid"); //직급매핑
  	              // 역량목록,행동지표 2개 이므로 /2를 하였음.
  	              compElement.height(tabStripElement.children(".k-content").height()/2-50);
  	              indcElement.height(tabStripElement.children(".k-content").height()/2-50);
  	              gradeElement.height(tabStripElement.children(".k-content").height()-50);
  	            
                  compdataArea = compElement.find(".k-grid-content"),
                  compgridHeight = compElement.innerHeight(),
                  compdataArea.height(compgridHeight - 55); 
                  
              });
              
              /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
        	  //로딩바 선언..
            loadingDefine();
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
        	
  			// show detail   
  			$('#details').show().html(kendo.template($('#template').html()));
        	  // list call
        	$("#grid").empty();
	       	$("#grid").kendoGrid({
	               dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_admin_list.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){	
	                       	return { JOBFLAG : "L" };
	                       } 		
	                   },
	                   schema: {
	   					total: "totalItemCount",
	                   	data: "items",
	                       model: {
	                           fields: {
	                        	   COMPANYID : { type: "int" },
	                        	   JOBLDR_NUM : { type: "int" },
	                        	   JOBLDR_NAME : { type: "string" },
	                        	   COMPANY_JOB_CD : { type: "string" },
	                        	   JOBLDR_COMMENT : { type: "string" },
	                        	   MAIN_TASK : { type: "string" },
	                        	   JOBLDR_FLAG : { type: "string" },
	                        	   USEFLAG : { type: "string" },
	                        	   RUN_DATE : { type: "string" },
	                        	   CNT: { type: "string" },
	                        	   RUN_STATE : { type: "string" }
	                           }
	                       }
	                   },
	                   pageSize: 30, serverPaging: false, serverFiltering: false, serverSorting: false
	               },
	               columns: [
	                   {
	                       field:"JOBLDR_NAME",
	                       title: "계급명",
	                       filterable: true,
						    width:130,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						    attributes:{"class":"table-cell", style:"text-align:left;text-decoration: underline;"},
		                    template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${JOBLDR_NUM});' >${JOBLDR_NAME} [코드 : ${JOBLDR_NUM}]</a>"
	                   },
	                   {
	                       field: "JOBLDR_COMMENT",
	                       title: "계급정의",
						   width:200,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:left"} 
	                   },
	                   {
	                       field: "USEFLAG_STRING",
	                       title: "사용여부",
	                       width:80,
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
	               pageable: true,
	               selectable: "row",
	               pageable : {
                       refresh : false,
                       pageSizes :[10,20,30],
                       buttonCount : 5
                   }
	   	       	 
	       	});
	       	
	        fn_compMaping(); //역량매핑 화면 출력
    	    fn_indcList();   //행동지표 화면 출력
    	    fn_gradeMaping(); //직급매핑 화면 출력
    	    buttonEvent();
    	    $("#mode").val("add");
        	  
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
        	  
        	   // list new btn add click event
        	   $("#newBtn").click( function(){
        		 	
        		   $("#splitter").data("kendoSplitter").expand("#detail_pane");
        		   
	        		// show detail 
					$('#details').show().html(kendo.template($('#template').html()));					
					
					 var tabStrip = $("#tabstrip").kendoTabStrip({
		                 animation:  {
		                     open: {
		                         effects: "fadeIn"
		                     }
		                 }
		             }).data("kendoTabStrip");
		             tabStrip.select(0); 
		             
		             
					buttonEvent();
	        		
					
					fn_compMaping(); //역량매핑 화면 출력
		    	    fn_indcList();   //행동지표 화면 출력
		    	    fn_gradeMaping(); //직급매핑 화면 출력
		    	    
		    	    fn_newCompList();
					fn_newIndcList(); //행동지표 추가 목록 초기화
					$("#newCompGrid .k-grid-content").height("195");
					$("#newIndcGrid .k-grid-content").height("195");
					
					kendo.bind( $(".tabular"),  null );
					$("#mode").val("add");
					$('input:radio[id=useFlag]:input[value=Y]').attr("checked", true);//사용여부
					
					$("#delBtn").hide();
					
					/* $("#compMapGrid").data("kendoGrid").dataSource.read();
					$("#indcMapGrid").data("kendoGrid").dataSource.read();
					$("#newCompGrid").data("kendoGrid").dataSource.read();
					$("#newIndcGrid").data("kendoGrid").dataSource.read(); */
		            //브라우저 resize 이벤트 dispatch..
		             $(window).resize();

        	  });

    		//브라우저 resize 이벤트 dispatch..
             $(window).resize();
             
          }
      }]);   
        
	</script>
	<script type="text/javascript">
	//compDelMod 가 rowDelete면 해당 로우 삭제, DbDelete면 DB에서 삭제
	var compDelMod = "DbDelete";
	//역량목록 리스트 출력 kht
	function fn_compMaping(){
		$("#compMapGrid").kendoGrid({
            dataSource : {
                type : "json",
                transport : {
                    read : {
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_cm_map_list.do?output=json",
                        type : "POST"
                    },
                    parameterMap : function(options, operation) {
                        return {
                        	jobLdrNum : $("#jobLdrNum").val()
                        };
                    }
                },
                schema : {
                    total : "totalItemCount",
                    data : "items",
                    model : {
                        fields : {
                            CMPNUMBER : {
                                type : "number",
                                editable : false,
                            },
                            /* STD_SCORE: {
                                type : "string",
                                editable : false
                            }, */
                            ROWNUMBER : {
                                type : "string",
                                editable : false
                            },
                            CHECKFLAG : {
                                type : "string",
                                editable : false
                            },
                            
                        }
                    }
                }
            },
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
            pageable : false,
            editable : false,
            selectable: "row",
            height: "100px",
            columns : [
                    {
                        field : "CMPGROUP_STRING",
                       
                        title : "역량군",
                        width : 120,
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
                        field : "CMPNAME",
                        title : "역량명",
                        width : 300,
                        headerAttributes : {
                            "class" : "table-header-cell",
                            style : "text-align:center"
                        },
                        attributes : {
                            "class" : "table-cell",
                            style : "text-align:center"
                        },
                    },
                    /* {
                    	field : "STD_SCORE",
                        title : "요구수준",
                        width : 200,
                        headerAttributes : {
                            "class" : "table-header-cell",
                            style : "text-align:center"
                        },
                        attributes : {
                            "class" : "table-cell",
                            style : "text-align:center"
                        }
                    }, */
                    
                    {
                        title : "삭제",
                        filterable : false,
                        sortable : false,
                        width : 90,
                        headerAttributes : {
                            "class" : "table-header-cell",
                            style : "text-align:center"
                        },
                        attributes : {
                            "class" : "table-cell",
                            style : "text-align:center"
                        },
                        template : "<button id='compIndcDel_${CMPNUMBER}' class='k-button' onclick='javascript:fn_CompIndcDel(${CMPNUMBER},null);'>삭제</button>"
                    } ],
                dataBound:function(){}
        });
	    $(window).resize();
	}
	/* function fn_sort(cmpNum , checkbox){
		$("#newIndcGrid").data("kendoGrid").dataSource.sort({
				 field: "CHECKFLAG", dir: "desc"

		   //체크된 값들만 나오도록 하는 필터 구현 //주석처리
		   /*var array = $('#newIndcGrid').data('kendoGrid').dataSource.data();
			var res = $.grep(array, function (e) {
				return e.CMPNUMBER == cmpNum;
	       });
			if (checkbox.checked == true) {
				res[0].CHECKFLAG = "checked=1";
			} else {
				res[0].CHECKFLAG = '';
			} 
			  $("#newIndcGrid").data("kendoGrid").dataSource.filter({
		            "field":"CHECKFLAG",
		            "operator":"eq",
		            "value":"checked=\"1\""
		     });  
			 for(var i = 0 ; i < cmpNum.length ; i++){
		     $("#compMapGrid").data("kendoGrid").dataSource.filter({
	         "field":"CMPMUNBER",
	         "operator":"or",
	         "value":"checked=\"1\""
	     });
	}   */
	//행동지표 상세보기
	 function fn_indcList(){
		 $("#indcMapGrid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_indc_map_list.do?output=json",
	                        type : "POST"
	                    },
	                    parameterMap : function(options, operation) {
	                        return {
	                        	jobLdrNum : $("#jobLdrNum").val()
	                        };
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        fields : {
	                            CMPNUMBER : {
	                                type : "number",
	                                editable : false
	                            },
	                            BHV_INDC_NUM : {
	                                type : "number",
	                                editable : false
	                            },
	                          
	                            
	                            ROWNUMBER : {
	                                type : "string",
	                                editable : false
	                            },
	                            CHECKFLAG : {
	                                type : "string",
	                                editable : false
	                            },
	                            
	                        }
	                    }
	                }
	            },
	            filterable: true,
	            filterable: {
	        	      extra : false,
	        	      messages : {filter : "필터", clear : "초기화"},
	        	      operators : { 
	        	       string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
	        	       number : { eq : "같음", gte : "이상", lte : "이하"}
	        	      }
	        	     },
	            scrollable : false,
	            sortable : true,
	            pageable : false,
	            selectable: "row",
	            editable : false,
	            height: "100px",
	            columns : [
					{
					    field : "CMPGROUP_STRING",
					    title : "역량군",
					    width : 150,
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
                        field : "CMPNAME",
                        title : "역량명",
                        width : 150,
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
                        field : "BHV_INDICATOR",
                        title : "행동지표",
                        width : 200,
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
                        title : "삭제",
                        width : 5,
                        headerAttributes : {
                            "class" : "table-header-cell",
                            style : "text-align:center"
                        },
                        attributes : {
                            "class" : "table-cell",
                            style : "text-align:center"
                        },
                        template : "<button id='compIndcDel_${CMPNUMBER}'  class='k-button' onclick='javascript:fn_CompIndcDel(${CMPNUMBER},${BHV_INDC_NUM});'>삭제</button>"
                    } ],
                dataBound:function(){}
        });
	  $(window).resize();
     
	}
	//직급매핑 상세보기
	 function fn_gradeMaping(){
			$("#gradeMapGrid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_gd_map_list.do?output=json",
	                        type : "POST"
	                    },
	                    parameterMap : function(options, operation) {
	                        return {
	                        	jobLdrNum : $("#jobLdrNum").val()
	                        };
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        fields : {
	                        	GRADE_NUM : {
	                                type : "number",
	                                editable : false,
	                            },
	                            COMMONCODE : {
	                                type : "string",
	                                editable : false,
	                            },
	                            ROWNUMBER : {
	                                type : "string",
	                                editable : false
	                            },
	                            JOBLDR_NUM : {
	                                type : "string",
	                                editable : false
	                            },
	                            CHECKFLAG : {
	                                type : "string",
	                                editable : false
	                            },
	                            
	                        }
	                    }
	                }
	            },
	            filterable: true,
	            filterable: {
	        	      extra : false,
	        	      messages : {filter : "필터", clear : "초기화"},
	        	      operators : { 
	        	       string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
	        	       number : { eq : "같음", gte : "이상", lte : "이하"}
	        	      }
	        	     },
	            scrollable : false,
	            sortable : true,
	            pageable : false,
	            selectable: "row",
	            editable : false,
	            columns : [
	                    {
							field : "CHECKFLAG",
							title : "선택",
							filterable : false,
							sortable : false,
							headerAttributes : {
							    "class" : "table-header-cell",
							    style : "text-align:center"
							},
							attributes : {
							    "class" : "table-cell",
							    style : "text-align:center"
							},
							template : "<div style=\"text-align:center\"><input type=\"checkbox\" name=\"${COMMONCODE}\" onclick=\"modifyYnFlag(this,${COMMONCODE},${JOBLDR_NUM})\" #: CHECKFLAG #/></div>"
                        },
                        {
	                        field : "JOBLDR_NAME",
	                        title : "계급명",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        },
	                    },
	                    {
	                        field : "CMM_CODENAME",
	                        title : "직급명",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        },
	                    } ],
	                dataBound:function(){}
	        });
		    $(window).resize();
		}
	function fn_newCompList(){
		 //역량 추가 리스트
        $("#newCompGrid").kendoGrid({
        	dataSource: {
                 type: "json",
                 transport: {
                     read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_cm_new_list.do?output=json", type:"POST" },
                     parameterMap: function (options, operation){
                          return {jobLdrNum : $("#jobLdrNum").val() };
                     }
                 },
                 schema: {
                 	total : "totalItemCount",
                      data: "items",
                      model: {
                     	 fields : {
	                            CMPNUMBER : {
	                                type : "number",
	                                editable : false
	                            },
	                            /* STD_SCORE : {
	                                type : "string",
	                                editable : false
	                            },*/	
                             	ROWNUMBER : {
	                                type : "string",
	                                editable : false
	                            },
	                            CHECKFLAG : {
	                                type : "string",
	                                editable : false
	                            },
	                            
	                        }
                      }
                 },
             },
             columns : [
                        {
							field : "CHECKFLAG",
							title : "선택",
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
							template : "<div style=\"text-align:center\"><input type=\"checkbox\" name=\"compCheck_${CMPNUMBER}\" data=\"${CMPNUMBER}\" id=\"compCheck\" onclick=\"compListCheckBox(${CMPNUMBER},this);\" #: CHECKFLAG #/></div>"
                        },
						{
                            field : "CMPGROUP_STRING",
                            title : "역량군",
                            width : 150,
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
                            field : "CMPNAME",
                            title : "역량명",
                            headerAttributes : {
                                "class" : "table-header-cell",
                                style : "text-align:center"
                            },
                            attributes : {
                                "class" : "table-cell",
                                style : "text-align:center"
                            },
                        },
                        /* {
                            field : "STD_SCORE",
                            title : "요구수준",
                            width : 200,
                            headerAttributes : {
                                "class" : "table-header-cell",
                                style : "text-align:center"
                            },
                            attributes : {
                                "class" : "table-cell",
                                style : "text-align:center"
                            },
                            template: function(dataItem){
                            	var stdScore = "";
                            	if(dataItem.STD_SCORE){
                            		stdScore = dataItem.STD_SCORE;
                            	}
                                return "<input type='text' id='sc_"+dataItem.CMPNUMBER+"' value='"+stdScore+"' class='k-input input_95' style='text-align:center; ' onkeyup='setValue("+dataItem.STD_SCORE+","+dataItem.CMPNUMBER+", this);' />";
                                   
                            }
                        }, */
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
             pageable : false,
             resizable : true,
             selectable: "row",
             reorderable : true,
             scrollable : true,
             editable : false,
             height: "230px",
         }); 

	}
	//행동지표 팝업 리스트 kht
	 function fn_newIndcList(){
		 $("#newIndcGrid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_indc_new_list.do?output=json",
	                        type : "POST"
	                    },
	                    parameterMap : function(options, operation) {
	                        return {
	                        	jobLdrNum : $("#jobLdrNum").val()
	                        };
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        fields : {
	                            CMPNUMBER : {
	                                type : "number",
	                                editable : false
	                            },
	                            BHV_INDC_NUM : {
	                                type : "number",
	                                editable : false
	                            },
	                            CHECKFLAG : {
	                                type : "string",
	                                editable : false
	                            },
	                            
	                        }
	                    }
	                }
	            },
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
                pageable : false,
                resizable : true,
                reorderable : true,
                scrollable : true,
                selectable: "row",
                editable : false,
                height: "230px",
	            columns : [
						{
						    field : "USEFLAG",
						    title : "선택",
						    filterable : false,
						    sortable : false,
						    width : 25,
						    headerAttributes : {
						        "class" : "table-header-cell",
						        style : "text-align:center"
						    },
						    attributes : {
						        "class" : "table-cell",
						        style : "text-align:center"
						    },
						    template : "<div id=\"indcObj_${CMPNUMBER}\" style=\"text-align:center\"><input type=\"checkbox\" name=\"indcCheck_${CMPNUMBER}\" data=\"${BHV_INDC_NUM}\" id=\"indcCheck_${BHV_INDC_NUM}\"  onclick=\"indcListCheckBox(${CMPNUMBER},this);\" #: CHECKFLAG #/></div>"
						},
	                    {
	                        field : "CMPGROUP_STRING",
	                        title : "역량군",
	                        width : 50,
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        },
		                },
		                {
	                        field : "CMPNAME",
	                        title : "역량명",
	                        width : 50,
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        },
		                },
	                    {
	                        field : "BHV_INDICATOR",
	                        title : "행동지표",
	                        width : 200,
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
	     
		}
	  
	//직급매핑정보 변경 이벤트.
		function modifyYnFlag(checkbox,commonCode,jobLdrNum) {
		  	
		    var array = $('#gradeMapGrid').data('kendoGrid').dataSource.data();
			var res = $.grep(array, function (e) {
				return e.COMMONCODE == checkbox.name;
	        });
			
			var useJobLdr = res[0].JOBLDR_NUM;

			if(jobLdrNum == "undefined"||jobLdrNum == null || jobLdrNum == ""||useJobLdr==$("#jobLdrNum").val() ){
				if (checkbox.checked == true) {
					res[0].CHECKFLAG = "checked";
				} else {
					res[0].CHECKFLAG = '';
				}
			}
			
	        else if(checkbox.checked == true){
	        	var isDel = confirm("이미 다른 계급에 매핑된 직급이 존재합니다. 변경하시겠습니까?");
			 	if(isDel){
			 		if (checkbox.checked == true) {
						res[0].CHECKFLAG = "checked";
					} else {
						res[0].CHECKFLAG = '';
					}
			 	}else{
					res[0].CHECKFLAG = '';
					checkbox.checked = false;
			 	}
	        }
		}
	  
	// 계급관리 상세보기.
    function fn_detailView(jobLdrNum){
		
    	var grid = $("#grid").data("kendoGrid");
        var data = grid.dataSource.data();

	    var res = $.grep(data, function (e) {
	        return e.JOBLDR_NUM == jobLdrNum;
	    });
	
	    var selectedCell = res[0];
	    
		$("#jobLdrNum").val(selectedCell.JOBLDR_NUM);
        
        
        var selectedCell;
        for(var i = 0; i<data.length; i++) {
            var dataItem = data[i];
            if(jobLdrNum == dataItem.JOBLDR_NUM){
            	selectedCell = dataItem;	            	
                  
             var selectRow =  {
            		JOBLDR_NUM: selectedCell.JOBLDR_NUM,
            		JOBLDR_NAME: selectedCell.JOBLDR_NAME,     
            		COMPANY_JOB_CD: selectedCell.COMPANY_JOB_CD,
            		JOBLDR_COMMENT :selectedCell.JOBLDR_COMMENT, 
            		MAIN_TASK :selectedCell.MAIN_TASK,
             		RUN_START: selectedCell.RUN_START,             
             		RUN_END: selectedCell.RUN_END,           
             		RUN_DATE : selectedCell.RUN_DATE,           
             		CNT: selectedCell.CNT,   
             		RUN_STATE: selectedCell.RUN_STATE,
             		MODE: "mod"      
           	 };
       
          	 // 상세영역 활성화
             $("#splitter").data("kendoSplitter").expand("#detail_pane");
             
             // show detail 
             //$('#details').show().html(kendo.template($('#template').html()));        
             
         	 // save btn add click event
          	 //buttonEvent();
         	 //삭제 버튼 모드 변경
          	 compDelMod = "DbDelete";
          	 // detail binding data
             kendo.bind( $(".tabular"), selectRow );
             $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//사용여부
                 
           //브라우저 resize 이벤트 dispatch..
             $(window).resize();
            	break;
            } // end if
        } // end for
        
        //역량매핑 정보 가져오기 
         fn_compMaping();
        //행동지표 정보 가져오기 
		 fn_indcList();
        //직급매핑 정보 가져오기
         fn_gradeMaping();
        
         fn_newCompList();
		 fn_newIndcList(); //행동지표 추가 목록 초기화
		 $("#delBtn").show();
		 
		 $("#newCompGrid .k-grid-content").height("195");
		 $("#newIndcGrid .k-grid-content").height("195");
       
      
        // template에서 호출된 함수에 대한 이벤트 종료 처리.
        if(event.preventDefault){
            event.preventDefault();
        } else {
            event.returnValue = false;
        }
       
     }
	 //역량 추가 팝업창
	 //역량 목록에서 이미 선택되어 있는 체크박스에서 체크를 해제 할 경우 해당되는 행동지표 체크 모두 해제
	 //새로운 역량을 체크 할 경우 하위 행동지표 모두 선택 
	 //역량 저장시 하나의 행동지표를 가져야 한다.
    function compListCheckBox(cmpNumber,obj){
		 //역량에서 체크를 하면 해당 행동지표가 모두 체크 되고 체크된 항목을 정렬을 한다.
		 var array = $('#newIndcGrid').data('kendoGrid').dataSource.data();
		 var res = $.grep(array, function (e) {
				return e.CMPNUMBER == cmpNumber;
	     });
 		 var state = $(obj).attr("checked");
		 
		 for(var i = 0 ; i < res.length ; i++ ){
			 if(state == "checked"){
				 res[i].CHECKFLAG = "checked=\"1\"";
			 }else{
				 res[i].CHECKFLAG = '';
			 }
		 }
		 
		 $("#newIndcGrid").data("kendoGrid").dataSource.filter({
	            "field":"CHECKFLAG",
	            "operator":"eq",
	            "value":"checked=\"1\""
	      });
		 
		 $("input[name=indcCheck_"+cmpNumber+"]").each(function(no){
			 if( state == "checked" ){
				$(this).attr('checked', true);
				//res[no].CHECKFLAG = "checked=\"1\""; //CHECKFLAG를 1로 변경해서 정렬한다.
			}else{
			    $(this).attr('checked', false);
			    //res[no].CHECKFLAG = '';  //CHECKFLAG를 초기화.
			}
		 }); 
		 
		 /* if($("#indcObj_"+cmpNumber+"").length){
			 var state = $(obj).attr("checked");﻿
			 $("input[name=indcCheck_"+cmpNumber+"]").each(function(no){
				 if( state == "checked" ){
					$(this).attr('checked', true);
					res[no].CHECKFLAG = "checked=1"; //CHECKFLAG를 1로 변경해서 정렬한다.
				}else{
				    $(this).attr('checked', false);
				    res[no].CHECKFLAG = '';  //CHECKFLAG를 초기화.
				}
			 });
			 fn_sort(cmpNumber,obj); //정렬
		 }else{
		   	 alert("선택된 역량은 행동지표가 없습니다.");
		   	 $(obj).attr("checked",false);
		 } */
	 }
	 //행동지표가 모두 해제 되면 상위 역량도 체크 해제 
	 //역량이 체크 되지 않은 상태에서 행동지표를 체크하면 역량 자동 체크
	 function indcListCheckBox(cmpNumber){
		 if( $(":checkbox[name='indcCheck_"+cmpNumber+"']:checked").length==0 ){
 		    $("input[name=compCheck_"+cmpNumber+"]").attr("checked",false);
 		 }else if($(":checkbox[name='indcCheck_"+cmpNumber+"']:checked").length==1){
 			$("input[name=compCheck_"+cmpNumber+"]").attr("checked",true);
 		}
	 }

	 //요구수준 숫자 유효성 검사 
	 /* function isFloat(obj) {
		 var word = obj.value ;
			var reg1 = /^(\d{1,1})([.]\d{0,2}?)?$/;
			if( !reg1.test(word)){
				alert("숫자 형식이 잘못되었습니다.");
				obj.value = "";
				obj.focus();
				return false ;
			}else if(word > 5.01){
				alert("요구수준은 5점 이하로 입력세요.");
				obj.value = "";
				obj.focus();
				return false ;
			}
	 } */
	 	
	 /* function setValue(score,cmpNum, obj){
		 
		 var array = $('#compMapGrid').data('kendoGrid').dataSource.data();            
		 var res = $.grep(array, function (e) {
	        return e.STD_SCORE == score;
	     });
		 if($("#sc_"+cmpNum+"").val()!=null && $("#sc_"+cmpNum+"").val()!="" ){
	     	isFloat(obj); //숫자 유효성 체크
		 }
	 } */
	 
	 
	 //역량  , 행동지표 삭제 
	 function fn_CompIndcDel(cmpNumber , indcNumber){
		 var mode=""; //역량 , 행동지표 구분
		 var isDel ="";

		 if(indcNumber != null && indcNumber != "" ){
			 mode = "indc"; // 행동지표
			 isDel = confirm("행동지표를 삭제 하시겠습니까?");
		 }else{
			 mode = "comp"; // 역량목록
			 isDel = confirm("역량을 삭제 하시겠습니까?");
		 }
		 
	 	 if(compDelMod == "DbDelete"){ // 역량을 추가 하지 않고 삭제 할 경우
	 		 var compDelChk = "N";
	 		 array = $('#indcMapGrid').data('kendoGrid').dataSource.data();
			//역량의 모든 행동지표가 삭제 될 경우 역량도 삭제
			 var resCompDel = $.grep(array, function (e) {
				return e.CMPNUMBER == cmpNumber ;
		    }); 
			//리스트의 목록이 1 에서 삭제가 0 이면 ...
			if(resCompDel.length == 1){
				compDelChk = "Y";
			}
			
	 		 if(isDel){
				//로딩바생성.
                 loadingOpen();
				var params = {
	     		    jobLdrNum : $("#jobLdrNum").val(),
	     		    cmpNumber : cmpNumber,
	     		    indcNumber : indcNumber,
	     		    mode : mode,
	     		   compDelYn : compDelChk
	      		};
	     		
	     		$.ajax({
	     			type : 'POST',
						url:"/operator/ba/ba_job_indc_del.do?output=json",
						data : { item: kendo.stringify( params ) },
						complete : function( response ){
							//로딩바 제거.
                            loadingClose();
							var obj  = eval("(" + response.responseText + ")");
							if(obj.saveCount != 0){

					            $("#splitter").data("kendoSplitter").expand("#detail_pane");
		                        // 목록 read
		                        $("#grid").data("kendoGrid").dataSource.read();
					            $("#compMapGrid").data("kendoGrid").dataSource.read();
	        					$("#indcMapGrid").data("kendoGrid").dataSource.read();
	        					$("#gradeMapGrid").data("kendoGrid").dataSource.read();
	        					
								alert("삭제되었습니다.");	
							}else{
								alert("삭제를 실패 하였습니다.");
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
		 }else if(compDelMod == "rowDelete"){
			 if(isDel){
				var array;
				//역량 로우 삭제
				if(mode == "comp"){	
					
					array = $('#compMapGrid').data('kendoGrid').dataSource.data();
					var res = $.grep(array, function (e) {
				        return e.CMPNUMBER == cmpNumber;
				    });
					//역량 삭제
				    $('#compMapGrid').data('kendoGrid').dataSource.remove(res[0]);
				    
				    array = $('#indcMapGrid').data('kendoGrid').dataSource.data();
					
				    var res = $.grep(array, function (e) {
				        return e.CMPNUMBER == cmpNumber;
				    });
					//역량에 해당하는 행동지표 삭제
					for(var i = 0 ; i < res.length ; i++){
				   	 $('#indcMapGrid').data('kendoGrid').dataSource.remove(res[i]);
					}
				    
				}
				//행동지표 로우삭제
				else if(mode == "indc"){
					
					array = $('#indcMapGrid').data('kendoGrid').dataSource.data();
					
					var res = $.grep(array, function (e) {
						return e.BHV_INDC_NUM == indcNumber ;
				    });
					
					$('#indcMapGrid').data('kendoGrid').dataSource.remove(res[0]);
				    
					//역량의 모든 행동지표가 삭제 될 경우 역량도 삭제
					 var resCompDel = $.grep(array, function (e) {
						return e.CMPNUMBER == cmpNumber ;
				    }); 
				    	
					if(resCompDel[0] == null || resCompDel[0]=="" || resCompDel[0]=="undefined"){
						array = $('#compMapGrid').data('kendoGrid').dataSource.data();
						var res = $.grep(array, function (e) {
					        return e.CMPNUMBER == cmpNumber;
					    });
						//역량 삭제
					    $('#compMapGrid').data('kendoGrid').dataSource.remove(res[0]);
					}
				}
			 }
		 }
	 } 
	// 역량 추가 팝업 저장버튼 클릭시
  		function saveCompBtn(){
  			
  		
    		var validation_yn="Y";
    		var compGrid = $("#newCompGrid").data("kendoGrid");
	        var compData = compGrid.dataSource.data();
	        
	        //요구수준 입력값 체크
	        //validation_yn을 체크하여 반복제어
	        /* $.each(compData, function(index, obj) {
	        	if(obj.CMPNUMBER == $(":checkbox[name='compCheck_"+obj.CMPNUMBER+"']:checked").attr("data")){
	        		if(($("#sc_"+obj.CMPNUMBER+"").val()==null || $("#sc_"+obj.CMPNUMBER+"").val()=="")&& validation_yn=="Y"){
	        			alert("요구수준을 입력해 주세요.");
	        			validation_yn = "N";
	        			return;
	        		}
	        	}
	        }); */
	        //유효성 체크 실행
	        if(validation_yn=="Y"){
	        	compDelMod = "rowDelete"; //역량 목록 삭제 버튼 로우 삭제 로직으로 변경 
	        	
	        	var compArray = $('#compMapGrid').data('kendoGrid').dataSource.data();
			    var compLength = compArray.length;
				
			    //역량 목록 (detail 창 초기화 )
			    for(var i=0; i<compLength; i++){
				$('#compMapGrid').data('kendoGrid').dataSource.remove(compArray[0]);
			    };
	 
				 //체크된 역량을 detail 창의 역량 목록으로 이동  
		         $.each(compData, function(index, obj) {
		        	if(obj.CMPNUMBER == $(":checkbox[name='compCheck_"+obj.CMPNUMBER+"']:checked").attr("data")){
		        		$("#compMapGrid").data("kendoGrid").dataSource.insert({
		            		CMPGROUP_STRING: obj.CMPGROUP_STRING,
		            		CMPNAME:obj.CMPNAME, 
		            		CMPNUMBER:obj.CMPNUMBER, 
		            		//STD_SCORE:$("#sc_"+obj.CMPNUMBER+"").val(),
		            		ROWNUM:null, 
		            		CHECKFLAG:null
		            	})
		         	}
	
		         });
		         $('#compMapGrid').data('kendoGrid').refresh();
		         
		         
		         var indcArray = $('#indcMapGrid').data('kendoGrid').dataSource.data();
				 var indcLength = indcArray.length;
					
				    //역량 목록 (detail 창 초기화 )
				 for(var i=0; i<indcLength; i++){
				 $('#indcMapGrid').data('kendoGrid').dataSource.remove(indcArray[0]);
				 };
				 
		         var indcGrid = $("#newIndcGrid").data("kendoGrid");
		         var indcData = indcGrid.dataSource.data();
	
		         $.each(indcData, function(index, obj) {
		        	 if(obj.BHV_INDC_NUM == $(":checkbox[id='indcCheck_"+obj.BHV_INDC_NUM+"']:checked").attr("data")){
		        		$("#indcMapGrid").data("kendoGrid").dataSource.insert({
		            		CMPGROUP_STRING: obj.CMPGROUP_STRING,
		            		CMPNAME:obj.CMPNAME, 
		            		CMPNUMBER:obj.CMPNUMBER, 
		            		BHV_INDC_NUM:obj.BHV_INDC_NUM,
		            		BHV_INDICATOR:obj.BHV_INDICATOR,
		            		ROWNUM:null
		            	});
		         	}
		         });
		         $('#indcMapGrid').data('kendoGrid').refresh();
		         //팝업창 닫음 
	     		 $("#newCompList-window").data("kendoWindow").close();
	        }
     }
  	// dtl del btn add click event	
	  function buttonEvent(){
		
	       	$("#delBtn").click( function(){
	       	 	
	        	var isDel = confirm("삭제 하시겠습니까?");
	        	
	            if(isDel){ //계급삭제 영역
	            	//로딩바생성.
	            	var delJob = "Y";
	            	var delComp = "Y";
                	loadingOpen();
	            	var params = {
	        		    jobLdrNum : $("#jobLdrNum").val(),
	        			FLAG : "5",	
	         		};
	        		$.ajax({
	        			type : 'POST',
						url:"/operator/ca/ca_common_del.do?output=json",
						data : { item: kendo.stringify( params ) },
						complete : function( response ){
							//로딩바 제거.
                            loadingClose();
							var obj  = eval("(" + response.responseText + ")");
							if(obj.saveCount != 0){
								$("#grid").data("kendoGrid").dataSource.read();

                                kendo.bind( $(".tabular"),  null );
                                compDelMod = "DbDelete"; // 역량 삭제 버튼 모드 초기화 
                                $("#compMapGrid").data("kendoGrid").dataSource.read();
            					$("#indcMapGrid").data("kendoGrid").dataSource.read();
            					$("#gradeMapGrid").data("kendoGrid").dataSource.read();
                                // 상세영역 비활성화
                                $("#splitter").data("kendoSplitter").collapse("#detail_pane");
                                delJob = "Y";
							}else{
								delJob = "N";
							}							
						},
						error: function( xhr, ajaxOptions, thrownError){
							//로딩바 제거.
                            loadingClose();
                            delJob = "N";
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
	        		//계급삭제가 올바르게 이루어 졌다면 역량 행동지표 삭제 
	        		if(delJob == "Y" ){ 
	        			//로딩바생성.
	                 	loadingOpen();
	    		 		var params = {
	                    	    LIST :  $('#compMapGrid').data('kendoGrid').dataSource.data(),
	                            LIST2 : $('#indcMapGrid').data('kendoGrid').dataSource.data(),
	                            LIST3 : $('#gradeMapGrid').data('kendoGrid').dataSource.data()
	                    };
	               		$.ajax({
	               			type : 'POST',
	       					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_admin_comp_del.do?output=json",
	       					data : { 
	       						item: kendo.stringify( params ),
	       						jobLdrNum : $("#jobLdrNum").val()
	       					},
	       					
	       					complete : function( response ){
	       						//로딩바 제거.
	                            loadingClose();
	       						var obj  = eval("(" + response.responseText + ")");
	       						if(obj.saveCount != 0){
	       							delComp = "Y";
	                                compDelMod = "DbDelete"; // 역량 삭제 버튼 모드 초기화 
	       						}else{
	       							delComp = "N";
	       						}							
	       					},
	       					dataType : "json"
	       				});
	        		}
	        		if(delJob=="Y" && delComp=="Y"){
	        			alert("삭제되었습니다.");	
	        		}else{
	        			alert("삭제에 실패 하였습니다.");
	        		}
	        	}
	       	});
		   
          
		//save btn add click event
       	  $("#saveBtn").click( function(){  

       		if($("#jobLdrName").val()=="") {
     			alert("계급명을 입력해 주십시오.");
     			return false;
     		}	
     		var isDel = confirm("계급정보를 저장하시겠습니까?");
		 	 if(isDel){
		 		//로딩바생성.
             	loadingOpen();
		 		var params = {
                	    LIST :  $('#compMapGrid').data('kendoGrid').dataSource.data(),
                        LIST2 : $('#indcMapGrid').data('kendoGrid').dataSource.data(),
                        LIST3 : $('#gradeMapGrid').data('kendoGrid').dataSource.data()
                };
           		$.ajax({
           			type : 'POST',
   					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_job_admin_save.do?output=json",
   					data : { 
   						item: kendo.stringify( params ),
   						mode : $("#mode").val(),
   	           			jobLdrNum : $("#jobLdrNum").val(),
   	           			jobLdrName : $("#jobLdrName").val(),
   	           			comJobCd : $("#comJobCd").val(),
   	           			jobLdrComment : $("#jobLdrComment").val(),
   	           			mainTask : $("#mainTask").val(),
   	           			useFlag : $(':radio[id="useFlag"]:checked').val(),
   	           			jobFlag : "L"
   					},
   					
   					complete : function( response ){
   						//로딩바 제거.
                        loadingClose();
   						var obj  = eval("(" + response.responseText + ")");
   						if(obj.saveCount != 0){
   			                // 상세영역 활성화
                            // $("#splitter").data("kendoSplitter").expand("#detail_pane");
                            $("#grid").data("kendoGrid").dataSource.read();

                            compDelMod = "DbDelete"; // 저장후에는 바로 삭제 되도록 변경 
                            
                            // 상세영역 비활성화
                            if($("#mode").val()=="add"){
                            	$("#splitter").data("kendoSplitter").collapse("#detail_pane");
                            }
   							$("#mode").val("mod");//저장후 수정모드로 변경
   							$("#compMapGrid").data("kendoGrid").dataSource.read();
     					 	$("#indcMapGrid").data("kendoGrid").dataSource.read();
     					 	$("#gradeMapGrid").data("kendoGrid").dataSource.read();
     					 	alert("저장되었습니다.");	
   							
   						}else{
   							alert("저장에 실패 하였습니다.");
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
         });
		
		
      	//cancel btn add click event
       	$("#cencelBtn").click( function(){
        	kendo.bind( $(".tabular"),  null );
        		 
        	$("#cudMode").val()=="";
        		 
        	$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
            $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
        });
      		
       	//역량추가 팝업 취소 버튼 kht 
       	$("#cencelCompBtn").click( function(){
        		//팝업창 닫음 
        		$("#newCompList-window").data("kendoWindow").close();
        		
        });
       	
        	//역량 추가 팝업 kht
       	 $("#newCompBtn").click(function(){
       		 if( !$("#newCompList-window").data("kendoWindow") ){
                    $("#newCompList-window").kendoWindow({
                        width:"800px",
                        height:"580px",
                        resizable : true,
                        title : "역량추가",
                        modal: true,
                        visible: false
                    });
                 }
	       		$("#newIndcGrid").data("kendoGrid").dataSource.filter({
		            "field":"CHECKFLAG",
		            "operator":"eq",
		            "value":"checked=\"1\""
		      });
                 $("#newCompList-window").data("kendoWindow").center();
                 $("#newCompList-window").data("kendoWindow").open();
             });
 	   }
	
	</script>
	
</head>
<body>
	<div id="excel-upload-window" style="display:none; width:320px;">
		<form method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_ldr_excel_upload.do?" >
		<input type ="hidden" name="jobFlag" value="L">
	       <div>
	           <input name="files" id="files" type="file" />
	           </br>
	           <div style="text-align: right;">
	           		<input type="submit" value="엑셀 업로드" class="k-button" id="uploadBtn"/>
	           </div>
	       </div>
	   </form>
   </div>
	<!-- START MAIN CONTNET -->
	
	<div id="content">
        <div class="cont_body">
            <div class="title mt30">계급관리</div>
			<div class="table_tin01">
                <div class="px">※ 계급이란 컨설팅에서 나온 결과로 역량과 맵핑이 되는 기준입니다.</div>
                <div class="px">※ 인사에서 사용하는 직급과 맵핑을 해야 진단이 제대로 진행이 됩니다..</div>
            </div>
            <div class="table_zone" >
                <div class="table_btn">
                	<%-- <a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp; --%>
                	<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ba/ba_ldr_list_excel.do?jobFlag=L" >엑셀 다운로드</a>&nbsp;
                    <!-- <button id="excelUploadBtn" class="k-button" >엑셀 업로드</button>&nbsp; -->
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
	 	<script type="text/x-kendo-template"  id="template"> 
 				<div id="tabstrip">
                    <ul>
                        <li class="k-state-active">
                            	기본정보
                        </li>
                        <li>
                           		 역량매핑
                        </li>
						<li>
                           		 직급매핑
                        </li>
                    </ul>
                <div style="overflow-y:auto;">
				<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
					<tr><td colspan="2" style="font-size:16px;">
                        <strong>&nbsp; 계급관리 </strong>
						<input type="hidden" id="mode" data-bind="value:MODE" readonly="readonly" />
						<input type="hidden" id="jobLdrNum" data-bind="value:JOBLDR_NUM" style="border:none" readonly="readonly" />
					</td></tr>
			    	<tr>
				    	<td width="100px"  class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 계급명 <span style="color:red">*</span> </td>
				    	<td><input type="text" id="jobLdrName" data-bind="value:JOBLDR_NAME" style="width:96%;" onKeyUp="chkNull(this);"  /></td>
			    	</tr>
			    	<tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 계급정의</td>
				    	<td><textarea rows="13"  type="text" id="jobLdrComment" data-bind="value:JOBLDR_COMMENT" style=" width:96%;" /></td>
			    	</tr>
					<tr>
				    	<td width="100px" class="subject"  ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 주요역할</td>
				    	<td><textarea rows="13"  type="text" id="mainTask" data-bind="value:MAIN_TASK" style=" width:96%;" /></td>
			    	</tr>
					<tr>
				    	<td width="100px" class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부</td> 
						<td class="subject">
								<input type="radio" name="useFlag" id="useFlag"   value="Y"/> 사용</input>
								<span style="padding-left:70px"><input type="radio" name="useFlag" id="useFlag"  value="N"/></span> 미사용</input></td>
						</td>
			    	</tr>
			    
				</table>
				</div>
                    <div>
						<div style="margin:10px 10px">
						▶  역량목록
							<button id="newCompBtn" class="k-button" style="float: right" ><span class="k-icon k-i-plus" ></span>역량추가</button>			
                        </div>
						<!-- 역량매핑 -->
                        <div id="compMapGrid" style="overflow-y:auto;" >
						</div>
						
						<div style="margin:10px 10px">
						▶  행동지표
						</div>
						<!-- 행동지표 -->
                        <div id="indcMapGrid" style="overflow-y:auto;"></div>
                    </div>
 					<div>
						<div style="margin:10px 10px">
						▶  직급목록
                        </div>
						<!-- 역량매핑 -->
                        <div id="gradeMapGrid" style="overflow-y:auto;" >
						</div>
						
                    </div>
				</div>
                <div style="text-align:right;margin-top:10px">
                               <button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
                               <button id="delBtn" class="k-button">삭제</button>&nbsp;
                               <button id="cencelBtn" class="k-button"></span>취소</button>
                </div>
	 		</script>
	 		<!-- 역량추가 팝업 -->
    <div id="newCompList-window" style="display:none; overflow-y: hidden;height:580px; width:800px;">
        <div style="position: relative;">
                                   ▶  역량목록<br>
            <div id="newCompGrid" ></div>
                                   ▶ 행동지표<br>
            <div id="newIndcGrid" ></div>
            <div style="text-align:right;margin-top:10px">
                 <button id="saveCompBtn" onclick ="saveCompBtn()" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
                 <button id="cencelCompBtn" class="k-button">취소</button>
            </div>
        </div>
    </div>
    <style scoped>
        #tabstrip {
            margin: 0px auto;
            height: 100%;
        }
    
    </style>

</body>
</html>