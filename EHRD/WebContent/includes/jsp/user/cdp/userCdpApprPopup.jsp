<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    
<link href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css" rel="stylesheet" />
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/common.js"></script>
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js"></script>
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js"></script>
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js"></script>
<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js"></script>

<script type="text/javascript">

	var reqApprCompleteCallbackFunc;
	/*
		경력개발계획 계획승인 팝업
		param runNum : 경력개발계획 번호
		prram reqUserid : 승인요청자 번호
	*/
	function cdpApprOpen(runNum, reqUserid, reqNum, reqLineSeq, reqStsCd)
	{
			
		$("#reqUserid").val(reqUserid);
		$("#runNum").val(runNum);
		$("#reqNum").val(reqNum);
		$("#reqLineSeq").val(reqLineSeq);
		
		if(reqStsCd == 1){
			$("#approvalBtn_n").attr("style", "display:;");
			$("#approvalBtn_y").attr("style", "display:;");
		}else{
			$("#approvalBtn_n").attr("style", "display:none;");
			$("#approvalBtn_y").attr("style", "display:none;");
		}
		
		if( !$("#cdpAppr").data("kendoWindow") ){
			$("#cdpAppr").kendoWindow({
				width:"1000px",
				height:"800px",
				resizable : true,
				title : "계획승인",
				modal: true,
				visible: false
			});
			

	        $("#approvalBtn_n").click(function(){
	            
	            if(confirm("미승인 하시겠습니까?")){
	                $.ajax({
	                    type : 'POST',
	                    dataType : "json",
	                    url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_appr_req.do?output=json",
	                    data : { 
	                                req_userid : $("#reqUserid").val(), 
	                                reqNum : $("#reqNum").val(), 
	                                runNum : $("#runNum").val(),
	                                req_lineSeq : $("#reqLineSeq").val(),
	                                comment : $("#COMMENT").text(),
	                                gubun : "N"
	                    },
	                    complete : function( response ){
	                        
	                        var obj = eval("(" + response.responseText + ")");
	                        if(obj.error){
	                             alert("ERROR=>"+obj.error.message);
	                        }else{
	                            if(obj.saveCount > 0){
	                                alert("미승인 되었습니다.");
	                                $("#cdpAppr").data("kendoWindow").close();
	                                
	                                //승인요청건 승인/미승인 완료 후 각 업무단에서 처리할 함수 callback..
	                                if(reqApprCompleteCallbackFunc){
	                                    reqApprCompleteCallbackFunc($("#reqNum").val());
	                                }
	                            }else{
	                                alert("실패 하였습니다.");
	                            }
	                        }
	                    },
	                    error: function( xhr, ajaxOptions, thrownError){
	                        //로딩바 제거
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
	                });//End $.ajax
	                
	            }
	        });
	        
	        $("#approvalBtn_y").click(function(){
	            if(confirm("승인 하시겠습니까?")){
	                
	                $.ajax({
	                    type : 'POST',
	                    dataType : "json",
	                    url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/cdp_plan_appr_req.do?output=json",
	                    data : { 
	                                req_userid : $("#reqUserid").val(), 
	                                reqNum : $("#reqNum").val(),
	                                sbjctNum : $("#sbjctNum").val(),
	                                runNum : $("#runNum").val(),
	                                req_lineSeq : $("#reqLineSeq").val(),
	                                comment : $("#COMMENT").text(),
	                                gubun : "Y"
	                    },
	                    complete : function( response ){
	                        
	                        var obj = eval("(" + response.responseText + ")");
	                         if(obj.error){
	                             alert("ERROR=>"+obj.error.message);
	                         }else{
	                             if(obj.saveCount > 0){
	                                 alert("승인 되었습니다.");
	                                 $("#cdpAppr").data("kendoWindow").close();
	                                 
	                                 //승인요청건 승인/미승인 완료 후 각 업무단에서 처리할 함수 callback..
	                                 if(reqApprCompleteCallbackFunc){
	                                     reqApprCompleteCallbackFunc($("#reqNum").val());
	                                 }
	                             }else{
	                                 alert("실패 하였습니다.");
	                             }
	                         }

	                    },
	                    error: function( xhr, ajaxOptions, thrownError){

	                        //로딩바 제거
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
	                });//End $.ajax
	                
	            }
	        });
	    
	        $("#closeBtn").click(function(){
	            $("#cdpAppr").data("kendoWindow").close();
	        });
	        
		}
		
		var dataSource_apprInfo = new kendo.data.DataSource({
			
			type: "json",
			transport: {
				read: {url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_cdp_plan_appr_reqinfo.do?output=json", type:"POST" },
				parameterMap: function (options, operation){
	                return {req_userid : $("#reqUserid").val(), runNum : runNum};
	            }
			},
			schema: {
				data: "items",
				model: {
					fields: {
						RUN_NUM : { type: "number" },
						RUN_NAME : { type: "string" },
						USERID : { type: "number" },
						NAME : { type: "string" },
						REQ_STS_CD : { type: "string" },
						REQ_STS_CD_NAME : { type: "string" },
						HOPE_JOB_CD1 : { type: "string" },
						HOPE_JOB_NAME1 : { type: "string" },
						HOPE_JOB_CD2 : { type: "string" },
						HOPE_JOB_NAME2 : { type: "string" },
						HOPE_DIVISIONID : { type: "string" },
						HOPE_DVS_NAME : { type: "string" },
						YYYY_TARG : { type: "string" },
						LONG_TARG : { type: "string" },
						REQ_REMARKS : { type: "string" }
					}
				}
			},
			serverFiltering: false,
	        serverSorting: false
		});
		
		dataSource_apprInfo.bind("change", function(){
			$.each(dataSource_apprInfo.data(), function(i,e){
				$("#YYYY_TARG").val(e.YYYY_TARG);
				$("#LONG_TARG").val(e.LONG_TARG);
				$("#HOPE_JOB_1").text(e.HOPE_JOB_NAME1);
				$("#HOPE_JOB_2").text(e.HOPE_JOB_NAME2);
				$("#HOPE_DVS").text(e.HOPE_DVS_NAME);
				if(e.REQ_REMARKS == null || e.REQ_REMARKS == ""){
					$("#COMMENT").text('');
				}else{
					$("#COMMENT").text(e.REQ_REMARKS);
				}
			});
		});

		dataSource_apprInfo.read();
		
		var grid_cert = $("#grid_cert").kendoGrid({ 
			dataSource: {
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_cdp_plan_appr_reqinfo_cert.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){ 
                            return { 
                            	req_userid : $("#reqUserid").val(),
                            	runNum : $("#runNum").val()
                            };
                        }        
                    },
                    schema: {
                        total: "totalItemCount",
                        data: "items",
                           model: {
                               fields: {
                                   RUN_NUM  : { type: "int" },
                                   USERID : {type:"int"},
                                   CERT_CD : {type:"string"},
                                   CERT_CD_NAME : { type:"string" }
                               }
                           }
                    }
                },
                height: 120,
                groupable: false,
                columns: [
                    {
                        field:"CERT_CD_NAME",
                        title: "자격증명",
                        width: 100,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    }                
                ]
            }).data("kendoGrid");	
        
        var grid_lang = $("#grid_lang").kendoGrid({ 
               dataSource: {
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_cdp_plan_appr_reqinfo_lang.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){ 
                            return { 
                            	req_userid : $("#reqUserid").val(),
                            	runNum : $("#runNum").val()
                            };
                        }        
                    },
                    schema: {
                        total: "totalItemCount",
                        data: "items",
                        model: {
                            fields: {
								RUN_NUM  : { type: "int" },
								USERID : {type:"int"},
								LANG_CD : {type:"string"},
								LANG_CD_NAME : { type:"string" },
								TARG_SCO : { type:"string" }
                            }
                        }
                    }
                },
                height: 120,
                groupable: false,
                columns: [{
                        field:"LANG_CD_NAME",
                        title: "어학명",
                        width: 100,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    },{
                        field:"TARG_SCO",
                        title: "목표점수",
                        width: 100,
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"}
                    }]
            }).data("kendoGrid");		
		
        var grid_edu = $("#grid_edu").kendoGrid({
               dataSource: {
                    type: "json",
                    transport: {
                        read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_cdp_plan_appr_reqinfo_edu.do?output=json", type:"POST" },
                        parameterMap: function (options, operation){ 
                            return { 
                            	req_userid : $("#reqUserid").val(),
                            	runNum : $("#runNum").val()
                            };
                        }        
                    },
                    schema: {
                        total: "totalItemCount",
                        data: "items",
                           model: {
                               fields: {
                                   RUN_NUM  : { type: "int" },
                                   USERID : {type:"int"},
                                   SUBJECT_NUM : {type:"string"},
                                   SUBJECT_NAME : {type:"string"}
                               }
                           }
                    }
                },
                height: 500,
                groupable: false,
                sortable: true,
                resizable: true,
                reorderable: true,
                columns: [
                    {
                     field:"SUBJECT_NAME",
                     title: "과정명",
                     width: 340,
                     filterable: true,
                     headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                     attributes:{"class":"table-cell", style:"text-align:left"}
                 }, {
                     field: "TRAINING_NM",
                     headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                     attributes : {"class":"table-cell", style:"text-align:center"},
                     title: "학습유형",
                     width:80
                 }, {
                     field: "RECOG_TIME",
                     headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                     attributes : {"class":"table-cell", style:"text-align:center"},
                     title: "인정시간",
                     width:100
                 }, {
                     field: "DEPT_DESIGNATION_YN",
                     headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                     attributes : {"class":"table-cell", style:"text-align:center"},
                     title: "부처지정학습",
                     width:100
                 }, {
                     field: "HOPE_YYYYMM",
                     headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                     attributes : {"class":"table-cell", style:"text-align:center"},
                     title: "희망교육월",
                     width:100 
                 }, {
                     field: "CMPNAME",
                     headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                     attributes : {"class":"table-cell", style:"text-align:center"},
                     title: "학습역량",
                     width:160
                 }, {
                     field: "SCORE_STRI",
                     headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
                     attributes : {"class":"table-cell", style:"text-align:center"},
                     title: "학습역량 최근점수",
                     width:150
                 }
                    ]
            }).data("kendoGrid");
        
		grid_edu.dataSource.read();
		grid_cert.dataSource.read();
		grid_lang.dataSource.read();
		
	    
	    //Step tab 정의..
	    $("#tabstrip2").kendoTabStrip({
	        animation:  {
	            open: {
	                effects: "fadeIn"
	            }
	        },
            activate: onActivateTabstrip
	    }).data("kendoTabStrip");
	
		$("#cdpAppr").data("kendoWindow").center();
		$("#cdpAppr").data("kendoWindow").open();

	}
	

    function onActivateTabstrip(e){
        if(e.item.innerText == "교육계획"){
            $("#grid_edu").data("kendoGrid").resize();
        }else{
            
        }
    }
    
