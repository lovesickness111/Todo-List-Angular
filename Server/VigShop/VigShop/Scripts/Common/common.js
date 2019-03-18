$(document).ready(function () {
    
});
//những hàm js được sử dụng cho mọi trang
var commonJS = {
    //hàm showMask hiện biểu tượng loading
    showMask: function (sender) {
        if (sender) {
            sender.addClass('loading');
        } else {
            $('html').addClass('loading');
        }
    },
    //load xong thì ẩn 
    hideMask: function (sender) {
        if (sender) {
            sender.removeClass('loading');
        } else {
            $('html').removeClass('loading');
        }
    },
    /* -----------------------------------------
     * Hiển thị hộp thoại cảnh báo
      
     */
    showWarning: function (msg) {

    },
    /* -----------------------------------------
     * Hiển thị hộp thoại xác nhận xóa dữ liệu
      msg hỏi muốn xóa gì? confirmCallBack là 1 hàm
     */
    showConfirm: function (msg, confirmCallBack) {
        var html = '<div class="question-content"><div class="question-icon"></div>'+msg+'</div>' +
            '<div class="dialog-message-bottom-toolbar">' +
            '<button id="btnConfirm">Đồng ý</button>' +
            '<button id="btnCancel">Hủy bỏ</button>' +
            '</div>';
        $('#dialog-message').html(html);
        $(function () {
            $("#dialog-message").dialog({
                modal: true,
                resizable: false,
                class: "bottom-dialogmessage",
                width: 350,
            });

            // không hiểu
            confirmCallBack = (function () {
                var cached_function = confirmCallBack;
                return function () {
                    $('#dialog-message').dialog("close")
                    var result = cached_function.apply(this, arguments); // use .apply() to call it
                    return result;
                };
            })();
            //Gán Even cho các Button:
            //confirm thì đóng cả 2 dialog
            $('.dialog-message-bottom-toolbar #btnConfirm').click(confirmCallBack);
            $('.dialog-message-bottom-toolbar #btnCancel').click(function () { $('#dialog-message').dialog("close") });
        });
    },

    /* -----------------------------------------
     * Hiển thị hộp thoại thông báo thành công
      
     */
    showSuccessMsg: function () {
        $('body').append('<div class="msg-success" style="display:none">Thành công</div>');
        $('.msg-success').slideDown(1000);
        setTimeout(function () {
            $('.msg-success').slideUp(1000);
        }, 3000);
    },
    //chuẩn hóa khi nhập
    change_alias: function (alias) {
        var str = alias;
        str = str.toLowerCase();
        str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
        str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
        str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
        str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
        str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
        str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
        str = str.replace(/đ/g, "d");
        str = str.replace(/!|@|%|\^|\*|\(|\)|\+|\=|\<|\>|\?|\/|,|\.|\:|\;|\'|\"|\&|\#|\[|\]|~|\$|_|`|-|{|}|\||\\/g, " ");
        str = str.replace(/ + /g, " ");
        str = str.trim();
        return str;
    },
    rowTable_OnClick: function () {
        $('table tr').removeClass('rowSelected');
        this.classList.add('rowSelected');
    },
    /* --------------------------------------------
     * Select vào dòng đầu tiên trong bảng dữ liệu
      
     */
    setFirstRowSelected: function (table) {
        var tBodys = table[0].tBodies,
            firstRow = null;
        if (tBodys.length > 0) {
            var tBody = tBodys[0],
                rows = tBody.rows;
            firstRow = rows.length > 0 ? rows[0] : null;
        }
        if (firstRow) {
            firstRow.classList.add('rowSelected');
        }
    },

    /* -------------------------------------------------------------------------------
     * Hiển thị cảnh báo khi validate dữ liệu trống (các trường yêu cầu bắt buộc nhập)
      
     */
    validateEmpty: function (sender) {
        var target = sender.target,
            idEmpty = target.id + '-empty';
        value = target.value,
            parent = $(this).parent(),
            currentThisWith = $(this).width();

        if (!value || value === '') {
            target.classList.add('validate-error');
            if (parent.find('.divError').length === 0) {
                parent.append('<div id="' + idEmpty + '" class="divError" title="Không được để trống trường này"></div>');
            }
        } else {
            target.classList.remove('validate-error');
            target.title = "";
            $('#' + idEmpty).remove();
        }
    },

    /* -------------------------------------------------------------------------------
     * Chỉ cho phép nhập các ký tự số
      
     */
    isNumberKey: function (evt) {
        var charCode = (evt.which) ? evt.which : event.keyCode;
        if (charCode === 59 || charCode === 46)
            return true;
        if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;
        return true;
    }
}
var initCommon = {
    intMessageBoxClass: function () {

    },
}

if (!String.prototype.format) {
    String.prototype.format = function () {
        var args = arguments;
        return this.replace(/{(\d+)}/g, function (match, number) {
            return typeof args[number] !== 'undefined'
                ? args[number]
                : match
                ;
        });
    };
}

/* Định dạng hiển thị tiền tệ */
if (!Number.prototype.formatMoney) {
    Number.prototype.formatMoney = function () {
        return this.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
    };
}

/* So sánh 2 object */
if (!Object.compare) {
    Object.compare = function (obj1, obj2) {
        var isDifferent = false;
        for (var property in obj1) {
            if (obj1[property] !== obj2[property]) {
                isDifferent = true;
                break;
            };
        }
        return isDifferent;
    }
}
/* Định dạng ngày tháng năm */
if (!Date.prototype.ddmmyyyy) {
    Date.prototype.ddmmyyyy = function () {
        var mm = this.getMonth() + 1; // getMonth() is zero-based
        var dd = this.getDate();

        return [(dd > 9 ? '' : '0') + dd + '/',
        (mm > 9 ? '' : '0') + mm + '/',
        this.getFullYear()
        ].join('');
    };
}


