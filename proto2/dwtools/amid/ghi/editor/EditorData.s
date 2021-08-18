( function _EditorData_s_( ) {

'use strict';

var _ = _global_.wTools;
var Parent = null;
var Self = function wEditorData( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'EditorData';

//

function init()
{
  var self = this;

  _.Copyable.prototype.init.apply( self,arguments );

}

//

function _rawSet( src )
{
  var self = this;

  self[ symbolForRaw ] = src;

  if( src )
  self.lines = src.split( '\n' );
  else
  self.lines = [];

}

// --
// relationship
// --

var symbolForRaw = Symbol.for( 'raw' );

var Composes =
{
  raw : null,
  lines : null,
  firstLine : 1,
}

var Aggregates =
{
}

var Associates =
{
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

  _rawSet : _rawSet,

  //

  /* constructor * : * Self, */
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

_.Copyable.mixin( Self );

//

_.accessor( Self.prototype,
{

  raw : 'raw',

});

//

_global_[ Self.name ] = _[ Self.shortName ] = Self;

})( );
