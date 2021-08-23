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
  context.suiteTempPath = __.path.tempOpen( _.path.join( __dirname, '../..'  ), 'renderer' );
  context.assetsOriginalPath = __.path.join( __dirname, '_assets' );
}

//

function onSuiteEnd()
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, '/renderer' ) )
  __.path.tempClose( context.suiteTempPath );
}

// --
// tests
// --

function pageRender( test )
{
  const a = test.assetFor( 'basic' );
  a.reflect();

  var dataStr = a.fileProvider.fileRead( a.abs( 'Courses.stxt' ) );
  var renderer = _.presentor.Renderer({ structure : dataStr });

  test.identical( renderer.structure.document.nodes.length, 2 );

  /* */

  test.case = 'node0';
  var got = renderer.pageRender( 0 );
  test.identical( got.length, 3 );
  test.identical( got[ 0 ].kind, 'p' );
  test.identical( got[ 1 ].kind, 'ul' );
  test.identical( got[ 2 ].kind, 'p' );
  test.identical( _.html.exportString( got[ 0 ] ), '<p></p>' );
  var exp =
`<ul><li><p><a href="https://www.edx.org/"><span>edX</span></a></p></li>
<li><p><a href="https://www.coursera.org/"><span>Coursera</span></a></p></li></ul>`;
  test.identical( _.html.exportString( got[ 1 ] ), exp );
  test.identical( _.html.exportString( got[ 2 ] ), '<p></p>' );

  /* */

  test.case = 'node1';
  var got = renderer.pageRender( 1 );
  test.identical( got.length, 3 );
  test.identical( got[ 0 ].kind, 'p' );
  test.identical( got[ 1 ].kind, 'ul' );
  test.identical( got[ 2 ].kind, 'p' );
  test.identical( _.html.exportString( got[ 0 ] ), '<p></p>' );
  var exp =
`<ul><li><p><a href="https://harvardx.harvard.edu/"><span>HarvardX</span></a></p></li>
<li><p><a href="https://mitprofessionalx.mit.edu/"><span>MIT Professional Education Digital Programs</span></a></p></li></ul>`;
  test.identical( _.html.exportString( got[ 1 ] ), exp );
  test.identical( _.html.exportString( got[ 2 ] ), '<p></p>' );

  /* */

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
  var got = _.html.exportString( renderer._pageElmentExportHtml( node ) );
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
  var got = _.html.exportString( renderer._pageElmentExportHtml( node ) );
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
  var got = _.html.exportString( renderer._pageElmentExportHtml( node ) );
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
  var got = _.html.exportString( renderer._pageElmentExportHtml( node ) );
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
  var got = _.html.exportString( renderer._pageElmentExportHtml( node ) );
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
  var got = _.html.exportString( renderer._pageElmentExportHtml( node ) );
  var exp = `<img level="2" src="/file.png">`;
  test.identical( got, exp );

  /* */

  test.case = 'Link';
  var data =
`
>> edX <<- https://www.edx.org/
`;
  var renderer = _.presentor.Renderer({ structure : data });
  var node = renderer.structure.document.nodes[ 0 ].nodes[ 0 ].nodes[ 0 ];
  test.identical( node.kind, 'Link' );
  var got = _.html.exportString( renderer._pageElmentExportHtml( node ) );
  var exp = `<a href="https://www.edx.org/"><span>edX</span></a>`;
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
    pageRender,
    _pageElmentExportHtml,
  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
