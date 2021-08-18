( function _App_s_( ) {

'use strict';

var $ = jQuery;
var _ = wTools;
var Parent = wGhiAbstractModule;
var Self = function Application( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

//

function init( o )
{
  var self = this;

  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  _.timeReady( function()
  {
    self.form();
  });

  return self;
}

//

function _formAct()
{
  var self = this;

  Parent.prototype._formAct.call( self );

  $( document.body ).removeClass( 'layout-not-ready ' );

}

//

// function form()
// {
//
//   _.domLoad({
//     parentDom : self.parentDom,
//     targetClass : self.classContainer,
//     url : self.urlHyperText,
//     showing : 1,
//     replacing : 0,
//   })
//   .andThen( about )
//   .doThen( function( err,target ) {
//
// }

// --
// relationship
// --

var Composes =
{
  url : '/spring_event/App',
}

var Aggregates =
{
}

var Associates =
{

  targetDom : '.landing-body',

  // targetDom : '.wbook',
  // pageDom : null,
  // headDom : null,

  // contentDomSelector : '{{targetDom}} > .content',
  // treeDomSelector : '{{targetDom}} > .content > .wtree',
  // pageDomSelector : '{{targetDom}} > .content > .page',
  // headDomSelector : '{{targetDom}} > .content > .head',

  // tree : null,

}

var Restricts =
{
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

  _formAct : _formAct,

  //

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
  extend : Proto,
  parent : Parent,
});

_.Instancing.mixin( Self );
_.EventHandler.mixin( Self );

//

_global_[ Self.name ] = Self;
_global_.application = new Self();

})( );
