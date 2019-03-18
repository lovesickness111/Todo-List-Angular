$(document).ready(function () {

    $('#btnAdd').on('click', groupJS.addNewGroup);
    $('#btnEdit').on('click', groupJS.getDataByID);
    $('#btnDelete').on('click', groupJS.deleteGroup);
    $('#btnDuplicate').on('click', groupJS.duplicateGroup);
    $('.cancel-delete').click(groupJS.closeDialog);
    //Thay đổi số bản ghi trong một bảng
    $("#show-column-menu").click(groupJS.showColumnNumber);
    $(".number-column-menu li").click(groupJS.changePageNumber);
    $("#choose-img-button").click(function () {
        var input = $(this).prev();
        readURL(input);
    });



    groupJS.loadData();
});
var groupJS = Object.create({
    ///lấy dữ liệu mã các nhóm thực đơn
    getDataGroup: function () {
        var groupCodes = [];
        $.ajax({
            url: "/api/group/getall",
            type: "get",
            dataType: "json",
            async: false,
            contentType: "application/json;charset=utf-8",
            success: function (data) {
                //groupJS.addNewGroup(data)
                $.each(data, function (index, val) {
                    var groupCode = val.groupCode;
                    groupCodes.push(groupCode);
                });
            }
        });
        return groupCodes;

    },
    //lấy dữ liệu theo id
    getDataByID: function () {
        var currentRow = $("#group-table-tbody .rowSelected");
        var menuGroupID = $(currentRow).attr("trid");
        $.ajax({
            url: "/api/group/GetMenuGroupByID?groupID=" + menuGroupID,
            type: "get",
            dataType: "json",
            async: false,
            contentType: "application/json;charset=utf-8",
            error: function (request, message, error) { console.log(request + " ----------- " + message + "  ----  " + error); },
            success: function (data) {
                groupJS.editGroup(data);
            }
        })
    },
    loadData: function () {
        $("#group-table-tbody tbody").html("");
        var filters = [];
        //tạo mảng đổi tượng các filter dạng text
        var inputFilters = $(".x-filter-text");
        $.each(inputFilters, function (index, inputFilter) {
            var fieldValue = $(inputFilter).val().trim();
            var fieldName = $(inputFilter).attr('filter');
            var fieldType = $(inputFilter).attr("fieldtype");
            //var inputType = 'string';
            if (fieldValue !== '') {
                var filter = {
                    FieldName: fieldName,
                    Type: fieldType,
                    //DataType: inputType,
                    Value: fieldValue
                };
                filters.push(filter);
            }
        });
        //filter có dạng lựa chọn có hoặc không( vd ngừng theo dõi)
        var inputFiltersYesNo = $(".focus-yes-no-filter");
        $.each(inputFiltersYesNo, function (index, inputFilterYesNo) {
            //var fieldValue = $(inputFilterYesNo).attr("fieldvalue");
            var fieldValue;

            var fieldName = $(inputFilterYesNo).attr("filter");
            var fieldType = $(inputFilterYesNo).attr("fieldtype");
            //var inputType = 'bit';
            if (fieldValue !== '' && fieldValue !== undefined) {
                var filter = {
                    FieldName: fieldName,
                    Type: fieldType,
                    //DataType: inputType,
                    Value: fieldValue
                };
                filters.push(filter);
            }
        });

        //filter dựa theo dữ liệu số
        //var inputFiltersNumber = $(".x-input-filter-number");
        //$.each(inputFiltersNumber, function (index, inputFilterNumber) {
        //    var fieldValue = $(inputFilterNumber).val().trim();
        //    var fieldName = $(inputFilterNumber).attr("filter");
        //    var fieldType = $(inputFilterNumber).attr("fieldtype");
        //    var inputType = 'decimal';
        //    if (fieldValue !== '' && fieldValue !== undefined) {
        //        var filter = {
        //            Field: fieldName,
        //            Type: fieldType,
        //            DataType: inputType,
        //            Value: fieldValue,
        //        }
        //        filters.push(filter);
        //    }
        //})
        var currentPage = parseInt($("#paging-index").val());
        var pageSize = parseInt($("#column-menu").val());

        $.ajax({
            url: '/api/group/postMenuGroupPaging?currentPage=' + currentPage + '&pageSize=' + pageSize,
            type: 'POST',
            data: JSON.stringify(filters),
            error: function (request, message, error) { console.log(request + " ----------- " + message + "  ----  " + error); },
            contentType: "application/json;charset=utf-8",
            async: true,
            dataType: "json",
            success: function (data) {
                $.each(data.Entities, function (index, val) {
                    var checkUnfollow = false;
                    var trid = val.groupID;
                    var htmlRowTblListMenu = '<tr trid="' + trid + '">' +
                        '<td class="td-group-type width-150" >' + val.typeName + '</td >' +
                        '<td class="td-group-code width-150">' + val.groupCode + '</td>' +
                        '<td class="td-group-name width-400">' + val.groupName + '</td>' +
                        '<td class="td-group-descrption width-400">' + val.groupDescription + '</td>' +
                        '<td class="td-group-unfollow width-150">' +
                        '<input type="checkbox" disabled></td>' +
                        '</tr>';
                    $(htmlRowTblListMenu).appendTo($('#group-table-tbody tbody'));
                    checkUnfollow = val.groupUnfollow;
                    checkUnfollow === false ? $('tr[trid="' + trid + '"] .td-group-unfollow input').attr('checked', false) : $('tr[trid="' + trid + '"] .td-group-unfollow input').attr('checked', true);

                });
                commonJS.setFirstRowSelected($('#group-table-tbody'));
                $('#group-table-tbody tbody').on('click', 'tr', commonJS.rowTable_OnClick);
            }
        });
    },
    //Thay đổi số bản ghi trong một bảng
    showColumnNumber: function () {
        $(".number-column").toggle();
    },
    //Add Số bản ghi của một trang
    changePageNumber: function () {
        var value = $(this).text().trim();
        $(".number-column").hide();
        $("#column-menu").val(value);
        $("#paging-index").val("1");
        $(".x-btnPageLast").removeClass("disable-button");
        $(".x-btnPageNext").removeClass("disable-button");
        $(".x-btnPageFirst").addClass("disable-button");
        $(".x-btnPagePrev").addClass("disable-button");
        $(Database.getFoodsPaging(1, value));
    },
    closeDialog: function () {
        $(this).closest('.ui-dialog-content').dialog('destroy');
    },
    addNewGroup: function () {
        $('#add-new-group').dialog({
            width: 450,
            dialogClass: "show-dialog",
            resizable: false,
            modal: true,
            closeOnEscape: true,
            close: function (event, ui) {
                $(this).dialog('destroy');
            },
            beforeClose: menuJS.beforeCloseDialog
        });
        ////-----bắt sự kiện cho các nút bấm trong dialog
        $('#add-new-group .save-new-group').click(groupJS.postDataMenuGroup);
    },
    postDataMenuGroup: function (sender) {
        var parent = this.closest(".main-content-dialog");
        //lấy giá trị từ input
        var groupCode = $(parent).find('.inputGroupCode').val().toUpperCase();
        //kiểm tra xem trong db đã có nhóm vừa nhập chưa
        var groupCodes = groupJS.getDataGroup();
        for (var i = 0; i < groupCodes.length; i++) {
            if (groupCode === groupCodes[i].trim()) {
                alert(groupCode + "  Đã tồn tại!");
                return;
            }
        }
        var groupName = $(parent).find('.inputGroupName').val();
        var typeID = $(parent).find('.inputGroupType').val();
        var restaurantID = $(parent).find('.inputGroupRestaurant').val();
        var groupDescription = $(parent).find('.inputGroupDescription').val();
        var dataMenuGroup = { groupCode, groupName, typeID, restaurantID, groupDescription};
        //gọi api
        $.ajax({
                url: "/api/group/InsertGroup",
                type: 'POST',
            data: JSON.stringify(dataMenuGroup),
            error: function (request, message, error) { console.log(request + " ----------- " + message + "  ----  " + error); },
            contentType: "application/json;charset=utf-8",
            async: true,
            dataType: "json",
            success: function () {
                $(".ui-dialog-content").dialog("destroy");

                groupJS.loadData();
            }
        });

    },
    duplicateGroup:function(){
        $("#replicate-group").dialog({
            width: 900,
            dialogClass: "show-dialog",
            resizable: false,
            modal: true,
            closeOnEscape: true,
            close: function (event, ui) {
                $(this).dialog('destroy');
            },
            beforeClose: menuJS.beforeCloseDialog
        })
    },
    editGroup: function (data) {
        $('#edit-group').dialog({
            width: 450,
            dialogClass: "show-dialog",
            resizable: false,
            modal: true,
            closeOnEscape: true,
            close: function (event, ui) {
                $(this).dialog('destroy');
            },
            beforeClose: menuJS.beforeCloseDialog
        });
        var dataRecived = data[0];
        //lấy dữ liệu đổ ra form sửa
        var menuGroupEntity = {
            groupID: '',
            groupCode: '',
            groupName: '',
            groupDescription: '',
            typeID: '',
            typeName: '',
            restaurantID: '',
            restaurantName: '',
            groupUnfollow: '',
        }
        menuGroupEntity.groupID = dataRecived.groupID;
        menuGroupEntity.groupCode = dataRecived.groupCode;
        menuGroupEntity.groupName = dataRecived.groupName;
        menuGroupEntity.groupDescription = dataRecived.groupDescription;
        menuGroupEntity.typeID = dataRecived.typeID;
        menuGroupEntity.typeName = dataRecived.typeName;
        menuGroupEntity.restaurantID = dataRecived.restaurantID;
        menuGroupEntity.restaurantName = dataRecived.restaurantName;
        menuGroupEntity.groupUnfollow = dataRecived.groupUnfollow;
        //đổ dữ liệu
        $("#edit-group .editGroupCode").val((menuGroupEntity.groupCode).trim());
        $("#edit-group .editGroupName").val(menuGroupEntity.groupName);
        $("#edit-group .editGroupType").val(menuGroupEntity.typeID);
        $("#edit-group .editGroupRestaurant").val(menuGroupEntity.restaurantID);
        $("#edit-group .editDescription").val(menuGroupEntity.groupDescription);
        $("#edit-group #editUnfollowGroup").val(menuGroupEntity.groupUnfollow);
        menuGroupEntity.groupUnfollow === false ? $("#edit-group #editUnfollowGroup").prop('checked', false) : $("#edit-group #editUnfollowGroup").prop('checked', true);
        //bắt sự kiện khi nhấn nút lưu
        $('#edit-group .updateMenuGroup').click(groupJS.putDataMeuGroup);
    },
    putDataMeuGroup: function () {
        var parent = this.closest("#edit-group ");
        //lấy giá trị từ input
        var groupID = $("#group-table-tbody .rowSelected").attr("trid");
        var groupCode = $(parent).find('.editGroupCode').val().toUpperCase();
        var groupName = $(parent).find('.editGroupName').val();
        var typeID = $(parent).find('.editGroupType').val();
        var restaurantID = $(parent).find('.editGroupRestaurant').val();
        var groupDescription = $(parent).find('.editDescription').val();
        var groupUnfollow = $(parent).find('#editUnfollowGroup').prop("checked");
        var dataMenuGroup = {groupID, groupCode, groupName, typeID, restaurantID, groupDescription, groupUnfollow};
        //gọi api
        $.ajax({
            url: "/api/group/updateMenuGroup",
            type: 'put',
            data: JSON.stringify(dataMenuGroup),
            error: function (request, message, error) { console.log(request + " ----------- " + message + "  ----  " + error); },
            contentType: "application/json;charset=utf-8",
            async: false,
            dataType: "json",
            success: function () {
                $(".ui-dialog-content").dialog("destroy");

                groupJS.loadData();
                $('#edit-group .updateMenuGroup').unbind("click");
            }
        });
    },
    deleteGroup: function () {
        $('#delete-group').dialog({
            width: 450,
            dialogClass: "show-dialog",
            resizable: false,
            modal: true,
            closeOnEscape: true,
            close: function (event, ui) {
                $(this).dialog('destroy');
            },
            beforeClose: menuJS.beforeCloseDialog
        });
        $("#delete-group").on('click', '.cancel-delete', function () { $('.ui-dialog-content').dialog("destroy") })
        $("#delete-group").on('click', '#submitDeleteGroup', groupJS.deleteDataMenuGroup)
    },
    //xác nhận xóa
    deleteDataMenuGroup: function () {
        var currentRow = $("#group-table-tbody .rowSelected");
        var groupID = $(currentRow).attr("trid");
        $.ajax({
            url: "/api/group/deleteMenuGroup?menuGroupID=" + groupID,
            type: 'DELETE',
            error: function (request, message, error) { console.log(request + " ----------- " + message + "  ----  " + error); },
            contentType: "application/json;charset=utf-8",
            async: true,
            dataType: "json",
            success: function () {
                $(".ui-dialog-content").dialog("destroy");

                location.reload();
            }
        });
    }
});

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#duplicate-groupmenu-image')
                .attr('src', e.target.result)
                .width(150)
                .height(200);
        };

        reader.readAsDataURL(input.files[0]);
    }
}