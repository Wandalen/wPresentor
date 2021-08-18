( function _UseBase_s_( ) {

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

  _.include( 'wProto' );
  _.include( 'wCopyable' );
  // _.include( 'wMathSpace' );

}

//

var _ = _global_.wTools;
var Parent = null;
var Self = _global_.wTools.graph = _global_.wTools.graph || Object.create( null );

//

})();
