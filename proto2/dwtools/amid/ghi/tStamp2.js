( function _tStamp2_js_(){

'use strict';

var $ = jQuery;
var _ = _global_.wTools;
var Parent = wHiSwitch2;
var Self = function wHiStamp2( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else if( Self._modifiers[ o.key ] )
  return Self._modifiers[ o.key ].init( o );
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.shortName = 'HiStamp2';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( this,o );

  return self;
}

//

function form( o )
{
  var self = this;

  if( o )
  self.copy( o );

  Parent.prototype.form.call( self );

  _.assert( _.domableIs( self.domForStamps ),'expects domForStamps' );

  self.domForStamps = $( self.domForStamps );
  _.assert( self.domForStamps.length );

  self.initStampDom();
  self.initStampData( self );
}

//

function initStampData()
{
  var self = this;

  var key = self.key;
  _.assert( _.strIs( key ) );

  if( self._inited )
  return;

  if( self._modifiers[ key ] !== undefined )
  debugger;

  if( self._modifiers[ key ] !== undefined )
  throw _.err( 'modifier',key,'already defined' );

  self._modifiers[ key ] = self;

  self._inited = true;
}

//

function initStampDom()
{
  var self = this;

  _.assert( _.jqueryIs( self.domForStamps ) );
  var domForStamps = self.domForStamps;

  var modifier = self;

  if( modifier._initStampDomDone )
  return;

  _.assert( _.strIs( modifier.icon ),'expects icon css class' );
  _.assert( _.strIs( modifier.key ),'expects key as string' );

  var iconHtml = '<i data-content="' + ( modifier.cancelHint ? modifier.cancelHint : '' ) + '" class="icons-buttons ui large icon ' + modifier.icon + ' reactive modifier modifier-' + modifier.key + '"></i>';
  modifier.iconDom = $( iconHtml );
  domForStamps.append( modifier.iconDom );

  $( '.icon.modifier-' + modifier.key )
  .bind( _.eventName( 'mousedown' ),function()
  {
    return false;
  });

  $( '.switch.modifier-' + modifier.key )
  .bind( _.eventName( 'mouseup' ),_.routineJoin( self, modifier._handleStampSet ) );

  $( '.icon.modifier-' + modifier.key )
  .bind( _.eventName( 'mouseup' ),_.routineJoin( self, modifier._handleStampSet ) );

  domForStamps.find( '.modifier[data-content]' ).popup
  ({
    'position' : 'top center'
  });

  modifier._initStampDomDone = true;

  // if( self.stateKey === 'scaling' )
  // debugger

  self.on( 'change', self._stampDomUpdate );

}

//

function _stampDomUpdate()
{
  var self = this;
  var state = self.state;
  var stateKey = self.stateKey;
  var key = self.key;

  // debugger

  if( state[ stateKey ] )
  $( '.switch-' + key ).addClass( 'active' );
  else $( '.switch-' + key ).removeClass( 'active' );

  if( state[ stateKey ] )
  $( '.icons-buttons.modifier-'+key ).addClass( 'force-visible' );
  else $( '.icons-buttons.modifier-'+key ).removeClass( 'force-visible' );

  if( state[ stateKey ] )
  $( '.icons-buttons.modifier-'+key ).addClass( 'animation-blow' );
  else $( '.icons-buttons.modifier-'+key ).removeClass( 'animation-blow' );
}

// --
// set
// --

function set()
{
  var self = this;
  var value, force;

  if( self instanceof Self )
  {
    value = arguments[ 0 ];
    force = arguments[ 1 ];
    _.assert( arguments.length === 1 || arguments.length === 2 );
  }
  else
  {
    value = arguments[ 1 ];
    force = arguments[ 2 ];
    // self = self.instances[ arguments[ 0 ] ];
    self = self.instanceByName(  arguments[ 0 ] );
    _.assert( arguments.length === 2 || arguments.length === 3 );
    _.assert( self,'instance not found' );
  }

  /**/

  self._handleStampSetAct( value,force );

  // Parent.prototype.set.call( self,value );

}

//

function _handleStampSet( event,force )
{
  var self = this;
  var state = self.state;
  var stateKey = self.stateKey;
  var newValue = null;

  //console.log( '_handleStampSet' );

  _.assert( self instanceof Self );

  if( arguments.length === 0 )
  {
    event = self.targetDom;
  }

  if( _.domableIs( event ) )
  {
    if( event.checked === undefined )
    event = _.domFirstOf( event,'input' );
    _.assert( event );
    _.assert( event.checked !== undefined );
    _.assert( arguments.length <= 2 );
    newValue = !!event.checked;
  }
  else if( _.eventIs( event ) )
  {
      _.assert( arguments.length === 1 );
    if( $( event.currentTarget ).hasClass( 'button' ) )
    newValue = !state[ stateKey];
    else newValue = false;
  }
  else if( _.boolIs( event ) || _.numberIs( event ) )
  {
    _.assert( arguments.length === 1 );
    newValue = !!event;
  }
  else throw _.err( 'unexpected' );

  self._handleStampSetAct( newValue,force );

}

//

function _handleStampSetAct( value,force )
{
  var self = this;

  // if( self.key === 'scaling' )
  // debugger;

  _.assert( arguments.length === 2 );

  // var allowed = self.changeAllowed( value );

  // if( !allowed && !force )
  // return;

  // self._setChanging( value );

  self.setTouching( value, force );

}

// function _handleStampSetAct( value,force )
// {
//   var self = this;

//   _.assert( arguments.length === 2 );

//   // var value, force;
//   //
//   // if( self instanceof Self )
//   // {
//   //   value = arguments[ 0 ];
//   //   force = arguments[ 1 ];
//   //   _.assert( arguments.length === 1 || arguments.length === 2 );
//   // }
//   // else
//   // {
//   //   value = arguments[ 1 ];
//   //   force = arguments[ 2 ];
//   //   self = self.instances[ arguments[ 0 ] ];
//   //   _.assert( arguments.length === 2 || arguments.length === 3 );
//   //   _.assert( self,'instance not found' );
//   // }

//   /**/

//   var value = !!value;
//   var state = self.state;
//   var stateKey = self.stateKey;
//   var key = self.key;

//   if( value === state[ stateKey ] && !force )
//   return;

//   // state[ stateKey ] = self.onSet.call( self.context,value );
//   var result = self.onSet.call( self.context,{ checked : value });
//   if( !_.boolIs( state[ stateKey ] ) && !state[ stateKey ] )
//   {
//     debugger;
//     state[ stateKey ] = self.onSet.call( self,value );
//     throw _.err( 'modifier.onSet should return true or false' );
//   }

//   if( result || force )
//   state[ stateKey ] = value;

//   if( state[ stateKey ] )
//   $( '.switch-' + key ).addClass( 'active' );
//   else $( '.switch-' + key ).removeClass( 'active' );

//   if( state[ stateKey ] )
//   $( '.icons-buttons.modifier-'+key ).addClass( 'force-visible' );
//   else $( '.icons-buttons.modifier-'+key ).removeClass( 'force-visible' );

//   if( state[ stateKey ] )
//   $( '.icons-buttons.modifier-'+key ).addClass( 'animation-blow' );
//   else $( '.icons-buttons.modifier-'+key ).removeClass( 'animation-blow' );

// }

// --
// relations
// --

var Composes =
{

  cancelHint : null,
  icon : null,

}

var Associates =
{

  iconDom : null,

}

var Restricts =
{

  _inited : 0,
  _initStampDomDone : null,

}

var Statics =
{
  set : set,
  _modifiers : {},
}

// --
// proto
// --

var Proto =
{

  init : init,

  form : form,

  initStampData : initStampData,
  initStampDom : initStampDom,
  _stampDomUpdate : _stampDomUpdate,

  // set

  set : set,

  handleSet : _handleStampSet,
  _handleStampSet : _handleStampSet,

  _handleStampSetAct : _handleStampSetAct,

  // relations

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
  parent : Parent,
  extend : Proto,
  // supplement : { Statics : Proto },
});

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
