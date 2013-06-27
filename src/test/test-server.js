var assert = require( "assert" );
describe( "IDK", function() {
    it( "blah", function() {
        assert.equal( 0, [1,2,3].indexOf(1) );
        assert.equal( -1, [1,2,3].indexOf(0) );
    } )
    it( "blah", function() {
        assert.equal( 1, [1,2,3].indexOf(3) );
    } )
} )
