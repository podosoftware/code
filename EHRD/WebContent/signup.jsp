<%@ page pageEncoding="UTF-8"%>
<html decorator="main">
<head>
<title>회원가입</title>
<script type="text/javascript">
		yepnope([{
       	  load: [ 
          	'css!<%=request.getContextPath()%>/styles/kendo/kendo.common.min.css',
          	'css!<%=request.getContextPath()%>/styles/kendo/kendo.metro.min.css',
			'<%=request.getContextPath() %>/js/jquery/1.8.2/jquery.min.js',
       	    '<%= request.getContextPath()  %>/js/kendo/kendo.web.min.js',
      	    '<%= request.getContextPath()  %>/js/common/common.models.min.js' 
          ],
          complete: function() {        	              		              		  
        	  
        	  
        	  var newUser = new User ({});		
        	  kendo.bind($("form[name='signup-fm']"), newUser); 
        	  
        	  
        	  
        	  
        	  $("#signup-btn").click(function() {    	
        		  
        		  // data : { groupId:selectedGroup.groupId, items: '[' + kendo.stringify( selectedUser ) + ']'  },
        		  if( newUser.password != newUser.password2 ){
        			  alert("비밀번호가 같지 않습니다.");
        			  $("#password2").val("").focus();  
        			  return ;
        		  }else{
        			  $.ajax({
							type : 'POST',
							url : "<%= request.getContextPath()  %>/accounts/signup-register.do?output=json",
							dataType: 'json',
							data : { item : kendo.stringify( newUser )  },
							success : function( response ){	
		                           if( response.error ){ 
		                        	   $("form[name='signup-fm']")[0].reset();   
		                        	   alert( response.error.message );
		                           } else {
		                                $("form[name='signup-fm']")[0].reset();               	                            
		                                $("form[name='signup-fm']").attr("action", "/main.do").submit();
		                           }      	
							},
							error:function(){
								$("form[name='signup-fm']")[0].reset(); 
							},
							dataType : "json"
						});	        		

        		  }        		  
        		  
        	  });  
        	  
        	  
          }
		}]);  
</script>
<style scoped>

                .pane-content {
                    padding: 10px;
                }
</style>
</head>
<body>
	<!-- Main Page Content  -->

<div class="yui3-g">
    <div class="yui3-u-1"><div class="content"><h2>회원가입</h2></div></div>
</div>	
<div class="yui3-g">
    <div class="yui3-u-1-2"><div class="content"></div></div>
    <div class="yui3-u-1-2">
	    <div class="content">    
			<form name="signup-fm" id="signup-fm" >
				<table>
				  <tbody>
				    <tr>
				      <td><label for="name" class="right inline required">이름</label></td>
				      <td><input class="k-textbox" data-bind="value: name"  placeholder="이름" /></td>
				    </tr>
				    <tr>
				      <td><label for="username" class="right inline">아이디</label></td>
				      <td> <input type="text" id="username" class="k-textbox"   data-bind="value: username"   placeholder="아이디"></td>
				    </tr>
				    <tr>
				      <td><label for="password" class="right inline">비밀번호</label></td>
				      <td><input type="password" id="password" class="k-textbox" data-bind="value: password"  placeholder="비밀번호"></td>
				    </tr>
				    <tr>
				      <td><label for="password2" class="right inline">비밀번호 확인</label></td>
				      <td><input type="password" id="password2" class="k-textbox" data-bind="value: password2"  placeholder="비밀번호"></td>
				    </tr>
				    
				    <tr>
				      <td><label for="email" class="right inline">메일</label></td>
				      <td>
				             <span class="k-textbox k-space-left">
			                    <input type="email" id="email"  data-bind="value: email"  placeholder="메일">
			                    <a href="#" class="k-icon k-i-email">&nbsp;</a>
			                </span>
				      </td>
				    </tr>
				    <tr>
				      <td><label for="nameVisible"  class="right inline">이름 공개</label></td>
				      <td><input type="checkbox" id="nameVisible"  data-bind="value: nameVisible"  class="k-checkbox" ></td>
				    </tr>   
				    <tr>
				      <td><label for="emailVisible"  class="right inline">메일 공개</label></td>
				      <td><input type="checkbox" id="emailVisible"  class="k-checkbox" ></td>
				    </tr>                
				  </tbody>
				</table>  
				<button id="signup-btn" class="k-button" type="submit">회원가입</button>
			</form>
    	</div>
    </div>
</div>
	
	<!-- End Main Content -->  	
</body>
</html>