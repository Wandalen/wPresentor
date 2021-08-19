( function _Abstract_js_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = _global_.wTools;

  _.include( 'wDomBaseLayer1' );
  _.include( 'wDomBaseLayer3' );
  _.include( 'wDomBaseLayer5' );

  _.include( 'wTemplateTreeEnvironment' );
  _.include( 'wConsequence' );

}

var $ = jQuery;
const _ = _global_.wTools;

_.assert( _.routineIs( _.Consequence ) );

const Parent = null;
const Self = function wGhiAbstractModule( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'AbstractModule';

//

function init( o )
{
  var self = this;

  _.workpiece.initFields( self );

  if( Self === self.Self )
  Object.freeze( self );
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( self._visibleCon.resourcesGet().length === 1 );
  _.assert( self._openCon.resourcesGet().length === 1 );

  self._inited = 1;

}

//

function form()
{
  var self = this;

  self._formStage = 1;

  if( self._formCon )
  return self._formCon.split();

  if( self.dynamic )
  self._formDynamic();
  else
  self._formStatic();

  self._formCon.tap( function()
  {
    self._formStage = 9;
    self._formedCon.take( null );
  });

  return self._formCon.split();
}

//

function _formDynamic()
{
  var self = this;

  self._formCon = _.domLoad
  ({

    parentDom : self.targetDom,
    url : self.url,
    replacing : 1,
    showing : 0,

  })
  .ready.give( function( err,target )
  {

    if( err )
    throw _.errLogOnce( err );

    self.targetDom = target.filter( _.domOwnIdentity( self.targetDom ) );
    _.assert( self.targetDom.length === 1 );

    self._formAct();

    self._formCon.take( null );

  });

}

//

function _formStatic()
{
  var self = this;

  self._formCon = new _.Consequence();

  self._formAct();

  self._formCon.take( null );

}

//

function _formAct()
{
  var self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  /* */

  self._resolveDoms();

  /* */

  _.assert( self.targetDom && self.targetDom.length > 0 );

  if( self.targetIdentity )
  {
    // debugger;
    _.assert( _.strHas( self.targetIdentity,'.' ) );
    _.domOwnIdentity( self.targetDom,self.targetIdentity );
    // self.targetDom.addClass( self.targetIdentity );
  }

  // if( self.targetIdentity )
  // self.targetDom.addClass( self.targetIdentity );

  // _.uiInitPopups( self.targetDom );

}

//

function _resolveDoms()
{
  var self = this;

  if( !self._env )
  self._env = new wTemplateTreeEnvironment({ tree : self, onStrFrom : self.handleStrFrom });

  /* */

  var fields = self.Associates;
  for( var f in fields )
  {

    if( !_.strEnds( f,'Dom' ) && !_.strEnds( f,'DomSelector' ) )
    continue;

    if( !_.strIs( self[ f ] ) )
    continue;

    self[ f ] = self._env.valueGet( self[ f ] );

  }

  /* */

  for( var d in self.Associates )
  {

    if( !_.strEnds( d,'Dom' ) )
    continue;

    // if( self[ d ] === null )
    // continue;
    //
    // _.assert( _.domableIs( self[ d ] ) );

    self[ d ] = $( self[ d ] );

  }

}

//

function _formContentDom()
{
  var self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( _.strIs( self.contentDomSelector ) );

  self.contentDom = self.targetDom.find( self.contentDomSelector );
  if( !self.contentDom.length )
  {
    self.contentDom = $( '<div>' ).appendTo( self.targetDom );
    _.domOwnIdentity( self.contentDom,self.contentDomSelector );
  }

  return self.contentDom;
}

//

function _formContent2Dom()
{
  var self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( _.strIs( self.content2DomSelector ) );
  _.assert( self.contentDom.length > 0 );

  self.content2Dom = self.targetDom.find( self.content2DomSelector );
  if( !self.content2Dom.length )
  {
    self.content2Dom = $( '<div>' ).appendTo( self.contentDom );
    _.domOwnIdentity( self.content2Dom,self.content2DomSelector );
  }

  return self.content2Dom;
}

//

function _formConentElementDom( selector )
{
  var self = this;
  var result = self.contentDom.find( selector );

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( selector ) );
  _.assert( self.contentDom.length > 0 );

  if( !result.length )
  {
    result = $( '<div>' ).appendTo( self.contentDom );
    _.domOwnIdentity( result,selector );
  }

  return result;
}

