( function _ServletFileSharer_ss_(){

'use strict';

/*
if( !module.parent )
process.chdir( __dirname );
*/

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../../dwtools/Base.s';
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

var _ = _global_.wTools;

  _.include( 'wFiles' );
  _.include( 'wServlet' );

  var Https = require( 'https' );
  var Http = require( 'http' );
  var Express = require( 'express' );

  Express.Logger = require( 'morgan' );
  Express.Directory = require( 'serve-index' );

}

//

var _ = _global_.wTools;
var Parent = null;
var Self = function wServerFileSharer( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'ServerFileSharer';

//

function init( o )
{
  var self = this;

  _.instanceInit( self );

  if( self.Self === Self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

}

//

function form()
{
  var self = this;

  _.assert( arguments.length === 0 );

  /* */

  if( !self.express )
  self.express = Express();
  var express = self.express;

  _.servlet.controlLoggingPre.call( self );

  /* */

  if( self.defaultMime )
  Express.static.mime.default_type = self.defaultMime;

  /* */

  _.servlet.controlPathesNormalize.call( self );

  self.path = _.path.join( _.path.current(),self.path );

  /* */

  if( self.port )
  express.use( _.routineJoin( self,self.requestPreHandler ) );

  if( self.port )
  {
    if( Config.debug && self.verbosity )
    express.use( Express.Logger( 'dev' ) );
  }

  /* */

  express.use( self.url,Express.static( self.path ) );
  express.use( self.url,Express.Directory( self.path,self.directoryOptions ) );

  if( self.port )
  express.use( _.routineJoin( self,self.requestPostHandler ) );

  /* */

  _.servlet.controlLoggingPost.call( self );
  _.servlet.controlExpressStart.call( self );

  return self;
}

//

function exec()
{
  _.assert( !_.instanceIs( this ) );

  var self = new _.constructorGet( this )();
  var args = _.appArgs();

  if( args.subject )
  self.path = _.path.join( _.path.current(),args.subject );

  return self.form();
}

//

function requestPreHandler( request, response, next )
{
  var self = this;

  _.servlet.controlRequestPreHandle.call( self, request, response, next );

  next();
}

//

function requestPostHandler( request, response, next )
{
  var self = this;

  _.servlet.controlRequestPostHandle.call( self, request, response, next );

}

// --
// relations
// --

var directoryOptions =
{
  'icons' : true,
  'hidden' : true,
}

var Composes =
{

  name : Self.shortName,
  url : '/',
  path : '.',

  port : 7777,
  verbosity : 2,
  lookingForPort : 1,
  usingHttps : 0,
  httpsOptions : null,
  defaultMime : 'text/plain',

  directoryOptions : directoryOptions,

}

var Associates =
{
  express : null,
  server : null,
}

var Restricts =
{
}

var Statics =
{
  exec : exec,
}

// --
// declare
// --

var Proto =
{

  init : init,
  form : form,
  exec : exec,

  requestPreHandler : requestPreHandler,
  requestPostHandler : requestPostHandler,

    // ident

  
  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( typeof module !== 'undefined' && !module.parent )
_global_.server = Self.exec();

})();
