var template = Object.create({
    productSingler: '<div class="card mb-4 box-shadow">' +
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
                    '{8}' + '<mark>{9}</mark>',
})