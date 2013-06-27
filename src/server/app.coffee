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
        if err
            console.log( err )
        if err or not users
            console.log( "No users found" )
            res.send( "No users found" )
        else
            console.log( users )
            #res.writeHead( 200, {
            #    'Content-Type' : 'application/json'
            #} )
            str = '['
            users.forEach( ( user ) ->
                if str.length > 1
                    str = str + ','
                str = str + '{ "name" : "' + user.username + '"}'
            )
            str = str.trim()
            #str = str.substring( 0, str.length - 1 )
            str = str + ']'
            res.send( str )
    )
)

# Expose API for inserting Mongo users.
app.post( '/insertangularmongouser', ( req, res ) ->
    console.log( "POST: " )
    # Allow for cross-domain communication.
    res.header( "Access-Control-Allow-Origin", "http://localhost" )
    res.header( "Access-Control-Allow-Methods", "GET, POST" )
    
    # Debugging output.
    console.log( req.body )
    console.log( req.body.mydata )
    
    # Parse fields.
    jsonData = JSON.parse( req.body.mydata )
    
    # Save registration fields.
    db.things.save( {
        'email': jsonData.email
        ,
        'password': jsonData.password
        ,
        'username': jsonData.username
    # Call back reports mongo results and potential errors.
    }, ( err, saved ) ->
        if err
            console.log( err )
        if err or not saved
            console.log( "User not saved." )
            res.end( "User not saved." )
        else
            console.log( "User saved." )
            res.end( "User saved." )
        return
    )
    console.log( "User might be saved." )
    return
)

# Open connection door way.
app.listen( 1212 )
console.log( "Server started. Listening on port 1212.")
