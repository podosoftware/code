<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>실시관리</title>

<script type="text/javascript">
var now = new Date();
var dataSource_compgroup;
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
	            '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
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
              });
              //브라우저 resize 이벤트 dispatch..
              $(window).resize();
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
        	  
        	  // list call
        	$("#grid").empty();
	       	$("#grid").kendoGrid({
	               dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_admin_list_main.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){	
	                       	return { };
	                       } 		
	                   },
	                   schema: {
	                   	data: "items",
	                   	total: "totalItemCount",
	                       model: {
	                           fields: {
	                        	   RUN_NUM : { type: "int" },
	                        	   EVL_TYPE_CD : { type: "int" },
	                        	   EVL_TYPE_STRING : { type: "string" },
	                        	   RUN_NAME : { type: "string" },
	                        	   RUN_COMMENT : { type: "string" },
	                        	   RUN_START : { type: "string" },
	                        	   RUN_END : { type: "string" },
	                        	   RUN_DATE : { type: "string" },
	                        	   RUN_STATE : { type: "string" },
	                        	   BOSS_YN : { type: "string" },
	                        	   COL_YN : { type: "string" },
	                        	   SUB_YN : { type: "string" },
	                        	   SELF_YN : { type: "string" },
	                        	   SELF_WEIGHT : { type: "string" },
	                        	   BOSS_WEIGHT : { type: "string" },
	                        	   COL_WEIGHT : { type: "string" },
	                        	   SUB_WEIGHT : { type: "string" },
	                        	   YYYY  : { type: "string" },
	                        	   RESULT_OPEN_DATE : { type: "string" },
	                        	   DIAGNO_DIR_TYPE_CD : { type: "string" },
	                        	   DIAGNOD_CD_STRING : { type: "string" }
	                           }
	                       }
	                   },
	                   pageSize: 30,serverPaging:false, serverFiltering:false, serverSorting:false
	               },
	               columns: [
	                   {
	                       field:"ROWNUMBER",
	                       title: "번호",
	                       filterable: false,
						    width:60,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },
	                   {
	                       field:"YYYY",
	                       title: "실시년도",
	                       filterable: true,
						    width:100,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },
                       {
                           field:"EVL_TYPE_STRING",
                           title: "실시유형",
                           filterable: true,
                            width:100,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"} 
                       },
	                   {
	                       field: "RUN_NAME",
	                       title: "실시명",
						   width:220,
						   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:left;text-decoration: underline;"},
	                       template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${RUN_NUM});' >${RUN_NAME}</a>"
	                   },
	                   {
	                       field: "RUN_DATE",
	                       title: "실시기간",
	                       width:140,
	                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },	                   
	                   {
	                       field: "RUN_STATE",
	                       title: "상태",
	                       width:100,
	                       headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                       attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },                     
                       {
                           field: "USEFLAG",
                           title: "사용여부",
                           width:100,
                           headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                           attributes:{"class":"table-cell", style:"text-align:center"},
                           template: function(data){
                        	   return data.USEFLAG =="Y" ? "사용" : "미사용";
                           }
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
	               selectable: "row",
	               pageable: true,
	               pageable : {
                       refresh : false,
                       pageSizes :[10,20,30],
                       buttonCount : 5
                   }
	               
	           });

	       	$('#details').show().html(kendo.template($('#template').html()));
	       	
	       	//역량군 리스트 불러오기
	       	dataSource_compgroup = new kendo.data.DataSource({
	                type: "json",
	                transport: {
	                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_admin_cmp_group_list.do?output=json", type:"POST" },
	                    parameterMap: function (options, operation){    
	                        return {  RUNNUM : $("#runNum").val() };
	                    }
	                },
	                schema: {
	                    data: "items",
	                    model: {
	                        fields: {
	                        	COMMONCODE : { type: "String" },
	                        	RUN_NUM : { type: "String" },
	                        	CMM_CODENAME : { type: "String"},
	                        	CHECKFLAG : { type: "String"}
	                        }
	                    }
	                },
	            });
	       	
	       	dataSource_compgroup.fetch(function(){ //역량군 리스트 fetch..
				var view = dataSource_compgroup.view();
				if(view.length>0){
					 $.each(view, function(idx, item) {
	                	 $("#evlCompGroup").append("<input type='checkbox' id='evlCompCheck"+idx+"' onclick =modifyYnFlag(this,\""+item.COMMONCODE+"\"); name='evlCompCheck'/>"+item.CMM_CODENAME+"</input><span style='padding-left:10px;'></span>");
	                 });
				}
			});	

		       numTexBox();
		       buttonEvent();
        	   // list new btn add click event
        	   $("#newBtn").click( function(){
        		   $("#splitter").data("kendoSplitter").expand("#detail_pane");
        		   kendo.bind($(".tabular"), null);
        		   // show detail 
					$('#details').show().html(kendo.template($('#template').html()));
        		   //역량군 리드
					dataSource_compgroup.read();
		            numTexBox(); //텍스트박스 이벤트
					buttonEvent(); //버튼 이벤트 
					useCompGroup(); //역량군 리스트
					$("#delBtn").hide();
					$("#yyyy").val(now.getFullYear());
					//yyyy.value(now.getFullYear());
					
        	  });

          }
      }]);   

	</script>
	<script type="text/javascript">

	//역량군 정보 변경 이벤트.
	function modifyYnFlag(checkbox,codeNum) {
		var dataCmp = dataSource_compgroup.data();
			var res = $.grep(dataCmp, function (e) {
				return e.COMMONCODE == codeNum;
	        });
	    
			if (checkbox.checked == true) {
				res[0].CHECKFLAG = "checked";
			} else {
				res[0].CHECKFLAG = '';
			}
	}
	 function numTexBox(){ //날짜 및 숫자입력 텍스트박스 제어
	       /*  var weight = $(".weight").kendoNumericTextBox({
             format: "",
             min: 0,
             max: 100,
             step: 1
         }).data("kendoNumericTextBox");
	       var hcnt = $(".hcnt").kendoNumericTextBox({
             format: "",
             min: 0,
             max: 100,
             step: 1
         }).data("kendoNumericTextBox"); */
		
	     var year = $(".amountYear").kendoNumericTextBox({
       		 format: "",
               min: 2014,
               max: 3000,
               step: 1
          }).data("kendoNumericTextBox");
         
         $(".amountYear").val(now.getFullYear());
         
         var weight = $(".weight").kendoNumericTextBox({
       		 format: "",
               min: 0,
               max: 100,
               step: 1
          }).data("kendoNumericTextBox");
         var hcnt = $(".hcnt").kendoNumericTextBox({
             format: "",
             min: 0,
             max: 100,
             step: 1
         }).data("kendoNumericTextBox");
         

	     var start = $("#runStart").kendoDatePicker({
			   format: "yyyy-MM-dd",
			   change: function(e) {                    
				   var startDate = start.value(),
                 endDate = end.value();

                 if (startDate) {
                     startDate = new Date(startDate);
                     startDate.setDate(startDate.getDate());
                     end.min(startDate);
                 } else if (endDate) {
                     start.max(new Date(endDate));
                 } else {
                     endDate = new Date();
                     start.max(endDate);
                     end.min(endDate);
                 }
	               			
	           	}
         }).data("kendoDatePicker");

         var end = $("#runEnd").kendoDatePicker({
      	   format: "yyyy-MM-dd",
      	   change: function(e) {                    
      		   var endDate = end.value(),
	       	        startDate = start.value();
	       	
	       	        if (endDate) {
	       	            endDate = new Date(endDate);
	       	            endDate.setDate(endDate.getDate());
	       	            start.max(endDate);
	       	        } else if (startDate) {
	       	            end.min(new Date(startDate));
	       	        } else {
	       	            endDate = new Date();
	       	            start.max(endDate);
	       	            end.min(endDate);
	       	        }
      	   }
         }).data("kendoDatePicker");
         
         var open = $("#runOpenDate").kendoDatePicker({
			   format: "yyyy-MM-dd",
			   
         }).data("kendoDatePicker");
         
         start.max(end.value());
         end.min(start.value());
     }
	 
	function showHideCheck(){	 //선택 유형에 따라 화면 변경		
     	if($(':radio[id="evlType"]:checked').val() == 1){
     		$("#cmptArea").show();
     		$("#useCompGroup").show(); //사용역량군
     		$("#dirPepleSet").show(); //방향 인원 설정
     		$("#reOpenDate").show(); //결과열람일
     		$("#diagType").show(); // 진단유형
     		$("#rsOpenDate").show(); //결과 열람일
     	}else if($(':radio[id="evlType"]:checked').val() == 2){
     		$("#cmptArea").hide();
     		$("#useCompGroup").hide(); //사용역량군
     		$("#dirPepleSet").hide(); //방향 인원 설정
     		$("#reOpenDate").hide(); //결과열람일
     		$("#diagType").hide(); // 진단유형
     		$("#rsOpenDate").hide(); //결과열람일 		
     	}

	}
	//방향 및 인원설정 활성화/비활성화 처리
	function disableWeight(){
		
		var disArray = new Array("boss","col","sub","self");
		//자가진단일 경우 모두 비활성화
		if($(':radio[id="diagDivision"]:checked').val() == 1){
  			$("#div01").hide();
  			$("#div02").hide();
  			$("#div03").hide();
     		
			for (var i= 0 ; i < disArray.length ; i++ ){
     			$("#"+disArray[i]+"Check").attr("disabled",true);
     			$("#"+disArray[i]+"Weight").attr("disabled",true);
     			$("#"+disArray[i]+"Hcnt").attr("disabled",true);
     			$("#"+disArray[i]+"Weight").val("0");
     			$("#"+disArray[i]+"Hcnt").val("0");
     			$("#"+disArray[i]+"Check").attr("checked",false);
     		}
     		
			$("#selfWeight").val("100");
     		$("#selfHcnt").val("1");
     		$("#selfCheck").attr("checked",true);
     		$("#selfWeight").focus();
     	//다면진단	
     	}else if($(':radio[id="diagDivision"]:checked').val() == 2){
  			$("#div01").show();
  			$("#div02").show();
  			$("#div03").show();
     		for (var i= 0 ; i < disArray.length ; i++ ){
     			$("#"+disArray[i]+"Check").attr("disabled",false);
     			$("#"+disArray[i]+"Weight").attr("disabled",false);
     			$("#"+disArray[i]+"Hcnt").attr("disabled",false);
     		}
     		$("#selfHcnt").attr("disabled",true);
     		$("#selfHcnt").val("1"); //자가 진단은 항상 1 (자기자신)
     	}
	}
	
	function dateCheck(){ //날짜기간 제어
		var date = new Date();
        var year = date.getFullYear(); 
     	if($(':radio[id="evlPrdType"]:checked').val() == 1){
     		$("#runStart").val(year+"-01-01");
     		$("#runEnd").val(year+"-06-30");
     	}else if($(':radio[id="evlPrdType"]:checked').val() == 2){
     		$("#runStart").val(year+"-07-01");
     		$("#runEnd").val(year+"-12-31");
     	}else if($(':radio[id="evlPrdType"]:checked').val() == 3){
     		$("#runStart").val(year+"-01-01");
     		$("#runEnd").val(year+"-12-31");
     	}  
	}
	function checkYn(obj){ //체크일 경우 value값 변경
		if( $("#bossCheck").attr("checked") == "checked" ){
			$("#bossCheck").val("Y");
		}else{
			$("#bossCheck").val("N");
			$("#bossWeight").val("0");
		}
		if( $("#colCheck").attr("checked") == "checked" ){
			$("#colCheck").val("Y");
		}else{
			$("#colCheck").val("N");
			$("#colWeight").val("0");
		}
		if( $("#subCheck").attr("checked") == "checked" ){
			$("#subCheck").val("Y");
		}else{
			$("#subCheck").val("N");
			$("#subWeight").val("0");
		}
		if( $("#selfCheck").attr("checked") == "checked" ){
			$("#selfCheck").val("Y");
		}else{
			$("#selfCheck").val("N");
		}
/* 		
		if($(':radio[id="diagDivision"]:checked').val() == 1){
			//가자 진단일경우 모두 0처리
			$("#colHcnt").val("0");
			$("#subHcnt").val("0");
			$("#bossHcnt").val("0");
		}else if($(':radio[id="diagDivision"]:checked').val() == 2){
			//가자 진단일경우 모두 999처리
			$("#selfHcnt").val("1");
			$("#subHcnt").val("999");
			$("#bossHcnt").val("999");
		} */
		
		
   	}
	function weightCheck(boss,col,sub,self){
		//자가진단일 경우 모두 비활성화
		if(boss == "Y"){ 
			$("#bossCheck").attr("checked",true);
		}else{
			$("#bossCheck").attr("checked",false);
		}
		if(col == "Y"){ 
			$("#colCheck").attr("checked",true);
		}else{
			$("#colCheck").attr("checked",false);
		}
		if(sub == "Y"){ 
			$("#subCheck").attr("checked",true);
		}else{
			$("#subCheck").attr("checked",false);
		}
		if(self == "Y"){ 
			$("#selfCheck").attr("checked",true);
		}else{
			$("#selfCheck").attr("checked",false);
		}

	}
	// 상세보기.
    function fn_detailView(runNumber){
		
    	var grid = $("#grid").data("kendoGrid");
        var data = grid.dataSource.data();
        
        var res = $.grep(data, function (e) {
	        return e.RUN_NUM == runNumber;
	    });
	
	    var selectedCell = res[0];
		
	    
	    $("#splitter").data("kendoSplitter").expand("#detail_pane");
                
          // show detail 
        $('#details').show().html(kendo.template($('#template').html()));
 
        $('input:radio[id=evlType]:input[value='+selectedCell.EVL_TYPE_CD+']').attr("checked", true);//실시유형
          
        $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//사용여부
        
        $('input:radio[id=diagDivision]:input[value='+selectedCell.DIAGNO_DIR_TYPE_CD+']').attr("checked", true);//사용여부
         
    	 // dtl save btn add click event
     	 buttonEvent();
     	 numTexBox();
     	 
     	 
     	weightCheck(selectedCell.BOSS_YN,selectedCell.COL_YN,selectedCell.SUB_YN,selectedCell.SELF_YN);
     	showHideCheck(); // 실시유형에 따라 화면 변경
     	disableWeight(); // 진단유형에 따리 방향 및 인원 설정 활성화/비활성화
     	
    	 
       	 // detail binding data
         kendo.bind( $(".tabular"), selectedCell ); 
		
     	//detail 창에서의 역량군 리스트 호출
        $.ajax({
             type : 'POST',
             dataType : 'json',
             url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_admin_cmp_group_list.do?output=json",
             data : {
            	 RUNNUM : $("#runNum").val()
             },
             success : function(response) {
                 if (response.items != null) {
                     var selectRow = new Object();
                     $.each(response.items, function(idx, item) {
                    	 $("#evlCompGroup").append("<input type='checkbox' id='evlCompCheck"+idx+"' "+item.CHECKFLAG+" onclick =modifyYnFlag(this,\""+item.COMMONCODE+"\"); name='evlCompCheck'/>"+item.CMM_CODENAME+"</input><span style='padding-left:10px;'></span>");
                     });
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
        dataSource_compgroup.read();
       
          // 사용 역량군
        // template에서 호출된 함수에 대한 이벤트 종료 처리.
        if(event.preventDefault){
            event.preventDefault();
        } else {
            event.returnValue = false;
        } 
    }
	function useCompGroup(){ //추가 창에서의 역량군 리스트 출력
		var dataCmp = dataSource_compgroup.data();
        for( var i=0 ; i < dataCmp.length ; i++){
        	$("#evlCompGroup").append("<input type='checkbox' id='evlCompCheck"+i+"' name='evlCompCheck' onclick =modifyYnFlag(this,\""+dataCmp[i].COMMONCODE+"\"); />"+dataCmp[i].CMM_CODENAME+"</input><span style='padding-left:10px;'></span>");

        }
	}
	//방향 및 인원 설정 숫자 방지
	function numberVaildate(obj){
		$(obj).val($(obj).val().replace(/[^0-9]/gi,""));
		if($(obj).val() > 100 ){
			$(obj).val("100");
		}
	}

	   function buttonEvent(){
		var complete = "N";
       	// dtl del btn add click event
          	$("#delBtn").click( function(){
          	    
           	var isDel = confirm("삭제 하시겠습니까?");
               if(isDel){
            	   loadingOpen();
            	   var params = {
           			RUN_NUM : $("#runNum").val(),
           			FLAG : "14",
            		};
           		
           		$.ajax({
           			type : 'POST',
   					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_del.do?output=json",
   					data : { item: kendo.stringify( params ) },
   					complete : function( response ){
   						loadingClose();
   						var obj  = eval("(" + response.responseText + ")");
   						if(obj.saveCount != 0){
 							kendo.bind( $(".tabular"),  null );
 							$("#grid").data("kendoGrid").dataSource.read(); 
 							$("#splitter").data("kendoSplitter").collapse("#detail_pane");
 			         		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
 			                $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
   							
   							alert("삭제되었습니다.");	
   							complete = "Y";
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
           		 if(complete == "Y"){
	           			$.ajax({
	               			type : 'POST',
	       					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_admin_cmp_group_del?output=json",
	       					data : { RUN_NUM : $("#runNum").val() },
	       					complete : function( response ){
	       						var obj  = eval("(" + response.responseText + ")");
	       						if(obj.saveCount != 0){
	       							complete = "N";	
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
         	});
           
		// dtl save btn add click event
       	  $("#saveBtn").click( function(){
       		checkYn(); // 방향 및 인원 설정 체크값만 받아오기
       		
       		var dataCmp = dataSource_compgroup.data();
       		
       		if($(':radio[id="evlType"]:checked').val()==null) {
        		alert("실시유형을 체크해주세요");
        		return false;
        	}
	 		
     		if($("#runName").val()=="") {
     			alert("실시명을 입력해 주십시오.");
     			$("#runName").focus();
     			return false;
     		}     		
     		
     		if($("#yyyy").val()=="") {
                alert("실시년도를 입력해 주십시오.");
                $("#yyyy").focus();
                return false;
            }           

            if($("#runStart").val()=="") {
                alert("실시시작일을 입력해 주십시오.");
                $("#runStart").focus();
                return false;
            }
            if(!ex_date("실시시작일","runStart")){
            	return false;
            }
            if($("#runEnd").val()=="") {
                alert("실시종료일을 입력해 주십시오.");
                $("#runEnd").focus();
                return false;
            }
            if(!ex_date("실시종료일","runEnd")){
                return false;
            }
            if($(':radio[id="evlType"]:checked').val()=="1"){
			          if($("#runOpenDate").val()=="" ) {
			              alert("결과열람일을 입력해 주십시오.");
			              $("#runOpenDate").focus();
			              return false;
			          }
			          if(!ex_date("결과열람일","runOpenDate")){
			          	return false;
			          }
			          var checkCnt=0;
			          for(var i = 0 ; i < dataCmp.length ;i++){
			          	if( $("#evlCompCheck"+i).attr("checked") == "checked" ){
			          		checkCnt++;
			   		}
			          }
			          if(checkCnt == 0){
			          	alert("사용역량군을 선택해 주십시오.");
			          	return false;
			          }
			          
			          if($(':radio[id="diagDivision"]:checked').val()==null) {
			              alert("진단유형을 입력해 주십시오.");
			              return false;
			          }
			          var dirCheckCnt = 0;
			          
			          if($("#bossCheck").attr("checked") == "checked"){
			   			if($("#bossWeight").val() < 1){
			   				alert("상사진단 가중치를 입력해 주십시오.");
			   				$("#bossWeight").focus();
			   				return false;
			   			}
			   			dirCheckCnt=1;
			   		}
			   		if($("#colCheck").attr("checked") == "checked"){
			   			if($("#colWeight").val() < 1){
			   				alert("동료진단 가중치를 입력해 주십시오.");
			   				$("#colWeight").focus();
			   				return false;
			   			}
			   			dirCheckCnt=1;
			   		}
			   		if($("#subCheck").attr("checked") == "checked"){
			   			if($("#subWeight").val() < 1){
			   				alert("부하진단 가중치를 입력해 주십시오.");
			   				$("#subWeight").focus();
			   				return false;
			   			}
			   			dirCheckCnt=1;
			   		}
			   		if($("#selfCheck").attr("checked") == "checked"){
			   			if($("#selfWeight").val() < 1){
			   				alert("자가진단 가중치를 입력해 주십시오.");
			   				$("#selfWeight").focus();
			   				return false;
			   			}
			   			dirCheckCnt=1;
			   		}
			   		if(dirCheckCnt == 0){
			   			alert("선택된 방향 및 인원 설정이 없습니다.");
			   			return false;
			   		}
			   		if($("#colWeight").val() > 0 ){
			   			if($("#colHcnt").val() < 1){
			   				alert("동료진단 명수를 입력해 주십시오.");
			   				$("#colHcnt").focus();
			   				return false;
			   			}
			   		}
			          if($(':radio[id="evlType"]:checked').val()=="1") {
			   			var bossw = $("#bossWeight").val()-0;
			   			var colw = $("#colWeight").val()-0;
			   			var subw = $("#subWeight").val()-0;
			   			var selfw = $("#selfWeight").val()-0;
			   			
			   			var resultWeight = bossw + colw + subw + selfw;
			   			
			   			if(resultWeight > 100 || resultWeight != 100){
			   	  			alert("가중치의 합은 100%이어야 합니다(현재:"+resultWeight+"%).");
			       			return false;
			       		}
			      	}
            }
      			
            	var isDel = confirm("실시정보를 저장하시겠습니까?");
			 	 if(isDel){				 		            		
			 		 loadingOpen();
			 		 var params = {
             			RUN_NUM : $("#runNum").val(),
             			EVL_TYPE_CD : $(':radio[id="evlType"]:checked').val(),
             			RUN_NAME : $("#runName").val(),
             			RUN_START : $("#runStart").val(),
             			RUN_END : $("#runEnd").val(),
             			RESULT_OPEN_DATE : $("#runOpenDate").val(),
             			SELF_WEIGHT : $("#selfWeight").val(),
             			BOSS_WEIGHT : $("#bossWeight").val(),
             			COL_WEIGHT : $("#colWeight").val(),
             			SUB_WEIGHT : $("#subWeight").val(),
             			//SELF_HCNT : $("#selfWeight").val(),
             			BOSS_HCNT : $("#bossHcnt").val(),
             			COL_HCNT : $("#colHcnt").val(),
             			SUB_HCNT : $("#subHcnt").val(),
             			BOSS_YN : $("#bossCheck").val(),
             			COL_YN :  $("#colCheck").val(),
             			SUB_YN :  $("#subCheck").val(),
             			SELF_YN : $("#selfCheck").val(),
             			YYYY : $("#yyyy").val(),
             			DIAGNO_DIR_TYPE_CD : $(':radio[id="diagDivision"]:checked').val(),
             			USEFLAG: $(':radio[id="useFlag"]:checked').val(),
                        LIST :  dataSource_compgroup.data(),

  	           		};
             		$.ajax({
             			type : 'POST',
     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_admin_save.do?output=json",
     					data : { item: kendo.stringify( params ) },
     					complete : function( response ){
     						loadingClose();
     						var obj  = eval("(" + response.responseText + ")");
     						if(obj.result != 0){	
     							$("#grid").data("kendoGrid").dataSource.read();
     							kendo.bind( $(".tabular"),  null );
     			         		 
     			         		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
     			                $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
     							
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
			
       		// dtl cancel btn add click event
        	$("#cencelBtn").click( function(){
         		kendo.bind( $(".tabular"),  null );
         		 
         		$("#cudMode").val()=="";
         		 
         		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
                $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
         	});
			
	   }

	</script>
	
</head>
<body>
	<!-- START MAIN CONTNET -->
	
	<div id="content">
        <div class="cont_body">
            <div class="title mt30">실시관리</div>
            <div class="table_tin01">
                <div class="px">※역량진단 혹은 CDP 생성과 생선된 정보에 대한 관리가 가능합니다.</div>
                <div class="px">※ 추가를 클릭하여 실시를 등록하십시오.</div>
                
            </div>
            <div class="table_zone" >
                <div class="table_btn">
						<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_admin_list_main_excel.do" >엑셀 다운로드</a>&nbsp;
			    		<button id="newBtn" class="k-button" ><span class="k-icon k-i-plus"></span>추가</button>
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
	
	<!-- END MAIN CONTENT  --> 	 

	 	<script type="text/x-kendo-template"  id="template"> 
			<div>
				<table class="tabular" id="tabular"  cellspacing="0" cellpadding="0">
					<tr width="120px"><td colspan="2" style="font-size:16px;"><strong>실시관리</strong>
						<input type="hidden" id="runNum" data-bind="value:RUN_NUM" style="border:none" readonly="readonly" />
					</td></tr>
					<tr>
				    	<td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 실시유형<span style="color:red">*</span></td> 
				    	<td class="subject"><input type="radio" id="evlType" name="evlType"  value="1" checked onclick="showHideCheck();"/> 역량진단</input>
					 	<span style="padding-left:20px;"><input type="radio" id="evlType" name="evlType"  value="2" onclick="showHideCheck();"/> CDP</input></span></td>
			    	</tr>
					<tr>
				    	<td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px;line-height:30px; ">&nbsp; 실시년도</span><span style="color:red">*</span></td>
				    	<td class="subject" ><input type="number" class="amountYear" id="yyyy" data-bind="value:YYYY" value="" style="width:80px;border:none;"/></td>
			    	</tr>
			    	<tr>
				    	<td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp; 실시명</span><span style="color:red">*</span></td>
				    	<td class="subject"><input type="text" id="runName" data-bind="value:RUN_NAME" style="width:300px;height:25px;" onKeyUp="chkNull(this); "  /></td>
			    	</tr>
			    	<tr>
				    	<td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp; 실시기간</span><span style="color:red">*</span></td>
				    	<td class="subject"><input type="text" id="runStart" data-bind="value:RUN_START" style="width:150px; border:none"  /> ~
							 <input type="text" id="runEnd" data-bind="value:RUN_END" style="width:150px; border:none"  /></td>

			    	</tr>
					<tr id="rsOpenDate">
				    	<td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp; 결과열람일</span> <span style="color:red">*</span></td>
				    	<td class="subject"><input type="text" id="runOpenDate" data-bind="value:RESULT_OPEN_DATE" style="width:150px; border:none"  />
						</td>

			    	</tr>
					<tr id="useCompGroup">
				    	<td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp; 사용역량군</span><span style="color:red">*</span></td>
				    	<td class="subject" id="evlCompGroup">
						</td>

			    	</tr>
					<tr id="diagType">
						<td class="subject" width="120px"   ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp; 진단유형</span><span style="color:red">*</span></td> 
						<td class="subject"><input type="radio" name="diagDivision"  id="diagDivision"  value="1" onclick = "disableWeight();"/> 자가진단</input>
						<span style="padding-left:20px"><input type="radio" name="diagDivision" id="diagDivision"  value="2" onclick = "disableWeight();"/> 다면진단</input></span></td>
					</tr>
					<tr id="dirPepleSet">
				    	<td width="120px" class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp; 방향 및 인원 설정</span><span style="color:red">*</span></td>
						<td class="subject" >

						<div id="div01" style="margin-top:10px;line-height:40px;vertical-align:top">
						<input type="checkbox" id="bossCheck" name="bossCheck"  data-bind="value:BOSS_YN" onclick="checkYn(this);"/> 상사를 진단</input>
					 	<span style="padding-left:15px"><input type="number" class="weight"  style="width:70px;border:none;" id="bossWeight" data-bind="value:BOSS_WEIGHT" onkeyup="numberVaildate(this);"/> %</input></span>
 						<span style="padding-left:15px"><input type="number" id="bossHcnt" class="hcnt"  style="width:70px;border:none;visibility:hidden;" value="999" onkeyup="numberVaildate(this);" /> </span>
						</div>

						<div id="div02" style="margin-top:10px;line-height:40px;vertical-align:top" >
						<input type="checkbox" id="colCheck" name="colCheck"  data-bind="value:COL_YN" onclick="checkYn(this);"/> 동료를 진단</input>
 						<span style="padding-left:15px"><input type="number" class="weight"  style="width:70px;border:none;" id="colWeight"  data-bind="value:COL_WEIGHT" onkeyup="numberVaildate(this);"/> %</input></span>
 						<span style="padding-left:15px"><input type="number" class="hcnt"style="width:70px;border:none;" id="colHcnt"  data-bind="value:COL_HCNT" onkeyup="numberVaildate(this);"/> 명</span>
						</div>

						<div id="div03" style="margin-top:10px;line-height:40px;vertical-align:top">
						<input type="checkbox" id="subCheck" name="subCheck"  data-bind="value:SUB_YN" onclick="checkYn(this);"/> 부하를 진단</input>
						<span style="padding-left:15px"><input type="number" class="weight" style="width:70px;border:none;" id="subWeight"  data-bind="value:SUB_WEIGHT" onkeyup="numberVaildate(this);"/> %</input></span>
 						<span style="padding-left:15px"><input type="number" class="hcnt""  style="width:70px;border:none;visibility:hidden;" id="subHcnt"  value="999" onkeyup="numberVaildate(this);"/> </span>
						</div>

						<div style="margin-top:10px;line-height:40px;vertical-align:top">
						<input type="checkbox" id="selfCheck" name="selfCheck"  data-bind="value:SELF_YN" onclick="checkYn(this);"/> 자신을 진단</input>
						<span style="padding-left:15px"><input type="number" class="weight"  style="width:70px;border:none;" id="selfWeight" data-bind="value:SELF_WEIGHT" onkeyup="numberVaildate(this);"/> %</input></span>
 						<span style="padding-left:15px"><input type="number" class="hcnt" style="width:70px;border:none;visibility:hidden;"  id="selfHcnt"  value="999" onkeyup="numberVaildate(this);"/> </span>
						</div>
						
					</td>
			    	</tr>
					<tr>
						<td class="subject" width="120px"   ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp; 사용여부</span><span style="color:red">*</span></td> 
						<td class="subject"><input type="radio" name="useFlag"  id="useFlag"  value="Y" checked = "true"/> 사용</input>
						<span style="padding-left:20px"><input type="radio" name="useFlag" id="useFlag"  value="N"/> 미사용</input></span></td>
					</tr>
				</table>

			</div>
			<div style="text-align:right;margin-top:10px">
                <button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
			    <button id="delBtn" class="k-button">삭제</button>&nbsp;
			    <button id="cencelBtn" class="k-button"></span>취소</button>
            </div>	
			
	 		</script>
	 		
	
</body>
</html>