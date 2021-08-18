( function _LiveSystem_s_() {

'use strict';

var _ObjectHasOwnProperty = Object.hasOwnProperty;
var _ = _global_.wTools;
var Parent = null;
var Self = function wLiveSystem( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'LiveSystem';

// --
// inter
// --

function init( o )
{
  var system = this;

  _.instanceInit( system );

  Object.preventExtensions( system );

  if( o )
  system.copy( o );

}

//

function finit()
{
  var system = this;

  while( system.nodes.length )
  {
    system.nodes.finit();
  }

  _.Copyable.prototype.finit.call( system );
}

//

function out( o )
{
  var system = this;

  if( _.strIs( o ) )
  o = { name : o };

  _.routineOptions( out,o );
  _.assert( arguments.length === 1, 'expects single argument' );

  var result = system.nodesMap[ o.name ];
  if( !result )
  {
    o.kind = 'out';
    o.system = system;
    result = new system.Out( o );

    if( system.currentOut )
    {
      _.assert( result.down === null );
      system.currentOut.elementAppend( result );
      _.assert( result.down === system.currentOut );
    }

  }

  return result;
}

out.defaults =
{
  name : null,
}

//

function outBegin( o )
{
  var system = this;
  var out = system.out.apply( system,arguments );

  system.fieldSet({ currentOut : out });

  return out;
}

outBegin.defaults = out.defaults;

//

function outEnd( o )
{
  var system = this;
  var out = system.out.apply( system,arguments );

  system.fieldReset({ currentOut : out });

  return out;
}

outEnd.defaults = out.defaults;

//

function outDefine( o )
{
  var system = this;
  var out = system.currentOut;

  _.assert( out instanceof system.Out );

  _.mapExtend( out,o );

  return out;
}

//

function inMake( o )
{
  var system = this;

  _.assert( _.strIs( o.key ) || _.numberIs( o.key ) );
  _.assert( _.longIs( o.container ) || _.objectLike( o.container ) );

  o.system = system;

  var result = new system.In( o );

  _.assert( result.down === system.currentOut );

  return result;
}

// --
// relations
// --

var Composes =
{

  name : null,
  containers : _.define.own( [] ),

  nodes : _.define.own( [] ),
  nodesMap : _.define.own( {} ),

  roots : _.define.own( [] ),
  rootsMap : _.define.own( {} ),

  onTextMake : null,
  onExists : null,

}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
  currentOut : null,
}

var Statics =
{
}

// --
// declare
// --

var Proto =
{

  // routine

  init : init,

  out : out,
  outBegin : outBegin,
  outEnd : outEnd,
  outDefine : outDefine,

  inMake : inMake,

/*
  systemMakeNodeAfter : systemMakeNodeAfter,
  systemUnmakeNodeAfter : systemUnmakeNodeAfter,
*/

  // relations


  Composes : Composes,
  Aggregates : Aggregates,
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

_.prototypeCrossRefer
({
  name : 'LiveSystem',
  entities :
  {
    System : Self,
    Node : null,
    In : null,
    Out : null,
  },
});

_.Copyable.mixin( Self );
_.GraphSystem.mixin( Self );
_.FieldsStack.mixin( Self );

//

_.accessor
({
  object : Self.prototype,
  names :
  {
  }
});

//

_.accessorForbid
({
  object : Self.prototype,
  names :
  {
  }
});

//

_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( Config.platform !== 'browser' )
{
  require( './LiveNode.s' );
  require( './LiveNodeIn.s' );
  require( './LiveNodeOut.s' );
}

})();
