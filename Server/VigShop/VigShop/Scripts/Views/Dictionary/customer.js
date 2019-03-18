$(document).ready(function () {
    $('.btn-select-filter').click(customerJS.btnSelectFilter_OnClick);
    $(document).mouseup(customerJS.document_onMouseUp);
    $('#box-triggerWrap').click(customerJS.showNumberRecordSelection);
    $('#numberRecordSelection .record-select-item').click(customerJS.boundListItem_OnClick);
    $('#tbarRefresh').click(customerJS.reloadData);
    $('#btnAdd').click(customerJS.btnAdd_OnClick);
    $('#btnDuplicate').click(customerJS.btnDuplicate_OnClick);
    $('#btnEdit').click(customerJS.btnEdit_OnClick);
    $('#btnDelete').click(customerJS.btnDelete_OnClick);
    $('#btnRefresh').click(customerJS.btnRefresh_OnClick);

});

/**
 * Đối tượng JS lưu trữ toàn bộ các field, function cho trang Customer:
 */
var customerJS = $.extend(basePopup, Object.create({
    //mở dialog chi chiết khách hàng
    initDetailForm: function () {
        var me = this;
        me.detailForm = $("#dialog-detailCustomer").dialog({
            autoOpen: false,
            //height: 250,
            width: 680,
            dialogClass: 'form-customerDetail',
            modal: true,
            buttons: [
                {
                    width: "75px",
                    "class": 'btn-customer',
                    html: '<div class="btn-customer-16-body"><div class="btn-customer-icon-16 btn-customer-save-icon"></div><div class="btn-customer-text">Cất</div></div>',
                    "id": 'btnSave',
                    click: me.btnSave_OnClick,
                },
                {
                    width: "120px",
                    "class": 'btn-customer',
                    html: '<div class="btn-customer-16-body"><div class="btn-customer-icon-16 btn-customer-saveadd-icon"></div><div class="btn-customer-text">Cất và thêm</div></div>',
                    "id": 'btnSaveAdd',
                    click: me.btnSaveAdd_OnClick,
                },
                {
                    width: "75px",
                    "class": 'btn-customer',
                    html: '<div class="btn-customer-16-body"><div class="btn-customer-icon-16 btn-customer-cancel-icon"></div><div class="btn-customer-text">Hủy bỏ</div></div>',
                    "id": 'btnCancel',
                    click: me.btnCancel_OnClick,
                },
                {
                    width: "75px",
                    "class": 'btn-customer btnHelp',
                    html: '<div class="btn-customer-16-body"><div class="btn-customer-icon-16 btn-customer-help-icon"></div><div class="btn-customer-text">Giúp</div></div>',
                    "id": 'btnHelp',
                    click: me.btnHelp_OnClick,
                },

            ],
            close: function () {
                //me.formRegister[0].reset();
                //$(window).lockscroll(false);
            },
            //open: customerJS.loadGroupCustomerDataForCombobox,
            create: customerJS.frmCustomerDetail_OnCreate,//bind dữ liệu ra combobox
            beforeClose: customerJS.beforeCloseDialog,//xác nhận thoát dialog
        });
        me.groupCustomerForm = $("#dialog-GroupCustomer").dialog({
            autoOpen: false,
            //height: 250,
            width: 450,
            dialogClass: 'form-customerDetail',
            modal: true,
            buttons: [

                {
                    width: "75px",
                    "class": 'btn-customer',
                    html: '<div class="btn-customer-16-body"><div class="btn-customer-icon-16 btn-customer-save-icon"></div><div class="btn-customer-text">Cất</div></div>',
                    "id": 'btnSaveGroupCustomer',
                    click: me.btnSaveGroupCustomer_OnClick,
                },

                {
                    width: "75px",
                    "class": 'btn-customer',
                    html: '<div class="btn-customer-16-body"><div class="btn-customer-icon-16 btn-customer-cancel-icon"></div><div class="btn-customer-text">Hủy bỏ</div></div>',
                    "id": 'btnCancelGroupCustomer',
                    click: me.btnCancelGroupCustomer_OnClick,
                },
                {
                    width: "75px",
                    "class": 'btn-customer btnHelp',
                    html: '<div class="btn-customer-16-body"><div class="btn-customer-icon-16 btn-customer-help-icon"></div><div class="btn-customer-text">Giúp</div></div>',
                    "id": 'btnHelpGroupCustomer',
                    click: me.btnHelpGroupCustomer_OnClick,
                },

            ],
            close: function () {
                //me.formRegister[0].reset();
                //$(window).lockscroll(false);
            },
            create: customerJS.frmCustomerGroup_OnCreate,
            beforeClose: customerJS.beforeCloseDialog,
        }),
        me.formRegister = me.detailForm.find("form").on("submit", function (event) {
            event.preventDefault();
            me.register();
        });
    },

    loadData: function () {
        this.detailForm.dialog('open');
    },
    reloadData: function () {
        commonJS.showMask($('.frmCustomerList'));
        setTimeout(function () {
            commonJS.hideMask($('.frmCustomerList'));
        }, 2000)
    },

    btnRefresh_OnClick: function () {
        customerJS.reloadData();
    },

    /* --------------------------------------------------------------------------------------
     * Khi nhấn button chọn điều kiện Filter thì hiển thị Sub Menu cho phép lựa chọn điều kiện
     * Author: vig (14/05/2018)
     */
    btnSelectFilter_OnClick: function (sender) {

        // Xóa toàn bộ các element của SubMenu Filter khác nếu có:
        $('.clause-filter-selection').remove();

        // Set cho button hiện tại ở trạng thái đang được active để phục vụ bind value sẽ lựa chọn từ các item filter:
        $('#tblCustomerList .btn-select-filter').removeClass('btn-select-filter-active');
        this.classList.add('btn-select-filter-active');
        var filterValue = $(this).attr('filter-value');
        if (!filterValue) {
            filterValue = "∗";
        }

        // Khai báo chuỗi html của SubMenu Filter:
        var htmlFilter =
            $('<div class="clause-filter-selection">' +
                '<a class="filter-menu-item menu-item-text" filter-value="∗">∗ : Chứa</a >' +
                '<a class="filter-menu-item menu-item-text" filter-value="=">= : Bằng</a>' +
                '<a class="filter-menu-item menu-item-text" filter-value="+">+ : Bắt đầu bằng</a>' +
                '<a class="filter-menu-item menu-item-text" filter-value="-">- : Kết thúc bằng</a>' +
                '<a class="filter-menu-item menu-item-text" filter-value="!">! : Không chứa</a>' +
                '</div>');

        // Tìm xem item nào sẽ set trạng thái active dựa vào attribute tự định nghĩa:
        filterForActiveElement = htmlFilter.find('[filter-value="{0}"]'.format(filterValue));
        filterForActiveElement.addClass('selectedIconFilterType');

        // append vào box ngang cấp:
        $(this.parentElement).append(htmlFilter);

        // unbind mọi even click của các item đã có và thực hiện bind even lại (để đảm bảo even chỉ được thực hiện 1 lần duy nhất):
        $('.filter-menu-item').unbind('click', customerJS.filterItem_OnClick);
        $('.filter-menu-item').bind('click', customerJS.filterItem_OnClick);
    },

    /* ---------------------------------------------------------------------------------------------
     * Chọn điều kiện Filter thì thực hiện lưu lại giá trị vừa chọn rồi ẩn SubMenu chọn điều kiện đi
     * Author: vig (14/05/2018)
     */
    filterItem_OnClick: function (sender) {
        $(this.parentElement).find('.selectedIconFilterType').removeClass('selectedIconFilterType');
        this.classList.add('selectedIconFilterType');
        filterValue = $(this).attr('filter-value');
        $('#tblCustomerList .btn-select-filter-active').text(filterValue);
        $('#tblCustomerList .btn-select-filter-active').attr('filter-value', filterValue);
        $(".clause-filter-selection").remove();
        $('.btn-select-filter-active').removeClass('btn-select-filter-active');
    },

    /* ---------------------------------------------------------------------------------------------
     * Nhấn chuột vào các vùng không phải là button ẩn hiện các element thì thực hiện ẩn toàn bộ các element đó đi
     * Author: vig (14/05/2018)
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

    /* ---------------------------------------------------------------------------------------------
     * Ẩn hiện lựa chọn số lượng bản ghi hiển thị trong 1 trang
     * Author: vig (14/05/2018)
     */
    showNumberRecordSelection: function (sender) {
        var boxRecordList = $('#numberRecordSelection');
        // Lấy số lượng bản ghi hiện tại:
        var numberRecoerd = $('#inputTotalRecord').val();

        // Không có set mặc định là 0:
        if (!numberRecoerd) {
            numberRecoerd = 0;
        }

        // Tìm đúng thằng có giá trị tương ứng để Set style:
        var boxSetSelected = boxRecordList.find('[item-value="{0}"]'.format(numberRecoerd));
        if (boxSetSelected) {
            $('#numberRecordSelection .record-item-selected').removeClass('record-item-selected');
            boxSetSelected.addClass('record-item-selected');
        }

        // Đang ẩn thì hiện mà đang hiện thì ẩn :):
        $('#numberRecordSelection').toggle();
    },

    /* ---------------------------------------------------------------------------------------------
     * Lựa chọn số lượng bản ghi hiển thị trong 1 trang
     * Author: vig (14/05/2018)
     */
    boundListItem_OnClick: function (sender) {
        var value = this.getAttribute('item-value');
        $('#inputTotalRecord').val(value);
        $('#numberRecordSelection').hide();
        sender.stopPropagation();
        customerJS.reloadData();
    },

    frmCustomerDetail_OnCreate: function () {
        var me = customerJS;
        debugger;
        me.loadGroupCustomerDataForCombobox($('#cbxCustomerGroup .combobox-data'));
        $('#btnAddCustomerGroup').unbind('click', me.btnAddCustomerGroup_OnClick);
        $('#btnAddCustomerGroup').bind('click', me.btnAddCustomerGroup_OnClick);
    },

    btnAddCustomerGroup_OnClick: function () {
        var me = customerJS;
        me.frmGroupCustomer.dialog('open'); 
    },
    /* ---------------------------------------------------------------------------------------------
     * Load dữ liệu cho combobox
     * Author: vig (14/05/2018)
     */
    loadGroupCustomerDataForCombobox: function (sender) {
        var me = this;
        $(sender).find('.combobox-data-item').remove();
        // Lấy dữ liệu:
        var customerGroups = [
            { CustomerGroupID: 1, CustomerGroupName: 'Khách VIP' },
            { CustomerGroupID: 2, CustomerGroupName: 'Khách thường' },
            { CustomerGroupID: 3, CustomerGroupName: 'Khách tiềm năng' },
            { CustomerGroupID: 4, CustomerGroupName: 'Khách vãng lai' },
            { CustomerGroupID: 5, CustomerGroupName: 'Khác' },
        ]
        // Build html:
        var htmlItemTemplate = '<div class="combobox-data-item" item-value="{0}">{1}</div>';
        //$('#cbxCustomerGroup ').append('<div class="combobox-data"></div>');
        customerGroups.forEach(function (item) {
            var htmlItem = htmlItemTemplate.format(item.CustomerGroupID, item.CustomerGroupName);
            $('body #comboboxData').append(htmlItem);
        });
        $('.combobox-data-item').click(customerJS.comboboxDataItem_OnSelect);
    },

    comboboxDataItem_OnSelect: function (event) {
        debugger;
        var customerGroupSelected = {
            CustomerGroupId: $(this).attr('item-value'),
            CustomerGroupName: $(this).text(),
        }
        $('#txtCustomerGroup').val(customerGroupSelected.CustomerGroupName);
        $('#txtCustomerGroup').attr('item-value', customerGroupSelected.CustomerGroupId);
        $('.combobox[controlType="ComboboxData"] input').focus();
    },

    /* ---------------------------------------------------------------------------------------------
     * Trước khi đóng form thì reset toàn bộ các giá trị đã chọn về NULL
     * Author: vig (14/05/2018)
     */
    beforeCloseDialog: function () {
        $('#dialog-detailCustomer').find('[dataIndex]').val(null);
    },

    frmCustomerGroup_OnCreate: function (sender,e) {
        var me = customerJS;
        me.loadGroupCustomerDataForCombobox($('#cbxCustomerGroupParent .combobox-data'));
    }
})
);

// Đây là Even thực hiện việc cho phép thay đổi width các cột trong table (sử dụng thư viện của jQuery UI):
$(function () {
    var thHeight = $("table#tblCustomerList th:first").height();
    $("table#tblCustomerList th").resizable({
        handles: "e",
        minHeight: thHeight,
        maxHeight: thHeight,
        minWidth: 40,
        resize: function (event, ui) {
            var sizerID = "#" + $(event.target).attr("id") + "-sizer";
            $(sizerID).width(ui.size.width);
        }
    });
});

