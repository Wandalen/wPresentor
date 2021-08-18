( function _LogicalExpression_test_s_( ) {

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

  require( '../agraph/l5/LogicalExpression.s' );

  _.include( 'wTesting' );

}

var _ = _global_.wTools;

// --
// tests
// --

function trivial( test )
{
  var context = this;

  test.identical( 1,1 );

  return;

  var logic = _.LogicalExpression();

  var expected =
  {
    all :
    {
      all : [ 'a', 'c', { not : 'c' }, { not : 'g' } ],
      any : [ 'c', 'e' ],
    }
  }

  var exp1 = { all : [ 'a', 'c' ], any : [ 'c', 'e' ], none : [ 'c', 'g' ] }
  var got = logic.normalize({ src : exp1 });

  debugger;

  test.is( got !== exp1 );
  test.identical( got, expected );

/*
  var xor = { or : { and : [ 'a', { not : 'b' } ], and : [ { not : 'a', 'b' ] } };
  var xor = { or : { and : [ 'a', { not : 'b' } ], and : [ { not : 'a', 'b' ] } };

  ( a and not b ) or ( not a and b )
  not( a or not b ) or not( not a or b )
  not( a or not b ) or not( not a or b )
*/

}

// --
// declaration
// --

var Self =
{

  name : 'Tools/mid/LogicalExpression',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    trivial : trivial,
  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})( );
