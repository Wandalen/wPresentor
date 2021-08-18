( function _Regexp_test_s_( ) {

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

// --
// routines
// --

function regexpsAreIdentical( test )
{
  var context = this;

  /* */

  test.case = 'null';

  var expected = false;
  var got = _.regexpsAreIdentical( null, null );
  test.identical( got, expected );

  /* */

  test.case = 'null and regexp';

  var expected = false;
  var got = _.regexpsAreIdentical( /x/, null );
  test.identical( got, expected );

  /* */

  test.case = 'same string';

  var expected = false;
  var got = _.regexpsAreIdentical( 'x','x' );
  test.identical( got, expected );

  /* */

  test.case = 'same regexp';
  var expected = true;
  var got = _.regexpsAreIdentical( /abc/iy, /abc/yi );
  test.identical( got, expected );

  /* */

  test.case = 'not identical regexp, different flags';
  var expected = false;
  var got = _.regexpsAreIdentical( /abc/i, /abc/ );
  test.identical( got, expected );

  /* */

  test.case = 'not identical regexp, different source';
  var expected = false;
  var got = _.regexpsAreIdentical( /abcd/i, /abc/i );
  test.identical( got, expected );

  /* */

  test.case = 'not identical regexp';
  var expected = false;
  var got = _.regexpsAreIdentical( /abcd/y, /abc/i );
  test.identical( got, expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'none argument';

  test.shouldThrowErrorSync( () => _.regexpsAreIdentical() );

  test.case = 'too many arguments';

  test.shouldThrowErrorSync( () => _.regexpsAreIdentical( /abc/i, /def/i, /a/i ) );

}

//

function regexpsSources( test )
{
  var context = this;

  /* */

  test.case = 'empty';

  var expected =
  {
    sources : [],
    flags : null,
    escaping : 0,
  }
  var got = _.regexpsSources([]);
  test.identical( got, expected );

  /* */

  test.case = 'single string';

  var r1 = 'abc';
  var expected =
  {
    sources : [ 'abc' ],
    flags : null,
    escaping : 0
  }
  var got = _.regexpsSources([ r1 ]);
  test.identical( got, expected );

  /* */

  test.case = 'single regexp';

  var r1 = /abc/i;
  var expected =
  {
    sources : [ 'abc' ],
    flags : 'i',
    escaping : 0
  }
  var got = _.regexpsSources([ r1 ]);
  test.identical( got, expected );

  /* */

  test.case = 'all strings';

  var r1 = 'abc';
  var r2 = 'def';
  var r3 = '.+';
  var expected =
  {
    sources : [ 'abc', 'def', '.+' ],
    flags : null,
    escaping : 0
  }
  var got = _.regexpsSources([ r1, r2, r3 ]);
  test.identical( got, expected );

  /* */

  test.case = 'strings with regexps';

  var r1 = 'abc';
  var r2 = /def/;
  var r3 = /.+/;
  var expected =
  {
    sources : [ 'abc', 'def', '.+' ],
    flags : '',
    escaping : 0
  }
  var got = _.regexpsSources([ r1, r2, r3 ]);
  test.identical( got, expected );

  /* */

  test.case = 'strings with regexps and flags i';

  var r1 = 'abc';
  var r2 = /def/i;
  var r3 = /.+/i;
  var expected =
  {
    sources : [ 'abc', 'def', '.+' ],
    flags : 'i',
    escaping : 0
  }
  var got = _.regexpsSources([ r1, r2, r3 ]);
  test.identical( got, expected );

  /* */

  test.case = 'strings with regexps and flags iy';

  var r1 = /abc/iy;
  var r2 = 'def';
  var r3 = /.+/yi;
  var expected =
  {
    sources : [ 'abc', 'def', '.+' ],
    flags : 'iy',
    escaping : 0
  }
  var got = _.regexpsSources([ r1, r2, r3 ]);
  test.identical( got, expected );

  /* */

  test.case = 'empty in map';

  var expected =
  {
    sources : [],
    flags : null,
    escaping : 0
  }
  var o =
  {
    sources : []
  }
  var got = _.regexpsSources( o );
  test.identical( got, expected );
  test.is( o === got );

  /* */

  test.case = 'strings with regexps and flags iy in map';

  var r1 = /abc/iy;
  var r2 = 'def';
  var r3 = /.+/yi;
  var expected =
  {
    sources : [ 'abc', 'def', '.+' ],
    flags : 'iy',
    escaping : 0
  }
  var o =
  {
    sources : [ r1, r2, r3 ],
  }
  var got = _.regexpsSources( o );
  test.identical( got, expected );
  test.is( o === got );

  /* */

  test.case = 'options map with flags';

  var r1 = /abc/i;
  var r2 = 'def';
  var r3 = /.+/i;
  var expected =
  {
    sources : [ 'abc', 'def', '.+' ],
    flags : 'i',
    escaping : 0
  }
  var o =
  {
    sources : [ r1, r2, r3 ],
    flags : 'i',
  }
  var got = _.regexpsSources( o );
  test.identical( got, expected );
  test.is( o === got );

  /* */

  if( !Config.debug )
  return;

  test.case = 'none argument';

  test.shouldThrowErrorSync( () => _.regexpsSources() );

  test.case = 'strings with different flags';

  test.shouldThrowErrorSync( () => _.regexpsSources([ /abc/i, /def/iy ]) );

  test.case = 'too many arguments';

  test.shouldThrowErrorSync( () => _.regexpsSources( 'ab', 'cd' ) );

  test.case = 'different flags in map';

  test.shouldThrowErrorSync( () => _.regexpsSources({ sources : [ /abc/i ], flags : 'y' }) );

}

//

function regexpsJoin( test )
{
  var context = this;

  /* */

  test.case = 'empty';

  var expected = new RegExp( '','' );
  var got = _.regexpsJoin([]);
  test.identical( got, expected );

  /* */

  test.case = 'single string';

  var r1 = 'abc';
  var expected = /abc/;
  var got = _.regexpsJoin([ r1 ]);
  test.identical( got, expected );

  /* */

  test.case = 'single regexp';

  var r1 = /abc/i;
  var expected = /abc/i;
  var got = _.regexpsJoin([ r1 ]);
  test.identical( got, expected );
  test.is( got === r1 );

  /* */

  test.case = 'all strings';

  var r1 = 'abc';
  var r2 = 'def';
  var r3 = '.+';
  var expected = /abcdef.+/;
  var got = _.regexpsJoin([ r1, r2, r3 ]);
  test.identical( got, expected );

  /* */

  test.case = 'strings with regexps';

  var r1 = 'abc';
  var r2 = /def/;
  var r3 = /.+/;
  var expected = /abcdef.+/;
  var got = _.regexpsJoin([ r1, r2, r3 ]);
  test.identical( got, expected );

  /* */

  test.case = 'strings with regexps and flags i';

  var r1 = 'abc';
  var r2 = /def/i;
  var r3 = /.+/i;
  var expected = /abcdef.+/i;
  var got = _.regexpsJoin([ r1, r2, r3 ]);
  test.identical( got, expected );

  /* */

  test.case = 'strings with regexps and flags iy';

  var r1 = /abc/iy;
  var r2 = 'def';
  var r3 = /.+/yi;
  var expected = /abcdef.+/iy;
  var got = _.regexpsJoin([ r1, r2, r3 ]);
  test.identical( got, expected );

  /* */

  test.case = 'empty in map';

  var o =
  {
    sources : [],
    flags : null,
  }
  var expected = new RegExp( '','' );
  var got = _.regexpsJoin( o );
  test.identical( got, expected );

  /* */

  test.case = 'strings with regexps and flags iy in map';

  var r1 = /abc/iy;
  var r2 = 'def';
  var r3 = /.+/yi;
  var expected = /abcdef.+/iy;
  var o =
  {
    sources : [ r1, r2, r3 ],
  }
  var got = _.regexpsJoin( o );
  test.identical( got, expected );

  /* */

  test.case = 'options map with flags';

  var r1 = /abc/i;
  var r2 = 'def';
  var r3 = /.+/i;
  var expected = /abcdef.+/i;
  var o =
  {
    sources : [ r1, r2, r3 ],
    flags : 'i',
  }
  var got = _.regexpsJoin( o );
  test.identical( got, expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'none argument';

  test.shouldThrowErrorSync( () => _.regexpsJoin() );

  test.case = 'strings with different flags';

  test.shouldThrowErrorSync( () => _.regexpsJoin([ /abc/i, /def/iy ]) );

  test.case = 'too many arguments';

  test.shouldThrowErrorSync( () => _.regexpsJoin( 'ab', 'cd' ) );

  test.case = 'different flags in map';

  test.shouldThrowErrorSync( () => _.regexpsJoin({ sources : [ /abc/i ], flags : 'y' }) );

}

//

function regexpsAtLeastFirst( test )
{
  var context = this;

  test.case = 'empty';

  var expected = new RegExp( '' );
  var got = _.regexpsAtLeastFirst([]);
  test.identical( got, expected );

  test.case = 'single regexp';

  var r1 = /.+/i;
  var expected = /.+/i;
  var got = _.regexpsAtLeastFirst([ r1 ]);
  test.identical( got, expected );
  test.is( got === r1 );

  test.case = 'strings';

  var r1 = 'abc';
  var r2 = 'def';
  var expected = /abc(?:def)?/;
  var got = _.regexpsAtLeastFirst([ r1, r2 ]);
  test.identical( got, expected );

  test.case = 'strings and regexps';

  var r1 = 'abc';
  var r2 = 'def';
  var r3 = /.+/i;
  var expected = /abc(?:def(?:.+)?)?/i;
  var got = _.regexpsAtLeastFirst([ r1, r2, r3 ]);
  test.identical( got, expected );

  test.case = 'strings and regexps and flags';

  var r1 = 'abc';
  var r2 = 'def';
  var r3 = /.+/i;
  var expected = /abc(?:def(?:.+)?)?/i;
  var got = _.regexpsAtLeastFirst({ sources : [ r1, r2, r3 ], flags : 'i' });
  test.identical( got, expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'none argument';

  test.shouldThrowErrorSync( () => _.regexpsAtLeastFirst() );

  test.case = 'strings with different flags';

  test.shouldThrowErrorSync( () => _.regexpsAtLeastFirst([ /abc/i, /def/iy ]) );

  test.case = 'too many arguments';

  test.shouldThrowErrorSync( () => _.regexpsAtLeastFirst( 'ab', 'cd' ) );

  test.case = 'different flags in map';

  test.shouldThrowErrorSync( () => _.regexpsAtLeastFirst({ sources : [ /abc/i ], flags : 'y' }) );

}

//

function regexpsNone( test )
{
  var context = this;

  test.case = 'empty';

  var expected = /^(?:(?!(?:)).)+$/;
  var got = _.regexpsNone([]);
  test.identical( got, expected );

  test.case = 'single regexp';

  var r1 = /.+/i;
  var expected = /^(?:(?!(?:.+)).)+$/i;
  var got = _.regexpsNone([ r1 ]);
  test.identical( got, expected );
  test.is( got !== r1 );

  test.case = 'strings';

  var r1 = 'abc';
  var r2 = 'def';
  var expected = /^(?:(?!(?:abc)|(?:def)).)+$/;
  var got = _.regexpsNone([ r1, r2 ]);
  test.identical( got, expected );

  test.case = 'strings and regexps';

  var r1 = 'abc';
  var r2 = 'def';
  var r3 = /.+/i;
  var expected = /^(?:(?!(?:abc)|(?:def)|(?:.+)).)+$/i;
  var got = _.regexpsNone([ r1, r2, r3 ]);
  test.identical( got, expected );

  test.case = 'strings and regexps and flags';

  var r1 = 'abc';
  var r2 = 'def';
  var r3 = /.+/i;
  var expected = /^(?:(?!(?:abc)|(?:def)|(?:.+)).)+$/i;
  var got = _.regexpsNone({ sources : [ r1, r2, r3 ], flags : 'i' });
  test.identical( got, expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'none argument';

  test.shouldThrowErrorSync( () => _.regexpsNone() );

  test.case = 'strings with different flags';

  test.shouldThrowErrorSync( () => _.regexpsNone([ /abc/i, /def/iy ]) );

  test.case = 'too many arguments';

  test.shouldThrowErrorSync( () => _.regexpsNone( 'ab', 'cd' ) );

  test.case = 'different flags in map';

  test.shouldThrowErrorSync( () => _.regexpsNone({ sources : [ /abc/i ], flags : 'y' }) );

}

//

function regexpsAny( test )
{
  var context = this;

  test.case = 'empty';

  var expected = /(?:)/;
  var got = _.regexpsAny([]);
  test.identical( got, expected );

  test.case = 'single regexp';

  var r1 = /.+/i;
  var expected = /.+/i;
  var got = _.regexpsAny([ r1 ]);
  test.identical( got, expected );
  test.is( got === r1 );

  test.case = 'strings';

  var r1 = 'abc';
  var r2 = 'def';
  var expected = /(?:abc)|(?:def)/;
  var got = _.regexpsAny([ r1, r2 ]);
  test.identical( got, expected );

  test.case = 'strings and regexps';

  var r1 = 'abc';
  var r2 = 'def';
  var r3 = /.+/i;
  var expected = /(?:abc)|(?:def)|(?:.+)/i;
  var got = _.regexpsAny([ r1, r2, r3 ]);
  test.identical( got, expected );

  test.case = 'strings and regexps and flags';

  var r1 = 'abc';
  var r2 = 'def';
  var r3 = /.+/i;
  var expected = /(?:abc)|(?:def)|(?:.+)/i;
  var got = _.regexpsAny({ sources : [ r1, r2, r3 ], flags : 'i' });
  test.identical( got, expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'none argument';

  test.shouldThrowErrorSync( () => _.regexpsAny() );

  test.case = 'strings with different flags';

  test.shouldThrowErrorSync( () => _.regexpsAny([ /abc/i, /def/iy ]) );

  test.case = 'too many arguments';

  test.shouldThrowErrorSync( () => _.regexpsAny( 'ab', 'cd' ) );

  test.case = 'different flags in map';

  test.shouldThrowErrorSync( () => _.regexpsAny({ sources : [ /abc/i ], flags : 'y' }) );

}

//

function regexpsAll( test )
{
  var context = this;

  test.case = 'empty';

  var expected = new RegExp( '' );
  var got = _.regexpsAll([]);
  test.identical( got, expected );

  test.case = 'single regexp';

  var r1 = /.+/i;
  var expected = /.+/i;
  var got = _.regexpsAll([ r1 ]);
  test.identical( got, expected );
  test.is( got === r1 );

  test.case = 'strings';

  var r1 = 'abc';
  var r2 = 'def';
  var expected = /(?=abc)(?:def)/;
  var got = _.regexpsAll([ r1, r2 ]);
  test.identical( got, expected );

  test.case = 'strings and regexps';

  var r1 = 'abc';
  var r2 = 'def';
  var r3 = /.+/i;
  var expected = /(?=abc)(?=def)(?:.+)/i;
  var got = _.regexpsAll([ r1, r2, r3 ]);
  test.identical( got, expected );

  test.case = 'strings and regexps and flags';

  var r1 = 'abc';
  var r2 = 'def';
  var r3 = /.+/i;
  var expected = /(?=abc)(?=def)(?:.+)/i;
  var got = _.regexpsAll({ sources : [ r1, r2, r3 ], flags : 'i' });
  test.identical( got, expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'none argument';

  test.shouldThrowErrorSync( () => _.regexpsAll() );

  test.case = 'strings with different flags';

  test.shouldThrowErrorSync( () => _.regexpsAll([ /abc/i, /def/iy ]) );

  test.case = 'too many arguments';

  test.shouldThrowErrorSync( () => _.regexpsAll( 'ab', 'cd' ) );

  test.case = 'different flags in map';

  test.shouldThrowErrorSync( () => _.regexpsAll({ sources : [ /abc/i ], flags : 'y' }) );

}

// --
// suite definition
// --

var Self =
{

  name : 'Tools/base/layer1/Regexp',
  silencing : 1,

  tests :
  {

    regexpsAreIdentical : regexpsAreIdentical,

    regexpsSources : regexpsSources,
    regexpsJoin : regexpsJoin,
    regexpsAtLeastFirst : regexpsAtLeastFirst,

    regexpsNone : regexpsNone,
    regexpsAny : regexpsAny,
    regexpsAll : regexpsAll,

  }

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
