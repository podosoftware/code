<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
kr.podosoft.ws.service.cdp.action.CdpServiceAction action = (kr.podosoft.ws.service.cdp.action.CdpServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage" >
<head>
<title></title>

<script type="text/javascript"> 

var dataSource_eduDetail;
var dataSource_myCdp;

yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.bootstrap.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/front-ui_mpva.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
    ],
    complete: function() {
        kendo.culture("ko-KR"); 

        //로딩바 선언..
        loadingDefine();
        
        $('#details').show().html(kendo.template($('#template').html()));      
        
        /* 나의 필수 계획시간 접기 펼치기 START!  */
        // faq 아코디언 
        $("dl.accordion dd").css("display","none");
        $("dl.accordion dt").append('<a href="#" class="icon">닫힘</a>');
        $("dl.accordion dt").click(function(e){
            if($("+dd",this).css("display")=="none"){                   
                $("dl.accordion dd").slideUp(300, "swing");
                $("+dd",this).slideDown(300, "swing");                  
                $("dl.accordion dt").removeClass("off");
                $("dl.accordion .icon").html("닫힘");
                $(this).addClass("off");
                $(this).find("dl.accordion .icon").html("열림");
            }else{
                $("+dd",this).slideUp(300, "swing");
                $(this).removeClass("off");
                $(this).find("dl.accordion .icon").html("닫힘");
            }        
            e.preventDefault();
        });
        // tbl 아코디언 
        $(".accordion_tbl .reply").css("display","none");
        $(".accor_list").find('.ico_plus').append('<a href="#" class="icon">닫힘</a>');
        $(".accor_list .list_tit, .accor_list .icon").click(function(e){
            
            var $list = $(this).parents('tr').next();
            var $reply = $(this).parents('tr').next().find('.reply');
            var $tr = $(this).parents('tr');
            
            if($reply.css("display")=="none"){
                $('.reply').slideUp(300, "swing");
                $list.find('.reply').slideDown(300, "swing");
                $reply.css("display","block");  
                $(".list_tit").removeClass("on");
                $(".ico_plus").removeClass("off");
                $("td .icon").html("닫힘");
                $tr.find(".ico_plus").addClass("off");
                $tr.find(".list_tit").addClass("on");
                $tr.find(".icon").html("열림");
            }else{
                $reply.slideUp(300, "swing");
                $tr.find(".ico_plus").removeClass("off");
                $tr.find(".list_tit").removeClass("on");
                $tr.find(".icon").html("닫힘");
            }        
            e.preventDefault();
        });
        /* 나의 필수 계획시간 접기 펼치기 END!  */
        
        
        //경력개발계획 내용 데이터소스
        dataSource_myCdp = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_my_cdp_info.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return { runNum: $("#rn").val(), tu:$("#tu").val() };
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            YYYY_TARG : { type: "string" },
                            LONG_TARG : { type: "string" },
                            HOPE_JOB_CD1: { type: "String" },
                            HOPE_JOB_CD2: { type: "String" },
                            HOPE_DIVISIONID : { type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
        dataSource_myCdp.fetch(function(){
        	myCdpInfo();
        });
        
        dataSource_myCdp.bind("change", function(){
        	myCdpInfo();
        });
        
        //경력개발계획내용 적용.
        var myCdpInfo = function (){
        	if(dataSource_myCdp!=null && dataSource_myCdp.data().length>0){
                var yTarg = "";
                var lTarg = "";
                var hJob1 = "";
                var hJob2 = "";
                var hDivisionid = "";
                var hDvsNm = "";
                if(dataSource_myCdp.data()[0].YYYY_TARG){
                    yTarg = dataSource_myCdp.data()[0].YYYY_TARG;
                }
                if(dataSource_myCdp.data()[0].LONG_TARG){
                    lTarg = dataSource_myCdp.data()[0].LONG_TARG;
                }
                if(dataSource_myCdp.data()[0].HOPE_JOB_CD1){
                    hJob1 = dataSource_myCdp.data()[0].HOPE_JOB_CD1;
                }
                if(dataSource_myCdp.data()[0].HOPE_JOB_CD2){
                    hJob2 = dataSource_myCdp.data()[0].HOPE_JOB_CD2;
                }
                if(dataSource_myCdp.data()[0].HOPE_JOB_CD2){
                    hDivisionid = dataSource_myCdp.data()[0].HOPE_DIVISIONID;
                }
                if(dataSource_myCdp.data()[0].HOPE_DVS_NM){
                    hDvsNm = dataSource_myCdp.data()[0].HOPE_DVS_NM;
                }
                $("#yyyyTarg").val(yTarg);
                $("#longTarg").val(lTarg);
                hopeJob1.value(hJob1);
                hopeJob2.value(hJob2);
                $("#divisionid").val(hDivisionid);
                $("#dvsName").val(hDvsNm);
                
                //승인요청중 화면 제어..
                if(dataSource_myCdp.data()[0].REQ_STS_CD!=null && dataSource_myCdp.data()[0].REQ_STS_CD!=""){
                	
                	if(dataSource_myCdp.data()[0].REQ_STS_CD=="1" || dataSource_myCdp.data()[0].REQ_STS_CD=="2"){//승인대기, 승인 인경우..
                		$("#tmpReqAppr1, #tmpReqAppr2").hide(); //임시저장 버튼
                		$("#reqAppr1, #reqAppr2").hide(); //승인요청 버튼
                		$("#yyyyTarg").attr("readOnly", true); //올해목표
                        $("#longTarg").attr("readOnly", true); //장기목표
                        hopeJob1.enable(false); //희망직무1
                        hopeJob2.enable(false); //희망직무2
                	}
                }
                
            }
        }
        //희망직무1 데이터소스
        var dataSource_hopeJob1 = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_job_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){    
                        return {};
                    }
                },
                schema: {
                    data: "items",
                    model: {
                        fields: {
                            JOBLDR_NUM : { type: "number" },
                            JOBLDR_NAME : { type: "String" },
                            JOBLDR_COMMENT : { type: "String" },
                            MAIN_TASK : { type: "String" }
                        }
                    }
                },
                serverFiltering: false,
                serverSorting: false});
        
        
        //희망직무1
        var hopeJob1 = $("#hopeJob1").kendoDropDownList({
                 dataTextField: "JOBLDR_NAME",
                 dataValueField: "JOBLDR_NUM",
                 dataSource: dataSource_hopeJob1,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
        
        var hopeJob_window = $("#hopeJob1-window");
        
        //희망직무1 정보 확인
        $("#jobInfo1").click(function(){
            if( !hopeJob_window.data("kendoWindow") ){
            	hopeJob_window.kendoWindow({
                    title : "희망직무1",
                    modal: true,
                    visible: false
                });
            	//확인버튼 클릭 시
            	$("#hopeJobOKBtn").click(function(){
            		hopeJob_window.data("kendoWindow").close();
            	});
            }
            
            var item = hopeJob1.dataItem();
            if(item.JOBLDR_NUM==null){
            	alert("희망직무1을 선택해주세요.");
            	return false;
            }else{
            	$("#hopeJobNm").val(item.JOBLDR_NAME);
            	$("#hopeJobDef").val(item.JOBLDR_COMMENT);
            	$("#hopeJobTask").val(item.MAIN_TASK);
                
            	hopeJob_window.data("kendoWindow").center();
                hopeJob_window.data("kendoWindow").open();
            }
            
        });

        //희망직무2
        var hopeJob2 = $("#hopeJob2").kendoDropDownList({
	        	dataTextField: "JOBLDR_NAME",
	            dataValueField: "JOBLDR_NUM",
                 dataSource: dataSource_hopeJob1,
                 filter: "contains",
                 suggest: true
             }).data("kendoDropDownList");
        

        //희망직무2 정보 확인
        $("#jobInfo2").click(function(){
            if( !hopeJob_window.data("kendoWindow") ){
                hopeJob_window.kendoWindow({
                    title : "희망직무2",
                    modal: true,
                    visible: false
                });
                //확인버튼 클릭 시
                $("#hopeJobOKBtn").click(function(){
                    hopeJob_window.data("kendoWindow").close();
                });
            }
            
            var item = hopeJob2.dataItem();
            if(item.JOBLDR_NUM==null){
                alert("희망직무2를 선택해주세요.");
                return false;
            }else{
                $("#hopeJobNm").val(item.JOBLDR_NAME);
                $("#hopeJobDef").val(item.JOBLDR_COMMENT);
                $("#hopeJobTask").val(item.MAIN_TASK);
                
                hopeJob_window.data("kendoWindow").center();
                hopeJob_window.data("kendoWindow").open();
            }
        });
        
        //희망부서선택 팝업
        $("#deptSearchBtn").click(function(){
        	if(dataSource_myCdp && dataSource_myCdp.data().length>0 && (dataSource_myCdp.data()[0].REQ_STS_CD=="1" || dataSource_myCdp.data()[0].REQ_STS_CD=="2")){
                //승인요청 또는 승인상태에는 안됨.
                var reqMsg = "";
                if(dataSource_myCdp.data()[0].REQ_STS_CD=="1"){
                    reqMsg = "승인요청 중에는 수정할 수 없습니다.";
                }else{
                    reqMsg = "승인된 계획은 수정할 수 없습니다.";
                }
                alert(reqMsg);
                return false;
            }
        	
            if( !$("#dept-window").data("kendoWindow") ){
                $("#dept-window").kendoWindow({
                    width:"370px",
                    title : "부서검색",
                    resizable: true,
                    modal: true,
                    visible: false
                });
                //부서검색트리 정의
                $("#deptPopupTreeview").kendoTreeView({
                    dataTextField: ["DVS_NAME"],
                    dataSource: new kendo.data.HierarchicalDataSource({
                        type: "json",
                        transport: {
                            read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get-dept-list.do?output=json", type:"POST" },
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
                                   HIGH_DVSID : { type: "String" },
                                 items : { DIVISIONID : { type: "String" }, DVS_NAME : { type: "String" }, HIGH_DVSID : { type: "String"} }
                               },
                               children: "items"
                           }
                       },
                       serverFiltering: false,
                       serverSorting: false}),
                   loadOnDemand: false
                });
                
                //선택버튼 클릭 시
                $("#selectDeptBtn").click(function(){
                    var deptPopupTreeview = $ ( "#deptPopupTreeview" ). data ( "kendoTreeView" ); 
                    var selectedCells = deptPopupTreeview.select();
                    var selectedCell = deptPopupTreeview.dataItem ( selectedCells ); 

                     $("#divisionid").val(selectedCell.DIVISIONID);
                     $("#dvsName").val(selectedCell.DVS_NAME);
                     
                     $("#dept-window").data("kendoWindow").close();
                });
             }
            $("#dept-window").data("kendoWindow").center();
            $("#dept-window").data("kendoWindow").open();
            
        });
        //부서초기화.
        $("#clearDeptBtn").click(function(){
        	if(dataSource_myCdp && dataSource_myCdp.data().length>0 && (dataSource_myCdp.data()[0].REQ_STS_CD=="1" || dataSource_myCdp.data()[0].REQ_STS_CD=="2")){
                //승인요청 또는 승인상태에는 안됨.
                var reqMsg = "";
                if(dataSource_myCdp.data()[0].REQ_STS_CD=="1"){
                    reqMsg = "승인요청 중에는 수정할 수 없습니다.";
                }else{
                    reqMsg = "승인된 계획은 수정할 수 없습니다.";
                }
                alert(reqMsg);
                return false;
            }
        	$("#divisionid").val("");
            $("#dvsName").val("");
        });

        //자격증 목록
         var certGrid = $("#certGrid").kendoGrid({
        	dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_cert_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){
                         return { runNum: $("#rn").val(), tu:$("#tu").val() };
                    }
                },
                schema: {
                     data: "items",
                     model: {
                         fields: {
                        	 COMMONCODE : { type: "number" },
                        	 CMM_CODENAME: { type:"string"}
                         }
                     }
                },
                pageSize : 99999,
                serverPaging: false, serverFiltering: false, serverSorting: false
            },
            height: 250,
            groupable: false,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            selectable: "row",
            columns: [
                      {
						field : "CMM_CODENAME",
						title : "자격증목록",
						headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"},
						attributes : { "class" : "table-cell", style : "text-align:left; cursor:pointer;"}
                      }
            ]
        }).data("kendoGrid");
        
        //자격증계획 목록
        var certPlanGrid = $("#certPlanGrid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_cert_plan_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){
                         return { runNum: $("#rn").val(), tu:$("#tu").val() };
                    }
                },
                schema: {
                     data: "items",
                     model: {
                         fields: {
                             COMMONCODE : { type: "number" },
                             CMM_CODENAME: { type:"string"}
                         }
                     }
                },
                pageSize : 99999,
                serverPaging: false, serverFiltering: false, serverSorting: false
            },
            height: 250,
            groupable: false,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            columns: [
                      {
                          field : "CMM_CODENAME",
                          title : "자격증 취득 계획 목록",
                          headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"},
                          attributes : { "class" : "table-cell", style : "text-align:left; cursor:pointer;"}
                      },
                      { 
                          title : "삭제",
                          width: "100px" , 
                          headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                          attributes : { "class" : "table-cell", style : "text-align:center;" },
                          template: function(dataItem){
                              return '<button style="width:60px; min-width: 50px;" class="k-button" onclick="deleteCert('+dataItem.COMMONCODE+')">삭제</button>';
                          }
                      }
            ]
        }).data("kendoGrid");
        
        //자격증 추가하는 화살표버튼 클릭 시
        $("#addCertBtn").click(function(){
        	if(dataSource_myCdp && dataSource_myCdp.data().length>0 && (dataSource_myCdp.data()[0].REQ_STS_CD=="1" || dataSource_myCdp.data()[0].REQ_STS_CD=="2")){
        		//승인요청또는 승인상태에는 추가안됨.
                var reqMsg = "";
                if(dataSource_myCdp.data()[0].REQ_STS_CD=="1"){
                    reqMsg = "승인요청 중에는 수정할 수 없습니다.";
                }else{
                    reqMsg = "승인된 계획은 수정할 수 없습니다.";
                }
                alert(reqMsg);
        		return false;
        	}else{
        		var rows = certGrid.select();
                rows.each(function(index, row) {
                var selectedItem = certGrid.dataItem(row);
                    certPlanGrid.dataSource.insert(selectedItem);
                    certGrid.dataSource.remove(selectedItem);
                });
        	}
        	
        });
        
        //어학 목록
        var langGrid = $("#langGrid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_lang_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){
                         return { runNum: $("#rn").val(), tu:$("#tu").val() };
                    }
                },
                schema: {
                     data: "items",
                     model: {
                         fields: {
                             COMMONCODE : { type: "number" },
                             CMM_CODENAME: { type:"string"}
                         }
                     }
                },
                pageSize : 99999,
                serverPaging: false, serverFiltering: false, serverSorting: false
            },
            height: 250,
            groupable: false,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            selectable: "row",
            columns: [
                      {
                          field : "CMM_CODENAME",
                          title : "어학인증시험",
                          headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                          attributes : { "class" : "table-cell", style : "text-align:left; cursor:pointer;" }
                      }
            ]
        }).data("kendoGrid");

        //어학계획목록.
        var langPlanGrid = $("#langPlanGrid").kendoGrid({
            dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_lang_plan_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){
                         return { runNum: $("#rn").val(), tu:$("#tu").val() };
                    }
                },
                schema: {
                     data: "items",
                     model: {
                         fields: {
                             COMMONCODE : { type: "number" },
                             CMM_CODENAME: { type:"string"}
                         }
                     }
                },
                pageSize : 99999,
                serverPaging: false, serverFiltering: false, serverSorting: false
            },
            height: 250,
            groupable: false,
            sortable: true,
            resizable: true,
            reorderable: true,
            pageable: false,
            columns: [
                      {
                          field : "CMM_CODENAME",
                          title : "어학인증시험 취득 계획 목록",
                          headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                          attributes : { "class" : "table-cell", style : "text-align:left; cursor:pointer;"}
                      },
                      { 
                          title : "목표점수",
                          width: "120px" , 
                          headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                          attributes : { "class" : "table-cell", style : "text-align:center;" },
                          template: function(data){
                        	  var sco = "";
                        	  if(data.TARG_SCO){
                        		  sco =  data.TARG_SCO;
                        	  }
                              return "<input id=\"targSco_"+data.COMMONCODE+"\" type=\"text\" class=\"k-textbox inp_style01\" value=\""+sco+"\" style=\"width:100px;\" maxlength=\"5;\" onkeyup=\"chkNum(this); setTargScoValue("+data.COMMONCODE+"); \" />";
                          }
                      },
                      { 
                          title : "삭제",
                          width: "80px" , 
                          headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                          attributes : { "class" : "table-cell", style : "text-align:center;" },
                          template: function(dataItem){
                              return '<button style="width:60px; min-width: 50px;" class="k-button" onclick="deleteLang('+dataItem.COMMONCODE+');">삭제</button>';
                          }
                      }
            ]
        }).data("kendoGrid");

        //어학 추가하는 화살표버튼 클릭 시
        $("#addLangBtn").click(function(){
        	if(dataSource_myCdp && dataSource_myCdp.data().length>0 && (dataSource_myCdp.data()[0].REQ_STS_CD=="1" || dataSource_myCdp.data()[0].REQ_STS_CD=="2")){
                //승인요청또는 승인상태에는 추가안됨.
                var reqMsg = "";
                if(dataSource_myCdp.data()[0].REQ_STS_CD=="1"){
                    reqMsg = "승인요청 중에는 수정할 수 없습니다.";
                }else{
                    reqMsg = "승인된 계획은 수정할 수 없습니다.";
                }
                alert(reqMsg);
                return false;
            }else{
	            var rows = langGrid.select();
	            rows.each(function(index, row) {
	            var selectedItem = langGrid.dataItem(row);
	                langPlanGrid.dataSource.insert({
	                	COMMONCODE : selectedItem.COMMONCODE,
	                	CMM_CODENAME : selectedItem.CMM_CODENAME,
	                	TARG_SCO : ""
	                });
	                langGrid.dataSource.remove(selectedItem);
	            });
            }
        });
        
        //step1에서 취소버튼 클릭 시 경력개발계획 메인화면으로 이동..
        $("#cancelStep1, #cancelStep2").click(function(){
        	if(confirm("취소하시고 경력개발계획 메인화면으로 이동하시겠습니까?")){
	        	document.frm.action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_run_list_pg.do";
	       	    document.frm.submit();  
            }
        });
        
        //다음단계 클릭 시
        $("#nextStep").click(function(){
        	window.scrollTo(0,0);
        	tabstrip.select(1);
        });

        //이전단계 클릭 시
        $("#beforeStep").click(function(){
            tabstrip.select(0);
        });
        
        //임시저장
        $("#tmpReqAppr1, #tmpReqAppr2").click(function(){
        	//교육계획 0건이상 시 교육희망년월 입력값 체크.
            var isHopeYm = true;
            if(eduPlanGrid!=null && eduPlanGrid.dataSource.data().length>0){
                $.each(eduPlanGrid.dataSource.data(), function(i,e){
                	if(e.HOPE_YYYYMM==null || e.HOPE_YYYYMM==""){
                        alert("교육계획의 교육희망월은 필수입력항목입니다.\n입력예) 2014-10");
                        $("#yyyymm_"+e.SUBJECT_NUM).focus();
                        tabstrip.select(1);
                        isHopeYm = false;
                        return false;
                    }else if(e.HOPE_YYYYMM!=null && e.HOPE_YYYYMM!=""){
                        if(!ex_month("교육희망월", "yyyymm_"+e.SUBJECT_NUM)){
                            $("#yyyymm_"+e.SUBJECT_NUM).focus();
                            isHopeYm = false;
                        }
                        e.HOPE_YYYYMM = $("#yyyymm_"+e.SUBJECT_NUM).val();
                    }
                });
            }
            if(!isHopeYm){
                return false;
            }
            
        	if(confirm("임시저장하시겠습니까?")){
        		apprReqExec("N");
        	}
        });
        
        //승인요청 버튼 클릭 시
        $("#reqAppr1, #reqAppr2").click(function(){
        	
        	var isReq = false;
        	var isPerf = false;
        	
        	if($("#yyyyTarg").val() == ""){
        		alert("올해목표를 입력해주세요.");
        		tabstrip.select(0);
        		$("#yyyyTarg").focus();
        		return false;
        	}
        	if($("#longTarg").val() == ""){
                alert("장기목표를 입력해주세요.");
                tabstrip.select(0);
                $("#longTarg").focus();
                return false;
            }
        	if(hopeJob1.select()==0){
        		alert("희망직무1을 선택해주세요");
                tabstrip.select(0);
        		hopeJob1.focus();
        		return false;
        	}
            if(hopeJob2.select()==0){
                alert("희망직무2를 선택해주세요");
                tabstrip.select(0);
                hopeJob2.focus();
                return false;
            }
        	if($("#divisionid").val()==""){
        		alert("희망부서를 선택해주세요.");
                tabstrip.select(0);
        		$("#deptSearchBtn").focus();
        		return false;
        	}

            //교육계획 0건이상 시 교육희망년월 필수입력 체크.
            var isHopeYm = true;
            if(eduPlanGrid!=null && eduPlanGrid.dataSource.data().length>0){
                $.each(eduPlanGrid.dataSource.data(), function(i,e){
                    if(e.HOPE_YYYYMM==null || e.HOPE_YYYYMM==""){
                        alert("교육계획의 교육희망월은 필수입력항목입니다.\n입력예) 2014-10");
                        $("#yyyymm_"+e.SUBJECT_NUM).focus();
                        tabstrip.select(1);
                        isHopeYm = false;
                        return false;
                    }else if(e.HOPE_YYYYMM!=null && e.HOPE_YYYYMM!=""){
                        if(!ex_month("교육희망월", "yyyymm_"+e.SUBJECT_NUM)){
                            $("#yyyymm_"+e.SUBJECT_NUM).focus();
                            isHopeYm = false;
                            tabstrip.select(1);
                            return false;
                        }
                        e.HOPE_YYYYMM = $("#yyyymm_"+e.SUBJECT_NUM).val();
                    }
                });
            }
            if(!isHopeYm){
                return false;
            }
            
        	if($("#reqSpan").html()=="미충족"){
        		if(confirm("필수계획이 미충족입니다. 그래도 진행하시겠습니까?")){
        			isReq = true;
        		}
        	}else{
        		isReq = true;
        	}
        	if(!isReq){
                return false;
            }
            if($("#perfSpan").html()=="미충족"){
                if(confirm("기관성과평가 계획이 미충족입니다. 그래도 진행하시겠습니까?")){
                	isPerf = true;
                }
            }else{
            	isPerf = true;
            }
        	if(!isPerf){
        		return false;
        	}
        	
        	//승인요청 팝업호출.
        	apprReqOpen();
        	apprReqCallBackFunc = apprReqExec;
        });
        
        //승인요청 처리 콜백 함수..
        var apprReqExec = function(cmpltFlag){
        	
        	var apprReqDataSource = null;
        	
       		if($("#apprReqUserGrid").data("kendoGrid")){
       			apprReqDataSource = $("#apprReqUserGrid").data("kendoGrid").dataSource.data();
       		}
        	var params = {
                    APPR_LINE :  apprReqDataSource, //승인경로
                    CERT_PLAN: certPlanGrid.dataSource.data(), //자격증계획
                    LANG_PLAN: langPlanGrid.dataSource.data(), //어학계획
                    EDU_PLAN: eduPlanGrid.dataSource.data() //교육계획
            };
            $.ajax({
               type : 'POST',
               url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/save_my_cdp.do?output=json",
               data : { 
            	   item: kendo.stringify( params ), 
            	   runNum: $("#rn").val(), 
            	   tu:$("#tu").val(),
            	   YYYY_TARG : $("#yyyyTarg").val(),
            	   LONG_TARG : $("#longTarg").val(),
            	   HOPE_JOB1 : removeNullStr(hopeJob1.value()),
                   HOPE_JOB2 : removeNullStr(hopeJob2.value()),
                   HOPE_DIVISIONID : $("#divisionid").val(),
                   CMPLT_FLAG : cmpltFlag
               },
               complete : function( response ){
                   var obj = eval("(" + response.responseText + ")");
                    if(obj.error){
                        alert("ERROR=>"+obj.error.message);
                    }else{
                        if(obj.saveCount > 0){
                        	if(cmpltFlag=="Y"){
                        		alert("계획이 완료되었습니다.");
                                document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_run_list_pg.do";
                                document.frm.submit();

                        	}else{
                        		alert("임시저장되었습니다.");
                        		//경력개발계획 내용 다시 읽기
                        		dataSource_myCdp.read();
                        		//자격증 계획 읽기.
                        		certPlanGrid.dataSource.read();
                        		//어학계획 읽기
                        		langPlanGrid.dataSource.read();
                        		//교육계획 읽기
                                eduPlanGrid.dataSource.read();
                        	}
                        }else{
                            alert("실패 하였습니다.");
                        }
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
        
        //부처지정학습종류 공통코드 조회.
        var dataSource_deptDesignation = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_common_code.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {  STANDARDCODE : "BA04" };
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
        dataSource_deptDesignation.fetch(function(){
        	var reqColGroup =  ""; //필수계획현황 colgroup
        	var reqTheadTr1 = ""; //필수계획현황 - 헤더1
            var reqTheadTr2 = ""; //필수계획현황 - 헤더2
            var reqTime = ""; //필수계획현황 - 필수시간
        	if(dataSource_deptDesignation.data().length>0){
        		
        		//테이블 헤더 세팅.
        		$("#reqColGroup").html("");
                reqColGroup = "<col style=\"width:180px;\"/>";
                reqColGroup += "<col style=\"width:100px;\" />";
                $.each(dataSource_deptDesignation.data(), function(i,e){
                	reqColGroup += "<col style=\"width:230px;\" />";
                	
                	reqTheadTr2 += "<th><span class=\"blue\">"+this.TEXT+"</span></th>";
                });
                
                $("#reqColGroup").html(reqColGroup);
                
                $("#reqTheadTr1").html("");
                
                reqTheadTr1 = "<th rowspan=\"2\" class=\"fir\"></th>";
                reqTheadTr1 += "<th rowspan=\"2\" class=\"fir\">총시간</th>";
                reqTheadTr1 += "<th colspan=\""+dataSource_deptDesignation.data().length+"\" class=\"fir\">부처지정학습 </th>";
                
                $("#reqTheadTr1").html(reqTheadTr1);
                $("#reqTheadTr2").html(reqTheadTr2);
                
                //데이터세팅
                reqEduStsFunc();
        	}
        	
        });
        
        //필수계획현황 조회
        var dataSource_requiredPlan = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_required_plan.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {tu : $("#tu").val() ,  year : $("#year").val()  };
                }
            },
            schema: {
                data: "items",
                model: {
                    fields: {
                        YYYY : { type: "number" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false});
        dataSource_requiredPlan.fetch(function(){
        	if(dataSource_requiredPlan.data().length>0){
        		//데이터 세팅..
        		reqEduStsFunc();
        		
        	}
        });
        
        //부처지정 총시간
        var reqtdTT_h,  reqtdTT_m=  0;
        var reqtd1_h,  reqtd1_m=  0;
        
        var reqEduStsFunc = function(e){
            if(dataSource_deptDesignation.data() && dataSource_deptDesignation.data().length>0 && dataSource_requiredPlan.data() && dataSource_requiredPlan.data().length>0){
            	var reqTr = "<tr><td>필수시간</td>";
            	var ttM = "";
            	if(dataSource_requiredPlan.data()[0].TT_CMP_TIME_M!=null && dataSource_requiredPlan.data()[0].TT_CMP_TIME_M>0){
            		ttM = dataSource_requiredPlan.data()[0].TT_CMP_TIME_M+"분";
            	}
            	
            	reqtdTT_h = dataSource_requiredPlan.data()[0].TT_CMP_TIME_H;
            	reqtdTT_m =  dataSource_requiredPlan.data()[0].TT_CMP_TIME_M;
            	
            	reqTr += "<td id=\"reqtdTT\">"+dataSource_requiredPlan.data()[0].TT_CMP_TIME_H+"시간 "+ttM+"</td>";
                $.each(dataSource_deptDesignation.data(), function(i, e){
                	var objNm_h =  "DD_H"+this.VALUE;
                	var objNm_m =  "DD_M"+this.VALUE;
                	var ddH = "0시간 ";
                	var ddM = "";
                	if(dataSource_requiredPlan.data()[0][objNm_h]!=null && dataSource_requiredPlan.data()[0][objNm_h]>0){
                        ddH = dataSource_requiredPlan.data()[0][objNm_h]+"시간 ";
                    }
                	if(dataSource_requiredPlan.data()[0][objNm_m]!=null && dataSource_requiredPlan.data()[0][objNm_m]>0){
                		ddM = dataSource_requiredPlan.data()[0][objNm_m]+"분";
                	}
                    reqTr += "<td id=\"reqtd"+this.VALUE+"\">"+ddH+ddM+"</td>";
                   	reqtd1_h = dataSource_requiredPlan.data()[0][objNm_h];
                   	reqtd1_m = dataSource_requiredPlan.data()[0][objNm_m];
                });
                reqTr += "</tr>";
                
                reqTr += "<tr><td>계획시간</td>";
                reqTr += "<td id=\"reqPlantdTT\"></td>";
                $.each(dataSource_deptDesignation.data(), function(i, e){
                	var val = "";
                    reqTr += "<td id=\"reqPlantd"+this.VALUE+"\"></td>";
                });
                reqTr += "</tr>";
                
                $("#reqTbody").html(reqTr);
                
                myReqPlanTimeFunc();
            }
        };

        //기관성과평가필수교육 공통코드 조회.
        var dataSource_perfAsse = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_common_code.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {  STANDARDCODE : "BA11" };
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
        dataSource_perfAsse.fetch(function(){
        	if(dataSource_perfAsse.data().length>0){
	        	var perfColGroup = "";
	        	var perfTheadTr = "";
	
	            //테이블 헤더 세팅.
	            $("#perfColGroup").html("");
	            
	            perfColGroup = "<col style=\"width:180px;\"/>";
	            perfTheadTr = "<th></th>";
	            $.each(dataSource_perfAsse.data(), function(i,e){
	            	perfColGroup += "<col style=\"width:208px;\" />";
	                
	            	perfTheadTr += "<th>"+this.TEXT+"</th>";
	            });
	            
	            $("#perfColGroup").html(perfColGroup);
	            $("#perfTheadTr").html(perfTheadTr);
	            
	            //기관성과평가 필수 계획시간 화면 구성.
	            perfEduStsFunc();
        	}
        });

        //기관성과평가교육 계획현황 조회
        var dataSource_perfPlan = new kendo.data.DataSource({
            type: "json",
            transport: {
                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_perf_plan.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return {tu : $("#tu").val() ,  year : $("#year").val()  };
                }
            },
            schema: {
                data: "items",
                model: {
                    fields: {
                        YYYY : { type: "number" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false});
        dataSource_perfPlan.fetch(function(){
            if(dataSource_perfPlan.data().length>0){
                //데이터 세팅..
                perfEduStsFunc();
            }
        });

        //기관성과평가 필수시간 변수
        var arrPerfReq = [];
        var perfEduStsFunc = function(e){
            if(dataSource_perfAsse.data() && dataSource_perfAsse.data().length>0 && dataSource_perfPlan.data() && dataSource_perfPlan.data().length>0){
                var perfTr = "<tr><td>필수시간</td>";
                $.each(dataSource_perfAsse.data(), function(i, e){
                    var objNm_h =  "PD_H"+this.VALUE;
                    var objNm_m =  "PD_M"+this.VALUE;
                    var pdH = "0시간 ";
                    var pdM = "";
                    if(dataSource_perfPlan.data()[0][objNm_h]!=null && dataSource_perfPlan.data()[0][objNm_h]>0){
                        pdH = dataSource_perfPlan.data()[0][objNm_h]+"시간";
                    }
                    if(dataSource_perfPlan.data()[0][objNm_m]!=null && dataSource_perfPlan.data()[0][objNm_m]>0){
                    	pdM = dataSource_perfPlan.data()[0][objNm_m]+"분";
                    }
                    
                    perfTr += "<td id=\"perftd"+this.VALUE+"\">"+pdH+pdM+"</td>";
                    
                    arrPerfReq["P_H"+this.VALUE] = dataSource_perfPlan.data()[0][objNm_h];
                    arrPerfReq["P_M"+this.VALUE] = dataSource_perfPlan.data()[0][objNm_m];
                    
                });
                perfTr += "</tr>";
                
                perfTr += "<tr><td>계획시간</td>";
                $.each(dataSource_perfAsse.data(), function(i, e){
                	perfTr += "<td id=\"perfPlantd"+this.VALUE+"\"></td>";
                });
                perfTr += "</tr>";
                
                $("#perfTbody").html(perfTr);
                
                myReqPlanTimeFunc();
            }
        };

        //교육계획 목록 조회
        var eduPlanGrid = $("#eduPlanGrid").kendoGrid({
        	dataSource: {
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_edu_plan.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){
                         return { runNum: $("#rn").val(), tu:$("#tu").val() };
                    }
                },
                schema: {
                     data: "items",
                     model: {
                         fields: {
                             SUBJECT_NUM : { type: "number" },
                             CMPNAME : { type: "string" },
                             SUBJECT_NAME: { type:"string"}
                         }
                     }
                },
                pageSize : 99999,
                serverPaging: false, serverFiltering: false, serverSorting: false
            },
	        height: 300,
	        groupable: false,
	        sortable: true,
	        resizable: false,
	        reorderable: true,
	        pageable: false,
	        columns: [
				{
				    field : "CMPNAME",
				    title : "역량명",
				    width: "150px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"},
				    attributes : { "class" : "table-cell", style : "text-align:left;"}
				},{
				    field : "SUBJECT_NAME",
				    title : "과정명",
				    width: "200px",
				    headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
				    attributes : { "class" : "table-cell", style : "text-align:left;" }
				},{
				    field: "TRAINING_NM",
				    title: "학습유형",
				    width: "80px",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                    attributes : { "class" : "table-cell", style : "text-align:center;" }
				},{
				    field: "ALW_STD_NM",
				    title: "상시학습종류",
				    width: "150px",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                    attributes : { "class" : "table-cell", style : "text-align:left;" }
				}, {
				    field: "DEPT_DESIGNATION_YN",
				    title: "부처지정학습",
                    width: "80px",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                    attributes : { "class" : "table-cell", style : "text-align:center;" },
                    template:function(data){
                    	if(data.DEPT_DESIGNATION_YN=="Y"){
                    		return "예";
                    	}else{
                    		return "아니오";
                    	}
                    }
				}, /*{
				    field: "PERF_ASSE_SBJ_NM",
				    title: "기관성과평가과정",
                    width: "100px",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                    attributes : { "class" : "table-cell", style : "text-align:left" }
				}, {
				    title: "교육기간",
                    width: "200px",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                    attributes : { "class" : "table-cell", style : "text-align:center" },
                    template:function(data){
                    	return data.EDU_STIME+"~"+data.EDU_ETIME;
                    }
				}, */{
				    field: "RECOG_TIME",
				    title: "인정시간",
                    width: "100px",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                    attributes : { "class" : "table-cell", style : "text-align:center" }
				}, {
                    field: "HOPE_YYYYMM",
                    title: "교육희망월",
                    width: "120px",
                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center"  },
                    attributes : { "class" : "table-cell", style : "text-align:center" },
                    template: function(data){
                        var yyyymm = "";
                        if(data.HOPE_YYYYMM){
                            yyyymm =  data.HOPE_YYYYMM;
                        }
                        return "<input id=\"yyyymm_"+data.SUBJECT_NUM+"\" type=\"text\" class=\"k-textbox inp_style01\" value=\""+yyyymm+"\" style=\"width:100px;\" maxlength=\"7\" onkeyup=\"chkNull(this); setHopeymValue("+data.SUBJECT_NUM+"); \" />";
                    }
                }, {
                	title: "삭제",
                	width: "80px",
                	headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                    attributes : { "class" : "table-cell", style : "text-align:center" },
                    template:function(data){
                        return "<button onclick=\"deleteEdu("+data.SUBJECT_NUM+")\" class=\"k-button\" style=\"width:60px; min-width:60px; \" >삭제</button>";
                    }
                }
	        ]
	    }).data("kendoGrid");
        
        //교육계획이 변경된경우 필수시간 재계산..
        $("#eduPlanGrid").data("kendoGrid").dataSource.bind("change", function(){
        	myReqPlanTimeFunc();
        });
        
        //필수계획현황 충족/미충족 세팅..
        var myReqPlanTimeFunc = function(e){
        	var ttTime_h = 0; //총시간_시
            var ttTime_m = 0; //총시간_분
            
            
            //필수시간이 먼저 세팅되어있어야함..
            if(dataSource_deptDesignation.data() && dataSource_deptDesignation.data().length>0 && dataSource_requiredPlan.data() && dataSource_requiredPlan.data().length>0){
                var array = $("#eduPlanGrid").data("kendoGrid").dataSource.data();
                
                //부처지정학습
                var dd1_h = 0;
                var dd1_m = 0;
                
                //기관성과평가 
                var arrPerf = [];
                
                $.each(array, function(i,e){
                    //부처지정학습인경우.
                    if(this.DEPT_DESIGNATION_YN=="Y"){
                        dd1_h = dd1_h + this.RECOG_TIME_H;
                        dd1_m = dd1_m + this.RECOG_TIME_M;
                    }
                    
                    //기관성과평가필수교육인 경우..
                    if(this.PERF_ASSE_SBJ_CD!=null && this.PERF_ASSE_SBJ_CD!=""){
                        var tmpH = arrPerf["P_H"+this.PERF_ASSE_SBJ_CD];
                        if(tmpH){
                            tmpH = tmpH + this.RECOG_TIME_H;
                        }else{
                            tmpH = this.RECOG_TIME_H;;
                        }
                        arrPerf["P_H"+this.PERF_ASSE_SBJ_CD] = tmpH;
                        
                        var tmpM = arrPerf["P_M"+this.PERF_ASSE_SBJ_CD];
                        if(tmpM){
                            tmpM = tmpM + this.RECOG_TIME_M;
                        }else{
                            tmpM = this.RECOG_TIME_M;;
                        }
                        arrPerf["P_M"+this.PERF_ASSE_SBJ_CD] = tmpM;
                    }
                    
                    //총시간 계산.
                    ttTime_h = ttTime_h + Number(this.RECOG_TIME_H);
                    ttTime_m = ttTime_m + Number(this.RECOG_TIME_M);
                    
                });
                //총시간
                ttTime_h = ttTime_h + Math.floor(ttTime_m/60); 
                ttTime_m = ttTime_m % 60;
                
                //부처지정학습
                dd1_h = dd1_h + Math.floor(dd1_m/60); 
                dd1_m = dd1_m % 60;

                var ttMt = "";
                if(ttTime_m!=null && ttTime_m>0){
                    ttMt = ttTime_m + "분";
                }
                var dd1Mt = "";
                if(dd1_m!=null && dd1_m>0){
                    dd1Mt = dd1_m + "분";
                }

                $("#reqPlantdTT").html(ttTime_h+"시간 "+ttMt);
                $("#reqPlantd001").html(dd1_h+"시간 "+dd1Mt);

                //필수계획 충족/미충족 처리 
                //총시간 , 부처지정학습 => 모두 필수시간모다 계획시간이 많아야함.
                if(reqtdTT_h <= ttTime_h && reqtdTT_m <= ttTime_m
                        && reqtd1_h <= dd1_h && reqtd1_m <= dd1_m){
                    $("#isEnoughReqNm").html("<span id=\"reqSpan\" class=\"yes\">충족</span>");
                }else{
                    $("#isEnoughReqNm").html("<span id=\"reqSpan\" class=\"no\">미충족</span>");
                }
                
                var isPerfCnt = 0;
                //기관성과평가 계획시간 세팅.
                if(dataSource_perfAsse &&  dataSource_perfAsse.data().length>0){
                    for(var i=0; i< dataSource_perfAsse.data().length; i++){
                        var obj =  dataSource_perfAsse.data()[i];
                        
                        var tmpHr  = "0";
                        if(arrPerf["P_H"+obj.VALUE]){
                            tmpHr  = arrPerf["P_H"+obj.VALUE];
                        }
                        var tmpMt  = 0;
                        var tmpMtStr = "";
                        if(arrPerf["P_M"+obj.VALUE]){
                            tmpMt = arrPerf["P_M"+obj.VALUE];
                            if( tmpMt>0 ){
                                tmpHr = tmpHr + Math.floor(tmpMt/60); 
                                tmpMtStr = tmpMt % 60+"분";
                            }
                        }
                        
                        $("#perfPlantd"+obj.VALUE).html( tmpHr+ "시간 "+tmpMtStr );
                        
                        //기관성과평가 충족/미충족 여부 확인.
                        if( Number(tmpHr) >= Number(arrPerfReq["P_H"+obj.VALUE])  && Number(tmpMt) >= Number(arrPerfReq["P_M"+obj.VALUE])  ){
                            isPerfCnt ++;
                        }
                    }
                }
                
                if(isPerfCnt == dataSource_perfAsse.data().length){
                    $("#isEnoughPerfNm").html("<span id=\"perfSpan\" class=\"yes\">충족</span>");
                }else{
                    $("#isEnoughPerfNm").html("<span id=\"perfSpan\" class=\"no\">미충족</span>");
                }
            }
        };
        
        
        //교육추가 버튼 클릭 시
		$("#addEdu").click(function(){
			if(dataSource_myCdp && dataSource_myCdp.data().length>0 && (dataSource_myCdp.data()[0].REQ_STS_CD=="1" || dataSource_myCdp.data()[0].REQ_STS_CD=="2")){
                //승인요청 또는 승인상태에는 안됨.
                var reqMsg = "";
                if(dataSource_myCdp.data()[0].REQ_STS_CD=="1"){
                	reqMsg = "승인요청 중에는 수정할 수 없습니다.";
                }else{
                	reqMsg = "승인된 계획은 수정할 수 없습니다.";
                }
                alert(reqMsg);
                return false;
            }
			
			if( !$("#addEdu-window").data("kendoWindow") ){
                $("#addEdu-window").kendoWindow({
                    width:"1284px",
                    title : "교육계획추가",
                    modal: true,
                    visible: false
                });
                
                //역량진단 이력 데이터소스
                var dataSource_cmpRunList = new kendo.data.DataSource({
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_cmp_run_list.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){    
                            return {  tu:$("#tu").val() };
                        }
                    },
                    schema: {
                        data: "items",
                        model: {
                            fields: {
                            	YYYY : { type: "number" },
                            	RUN_NUM : { type: "number" },
                            	RUN_NAME : { type: "string" }
                            }
                        }
                    },
                    serverFiltering: false,
                    serverSorting: false});
                dataSource_cmpRunList.fetch(function(dataItem){
                	var data = dataItem.items[0];
                	if(data){
                		$("#evlRunList").text(data.RUN_NAME);
                        $("#evlRunNum").val(data.RUN_NUM);
                	}else{
                		$("#evlRunList").text("역량진단 이력이 존재하지 않습니다.");
                        $("#evlRunNum").val("");
                	}
                	

                });
                //역량진단결과 조회
                var cmptDataSource = new kendo.data.DataSource({
		            type: "json",
		            transport: {
		                read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_cmp_run_result.do?output=json", type:"POST" },
		                parameterMap: function (options, operation){    
		                    return { tu:$("#tu").val(), runNum: $("#evlRunNum").val() };
		                }
		            },
		            schema: {
		                data: "items",
		                model: {
		                    fields: {
		                        COMPANYID : { type: "int" },
		                        CMPNUMBER : { type: "int" },
                                CMPNUMBER_NUMB : { type: "int" },
		                        CMPNAME : { type: "String" },
		                        SCORE : { type: "int" }
		                    }
		                }
		            },
		            serverFiltering: false,
		            serverSorting: false,
		            dataBound:function(){
		            	
		            }
		        });
                //최초 화면로딩시 데이터소스 fetch.. -> 데이터소스에 change이벤트 발생함.
                cmptDataSource.fetch(function(){});
                
		        //역량진단결과내용 데이터소스가 변경될경우..
		        cmptDataSource.bind("change", function(){
		        	var html = '';
                    var view = cmptDataSource.data();
		        	$('#cmptgrid').empty();
		        	if(view.length>0){
							html = "<table class=\"table_type02\">";
							html += 	"<colgroup>";
							html += 	"<col style=\"width:100px\"/>";
							
							$.each(view, function(i, e) {
								html += "<col style=\"width:*\" />";
							});
							html += 	"</colgroup>";
							html += 	"<thead>";
							html += 		"<tr>";
							html +=			"<th>역량명</th>";
							
							$.each(view, function(i, e) {
								html += "<th>"+e.CMPNAME+"</th>";	
							});
							html += 		"</tr>";
							html += 		"</thead>";
							html += "<tbody>";
							html += 	"<tr>";
							html += 		"<td>취득점수</td>";
							
							$.each(view, function(i, e) {
								var myScore = "";
								if(e.MY_SCR){
									myScore = e.MY_SCR+"점";
								}else{
									myScore  = "-";
								}
								html += "<td>"+myScore+"</td>";
							});
							html += "</tr>";
							
							//매핑과정보기 버튼..
							html += "<tr>";
                            html += "<td><button onclick=\"filterData(-1); return false;\" class=\"k-button\" >전체보기</button></td>";
                            
                            $.each(view, function(i, e) {
                                html += "<td><button onclick=\"filterData('"+e.CMPNUMBER+"'); return false;\" class=\"k-button\" >과정보기</button></td>";
                            });
                            html += "</tr>";
							html += "</tbody>";
							html += "</table>";
						} else {
							html = '※ 역량진단 결과정보가 존재 하지 않습니다.';
						}
		        	$('#cmptgrid').append(html);
		        });
                
		        //역량진단결과와 매핑된 교육과정 목록 조회
		        var eduCmpGrid = $("#eduCmpGrid").kendoGrid({
		        	dataSource: {
                        type: "json",
                        transport: {
                            read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_cmp_subject_map_list.do?output=json", type:"POST" },
                            parameterMap: function (options, operation){
                                var sortField = "";
                                var sortDir = "";
                                if (options.sort && options.sort.length>0) {
                                    sortField = options.sort[0].field;
                                    sortDir = options.sort[0].dir;
                                }
                                return {
                                    startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter),
                                    tu:$("#tu").val(), runNum: $("#evlRunNum").val()  
                                };
                            }
                        },
                        schema: {
                            total : "totalItemCount",
                             data: "items",
                             model: {
                                 fields: {
                                        SUBJECT_NUM : { type: "number" },
                                        CMPNAME : { type: "string" },
                                        TRAINING_NM: { type:"string"},
                                        SUBJECT_NAME : { type: "string" },
                                        DEPT_DESIGNATION_YN: { type: "string"},
                                        DEPT_DESIGNATION_NM: { type: "string" },
                                        INSTITUTE_NAME: { type: "string" },
                                        RECOG_TIME_H: { type: "number" },
                                        RECOG_TIME : { type:"string" }
                                    }
                             }
                        },
                        pageSize : 30,
                        serverPaging: true, serverFiltering: true, serverSorting: true
                    },
                    columns: [
						{
			                field: "CMPNAME",
			                title: "역량명",
			                width:"170px",
			                filterable : false,
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                            attributes : { "class" : "table-cell", style : "text-align:left" }
			            }, {
			                field: "TRAINING_NM",
			                title: "학습유형",
                            width:"80px",
                            filterable : false,
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                            attributes : { "class" : "table-cell", style : "text-align:center;" }
			            }, {
			                field: "SUBJECT_NAME",
			                title: "과정명",
                            width:"250px",
                            filterable : false,
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                            attributes : { "class" : "table-cell", style : "text-align:left; text-decoration: underline;" },
                            template: function(data){
                                var subjectName = data.SUBJECT_NAME;
                                return "<a href='javascript:void();' onclick='javascript: fn_detailView("+data.SUBJECT_NUM+","+data.CMPNUMBER+");' >"+subjectName+"</a>";
                            }
			            }, /*{
			                field: "CHASU",
			                title: "차수",
                            width:"50px",
                            filterable : false,
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                            attributes : { "class" : "table-cell", style : "text-align:right" }
			            }, {
						    title: "교육기간",
		                    width: "200px",
		                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
		                    attributes : { "class" : "table-cell", style : "text-align:center" },
		                    template:function(data){
		                    	return data.EDU_STIME+"~"+data.EDU_ETIME;
		                    }
			            }, */{
			                field: "RECOG_TIME",
			                title: "인정시간",
                            width:"100px",
                            filterable : false,
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                            attributes : { "class" : "table-cell", style : "text-align:right" }
			            }, {
			                field: "DEPT_DESIGNATION_YN",
			                title: "부처지정학습",
                            width:"100px",
                            filterable : false,
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                            attributes : { "class" : "table-cell", style : "text-align:center;" }
			            }, {
			                field: "PERF_ASSE_SBJ_NM",
			                title: "기관성과평가과정",
                            width:"130px",
                            filterable : false,
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                            attributes : { "class" : "table-cell", style : "text-align:left" }
			            }, {
			                field: "INSTITUTE_NAME",
			                title: "교육기관",
                            width:"150px",
                            filterable : false,
                            headerAttributes : { "class" : "table-header-cell", style : "text-align:center;"  },
                            attributes : { "class" : "table-cell", style : "text-align:left" }
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
		            height: 440,
		            groupable: false,
		            sortable: "row",
		            resizable: false,
		            reorderable: true,
		            pageable: true,
                    pageable : {
                        refresh : false,
                        pageSizes : [10,20,30],
                        buttonCount: 5
                    }
		        }).data("kendoGrid");
		        
		        // area splitter
		        var splitter = $("#splitter").kendoSplitter({
		            orientation : "horizontal",
		            panes : [ {
		                collapsible : true,
		                min : "300px"
		            }, {
		                collapsible : true,
		                collapsed : true,
		                min : "300px"
		            } ]
		        });
		        
		        $("#tabstrip2").kendoTabStrip({
		            animation:  {
		                open: {
		                    effects: "fadeIn"
		                }
		            },
	            select: onSelectTabstrip2
		        }); 
		        
		        //보고 있는 과정 상세화면 splitter 닫기.
		        function  onSelectTabstrip2(e){
		        	//if(e.item.innerText == "역량진단"){
		        		$("#splitter").data("kendoSplitter").toggle("#list_pane",true);
                        $("#splitter").data("kendoSplitter").toggle("#detail_pane",false);
                   // }else{
		        		//$("#splitter2").data("kendoSplitter").toggle("#list_pane2",true);
                        //$("#splitter2").data("kendoSplitter").toggle("#detail_pane2",false);
                    //}
		        	$("#eduCmpGrid div.k-grid-content").attr("style", "height: 369px;");
                    //$("#eduNorGrid div.k-grid-content").attr("style", "height: 369px;");
                    
		        }
		        
		        //교육과정상세정보 데이터소스
		        dataSource_eduDetail  = new kendo.data.DataSource({
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_sbjct_info.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){    
                            return {  subjectNum:$("#dtl-subjectNum").val() };
                        }
                    },
                    schema: {
                        data: "items"
                    },
                    serverFiltering: false,
                    serverSorting: false});
		        
		        $("#eduPopCloseBtn").click(function(){
		        	$("#addEdu-window").data("kendoWindow").close();
		        });
			}
			
			//$("#eduNorGrid").data("kendoGrid").dataSource.read();
			
			$("#addEdu-window").data("kendoWindow").center();
			$("#addEdu-window").data("kendoWindow").open();
		});

	    //Step tab 정의..
	    var tabstrip = $("#tabstrip").kendoTabStrip({
	        animation:  {
	            open: {
	                effects: "fadeIn"
	            }
	        }
	    }).data("kendoTabStrip");
	    
	    
    }
}]);

