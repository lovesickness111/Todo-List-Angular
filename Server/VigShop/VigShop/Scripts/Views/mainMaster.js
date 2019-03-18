$(document).ready(function () {
    $('.main-nav ul li').click(mainMaster.menuItem_OnClick);
    $('.pn-sub-menu .item .child-content').click(mainMaster.pnSubMenuItem_OnClick)
    $('.header-user-info').click(function () {
        $('.user-info-menu').toggle();
    })
})

var mainMaster = Object.create({
    menuItem_OnClick: function (sender) {
        var me = this;
        if (me.id === 'menu-item-dictionary') {
            $('.pn-sub-menu').toggle();
        } else {
            $('.main-nav .menu-parent li').removeClass('menu-active');
            me.classList.add('menu-active');
            if (me.classList.contains('menu-has-children-close')) {
                // Ẩn tất cả những thằng có menu con khác đang mở:
                $('.menu-has-children-open').find('.wrap-menu-children').slideToggle(200);
                $('.menu-has-children-open').addClass('menu-has-children-close');
                $('.menu-has-children-open').removeClass('menu-has-children-open');


                // hiển thị menu con của Menu hiện tại:
                $(this).find('.wrap-menu-children').slideToggle(200);
                me.classList.remove('menu-has-children-close');
                me.classList.add('menu-has-children-open');
            } else if (me.classList.contains('menu-has-children-open')) {
                $(this).find('.wrap-menu-children').slideToggle(200);
                me.classList.remove('menu-has-children-open');
                me.classList.add('menu-has-children-close');
            }
        }
        sender.stopPropagation();
    },
    pnSubMenuItem_OnClick: function (sender) {
        $('.pn-sub-menu').hide();
    }

})