</script>
<style scoped>
	#cdpPlan-window .k-window-title {font-size:13px;font-weight:bold;}
	.k-link {font-weight:bold;font-size:13px;}
	#tabstrip2 {width: 940px;}
	
</style>
<!--팝업 코딩 시작-->
<div id="cdpAppr" style="display: none;">
	<input type="hidden" name="reqUserid" id="reqUserid" />  <!-- 승인요청자 번호-->
	<input type="hidden" name="runNum" id="runNum" /> <!-- 경력개발 번호-->
	<input type="hidden" name="sbjctNum" id="sbjctNum" /> <!-- 경력개발 번호-->
	<input type="hidden" name="reqNum" id="reqNum" /> <!-- 승인요청 번호-->
	<input type="hidden" name="reqLineSeq" id="reqLineSeq" /> <!-- 승인요청 순번-->
				
	<!--팝업 코딩 시작-->
	<div id="pop01">
		<div id="tabstrip2" style="margin-left: 20px;">
			<ul>
				<li class="k-state-active">경력목표</li>
				<li>교육계획</li>
			</ul>
	
			<div class="tab_cont">
				<div class="d_step s01">
					<div class="step_tit">경력목표</div>
					<strong>STEP01. 경력목표</strong>
					<div class="des">
						경력개발계획의 1 단계인 경력목표입니다.<br/>
					</div>
				</div>
	
				<h4 class="mt30 g_tit">올해목표</h4>
				<div class="goal_inp">
					<textarea onFocus="this.blur()" id="YYYY_TARG" cols="18" rows="2" class="g_textarea" readonly></textarea>
				</div>
				
				<h4 class="mt30 g_tit">장기목표</h4>
				<div class="goal_inp">
					<textarea onFocus="this.blur()" id="LONG_TARG" cols="18" rows="2" class="g_textarea" readonly></textarea>
				</div>
				
				<ul class="select_Area01 mt10">
					<li class="tit"><label for="combobox">희망직무1</label></li>
					<li id="HOPE_JOB_1"></li>
				</ul>
				<ul class="select_Area01 mt10">
					<li class="tit"><label for="combobox2">희망직무2</label></li>
					<li id="HOPE_JOB_2"></li>
				</ul>
				<ul class="select_Area01 mt10">
					<li class="tit"><label for="">희망부서</label></li>
					<li id="HOPE_DVS"></li>
				</ul>	
				
				<div class="g_tit mt30 mb10">자격증 취득 계획 <div class="r_tit">어학 취득 계획</div></div>
				<div class="g_plan01_wp">
					<ul>
						<li class="fir">
							<div id="grid_cert"></div>
						</li>
						<li class="btn"></li>
						<li class="last">
							<div id="grid_lang"></div>
						</li>
					</ul>
				</div><!--//g_plan01_wp-->
			</div><!--//tabstrip2-->
			
			<div class="tab_cont">
				<div class="d_step s02">
					<div class="step_tit">교육계획</div>
					<strong>STEP02. 교육계획</strong>
					<div class="des">
						경력개발계획의 2 단계인 교육계획입니다.<br/>
					</div>
				</div>	
				<div class="g_tit mt30 mb15">교육계획</div>
				<div id="grid_edu"></div>
			</div><!--//tabstrip2-->
			</div><!--//tab_cont1-->
		
		<div class="btn_right mb20">
			<button id="approvalBtn_y" class="k-button k-primary" style="width:90px; ">승인</button>
			<button id="approvalBtn_n" class="k-button k-primary" style="width:90px; ">미승인</button>
			<button id="closeBtn" class="k-button" style="width:60px; margin-right: 20px;">창닫기</button>
		</div>
	</div><!--//pop01-->
</div><!--//cdpAppr-->
