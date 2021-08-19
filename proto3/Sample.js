( function _App_s_()
{

'use strict';

var $ = jQuery;
let _ = wTools;
let Parent = wGhiAbstractModule;
let Self = function Application( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

//

function init( o )
{
  var self = this;

  _.workpiece.initFields( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  _.process.ready( function()
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

  wHiPresentor.exec( _.fileProvider.fileRead({ filePath : _.path.join( _.path.current(), 'Sample.edoc' ), sync : 0 }) );

  $( document.body ).removeClass( 'layout-not-ready ' );

}

// --
// relationship
// --

var Composes =
{
  dynamic : 0,
  // url : '/overview/App',
}

var Aggregates =
{
}

var Associates =
{

  targetDom : '.overview-body',

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

  // constructor : Self,
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

wInstancing.mixin( Self );
wEventHandler.mixin( Self );

//

_global_[ Self.name ] = Self;
_global_.application = new Self();

})();
