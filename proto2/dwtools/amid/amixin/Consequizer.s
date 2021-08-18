( function _Consequizer_s_() {

'use strict';

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

  _.include( 'wConsequence' );

}

//

var _ = _global_.wTools;
var _ObjectHasOwnProperty = Object.hasOwnProperty;

//

/**
 * Mixin this into prototype of another object.
 * @param {object} dstClass - constructor of class to mixin.
 * @method onMixin
 * @memberof wConsequizer#
 */

function onMixin( mixinDescriptor, dstClass )
{

  var dstPrototype = dstClass.prototype;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.routineIs( dstClass ) );

  _.mixinApply( this, dstPrototype );
  // _.mixinApply
  // ({
  //   dstPrototype : dstPrototype,
  //   descriptor : Self,
  // });

}

//

function _consequizerRoutinesFor()
{
  var cls = this;

  if( _ObjectHasOwnProperty.call( cls , '_Consequizer' ) && cls._Consequizer )
  return cls._Consequizer;
  cls._Consequizer = function Consequizer(){}
  cls._Consequizer.prototype = Object.create( null );

  _.assert( _.constructorIs( cls ) );
  _.assert( arguments.length === 0 );

  /* */

  function consequenceRoutineAdopt()
  {
    _.assert( r[ 0 ] !== '_' );
    var _routine = routine;
    cls._Consequizer.prototype[ r ] = function _consequize()
    {
      var result = _routine.apply( this.consequence,arguments );
      return this;
    }
  }

  /* */

  for( var r in _.Consequence.prototype )
  {
    // debugger;
    // console.log( r );

    if( _.Consequence.prototype._Accessors[ r ] )
    continue;

    var routine = _.Consequence.prototype[ r ];
    if( r[ 0 ] === '_' )
    continue;
    if( !_.routineIs( routine ) )
    continue;
    if( !routine.with )
    continue;
    if( routine.with.consequizing )
    consequenceRoutineAdopt();
  }

  /* */

  function targetRoutineAdopt()
  {
    _.assert( r[ 0 ] === '_' );
    var _routine = routine;
    var name = _.strRemoveBegin( r,'_' ) + 'Then';
    /* logger.log( 'targetRoutineAdopt',name ); */
    cls._Consequizer.prototype[ name ] = function _consequize()
    {
      var self = this;
      var args = arguments;

      self.consequence.doThen( function( err,arg )
      {
        return _routine.apply( self,args );
      });

      return self;
    }
  }

  /* */

  for( var r in cls.prototype )
  {
    var routine = cls.prototype[ r ];
    if( !_.routineIs( routine ) )
    continue
    if( !routine.with )
    continue;
    if( !routine.with.consequizing )
    continue;
    if( !routine.with.exposing )
    continue;
    targetRoutineAdopt();
  }

}

//

function _consequize( instance )
{
  var cls = instance.Self;

  _.assert( _.instanceIs( instance ) );
  _.assert( _.constructorIs( cls ) );

  cls._consequizerRoutinesFor();

  var extension = new cls._Consequizer();
  extension.consequence = new _.Consequence().give();
  Object.preventExtensions( extension );

  var handler =
  {
    set : function( obj, k, e )
    {
      instance[ k ] = e;
      return true;
    },
    get : function( obj, k )
    {
      if( obj[ k ] !== undefined )
      return obj[ k ];
      return instance[ k ];
    },
  }

  var result = new Proxy( extension , handler );
  return result;
}

//

function consequized()
{
  var self = this;
  var consequized = self._consequize( self );
  return consequized;
}

// --
// relations
// --

var Composes =
{
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
}

var Medials =
{
}

var Statics =
{
  _Consequizer : null,

  _consequizerRoutinesFor : _consequizerRoutinesFor,
  _consequize : _consequize,
}

// --
// declare
// --

var Supplement =
{

  _consequizerRoutinesFor : _consequizerRoutinesFor,
  _consequize : _consequize,

  consequized : consequized,

  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Medials : Medials,
  Statics : Statics,

}

//

var Self = _.mixinDelcare
({
  supplement : Supplement,
  onMixin : onMixin,
  name : 'wConsequizer',
  shortName : 'Consequizer',
});

//

_global_[ Self.name ] = _[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_.assert( _.strIs( Self.shortName ) );
_.assert( _.objectIs( Self.__mixin__ ) );
_.assert( _.routineIs( Self.mixin ) );

})();
