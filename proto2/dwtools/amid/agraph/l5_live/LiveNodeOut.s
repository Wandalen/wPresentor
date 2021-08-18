( function _LiveOut_s_() {

'use strict';

var _ObjectHasOwnProperty = Object.hasOwnProperty;
var _ = _global_.wTools;
var Parent = wLiveNode;
var Self = function wLiveOut( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'LiveOut';

// --
// inter
// --

function init( o )
{
  var node = this;
  Parent.prototype.init.call( node,o );
}

//

function finit()
{
  var node = this;
  var system = node.system;

  node.elementsFinit();

  Parent.prototype.finit.call( node );
}

//

// function _exists( iteration,iterator )
// {
//   var node = this;
//   var result = true;
//
//   if( node.onExists )
//   {
//     debugger;
//     result = node.onExists( iteration,iterator );
//     debugger;
//   }
//
//   return result;
// }

//

// function _textMake( iteration,iterator )
// {
//   var node = this;
//   var result = '';
//
//   if( !node._doesExist )
//   debugger;
//
//   if( !node._doesExist )
//   return result;
//
//   if( node.onText )
//   {
//     debugger;
//     result = node.onText( node,iteration,iterator );
//     debugger;
//   }
//
//   return result;
// }

//

function textMake( o )
{
  var node = this;
  var system = node.system;

  _.routineOptions( textMake,o );

  function handleDown( node,iteration,iterator )
  {
    // if( node.kind === 'in' )
    // iteration.value = node.container[ node.key ];
    node._doesExist = node._exists( iteration,iterator );
    return node._doesExist;
  }

  function handleIterator( iterator,options )
  {
    iterator.result = '';
    return iterator;
  }

  function handleUp( node,iteration,iterator )
  {

    _.assert( _.boolLike( node._doesExist ) );

    if( !node._doesExist )
    return false;

    var r = node._textMake( iteration,iterator );
    _.assert( _.strIs( r ) );
    iterator.result += r;

  }

  var result = node.nodeEach
  ({
    onDown : handleDown,
  });

  var result = node.nodeEach
  ({
    onUp : handleUp,
    onIterator : handleIterator,
  });

  return result;
}

textMake.defaults =
{
}

// --
// relations
// --

var Composes =
{
  kind : 'out',
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
  finit : finit,

  /* _exists : _exists, */
  /*_textMake : _textMake,*/
  textMake : textMake,


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
    Node : null,
    In : null,
    Out : Self,
  },
});

_.GraphBranch.mixin( Self );

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

})();
