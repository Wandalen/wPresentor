( function _SwitchBase2_s_() {

'use strict';

/*
  setTouching / setChanging / _setChanging / _set
  changeAllowed / touchEvent / changeEvent

  setTouching ( calls changeAllowed, touchEvent, _setChanging )
  setChanging ( calls changeAllowed, _setChanging )
  changeAllowed - checks if change of the state is allowed
  _setChanging ( calls changeEvent, _set ) - private routine, changes state and emits 'change' event
  _set : private routine, changes only the state, doesn't emit event and doesn't call any routine/callback
*/

var _ = _global_.wTools;
var Parent = null;
var Self = function wSwitchBase2( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'SwitchBase2';

//

// function onMixin( cls )
// {

//   var dstProto = cls.prototype;

//   _.mixinApply
//   ({
//     dstProto : dstProto,
//     descriptor : Self,
//   });

//   // Accessors

//   _.accessor( dstProto,Accessors );

//   _.assert( arguments.length === 1 );

// }

function init( o )
{
  var self = this;

  _.instanceInit( self );
  Object.preventExtensions( self );

  _.assert( arguments.length <= 1 );

  if( o )
  self.copy( o );

  // _.assert( self.state );

  var state = self.state;

  if( self.context === undefined || self.context === null )
  self.context = self;

  if( _.objectIs( self.key ) )
  self.key = _.nameUnfielded( self.key ).coded;

  if( !_.definedIs( o.stateKey ) )
  self.stateKey = self.key;

  if( _.objectIs( self.stateKey ) )
  self.stateKey = _.nameUnfielded( self.stateKey ).coded;

  if( state )
  {
    if( state[ self.stateKey ] === undefined && self.defaultContainer )
    state[ self.stateKey ] = self.defaultContainer[ self.stateKey ];

    if( state[ self.stateKey ] === undefined && self.defaultState !== null && self.defaultState !== undefined )
    state[ self.stateKey ] = self.defaultState;

    if( self.defaultState === null ||  self.defaultState === undefined )
    self.defaultState = state[ self.stateKey ];
  }

  _.assert( Self.instancesMap[ self.key ][ 0 ].stateKey === self.stateKey );
  _.assert( Self.instancesMap[ self.key ].indexOf( self ) !== -1 );

  var keysToCheck = [ 'text', 'hint', 'defaultState', 'onChangeAllowed' ];
  var instances = Self.instancesMap[ self.key ];

  if( instances.length > 1 )
  keysToCheck.forEach( ( k ) =>
  {
    if( self[ k ] === null )
    {
      self[ k ] = instances[ 0 ][ k ];
    }
    else
    {
      instances.forEach( ( instance ) =>
      {
        if( instance === self )
        return;

        if( instance[ k ] === null )
        instance[ k ] = self[ k ];
        else if( instance[ k ] !== self[ k ] )
        throw _.errLogOnce( 'Switch instances of key: ', self.key, 'must have same value of property: ', k, 'expected :', instance[ k ], 'got:', self[ k ] );
      })
    }
  })

  /* instance */

  // _.assert( !Self.instancesMap[ self.key ] || Self.instancesMap[ self.key ] === self,'wHiSwitch :','already exists',self.key );
  // Self.instancesMap[ self.key ] = self;

  /* verification */

  _.assert( _.strIs( self.stateKey ) || self.stateKey === null );
  _.assert( _.strIs( self.key ) || self.key === null );
  // _.assert( self.folderDom );
  _.assert( _.strIs( self.key ) );

  if( state )
  {
    _.assert( !self.stateKey || state[ self.stateKey ] !== undefined,'state',self.key,'is not defined' );

    if( self.stateKey && self.state[ self.stateKey ] !== undefined )
    {
      if( self.checked !== undefined && self.checked !== null && !!self.checked !== !!self.state[ self.stateKey ] )
      throw _.err( self.nickName,'o.checked should not override state value' );
      self.checked = !!self.state[ self.stateKey ];
    }
  }
}

// --
// event
// --

function changeEvent( value )
{
  var self = this;

  var e =
  {
    kind : 'change',
    checked : value,
  }

  self.eventGive( e );
}

//

function touchEvent( value )
{
  var self = this;

  var e =
  {
    kind : 'touched',
    targetDom : self.targetDom,
    checked : value,
  }

  self.eventGive( e );

  var instances = self._instancesCommonStateGet();
  instances.forEach( ( instance ) =>
  {
    if( instance !== self )
    instance.changeEvent( value );
  })
}

// --
// check
// --

function changeAllowed( value )
{
  var self = this;
  var state = self.state;

  if( !self.enabled )
  return false;

  if( state === null )
  return false;

  // _.assert( _.routineIs( self.onChangeAllowed ) );
  // _.assert( _.objectLike( self.context ) );

  // if( self.stateKey === 'scaling' )
  // debugger

  if( _.entityEquivalent( state[ self.stateKey ], value ) )
  return false;

  if( !self.onChangeAllowed )
  return true;

  var e =
  {
    checked : value,
    targetDom : self.targetDom,
    targetSwitch : self,
  }

  var allowed = self.onChangeAllowed.call( self.context, e );

  if( !_.boolIs( allowed ) )
  {
    // debugger
    _.errLogOnce( 'forceApply expects result of onChangeAllowed(', self.onChangeAllowed, '), as boolean' );
  }

  return !!allowed;
}

// --
// set
// --

//

function _set( value )
{
  var self = this;
  self.state[ self.stateKey ] = value;
  self.checked = value;
}

//

function _setChanging( value )
{
  var self = this;
  self._set( value );
  self.changeEvent( value );
}

//

function setChanging( value )
{
  var self = this;

  var allowed = self.changeAllowed( value );
  if( allowed )
  self._setChanging( value );

  return allowed;
}

//

function setTouching( value, force )
{
  var self = this;

  var allowed = self.changeAllowed( value );
  if( allowed || force )
  {
    self._setChanging( value );
    self.touchEvent( value );
  }

  return allowed;
}

//

function set( value )
{
  var self = this;

  _.assert( arguments.length && arguments.length <= 3 );

  if( arguments.length > 1 )
  {
    var key = arguments[ 0 ];
    var state = arguments[ 1 ];
    var value = arguments[ 2 ];

    var instances = Self.instancesMap[ key ];
    var instance;

    _.assert( instances && instances.length );

    if( arguments.length === 2 )
    {
      value = arguments[ 1 ];
      instance = instances[ 0 ];
      _.assert( instance._instancesCommonStateGet().length === instances.length, 'wSwitchBase2.set: Instances of key:', key, ' must have same state map.' )
    }
    else
    {
      for( var i = 0; i < instances.length; i++ )
      {
        if( instances[ i ].state === state )
        {
          instance = instances[ i ];
          break;
        }
      }
    }

    _.assert( instance instanceof Self );

    instance.setTouching( value );
  }
  else
  {
    _.assert( self instanceof Self || _.parentGet( self ) === Self );
    self.setChanging( value );
  }

  return self;
}

//

// function setMaybe( value )
// {
//   var self = this;

//   _.assert( arguments.length === 1 || arguments.length === 2 );

//   if( arguments.length === 2 )
//   {
//     var instances = Self.instancesMap[ arguments[ 0 ] ];
//     var value = arguments[ 1 ];

//     if( !instances || !instances.length )
//     {
//       Self.prototype.state[ arguments[ 0 ] ] = value;
//       return self;
//     }
//     else
//     {
//       instances.forEach( ( instance ) =>
//       {
//         instance.setChanging( value );
//       })
//     }
//   }
//   else
//   {
//     _.assert( self instanceof Self || _.parentGet( self ) === Self );
//     self.setChanging( value );
//   }

//   return self;
// }

//

function setDefaults()
{
  var self = this;

  _.assert( arguments.length <= 0 );

  if( self === Self )
  {

    for( var i in Self.instancesMap )
    {

      var instances = Self.instancesMap[ i ];

      _.assert( instances && instances.length );

      // var first = instances[ 0 ];
      // if( first.defaultState !== undefined && first.defaultState !== null )
      // if( first.changeAllowed( first.defaultState ) )
      instances.forEach( ( instance ) =>
      {
        instance.setDefaults();
      })
    }
  }
  else
  {

    _.assert( self instanceof Self || _.parentGet( self ) === Self );

    // if( self.key === 'borders' )
    // debugger;

    if( self.defaultState !== undefined && self.defaultState !== null )
    {
      // self._set( self.defaultState );
      // self.domSet( self.defaultState );

      self.setChanging( self.defaultState );
    }

  }

}

//

function forceApply( key, state )
{
  var self = this;

  _.assert( arguments.length <= 2 )

  if( arguments.length > 1 )
  {
    var instances = Self.instancesMap[ key ];
    var instance;

    _.assert( instances && instances.length );

    if( state )
    for( var i = 0; i < instances.length; i++ )
    {
      if( instances[ i ].state === state )
      instance = instances[ i ]; break;
    }

    // if( !instance )
    // {
    //   instance = instances[ 0 ];
    //   _.assert( instance._instancesCommonStateGet().length === instances.length, 'wSwitchBase2.set: Instances of key:', key, ' must have same state map.' )
    // }

    if( !instance )
    {
      // console.warn( 'wSwitchBase2.forceApply: no instances with key:', key, ' and state: ', state, ' found.' )
      return;
    }

    self = instance;

    _.assert( self instanceof Self );
  }

  var state = self.state;
  var value;

  if( state === null )
  return;

  if( self.stateKey === null )
  value = self.checked;
  else
  value = state[ self.stateKey ];

  self.setTouching( value, true );
}

//

function forceApplyAll( state )
{
  var self = this;

  _.assert( arguments.length === 1, 'wSwitchBase2.forceApplyAll: expects state map as argument' );

  for( var s in Self.instancesMap )
  {
    // if( s === 'cameraOverhead' )
    // debugger

    Self.forceApply( s, state );
  }

}

// --
// get
// --

function _get()
{
  var self = this;
  return self.state[ self.stateKey ];
}

//

function get()
{
  var self = this;

  _.assert( arguments.length <= 2 );

  if( arguments.length === 1 )
  {
    var instances = Self.instancesMap[ arguments[ 0 ] ];

    _.assert( instances.length );

    for( var i = 0; i < instances.length; i++ )
    if( instances[ i ].state )
    return instances[ i ].get();

    _.assert( 0, 'All instances with key:', arguments[ 0 ], ' have state map disconnected.' )
  }

  if( arguments.length === 2 )
  {
    var instances = Self.instancesMap[ arguments[ 0 ] ];
    var state =  arguments[ 1 ];

    _.assert( instances.length );

    for( var i = 0; i < instances.length; i++ )
    if( instances[ i ].state === state )
    return instances[ i ].get();

    _.assert( 0, 'All instances with key:', arguments[ 0 ], ' have state map disconnected.' )
  }

  _.assert( self instanceof Self || _.parentGet( self ) === Self );

  return self._get();
}

// etc

function _keyGet()
{
  var self = this;
  return self[ nameSymbol ];
}

//

function _keySet( src )
{
  var self = this;
  self.name = src;
}

//

function _instancesCommonStateGet()
{
  var self = this;

  function filter( instance )
  {
    if( instance.key === self.key && instance.state === self.state )
    return instance;
  }

  return Self.instancesByFilter( filter );
}

//

function stateMapSet( state, newValue )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectLike( state ) || state === null );
  _.assert( !self.stateMapLocked, 'wSwitchBase: switch is permanently connected to state map.' );

  self.state = state;

  if( self.state )
  {
    var value = self.state[ self.key ];

    if( arguments.length === 1 )
    {
      if( self.checked !== value )
      self.touchEvent( value );
    }
    else
    {
      if( newValue !== value )
      {
        value = newValue;
        self.touchEvent( value );
      }
    }

    self.changeEvent( value );
  }
}

// --
// relations
// --

var nameSymbol = Symbol.for( 'name' );

// --
// proto
// --

var Composes =
{
  key : null,
  text : null,
  hint : null,
  keyboard : null,
  checked : null,

  stateKey : null,

  defaultContainer : null,
  defaultState : null,

  onChangeAllowed : null,

  stateMapLocked : false,
  enabled : true
}

var Associates =
{
  context : null,
  state : null,
}

var Medials =
{
  onChange : null
}

var Restricts =
{
}

var Statics =
{
  usingUniqueNames : 0,

  set : set,
  // setMaybe : setMaybe,
  setDefaults : setDefaults,

  forceApply : forceApply,
  forceApplyAll : forceApplyAll,
}

var Events =
{
  'change' : 'change',
  'touched' : 'touched',
}

var Functor =
{
}

var Accessors =
{
  key : 'key',
}

var Proto =
{
  init : init,
  changeEvent : changeEvent,
  touchEvent : touchEvent,

  changeAllowed : changeAllowed,

  _set : _set,
  _setChanging : _setChanging,
  setChanging : setChanging,
  setTouching : setTouching,
  set : set,
  // setMaybe : setMaybe,
  setDefaults : setDefaults,

  forceApply : forceApply,
  forceApplyAll : forceApplyAll,

  _get : _get,
  get : get,

  //

  _keyGet : _keyGet,
  _keySet : _keySet,

  _instancesCommonStateGet : _instancesCommonStateGet,

  stateMapSet : stateMapSet,

  Composes : Composes,
  Associates : Associates,
  Medials : Medials,
  Restricts : Restricts,
  Statics : Statics,
  Events : Events,
}

//

// var Self =
// {

//   onMixin : onMixin,

//   functor : Functor,
//   supplement : Supplement,
//   extend : Extend,

//   name : 'wSwitchBase2',
//   shortName : 'SwitchBase2',

// }

var Self = _.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto
});

_.accessor( Self.prototype,Accessors );

_.Copyable.mixin( Self );
_.EventHandler.mixin( Self );
_.Instancing.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_global_[ Self.name ] = _[ Self.shortName ] = Self;

})();
