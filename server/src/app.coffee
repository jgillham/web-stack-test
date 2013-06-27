# Use more descriptive alias.
application_root= __dirname

# Required libraries.
express = require("express")
path = require("path")

# Create web server.
app = express()

# Connect to the mongo database.
databaseUrl = "sampledb"
collections = [ "things" ]
db = require( "mongojs" ).connect(databaseUrl, collections)

# Configure express app.
app.configure( () ->
    app.use( express.bodyParser() )
    app.use( express.methodOverride() )
    app.use( app.router )
    app.use( express.static( path.join( application_root, "public" ) ) )
    return app.use( express.errorHandler( {
        dumpExceptions: true
        ,
        showStack: true
    } ) )
)

# Make REST web service available.
app.get( '/api', (req, res) ->
    return res.send( 'Our Sample API is up...' )
)

# Expose API to get angular users.
app.get( '/getangularusers', ( req, res ) ->
    res.header( "Access-Control-Allow-Origin", "http://localhost" )
    res.header( "Access-Control-Allow-Methods", "GET, POST" )
    
    # Call Mongo via JS API
    db.things.find( '', ( err, users ) ->
        if err or not useers
            console.log( "No users found" )
            res.send( "No users found" )
        else
            res.writeHead( 200, {
                'Content-Type' : 'application/json'
            } )
            str = '['
            users.forEach( ( user ) ->
                str = str + '{ "name" : "' + user.username + '"},' + '\n'
            )
            str = str.trim()
            str = str.substring( 0, str.length - 1 )
            str = str + ']'
            res.end( str )
    )
)

# Open connection door way.
app.listen( 1212 )