//자격증 계획 제거
function deleteCert(certNum){
	if(dataSource_myCdp && dataSource_myCdp.data().length>0 && (dataSource_myCdp.data()[0].REQ_STS_CD=="1" || dataSource_myCdp.data()[0].REQ_STS_CD=="2")){
        //승인요청 또는 승인상태에는 제거안됨.
        var reqMsg = "";
        if(dataSource_myCdp.data()[0].REQ_STS_CD=="1"){
            reqMsg = "승인요청 중에는 수정할 수 없습니다.";
        }else{
            reqMsg = "승인된 계획은 수정할 수 없습니다.";
        }
        alert(reqMsg);
        return false;
    }else{
		var array = $("#certPlanGrid").data("kendoGrid").dataSource.data();
		var res = $.grep(array, function (e) {
	        return e.COMMONCODE == certNum;
	    });
		$("#certPlanGrid").data("kendoGrid").dataSource.remove(res[0]);
		$("#certGrid").data("kendoGrid").dataSource.insert(res[0]);
    }
}

//어학인증시험 목표점수 입력..
function setTargScoValue(commoncode){
    var array = $('#langPlanGrid').data('kendoGrid').dataSource.data();            
    var res = $.grep(array, function (e) {
        return e.COMMONCODE == commoncode;
    });
    res[0].TARG_SCO = $("#targSco_"+commoncode).val();
}

