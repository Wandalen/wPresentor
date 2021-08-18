( function _NameMapper_s_( ) {

'use strict';

/**
  @module Tools/mid/NameMapper - Simple class to map names from one space to another and vice versa. Options for handling names collisions exist. Use the module to make your program shorter, more readable and to avoid typos.
*/

/**
 * @file NameMapper.s.
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

  var _ = _global_.wTools;

  _.include( 'wCopyable' );

}

//

var _global = _global_;
var _ = _global_.wTools;
var Parent = null;
var Self = function wNameMapper( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'NameMapper';

// --
// inter
// --

function init( o )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.instanceInit( self );

  if( o )
  self.copy( o );

  self.forVal = self._forVal.bind( self );
  self.forKey = self._forKey.bind( self );
  self.hasKey = self._hasKey.bind( self );
  self.hasVal = self._hasVal.bind( self );

  /* seal it */

  if( self.constructor === Self )
  Object.preventExtensions( self );

}

//

function set()
{
  var self = this;

  _.assert( arguments.length > 0 );

  self.keyToValueMap = _.mapExtend( null,self.keyToValueMap );
  _.mapsExtend( self.keyToValueMap,arguments );

  if( self.droppingDuplicate )
  self.valueToKeyMap = _.mapInvertDroppingDuplicates( self.keyToValueMap );
  else
  self.valueToKeyMap = _.mapInvert( self.keyToValueMap );

  Object.freeze( self.keyToValueMap );
  Object.freeze( self.valueToKeyMap );

  return self;
}

//

function forVal( val )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( !_.primitiveIs( val ) )
  {
    debugger;
    return _.entityMap( val,function forVal( val )
    {
      return self.forVal( val );
    });
  }

  if( self.asIsIfMiss && self.valueToKeyMap[ val ] === undefined )
  return val;

  _.assert( self.valueToKeyMap[ val ] !== undefined,'Unknown value',val );
  return self.valueToKeyMap[ val ];
}

//

function forKey( key )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( !_.primitiveIs( key ) )
  {
    debugger;
    return _.entityMap( key,function forKey( key )
    {
      return self.forKey( key );
    });
  }

  _.assert( _.strIs( key ) || _.numberIs( key ),'expects string or number {-key-}, but got',_.strTypeOf( key ) );

  if( self.asIsIfMiss && self.keyToValueMap[ key ] === undefined )
  return key;

  _.assert( self.keyToValueMap[ key ] !== undefined,'Unknown key',key );

  return self.keyToValueMap[ key ];
}

//

function hasKey( key )
{
  var self = this;
  _.assert( _.strIs( key ) || _.numberIs( key ),'expects string or number {-key-}, but got',_.strTypeOf( key ) );
  return self.keyToValueMap[ key ] !== undefined;
}

//

function hasVal( val )
{
  var self = this;
  return self.valueToKeyMap[ val ] !== undefined;
}

// --
// relations
// --

var Composes =
{
  droppingDuplicate : 1,
  asIsIfMiss : 0,
  keyToValueMap : _.define.own( {} ),
  valueToKeyMap : _.define.own( {} ),
}

var Associates =
{
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
  set : set,

  _forVal : forVal,
  _forKey : forKey,
  _hasKey : hasKey,
  _hasVal : hasVal,

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

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

_[ Self.shortName ] = _global_[ Self.name ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
