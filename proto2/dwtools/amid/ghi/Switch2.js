( function _Switch2_js_(){

'use strict';

var $ = jQuery;
var _ = _global_.wTools;
var Parent = null;

var $ = typeof jQuery !== 'undefined' ? jQuery : null;
var _ = _global_.wTools;
var Parent = wSwitchBase2;
var Self = function wHiSwitch2( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'HiSwitch2';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self, o );

  /* */
}

//

function form()
{
  var self = this;

  if( !self.bodyDom )
  self.bodyDom = $( document.body );

  _.assert( _.strIs( self.folderDom ) || _.domLike( self.folderDom ) );

  if( !self.folderDomStr )
  self.folderDomStr =  self.folderDom;

  if( !self.folderDom.length )
  self.folderDom = self.folderDomStr;

  var folderDom = _.strIs( self.folderDom ) ? self.bodyDom.find( self.folderDom ) : $( self.folderDom );
  _.assert( self.folderDom.length,'no DOM found for {folderDom}',folderDom );
  self.folderDom = folderDom;

  /* keyboard */

  if( typeof Mousetrap !== 'undefined' && self.keyboard )
  Mousetrap.bind( self.keyboard, function()
  {
    _.assert( !self.finitedIs() );
    targetDom.checkbox( 'toggle' );
  });

  /* targetDom */

  var key = self.key;
  var stateKey = self.stateKey;
  var selector = '.switch[' + 'key=' + key + ']';
  var targetDom = folderDom.find( selector );
  if( !targetDom.length )
  {

    var htmlCode = self.onViewSwitch( self );
    var targetDom = $( htmlCode );
    folderDom.append( targetDom );
    targetDom = self.targetDom = targetDom.filter( selector );

    _.assert( targetDom.length,'wHiSwitch2 :','no DOM found :',selector );

  }
  else
  {

    targetDom.find( 'input[' + 'key=' + key + ']' ).attr( 'checked',self.checked );

  }

  /* targetDom */

  targetDom.checkbox
  ({
    onChange : function()
    {
      var targetDom = _.domFirstOf( self.targetDom,'input' );
      _.assert( _.domIs( targetDom ) );

      self.checked = targetDom.checked;
      self.setTouching( targetDom.checked )
    }
  });

  self.targetDom = targetDom;

  // targetDom.each( function( k,e )
  // {
  //   self.forceApply();
  // });

  /* popup */

  self._popupMake();

}

//

function _popupMake()
{
  var self = this;

  if( !self.targetDom || !self.targetDom.length )
  return;

  self.targetDom.popup( 'destroy' );

  var khint = '';
  if( self.keyboard )
  khint = 'Keyboard : ' + ( _.arrayIs( self.keyboard ) ? self.keyboard[ 0 ] : self.keyboard );

  var popupHtml = '<div class="content">' + self.hint + '\n<span class="shortcut">' + khint + '</span>' + '</div>';
  var popupOptions = _.uiPopupDefaults( self.targetDom );
  popupOptions[ 'exclusive' ] = false;
  popupOptions[ 'html' ] = popupHtml;
  self.targetDom.popup( popupOptions );

}

//

function changeEvent( value )
{
  var self = this;

  if( self.targetDom && self.domSet )
  self.domSet( value );

  Parent.prototype.changeEvent.call( self, value );
}

//

function domSet( value )
{
  var self = this;

  var targetDom = self.targetDom;
  _.assert( targetDom.length,'wHiSwitch2 :','has no targetDom' );

  // if( self.key ==='borders' )
  // debugger

  self.checked = !!value;

  if( self.checked )
  targetDom.checkbox( 'set checked' );
  else
  targetDom.checkbox( 'set unchecked' );
}

//

function domGet()
{
  var self = this;

  _.assert( self.targetDom.length,'wHiSwitch2 :','has no targetDom' );

  var targetDom = _.domFirstOf( self.targetDom,'input' );
  return targetDom.checked;
}

//

function _textSet( value )
{
  var self = this;

  var changed = self[ textSymbol ] !== value;

  if( !changed )
  return;

  self[ textSymbol ] = value;

  if( self.targetDom && self.targetDom.length )
  {
    var label = self.targetDom.find( 'label' );
    _.assert( label.length );
    label.text( value );
  }
}

function _hintSet( value )
{
  var self = this;

  var changed = self[ hintSymbol ] !== value;

  if( !changed )
  return;

  self[ hintSymbol ] = value;

  if( self.targetDom && self.targetDom.length )
  {
    self._popupMake();
  }
}


//

var textSymbol = Symbol.for( 'text' );
var hintSymbol = Symbol.for( 'hint' );

// --
// relations
// --

var Composes =
{
  onViewSwitch : function() { return viewSwitch.apply( this,arguments ); },
}

var Aggregates =
{
}

var Associates =
{
  domForStamps : null,
  bodyDom : null,
  targetDom : null,
  folderDom : null,
  folderDomStr : null,
}

var Statics =
{
  SwitchEnabled : 1,
}

var Events =
{
}

var Accessors =
{
  text : 'text',
  hint : 'hint',
}

// --
// proto
// --

var Proto =
{

  init : init,
  form : form,

  _popupMake : _popupMake,

  changeEvent : changeEvent,

  domSet :domSet,
  domGet : domGet,

  _textSet : _textSet,
  _hintSet : _hintSet,

  // relations

  /* constructor * : * Self, */
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Events : Events,
  Statics : Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.accessor( Self.prototype,Accessors );

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
