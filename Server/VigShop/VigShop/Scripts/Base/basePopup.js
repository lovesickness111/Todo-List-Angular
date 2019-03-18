//các file js nên có cấu trúc như object basePopup
var basePopup = $.extend(base, Object.create({
    masterTable: null,//table truyền vào
    detailForm: null,//dialog hiện ra để xác nhận thoát
    //tạo form mới----> gọi đến hàm chi tiết form
    initForm: function (args) {
        var me = this;
        me.initDetailForm();
    },
    //sau khi load form load lại dữ liệu
    afterLoadForm: function (args) {
        var me = this;
        commonJS.setFirstRowSelected(me.masterTable);
        me.loadData();
    },
    initDetailForm: function () {

    },
    //hàm tạo sự kiện với chuột
    intEvents: function (args) {
        var me = this;
        $(me.masterTable).find('tbody tr').click(commonJS.rowTable_OnClick);
        $(me.masterTable).find('tbody tr').dblclick(me.rowTable_OnDbClick);
        //$(me.detailForm).find('#btnSave').click(me.btnSave_OnClick);
        //$(me.detailForm).find('#btnSaveAdd').click(me.btnSaveAdd_OnClick);
        //$(me.detailForm).find('#btnCancel').click(me.btnCancel_OnClick);
        //$(me.detailForm).find('#btnHelp').click(me.btnHelp_OnClick);
        $('input.validate-required').blur(me.inputValidateRequired_OnBlur);
    },
    loadData: function () {

    },
    rowTable_OnDbClick: function (sender) {
        alert(1);
    },
    //sự kiện với các nút bấm trên thanh toolbar
    btnAdd_OnClick: function () {
        var me = this;
        basePopup.detailForm.dialog('open');
    },
    btnDuplicate_OnClick: function () {

    },
    btnEdit_OnClick: function () {

    },
    btnDelete_OnClick: function () {

    },
    btnRefresh_OnClick: function () {
        customerJS.reloadData();
    },

    /* -------------------------------------------------------------------
     * Nhấn button Cất thực hiện các validate và cất dữ liệu
     * Created by: vig (20/05/2018)
     */
    btnSave_OnClick: function (event) {
        var isValid = basePopup.validateData();
        if (isValid) {
            alert('OK');
        }
    },

    /* -------------------------------------------------------------------
     * Nhấn button Cất và thêm mới
     * Created by: vig (20/05/2018)
     */
    btnSaveAdd_OnClick: function (event) {
        alert('btnSaveAdd_OnClick');
    },

    btnCancel_OnClick: function (event) {
        basePopup.detailForm.dialog('close');
    },

    btnHelp_OnClick: function (event) {
        alert('btnHelp_OnClick');
    },

    /* -------------------------------------------------------------------
     * Validate các trường bắt buộc nhập khi blur
     * Created by: vig (20/05/2018)
     */
    inputValidateRequired_OnBlur: function (event) {
        basePopup.validateRequired(event.target);
    },

    /* -------------------------------------------------------------------
     * Thực hiện validate dữ liệu
     * Created by: vig (20/05/2018)
     */
    validateData: function () {
        var isValid = true,
            me = basePopup,
            formValidate = me.detailForm.hasClass('form-validate');
        if (formValidate) {
            var itemValidates = me.detailForm.find('.validate-required');
            itemValidates.each(function (index, item) {
                if (!me.validateRequired(item)) {
                    isValid = false;
                }
            })
        }
        return isValid;
    },

    /* -------------------------------------------------------------------
     * Thực hiện validate dữ liệu các trường bắt buộc nhập
     * Created by: vig (20/05/2018)
     */
    validateRequired: function (target) {
        var isValid = true;
        var value = $(target).val().trim();
        $(target.parentElement).removeClass('error-box');
        if (!value) {
            isValid = false;
            $(target.parentElement).addClass('error-box');
            $(target).addClass('border-red');
            $(target.parentElement).attr('title', 'Trường này không được để trống');
        } else {
            $(target.parentElement).removeClass('error-box');
            $(target).removeClass('border-red');
            $(target.parentElement).attr('title', '');
        }
        return isValid;
    }
}))