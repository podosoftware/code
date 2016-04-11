<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.Calendar"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="architecture.ee.web.util.ParamUtils"%>
<%@ page import="javax.servlet.http.HttpSession"%>

<%
	HttpSession httpsession = request.getSession(true);
	String theme = "default";
	if (httpsession != null
			&& httpsession.getAttribute("THEME") != null) {
		theme = httpsession.getAttribute("THEME").toString();
	}

	//총괄관리자 권한 여부..
	boolean isSystem = request.isUserInRole("ROLE_SYSTEM");
	//고객사운영자 권한 여부..
	boolean isOperator = request.isUserInRole("ROLE_OPERATOR");
	//부서장 권한 여부..
	boolean isManager = request.isUserInRole("ROLE_MANAGER");

	kr.podosoft.ws.service.ca.action.ajax.CAServiceAction action = (kr.podosoft.ws.service.ca.action.ajax.CAServiceAction) architecture.ee.web.struts2.util.ActionUtils.getAction();

	String s_brdNum = action.getBrdInsertNum();
	
	List items = action.getItems();

	Map runMap = new HashMap();
	if (items != null && items.size() > 0) {
		runMap = (Map) items.get(0);

	}

	Object BOARD_TITLE = runMap.get("BOARD_TITLE");
	Object BOARD_CONTENT = runMap.get("BOARD_CONTENT");
	
	if (request.getParameter("BOARD_NUM") == null || request.getParameter("BOARD_NUM").equals("")) { //글쓰기 일경우
        BOARD_TITLE = "";
        BOARD_CONTENT = "";
    }
    
	if(BOARD_TITLE!=null && !BOARD_TITLE.equals("")){
		BOARD_TITLE = BOARD_TITLE.toString().replaceAll("\'", "\"");
	}
    
	String brdType = request.getParameter("BOARD_CODE"); //게시판 유형


	//게시판 유형별 처리
	String brdName="";
	if("1".equals(brdType)){
		brdName = "공지사항";
	}else if("2".equals(brdType)){
		brdName = "질문과 답변";
	}else if("3".equals(brdType)){
		brdName = "교육안내";
	}
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html decorator="subpage">
<head>
<title></title>

<script type="text/javascript"> 
var uId = "<%=action.getUser().getUserId()%>";
var uComId = "<%=action.getUser().getCompanyId()%>";
var brdCd = "<%=request.getParameter("BOARD_CODE")%>";
var brdNum = "<%=request.getParameter("BOARD_NUM")%>";
if(brdNum == "" || brdNum == null){ //등록일 경우 시퀀스를 받아와 처리한다.
	brdNum = <%=s_brdNum%>;
}

//권한 변수
var isManager = <%=isManager%>; //부서장
var isSystem =  <%=isSystem%>;  //총괄 관리자 
var isOperator = <%=isOperator%>;


