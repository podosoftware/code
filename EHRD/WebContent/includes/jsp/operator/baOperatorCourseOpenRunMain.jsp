<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page pageEncoding="UTF-8" isErrorPage="true"%>
<html decorator="operatorSubpage">
<head>
<title>운영관리</title>

<style scoped>
h4.pop_tit {
  color: #0072bc;
  font-size: 15px;
  font-weight: bold;
  padding-left: 13px;
  background: url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/bul01.gif) no-repeat left center;
  letter-spacing: -0.05em;
}
table.table_type03 td {
  border-left: 1px solid #ebebeb;
  border-right: 1px solid #ebebeb;
  border-bottom: 1px solid #ebebeb;
  color: #666666;
  padding: 6px 0;
  text-align: center;
}
.btn_center {text-align: center; margin-top: 20px;}
.mb15 { margin-bottom: 15px !important;}
ul, ol {list-style: none;}
.sel_pop {border-top:1px solid #a0c5e4;}
.sel_pop table td{font-size:13px;}
ul.last {overflow:hidden}
ul.last li {float:left;margin:0 3px;}
ul.last li.name {background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/bul02.gif) no-repeat 16px center;padding-left:23px;font-weight:bold;}
.app_search {position:relative;height:30px;margin-bottom:10px;color:#666666;}
.app_search .btn {position:absolute;top:0;right:0;}
.pop_step {}
.pop_step li {}
.pop_step li.arrow {text-align:center;margin:20px 0 20px 0;}
.pop_step li ul.inner {overflow:hidden;width:292px;padding:15px 10px 12px 20px;} 
.pop_step li ul.inner.green {background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/bg_big_green.png) no-repeat;}
.pop_step li ul.inner.pink {background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/bg_big_pink.png) no-repeat;}
.pop_step li ul.inner.purple {background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/bg_big_purple.png) no-repeat;}
.pop_step li ul.inner li {float:left;color:#fff;}
.pop_step li ul.inner li.fir {width:135px;}
.pop_step li ul.inner li.sec {width:157px;}
.pop_step li ul.inner li .comm {font-size:13px;font-weight:bold;color:#fff;}
.pop_step li ul.inner li p {font-size:13px;font-weight:bold;}
.pop_step li ul.inner li p.tit {display: block; overflow: hidden; width: 125px;text-overflow: ellipsis;white-space: nowrap;}
.pop_step li ul.inner li  textarea.comment {width:157px;height:44px;margin-top:3px;}
.pop_step li ul.inner li .a_state {text-align:center;padding:22px 0 22px 0;font-size:15px;color:#fff;}
.pop_step li ul.inner li .a_state.pink {background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/bg_pink.png) no-repeat;}
.pop_step li ul.inner li .a_state.green {background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/bg_green.png) no-repeat;}
.pop_step li ul.inner li .a_state.purple {background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/sub/bg_purple.png) no-repeat;}
.point3 {color:#3276b1;font-size:13px;}
.input_disColor {background-color: #F5F5F5 !important; }
</style>

<script type="text/javascript">

var dataSource_attend ;
var now = new Date();
var detailSelected=null;

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
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/jquery.form.min.js'
        ],
        complete : function() {
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
              	splitterOtherHeight = $("#splitter").offset().top + $("#footer").outerHeight() + 15; //
                  splitterElement.height(winHeight - splitterOtherHeight);
                  
                  //그리드 사이즈 재조정..
              	var gridElement = $("#grid");
                  gridElement.height(splitterElement.outerHeight()-2);
                  
                  dataArea = gridElement.find(".k-grid-content"),
                  gridHeight = gridElement.innerHeight()+3,
                  otherElements = gridElement.children().not(".k-grid-content"),
                  otherElementsHeight = 0;
                  otherElements.each(function(){
                      otherElementsHeight += $(this).outerHeight();
                  });
                  dataArea.height(gridHeight - otherElementsHeight);
                
				//탭 생성.
				$("#tabstrip").kendoTabStrip({
                  	animation:  {
                          open: {
                              effects: "fadeIn"
                          }
                      },
                      activate: function(e){
                      	if(e.item.innerText == "수강정보"){
                      		$("#ttListGrid div.k-grid-content").attr("style", "height: "+($("#ttListGrid").innerHeight() - 70)+"px;");
                          }else if(e.item.innerText == "대상확정"){
                      		$("#targetConfirmGrid div.k-grid-content").attr("style", "height: "+($("#targetConfirmGrid").innerHeight() -95)+"px;");
                          }else if(e.item.innerText == "교육확정자"){
                          	$("#targetGrid div.k-grid-content").attr("style", "height: "+($("#targetGrid").innerHeight() - 70)+"px;");
                          }else if(e.item.innerText == "수료관리"){
                          	$("#cmpltGrid div.k-grid-content").attr("style", "height: "+($("#cmpltGrid").innerHeight() - 95)+"px;");
                          }
                      }
                  }).data("kendoTabStrip");
                  
                //탭 사이즈 재조정
                var tabStripElement = $("#tabstrip").kendoTabStrip();
                var expandContentDivs = function(divs) {
	                divs.height(gridElement.innerHeight()-49);
	            };
	            var resizeAll = function() {
	                expandContentDivs(tabStripElement.children(".k-content")); 
	            };
	            resizeAll();
                

                //수강정보 그리드 사이즈 재조정..
                var ttListGridElement = $("#ttListGrid");
                ttListGridElement.height(splitterElement.outerHeight()-150);
                ttListdataArea = ttListGridElement.find(".k-grid-content"),
                ttListGridHeight = ttListGridElement.innerHeight(),
                ttListdataArea.height(ttListGridHeight);
                
                //대상확정 그리드 사이즈 조정.
                var targetConfirmGridElement = $("#targetConfirmGrid");
                targetConfirmGridElement.height(splitterElement.outerHeight()-100);
                targetConfirmGriddataArea = targetConfirmGridElement.find(".k-grid-content"),
                targetConfirmGridHeight = targetConfirmGridElement.innerHeight(),
                targetConfirmGriddataArea.height(targetConfirmGridHeight);
                
	            //교육확정자 그리드 사이즈 조정
                var targetGridElement = $("#targetGrid");
                targetGridElement.height(splitterElement.outerHeight()-100);
                targetGriddataArea = targetGridElement.find(".k-grid-content"),
                targetGridHeight = targetGridElement.innerHeight(),
                targetGriddataArea.height(targetGridHeight);

                //수료관리 그리드 사이즈 조정
                var cmpltGridElement = $("#cmpltGrid");
                cmpltGridElement.height(splitterElement.outerHeight()-100);
                cmpltGriddataArea = cmpltGridElement.find(".k-grid-content"),
                cmpltGridHeight = cmpltGridElement.innerHeight(),
                cmpltGriddataArea.height(cmpltGridHeight);
            });
            /* 브라우저 height 에 따라 resize() 스타일 적용..  END !!! */
            
            //로딩바선언
            loadingDefine();
            
            // area splitter
            $("#splitter").kendoSplitter({
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
                    var startDate = this.value(),
                    endDate = searchEdate.value();

                    if (startDate) {
                        startDate = new Date(startDate);
                        startDate.setDate(startDate.getDate());
                        searchEdate.min(startDate);
                    } else if (endDate) {
                    	this.max(new Date(endDate));
                    } else {
                        endDate = new Date();
                        this.max(endDate);
                        searchEdate.min(endDate);
                    }
                             
                 }
            }).data("kendoDatePicker");

            var searchEdate = $("#searchEdate").kendoDatePicker({
                format: "yyyy-MM-dd",
                change: function(e) {                    
                    var endDate = this.value(),
                     startDate = searchSdate.value();
             
                     if (endDate) {
                         endDate = new Date(endDate);
                         endDate.setDate(endDate.getDate());
                         searchSdate.max(endDate);
                     } else if (startDate) {
                    	 this.min(new Date(startDate));
                     } else {
                         endDate = new Date();
                         searchSdate.max(endDate);
                         this.min(endDate);
                     }
                }
            }).data("kendoDatePicker");

            searchSdate.value(new Date(now.getFullYear(), now.getMonth(), 1));
            searchEdate.value(new Date(now.getFullYear(), now.getMonth()+2, 0));
            searchSdate.max(searchEdate.value());
            searchEdate.min(searchSdate.value());
            
            $("#searchDiv").kendoDropDownList({
                width: 100
            });
            
            //검색버튼 클릭
            $("#searchBtn").click(function(){
            	if(searchSdate.value() && searchEdate.value()){
            		$("#grid").data("kendoGrid").dataSource.read();
            	}else{
            		alert("검색 시작일과 종료일을 모두 입력해주세요.");
            	}
            });
            
            //상세닫기 버튼 클릭 시
            $("#detailCloseBtn").click( function(){
                // 상세영역 비활성화
                $("#splitter").data("kendoSplitter").toggle("#list_pane", true);
                $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
            });
            
            //학습유형 데이터소스
            dataSource_attend = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_commonCode_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {  STANDARDCODE : "BA01", ADDVALUE: "=== 선택 ===" };
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

            
            // show detail 
            $('#details').show().html(kendo.template($('#template').html()));        
	        //교육과정 목록 그리드 생성
	        $("#grid").kendoGrid({
	            dataSource : {
	                type : "json",
	                transport : {
	                    read : {
	                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-open-run-list.do?output=json",
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
                                startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter), SEARCHSDATE: $("#searchSdate").val(), SEARCHEDATE: $("#searchEdate").val(), SEARCHDIV : $("#searchDiv").val()
                            };    
	                    }
	                },
	                schema : {
	                    total : "totalItemCount",
	                    data : "items",
	                    model : {
	                        id : "SUBJECT_NUM",
	                        fields : {
	                            SUBJECT_NUM : {type : "number"},
	                            SUBJECT_NAME : {type : "string"},
	                            TRAINING_CODE : {type : "string"},
	                            TRAINING_STRING : {type : "string"},
	                            ALW_STD_CD : {type : "string"},
	                            DEPT_DESIGNATION_YN : {type : "string"},
	                            DEPT_DESIGNATION_CD : {type : "string"},
	                            DEPT_DESIGNATION_STRING : {type : "string"},
	                            INSTITUTE_NAME : {type : "string"},
	                            RECOG_TIME_H : {type : "number"},
	                            RECOG_TIME_M : {type : "number"},
	                            CNT : { type : "number"}
	                        }
	                    }
	                },
	                pageSize : 30,
	                serverPaging : true,
	                serverFiltering : true,
	                serverSorting : true
	            },
	            columns : 
						[ {
                            field : "SUBJECT_NUM_NUMB",
                            title : "과정번호",
                            width : "110px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "OPEN_NUM_NUMB",
                            title : "개설번호",
                            width : "110px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "SUBJECT_NAME",
                            title : "과정명",
                            width : "200px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:left;text-decoration: underline;"},
                            template: function(data){
                                var subjectName = data.SUBJECT_NAME;
                                if(data.CLOSING_YN == 'Y'){
                                    subjectName = "<font color='red'>"+data.SUBJECT_NAME+" (폐강)</font>";
                                }
                                return "<a href='javascript:void();' onclick='javascript: fn_detailView("+data.SUBJECT_NUM+", "+data.OPEN_NUM+");' >"+subjectName+"</a>";
                            }
                        },{
	                        field : "TRAINING_STRING",
	                        title : "학습유형",
	                        width : "110px",
	                        headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:center"}
	                    },{
                            field : "CHASU",
                            title : "기수",
                            width : "90px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "EDU_PERIOD",
                            title : "교육기간",
                            width : "180px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "APPLY_PERIOD",
                            title : "신청기간",
                            width : "180px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "RECOG_TIME_H",
                            title : "인정시간",
                            width : "110px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:center"},
                            template : function(data) {
                                return data.RECOG_TIME_H + "시간" + data.RECOG_TIME_M + "분";
                            }
                        },{
	                        field : "DEPT_DESIGNATION_YN",
	                        title : "부처지정학습",
	                        width : "140px",
	                        headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:center"}
	                    },{
	                        field : "CNT",
	                        title : "총인원",
	                        width : "100px",
	                        headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
	                        attributes : {"class" : "table-cell",style : "text-align:center"}
	                    },{
                            field : "CONFIRM_CNT",
                            title : "대상자처리",
                            width : "120px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "CMPL_CNT",
                            title : "증빙제출",
                            width : "110px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
                        },{
                            field : "REQ_STS_NM",
                            title : "교육추천",
                            width : "110px",
                            headerAttributes : {"class" : "table-header-cell",style : "text-align:center"},
                            attributes : {"class" : "table-cell",style : "text-align:center"}
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
            
            //수강정보 탭의 상단그리드(현황)
            $("#ttGrid").kendoGrid({
                dataSource : {
                    type : "json",
                    transport : {
                        read : {
                            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-open-run-attend-curr.do?output=json",
                            type : "POST"
                        },
                        parameterMap : function(options, operation) {
                            return {
                            	SUBJECT_NUM : $("#dtl-subjectNum").val(), OPEN_NUM: $("#dtl-openNum").val()
                            };
                        }
                    },
                    schema : {
                        total : "totalItemCount",
                        data : "items",
                        model : {
                            fields : {
                            	T_CNT : { type : "number", editable : false },
                            	ONE_S : { type : "number", editable : false },
                            	TWO_S : { type : "number", editable : false },
                            	THREE_S : { type : "number", editable : false },
                            	FIVE_S : { type : "number", editable : false },
                            	SIX_S : { type : "number", editable : false },
                            	SEVEN_S : { type : "number", editable : false },
                            	EIGHT_S : { type : "number", editable : false },
                            	NINE_S : { type : "number", editable : false },
                            	TEN_S : { type : "number", editable : false }
                            }
                        }
                    }
                },
                scrollable : false,
                sortable : false,
                filterable : false,
                pageable : false,
                editable : false,
                columns : [
                        {
                            field : "T_CNT",
                            title : "총인원",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        },{
                            field : "ONE_S",
                            title : "신청",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        },{
                            field : "THREE_S",
                            title : "취소",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        },{
                            field : "TWO_S",
                            title : "수강",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        },{
                            field : "FIVE_S",
                            title : "수료",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        },{
                            field : "SIX_S",
                            title : "미등록",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        },{
                            field : "SEVEN_S",
                            title : "퇴교",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        },{
                            field : "EIGHT_S",
                            title : "미선정",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        },{
                            field : "NINE_S",
                            title : "기타",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        },{
                            field : "TEN_S",
                            title : "낙제",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        }  
                ],
                height : 65
            });
            
            //수강정보 탭의 하단 그리드
            $("#ttListGrid").kendoGrid({
                dataSource : {
                    type : "json",
                    transport : {
                        read : {
                            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-open-run-attend-list.do?output=json",
                            type : "POST"
                        },
                        parameterMap : function(options, operation) { 
                            return { SUBJECT_NUM : $("#dtl-subjectNum").val(), OPEN_NUM: $("#dtl-openNum").val() };
                        }
                    },
                    schema : {
                        total : "totalItemCount",
                        data : "items",
                        model : {
                            id : "SUBJECT_NUM",
                            fields : {
                                SUBJECT_NUM : {type : "number"},
                                NAME : {type : "string"},
                                DVS_NAME : {type : "string"},
                                EMPNO : {type : "string"},
                                GRADE_NM : {type : "string"},
                                ATTEND_STATE_NM : {type : "string"},
                                APL_DTIME : {type : "string"},
                                FAIL_REASON : {type : "string"}
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
                             field : "RNUM",
                             title : "번호",
                             width : "50px",
                             headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                             attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
                             field : "NAME",
                             title : "성명",
                             width : "80px",
                             headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                             attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
                            field : "DVS_NAME",
                            title : "부서",
                            width : "150px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:left" },
						},{
                            field : "EMPNO",
                            title : "교직원번호",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
                            field : "GRADE_NM",
                            title : "직급",
                            width : "100px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template:function(data){
                            	if(data.GRADE_NM!=null){
									return data.GRADE_NM;
                            	}else{
									return "";
                            	}
                            }
						},{
							field : "ATTEND_STATE_NM",
                            title : "수강상태",
                            width : "100px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
							title : "정보변경",
							width : "180px",
							headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template: function (data){
                                if(data.ATTEND_STATE_NM =="신청" || data.ATTEND_STATE_NM =="수강" || data.ATTEND_STATE_NM =="취소"){
                            	return "<button style='width:80px; min-width: 50px;' class='k-button' onclick='chasuChange("+data.USERID+","+data.YYYY+","+data.CHASU+");'>차수변경</button>"+
                                "<button style='width:60px; min-width: 50px;' class='k-button' onclick='deleteUser("+data.USERID+")'>삭제</button>";
                                }else{
                                	return "";
                                }
                            }
                        } 
                ],
                filterable : false,
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
            
            //대상확정 탭의 그리드.
            var targetConfirmGrid = $("#targetConfirmGrid").kendoGrid({
                dataSource : {
                    type : "json",
                    transport : {
                        read : {
                            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/confirm-the-target-list.do?output=json",
                            type : "POST"
                        },
                        parameterMap : function(options, operation) { 
                            return { subjectNum : $("#dtl-subjectNum").val(), openNum: $("#dtl-openNum").val() };
                        }
                    },
                    schema : {
                        total : "totalItemCount",
                        data : "items",
                        model : {
                            id : "OPEN_NUM",
                            fields : {
                                SUBJECT_NUM : { type : "number" },
                                OPEN_NUM : {type : "number" },
                                USERID : { type: "number" },
                                NAME : { type : "string" },
                                DVS_NAME : { type : "string" },
                                EMPNO : { type : "string" },
                                GRADE_NM : { type : "string" },
                                ATTEND_STATE_CODE : { type : "string" },
                                ATTEND_STATE_NM : {  type : "string" },
                                APL_DTIME : { type : "string" },
                                RNUM : { type : "number" }
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
							field : "RNUM",
							title : "번호",
							width : "60px",
							headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
							attributes : { "class" : "table-cell", style : "text-align:center" }
 						},{
                            field : "NAME",
                            title : "성명",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
							field : "DVS_NAME",
							title : "부서",
							width : "200px",
							headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
							attributes : { "class" : "table-cell", style : "text-align:left" },
						},{
                            field : "EMPNO",
                            title : "교직원번호",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
                            field : "GRADE_NM",
                            title : "직급",
                            width : "120px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template:function(data){
                            	if(data.GRADE_NM!=null){
									return data.GRADE_NM;
                            	}else{
									return "";
                            	}
                            }
						},{
                            field : "APL_DTIME",
                            title : "신청일시",
                            width : "100px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
                            field : "RECOMM_RANKING",
                            title : "추천순위",
                            width : "100px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template: function(data){
                            	var recommRanking = "";
                            	if(data.RECOMM_RANKING){
                            		recommRanking = data.RECOMM_RANKING;
                            	}
                            	return "<input type=\"text\" id=\"recomm_"+data.USERID+"\" name=\"recomm_"+data.USERID+"\" class=\"k-input input_95\" style=\"text-align:center; \" onkeyup=\"setRecommValue("+data.USERID+"); \" maxlength=\"5\" value=\""+recommRanking+"\"/>";
                            }
                        },{
							field : "ATTEND_STATE_CODE",
							title : "대상자선정<br>신청 / 선정 / 미선정",
							width : "150px",
							headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
							attributes : { "class" : "table-cell", style : "text-align:center" },
							template: function(data){
                            	var str1 = "";
                            	var str2 = "";
                            	var str8 = "";
                                
                            	if(data.ATTEND_STATE_CODE == "1"){
                            		str1 = "checked";
                            	}else if(data.ATTEND_STATE_CODE == "2"){
                                    str2 = "checked";
                                }else if(data.ATTEND_STATE_CODE == "8"){
                                    str8 = "checked";
                                }
                            	return "<div style=\"text-align:center; \">"+
                                "<input type=\"radio\" value=\"1\" name=\"asc_"+data.USERID+"\" id=\"asc_"+data.USERID+"\" onclick=\"setASCValue(1, "+data.USERID+"); \" "+str1+" />&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;"+
                                "<input type=\"radio\" value=\"2\" name=\"asc_"+data.USERID+"\" id=\"asc_"+data.USERID+"\" onclick=\"setASCValue(2, "+data.USERID+"); \" "+str2+" />&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;"+
                                "<input type=\"radio\" value=\"8\" name=\"asc_"+data.USERID+"\" id=\"asc_"+data.USERID+"\" onclick=\"setASCValue(8, "+data.USERID+"); \" "+str8+" /></div>";
                            },
                            sortable:false
						},{
                            field : "FAIL_REASON",
                            title : "미선정사유",
                            width : "150px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template: function(data){
                            	
                            	return "<input type=\"text\" id=\"reason_"+data.USERID+"\" name=\"reason_"+data.USERID+"\" class=\"k-input input_95\" style=\"text-align:left; \" onkeyup=\"setReasonValue("+data.USERID+"); \" maxlength=\"20\" />";
                            },
                            sortable:false
                        } 
                ],
                filterable : false,
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
            
            $("#recommSaveBtn").kendoButton();
            
            //대상확정 탭의 일괄선정 처리 이벤트
            $("#allSelectionBtn").click(function(){
            	$.each(targetConfirmGrid.dataSource.data(), function(index, value) {
            		this.ATTEND_STATE_CODE = "2";
            	});
            	
            	targetConfirmGrid.refresh();
            });
            
            //추천순위 승인현황
            $("#recommSts").click(function(){
                //요청 취소 가능 여부 체크
                var cancelAbleYn =  "Y";
                if($("#dtl-reqStsCd").val() == "2" || $("#dtl-reqStsCd").val() == "3"){
                    //승인요청건에 대해 최종 처리가 되기전엔 취소가능하도록 함.
                    cancelAbleYn =  "N";
                }
                //승인현황 팝업 호출.
                apprStsOpen(6, $("#dtl-reqNum").val() , cancelAbleYn);
                //승인취소 처리 후 callback 함수 정의
                reqCancelCompleteCallbackFunc = fn_afterReqCancel;
            });
            
            //승인요청 취소후 처리
            var fn_afterReqCancel = function(){
            	fn_detailView($("#dtl-subjectNum").val(), $("#dtl-openNum").val());
            };
            
            //대상확정 탭의 추천순위승인요청 버튼 클릭 시
            $("#recommSaveBtn").click(function(){
            	if(targetConfirmGrid.dataSource.data().length==0){
            		return false;
                }else{
                    var flag = true;
                    $.each(targetConfirmGrid.dataSource.data(), function(index, value) {
                        var recommRanking = "";
                        if(this.RECOMM_RANKING && this.RECOMM_RANKING!=""){
                        	recommRanking = this.RECOMM_RANKINGl
                        }
                    	if(recommRanking == ""){
                            flag = false;
                        }
                    });
                    
                    if(!flag){
                        alert("추천순위가 입력되지 않은 사용자가 존재합니다.");
                        return false;
                    }
                }
            	
            	if(!confirm("승인요청 하시겠습니까?")) return;
            	
            	// 결재창 오픈
                apprReqOpen();
                apprReqCallBackFunc = fn_saveRecomm;
                
            });
            

            /* 추천순위 승인요청 등록 */
            var fn_saveRecomm = function() {
                var appr_list = null;
                
                if($("#apprReqUserGrid").data("kendoGrid")){
                    appr_list = $("#apprReqUserGrid").data("kendoGrid").dataSource.data();
                } else {
                    alert('승인자 정보가 없습니다. 승인자를 선택해주세요.');
                    return;
                }
                //로딩바 생성.
                loadingOpen();
                
                var params = {
                        LIST :  targetConfirmGrid.dataSource.data()  
                };
                
                $.ajax({
                    type : 'POST',
                    dataType : 'json',
                    url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-open-recomm-target.do?output=json",
                    data : {
                        item: kendo.stringify( params ), 
                        openNum : $("#dtl-openNum").val(),
                        apprList : kendo.stringify( appr_list )
                    },
                    complete : function(response) {
                        //로딩바 제거.
                        loadingClose();
                        
                        var obj = eval("(" + response.responseText + ")");
                        if(obj.error){
                            alert("ERROR=>"+obj.error.message);
                        }else{
                            if (obj.saveCount > 0) {
                                //상세화면 refresh..
                                //fn_detailRefresh();
                                fn_detailView($("#dtl-subjectNum").val(), $("#dtl-openNum").val());
                                
                                alert("요청되었습니다.");
                            } else {
                                alert("실패 하였습니다.");
                            }
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
                    }
                });
                
            };
            
            //대상확정 탭의 저장 버튼 클릭 시
            $("#selectionSaveBtn").click(function(){
            	if(targetConfirmGrid.dataSource.data().length==0){
            		return false;
            	}else{
            		var flag = false;
            		$.each(targetConfirmGrid.dataSource.data(), function(index, value) {
            			if(this.ATTEND_STATE_CODE != "1"){
            				flag = true;
            			}
                    });
            		
            		if(!flag){
            			alert("대상자선정 처리할 대상자가 존재하지 않습니다.\n선정 또는 미선정을 선택해주세요.");
            			return false;
            		}
            	}
            	
                var isDel = confirm("저장 하시겠습니까?");
                if (isDel) {
                    //로딩바 생성.
                    loadingOpen();
                    
                    var params = {
                            LIST :  targetConfirmGrid.dataSource.data()  
                    };
                    
                    $.ajax({
                        type : 'POST',
                        dataType : 'json',
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-open-target.do?output=json",
                        data : {
                        	item: kendo.stringify( params ), openNum : $("#dtl-openNum").val()
                        },
                        complete : function(response) {
                            //로딩바 제거.
                            loadingClose();
                            
                            var obj = eval("(" + response.responseText + ")");
                            if(obj.error){
                                alert("ERROR=>"+obj.error.message);
                            }else{
                                if (obj.saveCount > 0) {
                                    //상세화면 refresh..
                                    fn_detailRefresh();
                                    
                                    alert("저장되었습니다.");
                                } else {
                                    alert("저장을 실패 하였습니다.");
                                }
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
                        }
                    });
                }
            });
            
            //교육확정자 탭의 그리드.
            $("#targetGrid").kendoGrid({
                dataSource : {
                    type : "json",
                    transport : {
                        read : {
                            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/edu-target-list.do?output=json",
                            type : "POST"
                        },
                        parameterMap : function(options, operation) { 
                            return { subjectNum : $("#dtl-subjectNum").val(), openNum: $("#dtl-openNum").val() };
                        }
                    },
                    schema : {
                        total : "totalItemCount",
                        data : "items",
                        model : {
                            fields : {
                                SUBJECT_NUM : { type : "number" },
                                OPEN_NUM : {type : "number" },
                                USERID : { type: "number" },
                                NAME : { type : "string" },
                                DVS_NAME : { type : "string" },
                                EMPNO : { type : "string" },
                                GRADE_NM : { type : "string" },
                                ATTEND_STATE_CODE : { type : "string" },
                                ATTEND_STATE_NM : {  type : "string" },
                                APL_DTIME : { type : "string" },
                                RNUM : { type : "number" }
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
                             field : "RNUM",
                             title : "번호",
                             width : "60px",
                             headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                             attributes : { "class" : "table-cell", style : "text-align:center" }
 						},{
                             field : "NAME",
                             title : "성명",
                             width : "80px",
                             headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                             attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
                            field : "DVS_NAME",
                            title : "부서",
                            width : "200px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:left" },
						},{
                            field : "APL_DTIME",
                            title : "신청일자",
                            width : "100px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
                            field : "EMPNO",
                            title : "교직원번호",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
                            field : "GRADE_NM",
                            title : "직급",
                            width : "120px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template:function(data){
                            	if(data.GRADE_NM!=null){
									return data.GRADE_NM;
                            	}else{
									return "";
                            	}
                            }
						},{
                            field : "APL_DIV_NM",
                            title : "신청구분",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
						},{
                            field : "ATTEND_STATE_NM",
                            title : "수강상태",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" }
                        }
                ],
                filterable : false,
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

            //수강생 엑셀업로드 버튼 클릭.
            $("#userExcelUploadBtn").click(function() {
                $('#targetUpload-window').data("kendoWindow").center();
                $("#targetUpload-window").data("kendoWindow").open();
            });

            //수강생 엑셀파일업로드 팝업창 정의.. 상단에서 jquery.form.min.js 파일로드 해야함. 
            if (!$("#targetUpload-window").data("kendoWindow")) {
                $("#targetUpload-window").kendoWindow({
                    width : "360px",
                    minWidth : "360px",
                    resizable : false,
                    title : "수강생 엑셀 업로드",
                    modal : true,
                    visible : false
                });
                
                //수강생 업로드 버튼 이벤트
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
                                	opt["url"] = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-target-user-excel.do?output=json&subjectNum=" + $("#dtl-subjectNum").val() + "&openNum=" + $("#dtl-openNum").val() ;
                                	
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
                                alert("-수강생 업로드 결과-\n"+myObj.statement);
                            }else{
                                //작업 실패.
                                alert("작업이 실패하였습니다.");
                            }
                            
                            //그리드 다시 읽고,
                            fn_detailRefresh();//$("#grid").data("kendoGrid").dataSource.read();
                            
                            //업로드 객체 초기화
                            $("#upload_file").parents(".k-upload").find(".k-upload-files").remove();
                            $("input[name=upload_file]").each(function(e){
                                var inputFile =  $("input[name=upload_file]")[e];
                                if($(inputFile)){
                                    if( $(inputFile).id  != "upload_file"){
                                        //프로그래밍한 input file이 아닌 자동  추가된 input file은 제거
                                        $(inputFile).remove();  
                                    }
                                }
                            });
                            
                            //팝업 닫기.
                            $("#targetUpload-window").data("kendoWindow").close();
                        },
                        error: function(e){
                            alert("ERROR:"+e);
                        }
                    });
                });
                
                $("#upload_file").kendoUpload({
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
            
            //수강생 엑셀 업로드 버튼 클릭 시.. 
            $("#userExcelUploadBtn").click(function(){
	            //브라우져 버젼체크
	            var ver = getInternetExplorerVersion();
                
                if( ( ver > -1) && ( ver < 10 ) ){
                	var width = 385;
                    var height = 280;
                    var left = (screen.width - width) / 2;
                    var top = (screen.height - height) / 2;
                    var windowUrl = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-target-user-excel.do?subjectNum=" + $("#dtl-subjectNum").val() + "&openNum=" + $("#dtl-openNum").val() +"&fileType=xls" ;
                    myWindow = window.open(windowUrl, "targetUpload", "toolbar=no, scrollbars=yes, resizable=yes, top="+top+", left="+left+", width="+width+", height="+height);
                    myWindow.focus();
                }else{
                	if( !$("#targetUpload-window").data("kendoWindow") ){
                        $("#targetUpload-window").kendoWindow({
                            width:"320px",
                            height:"150px",
                            resizable : true,
                            title : "수강생엑셀업로드",
                            modal: true,
                            visible: false
                        });
                        
                        if( $('#target-upload').text().length == 0  ) {
                            var template = kendo.template($("#targetUpload-template").html());
                            $('#target-upload').html(template({}));
                        }                   
                        if( !$('#upload_file').data('kendoUpload') ){
                            $("#upload_file").kendoUpload({
                                showFileList : false,
                                width : 250,
                                multiple : false,
                                localization:{ select : '파일 선택' , statusUploaded: "완료.", statusFailed : "업로드 실패." },
                                async: {
                                    saveUrl:  '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-target-user-excel.do?output=json',                               
                                    autoUpload: true
                                },
                                upload: function (e) {                                       
                                    e.data = { subjectNum : $("#dtl-subjectNum").val() , openNum : $("#dtl-openNum").val() };                                                                                                                    
                                },
                                error : function (e){                           
                                },
                                success : function(e){
                                	$("#targetUpload-window").data("kendoWindow").close();
                                    handleCallbackUploadResult(e.response.saveCount);
                                },
                                select: function(e){
                                    $.each(e.files, function(index, value) {
                                        if(value.size>10485760){
                                            e.preventDefault();
                                            alert("파일 사이즈는 10M로 제한되어 있습니다.");
                                        }else{
                                            if(value.extension.toLowerCase() != ".xls" && value.extension.toLowerCase() != ".xlsx") {
                                                e.preventDefault();
                                                alert("엑셀 파일만 선택해주세요.");
                                            }
                                        }
                                    });
                                }
                                
                            });
                            $("#target-upload").removeClass('hide');
                        }
                    }

                    $("#targetUpload-window").data("kendoWindow").center();
                    $("#targetUpload-window").data("kendoWindow").open();
                }
                
            });

            //수료관리 탭의 그리드.
            var cmpltGrid = $("#cmpltGrid").kendoGrid({
                dataSource : {
                    type : "json",
                    transport : {
                        read : {
                            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/edu-cmplt-list.do?output=json",
                            type : "POST"
                        },
                        parameterMap : function(options, operation) { 
                            return { subjectNum : $("#dtl-subjectNum").val(), openNum: $("#dtl-openNum").val() } ;
                        }
                    },
                    schema : {
                        total : "totalItemCount",
                        data : "items",
                        model : {
                            fields : {
                                SUBJECT_NUM : { type : "number" },
                                OPEN_NUM : {type : "number" },
                                USERID : { type: "number" },
                                NAME : { type : "string" },
                                DVS_NAME : { type : "string" },
                                EMPNO : { type : "string" },
                                GRADE_NM : { type : "string" },
                                TIME_GRADE_NM : { type : "string" },
                                ATTEND_STATE_CODE : { type : "string" },
                                ATTEND_STATE_NM : {  type : "string" },
                                APL_DTIME : { type : "string" },
                                RNUM : { type : "number" }
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
                             width : "80px",
                             headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                             attributes : { "class" : "table-cell", style : "text-align:center" }
 						},{
                             field : "",
                             title : "증빙자료",
                             width : "80px",
                             headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                             attributes : { "class" : "table-cell", style : "text-align:center" },
                             template : function(data){
		                        if(data.FILE_CNT && data.FILE_CNT>0){
		                        	return "<input type='button' class='k-button k-i-close' style='width:45px; ' value='다운로드' onclick='fn_attachments("+data.USERID+");'/>";
		                        }else{
		                        	return "미제출";
		                        }
       	                     }
						},{
                            field : "ATTEND_SCO",
                            title : "근태",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:left" },
                            template: function(data){
                                var attendSco = "";
                                if(data.ATTEND_SCO){
                                	attendSco = data.ATTEND_SCO;
                                }
                                return "<input type=\"text\" id=\"attend_"+data.USERID+"\" name=\"attend_"+data.USERID+"\" value=\""+attendSco+"\" class=\"k-input input_95\" style=\"text-align:center; \" onkeyup=\"setCmpltValue('attend', "+data.USERID+", this); \" maxlength=\"4\" />";
                            }
                        },
                        {
                            field : "PRAC_SCO",
                            title : "실기평가",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template: function(data){
                                var pracSco = "";

                                if(data.PRAC_SCO){
                                	pracSco = data.PRAC_SCO;
                                }
                                return "<input type=\"text\" id=\"prac_"+data.USERID+"\" name=\"prac_"+data.USERID+"\" value=\""+pracSco+"\" class=\"k-input input_95\" style=\"text-align:center; \" onkeyup=\"setCmpltValue('prac', "+data.USERID+", this); \" maxlength=\"4\" />";
                            }
						},{
                            field : "ANNO_SCO",
                            title : "발표",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template: function(data){
                                var annoSco = "";
                                
                                if(data.ANNO_SCO){
                                	annoSco = data.ANNO_SCO;
                                }
                                return "<input type=\"text\" id=\"anno_"+data.USERID+"\" name=\"anno_"+data.USERID+"\" value=\""+annoSco+"\" class=\"k-input input_95\" style=\"text-align:center; \" onkeyup=\"setCmpltValue('anno', "+data.USERID+", this); \" maxlength=\"4\" />";
                            }
						},{
                            field : "CHALL_SCO",
                            title : "과제",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template: function(data){
                                var challSco = "";
                                
                                if(data.CHALL_SCO){
                                	challSco = data.CHALL_SCO;
                                }
                                return "<input type=\"text\" id=\"chall_"+data.USERID+"\" name=\"chall_"+data.USERID+"\" value=\""+challSco+"\" class=\"k-input input_95\" style=\"text-align:center; \" onkeyup=\"setCmpltValue('chall', "+data.USERID+", this); \" maxlength=\"4\" />";
                            }
						},{
                            field : "ETC_SCO",
                            title : "기타",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template: function(data){
                                var etcSco = "";
                                
                                if(data.ETC_SCO){
                                	etcSco = data.ETC_SCO;
                                }
                                return "<input type=\"text\" id=\"etc_"+data.USERID+"\" name=\"etc_"+data.USERID+"\" value=\""+etcSco+"\" class=\"k-input input_95\" style=\"text-align:center; \" onkeyup=\"setCmpltValue('etc', "+data.USERID+", this); \" maxlength=\"4\" />";
                            }
						},{
                            field : "DISCU_SCO",
                            title : "분임토의",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template: function(data){
                                var discuSco = "";
                                
                                if(data.DISCU_SCO){
                                	discuSco = data.DISCU_SCO;
                                }
                                return "<input type=\"text\" id=\"discu_"+data.USERID+"\" name=\"discu_"+data.USERID+"\" value=\""+discuSco+"\" class=\"k-input input_95\" style=\"text-align:center; \" onkeyup=\"setCmpltValue('discu', "+data.USERID+", this); \" maxlength=\"4\" />";
                            }
						},{
                            field : "TT_GET_SCO",
                            title : "총점수",
                            width : "80px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template: function(data){
                                var ttSco = "";
                                
                                if(data.TT_GET_SCO){
                                    ttSco = data.TT_GET_SCO;
                                }
                                return "<input type=\"text\" id=\"tt_"+data.USERID+"\" name=\"tt_"+data.USERID+"\" value=\""+ttSco+"\" class=\"k-input input_95\" style=\"text-align:center; \" onkeyup=\"setCmpltValue('tt', "+data.USERID+", this); \" maxlength=\"4\" />";
                            }
						},{
                            title : "수료여부<br>수강 / 수료 / 미등록 / 퇴교 / 기타 / 낙제",
                            width : "240px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:center" },
                            template: function(data){
                                var str2 = "";
                                var str5 = "";
                                var str6 = "";
                                var str7 = "";
                                var str9 = "";
                                var str10 = "";
                                
                                if(data.ATTEND_STATE_CODE == "2"){
                                    str2 = "checked";
                                }else if(data.ATTEND_STATE_CODE == "5"){
                                    str5 = "checked";
                                }else if(data.ATTEND_STATE_CODE == "6"){
                                    str6 = "checked";
                                }else if(data.ATTEND_STATE_CODE == "7"){
                                    str7 = "checked";
                                }else if(data.ATTEND_STATE_CODE == "9"){
                                    str9 = "checked";
                                }else if(data.ATTEND_STATE_CODE == "10"){
                                    str10 = "checked";
                                }
                                return "<div style=\"text-align:center; \">"+
                                "<input type=\"radio\" value=\"2\" name=\"cmplt_"+data.USERID+"\" id=\"cmplt_"+data.USERID+"\" onclick=\"setCmpltASCValue(2, "+data.USERID+"); \" "+str2+" />&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;"+
                                "<input type=\"radio\" value=\"5\" name=\"cmplt_"+data.USERID+"\" id=\"cmplt_"+data.USERID+"\" onclick=\"setCmpltASCValue(5, "+data.USERID+"); \" "+str5+" />&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;"+
                                "<input type=\"radio\" value=\"6\" name=\"cmplt_"+data.USERID+"\" id=\"cmplt_"+data.USERID+"\" onclick=\"setCmpltASCValue(6, "+data.USERID+"); \" "+str6+" />&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;"+
                                "<input type=\"radio\" value=\"7\" name=\"cmplt_"+data.USERID+"\" id=\"cmplt_"+data.USERID+"\" onclick=\"setCmpltASCValue(7, "+data.USERID+"); \" "+str7+" />&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;"+
                                "<input type=\"radio\" value=\"9\" name=\"cmplt_"+data.USERID+"\" id=\"cmplt_"+data.USERID+"\" onclick=\"setCmpltASCValue(9, "+data.USERID+"); \" "+str9+" />&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;"+
                                "<input type=\"radio\" value=\"10\" name=\"cmplt_"+data.USERID+"\" id=\"cmplt_"+data.USERID+"\" onclick=\"setCmpltASCValue(10, "+data.USERID+"); \" "+str10+" /></div>";
                            }
						},{
                            title : "인정직급",
                            width : "200px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:left" },
                            template : function(data){
	                            if(data.TIME_GRADE_NM!=null){
									return data.TIME_GRADE_NM+" <input type=\"button\" class=\"k-button k-i-close\" style=\"width:45px; \" value=\"변경\" onclick=\"fn_gradeChange("+data.USERID+",'"+data.TIME_GRADE_NUM+"');\"/>";
	                            }else{
									return "<input type=\"button\" class=\"k-button k-i-close\" style=\"width:45px; \" value=\"변경\" onclick=\"fn_gradeChange("+data.USERID+",'"+data.TIME_GRADE_NUM+"');\"/>";
	                            }
   	                     	}
                        },{
                            title : "인정시간",
                            width : "160px",
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                            attributes : { "class" : "table-cell", style : "text-align:left" },
                            template : function(data){
                                if(data.ATTEND_STATE_CODE == "5"){
                                	return data.RECOG_TIME_H+"시간"+data.RECOG_TIME_M+"분 "+" <input type='button' class='k-button k-i-close' style='width:45px; ' value='재계산' onclick='fn_recogTimeChange("+data.USERID+");'/>";
                                }else{
                                	return data.RECOG_TIME_H+"시간"+data.RECOG_TIME_M+"분";
                                }
                            }
                        }
                ],
                filterable : false,
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
            
            //수료관리 탭의 일괄수료선택 처리 이벤트
            $("#allCmpltBtn").click(function(){
                $.each(cmpltGrid.dataSource.data(), function(index, value) {
                    this.ATTEND_STATE_CODE = "5";
                    //$("#cmplt");
                    $('input:radio[id=cmplt_'+this.USERID+']:input[value=5]').attr("checked", true);
                });
            });
            
            //수료처리
            $("#cmpltExecBtn").click(function(){
            	if(cmpltGrid.dataSource.data().length==0){
                    return false;
                }else{
                    var flag = false;
                    $.each(cmpltGrid.dataSource.data(), function(index, value) {
                        if(this.ATTEND_STATE_CODE == "5" || this.ATTEND_STATE_CODE == "6" || this.ATTEND_STATE_CODE == "7" || this.ATTEND_STATE_CODE == "9" || this.ATTEND_STATE_CODE == "10"){
                            flag = true;
                        }
                    });
                    
                    //if(!flag){
                    //    alert("수료 처리할 대상자가 존재하지 않습니다.");
                    //    return false;
                    //}
                }
                
                var isDel = confirm("입력된 내용으로 수료처리 하시겠습니까?");
                if (isDel) {
                    //로딩바 생성.
                    loadingOpen();
                    var params = {
                            LIST :  cmpltGrid.dataSource.data()  
                    };
                    
                    $.ajax({
                        type : 'POST',
                        dataType : 'json',
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-open-cmplt.do?output=json",
                        data : {
                            item: kendo.stringify( params ), 
                            openNum : $("#dtl-openNum").val(), 
                            alwStdCd : $("#dtl-alwStdCd").val(), 
                            RECOG_TIME_H: $("#dtl-recogTimeH").val(), 
                            RECOG_TIME_M: $("#dtl-recogTimeM").val(), 
                            YYYY: $("#yyyy").val(), 
                            SUBJECT_NUM : $("#dtl-subjectNum").val(),
                        },
                        complete : function(response) {
                            var obj = eval("(" + response.responseText + ")");

                            //로딩바 제거.
                            loadingClose();
                            
                            if(obj.error){
                                alert("ERROR=>"+obj.error.message);
                            }else{
                                if (obj.saveCount > 0) {
                                    
                                	//상세화면 refresh..
                                    fn_detailRefresh();
                                    
                                    alert("저장되었습니다.");
                                } else {
                                	alert("저장을 실패 하였습니다.");
                                }
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
                        }
                    });
                }
            });
            //브라우저 resize 이벤트 dispatch..
            $(window).resize();
            //$("#tabstrip ").click(function(){
            $("#tabstrip ul li").change(function(){
            	$("#ttGrid").data("kendoGrid").dataSource.read();
                $("#ttListGrid").data("kendoGrid").dataSource.read();
                $("#targetConfirmGrid").data("kendoGrid").dataSource.read();
                $("#targetGrid").data("kendoGrid").dataSource.read();
                $("#cmpltGrid").data("kendoGrid").dataSource.read();
            });
            
          //직급목록 데이터소스
            var dataSource_gradeCd = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/grade-change-list.do?output=json", type:"POST" },
                },
                schema: {data: "items",model: {fields: {
                    VALUE : { type: "String" },
                    TEXT : { type: "String" }
    			}}},
                serverFiltering: false,
                serverSorting: false});
    	  	//직급목록
            $("#gradeChange").kendoDropDownList({
                 dataTextField: "TEXT",
                 dataValueField: "VALUE",
                 dataSource: dataSource_gradeCd,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
    	  	
    	  	
    	  	//차수정보 탭의 메모 저장 버튼 클릭 
            $("#memoChangeBtn").click(function(){
                if($("#EDU_MEMO").val()==""){alert("메모를 입력해주세요.");return false;}
                
                var isDel = confirm("메모 내용을 저장하시겠습니까?");
                
                if (isDel) {
                    $.ajax({
                        type : 'POST',
                        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/change-user-memo.do?output=json",
                        data : {
                            EDU_MEMO : $("#EDU_MEMO").val(), openNum : $("#dtl-openNum").val()
                        },
                        complete : function(response) {
                            var obj = eval("(" + response.responseText + ")");
                            if (obj.saveCount > 0) {
                                alert("저장되었습니다.");
                                
                              } else {
                                  alert("실패 하였습니다.");
                              }
                            if(obj.error){
                                alert("ERROR=>"+obj.error.message);
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
                        },
                        dataType : "json"
                    });
                }
            });
        }
    } ]);
</script>

<script type="text/javascript">


	//수료관리 라디오버튼 이벤트 처리
	function setCmpltASCValue(code, userid){
	    var array = $('#cmpltGrid').data('kendoGrid').dataSource.data();            
	    
	    var res = $.grep(array, function (e) {
	        return e.USERID == userid;
	    });
	    
	    res[0].ATTEND_STATE_CODE = code;
	}
	
	//수강생 엑셀 업로드 콜백함수
	function handleCallbackUploadResult(num){
	    alert(num+"건이 등록되었습니다.");
	    fn_detailRefresh();
	}
	
	//추천순위 입력 이벤트
    function setRecommValue(userid){
        var array = $('#targetConfirmGrid').data('kendoGrid').dataSource.data();            
        
        var res = $.grep(array, function (e) {
            return e.USERID == userid;
        });
        
        res[0].RECOMM_RANKING = $("#recomm_"+userid).val();
    }
	
	//미선정사유 입력 이벤트
	function setReasonValue(userid){
	    var array = $('#targetConfirmGrid').data('kendoGrid').dataSource.data();            
	    
	    var res = $.grep(array, function (e) {
	        return e.USERID == userid;
	    });
	    
	    res[0].FAIL_REASON = $("#reason_"+userid).val();
	}
	
	//대상자선정 라디오버튼 이벤트 처리
	function setASCValue(code, userid){
		var array = $('#targetConfirmGrid').data('kendoGrid').dataSource.data();            
		
		var res = $.grep(array, function (e) {
		    return e.USERID == userid;
		});
		
		res[0].ATTEND_STATE_CODE = code;
	}
	//차시변경함수
	function fn_SelectOpen(openNum){
	    var isDel = confirm("해당차시로 변경 하시겠습니까?");
	    if (isDel) {
		    //로딩바 생성.
		    loadingOpen();
		    
		    $.ajax({
		        type : 'POST',
		        dataType : 'json',
		        url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/change-user-chasu.do?output=json",
		        data : {
		            O_OPEN_NUM : $("#dtl-openNum").val(), N_OPEN_NUM : openNum, USERID : $("#dtl-userid").val()
		        },
		        complete : function(response) {
		        	//로딩바 제거.
	                loadingClose();
	                
	                var obj = eval("(" + response.responseText + ")");
	                if(obj.error){
	                    alert("ERROR=>"+obj.error.message);
	                }else{
	                    if (obj.saveCount > 0) {

	                        $("#chasuChange-window").data("kendoWindow").close();
	                        
	                        //상세화면 refresh..
	                        fn_detailRefresh();
	                        
	                        alert("변경되었습니다.");
	                    } else {
	                        alert("변경을 실패 하였습니다.");
	                    }
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
		        }
		    });
	    }
	}
	//차수변경 팝업 호출
	function chasuChange(userid){
		$("#dtl-userid").val(userid);
		
	    var ttListGrid = $("#ttListGrid").data("kendoGrid");
        var ttListGriddata = ttListGrid.dataSource.data();
        var res = $.grep(ttListGriddata, function (e) {
            return (e.USERID == userid);
        });
        var selectedCell = res[0];
        
        if(selectedCell.ATTEND_STATE_CODE != "1"){
            alert("수강상태가 신청 상태인 경우에만 변경할 수 있습니다.");
        	return false;
        }
        
		if( !$("#chasuChange-window").data("kendoWindow") ){
	        $("#chasuChange-window").kendoWindow({
	            width:"700px",
	            height:"380px",
	            resizable : true,
	            title : "차수변경",
	            modal: true,
	            visible: false
	        });
	    }
	    
		$("#chasuChangeGrid").kendoGrid({
		    dataSource : {
		        type : "json",
		        transport : {
		            read : {
		                url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/same-subject-chasu-list.do?output=json",
		                type : "POST"
		            },
		            parameterMap : function(options, operation) { 
		                return { SUBJECT_NUM : $("#dtl-subjectNum").val(), YYYY: $("#yyyy").val(), CHASU :  $("#chasu").val() } ;
		            }
		        },
		        schema : {
		            total : "totalItemCount",
		            data : "items",
		            model : {
		                id : "SUBJECT_NUM",
		                fields : {
		                    SUBJECT_NUM : {type : "number"},
		                    OPEN_NUM : {type : "number"},
		                    SUBJECT_NAME : {type : "string"},
		                    CHASU : {type : "number"},
		                    EDU_PERIOD : {type : "string"},
		                    YYYY : {type : "number"}
		                }
		            }
		        },
		        pageSize : 9999,
		        serverPaging : false,
		        serverFiltering : false,
		        serverSorting : false
		    },
		    columns : [
	                 { 
	                	 title: "선택", 
	                	 width: "80px",
	                     headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                     attributes:{"class":"table-cell", style:"text-align:center"} ,
	                     template : function(data){
	                         return "<input type='button' class='k-button k-i-close' style='width:45px; ' value='선택' onclick='fn_SelectOpen("+data.OPEN_NUM+");'/>";
	                     }
					},{
		                 field : "SUBJECT_NAME",
		                 title : "과정명",
		                 width : "200px",
		                 headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
		                 attributes : { "class" : "table-cell", style : "text-align:left" }
					},{
		                field : "YYYY",
		                title : "년도",
		                width : "80px",
		                headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
		                attributes : { "class" : "table-cell", style : "text-align:center" },
					},{
		                field : "CHASU",
		                title : "차수",
		                width : "80px",
		                headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
		                attributes : { "class" : "table-cell", style : "text-align:center" }
					},{
		                field : "EDU_PERIOD",
		                title : "교육기간",
		                width : "180px",
		                headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
		                attributes : { "class" : "table-cell", style : "text-align:center" }
		            }
		    ],
		    filterable : false,
		    sortable : false,
		    pageable : false,
		    resizable : false,
		    reorderable : false,
		    selectable: false,
		    pageable : false,
		    height: 350
		}).data("kendoGrid");
	
		
	
	    $("#chasuChange-window").data("kendoWindow").center();
	    $("#chasuChange-window").data("kendoWindow").open();
	}
	
	function deleteUser(userid){
		var isDel = confirm("사용자를 삭제 하시겠습니까?");
	    if (isDel) {
	        //로딩바 생성.
	        loadingOpen();
	        
	        $.ajax({
	            type : 'POST',
	            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-open-run-user_del.do?output=json",
	            data : {
	            	SUBJECT_NUM : $("#dtl-subjectNum").val(), OPEN_NUM : $("#dtl-openNum").val(), USERID : userid
	            },
	            complete : function(response) {
	                var obj = eval("(" + response.responseText + ")");
	                //로딩바 제거.
	                loadingClose();
	                if(obj.error){
	                	alert("ERROR=>"+obj.error.message);
	                }else{
	                	if (obj.saveCount > 0) {
	                        fn_detailRefresh();
	                        alert("삭제되었습니다.");
	                    } else {
	                        alert("삭제를 실패 하였습니다.");
	                    }
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
	}
	
    //인정시간 재계산
    function fn_recogTimeChange(user_id){
    	$("#dtl-userid").val(user_id);
        
            //상시학습종류별 연간인정시간 체크
            $.ajax({
                type : 'POST',
                url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/emalw/year_recog_limit_check.do?output=json",
                data : {
                    asOpenSeq : $("#dtl-openNum").val(),
                    tUserid : user_id,
                    eduDiv : "1",
                    yyyy : $("#yyyy").val(),
                    recogTimeH : $("#dtl-recogTimeH").val(),
                    recogTimeM : $("#dtl-recogTimeM").val(),
                    alwStdCd : $("#dtl-alwStdCd").val()
                },
                complete : function( response ){
                    var obj = eval("(" + response.responseText + ")");
                    if(obj.error){
                         alert("ERROR=>"+obj.error.message);
                    } else {
                         if(obj.statement!="") {
                             var msg = obj.statement.replace(/<br>/g, "\n");
                             if(!confirm("선택된 사용자는 상시학습종류의 연간 최대 인정시간 제한으로 과정의 인정시간을 모두 인정받지 못합니다.\n적용 하시겠습니까?")) return;
                         } else {
                             //제한이 없는 경우 바로 재계산해줌...
                        	 if(!confirm("다시 계산 하시겠습니까?")) return;
                         }
                         
                         // 재계산 호출..
                         $.ajax({
                             type : 'POST',
                             url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/change-user-recogTime.do?output=json",
                             data : {
                            	 OPEN_NUM : $("#dtl-openNum").val(),
                                 tUserid : user_id,
                                 YYYY : $("#yyyy").val(),
                                 RECOG_TIME_H : $("#dtl-recogTimeH").val(),
                                 RECOG_TIME_M : $("#dtl-recogTimeM").val(),
                                 ALW_STD_CD : $("#dtl-alwStdCd").val()
                             },
                             complete : function(response) {
                                 var obj = eval("(" + response.responseText + ")");
                                 if(obj.error){
                                     alert("ERROR=>"+obj.error.message);
                                 }else{
                                	 if (obj.saveCount > 0) {
	                                   alert("적용되었습니다.");
	                                   
	                                   $("#cmpltGrid").data("kendoGrid").dataSource.read();
	                                 } else {
	                                     alert("실패 하였습니다.");
	                                 }
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
                             },
                             dataType : "json"
                         });
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
    
	//직급변경 팝업 호출
	function fn_gradeChange(user_id, timeGradeNum){
	    $("#dtl-userid").val(user_id);
	    

        var gradeChangeData = $("#gradeChange").data("kendoDropDownList");
        
		if(!$("#gradeChange-window").data("kendoWindow") ){
	        $("#gradeChange-window").kendoWindow({
	            width:"300px",
	            height:"50px",
	            resizable : true,
	            title : "인정직급변경",
	            modal: true,
	            visible: false
	        });
	        
	      //변경 버튼
	        $("#gradeChangeBtn").click(function(){
	            if(gradeChangeData.value()=="null"){alert("변경할 인정직급을 선택하세요.");return false;}
                
	            var isDel = confirm("인정직급을 변경 하시겠습니까?");
	            
	            if (isDel) {
	                $.ajax({
	                    type : 'POST',
	                    url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/change-user-grade.do?output=json",
	                    data : {
	                        TIME_GRADE_NUM : gradeChangeData.value(), SUBJECT_NUM : $("#dtl-subjectNum").val(), OPEN_NUM : $("#dtl-openNum").val(), USERID : $("#dtl-userid").val()
	                    },
	                    complete : function(response) {
	                        var obj = eval("(" + response.responseText + ")");
	                        if (obj.saveCount > 0) {
	                            alert("변경되었습니다.");
	                            
	                            $("#gradeChange-window").data("kendoWindow").close();
	                            $("#cmpltGrid").data("kendoGrid").dataSource.read();
	                            $("#gradeChange").select(0);
	                            
	                          } else {
	                              alert("변경을 실패 하였습니다.");
	                          }
	                        if(obj.error){
	                            alert("ERROR=>"+obj.error.message);
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
	                    },
	                    dataType : "json"
	                });
	            }
	        });
        }
		
		gradeChangeData.value(timeGradeNum);
		
        $("#gradeChange-window").data("kendoWindow").center();
	    $("#gradeChange-window").data("kendoWindow").open();
	}
    
    
	function fn_attachments(userId){
		$("#dtl-userid").val(userId);
		
		if( !$("#attachments-window").data("kendoWindow") ){
			$("#attachments-window").kendoWindow({
                width:"550px",
                height:"300px",
                resizable : true,
                title : "증빙자료 다운로드",
                modal: true,
                visible: false
            });
			
			$("#attachmentsGrid").kendoGrid({
	            dataSource: {
	                type: 'json',
	                transport: {
	                    read: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/download_attachments.do?output=json', type: 'POST' },      
	                    destroy: { url:'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/delete-my-attachment.do?output=json', type:'POST' },                                
	                    parameterMap: function (options, operation){
	                            return { objectType: 7, userId: $("#dtl-userid").val(), openNum: $("#dtl-openNum").val() };
	                    }
	                },
	                schema : {
	                    data : "items",
	                    model : {
	                        id : "SUBJECT_NUM",
	                        fields : {
	                            FILE_NAME : {type : "string"},
	                            FILE_SIZE : {type : "string"}
	                        }
	                    }
	                }
	            },
	            height: 280,
	            pageable: false,
	            selectable: false,
	            columns: [
	                {
	                    field: "FILE_NAME",
	                    title: "파일명",
	                    width: "320px",
	                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    attributes:{"class":"table-cell", style:"text-align:left"},
	                    template: '#= FILE_NAME #'
	               },{
	                   field: "FILE_SIZE",
	                   title: "크기(byte)",
	                   format: "{0:##,###}",
	                   width: "80px",
	                   headerAttributes:{"class":"table-header-cell", style:"text-align:right"},
	                   attributes:{"class":"table-cell", style:"text-align:right"} 
	               },{
	                   width: "80px",
	                   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                   attributes:{"class":"table-cell", style:"text-align:center"} ,
	                   template: function(dataItem){
	                        return '<a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/download-my-attachment.do?attachmentId='+dataItem.ATTACHMENT_ID+'" class="k-button">다운로드</a>';
	                   }
	               }]
	            });
		}else{
			$("#attachmentsGrid").data("kendoGrid").dataSource.read();
		}	
		
		$("#attachments-window").data("kendoWindow").center();
        $("#attachments-window").data("kendoWindow").open();
         		
	}
	
	// 상세보기.
	function fn_detailView(subjectNum, openNum){
	    var grid = $("#grid").data("kendoGrid");
	    var data = grid.dataSource.data();
	    var res = $.grep(data, function (e) {
	        return (e.SUBJECT_NUM == subjectNum && e.OPEN_NUM == openNum);
	    });
	    var selectedCell = res[0];
	    
		$("#dtl-subjectNum").val(selectedCell.SUBJECT_NUM);
		$("#dtl-openNum").val(selectedCell.OPEN_NUM);
        $("#dtl-recogTimeH").val(selectedCell.RECOG_TIME_H);
		$("#dtl-recogTimeM").val(selectedCell.RECOG_TIME_M);
		$("#dtl-alwStdCd").val(selectedCell.ALW_STD_CD);
		$("#cmplt_"+data.USERID).val(selectedCell.ATTEND_STATE_CODE);

		// 상세영역 활성화
		$("#splitter").data("kendoSplitter").expand("#detail_pane");

	    isChasuDup = true;
	    
        //로딩바 생성.
        loadingOpen();
        
	    $.ajax({
            type : 'POST',
            dataType : 'json',
            url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/sbjct-open-info.do?output=json",
            data : {
                subjectNum : selectedCell.SUBJECT_NUM, openNum: selectedCell.OPEN_NUM
            },
            complete : function(response) {
                //로딩바 제거.
                loadingClose();

                var obj = eval("(" + response.responseText + ")");
                if(obj.error){
                	alert("ERROR=>"+obj.error.message);
                }else{
	                if (obj.items != null) {
	                    var selectRow = new Object();
	                    $.each(obj.items, function(idx, item) {
	                        $.each(item,function(key,val){
	                            selectRow[key] = val;
	                        });
	                    });
	                    detailSelected = selectRow;
	                    //상세데이터 바인딩..
	                    kendo.bind($(".tabular"), selectRow);
	                    
	                    //대상확정 - 추천순위승인요청에 대한 처리
	                    $("#dtl-reqNum").val(selectRow.REQ_NUM);
	                    $("#dtl-reqStsCd").val(selectRow.REQ_STS_CD);
                        
	                    if(selectRow.REQ_NUM && selectRow.REQ_NUM > 0){
	                    	//승인요청을 함..
	                    	if(selectRow.REQ_STS_CD == "0"){
	                    		$("#recommSts").hide();
                                $("#recommSaveBtn").data("kendoButton").enable(true);
	                    	}else if(selectRow.REQ_STS_CD == "1"){
	                    		$("#recommSts").show();
	                    		$("#recommSts").text("승인대기");
	                    		$("#recommSaveBtn").data("kendoButton").enable(false);
	                    	}else if(selectRow.REQ_STS_CD == "2"){
	                    		$("#recommSts").show();
                                $("#recommSts").text("승인");
                                $("#recommSaveBtn").data("kendoButton").enable(false);
	                    	}else if(selectRow.REQ_STS_CD == "3"){
                                $("#recommSts").show();
                                $("#recommSts").text("미승인");
                                $("#recommSaveBtn").data("kendoButton").enable(true);
                            }else{
                            	$("#recommSts").hide();
                                $("#recommSaveBtn").data("kendoButton").enable(true);
                            }
	                    }else{
	                    	$("#recommSaveBtn").data("kendoButton").enable(true);
                            $("#recommSts").hide();
	                    	
	                    }
	                    
	                }
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
        //상세화면 refresh..
        fn_detailRefresh();
		// template에서 호출된 함수에 대한 이벤트 종료 처리.
		if (event.preventDefault) {
			event.preventDefault();
		} else {
			event.returnValue = false;
		}
	}

	//수료관리 성적 입력 처리 함수
    function setCmpltValue(div, userid, obj){
        var array = $('#cmpltGrid').data('kendoGrid').dataSource.data();
        var res = $.grep(array, function (e) {
            return e.USERID == userid;
        });
        
        var ttSco = 0;
        
        if(div == "attend"){ //근태
        	if(chkNoNull(obj) && isNumber(obj)){
        		if(Number($("#attend_"+userid).val())>100){
        			alert("100점 이상의 점수는 입력할 수 없습니다.");
        			$("#attend_"+userid).val("");
        			return false;
        		}
                res[0].ATTEND_SCO = $("#attend_"+userid).val();
            }else{
            	res[0].ATTEND_SCO = null;
            }
        	//총점수 재계산..
            ttSco = Number(res[0].ATTEND_SCO)+Number(res[0].PRAC_SCO)+Number(res[0].ANNO_SCO)+Number(res[0].CHALL_SCO)+Number(res[0].ETC_SCO)+Number(res[0].DISCU_SCO);

            if(ttSco>100){
                alert("총점수는 100점을 넘을 수 없습니다.");
                $("#attend_"+userid).val("");
                res[0].ATTEND_SCO = null;
                $("#tt_"+userid).val("");
                res[0].TT_GET_SCO = null;
            }else{
                res[0].TT_GET_SCO = ttSco;
                $("#tt_"+userid).val(ttSco);
            }
        }else if(div == "prac"){ //실기평가
        	if(chkNoNull(obj) && isNumber(obj)){
                if(Number($("#prac_"+userid).val())>100){
                    alert("100점 이상의 점수는 입력할 수 없습니다.");
                    $("#prac_"+userid).val("");
                    return false;
                }
                res[0].PRAC_SCO = $("#prac_"+userid).val();
            }else{
                res[0].PRAC_SCO = null;
            }
        	//총점수 재계산..
            ttSco = Number(res[0].ATTEND_SCO)+Number(res[0].PRAC_SCO)+Number(res[0].ANNO_SCO)+Number(res[0].CHALL_SCO)+Number(res[0].ETC_SCO)+Number(res[0].DISCU_SCO);

            if(ttSco>100){
                alert("총점수는 100점을 넘을 수 없습니다.");
                $("#prac_"+userid).val("");
                res[0].PRAC_SCO = null;
                $("#tt_"+userid).val("");
                res[0].TT_GET_SCO = null;
            }else{
                res[0].TT_GET_SCO = ttSco;
                $("#tt_"+userid).val(ttSco);
            }
        }else if(div == "anno"){ //발표
        	if(chkNoNull(obj) && isNumber(obj)){
                if(Number($("#anno_"+userid).val())>100){
                    alert("100점 이상의 점수는 입력할 수 없습니다.");
                    $("#anno_"+userid).val("");
                    return false;
                }
                res[0].ANNO_SCO = $("#anno_"+userid).val();
            }else{
                res[0].ANNO_SCO = null;
            }
        	//총점수 재계산..
            ttSco = Number(res[0].ATTEND_SCO)+Number(res[0].PRAC_SCO)+Number(res[0].ANNO_SCO)+Number(res[0].CHALL_SCO)+Number(res[0].ETC_SCO)+Number(res[0].DISCU_SCO);

            if(ttSco>100){
                alert("총점수는 100점을 넘을 수 없습니다.");
                $("#anno_"+userid).val("");
                res[0].ANNO_SCO = null;
                $("#tt_"+userid).val("");
                res[0].TT_GET_SCO = null;
            }else{
                res[0].TT_GET_SCO = ttSco;
                $("#tt_"+userid).val(ttSco);
            }
        }else if(div == "chall"){ //과제
        	if(chkNoNull(obj) && isNumber(obj)){
                if(Number($("#chall_"+userid).val())>100){
                    alert("100점 이상의 점수는 입력할 수 없습니다.");
                    $("#chall_"+userid).val("");
                    return false;
                }
                res[0].CHALL_SCO = $("#chall_"+userid).val();
            }else{
                res[0].CHALL_SCO = null;
            }
        	//총점수 재계산..
            ttSco = Number(res[0].ATTEND_SCO)+Number(res[0].PRAC_SCO)+Number(res[0].ANNO_SCO)+Number(res[0].CHALL_SCO)+Number(res[0].ETC_SCO)+Number(res[0].DISCU_SCO);

            if(ttSco>100){
                alert("총점수는 100점을 넘을 수 없습니다.");
                $("#chall_"+userid).val("");
                res[0].CHALL_SCO = null;
                $("#tt_"+userid).val("");
                res[0].TT_GET_SCO = null;
            }else{
                res[0].TT_GET_SCO = ttSco;
                $("#tt_"+userid).val(ttSco);
            }
        }else if(div == "etc"){ //기타
        	if(chkNoNull(obj) && isNumber(obj)){
                if(Number($("#etc_"+userid).val())>100){
                    alert("100점 이상의 점수는 입력할 수 없습니다.");
                    $("#etc_"+userid).val("");
                    return false;
                }
                res[0].ETC_SCO = $("#etc_"+userid).val();
            }else{
                res[0].ETC_SCO = null;
            }
        	//총점수 재계산..
            ttSco = Number(res[0].ATTEND_SCO)+Number(res[0].PRAC_SCO)+Number(res[0].ANNO_SCO)+Number(res[0].CHALL_SCO)+Number(res[0].ETC_SCO)+Number(res[0].DISCU_SCO);

            if(ttSco>100){
                alert("총점수는 100점을 넘을 수 없습니다.");
                $("#etc_"+userid).val("");
                res[0].ETC_SCO = null;
                $("#tt_"+userid).val("");
                res[0].TT_GET_SCO = null;
            }else{
                res[0].TT_GET_SCO = ttSco;
                $("#tt_"+userid).val(ttSco);
            }
        }else if(div == "discu"){ //분임토의
        	if(chkNoNull(obj) && isNumber(obj)){
                if(Number($("#discu_"+userid).val())>100){
                    alert("100점 이상의 점수는 입력할 수 없습니다.");
                    $("#discu_"+userid).val("");
                    return false;
                }
                res[0].DISCU_SCO = $("#discu_"+userid).val();
            }else{
                res[0].DISCU_SCO = null;
            }
        	//총점수 재계산..
            ttSco = Number(res[0].ATTEND_SCO)+Number(res[0].PRAC_SCO)+Number(res[0].ANNO_SCO)+Number(res[0].CHALL_SCO)+Number(res[0].ETC_SCO)+Number(res[0].DISCU_SCO);

            if(ttSco>100){
                alert("총점수는 100점을 넘을 수 없습니다.");
                $("#discu_"+userid).val("");
                res[0].DISCU_SCO = null;
                $("#tt_"+userid).val("");
                res[0].TT_GET_SCO = null;
            }else{
                res[0].TT_GET_SCO = ttSco;
                $("#tt_"+userid).val(ttSco);
            }
        }else if(div == "tt"){ //총점수
        	if(chkNoNull(obj) && isNumber(obj)){
                if(Number($("#tt_"+userid).val())>100){
                    alert("100점 이상의 점수는 입력할 수 없습니다.");
                    $("#tt_"+userid).val("");
                    return false;
                }
                res[0].TT_GET_SCO = $("#tt_"+userid).val();
            }else{
                res[0].TT_GET_SCO = null;
            }

        }
        
        
        
    }
    
	//상세영역의 그리드 다시 읽기.
	function fn_detailRefresh(){
        $("#ttGrid").data("kendoGrid").dataSource.read();
        $("#ttListGrid").data("kendoGrid").dataSource.read();
        $("#targetConfirmGrid").data("kendoGrid").dataSource.read();
        $("#targetGrid").data("kendoGrid").dataSource.read();
        $("#cmpltGrid").data("kendoGrid").dataSource.read();
    }
	
	//추천순위 다운로드 
	function recommDownLoad(){
		frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/edu_target_recomm_list_excel.do?subjectNum=" + $("#dtl-subjectNum").val() + "&openNum=" + $("#dtl-openNum").val() ;
        frm.submit();
	}
	//대상확정 탭역량진단결과 엑셀다운로드
	function cmptResultDownLoad(){
		frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/edu_target_cmpt_result_list_excel.do?subjectNum=" + $("#dtl-subjectNum").val() + "&openNum=" + $("#dtl-openNum").val() ;
        frm.submit();
	}
	
	//수강생 엑셀 다운로드
	function excelDownLoad(){
        frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/edu_target_list_excel.do?subjectNum=" + $("#dtl-subjectNum").val() + "&openNum=" + $("#dtl-openNum").val() ;
        frm.submit();
    }
	
	//수료관리 엑셀다운로드
    function cmpltExcelDownLoad(){
        frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/edu_cmplt_list_excel.do?subjectNum=" + $("#dtl-subjectNum").val() + "&openNum=" + $("#dtl-openNum").val() ;
        frm.submit();
    }
    
	
</script>

</head>
<body>
<form name="frm" id="frm" method="post" >
	<input type="hidden" name="dtl-userid" id="dtl-userid"/>
	<input type="hidden" name="dtl-subjectNum" id="dtl-subjectNum" />
	<input type="hidden" name="dtl-openNum" id="dtl-openNum" />
    <input type="hidden" name="dtl-alwStdCd" id="dtl-alwStdCd" />
    <input type="hidden" name="dtl-recogTimeH" id="dtl-recogTimeH" />
    <input type="hidden" name="dtl-recogTimeM" id="dtl-recogTimeM" />
    <input type="hidden" name="objectId" id="objectId"/>
    <input type="hidden" name="dtl-reqNum" id="dtl-reqNum"/>
    <input type="hidden" name="dtl-reqStsCd" id="dtl-reqStsCd"/>
</form>

    <!-- START MAIN CONTENT  -->
        <div id="content">
            <div class="cont_body">
                <div class="title mt30">운영관리</div>
                <div class="table_tin01">
	                <div class="px">※ 수강생들을 관리할 수 있으며, 과정 운영의 전반적인 업무를 수행할 수 있습니다</div>
                    <ul>
	                    <li style="position: relative;">
	                        <select id="searchDiv" style="width:100px;" >
	                           <option value="EDU_STIME" >교육시작일</option>
	                           <option value="EDU_ETIME" >교육종료일</option>
	                           <option value="APPLY_STIME" >신청시작일</option>
	                           <option value="APPLY_ETIME" >신청종료일</option>
	                        </select> : 
	                        <input type="text" id="searchSdate" style="width:140px; "  /> ~
                            <input type="text" id="searchEdate" style="width:140px; "  />
                            <button id="searchBtn" class="k-button" style="width: 60px;">검색</button>
                            <button class="k-button" id="detailCloseBtn" style="position: absolute; right: 50px;"  > 상세닫기 </button>
                            
	                    </li>
	                </ul>
	            </div>
                <div class="table_zone">
                    <div class="table_list" style="min-height: 900px;">
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
                <div id="tabstrip">
                    <ul>
                        <li class="k-state-active">수강정보</li>
                        <li>대상확정</li>
                        <li>교육확정자</li>
                        <li>수료관리</li>
                        <li>과정정보</li>
                        <li>차수정보</li>
                    </ul>

					<!-- 수강정보 -->
                    <div style="overflow-y:auto;">
                        <span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 현황
                        <div id="ttGrid" ></div>
                        <div id="ttListGrid" style="top: 10px;" ></div>
                    </div>

					<!-- 대상확정 -->
                    <div style="overflow-y:auto;">
                        <div id="targetConfirmGrid" ></div>
                        <div style="text-align:right;margin-top:13px;">
                            <button id="recommSts" class="k-button">추천순위승인현황</button>
                            <button id="recommSaveBtn" class="k-button">추천순위승인요청</button>
                            <a class="k-button"  href="javascript: recommDownLoad()" >추천순위다운로드</a>&nbsp;
                            <a class="k-button"  href="javascript: cmptResultDownLoad()" >역량진단결과</a>&nbsp;
                            <button id="allSelectionBtn" class="k-button">일괄선정</button>&nbsp;
                            <button id="selectionSaveBtn" class="k-button">저장</button>
                        </div>
                    </div>

					<!-- 교육확정자 -->
                    <div style="overflow-y:auto;">
                        <div id="targetGrid" ></div>
                        <div style="text-align:right;margin-top:13px;">
                            <a class="k-button"  href="javascript:excelDownLoad()" >수강생엑셀다운로드</a>&nbsp;
                            <button id="userExcelUploadBtn" class="k-button">수강생엑셀업로드</button>
                        </div>
                    </div>

					<!-- 수료관리 -->
                    <div style="overflow-y:auto;">
                        <div id="cmpltGrid" ></div>
                        <div style="text-align:right;margin-top:13px;">
                            <a class="k-button"  href="javascript:cmpltExcelDownLoad()" >엑셀다운로드</a>&nbsp;
                            <button id="allCmpltBtn" class="k-button">일괄수료선택</button>
                            <button id="cmpltExecBtn" class="k-button">저장</button>
                        </div>
                    </div>
                    
                    

	<!-- 과정정보 -->
	<div style="overflow-y:auto;">
		<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td class="subject" style="width:100px;"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 과 정 명 </label></td>
                <td class="subject">
                    <input class="k-textbox input_disColor" id="SUBJECT_NAME" data-bind="value:SUBJECT_NAME"  style="width:80%; " readOnly/>
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 학습유형 </label></td>
                <td class="subject">
                        <input class="k-textbox input_disColor" id="TRAINING_CODE" data-bind="value:TRAINING_STRING"  style="width:200px;" readOnly/>
                </td>
            </tr>
			<tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 상시학습종류</label></td>
                <td class="subject">
                    <input class="k-textbox input_disColor" data-bind="value:ALW_STD_NM1" style="width:100%; " readOnly /><br>
                    <input class="k-textbox input_disColor" data-bind="value:ALW_STD_NM2" style="width:100%; " readOnly /><br>
                    <input class="k-textbox input_disColor" data-bind="value:ALW_STD_NM" style="width:100%; " readOnly />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육시간 </label></td>
                <td class="subject">
                    <input class="k-textbox input_disColor" id="EDU_HOUR_H" data-bind="value:EDU_HOUR_H" style="width:40px; text-align: center; " readOnly />시간
                    <input class="k-textbox input_disColor" id="EDU_HOUR_M" data-bind="value:EDU_HOUR_M" style="width:40px; text-align: center; " readOnly />분
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 인정시간 </label></td>
                <td class="subject">
                    <input class="k-textbox input_disColor" id="RECOG_TIME_H" data-bind="value:RECOG_TIME_H" style="width:40px; text-align: center; " readOnly />시간
                    <input class="k-textbox input_disColor" id="RECOG_TIME_M" data-bind="value:RECOG_TIME_M" style="width:40px; text-align: center; " readOnly />분
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 목적</label></td>
                <td class="subject"><textarea class="k-textbox input_disColor" id="EDU_OBJECT" data-bind="value:EDU_OBJECT" rows="5"  style="width:100%;" readOnly></textarea></td>
            </tr>           
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 대상</label></td>
                <td class="subject"><textarea class="k-textbox input_disColor" id="EDU_TARGET" data-bind="value:EDU_TARGET" rows="5"  style="width:100%;" readOnly></textarea></td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 내용</label></td>
                <td class="subject"><textarea class="k-textbox input_disColor" id="COURSE_CONTENTS" data-bind="value:COURSE_CONTENTS" rows="5"  style="width:100%;" readOnly></textarea></td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기관 </label></td>
                <td class="subject"><input class="k-textbox input_disColor" id="INSTITUTE_NAME" data-bind="value:INSTITUTE_NAME" style="width:200px;" readOnly /></td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기관구분</label></td>
                <td class="subject">
                    <input class="k-textbox input_disColor" id="eduinsDivCd" data-bind="value:EDUINS_DIV_NM" style="width:200px;" readOnly />
                </td>
            </tr>
            <!--<tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 지정학습종류 </label></td>
                <td class="subject">
                    <input class="k-textbox input_disColor" data-bind="value:DEPT_DESIGNATION_STRING" style="width:200px; " readOnly />
                </td>
            </tr>-->
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 부처지정학습 </label></td>
                <td class="subject">
                    <input class="k-textbox input_disColor" data-bind="value:DEPT_DESIGNATION_NM" style="width:200px; " readOnly />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 기관성과평가필수교육과정</label></td>
                <td class="subject">
                    <input class="k-textbox input_disColor" data-bind="value:PERF_ASSE_SBJ_NM" style="width:200px; " readOnly />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육시간구분</label></td>
                <td class="subject">
                    <input class="k-textbox input_disColor" id="officeTimeCd" data-bind="value:OFFICETIME_NM" style="width:200px;" readOnly />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 평가 및 수료기준</label></td>
                <td class="subject"><textarea class="k-textbox input_disColor" id="EVL_CMPL" data-bind="value:EVL_CMPL" rows="5"  style="width:100%;" readOnly></textarea></td>
            </tr>
        </table>
	</div>


	<!-- 차수정보 -->
	<div style="overflow-y:auto;">
        <table class="tabular" id="tabular1" width="100%" cellspacing="0" cellpadding="0">
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 개설년도 </label></td>
                <td class="subject">
                    <input id="yyyy" class="k-textbox input_disColor" data-bind="value:YYYY" style="width:60px; text-align:center;" readOnly  />년
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 차수 </label></td>
                <td class="subject">
                    <input id="chasu" class="k-textbox input_disColor" data-bind="value:CHASU" style="width:60px; text-align:center;" readOnly />차
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육기간 </label></td>
                <td class="subject">
                    <input id="EDU_STIME" class="k-textbox input_disColor" data-bind="value:EDU_STIME" style="width:120px; text-align:center;" readOnly /> ~
                    <input id="EDU_ETIME" class="k-textbox input_disColor" data-bind="value:EDU_ETIME" style="width:120px; text-align:center;" readOnly />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 신청기간 </label></td>
                <td class="subject">
                    <input id="APPLY_STIME" class="k-textbox input_disColor" data-bind="value:APPLY_STIME" style="width:120px; text-align:center;" readOnly /> ~
                    <input id="APPLY_ETIME" class="k-textbox input_disColor" data-bind="value:APPLY_ETIME" style="width:120px; text-align:center;" readOnly />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 취소마감일 </label></td>
                <td class="subject">
                    <input id="CANCEL_ETIME" class="k-textbox input_disColor" data-bind="value:CANCEL_ETIME" style="width:120px;text-align:center;" readOnly />
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 모집정원 </label></td>
                <td class="subject">
                    <input id="APPLICANT" class="k-textbox input_disColor" data-bind="value:APPLICANT" style="width:40px;text-align:center;" readOnly />명
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 교육일수</label></td>
                <td class="subject">
                    <input id="EDU_DAYS" class="k-textbox input_disColor" data-bind="value:EDU_DAYS" style="width:40px;text-align:center;" readOnly />일
                </td>
            </tr>
            <tr>
                <td class="subject"><label class="right inline required"><span style="background:url(<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 메모</label></td>
                <td class="subject">
                    <textarea class="k-textbox" id="EDU_MEMO" data-bind="value:EDU_MEMO" rows="5"  style="width:100%;" ></textarea><br><br>
                    <button id="memoChangeBtn" class="k-button" style="width: 60px;">저장</button>
                </td>
            </tr>
        </table>
	</div>
</div>

        	
        
</script>

    <!-- 수강생엑셀업로드 팝업 -->
    <div id="targetUpload-window" style="display:none; width:360px;">
        <form id="excelForm" name="excelForm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-target-user-excel.do?output=json" enctype="multipart/form-data" >
        ※ 엑셀 작성 방법 = A열에 추가될 교직원번호를 작성.<br>
        ※ 수강정보 탭에 없는 사용자만 등록됩니다.<br>
        ※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
           <div>
               <input name="upload_file" id="upload_file" type="file" />
               <br/>
               <div style="text-align: right;">
                    <a href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/includes/templateDownload/target_user_upload_template.xls" class="k-button" >수강생템플릿다운로드</a>
                    <input type="submit" value="실행" class="k-button" id="uploadBtn"/>
               </div>
           </div>
       </form>
   </div>
 
    <!-- 차수 변경 팝업 -->
    <div id="chasuChange-window" style="display:none; overflow-y: hidden;">
        <div id="chasuChangeGrid" ></div>
    </div>

    <!-- 직급 변경 팝업 -->
    <div id="gradeChange-window" style="display:none; overflow-y: hidden;">
        <div id="gradeChangeGrid" >
        <select id="gradeChange" style="width:200px;"></select>&nbsp;<button id="gradeChangeBtn" class="k-button" style="width: 60px;">확인</button>
        </div>
    </div>
    
    <!-- 증빙자료 다운로드 팝업 -->
    <div id="attachments-window" style="display:none; overflow-y: hidden;">
        <div id="attachmentsGrid" ></div>
    </div>
    
    <!-- 교육생 엑셀업로드 template -->
    <script type="text/x-kendo-tmpl" id="targetUpload-template">
        <input name="upload_file" id="upload_file" type="file"/>
    </script>
  

<%@ include file="/includes/jsp/user/common/certificatePopup.jsp"  %>  
<%@ include file="/includes/jsp/user/common/apprReqPopup.jsp"  %>      
<%@ include file="/includes/jsp/user/common/apprStsPopup.jsp"  %>
</body>

</html>