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
		경력개발계획 계획수립 현황 팝업
		param runNum : 경력개발계획 번호
		prram reqUserid : 승인요청자 번호
	*/
	function cdpPlanOpen(runNum, reqUserid, reqNum)
	{
			
		var msg = "계획되지 않았습니다.";
			
		$("#YYYY_TARG").val(msg);	
		$("#LONG_TARG").val(msg);
		$("#HOPE_JOB_1").text(msg);
		$("#HOPE_JOB_2").text(msg);
		$("#HOPE_DVS").text(msg);
		
		$("#reqUserid").val(reqUserid);
		$("#runNum").val(runNum);
		
		if( !$("#cdpPlan").data("kendoWindow") ){
			$("#cdpPlan").kendoWindow({
				width:"1000px",
				height:"650px",
				resizable : true,
				title : "경력개발 계획 수립현황",
				modal: true,
				visible: false
			});
		}
		
		
		var dataSource_apprInfo = new kendo.data.DataSource({
			
			type: "json",
			transport: {
				read: {url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_cdp_plan_appr_reqinfo.do?output=json", type:"POST" },
				parameterMap: function (options, operation){    
	                return {req_userid : $("#reqUserid").val(), runNum : $("#runNum").val()};
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
			tabstrip2.select(0);
			$.each(dataSource_apprInfo.data(), function(i,e){
				$("#YYYY_TARG").val(e.YYYY_TARG);
				$("#LONG_TARG").val(e.LONG_TARG);
				$("#HOPE_JOB_1").text(e.HOPE_JOB_NAME1);
				$("#HOPE_JOB_2").text(e.HOPE_JOB_NAME2);
				$("#HOPE_DVS").text(e.HOPE_DVS_NAME);
				$("#_hopeJobCd1").val(e.HOPE_JOB_CD1);
				$("#_hopeJobCd2").val(e.HOPE_JOB_CD2);
			});
		});

		dataSource_apprInfo.read();
        
		/*
			자격증계획
		*/		
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
        
        /*
    		어학계획
    	*/
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
             columns: [
                 {
                     field:"LANG_CD_NAME",
                     title: "어학명",
                     width: 100,
                     filterable: true,
                     headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                     attributes:{"class":"table-cell", style:"text-align:center"}
                 },                
                 {
                     field:"TARG_SCO",
                     title: "목표점수",
                     width: 100,
                     filterable: true,
                     headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                     attributes:{"class":"table-cell", style:"text-align:center"}
                 }                
             ]
         }).data("kendoGrid");	        
        
        $("#tabstrip2").kendoTabStrip({
            animation:  {
                open: {
                    effects: "fadeIn"
                }
            },
            activate: onActivateTabstrip
        });
        
        /*
        	교육계획
        */
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
                                SUBJECT_NAME : {type:"string"},
                                HOPE_YYYYMM : { type:"string" },
                                HOPE_YYYYMM3 : { type:"date" }
                            }
                        }
                 }
             },
             height: 320,
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
        
        grid_cert.dataSource.read();
        grid_lang.dataSource.read();
        grid_edu.dataSource.read();
        
        
        //다음단계 클릭 시
        $("#nextStep").click(function(){
        	tabstrip2.select(1);

        	if (event.preventDefault) {
                event.preventDefault();
            } else {
                event.returnValue = false;
            }
        });

        //이전단계 클릭 시
        $("#beforeStep").click(function(){
            tabstrip2.select(0);
        });
        
        $("#closeBtn1, #closeBtn2").click(function(){
            $("#cdpPlan").data("kendoWindow").close();
        });
        
        
	    //Step tab 정의..
	    var tabstrip2 = $("#tabstrip2").kendoTabStrip({
	        animation:  {
	            open: {
	                effects: "fadeIn"
	            }
	        }
	    }).data("kendoTabStrip");
	    
	    
	    
	    
	    var hopeArray;
	    
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
        
        dataSource_hopeJob1.fetch(function(){
        	hopeArray = dataSource_hopeJob1.data();
        });   
        
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
            
            var items = $.grep(hopeArray, function(item, idx){
            	if(item.JOBLDR_NUM == $("#_hopeJobCd1").val()) {
            		return item;
            	} else {
            		return null;
            	}
            });
           
            var obj;
            
            if(items!=null && items.length>0) {
            	obj = items[0];
            }
            
            //alert(JSON.stringify(obj));
            
            if(obj.JOBLDR_NUM==null){
            	alert("희망직무1을 선택해주세요.");
            	return false;
            }else{
            	$("#hopeJobNm").val(obj.JOBLDR_NAME);
            	$("#hopeJobDef").val(obj.JOBLDR_COMMENT);
            	$("#hopeJobTask").val(obj.MAIN_TASK);
                
            	hopeJob_window.data("kendoWindow").center();
                hopeJob_window.data("kendoWindow").open();
            }
            
        });


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
            
            var items = $.grep(hopeArray, function(item, idx){
            	if(item.JOBLDR_NUM == $("#_hopeJobCd2").val()) {
            		return item;
            	} else {
            		return null;
            	}
            });
           
            var obj;
            
            if(items!=null && items.length>0) {
            	obj = items[0];
            }
            
            if(obj.JOBLDR_NUM==null){
                alert("희망직무2를 선택해주세요.");
                return false;
            }else{
                $("#hopeJobNm").val(obj.JOBLDR_NAME);
                $("#hopeJobDef").val(obj.JOBLDR_COMMENT);
                $("#hopeJobTask").val(obj.MAIN_TASK);
                
                hopeJob_window.data("kendoWindow").center();
                hopeJob_window.data("kendoWindow").open();
            }
        });
		
		$("#cdpPlan").data("kendoWindow").center();
		$("#cdpPlan").data("kendoWindow").open();
        
	}
	
	
	