//어학 계획 제거
function deleteLang(langNum){
	if(dataSource_myCdp && dataSource_myCdp.data().length>0 && (dataSource_myCdp.data()[0].REQ_STS_CD=="1" || dataSource_myCdp.data()[0].REQ_STS_CD=="2")){
        //승인요청또는 승인상태에는 제거안됨.
        var reqMsg = "";
        if(dataSource_myCdp.data()[0].REQ_STS_CD=="1"){
            reqMsg = "승인요청 중에는 수정할 수 없습니다.";
        }else{
            reqMsg = "승인된 계획은 수정할 수 없습니다.";
        }
        alert(reqMsg);
        return false;
    }else{
		var array = $("#langPlanGrid").data("kendoGrid").dataSource.data();
		var res = $.grep(array, function (e) {
		    return e.COMMONCODE == langNum;
		});
		
		$("#langPlanGrid").data("kendoGrid").dataSource.remove(res[0]);
		$("#langGrid").data("kendoGrid").dataSource.insert(res[0]);
    }
}

//역량별 교육과정 목록 filter
function filterData(cn){
    var educmptgridDatasource = $("#eduCmpGrid").data('kendoGrid').dataSource;
    
    if(cn==-1){
    	educmptgridDatasource.filter({});
    }else{
    	educmptgridDatasource.filter({
            "field":"CMPNUMBER",
            "operator":"eq",
            "value":cn
        });
    }
}

