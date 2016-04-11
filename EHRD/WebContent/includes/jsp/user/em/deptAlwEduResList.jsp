<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="java.util.*"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}

kr.podosoft.ws.service.ba.action.admin.BaMgmtSubjectAction action = (kr.podosoft.ws.service.ba.action.admin.BaMgmtSubjectAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage"   >
<head>
<title></title>
<script type="text/javascript"> 
var dataSource_attend ;
var now = new Date();
var detailSelected=null;
var dataSource_list2;

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
        	/* 브라우저 height 에 따라 resize() 스타일 적용..  START !!! 
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
            브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
            
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
            var fn_yyyyOnChange = function() {
            	grid.dataSource.read();
            };
          //기준년도 
            var now = new Date();
            var maxYyyy = now.getFullYear()+1;
            var arrYyyy = [];
            for(var i=maxYyyy; i>=1970; i--){
            	arrYyyy.push({VALUE: i, TEXT:(i+"년")});
            }
            var dataSource_searchYyyy = new kendo.data.ObservableArray( arrYyyy );
            
            var searchYyyy = $("#yyyy").kendoDropDownList({
                dataTextField: "TEXT",
                dataValueField: "VALUE",
                dataSource: dataSource_searchYyyy,
                filter: "contains",
                suggest: true,
                change: fn_yyyyOnChange,
                dataBound: function(e){
                	this.value(now.getFullYear());
                	//grid.dataSource.read();
                }
            }).data("kendoDropDownList");

            
	        //교육과정 목록 그리드 생성
	        var grid = $("#grid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/alw-edu-result-list.do?output=json",
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
                                startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter), YYYY : removeNullStr( searchYyyy.value() )
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
	                            DATA : {
	                                type : "number"
	                            },
	                            LABEL : {
	                                type : "string"
	                            },
	                            REQ_TIME: {
	                                type : "string"
	                            },
	                            TAKE_TIME: {
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
	                   /* {
                    		field : "DVS_NAME",
	                        title : "부서명",
	                        width : "70px",
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
                            field : "NAME",
                            title : "성명",
                            width : "80px",
                            headerAttributes : {
                                "class" : "table-header-cell",
                                style : "text-align:center"
                            },
                            attributes : {
                                "class" : "table-cell",
                                style : "text-align:center; text-decoration: underline;"
                            },
                            template: "<a href=\"javascript:void(0);\" onclick=\"javascript: fn_openDtlPop(${USERID});\" >${NAME}</a>",
                        },
                        {
                            field : "GRADE_NM",
                            title : "직급",
                            width : "140px",
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
	                        width : "300px",
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
	                        field : "DD0_REQ_TIME",
	                        title : "총시간</br>(기준)",
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
                            field : "DD0_TAKE_TIME",
                            title : "총시간</br>(실적)",
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
	                        field : "DD1_REQ_TIME",
	                        title : "부처지정학습</br>(기준)",
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
	                        field : "DD1_TAKE_TIME",
	                        title : "부처지정학습</br>(실적)",
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
	                        field : "REVAL",
	                        title : "결과",
	                        width : "80px",
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
	            pageable : {
	                refresh : false,
                    pageSizes : [10,20,30],
                    buttonCount: 5
	            }
	        }).data("kendoGrid");
		//grid.dataSource.read();
		

            dataSource_list2 = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/alw-edu-result-list-detail.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){ 
                        return { userid : $('#userid').val(),  YYYY : removeNullStr( searchYyyy.value() ) };
                    }
                },
                schema: {
                    total: "totalItemCount",
                    data: "items",
                    model: {
                        fields: {
                            EDU_TP : { type: "int" } ,
                            SUBJECT_NUM : { type: "int" } ,
                            OPEN_NUM  : { type: "int" },
                            SUBJECT_NAME : { type : "string" },
                            TRAINING_NM : {type:"string"},
                            YYYY : {type:"int"},
                            CHASU : {type:"string"},
                            EDU_PERIOD : { type:"string" },
                            DEPT_DESIGNATION_YN : { type:"string"},
                            VETER_ASSE_REQ_YN : { type: "string" },
                            ATTEND_STATE_NM : { type: "string" },
                            REQ_NUM : { type: "int" },
                            REQ_STS_NM : { type: "string" },
                            RECOG_TIME : {type:"string"},
                            CANCEL_YN : { type:"string" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false,
                pageSize: 30,
                error : function(e) {
                    //alert(e.status);
                    if(e.xhr.status==403){
                       alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                       sessionout();
                    }else{
                       alert('xhr.status = ' + e.xhr.status + '\n' +  'xhr.statusText = '  + e.xhr.statusText );
                    }
                }
            });
            
        }
    } ]);
  //엑셀다운로드
    function excelDownload(button){
    	button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/alw-edu_result_list_excel.do?YYYY=" + $("#yyyy").val();
    }
  

    /* 부서원상시학습달성현황 상세팝업창 열기 */
    var fn_openDtlPop = function(id) {
        $('#userid').val(id);
        
        //var obj = $('#grid').data('kendoGrid').dataSource.get(id);
        //console.log( JSON.stringify( $('#grid').data('kendoGrid').dataSource.get(id) ));
        //
        var res = $.grep($('#grid').data('kendoGrid').dataSource.data(), function (e) {
	        return e.USERID == id;
	    });
        $('#dtl-ttl').text( "※ "+res[0].NAME + "( " + res[0].GRADE_NM + " ) 님이 "+$("#yyyy").val()+"년에 수료한 교육이력 입니다." );
        
        if (!$("#dtl-window").data("kendoWindow")) {
            $("#dtl-window").kendoWindow({
                width : "1100px",
                title : "부서원상시학습달성현황 상세정보",
                modal: true,
                visible: false
            });
            
            $("#dtl-grid").kendoGrid({
                dataSource: dataSource_list2,
                height: 450,
                groupable: false,
                filterable:{
                    extra : false,
                    messages : { filter : "필터", clear : "초기화" },
                    operators : {
                        string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
                        number : { eq : "같음", gte : "이상", lte : "이하" }
                    }
                },
                sortable: true,
                resizable: true,
                reorderable: true,
                selectable: true,
                pageable : { refresh : false, pageSizes : [10,20,30], buttonCount: 5 },
                columns: [{
                    field: "SUBJECT_NAME", title: "과정명",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                    attributes : {"class":"table-cell", style:"text-align:left"},
                    width:350
                }, {
                    field: "TRAINING_NM",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                    attributes : {"class":"table-cell", style:"text-align:center"},
                    title: "학습유형",
                    width:120
                }, {
                    field: "EDU_PERIOD",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                    attributes : {"class":"table-cell", style:"text-align:center"},
                    title: "교육기간",
                    width:200
                }, {
                    field: "RECOG_TIME",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                    attributes : {"class":"table-cell", style:"text-align:center"},
                    title: "인정시간",
                    width:120
                }, {
                    field: "DEPT_DESIGNATION_YN",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                    attributes : {"class":"table-cell", style:"text-align:center"},
                    title: "부처지정학습",
                    width:130
                }]
            });
        } else {        
            dataSource_list2.read();
        }
        
        $("#dtl-window").data("kendoWindow").center();
        $("#dtl-window").data("kendoWindow").open();
    };
    
    /* 부서원상시학습달성현황 상세팝업 엑셀다운로드 */
    var fn_dtlExcelDown = function(button){
        button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/deptmgr/sbjct/alw-edu-result-list-detail-excel.do?userid="+$('#userid').val()+"&YYYY=" + removeNullStr( $("#yyyy").val() );
    };
    
</script>  

</head>
<body>
<div class="container">
		<div id="cont_body">
		 <div class="content">
			<div class="top_cont">
				<h3 class="tit01">부서원상시학습달성현황</h3>
				<div class="point">※ 부서원들의 년도별 상시학습 달성 현황을 열람할 수 있습니다.</div>
				<div class="location">
					<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
					<span>교육훈련결과&nbsp; &#62;</span>
					<span class="h">부서원상시학습달성현황</span>
				</div><!--//location-->
			</div>
			<div class="sub_cont">
				<div class="result_info">
                	<div class="tab_cont">
                		<label for="yyyy" >기준연도</label> : 
						<select id="yyyy" style="width:120px;" accesskey="w" ></select>
					</div>  
                    <div class="btn">
                        <a class="k-button"  onclick="excelDownload(this)" >엑셀 다운로드</a>
                    </div>
                </div><!--//result_info-->
                <div id="grid" class="mt15" style="height:550px;"></div>

             </div><!--//sub_cont-->
           </div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->

<!-- 선택 임직원 상세교육현황 -->
<div id="dtl-window" style="display: none;">
    <input type='hidden' id='userid' />

        <div >
            <div class="result_info">
                <div class="tab_cont">
                    <label id='dtl-ttl'>&nbsp;</label>
                </div>
                <div class="btn">
                    <a class="k-button" id="dtl-exceldown-btn" onclick="fn_dtlExcelDown(this)">엑셀 다운로드</a>
                </div>
            </div>
            <div id="dtl-grid" class="mt15" style="height:450px;"></div>
        </div>
    
</div>


</body>
</html>