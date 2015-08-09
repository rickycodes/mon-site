define([
    'intern!object',
    'intern/chai!assert',
    'require'
], function (registerSuite, assert, require) {

    var linkToCheck = 'about';

    function getScrollPosition(context) {
        return context.remote
          .execute(function () {
            return window.pageYOffset;
          });
    }

    registerSuite({

        name: 'navigation',

        'hash updates on navigation click' : function() {

            return this.remote
                .get(require.toUrl('http://localhost:9000/'))
                .setFindTimeout(5000)
                .findByCssSelector('nav ul li a[data-to="' + linkToCheck + '"]').click()
                .end()
                .getCurrentUrl()
                .then(function(value) {
                    assert.ok(value.indexOf('#' + linkToCheck) != -1);
                })
                .end();
        },

        'scroll increases on navigation click' : function() {

            var self = this;
            var before;

            return self.remote.get(require.toUrl('http://localhost:9000/'))
                .then(function(){
                    getScrollPosition(self).then(function(val){
                        before = val;
                    });
                })
                .end()
                .findByCssSelector('nav ul li a[data-to="' + linkToCheck + '"]').click()
                .end()
                .setFindTimeout(50000)
                .then(function() {
                    getScrollPosition(self).then(function(val){
                        assert.ok(val > before);
                    });
                })
                .end();
        }
    });
});
