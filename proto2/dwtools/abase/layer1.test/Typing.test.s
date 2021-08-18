( function _Typing_test_s_( ) {

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

  _.include( 'wTesting' );

}
var _global = _global_;
var _ = _global_.wTools;

//

function objectLike( t )
{
  debugger;

  t.description = 'array-like entities should not overlap with array-like entities set';

  t.identical( _.objectLike( new ArrayBuffer( 10 ) ),false );
  t.identical( _.objectLike( new Float32Array( 10 ) ),false );
  t.identical( _.objectLike( new Int32Array( 10 ) ),false );
  t.identical( _.objectLike( new DataView( new ArrayBuffer( 10 ) ) ),false );
  t.identical( _.objectLike( new Array( 10 ) ),false );
  t.identical( _.objectLike( [ 1,2,3 ] ),false );
  t.identical( _.objectLike( new Map ),false );

  t.description = 'this entities are object-like';

  t.identical( _.objectLike( _global_ ),true );
  t.identical( _.objectLike( new Object() ),true );
  t.identical( _.objectLike( {} ),true );
  t.identical( _.objectLike( Object.create( null ) ),true );

  debugger;
}

//

function promiseIs( test )
{
  test.case = 'check if entity is a Promise';

  test.is( !_.promiseIs() );
  test.is( !_.promiseIs( {} ) );

  var _Promise = function Promise(){};
  test.is( !_.promiseIs( new _Promise() ) );

  test.is( _.promiseIs( Promise.resolve( 0 ) ) );

  var promise = new Promise( ( resolve, reject ) => { resolve( 0 ) } )
  test.is( _.promiseIs( promise ) );
}

//

function consequenceLike( test )
{
  test.case = 'check if entity is a consequenceLike';

  if( !_.consequenceLike )
  return test.identical( true,true );

  test.is( !_.consequenceLike() );
  test.is( !_.consequenceLike( {} ) );
  if( _.Consequence )
  {
    test.is( _.consequenceLike( new _.Consequence() ) );
    test.is( _.consequenceLike( _.Consequence() ) );
  }
  test.is( _.consequenceLike( Promise.resolve( 0 ) ) );

  var promise = new Promise( ( resolve, reject ) => { resolve( 0 ) } )
  test.is( _.consequenceLike( promise ) );
  test.is( _.consequenceLike( wConsequence.from( promise ) ) );

}

//

var Self =
{

  name : 'Tools/base/layer1/Typing',
  silencing : 1,

  tests :
  {

    objectLike : objectLike,
    promiseIs : promiseIs,
    consequenceLike : consequenceLike

  }

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
