//các hàm xử lý controll 
$(document).ready(function () {
    //sử lý các class comboboxData
    $('.combobox[controlType="ComboboxData"] input').focus(function () {
        this.parentElement.classList.add('focus-default');
    })
    //class focus-default cho phép khối combobox có thêm border
    $('.combobox[controlType="ComboboxData"] input').focusout(function () {
        this.parentElement.classList.remove('focus-default');
    })

    $('.combobox[controlType="ComboboxData"] input').blur(controlJs.inputCombobox_OnBlur);

    $('.combobox[controlType="ComboboxData"] .trigger-loadData').click(controlJs.showDataSelection);
});

var controlJs = Object.create({
    //itemText : giá trị của ô input đang được chọn
    //itemValue: combobox nào
    //existData : kiểm tra dữ liệu có chưa
    //comboboxElement: ô combobox đang được chọn
    inputCombobox_OnBlur: function () {
        var me = this,
            itemText = $(this).val(),
            itemValue,
            existData = (itemText.trim() === ''),
            comboboxElement = this.parentElement;
        // các giá trị hiện có của cbb
        var comboboxDataItemElement = $(comboboxElement).find('[controlType="comboboxData"] .combobox-data-item');
        if (!existData) {//nếu không có dữ liệu trong ô input thì lặp qua các phần tử
            comboboxDataItemElement.each(function (index, item) {
                //nếu giá trị item = giá trị của ô input thì gán gía trị cho các thuộc tính cbb
                if (item.innerText.toUpperCase() === itemText.toUpperCase()) {
                    itemText = item.innerText;
                    itemValue = $(item).attr('item-value');
                    existData = true;
                    return true;
                }
            });
        }
        //nếu có dữ liệu rồi thì in vào ô input
        if (existData) {
            $(comboboxElement).find('input').val(itemText);
            $(comboboxElement).find('input').attr('item-value', itemValue);
            $(comboboxElement).removeClass('border-red');
            $(comboboxElement.parentElement).removeClass('error-box');
            $(comboboxElement.parentElement).removeAttr('title');
        } else {
            $(comboboxElement).addClass('border-red');
            $(comboboxElement.parentElement).addClass('error-box');
            $(comboboxElement.parentElement).attr('title', 'Dữ liệu không có trong danh sách');
            $(comboboxElement).find('input').val('');
            $(comboboxElement).find('input').removeAttr('item-value');
        }
    },

    /* ---------------------------------------------------------------------------------------------
     * Ẩn hiện lựa chọn cac item trong combobox
     * Author: vig (14/05/2018)
     */
    showDataSelection: function (event) {
        debugger;
        var comboboxElement = this.parentElement,
            heightCombobox = comboboxElement.offsetHeight,
            widthCombobox = comboboxElement.offsetWidth,
            offsetComboboxElement = controlJs.offset(comboboxElement);
        var comboboxDataElement = $('#comboboxData');
        comboboxDataElement.css('top', (offsetComboboxElement.top + heightCombobox).toString() + 'px');
        comboboxDataElement.css('width', widthCombobox.toString() + 'px');
        comboboxDataElement.css('left', offsetComboboxElement.left.toString() + 'px');
        //$(comboboxElement).find('.combobox-data').toggle();
        $(comboboxElement).find('input').focus();

    },

    /* ---------------------------------------------------------------------------------------------
     * Ẩn hiện lựa chọn cac item trong combobox
     * Author: vig (14/05/2018)
     */
    offset: function (el) {
        var rect = el.getBoundingClientRect(),
            scrollLeft = window.pageXOffset || document.documentElement.scrollLeft,
            scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        return { top: rect.top + scrollTop, left: rect.left + scrollLeft }
    }
})