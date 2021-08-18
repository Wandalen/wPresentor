( function(){

'use strict';

/* called by _.domScrolable() */

var $ = jQuery;
var _ = _global_.wTools;
var Parent = null;
var Self = function wScrollable( options )
{
  if( !( this instanceof Self ) )
  {
    var result = [];
    var targetDom = $( options.targetDom );

    _.assert( _.domableIs( options.targetDom ), 'domScrollFix','expects domable options.targetDom' );

    targetDom.each( function( k,e )
    {
      var o = _.mapExtend( null,options );
      o.targetDom = $( e );
      result.push( new( Function.prototype.bind.apply( Self, [ Self,o ] ) ) );
    });

    return result;
  }
  return Self.prototype.init.apply( this,arguments );
}

Self.shortName = 'Scrollable';

//

function init( options )
{
  var self = this;

  _.mapExtendConditional( _.field.mapper.srcOwnAssigning,self,Composes );
  _.mapExtendConditional( _.field.mapper.srcOwnAssigning,self,Aggregates );

  if( options )
  self.copy( options );

  if( self.axis === null )
  self.axis = self.xScroll ? 0 : 1;

  _.assert( _.domableIs( self.targetDom ), 'domScrollFix','expects domable options.targetDom' );
  _.assert( self.containerDom === null || _.domableIs( self.containerDom ), 'domScrollFix','expects domable options.containerDom' );

  var state = self.state;
  var targetDom = self.targetDom = self.containerDom ? $( self.containerDom ).find( self.targetDom ) : $( self.targetDom );
  var containerDom = self.containerDom = self.containerDom ? $( self.containerDom ) : targetDom.parent();

  _.assert( containerDom.length );

  /* dragstart */

  self.targetDom.find( 'img' ).bind( 'dragstart', function( event ) { event.preventDefault(); } );

  /* mousedown */

  containerDom.bind( _.eventName( 'mousedown' ), function( event )
  {
    state.mouseAnchor = _.eventClientPosition( event );
    state.animating = false;
  });

  /* mouseup */

  containerDom.bind( _.eventName( 'mouseup' ) + ' ' + _.eventName( 'mouseleave' ), function( event )
  {
    if( !state.inited )
    return;
    if( !state.mouseAnchor )
    return;
    state.mouseAnchor = null;
    if( self.usingStepping )
    {
      var c = self.currentGet( 0 )
      if( _.isNumber( c ) )
      self.show( c );
    }
  });

  /* mousemove */

  containerDom.bind( _.eventName( 'mousemove' ), function( event )
  {
    if( !state.mouseAnchor ) return;
    var mousePosition = _.eventClientPosition( event );
    if( self.xScroll === true )
    self.scroll( 0,mousePosition[ 0 ]-state.mouseAnchor[ 0 ] );
    if( self.yScroll === true )
    self.scroll( 1,mousePosition[ 1 ]-state.mouseAnchor[ 1 ] );
    state.mouseAnchor = mousePosition;
  });

  /* mousewheel */

  if( self.usingWheel )
  {

    var h;
    if( self.usingStepping )
    {
      var debouncedHandleWheel = _.debounce( _.routineJoin( self, self.handleWheel ), 100, 1 );
      h = function( event )
      {

        debouncedHandleWheel.call( this,event );
        /*event = _.eventWheelZero( event,1,0 );*/
        event._fromScrollable = true;

        return false;
      }
    }
    else
    {
      h = _.routineJoin( self, self.handleWheel );
    }

    containerDom.mousewheel( h );

  }

  /* buttons */

  if( self.usingButtons ) {

    _.assert( _.strIs( self.buttonLeft ) );
    _.assert( _.strIs( self.buttonRight ) );

    self.buttons =
    self.containerDom.find( self.buttonLeft ).add( containerDom.find( self.buttonRight ) );

    self.buttons
    .bind( _.eventName( 'mousedown' ), function( event )
    {

      var t = $( this );
      if( t.filter( self.buttonLeft ).length )
      {
        self.showPrev();
      }
      else if( t.filter( self.buttonRight ).length )
      {
        self.showNext();
      }
      else throw _.err( 'Unknown button' );

      return false;
    });

  }

  /* showing consequence */

  self._showing = new wConsequence({ tag : 'showing' }).give();
  self._showingSibling = new wConsequence({ tag : 'showingSibling' }).give();

}

//

function updateState()
{
  var self = this;
  var state = self.state;

  state.inited = true;

  state.sizeTarget = [ self.targetDom.outerWidth(),self.targetDom.outerHeight() ];
  state.sizeContainer = [ self.containerDom.outerWidth(),self.containerDom.outerHeight() ];

  state.position = self.targetDom.position();
  state.position = [ state.position.left,state.position.top ];
  state.offset = [ 0,0 ];

  self.updateSteps( 0 );
  self.updateSteps( 1 );

  /*console.log( 'state.steps :',_.toStr( state.steps,{ levels : 10 } ) );*/
}

//

function updateSteps( d )
{
  var self = this;
  var state = self.state;

  var children = self.targetDom.children();

  if( !state.steps )
  state.steps = [];

  state.steps[ d ] = [];
  children.each( function( k,e )
  {
    var e = $( e );
    var size = d ? e.outerHeight() : e.outerWidth();
    if( !size ) return;
    var pos = e.position();
    state.steps[ d ].push
    ({
      position : d ? pos.top : pos.left,
      size : size,
    });
  });
  state.steps[ d ].sort( self.stepComparator );

  /*console.log( 'position :',state.steps[ d ][ 0 ].position );*/

}

//

function stepComparator( a,b )
{
  return a.position - b.position
}

//

function currentGet( d )
{
  var self = this;
  var state = self.state;

  _.assert( _.numberIs( d ) );

  for( var s = 0 ; s < state.steps[ d ].length ; s++ )
  {
    var step = state.steps[ d ][ s ];
    if( Math.abs( step.position + state.offset[ d ] ) < step.size / 2 )
    return s;
  }
}

//

function scroll( d,delta )
{
  var self = this;
  var state = self.state;

  if( state.inited === false )
  self.updateState();

  if( delta > 0 )
  {
    if( state.offset[ d ] + delta > - state.position[ d ] )
    {
      /*console.log( 'delta > 0' );*/
      return;
    }
  }

  if( delta < 0 )
  {
    if( state.position[ d ] + state.offset[ d ] + state.sizeTarget[ d ] + delta < state.sizeContainer[ d ] )
    {
      /*console.log( 'delta < 0' );*/
      return;
    }
  }
/*
  console.log( 'scroll :',delta );
*/
  state.offset[ d ] += delta;

  if( d === 1 )
  {
    /*console.log( 'y :',state.position[ d ] + state.offset[ d ] );*/
    self.targetDom.css( 'top', ( state.position[ d ] + state.offset[ d ] ) + 'px' );
  }
  else
  {
    /*console.log( 'x :',state.position[ d ] + state.offset[ d ] );*/
    self.targetDom.css( 'left', ( state.position[ d ] + state.offset[ d ] ) + 'px' );
  }
/*
  if( self.usingStepping )
  {
    var c = self.currentGet( 0 );
    console.log( 'current :',c );
  }
*/
  return true;
}

//

function show( index )
{
  var self = this;
  var state = self.state;
  var d = self.axis;
  var con = new _.Consequence();

  if( state.inited === false )
  self.updateState();

  if( index === 0 )
  console.log( '!show :',index );

  _.assert( 0 <= index && index < state.steps[ d ].length );

  state.animating = false;

  self._showing.got( function()
  {

    var diff = - state.offset[ d ] - state.steps[ d ][ index ].position;

    console.log( 'show :',index );
    /*console.log( 'diff :',diff );*/

    state.animating = true;
    _.timePeriodic( 20,function()
    {

      if( state.animating === false )
      {
        self._showing.give();
        con.give();
        return false;
      }

      var diff = - state.offset[ d ] - state.steps[ d ][ index ].position;

      if( Math.abs( diff ) > 1 )
      self.scroll( d,( diff ) / self.damp );
      else
      {
        self.scroll( d,diff );
        self._showing.give();
        con.give();
        return false;
      }

    });

  });

  return con;
}

//

function _showSibling( delta )
{
  var self = this;
  var state = self.state;

  _.assert( _.numberIs( delta ) );

  if( state.inited === false )
  self.updateState();

  state.animating = false;

  self._showingSibling.got( function()
  {

    var showed;
    var d = self.axis;
    var l = state.steps[ d ].length;

    if( !l )
    return self._showingSibling.give();

    var c = self.currentGet( d );
    c += delta;

    if( c >= l )
    {
      if( self.usingCycling )
      showed = self.show( 0 );
    }
    else if( c < 0 )
    {
      if( self.usingCycling )
      showed = self.show( l-1 );
    }
    else showed = self.show( c );

    showed.got( self._showingSibling );
  });

}

//

function showNext()
{
  var self = this;

  return self._showSibling( +1 );
}

//

function showPrev()
{
  var self = this;

  return self._showSibling( -1 );
}

// --
// handler
// --

function handleWheel( event )
{
  var self = this;
  var state = self.state;;
  var delta = _.eventWheelDeltaScreen( event );
  var prevent = false;

  /*console.log( 'handleWheel',delta );*/

  if( self.usingStepping )
  {

    if( delta[ self.axis ] < 0 )
    self.showNext();
    else if( delta[ self.axis ] > 0 )
    self.showPrev();
    prevent = true;

  }
  else
  {

    if( self.xScroll === true )
    if( self.scroll( 0,delta[ 0 ] ) )
    prevent = true;

    if( self.yScroll === true )
    if( self.scroll( 1,delta[ 1 ] ) )
    prevent = true;

  }

  if( prevent === true )
  event.preventDefault();

}

// --
// relations
// --

var Composes =
{

  axis : null,
  xScroll : true,
  yScroll : true,

  usingStepping : false,
  usingCycling : true,
  usingWheel : true,

  usingButtons : false,
  buttonLeft : '.icon.left',
  buttonRight : '.icon.right',

  damp : 10,

  state :
  {
    inited : false,

    offset : null,
    position : null,
    sizeTarget : null,
    sizeContainer : null,
    steps : null,
    animating : false,
  },

}

var Aggregates =
{

  targetDom : null,
  containerDom : null,

}

// --
// proto
// --

var Proto =
{

  init : init,

  updateState : updateState,
  updateSteps : updateSteps,
  stepComparator : stepComparator,

  currentGet : currentGet,
  scroll : scroll,
  show : show,

  _showSibling : _showSibling,
  showNext : showNext,
  showPrev : showPrev,

  // handler

  handleWheel : handleWheel,

  // relations

  /* constructor * : * Self, */
  Composes : Composes,
  Aggregates : Aggregates,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.EventHandler.mixin( Self );

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
