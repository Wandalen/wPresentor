//#! /usr/bin/env node
(function _wToolsLayer1_s_(){

'use strict';

if( typeof module !== 'undefined' && module !== null )
{

  require( './layer1/aFundamental.s' );
  require( './layer1/cDiagnostics.s' );
  require( './layer1/eFieldMapper.s' );
  require( './layer1/kArrayDescriptor.s' );
  require( './layer1/zSetup.s' );
  var _global = _global_;
  var _ = _global_.wTools;
  var Self = _global_.wTools;

}

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
