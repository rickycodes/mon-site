define([
    'intern!object',
    'intern/chai!assert',
    'require'
], function (registerSuite, assert, require) {

    registerSuite({

        name: 'hashupdate',

        'hash updates on navigation click' : function() {

            var linkToCheck = 'about';

            return this.remote
                .get(require.toUrl('http://localhost:9000/'))
                .findByCssSelector('nav ul li a[data-to="' + linkToCheck + '"]').click()
                    .end()
                .setFindTimeout(5000)
                .getCurrentUrl()
                    .then(function(value) {
                        assert.ok(value.indexOf('#' + linkToCheck) != -1);
                    })
                    .end();
        }
    });
});
