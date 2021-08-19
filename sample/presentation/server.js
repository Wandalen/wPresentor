let Express = require( 'express' );
let app = new Express();
let path = require( 'path' );

app.get( '/', function( req, res )
{
  res.sendFile( path.join( __dirname, 'Presentor.html' ) );
});
app.use( Express.static( __dirname ) );

app.listen( 3000, () =>
{
  console.log( 'http://localhost:3000' );
})