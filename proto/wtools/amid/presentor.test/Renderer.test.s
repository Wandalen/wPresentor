( function _Renderer_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( 'Tools' );
  _.include( 'wTesting' );
  _.include( 'stxt' );
  require( '../presentor/include/Mid.s' );
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
  var renderer = _.presentor.Renderer({ structure : dataStr });

  /* */

  test.case = 'trivial';
  var got = renderer.pageRender( 0 );
  console.log( got );
  test.true( true );
}

//

function _pageElementRender( test )
{
  const a = test.assetFor( 'basic' );
  a.reflect();

  // var dataStr = a.fileProvider.fileRead( a.abs( 'Courses.stxt' ) );
  // var renderer = _.presentor.Renderer({ structure : dataStr });

  /* */

  test.case = 'LineEmpty';
  var element = renderer.structure.document.nodes[ 0 ].nodes[ 0 ];
  test.identical( element.kind, 'LineEmpty' );
  var got = renderer._pageElementRender( element );
  test.identical( got, '<p></p>' );

  /* */

  // test.case = 'List';
  // var renderer = _.presentor.Renderer({ structure : dataStr });
  // var element = renderer.structure.document.nodes[ 0 ].nodes[ 1 ];
  // var got = renderer._pageElementRender( element );
  // test.identical( got, '<ul><li><p><a href="https://www.edx.org/"<span> edX </span></a>edX</p></li><li><p><a href="https://www.coursera.org/"<span> Coursera </span></a>Coursera</p></li></ul>' );
  // test.identical( got, '<p></p>' );

}

// --
// declare
// --

const Proto =
{

  name : 'Tools.presentor.Renderer',
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
    trivial,
    _pageElementRender,
  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

