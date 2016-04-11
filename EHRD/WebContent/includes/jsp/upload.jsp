<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
HttpSession httpsession = request.getSession(true);
String theme = "default";
if(httpsession !=null && httpsession.getAttribute("THEME")!=null){
    theme = httpsession.getAttribute("THEME").toString();
}
String fileType = "";
if(request.getParameter("fileType")!=null){
	fileType = request.getParameter("fileType").toString();
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>파일업로드</title>

<script src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/js/yepnope/1.5.4/yepnope.min.js"></script>
<script type="text/javascript"> 

		yepnope([{
			load: [ 
				'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.common.min.css',
				'css!<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/styles/kendo/kendo.<%=theme%>.min.css',
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
				architecture.ee.web.struts2.action.ajax.MyAttachmentAction action = (architecture.ee.web.struts2.action.ajax.MyAttachmentAction) architecture.ee.web.struts2.util.ActionUtils.getAction();
				%>
				var objectType = <%= action.getObjectType() %> ;
				var objectId = <%= action.getObjectId() %> ;
				var isMultipart = <%= architecture.ee.web.struts2.util.ActionUtils.isMultiPart(request) %>;
				var fileType = "<%=fileType%>";
				
				if( objectType > 0 && objectId > 0 && !isMultipart  ){
					$("#objectType").val(objectType);
					$("#objectId").val(objectId);
					
					//if( $('#my-file-upload').text().length == 0  ) {
					//	var template = kendo.template($("#fileupload-template").html());
					//	$('#my-file-upload').html(template({ "objectType": objectType, "objectId" : objectId}));
					//
					//}	
					if( !$('#upload_file').data('kendoUpload') ){
						$("#upload_file").kendoUpload({
							showFileList : true,
							width : 300,
							height: 27,
							multiple : false,
							localization:{ select : '파일 선택' , dropFilesHere : '업로드할 파일을 이곳에 끌어 놓으세요.', statusUploaded: "완료.", statusFailed : "업로드 실패." },
							select: function(e){
								if(fileType=="img"){
									$.each(e.files, function(index, value) {
										if(value.size>10485760){
		                                    e.preventDefault();
		                                    alert("파일 사이즈는 10M로 제한되어 있습니다.");
		                                }
										
		                                if(value.extension != ".JPG" && value.extension != ".jpg" 
                                            && value.extension != ".JPEG" && value.extension != ".jpeg" 
		                                          && value.extension != ".GIF" && value.extension != ".gif" 
		                                              && value.extension != ".BMP" && value.extension != ".bmp"
		                                                  && value.extension != ".PNG" && value.extension != ".png") {
		                                    e.preventDefault();
		                                    alert("이미지 파일만 선택해주세요.");
		                                }
			                        });
								}else{
									$.each(e.files, function(index, value) {
										if(value.size>10485760){
                                            e.preventDefault();
                                            alert("파일 사이즈는 10M로 제한되어 있습니다.");
                                        }
                                        
										if(value.extension != ".HWP" && value.extension != ".hwp" 
                                            && value.extension != ".DOC" && value.extension != ".doc" 
                                            && value.extension != ".PPT" && value.extension != ".ppt" 
                                            && value.extension != ".XLS" && value.extension != ".xls"
                                            && value.extension != ".PDF" && value.extension != ".pdf" 
                                            && value.extension != ".DOCX" && value.extension != ".docx" 
                                            && value.extension != ".PPTX" && value.extension != ".pptx" 
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
								/*
								$.ajax({
									url:  '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/common/get-file-size.do',
									type: 'post',
									cache: false,
									data: $("#frm").serialize(),
									dataType: 'json',
									success: function(data){
										alert("s--"+data);
									},
									error: function(data){
										alert("f--"+data);
									}
								});
								
								var options = { 
									    url:        '<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/service/common/get-file-size.do?output=json', 
									    dataType : 'json',
									    success:    function(data) { 
									    	alert(data);
									    } 
									}; 
									 
								$('#frm').ajaxForm(options);
								*/

							}
					});

				}
			}

			if (objectType > 0 && objectId > 0 && isMultipart) {
				if (typeof window.opener.handleCallbackUploadResult != "undefined") {
					window.opener.handleCallbackUploadResult();
				}
				alert("업로드가 완료되었습니다.");
				window.close();
			}

		}
	} ]);

	function upload() {
		var uploadFile = $('#upload_file').data('kendoUpload');
		if(uploadFile){
			if($(".k-filename").text()==""){
				alert("파일을 선택해주세요.");
			}else{
				document.frm.submit();
			}
		}
	    
	}
</script>
		
</head>
<body>
<form id="frm" name="frm" method="post" action="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/save-my-attachments.do" >
<div style="position:relative;">            
            <img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/file_upload.gif"  />

			<div style="height:130px; padding:0px;">
            		<input id="objectType" name="objectType" type="hidden" value="" />
					<input id="objectId" name="objectId" type="hidden" value="" />
                    <input name="upload_file" id="upload_file" type="file" />
                    
            </div>
            <!-- img id="loading" src="loading.gif" style="display:none;"-->
            <div style="text-align:center; " >
                <a href="javascript:upload();"><img src="<%= architecture.ee.web.util.ServletUtils.getContextPath(request) %>/images/con_btn.gif" style="border:0px;" /></a>
            </div>
</div>
</form>

</body>
</html>