//과정정보 상세보기.
function fn_detailView(subjectNum, cmpnumber){
    $('#detail_pane').show().html("");      
    
	var selectRow = new Object();
	var grid;
    
	grid = $("#eduCmpGrid").data("kendoGrid");
    
    var data = grid.dataSource.data();
    
    var res = $.grep(data, function (e) {
        return (e.SUBJECT_NUM == subjectNum && e.CMPNUMBER == cmpnumber);
    });

    var selectedCell = res[0];
    
    $("#dtl-subjectNum").val(selectedCell.SUBJECT_NUM);
    $("#dtl-cmpNumber").val(selectedCell.CMPNUMBER);
    $("#dtl-cmpName").val(selectedCell.CMPNAME);
    //$("#dtl-openNum").val(selectedCell.OPEN_NUM);
    
	//과정상세정보화면
	$('#detail_pane').show().html(kendo.template($('#eduDetailTemplate').html()));      
	// 상세영역 활성화
	$("#splitter").data("kendoSplitter").expand("#detail_pane");
    
    //과정 추가버튼 클릭 
    $("#addEduBtn").click(function(){
    	var array = $("#eduPlanGrid").data("kendoGrid").dataSource.data();
    	
    	var ares = $.grep(array, function (e) {
            return e.SUBJECT_NUM == $("#dtl-subjectNum").val();
        });
    	if(ares!=null && ares.length>0){
    		alert("이미 계획된 과정입니다.");
    		return false;
    	}
        
    	if(confirm("이 과정을 교육계획에 추가하시겠습니까?")){
    		$("#eduPlanGrid").data("kendoGrid").dataSource.insert({
    			SUBJECT_NUM: $("#dtl-subjectNum").val(),
    			//OPEN_NUM: $("#dtl-openNum").val(),
    			SUBJECT_NAME : selectRow.SUBJECT_NAME,
    			TRAINING_NM : selectRow.TRAINING_STRING,
    			ALW_STD_NM : selectRow.ALW_STD_NM,
    			CMPNUMBER : $("#dtl-cmpNumber").val(),
    			CMPNAME : $("#dtl-cmpName").val(),
    			DEPT_DESIGNATION_YN : selectRow.DEPT_DESIGNATION_YN,
    			DEPT_DESIGNATION_CD : selectRow.DEPT_DESIGNATION_CD,
    			DEPT_DESIGNATION_NM : selectRow.DEPT_DESIGNATION_NM,
    			RECOG_TIME_H : selectRow.RECOG_TIME_H,
    			RECOG_TIME_M : selectRow.RECOG_TIME_M,
    			RECOG_TIME : selectRow.RECOG_TIME,
    			PERF_ASSE_SBJ_CD : selectRow.PERF_ASSE_SBJ_CD,
    			PERF_ASSE_SBJ_NM : selectRow.PERF_ASSE_SBJ_NM
    		});
    		
    		alert("추가되었습니다.");
    		
    		//교육계획에 추가하고 인정시간 계산 다시 해줘야함..
    	}
    });
    
    //과정상세보기 취소버튼 클릭
    $("#cancelEduBtn").click(function(){
    		$("#splitter").data("kendoSplitter").toggle("#list_pane",true);
            $("#splitter").data("kendoSplitter").toggle("#detail_pane",false);
    });
    
    //과정상세정보 조회
    dataSource_eduDetail.read();
    dataSource_eduDetail.bind("change", function(){
    	if(dataSource_eduDetail != null){
            $.each(dataSource_eduDetail.data(), function(idx, item) {
                $.each(item,function(key,val){
                    selectRow[key] = val;
                });
            });
            detailSelected = selectRow;
            
            //상세데이터 바인딩..
            kendo.bind($("#tabular"), selectRow);
        }
    });
    
    // template에서 호출된 함수에 대한 이벤트 종료 처리.
    if (event.preventDefault) {
        event.preventDefault();
    } else {
        event.returnValue = false;
    }

}

