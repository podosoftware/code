<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page pageEncoding="UTF-8" isErrorPage="true"%>
<html decorator="operatorSubpage">
<head>
<title>방향설정</title>
<style type="text/css">
	.runSet {
		border-bottom:1px solid #dfdfdf;
		width:100%; 
		height:50px;
		
		float:top;
	}
	.templine{
	border:1px solid #dfdfdf;
		width:99%;
		height: 100%;
		text-align:center;
		float:left;
	}
	.runSetName{
		padding: 17px;
		font-size:16px;
	}
	.runBCS{
		width:45%;
		height:100%;
		float:right;
		padding-top:5px;
		padding-right:2px;
	}
	.bsc {
		text-align:left;
		margin : 5px 5px 5px 5px ;
	}
	.emp {
		width:47%;
		height:100%;
		float:left;
		padding-top:5px;
		padding-left:2px;
	}
</style>

<script type="text/javascript">
var dataSource_run;

    yepnope([ {
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
                splitterOtherHeight = $("#splitter").offset().top + $("#footer").outerHeight() + 15; //
                splitterElement.height(winHeight - splitterOtherHeight);
                
                splitterOtherWidth = $("#splitter").offset().top + $("#footer").outerHeight() + 15; //
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
                
                var gridElement = $("#employeeGrid");
                gridElement.height(splitterElement.outerHeight()-95);
                
                dataArea = gridElement.find(".k-grid-content"),
                gridHeight = gridElement.innerHeight(),
                otherElements = gridElement.children().not(".k-grid-content"),
                otherElementsHeight = 0;
                otherElements.each(function(){
                    otherElementsHeight += $(this).outerHeight();
                });
                dataArea.height(gridHeight - otherElementsHeight);
                
                // 진단자 설정 화면 사이즈 조절
                var gridElement = $("#bossRunGrid");
                gridElement.height(splitterElement.outerHeight()/3-65);
                
                var gridElement = $("#colRunGrid");
                gridElement.height(splitterElement.outerHeight()/3-65);
                
                var gridElement = $("#subRunGrid");
                gridElement.height(splitterElement.outerHeight()/3-65);
                
                var gridElement = $("#btnDiv");
                gridElement.height(splitterElement.outerHeight()/4-80);
                
                var gridElement = $("#bossBtnDiv");
               // gridElement.height(splitterElement.outerHeight()/4+10);
                
                var gridElement = $("#colBtnDiv");
                //gridElement.height(splitterElement.outerHeight()/4+40);
                
                var gridElement = $("#subBtnDiv");
                //gridElement.height(splitterElement.outerHeight()/4-80);
                
                
                
                dataArea = gridElement.find(".k-grid-content"),
                gridHeight = gridElement.innerHeight(),
                otherElements = gridElement.children().not(".k-grid-content"),
                otherElementsHeight = 0;
                otherElements.each(function(){
                    otherElementsHeight += $(this).outerHeight();
                });
                dataArea.height(gridHeight - otherElementsHeight);

            });
            /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
          
            //로딩바 선언..
            loadingDefine();
            
            // area splitter
            var splitter = $("#splitter").kendoSplitter({
                orientation : "horizontal",
                panes : [ {
                    collapsible : true,
                    min : "300px",
                    size : "30%"
                }, {
                    collapsible : true,
                    collapsed : true,
                    min : "700px"
                } ]
            });
            //년도 받아오기
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
            
/*             
            var trainingCode = $("#TRAINING_CODE").kendoDropDownList({
                dataTextField: "TEXT",
                dataValueField: "VALUE",
                dataSource: dataSource_training,
                filter: "contains",
                suggest: true
            }).data("kendoDropDownList");
             */
            
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
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_diagnosis_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){	
                    	return {} ;
                    } 		
                },
                schema: {
                	data: "items",
                	model: { 
                		SELF_WEIGHT : { type: "string" } ,
	                    VALUE : { type: "string" }, 
	                    TEXT : { type: "string" },
	                    YYYY: { type: "string" }
                	}
                },
                serverFiltering: false,
	              serverSorting: false
   		 });
      	  //실시목록 출력
      	  $("#runNumber").kendoDropDownList({
					dataTextField : "TEXT",
					dataValueField : "VALUE",
					dataSource : dataSource_run,
					suggest : true,
					index : 0,
					change : function() {
						$("#grid").data("kendoGrid").dataSource.read();
						$("#upload_run_num").val($("#runNumber").val());
						$("#splitter").data("kendoSplitter").collapse("#detail_pane");
					},
					dataBound:function(e){
	                    $("#runNumber").data("kendoDropDownList").select(0);
	                    $("#upload_run_num").val($("#runNumber").val());
	                    $("#grid").data("kendoGrid").dataSource.read();
	                }
				}).data("kendoDropDownList");
      	  
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

	        // 그리드
	        $("#grid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_dir_list.do?output=json",
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
	                                type : "number"
	                            },
	                            RUN_NUM : {
	                                type : "string"
	                            },
	                            USERID : {
	                                type : "string"
	                            }
	                        }
	                    }
	                },
	                pageSize : 30,
	                serverPaging : true,
	                serverFiltering : true,
	                serverSorting : true
	            },
	            columns : [
	                    {
	                        field : "NAME",
	                        title : "성명",
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center;text-decoration: underline;"
	                        },
	                        template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${USERID},\"${NAME}\");'> ${NAME} </a>"
	                    },
	                    {
	                        field : "EMPNO",
	                        title : "교직원번호",
	                        width : "100px",
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
	                        width : "100px",
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
	                        width : "100px",
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
	                        width : "100px",
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
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:left;"
	                        },
	                    },
	                    {
	                        field : "BOSS_CNT",
	                        title : "상사",
	                        width : "100px",
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
	                        field : "COL_CNT",
	                        title : "동료",
	                        width : "100px",
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
	                        field : "SUB_CNT",
	                        title : "부하",
	                        width : "100px",
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
	                        field : "SELF_CNT",
	                        title : "본인",
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        }
	                    } ],
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
	            resizable : true,
	            reorderable : true,
	            selectable: "row",
	            pageable : {
		            refresh : false,
		            pageSizes : [10,20,30],
		            buttonCount : 5
		            
		        }
	        });
	        
	     // show detail 
            $('#details').show().html(kendo.template($('#template').html()));
	     
	      //임직원 목록 그리드
	        $("#employeeGrid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_dir_emp_list.do?output=json",
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
                            	USERID : $("#userId").val(),
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
	                                type : "number"
	                            },
	                            RUN_NUM : {
	                                type : "string"
	                            },
	                            USERID : {
	                                type : "string"
	                            }
	                        }
	                    }
	                },
	                pageSize : 30,
	                serverPaging : true,
	                serverFiltering : true,
	                serverSorting : true
	            },
	            columns : [
						{
						    field : "",
						    title : "선택 <input type =checkbox class=select_all>",
						    width : "60px",
						    headerAttributes : {
						        "class" : "table-header-cell",
						        style : "text-align:center"
						    },
						    attributes : {
						        "class" : "table-cell",
						        style : "text-align:center;text-decoration: underline;"
						    },
						    template : "<div style=\"text-align:center\"><input type=\"checkbox\" name=\"empCheck_${USERID}\" data=\"${USERID}\" id=\"empCheck\" class='empCheck' onclick=\"\"/></div>"
						},
	                    {
	                        field : "NAME",
	                        title : "성명",
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center;"
	                        }
	                    },
	                    {
	                        field : "EMPNO",
	                        title : "교직원번호",
	                        width : "100px",
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
	                        width : "100px",
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
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        },
	                    } ],
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
	    	            pageable : false,
	    	            resizable : true,
	    	            reorderable : true,
	    	            selectable: "row",
	    	            pageable : {
	    		            refresh : false,
	    		            buttonCount : 5
	    		        }
	        });
	      
	      //상사진단 목록 그리드
	       $("#bossRunGrid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_dir_user_list.do?output=json",
	                        type : "POST"
	                    },
	                    parameterMap : function(options, operation) {
	                    	return {
                            	RUN_NUM : $("#runNumber").val(),
                            	USERID : $("#userId").val(),
                            	RUNDIRECTION_CD : 4
                            };
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        fields : {
	                        	COMPANYID : {
	                                type : "number"
	                            },
	                            RUN_NUM : {
	                                type : "string"
	                            },
	                            USERID : {
	                                type : "string"
	                            }
	                        }
	                    }
	                },
	                serverPaging : false,
	                serverFiltering : false,
	                serverSorting : false,
		            requestEnd: function(e) {
		                var response = e.response;
		                $("#bossText").append(" ("+response.items.length+" 명)");
		            }
	            },
	            columns : [
						{
						    field : "",
						    title : "삭제",
						    width : "80px",
						    headerAttributes : {
						        "class" : "table-header-cell",
						        style : "text-align:center"
						    },
						    attributes : {
						        "class" : "table-cell",
						        style : "text-align:center;"
						    },
						    template : "<button id='runBossDel_${USERID}' style='height:27px;min-width:56px;' class='k-button' onclick='javascript:fn_runListdel(1,${USERID});'>삭제</button>"
						},
	                    {
	                        field : "NAME",
	                        title : "성명",
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center;"
	                        }
	                    },
	                    {
	                        field : "EMPNO",
	                        title : "교직원번호",
	                        width : "100px",
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
	                        width : "100px",
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
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        },
	                    } ],
	                    sortable : false,
	    	            pageable : false,
	    	            resizable : true,
	    	            reorderable : true,
	    	            selectable: "row"
	        });
	        
	      //동료진단 목록 그리드
	        $("#colRunGrid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_dir_user_list.do?output=json",
	                        type : "POST"
	                    },
	                    parameterMap : function(options, operation) {
	                    	return {
                            	RUN_NUM : $("#runNumber").val(),
                            	USERID : $("#userId").val(),
                            	RUNDIRECTION_CD : 3
                            };
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        fields : {
	                        	COMPANYID : {
	                                type : "number"
	                            },
	                            RUN_NUM : {
	                                type : "string"
	                            },
	                            USERID : {
	                                type : "string"
	                            }
	                        }
	                    }
	                },
	                serverPaging : false,
	                serverFiltering : false,
	                serverSorting : false,
		            requestEnd: function(e) {
		                var response = e.response;
		                $("#colText").append(" ("+response.items.length+" 명)");
		            }
	            },
	            columns : [
						{
						    field : "",
						    title : "삭제",
						    width : "80px",
						    headerAttributes : {
						        "class" : "table-header-cell",
						        style : "text-align:center"
						    },
						    attributes : {
						        "class" : "table-cell",
						        style : "text-align:center;text-decoration: underline;"
						    },
						    template : "<button id='runColDel_${USERID}' class='k-button' style='height:27px;min-width:56px;' onclick='javascript:fn_runListdel(2,${USERID})';>삭제</button>"
						},
	                    {
	                        field : "NAME",
	                        title : "성명",
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center;"
	                        }
	                    },
	                    {
	                        field : "EMPNO",
	                        title : "교직원번호",
	                        width : "100px",
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
	                        width : "100px",
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
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        },
	                    } ],
                filterable : false,
	            sortable : true,
	            pageable : false,
	            resizable : true,
	            reorderable : true,
	            selectable: "row"
	        });
	      
	      //부하진단 목록 그리드
	        $("#subRunGrid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_dir_user_list.do?output=json",
	                        type : "POST"
	                    },
	                    parameterMap : function(options, operation) {
	                    	return {
                            	RUN_NUM : $("#runNumber").val(),
                            	USERID : $("#userId").val(),
                            	RUNDIRECTION_CD : 2
                            };
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        fields : {
	                        	COMPANYID : {
	                                type : "number"
	                            },
	                            RUN_NUM : {
	                                type : "string"
	                            },
	                            USERID : {
	                                type : "string"
	                            }
	                        }
	                    }
	                },
	                serverPaging : true,
	                serverFiltering : false,
	                serverSorting : false,
		            requestEnd: function(e) {
		                var response = e.response;
		                $("#subText").append(" ("+response.items.length+" 명)");
		            }
	            },
	            columns : [
						{
						    field : "",
						    title : "삭제",
						    width : "80px",
						    headerAttributes : {
						        "class" : "table-header-cell",
						        style : "text-align:center"
						    },
						    attributes : {
						        "class" : "table-cell",
						        style : "text-align:center;text-decoration: underline;"
						    },
						    template : "<button id='runSubDel_${USERID}' class='k-button' style='height:27px;min-width:56px;' onclick='javascript:fn_runListdel(3,${USERID});'>삭제</button>"
						},
	                    {
	                        field : "NAME",
	                        title : "성명",
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center;"
	                        }
	                    },
	                    {
	                        field : "EMPNO",
	                        title : "교직원번호",
	                        width : "100px",
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
	                        width : "100px",
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
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        },
	                    } ],
                    filterable : false,
    	            sortable : true,
    	            pageable : false,
    	            resizable : true,
    	            reorderable : true,
    	            selectable: "row"
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

            	alert("방향설정의 엑셀 업로드는 이전 매핑된 진단자가 초기화 됩니다. 즉, 현재 매핑된 진단자는 삭제되고 엑셀 내용만 진단자로 매핑됩니다.");
                $('#excel-upload-window').data("kendoWindow").center();
                $("#excel-upload-window").data("kendoWindow").open();
            });

            //엑셀파일업로드 팝업창 정의.. 상단에서 jquery.form.min.js 파일로드 해야함. 
            if (!$("#excel-upload-window").data("kendoWindow")) {
                $("#excel-upload-window").kendoWindow({
                    width : "340px",
                    minWidth : "340px",
                    resizable : false,
                    title : "방향설정 엑셀 업로드",
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
                                alert("-방향설정 업로드 결과-\n"+myObj.statement);
                            }else{
                                //작업 실패.
                                alert("작업이 실패하였습니다.");
                            }
                            
                            //그리드 다시 읽고,
                            $("#grid").data("kendoGrid").dataSource.read();
		                    $("#bossRunGrid").data("kendoGrid").dataSource.read();
		                    $("#colRunGrid").data("kendoGrid").dataSource.read();
		                    $("#subRunGrid").data("kendoGrid").dataSource.read();
							$("#employeeGrid").data("kendoGrid").dataSource.read();
                            
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
	        
	        //엑셀 다운로드
	        //$("#lst-excel-btn").attr("href","<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-list-excel.do");
           
            $('.select_all').bind('click' , function(){
	  			 var chk = $(this).is(':checked');
	  			 if(chk) $('.empCheck').attr('checked' , true);
	  			 else $('.empCheck').attr('checked' , false);
	  		});
            
            // dtl cancel btn add click event
            $("#cencelBtn").click( function(){
	        	$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
	            $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
	        });
            

            //자동설정
			$("#setAutomatic").click( function(){
				
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

				if(confirm("자동설정하시겠습니까?\n대상자가 많은 경우 다소 시간이 소요될 수 있습니다.")){
            		loadingOpen();
            		$.ajax({
        	            type : 'POST',
        	            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_dir_auto_save.do?output=json",
        	            data : {
        	            	RUN_NUM : $("#runNumber").val()
        	            },
        	            complete : function( response ){
        	            	//로딩바 제거.
        	                loadingClose();

        	                var obj  = eval("(" + response.responseText + ")");
        	                if(!obj.error){
        	                	if(obj.saveCount > 0){
        	                        alert("자동설정에 성공하였습니다.");
									$("#grid").data("kendoGrid").dataSource.read();
        	                    }else{
        	                        alert("자동설정에 실패하였습니다.");
        	                    }   
        	                }else{
        	                	alert("ERROR: "+obj.error.message);
        	                }                       
        	            },
        	            error : function(xhr, ajaxOptions, thrownError) { 
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

            //브라우저 resize 이벤트 dispatch..
            $(window).resize();
        }
    } ]);
</script>

<script type="text/javascript">

	//엑셀다운로드(목록)
	function excelDown(button){
		if($("#runNumber").val() == null || $("#runNumber").val() == "" ){
			alert("선택된 진단이 없습니다.");
			return false;
		}
		button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_direction_list_excel.do?runNum=" + $("#runNumber").val();
	}
	
	//엑셀다운로드(설정)
    function excelDirDown(button){
        if($("#runNumber").val() == null || $("#runNumber").val() == "" ){
            alert("선택된 진단이 없습니다.");
            return false;
        }
        button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_direction_dir_excel.do?runNum=" + $("#runNumber").val();
    }
    
	function saveDir(dirCd,delCeheck){	
	   // if (confirm("진단자 설정 정보를 저장하시겠습니까?")) {
	    	//로딩바생성.
	    	if($("#runNumber").val() == null || $("#runNumber").val() == "" ){
	            alert("선택된 진단이 없습니다.");
	            
	            if($("#selfCheck").attr("checked")){
	            	$("#selfCheck").attr("checked",false); //체크박스 초기화
	            }else{
	            	$("#selfCheck").attr("checked",true); //체크박스 초기화
	            }
	            return false;
	        }
	        var dataRun = dataSource_run.data();
	        var res = $.grep(dataRun, function (e) {
	            return e.VALUE == $("#runNumber").val();
	        });
	        if(res[0] != null){
	            if(res[0].RUN_START_YN == 'N'){
	                alert("설정한 내용을 변경할 수 없습니다.실시 시작일을 확인해 주십시오.");
	                if($("#selfCheck").attr("checked")){
	                    $("#selfCheck").attr("checked",false); //체크박스 초기화
	                }else{
	                    $("#selfCheck").attr("checked",true); //체크박스 초기화
	                }
	                return false;
	            }
	        }
	        
	    	loadingOpen();
	    	
	        var params = {
	        	    LIST1 :  $('#bossRunGrid').data('kendoGrid').dataSource.data(),
	                LIST2 : $('#colRunGrid').data('kendoGrid').dataSource.data(),  
	                LIST3 : $('#subRunGrid').data('kendoGrid').dataSource.data(),
	        };
	
	        $.ajax({
	            type : 'POST',          
	            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_dir_save.do?output=json",
	            data : {
	            	item: kendo.stringify( params ), 
	            	RUN_NUM : $("#runNumber").val(),
	                USERID_EXED: $("#userId").val(),
	                SELF_CHECKED : $("#selfCheck").attr("checked"),
	                DIR_CD : dirCd
	            },
	            complete : function( response ){
	            	//로딩바 제거.
	                loadingClose();
	                
	                var obj  = eval("(" + response.responseText + ")");
	                if(!obj.error){
	                	if(obj.saveCount > 0){         
	                        
	                        // 상세영역 활성화
	                        $("#splitter").data("kendoSplitter").expand("#detail_pane");
	                    
	                        /* $("#grid").data("kendoGrid").dataSource.read();
		                    $("#bossRunGrid").data("kendoGrid").dataSource.read();
		                    $("#colRunGrid").data("kendoGrid").dataSource.read();
		                    $("#subRunGrid").data("kendoGrid").dataSource.read();
							$("#employeeGrid").data("kendoGrid").dataSource.read(); */
							if(delCeheck=="del"){
								alert("삭제되었습니다.");
							}else{
								 alert("설정되었습니다.");  
							}
	                       
	                    }else{
	                        alert("설정에 실패하였습니다.");
	                    }   
	                }else{
	                	alert("ERROR: "+obj.error.message);
	                }                       
	            },
	            error : function(xhr, ajaxOptions, thrownError) { 
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
	
	   // }
	            
	};

	function selfCheckBox(){
		$("#selfCheck").attr("checked",false); //체크박스 초기화
		$.ajax({
             type : 'POST',
             dataType : 'json',
             url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_run_dir_user_list.do?output=json",
             data : {
            	RUN_NUM : $("#runNumber").val(),
             	USERID : $("#userId").val(),
             	RUNDIRECTION_CD : 1 //자가진단
             },
             success : function(response) {
                 if (response.items != null) {
                     $.each(response.items, function(idx, item) {
                    	 $("#selfCheck").attr("checked",true); //값이 있다면 체크
                     });
                 }else{
                	 $("#selfCheck").attr("checked",false); //값이 없으면 체크 안함
                 }
             },
             error : function(xhr, ajaxOptions, thrownError) { 
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

	
	function changeRowBtn(mod){

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

		var modList = "";
		var dirCd = 1;// 1 자가  2 부하 3 동료 4상사
		
		if(mod == "boss"){
			modList = "bossRunGrid";
			dirCd = 4;
		}else if(mod == "col"){
			dirCd = 3;
			modList = "colRunGrid";
		}else if(mod == "sub"){
			dirCd = 2; 
			modList = "subRunGrid";
		}else if(mod == "self"){
			dirCd = 1;
		}

		var grid = $('#grid').data('kendoGrid').dataSource.data();            
        var resGrid = $.grep(grid, function (e) {
            return e.RUN_NUM == $("#runNumber").val();
        });
        
        if(mod == "self"){
            if(resGrid[0].SELF_YN !="Y"){
            	$("#selfCheck").attr("checked",false);
                alert("선택된 진단은 자기자신을 진단할 수 없게 설정되어 있습니다.\n실시관리에서 방향 및 설정인원을 확인해주세요.");
                return false;
            }
            saveDir(dirCd); //실제 저장 로직
        }else{
        
			var runGrid = $("#employeeGrid").data("kendoGrid");
	        var runData = runGrid.dataSource.data();
	        var cnt = 0;//체크된 로우 번호를 저장하기 위한 변수
	        var hcnt=0; //진단 리스트의 카운터를 저장하기 위한 변수 (상사,동료,부하)
	        var array = new Array();  
			var runCount; //체크된 임직원 카운터를 저장하기 위한 변수
			
			//체크된 임직원 카운트 
		    runCount = $(":checkbox[id='empCheck']:checked").length ;
			//진단 리스트의 카운터 가져오기
			var runHcnt = $('#'+modList).data('kendoGrid').dataSource.data();
		    $.grep(runHcnt, function (e) {
		    	hcnt++;
				return e.RUN_NUM == $("#runNumber").val();
	    	});
 		
 		    if(mod =="sub"){
				if(resGrid[0].BOSS_YN !="Y"){
					alert("선택된 진단은 부하가 진단할 수 없게 설정되어 있습니다.\n실시관리에서 방향 및 설정인원을 확인해주세요.");
					return false;
				}else if(runCount+hcnt > resGrid[0].BOSS_HCNT){
					alert("선택된 진단의 최대 부하 진단자 수는 "+resGrid[0].BOSS_HCNT+"명 입니다.\n실시관리에서 방향 및 설정인원을 확인해주세요.");
					return false;
				}
			}
			else if(mod =="col"){
				if(resGrid[0].COL_YN !="Y"){
					alert("선택된 진단은 동료가 진단할 수 없게 설정되어 있습니다.\n실시관리에서 방향 및 설정인원을 확인해주세요");
					return false;
				}else if(runCount+hcnt > resGrid[0].COL_HCNT){
					alert("선택된 진단의 최대 동료 진단자 수는 "+resGrid[0].COL_HCNT+"명 입니다.\n실시관리에서 방향 및 설정인원을 확인해주세요.");
					return false;
				}
			}
			else if(mod =="boss"){
				if(resGrid[0].SUB_YN !="Y"){
					alert("선택된 진단은 상사가 진단할 수 없게 설정되어 있습니다.\n실시관리에서 방향 및 설정인원을  확인해주세요.");
					return false;
				}else if(runCount+hcnt > resGrid[0].SUB_HCNT){
					alert("선택된 진단의 최대 상사 진단자 수는 "+resGrid[0].SUB_HCNT+"명 입니다.\n실시관리에서 방향 및 설정인원을 확인해주세요.");
					return false;
				}
			}
	      
	        for(var i = 0; i<runData.length; i++) {
	            var obj = runData[i];
	            if(obj.USERID == $(":checkbox[name='empCheck_"+obj.USERID+"']:checked").attr("data")){
					$("#"+modList).data("kendoGrid").dataSource.insert({
	            		USERID:obj.USERID,
					    ID: obj.ID,
					    NAME: obj.NAME,
					    GRADE_NM: obj.GRADE_NM,
					    EMPNO: obj.EMPNO,
					    DVS_NAME: obj.DVS_NAME,
					    USEFLAG : obj.USEFLAG,
					    RUN_NUM : $("#runNumber").val()
	            	});
	            	array[cnt] = i; //체크된 로우 번호를 저장
	    			cnt++;
	            }
	             if(cnt == $(":checkbox[id='empCheck']:checked").length){
	            	 break; 
	             }  
	        }	
	        //dataSource.remove 사용시 하나의 로우만 삭제 되므로 array변수에 삭제되는
	        //로우 번호를 받아와서 한행이 삭제 될때마다 -1씩(처음삭제 -1 두번째삭제 -2 ....)하여 처리함.
	         var delCnt = 0;
	         for(var i=0 ; i < array.length ; i++){
	        	 $("#employeeGrid").data('kendoGrid').dataSource.remove(runData[array[i]-delCnt]);
	        	 delCnt++;
	         }
	         saveDir(dirCd); //실제 저장 로직
			$(".select_all").attr("checked",false);
 		}
	}
	// 진단자 삭제 (ROW 삭제)
	function fn_runListdel( mod , userId){
        
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
        
		var modList = "";
		var isDel ="";
		var dirCd = 1; // 1 자가  2 부하 3 동료 4상사
		
		if(mod == 1){
			modList = "bossRunGrid";
			dirCd = 4;
		}
		else if(mod == 2 ){
			modList = "colRunGrid";
			dirCd = 3;
		}
		else if(mod == 3){
			modList = "subRunGrid";
			dirCd = 2;
		}

		if(userId != null && userId != "" ){
			isDel = confirm("해당 진단자를 삭제 하시겠습니까?");
		}
		 
		if(isDel){
			var array;
			array = $('#'+modList).data('kendoGrid').dataSource.data();
			var res = $.grep(array, function (e) {
				return e.USERID == userId;
			});
			
			$('#employeeGrid').data('kendoGrid').dataSource.insert(res[0]);
			//ROW삭제
		    $('#'+modList).data('kendoGrid').dataSource.remove(res[0]); 
			saveDir(dirCd,"del"); //저장 로직
		 }
	}
	function fn_detailView(userId,name){
		// 필터를 사용할 경우 필터 초기화 ,필터의 초기화 버튼 이벤트를 발생 
		//$("form.k-filter-menu button[type='reset']").trigger("click");
		// 임직원 목록을 조회할때 필터 초기화 
		//$("#employeeGrid").data("kendoGrid").dataSource.filter({});
		// 상세영역 활성화
		$("#splitter").data("kendoSplitter").expand("#detail_pane");
		$("#userId").val(userId);
		
		$("#employeeGrid").data("kendoGrid").dataSource.read();
		$("#bossRunGrid").data("kendoGrid").dataSource.read();
		$("#colRunGrid").data("kendoGrid").dataSource.read();
		$("#subRunGrid").data("kendoGrid").dataSource.read();
		
		$("#bossText").text("> "+name+" 님을 진단할 상사");
		$("#colText").text("> "+name+" 님을 진단할 동료");
		$("#subText").text("> "+name+" 님을 진단할 부하");
		//자가진단 체크박스 
		selfCheckBox(); 
		// template에서 호출된 함수에 대한 이벤트 종료 처리.
		if (event.preventDefault) {
			event.preventDefault();
		} else {
			event.returnValue = false;
		}
	}
</script>

</head>
<body>
    <!-- START MAIN CONTENT  -->
        <div id="content">
            <div class="cont_body">
                <div class="title mt30">방향설정</div>
                <div class="table_tin01">
	                <div class="px">※ 피진단자를 진단할 진단자를 설정합니다.</div>
	                <div class="px">※ 자동설정을 클릭하면 진단자가 자동으로 설정됩니다. 성명을 클릭하여 진단자를 설정할 수 있습니다.</div>
	                <div class="px">※ 엑셀업로드는 선택된 진단만 업로드(업데이트)됩니다.</div>
	            </div>
                <div class="table_zone">
                <div>
	                <ul>
	                    <li class="mt10" style="line-height:40px;">
	                        <label for="runNumber" >진단 선택:</label>
	                        <select id="yyyy" style="width:100px;"></select>
	                        <select id="runNumber" style="width:350px;"></select>
	                        <div style="float:right;line-height:40px;">
		                        <button id="setAutomatic" class="k-button" >자동 설정</button>&nbsp;
	                    		<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp;
	                            <a id="lst-excel-btn" class="k-button"  onclick="excelDown(this);">엑셀 다운로드(목록)</a>&nbsp;
	                            <a id="lst-dir-excel-btn" class="k-button"  onclick="excelDirDown(this);">엑셀 다운로드(설정)</a>&nbsp;
                                <button id="excelUploadBtn" class="k-button" >엑셀 업로드</button>&nbsp;
	                            <button id=cencelBtn class="k-button" >상세닫기</button>&nbsp;
                            </div>
	                	</li>
	                </ul>
                </div>
                    <div class="table_list">
                        <div id="splitter" style="width:100%; height: 100%; border:none;">
                            <div id="list_pane">
                                <div id="grid" ></div>
                            </div>
                            <div id="detail_pane">
                                <div id="details">

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
                          
    <script type="text/x-kendo-template"  id="template"> 
	<input type="hidden" id="userId" value=""/>
    <div class = "templine">
		<div class="runSet">
			<div class="runSetName">진단자 설정</div>
		</div>
		<div class="emp">
			<div class="bsc"> > 임직원 목록</div>
			<div id="employeeGrid" style="min-height:550px;"></div>
		</div>
		<div style="width:7%; height:100%; float:left;">
			<div id="btnDiv" style="min-height:100px;"></div>
 			<div id="bossBtnDiv" style="min-height:190px;"><button id="bossBtn" class="k-button" onClick="changeRowBtn('boss')";> ▶  </button><br>	</div>
			<div id="colBtnDiv" style="min-height:210px;"><button id="colBtn" class="k-button" onClick="changeRowBtn('col')";> ▶  </button><br>	</div>
 			<div id="subBtnDiv" ><button id="subBtn" class="k-button" onClick="changeRowBtn('sub')";> ▶  </button><br>	</div>
		</div>
		<div class="runBCS">
			<div class="bsc" id="bossText" style="width: 450px;"><div id="bossCnt"></div></div>
			<div id="bossRunGrid" style="min-height:150px;"></div>
			
			<div class="bsc" id="colText"></div>
			<div id="colRunGrid"  style="min-height:150px;"></div>

			<div class="bsc" id="subText"></div>
			<div id="subRunGrid"  style="min-height:150px;"></div>

			<div id="selfDiv" class="bsc">
			<input id="selfCheck" type="checkbox" onclick="changeRowBtn('self');" > 자신을 진단 </input>
            <!--<input id="selfCheck" type="checkbox" onclick="saveDir(1);" > 자신을 진단 </input>-->
			</div>	
		</div>
	</div>

	<!--<div style="text-align:right;">
            	<button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
            	<button id="cancelBtn" class="k-button"><span class="k-icon k-i-close"></span>취소</button>&nbsp;&nbsp;
    </div>-->
</script>
<div id="excel-upload-window" style="display:none; width:340px;">
	        <form id="excelForm" name="excelForm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca-cmpt-dir-excel-upload.do?output=json" enctype="multipart/form-data" >
	        		※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
	           <div>
	               <input name="openUploadFile" id="openUploadFile" type="file" />
	               <input type="hidden" name="upload_run_num" id="upload_run_num" />
	               <br>
	               <div style="text-align: right;">
	                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/ca_cmpt_upload_dir_template.xls" class="k-button" >템플릿다운로드</a>
	                    <input type="submit" value="실행" class="k-button" id="uploadBtn"/>
	               </div>
	           </div>
	       </form>
	   </div>
</body>
</html>