//khởi tạo các object
var base = Object.create({
    init: function () {
        var me = this,
            args = arguments;
        //khởi tạo mảng các key của object
        for (var i = 0; i < args.length; i++) {
            if (typeof args[i] === 'object') {
                var keys = Object.keys(args[0]);
                keys.forEach(function (key) {
                    me[key] = args[i][key];
                });
            }
        }
        me.initForm(args);
        me.intEvents(args);
        me.afterLoadForm(args);
    },
    initForm: function (args) {

    },
    intEvents: function (args) {

    },
    afterLoadForm: function (args) {

    },


});