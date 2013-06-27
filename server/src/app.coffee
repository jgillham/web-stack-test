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

# Open connection door way.
app.listen( 1212 )
