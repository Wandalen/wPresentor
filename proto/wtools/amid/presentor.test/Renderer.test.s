( function _Renderer_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  _.include( 'wTesting' );
  _.include( 'stxt' );
  require( '../presentor/Renderer.s' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let context = this;
  context.suiteTempPath = __.path.tempOpen( _.path.join( __dirname, '../..'  ), 'presentor' );
  context.assetsOriginalPath = __.path.join( __dirname, '_assets' );
}

//

function onSuiteEnd()
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, '/presentor' ) )
  __.path.tempClose( context.suiteTempPath );
}

// --
// tests
// --

function trivial( test )
{
  const a = test.assetFor( 'basic' );
  a.reflect();

  var dataStr = a.fileProvider.fileRead( a.abs( 'Courses.stxt' ) );
  var parser = _.stxt.Parser({ dataStr });
  parser.form();

  const renderer = _.ghi.HiPresentor( parser );

  /* */

  test.case = 'trivial';
  var got = renderer.pageRender( 0 );
  test.true( true );
}

//

function _pageElementRender( test )
{
  const a = test.assetFor( 'basic' );
  a.reflect();

  var dataStr = a.fileProvider.fileRead( a.abs( 'Courses.stxt' ) );
  var parser = _.stxt.Parser({ dataStr });
  parser.form();

  const renderer = _.ghi.HiPresentor( parser );
  const node0 = parser.document.nodes[ 0 ];

  /* */

  test.case = 'LineEmpty';
  var element = node0.nodes[ 0 ];
  test.identical( element.kind, 'LineEmpty' );
  var got = renderer._pageElementRender( element );
  test.identical( got, '<p></p>' );
  test.true( true );

  /* */

  test.case = 'List';
  var element = node0.nodes[ 1 ];
  test.identical( element.kind, 'List' );
  var got = renderer._pageElementRender( element );
  test.identical( got, '<p></p>' );
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

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
  },

  tests :
  {
    // trivial,
    _pageElementRender,
  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