//

function _formConent2ElementDom( selector )
{
  var self = this;
  var result = self.content2Dom.find( selector );

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( selector ) );
  _.assert( self.content2Dom.length > 0 );

  if( !result.length )
  {
    result = $( '<div>' ).appendTo( self.content2Dom );
    _.domOwnIdentity( result,selector );
  }

  return result;
}

// --
// change
// --

function changeEvent()
{
  var self = this;

  if( !self._formCon )
  return false;

  var result = self._changeEvent.apply( self,arguments );

  if( result === undefined )
  result = true;

  return result;
}

//

function _changeEvent()
{
  var self = this;
}

//

function touchEvent()
{
  var self = this;

  if( !self._formCon )
  return false;

  var result = self._touchEvent.apply( self,arguments );

  if( result === undefined )
  result = true;

  return result;
}

//

function _touchEvent()
{
  var self = this;
}

// --
//
// --

function accept()
{
  var self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( !self._formCon )
  return;

  if( !self.usingAccept )
  return;

  return self._acceptAct();
}

//

function _acceptAct()
{
  var self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

}

//

function cancel()
{
  var self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( !self._formCon )
  return;

  if( !self.usingCancel )
  return;

  return self._cancelAct();
}

//

function _cancelAct()
{
  var self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

}

//

function visibleGet()
{
  var self = this;

  return _.uiIsShowed( self.targetDom );
}

//

function visibleSet( value )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( value === undefined )
  value = !self.visibleGet();
  value = !!value;

  // console.log( 'visibleSet',value );

  self._showing = value ? 1 : 0;
  self._hiding = value ? 0 : 1;

  return self._visibleCon
  .andKeep([ self.form() ])
  .ifNoErrorThen( function( arg )
  {
    value = self._visibleSetBegin( value );
    self._showing = value ? 1 : 0;
    self._hiding = value ? 0 : 1;
  })
  .andKeep([ value ? null : self.openSet( false ) ])
  .thenGive( function()
  {
    if( self.visibleGet() === value )
    return this.take( null );
    // console.log( '_visibleSetAct',value );
    self._visibleSetAct( value );
  })
  .split()
  .ifNoErrorThen( function( arg )
  {
    // console.log( 'visibleSet','done' );
    self._showing = 0;
    self._hiding = 0;
  })
  ;

}

//

function _visibleSetBegin( value )
{
  var self = this;

  return value
}

//

function _visibleSetAct( value )
{
  var self = this;

  self._visibleSetAnimation( value );

}

//

function _visibleSetAnimation( value )
{
  var self = this;

  // console.log( '_visibleSetAnimation',value );
  // console.log( self.targetDom );

  _.uiShow
  ({
    targetDom : self.targetDom,
    consequence : self._visibleCon,
    value : value,
    animation : self.animation,
    duration : self.duration,
  });

}

//

function openGet()
{
  var self = this;

  return _.uiIsShowed( self.contentDom );
}

//

function openSet( value )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( value === undefined )
  value = !self.openGet();

  self._openning = value ? 1 : 0;
  self._closing = value ? 0 : 1;

  // console.log( 'openSet',value );

  return self._openCon
  .andKeep([ self.form() ])
  .ifNoErrorThen( function( arg )
  {
    value = self._openSetBegin( value );
    self._openning = value ? 1 : 0;
    self._closing = value ? 0 : 1;
  })
  .andKeep([ value ? self.visibleSet( true ) : null ])
  .thenGive( function()
  {
    self._openSetAnimation( value );
  })
  .split()
  .ifNoErrorThen( function( arg )
  {
    return self._openSetAct( value );
  })
  .ifNoErrorThen( function( arg )
  {
    self._openning = 0;
    self._closing = 0;
  })
  ;

}