//교육계획 희망년월 입력..
function setHopeymValue(subjectNum){
    var array = $('#eduPlanGrid').data('kendoGrid').dataSource.data();            
    var res = $.grep(array, function (e) {
        return e.SUBJECT_NUM == subjectNum;
    });
    res[0].HOPE_YYYYMM = $("#yyyymm_"+subjectNum).val();
}

//교육계획 제거
function deleteEdu(subjectNum){
	if(dataSource_myCdp && dataSource_myCdp.data().length>0 && (dataSource_myCdp.data()[0].REQ_STS_CD=="1" || dataSource_myCdp.data()[0].REQ_STS_CD=="2")){
        //승인요청또는 승인상태에는 제거안됨.
        var reqMsg = "";
        if(dataSource_myCdp.data()[0].REQ_STS_CD=="1"){
            reqMsg = "승인요청 중에는 수정할 수 없습니다.";
        }else{
            reqMsg = "승인된 계획은 수정할 수 없습니다.";
        }
        alert(reqMsg);
        return false;
    }else{
		if(confirm("교육계획에서 삭제하시겠습니까?")){
			var array = $("#eduPlanGrid").data("kendoGrid").dataSource.data();
			var res = $.grep(array, function (e) {
			    return e.SUBJECT_NUM == subjectNum;
			});
			
		    $("#eduPlanGrid").data("kendoGrid").dataSource.remove(res[0]);
	    }
    }
}

