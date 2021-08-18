( function _Bitmask_test_s_( ) {

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

  require( '../amapping/Bitmask.s' );

}

var _ = _global_.wTools;

//

var defaultFieldsArray =
[

  { hidden : false },
  { system : false },
  { terminal : true },
  { directory : false },
  { link : true },

];

var bitmask = wBitmask
( {
  defaultFieldsArray : defaultFieldsArray
} );

//

function mapToWord( test )
{

  //default 10100

  test.case = 'simple1';
  var got = bitmask.mapToWord( { hidden : 1, terminal : 0, directory : 1 } );
  var expected = parseInt( '11001', 2 );
  test.identical( got,expected );

  test.case = 'simple2';
  var got = bitmask.mapToWord( { link : 0, system : 1 } );
  var expected = parseInt( '00110', 2 );
  test.identical( got,expected );

  test.case = 'value is -1';
  var got = bitmask.mapToWord( { hidden : -1, system : 1 } );
  var expected = parseInt( '10111', 2 );
  test.identical( got,expected );

  test.case = 'map value is bigger then 1 or 0';
  var got = bitmask.mapToWord( { hidden : -1, system : 100 } );
  var expected = parseInt( '10111', 2 );
  test.identical( got,expected );

  test.case = 'map value is str';
  var got = bitmask.mapToWord( { hidden : 'a', system : 0 } );
  var expected = parseInt( '10101', 2 );
  test.identical( got,expected );

  if( Config.debug )
  {
    test.case = 'no argument';
    test.shouldThrowError( function( )
    {
       bitmask.mapToWord(  );
    } );

    test.case = 'map is not a object';
    test.shouldThrowError( function( )
    {
       bitmask.mapToWord( [ 1, 2, 3 ] );
    } );

    test.case = 'map with unknown property';
    test.shouldThrowError( function( )
    {
       bitmask.mapToWord( { hidden : -1, system : 1, original : 1 } );
    } );
  }
}

//

function wordToMap( test )
{

  test.case = 'simple1';
  var got = bitmask.wordToMap( parseInt( '11001', 2 ) );
  var expected =
  {
     hidden : true,
     system : false,
     terminal : false,
     directory : true,
     link : true,
  }
  test.identical( got,expected );

  test.case = 'simple2';
  var got = bitmask.wordToMap( parseInt( '00110', 2 ) );
  var expected =
  {
     hidden : false,
     system : true,
     terminal : true,
     directory : false,
     link : false,
  }
  test.identical( got,expected );

  test.case = 'value is 0';
  var got = bitmask.wordToMap( 0 );
  var expected =
  {
     hidden : false,
     system : false,
     terminal : false,
     directory : false,
     link : false,
  }
  test.identical( got,expected );
  test.case = 'value is 1';
  var got = bitmask.wordToMap( 1 );
  var expected =
  {
     hidden : true,
     system : false,
     terminal : false,
     directory : false,
     link : false,
  }
  test.identical( got,expected );

  if( Config.debug )
  {
    test.case = 'no argument';
    test.shouldThrowError( function( )
    {
       bitmask.wordToMap(  );
    } );

    test.case = 'word is not a number';
    test.shouldThrowError( function( )
    {
       bitmask.wordToMap( "123" );
    } );
  }
}

//

var _defaultFieldsArraySet = function( test )
{
  bitmask = wBitmask
  ( {
    defaultFieldsArray : defaultFieldsArray
  } );

  test.case = 'defaultFieldsArray check';
  var got = bitmask.defaultFieldsArray;
  var expected =
  [
    { hidden : false },
    { system : false },
    { terminal : true },
    { directory : false },
    { link : true },
  ];
  test.identical( got,expected );

  test.case = 'names check';
  var got = bitmask.names;
  var expected =
  [
    'hidden',
    'system',
    'terminal',
    'directory',
    'link'
  ]
  test.identical( got,expected );

  test.case = 'defaultFieldsMap check';
  var got = bitmask.defaultFieldsMap;
  var expected =
  {
    hidden: false,
    system: false,
    terminal: true,
    directory: false,
    link: true
  }
  test.identical( got,expected );

  if( Config.debug )
  {
    test.case = 'set defaultFieldsArray with string ';
    test.shouldThrowError( function( )
    {
       bitmask.defaultFieldsArray = 'string';
    } );
  }
}

var Self =
{

  name : 'Tools/mid/Bitmask',
  silencing : 1,
  // verbose : 1,

  context :
  {
  },

  tests :
  {
    mapToWord : mapToWord,
    wordToMap : wordToMap,
    _defaultFieldsArraySet : _defaultFieldsArraySet
  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
