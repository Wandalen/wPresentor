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

function _pageElmentExportHtml( test )
{
  const a = test.assetFor( 'basic' );
  a.reflect();

  /* */

  test.case = 'Line';
  var data =
`
txt
`;
  var renderer = _.presentor.Renderer({ structure : data });
  var node = renderer.structure.document.nodes[ 0 ].nodes[ 0 ];
  test.identical( node.kind, 'Line' );
  var got = _.html.exportToString( renderer._pageElmentExportHtml( node ) );
  var exp = `<p><span>txt</span></p>`;
  test.identical( got, exp );

  /* */

  test.case = 'LineEmpty';
  var data =
`
- txt
`;
  var renderer = _.presentor.Renderer({ structure : data });
  var node = renderer.structure.document.nodes[ 0 ].nodes[ 1 ];
  test.identical( node.kind, 'LineEmpty' );
  var got = _.html.exportToString( renderer._pageElmentExportHtml( node ) );
  var exp = `<p></p>`;
  test.identical( got, exp );

  /* */

  test.case = 'List - one layer';
  var data =
`
- txt
`;
  var renderer = _.presentor.Renderer({ structure : data });
  var node = renderer.structure.document.nodes[ 0 ].nodes[ 0 ];
  test.identical( node.kind, 'List' );
  var got = _.html.exportToString( renderer._pageElmentExportHtml( node ) );
  var exp = `<ul><li><p><span>txt</span></p></li></ul>`;
  test.identical( got, exp );

  /* */

  test.case = 'List - two layers';
  var data =
`
- txt
-- abc
`;
  var renderer = _.presentor.Renderer({ structure : data });
  var node = renderer.structure.document.nodes[ 0 ].nodes[ 0 ];
  test.identical( node.kind, 'List' );
  var got = _.html.exportToString( renderer._pageElmentExportHtml( node ) );
  var exp =
`<ul><li><p><span>txt</span></p></li>
<ul><li><p><span>abc</span></p></li></ul></ul>`;
  test.identical( got, exp );

  /* */

  test.case = 'Directive - image';
  var data =
`
~ image:/file.png
`;
  var renderer = _.presentor.Renderer({ structure : data });
  var node = renderer.structure.document.nodes[ 0 ].nodes[ 0 ];
  test.identical( node.kind, 'Directive' );
  var got = _.html.exportToString( renderer._pageElmentExportHtml( node ) );
  var exp = `<img level="1" src="/file.png">`;
  test.identical( got, exp );

  /* */

  test.case = 'Directive - image';
  var data =
`
~~ image:/file.png
`;
  var renderer = _.presentor.Renderer({ structure : data });
  var node = renderer.structure.document.nodes[ 0 ].nodes[ 0 ];
  test.identical( node.kind, 'Directive' );
  var got = _.html.exportToString( renderer._pageElmentExportHtml( node ) );
  var exp = `<img level="2" src="/file.png">`;
  test.identical( got, exp );
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
    // trivial,
    _pageElmentExportHtml,
  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
