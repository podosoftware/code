<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script type="text/javascript">
yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/js/jquery.easing.1.3.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.web.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
           
           
    ],
    complete: function() {
        kendo.culture("ko-KR"); 
      //승인요청/처리현황>경력개발계획
		var menuDataSource = new kendo.data.DataSource({
            type: "json",
            transport: {
            	read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/quick-menu-data.do?output=json", type:"POST" },
                parameterMap: function (options, operation){    
                    return;
                }
            },
            schema: {
                data: "items1",
                total: "totalItemCount",
                model: {
                    fields: {
                    	CNT : { type: "string" },
                    	REQ_STS_CD : { type: "string" }
                    }
                }
            },
            serverFiltering: false,
            serverSorting: false
        });
		
		menuDataSource.fetch(function(){
			var view = menuDataSource.view();
			if(view.length>0){
				if(view[0].REQ_STS_CD=="1"){
					$("#CDP_SUM_CNT").text(view[0].CNT);
					$("#CDP_REST_CNT").text(view[1].CNT);
				}else if(view[0].REQ_STS_CD=="2"){
					$("#CDP_SUM_CNT").text(view[0].CNT);
					$("#CDP_REST_CNT").text("0");
				}
			}else{
					$("#CDP_SUM_CNT").text("0");
					$("#CDP_REST_CNT").text("0");
			}	
		});
    }
}]);


function selMenu(obj){
	var pos_num = $("#menu_pos_num").val();
	var menu_num = $(obj).attr("id");
	
	//if(){
		$.ajax({
		       type : 'POST',
		       url: "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/main/quick-menu-sel.do?output=json",
		       data : { 
		    	   MENU_NUM : menu_num,
		    	   MENU_POS_NUM : pos_num
		       },
		       complete : function( response ){
		    	   var obj = eval("(" + response.responseText + ")");
		           console.log(obj.saveCount);
		            if(obj.error){
		                alert("ERROR=>"+obj.error.message);
		            }else{
		                if(obj.saveCount > 0){
							$("#window").data("kendoWindow").close();
							location.reload();
		                   if(event.preventDefault){
		                       event.preventDefault();
		                   } else {
		                       event.returnValue = false;
		                   }
		                }else{
		                    alert("이미 등록되어있는 메뉴입니다.");
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
		           if(event.preventDefault){
		               event.preventDefault();
		           } else {
		               event.returnValue = false;
		           };
		       },
		       dataType : "json"
		});
	//}else{
	//	alert("이미 등록되어있는 메뉴입니다.");
	//}
}

function emPower(id){
	if( !$("#window").data("kendoWindow") ){
		$("#window").kendoWindow({
			width:"620",
			height:"320px",
			resizable : true,
			title : "교육담당자 변경",
			modal: true,
			visible: false
		});
	}
	$("#window").data("kendoWindow").center();
	$("#window").data("kendoWindow").open();
	$("#userId").val(id);
}
function changReq(){
	alert("변경요청");
}

function fn_empInsert(userId,mod){
	//var array;
	var popArray;
	var empArray;
	var overlap = true;
	
	popArray = $('#findEmp').data('kendoGrid').dataSource.data();
	var res = $.grep(popArray, function (e) {
		return e.USERID == userId;
	});
	
	//그리드의 유저 목록을 가져옴
	empArray = $($('#menteeList')).data('kendoGrid').dataSource.data();
	$("#personText").val(res[0].NAME);
	$("#userId").val(res[0].USERID);
	$("#pop04").data("kendoWindow").close();
}
	</script>
	<input type="hidden" id="userId" name="userId"/>
			<!--팝업 코딩 시작-->
	<div id="window" style="display:none;">
		<div class="menu_add">
			<ul class="one">
				<li>
					<em>※ 교육담당자 권한을 타인에게 양도할 수 있습니다.</em>
					<em>※ 변경요청이 승인되면 귀하의 교육담당자 권한은 없어지며, 새로운 담당자에게 권한이 부여됩니다.</em>
					<a href="#">
						<span class="des">
							<span class="department">▣ 현재 담당 부서 : 국가보훈처 서울지방보훈청 수원보훈지청 관리과</span>
							<span class="person">▣ 새로운 담당자
								<input type="text" id="personText" class="k-textbox" disabled style="width:170px;margin-right:1px;" title="담당자"/>
								<button  class="k-button wid60 ie7_left" onclick="empPop();">검색</button>
								<button  onclick="mentoNmDel()" class="k-button  wid60">삭제</button>
							</span>
							<button  onclick="changReq()" class="k-button" align="center">변경요청</button>
						</span>
					</a>
				</li>
			</ul>
		</div><!--//menu_add-->
	</div>
	<style>
			 .k-window-content{padding:30px !important;}
			 .k-window-title {font-size:13px !important;}
	</style>
			<!--//팝업코딩끝-->
<%@ include file="/includes/jsp/user/common/findEmployeePopup.jsp"  %>