$(document).ready(function () {
    $('.menu-item').click(menuJs.menuItem_onClick);
    $('.sub-ul-group li a').click(menuJs.subMenu_OnClick)
})

var menuJs = Object.create({
    menuItem_onClick: function () {
        $('.menu-active').removeClass('menu-active');
        $(this).addClass('menu-active');
        var subMenuBox = $(this).attr('subMenu');
        if (subMenuBox) {
            $(subMenuBox).toggle();
        } else {
            var routerLink = $(this).attr('routerlink');
            $(location).attr('href', routerLink);
        }
        
    },
    subMenu_OnClick: function () {
        var routerLink = $(this).attr('routerlink');
        $(location).attr('href', routerLink);
    },
   
})