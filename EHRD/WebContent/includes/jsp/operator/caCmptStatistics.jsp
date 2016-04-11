<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>평가현황열람</title>
	<script type="text/javascript">
	
		var dataSource = null;		
		
		function modifyYnFlag(checkbox, userid){
 			var array = $('#grid').data('kendoGrid').dataSource.data();
 			var res =  $.grep(array, function (e) {
                return e.USERID == userid;
            });
 			
 			if(checkbox.checked == true){
 				res[0].CHECKFLAG = "checked=\"1\"";
 			}else{
 				res[0].CHECKFLAG = '';
 			}
 	   }
		
		function modifyAllCheck(checkbox){
 			var array =  $('#grid').data('kendoGrid').dataSource.view();
 			
 			if(checkbox.checked == true){
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = "checked=\"1\"";
 				}
 			}else{
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = ''; 
 				}
 			} 			
 			$("#grid").data("kendoGrid").refresh();			
 	   } 
		
		function excelDownload(button){
			button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_statistics_excel_list.do?RUN_NUM="+$("#runNumber").val();
		}
		
		function setDataSource(startYn){
			
			if(startYn == 'Y'){
				runNum = "";
			}else{
				runNum = $("#runNumber").val();
			}
			
			dataSource = new kendo.data.DataSource({
	                  type: "json",
	                  transport: {
	                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_statistics_list_main.do?output=json", type:"POST" },
	                      parameterMap: function (options, operation){	
	                      	return {RUN_NUM : $("#runNumber").val()} ;
	                      } 		
	                  },
	                  schema: {
	                	  total: "totalItemCount",
	                      data: "items",
	                      model: {
	                          fields: {
	                              COMPANYID : { type: "int" },                                
	                              ROWNUMBER : { type: "int" },
	                              USERID : { type: "int" },
	                              CHECKFLAG : { type: "string" },
	                              RUN_NUM : { type: "int" },
	                              LEADERSHIP_NAME : { type: "string" },
	                              DVS_NAME : { type: "string" },
                                  EMPNO : { type: "string" },
	                              NAME : { type: "string" },
	                              STATE : { type: "string" },                                
	                              T_CNT : { type: "int" },
	                              C_CNT : { type: "int" },
	                          }
	                      }
	                  },
	                  serverFiltering: false,
		              serverSorting: false,
		              pageSize: 30
	      	});

            $(window).resize();

// 	       	 openwindow(dataSource);
			
			
		}
		
		function diagInitialization(userid, name){
			
			var isDel = confirm(name+ "님에 대한 평가정보를 초기화 하시겠습니까?");
		 	 if(isDel){
        		
        		$.ajax({
        			type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_diag_initializaion.do?output=json",
					data : { RUN_NUM : $("#runNumber").val(), USERID : userid},
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
						if(obj.saveCount != 0){
							//setDataSource('N');
							$("#grid").data("kendoGrid").dataSource.read();
							alert("초기화 되었습니다.");	
						}else{
							alert("저장에 실패 하였습니다.");
						}							
					},
					error: function( xhr, ajaxOptions, thrownError){	
						alert('xrs.status = ' + xhr.status + '\n' + 
		                        'thrown error = ' + thrownError + '\n' +
		                        'xhr.statusText = '  + xhr.statusText + '\n세션이 종료되었습니다.' );
		            	sessionout();
					},
					dataType : "json"
				});		
		 	}

	   }
		
		function encourage(){
			
            var gridData = $('#grid').data('kendoGrid').dataSource.data();
            
            //console.log("--------"+gridData.length);
            var isCnt =  0;
            for(var i=0; i<gridData.length; i++){
                if(gridData[i].CHECKFLAG=='checked=\"1\"'){
                	isCnt = isCnt+1;
                	
                }
            }
            if(isCnt==0){
                alert("메일 발송 대상을 체크해주세요.");
                return false;
            }
            
			var isDel = confirm("메일을 발송 하시겠습니까?");
		 	 if(isDel){ 
		 		 
		 		var params = {	             				
             			LIST :  $('#grid').data('kendoGrid').dataSource.data(),	             			             			
  	           		}; 
		 		 
        		$.ajax({
        			type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/encourage_mail_send.do?output=json",
					data : { RUN_NAME :  $("#runNumber").data("kendoComboBox").text(), item: kendo.stringify( params )},
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
						if(obj.error==null){
							if(obj.saveCount != 0){
								alert("메일이 발송되었습니다");	
							}else{
								alert("메일이 발송에 실패 하였습니다.");
							}
						}else{
							alert("error:"+obj.error.message);
						}
													
					},
					error: function( xhr, ajaxOptions, thrownError){	
					},
					dataType : "json"
				});		
		 	 }
	   }
		

	   
