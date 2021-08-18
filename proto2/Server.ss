( function _server_ss_(){

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = './dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  let _ = _global_.wTools;

  _.include( 'wCopyable' );
  _.include( 'wInstancing' );
  _.include( 'wEventHandler' );
  _.include( 'wVerbal' );
  _.include( 'wPathFundamentals' );
  _.include( 'wFiles' );

}

process.chdir( __dirname );

require( './dwtools/atop/servlet/Servlet.ss' );

let Express = require( 'express' );
Express.Logger = require( 'morgan' );

/*

git clone https://wandalen@bitbucket.org/wandalen/events.git .
http://freelancing.guide/distributed.html

*/

//

let _ = wTools;
let Parent = null;
let Self = function EventServer()
{
  return _.instanceConstructor( Self, this, arguments );
}

//

function init( o )
{
  let self = this;

  _.instanceInit( self );
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  _.appArgsReadTo
  ({
    dst : self,
    only : 1,
    namesMap :
    {
      'production' : 'production',
    },
  });

  // xxx
  if( self.production )
  self.port = 80;

  return self;
}

//

function form()
{
  let self = this;

  if( !self.express )
  self.express = Express();
  let express = self.express;

  _.servlet.controlLoggingPre.call( self );

  /* */

  self.staticPath = _.path.resolve( __dirname, self.staticPath );
  self.stagingPath = _.path.resolve( __dirname, self.stagingPath );
  self.productionPath = _.path.resolve( __dirname, self.productionPath );

  _.servlet.controlPathesNormalize.call( self );

  logger.log( 'staticPath', self.staticPath );
  logger.log( 'stagingPath', self.stagingPath );
  logger.log( 'productionPath', self.productionPath );

  /* */

  express.set( 'views', __dirname + '/shared' );
  express.set( 'view engine', 'jade' );

  if( express.get( 'env' ) === 'development' )
  {
    express.locals.pretty = true;
    express.locals.doctype = 'jade';
  }

  /* static file */
  /*express.use( Express.static( Path.join( __dirname, Config.path.staging ) ) );*/
  /* heavy static files in '/file' folder */

  console.log( 'production', self.production );

  express.use( '/file', Express.static( _.path.nativize( self.staticPath ) ) );

  if( self.production )
  express.use( '/', Express.static( _.path.nativize( self.productionPath ) ) );
  else
  express.use( '/', Express.static( _.path.nativize( self.stagingPath ) ) );

  express.use( _.routineJoin( self, self.requestPreHandler ) );

  if( self.usingLogging )
  express.use( Express.Logger( 'dev' ) );

  /* servlet */

  self.servlet = Object.create( null );

  /* */

  express.use( _.routineJoin( self, self.requestPostHandler ) );

  _.servlet.controlLoggingPost.call( self );
  _.servlet.controlExpressStart.call( self );

  return self;
}

// --
// handler
// --

function requestPreHandler( request, response, next )
{
  let self = this;
  let result = null;

  /* console.log( 'request : ' + request.protocol + '://' + request.get( 'host' ) + request.originalUrl ); */

  next();
}

//

function requestPostHandler( request, response, next )
{
  let self = this;
  let result = null;

  if( response.finished )
  return next( request, response, next );

  response.writeHead( 400,{ 'Content-Type': 'text/plain' });
  response.write( 'Not found' );
  response.end();

}

// --
// relationships
// --

let Composes =
{

  name : 'EventServer',
  usingLogging : Config.debug,
  port : 13131,
  usingHttps : 0,
  allowCrossDomain : 1,
  verbosity : 9,
  production : 0,

  stagingPath : '../../staging',
  productionPath : '../../production',
  staticPath : '../../file',

}

let Aggregates =
{
  express : null,
  server : null,
}

let Associates =
{
  servlet : null,
}

let Restricts =
{
}

// --
// proto
// --

let Extend =
{

  init : init,
  form : form,

  requestPreHandler : requestPreHandler,
  requestPostHandler : requestPostHandler,

  // ident

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

_.Copyable.mixin( Self );
_.EventHandler.mixin( Self );
_.Verbal.mixin( Self );

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_.Server = Self;
_global_.server = new Self().form();

})();
