#! /usr/bin/env node
( function _Back_ss_() {

'use strict';

// dependencies

var Path = require( 'path' );
var Module = require( 'module' );

require( './Layer2.s' );

var BackTools = wTools;
var Parent = wTools;
var Self = _global_.wTools;
var _global = _global_;
var _ = _global_.wTools;

_.usePath( __dirname + '/../..' );
_.usePath( __dirname + '/../../..' );

// --
// module
// --

var _nodeModulePaths_original = Module._nodeModulePaths;
function _nodeModulePaths( file )
{
  var result = _nodeModulePaths_original.apply( this,arguments );

  result.push.apply( result,Module.globalPaths );

  return result;
}

//

var _resolveFilename_original = Module._resolveFilename;
function _resolveFilename( request, parent, isMain )
{

  // if( request.indexOf( 'include/dwtools/common.external/Esprima.s' ) !== -1 )
  // {
  //   debugger;
  //   logger.log( 'Loking at ','\n',_.toStr( Module.globalPaths,{ levels : 2 } ) );
  // }

  if( request.indexOf( '/' ) === -1 && request.indexOf( '\\' ) === -1 )
  return _resolveFilename_original.call( this, request, parent, isMain );

  var path = _.path.join( parent.filename + '/..',request );
  var resolved = _.path._pathResolveTextLink( path );

  // if( request.indexOf( 'include/dwtools/common.external/Esprima.s' ) !== -1 )
  // debugger;

  if( resolved.resolved )
  request = _.fileProvider.path.nativize( resolved.path );

  try
  {
    var result = _resolveFilename_original.call( this, request, parent, isMain );
  }
  catch( err )
  {
    // debugger;
    throw _.err
    (
      err,
      '\nLooked at ' + _.path.resolve( resolved.path ),'\n',
      '\nModule.globalPaths\n',
      _.toStr( Module.globalPaths,{ levels : 2 } ),
      '\nparent.paths\n',
      _.toStr( parent.paths,{ levels : 2 } )
    );
  }

  return result;
}

//

function _moduleRegister()
{

  // logger.log( '_moduleRegister' );
  // logger.log( 'module',module );

  var paths = [];

  var dir = _.path.resolve( __dirname,'../..' );
  paths.push( _.fileProvider.path.nativize( dir ) );
  paths.push( _.fileProvider.path.nativize( _.path.join( dir,'node_modules' ) ) );

  var dir = _.path.resolve( __dirname,'../../..' );
  paths.push( _.fileProvider.path.nativize( dir ) );
  paths.push( _.fileProvider.path.nativize( _.path.join( dir,'node_modules' ) ) );

  _._usePathGlobally( module,paths,[] );

  Module._resolveFilename = _resolveFilename;
  Module._nodeModulePaths = _nodeModulePaths;

  // debugger;
  _._setupUnhandledErrorHandler();

}

// --
// declare
// --

var Proto =
{

  // module

  _resolveFilename : _resolveFilename,
  _nodeModulePaths : _nodeModulePaths,
  _moduleRegister : _moduleRegister,

  // etc

  // stringify : stringify,

}

_.mapExtend( Self,Proto );

//

_global_.BackTools = BackTools;
_global_[ 'BackTools' ] = BackTools;

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

//

try
{

  require( './Base.s' );

  _.include( 'wFiles' );

}
catch( err )
{
  debugger;
  throw _.errLog( err );
}

//

// if( !_global_._wBackToolsWithConfig )
_._moduleRegister();

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
