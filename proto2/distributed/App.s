( function _App_s_( ) {

'use strict';

let $ = jQuery;
let _ = wTools;
let Parent = wGhiAbstractModule;
let Self = function Application( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

//

function init( o )
{
  let self = this;

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
  let self = this;

  Parent.prototype._formAct.call( self );

  _.ghi.HiPresentor.exec( _.fileProvider.fileRead({ filePath : '/distributed/Document.md', sync : 0 }) );

  // _.ghi.HiPresentor.exec( theData );

  $( document.body ).removeClass( 'layout-not-ready ' );

}

// --
// relationship
// --

let Composes =
{
  dynamic : 0,
  // url : '/overview/App',
}

let Aggregates =
{
}

let Associates =
{

  targetDom : '.overview-body',

}

let Restricts =
{
}

let Statics =
{
}

// --
// proto
// --

let Proto =
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