</script>
<style scoped>
	#cdpPlan-window .k-window-title {font-size:13px;font-weight:bold;}
	
</style>
<!--팝업 코딩 시작-->
<div id="cdpPlan" style="display: none;">
<input type="hidden" name="reqUserid" id="reqUserid" />  <!-- 승인요청자 번호-->
<input type="hidden" name="runNum" id="runNum" /> <!-- 경력개발 번호-->
<input type="hidden" name="_hopeJobCd1" id="_hopeJobCd1" /> <!-- 경력개발 번호-->
<input type="hidden" name="_hopeJobCd2" id="_hopeJobCd2" /> <!-- 경력개발 번호-->
				
<!--팝업 코딩 시작-->
<div id="pop03">
	
	<div id="tabstrip2" style="margin:15px;">
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
					<textarea wrap="hard" readonly="readonly" onFocus="this.blur()" id="YYYY_TARG" cols="18" rows="2" class="g_textarea" title="올해목표입력란"></textarea>
				</div>
				
				<h4 class="mt30 g_tit">장기목표</h4>
				<div class="goal_inp">
					<textarea readonly="readonly" onFocus="this.blur()" id="LONG_TARG" cols="18" rows="2" class="g_textarea" title="장기목표입력란"></textarea>
				</div>	
					
				<ul class="select_Area01 mt30">
					<li class="tit"><label for="combobox">희망직무1</label></li>
					<li id="HOPE_JOB_1" style="padding-right:15px;"></li>
					
					<li>
                        <span id="jobInfo1" class="k-button btn_style01">직무정보보기</span>
                    </li>
				</ul>
				

				<ul class="select_Area01 mt25">
					<li class="tit"><label for="combobox2">희망직무2</label></li>
					<li id="HOPE_JOB_2" style="padding-right:15px;"></li>
					<li>
		            	<span id="jobInfo2" class="k-button btn_style01">직무정보보기</span>
		            </li>
				</ul>
				<ul class="select_Area01 mt25">
					<li class="tit"><label for="">희망부서</label></li>
					<li id="HOPE_DVS"></li>
				</ul>	
				
				<div class="g_tit mt30 mb15">자격증 취득 계획 <div class="r_tit">어학 취득 계획</div></div>
				<div class="g_plan01_wp">
					<ul>
						<li class="fir">
							<div id="grid_cert"></div>
						</li>
						<li class="btn"><!--<img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_arrow03.png" alt="화살표">--></li>
						<li class="last">
							<div id="grid_lang"></div>
						</li>
					</ul>
				</div><!--//g_plan01_wp-->
				
				<div class="btn_right mb20">
					<button id="nextStep" class="k-primary k-button" style="width:150px;">다음단계</button>
					<button id="closeBtn1" class="k-button" style="width:60px;">창닫기</button>
				</div>
																		
	
		</div><!--//tab_cont1-->
		
		<div class="tab_cont">
			<div class="d_step s02">
				<div class="step_tit">교육계획</div>
				<strong>STEP02. 교육계획</strong>
				<div class="des">
					경력개발계획의 2 단계인 교육계획입니다.<br/>
				</div>
			</div>	
				
			<div class="g_tit mt30 mb15">교육계획</div>
			<div id="grid_edu" style="height: 220px;" ></div>
			<div class="btn_right mb20">
				<button id="beforeStep"  class="k-primary k-button" style="width:100px;">이전단계</button>
				<button id="closeBtn2" class="k-button" style="width:60px;">창닫기</button>
			</div>		
				
		</div><!--//tab_cont1-->		
		
		</div>

		<style scoped>
			#tabstrip2 {
				width: 940px;
			}
			
			.k-link {font-weight:bold;font-size:13px;}
			
		</style>
		
		<script>

			
			function onActivateTabstrip(e){
	            if(e.item.innerText == "교육계획"){
	            	$("#grid_edu").data("kendoGrid").resize();
	            }else{
	                
	            }
	        }
		</script>

	</div><!--//pop03-->
	
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
	
	
</div><!--//cdpPlan-->

