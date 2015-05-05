define([
    'intern!object',
    'intern/chai!assert',
    'require'
], function (registerSuite, assert, require) {

    registerSuite({

        name: 'click_scroll',

        'click nav and scroll down' : function() {

            return this.remote
                .get(require.toUrl('http://localhost:9000/'))
                .findByCssSelector('nav ul li:first-child').click()
                    .end()
                .setFindTimeout(5000)
                .findByCssSelector('.content > section[data-current=""] > h1').isDisplayed()
                    .then(function(value) {
                        assert.ok(value);
                    })
                    .end();
        }
    });
});
