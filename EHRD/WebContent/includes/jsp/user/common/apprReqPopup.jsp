<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    
<script type="text/javascript">

      var apprReqCallBackFunc;
      //승인요청 공통팝업.
      function apprReqOpen(){
    	  var apprReq_window = $("#apprReq-window");
          
    	  var dataSource_latestAppr;

          //최근 승인요청정보.
          dataSource_latestAppr = new kendo.data.DataSource({
              type: "json",
              transport: {
                  read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_my_latest_appr_info.do?output=json", type:"POST" },
                  parameterMap: function (options, operation){    
                      return { };
                  }
              },
              schema: {
                  data: "items"
              },
              serverFiltering: false,
              serverSorting: false});
          
          dataSource_latestAppr.fetch(function(){
              if(dataSource_latestAppr.data().length>0){
                  var latestHtml = "";
                  
                  $.each(dataSource_latestAppr.data(), function(i,e){
                      latestHtml += "<tr><td><ul class=\"last\"><li class=\"name\">"+this.USER_INFO+"</li></ul></td><td><div class=\"sel_btn\"><button onclick=\"apprReq( '"+this.REQ_NUM+"');\" class=\"k-button\" >선택</button></div></td></tr>";
                  });
                  $("#apprReqTbody").html(latestHtml);
              }else{
                  $("#apprReqTbody").html("<tr><td><ul class=\"last\"><li class=\"name\">최근 승인요청 정보가 존재하지 않습니다. </li></ul></td><td><div class=\"sel_btn\"></div></td></tr>");
              }
          });
          
          
	      if (!apprReq_window.data("kendoWindow")) {
	    	  apprReq_window.kendoWindow({
	              width: "800px",
	              title: "승인자 선택",
                  modal: true,
                  visible: false
	          });
	          
	    	  //승인자 검색 그리드.
	          var apprReqSearchGrid = $("#apprReqSearchGrid").kendoGrid({
	        	  dataSource: {
                      type: "json",
                      transport: {
                          read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_appr_user_req_search_list.do?output=json", type:"POST" },
                          parameterMap: function (options, operation){
                               return { NAME : $("#reqUserSearchInput").val(), SEARCHDIV: $("#reqUserSearchDiv").val() };
                          }
                      },
                      schema: {
                          total : "totalItemCount",
                           data: "items",
                           model: {
                               fields: {
                            	   USERID : { type: "number" },
                            	   NAME: { type:"string"},
                            	   DVS_NAME : { type: "string" },
                            	   EMPNO: { type: "string"},
                            	   GRADE_NM: { type: "string" }
                                  }
                           }
                      },
                      pageSize : 99999,
                      serverPaging: false, serverFiltering: false, serverSorting: false
                  },
                  height: 155,
                  groupable: false,
                  sortable: true,
                  resizable: true,
                  reorderable: true,
                  pageable: false,
                  columns: [{
                      title: "선택",
                      width: 100,
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"},
                      template : function(data){
                    	  return "<button class=\"k-button\" onclick=\"addApprUser("+data.USERID+")\">선택</button>";
                      }
                  }, {
                      field: "NAME",
                      width: 100,
                      title: "성명",
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"}
                  }, {
                      field: "DVS_FULLNAME",
                      width: 250,
                      title: "부서",
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"}
                  }, /*{
                      field: "EMPNO",
                      width: 100,
                      title: "교직원번호",
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"}
                  }, */{
                      field: "GRADE_NM",
                      width: 180,
                      title: "직급",
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"}
                  }]
              }).data("kendoGrid");
	    	  
	    	  //승인자검색 텍스트박스
	    	  $("#reqUserSearchInput").bind("keydown", function(e){
	    		  //엔터키일 경우 검색..
	    		  if(e.keyCode == 13){
	    			  if($("#reqUserSearchInput").val()==""){
	    				  alert("성명을 입력해주세요.");
	    				  return false;
	    			  }
	    			  
	    			  $("#reqUserSearchDiv").val("Y");
	    			  apprReqSearchGrid.dataSource.read();
	    			  
	    			  if(event.preventDefault){
                          event.preventDefault();
                      } else {
                          event.returnValue = false;
                      }
	    		  }
	    	  });
	    	  //승인자검색 버튼 
	    	  $("#reqUserSearchBtn").bind("click", function(){
	    		  if($("#reqUserSearchInput").val()==""){
                      alert("성명을 입력해주세요.");
                      return false;
                  }
	    		  $("#reqUserSearchDiv").val("Y");
	    		  apprReqSearchGrid.dataSource.read();
	    		  
	    		  if(event.preventDefault){
                      event.preventDefault();
                  } else {
                      event.returnValue = false;
                  }
	    	  });

	    	  //승인경로 데이터소스.
              var dataSource_apprReqUser = new kendo.data.DataSource({
                  schema: {
                   	  model: {
                             fields: {
                            	 RNUM : { type: "number"},
                                 USERID : { type: "number" },
                                 NAME: { type:"string"},
                                 DVS_NAME : { type: "string" },
                                 EMPNO: { type: "string"},
                                 GRADE_NM: { type: "string" }
                                }
                   	  }
                  }
              });
	    	
	    	  //승인경로 그리드.
              var apprReqUserGrid = $("#apprReqUserGrid").kendoGrid({
                  dataSource: dataSource_apprReqUser,
                  height: 155,
                  groupable: false,
                  sortable: false,
                  resizable: false,
                  reorderable: true,
                  pageable: false,
                  columns: [{
                      field: "REQ_LINE_SEQ",
                      width: 40,
                      title: " No",
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"}
                  }, {
                      field: "APPR_DIV_CD",
                      width: 120,
                      title: "구분",
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"},
                      template: function(data){
                    	  var apprDiv = "";
                    	  var selected1,selected2,selected3,selected4,selected5,selected6 = "";
                    	  if(data.APPR_DIV_CD=="1"){
                    		  selected1 = "selected";
                    	  }else if(data.APPR_DIV_CD=="2"){
                              selected2 = "selected";
                          }else if(data.APPR_DIV_CD=="3"){
                              selected3 = "selected";
                          }else if(data.APPR_DIV_CD=="4"){
                              selected4 = "selected";
                          }else if(data.APPR_DIV_CD=="5"){
                              selected5 = "selected";
                          }else if(data.APPR_DIV_CD=="6"){
                              selected6 = "selected";
                          }
                    	  apprDiv += "<select id=\"apprDivCd"+data.USERID+"\" onchange=\"apprDivChange(this, "+data.USERID+");\" data-bind=\"value:APPR_DIV_CD\">";
                    	  apprDiv += "    <option value='' >선택</option>";
                          apprDiv += "    <option value='1' "+selected1+">결재</option>";
                    	  apprDiv += "    <option value='2' "+selected2+">결재(전결)</option>";
                    	  apprDiv += "    <option value='3' "+selected3+">결재(대결)</option>";
                    	  apprDiv += "    <option value='4' "+selected4+">검토</option>";
                    	  apprDiv += "    <option value='5' "+selected5+">협조</option>";
                    	  apprDiv += "    <option value='6' "+selected6+">통보</option>";
                    	  apprDiv += "</select>";
                    	  apprDiv += "<script type=\"text/javascript\">";
                    	  apprDiv += "    var apprDivCd = $(\"#apprDivCd"+data.USERID+"\").kendoDropDownList().data(\"kendoDropDownList\");";
                    	  apprDiv += "<\/script>";
                    	  return apprDiv;
                      }
                  }, {
                      field: "NAME",
                      width: 80,
                      title: "성명",
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"}
                  }, {
                      field: "DVS_NAME",
                      width: 150,
                      title: "부서",
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"}
                  }, /*{
                      field: "EMPNO",
                      width: 100,
                      title: "교직원번호",
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"}
                  }, */{
                      field: "GRADE_NM",
                      width: 180,
                      title: "직급",
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"}
                  }, {
                      title: "삭제",
                      width: 100,
                      headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                      attributes:{"class":"table-cell", style:"text-align:center"},
                      template: function(data){
                    	  
                    	  return "<button class=\"k-button\" onclick=\"apprLineDel("+data.USERID+")\">삭제</button>";
                      }
                  }]
              }).data("kendoGrid");
              
              $("#apprReqPopupBtn").click(function(){
            	  if(apprReqUserGrid.dataSource.data().length==0){
            		  alert("승인경로가 존재하지 않습니다.");
            		  return false;
            	  }
            	  if(apprReqUserGrid.dataSource.data().length>3){
                      alert("승인경로는 최대 3명까지 입니다.");
                      return false;
                  }
            	  var apprid = "";
            	  var apprCnt = 0;
            	  $.each(apprReqUserGrid.dataSource.data(), function(i, e){
            		  if(this.APPR_DIV_CD==null || this.APPR_DIV_CD==""){
            			  apprCnt ++;
            		  }
            	  });
            	  if(apprCnt>0){
            		  alert("승인경로 구분을 선택해주세요.");
            		  return false;
            	  }
            	  
                  if(confirm( "선택한 승인경로로 승인요청 하시겠습니까?" )){
                      if(apprReqCallBackFunc){
                          apprReqCallBackFunc("Y");
                          apprReq_window.data("kendoWindow").close();
                      }
                  }
              });
	      }else{
	    	  dataSource_latestAppr.read();
	    	  
	    	  $("#reqUserSearchInput").val("");
	    	  $("#reqUserSearchDiv").val("");
	    	  
	    	  $("#apprReqSearchGrid").data("kendoGrid").dataSource.read();
	    	  
	    	  $("#apprReqUserGrid").data("kendoGrid").dataSource.data([]);
	    	  
	    	  //dataSource_apprReqUser.data([]);
	      }
	      
	      apprReq_window.data("kendoWindow").open();
	      apprReq_window.data("kendoWindow").center();
      }
      
      function apprDivChange(obj, userid){
    	  var res = $.grep($("#apprReqUserGrid").data("kendoGrid").dataSource.data(), function (e) {
              return e.USERID == userid;
          });
    	  res[0].APPR_DIV_CD = obj.value;
      }
      
      //최근 승인정보를 통해 승인경로 설정...
      function apprReq( reqNum ){
    	  if(confirm("선택된 정보로 승인경로가 설정됩니다. 하단의 승인요청 버튼을 클릭하여 주세요.")){
	    		  
	
	          //최근 승인요청정보.
	          var dataSource_apprReqLine = new kendo.data.DataSource({
	              type: "json",
	              transport: {
	                  read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/cdp/get_appr_req_line_list.do?output=json", type:"POST" },
	                  parameterMap: function (options, operation){    
	                      return { REQ_NUM : reqNum };
	                  }
	              },
	              schema: {
	                  data: "items"
	              },
	              serverFiltering: false,
	              serverSorting: false});
	    	  
	          dataSource_apprReqLine.fetch(function(e){
	        	  $("#apprReqUserGrid").data("kendoGrid").dataSource.data([]);
	        	  
	        	  $.each(dataSource_apprReqLine.data(), function(i, e){
	        		  $("#apprReqUserGrid").data("kendoGrid").dataSource.add(e);
	        	  });
	          });
          }
      }
      
      function addApprUser(userid){
    	  //이미 승인경로에 존재하는지 체크.
    	  var chkRes = $.grep($("#apprReqUserGrid").data("kendoGrid").dataSource.data(), function (e) {
                return e.USERID == userid;
          });
    	  if(chkRes.length>0){
    		  alert("이미 승인경로에 존재합니다.");
    		  return false;
    	  }
    	  
    	  var array = $("#apprReqSearchGrid").data("kendoGrid").dataSource.data();
    	  var res = $.grep(array, function (e) {
    		    return e.USERID == userid;
    	  });
    	  
    	  $("#apprReqUserGrid").data("kendoGrid").dataSource.add({
    		  REQ_LINE_SEQ : null,
    		  USERID : res[0].USERID,
    		  NAME : res[0].NAME,
    		  DVS_NAME : res[0].DVS_NAME,
    		  EMPNO : res[0].EMPNO,
    		  GRADE_NM : res[0].GRADE_NM,
    		  APPR_DIV_CD : null
    	  });
    	  setApprLineSeq();
      }
      
      //승인경로 데이터 순으로 결재순번 설정
      function setApprLineSeq(){
    	  var cnt = 0;
    	  $.each($("#apprReqUserGrid").data("kendoGrid").dataSource.data(), function(i, e){
    		  cnt++;
    		  this.REQ_LINE_SEQ = (i+1);
    	  });
    	  $("#apprReqUserGrid").data("kendoGrid").refresh();
      }
      
      //승인경로 삭제
      function apprLineDel(userid){
    	  var array = $("#apprReqUserGrid").data("kendoGrid").dataSource.data();
    	  var res = $.grep(array, function (e) {
              return e.USERID == userid;
          });
    	  $("#apprReqUserGrid").data("kendoGrid").dataSource.remove(res[0]);
          setApprLineSeq();
      }
      
