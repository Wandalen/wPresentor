( function _String_test_s_() {

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
//
// --

function strFirst( test )
{

  /* - */

  test.open( 'string' );

  /* - */

  test.case = 'begin';

  var expected = { index : 0, entry : 'aa' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', 'aa' );
  test.identical( got, expected );

  test.case = 'middle';

  var expected = { index : 6, entry : 'bb' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', 'bb' );
  test.identical( got, expected );

  test.case = 'end';

  var expected = { index : 12, entry : 'cc' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', 'cc' );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry';

  var expected = { index : 0, entry : 'aa' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ 'aa', 'bb' ] );
  test.identical( got, expected );
  var expected = { index : 0, entry : 'aa' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ 'bb', 'aa' ] );
  test.identical( got, expected );

  test.case = 'middle, several entry';

  var expected = { index : 6, entry : 'bb' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ 'bb', 'cc' ] );
  test.identical( got, expected );
  var expected = { index : 6, entry : 'bb' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ 'cc', 'bb' ] );
  test.identical( got, expected );

  test.case = 'end, several entry';

  var expected = { index : 12, entry : 'cc' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ 'cc', 'dd' ] );
  test.identical( got, expected );
  var expected = { index : 12, entry : 'cc' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ 'dd', 'cc' ] );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry, several sources';

  var expected = [ { index : 0, entry : 'aa' },{ index : 6, entry : 'bb' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'aa', 'bb' ] );
  test.identical( got, expected );
  var expected = [ { index : 0, entry : 'aa' },{ index : 6, entry : 'bb' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'bb', 'aa' ] );
  test.identical( got, expected );

  test.case = 'middle, several entry, several sources';

  var expected = [ { index : 6, entry : 'bb' },{ index : 0, entry : 'cc' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'bb', 'cc' ] );
  test.identical( got, expected );
  var expected = [ { index : 6, entry : 'bb' },{ index : 0, entry : 'cc' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'cc', 'bb' ] );
  test.identical( got, expected );

  test.case = 'end, several entry, several sources';

  var expected = [ { index : 12, entry : 'cc' },{ index : 0, entry : 'cc' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'cc', 'dd' ] );
  test.identical( got, expected );
  var expected = [ { index : 12, entry : 'cc' },{ index : 0, entry : 'cc' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'dd', 'cc' ] );
  test.identical( got, expected );

  /* */

  test.case = 'no entry';

  var expected = { index : 17, entry : undefined }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [] );
  test.identical( got, expected );

  test.case = 'not found';

  var expected = { index : 17, entry : undefined }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', 'dd' );
  test.identical( got, expected );

  test.case = 'empty entry';

  var expected = { index : 0, entry : '' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', '' );
  test.identical( got, expected );

  test.case = 'empty entry, empty src';

  var expected = { index : 0, entry : '' }
  var got = _.strFirst( '', '' );
  test.identical( got, expected );

  test.case = 'empty src';

  var expected = { index : 0, entry : undefined }
  var got = _.strFirst( '', 'aa' );
  test.identical( got, expected );

  /* - */

  test.close( 'string' );
  test.open( 'regexp' );

  /* - */

  test.case = 'begin';

  var expected = { index : 0, entry : 'aa' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', /a+/ );
  test.identical( got, expected );

  test.case = 'middle';

  var expected = { index : 6, entry : 'bb' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', /b+/ );
  test.identical( got, expected );

  test.case = 'end';

  var expected = { index : 12, entry : 'cc' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', /c+/ );
  test.identical( got, expected );

  /* */

  test.case = 'begin smeared';

  var expected = { index : 0, entry : 'xa' }
  var got = _.strFirst( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /\wa/ );
  test.identical( got, expected );

  test.case = 'middle smeared';

  var expected = { index : 10, entry : 'xb' }
  var got = _.strFirst( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /\wb/ );
  test.identical( got, expected );

  test.case = 'end ';

  var expected = { index : 20, entry : 'xc' }
  var got = _.strFirst( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /\wc/ );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry';

  var expected = { index : 0, entry : 'aa' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ /a+/, /b+/ ] );
  test.identical( got, expected );
  var expected = { index : 0, entry : 'aa' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ /b+/, /a+/ ] );
  test.identical( got, expected );

  test.case = 'middle, several entry';

  var expected = { index : 6, entry : 'bb' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ /b+/, /c+/ ] );
  test.identical( got, expected );
  var expected = { index : 6, entry : 'bb' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ /c+/, /b+/ ] );
  test.identical( got, expected );

  test.case = 'end, several entry';

  var expected = { index : 12, entry : 'cc' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ /c+/, /d+/ ] );
  test.identical( got, expected );
  var expected = { index : 12, entry : 'cc' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [ /d+/, /c+/ ] );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry, several sources';

  var expected = [ { index : 0, entry : 'aa' },{ index : 6, entry : 'bb' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /a+/, /b+/ ] );
  test.identical( got, expected );
  var expected = [ { index : 0, entry : 'aa' },{ index : 6, entry : 'bb' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /b+/, /a+/ ] );
  test.identical( got, expected );

  test.case = 'middle, several entry, several sources';

  var expected = [ { index : 6, entry : 'bb' },{ index : 0, entry : 'cc' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /b+/, /c+/ ] );
  test.identical( got, expected );
  var expected = [ { index : 6, entry : 'bb' },{ index : 0, entry : 'cc' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /c+/, /b+/ ] );
  test.identical( got, expected );

  test.case = 'end, several entry, several sources';

  var expected = [ { index : 12, entry : 'cc' },{ index : 0, entry : 'cc' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /c+/, /d+/ ] );
  test.identical( got, expected );
  var expected = [ { index : 12, entry : 'cc' },{ index : 0, entry : 'cc' } ];
  var got = _.strFirst( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /d+/, /c+/ ] );
  test.identical( got, expected );

  /* */

  test.case = 'no entry';

  var expected = { index : 17, entry : undefined }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', [] );
  test.identical( got, expected );

  test.case = 'not found';

  var expected = { index : 17, entry : undefined }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', /d+/ );
  test.identical( got, expected );

  test.case = 'empty entry';

  var expected = { index : 0, entry : '' }
  var got = _.strFirst( 'aa_aa_bb_bb_cc_cc', new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'empty entry, empty src';

  var expected = { index : 0, entry : '' }
  var got = _.strFirst( '', new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'empty src';

  var expected = { index : 0, entry : undefined }
  var got = _.strFirst( '', /a+/ );
  test.identical( got, expected );

  /* - */

  test.close( 'regexp' );

  /* - */

  if( !Config.debug )
  return;

  test.open( 'throwing' );

  test.shouldThrowErrorSync( () => _.strFirst( /a/, /a+/ ) );
  test.shouldThrowErrorSync( () => _.strFirst( 'abc', /a+/, '' ) );
  test.shouldThrowErrorSync( () => _.strFirst( 'abc' ) );
  test.shouldThrowErrorSync( () => _.strFirst( '123', 1 ) );
  test.shouldThrowErrorSync( () => _.strFirst( '123', [ 1 ] ) );
  test.shouldThrowErrorSync( () => _.strFirst() );

  test.close( 'throwing' );

}

//

function strLast( test )
{

  /* - */

  test.open( 'string' );

  /* - */

  test.case = 'begin';

  var expected = { index : 3, entry : 'aa' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', 'aa' );
  test.identical( got, expected );

  test.case = 'middle';

  var expected = { index : 9, entry : 'bb' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', 'bb' );
  test.identical( got, expected );

  test.case = 'end';

  var expected = { index : 15, entry : 'cc' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', 'cc' );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry';

  var expected = { index : 9, entry : 'bb' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ 'aa', 'bb' ] );
  test.identical( got, expected );
  var expected = { index : 9, entry : 'bb' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ 'bb', 'aa' ] );
  test.identical( got, expected );

  test.case = 'middle, several entry';

  var expected = { index : 15, entry : 'cc' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ 'bb', 'cc' ] );
  test.identical( got, expected );
  var expected = { index : 15, entry : 'cc' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ 'cc', 'bb' ] );
  test.identical( got, expected );

  test.case = 'end, several entry';

  var expected = { index : 15, entry : 'cc' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ 'cc', 'dd' ] );
  test.identical( got, expected );
  var expected = { index : 15, entry : 'cc' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ 'dd', 'cc' ] );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry, several sources';

  var expected = [ { index : 9, entry : 'bb' },{ index : 15, entry : 'aa' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'aa', 'bb' ] );
  test.identical( got, expected );
  var expected = [ { index : 9, entry : 'bb' },{ index : 15, entry : 'aa' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'bb', 'aa' ] );
  test.identical( got, expected );

  test.case = 'middle, several entry, several sources';

  var expected = [ { index : 15, entry : 'cc' },{ index : 9, entry : 'bb' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'bb', 'cc' ] );
  test.identical( got, expected );
  var expected = [ { index : 15, entry : 'cc' },{ index : 9, entry : 'bb' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'cc', 'bb' ] );
  test.identical( got, expected );

  test.case = 'end, several entry, several sources';

  var expected = [ { index : 15, entry : 'cc' },{ index : 3, entry : 'cc' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'cc', 'dd' ] );
  test.identical( got, expected );
  var expected = [ { index : 15, entry : 'cc' },{ index : 3, entry : 'cc' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'dd', 'cc' ] );
  test.identical( got, expected );

  /* */

  test.case = 'no entry';

  var expected = { index : -1, entry : undefined }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [] );
  test.identical( got, expected );

  test.case = 'not found';

  var expected = { index : -1, entry : undefined }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', 'dd' );
  test.identical( got, expected );

  test.case = 'empty entry';

  var expected = { index : 17, entry : '' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', '' );
  test.identical( got, expected );

  test.case = 'empty entry, empty src';

  var expected = { index : 0, entry : '' }
  var got = _.strLast( '', '' );
  test.identical( got, expected );

  test.case = 'empty src';

  var expected = { index : -1, entry : undefined }
  var got = _.strLast( '', 'aa' );
  test.identical( got, expected );

  /* - */

  test.close( 'string' );
  test.open( 'regexp' );

  /* - */

  test.case = 'begin';

  var expected = { index : 3, entry : 'aa' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', /a+/ );
  test.identical( got, expected );

  test.case = 'middle';

  var expected = { index : 9, entry : 'bb' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', /b+/ );
  test.identical( got, expected );

  test.case = 'end';

  var expected = { index : 15, entry : 'cc' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', /c+/ );
  test.identical( got, expected );

  /* */

  test.case = 'begin smeared';

  var expected = { index : 7, entry : 'ax' }
  var got = _.strLast( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /a\w/ );
  test.identical( got, expected );

  test.case = 'middle smeared';

  var expected = { index : 17, entry : 'bx' }
  var got = _.strLast( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /b\w/ );
  test.identical( got, expected );

  test.case = 'end ';

  var expected = { index : 27, entry : 'cx' }
  var got = _.strLast( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /c\w/ );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry';

  var expected = { index : 9, entry : 'bb' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ /a+/, /b+/ ] );
  test.identical( got, expected );
  var expected = { index : 9, entry : 'bb' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ /b+/, /a+/ ] );
  test.identical( got, expected );

  test.case = 'middle, several entry';

  var expected = { index : 15, entry : 'cc' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ /b+/, /c+/ ] );
  test.identical( got, expected );
  var expected = { index : 15, entry : 'cc' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ /c+/, /b+/ ] );
  test.identical( got, expected );

  test.case = 'end, several entry';

  var expected = { index : 15, entry : 'cc' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ /c+/, /d+/ ] );
  test.identical( got, expected );
  var expected = { index : 15, entry : 'cc' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [ /d+/, /c+/ ] );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry, several sources';

  var expected = [ { index : 9, entry : 'bb' },{ index : 15, entry : 'aa' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /a+/, /b+/ ] );
  test.identical( got, expected );
  var expected = [ { index : 9, entry : 'bb' },{ index : 15, entry : 'aa' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /b+/, /a+/ ] );
  test.identical( got, expected );

  test.case = 'middle, several entry, several sources';

  var expected = [ { index : 15, entry : 'cc' },{ index : 9, entry : 'bb' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /b+/, /c+/ ] );
  test.identical( got, expected );
  var expected = [ { index : 15, entry : 'cc' },{ index : 9, entry : 'bb' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /c+/, /b+/ ] );
  test.identical( got, expected );

  test.case = 'end, several entry, several sources';

  var expected = [ { index : 15, entry : 'cc' },{ index : 3, entry : 'cc' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /c+/, /d+/ ] );
  test.identical( got, expected );
  var expected = [ { index : 15, entry : 'cc' },{ index : 3, entry : 'cc' } ];
  var got = _.strLast( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /d+/, /c+/ ] );
  test.identical( got, expected );

  /* */

  test.case = 'no entry';

  var expected = { index : -1, entry : undefined }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', [] );
  test.identical( got, expected );

  test.case = 'not found';

  var expected = { index : -1, entry : undefined }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', /d+/ );
  test.identical( got, expected );

  test.case = 'empty entry';

  var expected = { index : 17, entry : '' }
  var got = _.strLast( 'aa_aa_bb_bb_cc_cc', new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'empty entry, empty src';

  var expected = { index : 0, entry : '' }
  var got = _.strLast( '', new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'empty src';

  var expected = { index : -1, entry : undefined }
  var got = _.strLast( '', /a+/ );
  test.identical( got, expected );

  /* - */

  test.close( 'regexp' );

  /* - */

  if( !Config.debug )
  return;

  test.open( 'throwing' );

  test.shouldThrowErrorSync( () => _.strLast( /a/, /a+/ ) );
  test.shouldThrowErrorSync( () => _.strLast( 'abc', /a+/, '' ) );
  test.shouldThrowErrorSync( () => _.strLast( 'abc' ) );
  test.shouldThrowErrorSync( () => _.strLast( '123', 1 ) );
  test.shouldThrowErrorSync( () => _.strLast( '123', [ 1 ] ) );
  test.shouldThrowErrorSync( () => _.strLast() );

  test.close( 'throwing' );

}

//

function strIsolateInsideOrNone( test )
{

  /* - */

  test.open( 'string' );

  /* - */

  test.case = 'begin';

  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', 'aa', 'bb' );
  test.identical( got, expected );

  test.case = 'middle';

  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', 'bb', 'cc' );
  test.identical( got, expected );

  test.case = 'end';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', 'cc', 'dd' );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', 'cc', '' );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry';

  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ 'aa', 'bb' ], [ 'aa', 'bb' ] );
  test.identical( got, expected );
  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ 'bb', 'aa' ], [ 'bb', 'aa' ] );
  test.identical( got, expected );

  test.case = 'middle, several entry';

  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ 'bb', 'cc' ], [ 'bb', 'cc' ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ 'cc', 'bb' ], [ 'cc', 'bb' ] );
  test.identical( got, expected );

  test.case = 'end, several entry';

  var expected = [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ 'cc', 'dd' ], [ 'cc', 'dd' ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ 'dd', 'cc' ], [ 'dd', 'cc' ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ 'dd', 'cc' ], [ '', '' ] );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry, several sources';

  var expected = [ [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ], [ 'cc_cc_', 'bb', '_bb_aa_', 'aa', '' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'aa', 'bb' ], [ 'aa', 'bb' ] );
  test.identical( got, expected );
  var expected = [ [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ], [ 'cc_cc_', 'bb', '_bb_aa_', 'aa', '' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'bb', 'aa' ], [ 'bb', 'aa' ] );
  test.identical( got, expected );

  test.case = 'middle, several entry, several sources';

  var expected = [ [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ], [ '', 'cc', '_cc_bb_', 'bb', '_aa_aa' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'bb', 'cc' ], [ 'bb', 'cc' ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ], [ '', 'cc', '_cc_bb_', 'bb', '_aa_aa' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'cc', 'bb' ], [ 'cc', 'bb' ] );
  test.identical( got, expected );

  test.case = 'end, several entry, several sources';

  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ], [ '', 'cc', '_', 'cc', '_bb_bb_aa_aa' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'cc', 'dd' ], [ 'cc', 'dd' ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ], [ '', 'cc', '_', 'cc', '_bb_bb_aa_aa' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'dd', 'cc' ], [ 'dd', 'cc' ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ], [ '', 'cc', '_cc_bb_bb_aa_aa', '', '' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'dd', 'cc' ], [ '', '' ] );
  test.identical( got, expected );

  /* */

  test.case = 'no entry';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [], [] );
  test.identical( got, expected );

  test.case = 'not found';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', 'dd', 'dd' );
  test.identical( got, expected );

  test.case = 'not found begin';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', 'dd', '' );
  test.identical( got, expected );

  test.case = 'not found end';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', '', 'dd' );
  test.identical( got, expected );

  test.case = 'empty entry';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', '', '' );
  test.identical( got, expected );

  test.case = 'empty entry, empty src';

  var expected = [ '', '', '', '', '' ];
  var got = _.strIsolateInsideOrNone( '', '', '' );
  test.identical( got, expected );

  test.case = 'empty src';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( '', 'aa', 'bb' );
  test.identical( got, expected );

  /* - */

  test.close( 'string' );
  test.open( 'regexp' );

  /* */

  test.case = 'begin smeared';

  var expected = [ 'x', 'aa', 'x_xaax_xbbx_xb', 'bx', '_xccx_xccx' ];
  var got = _.strIsolateInsideOrNone( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /a\w/, /b\w/ );
  test.identical( got, expected );

  test.case = 'middle smeared';

  var expected = [ 'xaax_xaax_x', 'bb', 'x_xbbx_xccx_xc', 'cx', '' ];
  var got = _.strIsolateInsideOrNone( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /b\w/, /c\w/ );
  test.identical( got, expected );

  test.case = 'end smeared';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /c\w/, /d\w/ );
  test.identical( got, expected );
  var expected = [ 'xaax_xaax_xbbx_xbbx_x', 'cc', 'x_xccx', '', '' ];
  var got = _.strIsolateInsideOrNone( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /c\w/, new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'begin';

  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', /a+/, /b+/ );
  test.identical( got, expected );

  test.case = 'middle';

  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', /b+/, /c+/ );
  test.identical( got, expected );

  test.case = 'end';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', /c+/, /d+/ );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', /c+/, new RegExp( '' ) );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry';

  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ /a+/, /b+/ ], [ /a+/, /b+/ ] );
  test.identical( got, expected );
  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ /b+/, /a+/ ], [ /b+/, /a+/ ] );
  test.identical( got, expected );

  test.case = 'middle, several entry';

  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ /b+/, /c+/ ], [ /b+/, /c+/ ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ /c+/, /b+/ ], [ /c+/, /b+/ ] );
  test.identical( got, expected );

  test.case = 'end, several entry';

  var expected = [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ /c+/, /d+/ ], [ /c+/, /d+/ ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ /d+/, /c+/ ], [ /d+/, /c+/ ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [ /d+/, /c+/ ], [ new RegExp( '' ), new RegExp( '' ) ] );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry, several sources';

  var expected = [ [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ], [ 'cc_cc_', 'bb', '_bb_aa_', 'aa', '' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /a+/, /b+/ ], [ /a+/, /b+/ ] );
  test.identical( got, expected );
  var expected = [ [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ], [ 'cc_cc_', 'bb', '_bb_aa_', 'aa', '' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /b+/, /a+/ ], [ /b+/, /a+/ ] );
  test.identical( got, expected );

  test.case = 'middle, several entry, several sources';

  var expected = [ [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ], [ '', 'cc', '_cc_bb_', 'bb', '_aa_aa' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /b+/, /c+/ ], [ /b+/, /c+/ ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ], [ '', 'cc', '_cc_bb_', 'bb', '_aa_aa' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /c+/, /b+/ ], [ /c+/, /b+/ ] );
  test.identical( got, expected );

  test.case = 'end, several entry, several sources';

  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ], [ '', 'cc', '_', 'cc', '_bb_bb_aa_aa' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /c+/, /d+/ ], [ /c+/, /d+/ ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ], [ '', 'cc', '_', 'cc', '_bb_bb_aa_aa' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /d+/, /c+/ ], [ /d+/, /c+/ ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ], [ '', 'cc', '_cc_bb_bb_aa_aa', '', '' ] ];
  var got = _.strIsolateInsideOrNone( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /d+/, /c+/ ], [ new RegExp( '' ), new RegExp( '' ) ] );
  test.identical( got, expected );

  /* */

  test.case = 'no entry';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', [], [] );
  test.identical( got, expected );

  test.case = 'not found';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', /d+/, /d+/ );
  test.identical( got, expected );

  test.case = 'not found begin';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', /d+/, new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'not found end';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', new RegExp( '' ), /d+/ );
  test.identical( got, expected );

  test.case = 'empty entry';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrNone( 'aa_aa_bb_bb_cc_cc', new RegExp( '' ), new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'empty entry, empty src';

  var expected = [ '', '', '', '', '' ];
  var got = _.strIsolateInsideOrNone( '', new RegExp( '' ), new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'empty src';

  var expected = undefined;
  var got = _.strIsolateInsideOrNone( '', /a+/, /b+/ );
  test.identical( got, expected );

  /* - */

  test.close( 'regexp' );

  /* - */

  if( !Config.debug )
  return;

  test.shouldThrowError( () => _.strIsolateInsideOrNone() );
  test.shouldThrowError( () => _.strIsolateInsideOrNone( '' ) );
  test.shouldThrowError( () => _.strIsolateInsideOrNone( '', '' ) );
  test.shouldThrowError( () => _.strIsolateInsideOrNone( '', '', '', '' ) );
  test.shouldThrowError( () => _.strIsolateInsideOrNone( 1, '', '' ) );
  test.shouldThrowError( () => _.strIsolateInsideOrNone( '123', 1, '' ) );
  test.shouldThrowError( () => _.strIsolateInsideOrNone( '123', '', 3 ) );

}

//

function strIsolateInsideOrAll( test )
{

  /* - */

  test.open( 'string' );

  /* - */

  test.case = 'begin';

  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', 'aa', 'bb' );
  test.identical( got, expected );

  test.case = 'middle';

  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', 'bb', 'cc' );
  test.identical( got, expected );

  test.case = 'end';

  var expected = [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', 'cc', 'dd' );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', 'cc', '' );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry';

  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ 'aa', 'bb' ], [ 'aa', 'bb' ] );
  test.identical( got, expected );
  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ 'bb', 'aa' ], [ 'bb', 'aa' ] );
  test.identical( got, expected );

  test.case = 'middle, several entry';

  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ 'bb', 'cc' ], [ 'bb', 'cc' ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ 'cc', 'bb' ], [ 'cc', 'bb' ] );
  test.identical( got, expected );

  test.case = 'end, several entry';

  var expected = [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ 'cc', 'dd' ], [ 'cc', 'dd' ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ 'dd', 'cc' ], [ 'dd', 'cc' ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ 'dd', 'cc' ], [ '', '' ] );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry, several sources';

  var expected = [ [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ], [ 'cc_cc_', 'bb', '_bb_aa_', 'aa', '' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'aa', 'bb' ], [ 'aa', 'bb' ] );
  test.identical( got, expected );
  var expected = [ [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ], [ 'cc_cc_', 'bb', '_bb_aa_', 'aa', '' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'bb', 'aa' ], [ 'bb', 'aa' ] );
  test.identical( got, expected );

  test.case = 'middle, several entry, several sources';

  var expected = [ [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ], [ '', 'cc', '_cc_bb_', 'bb', '_aa_aa' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'bb', 'cc' ], [ 'bb', 'cc' ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ], [ '', 'cc', '_cc_bb_', 'bb', '_aa_aa' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'cc', 'bb' ], [ 'cc', 'bb' ] );
  test.identical( got, expected );

  test.case = 'end, several entry, several sources';

  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ], [ '', 'cc', '_', 'cc', '_bb_bb_aa_aa' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'cc', 'dd' ], [ 'cc', 'dd' ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ], [ '', 'cc', '_', 'cc', '_bb_bb_aa_aa' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'dd', 'cc' ], [ 'dd', 'cc' ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ], [ '', 'cc', '_cc_bb_bb_aa_aa', '', '' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ 'dd', 'cc' ], [ '', '' ] );
  test.identical( got, expected );

  /* */

  test.case = 'no entry';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [], [] );
  test.identical( got, expected );

  test.case = 'not found';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', 'dd', 'dd' );
  test.identical( got, expected );

  test.case = 'not found begin';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', 'dd', '' );
  test.identical( got, expected );

  test.case = 'not found end';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', '', 'dd' );
  test.identical( got, expected );

  test.case = 'empty entry';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', '', '' );
  test.identical( got, expected );

  test.case = 'empty entry, empty src';

  var expected = [ '', '', '', '', '' ];
  var got = _.strIsolateInsideOrAll( '', '', '' );
  test.identical( got, expected );

  test.case = 'empty src';

  var expected = [ '', '', '', '', '' ];
  var got = _.strIsolateInsideOrAll( '', 'aa', 'bb' );
  test.identical( got, expected );

  /* - */

  test.close( 'string' );
  test.open( 'regexp' );

  /* */

  test.case = 'begin smeared';

  var expected = [ 'x', 'aa', 'x_xaax_xbbx_xb', 'bx', '_xccx_xccx' ];
  var got = _.strIsolateInsideOrAll( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /a\w/, /b\w/ );
  test.identical( got, expected );

  test.case = 'middle smeared';

  var expected = [ 'xaax_xaax_x', 'bb', 'x_xbbx_xccx_xc', 'cx', '' ];
  var got = _.strIsolateInsideOrAll( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /b\w/, /c\w/ );
  test.identical( got, expected );

  test.case = 'end smeared';

  var expected = [ 'xaax_xaax_xbbx_xbbx_x', 'cc', 'x_xccx', '', '' ];
  var got = _.strIsolateInsideOrAll( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /c\w/, /d\w/ );
  test.identical( got, expected );
  var expected = [ 'xaax_xaax_xbbx_xbbx_x', 'cc', 'x_xccx', '', '' ];
  var got = _.strIsolateInsideOrAll( 'xaax_xaax_xbbx_xbbx_xccx_xccx', /c\w/, new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'begin';

  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', /a+/, /b+/ );
  test.identical( got, expected );

  test.case = 'middle';

  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', /b+/, /c+/ );
  test.identical( got, expected );

  test.case = 'end';

  var expected = [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', /c+/, /d+/ );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', /c+/, new RegExp( '' ) );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry';

  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ /a+/, /b+/ ], [ /a+/, /b+/ ] );
  test.identical( got, expected );
  var expected = [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ /b+/, /a+/ ], [ /b+/, /a+/ ] );
  test.identical( got, expected );

  test.case = 'middle, several entry';

  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ /b+/, /c+/ ], [ /b+/, /c+/ ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ /c+/, /b+/ ], [ /c+/, /b+/ ] );
  test.identical( got, expected );

  test.case = 'end, several entry';

  var expected = [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ /c+/, /d+/ ], [ /c+/, /d+/ ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ /d+/, /c+/ ], [ /d+/, /c+/ ] );
  test.identical( got, expected );
  var expected = [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [ /d+/, /c+/ ], [ new RegExp( '' ), new RegExp( '' ) ] );
  test.identical( got, expected );

  /* */

  test.case = 'begin, several entry, several sources';

  var expected = [ [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ], [ 'cc_cc_', 'bb', '_bb_aa_', 'aa', '' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /a+/, /b+/ ], [ /a+/, /b+/ ] );
  test.identical( got, expected );
  var expected = [ [ '', 'aa', '_aa_bb_', 'bb', '_cc_cc' ], [ 'cc_cc_', 'bb', '_bb_aa_', 'aa', '' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /b+/, /a+/ ], [ /b+/, /a+/ ] );
  test.identical( got, expected );

  test.case = 'middle, several entry, several sources';

  var expected = [ [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ], [ '', 'cc', '_cc_bb_', 'bb', '_aa_aa' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /b+/, /c+/ ], [ /b+/, /c+/ ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_', 'bb', '_bb_cc_', 'cc', '' ], [ '', 'cc', '_cc_bb_', 'bb', '_aa_aa' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /c+/, /b+/ ], [ /c+/, /b+/ ] );
  test.identical( got, expected );

  test.case = 'end, several entry, several sources';

  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ], [ '', 'cc', '_', 'cc', '_bb_bb_aa_aa' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /c+/, /d+/ ], [ /c+/, /d+/ ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_', 'cc', '' ], [ '', 'cc', '_', 'cc', '_bb_bb_aa_aa' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /d+/, /c+/ ], [ /d+/, /c+/ ] );
  test.identical( got, expected );
  var expected = [ [ 'aa_aa_bb_bb_', 'cc', '_cc', '', '' ], [ '', 'cc', '_cc_bb_bb_aa_aa', '', '' ] ];
  var got = _.strIsolateInsideOrAll( [ 'aa_aa_bb_bb_cc_cc', 'cc_cc_bb_bb_aa_aa' ], [ /d+/, /c+/ ], [ new RegExp( '' ), new RegExp( '' ) ] );
  test.identical( got, expected );

  /* */

  test.case = 'no entry';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', [], [] );
  test.identical( got, expected );

  test.case = 'not found';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', /d+/, /d+/ );
  test.identical( got, expected );

  test.case = 'not found begin';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', /d+/, new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'not found end';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', new RegExp( '' ), /d+/ );
  test.identical( got, expected );

  test.case = 'empty entry';

  var expected = [ '', '', 'aa_aa_bb_bb_cc_cc', '', '' ];
  var got = _.strIsolateInsideOrAll( 'aa_aa_bb_bb_cc_cc', new RegExp( '' ), new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'empty entry, empty src';

  var expected = [ '', '', '', '', '' ];
  var got = _.strIsolateInsideOrAll( '', new RegExp( '' ), new RegExp( '' ) );
  test.identical( got, expected );

  test.case = 'empty src';

  var expected = [ '', '', '', '', '' ];
  var got = _.strIsolateInsideOrAll( '', /a+/, /b+/ );
  test.identical( got, expected );

  /* - */

  test.close( 'regexp' );

  /* - */

  if( !Config.debug )
  return;

  test.shouldThrowError( () => _.strIsolateInsideOrAll() );
  test.shouldThrowError( () => _.strIsolateInsideOrAll( '' ) );
  test.shouldThrowError( () => _.strIsolateInsideOrAll( '', '' ) );
  test.shouldThrowError( () => _.strIsolateInsideOrAll( '', '', '', '' ) );
  test.shouldThrowError( () => _.strIsolateInsideOrAll( 1, '', '' ) );
  test.shouldThrowError( () => _.strIsolateInsideOrAll( '123', 1, '' ) );
  test.shouldThrowError( () => _.strIsolateInsideOrAll( '123', '', 3 ) );

}

//

function strBeginOf( test )
{
  var got,expected;

  /**/

  test.case = 'strBeginOf';

  /**/

  got = _.strBeginOf( 'abc', '' );
  expected = '';
  test.identical( got,expected )

  /**/

  got = _.strBeginOf( 'abc', 'c' );
  expected = false;
  test.identical( got,expected )

  /**/

  got = _.strBeginOf( 'abc', 'bc' );
  expected = false;
  test.identical( got,expected )

  /**/

  got = _.strBeginOf( 'abc', ' c' );
  expected = false;
  test.identical( got,expected )

  /* end.length > src.length */

  got = _.strBeginOf( 'abc', 'abcd' );
  expected = false;
  test.identical( got,expected )

  /* same length, not equal*/

  got = _.strBeginOf( 'abc', 'cba' );
  expected = false;
  test.identical( got,expected )

  /* equal */

  got = _.strBeginOf( 'abc', 'abc' );
  expected = 'abc';
  test.identical( got,expected )

  /* array */

  got = _.strBeginOf( 'abc', [] );
  expected = false;
  test.identical( got,expected )

  /**/

  got = _.strBeginOf( 'abc', [ '' ] );
  expected = '';
  test.identical( got,expected )

  /**/

  got = _.strBeginOf( 'abccc', [ 'c', 'ccc' ] );
  expected = false;
  test.identical( got,expected )

  /**/

  got = _.strBeginOf( 'abc', [ 'a', 'ab', 'abc' ] );
  expected = 'a';
  test.identical( got,expected )

  /**/

  got = _.strBeginOf( 'abc', [ 'x', 'y', 'c' ] );
  expected = false;
  test.identical( got,expected )

  /**/

  got = _.strBeginOf( 'abc', [ 'x', 'y', 'z' ] );
  expected = false;
  test.identical( got,expected )

  if( !Config.debug )
  return;

  test.shouldThrowError( () => _.strBeginOf( 1, '' ) );
  test.shouldThrowError( () => _.strBeginOf( 'abc', 1 ) );
  test.shouldThrowError( () => _.strBeginOf() );
  test.shouldThrowError( () => _.strBeginOf( undefined, undefined ) );
  test.shouldThrowError( () => _.strBeginOf( null, null ) );
}

//

function strEndOf( test )
{
  var got,expected;

  //

  test.case = 'strEndOf';

  /**/

  got = _.strEndOf( 'abc', '' );
  expected = '';
  test.identical( got,expected )

  /**/

  got = _.strEndOf( 'abc', 'a' );
  expected = false;
  test.identical( got,expected )

  /**/

  got = _.strEndOf( 'abc', 'ab' );
  expected = false;
  test.identical( got,expected )

  /**/

  got = _.strEndOf( 'abc', ' a' );
  expected = false;
  test.identical( got,expected )

  /* end.length > src.length */

  got = _.strEndOf( 'abc', 'abcd' );
  expected = false;
  test.identical( got,expected )

  /* same length */

  got = _.strEndOf( 'abc', 'cba' );
  expected = false;
  test.identical( got,expected )

  /* equal */

  got = _.strEndOf( 'abc', 'abc' );
  expected = 'abc';
  test.identical( got,expected )

  /* array */

  got = _.strEndOf( 'abc', [] );
  expected = false;
  test.identical( got,expected )

  /**/

  got = _.strEndOf( 'abc', [ '' ] );
  expected = '';
  test.identical( got,expected )

  /**/

  got = _.strEndOf( 'abccc', [ 'a', 'ab' ] );
  expected = false;
  test.identical( got,expected )

  /**/

  got = _.strEndOf( 'abc', [ 'ab', 'abc' ] );
  expected = 'abc';
  test.identical( got,expected )

  /**/

  got = _.strEndOf( 'abc', [ 'x', 'y', 'a' ] );
  expected = false;
  test.identical( got,expected )

  /**/

  got = _.strEndOf( 'abc', [ 'x', 'y', 'z' ] );
  expected = false;
  test.identical( got,expected )

  if( !Config.debug )
  return;

  test.shouldThrowError( () => _.strEndOf( 1, '' ) );
  test.shouldThrowError( () => _.strEndOf( 'abc', 1 ) );
  test.shouldThrowError( () => _.strEndOf() );
  test.shouldThrowError( () => _.strEndOf( undefined, undefined ) );
  test.shouldThrowError( () => _.strEndOf( null, null ) );

}

//

function strBegins( test )
{
  var got, expected;

  //

  test.case = 'strBegins';

  /**/

  got = _.strBegins( '', '' );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strBegins( 'a', '' );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strBegins( 'a', 'a' );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strBegins( 'a', 'b' );
  expected = false;
  test.identical( got, expected );

  /**/

  got = _.strBegins( 'abc', 'ab' );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strBegins( 'abc', 'abc' );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strBegins( 'abc', ' a' );
  expected = false;
  test.identical( got, expected );

  /**/

  got = _.strBegins( 'abc', [ 'x', 'y', 'ab' ] );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strBegins( 'abc', [ '' ] );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strBegins( 'abc', [] );
  expected = false;
  test.identical( got, expected );

  /**/

  got = _.strBegins( 'abc', [ '1', 'b', 'a' ] );
  expected = true;
  test.identical( got, expected );

  if( !Config.debug )
  return;

  test.shouldThrowError( () => _.strBegins( 1, '' ) );
  test.shouldThrowError( () => _.strBegins( 'a', 1 ) );
  test.shouldThrowError( () => _.strBegins( 'abc', [ 1, 'b', 'a' ] ) );

}

//

function strEnds( test )
{
  var got, expected;

  //

  test.case = 'strEnds';

  /**/

  got = _.strEnds( '', '' );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strEnds( 'a', '' );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strEnds( 'a', 'a' );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strEnds( 'a', 'b' );
  expected = false;
  test.identical( got, expected );

  /**/

  got = _.strEnds( 'abc', 'bc' );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strEnds( 'abc', 'abc' );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strEnds( 'abc', [ 'x', 'y', 'bc' ] );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strEnds( 'abc', [ '' ] );
  expected = true;
  test.identical( got, expected );

  /**/

  got = _.strEnds( 'abc', [] );
  expected = false;
  test.identical( got, expected );

  /**/

  got = _.strEnds( 'abc', [ '1', 'b', 'c' ] );
  expected = true;
  test.identical( got, expected );

  if( !Config.debug )
  return;

  test.shouldThrowError( () => _.strEnds( 1, '' ) );
  test.shouldThrowError( () => _.strEnds( 'a', 1 ) );
}

//

var Self =
{

  name : 'Tools/base/layer1/String',
  silencing : 1,

  tests :
  {

    strFirst : strFirst,
    strLast : strLast,

    strIsolateInsideOrNone : strIsolateInsideOrNone,
    strIsolateInsideOrAll : strIsolateInsideOrAll,

    strBeginOf : strBeginOf,
    strEndOf : strEndOf,

    strBegins : strBegins,
    strEnds : strEnds,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
