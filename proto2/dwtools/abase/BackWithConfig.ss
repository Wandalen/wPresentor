#! /usr/bin/env node
( function _BackWithConfig_ss_() {

'use strict';

require( './PreloadConfig.ss' );

wTools.configReadGlobally();

require( './Back.ss' );
var _global = _global_;
var _ = _global_.wTools;
var Self = _global_.wTools;

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
