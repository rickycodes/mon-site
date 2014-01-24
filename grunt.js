module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-css');
  // grunt.loadNpmTask('grunt-contrib-htmlmin');
  var gruntConfig = require('./grunt-config.json');
  grunt.initConfig(gruntConfig);
  grunt.registerTask('default', Object.keys(gruntConfig).join(' '));
};