var serviceAjax = {
    getJson: function (uri, callback) {
        $.getJSON(uri)
            .done(function (data) {
                callback(data, true);
            });
    },
    get: function (uri, param, async, callback) {
        $.ajax({
            url: uri,
            dataType: 'json',
            async: async === undefined ? false : async,
            data: param,
            success: function (data) {
                callback({ Data: data, Success: true });
            }
        });
    },
    post: function (uri, param, async, callback) {
        $.ajax({
            url: uri,
            type: 'POST',
            data: param,
            contentType: 'application/json',
            async: async === undefined ? false : async,
            //dataType: 'application/json',
            success: function (result) {
                callback({ Data: result, Success: true });
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var exceptionMessage = JSON.parse(XMLHttpRequest.responseText).ExceptionMessage;
                if (callback) {
                    callback({ Data: XMLHttpRequest, Success: false });
                } else {
                    alert(exceptionMessage);
                }
            }
        });
    },
    postFile: function (uri, param, async, callback) {
        $.ajax({
            url: uri,
            type: 'POST',
            data: param,
            contentType: false,
            processData: false,
            async: async === undefined ? false : async,
            //dataType: 'application/json',
            success: function (result, b, c) {
                callback({ Data: result, Success: true });
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var exceptionMessage = JSON.parse(XMLHttpRequest.responseText).ExceptionMessage;
                if (callback) {
                    alert(textStatus);
                    callback({ Data: XMLHttpRequest, Success: false });
                } else {
                    alert(exceptionMessage);
                }
            }
        });
    },

    put: function (uri, param, async, callback) {
        $.ajax({
            url: uri,
            type: 'PUT',
            data: param,
            //dataType: 'application/json',
            async: async === undefined ? false : async,
            success: function (result) {
                callback({ Data: result, Success: true });
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var exceptionMessage = JSON.parse(XMLHttpRequest.responseText).ExceptionMessage;
                if (callback) {
                    callback({ Data: XMLHttpRequest, Success: false });
                } else {
                    alert(exceptionMessage);
                }
            }
        });
    },
    delete: function (uri, param, async, callback) {
        $.ajax({
            url: uri,
            type: 'DELETE',
            data: param,
            //dataType: 'application/json',
            async: async === undefined ? false : async,
            success: function (result) {
                callback({ Data: result, Success: true });
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var exceptionMessage = JSON.parse(XMLHttpRequest.responseText).ExceptionMessage;
                if (callback) {
                    callback({ Data: XMLHttpRequest, Success: false });
                } else {
                    alert(exceptionMessage);
                }
            }
        });
    }
};