</script>

<style scoped>
    .demo-section {
        width: 170px;
        background:none;
    }
	.demo-section.style02 {width:175px;margin-left:5px;font-size:13px;}
	.demo-section.style02 {width:175px;margin-left:5px;}
	.k-input {padding-left:5px;}
	.demo-section.style03 {width:125px;font-size:13px;}
	.demo-section.style04 {width:253px;margin-left:5px;font-size:13px;}
	#addEdu {
	    text-align: center;
	    position: absolute;
	    white-space: nowrap;
	    cursor: pointer;
	}
	.k-window-title {font-size:13px;font-weight:bold;padding-left:20px;}
	.k-content {padding:20px !important}/*팝업 내부 콘텐츠 간격*/
	#tabstrip2 {
	    width: 1115px;
	}
	.k-link {font-weight:bold;font-size:13px;}
	#tabstrip {
	    width:1220px;
	}
	.k-link {font-weight:bold;}
	#tabstrip .k-content {padding:30px 30px 0 30px!important;}
	#tabstrip .tab_cont {}
	#jobInfo1 {
	    text-align: center;
	    position: absolute;
	    white-space: nowrap;
	    cursor: pointer;
	}
	.k-window-title {font-size:13px;font-weight:bold;}
	#hopeJob1-window .k-content {padding:25px 25px 20px 25px !important}/*팝업 내부 콘텐츠 간격*/
	
	#jobInfo2 {
	    text-align: center;
	    position: absolute;
	    white-space: nowrap;
	    cursor: pointer;
	}
	.k-window-title {font-size:13px;font-weight:bold;}
	#pop02 .k-content {padding:25px 25px 20px 25px !important}/*팝업 내부 콘텐츠 간격*/