</script>
<style scoped>
	#apprReq-window .k-window-title {font-size:13px;font-weight:bold;}
	#apprReq-window {padding:0px 25px 0px 25px !important}/*팝업 내부 콘텐츠 간격*/
</style>
<!-- 승인요청 팝업 -->
<div id="apprReq-window" style="display: none;">
    
    <h4 class="pop_tit mt10">최근 승인요청 정보</h4>
    <div class="sel_pop">
        <table class="table_type03">
            <colgroup>
                <col style="width:*" />
                <col style="width:75px;" />
            </colgroup>
            <tbody id="apprReqTbody">
                <!-- <tr>
                    <td>
                        <ul class="last">
                            <li class="name">홍길동(12345) 5급사무관</li>
                        </ul>
                    </td>
                    <td><div class="sel_btn"><a href="#">[선택]</a></div></td>
                </tr>
                <tr>
                    <td>
                        <ul class="last">
                            <li class="name">홍길동(12345) 5급사무관 > 임꺽정(54321) 4급관리자</li>
                        </ul>
                    </td>
                    <td><div class="sel_btn"><a href="#">[선택]</a></div></td>
                </tr>
                <tr>
                    <td>
                        <ul class="last">
                            <li class="name">홍길동(12345) 5급사무관 > 임꺽정(54321) 4급관리자</li>
                        </ul>
                    </td>
                    <td><div class="sel_btn"><a href="#">[선택]</a></div></td>
                </tr> -->
            </tbody>
        </table>
    </div><!--//sel_pop-->
    <h4 class="pop_tit mt10 ">승인자 검색</h4>
    <div class="app_search">
        <input id="reqUserSearchDiv" type="hidden" />
<!--         <input type="radio" title="동일부서 선택" /><label class="part01 ml5 mr15">동일부서</label>  -->
<!--         <input type="radio" title="자체부서 선택" /><label class="part02 ml5">자체부서</label>  -->
            <input id="reqUserSearchInput" type="text" class="k-textbox inp_style01" style="width:200px;" />
            <button id="reqUserSearchBtn" class="k-button btn_style02" >검색</button>
        <div class="btn">
            
        </div>
    </div>
    <div id="apprReqSearchGrid"></div>
    * 팀원/팀장 : 과장전결, 과(실)장 : 교육훈련담당자 통보<br>
    * 상단의 '승인자 검색'을 사용하여 결재선을 변경할 수 있습니다.
    <h4 class="pop_tit mt10 ">승인경로</h4>
    <div id="apprReqUserGrid"></div>
    <div class="btn_center mt10 mb15">
        <button id="apprReqPopupBtn" class="k-button k-primary" style="width:110px;">승인요청</button>
    </div>
</div><!--//apprReq-window-->
