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

function addMenu(i){
	if( !$("#window").data("kendoWindow") ){
		$("#window").kendoWindow({
			width:"1060px",
			height:"604px",
			resizable : true,
			title : "메뉴 추가",
			modal: true,
			visible: false
		});
	}
	$("#window").data("kendoWindow").center();
	$("#window").data("kendoWindow").open();
	$("#menu_pos_num").val(i+1);
}

	</script>
	<input type="hidden" id="menu_pos_num" name="menu_pos_num"/>
			<!--팝업 코딩 시작-->
	<div id="window" style="display:none;">
		<div class="menu_add">
			<ul class="one">
				<li class="fir">
					<em>[역량진단]</em>
					<a href="#">
						<span class="des" id="1" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/1.png" /></span>
							<span class="stit">1.역량진단</span>
						</span>
					</a>
				</li>
				<li class="sec">
					<em>[역량진단 결과]</em>
					<a href="#">
						<span class="des" id="2" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/2.png" /></span>
							<span class="stit">2.진단실시현황</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="3" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/3.png" /></span>
							<span class="stit">3.소속별응답현황</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="4" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/4.png" /></span>
							<span class="stit">4.직무별응답현황</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="5" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/5.png" /></span>
							<span class="stit">5.역량별직무/계급점수</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="6" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/6.png" /></span>
							<span class="stit">6.역량별점수</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="7" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/7.png" /></span>
							<span class="stit">7.종합진단결과</span>
						</span>
					</a>
				</li>
			</ul>
			<ul class="two">
				<li class="fir">
					<em>[경력개발계획]</em>
					<a href="#">
						<span class="des" id="8" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/8.png" /></span>
							<span class="stit">8.계획수립</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="9" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/9.png" /></span>
							<span class="stit">9.계획수립현황</span>
						</span>
					</a>
				</li>
				<li class="sec">
					<em>[교육훈련]</em>
					<a href="#">
						<span class="des" id="10" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/10.png" /></span>
							<span class="stit">10.나의강의실</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="11" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/11.png" /></span>
							<span class="stit">11.교육신청</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="12" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/12.png" /></span>
							<span class="stit">12.상시학습</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="13" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/13.png" /></span>
							<span class="stit">13.상시학습관리</span>
						</span>
					</a>
				</li>
				<li class="last">
					<em>[교육훈련결과]</em>
					<a href="#">
						<span class="des" id="14" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/14.png" /></span>
							<span class="stit">14.부서원교육현황</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="15" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/15.png" /></span>
							<span class="stit">15.부서원상시학습달성현황</span>
						</span>
					</a>
				</li>
			</ul>
			<ul class="third">
				<li class="fir">
					<em>[멘토링]</em>
					<a href="#">
						<span class="des" id="16" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/16.png" /></span>
							<span class="stit">16.멘토링</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="17" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/17.png" /></span>
							<span class="stit">17.멘토링관리</span>
						</span>
					</a>
				</li>
				<li class="sec">
					<em>[게시판]</em>
					<a href="#">
						<span class="des" id="18" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/18.png" /></span>
							<span class="stit">18.공지사항</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="19" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/19.png" /></span>
							<span class="stit">19.질문과답변</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="20" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/20.png" /></span>
							<span class="stit">20.교육안내</span>
						</span>
					</a>
				</li>
				<li class="last">
					<em>[승인하기]</em>
					<a href="#">
						<span class="des" id="21" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/21.png" /></span>
							<span class="stit2">21.경력개발계획승인</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="22" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/22.png" /></span>
							<span class="stit3">22.멘토링승인</span>
						</span>
					</a>
					<a href="#">
						<span class="des" id="23" onClick=selMenu(this); >
							<span class="img"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/main/23.png" /></span>
							<span class="stit">23.교육승인</span>
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