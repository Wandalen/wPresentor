( function _StringSaver_js_( ) {

'use strict';

var _ = _global_.wTools;
var Parent = null;
var Self = function wStringSaver( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'StringSaver';

//

function init( o )
{
  var self = this;

  _.instanceInit( self );

  if( Self === self.Self )
  Object.freeze( self );

  if( o )
  self.copy( o );

  _.assert( arguments.length === 0 || arguments.length === 1 );

}

//

function clean()
{
  var self = this;

  self.out = '';

  return self;
}

// --
// relationship
// --

var Composes =
{
  out : '',
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
// declare
// --

var Proto =
{

  init : init,
  clean : clean,

  //

  
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

_global_[ Self.name ] = _[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})( );