</style> 
</head>
<body>
    <form id="frm" name="frm"  method="post" >
        <input type="hidden" name="rn" id="rn" value="<%=request.getParameter("rn")%>"/>
        <input type="hidden" name="tu" id="tu" value="<%=action.getUser().getUserId()%>" />
        <input type="hidden" name="year" id="year" value="<%=request.getParameter("year")%>"/>
        <input type="hidden" name="evlRunNum" id="evlRunNum"/>
        <input type="hidden" id="dtl-subjectNum" />
        <input type="hidden" id="dtl-cmpNumber" />
        <input type="hidden" id="dtl-cmpName" />
        <!-- <input type="hidden" id="dtl-openNum" /> -->
    </form>

	<div class="container">
		<div id="cont_body">
			<div class="content">
				<div class="top_cont">
					<h3 class="tit01">계획수립</h3>
		            <div class="location">
		                <span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
		                <span>경력개발계획&nbsp; &#62;</span>
		                <span class="h">계획수립</span>
		            </div>
	            </div>
				<div class="sub_cont tab_sub_cont">
					<div id="details" style="padding-left: 30px; height:1380px;"></div>
				</div>
			</div><!--//content-->
		</div><!--//cont_body-->
	</div><!--//container-->

<script type="text/x-kendo-template"  id="template"> 
                <div id="tabstrip">
                    <ul>
                        <li class="k-state-active">STEP01</li>
                        <li>STEP02</li>
                    </ul>
                    <div class="tab_cont" id="cdpContents">
                        <div class="d_step s01">
                            <div class="step_tit">경력목표수립</div>
                            <strong>STEP01. 경력목표수립</strong>
                            <div class="des">
                                경력개발계획의 1 단계인 경력목표수립입니다.<br/>
                                올해/장기목표 수립,  희망 직무/부서 설정 및 올해의 자격증, 어학 취득 목표를 설정합니다.
                            </div>
                        </div>
                        <h4 class="mt30">올해목표</h4>
                        <div class="goal_inp">
                            <textarea id="yyyyTarg" cols="18" rows="2" class="textarea01" title="올해목표입력란"></textarea>
                        </div>
                        <h4 class="mt30">장기목표</h4>
                        <div class="goal_inp">
                            <textarea id="longTarg" cols="18" rows="2" class="textarea01" title="장기목표입력란"></textarea>
                        </div>
                        <ul class="select_Area01 mt30">
                            <li class="tit"><label for="combobox">희망직무1</label></li>
                            <li>
                                <div class="demo-section k-header style02">
                                    <select id="hopeJob1" style="width: 175px" ></select>
                                </div>
                            </li>
                            <li>
                                <span id="jobInfo1" class="k-button btn_style01">직무정보보기</span>
                            </li>
                        </ul>
                        <ul class="select_Area01 mt25">
                            <li class="tit"><label for="combobox2">희망직무2</label></li>
                            <li>
                                <div class="demo-section k-header style02">
                                    <select id="hopeJob2" style="width: 175px" ></select>
                                </div>
                            </li>
                            <li>
                                <span id="jobInfo2" class="k-button btn_style01">직무정보보기</span>
                            </li>
                        </ul>
                        <ul class="select_Area01 mt25">
                            <li class="tit"><label for="">희망부서</label></li>
                            <li>
                                <input id="dvsName" type="text" class="k-textbox inp_style01" value="" style="width:200px;" readOnly/>
                                <input type="hidden" id="divisionid" data-bind="value:DIVISIONID"  />
                            </li>
                            <li><button button id="deptSearchBtn" class="btn_style02 k-button" >검색</button><button id="clearDeptBtn" class="k-button btn_style03" >X</button></li>
                        </ul>
                        <h4 class="mt30 mb15">자격증 취득 계획</h4>
                        <div class="plan01_wp">
                            <ul>
                                <li class="fir">
                                    <div id="certGrid"></div>
                                    * 자격증목록을 클릭하여 선택 후 오른쪽 화살표를 클릭합니다.
                                </li>
                                <li class="btn"><img id="addCertBtn" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_arrow03.png" style="cursor:pointer;" alt="화살표"></li>
                                <li class="last">
                                    <div id="certPlanGrid"></div>
                                </li>
                            </ul>
                        </div><!--//plan01_wp-->
                        <h4 class="mt30 mb15">어학 취득 계획</h4>
                        <div class="plan01_wp">
                            <ul>
                                <li class="fir">
                                    <div id="langGrid"></div>
                                    * 어학인증시험을 클릭하여 선택 후 오른쪽 화살표를 클릭합니다.
                                </li>
                                <li class="btn"><img id="addLangBtn" src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_arrow03.png" style="cursor:pointer;" alt="화살표"></li>
                                <li class="last">
                                    <div id="langPlanGrid"></div>
                                </li>
                            </ul>
                        </div><!--//plan01_wp-->
                        <div class="btn_right mb20">
                            <button id="cancelStep1" class="k-button" style="width:60px;">취소</button>
                            <button id="nextStep" class="k-button" style="width:100px;">다음단계</button>
                            <button id="tmpReqAppr1" class="k-button" style="width:100px;">임시저장</button>
                            <button id="reqAppr1" class="k-primary k-button" style="width:100px;">승인요청</button>
                        </div>
                    </div><!--//tab_cont1-->
                    <div class="tab_cont">
                        <div class="d_step s02">
                            <div class="step_tit">교육계획수립</div>
                            <strong>STEP01. 교육계획수립</strong>
                            <div class="des">
                                경력개발계획의 2 단계인 교육계획수립입니다.<br/>
                                교육계획수립은 일반검색, 역량진단결과에 따라 수립할 수 있으며 교육 계획 시간을 충족해야 합니다.
                            </div>
                        </div>
                        <h4 class="mt30">나의 필수 계획시간</h4>
                         <div class="state_wrap">
                            <dl class="accordion">
                                <dt class="ico_plus">
                                    <span class="satisfy_tit">필수 계획 현황</span>
                                    <span id="isEnoughReqNm" class="satisfy_txt mr140">
                                    </span>
                                    <span class="satisfy_tit">기관성과평가 계획 현황</span>
                                    <span class="satisfy_txt">
                                        <span id="isEnoughPerfNm" class="no"></span>
                                    </span>
                                </dt>
                                <dd>
                                    <h5>필수 계획 현황</h5>
                                    <div class="table_wp02">
                                        <table class="table_type02">
                                            <caption>필수 계획 현황</caption>
                                            <colgroup id="reqColGroup">
                                            </colgroup>
                                            <thead>
                                                <tr id="reqTheadTr1">
                                                </tr>
                                            </thead>
                                            <tbody id="reqTbody">
                                            </tbody>
                                        </table>
                                    </div>
                                    <p class="point">※ 부처지정학습은 총시간의 40%이며, 40% 중 25%는 국정철학및공직관이며 15%는 직무역량과정이여야 합니다. </p>
                                    <h5>기관성과평가 계획 현황</h5>
                                    <div class="table_wp02">
                                        <table class="table_type02">
                                            <caption기관성과평가 계획 현황</caption>
                                            </colgroup>
                                            <thead>
                                                <tr id="perfTheadTr">
                                                </tr>
                                            </thead>
                                            <tbody id="perfTbody">
                                            </tbody>
                                        </table>
                                    </div>
                                </dd>
                            </dl>
                        </div>
                        <div class="title">교육계획목록 
                            <span id="addEdu" class="k-button btn_add01">교육추가</span>
                        </div>
                        <div id="eduPlanGrid"></div>
                        <div class="btn_right mb20">
                            <button id="cancelStep2" class="k-button" style="width:60px;">취소</button>
                            <button id="beforeStep" class="k-button" style="width:100px;">이전단계</button>
                            <button id="tmpReqAppr2" class="k-button" style="width:100px;">임시저장</button>
                            <button id="reqAppr2" class="k-primary k-button" style="width:100px;">승인요청</button>
                        </div>
                    </div><!--//tab_cont2-->
                </div><!--//tabstrip-->
