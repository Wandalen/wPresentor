( function _SimpleTree_s_( ) {

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

  _.include( 'wGraph' );
  // require( '../UseBase.s' );

}

//

var _ = _global_.wTools;
var Parent = null;
var Self = _global_.wTools.graph || Object.create( null );

// --
// inter
// --

var NodeGetters =
{
  elementsGet : function elementsGet( node ){ return node.elements },
  nameGet : function nameGet( node ){ return node.name },
  downGet : function elementsGet( node ){ return node.down },
}

//

function _simpleTreeIteratorMake()
{
  var iterator = Object.create( null );

  _.assert( arguments.length === 0 );

  iterator.root = null;
  iterator.visited = [];
  iterator.iterations = [];
  iterator.looped = [];

  iterator.result = null;
  iterator.onUp = null;
  iterator.onDown = null;
  iterator.onIterator = null;
  iterator.elementsGet = null;
  iterator.nameGet = null;

  iterator.iterationMake = function iterationMake( iteration )
  {
    return _simpleTreeIterationMake( this,iteration );
  }

  /*Object.freeze( iterator );*/

  return iterator;
}

//

function _simpleTreeIterationMake( iterator,iteration )
{
  var newIteration = Object.create( null );

  _.assert( arguments.length === 1 || arguments.length === 2 );

  newIteration.returned = [];
  newIteration.node = null;
  newIteration.key = null;
  newIteration.index = null;

  if( !iteration )
  {
    newIteration.level = 0;
    newIteration.path = '';
    newIteration.down = null;
    /*Object.freeze( newIteration );*/
  }
  else
  {
    newIteration.path = iteration.path;
    newIteration.level = iteration.level+1;
    newIteration.down = iteration;
    /*Object.freeze( newIteration );*/
  }

  return newIteration;
}

//

function eachNode( o )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.routineIs( o.elementsGet ) );
  _.assert( _.routineIs( o.nameGet ) );
  _.routineOptions( eachNode,o );

  var iterator = _simpleTreeIteratorMake();
  iterator.root = o.node;
  iterator.result = o.result;
  iterator.onUp = o.onUp;
  iterator.onDown = o.onDown;
  iterator.onIterator = o.onIterator;
  iterator.elementsGet = o.elementsGet;
  iterator.nameGet = o.nameGet;

  if( o.onIterator )
  iterator = o.onIterator( iterator,o );
  _.assert( _.objectIs( iterator ) );

  var iteration = _simpleTreeIterationMake( iterator );
  iteration.node = o.node;

  _eachNodeAct( iterator,iteration );

  o.result = iterator.result;

  return iterator.result;
}

eachNode.defaults =
{
  node : null,
  result : null,
  onUp : null,
  onDown : null,
  onIterator : null,
}

_.mapExtend( eachNode.defaults,NodeGetters );

//

function _eachNodeAct( iterator,iteration )
{
  var node = iteration.node;
  var name = iterator.nameGet.call( node,node,iteration,iterator );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.strIs( name ) );
  iteration.path += '/' + name;
  iteration.visited = 1;
  iteration.second = 0;
  iteration.visitedInIterations = iteration.down !== null ? [ iteration.down ] : [];

  /* */

  var first = iterator.visited.indexOf( node );
  if( first !== -1 )
  {
    iterator.looped.push( node );
    iteration.second = 1;

    for( var i = iterator.iterations.length-1 ; i >= first ; i-- )
    {
      var iteration0 = iterator.iterations[ i ];
      iteration0.visited += 1;
    }

    var iteration0 = iterator.iterations[ first ];
    _.assert( iteration0.node === node );
    iteration0.visitedInIterations.push( iteration.down );

  }

  iterator.visited.push( node );
  iterator.iterations.push( iteration );

  /* */

  function down()
  {
    if( iterator.onDown )
    {
      var downReturned = iterator.onDown( node,iteration,iterator );
      if( iteration.down )
      iteration.down.returned.push( downReturned );
    }
    _.assert( iterator.visited[ iterator.visited.length - 1 ] === node );
    _.assert( iterator.iterations[ iterator.visited.length - 1 ] === iteration );
    iterator.visited.pop();
    iterator.iterations.pop();
  }

  /* up */

  var keepGoing = true;
  if( iterator.onUp )
  keepGoing = iterator.onUp( node,iteration,iterator );

  /* */

  if( !iteration.second && keepGoing !== false )
  {

    var elements = iterator.elementsGet.call( node,node,iteration,iterator );
    for( var e = 0 ; e < elements.length ; e++ )
    {
      var newIteration = _simpleTreeIterationMake( iterator,iteration );
      newIteration.key = e;
      newIteration.index = e;
      newIteration.node = elements[ e ];
      _eachNodeAct( iterator,newIteration );
    }

  }

  /* down */

  down();
}

//

function goRelative( o )
{

  _.routineOptions( goRelative,o );
  _.assert( _.numberIs( o.offset ) );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( o.axis === 'vertical' || o.axis === 'horizontal' );

  if( !o.offset )
  return o.node;

  if( o.axis === 'vertical' )
  {
    var offset = o.offset;
    var element = o.node;
    if( offset > 0 ) while( offset !== 0 )
    {
      var elements = o.elementsGet( element )
      if( !elements || !elements.length )
      return;
      element = elements[ 0 ];
      offset -= 1;
    }
    else while( offset !== 0 )
    {
      element = o.downGet( element );
      if( !element )
      return;
      offset += 1;
    }
    return element;
  }

  var down = o.downGet( o.node );

  if( !down )
  return;

  var elements = o.elementsGet( down );
  var index = elements.indexOf( o.node );

  _.assert( index >= 0 );

  var newIndex = index + o.offset;
  var l = newIndex < 0;
  var r = elements.length <= newIndex;

  if( l || r )
  if( o.allowHorizontalDuringVertical )
  {
    var optionsForRelative = _.mapExtend( null,o );
    optionsForRelative.node = down;
    optionsForRelative.offset = l ? newIndex + 1 : newIndex - elements.length + 1;
    return goRelative( optionsForRelative );
  }
  else
  {
    return;
  }

  return elements[ newIndex ];
}

goRelative.defaults =
{
  node : null,
  offset : null,
  axis : 'horizontal',
  allowHorizontalDuringVertical : 0,
}

_.mapExtend( goRelative.defaults,NodeGetters );

// --
// declare
// --

var Proto =
{

  _simpleTreeIteratorMake : _simpleTreeIteratorMake,
  _simpleTreeIterationMake : _simpleTreeIterationMake,

  eachNode : eachNode,
  _eachNodeAct : _eachNodeAct,

  goRelative : goRelative,

}

//

_.mapExtend( Self, Proto );
wTools[ 'graph' ] = Self;

})();
