(function _wToolsLayer3_s_(){

'use strict';

if( typeof module !== 'undefined' && module !== null )
{

  require( './Layer2.s' );

  var _ = _global_.wTools;
  var Self = _global_.wTools;

  _.include( 'wExternalFundamentals' );
  _.include( 'wPathFundamentals' );
  _.include( 'wTraverser' );
  _.include( 'wCloner' );
  _.include( 'wProto' );
  _.include( 'wCopyable' );
  _.include( 'wEventHandler' );
  _.include( 'wInstancing' );
  _.include( 'wConsequence' );

  try
  {
    if( typeof module !== 'undefined' && module !== null )
    require( './Back.ss' );
  }
  catch( err )
  {
  }

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