//        function openwindow(dataSource) {
    	   
// 	   }
       
		   
	</script>
	<script type="text/javascript">         
	
	
        yepnope([{
       	  load: [ 
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.default.min.css',
          	'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.metro.min.css',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
      		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
       	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
       	 	'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
      	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js', 
       	 	'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js'
          ],
          complete: function() {  
        	  
        	  
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
                  
              	var gridElement = $("#grid");
              	gridOtherHeight = $("#grid").offset().top + $("#footer").outerHeight() + 30; //
              	gridElement.height(winHeight - gridOtherHeight);
              	
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
              
              
            //평가년도 콤보박스
            $("#yyyy").kendoComboBox({
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
            });
            
            var dataSource_run = new kendo.data.DataSource({
                type: "json",
                transport: {
                    read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_diagnosis_list.do?output=json", type:"POST" },
                    parameterMap: function (options, operation){ 
                     return { };
                    }        
                },
                schema: {
                    data: "items",
                    model: {
                           fields: {
                        	   SELF_WEIGHT : { type: "string" } ,
                               VALUE : { type: "string" }, 
                               TEXT : { type: "string" },
                               YYYY: { type: "string" }
                           }
                       }
                }
            });
              
        	  $("#runNumber").kendoComboBox({
        	        dataTextField: "TEXT",
        	        dataValueField: "VALUE",
        	        dataSource: dataSource_run,
        	        suggest: true,
        	        index: 0,
       	       		 change: function() {
       	       			//setDataSource('N');
       	       		$("#grid").data("kendoGrid").dataSource.read();
               		 },
                    dataBound:function(e){
                    	//alert("11");
                    	$("#runNumber").data("kendoComboBox").select(0);
                    	//setDataSource('N');
                    	$("#grid").data("kendoGrid").dataSource.read();
                    }
        	    });


              dataSource_run.fetch(function(){
                    if(dataSource_run.data().length>0){
                        if($("#runNumber").val()!=""){
                        	//setDataSource('N');
                        	$("#grid").data("kendoGrid").dataSource.read();
                        }
                    }  
                });
              

        	  //buttonEvent();
        	  
        	$("#grid").empty();
            $("#grid").kendoGrid({
                   dataSource: {
                       type: "json",
                       transport: {
                           read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_statistics_list_main.do?output=json", type:"POST" },
                           parameterMap: function (options, operation){  
                             return {RUN_NUM : $("#runNumber").val()} ;
                           }         
                       },
                       schema: {
                           total: "totalItemCount",
                           data: "items",
                           model: {
                               fields: {
                                   COMPANYID : { type: "int" },                                
                                   ROWNUMBER : { type: "int" },
                                   USERID : { type: "int" },
                                   CHECKFLAG : { type: "string" },
                                   RUN_NUM : { type: "int" },
                                   LEADERSHIP_NAME : { type: "string" },
                                   DVS_NAME : { type: "string" },
                                   EMPNO : { type: "string" },
                                   NAME : { type: "string" },
                                   STATE : { type: "string" },                                
                                   T_CNT : { type: "int" },
                                   C_CNT : { type: "int" },
                               }
                           }
                       },
                       serverFiltering: false,
                       serverSorting: false,
                       pageSize: 30
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
                   editable: false,
                   sortable: true,
                   pageable: {  messages: { display: '{1} / {2}' }  }, 
                   selectable: false,
                   //rowTemplate : kendo.template($("#rowTemplate").html()),
                   height: 500,
                   columns: [
                          {
                              field:"CHECKFLAG",
                              title: "선택",
                              filterable: false,
                              sortable: false,
                              width:50,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              headerTemplate: "선택<br><input type='checkbox' onchange='modifyAllCheck(this);' />",
                              template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag(this, #: USERID #)\" #: CHECKFLAG #\></div>" 
                          },
                          {
                              field: "DVS_NAME",
                              title: "부서",
                               width:150,
                               headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                               attributes:{"class":"table-cell", style:"text-align:left"}
                          },
                          {
                              field: "NAME ",
                              title: "평가자",
                              width:80,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"}
                          },
                          {
                              field: "EMPNO",
                              title: "교직원번호",
                              width:80,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"}
                          }, 
                          {
                              field: "LEADERSHIP_NAME",
                              title: "계층",
                              width:120,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:center"}
                          },                    
                          {
                              field: "STATE",
                              title: "상태",
                              width:80,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:center"}
                          },
                          {
                              field: "",
                              title: "평가현황",
                               width:150,
                               headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                               attributes:{"class":"table-cell", style:"text-align:center"},
                               template: function(dataItem){
                                   return dataItem.T_CNT+"명 중 "+dataItem.C_CNT+"명 평가 완료";
                               }
                          }/*,
                          {
                              field: "",
                              title: "초기화",
                              width:50,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:center"},
                          }*/                    
                      ]
               });
            
        	  //브라우저 resize 이벤트 dispatch..
              $(window).resize();
          }
      }]);   
        
function runFilter(){
	if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
        $("#runNumber").data("kendoComboBox").dataSource.filter({
            "field":"YYYY",
            "operator":"eq",
            "value":$("#yyyy").val()
        });
    }else{
        $("#runNumber").data("kendoComboBox").dataSource.filter({});
    }
}
	</script>
</head>
<body>
	<!-- START MAIN CONTNET -->
	
	
	
	<div id="content">
        <div class="cont_body">
            <div class="title mt30">역량평가현황열람</div>
            <div class="table_tin01">
                <ul>
                    <li class="mt10">
                        <label for="runNumber" >평가명</label>
                        <select id="yyyy" style="width:100px;"></select>
                        <select id="runNumber" style="width:350px;"></select>
                    </li>
                </ul>
            </div>
            
	        <div class="table_zone" >
                <div class="table_btn">
					<!-- <div style="float:left; width: 130px"><input id="allCheck"  type="checkbox" onchange="modifyAllCheck(this)"> 전체선택/전체해지</div> -->
	                <a class="k-button"  onclick="encourage()" >독려메일 발송</a>
					<a class="k-button"  onclick="excelDownload(this)" >엑셀 다운로드</a>
	            </div>
	            <div class="table_list">
	                <div id="grid" ></div>
	            </div>
	        </div>
	    </div>
    </div>

		<script id="rowTemplate" type="text/x-kendo-tmpl">
	            <tr>
		            <td width="30%" align="center">
			           <div style="text-align:center"><input type="checkbox"  onclick="modifyYnFlag(this, #: USERID #)" #: CHECKFLAG #/></div>
		            </td>
		            <td width="30%" align="left">
			           #: DVS_NAME #
		            </td>
		            <td width="20%" align="center">
		               #: NAME #
		            </td>
					<td width="20%" align="left">
		               #: EMPNO #
		            </td>
                    <td width="20%" align="center">
                       #: LEADERSHIP_NAME #
                    </td>				
					<td width="15%" align="center">
		               #: STATE #
		            </td>
					<td width="30%" align="left">
			           #: T_CNT #명중 #: C_CNT #명 평가 완료
		            </td>
					<!--<td width="15%" align="center">
		              <a class="k-button"  onclick='diagInitialization( #: USERID #,  "#: NAME #")' >초기화</a>
		            </td>-->
	           </tr>
            </script>
	
</body>
</html>