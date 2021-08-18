 ( function(){

'use strict';

if( typeof module !== 'undefined' )
{

  require( './Servlet.ss' );

  var Path = require( 'path' );
  var File = require( 'fs-extra' );
  var Https = require( 'https' );
  var Http = require( 'http' );
  var Express = require( 'express' );
  Express.Logger = require( 'morgan' );
  Express.Directory = require( 'serve-index' );
  Express.BodyParser = require('body-parser');

}

//

var _ = _global_.wTools;
var Parent = null;
var Self = function wServerLogService( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'ServerLogService';

//

function init( o )
{
  var self = this;

  _.instanceInit( self );

  if( o )
  self.copy( o );

  if( !self.express )
  {
    self.express = Express();
    _.assert( self.port > 0 );
  }

  var express = self.express;

  if( !seilf.fileProvider )
  self.fileProvider = _.FileProvider.Default();

  _.servlet.controlLoggingPre.call( self );

  //

  if( self.port )
  {
    express.set( 'views', __dirname + '/shared' );
    express.set( 'view engine', 'jade' );

    if( express.get( 'env' ) === 'development' )
    {
      express.locals.pretty = true;
      express.locals.doctype = 'jade';
    }
  }

  //

  _.servlet.controlPathesNormalize.call( self );
  var dirname = _.path.normalize( __dirname );

  self.filePath = _.path.join( dirname,self.filePath );
  if( !self.log )
  self.log = _.path.join( self.filePath,'log' );

  //

  if( Config.debug && self.logging )
  express.use( Express.Logger( 'dev' ) );
  /*express.use( self.urlFile, Express.static( self.filePath ) );*/
  express.use( self.urlLog,_.routineJoin( self,self.requestLog ) );

  // serving

  _.servlet.controlLoggingPost.call( self );
  _.servlet.controlExpressStart.call( self );

  //

  if( self.usingFileSharer )
  {
    require( './ServerFileSharer.ss' );
    self.fileSharer = new wServerFileSharer
    ({
      url : self.urlLog,
      path : self.log,
      express : self.express,
      port : 0,
    });
  }

}

//

var _logs = {};
function requestLog( request, response, next )
{
  var self = this;

  if( request.method !== 'POST' )
  return next();

  var postData = _._.servlet.postDataGet( request,response,{ jsonLike : 1 } );
  postData.got( function( err,data )
  {

    if( !_.objectIs( data ) )
    return _.servlet.errorHandle( request,response,next,_.err( 'ServerLogService :','bad request' ) );

    var id = data.o.id;
    var ip = request.connection.remoteAddress;
    var time = new Date().toISOString();
    var fileName;

    if( id )
    fileName = _logs[ id ];

    if( !fileName )
    {
      fileName = _.path.join( self.log,_.strFilenameFor( ip ) + '-' + time + '-' + id + '.log' );
      _logs[ id ] = fileName;
    }

    if( data.way === 'handshake' )
    {
      var url = _.servlet.requestUrlGet( request );
      data.text = ip + ' connected..';
      if( self.verbosity )
      logger.log( 'requestLog : ' + url + ' : ' + data.text );
    }

    var text = ip + ' : ' + time + ' : ' + ( data.method || data.way ) + ' : ' + data.text + '\n';

    self.fileProvider.fileWrite
    ({
      path : fileName,
      data : text,
      append : true,
      force : true,
    });

    _.servlet.controlAllowCrossDomain( request, response );

    response.write( 'ok' );
    response.end();

    /*next();*/

  });
}

// --
// relations
// --

var Composes =
{

  name : Self.shortName,
  port : 13131,

  usingHttps : 1,
  usingFileSharer : 1,
  verbosity : 1,

  filePath : Config.path.file ? _.path.join( '..', Config.path.file ) : './file',
  log : null,

  urlFile : '/file',
  urlLog : '/log',

}

var Associates =
{
  express : null,
  httpsOptions : null,
  fileProvider : null,
}

var Restricts =
{
}

// --
// declare
// --

var Proto =
{

  init : init,
  requestLog : requestLog,

    // ident


  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.Instancing.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( !module.parent )
_global_.server = new Self();

})();
