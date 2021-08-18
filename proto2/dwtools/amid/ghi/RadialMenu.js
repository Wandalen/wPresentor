( function _RadialMenu_js_( ) {

'use strict';

var $ = jQuery;
var _ = _global_.wTools;
var Parent = wGhiAbstractModule;
var Self = function wGhiRadialMenu( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'RadialMenu';

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );
}

//

function _formAct()
{
  var self = this;

  _.assert( arguments.length === 0 );
  Parent.prototype._formAct.call( self );

  self.elementsDom = $( self.elementsDom );
  self.linesDom = $( self.linesDom );

  self._handleMouseMove = _.routineJoin( self,self._handleMouseMove );
  self._handleMouseDown = _.routineJoin( self,self._handleMouseDown );
  self._handleMouseUp = _.routineJoin( self,self._handleMouseUp );

  _.uiInitPopups( self.targetDom );

  /* some interactivity */

  self.targetDom
  .on( _.eventName( 'mouseleave' ), function( e )
  {

    if( !self.usingMouseEscape )
    return;

    if( self._openning || self._showing )
    return;

    if( self._mouseDown )
    return;

    if( !self.visibleGet() )
    return;

    console.log( 'mouseleave' ); debugger;

    if( self.usingEscapeAsCancel )
    self.cancel();
    else
    self.accept();

  })
  ;

}

//

function accept()
{
  var self = this;

  if( self._closing || self._hiding )
  return;

  if( self._itemActive === null )
  return self.cancel();

  var result = Parent.prototype.accept.call( self );
  self.visibleSet( 0 );

  return result;
}

//

function cancel()
{
  var self = this;

  if( !self._formCon )
  return;

  if( self._closing || self._hiding )
  return;

  self.itemActivate( null );

  var result = Parent.prototype.cancel.call( self );
  self.visibleSet( 0 );

  return result;
}

//

function angleByState( value )
{
  var self = this;

  if( _.strIs( value ) )
  value = self.items.indexOf( value );

  _.assert( 0 <= value && value < self.items.length )

  var result = value * ( 2 * pi / self.items.length );

  return result;
}

//

function stateByAngle( angle )
{
  var self = this;

  if( angle < 0 )
  angle += 2*pi;

  _.assert( _.numberIs( angle ) );
  _.assert( angle >= 0 && angle <= 2*pi );

  var value = Math.round( angle / ( 2 * pi / self.items.length ) );

  if( value === self.items.length )
  value = 0;

  _.assert( 0 <= value && value < self.items.length )

  var result = self.items[ value ];

  return result;
}

//

function itemActivateByMouseEvent( e )
{
  var self = this;

  var pos = _.eventClientPosition
  ({
    event : e,
    relative : self.targetDom,
  });

  return self.itemActivateByMousePosition( pos );
}

//

function itemActivateByMousePosition( pos )
{
  var self = this;

  pos = pos.slice();
  _.avector.subScalar( pos,self.radius )

  var mag = _.avector.mag( pos );
  if( mag < self.radius / 2 )
  return self.itemActivate( self.defaultItem );

  var normalized = _.avector.normalize( pos ).slice();

  if( self.usingFloatingArrow )
  {
    _.avector.mulScalar( pos,self.radius );
    _.avector.addScalar( pos,self.radius )
    self.linesDom.attr
    ({
      x2 : pos[ 0 ],
      y2 : pos[ 1 ],
    });
  }

  var angle = Math.atan2( -normalized[ 1 ],normalized[ 0 ] );

  // console.log( 'angle',angle );

  return self.itemActivate( self.stateByAngle( angle ) );
}

//

function itemActivate( value )
{
  var self = this;

  value = self._itemActivateAct( value );

  self._arrowAdjust();

  return value;
}

//

function _itemActivateAct( value )
{
  var self = this;

  _.assert( _.strIs( value ) || value === null );
  _.assert( arguments.length === 1 );

  self._itemActive = value;

  self.elementsDom.removeClass( 'active' );
  if( value !== null )
  self.elementsDom.filter( '[data-value=' + value+ ']' ).addClass( 'active' );

  return value;
}

//

function _arrowAdjust()
{
  var self = this;
  var value = self._itemActive;

  if( value === null )
  {
    self.linesDom.attr
    ({
      x2 : self.radius,
      y2 : self.radius,
    });
    return;
  }

  var angle = self.angleByState( value );

  var pos =
  [
    self.radius + Math.cos( angle )*self.radius,
    self.radius - Math.sin( angle )*self.radius,
  ];

  self.linesDom.attr
  ({
    x2 : pos[ 0 ],
    y2 : pos[ 1 ],
  });

  return pos;
}

//

function _positionRadialAdjust( radius,phase )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );

  if( radius === undefined )
  radius = 1;

  if( phase === undefined )
  phase = 0;

  _.domFormationRadialSet
  ({
    containerDom : self.targetDom,
    elementsDom : self.elementsDom,
    radius : radius,
    phase : phase,
  });

}

//

