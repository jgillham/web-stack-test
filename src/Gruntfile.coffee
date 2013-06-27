# The project build file.
#
# @author Josh Gillham
# @version 7-1-2013

module.exports = (grunt) ->
    # For copying js files to public folder.
    grunt.loadNpmTasks('grunt-contrib-copy')
    # Watches files for changes.
    grunt.loadNpmTasks('grunt-contrib-watch')
    # There was a problem with the existing function where it would snip off
    #  cwd. This simple solution is not very robust but does solve problem.
    fixedExpandMappings = ( a, b, c, cwd ) ->
        files = grunt.file.expandMapping( a, b, c )
        if cwd
            for mapping in files
                mapping.dest = mapping.dest.replace( cwd, '' )
        return files

    # Project configuration.
    grunt.initConfig( {
        jade : {
            html : {
                files : {
                    'public/' : ['src/client/*.jade']
                }
                ,
                options : {
                    client : false
                }
            }
        }
        ,
        pkg : grunt.file.readJSON('package.json')
        ,
        coffee : {
            compileDefault : {
                files : fixedExpandMappings( "src/Gruntfile.coffee", "", {
                    ext : ".js"
                }, "src/" )
            }
            ,
            server: {
                files : fixedExpandMappings( "src/server/*.coffee", "", {
                    ext : ".js"
                }, "src/server/" )
            }
            ,
            client: {
                files : fixedExpandMappings( "src/client/**/*.coffee", \
                        "public", {
                    ext : ".js"
                }, "src/client/" )
            }
        }
        ,
        coffeelint : {
            options : grunt.file.readJSON( 'coffeelint.json' )
            ,
            test : {
                files : {
                    src: grunt.file.expand( "src/**/*.coffee" )
                }
            }
        }
        ,
        watch: {
            scripts: {
                files: 'src/**/*.coffee',
                tasks: ['coffee'],
                options: {
                    debounceDelay: 250,
                }
            }
        }
        ,
        copy: {
            client_js: {
                files : fixedExpandMappings( "src/client/**/*.js", "public", {
                    ext : ".js"
                }, "src/client" )
            }
            client_css: {
                files : fixedExpandMappings( "src/client/**/*.css", "public", {
                    ext : ".css"
                }, "src/client" )
            }
        }
    } )

    # BEGIN Taken from
    # http://stackoverflow.com/questions/15230090/nodemon-like-
    #    task-in-grunt-execute-node-process-and-watch
    grunt.registerTask('start', () ->
        grunt.util.spawn( {
            cmd : 'node'
            ,
            args : ['app/app.js']
        } )
        #grunt.task.run('watch')
    )
    # END

    grunt.registerTask('default', 'start')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-coffeelint')
    grunt.loadNpmTasks('grunt-jade')

    # Default task.
    grunt.registerTask('default', [ 'coffee', 'jade', 'copy' ] )

#Interesting links.
#http://markdalgleish.com/2012/09/test-driven-node-js-development-with-grunt/
