( function _PreloadConfig_ss_() {

'use strict';

// global

var _global = undefined;
if( !_global && typeof Global !== 'undefined' && Global.Global === Global ) _global = Global;
if( !_global && typeof global !== 'undefined' && global.global === global ) _global = global;
if( !_global && typeof window !== 'undefined' && window.window === window ) _global = window;
if( !_global && typeof self   !== 'undefined' && self.self === self ) _global = self;
var _realGlobal = _global;
var _globalWas = _global._global_ || _global;
if( _global._global_ )
_global = _global._global_;
_global._global_ = _global;
_realGlobal._realGlobal_ = _realGlobal;

// dependency

var _ObjectToString = Object.prototype.toString;
var Path = require( 'path' );
var File = require( 'fs-extra' );

// --
// config
// --

function fileStat( filePath )
{
  try
  {
    return File.statSync( filePath );
  }
  catch ( err )
  {
    // console.log( 'no ',filePath );
  }
}

//

function strIs( src )
{
  var result = _ObjectToString.call( src ) === '[object String]';
  return result;
}

//

function exec( code )
{
  var f = new Function( code );
  var result = f.call();
  return result;
}

//

function _configRead( o )
{

  var self = this;
  var read;

  if( o.path === undefined )
  {

    var effectiveMainFile = require.main ? require.main.filename : process.cwd();

    o.path = Path.resolve( effectiveMainFile );
    o.path = Path.dirname( o.path );
    o.path = Path.normalize( o.path ).replace( /\\/g,'/' );

  }

  if( o.name === undefined )
  o.name = 'config';

  if( o.result === undefined )
  o.result = Object.create( null );

  var filePath = o.name[ 0 ] !== '/' && o.name[ 1 ] !== ':' ? o.path + '/' + o.name : o.name;

  /**/

  try
  {

    if( typeof Coffee !== 'undefined' )
    {
      var fileName = filePath + '.coffee';
      if( fileStat( fileName ) )
      {

        read = Coffee.eval( File.readFileSync( fileName, 'utf8'), {
          filename : fileName,
        });

        if( read )
        {
          // console.log( 'config loaded from',fileName );
          Object.assign( o.result,read );
        }

      }
    }

  }
  catch( err )
  {
    console.error( '\nCant read ' + fileName );
    throw err;
  }

  /**/

  try
  {

    var fileName = filePath + '.json';
    if( fileStat( fileName ) )
    {

      read = JSON.parse( File.readFileSync( fileName, 'utf8' ) );

      if( read )
      {
        console.log( 'config loaded from',fileName );
        Object.assign( o.result,read );
      }

    }

  }
  catch( err )
  {
    console.error( '\nCant read ' + fileName );
    throw err;
  }

  /**/

  try
  {

    var fileName = filePath + '.s';
    if( fileStat( fileName ) )
    {

      read = File.readFileSync( fileName, 'utf8' );
      read = exec( read );
      if( read )
      {
        console.log( 'config loaded from',fileName );
        Object.assign( o.result,read );
      }

    }

  }
  catch( err )
  {
    console.error( '\nCant read ' + fileName );
    throw err;
  }

  return o.result;
}

_configRead.defaults =
{
  path : null,
  name : null,
  result : null,
}

//

function fileConfigRead( o )
{

  var self = this;
  var o = o || Object.create( null );

  if( strIs( o ) )
  {
    o = { name : o };
  }

  if( !o.name )
  {
    o.name = 'Config';
    _configRead( o );
    o.name = 'config';
    _configRead( o );

    o.name = 'public';
    _configRead( o );
    o.name = 'private';
    _configRead( o );
    o.name = 'include/auto.pre/Config';
    _configRead( o );
  }
  else
  {
    _configRead( o );
  }

  return o.result;
}

fileConfigRead.defaults =
{
}

fileConfigRead.defaults.__proto__ = _configRead.defaults;

//

var _configReadGloballyDone = 0;
function configReadGlobally( o )
{

  if( _configReadGloballyDone )
  return _global_.Config;
  _configReadGloballyDone = 1;

  var c = fileConfigRead( o );
  c = Object.assign( Object.create( null ), _global_.Config, c );
  _global_.Config = c;

  return _global_.Config;
}

configReadGlobally.defaults =
{
}

configReadGlobally.defaults.__proto__ = fileConfigRead.defaults;

// --
// declare
// --

var Self =
{

  _configRead : _configRead,
  fileConfigRead : fileConfigRead,
  configReadGlobally : configReadGlobally,

}

_global_.wTools = _global_.wTools ? _global_.wTools : Object.create( null );
Object.assign( _global_.wTools,Self );

//

// configReadGlobally();

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
