( function _Common_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../UseBase.s' );

}

//

var _ = _global_.wTools;
var Parent = null;
var Self = _global_.wTools.graph;
_.assert( !!Self );

// var Self = _global_.wTools.graph = _global_.wTools.graph || Object.create( null );

// --
// inter
// --

// --
// declare
// --

var Proto =
{
}

//

_.mapExtend( Self, Proto );

})();
