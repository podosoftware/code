<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html decorator="operatorSubpage">
<head>
	<title>진단현황</title>
	
	<script type="text/javascript">
	var qstnPoolIndex = 0;
	var servQstnIndex = 0;
	var servUserIndex = 0;
	
	var qstnCd = 0;
	
	function excelDownload(button){
		button.href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_list_excel.do?PP_NO="+$("#ppNoRst").val();
	}
	
    //설문지 미리보기 버튼
    function listPerview(ppNo){
    	
			var dataSource_qstnPreview = new kendo.data.DataSource({
                  type: "json",
			
                 transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_qstn.do?output=json", type:"POST" },
                	 parameterMap: function (options, operation){	
	                      	return { PP_NO: ppNo };
	                      }	
          		},
                 schema: {
                      data: "items2",
                      model: {		                              
                          fields: {
                        	  QSTN_SEQ : { type: "number", editable: false},
                        	  QSTN_TYPE_CD : { type: "int", editable: false }
                          }
                      }
                 },
             })
			
      
              $("#lst-add-perview-window").kendoWindow({
              	width:"430px",
                  minHeight:"430px",
                  resizable : true,
                  title : "미리보기",
                  modal: true,
                  visible: false
              });        		              
              
			  $("#lst-add-perview-window-selecter-grid").empty();		              
              $("#lst-add-perview-window-selecter-grid").kendoGrid({
                 dataSource: dataSource_qstnPreview,
                 columns: [
                      { 
                      	title: "※ 설문 문항에 대해 성실히 답변해 주시기 바랍니다.", filterable: true, width:100 ,
                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                          attributes:{"class":"table-cell", style:"text-align:left"},
                          template: kendo.template($("#qstnPreviewTemplate").html())
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
                  height: 370,
                  editable: true
              });      
        
            //취소버튼 클릭
            $("#cancel-perview-btn").click(function(){
            
            	 $("#lst-add-perview-window").data("kendoWindow").close();
            	 
            });
           
       
          
          $("#lst-add-perview-window").data("kendoWindow").center();
          $("#lst-add-perview-window").data("kendoWindow").open();
     
	}
    
    
    //설문지 결과 열람 버튼
    function servResult(ppNo){
    		//dataSource loading
			var dataSource_servRst = new kendo.data.DataSource({
                  type: "json",
                  async: false,
                  transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_qstn.do?output=json", type:"POST" },
                  parameterMap: function (options, operation){	
	                      return { PP_NO: ppNo };
	               }	
          		  },
                 schema: {
                      data: "items2",
                      model: {		                              
                          fields: {
                        	  QSTN_SEQ : { type: "number", editable: false},
                        	  QSTN_TYPE_CD : { type: "int", editable: false },
                        	  SV_RST : { type: "string", editable: false }
                          }
                      }
                 },
             })
			//winodw pop open
              $("#lst-serv-result-window").kendoWindow({
              	width:"750px",
                  minHeight:"400px",
                  resizable : true,
                  title : "설문결과",
                  modal: true,
                  visible: false
              });
			
			//grid create
			  $("#lst-serv-result-window-selecter-grid").empty();		              
              $("#lst-serv-result-window-selecter-grid").kendoGrid({
                 dataSource: dataSource_servRst,
                 columns: [
                      { 
                    	  field:"QSTN", title: "문항", filterable: true, width:300,
                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                          attributes:{"class":"table-cell", style:"text-align:left"}
//                        template: kendo.template($("#servRstTemplate").html())
                      },
                      { 
                    	  field:"QSTN_TYPE_CD_STRING", title: "문항유형", filterable: true, width:100,
                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                          attributes:{"class":"table-cell", style:"text-align:center"}
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
                  sortable: true,
                  height: 500,
                  detailInit: detailInit
              });
              
             //grid load
              var grid = $("#grid").data("kendoGrid");
              var data = grid.dataSource.data();

              var selectedCell;
              for(var i = 0; i<data.length; i++) {
                  var dataItem = data[i];
                  if(ppNo == dataItem.PP_NO){
                  	selectedCell = dataItem;
                  	     
//                        var selectRow =  {
//                       		PP_NO: selectedCell.PP_NO,
//                       		PP_NM: selectedCell.PP_NM,      
//                       		PP_ST: selectedCell.PP_ST, 
//                       		PP_ED: selectedCell.PP_ED,  
//                       		PP_PURP :selectedCell.PP_PURP,          
//                       		RUN_DATE :selectedCell.RUN_DATE
//                      	 };

					$("#ppNoRst").val(selectedCell.PP_NO);
					$("#ppNmRst").val(selectedCell.PP_NM);
					$("#ppDateRst").val(selectedCell.RUN_DATE);
					$("#ppPurpRst").val(selectedCell.PP_PURP);

                  }
              }
//               kendo.bind( $(".tabular4"), selectRow );
              
            //취소버튼 클릭
            $("#cancel-serv-result-btn").click(function(){
            	 $("#lst-serv-result-window").data("kendoWindow").close();
            });
           
          $("#lst-serv-result-window").data("kendoWindow").center();
          $("#lst-serv-result-window").data("kendoWindow").open();
     
	}
    
    //설문결과 디테일 그리드
    function detailInit(e) {
    	
    	var qstnSeq = e.data.QSTN_SEQ;
    	
    	if(e.data.QSTN_TYPE_CD == 1){
    		
	        $("<div/>").appendTo(e.detailCell).kendoGrid({
	            dataSource: {
	                type: "json",
	                transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_rst_count.do?output=json", type:"POST" },	
	                	parameterMap: function (options, operation){
		                      return { PP_NO: e.data.PP_NO, QSTN_TYPE_CD: e.data.QSTN_TYPE_CD, QSTN_SEQ: e.data.QSTN_SEQ };
		                }
	            	},
	            	async: false,
	                schema: {
	                    data: "items6",
	                       model: {
	                           fields: {
	                        	   QSTN_SEQ  : { type: "number" },
	                        	   SV_RST_NM : {type:"string"},
	                        	   TYPE_FLAG : {type:"string"}
	                           }
	                       }
	                }
	
	            },
		        columns: [
		             {
		           	  	field:"SV_RST", title: "결과", filterable: true, width:80,
		                 headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                 attributes:{"class":"table-cell", style:"text-align:left"},
		                 template: kendo.template($("#servResultTemplate").html())
		             }
		        ],
		        filterable: {
		             extra : false,
		             messages : {filter : "필터", clear : "초기화"},
		             operators : { 
		                 string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
		                 number : { contains : "포함", startswith : "시작값", eq : "동일값" }
		             }
		         }
	        });
	        
	        
			var chartDataSource = new kendo.data.DataSource({
                type: "json",
                transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_rst.do?output=json", type:"POST" },
                parameterMap: function (options, operation){
	                      return { PP_NO: e.data.PP_NO, QSTN_TYPE_CD: e.data.QSTN_TYPE_CD, QSTN_SEQ: e.data.QSTN_SEQ };
	               }	
        		  },
               schema: {
                    data: "items5",
                    model: {		                              
                        fields: {
                      	  QSTN_SEQ : { type: "number", editable: false},
                      	  QSTN_TYPE_CD : { type: "int", editable: false },
                      	  SV_RST : { type: "string", editable: false }
                        }
                    }
               },
           })
	    	if(e.data.QSTN_TYPE_CD == 1 ){
	       	 	//chartDataSource fetch 시..
		        chartDataSource.fetch(function(){
		          var view = chartDataSource.data();
		            if(view.length>0){
		            	var rst1=0, rst2=0, rst3=0, rst4=0, rst5=0;
		            	
		            	for(var i=0; i<view.length; i++){
		            		var item = view[i];
		            		
		            		
		            		//상대적 부족역량 1,2,3
		            		if(item.SV_RST == 1){ rst1 = item.CNT}
		            		if(item.SV_RST == 2){ rst2 = item.CNT}
		            		if(item.SV_RST == 3){ rst3 = item.CNT}
		            		if(item.SV_RST == 4){ rst4 = item.CNT}
		            		if(item.SV_RST == 5){ rst5 = item.CNT}
		            		
		            		var rst = rst1+rst2+rst3+rst4+rst5;

		            		var rstPer1 = Math.round(rst1/rst*100*10)/10;
		            		var rstPer2 = Math.round(rst2/rst*100*10)/10;
		            		var rstPer3 = Math.round(rst3/rst*100*10)/10;
		            		var rstPer4 = Math.round(rst4/rst*100*10)/10;
		            		var rstPer5 = Math.round(rst5/rst*100*10)/10;
		            		
		            		var row = view[0].QSTN_SEQ;
		            		
		                    $("#chart_"+row+"").kendoChart({
		                        title: {
		                            position: "bottom",
		                            text: "총"+rst+"명의 설문 결과 입니다."
		                        },
		                        legend: {
		                            visible: false
		                        },
		                        chartArea: {
		                            background: ""
		                        },
		                        seriesDefaults: {
		                            labels: {
		                                visible: true,
		                                background: "transparent",
		                                template: "#= category #: #= value#%"
		                            }
		                        },
		                        series: [{
		                            type: "pie",
		                            startAngle: 150,
		                            data: [{
		                                category: "매우그렇다",
		                                value: rstPer5,
		                                color: "#9de219"
		                            },{
		                                category: "그렇다",
		                                value: rstPer4,
		                                color: "#90cc38"
		                            },{
		                                category: "중간이다",
		                                value: rstPer3,
		                                color: "#068c35"
		                            },{
		                                category: "아니다",
		                                value: rstPer2,
		                                color: "#006634"
		                            },{
		                                category: "전혀아니다",
		                                value: rstPer1,
		                                color: "#004d38"
		                            }]
		                        }],
		                        tooltip: {
		                            visible: true,
		                            format: "{0}%"
		                        }
		                    });
		//	                    cmptList.push(item.CMPNAME);
		            	}
		            }else{
		            	$("#chart_"+row+"").kendoChart({
	                        title: {
	                            position: "bottom",
	                            text: "설문 결과 입니다."
	                        },
	                        legend: {
	                            visible: false
	                        },
	                        chartArea: {
	                            background: ""
	                        },
	                        seriesDefaults: {
	                            labels: {
	                                visible: true,
	                                background: "transparent",
	                                template: "#= category #: #= value#건"
	                            }
	                        },
	                        series: [{
	                            type: "pie",
	                            startAngle: 150,
	                            data: [{
	                                category: "매우그렇다",
	                                value: 0,
	                                color: "#9de219"
	                            },{
	                                category: "그렇다",
	                                value: 0,
	                                color: "#90cc38"
	                            },{
	                                category: "중간이다",
	                                value: 0,
	                                color: "#068c35"
	                            },{
	                                category: "아니다",
	                                value: 0,
	                                color: "#006634"
	                            },{
	                                category: "전혀아니다",
	                                value: 0,
	                                color: "#004d38"
	                            }]
	                        }],
	                        tooltip: {
	                            visible: true,
	                            format: "{0}건"
	                        }
	                    });
		            }
		        });
		        chartDataSource.read();
	    	}
    	}
    	

            
            if(e.data.QSTN_TYPE_CD == 2){
    	        $("<div/>").appendTo(e.detailCell).kendoGrid({
    	            dataSource: {
    	                type: "json",
    	                transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_rst.do?output=json", type:"POST" },	
    	                	parameterMap: function (options, operation){
    		                      return { PP_NO: e.data.PP_NO, QSTN_TYPE_CD: e.data.QSTN_TYPE_CD, QSTN_SEQ: e.data.QSTN_SEQ };
    		                }
    	            	},
    	                schema: {
    	                    data: "items5",
    	                       model: {
    	                           fields: {
    	                        	   QSTN_SEQ  : { type: "number" },
    	                        	   SV_RST_NM : {type:"string"},
    	                        	   TYPE_FLAG : {type:"string"}
    	                           }
    	                       }
    	                }
    	
    	            },
    		        columns: [
    		             {
    		           	  	field:"SV_RST", title: "결과", filterable: true, width:80,
    		                 headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
    		                 attributes:{"class":"table-cell", style:"text-align:left"},
    		                 template: kendo.template($("#servResultTemplate").html())
    		             }
    		        ],
    		        filterable: {
    		             extra : false,
    		             messages : {filter : "필터", clear : "초기화"},
    		             operators : { 
    		                 string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
    		                 number : { contains : "포함", startswith : "시작값", eq : "동일값" }
    		             }
    		         }
    	        });
            
        	}
    }
	
	function qntnPoolCheck_1(checkbox, rows){
    	
		var data = $('#lst-add-qstn-window-selecter-grid').data('kendoGrid').dataSource.view();
		
		var res = $.grep(data, function (e) {
    	    return e.ROWNUMBER == rows;    	  
    	});
		
		res[0].QSTN_TYPE_CD = 1;		
	}
    
	function qntnPoolCheck_2(checkbox, rows){
		
		var data = $('#lst-add-qstn-window-selecter-grid').data('kendoGrid').dataSource.view();
		
		var res = $.grep(data, function (e) {
    	    return e.ROWNUMBER == rows;    	  
    	});
			
		res[0].QSTN_TYPE_CD = 2;
		
	}
    
	//상세보기 화면.
    function fn_detailView(ppNumber){
		
    	var grid = $("#grid").data("kendoGrid");
        var data = grid.dataSource.data();

        var selectedCell;
        for(var i = 0; i<data.length; i++) {
            var dataItem = data[i];
            if(ppNumber == dataItem.PP_NO){
            	selectedCell = dataItem;
            	     
                 var selectRow =  {
                		PP_NO: selectedCell.PP_NO,
                		PP_NM: selectedCell.PP_NM,      
                		PP_ST: selectedCell.PP_ST, 
                		PP_ED: selectedCell.PP_ED, 
                		RUN_DATE :selectedCell.RUN_DATE, 
                		PP_PURP :selectedCell.PP_PURP,
                		USEFLAG: selectedCell.USEFLAG              			
               	 };                
                 
                 $("#splitter").data("kendoSplitter").expand("#detail_pane");
                 
                 // show detail 
                 $('#detailPp').show().html(kendo.template($('#defaultTemplate').html()));
                 $('#saveData').show().html(kendo.template($('#template').html()));             
                 $('#saveData2').show().html(kendo.template($('#template2').html()));                  
                 $('#grid2').show();
                 $('#grid3').show();
                 
	         	 // save btn add click event
	          	 buttonEvent();		          	
	          	
              	 // detail binding data
                 kendo.bind( $(".tabular"), selectRow );
                 $('input:radio[id=useFlag]:input[value='+selectedCell.USEFLAG+']').attr("checked", true);//사용여부
				//setDataSource('N');
                 openwindow2(ppNumber);
                 openwindow3(ppNumber);
                 // dtl save btn add click event
                
                    break;
                    
            } // end if
        } // end for
        
        
        var start = $("#ppSt").kendoDatePicker({
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

        var end = $("#ppEd").kendoDatePicker({
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

        start.max(end.value());
        end.min(start.value());
        
        // template에서 호출된 함수에 대한 이벤트 종료 처리.
        if(event.preventDefault){
            event.preventDefault();
        } else {
            event.returnValue = false;
        } 
    }	
	
		var dataSource = null;		
		
		//문항 Pool 삭제
		function singleDel(qstnPoolNo, rows){
			
			if (qstnPoolNo == null){
				
				var data = $("#lst-add-qstn-window-selecter-grid").data("kendoGrid").dataSource.data();
				
				for(var i = 0; i<data.length; i++) {
		            var dataItem = data[i];
		            if(rows == dataItem.ROWNUMBER){
		            	
		            	$("#lst-add-qstn-window-selecter-grid").data("kendoGrid").dataSource.remove(dataItem);
		            	
		            }
				}
			}else{				
        		$.ajax({
            			type : 'POST',
    					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_qstn_pool_del.do?output=json",
    					data : { QSTNPOOLNO: qstnPoolNo },
    					complete : function( response ){
    						var obj  = eval("(" + response.responseText + ")");
    						if(obj.saveCount != 0){	
    							$('#lst-add-qstn-window-selecter-grid').data("kendoGrid").dataSource.read();
    						}else{
    							alert("삭제 실패 하였습니다.");
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
	
		function modifyYnFlag(checkbox, rows){
 			var array = $('#grid').data('kendoGrid').dataSource.data();
 			if(checkbox.checked == true){
 				array[rows].CHECKFLAG = "checked=\"1\"";
 			}else{
 				array[rows].CHECKFLAG = '';
 			}
 	   }
		
		function modifyYnFlag2(checkbox, rows){
 			var data = $('#grid2').data('kendoGrid').dataSource.view();
 			
 			//rows 와 같은 데이터를 배열로 리턴함..
 	    	var res = $.grep(data, function (e) {
 	    	    return e.ROWNUMBER == rows;
 	    	});
 			
 	    	if(checkbox.checked){
 	    		res[0].CHECKFLAG = "checked=\"1\"";
 	    		res[0].ROWNUMBER = rows;
 	    	}else{
 	    		res[0].CHECKFLAG = '';
 	    		res[0].ROWNUMBER = rows;
 	    	}
 	   }
		
		function modifyYnFlag3(checkbox, rows){
 			var array = $('#grid3').data('kendoGrid').dataSource.data();
 			if(checkbox.checked == true){
 				array[rows].CHECKFLAG = "checked=\"1\"";
 			}else{
 				array[rows].CHECKFLAG = '';
 			}
 	   }
		
		function modifyYnFlag4(checkbox, qstnPoolNo, rows){
		
 			var data = $('#lst-add-qstn-window-selecter-grid').data('kendoGrid').dataSource.data(); 			
 			
 			
 			if(qstnPoolNo == null){
 				//qstnPoolNo 와 같은 데이터를 배열로 리턴함..
	 	    	var res = $.grep(data, function (e) {
	 	    	    return e.ROWNUMBER == rows;
	 	    	});
	 	    	if(checkbox.checked){
	 	    		res[0].CHECKFLAG = "checked=\"1\"";
	 	    		
	 	    	}else{
	 	    		res[0].CHECKFLAG = '';
	 	    	}
 			}else{
 				//qstnPoolNo 와 같은 데이터를 배열로 리턴함..
	 	    	var res = $.grep(data, function (e) {
	 	    	    return e.QSTN_POOL_NO == qstnPoolNo;
	 	    	});
	 	    	if(checkbox.checked){
	 	    		res[0].CHECKFLAG = "checked=\"1\"";
	 	    	}else{
	 	    		res[0].CHECKFLAG = '';
	 	    	}
 			}
 			$("#lst-add-qstn-window-selecter-grid").data("kendoGrid").refresh();	
 	   }
		
		function modifyYnFlag5(checkbox, rows){
			
			var array = $('#lst-add-user-window-selecter-grid').data('kendoGrid').dataSource.view();
 			if(checkbox.checked == true){
 				array[rows].CHECKFLAG = "checked=\"1\"";
 			}else{
 				array[rows].CHECKFLAG = '';
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
		
		//문항관리 전체선택/해지
		function qstnAllCheck(checkbox){
 			var array =  $('#grid2').data('kendoGrid').dataSource.view();
 			
 			if(checkbox.checked == true){
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = "checked=\"1\"";
 				}
 			}else{
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = '';
 				}
 			} 			
 			$("#grid2").data("kendoGrid").refresh();			
 	   }
		
		//대상자관리 전체선택/해지
		function targAllCheck(checkbox){
 			var array =  $('#grid3').data('kendoGrid').dataSource.view();
 			
 			if(checkbox.checked == true){
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = "checked=\"1\"";
 				}
 			}else{
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = '';
 				}
 			} 			
 			$("#grid3").data("kendoGrid").refresh();			
 	   }
		
		//문항추가 팝업 전체선택/해지
		function qstnPoolAllCheck(checkbox){
 			var array =  $('#lst-add-qstn-window-selecter-grid').data('kendoGrid').dataSource.view();
 			
 			if(checkbox.checked == true){
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = "checked=\"1\"";
 				}
 			}else{
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = '';
 				}
 			} 			
 			$("#lst-add-qstn-window-selecter-grid").data("kendoGrid").refresh();			
 	   } 
		
		//대상자추가 팝업 전체선택/해지
		function userAllCheck(checkbox){
 			var array =  $('#lst-add-user-window-selecter-grid').data('kendoGrid').dataSource.view();
 			
 			if(checkbox.checked == true){
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = "checked=\"1\"";
 				}
 			}else{
 				for(var i = 0 ; i < array.length ; i ++ ){
 					array[i].CHECKFLAG = '';
 				}
 			} 			
 			$("#lst-add-user-window-selecter-grid").data("kendoGrid").refresh();			
 	   } 

		
		function setDataSource(startYn){
			
			if(startYn == 'Y'){
				runNum = "";
			}else{
				runNum = $("#runNumber").val();
			}
			
      	  $("#runNumber").kendoComboBox({
  	        dataTextField: "TEXT",
  	        dataValueField: "VALUE",
  	        dataSource: {
                 type: "json",
                 transport: {
                     read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_yeal_list.do?output=json", type:"POST" },
                     parameterMap: function (options, operation){	
                     	return { };
                     } 		
                 },
                 schema: {
              	   data: "items",
                     model: {}
                 }
             },
  	        suggest: true,
  	        index: 0,
 	       		 change: function() {
 	       			setDataSource('N');
	       	       		
         		 }
  	    });
			
			dataSource = new kendo.data.DataSource({
	                  type: "json",
	                  transport: {
	                      read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_list.do?output=json", type:"POST" },
	                      parameterMap: function (options, operation){	
	                      	return {RUN_NUM : runNum} ;
	                      } 		
	                  },
	                  schema: {
	                  	data: "items"
	                  },
	                  serverFiltering: false,
		              serverSorting: false
	      	})
 	       	
 	       	 openwindow(dataSource);
			
			
		}		
		
		
		function encourage(){
			
			var isDel = confirm("저장하시겠습니까?");
		 	 if(isDel){ 
		 		 
		 		var params = {	             				
             			LIST :  $('#grid').data('kendoGrid').dataSource.data(),	             			             			
  	           		};
		 		 
        		$.ajax({
        			type : 'POST',
					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/encourage_mail_send.do?output=json",
					data : { RUN_NAME :  $("#runNumber").data("kendoComboBox").text(), item: kendo.stringify( params )},
					complete : function( response ){
						var obj  = eval("(" + response.responseText + ")");
						if(obj.saveCount != 0){
							alert("메일이 발송되었습니다");	
						}else{
							alert("메일이 발송에 실패 하였습니다.");
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
		
		
// 		function filterCheck(){

//  			var selectedFlag =$(':radio[id="selectedFlag"]:checked').val();
			
// 			if(selectedFlag==null){
//  				selectedFlag = "0"
//  			}
			
// 			if(selectedFlag=="0"){
// 				dataSource.filter({field : "DIAG_STATE", operator: "neq", value: "not"});
// 			}else if(selectedFlag=="1"){
// 				dataSource.filter({field : "DIAG_STATE", operator: "eq", value: "완료"});
// 			}else if(selectedFlag=="2"){
// 				dataSource.filter({field : "DIAG_STATE", operator: "eq", value: "진행"});
// 			}else{
// 				dataSource.filter({field : "DIAG_STATE", operator: "eq", value: "미실시"});
// 			}
// 	   }
		
	   function buttonEvent(){
		   
		   
	       	// dtl del btn add click event
         	$("#delBtn").click( function(){
         	    
          	var isDel = confirm("삭제 하시겠습니까?");
              if(isDel){
          		var params = {
          			PP_NO: $("#ppNo").val(),
          			FLAG : "15",
           		};
          		
          		$.ajax({
          			type : 'POST',
  					url:"/operator/ca/ca_common_del.do?output=json",
  					data : { item: kendo.stringify( params ) },
  					complete : function( response ){
  						var obj  = eval("(" + response.responseText + ")");
  						if(obj.saveCount != 0){
  							setDataSource('N');	
   							
   				       		kendo.bind( $(".tabular"),  null );
   			         		 
   			         		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
   			                $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
   							
  							alert("삭제되었습니다.");	
  						}else{
  							alert("삭제를 실패 하였습니다.");
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
         	});
		   	
			//설문지 저장
  	  		$("#saveBtn").click( function(){
  	  				
 	       		if($("#ppNm").val()=="") {
 	     			alert("설문명을 입력해 주십시오.");
 	     			return false;
 	     		}	
 	       		if($("#ppSt").val()=="") {
 	     			alert("설문시작일을 입력해 주십시오.");
 	     			return false;
 	     		}	
                if(!ex_date("설문시작일","ppSt")){
                	return false;
                }
 	       		if($("#ppEd").val()=="") {
 	     			alert("설문종료일을 입력해 주십시오.");
 	     			return false;
 	     		}
                if(!ex_date("설문종료일","ppEd")){
                	return false;
                }
                
  	       			var isDel = confirm("저장하시겠습니까?");
  					 	 if(isDel){
  		             		
  		             		$.ajax({
  		             			type : 'POST',
  		     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_all_save.do?output=json",
  		     					data : { PP_NO: $("#ppNo").val(), PP_NM: $("#ppNm").val(), PP_PURP: $("#ppPurp").val(), PP_ST: $("#ppSt").val() , PP_ED: $("#ppEd").val(), USEFLAG: $(':radio[id="useFlag"]:checked').val() },
  		     					complete : function( response ){
  		     						var obj  = eval("(" + response.responseText + ")");
  		     						if(obj.saveCount != 0){
  		     							setDataSource('N');	
  		     							
  		     				       		kendo.bind( $(".tabular"),  null );
  		     			         		 
  		     			         		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
  		     			                $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
  		     							
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
  	          	});
			
			
       		//cancel btn add click event
        	$("#cencelBtn").click( function(){
         		kendo.bind( $(".tabular"),  null );
         		 
         		$("#splitter").data("kendoSplitter").toggle("#list_pane", true);
                $("#splitter").data("kendoSplitter").toggle("#detail_pane", false);
         	});
		   
	        //안내 메일 발송 버튼 클릭 시..
	        $("#mailBtn").click( function(){
	        	var gridData = $('#grid3').data('kendoGrid').dataSource.data();
	        	//console.log("--------"+gridData.length);
	        	var isCnt =  0;
	        	for(var i=0; i<gridData.length; i++){
	        		if(gridData[i].CHECKFLAG=="checked=\"1\""){
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
                           LIST :  $('#grid3').data('kendoGrid').dataSource.data(),                                                 
                   };
                    
                   $.ajax({
                       type : 'POST',
                       url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/kpi/serv_mail_send.do?output=json",
                       data : { PP_NO :  $("#ppNo").val(), item: kendo.stringify( params )},
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
	        });
		   
		// list new btn add click event
	          $("#newBtn").click( function(){
	        	  $("#splitter").data("kendoSplitter").expand("#detail_pane");
	              
	              // show detail 
	              $('#detailPp').show().html(kendo.template($('#defaultTemplate').html()));
	              $('#saveData').hide().html(kendo.template($('#template').html()));             
	              $('#saveData2').hide().html(kendo.template($('#template2').html())); 
	   			
	              openwindow2();
	              openwindow3();
	              
	              $("#grid2").hide();
	              $("#grid3").hide();
	              $("#delBtn").hide();
	              
	              kendo.bind( $(".tabular"),  null ); 
	              $('input:radio[id=useFlag]:input[value=Y]').attr("checked", true);//사용여부
	              
      		//설문지 저장
     	  		$("#saveBtn").click( function(){
     	  			
     	       		if($("#ppNm").val()=="") {
     	     			alert("설문명을 입력해 주십시오.");
     	     			return false;
     	     		}	
     	       		if($("#ppSt").val()=="") {
     	     			alert("설문시작일을 입력해 주십시오.");
     	     			return false;
     	     		}	
                    if(!ex_date("설문시작일","ppSt")){
                    	return false;
                    }
     	       		if($("#ppEd").val()=="") {
     	     			alert("설문종료일을 입력해 주십시오.");
     	     			return false;
     	     		}
                    if(!ex_date("설문종료일","ppEd")){
                    	return false;
                    }
     	       		
     	       			var isDel = confirm("저장하시겠습니까?");
     					 	 if(isDel){
     		             		$.ajax({
     		             			type : 'POST',
     		     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_all_save.do?output=json",
     		     					data : { PP_NO: $("#ppNo").val(), PP_NM: $("#ppNm").val(), PP_PURP: $("#ppPurp").val(), PP_ST: $("#ppSt").val() , PP_ED: $("#ppEd").val(), USEFLAG: $(':radio[id="useFlag"]:checked').val()},
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
     	          	});
	             
	   		   var start = $("#ppSt").kendoDatePicker({
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

	           var end = $("#ppEd").kendoDatePicker({
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

	           start.max(end.value());
	           end.min(start.value());
	             
	         });
		
		
			
	        //설문문항 관리 리스트 삭제
		  		$("#servQstnDel").click( function(){
		  			
	    			var isDel = confirm("문항을 삭제 하시겠습니까?");
 				 	 if(isDel){
 	             		var params = {
 	             			LIST :  $('#grid2').data('kendoGrid').dataSource.data() 
 	  	           		};
 	             		
 	             		$.ajax({
 	             			type : 'POST',
 	     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_qstn_del.do?output=json",
 	     					data : { item: kendo.stringify( params ), PP_NO: $("#ppNo").val() },
 	     					complete : function( response ){
 	     						var obj  = eval("(" + response.responseText + ")");
 	     						if(obj.saveCount != 0){
 	     							alert("저장되었습니다.");	
 	     							$("#grid2").data("kendoGrid").dataSource.read();
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
		  		
// 		  				var data = $("#grid2").data("kendoGrid").dataSource.data();
		  				
// 		  				for(var i = 0; i<data.length; i++) {
// 		  		            var dataItem = data[i];
// 		  		            if(dataItem.QSTN_SEQ == null && dataItem.CHECKFLAG == "checked=\"1\""){	
		  		            	
// 		  		            	$("#grid2").data("kendoGrid").dataSource.remove(dataItem);
// 		  		            }
// 		  		            if(dataItem.QSTN_SEQ != null && dataItem.CHECKFLAG == "checked=\"1\""){
		  		              
// 		  		            	$.ajax({
// 			            			type : 'POST',
// 			    					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_qstn_del.do?output=json",
// 			    					data : { QSTNSEQ: dataItem.QSTN_SEQ },
// 			    					complete : function( response ){
// 			    						var obj  = eval("(" + response.responseText + ")");
// 			    						if(obj.saveCount != 0){	
// 			    							$("#grid2").data("kendoGrid").dataSource.read();
// 			    						}else{
// 			    							alert("삭제 실패 하였습니다.");
// 			    						}							
// 			    					},
// 			    					error: function( xhr, ajaxOptions, thrownError){								
// 			    					},
// 			    					dataType : "json"
// 			    				});		  		            	
// 		  		            } //end if/else
// 		  				} //end for
		  				
		  		});
	        
		        //대상자 관리 리스트 삭제
		  		$("#servUserDel").click( function(){
		  			
	    			var isDel = confirm("대상자를 삭제 하시겠습니까?");
 				 	 if(isDel){
 	             		var params = {
 	             			LIST :  $('#grid3').data('kendoGrid').dataSource.data() 
 	  	           		};
 	             		
 	             		$.ajax({
 	             			type : 'POST',
 	     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_user_del.do?output=json",
 	     					data : { item: kendo.stringify( params ), PP_NO: $("#ppNo").val() },
 	     					async: false,
 	     					complete : function( response ){
 	     						var obj  = eval("(" + response.responseText + ")");
 	     						if(obj.saveCount != 0){
 	     							alert("저장되었습니다.");	
 	     							$("#grid3").data("kendoGrid").dataSource.read();
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
		  		
// 		  				var data = $("#grid2").data("kendoGrid").dataSource.data();
		  				
// 		  				for(var i = 0; i<data.length; i++) {
// 		  		            var dataItem = data[i];
// 		  		            if(dataItem.QSTN_SEQ == null && dataItem.CHECKFLAG == "checked=\"1\""){	
		  		            	
// 		  		            	$("#grid2").data("kendoGrid").dataSource.remove(dataItem);
// 		  		            }
// 		  		            if(dataItem.QSTN_SEQ != null && dataItem.CHECKFLAG == "checked=\"1\""){
		  		              
// 		  		            	$.ajax({
// 			            			type : 'POST',
// 			    					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_qstn_del.do?output=json",
// 			    					data : { QSTNSEQ: dataItem.QSTN_SEQ },
// 			    					complete : function( response ){
// 			    						var obj  = eval("(" + response.responseText + ")");
// 			    						if(obj.saveCount != 0){	
// 			    							$("#grid2").data("kendoGrid").dataSource.read();
// 			    						}else{
// 			    							alert("삭제 실패 하였습니다.");
// 			    						}							
// 			    					},
// 			    					error: function( xhr, ajaxOptions, thrownError){								
// 			    					},
// 			    					dataType : "json"
// 			    				});		  		            	
// 		  		            } //end if/else
// 		  				} //end for
		  				
		  		});
		   
		 	//문항추가 
// 			function userSearchBtn(rows,dvsId,flag){
				$("#qstnPool").click( function(){
					
					var dataSource_qstnPool = new kendo.data.DataSource({
		                  type: "json",
					
	                     transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_qstn_pool.do?output=json", type:"POST" },
	                    	 parameterMap: function (options, operation){	
	 	                      	return { };
	 	                      }	
	              		},
	                     schema: {
	                          data: "items1",
	                          model: {		                              
	                              fields: {
	                            	  QSTN_POOL_NO : { type: "number", editable: false},
	                            	  QSTN_TYPE_CD : { type: "int", editable: false },
	                            	  QSTN_TYPE_CD_STRING : { type: "string", editable: false },
	                            	  QSTN : { type: "string" },
	                            	  ROWNUMBER : { type: "int", editable: false },
	                            	  CHECKFLAG : { type: "string", editable: false}
	                              }
	                          }
	                     },
	                 })
					
		          if( !$("#lst-add-qstn-window").data("kendoWindow") ){
		              $("#lst-add-qstn-window").kendoWindow({
		              	width:"650px",
		                  minHeight:"400px",
		                  resizable : true,
		                  title : "문항관리",
		                  modal: true,
		                  visible: false
		              });        		              
		              
 					  $("#lst-add-qstn-window-selecter-grid").empty();		              
		              $("#lst-add-qstn-window-selecter-grid").kendoGrid({
		                 dataSource: dataSource_qstnPool,
		                 columns: [
		                      { 
		                          field:"CHECKFLAG", title: "선택", filterable: false, width:50, sortable: false,
		                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                          attributes:{"class":"table-cell", style:"text-align:left"} ,
		                          template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag4(this, #: QSTN_POOL_NO #, #: ROWNUMBER #)\" #: CHECKFLAG #/></div>"
		                      },
		                      { 
		                      	field:"QSTN_TYPE_CD", title: "문항유형", filterable: false, width:100 ,
		                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                          attributes:{"class":"table-cell", style:"text-align:left"},
		                          template: kendo.template($("#qstnTypeTemplate").html())
		                      },
		                      { 
		                      	field:"QSTN", title: "설문문항", filterable: true, width:140,
		                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                          attributes:{"class":"table-cell", style:"text-align:left"} 
		                      },
		                      { 
		                          title: "삭제", filterable: false, width:60,
		                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                          attributes:{"class":"table-cell", style:"text-align:left"},
		                          template: kendo.template($("#qstnDelTemplate").html())
		                      },
		                 ],
		                 filterable: {
		                      extra : false,
		                      messages : {filter : "필터", clear : "초기화"},
		                      operators : { 
		                          string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
		                          number : { contains : "포함", startswith : "시작값", eq : "동일값" }
		                      }
		                  }, 
		                  sortable: true,
		                  dataBound: function(e) {
		                      //alert("11");
		                      //$(".amount").kendoNumericTextBox();
		                      if($('#lst-add-qstn-window-selecter-grid').data('kendoGrid').dataSource.data()!=null){
		                      	qstnPoolIndex = $('#lst-add-qstn-window-selecter-grid').data('kendoGrid').dataSource.data().length;		                      	
		                      }else{
		                    	qstnPoolIndex = 0;
		                      }
		                  	
		                  },
		                  height: 370,
		                  editable: true,
		                  toolbar: [
		                  {
		                   template: $("#qstnPoolToolbarTemplate").html()
		                  }],
		              });        
		             
		              
		            //문항추가 버튼 클릭
		              $("#addQstnPool").click( function(){
		              	            	
		              	$("#lst-add-qstn-window-selecter-grid").data("kendoGrid").dataSource.add({            		
		              		QSTN_POOL_NO : null,
		              		QSTN_TYPE_CD : 1,
		              		USEFLAG : "Y",
		              		QSTN:"",
		              		ROWNUMBER : qstnPoolIndex,
                      	    QSTN_TYPE_CD_STRING : "",
                      	    CHECKFLAG : ""		              		
		              	});
		              	
		              	var qstnPoolFocus = qstnPoolIndex-1;
		              	$("#lst-add-qstn-window-selecter-grid").data("kendoGrid").refresh();
		              	$("#qntnPoolCheck_"+qstnPoolFocus+"").focus();
		              });    
		            	
		           //문항 POOL 저장
		   		   $("#savePoolBtn").click( function(){
		         			var isDel = confirm("문항 POOL을 저장하시겠습니까?");
		   				 	 if(isDel){
		   	             		var params = {
		   	             			LIST :  $('#lst-add-qstn-window-selecter-grid').data('kendoGrid').dataSource.data() 
		   	  	           		};
		   	             		
		   	             		$.ajax({
		   	             			type : 'POST',
		   	     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_qstn_pool_save.do?output=json",
		   	     					data : { item: kendo.stringify( params )},
		   	     					complete : function( response ){
		   	     						var obj  = eval("(" + response.responseText + ")");
		   	     						if(obj.saveCount != 0){
		   	     							setDataSource('N');	
		   	     							alert("저장되었습니다.");	
		   	     						$("#lst-add-qstn-window-selecter-grid").data("kendoGrid").dataSource.read();
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
		            }); 
		           
					// 문항 pool 데이터 바인딩 & 세팅
			       $("#bindPoolBtn").click( function(){
			        	  
// 			          	var grid = $("#lst-add-qstn-window-selecter-grid").data("kendoGrid");
// 			            var data = grid.dataSource.data();

// 			            for(var i = 0; i<data.length; i++) {
// 			                var dataItem = data[i];
// 			                if(dataItem.CHECKFLAG == "checked=\"1\""){
			                	
// 			                	var qstnTypeString;
// 			                	if(dataItem.QSTN_TYPE_CD == 1){
// 			                		qstnTypeString = "객관식";
// 			                	}else{
// 			                		qstnTypeString = "주관식";
// 			                	}
// 				              	$("#grid2").data("kendoGrid").dataSource.add({            		
// 				              		PP_NO : null,
// 				              		QSTN_SEQ: null,
// 				              		QSTN_TYPE_CD : dataItem.QSTN_TYPE_CD,
// 				              		QSTN_TYPE_CD_STRING : qstnTypeString,
// 				              		QSTN_SEQ: null,		
// 				              		QSTN : dataItem.QSTN,
// 				              		USEFLAG : "Y",
// 				              		ROWNUMBER : servQstnIndex,
// 		                      	    CHECKFLAG : ""		              		
// 				              	});  
			                                               
// 			                } // end if
// 			            } // end for

		   		
		         			var isDel = confirm("문항POOL의 문항을 설문지에 저장 하시겠습니까?");
		   				 	 if(isDel){
		   	             		var params = {
		   	             			LIST :  $('#lst-add-qstn-window-selecter-grid').data('kendoGrid').dataSource.data() 
		   	  	           		};
		   	             		
		   	             		$.ajax({
		   	             			type : 'POST',
		   	     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_qstn_bind_save.do?output=json",
		   	     					data : { item: kendo.stringify( params ), PP_NO: $("#ppNo").val() },
		   	     					complete : function( response ){
		   	     						var obj  = eval("(" + response.responseText + ")");
		   	     						if(obj.saveCount != 0){
		   	     							alert("저장되었습니다.");	
		   	     							$("#lst-add-qstn-window-selecter-grid").data("kendoGrid").dataSource.read();
		   	     							$("#grid2").data("kendoGrid").dataSource.read();
		   	     			            	$("#lst-add-qstn-window").data("kendoWindow").close();
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
		       
			         });
		           
		           
		            //취소버튼 클릭
		            $("#cancel-pool-btn").click(function(){
		            
		            	 $("#lst-add-qstn-window").data("kendoWindow").close();
		            });
		           
		           }
		          
		          $("#lst-add-qstn-window").data("kendoWindow").center();
		          $("#lst-add-qstn-window").data("kendoWindow").open();
		      });
				
				
				
			 	//미리보기 
//	 			function qstnPreview(rows,dvsId,flag){
					$("#qstnPreview").click( function(){
						var dataSource_qstnPreview = new kendo.data.DataSource({
			                  type: "json",
						
		                     transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_qstn.do?output=json", type:"POST" },
		                    	 parameterMap: function (options, operation){	
		 	                      	return { PP_NO: $("#ppNo").val() };
		 	                      }	
		              		},
		                     schema: {
		                          data: "items2",
		                          model: {		                              
		                              fields: {
		                            	  QSTN_SEQ : { type: "number", editable: false},
		                            	  QSTN_TYPE_CD : { type: "int", editable: false }
		                              }
		                          }
		                     },
		                 })
						
			      
			              $("#lst-add-perview-window").kendoWindow({
			              	width:"430px",
			                  minHeight:"430px",
			                  resizable : true,
			                  title : "미리보기",
			                  modal: true,
			                  visible: false
			              });        		              
			              
	 					  $("#lst-add-perview-window-selecter-grid").empty();		              
			              $("#lst-add-perview-window-selecter-grid").kendoGrid({
			                 dataSource: dataSource_qstnPreview,
			                 columns: [
			                      { 
			                      	title: "※ 설문 문항에 대해 성실히 답변해 주시기 바랍니다.", filterable: true, width:100 ,
			                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
			                          attributes:{"class":"table-cell", style:"text-align:left"},
			                          template: kendo.template($("#qstnPreviewTemplate").html())
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
			                  height: 370,
			                  editable: true
			              });      
			        
			            //취소버튼 클릭
			            $("#cancel-perview-btn").click(function(){
			            
			            	 $("#lst-add-perview-window").data("kendoWindow").close();
			            });
			           
			       
			          
			          $("#lst-add-perview-window").data("kendoWindow").center();
			          $("#lst-add-perview-window").data("kendoWindow").open();
			      });
				
			 	//대상자추가 버튼
//	 			function userSearchBtn(rows,dvsId,flag){
					$("#servTarg").click( function(){
						
						var dataSource_targ = new kendo.data.DataSource({
			                  type: "json",
						
		                     transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_user.do?output=json", type:"POST" },
		                    	 parameterMap: function (options, operation){	
		 	                      	return { };
		 	                      }	
		              		},
		                     schema: {
		                          data: "items4",
		                          model: {		                              
		                              fields: {
		                            	  USERID : { type: "number", editable: false},
		                            	  EMPNO : { type: "string", editable: false },
		                            	  NAME : { type: "string", editable: false },
		                            	  JOB : { type: "string" },
		                            	  JOB_NAME : { type: "string" },
		                            	  LEADERSHIP : { type: "string" },
		                            	  LEADERSHIP_NAME : { type: "string" },
		                            	  ROWNUMBER : { type: "int", editable: false },
		                            	  CHECKFLAG : { type: "string", editable: false}
		                              }
		                          }
		                     },
		                 })
						
			          if( !$("#lst-add-user-window").data("kendoWindow") ){
			              $("#lst-add-user-window").kendoWindow({
			              	width:"750px",
			              	minHeight:"300px",
			                  resizable : true,
			                  title : "사용자 찾기",
			                  modal: true,
			                  visible: false
			              });        		              
			              
	 					  $("#lst-add-user-window-selecter-grid").empty();		              
			              $("#lst-add-user-window-selecter-grid").kendoGrid({
			                 dataSource: dataSource_targ,
			                 columns: [
			                      { 
			                          field:"CHECKFLAG", title: "선택", filterable: false, width:40, sortable: false,
			                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
			                          attributes:{"class":"table-cell", style:"text-align:left"} ,
			                          template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag5(this, #: ROWNUMBER #)\" #: CHECKFLAG #/></div>"
			                      },
			                      { 
			                      	field:"DVS_NAME", title: "부서", filterable: true, width:90 ,
			                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
			                          attributes:{"class":"table-cell", style:"text-align:left"}
			                      },
			                      { 
			                      	field:"NAME", title: "이름", filterable: true, width:130,
			                          headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
			                          attributes:{"class":"table-cell", style:"text-align:left"} 
			                      },
			                      { 
				                     field:"EMPNO", title: "교직원번호", filterable: true, width:130,
				                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
				                      attributes:{"class":"table-cell", style:"text-align:left"} 
				                  },
				                  { 
					                  field:"JOB_NAME", title: "직무", filterable: true, width:130,
					                  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
					                  attributes:{"class":"table-cell", style:"text-align:left"} 
					              },
				                  { 
					                 field:"LEADERSHIP_NAME", title: "계층", filterable: true, width:120,
					                  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
					                  attributes:{"class":"table-cell", style:"text-align:left"} 
					              },
			                 ],
			                 filterable: {
			                      extra : false,
			                      messages : {filter : "필터", clear : "초기화"},
			                      operators : { 
			                          string : { contains : "포함", startswith : "시작문자", eq : "동일단어" },
			                          number : { contains : "포함", startswith : "시작값", eq : "동일값" }
			                      }
			                  },
			                  height: 400,
			              	
			              });        
		            	
			           
						// 대상자 데이터 바인딩 & 세팅
				          $("#bindUserBtn").click( function(){
				        	  
// 				          	var grid = $("#lst-add-user-window-selecter-grid").data("kendoGrid");
// 				            var data = grid.dataSource.data();

// 				            for(var i = 0; i<data.length; i++) {
// 				                var dataItem = data[i];
// 				                if(dataItem.CHECKFLAG == "checked=\"1\""){
				                	
// 					              	$("#grid3").data("kendoGrid").dataSource.add({ 
// 					              		USERID : dataItem.USERID,
// 					              		NAME : dataItem.NAME,
// 					              		EMPNO : dataItem.EMPNO,
// 					              		DVS_NAME : dataItem.DVS_NAME,
// 					              		ROWNUMBER : servUserIndex,					              		 
// 			                      	    CHECKFLAG : ""		              		
// 					              	});
				                                               
// 				                } // end if
// 				            } // end for

			         			var isDel = confirm("대상자를 설문지에 추가 하시겠습니까?");
			   				 	 if(isDel){
			   	             		var params = {
			   	             			LIST :  $('#lst-add-user-window-selecter-grid').data('kendoGrid').dataSource.data() 
			   	  	           		};
			   	             		
			   	             		$.ajax({
			   	             			type : 'POST',
			   	     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_user_bind_save.do?output=json",
			   	     					data : { item: kendo.stringify( params ), PP_NO: $("#ppNo").val() },
			   	     					async: false,
			   	     					complete : function( response ){
			   	     						var obj  = eval("(" + response.responseText + ")");
			   	     						if(obj.saveCount != 0){
			   	     							alert("저장되었습니다.");	
			   	     							$("#lst-add-user-window-selecter-grid").data("kendoGrid").dataSource.read();
			   	     						 	$("#lst-add-user-window").data("kendoWindow").close();
			   	     							$("#grid3").data("kendoGrid").dataSource.read();
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
				        	
				         });
			           
			           
			            //취소버튼 클릭
			            $("#cancel-user-btn").click(function(){
			            
			            	 $("#lst-add-user-window").data("kendoWindow").close();
			            });
			           
			           }
			          
			          $("#lst-add-user-window").data("kendoWindow").center();
			          $("#lst-add-user-window").data("kendoWindow").open();
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
	               editable: false,
	               sortable: true, 
	               columns: [
		                  {
		                      field:"CHECKFLAG",
		                      title: "선택",
		                      filterable: false,
		                      sortable: false,
							    width:50,
							    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
							    template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag(this, #: ROWNUMBER #)\" #: CHECKFLAG #/></div>" 
		                  },
		                  {
		                      field: "PP_NM",
		                      title: "설문지명",
							   width:200,
							   headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                        attributes:{"class":"table-cell", style:"text-align:left;text-decoration: underline;"},
							   template: "<a href='javascript:void();' onclick='javascript:fn_detailView(${PP_NO});' >${PP_NM}</a>"
		                  },
		                  {
		                      field: "RUN_DATE ",
		                      title: "기간",
		                      width:140,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"} 
		                  },
		                  {
		                      field: "",
		                      title: "설문미리보기",
		                      width:100,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"},
		                      template: "<a href='javascript:listPerview(#: PP_NO #);'>[미리보기]</a>"
		                  }, 
		                  {
		                      field: "",
		                      title: "결과",
		                      width:50,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"},
		                      template: "<a href='javascript:servResult(#: PP_NO #);'>[열람]</a>"
		                  },
		                  {
		                      field: "USEFLAG_STRING",
		                      title: "사용여부",
		                      width:100,
		                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                      attributes:{"class":"table-cell", style:"text-align:center"}
		                  },		                  		                 
		              ]
	           });
	       	
	        //설문문항 관리 리스트 삭제
	  		$("#servPpDel").click( function(){
	  			
   			var isDel = confirm("문항을 삭제 하시겠습니까?");
			 	 if(isDel){
             		var params = {
             			LIST :  $('#grid').data('kendoGrid').dataSource.data() 
  	           		};
             		
             		$.ajax({
             			type : 'POST',
     					url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_Pp_del.do?output=json",
     					data : { item: kendo.stringify( params ) },
     					complete : function( response ){
     						var obj  = eval("(" + response.responseText + ")");
     						if(obj.saveCount != 0){
     							alert("삭제되었습니다.");	
     							$("#grid").data("kendoGrid").dataSource.read();
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
	  		});
	       	
	       }       
       
       function openwindow2(ppNumber){
    	   
	   		var dataSource_serv_qstn = new kendo.data.DataSource({
	            type: "json",
			
	           transport: { read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_qstn.do?output=json", type:"POST" },
	          	 parameterMap: function (options, operation){	
	                   	return { PP_NO: ppNumber };
	                   }	
	    		},
	           schema: {
	                data: "items2",
	                model: {	
	                	OD_SEQ: "OD_SEQ",
	                    fields: {
	                  	  QSTN_SEQ : { type: "number", editable: false},
	                  	  OD_SEQ : { type: "number", editable: false},
	                  	  QSTN_TYPE_CD : { type: "int", editable: false }
	                    }
	                }
	           },
	       });
  		
   	   $("#grid2").empty();
   	   
   	   var grid2 = $("#grid2").kendoGrid({
	               dataSource: dataSource_serv_qstn,
	               columns: [
						{
						    field:"CHECKFLAG",
						    title: "선택",
						    filterable: false,
						    sortable: false,
						    width:30,
						 	  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						 	  attributes:{"class":"table-cell", style:"text-align:center"},
							  template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag2(this, #: ROWNUMBER #)\" #: CHECKFLAG #/></div>" 
					   },
// 					   {
// 						    field:"QSTN_SEQ",
// 						    title: "순번",
// 						    filterable: false,
// 						    width:30,
// 						 	  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
// 						 	  attributes:{"class":"table-cell", style:"text-align:center"} 
// //							  template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag2(this, #: ROWNUMBER #)\" #: CHECKFLAG #/></div>" 
// 					   },
// 					   {
// 						    field:"OD_SEQ",
// 						    title: "정렬순번",
// 						    filterable: false,
// 						    width:30,
// 						 	  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
// 						 	  attributes:{"class":"table-cell", style:"text-align:center"} 
// //							  template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag2(this, #: ROWNUMBER #)\" #: CHECKFLAG #/></div>" 
// 					   },
	                   {
	                       field:"QSTN_TYPE_CD_STRING",
	                       title: "문항유형",
	                       filterable: true,
						    width:60,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },	  
	                   {
	                       field:"QSTN",
	                       title: "문항",
	                       filterable: true,
						    width:160,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"}
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
	               height: 200,
	               dataBound: function(e) {
	                      if($('#grid2').data('kendoGrid').dataSource.data()!=null){
	                      	servQstnIndex = $('#grid2').data('kendoGrid').dataSource.data().length;	
	                      }else{
	                    	servQstnIndex = 0;
	                      }
	               }
	               
	           }).data("kendoGrid");
	       	
//	       	var grid2 = $("#grid2").kendoGrid({
//	       	    dataSource: dataSource,  
//	       	    scrollable: false,    
//	       	    columns: ["ROWNUMBER", "NAME", "EMPNO"]            
//	       	}).data("kendoGrid");
	       	

	       	grid2.table.kendoDraggable({
	       	    filter: "tbody > tr",
	       	    group: "gridGroup",
	       	    hint: function(e) {
	       	        return $('<div class="k-grid k-widget"><table><tbody><tr>' + e.html() + '</tr></tbody></table></div>');
	       	    }
	       	});

	       	grid2.table/*.find("tbody > tr")*/.kendoDropTarget({
	       	    group: "gridGroup",
	       	    drop: function(e) {
	       	    	
	       	        var target = dataSource_serv_qstn.get($(e.draggable.currentTarget).data("OD_SEQ")),
	       	            dest = $(e.target);
	       	        if (dest.is("th")) {
	       	            return;
	       	        }       
	       	        dest = dataSource_serv_qstn.get(dest.parent().data("OD_SEQ"));
	       	        //not on same item
	       	        if (target.get("OD_SEQ") !== dest.get("OD_SEQ")) {
	       	        	alert("z");
	       	            //reorder the items
	       	            var tmp = target.get("QSTN_SEQ");
	       	            target.set("QSTN_SEQ", dest.get("QSTN_SEQ"));
	       	            dest.set("QSTN_SEQ", tmp);
	       	            
	       	         	dataSource_serv_qstn.sort({ field: "QSTN_SEQ", dir: "asc" });
	       	        }                
	       	    }
	       	 });
	       	
	       }   
       
       function openwindow3(ppNumber) {
    	   $("#grid3").empty();
    	   
	       	$("#grid3").kendoGrid({
	               dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_targ.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){	
	                       	return { PP_NO : ppNumber};
	                       } 		
	                   },
	                   schema: {
	                   	data: "items3",
	                       model: {
	                           fields: { }
	                       }
	                   }
	               },
	               columns: [
						{
						    field:"CHECKFLAG",
						    title: "선택",
						    filterable: false,
						    sortable: false,
						    width:30,
						 	  headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
						 	  attributes:{"class":"table-cell", style:"text-align:center"} ,
							  template:"<div style=\"text-align:center\"><input type=\"checkbox\"  onclick=\"modifyYnFlag3(this, #: ROWNUMBER #)\" #: CHECKFLAG #/></div>" 
					   },
	                   {
	                       field:"DVS_NAME",
	                       title: "부서",
	                       filterable: true,
						    width:60,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                   },	  
	                   {
	                       field:"NAME",
	                       title: "이름",
	                       filterable: true,
						    width:160,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"}
	                   },
	                   {
	                       field:"EMPNO",
	                       title: "교직원번호",
	                       filterable: true,
						    width:160,
						    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
		                    attributes:{"class":"table-cell", style:"text-align:center"}
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
	               height: 200,
	               dataBound: function(e) {
	                      if($('#grid3').data('kendoGrid').dataSource.data()!=null){
	                      	servUserIndex = $('#grid3').data('kendoGrid').dataSource.data().length;	
	                      }else{
	                    	servUserIndex = 0;
	                      }
	               }
	               
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
       	    '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
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
        	  
       	    
       	    
        	  $("#runNumber").kendoComboBox({
        	        dataTextField: "TEXT",
        	        dataValueField: "VALUE",
        	        dataSource: {
	                   type: "json",
	                   transport: {
	                       read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_yeal_list.do?output=json", type:"POST" },
	                       parameterMap: function (options, operation){	
	                       	return { };
	                       } 		
	                   },
	                   schema: {
	                	   data: "items",
	                       model: {}
	                   }
	               },
        	        suggest: true,
        	        index: 0,
       	       		 change: function() {
       	       			setDataSource('N');
		       	       		
               		 }
        	    });
        	  
        	  setDataSource('Y');
        	  
        	  buttonEvent();
        	  
        	  
        	  
              $("#excelUBtn").click( function(){
                  $('#excel-upload-window').data("kendoWindow").center();      
                  $("#excel-upload-window").data("kendoWindow").open();
                 
              });
              
              if( !$("#excel-upload-window").data("kendoWindow") ){     

                  $("#excel-upload-window").kendoWindow({
                      width:"350px",
                      minWidth:"100px",
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
        	  
          }
      }]);   
        
       
	</script>
</head>
<body>
<form name="frm" id="frm" method="post" >
    <input type="hidden" name="TG_USERID" id="TG_USERID" />
    <input type="hidden" name="jkRnum" id="jkRnum" />
</form>
	<!-- START MAIN CONTNET -->

	<!-- 문항추가 선택 팝업 -->
        <div id="lst-add-qstn-window" style="display:none;">
            <div id="lst-add-qstn-window-selecter">    
            <table width="100%" cellspacing="0" cellpadding="0">                
                    <tr>         		
                        <td align="right">
                        <a class="k-button"  href="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_qstn_pool_excel.do" >POOL 엑셀 다운로드</a>&nbsp;
                        <button id="excelUBtn" class="k-button" >POOL 엑셀 업로드</button>&nbsp;
                        <button id="savePoolBtn" class="k-button"><span class="k-icon k-i-plus"></span>POOL 저장</button>
                        <div style="float:left; width: 95px"><input id="qstnPoolAllCheck"  type="checkbox" onchange="qstnPoolAllCheck(this)">전체 선택/해지</div>
                        </td>
                    </tr>
                </table>        	
                <div id="lst-add-qstn-window-selecter-grid"></div>
	                <div style="float:right; width: 370px">
	                <button id="bindPoolBtn" class="k-button">저장</button>
	                <button id="cancel-pool-btn" class="k-button">닫기</button>
                </div>
            </div>
	    </div>


	<!-- 미리보기 팝업 -->
        <div id="lst-add-perview-window" style="display:none;">
            <div id="lst-add-perview-window-selecter">    
            <table width="100%" cellspacing="0" cellpadding="0">  
                </table>        	
                <div id="lst-add-perview-window-selecter-grid"></div>
	                <div style="float:right; width: 60px">
	                	<button id="cancel-perview-btn" class="k-button">닫기</button>
               		</div>
            </div>
	    </div>
	    
	  <!-- 결과보기 팝업 -->
        <div id="lst-serv-result-window" style="display:none;">
            <div id="lst-serv-result-window-selecter">    
            <table class="tabular4" width="100%" cellspacing="0" cellpadding="0">
            	<input type="hidden" id="ppNoRst" data-bind="value:PP_NO"  readonly="readonly" />
           		※설문명 : <input id="ppNmRst" data-bind="value:PP_NM" style="width:400px; border:none" readonly="readonly" /></br>
           		※설문기간 : <input id="ppDateRst" data-bind="value:RUN_DATE" style="width:200px; border:none" readonly="readonly" /><br> <!-- ※설문현황 : 00%완료 (00몇중 00명 완료)</br>-->
       			※설문목적  <input id="ppPurpRst" data-bind="value:PP_PURP" style="width:100%; border:none;" readonly="readonly"/></br>
            </table>        	
                <div id="lst-serv-result-window-selecter-grid"></div>
                <div class="table_btn">
	               <a class="k-button"  onclick="excelDownload(this)" >엑셀 다운로드</a>
	               <button id="cancel-serv-result-btn" class="k-button">닫기</button>
	            </div>
            </div>
	    </div>

	<!-- 대상자추가 선택 팝업 -->
        <div id="lst-add-user-window" style="display:none;">
            <div id="lst-add-user-window-selecter">    
            <table width="100%" cellspacing="0" cellpadding="0">                
                    <tr>         		
                        <td>
                        <div style="float:left; width: 120px"><input id="userAllCheck"  type="checkbox" onchange="userAllCheck(this)"> 전체 선택/해지</div>
                        </td>
                    </tr>
                </table>        	
                <div id="lst-add-user-window-selecter-grid"></div>
	                <div style="float:right; width: 370px">
	                <button id="bindUserBtn" class="k-button">저장</button>
	                <button id="cancel-user-btn" class="k-button">닫기</button>
                </div>
            </div>
	    </div>
	
	
	<!-- START MAIN CONTNET -->
	<div id="content">
        <div class="cont_body">
        	<div class="title mt30">설문관리</div>
        	           <div class="table_tin01">
			                <ul>
			                    <li>
			                        <label for="runNumber" >설문년도</label> 
			                        <select id="runNumber" ></select>
			                    </li>
			                </ul>
			            </div>
            	<div class="table_zone" >
            		<div class="table_btn">            			
                    	<div style="float:left; width: 130px"><input id="allCheck"  type="checkbox" onchange="modifyAllCheck(this)"> 전체선택/전체해지</div>	
	                       <button id="servPpDel" class="k-button">삭제</button>&nbsp;
	                       <button id="newBtn" class="k-button" ><span class="k-icon k-i-plus"></span>설문지추가</button>
               		 </div>
					 <div class="table_list">
					<div id="splitter" style="width:100%; height: 100%; border:none;">
							<div id="list_pane">
								<div id="grid"></div>				
							</div>							
							<div id="detail_pane">	
								<div id="detailPp"></div>
								<div id="saveData"></div>	
								<div id="grid2"></div>	
								<div id="saveData2"></div>
								<div id="grid3"></div>								
							</div>
						</div>
					</div>
				</div>
					
		</div>
	</div>
	
		<div id="excel-upload-window" style="display: none; width: 350px;">
        <form method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/ca/ca_serv_excel_upload.do?">
            <!-- ※ 템플릿을 다운 받아 역량정보를 작성 후 업로드 하세요<br> -->
            ※  문항유형코드 : 객관식[ 1 ] 주관식[ 2 ]
            <div>
                <input name="files" id="files" type="file" /> </br>
                <div style="text-align: right;">
                    <input type="submit" value="엑셀 업로드" class="k-button" id="uploadBtn" />
                </div>
            </div>
        </form>
    </div> 
			
	<!-- END MAIN CONTENT  -->
			
			<script type="text/x-kendo-template"  id="defaultTemplate"> 		
				<table class="tabular" id="tabular" width="100%" cellspacing="0" cellpadding="0">
					<tr><td colspan="2" style="font-size:16px;">
                        <strong>&nbsp; 설문관리 </strong>
					<tr>
						<input type="hidden" id="ppNo" data-bind="value:PP_NO"  readonly="readonly" />	
						<td class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px;">&nbsp;</span> 설&nbsp문&nbsp명&nbsp <span style="color:red">*</span></td> <td class="subject"> <input type="text" id="ppNm" data-bind="value:PP_NM" style="width:700px; readonly="readonly" onKeyUp="chkNull(this);"/></td>
					</tr>
					<tr>							
						<td class="subject"><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px;">&nbsp;</span> 설문목적</td> <td class="subject"> <textarea id="ppPurp" data-bind="value:PP_PURP" style="width:700px; readonly="readonly" rows = "10"/></td>		
					</tr>
					<tr>
						<td width="100px" class="subject" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px;">&nbsp;</span> 설문기간 <span style="color:red">*</span></td>
				    	<td class="subject" > <input type="text" id="ppSt" data-bind="value:PP_ST" style="width:150px; border:none"  /> ~
							 	<input type="text" id="ppEd" data-bind="value:PP_ED" style="width:150px; border:none"  />
						</td>		    	
			    	</tr>
					<tr>
						<td class="subject" width="100px"  style="border-bottom:1px solid gray" ><span style="background:url(/images/ico/ico_rec01.gif) no-repeat 0 6px">&nbsp;</span> 사용여부</td> 
						<td class="subject" style="border-bottom:1px solid gray"><input type="radio" name="useFlag"  id="useFlag"  value="Y" /> 사용</input>
						<span style="padding-left:70px"><input type="radio" name="useFlag" id="useFlag"  value="N" /> 미사용</input></span>
						<div style="float:right; width: 170px"><button id="saveBtn" class="k-button"><span class="k-icon k-i-plus"></span>저장</button>&nbsp;
						<button id="delBtn" class="k-button">삭제</button>&nbsp;
						<button id="cencelBtn" class="k-button"><span class="k-icon k-i-close"></span>취소</button></div>
						</td>
				    </tr>
				</table>
	 		</script>
	
			<script type="text/x-kendo-template"  id="template"> 		
				<table class="tabular2" id="tabular2" width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2"><b>※설문문항 관리</b></td>
					</tr>
			    	<tr>
			    		<td colspan="2" align="right">
							<div style="float:left; width: 120px"><input id="qstnAllCheck"  type="checkbox" onchange="qstnAllCheck(this)">전체 선택/해지</div>
							<div style="text-align: right;">
			    			    <button id="qstnPool" class="k-button"><span class="k-icon k-i-plus"></span>문항추가</button>&nbsp;
								<button id="qstnPreview" class="k-button">미리보기</button>&nbsp;
								<button id="servQstnDel" class="k-button">삭제</button>&nbsp;
							</div>
			    		</td>			    	
			    	</tr>
				</table>
	 		</script>
	 		
	 		<script type="text/x-kendo-template"  id="template2"> 
		
				<table class="tabular3" id="tabular3" width="100%" cellspacing="0" cellpadding="0">	
					<tr>
						<td colspan="2" align="left">
							<b>※설문대상자 관리</b>
						</td>
					</tr>				
			    	<tr>
			    		<td colspan="2" align="right">
							<div style="float:left; width: 120px"><input id="targAllCheck"  type="checkbox" onchange="targAllCheck(this)">전체 선택/해지</div>
							<div style="text-align: right;">
								<button id="mailBtn" class="k-button" >안내메일발송</button>
			    			    <button id="servTarg" class="k-button"><span class="k-icon k-i-plus"></span>대상자추가</button>&nbsp;
								<button id="servUserDel" class="k-button">삭제</button>&nbsp;
							</div>
			    		</td>			    	
			    	</tr>
				</table>
	 		</script>
	 		
	 		
	 <script id="qstnTypeTemplate" type="text/x-kendo-tmpl">
			# if (USEFLAG == "Y"){ #						

				<input type="radio" name="qntnPoolCheck_#:ROWNUMBER#" id="qntnPoolCheck_#:ROWNUMBER#" onclick="qntnPoolCheck_1(this.id, #:ROWNUMBER#)" value="1" #= QSTN_TYPE_CD== "1" ? "checked":"" #/>객관식
				<input type="radio" name="qntnPoolCheck_#:ROWNUMBER#" id="qntnPoolCheck_#:ROWNUMBER#" onclick="qntnPoolCheck_2(this.id, #:ROWNUMBER#)" value="2" #= QSTN_TYPE_CD== "2" ? "checked":"" # />주관식

            # }else{ #
					
            # } #		
			
	</script>
	
		 <script id="qstnPreviewTemplate" type="text/x-kendo-tmpl">
									
			<b>#:RSTNUMBER#</b> . #:QSTN# </br>

			# if (QSTN_TYPE_CD == 1){ #          
				<input type="radio" name="" id=""  value="1" />매우 그렇다&nbsp
				<input type="radio" name="" id=""  value="1" />그렇다&nbsp
				<input type="radio" name="" id=""  value="1" />보통이다&nbsp
				<input type="radio" name="" id=""  value="1" />아니다&nbsp
				<input type="radio" name="" id=""  value="1" />전혀 아니다&nbsp
            # }else{ #	
				<input type="text" id="" style="width:400px;"  />
			# } #
	</script>
	 		
	 <script id="qstnDelTemplate" type="text/x-kendo-tmpl">

			<button id ="singleDel_#:QSTN_POOL_NO #" class="k-button" onclick="singleDel(#:QSTN_POOL_NO#, #:ROWNUMBER#)"><span class="k-icon k-i-plus"></span>삭제</button>

	</script>
	
	<script type="text/x-kendo-template" id="qstnPoolToolbarTemplate">
    	<div class="toolbar">
        	<button id="addQstnPool" class="k-button" >문항 추가</button>			
    	</div>
	</script>
	
	
    <script id="servResultTemplate" type="text/x-kendo-tmpl">
		
			# if ( TYPE_FLAG  == "1"){ #
				<div class="chart-wrapper">
        			<div id="chart_#:QSTN_SEQ#"></div>
    			</div>
            # }else{ #	
				#:SV_RST#
			# } #

			</br>
    </script>
    
    
    
</body>
</html>