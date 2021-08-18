( function _UseLive_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  require( './UseBase.s' );

  require( './l5_live/LiveNode.s' );
  require( './l5_live/LiveNodeIn.s' );
  require( './l5_live/LiveNodeOut.s' );
  require( './l5_live/LiveSystem.s' );

}

})();