function _visibleSetBegin( value )
{
  var self = this;

  /* */

  if( value )
  {

    self._mouseDown = 0;
    //self._itemActive = self.defaultItem;
    self.itemActivate( self.defaultItem );

    self.rootDom
    .on( _.eventName( 'mousemove' ), self._handleMouseMove )
    // .on( _.eventName( 'mousedown' ), self._handleMouseDown )
    // .on( _.eventName( 'mouseup' ), self._handleMouseUp )
    ;

  }
  else
  {

    self.rootDom
    .off( _.eventName( 'mousemove' ), self._handleMouseMove )
    // .off( _.eventName( 'mousedown' ), self._handleMouseDown )
    // .off( _.eventName( 'mouseup' ), self._handleMouseUp )
    ;

  }

  /* */

  return Parent.prototype._visibleSetBegin.call( self,value );
}

//

function _visibleSetAct( value )
{
  var self = this;

  /* */

  if( value )
  {

    self.rootDom
    // .on( _.eventName( 'mousemove' ), self._handleMouseMove )
    .on( _.eventName( 'mousedown' ), self._handleMouseDown )
    .on( _.eventName( 'mouseup' ), self._handleMouseUp )
    ;

  }
  else
  {

    self.rootDom
    // .off( _.eventName( 'mousemove' ), self._handleMouseMove )
    .off( _.eventName( 'mousedown' ), self._handleMouseDown )
    .off( _.eventName( 'mouseup' ), self._handleMouseUp )
    ;

  }

  /* */

  return Parent.prototype._visibleSetAct.call( self,value );
}

//

function _visibleSetAnimation( value )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( value )
  {

    self._positionRadialAdjust();

    if( !Config.slowPlatform && self.usingAnimation )
    wAnimator.get()
    .animation({ name : '_visibleSetAnimation' })
    .stop( 0 )
    .options
    ({
      target : [ 0,-1.5 ],
      valueStop : [ 1,0 ],
      repeat : 1,
      duration : self.duration,
      law : wAnimator.laws.cubic.inOut,
      onUpdate : function( val )
      {
        self._positionRadialAdjust( val[ 0 ],val[ 1 ] );
      },
    })
    .start();

    self.soundPlay( self.soundVisibleOnUrl );

  }
  else
  {

    self.soundPlay( self.soundVisibleOffUrl );

  }

  Parent.prototype._visibleSetAnimation.call( self,value );

}

//

function _handleMouseMove( e )
{
  var self = this;

  var pos = _.eventClientPosition
  ({
    event : e,
    relative : self.targetDom,
  });

  self.itemActivateByMousePosition( pos );

  if( self.usingMouseDistanceEscape )
  {

    self._mouseDistance = _.avector.distance( pos,[ self.radius,self.radius ] ) / self.radius;
    if( self._mouseDistance > 2 && !self._mouseDown )
    if( self.usingEscapeAsCancel )
    self.cancel();
    else
    self.accept();

  }

  if( self._mouseDown )
  {
    return false;
  }
}

//

function _handleMouseDown( e )
{
  var self = this;

  // console.log( 'radial.mousedown' );
  self._mouseDown = 1;

}

//

function _handleMouseUp( e )
{
  var self = this;

  if( !self._mouseDown )
  return;

  self._mouseDown = 0;

  e.usedByRadialMenuAsMouseUp = 1;

  console.log( 'radial.mouseup' );
  self.itemActivateByMouseEvent( e );
  self.accept();

  return false;
}

// --
// relationship
// --

var pi = Math.PI;

var Composes =
{

  _itemActive : null,
  radius : 50,

  usingCancel : 1,
  usingAccept : 1,

  soundVisibleOnUrl : '',
  soundVisibleOffUrl : '',

  usingMouseEscape : 0,
  usingMouseDistanceEscape : 1,
  usingEscapeAsCancel : 0,

  usingFloatingArrow : 0,
  usingSound : 1,

  defaultItem : null,
  animation : 'scale',

}

var Aggregates =
{

  items : null,

}

var Associates =
{

  targetDom : '',
  contentDom : '',
  elementsDom : '',
  linesDom : '',

}

var Restricts =
{

  _mouseDown : 0,
  _mouseDistance : 0,

  _handleMouseMove : null,
  _handleMouseDown : _handleMouseDown,
  _handleMouseUp : null,

}

var Statics =
{
}

// --
// proto
// --

var Proto =
{

  init : init,

  accept : accept,
  cancel : cancel,

  _formAct : _formAct,

  angleByState : angleByState,
  stateByAngle : stateByAngle,

  itemActivateByMouseEvent : itemActivateByMouseEvent,
  itemActivateByMousePosition : itemActivateByMousePosition,
  itemActivate : itemActivate,
  _itemActivateAct : _itemActivateAct,

  _arrowAdjust : _arrowAdjust,
  _positionRadialAdjust : _positionRadialAdjust,

  _visibleSetBegin : _visibleSetBegin,
  _visibleSetAct : _visibleSetAct,
  _visibleSetAnimation : _visibleSetAnimation,

  _handleMouseMove : _handleMouseMove,
  _handleMouseDown : _handleMouseDown,
  _handleMouseUp : _handleMouseUp,

  //

  /* constructor * : * Self, */
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Statics : Statics,

}

//

_.classDeclare
({
  cls : Self,
  extend : Proto,
  parent : Parent,
});

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})( );
