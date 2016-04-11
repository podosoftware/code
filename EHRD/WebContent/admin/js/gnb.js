
var oneNum = -1;
var twoNum = -1;
var interval;
var duration = 200;
var isSlideUp = false;  //�������������� 2���� �Ⱥ��̷��� true �ƴϸ� false
jQuery(document).ready(function(){
	jQuery(".totalMenuNewDiv").slideUp(0);
	var isView = false;
	var isTab = false;
	oneNum = jQuery(".oneNum").val();
	twoNum = jQuery(".twoNum").val();
	
	jQuery(".gnbNew ul").children().stop().animate({paddingBottom:15}, 0, function(){isView = true;})
	jQuery(".totalOnbgDiv").css("height", jQuery(document).height());
	if(oneNum != -1) activeOneMenu();  //�޴� Ȱ��ȭ
	jQuery(".gnbNew ul").children().each(function(q){
		//1���� ���� ���ε�
		jQuery(this).bind("mouseover", function(){
			clearInterval(interval);
			jQuery(".gnbNew ul").children().removeClass("on");
			if(isView) jQuery(this).stop().animate({paddingBottom:40}, 0);
			if(isTab) jQuery(".depthTwo").find("a").removeClass("on");
			isTab = false;
			jQuery(this).stop().animate({paddingBottom:40}, 180, function(){isView = true;});
			jQuery(this).addClass("on");
			if(oneNum != -1 && q != oneNum) {
				jQuery(".gnbNew ul").children().eq(oneNum).removeClass("on");
			}
		}).focusin(function(){
			jQuery(".gnbNew ul").children().removeClass("on");
			jQuery(".gnbNew ul").children().stop().animate({paddingBottom:15}, 180, function(){isView = false;});
			clearInterval(interval);
			jQuery(".gnbNew ul").children().removeClass("on");
			if(isView) jQuery(this).stop().animate({paddingBottom:40}, 0);
			jQuery(this).stop().animate({paddingBottom:40}, 180, function(){isView = true;});
			jQuery(this).addClass("on");
			if(oneNum != -1 && q != oneNum) {
				jQuery(".gnbNew ul").children().eq(oneNum).removeClass("on");
			}
			isTab = true;
		})

		//1���� �ƿ� ���ε�
		jQuery(this).bind("mouseout", function(){
			jQuery(".gnbNew ul").children().stop().animate({paddingBottom:15}, 180, function(){isView = false;});
			//jQuery(this).removeClass("on");
			clearInterval(interval);
			interval = setTimeout("activeInterval()", duration);
			if(twoNum != -1) activeTwoMenu();
		}).focusout(function(){
			//jQuery(this).trigger("mouseout");
		})
	})

	jQuery(".gnbDivNew").mouseleave(function(){
		//clearInterval(interval);
		//interval = setTimeout("activeInterval()", duration);
	})

	//2���� ���ε�
	jQuery(".depthTwo").each(function(q){
		jQuery(this).find("a").each(function(k){
			jQuery(this).bind("mouseenter", function(){
				if(twoNum != -1) {
					jQuery(".depthTwo").eq(oneNum).find("a").eq(twoNum).removeClass("on");
				}
				jQuery(this).addClass("on");
			}).focusin(function(){
				jQuery(this).trigger("mouseenter");
			})

			jQuery(this).bind("mouseleave", function(){
				jQuery(this).removeClass("on");
				if(twoNum != -1) activeTwoMenu();
			}).focusout(function(){
				clearInterval(interval);
				interval = setTimeout("activeInterval()", duration);
				jQuery(this).trigger("mouseleave");
			})
		})
	})

	//��ü����
	jQuery(".totolMenuNew").toggle(function(){
		jQuery(".totalOnbgDiv").stop(true, true).fadeIn(150);
		jQuery(".totalMenuNewDiv").stop(true, true).slideDown(150);
	}, function(){
		jQuery(".totalOnbgDiv").stop(true, true).fadeOut(150);
		jQuery(".totalMenuNewDiv").stop(true, true).slideUp(150);
	})
})

//1���� Ȱ��ȭ
function activeOneMenu()
{
	jQuery(".gnbNew ul").children().eq(oneNum).addClass("on");

	if(isSlideUp) jQuery(".gnbNew ul").children().eq(oneNum).stop().animate({paddingBottom:15}, 180, function(){isView = true;});
	else jQuery(".gnbNew ul").children().eq(oneNum).stop().animate({paddingBottom:40}, 180, function(){isView = true;});

	if(twoNum != -1) activeTwoMenu();
}

//2���� Ȱ��ȭ
function activeTwoMenu()
{
	jQuery(".gnbNew ul").children().eq(oneNum).find(".depthTwo").find("a").eq(twoNum).addClass("on");
}

//���͹� Ȱ��ȭ
function activeInterval()
{
	if(oneNum != -1) {
		jQuery(".gnbNew ul").children().removeClass("on");
		jQuery(".gnbNew ul").children().eq(oneNum).addClass("on");

		if(isSlideUp) jQuery(".gnbNew ul").children().eq(oneNum).stop().animate({paddingBottom:15}, 180, function(){isView = true;});
		else jQuery(".gnbNew ul").children().eq(oneNum).stop().animate({paddingBottom:40}, 180, function(){isView = true;});

		if(twoNum != -1) activeTwoMenu();
	} else {
		jQuery(".gnbNew ul").children().removeClass("on");
		jQuery(".gnbNew ul").children().stop().animate({paddingBottom:15}, 180, function(){isView = false;});
	}

	clearInterval(interval);
}