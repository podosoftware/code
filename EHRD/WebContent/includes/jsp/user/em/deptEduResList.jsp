<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="java.util.*"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}

//kr.podosoft.ws.service.ba.action.admin.BaMgmtSubjectAction action = (kr.podosoft.ws.service.ba.action.admin.BaMgmtSubjectAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
boolean isAdmin = request.isUserInRole("ROLE_SYSTEM");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage"   >
<head>
<title>교육훈련결과 :: 부서원교육현황</title>
<script type="text/javascript"> 
var dataSource_attend ;
var now = new Date();
var detailSelected = null;

    yepnope([ {
        load : [ 'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
                'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js', 
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js', 
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
        ],
        complete : function() {
        	kendo.culture("ko-KR"); 
        	/* 브라우저 height 에 따라 resize() 스타일 적용..  START !!! */
        	/*
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
                $("#tabstrip").kendoTabStrip({
        			animation:  {
        				open: {
        					effects: "fadeIn"
        				}
        			}
        		});
                var expandContentDivs = function(divs) {
	                divs.height(gridElement.innerHeight()-47);
	            };
	            var resizeAll = function() {
	                expandContentDivs(tabStripElement.children(".k-content")); 
	            };
	            resizeAll();
            });
        	*/
            /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
            
            //로딩바선언
            loadingDefine();
            
            // area splitter
            var splitter = $("#splitter").kendoSplitter({
                orientation : "horizontal",
                panes : [ {
                    collapsible : true,
                    min : "300px",
                    size: "30%"
                }, {
                    collapsible : true,
                    collapsed : true,
                    min : "700px",
                    size: "70%"
                } ]
            });

            var searchSdate = $("#searchSdate").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {                    
                    var startDate = searchSdate.value(),
                    endDate = searchEdate.value();

                    if (startDate) {
                        startDate = new Date(startDate);
                        startDate.setDate(startDate.getDate());
                        searchEdate.min(startDate);
                    } else if (endDate) {
                    	searchSdate.max(new Date(endDate));
                    } else {
                        endDate = new Date();
                        searchSdate.max(endDate);
                        searchEdate.min(endDate);
                    }
                             
                 }
            }).data("kendoDatePicker");

            var searchEdate = $("#searchEdate").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {                    
                    var endDate = searchEdate.value(),
                     startDate = searchSdate.value();
             
                     if (endDate) {
                         endDate = new Date(endDate);
                         endDate.setDate(endDate.getDate());
                         searchSdate.max(endDate);
                     } else if (startDate) {
                    	 searchEdate.min(new Date(startDate));
                     } else {
                         endDate = new Date();
                         searchSdate.max(endDate);
                         searchEdate.min(endDate);
                     }
                }
            }).data("kendoDatePicker");

            searchSdate.value(new Date(now.getFullYear(), now.getMonth(), 1));
            searchEdate.value(new Date(now.getFullYear(), now.getMonth()+1, 0));
            searchSdate.max(searchEdate.value());
            searchEdate.min(searchSdate.value());
            
            //검색버튼 클릭
            $("#searchBtn").click(function(){
            	if(searchSdate.value() && searchEdate.value()){
            		grid.dataSource.read();
            	}else{
            		alert("검색 시작일과 종료일을 모두 입력해주세요.");
            	}
            });
	        
			//엑셀다운로드
            var excelDownload = $("#excelDownload").click(function(){
            	if(searchSdate.value() && searchEdate.value()){
            		location.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/edu_result_list_excel.do?SEARCHSDATE=" + $("#searchSdate").val() + "&SEARCHEDATE=" + $("#searchEdate").val() ;
            	}else{
            		alert("검색 시작일과 종료일을 모두 입력해주세요.");
            	}
            });

	        //교육과정 목록 그리드 생성
	        var grid = $("#grid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/edu-result-list.do?output=json",
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
                                startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter), SEARCHSDATE: $("#searchSdate").val(), SEARCHEDATE: $("#searchEdate").val() 
                            };    
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        id : "SUBJECT_NUM",
	                        fields : {
	                        	DVS_NAME : {
	                                type : "string"
	                            },
	                            DVS_FULLNAME : {
	                                type : "string"
	                            },
	                            NAME : {
	                                type : "string"
	                            },
	                            GRADE_NM : {
	                                type : "string"
	                            },
	                            TRAINING_NM : {
	                                type : "string"
	                            },
	                            SUBJECT_NAME : {
	                                type : "string"
	                            },
	                            CHASU_NUMB : {
	                                type : "number"
	                            },
	                            EDU_STIME : {
	                                type : "string"
	                            },
	                            EDU_ETIME : {
	                                type : "string"
	                            },
	                            EDU_HOUR_H : {
	                                type : "string"
	                            },
	                            RECOG_TIME_H : {
	                                type : "string"
	                            },
	                            DEPT_DESIGNATION_YN : {
	                                type : "string"
	                            },
	                            ATTEND_STATE_NM : {
	                                type : "string"
	                            },
	                            DEL_YN : {
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
                                style : "text-align:center"
                            }
                        },
                        {
                            field : "GRADE_NM",
                            title : "직급",
                            width : "150px",
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
	                        field : "DVS_FULLNAME",
	                        title : "부서명",
	                        width : "150px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:left"
	                        }
	                    },
	                    {
	                        field : "SUBJECT_NAME",
	                        title : "과정명",
	                        width : "150px",
	                        headerAttributes : {
                                "class" : "table-header-cell",
                                style : "text-align:center"
                            },
                            attributes : {
                                "class" : "table-cell",
                                style : "text-align:left"
                            }
	                    },/*
                        {
                            field : "CHASU_NUMB",
                            title : "기수",
                            width : "80px",
                            headerAttributes : {
                                "class" : "table-header-cell",
                                style : "text-align:center"
                            },
                            attributes : {
                                "class" : "table-cell",
                                style : "text-align:center"
                            }
                        },*/
                        {
                            field : "EDU_PERIOD",
                            title : "교육기간",
                            width : "200px",
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
                            field : "TRAINING_NM",
                            title : "학습유형",
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
                            field : "RECOG_TIME",
                            title : "인정시간",
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
	                        field : "DEPT_DESIGNATION_YN",
	                        title : "부처지정학습",
	                        width : "130px",
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
	                        field : "ATTEND_STATE_NM",
	                        title : "수강상태",
	                        width : "100px",
	                        headerAttributes : {
	                            "class" : "table-header-cell",
	                            style : "text-align:center"
	                        },
	                        attributes : {
	                            "class" : "table-cell",
	                            style : "text-align:center"
	                        }
	                    }],
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
	            pageable : {
	                refresh : false,
                    pageSizes : [10,20,30],
                    buttonCount: 5
	            }
	        }).data("kendoGrid");

        }
    } ]);

