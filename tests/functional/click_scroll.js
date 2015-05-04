define([
    'intern!object',
    'intern/chai!assert',
    'require'
], function (registerSuite, assert, require) {

    registerSuite({

        name: 'click_scroll',

        'click nav and scroll down' : function() {

            var section = 'about';

            return this.remote
                .get(require.toUrl('http://localhost:9000/'))
                .setWindowSize(800,600)
                .setFindTimeout(1000)
                .findByCssSelector('nav ul li:first-child').click()
                    .end()
                .setFindTimeout(1000)
                .findByCssSelector('section[data-current=""] > h1').getVisibleText()
                    .then(function(value) {
                        console.log(value.toLowerCase().indexOf(section) > -1);
                        assert.ok(value.toLowerCase().indexOf(section) > -1);
                    })
                    .end()
        }
    });
});