//

function _openSetBegin( value )
{
  var self = this;

  return value
}

//

function _openSetAnimation( value )
{
  var self = this;

  _.uiShow
  ({
    targetDom : self.contentDom,
    consequence : self._openCon,
    value : value,
    animation : self.animation,
    duration : self.duration,
  });

}

//

function _openSetAct( value )
{
  var self = this;

  // self._openSetAnimation( value );

}

// --
// etc
// --

function centerSet( src )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.longIs( src ) );

  self.targetDom.css
  ({
    'left' : src[ 0 ],
    'top' : src[ 1 ],
  });

  var size = _.domSizeGet( self.targetDom );
  self.targetDom.css
  ({
    'margin-left' : -size[ 0 ] / 2,
    'margin-top' : -size[ 1 ] / 2,
  });

}

//

function soundPlay( url )
{
  var self = this;

  if( self.usingSound )
  return _.sound.playTry( url );
}

//

function handleStrFrom( src )
{
  _.assert( _.domLike( src ) );
  _.assert( arguments.length === 1 );

  return _.domOwnIdentity( src );
}

// --
// relations
// --

var Composes =
{

  dynamic : 1,

  usingAnimation : 0,
  usingSound : 0,
  usingCancel : 0,
  usingAccept : 0,

  name : '',
  url : '',

  animation : 'scale',
  duration : 400,

  invisibleCssClass : 'layout-invisible',
  hiddenCssClass : 'layout-hidden',
  targetIdentity : '',

}

var Associates =
{

  rootDom : 'body',
  targetDom : null,
  contentDom : null,

}

var Restricts =
{

  _visibleCon : _.define.own( new _.Consequence().take( null ) ),
  _openCon : _.define.own( new _.Consequence().take( null ) ),

  _formCon : null,
  _formedCon : _.define.own( new _.Consequence() ),

  _formStage : 0,

  _env : null,

  _inited : 0,

  _showing : 0,
  _hiding : 0,

  _closing : 0,
  _openning : 0,

}

var Statics =
{
}

// --
// proto
// --

const Proto =
{

  init : init,

  // form

  form : form,
  _formDynamic : _formDynamic,
  _formStatic : _formStatic,
  _formAct : _formAct,
  _resolveDoms : _resolveDoms,

  _formConentElementDom : _formConentElementDom,
  _formConent2ElementDom : _formConent2ElementDom,
  _formContentDom : _formContentDom,
  _formContent2Dom : _formContent2Dom,


  // change

  changeEvent : changeEvent,
  _changeEvent : _changeEvent,

  touchEvent : touchEvent,
  _touchEvent : _touchEvent,


  //

  accept : accept,
  _acceptAct : _acceptAct,

  cancel : cancel,
  _cancelAct : _cancelAct,

  visibleGet : visibleGet,
  visibleSet : visibleSet,
  _visibleSetAct : _visibleSetAct,
  _visibleSetBegin : _visibleSetBegin,
  _visibleSetAnimation : _visibleSetAnimation,

  openGet : openGet,
  openSet : openSet,
  _openSetBegin : _openSetBegin,
  _openSetAnimation : _openSetAnimation,
  _openSetAct : _openSetAct,

  // etc

  centerSet : centerSet,
  soundPlay : soundPlay,
  handleStrFrom : handleStrFrom,


  //

  /* constructor * : * Self, */
  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

//

_.classDeclare
({
  cls : Self,
  extend : Proto,
  parent : Parent,
});

_.Copyable.mixin( Self );

//

// _.accessor.declare( Self.prototype,
// {
//   visible : 'visible',
//   open : 'open',
// });

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})( );