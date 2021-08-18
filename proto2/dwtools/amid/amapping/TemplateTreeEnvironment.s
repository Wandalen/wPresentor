( function _TemplateTreeEnvironment_s_( ) {

'use strict';

/**
  @module Tools/base/TemplateTreeEnvironment - Class to resolve tree-like with links data structures or paths in the structure. TemplateTreeEnvironment extends TemplateTreeResolver to been able to resolve paths into a files system. Use the module to resolve template or path to value.
*/

/**
 * @file TemplateTreeEnvironment.s.
 */

if( typeof module !== 'undefined' )
{

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


  let _ = _global_.wTools;

  _.include( 'wTemplateTreeResolver' );
  _.include( 'wPathFundamentals' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = wTemplateTreeResolver;
let Self = function wTemplateTreeEnvironment( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'TemplateTreeEnvironment';

// --
// inter
// --

function init( o )
{
  let self = this;

  Parent.prototype.init.call( self,o );

  if( self.constructor === Self )
  Object.preventExtensions( self );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( self.path === null )
  self.path = _.path;

}

//

function valueTry( name,def )
{
  let self = this;
  let name2 = name;

  if( self.front !== null )
  name2 = _.entitySelect
  ({
    container : self.front,
    query : name,
  });

  let result = self.resolveTry( name2 );

  /* console.log( 'REMINDER : optimize valueTry' ); */

  _.assert( arguments.length === 1 || def !== undefined, 'def should not be undefined if used' );
  _.assert( arguments.length === 1 || arguments.length === 2, 'valueTry expects 1 or 2 arguments' );

  if( result === undefined )
  result = def;

  if( self.verbosity )
  logger.debug( 'value :',name,'->',result );

  return result;
}

//

function valueGet( name )
{
  let self = this;
  let result = self.valueTry( name );

  _.assert( arguments.length === 1,'valueGet expects 1 argument' );

  if( result === undefined )
  {
    debugger;
    throw _.err( 'Unknown variable',name );
  }

  return result;
}

//

function pathTry( name,def )
{
  let self = this;
  let result;

  if( def !== undefined )
  result = self.valueTry( name,def );
  else
  result = self.valueTry( name );

  _.assert( arguments.length === 1 || arguments.length === 2,'pathTry expects 1 or 2 arguments' );

  if( !result )
  return def;

  result = self.path.join( self.rootDirPath, result );
  result = self.path.normalize( result );
  result = result.replace( /(?<!:|:\/)\/\//, '/' );

  if( self.verbosity )
  logger.debug( 'path :',name,'->',result );

  return result;
}

//

function pathGet( name )
{
  let self = this;
  let result = self.pathTry( name );

  if( result === undefined )
  {
    debugger;
    throw _.err( 'Unknown variable',name );
  }

  return result;
}

//

function pathsNormalize()
{
  let self = this;

  for( let t in self.tree )
  {
    let src = self.tree[ t ];
    if( !_.strEnds( t,'Path' ) )
    continue;
    if( !_.strIs( src ) )
    continue;
    self.tree[ t ] = self.pathGet( src );
  }

  return self;
}

// --
// relations
// --

let Composes =
{
  verbosity : 0,
  rootDirPath : '',
}

let Associates =
{
  front : null,
  path : null,
}

let Restricts =
{
}

// --
// declare
// --

let Proto =
{

  init : init,

  valueTry : valueTry,
  valueGet : valueGet,
  value : valueGet,

  pathTry : pathTry,
  pathGet : pathGet,
  path : pathGet,

  pathsNormalize : pathsNormalize,

  // relations

  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,

};

// define

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

_[ Self.shortName ] = _global_[ Self.name ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