</script>

<!--직무확인 팝업 시작-->
<div id="hopeJob1-window" style="display:none; overflow-y: hidden;">
    <ul class="select_Area02">
        <li class="tit fir">직무명</li>
        <li class="txt">
            <input id="hopeJobNm" type="text" class="k-textbox inp_style02" value="" style="width:240px;" title="직무명" readOnly/>
        </li>
    </ul>
    <ul class="select_Area02">
        <li class="tit">직무정의</li>
        <li class="txt">
            <textarea id="hopeJobDef" class="k-textbox" style="width:240px;height:100px;" readOnly></textarea>
        </li>
    </ul>
    <ul class="select_Area02">
        <li class="tit">주요업무</li>
        <li class="txt">
            <textarea id="hopeJobTask" class="k-textbox" style="width:240px;height:100px;" readOnly></textarea>
        </li>
    </ul>
    <div class="pop_btn_right"><button id="hopeJobOKBtn" class="btn_style02 mt5 k-button">확인</button></div>
</div>
<!--//직무확인 팝업 끝-->

<!-- 교육추가 팝업 시작-->
<div id="addEdu-window" style="display:none; overflow-y: hidden;">
    
    <div id="tabstrip2" style="width: 1243px;">
            <ul>
                <li class="k-state-active">역량진단</li>
            </ul>
            <div class="tab_cont">
                <ul class="select_Area03 mt10">
                    <li class="tit">진단명</li>
                    <li id="evlRunList" style="padding-top: 3px;"></li>
                </ul>
                 <p class="point2 mt10">※ 역량별 취득 점수 클릭 시 해당 역량을 개발하기 위한 과정이 검색됩니다.</p>
                <div id="example" style="width: 1184px;height: 130px;" class="mt10">
                    <div id="cmptgrid" data-bind="source: gridRows" style="width: 1184px; height: 121px;"></div>
                </div>
                <ul class="select_Area03 mt20">
                    <li class="tit">교육 목록</li>
                </ul>
                 <p class="point2 mt10">※ 과정명을 클릭하면 과정의 상세 정보를 열람할 수 있으며, 계획에 추가할 수 있습니다.</p>
                 <div id="splitter" style="width:1184px; height: 450px; border:none;" class="mt10">
                    <div id="list_pane">
                        <div id="eduCmpGrid"></div>
                    </div>
                    <div id="detail_pane">
                        
                    </div><!--//detail_pane-->
                </div>
                
            </div><!--//tab_cont1-->
            <!-- 
            <div class="tab_cont">
                <p class="point2 ">※ 과정명을 클릭하면 과정의 상세 정보를 열람할 수 있으며, 계획에 추가할 수 있습니다.</p>
                 <div id="splitter2" style="width:1184px; height: 445px; border:none;" class="mt10">
                    <div id="list_pane2">
                        <div id="eduNorGrid" ></div>
                    </div>
                    <div id="detail_pane2">
                    </div>//detail_pane
                </div>
            </div>//tab_cont2 -->
            
        </div>

        <button class="k-button k-primary" id="eduPopCloseBtn" style="position: absolute; top: 24px; left: 1210px;"  > 닫기 </button>
</div><!--//addEdu-window-->
<!--//교육추가 팝업 끝-->

<!-- 희망부서 선택 팝업 -->
<div id="dept-window" style="display: none;">
    <div style="width: 100%">
      <table style="width: 100%;">
        <tr>
            <td>
                <div id="deptPopupTreeview"   style="width: 100%; height: 200px; "></div>
                <div style="text-align: right; padding : 10px 10px 0px 0px; ">
                    <button id="selectDeptBtn" class="k-button btn_style03" >선택</button>
                </div>
            </td>
        </tr>
      </table>
    </div>
</div>
<!--//희망부서 선택 팝업끝 -->

<script type="text/x-kendo-template"  id="eduDetailTemplate"> 
                        <div id="tabular" class="detail_Info">
                            <div class="tit">과정상세정보</div>
                            <div class="pop_dl_wrap">
                                <div class="btn_top">
                                    <button id="addEduBtn" class="k-primary k-button" style="width:88px;">계획추가</button>
                                    <button id="cancelEduBtn" class="k-button" style="width:88px;">닫기</button>

                                </div>
                                <dl>
                                    <dt class="fir">학습유형</dt>
                                    <dd class="fir"><span data-bind="text:TRAINING_STRING" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 과정명 </dt>
                                    <dd><span data-bind="text:SUBJECT_NAME" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 상시학습종류 </dt>
                                    <dd><span data-bind="text:ALW_STD_NM" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 인정시간 </dt>
                                    <dd><span data-bind="text:RECOG_TIME" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 목적 </dt>
                                    <dd><span data-bind="text:EDU_OBJECT" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 내용 </dt>
                                    <dd><span data-bind="text:COURSE_CONTENTS" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 대상 </dt>
                                    <dd><span data-bind="text:EDU_TARGET" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 교육기관 </dt>
                                    <dd><span data-bind="text:INSTITUTE_NAME" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 부처지정학습 </dt>
                                    <dd><span data-bind="text:DEPT_DESIGNATION_YN_NM" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt class="line"> 기관성과평가필수교육 </dt>
                                    <dd class="noline"><span data-bind="text:PERF_ASSE_SBJ_NM" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 교육시간구분 </dt>
                                    <dd><span data-bind="text:OFFICETIME_NM" ></span>&nbsp;</dd>
                                </dl>
                                <dl>
                                    <dt> 교육기관구분 </dt>
                                    <dd><span data-bind="text:EDUINS_DIV_NM" ></span>&nbsp;</dd>
                                </dl>
                            </div>
                        </div>
</script>

<!-- 승인요청 팝업. -->
<%@ include file="/includes/jsp/user/common/apprReqPopup.jsp"  %>
</body>
</html>