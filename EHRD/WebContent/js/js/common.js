  $(function(){
    $(".nav > ul > li").bind("mouseenter keydown", function(){
       var el = $('.nav');
       var curHeight = 0;
       curHeight = el.height();
       var autoHeight = 0;
       autoHeight = el.css('height', 'auto').height();

       $(".nav > ul").find("li").removeClass("selected");
       $(this).addClass("selected");
       $(this).find("ul").css("height",autoHeight);
       $('.sub_nav_bg').stop().css('display','block').animate({'height':autoHeight-53},300,'easeOutExpo');
       el.height(curHeight).stop().animate({"height" : autoHeight}, {easing:"easeOutExpo", duration:300});
    });

    $(".nav > ul > li").bind("mouseleave keyup", function(){
      $(this).removeClass("selected");
      $(this).find("ul").css("height","auto");
      $(".nav").stop().animate({"height" : 42}, {easing:"easeOutExpo", duration:300});
      $(".sub_nav_bg").stop().animate({"height" : 0}, {easing:"easeOutExpo", duration:300});
    });

	$(window).scroll(function() {
        navigation.scroll();
    });
  });


  var navigation = {
      settings : {
          offset: 65
      },
      scroll : function() {
          var scroll_top = $(window).scrollTop() * 1;
		  var scroll_bottom = ($(document).height() - $(window).height() - $(window).scrollTop()) * 1;

          if( scroll_top > navigation.settings.offset ) {
              $(".sub_nav_bg").css({'position': 'fixed', 'top': 43 });/*top:42에서 top:0으로 수정함*/
              $('.nav-area').css({ 'position': 'fixed', 'top': '0' });
          } else {
              $('.nav-area').css({ 'position': 'relative'});
              $(".sub_nav_bg").css({'position': 'absolute', 'top': 108 });/*top:135에서 top:108로 수정*/
          }

      }
  };
  