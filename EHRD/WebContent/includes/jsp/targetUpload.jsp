<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
String fileType = "";
if(request.getParameter("fileType")!=null){
	fileType = request.getParameter("fileType").toString();
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>수강생업로드</title>

<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
<script type="text/javascript"> 

		yepnope([{
			load: [ 
				'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
				'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.bootstrap.min.css',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jquery/1.8.2/jquery.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/jgrowl/jquery.jgrowl.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.all.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/kendo.ko_KR.js',             
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/kendo/cultures/kendo.culture.ko-KR.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.ui.min.js',
				'<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/common.models.min.js',
                '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/common/jquery.form.min.js'
			],
			complete: function() {
				kendo.culture("ko-KR"); 
				<%
				kr.podosoft.ws.service.ba.action.admin.BaMgmtSubjectAction action = (kr.podosoft.ws.service.ba.action.admin.BaMgmtSubjectAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
				%>
				var subjectNum = <%= action.getSubjectNum() %> ;
				var openNum = <%= action.getOpenNum() %> ;
				var isMultipart = <%= architecture.ee.web.struts2.util.ActionUtils.isMultiPart(request) %>;
				var fileType = "<%=fileType%>";
				var saveCount = "<%= action.getSaveCount() %>";
				
				if( subjectNum > 0 && openNum > 0 && !isMultipart  ){
					$("#subjectNum").val(subjectNum);
					$("#openNum").val(openNum);
					

					if( !$('#upload_file').data('kendoUpload') ){
						$("#upload_file").kendoUpload({
							showFileList : true,
							width : 300,
							height: 27,
							multiple : false,
							localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.', statusUploaded: "완료.", statusFailed : "업로드 실패." },
							select: function(e){
									$.each(e.files, function(index, value) {
                                        if(value.extension.toLowerCase() != ".xls" && value.extension.toLowerCase() != ".xlsx") {
                                            e.preventDefault();
                                            alert("엑셀 파일만 선택해주세요.");
                                        }
                                    });
								
							}
					});

				}
			}

			if (subjectNum > 0 && openNum > 0 && isMultipart) {
				if (typeof window.opener.handleCallbackUploadResult != "undefined") {
					window.opener.handleCallbackUploadResult(saveCount);
				}
				window.close();
			}

		}
	} ]);

	function upload() {
	    document.frm.submit();
	}
</script>
		
</head>
<body >
<form id="frm" name="frm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/operator/sbjct/save-target-user-excel.do" >
<div style="position:relative;">            
            <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/file_upload.gif"  />

			<div style="height:130px; padding:0px;">
            		<input id="subjectNum" name="subjectNum" type="hidden" value="" />
					<input id="openNum" name="openNum" type="hidden" value="" />
                    <input name="upload_file" id="upload_file" type="file" />
            </div>
            <div style="text-align:center; " >
                <a href="javascript:upload();"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/con_btn.gif" type="submit" value="확인" style="border:0px;" /></a>
            </div>
            <div>
                 ※ 엑셀 작성 방법 => A열에 추가될 교직원번호를 작성.<br>        
                 ※ 파일을 선택하면 자동업로드 됩니다.
             </div>
</div>
</form>

</body>
</html>