yepnope([{
    load: [ 
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.min.css',
           'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.dataviz.<%=theme%>.min.css',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js',
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
           '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js'
    ],
    complete: function() {
        kendo.culture("ko-KR"); 
        
        //로딩바 선언..
        loadingDefine();
        
        $("#brdTitle").val('<%=BOARD_TITLE%>');
        //$("#brdCont").val('');
        /*
        @@@ 첨부파일 세팅 방법 @@@
        object_type = 2 (고정된 값)
        object_id 값은 해당 업무 테이블의 pk가 unique하다면 해당컬럼의 값으로 처리해도됨. 그렇지 않다면 pk의 조합으로 처리해야함.
        
        object_id = 회사번호+실시번호+평가대상자+지표번호
           예 ) 회사번호 1, 실시번호 7, 평가대상자 1500, 지표번호 10 => 17150010
           
        */
        var objectType = 2 ;
        
        $("#objectId").val(brdNum);
        
        if( !$("#my-file-gird").data('kendoGrid') ){
            $("#my-file-gird").kendoGrid({
                dataSource: {
                    type: 'json',
                    transport: {
                        read: { url:'<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/list-my-attachement.do?output=json', type: 'POST' },      
                        destroy: { url:'<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/delete-my-attachment.do?output=json', type:'POST' },                                
                        parameterMap: function (options, operation){
                            if (operation != "read" && options) {                                                                                                                           
                                return { objectType: objectType, objectId:$("#objectId").val(), attachmentId :options.attachmentId };                                                                   
                            }else{
                                 return { objectType: objectType, objectId:$("#objectId").val(), startIndex: options.skip, pageSize: options.pageSize };
                            }
                        }
                    },
                    schema: {
                        model: Attachment,
                        data : "targetAttachments"
                    },
                },
                pageable: false,
                height: 200,
                selectable: false,
                columns: [
                    { 
                    	field: "name", 
                    	title: "파일",  
                    	width: "500px" , 
                    	template: '#= name #' 
                   },
                   { 
                    	field: "size",
                    	title: "크기(byte)", 
                    	format: "{0:##,###}", 
                    	width: "100px" 
                   },
                   { 
                        width: "220px" , 
                        template: function(dataItem){
                        	return '<a href="<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/download-my-attachment.do?attachmentId='+dataItem.attachmentId+'" class="k-button">다운로드</a>'+
                        	'<button style="width:60px; min-width: 50px;" class="k-button" onclick="deleteFile('+dataItem.attachmentId+')">삭제</button>';
                        } 
                   }
                ]
            });
        }else{
        	handleCallbackUploadResult();
        }
        
        var ver = getInternetExplorerVersion();
        if( ( ver > -1) && ( ver < 10 ) ){
            if( $('#my-file-upload').text().length == 0  ) {
                var template = kendo.template('<button id="openUploadWindow" name="openUploadWindow">파일 업로드 하기</button>');
                $('#my-file-upload').html(template({}));
                $('#openUploadWindow').kendoButton({
                    click: function(e){
                    	var width = 380;
                        var height = 220;
                        var left = (screen.width - width) / 2;
                        var top = (screen.height - height) / 2;
                        
                        var windowUrl = "<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/save-my-attachments.do?objectType=" + objectType + "&objectId=" + $("#objectId").val() ;
                        myWindow = window.open(windowUrl, "_blank", "toolbar=no, scrollbars=yes, resizable=yes, top="+top+", left="+left+", width="+width+", height="+height);
                    }
                });
                $('button.custom-button-delete').click( function(e){
                    
                    alert ("delete");
                });
                $("#my-file-upload").removeClass('hide');
                $("#fileInfo").hide();
            }                   
        }else{                  
            if( $('#my-file-upload').text().length == 0  ) {
                var template = kendo.template($("#fileupload-template").html());
                $('#my-file-upload').html(template({}));
            }                   
            if( !$('#upload-file').data('kendoUpload') ){             
                $("#upload-file").kendoUpload({
                    showFileList : false,
                    width : 500,
                    multiple : false,
                    localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.', statusUploaded: "완료.", statusFailed : "업로드 실패." },
                    async: {
                        saveUrl:  '<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/save-my-attachments.do?output=json',                               
                        autoUpload: true
                    },
                    upload: function (e) {                                       
                        e.data = {objectType: objectType, objectId:$("#objectId").val()};                                                                                                                    
                    },
                    error : function (e){                           
                    },
                    success : function(e){                          
                        handleCallbackUploadResult();
                    },
                    select: function(e){
                        $.each(e.files, function(index, value) {
                            if(value.size>10485760){
                                e.preventDefault();
                                alert("파일 사이즈는 10M로 제한되어 있습니다.");
                            }else{
                                $.each(e.files, function(index, value) {
                                    if(value.extension != ".HWP" && value.extension != ".hwp" 
                                        && value.extension != ".DOC" && value.extension != ".doc" 
                                        && value.extension != ".PPT" && value.extension != ".ppt" 
                                        && value.extension != ".XLS" && value.extension != ".xls"
                                        && value.extension != ".PDF" && value.extension != ".pdf" 
                                        && value.extension != ".DOCX" && value.extension != ".docx" 
                                        && value.extension != ".PPTX" && value.extension != ".ppt" 
                                        && value.extension != ".XLSX" && value.extension != ".xlsx"
                                        && value.extension != ".TXT" && value.extension != ".txt"
                                        && value.extension != ".ZIP" && value.extension != ".zip"
                                        && value.extension != ".JPG" && value.extension != ".jpg" 
	                                    && value.extension != ".JPEG" && value.extension != ".jpeg" 
	                                    && value.extension != ".GIF" && value.extension != ".gif" 
	                                    && value.extension != ".BMP" && value.extension != ".bmp"
	                                    && value.extension != ".PNG" && value.extension != ".png") {
                                    	
                                        e.preventDefault();
                                        alert("업로드가 허용된 형식의 파일만 선택해주세요.\n가능한 파일확장자:hwp, doc, ppt, xls, pdf, docx, pptx, xlsx, txt, zip, jpg, jpeg, gif, bmp, png");
                                    }
                                });
                            }
                        });
                    }
                });
                $("#my-file-upload").removeClass('hide');
            }
        }
  	  
	        
	  	  //게시판에서 글쓰기 입력으로 들어왔을시 취소버튼 hide
	  	  if("<%=request.getParameter("BOARD_NUM")%>" == "" || "<%=request.getParameter("BOARD_NUM")%>" == null){
	 			 $("#backBtn").hide();
	 	 	  }
	  		
	  	  //에디터창 소환
	  	  $("#brdCont").kendoEditor({
	  		tools: [
	                "bold",
	                "italic",
	                "underline",
	                "strikethrough",
	                "justifyLeft",
	                "justifyCenter",
	                "justifyRight",
	                "justifyFull",
	                "insertUnorderedList",
	                "insertOrderedList",
	                "indent",
	                "outdent",
	                "createLink",
	                "unlink",
	                "insertImage",
	                "subscript",
	                "superscript",
	                "createTable",
	                "addRowAbove",
	                "addRowBelow",
	                "addColumnLeft",
	                "addColumnRight",
	                "deleteRow",
	                "deleteColumn",
	                "formatting",
	                "cleanFormatting",
	                "fontName",
	                "fontSize",
	                "foreColor",
	                "backColor"
	            ]
	  	  });
	  	 
	  	  //목록버튼
	      $("#listBtn").click(function(){
	    	  fn_location();
	       });
	        
			//저장 취소버튼
	      $("#backBtn").click(function(){
	      		$("#BOARD_CODE").val(brdCd);
		      	$("#BOARD_NUM").val(brdNum);
	          	document.frm.action = "<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/service/ca/brd_detail.do";
	          	document.frm.submit();
          });
			 
		  // 게시글 등록 및 수정
	      $("#brdSave").click( function(){
   				if($("#brdTitle").val()=="") {
          			alert("게시물 제목을 입력해 주세요");
          			$("#brdTitle").focus();
          			return false;
          		}
          		if($("#brdCont").val()=="") {
          			alert("게시물 내용을 입력해 주세요");
          			$("#brdCont").focus();
          			return false;
          		}	
          		
          		if(!confirm("게시물을 저장하시겠습니까?")) return;
                //로딩바생성
                loadingOpen();
                
                <%
                if(brdType.equals("3")){
                %>
          		var params = {
                        LIST :  $('#empList').data('kendoGrid').dataSource.data(),
                };
          		<%
                }
                %>
          		//제목에 html 태그 입력 체크..
          		var boardTitle = $("#brdTitle").val();
          		boardTitle = boardTitle.replace(/</gi,'&lt;').replace(/>/gi,'&gt;');
          		
          		$.ajax({
                     type : 'POST',
                     url : "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_cont_save.do?output=json",
                    	data : { 
                     		BOARD_TITLE : boardTitle
                     		, BOARD_CONTENT : $("#brdCont").val()
                     		, BOARD_CODE : brdCd
                     		, BOARD_NUM : brdNum
                            <%
                            if(brdType.equals("3")){
                            %>
                            , mailItem: kendo.stringify( params )
                            <%
                            }
                            %>
                     },
                     complete : function(response) {
                     	//로딩바 제거.
                         loadingClose();
                     	
                         var obj = eval("(" + response.responseText + ")");
                         if(obj.error){
                         	alert("ERROR==>"+obj.error.message);
                         }else{
                             if (obj.saveCount != 0) {
                                 alert("저장되었습니다.");
                                 $("#BOARD_CODE").val(brdCd);
                                 $("#BOARD_NUM").val(brdNum);
                                 if(brdNum==null || brdNum ==""){
                                 	fn_location(); //화면이동
                                 }else{
   								document.frm.action = "<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/ca/brd_detail.do";
   			                	document.frm.submit();
                                 }
                             } else {
                                 alert("저장에 실패 하였습니다.");
                             }
                         }
                     },
                     error : function(xhr, ajaxOptions, thrownError) {
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
            	
        });
		  
		  <%
		  if(brdType.equals("3")){
		  %>
          //대상자 추가버튼 클릭 시
          $("#empInsertPop").click(function(){
              var emp = $("#empList").data("kendoGrid");
              //empPop('alwEmp');
              
              if( !$("#pop04").data("kendoWindow") ){
                  $("#pop04").kendoWindow({
                      width:"800px",
                      height:"590px",
                      resizable : true,
                      title : "임직원 찾기",
                      modal: true,
                      visible: false
                  });

                  
                  var empGrid = $("#findEmp").kendoGrid({
                      dataSource: {
                           type: "json",
                           transport: {
                               read: { url:"<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/mtr/find-emp-list.do?output=json", type:"POST" },
                               parameterMap: function (options, operation){
                                   var sortField = "";
                                   var sortDir = "";
                                   if (options.sort && options.sort.length>0) {
                                      sortField = options.sort[0].field;
                                      sortDir = options.sort[0].dir;
                                   }
                                    return {
                                        ADMIN : isManager,
                                        DIVISION_BOSS : isSystem,
                                        OPERATOR : isOperator,
                                        startIndex: options.skip, pageSize: options.pageSize, sortField: sortField, sortDir: sortDir, filter: JSON.stringify(options.filter) 
                                    };
                               }
                           },
                           schema: {
                              total : "totalItemCount",
                                data: "items3",
                                model: {
                                   id : "USERID",
                                   fields : {
                                          USERID : {
                                              type : "number",
                                              editable : false
                                          },
                                          GRADE_NUM: {
                                              type : "string",
                                              editable : false
                                          },
                                          DIVISIONID : {
                                              type : "string",
                                              editable : false
                                          },
                                          USEFLAG : {
                                              type : "string",
                                              editable : false
                                          }
                                      }
                                }
                           },
                           pageSize : 30,
                           serverPaging : true,
                           serverFiltering : true,
                           serverSorting : true,
                           requestEnd : function () {
                        	   $('#allchkbox').removeAttr('checked');
                           },
                           error : function(e) {
                               //alert(e.status);
                               if(e.xhr.status==403){
                                  alert("세션이 종료되었거나 접근이 유효하지 않은 URL 입니다.");
                                  sessionout();
                               }else{
                                  alert('xhr.status = ' + e.xhr.status + '\n' +  'xhr.statusText = '  + e.xhr.statusText );
                               }
                           }
                       },
                       columns : [
                                  {
                                	  field : "CHECKFLAG",
                                      title : "선택",
                                      filterable : false,
                                      sortable : false,
                                      width : 80,
                                      headerAttributes : {
                                          "class" : "table-header-cell",
                                          style : "text-align:center"
                                      },
                                      attributes : {
                                          "class" : "table-cell",
                                          style : "text-align:center"
                                      },
                                      headerTemplate: "선택 <input type=\"checkbox\" id=\"allchkbox\" onchange=\"modifyAllCheck(this);\" />",
                                      template : "<div style=\"text-align:center\"><input type=\"checkbox\" id=\"check_#:USERID#\" onclick=\"modifyYnFlag(this, #: USERID #)\" #: CHECKFLAG #\></div>"
                                  },
                                  {
                                      field : "NAME",
                                      title : "성명",
                                      width : 120,
                                      headerAttributes : {
                                          "class" : "table-header-cell",
                                          style : "text-align:center"
                                      },
                                      attributes : {
                                          "class" : "table-cell",
                                          style : "text-align:center"
                                      }
                                  },
                                  {
                                      field : "DVS_FULLNAME",
                                      title : "부서명",
                                      width : 300,
                                      headerAttributes : {
                                          "class" : "table-header-cell",
                                          style : "text-align:center"
                                      },
                                      attributes : {
                                          "class" : "table-cell",
                                          style : "text-align:left"
                                      }
                                  },
                                  {
                                      field : "GRADE_DIV_NM",
                                      title : "직렬",
                                      width : 120,
                                      headerAttributes : {
                                          "class" : "table-header-cell",
                                          style : "text-align:center"
                                      },
                                      attributes : {
                                          "class" : "table-cell",
                                          style : "text-align:center"
                                      }
                                  },
                                  {
                                      field : "GRADE_NM",
                                      title : "직급",
                                      width : 120,
                                      headerAttributes : {
                                          "class" : "table-header-cell",
                                          style : "text-align:center"
                                      },
                                      attributes : {
                                          "class" : "table-cell",
                                          style : "text-align:center"
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
                              height: 500,
                              sortable : true,
                              pageable : true,
                              resizable : true,
                              reorderable : true,
                              pageable : {
                                  refresh : false,
                                  pageSizes :[10,20,30, 3000],
                                  buttonCount : 5
                              }
                      }).data("kendoGrid"); 
                  
                  //대상자추가버튼 클릭 시..
                  $("#addUserBtn").click(function(){
                	  
                	  
                	    var popArray;
                	    var empArray;
                	    var overlap = true;
                	    popArray = empGrid.dataSource.data();

                	    var res = $.grep(popArray, function (e) {
                	        return e.CHECKFLAG == "checked";
                	    });
                	    
                	    if(res.length==0){
                	    	alert("대상자를 선택해주세요");
                	    	return false;
                	    }
                	    
                	    if(!confirm("선택한 임직원을 추가하시겠습니까?")) return;
                	    
                	    empArray = $($('#empList')).data('kendoGrid').dataSource.data();
                	    
                	    var insCnt = 0;
                	    for(var i = 0 ; i < res.length ; i++){
                	    	var isBe = false;
                	    	if(empArray.length>0){
                	    		for(var j = 0; j < empArray.length; j++){
                	    			if(res[i].USERID == empArray[j].USERID){
                	    				isBe = true;
                	    			}
                	    		}
                	    	}
                	    	
                	    	if(!isBe){
                	    		insCnt++;
                	    		$($('#empList')).data('kendoGrid').dataSource.insert(res[i]);
                	    	}
                	    }

                	    if(insCnt>0){
                	    	alert("추가되었습니다.");
                	    }else{
                	    	alert("이미 추가된 임직원입니다.");
                	    }
                	    //$("#pop04").data("kendoWindow").close();
                	    
                  });
                  
                  //닫기
                  $("#closeUserBtn").click(function(){
                	  $("#pop04").data("kendoWindow").close();
                  })
               }
          
               $("#pop04").data("kendoWindow").center();
               $("#pop04").data("kendoWindow").open();
               
          });
          
          
	      $("#empList").kendoGrid({
	    	  dataSource: {
	                type: "json",
	                schema: {
	                    data: "items",
	                    model: {
	                        fields: {
	                            ALW_STD_SEQ : { type: "int" },
	                            NAME : { type: "string" },
	                            USERID : { type: "string" }
	                        }
	                    }
	                },
                    pageSize : 30,
	                serverPaging:false, serverFiltering:false, serverSorting:false
	            },
	            columns: [
	                {
	                    field:"NAME",
	                    title: "성명",
	                    width: "120px",
	                    filterable: true,
	                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    attributes:{"class":"table-cell", style:"text-align:center;"},
	                },
	                {
                        field:"DVS_FULLNAME",
                        title: "부서",
                        width:"300px",
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:left"}
                    },
                    {
	                    field:"GRADE_DIV_NM",
	                    title: "직렬",
	                    width:"120px",
	                    filterable: true,
	                    headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
	                    attributes:{"class":"table-cell", style:"text-align:center"} 
	                },
                    {
                        field:"GRADE_NM",
                        title: "직급",
                        width:"120px",
                        filterable: true,
                        headerAttributes:{"class":"table-header-cell", style:"text-align:center"},
                        attributes:{"class":"table-cell", style:"text-align:center"} 
                    },
	                {
	                    title : "삭제",
	                    filterable : false,
	                    sortable : false,
	                    width : "70px",
	                    headerAttributes : { "class" : "table-header-cell", style : "text-align:center" },
	                    attributes : {"class" : "table-cell", style : "text-align:center"},
	                    template: function(dataItem){
	                            return "<button id=\"empDel\" class=\"k-button\" style=\"min-width:50px\" onclick=\"javascript: fn_empDel("+dataItem.USERID+");\">삭제</button>";
	                    }
	                }
	            ],
	            filterable: {
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
	            pageSize: 30,
	            height: 300,
	            groupable: false,
	            sortable: true,
                pageable : true,
                resizable: true,
                reorderable: true,
                selectable: "row",
                pageable : {
                    refresh : false,
                    pageSizes : [10,20,30]
                 }
	        });
	      
	      <%
		  }
	      %>
	}
}]);

<%
if(brdType.equals("3")){
%>
	//전체선택..
	function modifyAllCheck(checkbox){
	    var array = $("#findEmp").data("kendoGrid").dataSource.view();
	    $.each(array, function(i,e){
	        if(checkbox.checked == true){
	            e.CHECKFLAG = "checked";
	            $("#check_"+e.USERID).attr("checked", true);
	        }else{
	            e.CHECKFLAG = "";
	            $("#check_"+e.USERID).removeAttr("checked");
	        }
	    });       
	};
	// 체크박스 체크..
	function modifyYnFlag(checkbox, id){
	    var item = $("#findEmp").data("kendoGrid").dataSource.get(id);
	    if(checkbox.checked == true){
	        item.CHECKFLAG = 'checked';
	    }else{
	        item.CHECKFLAG = "";
	        
	        // 전체선택 버튼 해제
	        $('#allchkbox').removeAttr('checked');
	    }
	}
	//임직원 삭제 (ROW 삭제)
	function fn_empDel(userId){
	    if(userId != null && userId != "" ){
	        isDel = confirm("삭제 하시겠습니까?");
	    }
	    if(isDel){
	        var array;
	        array = $('#empList').data('kendoGrid').dataSource.data();
	        var res = $.grep(array, function (e) {
	            return e.USERID == userId;
	        });
	        
	        $($('#empList')).data('kendoGrid').dataSource.remove(res[0]);
	     }
	}
<%
}
%>
</script>

<script type="text/javascript">

//첨부파일 리로딩
function handleCallbackUploadResult(){
    $("#my-file-gird").data('kendoGrid').dataSource.read();             
}
//첨부파일 버전 체크
function getInternetExplorerVersion() {    
    var rv = -1; // Return value assumes failure.    
    if (navigator.appName == 'Microsoft Internet Explorer') {        
         var ua = navigator.userAgent;        
         var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");        
         if (re.exec(ua) != null)            
             rv = parseFloat(RegExp.$1);    
        }    
    return rv; 
}

//첨부파일 삭제.
function deleteFile (attachmentId){
	if(confirm("첨부파일을 삭제 하시겠습니까?")){
		$.ajax({
            type : 'POST',
            url : '<%=architecture.ee.web.util.ServletUtils
					.getContextPath(request)%>/delete-my-attachment.do?output=json' ,
            data:{ attachmentId : attachmentId },
            success : function(response){
            	handleCallbackUploadResult();
            },
            dataType : "json"
        });
	}

} 

//결과 처리후 페이지 이동
function fn_location(){ 
    if(brdCd=="1"){
    	document.frm.action = "<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/service/ca/brd_notice_main.do";
    }else if(brdCd=="2"){
    	document.frm.action = "<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/service/ca/brd_qna_main.do";
    }else if(brdCd=="3"){
    	document.frm.action = "<%=architecture.ee.web.util.ServletUtils.getContextPath(request)%>/service/ca/brd_edu_info_main.do";
	}
		document.frm.submit();
};
</script>

</head>
<body>
	<form id="frm" name="frm" method="post">
		<input type="hidden" name="BOARD_CODE" id="BOARD_CODE" /> 
		<input type="hidden" name="BOARD_NUM" id="BOARD_NUM" /> 
		<input type="hidden" name="objectId" id="objectId" />
	</form>

	<!-- START MAIN CONTNET -->


	<div class="container">
		<div id="cont_body">
		 <div class="content">
			<div class="top_cont" style ="margin-bottom : 50px">	 
					<h3 class="tit01"><%=brdName%> </h3>
					<%-- <div class="point">
					※ <%=brdName%>의 내용을 수정 및 등록합니다. 
					</div> --%>
					<div class="location">
						<span><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/ico/ico_home.png" /> &nbsp;&#62;</span>
						<span><%=brdName%>&nbsp; &#62;</span>
						<span class="h">등록 </span>
					</div><!--//location-->
			</div>
			<div class="sub_cont">
				<div class="table_wp04">
					<table class="list_view01">
						<caption>게시판 view</caption>
						<colgroup>
							<col style="width:150px"/>
							<col style="width:1070px"/>
						</colgroup>
						<tbody >
							<tr>
								<th><div class="tb_tit">제목</div></th>
								<td><input type="text" id="brdTitle" style="width: 1050px;" value="" />
							</td>
							</tr>
							<tr>
								<th><div class="tb_tit">내용</div></th>
								<td>
									<textarea id="brdCont" rows="10" cols="30" style="height: 440px;"><%=BOARD_CONTENT%></textarea>
							     </td>
							</tr>
							
                            <tr>
                                <th><div class="tb_tit">첨부파일</div></th>
                                <td>
                                    <div class="drag_Area" id="drag_plan" >
					                    <div class="info" id="fileInfo">업로드할 파일은 아래의 파일선택 버튼을 클릭하여 직접 선택하거나, 아래의 영역에 파일을 끌어서 놓기(Drag & Drop)를 하세요</div>
					                    <div class="area" style="width: 1050px; padding-right: 0;">
					                           <div id="my-file-upload" class="hide" style="width: 1050px;"></div>
					                    </div>
				                    </div>
				                   
				                    <div style="width: 1050px;">
				                        <div id="my-file-gird" ></div>
				                    </div>
				                    <script type="text/x-kendo-tmpl" id="fileupload-template">
                                        <input name="upload-file" id="upload-file" type="file"/>
                                    </script>
                          
                                </td>
                            </tr>
          <%
          if(brdType.equals("3")){
          %>
                            <tr>
                                <th><div class="tb_tit">알림메일</div></th>
                                <td>
                                    <div style="width: 100%;" id="empList"></div>
                                    <div style="margin-top: 5px;">
	                                    <button class="k-button ie7_left" id="empInsertPop" >대상자추가</button>
	                                    <span style="vertical-align: middle;">※ 알림메일은 저장 버튼을 클릭하면 전송됩니다.</span>
                                    </div>
                                 </td>
                            </tr>
          <%
          }
          %>                  
						</tbody>
					</table>
					<table class="list_view01">
						<tbody id="brdContent">
						</tbody>
					</table>
					<div class="sub_title01"></div>

				

					<div style="text-align:right;width: 1200px; padding-top:15px;">
                    	<button id="brdSave" class="k-button">저장</button>
						<button id="backBtn" class="k-button">취소</button>
						<button id="listBtn" class="k-button">목록</button>
					</div>
				</div>
			 </div>
 			</div>
		</div>
	</div>

    <!-- 메일 대상자 -->
    <div id="pop04" style="display:none;">
        <div class="point3 mb10" >
            <span>※ 찾고자 하는 임직원을 각 컬럼의 필터기능을 이용하여 찾으십시오</span>
            
        </div>
        <div id="findEmp"></div>
        <!-- <div class="btn_center">
            <button class="k-button" style="width:55px;">확인</button>
        </div> -->
        <div style="text-align: center; margin-top: 10px;">
            <button id="addUserBtn" class="k-button  k-primary">대상자추가</button>
            <button id="closeUserBtn" class="k-button  k-primary">닫기</button>
        </div>
    </div><!--//pop04-->
</body>
</html>