</script>  

</head>
<body>
<div class="container">
		<div id="cont_body">
		 <div class="content">
			<div class="top_cont">
				<h3 class="tit01">부서원교육현황</h3>
				<div class="point">※ 부서원들의 교육 현황을 열람할 수 있습니다.</div>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>교육훈련결과&nbsp; &#62;</span>
					<span class="h">부서원교육현황</span>
				</div><!--//location-->
			</div>
			<div class="sub_cont">
                <div class="result_info">
					<div class="tab_cont">
					<label for="yyyy" >교육시작일</label> : 
	                        <input type="text" id="searchSdate" style="width:120px; "  /> ~
                            <input type="text" id="searchEdate" style="width:120px; "  />
                            <button id="searchBtn" class="k-button" style="width: 60px;">검색</button>
					</div>
                    <div class="btn">
                    	<% if(isAdmin) { %><a class="k-button" onclick="fn_syncEdursltPopup()" >이사람연동 엑셀 다운로드</a>&nbsp;<% } %>
                        <a class="k-button" id="excelDownload" >엑셀 다운로드</a>
                    </div>
                </div><!--//result_info-->
                <div id="grid" class="mt15" style="height:550px;"></div>

             </div><!--//sub_cont-->
           </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->
<%@ include file="/includes/jsp/user/common/apprStsPopup.jsp"  %>
<%@ include file="/includes/jsp/user/common/syncEduRsltPopup.jsp"  %>
</body>
</html>