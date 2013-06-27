module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig( {
    pkg: grunt.file.readJSON('package.json')
    ,
    coffee: {
      compileDefault: {
        files: grunt.file.expandMapping( "**/*.coffee", "", {
            //flatten: true
            cwd: "src/"
            ,
            ext: ".js"
        } )
      }
    }
    ,
    coffeelint: {
      options: grunt.file.readJSON( 'coffeelint.json' )
      ,
      test: {
      files: { src: grunt.file.expand( "src/**/*.coffee" ) }
      }
    }
  } );

  // BEGIN Taken from http://stackoverflow.com/questions/15230090/nodemon-like-task-in-grunt-execute-node-process-and-watch
  grunt.registerTask('start', function() {
    grunt.util.spawn({
      cmd: 'node',
      args: ['app/app.js']
    });
    //grunt.task.run('watch');
  });
  // END

  grunt.registerTask('default', 'start');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-coffeelint');

  // Default task.
  grunt.registerTask('default', [ 'coffeelint', 'coffee' ] );
};

/*** Interesting links.
http://markdalgleish.com/2012/09/test-driven-node-js-development-with-grunt/
***/
