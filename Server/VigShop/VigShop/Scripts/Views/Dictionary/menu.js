$(document).ready(function () {
    var window_tbody_height = $('.frmFoodList').height();
    var window_tr_width = $('#table-tbody tr').width();
    $('#table-tbody').height(window_tbody_height - $('#table-thead').height());
    $('#table-tbody').width(window_tr_width);
    $('.cls-gridPanel').height(window_tbody_height - 30);
    $(window).resize(menuJS.resizeWindow);
    $("#table-tbody tr").click(function () {
        $('#table-tbody').find('.rowSelected').removeClass('rowSelected');
        $(this).addClass("rowSelected");
    });
    //mở dialog

    $('#btnAdd').on('click', menuJS.openAddDialog);
    $('#btnEdit').on('click', menuJS.openEditDialog);

    //đổ dữ liệu ra bảng
    //var uri = "/api/Product";

    //$.getJSON(uri).done(function (data) {
    //    $.each(data, function (key, item) {
    //        $('#table-tbody tbody').append("<tr>" +
    //            '<td class= "th-food-name width-200" >' + item.productName + '</td >' +
    //            '<td class="th-food-code width-150">' + item.productCode + '</td>' +
    //            '<td class="th-food-group width-150">' + item.productType + '</td>' +
    //            '<td class="th-food-price width-150">' + item.productPrice + '</td>' +
    //            '<td class="th-food-quantity width-150">' + item.productSize + '</td>' +
    //            '<td class="th-food-notify width-150">' + item.productDescription + '</td>' +
    //            +"</tr>");
    //    });
    //});
});
var menuJS = Object.create({
    resizeWindow: function () {
        var window_tbody_height = $('.frmFoodList').height();
        var window_tr_width = $('#table-tbody tr').width();
        $('#table-tbody').height(window_tbody_height - $('#table-thead').height());
        $('#table-tbody').width(window_tr_width);
        $('.cls-gridPanel').height(window_tbody_height - 30);
    },
    openAddDialog: function (name) {
        $('#add-new-product').dialog({

            dialogClass: "show-dialog",
            resizable: false,
            closeOnEscape: true,
            close: function (event, ui) {
                $(this).dialog('destroy');
            },
            beforeClose: menuJS.beforeCloseDialog,
        });
        
    },
    openEditDialog: function () {
        $('#edit-product').dialog({
            width: 350,
            closeOnEscape: true,
            resizable: false,
            dialogClass: "show-dialog",
            close: function (event, ui) {
                $(this).dialog('destroy');
            },
            beforeClose: menuJS.beforeCloseDialog,
        });

    },
    beforeCloseDialog: function () {


    }

});
