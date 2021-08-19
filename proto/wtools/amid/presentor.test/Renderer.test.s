( function _Renderer_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  _.include( 'wTesting' );
  require( '../presentor/Renderer.s' );
}

const _ = _global_.wTools;

// --
// tests
// --

function trivial( test )
{
  test.true( true );
}

// --
// declare
// --

const Proto =
{

  name : 'Tools.ghi.Renderer',
  silencing : 1,
  enabled : 1,

  tests :
  {
    trivial,
  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

