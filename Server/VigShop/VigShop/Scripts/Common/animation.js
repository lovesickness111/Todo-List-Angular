$(document).ready(function () {
    $(document).mouseup(animationJs.document_onMouseUp);
    $('#menu-help').click(function () {
        $(".toogle-dropdown-content").toggle("slow");
    }//chỗ này dùng slide của jquery cũng được
    );
})

var animationJs = Object.create({
    /* ---------------------------------------------------------------------------------------------
    * Nhấn chuột vào các vùng không phải là button ẩn hiện các element thì thực hiện ẩn toàn bộ các element đó đi
    */
    document_onMouseUp: function (e) {
        // Thằng nào không muốn bị ảnh hưởng bởi Event này thì set cho nó thêm class targetNotEffectByMouseUp:
        var targetNotEffectByMouseUp = $(e.target).hasClass('targetNotEffectByMouseUp');
        if (!targetNotEffectByMouseUp) {
            var container = $(".clause-filter-selection");
            var containerHideIfOutside = $(".hide-if-outside");
            // if the target of the click isn't the container nor a descendant of the container
            if (!container.is(e.target) && container.has(e.target).length === 0) {
                container.remove();
                $('.btn-select-filter-active').removeClass('btn-select-filter-active');
            }

            // Đối với các target chỉ thực hiện ẩn đi:
            containerHideIfOutside.hide();
        }
    },
})