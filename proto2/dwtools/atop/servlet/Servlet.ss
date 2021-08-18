(function _Servlet_ss_() {

'use strict';

var Querystring = null;
var Jade = null;
var Https = null;
var Http = null;
var Express = null;

if( typeof _global_ === 'undefined' || !_global_.wBase )
{
  let toolsPath = '../../../dwtools/Base.s';
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

var File = require( 'fs-extra' );
var _ = _global_.wTools;

_.include( 'wPathFundamentals' );
_.include( 'wFiles' );

var Parent = null;
var Self = _.servlet = _.servlet || Object.create( null );

// --
// servlet
// --

function controlLoggingPre()
{
  var servlet = this;

  _.assert( arguments.length === 0,'expects none argument' );
  _.assert( servlet.verbosity !== undefined,'servlet needs field { verbosity }' );
  _.assert( servlet.Self,'servlet should have { Copyable } mixin' );

  if( !servlet.verbosity )
  return;

  _.assert( servlet.constructor === servlet.Self );

  // if( servlet.Self && servlet.constructor !== servlet.Self )
  // return;

  if( servlet.verbosity > 2 )
  {
    logger.log( '' );
    logger.logUp( servlet.nickName,' :' );
    logger.logDown( '' );
  }

}

//

function controlLoggingPost()
{
  var servlet = this;

  _.assert( arguments.length === 0,'expects none argument' );
  _.assert( servlet.verbosity !== undefined,'servlet needs field { verbosity }' );

  if( !servlet.verbosity )
  return;

  if( servlet.Self && servlet.constructor !== servlet.Self )
  return;

  var l = typeof logger !== 'undefined' ? logger : console;
  // if( l.logUp === undefined ) l.logUp = l.log;
  // if( l.logDown === undefined ) l.logDown = l.log;

  // l.logDown();
  // l.logUp( 'Properties of',servlet.nickName,' :' );

  l.logUp( 'Properties of',servlet.nickName,' :' );

  // db

  for( var c in servlet )
  {
    var component = servlet[ c ];
    if( _.strIs( component ) && _.strBegins( c,'db' ) )
    {
      l.log( c, ' :', component );
    }
  }

  // url

  for( var c in servlet )
  {
    var component = servlet[ c ];
    if( _.strIs( component ) && _.strBegins( c,'url' ) )
    {
      l.log( c, ' :', component );
    }
  }

  // path

  for( var c in servlet )
  {
    var component = servlet[ c ];
    if( _.strIs( component ) && _.strBegins( c,'path' ) )
    {
      l.log( c, ' :', component );
    }
  }

  /*l.log( '' );*/

  // express locals
/*
  if( servlet.app )
  {
    logger.log( 'app.locals :',_.toStr( servlet.app.locals ) );
  }
*/

  l.logDown( '' );

}

//

function controlPathesNormalize()
{
  var servlet = this;

  _.assert( arguments.length === 0,'expects none argument' );
  _.assert( servlet.verbosity !== undefined,'servlet needs field { verbosity }' );

  /* url */

  for( var c in servlet )
  {
    var component = servlet[ c ];
    if( _.strIs( component ) && _.strBegins( c,'url' ) )
    {
      if( !component ) continue;
      servlet[ c ] = _.path.normalize( servlet[ c ] );
    }
  }

  /* path */

  for( var c in servlet )
  {
    var component = servlet[ c ];
    if( _.strIs( component ) && _.strBegins( c,'path' ) )
    {
      if( !component ) continue;
      servlet[ c ] = _.path.normalize( servlet[ c ] );
    }
  }

}

//

function controlAllowCrossDomain( request, response )
{

  _.assert( arguments.length === 2 || arguments.length === 3, 'expects two or three arguments' );

  response.setHeader( 'Access-Control-Allow-Origin', '*' );
  response.setHeader( 'Access-Control-Allow-Headers', 'X-Requested-With' );
  response.setHeader( 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE' );

}

//

function controlExpressStart()
{
  var servlet = this;
  var url;

  _.assert( servlet.Self,'servlet should be have { Copyable } mixin' );
  _.assert( servlet.name !== undefined,'servlet needs field { name }' );
  _.assert( servlet.port !== undefined,'servlet needs field { port }' );
  _.assert( servlet.usingHttps !== undefined,'servlet needs field { usingHttps }' );
  _.assert( servlet.allowCrossDomain !== undefined,'servlet needs field { allowCrossDomain }' );
  _.assert( servlet.verbosity !== undefined,'servlet needs field { verbosity }' );
  _.assert( servlet.server !== undefined,'servlet needs field { server }' );
  _.assert( servlet.express !== undefined,'servlet needs field { express }' );
  _.assert( arguments.length === 0,'expects none argument' );

  if( !Express )
  Express = require( 'express' );

  if( !servlet.port )
  return;

  if( !servlet.express )
  servlet.express = Express();

  if( servlet.server )
  return;

  if( servlet.usingHttps )
  {

    if( !Https )
    Https = require( 'https' );

    url = 'https://127.0.0.1:' + servlet.port;

    var httpsOptions = servlet.httpsOptions;
    if( !httpsOptions )
    {
      _.assert( servlet.certificatePath );

      httpsOptions = {};
      httpsOptions.key = _.fileProvider.fileRead( servlet.certificatePath + '.rsa' );
      httpsOptions.cert = _.fileProvider.fileRead( servlet.certificatePath + '.crt' );

    }

    servlet.server = Https.createServer( httpsOptions, servlet.express ).listen( servlet.port );

  }
  else
  {

    if( !Http )
    Http = require( 'http' );

    url = 'http://127.0.0.1:' + servlet.port;
    servlet.server = Http.createServer( servlet.express ).listen( servlet.port );

  }

  logger.log( servlet.name, ':', 'express.locals :','\n' + _.toStr( servlet.express.locals,{ wrap : 0 } ) );
  logger.log( servlet.name, ':', 'Serving',servlet.nickName,'on',servlet.port,'port..','\n' )

  return url;
}

//

function controlRequestPreHandle( request, response, next )
{
  var servlet = this;

  _.assert( servlet.allowCrossDomain !== undefined,'servlet need { allowCrossDomain } field' );

  if( servlet.allowCrossDomain )
  _.servlet.controlAllowCrossDomain( request, response, next );

  if( servlet.verbosity >= 2 )
  logger.log( 'request : ' + _.servlet.requestUrlGet( request ) );

}

//

function controlRequestPostHandle( request, response, next )
{
  var servlet = this;

  _.assert( servlet.allowCrossDomain !== undefined,'servlet need { allowCrossDomain } field' );

  if( response.finished )
  return next( request, response, next );

  _.servlet.errorHandle.call( servlet, request, response, next );

}

//

function requestUrlGet( request )
{
  var result = request.protocol + '://' + request.get( 'host' ) + request.originalUrl;
  return result;
}

//

function errorHandle( request, response, next, err )
{

  _.assert( arguments.length === 3 || arguments.length === 4 );

  // debugger;
  //console.log( 'errorHandle', 'response.finished :', response.finished );

  //if( !response.finished && !response._headerSent )
  if( !response.finished )
  {

    response.writeHead( 400,{ 'Content-Type' : 'text/plain' });
    if( err ) response.write( 'Error :\n' + String( err ) );
    else response.write( 'Not found' );
    response.end();
    //next();

  }

  if( err )
  console.warn( 'Error :\n' + String( err ) );

  //if( err ) throw err;
}

//

function postDataGet( request, response, o )
{
  var servlet = this;

  if( !_.Consequence )
  require( './oclass/Consequence.s' );

  if( o.querystring )
  {
    if( !Querystring )
    Querystring = require( 'querystring' );
  }

  var con = _.Consequence();
  var o = o || {};

  _.assert( 2 <= arguments.length && arguments.length <= 3 );
  _.assert( _.objectIs( o ) );


  if( request.readable )
  {

    request.data = '';

    request.on( 'data', function( data )
    {
      if( request.data.length > servlet.postDataSizeLimit )
      {
        response.json( { error : 'Request entity too large.' }, 413 );
        console.warn( 'Request entity too large.',request.data.length );
      }
      request.data += data;
    });

    request.on( 'end', function()
    {
      if( o.json )
      {
        request.data = decodeURIComponent( request.data );
        request.data = JSON.parse( request.data );
      }
      else if ( o.querystring )
      {
        request.data = Querystring.parse( request.data );
      }
      con.give( request.data );
    });

  }
  else
  {

    request.data = request.body;
    con.give( request.body );

  }

  return con;
}

// --
// etc
// --

function jadeWatch( o )
{

  _.assert( 0,'not tested' );

  var optionsDefault =
  {
    name : null,
    source : null,
    rootDirPath : null,
    context : null,
  }

  _.assert( _.strIs( o.name ) );
  _.assert( _.strIs( o.source ) );
  _.assert( _.strIs( o.rootDirPath ) );
  _.assertMapHasOnly( o,optionsDefault );

  if( Jade == null )
  Jade = require( 'jade' );

  if( _.path.ext( o.source ) !== 'sht' )
  o.source += '.sht';

  var o = { basedir : o.rootDirPath };
  var result = Jade.compileFile( o.source,o );

  logger.warn( 'jadeWatch :','async file reading needed!' );

  o.context[ o.name ] = result;

  if( Config.debug && 0 )
  File.watch( o.source, function( event, filename )
  {

    logger.log( 'file :', event, filename );
    var result = Jade.compileFile( o.source,o );
    o.context[ o.name ] = result;

  });

  return result;
}

// --
// declare
// --

var Proto =
{

  // servlet

  controlLoggingPre : controlLoggingPre,
  controlLoggingPost : controlLoggingPost,

  controlPathesNormalize : controlPathesNormalize,
  controlAllowCrossDomain : controlAllowCrossDomain,
  controlExpressStart : controlExpressStart,

  controlRequestPreHandle : controlRequestPreHandle,
  controlRequestPostHandle : controlRequestPostHandle,

  requestUrlGet : requestUrlGet,
  errorHandle : errorHandle,
  postDataGet : postDataGet,

  // etc

  jadeWatch : jadeWatch,

//

  postDataSizeLimit : 1e6

}

_.mapExtend( Self,Proto );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
