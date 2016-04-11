<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>역량평가자설정</title>
	<style type="text/css">
	.k-grid tbody tr{height:38px;}
	.disabledInput {
	    background-color: #eeeeee;
	}
	</style>
	<script type="text/javascript">	
	
	 var winElement = this;
	 var dataSource_run ;
	 
	//자가 가중치 키업 이벤트..
    function selfWeightValue(userid){
		var array = $('#grid').data('kendoGrid').dataSource.data();
	    var res =  $.grep(array, function (e) {
            return e.USERID == userid;
        });
	    res[0].SELF_WEIGHT = $("#selfWeight_"+userid+"").val();
	}
	
	//동료 가중치 키업 이벤트..
    function colWeightValue(userid){
		
		var array = $('#grid').data('kendoGrid').dataSource.data();
	    var res =  $.grep(array, function (e) {
            return e.USERID == userid;
        });
	    res[0].COL_WEIGHT = $("#colWeight_"+userid+"").val();
	}
	
	//부하 가중치 키업 이벤트..
    function subWeightValue(userid){
		
		var array = $('#grid').data('kendoGrid').dataSource.data();			
	    var res =  $.grep(array, function (e) {
            return e.USERID == userid;
        });
	    res[0].SUB_WEIGHT = $("#subWeight_"+userid+"").val();
	}
    
	
	//1차 가중치 키업 이벤트..
    function oneWeightValue(userid){
		var array = $('#grid').data('kendoGrid').dataSource.data();			
		var res =  $.grep(array, function (e) {
            return e.USERID == userid;
        });
	    res[0].ONE_WEIGHT = $("#oneWeight_"+userid+"").val();
	 }
	
	//2차 가중치 키업 이벤트..
    function twoWeightValue(userid){
		var array = $('#grid').data('kendoGrid').dataSource.data();			
		var res =  $.grep(array, function (e) {
            return e.USERID == userid;
        });
		res[0].TWO_WEIGHT = $("#twoWeight_"+userid+"").val();
	 }
	
		
	
		var dataSource = null;
		
		//1,2차 평가자 검색 
    	function userSearchBtn(userid,dvsId, highDvsId, flag){
			//null 값 초기화(서버단에서 int형변환시 에러대비)
    		if(dvsId == null)dvsId = 0;
			if(highDvsId == null)highDvsId = 0;
			
			if(flag == "1"){
    			$("#bindBtn").hide();
    			$("#bindBtn2").hide();
			}else if(flag == "2"){
	    		$("#bindBtn").hide();
	    		$("#bindBtn2").hide();
			}
          		//평가자 선택 폼              
                  $("#lst-add-user-window-selecter-grid").empty();
                  
                  $("#lst-add-user-window-selecter-grid").kendoGrid({
                     dataSource: {
                         type: "json",
                         transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_target_user_v2.do?output=json", type:"POST" },
                        	 parameterMap: function (options, operation){	
     	                      	return { DIVISIONID : dvsId, HIGH_DVSID : highDvsId, USERID: userid, EVL_LEVEL: flag  };
     	                      }	
                  		},
                         schema: {
                              data: "items1",
                              model: {
                                  id : "USERID",
                                  fields: {
                                      USERID : { type: "number", editable:false },
                                      NAME : { type: "string", editable:false },
                                      DVS_NAME : { type: "string", editable:false },
                                      EMPNO : { type: "String", editable:false }
                                  }
                              }
                         },
                     },
                     columns: [
                          { 
                              field:"DVS_NAME", title: "부서", filterable: true, width:150,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          { 
                          	field:"NAME", title: "성명", filterable: true, width:100 ,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          { 
                          	field:"EMPNO", title: "교직원번호", filterable: true, width:80,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          { 
                              field:"JOB_NAME", title: "직무", filterable: true, width:80,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          { 
                              field:"LEADERSHIP_NAME", title: "리더십", filterable: true, width:80,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          { 
                          	field: "button", title: " ", filterable:false, width:80,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:center"},
                              template: "<input type='button' class='k-button k-i-close' style='size:20' value='선택' onclick='fn_selectUser(\"${USERID}\",\"${NAME}\","+userid+","+flag+");'/>"
                          }
                     ],
                     filterable: {
                          extra : false,
                          messages : {filter : "필터", clear : "초기화"},
                          operators : { 
                              string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
                              number : { contains : "포함", startswith : "시작값", eq : "동일값" }
                          }
                      }, 
                      height: 370
                  });
              
          	
              if( !$("#lst-add-user-window").data("kendoWindow") ){
                  $("#lst-add-user-window").kendoWindow({
                  	width:"650px",
                      minHeight:"400px",
                      resizable : true,
                      title : "사용자검색",
                      modal: true,
                      visible: false
                  });
               }
              
              //취소버튼 클릭
              $("#cancel-btn").click(function(){
            	  
              	 $("#lst-add-user-window").data("kendoWindow").close();
              	 
              });
              
              $("#lst-add-user-window").data("kendoWindow").center();
              $("#lst-add-user-window").data("kendoWindow").open();
          }
		
		//동료, 부하 검색 
    	function userListBtn(userid, colUserid, flag){
			
			if(flag == "3"){
    			colUserid = $("#colUserId_"+userid+"").val();
    			$("#bindBtn").show();
    			$("#bindBtn2").hide();
			}else if(flag == "4"){
	    		colUserid = $("#subUserId_"+userid+"").val();
	    		$("#bindBtn").hide();
	    		$("#bindBtn2").show();
			}
    		if(colUserid == "null" || colUserid == "")colUserid = 0;
    		
    		
    		$("#colUserChk").val(userid);
    		
//     		var cutTmp = colUserid.split(',');
			
    		
          		//평가자 선택 폼              
                  $("#lst-add-user-window-selecter-grid").empty();
                  
                  $("#lst-add-user-window-selecter-grid").kendoGrid({
                     dataSource: {
                         type: "json",
                         transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_list_user_v2.do?output=json", type:"POST" },
                        	 parameterMap: function (options, operation){	
     	                      	return {  USERID: userid , COL_USERID: colUserid };
     	                      }	
                  		},
                         schema: {
                              data: "items1",
                              model: {
                                  id : "USERID",
                                  fields: {
                                      USERID : { type: "number", editable:false },
                                      NAME : { type: "string", editable:false },
                                      DVS_NAME : { type: "string", editable:false },
                                      EMPNO : { type: "String", editable:false },
                                      ROWNUMBER : { type: "int", editable: false },
                                      CHECKFLAG : { type: "string", editable: false}
                                  }
                              }
                         },
                     },
                     columns: [
   		                  {
   		                      field:"CHECKFLAG",
   		                      title: "선택",
   		                      filterable: false,
   		                      sortable: false,
   						      width:50,
   						   	  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
   						   	  attributes:{"class":"table-cell", style:"text-align:center"},
   							  template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag2(this, #: USERID #, "+flag+")\" #: CHECKFLAG #\></div>" 
   		                  },
                          { 
                              field:"DVS_NAME", title: "부서", filterable: true, width:150,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          { 
                          	field:"NAME", title: "성명", filterable: true, width:100 ,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          { 
                          	field:"EMPNO", title: "교직원번호", filterable: true, width:80,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          { 
                              field:"JOB_NAME", title: "직무", filterable: true, width:80,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          { 
                              field:"LEADERSHIP_NAME", title: "리더십", filterable: true, width:80,
                              headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                              attributes:{"class":"table-cell", style:"text-align:left"} 
                          }
                     ],
                     filterable: {
                          extra : false,
                          messages : {filter : "필터", clear : "초기화"},
                          operators : { 
                              string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
                              number : { contains : "포함", startswith : "시작값", eq : "동일값" }
                          }
                      }, 
                      height: 370
                  });
              
          	
              if( !$("#lst-add-user-window").data("kendoWindow") ){
                  $("#lst-add-user-window").kendoWindow({
                  	width:"650px",
                      minHeight:"400px",
                      resizable : true,
                      title : "사용자검색",
                      modal: true,
                      visible: false
                  });
               }
              
              $("#lst-add-user-window").data("kendoWindow").center();
              $("#lst-add-user-window").data("kendoWindow").open();
              
              
              //취소버튼 클릭
              $("#cancel-btn").click(function(){
            	  
              	 $("#lst-add-user-window").data("kendoWindow").close();
              	 
              });
              
              
              //설정버튼 클릭
              $("#bindBtn").click(function(){
            	  
            	  var colUserId = $("#colUserChk").val();
            	  
            	  $("#colUserId_"+colUserId+"").val("");
            	  $("#colCnt_"+colUserId+"").val("0");
            	  
            	  var data = $('#lst-add-user-window-selecter-grid').data('kendoGrid').dataSource.data();
            	  var str = "";
            	  var cnt = ""-0;
                  for(var i=0; i<data.length; i++){
                  	var dataItem = data[i];               
                      if(dataItem.CHECKFLAG == "checked=\"1\""){
                    	  cnt += 1;
                    	  str += ""+dataItem.USERID+",";
                    	  $("#colUserId_"+colUserId+"").val(str+"0");
                    	  $("#colCnt_"+colUserId+"").val(cnt);
                      }
                  }
                
                  
  				var grid = $("#grid").data("kendoGrid");
		        var data = grid.dataSource.data();			
		        
		        for(var i = 0; i<data.length; i++) {
		            var dataItem = data[i];
		           if(dataItem.USERID == colUserId){
		        	   if(str == "" || str == null){
		        		   dataItem.COL_USERID = "";
		        	   }else{
		        		   dataItem.COL_USERID = str+"0";
		        		   dataItem.COL_CNT = cnt;
		        	   }
		           }
		        } 
                  $("#lst-add-user-window").data("kendoWindow").close();
              });
              
              //설정버튼 클릭
              $("#bindBtn2").click(function(){
            	  
            	  var subUserId = $("#colUserChk").val();
            	  
            	  $("#subUserId_"+subUserId+"").val("");
            	  $("#subCnt_"+subUserId+"").val("0");
            	  
            	  var data = $('#lst-add-user-window-selecter-grid').data('kendoGrid').dataSource.data();
            	  var str2 = "";
            	  var cnt2 = ""-0;
                  for(var i=0; i<data.length; i++){
                  	var dataItem = data[i];               
                      if(dataItem.CHECKFLAG == "checked=\"1\""){
                    	  cnt2 += 1;
                    	  str2 += ""+dataItem.USERID+",";
                    	  $("#subUserId_"+subUserId+"").val(str2+"0");
                    	  $("#subCnt_"+subUserId+"").val(cnt2);
                    	  
                      }
                  }
                  
                  
                  
  				var grid = $("#grid").data("kendoGrid");
		        var data = grid.dataSource.data();			
		        
		        for(var i = 0; i<data.length; i++) {
		            var dataItem = data[i];
		           if(dataItem.USERID == subUserId){
		        	   if(str2 == "" || str2 == null){
		        		   dataItem.SUB_USERID = "";
		        	   }else{
		        		   dataItem.SUB_USERID = str2+"0";
		        		   dataItem.SUB_CNT = cnt2;
		        	   }
		           }
		        } 
                  $("#lst-add-user-window").data("kendoWindow").close();
              });
              
             
          }
		
		
    	//동료 정보 초기화
		function fn_colInit(userid){
	        var array = dataSource.data();
            var res = $.grep(array, function (e) {
                return e.USERID == userid;
            });
            
            res[0].COL_USERID = "";
            res[0].COL_WEIGHT = "0";
            
            $("#colUserId_"+userid).val("");
            $("#colWeight_"+userid).val("0");
            $("#colCnt_"+userid).val("");
            
		}
    	
    	//부하 정보 초기화
		function fn_subInit(userid){
	        var array = dataSource.data();
            var res = $.grep(array, function (e) {
                return e.USERID == userid;
            });
            
            res[0].SUB_USERID = "";
            res[0].SUB_WEIGHT = "";
            
            $("#subUserId_"+userid).val("");
            $("#subWeight_"+userid).val("");
            $("#subCnt_"+userid).val("");
            
		}
		
		//1차평가자 정보 초기화
		function fn_oneInit(userid){
	        var array = dataSource.data();
            var res = $.grep(array, function (e) {
                return e.USERID == userid;
            });
            
            res[0].ONE_USERID = "";
            res[0].ONE_NAME = "";
            res[0].ONE_WEIGHT = "";
            
            $("#oneUserId_"+userid).val("");
            $("#oneName_"+userid).val("");
            $("#oneWeight_"+userid).val("");
            
		}
        
        //2차평가자 정보 초기화
        function fn_twoInit(userid){
        	var array = dataSource.data();
            var res = $.grep(array, function (e) {
                return e.USERID == userid;
            });
            
            res[0].TWO_USERID = "";
            res[0].TWO_NAME = "";
            res[0].TWO_WEIGHT = "";
            
            $("#twoUserId_"+userid).val("");
            $("#twoName_"+userid).val("");
            $("#twoWeight_"+userid).val("");
            
        }
        
		
    	//평가자 선택
		function fn_selectUser(id,name,userid,flag){
    		if(flag==1 || flag==2){
    			//그리드 내에서 1,2차 평가자 설정인 경우..
				if($("#userId_"+userid+"").val() == id) {
	                alert("대상자를 평가자로 설정할 수 없습니다.");
	                return false;
	            }
				if(flag==1){
		    		if($("#twoUserId_"+userid+"").val() == id) {
		    			alert("선택하신 사용자는 2차 평가자로 설정되어있습니다.");
		    			return false;
		    		}
	    		}
				
	    		if(flag==2){
		    		if($("#oneUserId_"+userid+"").val() == id) {
		    			alert("선택하신 사용자는 1차 평가자로 설정되어있습니다.");
		    			return false;
		    		}
	    		}
				var grid = $("#grid").data("kendoGrid");
		        var data = grid.dataSource.data();			
		        
		        for(var i = 0; i<data.length; i++) {
		            var dataItem = data[i];
		           if(flag==1){
		            	if(dataItem.USERID == userid){
		            		dataItem.ONE_NAME = name;
		            		$("#oneName_"+userid+"").val(name);
		            		dataItem.ONE_USERID = id;
		            		$("#oneUserId_"+userid+"").val(id);
		            		break;
		            	}//end if
		           }else{
		        	   if(dataItem.USERID == userid){
			            	dataItem.TWO_NAME = name;
			            	$("#twoName_"+userid+"").val(name);
			            	dataItem.TWO_USERID = id;
			            	$("#twoUserId_"+userid+"").val(id);
			            	break;
			            }//end if
		           }
		        } // end for

            }else{
            	//평가자 일괄설정에서 호출된 경우..
            	
                if(flag==3){
                	if($("#twoEvl").val()!="" && $("#twoEvl").val() == id) {
                        alert("2차 평가자와 동일하게 선택할 수 없습니다.");
                        return false;
                    }
                	
                	$("#oneEvl").val(id);
                    $("#oneEvlNm").val(name);
                }else if(flag==4){
                	if($("#oneEvl").val()!="" && $("#oneEvl").val() == id) {
                        alert("1차 평가자와 동일하게 선택할 수 없습니다.");
                        return false;
                    }
                	
                	$("#twoEvl").val(id);
                    $("#twoEvlNm").val(name);
                }
            }
    		
			$("#lst-add-user-window").data("kendoWindow").close();
		}
		//일괄적용 1차평가자 초기화
		function evlInit(flag){
			if(flag==1){
				$("#oneEvl").val("");
	            $("#oneEvlNm").val("");
			}else{
				$("#twoEvl").val("");
                $("#twoEvlNm").val("");
			}
			
		}
		
		function excelDownload(button){
		     if($("#runNumber").val()==null || $("#runNumber").val()==""){
	            alert("평가를 선택해주세요.");
	            return false;
	        }
			button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_target_excel_list_v2.do?RUN_NUM="+$("#runNumber").val()+"&RUN_NAME="+ $("#runNumber").data("kendoComboBox").text();
		}
		
		//역량평가명 선택시 그리드,자가평가 점수 세팅
		function setDataSource(startYn,runSelfWeight,runOneWeight,runTwoWeight,runColWeight,runSubWeight, periodFlag){
				
			$("#runSelfWei").val(runSelfWeight);
			$("#runOneWei").val(runOneWeight);
			$("#runTwoWei").val(runTwoWeight);
			$("#runColWei").val(runColWeight);
			$("#runSubWei").val(runSubWeight);
			$("#periodFlag").val(periodFlag);
			
			
			//$("#allCheck").attr("checked", false);
			
			var runNum = "";
			
			if(startYn == 'Y'){
				runNum = "";
			}else{
				runNum = $("#runNumber").val();
			}
			
			dataSource = new kendo.data.DataSource({
	                  type: "json",
	                  transport: {
	                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_target_list_main_v2.do?output=json", type:"POST" },
	                      parameterMap: function (options, operation){	
	                      	return {RUN_NUM : runNum} ;
	                      } 		
	                  },
	                  schema: {
	                	total: "totalItemCount",
	                  	data: "items2",
	                  	 model: {
	                           fields: {
	                        	   COMPANYID : { type: "int" },	                        	   
	                        	   ROWNUMBER : { type: "int" },
	                        	   USERID : { type: "int" },
	                        	   CHECKFLAG : { type: "string", editable :false },
	                        	   JOB : { type: "string" },
	                        	   LEADERSHIP : { type: "string" },
	                        	   DVS_NAME : { type: "string", editable :false },
	                        	   DIVISIONID : { type: "string" },	      
	                        	   HIGH_DVSID : { type: "string" },
	                        	   NAME : { type: "string", editable :false },
	                        	   SELF_WEIGHT : { type: "int" },
	                        	   COL_USERID : { type: "string" },
	                        	   COL_WEIGHT : { type: "int" },
	                        	   SUB_USERID : { type: "string" },
	                        	   SUB_WEIGHT : { type: "int" },
	                        	   ONE_USERID : { type: "string" },
	                        	   ONE_NAME: { type: "string", editable :false },
	                        	   ONE_WEIGHT : { type: "int" },
	                        	   TWO_USERID : { type: "string" },
	                        	   TWO_NAME : { type: "string", editable :false },
	                        	   TWO_WEIGHT : { type: "int" },
	                        	   COL_CNT: { type: "string" },
	                        	   SUB_CNT: { type: "string" }
	                           }
	                       }
	                  },
	                  serverFiltering: false,
		              serverSorting: false,
		              pageSize: 30
	      	})
 	       	
 	       	 openwindow(dataSource);
			
			
		}
		
		function singleSave(userid, dvsId, name, job,ldr,selfWeight,oneUser,oneWeight,twoUser,twoWeight, s_start_date){
			
			if($("#runNumber").val()==null || $("#runNumber").val()==""){
                alert("평가를 선택해주세요.");
                return false;
            }
			
       		if($("#periodFlag").val()=="O" || $("#periodFlag").val()=="O"){
                alert("진단이 시작되어 평가자 설정이 불가합니다, 평가자 설정을 원하시는 경우 진단기간을 조정해 주시기 바랍니다.");
                return false;
            }
       		
			if(s_start_date!=null && s_start_date!="null" && s_start_date!="" ){
                alert("이미 역량평가를 진행한 상태로 설정값을 변경할 수 없습니다.");
                return false;
            }
			if(($("#selfWeight_"+userid+"").val()=="") || ($("#selfWeight_"+userid+"").val()=="0")){
				alert("자가 가중치를 입력해주세요.");
				return false;
			}
			if(($("#colUserId_"+userid+"").val()!="null" && $("#colUserId_"+userid+"").val()!="" && $("#colWeight_"+userid+"").val()=="") || ($("#colUserId_"+userid+"").val()!="null" && $("#colUserId_"+userid+"").val()!="" && $("#colWeight_"+userid+"").val()=="0")){
				alert("동료 평가자 가중치를 입력해주세요.");
                return false;
			}
            if((($("#colUserId_"+userid+"").val()=="null" || $("#colUserId_"+userid+"").val()=="") && $("#colWeight_"+userid+"").val()!="") && ($("#colUserId_"+userid+"").val()=="null" || $("#colUserId_"+userid+"").val()=="") && $("#colWeight_"+userid+"").val()!="0"){
                alert("동료 평가자를 입력해주세요.");
                return false;
            }
			if(($("#subUserId_"+userid+"").val()!="null" && $("#subUserId_"+userid+"").val()!="" && $("#subWeight_"+userid+"").val()=="") || ($("#subUserId_"+userid+"").val()!="null" && $("#subUserId_"+userid+"").val()!="" && $("#subWeight_"+userid+"").val()=="0")){
				alert("부하 평가자 가중치를 입력해주세요.");
                return false;
			}
            if((($("#subUserId_"+userid+"").val()=="null" || $("#subUserId_"+userid+"").val()=="") && $("#subWeight_"+userid+"").val()!="") && (($("#subUserId_"+userid+"").val()=="null" || $("#subUserId_"+userid+"").val()=="") && $("#subWeight_"+userid+"").val()!="0")){
                alert("부하 평가자를 입력해주세요.");
                return false;
            }
			if(($("#oneUserId_"+userid+"").val()!="null" && $("#oneUserId_"+userid+"").val()!="" && $("#oneWeight_"+userid+"").val()=="") || ($("#oneUserId_"+userid+"").val()!="null" && $("#oneUserId_"+userid+"").val()!="" && $("#oneWeight_"+userid+"").val()=="0")){
				alert("1차 평가자 가중치를 입력해주세요.");
                return false;
			}
            if((($("#oneUserId_"+userid+"").val()=="null" || $("#oneUserId_"+userid+"").val()=="") && $("#oneWeight_"+userid+"").val()!="") && (($("#oneUserId_"+userid+"").val()=="null" || $("#oneUserId_"+userid+"").val()=="") && $("#oneWeight_"+userid+"").val()!="0")){
                alert("1차 평가자를 입력해주세요.");
                return false;
            }
            //alert($("#twoUserId_"+userid+"").val());
            if(($("#twoUserId_"+userid+"").val()!="null" && $("#twoUserId_"+userid+"").val()!="" && $("#twoWeight_"+userid+"").val()=="") || ($("#twoUserId_"+userid+"").val()!="null" && $("#twoUserId_"+userid+"").val()!="" && $("#twoWeight_"+userid+"").val()=="0")){
                alert("2차 평가자 가중치를 입력해주세요.");
                return false;
            }
            if((($("#twoUserId_"+userid+"").val()=="null" || $("#twoUserId_"+userid+"").val()=="") && $("#twoWeight_"+userid+"").val()!="") && (($("#twoUserId_"+userid+"").val()=="null" || $("#twoUserId_"+userid+"").val()=="") && $("#twoWeight_"+userid+"").val()!="0")){
                alert("2차 평가자를 입력해주세요.");
                return false;
            }
			
			  var wei = 0;
			  var sw=0, ow=0, tw=0, cw=0, sbw=0, cwp=0, sbwp=0;
			  var cwc = $("#colCnt_"+userid+"").val();
			  var sbwc = $("#subCnt_"+userid+"").val();
			  
			  if($("#selfWeight_"+userid+"").val()!=null && $("#selfWeight_"+userid+"").val()!="null" && $("#selfWeight_"+userid+"").val()!=""){
				  sw = parseFloat($("#selfWeight_"+userid+"").val());
			  }
			  if($("#oneWeight_"+userid+"").val()!=null && $("#oneWeight_"+userid+"").val()!="null" && $("#oneWeight_"+userid+"").val()!=""){
				  ow = parseFloat($("#oneWeight_"+userid+"").val());
              }
			  if($("#twoWeight_"+userid+"").val()!=null && $("#twoWeight_"+userid+"").val()!="null" && $("#twoWeight_"+userid+"").val()!=""){
				  tw = parseFloat($("#twoWeight_"+userid+"").val());
              }
			  if($("#colWeight_"+userid+"").val()!=null && $("#colWeight_"+userid+"").val()!="null" && $("#colWeight_"+userid+"").val()!=""){
				  cw = parseFloat($("#colWeight_"+userid+"").val());
              }
			  if($("#subWeight_"+userid+"").val()!=null && $("#subWeight_"+userid+"").val()!="null" && $("#subWeight_"+userid+"").val()!=""){
				  sbw = parseFloat($("#subWeight_"+userid+"").val());
              }
			  
// 			  cwp = cw * cwc;
// 			  sbwp = sbw * sbwc;
			  
			  wei = sw + ow + tw + cw + sbw;
			  if(wei != 100){
				  alert("가중치의 합이 100이어야 합니다. (현재:"+wei+")");
				  return false;
			  }
			  
			  if($("#twoUserId_"+userid+"").val()!=null && $("#twoUserId_"+userid+"").val()!="null" && $("#twoUserId_"+userid+"").val()!="" && ( $("#oneUserId_"+userid).val()==null || $("#oneUserId_"+userid).val()=="null" || $("#oneUserId_"+userid).val()==""  ) ){
	                alert("1차평가자가 존재하지 않습니다.\n1차평가자를 추가하거나 2차평가자를 1차로 채워서 설정하시길 바랍니다.");
	                return false;
	            }
			  
			  
			var isDel = confirm(""+name+"님의 데이터를 저장 하시겠습니까?                                        "+name+"님 이외에 저장되지 않은 설정값들은 초기화됩니다.                                                                                                                  ※전체 저장을 원하시면 상단의 저장 버튼을 이용해주세요.  ");
            if(isDel){
        		var params = {
        			DIVISIONID  : dvsId,
        			USERID  : userid,
        			JOB : job,
        			LEADERSHIP: ldr,
        			SELF_WEIGHT : $("#selfWeight_"+userid+"").val(),
        			COL_USERID : $("#colUserId_"+userid+"").val().replace("null",""), 
        			COL_WEIGHT : $("#colWeight_"+userid+"").val(),
        			SUB_USERID : $("#subUserId_"+userid+"").val().replace("null",""), 
        			SUB_WEIGHT : $("#subWeight_"+userid+"").val(),
        			ONE_USERID : $("#oneUserId_"+userid+"").val().replace("null",""), 
        			ONE_WEIGHT : $("#oneWeight_"+userid+"").val(), 
        			TWO_USERID : $("#twoUserId_"+userid+"").val().replace("null",""),
        			TWO_WEIGHT : $("#twoWeight_"+userid+"").val(),
        			RUN_NUM : $("#runNumber").val(),
        			CHECKFLAG : $("#singleChkFlag_"+userid+"").val()
         		};
        		
        		$.ajax({
        			type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_single_target_save_v2.do?output=json",
					data : { item: kendo.stringify( params ) },
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
 						if(obj.saveCount != 0){
 							setDataSource('N');	
 							alert("저장되었습니다.");	
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
		
		function singleDel(userid, name, s_start_date){
			if($("#runNumber").val()==null || $("#runNumber").val()==""){
                alert("평가를 선택해주세요.");
                return false;
            }
			
       		if($("#periodFlag").val()=="O" || $("#periodFlag").val()=="O"){
                alert("진단이 시작되어 평가자 설정이 불가합니다, 평가자 설정을 원하시는 경우 진단기간을 조정해 주시기 바랍니다.");
                return false;
            }
       		
            if(s_start_date!=null && s_start_date!="null" && s_start_date!="" ){
            	alert("이미 역량평가를 진행한 상태로 설정값을 변경할 수 없습니다.");
            	return false;
            }
            var isDel = confirm(name + "님의 평가설정 정보를 삭제 하시겠습니까?\n확인을 클릭하시면 설정된 평가정보가 초기화됩니다.");
            if(isDel){
                var params = {
                    USERID  : userid,
                    RUN_NUM : $("#runNumber").val()
                };
                
                $.ajax({
                    type : 'POST',
                    url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_single_target_del_v2.do?output=json",
                    data : { item: kendo.stringify( params ) },
                    complete : function( response ){
                        var obj  = eval("(" + response.responseText + ")");
                        if(obj.saveCount != 0){
                            setDataSource('N'); 
                            alert("삭제되었습니다.");  
                        }else{
                            alert("삭제에 실패 하였습니다.");
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
		
		function modifyYnFlag(checkbox, userid){
			
			var array = dataSource.data();
			var res = $.grep(array, function (e) {
	            return e.USERID == userid;
	        });
	        
			if(checkbox.checked == true){
				res[0].CHECKFLAG = 'checked=\"1\"';
				$("#singleChkFlag_"+userid+"").val('checked=\"1\"');
				$("#singleSave_"+userid+"").show();
				$("#selfWeight_"+userid+"").show();
				$("#oneName_"+userid+"").show();
				$("#oneSearch_"+userid+"").show();
				$("#oneWeight_"+userid+"").show();
				$("#colSearch_"+userid+"").show();
				$("#colWeight_"+userid+"").show();
				$("#colCnt_"+userid+"").show();
				$("#subSearch_"+userid+"").show();
				$("#subCnt_"+userid+"").show();
				$("#subWeight_"+userid+"").show();
				$("#twoName_"+userid+"").show();
				$("#twoSearch_"+userid+"").show();
				$("#twoWeight_"+userid+"").show();
				$("#singleDel_"+userid+"").show();
				$("#s_span_"+userid+"").show();
				$("#c_span_"+userid+"").show();
				$("#c_cnt_"+userid+"").show();
				$("#s_cnt_"+userid+"").show();
				$("#b_span_"+userid+"").show();
				$("#o_span_"+userid+"").show();
				$("#t_span_"+userid+"").show();
				$("#colInit_"+userid+"").show();
				$("#subInit_"+userid+"").show();
				$("#oneInit_"+userid+"").show();
				$("#twoInit_"+userid+"").show();
			}else{
				res[0].CHECKFLAG = "N";	
				$("#singleChkFlag_"+userid+"").val("N");
				$("#singleSave_"+userid+"").hide();
				$("#selfWeight_"+userid+"").hide();
				$("#oneName_"+userid+"").hide();
				$("#oneSearch_"+userid+"").hide();
				$("#oneWeight_"+userid+"").hide();
				$("#colSearch_"+userid+"").hide();
				$("#colWeight_"+userid+"").hide();
				$("#colCnt_"+userid+"").hide();
				$("#subSearch_"+userid+"").hide();
				$("#subWeight_"+userid+"").hide();
				$("#subCnt_"+userid+"").hide();
				$("#twoName_"+userid+"").hide();
				$("#twoSearch_"+userid+"").hide();
				$("#twoWeight_"+userid+"").hide();
                $("#singleDel_"+userid+"").hide();
                $("#s_span_"+userid+"").hide();
                $("#c_span_"+userid+"").hide();
                $("#c_cnt_"+userid+"").hide();
                $("#s_cnt_"+userid+"").hide();
                $("#b_span_"+userid+"").hide(); 
                $("#o_span_"+userid+"").hide();
                $("#t_span_"+userid+"").hide();
                $("#colInit_"+userid+"").hide();
                $("#subInit_"+userid+"").hide();
                $("#oneInit_"+userid+"").hide();
                $("#twoInit_"+userid+"").hide();
                
			}
			//$("#grid").data("kendoGrid").refresh();
	   }		
		
  		function modifyYnFlag2(checkbox, userid, flag){
  			var colUserid = "";
  			var colUserChk = $("#colUserChk").val();
  			
			if(flag == "4"){          //부하평가 일경우
    			colUserid = $("#colUserId_"+colUserChk+"").val();
			}else if(flag == "3"){    //동료평가 일경우
	    		colUserid = $("#subUserId_"+colUserChk+"").val();
			}
  			
 			var array = $('#lst-add-user-window-selecter-grid').data('kendoGrid').dataSource.data();
			var res = $.grep(array, function (e) {
	            return e.USERID == userid;
	        });
			
			if(flag == "3"){     //동료평가 일경우
				var cutTmp = colUserid.split(",");
				for(var i = 0 ; i < cutTmp.length ; i ++ ){
					if(cutTmp[i] == userid){
						alert("선택하신 사용자는 부하평가자로 이미 설정되어있습니다.");
						res[0].CHECKFLAG = 'N';
			 			$("#lst-add-user-window-selecter-grid").data("kendoGrid").refresh();
			 			return false;
					}
				}
			}
			if(flag == "4"){   //부하평가 일경우
				var cutTmp = colUserid.split(',');
				for(var i = 0 ; i < cutTmp.length ; i ++ ){
					if(cutTmp[i] == userid){
						alert("선택하신 사용자는 동료평가자로 이미 설정되어있습니다.");
						res[0].CHECKFLAG = 'N';
			 			$("#lst-add-user-window-selecter-grid").data("kendoGrid").refresh();
			 			return false;
					}
				}
			}
			
	    		if($("#oneUserId_"+colUserChk+"").val() == userid) {
	    			alert("선택하신 사용자는 1차 평가자로 설정되어있습니다.");
	    			res[0].CHECKFLAG = 'N';
		 			$("#lst-add-user-window-selecter-grid").data("kendoGrid").refresh();
	    			return false;
	    		}
	    		
	    		if($("#twoUserId_"+colUserChk+"").val() == userid) {
	    			alert("선택하신 사용자는 2차 평가자로 설정되어있습니다.");
	    			res[0].CHECKFLAG = 'N';
		 			$("#lst-add-user-window-selecter-grid").data("kendoGrid").refresh();
	    			return false;
	    		}
    	
 			if(checkbox.checked == true){
 				res[0].CHECKFLAG = 'checked=\"1\"';
 			}else{
 				res[0].CHECKFLAG = 'N';
 			}
 			

 	   }
  		
  		
  		
		
		function modifyAllCheck(checkbox){
			
			var array =  dataSource.view();			

			if(checkbox.checked == true){
				for(var i = 0 ; i < array.length ; i ++ ){
					array[i].CHECKFLAG = "checked=\"1\"";
				}
			}else{
				for(var i = 0 ; i < array.length ; i ++ ){
					array[i].CHECKFLAG = "N";
				}
			}			
			$("#grid").data("kendoGrid").refresh();			
	   }
		
		function modifyAllCheck2(checkbox){
			
			var array = $('#lst-add-user-window-selecter-grid').data('kendoGrid').dataSource.view();	

			if(checkbox.checked == true){
				for(var i = 0 ; i < array.length ; i ++ ){
					array[i].CHECKFLAG = "checked=\"1\"";
				}
			}else{
				for(var i = 0 ; i < array.length ; i ++ ){
					array[i].CHECKFLAG = "N";
				}
			}			
			$("#lst-add-user-window-selecter-grid").data("kendoGrid").refresh();			
	   }
		
		function filterCheck(){

			var selectedFlag =$(':radio[id="selectedFlag"]:checked').val();
			
			if(selectedFlag==null){
				selectedFlag = "ALL"
			}
			
			if(selectedFlag=="ALL"){
				dataSource.filter({field : "CHECKFLAG", operator: "neq", value: "not"});
			}else if(selectedFlag=="Y"){
				dataSource.filter({field : "CHECKFLAG", operator: "eq", value: "checked=\"1\""});
			}else{
				dataSource.filter({field : "CHECKFLAG", operator: "eq", value: ""});
			}
			
			$("#peopleCount").html();
	   }
		
		
		
	   function buttonEvent(){
		   

		   
		   $("#excelUBtn").click( function(){
			   if($("#runNumber").val()==null || $("#runNumber").val()==""){
	                alert("평가를 선택해주세요.");
	                return false;
	            }
			   
	       		if($("#periodFlag").val()=="O" || $("#periodFlag").val()=="O"){
	                alert("진단이 시작되어 평가자 설정이 불가합니다, 평가자 설정을 원하시는 경우 진단기간을 조정해 주시기 바랍니다.");
	                return false;
	            }
			   
		        $('#excel-upload-window').data("kendoWindow").center();      
		        $("#excel-upload-window").data("kendoWindow").open();
		        $("#runNum").val($("#runNumber").val());
		    });
		   
		   if( !$("#excel-upload-window").data("kendoWindow") ){		

		    	$("#excel-upload-window").kendoWindow({
		    		width:"340px",
		    		minWidth:"320px",
		    		resizable : false,
		    		title : "엑셀 업로드",
                   modal: true,
                   visible: false
		    	});
			 }   	   
		   
		   if( ! $("files").data("kendoUpload") ){	
				$("#files").kendoUpload({
	     			multiple : false,
	     			showFileList : true,
	     			localization : { select: '파일 선택'
	     			 },
	     			 async: {					   
					    autoUpload: false
				    },
				    
	     		});						
			}
		   
		   $("#uploadBtn").click( function() {
			  	  
		        $("#excel-upload-window").data("kendoWindow").close();
		         
		      });
		   
		  // 가중치 일괄적용버튼 클릭시
		   $("#weightCommit").click( function(){
			    
		        //필터된 데이터만 가중치 값 적용..
                var userGrid = $("#grid").data("kendoGrid").dataSource;
                var filters = userGrid.filter();
                var allData = userGrid.data();
                var query = new kendo.data.Query(allData);
                var data = query.filter(filters).data;
                
                for(var i=0; i<data.length; i++){
                	var dataItem = data[i];
                    
                    if(dataItem.CHECKFLAG == "checked=\"1\""){
                        dataItem.SELF_WEIGHT = $("#runSelfWei").val();
                        $("#selfWeight_"+dataItem.USERID+"").val($("#runSelfWei").val());
                        
                        dataItem.ONE_WEIGHT = $("#runOneWei").val();   
                        $("#oneWeight_"+dataItem.USERID+"").val($("#runOneWei").val());
                        
                        dataItem.TWO_WEIGHT = $("#runTwoWei").val();         
                        $("#twoWeight_"+dataItem.USERID+"").val($("#runTwoWei").val());  
                        
                        dataItem.COL_WEIGHT = $("#runColWei").val();         
                        $("#colWeight_"+dataItem.USERID+"").val($("#runColWei").val());  
                        
                        dataItem.SUB_WEIGHT = $("#runSubWei").val();         
                        $("#subWeight_"+dataItem.USERID+"").val($("#runSubWei").val());  
                    }else{
                        dataItem.SELF_WEIGHT = "";
                        $("#selfWeight_"+dataItem.USERID+"").val("");
                        dataItem.ONE_WEIGHT = "";   
                        $("#oneWeight_"+dataItem.USERID+"").val("");
                        dataItem.TWO_WEIGHT = "";        
                        $("#twoWeight_"+dataItem.USERID+"").val(""); 
                        dataItem.COL_WEIGHT = "";         
                        $("#colWeight_"+dataItem.USERID+"").val("");  
                        dataItem.SUB_WEIGHT = "";         
                        $("#subWeight_"+dataItem.USERID+"").val("");  
                    }//end if     
                }
		      
				 	 
         	});
		    

	          //평가자 일괄적용버튼 클릭시
	           $("#evlerCommit").click( function(){  
	                
	                //필터된 데이터만 가중치 값 적용..
	                var userGrid = $("#grid").data("kendoGrid").dataSource;
	                var filters = userGrid.filter();
	                var allData = userGrid.data();
	                var query = new kendo.data.Query(allData);
	                var data = query.filter(filters).data;
	                
	                for(var i=0; i<data.length; i++){
	                    var dataItem = data[i];
	                    
	                    if(dataItem.CHECKFLAG == "checked=\"1\""){
	                    	//alert(dataItem.USERID +"-"+ $("#oneEvl").val());
	                        if(dataItem.USERID != $("#oneEvl").val()){
	                        
	                        	dataItem.ONE_USERID = $("#oneEvl").val();
	                            dataItem.ONE_NAME = $("#oneEvlNm").val();
	                            
	                            $("#oneUserId_"+dataItem.USERID+"").val( $("#oneEvl").val() );
	                            $("#oneName_"+dataItem.USERID+"").val( $("#oneEvlNm").val() );
	                            
	                        }else{
	                        	dataItem.ONE_USERID = "";
                                dataItem.ONE_NAME = "";
                                
                                $("#oneUserId_"+dataItem.USERID+"").val( "" );
                                $("#oneName_"+dataItem.USERID+"").val( "" );
	                        }
	                        
	                        if(dataItem.USERID != $("#twoEvl").val()){
	                        	
	                        	dataItem.TWO_USERID = $("#twoEvl").val();
	                            dataItem.TWO_NAME = $("#twoEvlNm").val();
	                        
	                            $("#twoUserId_"+dataItem.USERID+"").val( $("#twoEvl").val() );
	                            $("#twoName_"+dataItem.USERID+"").val( $("#twoEvlNm").val() );
	                            
	                        }else{
	                        	dataItem.TWO_USERID = "";
                                dataItem.TWO_NAME = "";
                            
                                $("#twoUserId_"+dataItem.USERID+"").val( "" );
                                $("#twoName_"+dataItem.USERID+"").val( "" );
	                        }
	                    	
	                                      
	                    }else{
	                        
	                    	dataItem.ONE_USERID = "";
                            dataItem.ONE_NAME = "";
                            dataItem.TWO_USERID = "";
                            dataItem.TWO_NAME = "";
                            
                            $("#oneUserId_"+dataItem.USERID+"").val( "" );
                            $("#oneName_"+dataItem.USERID+"").val( "" );
                            $("#twoUserId_"+dataItem.USERID+"").val( "" );
                            $("#twoName_"+dataItem.USERID+"").val( "" );
                                        
                            
	                    }//end if     
	                }
	              
	                     
	            });
		   
		   
		// dtl save btn add click event
       	  $("#saveBtn").click( function(){
       		if($("#runNumber").val()==null || $("#runNumber").val()==""){
                alert("평가를 선택해주세요.");
                return false;
            }
       		if($("#periodFlag").val()=="O" || $("#periodFlag").val()=="O"){
                alert("진단이 시작되어 평가자 설정이 불가합니다, 평가자 설정을 원하시는 경우 진단기간을 조정해 주시기 바랍니다.");
                return false;
            }
       		
       		var array = $('#grid').data('kendoGrid').dataSource.data();
       		for(var i=0; i<array.length; i++){
       			var userid = array[i].USERID;
       			var userNm = array[i].NAME;
       		  
       			if(array[i].CHECKFLAG == "checked=\"1\""){
       				if((array[i].SELF_WEIGHT==null || array[i].SELF_WEIGHT=="null" || array[i].SELF_WEIGHT=="") || (array[i].SELF_WEIGHT=="0")){
		                alert(userNm+"님의 "+"자가 가중치를 입력해주세요.");
		                return false;
		            }
       			 	if((array[i].COL_USERID!=null && array[i].COL_USERID!="null" && array[i].COL_USERID!="" && (array[i].COL_WEIGHT==null || array[i].COL_WEIGHT=="null" || array[i].COL_WEIGHT=="")) || (array[i].COL_USERID!=null && array[i].COL_USERID!="null" && array[i].COL_USERID!="" && (array[i].COL_WEIGHT=="0")) ){
		                alert(userNm+"님의 "+"동료 평가자 가중치를 입력해주세요.");
		                return false;
		            }
		            if((array[i].COL_USERID==null || array[i].COL_USERID=="null" || array[i].COL_USERID=="") && (array[i].COL_WEIGHT!=null && array[i].COL_WEIGHT!="null" && array[i].COL_WEIGHT!="") && (array[i].COL_USERID==null || array[i].COL_USERID=="null" || array[i].COL_USERID=="") && (array[i].COL_WEIGHT!="0")){
		                alert(userNm+"님의 "+"동료 평가자를 입력해주세요.");
		                return false;
		            }
       			 	if((array[i].SUB_USERID!=null && array[i].SUB_USERID!="null" && array[i].SUB_USERID!="" && (array[i].SUB_WEIGHT==null || array[i].SUB_WEIGHT=="null" || array[i].SUB_WEIGHT=="")) || (array[i].SUB_USERID!=null && array[i].SUB_USERID!="null" && array[i].SUB_USERID!="" && (array[i].SUB_WEIGHT=="0")) ){
		                alert(userNm+"님의 "+"부하 평가자 가중치를 입력해주세요.");
		                return false;
		            }
		            if((array[i].SUB_USERID==null || array[i].SUB_USERID=="null" || array[i].SUB_USERID=="") && (array[i].SUB_WEIGHT!=null && array[i].SUB_WEIGHT!="null" && array[i].SUB_WEIGHT!="") && (array[i].SUB_USERID==null || array[i].SUB_USERID=="null" || array[i].SUB_USERID=="") && (array[i].SUB_WEIGHT!="0")){
		                alert(userNm+"님의 "+"부하 평가자를 입력해주세요.");
		                return false;
		            }
		            if((array[i].ONE_USERID!=null && array[i].ONE_USERID!="null" && array[i].ONE_USERID!="" && (array[i].ONE_WEIGHT==null || array[i].ONE_WEIGHT=="null" || array[i].ONE_WEIGHT=="")) || (array[i].ONE_USERID!=null && array[i].ONE_USERID!="null" && array[i].ONE_USERID!="" && (array[i].ONE_WEIGHT=="0"))){
		                alert(userNm+"님의 "+"1차 평가자 가중치를 입력해주세요.");
		                return false;
		            }
		            if(((array[i].ONE_USERID==null || array[i].ONE_USERID=="null" || array[i].ONE_USERID=="") && (array[i].ONE_WEIGHT!=null && array[i].ONE_WEIGHT!="null" && array[i].ONE_WEIGHT!="")) && ((array[i].ONE_USERID==null || array[i].ONE_USERID=="null" || array[i].ONE_USERID=="") && (array[i].ONE_WEIGHT!="0"))){
		                alert(userNm+"님의 "+"1차 평가자를 입력해주세요.");
		                return false;
		            }
		            //alert($("#twoUserId_"+userid+"").val());
		            if((array[i].TWO_USERID!=null && array[i].TWO_USERID!="null" && array[i].TWO_USERID!="" && (array[i].TWO_WEIGHT==null || array[i].TWO_WEIGHT=="null" || array[i].TWO_WEIGHT=="")) || (array[i].TWO_USERID!=null && array[i].TWO_USERID!="null" && array[i].TWO_USERID!="" && (array[i].TWO_WEIGHT=="0"))){
		                alert(userNm+"님의 "+"2차 평가자 가중치를 입력해주세요.");
		                return false;
		            }
		            if(((array[i].TWO_USERID==null || array[i].TWO_USERID=="null" || array[i].TWO_USERID=="") && (array[i].TWO_WEIGHT!=null && array[i].TWO_WEIGHT!="null" && array[i].TWO_WEIGHT!="")) && ((array[i].TWO_USERID==null || array[i].TWO_USERID=="null" || array[i].TWO_USERID=="") && (array[i].TWO_WEIGHT!="0"))){
		                alert(userNm+"님의 "+"2차 평가자를 입력해주세요.");
		                return false;
		            }
		            
					  var wei = 0;
					  var sw=0, ow=0, tw=0, cw=0, sbw=0, cwp=0, sbwp=0;
					  var cwc = $("#colCnt_"+userid+"").val();
					  var sbwc = $("#subCnt_"+userid+"").val();
					  
		              if(array[i].SELF_WEIGHT!=null && array[i].SELF_WEIGHT!="null" && array[i].SELF_WEIGHT!=""){
		                  sw = parseFloat(array[i].SELF_WEIGHT);
		              }
		              if(array[i].ONE_WEIGHT!=null && array[i].ONE_WEIGHT!="null" && array[i].ONE_WEIGHT!=""){
		                  ow = parseFloat(array[i].ONE_WEIGHT);
		              }
		              if(array[i].TWO_WEIGHT!=null && array[i].TWO_WEIGHT!="null" && array[i].TWO_WEIGHT!=""){
		                  tw = parseFloat(array[i].TWO_WEIGHT);
		              }
		              if(array[i].COL_WEIGHT!=null && array[i].COL_WEIGHT!="null" && array[i].COL_WEIGHT!=""){
		                  cw = parseFloat(array[i].COL_WEIGHT);
		              }
		              if(array[i].SUB_WEIGHT!=null && array[i].SUB_WEIGHT!="null" && array[i].SUB_WEIGHT!=""){
		            	  sbw = parseFloat(array[i].SUB_WEIGHT);
		              }
		              
// 		              cwp = cw * cwc;
// 					  sbwp = sbw * sbwc;
					  
					  wei = sw + ow + tw + cw + sbw;
		              
		              if(wei != 100){
		            	  alert(userNm+"님의 "+"가중치의 합이 100이어야 합니다. (현재:"+wei+")");
		                  return false;
		              }
		              
		              if(array[i].TWO_USERID!=null && array[i].TWO_USERID!="null" && array[i].TWO_USERID!="" && ( array[i].ONE_USERID==null || array[i].ONE_USERID=="null" || array[i].ONE_USERID==""  ) ){
		                    alert(userNm+"님의 1차평가자가 존재하지 않습니다.\n1차평가자를 추가하거나 2차평가자를 1차로 채워서 설정하시길 바랍니다.");
		                    return false;
		              }
                }
            }
              
              
              
       			var isDel = confirm("평가 대상자를 저장하시겠습니까?");
				 	 if(isDel){
				 		 
				 		$("#loading-window").data("kendoWindow").center();
		                $("#loading-window").data("kendoWindow").open();
		                
				 		//로딩바 생성...
                         winElement.append(loadingElement());
				 		
				 		var params = {
	             			LIST :  $('#grid').data('kendoGrid').dataSource.data() 
	  	           		};

	             		
	             		$.ajax({
	             			type : 'POST',
	     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_target_save.do?output=json",
	     					data : { item: kendo.stringify( params ), RUN_NUM : $("#runNumber").val()},
	     					complete : function( response ){
	     						//로딩바 제거..
                                winElement.find(".k-loading-mask").remove();
                                $("#loading-window").data("kendoWindow").close();
                                
	     						var obj  = eval("(" + response.responseText + ")");
	     						if(obj.saveCount != 0){
	     							dataSource.read();	
	     							alert("저장되었습니다.");	
	     						}else{
	     							alert("저장에 실패 하였습니다.");
	     						}							
	     					},
	     					error: function( xhr, ajaxOptions, thrownError){
	     						//로딩바 제거..
                                winElement.find(".k-loading-mask").remove();
                                $("#loading-window").data("kendoWindow").close();
                                
                                alert('xrs.status = ' + xhr.status + '\n' + 
                                        'thrown error = ' + thrownError + '\n' +
                                        'xhr.statusText = '  + xhr.statusText + '\n세션이 종료되었습니다.' );
                            	sessionout();
                                
	     					},
	     					dataType : "json"
	     				});		
				 	}
          	});
			
	   }
	   
       function openwindow(dataSource) {
    	  
    	    $("#grid").empty();
    	   
    	    $("#grid").kendoGrid({
	               dataSource: dataSource,
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
	               pageable: {  messages: { display: '{1} / {2}' }  }, 
	               columns: [			
		                  {
		                      field:"CHECKFLAG",
		                      title: "선택",
		                      filterable: false,
		                      sortable: false,
						      width:50,
						   	  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						   	  attributes:{"class":"table-cell", style:"text-align:center"},
						   	  headerTemplate: "선택<br><input type='checkbox' onchange='modifyAllCheck(this);' />",
							  template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag(this, #: USERID #)\" #: CHECKFLAG #\></div>" 
		                  },
		                  {
		                      field: "DVS_NAME",
		                      title: "부서",
							   width:190,
							   editable:true,
							   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
							   attributes:{"class":"table-cell", style:"text-align:left"} 
		                  },
		                  {
		                      field: "NAME",
		                      title: "이름",
							   width:80,
							   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
							   attributes:{"class":"table-cell", style:"text-align:center"} 
		                  },
                          {
                              field: "EMPNO",
                              title: "교직원번호",
                               width:100,
                               headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                               attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          {
                              field: "JOB_NM",
                              title: "직무",
                               width:120,
                               headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                               attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
                          {
                              field: "LEADERSHIP_NM",
                              title: "계층",
                               width:120,
                               headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                               attributes:{"class":"table-cell", style:"text-align:left"} 
                          },
		                  {
		                      field: "SELF_WEIGHT",
		                      title: "자가가중치",
		                      filterable: false,
                              sortable: false,
		                      width:100,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"},
		                      template: kendo.template($("#selfWeightTemplate").html())
		                  },
                          {
		                      field: "COL_USERID",
		                      title: "동료 평가자(가중치%)",
		                      filterable: false,
                              sortable: false,
		                      width:250,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"},
 		                  	  template: kendo.template($("#colNmTemplate").html())
//  						  template: "<button id =\"a\" class=\"k-button\" onclick=\"oneUserSearchBtn(#: ROWNUMBER #, #: HIGH_DVSID #)\" #: CHECKFLAG #><span class=\"\"></span>검색</button>"  ,							  
// 							  editor: categoryDropDownEditor
		                  },
                          {
		                      field: "SUB_USERID",
		                      title: "부하 평가자(가중치%)",
		                      filterable: false,
                              sortable: false,
		                      width:250,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"},
 		                  	  template: kendo.template($("#subNmTemplate").html())
//  						  template: "<button id =\"a\" class=\"k-button\" onclick=\"oneUserSearchBtn(#: ROWNUMBER #, #: HIGH_DVSID #)\" #: CHECKFLAG #><span class=\"\"></span>검색</button>"  ,							  
// 							  editor: categoryDropDownEditor
		                  },
		                  {
		                      field: "ONE_NAME",
		                      title: "1차 평가자(가중치%)",
		                      filterable: false,
                              sortable: false,
		                      width:330,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"},
 		                  	  template: kendo.template($("#oneNmTemplate").html())
//  						  template: "<button id =\"a\" class=\"k-button\" onclick=\"oneUserSearchBtn(#: ROWNUMBER #, #: HIGH_DVSID #)\" #: CHECKFLAG #><span class=\"\"></span>검색</button>"  ,							  
// 							  editor: categoryDropDownEditor
		                  },/*
		                  { 	
		                	    title: "", 
			                	width: 100,
			                	template: kendo.template($("#oneSearchTemplate").html())
// 			                	template: "<button id =\"a\" class=\"k-button\" onclick=\"oneUserSearchBtn(#: ROWNUMBER #, #: HIGH_DVSID #,1)\"><span class=\"\"></span>검색</button>"
		                  },
		                  {
		                      field: "ONE_WEIGHT",
		                      title: "1차 평가 가중치",
		                      filterable: false,
		                      width:170,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"},
		                      template: kendo.template($("#oneWeightTemplate").html())
		                  },*/
		                  {
		                      field: "TWO_NAME",
		                      title: "2차 평가자(가중치%)",
		                      filterable: false,
                              sortable: false,
		                      width:330,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"},
		                      template: kendo.template($("#twoNmTemplate").html())
		                  },/*
		                  {     title: "",
			                	width: 100,
			                	template: kendo.template($("#twoSearchTemplate").html())
// 			                	template: "<button id =\"a\" class=\"k-button\" onclick=\"oneUserSearchBtn(#: ROWNUMBER #, #: DIVISIONID #,2)\"><span class=\"\"></span>검색</button>"
		                  },
		                  {
		                      field: "TWO_WEIGHT",
		                      title: "2차 평가 가중치",
		                      filterable: false,
		                      width:170,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"},
		                      template: kendo.template($("#twoWeightTemplate").html())
		                  },*/
		                  { title: "저장/삭제", 
		                	width: 170,
                            sortable: false,
                            headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                            attributes:{"class":"table-cell", style:"text-align:center"},
		                	template: kendo.template($("#singleSaveTemplate").html())
// 		                	template: "<button id =\"a\" class=\"k-button\" onclick=\"singleSave(#: CHECKFLAG #, #: DIVISIONID #, #: USERID #, #: SELF_WEIGHT #, #: ONE_USERID #, #: ONE_WEIGHT #, #: TWO_USERID #, #: TWO_WEIGHT #)\"><span class=\"k-icon k-i-plus\"></span>저장</button>" 
		                  }
		              ]               
	           });	    	
	       }
       
       
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
       		'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
       	 	'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
      	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js', 
       	 '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js'
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
              //브라우저 resize 이벤트 dispatch..
              $(window).resize();
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
        	 
        	  $("#runNumber").kendoComboBox({
					dataTextField : "TEXT",
					dataValueField : "VALUE",
					dataSource : dataSource_run,
					suggest : true,
					index : 0,
					change : function() {
						runChange();
					},
					dataBound:function(e){
	                  //alert("11");
	                  $("#runNumber").data("kendoComboBox").select(0);
	                  runChange();
	              }
				});

				//setDataSource('Y');

				buttonEvent();
				
				dataSource_run.fetch(function(){
	                  if(dataSource_run.data().length>0){
	                      if($("#runNumber").val()!=""){
	                    	  for ( var i = 0; i < dataSource_run.data().length; i++) {
	                              var dataItem = dataSource_run.data()[i];

	                              if ($("#runNumber").val() == dataItem.VALUE) {
	                                  setDataSource('N',
	                                          dataItem.SELF_WEIGHT,
	                                          dataItem.ONE_WEIGHT,
	                                          dataItem.TWO_WEIGHT,
	                                          dataItem.COL_WEIGHT,
	                                          dataItem.SUB_WEIGHT,
	                                          dataItem.PERIOD_FLAG);
	                                  
	                                  break;
	                              } // end if
	                          } // end for                
	                          
//	                    	  setDataSource('N');
	                      }
	                  }  else{
	                	  setDataSource('N', '', '', '', '', '', '');
	                  }
	              });
				
				//로딩윈도우
				if( !$("#loading-window").data("kendoWindow") ){
                    winElement = $("#loading-window").kendoWindow({
                        width:"100px",
                        minHeight:"0px",
                        resizable : true,
                        title : false,
                        modal: true,
                        visible: false
                    });
				}
				
				
				
			}
		} ]);
        
        function runFilter(){
            if($("#yyyy").val()!=null && $("#yyyy").val()!=""){
                $("#runNumber").data("kendoComboBox").dataSource.filter({
                    "field":"YYYY",
                    "operator":"eq",
                    "value":Number($("#yyyy").val())
                });
            }else{
                $("#runNumber").data("kendoComboBox").dataSource.filter({});
            }
        }
        
        function runChange(){

            var data = dataSource_run.data();

            for ( var i = 0; i < data.length; i++) {

                var dataItem = data[i];

                if ($("#runNumber").val() == dataItem.VALUE) {
                    selectedCell = dataItem;

                    setDataSource('N',
                            dataItem.SELF_WEIGHT,
                            dataItem.ONE_WEIGHT,
                            dataItem.TWO_WEIGHT,
                            dataItem.COL_WEIGHT,
                            dataItem.SUB_WEIGHT,
                            dataItem.PERIOD_FLAG);

                    break;
                } // end if
            } // end for                        

        }
        //로딩바 ... 평가 생성하는데 직원이 많을경우 시간이 오래 소요됨.. 
        function loadingElement() {
            return $("<div class='k-loading-mask' style='overflow:hidden;'><span class='k-loading-text'>Loading...</span><div class='k-loading-image'/><div class='k-loading-color'/></div>");
        }
        
        
	</script>
</head>
<body>

<div id="excel-upload-window" style="display:none; width:340px;">
		<form method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/cmpt_target_excel_upload.do?" >
		※ 코드성 데이터조회는 엑셀 코드모음버튼을 클릭 하세요.
	       <div>
	       	   <input type="hidden" id="runNum" name="runNum" value="">
	           <input name="files" id="files" type="file" />
	           </br>
	           <div style="text-align: right;">
	           		<input type="submit" value="엑셀 업로드" class="k-button" id="uploadBtn"/>
	           </div>
	       </div>
	   </form>
   </div>


	<!-- START MAIN CONTNET -->
	
	
	<div id="content">
        <div class="cont_body">
            <div class="title mt30">역량평가자설정</div>
            <div class="table_tin01">
                <ul>
                    <li class="mt10">
                        <label for="runNumber" >평가명</label>
                        <select id="yyyy" style="width:100px;"></select>
                        <select id="runNumber" style="width:350px;"></select>
                    </li>
                    <li>
                    	<input type="hidden" id="divisionId" name="divisionId"/>
                        자가평가 가중치 / 동료평가 가중치 / 부하평가 가중치 / 1차평가자 가중치 / 2차평가자 가중치 <input type="text" id="runSelfWei" style="width:50px; "> / <input type="text" id="runColWei" style="width:50px; "> / <input type="text" id="runSubWei" style="width:50px; ">  / <input type="text" id="runOneWei" style="width:50px; "> / <input type="text" id="runTwoWei" style="width:50px; "> <button id="weightCommit" class="k-button"><span></span>일괄적용</button>
                    </li>
                    <li>
                        <input type="hidden" id="divisionId" name="divisionId"/>
                        <input type="hidden" id="periodFlag" name="periodFlag"/>
                        1차평가자 / 2차평가자 <input type="hidden" id="oneEvl" name="oneEvl" ><input type="text" id="oneEvlNm" style="width:80px; " readOnly> <button id="oneSearch" class="k-button" onclick="userSearchBtn(0, 0, 0, 3)"><span></span>검색</button> <button id="oneInit" class="k-button" onclick="evlInit(1)"><span></span>초기화</button>  /  <input type="hidden" id="twoEvl" name="twoEvl" ><input type="text" id="twoEvlNm" style="width:80px; " readOnly> <button id="twoSearch" class="k-button" onclick="userSearchBtn(0, 0, 0, 4)"><span></span>검색</button> <button id="twoInit" class="k-button" onclick="evlInit(2)"><span></span>초기화</button>  <button id="evlerCommit" class="k-button"><span></span>1,2차 평가자 일괄적용</button>
                    </li>
                    <!-- <li>
                        <input type="hidden" id="divisionId" name="divisionId"/>
                        1차평가자 / 2차평가자 <input type="text" id="runOneWei" style="width:50px; "><button id="weightCommit" class="k-button"><span></span>검색</button> / <input type="text" id="runTwoWei" style="width:50px; "> <button id="weightCommit" class="k-button"><span></span>검색</button>
                    </li> -->
                </ul>
            </div>
            
	        <div class="table_zone" >
                <div class="table_btn">
					<!-- <div style="float:left; width: 130px"><input id="allCheck"  type="checkbox" onchange="modifyAllCheck(this)"> 전체선택/전체해지</div> -->
					<div style="float:left;">※ 부서장일지라도 1차 평가자 설정 필요합니다.</div>
					<a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_common_operator_excel.do" >엑셀 코드모음</a>&nbsp;
					<a class="k-button"  onclick="excelDownload(this)" >엑셀 다운로드</a>&nbsp;
					<button id="excelUBtn" class="k-button" >엑셀 업로드</button>&nbsp;					
					<button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>
	            </div>
	            <div class="table_list">
	                <div id="grid" ></div>
	            </div>
	        </div>
	    </div>
    </div>
	
	
	
	<!-- 평가자 선택 -->
        <div id="lst-add-user-window" style="display:none;">
            <div id="lst-add-user-window-selecter">
                <div id="lst-add-user-window-selecter-grid"></div>
                <div style="float:right; width: 370px">
	                <button id="bindBtn" class="k-button">설정</button>
	                <button id="bindBtn2" class="k-button">설정</button>
	                <button id="cancel-btn" class="k-button">닫기</button>
                </div>
            </div>
	    </div>
	    
	    
	    
	<script id="selfWeightTemplate" type="text/x-kendo-tmpl">
            <input type="hidden" name="userId_#:USERID #" id="userId_#:USERID #" value="#:USERID #" data-bind="value:USERID" >
			# if (CHECKFLAG == "checked=\"1\""){ #


                # if (SELF_WEIGHT == null){ #
                        <input type="text" name="selfWeight_#:USERID #" id="selfWeight_#:USERID #" style="min-width: 60px; width: 60px" value="" data-bind="value:SELF_WEIGHT" onkeyup="chkNull(this); chkNum (this); selfWeightValue(#:USERID #);" ><span id="s_span_#:USERID #" >%</span>
                # }else{ # 
                        <input type="text" name="selfWeight_#:USERID #" id="selfWeight_#:USERID #" style="min-width: 60px; width: 60px" value="#:SELF_WEIGHT #" data-bind="value:SELF_WEIGHT" onkeyup="chkNull(this); chkNum (this); selfWeightValue(#:USERID #);" ><span id="s_span_#:USERID #" >%</span>
                # } #  


            # }else{ #
                        <input type="text" name="selfWeight_#:USERID #" id="selfWeight_#:USERID #" class="selfWeight" style="min-width: 60px; width: 60px; display: none;" value="" data-bind="value:SELF_WEIGHT" onkeyup="chkNull(this); chkNum (this); selfWeightValue(#:USERID #);"  ><span id="s_span_#:USERID #"  style="display: none;" >%</span>

            # } #		
			
	</script>    
	
		<script id="colNmTemplate" type="text/x-kendo-tmpl">
			<input type="hidden" name="colUserId_#:USERID #" id="colUserId_#:USERID #" class="colUserId" value="#:COL_USERID #" data-bind="value:COL_USERID" >
			<input type="hidden" name="colUserChk" id="colUserChk" class="colUserId2"  >
			
            # if (CHECKFLAG == "checked=\"1\""){ #
				
				# if (COL_CNT == null){ #
						<input type="text" name="colCnt_#:USERID #" id="colCnt_#:USERID #" class="colCnt" style="min-width: 20px; width: 20px; background-color:rgb(238,238,238);" value="0" data-bind="value:COL_CNT" onkeyup="chkNull(this); chkNum (this);" readonly="readonly"> <span id="c_cnt_#:USERID #" > 명</span>
				# }else{ #	
						<input type="text" name="colCnt_#:USERID #" id="colCnt_#:USERID #" class="colCnt" style="min-width: 20px; width: 20px; background-color:rgb(238,238,238);" value="#:COL_CNT#" data-bind="value:COL_CNT" onkeyup="chkNull(this); chkNum (this);" readonly="readonly"> <span id="c_cnt_#:USERID #" > 명</span>
				# } #
				
                # if (COL_USERID == null){ #
						
                       <button id ="colSearch_#:USERID #" class="k-button" style="width:45px; min-width:30px;" onclick="userListBtn(#: USERID #, '#:COL_USERID #', 3)"><span class=""></span>검색</button>
				# }else{ #	
                       <button id ="colSearch_#:USERID #" class="k-button" style="width:45px; min-width:30px;" onclick="userListBtn(#: USERID #, '#:COL_USERID #', 3)" style="width:10;display: none; "><span class=""></span>검색</button>	
				# } #	
				
                # if (COL_WEIGHT == null){ #
                        <input type="text" name="colWeight_#:USERID #" id="colWeight_#:USERID #" class="colWeight" style="min-width: 60px; width: 60px" value="" data-bind="value:COL_WEIGHT" onkeyup="chkNull(this); chkNum (this); colWeightValue(#:USERID #); " ><span id="c_span_#:USERID #" >%</span>
                # }else{ # 
                        <input type="text" name="colWeight_#:USERID #" id="colWeight_#:USERID #" class="colWeight" style="min-width: 60px; width: 60px" value="#:COL_WEIGHT #" data-bind="value:COL_WEIGHT" onkeyup="chkNull(this); chkNum (this); colWeightValue(#:USERID #); " ><span id="c_span_#:USERID #" >%</span>
                # } #  

					<button id="colInit_#:USERID #" class="k-button" onclick="fn_colInit(#:USERID #)" style="width:55px; min-width:55px;"><span></span>초기화</button>
            # }else{ #

		

                # if (COL_USERID == null){ #
                        <input type="text" name="colCnt_#:USERID #" id="colCnt_#:USERID #" class="colCnt" style="min-width: 20px; width: 20px; display: none; background-color:rgb(238,238,238);" value="0" data-bind="value:COL_CNT" onkeyup="chkNull(this); chkNum (this);" readonly="readonly"> <span id="c_cnt_#:USERID #" style="display: none;" > 명</span>                              
                        <button id ="colSearch_#:USERID #" class="k-button"  style="width:45px;  min-width:30px; display: none;" onclick="userListBtn(#: USERID #, '#:COL_USERID #', 3)"><span class=""></span>검색</button>
                # }else{ #  
                        <input type="text" name="colCnt_#:USERID #" id="colCnt_#:USERID #" class="colCnt" style="min-width: 20px; width: 20px; display: none; background-color:rgb(238,238,238);" value="#:COL_CNT#" style="width:10;display: none; background-color:rgb(238,238,238);" data-bind="value:COL_CNT" onkeyup="chkNull(this); chkNum (this);"  readonly="readonly">   <span id="c_cnt_#:USERID #" style="display: none;" > 명</span>  
                        <button id ="colSearch_#:USERID #" class="k-button" style="width:45px; min-width:30px; display: none;" onclick="userListBtn(#: USERID #, '#:COL_USERID #', 3)" style="width:10;display: none; "><span class=""></span>검색</button> 
                # } #   

                # if (COL_WEIGHT == null){ #
                        <input type="text" name="colWeight_#:USERID #" id="colWeight_#:USERID #" class="colWeight" style="min-width: 60px; width: 60px; display: none;" value="" data-bind="value:COL_WEIGHT" onkeyup="chkNull(this); chkNum (this); colWeightValue(#:USERID #); " ><span id="c_span_#:USERID #" style="display: none;" >%</span>
                # }else{ # 
                        <input type="text" name="colWeight_#:USERID #" id="colWeight_#:USERID #" class="colWeight" style="min-width: 60px; width: 60px; display: none;" value="#:COL_WEIGHT #" data-bind="value:COL_WEIGHT" onkeyup="chkNull(this); chkNum (this); colWeightValue(#:USERID #); " ><span id="c_span_#:USERID #" style="display: none;"  >%</span>
                # } #  

					<button id="colInit_#:USERID #" class="k-button" onclick="fn_colInit(#:USERID #)" style="width:55px; min-width:55px; display: none;"><span></span>초기화</button>
            # } #			
   
	</script>
	    
			<script id="subNmTemplate" type="text/x-kendo-tmpl">
			<input type="hidden" name="subUserId_#:USERID #" id="subUserId_#:USERID #" class="subUserId" value="#:SUB_USERID #" data-bind="value:SUB_USERID" >
			<input type="hidden" name="subUserChk" id="subUserChk" class="subUserId2"  >
			
            # if (CHECKFLAG == "checked=\"1\""){ #
				  
				# if (SUB_CNT == null){ #
						<input type="text" name="subCnt_#:USERID #" id="subCnt_#:USERID #" class="subCnt" style="min-width: 20px; width: 20px; background-color:rgb(238,238,238);" value="0" data-bind="value:SUB_CNT" onkeyup="chkNull(this); chkNum (this);" readonly="readonly"> <span id="s_cnt_#:USERID #"   > 명</span>
				# }else{ #	
						<input type="text" name="subCnt_#:USERID #" id="subCnt_#:USERID #" class="subCnt" style="min-width: 20px; width: 20px; background-color:rgb(238,238,238);" value="#:SUB_CNT#" data-bind="value:SUB_CNT" onkeyup="chkNull(this); chkNum (this);" readonly="readonly"> <span id="s_cnt_#:USERID #"   > 명</span>
				# } #

                # if (SUB_USERID == null){ #
                        <button id ="subSearch_#:USERID #" class="k-button" style="width:45px; min-width:30px;" onclick="userListBtn(#: USERID #, '#:SUB_USERID #', 4)"><span class=""></span>검색</button>
				# }else{ #	
						<button id ="subSearch_#:USERID #" class="k-button" style="width:45px; min-width:30px;" onclick="userListBtn(#: USERID #, '#:SUB_USERID #', 4)" style="width:10;display: none; "><span class=""></span>검색</button>	
				# } #	

                # if (SUB_WEIGHT == null){ #
                        <input type="text" name="subWeight_#:USERID #" id="subWeight_#:USERID #" class="subWeight" style="min-width: 60px; width: 60px" value="" data-bind="value:SUB_WEIGHT" onkeyup="chkNull(this); chkNum (this); subWeightValue(#:USERID #); " ><span id="b_span_#:USERID #" >%</span>
                # }else{ # 
                        <input type="text" name="subWeight_#:USERID #" id="subWeight_#:USERID #" class="subWeight" style="min-width: 60px; width: 60px" value="#:SUB_WEIGHT #" data-bind="value:SUB_WEIGHT" onkeyup="chkNull(this); chkNum (this); subWeightValue(#:USERID #); " ><span id="b_span_#:USERID #" >%</span>
                # } #  

					<button id="subInit_#:USERID #" class="k-button" onclick="fn_subInit(#:USERID #)" style="width:55px; min-width:55px;"><span></span>초기화</button>
            # }else{ #
                # if (SUB_USERID == null){ #
                        <input type="text" name="subCnt_#:USERID #" id="subCnt_#:USERID #" class="subCnt" style="min-width: 20px; width: 20px; display: none; background-color:rgb(238,238,238);" value="0" data-bind="value:SUB_CNT" onkeyup="chkNull(this); chkNum (this);" ><span id="s_cnt_#:USERID #" style="display: none;"  > 명</span>                
                        <button id ="subSearch_#:USERID #" class="k-button"  style="width:45px;  min-width:30px; display: none;" onclick="userListBtn(#: USERID #, '#:SUB_USERID #', 4)"><span class=""></span>검색</button>
                # }else{ #  
                        <input type="text" name="subCnt_#:USERID #" id="subCnt_#:USERID #" class="subCnt" style="min-width: 20px; width: 20px; display: none; background-color:rgb(238,238,238);" value="#:SUB_CNT#" style="width:10;display: none;" data-bind="value:SUB_CNT" onkeyup="chkNull(this); chkNum (this);" ><span id="s_cnt_#:USERID #" style="display: none;"  > 명</span>                
                        <button id ="subSearch_#:USERID #" class="k-button" style="width:45px;   min-width:30px; display: none;" onclick="userListBtn(#: USERID #, '#:SUB_USERID #', 4)" style="width:10;display: none; "><span class=""></span>검색</button> 
                # } #   

                # if (SUB_WEIGHT == null){ #
                        <input type="text" name="subWeight_#:USERID #" id="subWeight_#:USERID #" class="subWeight" style="min-width: 60px; width: 60px; display: none;" value="" data-bind="value:SUB_WEIGHT" onkeyup="chkNull(this); chkNum (this); subWeightValue(#:USERID #); " ><span id="b_span_#:USERID #" style="display: none;" >%</span>
                # }else{ # 
                        <input type="text" name="subWeight_#:USERID #" id="subWeight_#:USERID #" class="subWeight" style="min-width: 60px; width: 60px; display: none;" value="#:SUB_WEIGHT #" data-bind="value:SUB_WEIGHT" onkeyup="chkNull(this); chkNum (this); subWeightValue(#:USERID #); " ><span id="b_span_#:USERID #" style="display: none;"  >%</span>
                # } #  

					<button id="subInit_#:USERID #" class="k-button" onclick="fn_subInit(#:USERID #)" style="width:55px; min-width:55px; display: none;"><span></span>초기화</button>
            # } #			
   
	</script>    
	    
	<script id="oneNmTemplate" type="text/x-kendo-tmpl">
			<input type="hidden" name="oneUserId_#:USERID #" id="oneUserId_#:USERID #" class="oneUserId" value="#:ONE_USERID #" data-bind="value:ONE_USERID" >
			
            # if (CHECKFLAG == "checked=\"1\""){ #


                # if (ONE_NAME == null){ #
						<input type="text" name="oneName_#:USERID #" id="oneName_#:USERID #" class="disabledInput" style="width:80px; background-color:rgb(238,238,238)" value="" data-bind="value:ONE_NAME" readonly="readonly" >							
                        <button id ="oneSearch_#:USERID #" class="k-button" style="width:45px; min-width:30px;" onclick="userSearchBtn(#: USERID #, #: DIVISIONID #, #: HIGH_DVSID #,1)"><span class=""></span>검색</button>
				# }else{ #	
						<input type="text" name="oneName_#:USERID #" id="oneName_#:USERID #" class="disabledInput" style="width:80px; background-color:rgb(238,238,238)" value="#:ONE_NAME #" data-bind="value:ONE_NAME" readonly="readonly" >
                        <button id ="oneSearch_#:USERID #" class="k-button" style="width:45px; min-width:30px;" onclick="userSearchBtn(#: USERID #, #: DIVISIONID #, #: HIGH_DVSID #,1)" style="width:10;display: none; "><span class=""></span>검색</button>	
				# } #	

                # if (ONE_WEIGHT == null){ #
                        <input type="text" name="oneWeight_#:USERID #" id="oneWeight_#:USERID #" class="oneWeight" style="min-width: 60px; width: 60px" value="" data-bind="value:ONE_WEIGHT" onkeyup="chkNull(this); chkNum (this); oneWeightValue(#:USERID #); " ><span id="o_span_#:USERID #" >%</span>
                # }else{ # 
                        <input type="text" name="oneWeight_#:USERID #" id="oneWeight_#:USERID #" class="oneWeight" style="min-width: 60px; width: 60px" value="#:ONE_WEIGHT #" data-bind="value:ONE_WEIGHT" onkeyup="chkNull(this); chkNum (this); oneWeightValue(#:USERID #); " ><span id="o_span_#:USERID #" >%</span>
                # } #  
                
                        <button id="oneInit_#:USERID #" class="k-button" onclick="fn_oneInit(#:USERID #)" style="width:55px; min-width:55px;"><span></span>초기화</button>

            # }else{ #


                # if (ONE_NAME == null){ #
                        <input type="text" name="oneName_#:USERID #" id="oneName_#:USERID #" class="disabledInput" style="width:80px; background-color:rgb(238,238,238); display: none;" value="" data-bind="value:ONE_NAME" readonly="readonly" >                          
                        <button id ="oneSearch_#:USERID #" class="k-button"  style="width:45px;  min-width:30px; display: none;" onclick="userSearchBtn(#: USERID #, #: DIVISIONID #, #: HIGH_DVSID #,1)"><span class=""></span>검색</button>
                # }else{ #  
                        <input type="text" name="oneName_#:USERID #" id="oneName_#:USERID #" class="disabledInput" style="width:80px; background-color:rgb(238,238,238); display: none;" value="#:ONE_NAME #" data-bind="value:ONE_NAME" readonly="readonly" >
                        <button id ="oneSearch_#:USERID #" class="k-button" style="width:45px; min-width:30px; display: none;" onclick="userSearchBtn(#: USERID #, #: DIVISIONID #, #: HIGH_DVSID #,1)" style="width:10;display: none; "><span class=""></span>검색</button> 
                # } #   

                # if (ONE_WEIGHT == null){ #
                        <input type="text" name="oneWeight_#:USERID #" id="oneWeight_#:USERID #" class="oneWeight" style="min-width: 60px; width: 60px; display: none;" value="" data-bind="value:ONE_WEIGHT" onkeyup="chkNull(this); chkNum (this); oneWeightValue(#:USERID #); " ><span id="o_span_#:USERID #" style="display: none;" >%</span>
                # }else{ # 
                        <input type="text" name="oneWeight_#:USERID #" id="oneWeight_#:USERID #" class="oneWeight" style="min-width: 60px; width: 60px; display: none;" value="#:ONE_WEIGHT #" data-bind="value:ONE_WEIGHT" onkeyup="chkNull(this); chkNum (this); oneWeightValue(#:USERID #); " ><span id="o_span_#:USERID #" style="display: none;"  >%</span>
                # } #  

                        <button id="oneInit_#:USERID #" class="k-button" onclick="fn_oneInit(#:USERID #)" style="width:55px; min-width:55px; display: none;"><span></span>초기화</button>

            # } #			
   
	</script>
	
	<script id="twoNmTemplate" type="text/x-kendo-tmpl">
			<input type="hidden" name="twoUserId_#:USERID #" id="twoUserId_#:USERID #" class="twoUserId"  value="#:TWO_USERID #" data-bind="value:TWO_USERID" >

			# if (CHECKFLAG == "checked=\"1\""){ #


				# if (TWO_NAME == null){ #
						<input type="text" name="twoName_#:USERID #" id="twoName_#:USERID #" class="twoName" style="width:80px;background-color:rgb(238,238,238)" value="" data-bind="value:TWO_NAME" readonly="readonly" >
                        <button id ="twoSearch_#:USERID #" class="k-button" style="width:45px;  min-width:30px;" onclick="userSearchBtn(#: USERID #, #: DIVISIONID #, #: HIGH_DVSID #,2)"><span class=""></span>검색</button>
				# }else{ #	
						<input type="text" name="twoName_#:USERID #" id="twoName_#:USERID #" class="twoName" style="width:80px;background-color:rgb(238,238,238)" value="#:TWO_NAME #" data-bind="value:TWO_NAME" readonly="readonly" >
                        <button id ="twoSearch_#:USERID #" class="k-button" style="width:45px;  min-width:30px;" onclick="userSearchBtn(#: USERID #, #: DIVISIONID #, #: HIGH_DVSID #,2)" style="width:10;display: none; "><span class=""></span>검색</button>
				# } #	

                # if (TWO_WEIGHT == null){ #
                        <input type="text" name="twoWeight_#:USERID #" id="twoWeight_#:USERID #" class="twoWeight" style="min-width: 60px; width: 60px" value="" data-bind="value:TWO_WEIGHT" onkeyup="chkNull(this); chkNum (this); twoWeightValue(#:USERID #); "><span id="t_span_#:USERID #" >%</span>
                # }else{ # 
                        <input type="text" name="twoWeight_#:USERID #" id="twoWeight_#:USERID #" class="twoWeight" style="min-width: 60px; width: 60px" value="#:TWO_WEIGHT #" data-bind="value:TWO_WEIGHT" onkeyup="chkNull(this); chkNum (this); twoWeightValue(#:USERID #); "><span id="t_span_#:USERID #" >%</span>
                # } #  

                        <button id="twoInit_#:USERID #" class="k-button" onclick="fn_twoInit(#:USERID #)" style="width:55px; min-width:55px;"><span></span>초기화</button>

            # }else{ #


                # if (TWO_NAME == null){ #
                        <input type="text" name="twoName_#:USERID #" id="twoName_#:USERID #" class="twoName" style="width:80px;background-color:rgb(238,238,238); display: none;" value="" data-bind="value:TWO_NAME" readonly="readonly" >
                        <button id ="twoSearch_#:USERID #" class="k-button" style="width:45px;  min-width:30px; display: none;" onclick="userSearchBtn(#: USERID #, #: DIVISIONID #, #: HIGH_DVSID #,2)"><span class=""></span>검색</button>
                # }else{ #  
                        <input type="text" name="twoName_#:USERID #" id="twoName_#:USERID #" class="twoName" style="width:80px;background-color:rgb(238,238,238); display: none;" value="#:TWO_NAME #" data-bind="value:TWO_NAME" readonly="readonly" >
                        <button id ="twoSearch_#:USERID #" class="k-button" style="width:45px;  min-width:30px; display: none;" onclick="userSearchBtn(#: USERID #, #: DIVISIONID #, #: HIGH_DVSID #,2)" style="width:10;display: none; "><span class=""></span>검색</button>
                # } #   

                # if (TWO_WEIGHT == null){ #
                        <input type="text" name="twoWeight_#:USERID #" id="twoWeight_#:USERID #" class="twoWeight" style="min-width: 60px; width: 60px; display: none;" value="" data-bind="value:TWO_WEIGHT" onkeyup="chkNull(this); chkNum (this); twoWeightValue(#:USERID #); "><span id="t_span_#:USERID #" style="display: none;"  >%</span>
                # }else{ # 
                        <input type="text" name="twoWeight_#:USERID #" id="twoWeight_#:USERID #" class="twoWeight" style="min-width: 60px; width: 60px; display: none;" value="#:TWO_WEIGHT #" data-bind="value:TWO_WEIGHT" onkeyup="chkNull(this); chkNum (this); twoWeightValue(#:USERID #); "> <span id="t_span_#:USERID #" style="display: none;"  >%</span>
                # } #  

                        <button id="twoInit_#:USERID #" class="k-button" onclick="fn_twoInit(#:USERID #)" style="width:55px; min-width:55px; display: none;"><span></span>초기화</button>

            # } #			
			
	</script>
	
	<script id="singleSaveTemplate" type="text/x-kendo-tmpl">

			# if (CHECKFLAG == "checked=\"1\""){ #
						<button id ="singleSave_#:USERID #" class="k-button" style="width:70px;  min-width:30px;" onclick="singleSave(#:USERID#, #: DIVISIONID #, '#:NAME#', #: JOB #, #: LEADERSHIP #, #: SELF_WEIGHT #, #: ONE_USERID #, #: ONE_WEIGHT #, #: TWO_USERID #, #: TWO_WEIGHT #, '#:S_START_DATE#')"><span class="k-icon k-i-plus"></span>저장</button>
						<button id ="singleDel_#:USERID #" class="k-button" style="width:70px;  min-width:30px;" onclick="singleDel(#:USERID#, '#:NAME#', '#:S_START_DATE#')"><span class="k-icon k-i-minus"></span>삭제</button>
                        <input type="hidden" name="singleChkFlag_#:USERID #" id="singleChkFlag_#:USERID#" value="#:CHECKFLAG #"  style="width:10; ">
            # }else{ #
           				<button id ="singleSave_#:USERID #" class="k-button"  style="width:70px;  min-width:30px; display: none;" onclick="singleSave(#:USERID#, #: DIVISIONID #, '#:NAME#', #: JOB #, #: LEADERSHIP #, #: SELF_WEIGHT #, #: ONE_USERID #, #: ONE_WEIGHT #, #: TWO_USERID #, #: TWO_WEIGHT #, '#:S_START_DATE#')" ><span class="k-icon k-i-plus"></span>저장</button>
                        <button id ="singleDel_#:USERID #" class="k-button"  style="width:70px;  min-width:30px; display: none;" onclick="singleDel(#:USERID#, '#:NAME#', '#:S_START_DATE#')" ><span class="k-icon k-i-minus"></span>삭제</button>
						<input type="hidden" name="singleChkFlag_#:USERID #" id="singleChkFlag_#:USERID#" value="N"  style="width:10; ">
            # } #		
			
	</script>

    <div id="loading-window" style="display:none; overflow:hidden;"></div>
    
    
<style>
.k-window .k-loading-mask
{
    top:0;
    left:0;
    width:100%;
    height:100%;
    z-index:2;
}

</style>

</body>
</html>