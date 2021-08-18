(function wContextDropdown(){

'use strict';

var _ = _global_.wTools;
var $ = jQuery;
var Parent = null;
var Self = function wContextDropdown( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'ContextDropdown';

// var Self = function wContextDropdown( o )
// {
//   if( !( this instanceof Self ) )
//   return new( _.routineJoin( Self, Self, arguments ) );
//   return Self.prototype.init.apply( this,arguments );
// }

// --
// routine
// --

function init( options )
{
  var self = this;

  _.mapExtendConditional( _.field.mapper.srcOwnAssigning,self,Composes );
  _.mapExtendConditional( _.field.mapper.srcOwnAssigning,self,Associates );

  if( options )
  self.copy( options );

  _.assert( _.domableIs( self.containerDom ) );
  _.assert( _.domableIs( self.dropdownDom ) );

  self.containerDom = $( self.containerDom );
  self.dropdownDom = $( self.dropdownDom );

/*
  if( self.containerDom === undefined )
  self.containerDom = 'body';

  if( self.dropdownDom === undefined )
  self.dropdownDom = '.context.dropdown';

  if( self.actions === undefined )
  self.actions = [];

  self._visible = false;
*/

  //

  self.initContainer();
  self.initDropmenu();

}

//

function initContainer()
{
  var self = this;

  if( !self.manualRightClick )
  _.domHabitRightClick( self.containerDom,function( event )
  {

    return self.handleRightClick( event,this );

  });

  self.containerDom
  .bind( 'contextmenu', function( event ){

    event.preventDefault();
    return false;

  });

  self.containerDom
  .bind( _.eventName( 'mousedown' ), function( event ){

    self.hide();

  });

  $( document.body )
  .bind( 'contextmenu', function( event ){

    self.dropdownDom.dropdown( 'hide' );
    self._visible = false;

  });

}

//

function initDropmenu()
{
  var self = this;
  var dropdown = self.dropdownDom;

  dropdown
  // .dropdown( _.mapExtend( null,self.m_app.m_dropDownOptions,{
  .dropdown( _.mapExtend( null,{},{
    onChange : _.routineJoin( self,self.handleSelect ),
    duration : 100,
  }))
  /*.dropdown( 'set selected', viewOptions.defaultFieldsMap )*/
  ;

/*
  if( self.dropdown && dropdown.is( self.dropdown ) )
  return;
  self.dropdown = dropdown;
  if( !self.dropdown.length ) return;
*/

  function prevent( event )
  {
    event.preventDefault();
    return false;
  }

  dropdown.bind( _.eventName( 'click' ),prevent );
  dropdown.bind( _.eventName( 'mousedown' ),prevent );
  dropdown.bind( _.eventName( 'mouseup' ),prevent );

  dropdown.dropdown( 'setting','onHide', function(){ self._visible = false; } );
  dropdown.dropdown( 'setting','onShow', function(){ self._visible = true; } );

/*
  _.each( self.actions,function( e,k ){

    throw _.err( 'Not implemented' );

    var t = dropdown.find( k );
    //if( t.prop( 'tagName' ) === 'I' ) t = t.parent();
    //t.unbind( 'click' ).bind( 'click', function( event ){
    t.bind( _.eventName( 'click' ), function( event ){

      self._visible = false;
      dropdown.dropdown( 'hide' );
      e.call( self,event );

    });

  });
*/

}

//

function hide()
{
  var self = this;

  if( !self._visible )
  return;

  self.dropdownDom.dropdown( 'hide' );

}

//

function handleRightClick( event )
{
  var self = this;

  self._mouseEvent = event;
  if( !event.position )
  event.position = _.eventClientPosition( event );

  /*self.initDropmenu();*/

  self.dropdownDom.css
  ({
    'display' : '',
    'position' : 'absolute',
    'z-index' : '1000',
    'left' : event.position[ 0 ] + 3 + 'px',
    'top' : event.position[ 1 ] + 3 + 'px',
  })
  .dropdown( 'show' )
  ;

  self.dropdownDom.find( '.selected' ).removeClass( 'selected' );
  self.dropdownDom.find( '.active' ).removeClass( 'active' );

  self._visible = true;

  event.mouse.preventDefault();

  self.onShow( event );

  return false;
}

//

function handleSelect( value, text, dom )
{
  var self = this;
  var item = $( dom ).attr( 'data-item' );

  var e = {};
  e.dom = dom;
  e.item = item;
  e.text = text;
  e.value = value;
  e.mouse = self._mouseEvent;

  _.assert( self.onSelect.length === 1 );

  self.onSelect( e );

  return;

  self.dropdownDom.css
  ({
    'left' : '',
    'top' : '',
  });

  self.onHide( self._mouseEvent );

}

// --
// relations
// --

var Composes =
{

  containerDom : null,
  dropdownDom : null,

  onSelect : function(){},
  onShow : function(){},
  onHide : function(){},

  manualRightClick : false,
  _visible : false,

}

var Associates =
{
}

// --
// proto
// --

var Proto =
{

  init : init,
  initContainer : initContainer,
  initDropmenu : initDropmenu,

  hide : hide,

  handleRightClick : handleRightClick,
  handleSelect : handleSelect,

  // relations

  /* constructor * : * Self, */
  Composes : Composes,
  Associates : Associates,

};

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
