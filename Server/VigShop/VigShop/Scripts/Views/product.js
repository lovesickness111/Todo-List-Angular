
var productJs = $.extend(base, Object.create({
    afterLoadForm: function (args) {
        var me = this;
        $.removeCookie('cookieCartData');
        me.loadData();
        // Khởi tạo form đăng ký:
        me.detailForm = $("#dialog-detailCustomer").dialog({
            autoOpen: false,
            //height: 250,
            width: 300,
            dialogClass: 'dialog-custome',
            modal: true,
            buttons: [
                {
                    text: "Thêm vào giỏ hàng",
                    "class": 'btn-custome btn-custome-primary',
                    "id": 'btnAddToCart',
                    html: '<span class="glyphicon glyphicon-plus"></span> Thêm vào giỏ hàng</a>',
                    click: function () {
                        me.btnAddToCart_OnClientClick();
                        $(window).lockscroll(false);
                    }
                },
                {
                    text: "Hủy",
                    "class": 'btn-custome btn-custome-cancel',
                    html: '<span class="glyphicon glyphicon-remove"></span> Hủy bỏ</a>',
                    "id": 'btnCancel',
                    click: function () {
                        me.detailForm.dialog("close");
                        $(window).lockscroll(false);
                    }
                }
            ],
            close: function () {
                me.formRegister[0].reset();
                $(window).lockscroll(false);
            }
        });

        me.formRegister = me.detailForm.find("form").on("submit", function (event) {
            event.preventDefault();
            me.register();
        });
    },

    /* --------------------------------------------------------------------------------
     * Load dữ liệu và hiển thị
     * vig (07/05/2018)
     */
    loadData: function () {
        var me = this, uri = '/api/product/sale';
        commonJS.showMask($('.productList'));
        serviceAjax.get(uri, {}, true, function (result) {
            if (result.Success) {
                sessionStorage.setItem('productStore', JSON.stringify(result.Data));
                if (result.Data.length > 0) {
                    var productsView = me.productsView,
                        productsSaleOffView = me.productsSaleOffView;
                    productsView.html('');
                    productsSaleOffView.html('');

                    var htmlPriceOrginalBox = '',
                        htmlHotSaleBox = '',
                        htmlHotSaleText = '';
                    // 0: Tên sản phẩm
                    // 1: Ảnh sản phẩm
                    // 2: Giá bán
                    // 3: Đơn vị tính
                    // 4: Giá gốc
                    // 5: Mô tả
                    // 6: Khuyến mại
                    // 7: Mã sản phẩm
                    var htmlTemplate =
                        '<div class="card mb-4 box-shadow">' +
                        '<div class="card-header card-header-custom">' +
                        '<h5 class="my-0 font-weight-normal">{0}</h5>' +
                        '</div>' +
                        '<img class="card-img-top img-customer" style="  display: block;" src="{1}" data-holder-rendered="true">' +
                        '<div class="card-body">' +
                        '<h4 class="card-title pricing-card-title"><span class="price-for-sale">{2}<small class="currency-text">đ</small></span> <small class="text-muted">/ {3}</small></h4>' +
                        '{4}' +
                        '<hr />' +
                        '<p class="card-text">{5}</p>' +
                        '<p><b>Bảo hành:</b> {6}</p>' +
                        '<div class="d-flex justify-content-between align-items-center">' +
                        '<div class="btn-group">' +
                        '<!--<button type="button" class="btn btn-sm btn-outline-secondary">View</button>' +
                        '<button type="button" class="btn btn-sm btn-outline-secondary">Edit</button>-->' +
                        '<button type="button" productId="{7}" productName="{0}" price="{2}" class="btn btn-md btn-block btn-primary btnSelectProduct"><span class="glyphicon glyphicon-shopping-cart"></span>  Chọn mua</button>' +
                        '</div>' +
                        '<small class="text-muted">86 người đã mua</small>' +
                        '</div>' +
                        '</div>' +
                        '{8}' + '<mark>{9}</mark>';
                    $.each(result.Data, function (key, item) {
                        if (item.SaleOffEventId) {
                            var pecentOff = (item.Price / item.PriceOrginal * 100).toFixed(0),
                                htmlHotSaleText = '<div class="sale-off-text">-{0}%</div>'.format(pecentOff);

                            htmlPriceOrginalBox = '<h6 class="card-title pricing-card-title">Giá gốc: <span class="price-orginal-not-sale">{0}<small class="currency-text">đ</small></span> <small class="text-muted">/ {1}</small></h6>'.format(item.PriceOrginal.formatMoney(), item.CalculationUnitName);
                            htmlHotSaleBox = '<div class="sale-off-box box-sale-animation"></div>';
                            $('<div>', {
                                html: htmlTemplate.format(item.ProductName, 'Content/images/products/Win10Pro.jpeg', item.Price.formatMoney(), item.CalculationUnitName, htmlPriceOrginalBox, item.Description, item.Warranty, item.Id, htmlHotSaleBox, htmlHotSaleText),
                                eventId: item.EventId,
                                class: "col-md-4"
                            }).appendTo(productsSaleOffView);
                        } else {
                            htmlPriceOrginalBox = '';
                            htmlHotSaleBox = '';
                            htmlHotSaleText = '';
                            $('<div>', {
                                html: htmlTemplate.format(item.ProductName, 'Content/images/products/Win10Pro.jpeg', item.Price.formatMoney(), item.CalculationUnitName, htmlPriceOrginalBox, item.Description, item.Warranty, item.Id, htmlHotSaleBox, htmlHotSaleText),
                                eventId: item.EventId,
                                class: "col-md-4"
                            }).appendTo(productsView);
                        }
                    });

                    $('.btnSelectProduct').unbind('click', productJs.btnSelectProduct_OnClientClick);
                    $('.btnSelectProduct').bind('click', productJs.btnSelectProduct_OnClientClick);
                }

            }
            commonJS.hideMask($('.productList'));
        });
    },

    /* --------------------------------------------------------------------------------
     * Hiển thị form chọn số lượng sản phẩm muốn mua khi nhấn phím chọn mua
     * vig (07/05/2018)
     */
    btnSelectProduct_OnClientClick: function () {
        var productId = $(this).attr('productId'),
            //productName = $(this).attr('productName'),
            //price = $(this).attr('price'),
            productSaleOffId = null,
            quanlity = 1;
        var productStore = JSON.parse(sessionStorage.getItem('productStore'));
        var currentProduct;

        // Gán số lượng mặc định là 1:
        $('#numProduct').val(quanlity);

        // Lấy thông tin chi tiết sản phẩm đã được lưu trữ trong sessonStoragr từ trước:
        productStore.some(function (item, index) {
            if (item.Id === productId) {
                currentProduct = item;
                return false;
            }
        });

        // Gán các giá trị vào các trường thông tin tương ứng (có thì gán giá trị, không thì gán trống giá trị):
        if (currentProduct) {
            $('#productDetail').text(currentProduct.ProductName);
            $('#productPriceDetail').text(currentProduct.Price.formatMoney());
            $('#productPriceDetail').attr('price', currentProduct.Price);
            $('#productTotalPriceDetail').text((currentProduct.Price * quanlity).formatMoney());

            // Lưu thông tin vào sessionStorage:
            $('#productDetail').attr('productId', productId);
            $('#productDetail').attr('productSaleOffId', currentProduct.ProductSaleOffId);

        } else {
            $('#productDetail').text('');
            $('#productPriceDetail').text('');
            $('#productTotalPriceDetail').text('');
        }

        // Bind Even Blur cho input nhập số lượng (tự động tính lại số tiền tương ứng với số lượng sản phẩm được chọn)
        $('#numProduct').unbind('blur', productJs.numProduct_OnBlur);
        $('#numProduct').bind('blur', productJs.numProduct_OnBlur);

        // Bind Even keypress cho input nhập số lượng (chỉ cho phép nhập số)
        $('#numProduct').unbind('keypress', commonJS.isNumberKey);
        $('#numProduct').bind('keypress', commonJS.isNumberKey);

        // Khóa thanh cuộn dọc:
        $(window).lockscroll(true);

        // Hiển thị form:
        productJs.frmAddProductToCart.dialog('open');
    },

    /* --------------------------------------------------------------------------------
     * Description: Thay đổi số lượng thì cập nhật lại tổng số tiền.
     * Author: vig (07/05/2018)
     */
    numProduct_OnBlur: function () {
        var numberProduct = this.value,
            price = $('#productPriceDetail').attr('price'),
            totalAmount = (price * (numberProduct ? numberProduct : 1));
        $('#productTotalPriceDetail').text(totalAmount.formatMoney());
        $('#productTotalPriceDetail').attr('total-amount', totalAmount);
    },

    /* --------------------------------------------------------------------------------
     * Description: Nhấn button thêm sản phẩm vào giỏ hàng (Xác nhận)
     * Author: vig (07/05/2018)
     */
    btnAddToCart_OnClientClick: function () {
        var quanlity = $('#numProduct').val(),
            totalAmount = $('#productTotalPriceDetail').attr('total-amount'),
            productId = $('#productDetail').attr('productId'),
            productSaleOffId = $('#productDetail').attr('productSaleOffId');
        if (quanlity) {
            // Build object Order:
            var orderDetail = {
                ProductId: productId,
                ProductSaleOffId: productSaleOffId,
                Quantity: parseFloat(quanlity),
                TotalAmount: parseFloat(totalAmount)
            };

            // Cập nhật giỏ hàng trong Cookie:
            productJs.updateCartDetail_OnClient(orderDetail);

            // Cập nhật giỏ hàng vào Session:
            productJs.updateCartDetail_OnServer(orderDetail);
        } else {
            alert('Số lượng sản phẩm phải lớn hơn 0.');
        }

    },

    /* --------------------------------------------------------------------------------
     * Description: Nhấn button thêm sản phẩm vào giỏ hàng (Xác nhận)
     * Author: vig (07/05/2018)
     */
    updateCartDetail_OnClient: function (orderDetail) {
        var cartData = $.cookie('cookieCartData'),
            cartInfo = {
                TotalQuantity: 0,
                TotalAmount:0
            };
        if (orderDetail) {
            if (cartData) {
                var cartDataDetail = JSON.parse(cartData),
                    itemExistsInCart = false;

                // Kiểm tra trong giỏ hàng đã mua sản phẩm này chưa? nếu mua rồi thì chỉ cập nhật lại số lượng và tổng giá tiền, chưa mua thì thêm mới vào Cart:
                cartDataDetail.some(function (item, index) {
                    if (item.ProductId === orderDetail.ProductId && item.ProductSaleOffId === orderDetail.ProductSaleOffId) {
                        item.Quantity += orderDetail.Quantity;
                        item.TotalAmount += orderDetail.TotalAmount;
                        itemExistsInCart = true;
                        return false;
                    }
                });
                if (!itemExistsInCart) {
                    cartDataDetail.push(orderDetail);
                }

                // Tính lại tổng số lượng sản phẩm đã mua + tổng tiền để hiển thị lên Cart
                cartDataDetail.forEach(function (item) {
                    cartInfo['TotalQuantity'] += item.Quantity;
                    cartInfo['TotalAmount'] += item.TotalAmount;
                })

                // Lưu thông tin vào Cookie:
                $.cookie('cookieCartData', JSON.stringify(cartDataDetail), { expires: 1 });
            } else {
                $.cookie('cookieCartData', JSON.stringify([orderDetail]), { expires: 1 });
                cartInfo['TotalQuantity'] += orderDetail.Quantity;
                cartInfo['TotalAmount'] += orderDetail.TotalAmount;
            }

            // Hiển thị thông tin trên trình duyệt:
            $('.quanlity-cart').text('({0})'.format(cartInfo['TotalQuantity']));
            $('#pay-total').text(cartInfo['TotalAmount'].formatMoney());
            $('#cart-detail').removeAttr('hidden');
            $('#cart-detail').show();
        }
        productJs.frmAddProductToCart.dialog('close');
    },

    /* --------------------------------------------------------------------------------
     * Description: Cập nhật lại thông tin giỏ hàng phía Server:
     * Author: vig (07/05/2018)
     */
    updateCartDetail_OnServer: function () {

    }
}));
