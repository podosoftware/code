jQuery(function($){


	// faq 아코디언	
	$("dl.accordion dd").css("display","none");
    $("dl.accordion dt").append('<a href="#" class="icon">답변닫힘</a>');
    $("dl.accordion dt").click(function(e){
        if($("+dd",this).css("display")=="none"){		        	
            $("dl.accordion dd").slideUp(300, "swing");
            $("+dd",this).slideDown(300, "swing");		            
            $("dl.accordion dt").removeClass("off");
            $("dl.accordion .icon").html("답변닫힘");
            $(this).addClass("off");
            $(this).find("dl.accordion .icon").html("답변열림");
        }else{
        	$("+dd",this).slideUp(300, "swing");
        	$(this).removeClass("off");
        	$(this).find("dl.accordion .icon").html("답변닫힘");
        }        
        e.preventDefault();
    });
	

	// tbl 아코디언	
	$(".accordion_tbl .reply").css("display","none");
    $(".accor_list").find('.ico_plus').append('<a href="#" class="icon">답변닫힘</a>');
    $(".accor_list .list_tit, .accor_list .icon").click(function(e){
    	
    	var $list = $(this).parents('tr').next();
    	var $reply = $(this).parents('tr').next().find('.reply');
        var $tr = $(this).parents('tr');
        
        if($reply.css("display")=="none"){
        	$('.reply').slideUp(300, "swing");
        	$list.find('.reply').slideDown(300, "swing");
        	$reply.css("display","block");	
        	$(".list_tit").removeClass("on");
        	$(".ico_plus").removeClass("off");
        	$("td .icon").html("답변닫힘");
        	$tr.find(".ico_plus").addClass("off");
        	$tr.find(".list_tit").addClass("on");
        	$tr.find(".icon").html("답변열림");
        }else{
        	$reply.slideUp(300, "swing");
        	$tr.find(".ico_plus").removeClass("off");
        	$tr.find(".list_tit").removeClass("on");
        	$tr.find(".icon").html("답변닫힘");
        }        
        e.preventDefault();
    });



});

