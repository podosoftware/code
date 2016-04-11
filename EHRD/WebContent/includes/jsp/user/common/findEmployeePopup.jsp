<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script type="text/javascript">

var isManager = <%=isManager%>; //부서장
var isSystem =  <%=isSystem%>;  //총괄 관리자 
var isOperator = <%=isOperator%>;

		function fn_findEmp(mod){
			$("#findEmp").empty();
			$("#findEmp").kendoGrid({
	        	dataSource: {
	                 type: "json",
	                 transport: {
	                     read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/find-emp-list.do?output=json", type:"POST" },
	                     parameterMap: function (options, operation){
	                    	 var sortField = "";
	                     	 var sortDir = "";
	                     	 if (options.sort && options.sort.length>0) {
	                     		sortField = options.sort[0].field;
	                     		sortDir = options.sort[0].dir;
	                         }
	                    	  return {
	                        	  ADMIN : isManager,
	                        	  DIVISION_BOSS : isSystem,
	                        	  OPERATOR : isOperator,
	                        	  startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter) 
	                          };
	                     }
	                 },
	                 schema: {
	                 	total : "totalItemCount",
	                      data: "items3",
	                      model: {
	                     	 fields : {
	                     			USERID : {
		                                type : "number",
		                                editable : false
		                            },
		                            GRADE_NUM: {
		                                type : "string",
		                                editable : false
		                            },
		                            DIVISIONID : {
		                                type : "string",
		                                editable : false
		                            },
		                            USEFLAG : {
		                                type : "string",
		                                editable : false
		                            },
		                            
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
	                            width : 80,
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
	                            width : 80,
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
	                            field : "DVS_FULLNAME",
	                            title : "부서명",
	                            width : 140,
	                            headerAttributes : {
	                                "class" : "table-header-cell",
	                                style : "text-align:center"
	                            },
	                            attributes : {
	                                "class" : "table-cell",
	                                style : "text-align:left"
	                            },
	                        },
	                        {
	                            field : "GRADE_NM",
	                            title : "직급",
	                            width : 100,
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
								field : "",
								title : "선택",
								filterable : false,
								sortable : false,
								width : 100,
								headerAttributes : {
								    "class" : "table-header-cell",
								    style : "text-align:center"
								},
								attributes : {
								    "class" : "table-cell",
								    style : "text-align:center"
								},
							    template : "<button id='selectEmp_${USERID}' class='k-button' onclick='javascript:fn_empInsert(${USERID},\""+mod+"\");'>선택</button>"
	                        },
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
	                  	height: 500,
	                  	sortable : true,
	    	            pageable : true,
	    	            resizable : true,
	    	            reorderable : true,
	    	            pageable : {
	                        refresh : false,
	                        pageSizes :[10,20,30],
	                        buttonCount : 5
	                    }
	         	}); 
		}
		
		function fn_findGradeNm(mod){
			$("#findEmpUpdate").empty();
			$("#findEmpUpdate").kendoGrid({
	        	dataSource: {
	                 type: "json",
	                 transport: {
	                     read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/find-gradeNm-list.do?output=json", type:"POST" },
	                     parameterMap: function (options, operation){
	                    	 var sortField = "";
	                     	 var sortDir = "";
	                     	 if (options.sort && options.sort.length>0) {
	                     		sortField = options.sort[0].field;
	                     		sortDir = options.sort[0].dir;
	                         }
	                    	  return {
	                        	  ADMIN : isManager,
	                        	  DIVISION_BOSS : isSystem,
	                        	  OPERATOR : isOperator,
	                        	  startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter) 
	                          };
	                     }
	                 },
	                 schema: {
	                 	total : "totalItemCount",
	                      data: "items3",
	                      model: {
	                     	 fields : {
	                     			COMMONCODE : {
		                                type : "string",
		                                editable : false
		                            },
		                            CMM_CODENAME: {
		                                type : "string",
		                                editable : false
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
	                            field : "CMM_CODENAME",
	                            title : "인정직급",
	                            width : 100,
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
								field : "",
								title : "선택",
								filterable : false,
								sortable : false,
								width : 100,
								headerAttributes : {
								    "class" : "table-header-cell",
								    style : "text-align:center"
								},
								attributes : {
								    "class" : "table-cell",
								    style : "text-align:center"
								},
							    template : "<button id='selectEmp_${COMMONCODE}' class='k-button' onclick='javascript:fn_empUpdate(${COMMONCODE});'>선택</button>"
	                        },
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
	                  	height: 500,
	                  	sortable : true,
	    	            pageable : true,
	    	            resizable : true,
	    	            reorderable : true,
	    	            pageable : {
	                        refresh : false,
	                        pageSizes :[10,20,30],
	                        buttonCount : 5
	                    }
	         	}); 
		}
		
		  /* function empPop(a,b,c){
			  alert(a);
			var window = $("#pop04");
			if (!window.data("kendoWindow")) {
				window.kendoWindow({
					width: "600px",
					resizable : true,
					modal: true,
                    visible: false,
					title: "임직원 찾기",
				});
				fn_findEmp();
       		 	window.data("kendoWindow").center();
       		    window.data("kendoWindow").open();
			}
		 } */
		  function empPop(mod){
	       		 if( !$("#pop04").data("kendoWindow") ){
	                    $("#pop04").kendoWindow({
	                        width:"800px",
	                        height:"550px",
	                        resizable : true,
	                        title : "임직원 찾기",
	                        modal: true,
	                        visible: false
	                    });
	                 }
	       		
	       			fn_findEmp(mod);
	                 $("#pop04").data("kendoWindow").center();
	                 $("#pop04").data("kendoWindow").open();
	       }
		 
		 function empUpdatePop(mod){
       		 if( !$("#pop05").data("kendoWindow") ){
                    $("#pop05").kendoWindow({
                        width:"500px",
                        height:"550px",
                        resizable : true,
                        title : "인정직급 찾기",
                        modal: true,
                        visible: false
                    });
                 }
       		
       			fn_findGradeNm(mod);
                 $("#pop05").data("kendoWindow").center();
                 $("#pop05").data("kendoWindow").open();
       }
		 
	</script>

			<!--팝업 코딩 시작-->
					<div id="pop04" style="display:none;">
						<div class="point3 mb10">※ 찾고자 하는 임직원을 각 컬럼의 필터기능을 이용하여 찾으십시오</div>
						<div id="findEmp"></div>
						<!-- <div class="btn_center">
							<button class="k-button" style="width:55px;">확인</button>
						</div> -->
					</div><!--//pop04-->
					
					<div id="pop05" style="display:none;">
						<div class="point3 mb10">※ 찾고자 하는 인정직급을 컬럼의 필터기능을 이용하여 찾으십시오</div>
						<div id="findEmpUpdate"></div>
						<!-- <div class="btn_center">
							<button class="k-button" style="width:55px;">확인</button>
						</div> -->
					</div><!--//pop05-->
				<!--//팝업코딩끝-->