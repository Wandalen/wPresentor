( function _LiveNode_s_() {

'use strict';

var _ObjectHasOwnProperty = Object.hasOwnProperty;
var _ = _global_.wTools;
var Parent = null;
var Self = function wLiveNode( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'LiveNode';

// --
// inter
// --

function init( o )
{
  var node = this;

  node._nodeCounter[ 0 ] += 1;

  _.instanceInit( node );

  Object.preventExtensions( node );

  if( o )
  {
    // debugger;
    node.copy( o );
    // debugger;
    if( o.container !== undefined )
    _.assert( node.container === o.container );
  }

  if( node.name === null )
  node.name = 'node-' + node._nodeCounter[ 0 ];

  _.assert( _.strIsNotEmpty( node.name ) );
  _.assert( _.objectIs( node.system ),'each live node should be associated with system' );

  node.system.systemMakeNodeAfter( node );

}

//

function finit()
{
  var node = this;
  var system = node.system;

  system.systemUnmakeNodeAfter( node );

  _.Copyable.prototype.finit.call( node );
}

//

function _exists( iteration,iterator )
{
  var node = this;
  var result = true;

  if( node.onExists )
  {
    result = node.onExists( node,iteration,iterator );
  }

  return result;
}

//

function _textMake( iteration,iterator )
{
  var node = this;
  var result = '';

  if( !node._doesExist )
  debugger;

  if( !node._doesExist )
  return result;

  if( node.onText )
  {
    result = node.onText( node,iteration,iterator );
  }

  return result;
}


//

function textMake( o )
{
  var node = this;

  _.routineOptions( textMake,o );

  debugger;

  var iterator = node.iteratorNew();

  if( !node._exists( iterator ) )
  return;

  debugger;
  var result = node._textMake( iterator );
  debugger;

  return result;
}

textMake.defaults =
{
}

//

function iteratorationNew( o )
{
  var node = this;
  var result = Object.create( null );

  _.routineOptions( iteratorationNew,o ); debugger;

  // result.value = null;
  // tesult.key = null;

  return result;
}

iteratorationNew.defaults =
{
  iterator : null,
}

//

function iteratorNew( o )
{
  var node = this;
  var result = Object.create( null );

  _.routineOptions( iteratorNew,o );

  // result.value = null;
  // tesult.key = null;

  return result;
}

iteratorNew.defaults =
{
}

//

function uniqGet()
{
  var node = this;
  return node.name;
}

// --
// relations
// --

var Composes =
{
  name : null,
  kind : null,
  onExists : null,
  onText : null,
}

var Aggregates =
{
}

var Associates =
{
  a : null,
  system : null,
}

var Restricts =
{
  _doesExist : null,
  down : null,
}

var Statics =
{
  _nodeCounter : [ 0 ],
}

// --
// declare
// --

var Proto =
{

  // routine

  init : init,
  finit : finit,

  _exists : _exists,
  _textMake : _textMake,
  textMake : textMake,

  iteratorationNew : iteratorationNew,
  iteratorNew : iteratorNew,

  uniqGet : uniqGet,


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
    System : null,
    Node : Self,
    In : null,
    Out : null,
  },
});

_.Copyable.mixin( Self );
_.GraphNode.mixin( Self );

//

_.accessor
({

  object : Self.prototype,
  readOnly : 1,
  names :
  {
    uniq : 'uniq',
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

})();
