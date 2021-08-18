( function _Path_test_s_( ) {

'use strict';

var isBrowser = true;

if( typeof module !== 'undefined' )
{
  isBrowser = false;

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
  require( '../layer3/Path.s' );

}

var _global = _global_;
var _ = _global_.wTools;

//

function refine( test )
{

  var got;

  test.case = 'posix path'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar//baz/asdf/quux/..';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar//baz/asdf/quux/..';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '//foo/bar//baz/asdf/quux/..//';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar//baz/asdf/quux/..//.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  test.case = 'winoows path'; /* */

  var path = 'C:\\';
  var expected = '/C';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'C:';
  var expected = '/C';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp//foo/bar/..';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo/bar/..//';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo/bar/..//';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp//foo/bar/../..';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp//foo/bar/../../.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  test.case = 'empty path'; /* */

  var path = '';
  var expected = '.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '//';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '///';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/./.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = './.';
  var expected = './.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  test.case = 'path with "." in the middle'; /* */

  var path = 'foo/./bar/baz';
  var expected = 'foo/./bar/baz';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/././bar/baz';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/././bar/././baz';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/././bar/././baz';
  var got = _.path.refine( path );
  test.identical( got, expected );

  test.case = 'path with "." in the beginning'; /* */

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = '././foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './/.//foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '/.//.//foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  test.case = 'path with "." in the end'; /* */

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar/.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar/./.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar/./.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar/./.';
  var got = _.path.refine( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle'; /* */

  var path = 'foo/../bar/baz';
  var expected = 'foo/../bar/baz';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = 'foo/../../bar/baz';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = 'foo/../../bar/../../baz';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/foo/../../bar/../../baz';
  var got = _.path.refine( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning'; /* */

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '..//..//foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/..//..//foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.path.refine( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the end'; /* */

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo/bar/..';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = 'foo/bar/../..';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = 'foo/bar/../..';
  var got = _.path.refine( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/foo/bar/../..';
  var got = _.path.refine( path );
  test.identical( got, expected );

}

//

function pathsRefine( test )
{

  var got;

  var cases =
  [
    {
      description : 'posix path',
      src :
      [
        '/foo/bar//baz/asdf/quux/..',
        '/foo/bar//baz/asdf/quux/../',
        '//foo/bar//baz/asdf/quux/..//',
        'foo/bar//baz/asdf/quux/..//.',
      ],
      expected :
      [
        '/foo/bar//baz/asdf/quux/..',
        '/foo/bar//baz/asdf/quux/..',
        '//foo/bar//baz/asdf/quux/..//',
        'foo/bar//baz/asdf/quux/..//.'
       ]
    },
    {
      description : 'winoows path',
      src :
      [
        'C:\\temp\\\\foo\\bar\\..\\',
        'C:\\temp\\\\foo\\bar\\..\\\\',
        'C:\\temp\\\\foo\\bar\\..\\\\.',
        'C:\\temp\\\\foo\\bar\\..\\..\\',
        'C:\\temp\\\\foo\\bar\\..\\..\\.'
      ],
      expected :
      [
        '/C/temp//foo/bar/..',
        '/C/temp//foo/bar/..//',
        '/C/temp//foo/bar/..//.',
        '/C/temp//foo/bar/../..',
        '/C/temp//foo/bar/../../.'
      ]
    },
    {
      description : 'empty path',
      src :
      [
        '',
        '/',
        '//',
        '///',
        '/.',
        '/./.',
        '.',
        './.'
      ],
      expected :
      [
        '.',
        '/',
        '//',
        '///',
        '/.',
        '/./.',
        '.',
        './.'
      ]
    },
    {
      description : 'path with "." in the middle',
      src :
      [
        'foo/./bar/baz',
        'foo/././bar/baz/',
        'foo/././bar/././baz/',
        '/foo/././bar/././baz/'
      ],
      expected :
      [
        'foo/./bar/baz',
        'foo/././bar/baz',
        'foo/././bar/././baz',
        '/foo/././bar/././baz'
      ]
    },
    {
      description : 'path with "." in the beginning',
      src :
      [
        './foo/bar',
        '././foo/bar/',
        './/.//foo/bar/',
        '/.//.//foo/bar/',
        '.x/foo/bar',
        '.x./foo/bar'
      ],
      expected :
      [
        './foo/bar',
        '././foo/bar',
        './/.//foo/bar',
        '/.//.//foo/bar',
        '.x/foo/bar',
        '.x./foo/bar'
      ]
    },
    {
      description : 'path with "." in the end',
      src :
      [
        'foo/bar.',
        'foo/.bar.',
        'foo/bar/.',
        'foo/bar/./.',
        'foo/bar/././',
        '/foo/bar/././'
      ],
      expected :
      [
        'foo/bar.',
        'foo/.bar.',
        'foo/bar/.',
        'foo/bar/./.',
        'foo/bar/./.',
        '/foo/bar/./.'
      ]
    },
    {
      description : 'path with ".." in the middle',
      src :
      [
        'foo/../bar/baz',
        'foo/../../bar/baz/',
        'foo/../../bar/../../baz/',
        '/foo/../../bar/../../baz/',
      ],
      expected :
      [
        'foo/../bar/baz',
        'foo/../../bar/baz',
        'foo/../../bar/../../baz',
        '/foo/../../bar/../../baz'
      ]
    },
    {
      description : 'path with ".." in the beginning',
      src :
      [
        '../foo/bar',
        '../../foo/bar/',
        '..//..//foo/bar/',
        '/..//..//foo/bar/',
        '..x/foo/bar',
        '..x../foo/bar'
      ],
      expected :
      [
        '../foo/bar',
        '../../foo/bar',
        '..//..//foo/bar',
        '/..//..//foo/bar',
        '..x/foo/bar',
        '..x../foo/bar'
      ]
    },
    {
      description : 'path with ".." in the end',
      src :
      [
        'foo/bar..',
        'foo/..bar..',
        'foo/bar/..',
        'foo/bar/../..',
        'foo/bar/../../',
        '/foo/bar/../../'
      ],
      expected :
      [
        'foo/bar..',
        'foo/..bar..',
        'foo/bar/..',
        'foo/bar/../..',
        'foo/bar/../..',
        '/foo/bar/../..'
      ]
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    test.case = c.description;
    test.identical( _.path.pathsRefine( c.src ), c.expected );
  }
}

//

function isRefined( test )
{
  test.case = 'posix path, not refined'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  test.case = 'posix path, refined'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  test.case = 'winoows path, not refined'; /* */

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  test.case = 'winoows path, refined'; /* */

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  test.case = 'empty path,not refined';

  var path = '';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '/';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '//';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '///';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '.';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = './.';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  test.case = 'empty path,refined';

  var path = '';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '/';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '//';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '///';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '/.';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '/./.';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '.';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = './.';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  test.case = 'path with "." in the middle'; /* */

  var path = 'foo/./bar/baz';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  test.case = 'path with "." in the middle,refined';

  var path = 'foo/./bar/baz';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle'; /* */

  var path = 'foo/../bar/baz';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle,refined'; /* */

  var path = 'foo/../bar/baz';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning'; /* */

  var path = '../foo/bar';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = false;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = true;
  var got = _.path.isRefined( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning,refined';

  var path = '../foo/bar';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var refined = _.path.refine( path );
  var expected = true;
  var got = _.path.isRefined( refined );
  test.identical( got, expected );
}

//

function normalize( test )
{

  var got;

  test.case = 'posix path'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar//baz/asdf';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar//baz/asdf';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '//foo/bar//baz/asdf//';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar//baz/asdf//';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  test.case = 'winoows path'; /* */

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp//foo';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo//';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo//';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp//';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp//';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  test.case = 'empty path'; /* */

  var path = '';
  var expected = '.';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '//';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '///';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  test.case = 'path with "." in the middle'; /* */

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  test.case = 'path with "." in the beginning'; /* */

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '.\\foo\\bar';
  var expected = './foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './//foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '///foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  test.case = 'path with "." in the end'; /* */

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x.';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle'; /* */

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning'; /* */

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '..//foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/..//foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the end'; /* */

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = '.';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." and "." combined'; /* */

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '..';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.path.normalize( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '..';
  var got = _.path.normalize( path );
  test.identical( got, expected );

}

//

function pathsNormalize( test )
{
  var cases =
  [
    {
      description : 'posix path',
      src :
      [
        '/foo/bar//baz/asdf/quux/..',
        '/foo/bar//baz/asdf/quux/../',
        '//foo/bar//baz/asdf/quux/..//',
        'foo/bar//baz/asdf/quux/..//.'
      ],
      expected :
      [
        '/foo/bar//baz/asdf',
        '/foo/bar//baz/asdf',
        '//foo/bar//baz/asdf//',
        'foo/bar//baz/asdf//'
      ]
    },
    {
      description : 'winoows path',
      src :
      [
        'C:\\temp\\\\foo\\bar\\..\\',
        'C:\\temp\\\\foo\\bar\\..\\\\',
        'C:\\temp\\\\foo\\bar\\..\\\\',
        'C:\\temp\\\\foo\\bar\\..\\..\\',
        'C:\\temp\\\\foo\\bar\\..\\..\\.'
      ],
      expected :
      [
        '/C/temp//foo',
        '/C/temp//foo//',
        '/C/temp//foo//',
        '/C/temp//',
        '/C/temp//'
      ]
    },
    {
      description : 'empty path',
      src :
      [
        '',
        '/',
        '//',
        '///',
        '/.',
        '/./.',
        '.',
        './.'
      ],
      expected :
      [
        '.',
        '/',
        '//',
        '///',
        '/',
        '/',
        '.',
        '.'
      ]
    },
    {
      description : 'path with "." in the middle',
      src :
      [
        'foo/./bar/baz',
        'foo/././bar/baz/',
        'foo/././bar/././baz/',
        '/foo/././bar/././baz/',
        '/foo/.x./baz/'
      ],
      expected :
      [
        'foo/bar/baz',
        'foo/bar/baz',
        'foo/bar/baz',
        '/foo/bar/baz',
        '/foo/.x./baz'
      ]
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    test.case = c.description;
    test.identical( _.path.pathsNormalize( c.src ), c.expected );
  }

}

//

function normalizeTolerant( test )
{

  var got;

  test.case = 'posix path'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar/baz/asdf/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'winoows path'; /* */

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp/foo/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'empty path'; /* */

  var path = '';
  var expected = '.';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with "." in the middle'; /* */

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with "." in the beginning'; /* */

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './foo/bar/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '/foo/bar/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with "." in the end'; /* */

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x./';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle'; /* */

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning'; /* */

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '../foo/bar/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/../foo/bar/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the end'; /* */

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = '/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." and "." combined'; /* */

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b/';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '../';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '../';
  var got = _.path.normalizeTolerant( path );
  test.identical( got, expected );

}

//

function dot( test )
{
  var cases =
  [
    { src : '', expected : './' },
    { src : 'a', expected : './a' },
    { src : '.', expected : '.' },
    { src : '.a', expected : './.a' },
    { src : './a', expected : './a' },
    { src : '..', expected : '..' },
    { src : '..a', expected : './..a' },
    { src : '../a', expected : '../a' },
    { src : '/', error : true },
    { src : '/a', error : true },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.dot( c.src ) )
    }
    else
    test.identical( _.path.dot( c.src ), c.expected );
  }
}

//

function pathsDot( test )
{
  test.case = 'add ./ prefix';

  var cases =
  [
    {
      src :  [ '', 'a', '.', '.a', './a', '..', '..a', '../a',  ],
      expected : [ './', './a', '.', './.a', './a', '..', './..a', '../a' ]
    },
    {
      src :  _.arrayToMap( [ '', 'a', '.', '.a', './a', '..', '..a', '../a' ] ),
      expected : _.arrayToMap( [ './', './a', '.', './.a', './a', '..', './..a', '../a' ] )
    },
    {
      src : [ 'a', './', '', '/' ],
      error : true
    },
    {
      src : [ 'b', './a', '../a', '/a' ],
      error : true
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.pathsDot( c.src ) )
    }
    else
    {
      test.identical( _.path.pathsDot( c.src ), c.expected );
    }
  }

}

//

function undot( test )
{
  var cases =
  [
    { src : './', expected : '' },
    { src : './a', expected : 'a' },
    { src : 'a', expected : 'a' },
    { src : '.', expected : '.' },
    { src : './.a', expected : '.a' },
    { src : '..', expected : '..' },
    { src : './..a', expected : '..a' },
    { src : '/./a', expected : '/./a' },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.undot( c.src ) )
    }
    else
    test.identical( _.path.undot( c.src ), c.expected );
  }
}

//

function pathsUndot( test )
{
  test.case = 'rm ./ prefix'
  var cases =
  [
    {
      src : [ './', './a', '.', './.a', './a', '..', './..a', '../a', 'a', '/a' ],
      expected :  [ '', 'a', '.', '.a', 'a', '..', '..a', '../a', 'a', '/a' ]
    },
    {
      src : _.arrayToMap( [ './', './a', '.', './.a', './a', '..', './..a', '../a', 'a', '/a' ] ),
      expected :  _.arrayToMap( [ '', 'a', '.', '.a', 'a', '..', '..a', '../a', 'a', '/a' ] )
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.pathsUndot( c.src ) )
    }
    else
    test.identical( _.path.pathsUndot( c.src ), c.expected );
  }
}

//

function _pathJoin_body( test )
{

  // var options1 =
  // {
  //   reroot : 1,
  //   url : 0,
  // }
  // var options2 =
  // {
  //   reroot : 0,
  //   url : 1,
  // }
  // var options3 =
  // {
  //   reroot : 0,
  //   url : 0,
  // }

  var paths1 = [ 'http://www.site.com:13/', 'bar', 'foo', ];
  var paths2 = [ 'c:\\', 'foo\\', 'bar\\' ];
  var paths3 = [ '/bar/', '/', 'foo/' ];
  var paths4 = [ '/bar/', '/baz', 'foo/' ];

  var expected1 = 'http://www.site.com:13/bar/foo';
  var expected2 = '/c/foo/bar';
  var expected3 = '/foo';
  var expected4 = '/bar/baz/foo';

  // test.case = 'join url';
  // var got = _.path._pathJoin_body
  // ({
  //   paths : paths1,
  //   reroot : 0,
  //   url : 1,
  // });
  // test.identical( got, expected1 );

  test.case = 'join windows os paths';
  var got = _.path._pathJoin_body
  ({
    paths : paths2,
    reroot : 0,
    allowingNull : 0,
  });
  test.identical( got, expected2 );

  test.case = 'join unix os paths';
  var got = _.path._pathJoin_body
  ({
    paths : paths3,
    reroot : 0,
    allowingNull : 0,
  });
  test.identical( got, expected3 );

  test.case = 'join unix os paths with reroot';
  var got = _.path._pathJoin_body
  ({
    paths : paths4,
    reroot : 1,
    allowingNull : 0,
  });
  test.identical( got, expected4 );

  test.case = 'join reroot with /';
  var got = _.path._pathJoin_body
  ({
    paths : [ '/','/a/b' ],
    reroot : 1,
    allowingNull : 0,
  });
  test.identical( got, '/a/b' );

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function()
  {
    _.path._pathJoin_body();
  });

  test.case = 'path element is not string';
  test.shouldThrowErrorSync( function()
  {
    _.path._pathJoin_body( _.mapSupplement( { paths : [ 34 , 'foo/' ] },options3 ) );
  });

  test.case = 'missed options';
  test.shouldThrowErrorSync( function()
  {
    _.path._pathJoin_body( paths1 );
  });

  test.case = 'options has unexpected parameters';
  test.shouldThrowErrorSync( function()
  {
    _.path._pathJoin_body({ paths : paths1, wrongParameter : 1 });
  });

  test.case = 'options does not has paths';
  test.shouldThrowErrorSync( function()
  {
    _.path._pathJoin_body({ wrongParameter : 1 });
  });
}

//

function join( test )
{

  test.case = 'join with empty';
  var paths = [ '', 'a/b', '', 'c', '' ];
  var expected = 'a/b/c';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  test.case = 'join windows os paths';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  test.case = 'join unix os paths';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo/.';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  test.case = 'more complicated cases'; /* */

  var paths = [  '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb//cc';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '/aa', '/bb', 'cc' ];
  var expected = '/bb/cc';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '//aa', 'bb//', 'cc//' ];
  var expected = '//aa/bb//cc//';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '/aa', 'bb//', 'cc','.' ];
  var expected = '/aa/bb//cc/.';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '/','a', '//b//', '././c', '../d', '..e' ];
  var expected = '//b//././c/../d/..e';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  /* - */

  test.open( 'with nulls' );

  var paths = [ 'a', null ];
  var expected = null;
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [ '/', null ];
  var expected = null;
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [ 'a', null, 'b' ];
  var expected = 'b';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, 'b' ];
  var expected = 'b';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [ '/a', null, '/b' ];
  var expected = '/b';
  var got = _.path.join.apply( _.path, paths );
  test.identical( got, expected );

  test.close( 'with nulls' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'bad arguments';

  test.shouldThrowErrorSync( () => _.path.join() );
  test.shouldThrowErrorSync( () => _.path.join( {} ) );
  test.shouldThrowErrorSync( () => _.path.join( 1 ) );
  test.shouldThrowErrorSync( () => _.path.join( '/',1 ) );

}

//

function crossJoin( test )
{

  test.description = 'trivial';
  var paths = [ 'a', 'b', 'c' ];
  var expected = 'a/b/c';
  var got = _.path.crossJoin.apply( _.path, paths );
  test.identical( got, expected );

  test.description = 'single element vector in the middle';
  var paths = [ 'a', [ 'b' ], 'c' ];
  var expected = [ 'a/b/c' ];
  var got = _.path.crossJoin.apply( _.path, paths );
  test.identical( got, expected );

  test.description = 'two elements vector in the middle';
  var paths = [ 'a', [ 'b1', 'b2' ], 'c' ];
  var expected = [ 'a/b1/c', 'a/b2/c' ];
  var got = _.path.crossJoin.apply( _.path, paths );
  test.identical( got, expected );

  test.description = 'several many elements vectors';
  var paths = [ 'a', [ 'b1', 'b2' ], [ 'c1', 'c2', 'c3' ] ];
  var expected = [ 'a/b1/c1', 'a/b2/c1', 'a/b1/c2', 'a/b2/c2', 'a/b1/c3', 'a/b2/c3' ];
  var got = _.path.crossJoin.apply( _.path, paths );
  test.identical( got, expected );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'bad arguments';

  test.shouldThrowErrorSync( () => _.path.crossJoin() );
  test.shouldThrowErrorSync( () => _.path.crossJoin( {} ) );
  test.shouldThrowErrorSync( () => _.path.crossJoin( 1 ) );
  test.shouldThrowErrorSync( () => _.path.crossJoin( '/',1 ) );

}

//

function pathsJoin( test )
{
  test.case = 'join windows os paths';

  var got = _.path.pathsJoin( '/a', [ 'c:\\', 'foo\\', 'bar\\' ] );
  var expected = [ '/c', '/a/foo', '/a/bar' ];
  test.identical( got, expected );

  var got = _.path.pathsJoin( '/a', [ 'c:\\', 'foo\\', 'bar\\' ], 'd' );
  var expected = [ '/c/d', '/a/foo/d', '/a/bar/d' ];
  test.identical( got, expected );

  var got = _.path.pathsJoin( 'c:\\', [ 'a', 'b', 'c' ], 'd' );
  var expected = [ '/c/a/d', '/c/b/d', '/c/c/d' ];
  test.identical( got, expected );

  var got = _.path.pathsJoin( 'c:\\', [ '../a', './b', '..c' ] );
  var expected = [ '/c/../a', '/c/./b', '/c/..c' ];
  test.identical( got, expected );

  test.case = 'join unix os paths';

  var got = _.path.pathsJoin( '/a', [ 'b', 'c' ], 'd', 'e' );
  var expected = [ '/a/b/d/e', '/a/c/d/e' ];
  test.identical( got, expected );

  var got = _.path.pathsJoin( [ '/a', '/b', '/c' ], 'e' );
  var expected = [ '/a/e', '/b/e', '/c/e' ];
  test.identical( got, expected );

  var got = _.path.pathsJoin( [ '/a', '/b', '/c' ], [ '../a', '../b', '../c' ], [ './a', './b', './c' ] );
  var expected = [ '/a/../a/./a', '/b/../b/./b', '/c/../c/./c' ];
  test.identical( got, expected );

  var got = _.path.pathsJoin( [ 'a', 'b', 'c' ], [ 'a1', 'b1', 'c1' ], [ 'a2', 'b2', 'c2' ] );
  var expected = [ 'a/a1/a2', 'b/b1/b2', 'c/c1/c2' ];
  test.identical( got, expected );

  var got = _.path.pathsJoin( [ '/a', '/b', '/c' ], [ '../a', '../b', '../c' ], [ './a', './b', './c' ] );
  var expected = [ '/a/../a/./a', '/b/../b/./b', '/c/../c/./c' ];
  test.identical( got, expected );

  var got = _.path.pathsJoin( [ '/', '/a', '//a' ], [ '//', 'a//', 'a//a' ], 'b' );
  var expected = [ '//b', '/a/a//b', '//a/a//a/b' ];
  test.identical( got, expected );

  //

  test.case = 'works like join'

  var got = _.path.pathsJoin( '/a' );
  var expected = _.path.join( '/a' );
  test.identical( got, expected );

  var got = _.path.pathsJoin( '/a', 'd', 'e' );
  var expected = _.path.join( '/a', 'd', 'e' );
  test.identical( got, expected );

  var got = _.path.pathsJoin( '/a', '../a', './c' );
  var expected = _.path.join( '/a', '../a', './c' );
  test.identical( got, expected );

  //

  test.case = 'scalar + array with single argument'

  var got = _.path.pathsJoin( '/a', [ 'b' ] );
  var expected = [ '/a/b' ];
  test.identical( got, expected );

  test.case = 'array + array with single arguments'

  var got = _.path.pathsJoin( [ '/a' ], [ 'b' ] );
  var expected = [ '/a/b' ];
  test.identical( got, expected );

  //

  if( !Config.debug )
  return;

  test.case = 'arrays with different length'
  test.shouldThrowError( function()
  {
    _.path.pathsJoin( [ '/b', '.c' ], [ '/b' ] );
  });

  test.case = 'nothing passed';
  test.shouldThrowErrorSync( function()
  {
    _.path.pathsJoin();
  });

  test.case = 'object passed';
  test.shouldThrowErrorSync( function()
  {
    _.path.pathsJoin( {} );
  });

  test.case = 'inner arrays'
  test.shouldThrowError( function()
  {
    _.path.pathsJoin( [ '/b', '.c' ], [ '/b', [ 'x' ] ] );
  });
}

//

function reroot( test )
{

  // test.case = 'missed arguments';
  // var got = _.path.reroot();
  // test.identical( got, '.' );

  test.case = 'join windows os paths';
  var paths1 = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected1 = '/c/foo/bar';
  var got = _.path.reroot.apply( _.path, paths1 );
  test.identical( got, expected1 );

  test.case = 'join unix os paths';
  var paths2 = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected2 = '/bar/baz/foo/.';
  var got = _.path.reroot.apply( _.path, paths2 );
  test.identical( got, expected2 );

  test.case = 'reroot';

  var got = _.path.reroot( 'a', '/a', 'b' );
  var expected = 'a/a/b';
  test.identical( got, expected );

  var got = _.path.reroot( 'a', '/a', '/b' );
  var expected = 'a/a/b';
  test.identical( got, expected );

  var got = _.path.reroot( '/a', '/b', '/c' );
  var expected = '/a/b/c';
  test.identical( got, expected );

  if( !Config.debug )
  return;

  test.case = 'nothing passed';
  test.shouldThrowErrorSync( function()
  {
    _.path.reroot();
  });

  test.case = 'not string passed';
  test.shouldThrowErrorSync( function()
  {
    _.path.reroot( {} );
  });

}

//

function pathsReroot( test )
{

  test.case = 'paths reroot';

  var got = _.path.pathsReroot( 'a', [ '/a', 'b' ] );
  var expected = [ 'a/a', 'a/b' ];
  test.identical( got, expected );

  var got = _.path.pathsReroot( [ '/a', '/b' ], [ '/a', '/b' ] );
  var expected = [ '/a/a', '/b/b' ];
  test.identical( got, expected );

  var got = _.path.pathsReroot( '../a', [ '/b', '.c' ], './d' );
  var expected = [ '../a/b/./d', '../a/.c/./d' ]
  test.identical( got, expected );

  var got = _.path.pathsReroot( [ '/a' , '/a' ] );
  var expected = [ '/a' , '/a' ];
  test.identical( got, expected );

  var got = _.path.pathsReroot( '.', '/', './', [ 'a', 'b' ] );
  var expected = [ '././a', '././b' ];
  test.identical( got, expected );

  //

  test.case = 'scalar + scalar'

  var got = _.path.pathsReroot( '/a', '/a' );
  var expected = '/a/a';
  test.identical( got, expected );

  test.case = 'scalar + array with single argument'

  var got = _.path.pathsReroot( '/a', [ '/b' ] );
  var expected = [ '/a/b' ];
  test.identical( got, expected );

  test.case = 'array + array with single arguments'

  var got = _.path.pathsReroot( [ '/a' ], [ '/b' ] );
  var expected = [ '/a/b' ];
  test.identical( got, expected );

  if( !Config.debug )
  return;

  test.case = 'arrays with different length'
  test.shouldThrowError( function()
  {
    _.path.pathsReroot( [ '/b', '.c' ], [ '/b' ] );
  });

  test.case = 'inner arrays'
  test.shouldThrowError( function()
  {
    _.path.pathsReroot( [ '/b', '.c' ], [ '/b', [ 'x' ] ] );
  });
}

//

function resolve( test )
{

  test.case = 'join windows os paths';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar';
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  test.case = 'join unix os paths';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo';
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  test.case = 'here cases'; /* */

  var paths = [ 'aa','.','cc' ];
  var expected = _.path.join( _.path.current(), 'aa/cc' );
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  'aa','cc','.' ];
  var expected = _.path.join( _.path.current(), 'aa/cc' );
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '.','aa','cc' ];
  var expected = _.path.join( _.path.current(), 'aa/cc' );
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  test.case = 'down cases'; /* */

  var paths = [  '.','aa','cc','..' ];
  var expected = _.path.join( _.path.current(), 'aa' );
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '.','aa','cc','..','..' ];
  var expected = _.path.current();
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  console.log( '_.path.current()',_.path.current() );
  var paths = [  'aa','cc','..','..','..' ];
  var expected = _.strIsolateEndOrNone( _.path.current(),'/' )[ 0 ];
  if( _.path.current() === '/' )
  expected = '/..';
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  test.case = 'like-down or like-here cases'; /* */

  var paths = [  '.x.','aa','bb','.x.' ];
  var expected = _.path.join( _.path.current(), '.x./aa/bb/.x.' );
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '..x..','aa','bb','..x..' ];
  var expected = _.path.join( _.path.current(), '..x../aa/bb/..x..' );
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  test.case = 'period and double period combined'; /* */

  var paths = [  '/abc','./../a/b' ];
  var expected = '/a/b';
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '/abc','a/.././a/b' ];
  var expected = '/abc/a/b';
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '/abc','.././a/b' ];
  var expected = '/a/b';
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./.././a/b' ];
  var expected = '/a/b';
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./../.' ];
  var expected = '/';
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./../../.' ];
  var expected = '/..';
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./../.' ];
  var expected = '/';
  var got = _.path.resolve.apply( _.path, paths );
  test.identical( got, expected );

  if( !Config.debug ) //
  return;

  test.case = 'nothing passed';
  test.shouldThrowErrorSync( function()
  {
    _.path.resolve();
  });

  test.case = 'non string passed';
  test.shouldThrowErrorSync( function()
  {
    _.path.resolve( {} );
  });
}

//

function pathsResolve( test )
{
  test.case = 'paths resolve';

  var current = _.path.current();

  var got = _.path.pathsResolve( 'c', [ '/a', 'b' ] );
  var expected = [ '/a', _.path.join( current, 'c/b' ) ];
  test.identical( got, expected );

  var got = _.path.pathsResolve( [ '/a', '/b' ], [ '/a', '/b' ] );
  var expected = [ '/a', '/b' ];
  test.identical( got, expected );

  var got = _.path.pathsResolve( '../a', [ 'b', '.c' ] );
  var expected = [ _.path.dir( current ) + '/a/b', _.path.dir( current ) + '/a/.c' ]
  test.identical( got, expected );

  var got = _.path.pathsResolve( '../a', [ '/b', '.c' ], './d' );
  var expected = [ '/b/d', _.path.dir( current ) + '/a/.c/d' ];
  test.identical( got, expected );

  var got = _.path.pathsResolve( [ '/a', '/a' ],[ 'b', 'c' ] );
  var expected = [ '/a/b' , '/a/c' ];
  test.identical( got, expected );

  var got = _.path.pathsResolve( [ '/a', '/a' ],[ 'b', 'c' ], 'e' );
  var expected = [ '/a/b/e' , '/a/c/e' ];
  test.identical( got, expected );

  var got = _.path.pathsResolve( [ '/a', '/a' ],[ 'b', 'c' ], '/e' );
  var expected = [ '/e' , '/e' ];
  test.identical( got, expected );

  var got = _.path.pathsResolve( '.', '../', './', [ 'a', 'b' ] );
  var expected = [ _.path.dir( current ) + '/a', _.path.dir( current ) + '/b' ];
  test.identical( got, expected );

  //

  test.case = 'works like resolve';

  var got = _.path.pathsResolve( '/a', 'b', 'c' );
  var expected = _.path.resolve( '/a', 'b', 'c' );
  test.identical( got, expected );

  var got = _.path.pathsResolve( '/a', 'b', 'c' );
  var expected = _.path.resolve( '/a', 'b', 'c' );
  test.identical( got, expected );

  var got = _.path.pathsResolve( '../a', '.c' );
  var expected = _.path.resolve( '../a', '.c' );
  test.identical( got, expected );

  var got = _.path.pathsResolve( '/a' );
  var expected = _.path.resolve( '/a' );
  test.identical( got, expected );

  var got = _.path.pathsResolve( 'b' );
  var expected = _.path.join( current, 'b' );
  test.identical( got, expected );

  var got = _.path.pathsResolve( './b' );
  var expected = _.path.join( current, 'b' );
  test.identical( got, expected );

  var got = _.path.pathsResolve( '../b' );
  var expected = _.path.join( _.path.dir( current ), 'b' );
  test.identical( got, expected );

  var got = _.path.pathsResolve( '..' );
  var expected = _.path.dir( current )
  test.identical( got, expected );

  //

  test.case = 'scalar + array with single argument'

  var got = _.path.pathsResolve( '/a', [ 'b/..' ] );
  var expected = [ '/a' ];
  test.identical( got, expected );

  test.case = 'array + array with single arguments'

  var got = _.path.pathsResolve( [ '/a' ], [ 'b/../' ] );
  var expected = [ '/a' ];
  test.identical( got, expected );

  test.case = 'single array';

  var got = _.path.pathsResolve( [ '/a', 'b', './b', '../b', '..' ] );
  var expected =
  [
    '/a',
    _.path.join( current, 'b' ),
    _.path.join( current, 'b' ),
    _.path.join( _.path.dir( current ), 'b' ),
    _.path.dir( current )
  ];
  test.identical( got, expected );

  //

  if( !Config.debug )
  return

  test.case = 'arrays with different length'
  test.shouldThrowError( function()
  {
    _.path.pathsResolve( [ '/b', '.c' ], [ '/b' ] );
  });

  test.shouldThrowError( function()
  {
    _.path.pathsResolve();
  });

  test.case = 'inner arrays'
  test.shouldThrowError( function()
  {
    _.path.pathsResolve( [ '/b', '.c' ], [ '/b', [ 'x' ] ] );
  });
}

//

function dir( test )
{

  test.case = 'simple absolute path'; /* */

  var path2 = '/foo';
  var expected2 = '/';
  var got = _.path.dir( path2 );
  test.identical( got, expected2 );

  test.case = 'absolute path : nested dirs'; /* */

  var path = '/foo/bar/baz/text.txt';
  var expected = '/foo/bar/baz';
  var got = _.path.dir( path );
  test.identical( got, expected );

  var path = '/aa/bb';
  var expected = '/aa';
  var got = _.path.dir( path );
  test.identical( got, expected );

  var path = '/aa/bb/';
  var expected = '/aa';
  var got = _.path.dir( path );
  test.identical( got, expected );

  var path = '/aa';
  var expected = '/';
  var got = _.path.dir( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/..';
  var got = _.path.dir( path );
  test.identical( got, expected );

  test.case = 'relative path : nested dirs'; /* */

  var path = 'aa/bb';
  var expected = 'aa';
  var got = _.path.dir( path );
  test.identical( got, expected );

  var path = 'aa';
  var expected = '.';
  var got = _.path.dir( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '..';
  var got = _.path.dir( path );
  test.identical( got, expected );

  var path = '..';
  var expected = '../..';
  var got = _.path.dir( path );
  test.identical( got, expected );

  // test.case = 'windows os path';
  // var path4 = 'c:/';
  // var expected4 = 'c:/..';
  // var got = _.path.dir( path4 );
  // test.identical( got, expected4 );

  // test.case = 'windows os path : nested dirs';
  // var path5 = 'a:/foo/baz/bar.txt';
  // var expected5 = 'a:/foo/baz';
  // var got = _.path.dir( path5 );
  // test.identical( got, expected5 );

  if( !Config.debug )
  return;

  test.case = 'empty path';
  test.shouldThrowErrorSync( function()
  {
    var got = _.path.dir( '' );
  });

  test.case = 'redundant argument';
  test.shouldThrowErrorSync( function()
  {
    var got = _.path.dir( 'a','b' );
  });

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.path.dir( {} );
  });

}

//

function pathsDir( test )
{
  var cases =
  [
    {
      description : 'simple absolute path',
      src : [ '/foo' ],
      expected : [ '/' ]
    },
    {
      description : 'absolute path : nested dirs',
      src :
      [
        '/foo/bar/baz/text.txt',
        '/aa/bb',
        '/aa/bb/',
        '/aa',
        '/'
      ],
      expected :
      [
        '/foo/bar/baz',
        '/aa',
        '/aa',
        '/',
        '/..'
      ]
    },
    {
      description : 'relative path : nested dirs',
      src :
      [
        'aa/bb',
        'aa',
        '.',
        '..'
      ],
      expected :
      [
        'aa',
        '.',
        '..',
        '../..'
      ]
    },
    {
      description : 'incorrect path type',
      src : [  'aa/bb',  1  ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.pathsDir( c.src ) )
    }
    else
    test.identical( _.path.pathsDir( c.src ), c.expected );
  }

}

//

function pathsExt( test )
{
  var cases =
  [
    {
      description : 'absolute path : nested dirs',
      src :
      [
        'some.txt',
        '/foo/bar/baz.asdf',
        '/foo/bar/.baz',
        '/foo.coffee.md',
        '/foo/bar/baz'
      ],
      expected :
      [
        'txt',
        'asdf',
        '',
        'md',
        ''
      ]
    },
    {
      description : 'incorrect path type',
      src : [  'aa/bb',  1  ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.pathsExt( c.src ) )
    }
    else
    test.identical( _.path.pathsExt( c.src ), c.expected );
  }
}

//

function ext( test )
{
  var path1 = '',
    path2 = 'some.txt',
    path3 = '/foo/bar/baz.asdf',
    path4 = '/foo/bar/.baz',
    path5 = '/foo.coffee.md',
    path6 = '/foo/bar/baz',
    expected1 = '',
    expected2 = 'txt',
    expected3 = 'asdf',
    expected4 = '',
    expected5 = 'md',
    expected6 = '';

  test.case = 'empty path';
  var got = _.path.ext( path1 );
  test.identical( got, expected1 );

  test.case = 'txt extension';
  var got = _.path.ext( path2 );
  test.identical( got, expected2 );

  test.case = 'path with non empty dir name';
  var got = _.path.ext( path3 );
  test.identical( got, expected3) ;

  test.case = 'hidden file';
  var got = _.path.ext( path4 );
  test.identical( got, expected4 );

  test.case = 'several extension';
  var got = _.path.ext( path5 );
  test.identical( got, expected5 );

  test.case = 'file without extension';
  var got = _.path.ext( path6 );
  test.identical( got, expected6 );

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.path.ext( null );
  });

}

//

function prefixGet( test )
{
  var path1 = '',
    path2 = 'some.txt',
    path3 = '/foo/bar/baz.asdf',
    path4 = '/foo/bar/.baz',
    path5 = '/foo.coffee.md',
    path6 = '/foo/bar/baz',
    expected1 = '',
    expected2 = 'some',
    expected3 = '/foo/bar/baz',
    expected4 = '/foo/bar/',
    expected5 = '/foo',
    expected6 = '/foo/bar/baz';

  test.case = 'empty path';
  var got = _.path.prefixGet( path1 );
  test.identical( got, expected1 );

  test.case = 'txt extension';
  var got = _.path.prefixGet( path2 );
  test.identical( got, expected2 );

  test.case = 'path with non empty dir name';
  var got = _.path.prefixGet( path3 );
  test.identical( got, expected3 ) ;

  test.case = 'hidden file';
  var got = _.path.prefixGet( path4 );
  test.identical( got, expected4 );

  test.case = 'several extension';
  var got = _.path.prefixGet( path5 );
  test.identical( got, expected5 );

  test.case = 'file without extension';
  var got = _.path.prefixGet( path6 );
  test.identical( got, expected6 );

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.path.prefixGet( null );
  });
};

//

function pathsPrefixesGet( test )
{
  var cases =
  [
    {
      description : 'get path without ext',
      src :
      [
        '',
        'some.txt',
        '/foo/bar/baz.asdf',
        '/foo/bar/.baz',
        '/foo.coffee.md',
        '/foo/bar/baz'
      ],
      expected :
      [
        '',
        'some',
        '/foo/bar/baz',
        '/foo/bar/',
        '/foo',
        '/foo/bar/baz'
      ]
    },
    {
      description : 'incorrect path type',
      src : [  'aa/bb',  1  ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.pathsPrefixesGet( c.src ) )
    }
    else
    test.identical( _.path.pathsPrefixesGet( c.src ), c.expected );
  }
}

//

function name( test )
{
  var path1 = '',
    path2 = 'some.txt',
    path3 = '/foo/bar/baz.asdf',
    path4 = '/foo/bar/.baz',
    path5 = '/foo.coffee.md',
    path6 = '/foo/bar/baz',
    expected1 = '',
    expected2 = 'some.txt',
    expected3 = 'baz',
    expected4 = '.baz',
    expected5 = 'foo.coffee',
    expected6 = 'baz';

  test.case = 'empty path';
  var got = _.path.name( path1 );
  test.identical( got, expected1 );

  test.case = 'get file with extension';
  var got = _.path.name({ path : path2, withExtension : 1 } );
  test.identical( got, expected2 );

  test.case = 'got file without extension';
  var got = _.path.name({ path : path3, withExtension : 0 } );
  test.identical( got, expected3) ;

  test.case = 'hidden file';
  var got = _.path.name({ path : path4, withExtension : 1 } );
  test.identical( got, expected4 );

  test.case = 'several extension';
  var got = _.path.name( path5 );
  test.identical( got, expected5 );

  test.case = 'file without extension';
  var got = _.path.name( path6 );
  test.identical( got, expected6 );

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.path.name( false );
  });
};

//

function pathsName( test )
{
  var cases =
  [
    {
      description : 'get paths name',
      withExtension : 0,
      src :
      [
        '',
        'some.txt',
        '/foo/bar/baz.asdf',
        '/foo/bar/.baz',
        '/foo.coffee.md',
        '/foo/bar/baz'
      ],
      expected :
      [
        '',
        'some',
        'baz',
        '',
        'foo.coffee',
        'baz'
      ]
    },
    {
      description : 'get paths name with extension',
      withExtension : 1,
      src :
      [
        '',
        'some.txt',
        '/foo/bar/baz.asdf',
        '/foo/bar/.baz',
        '/foo.coffee.md',
        '/foo/bar/baz'
      ],
      expected :
      [
        '',
        'some.txt',
        'baz.asdf',
        '.baz',
        'foo.coffee.md',
        'baz'
      ]
    },
    {
      description : 'incorrect path type',
      src : [  'aa/bb',  1  ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];

    test.case = c.description;

    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.pathsName( c.src ) );
    }
    else
    {
      var args = c.src.slice();

      if( c.withExtension )
      {
        for( var j = 0; j < args.length; j++ )
        args[ j ] = { path : args[ j ], withExtension : 1 };
      }

      test.identical( _.path.pathsName( args ), c.expected );
    }
  }
};

//

// function current( test )
// {
//   var got, expected;
//
//   test.case = 'get current working dir';
//
//   if( isBrowser )
//   {
//     /*default*/
//
//     got = _.path.current();
//     expected = '.';
//     test.identical( got, expected );
//
//     /*incorrect arguments count*/
//
//     test.shouldThrowErrorSync( function()
//     {
//       _.path.current( 0 );
//     })
//
//   }
//   else
//   {
//     /*default*/
//
//     if( _.fileProvider )
//     {
//
//       got = _.path.current();
//       expected = _.path.normalize( process.cwd() );
//       test.identical( got,expected );
//
//       /*empty string*/
//
//       expected = _.path.normalize( process.cwd() );
//       got = _.path.current( '' );
//       test.identical( got,expected );
//
//       /*changing cwd*/
//
//       got = _.path.current( './staging' );
//       expected = _.path.normalize( process.cwd() );
//       test.identical( got,expected );
//
//       /*try change cwd to terminal file*/
//
//       got = _.path.current( './abase/layer3/Path.s' );
//       expected = _.path.normalize( process.cwd() );
//       test.identical( got,expected );
//
//     }
//
//     /*incorrect path*/
//
//     test.shouldThrowErrorSync( function()
//     {
//       got = _.path.current( './incorrect_path' );
//       expected = _.path.normalize( process.cwd() );
//       test.identical( got,expected );
//     });
//
//     if( Config.debug )
//     {
//       /*incorrect arguments length*/
//
//       test.shouldThrowErrorSync( function()
//       {
//         _.path.current( '.', '.' );
//       })
//
//       /*incorrect argument type*/
//
//       test.shouldThrowErrorSync( function()
//       {
//         _.path.current( 123 );
//       })
//     }
//
//   }
//
// }

//

function withoutExt( test )
{

  test.case = 'empty path';
  var path = '';
  var expected = '';
  var got = _.path.withoutExt( path );
  test.identical( got, expected );

  /* */

  test.case = 'txt extension';
  var path = 'some.txt';
  var expected = 'some';
  var got = _.path.withoutExt( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with non empty dir name';
  var path = '/foo/bar/baz.asdf';
  var expected = '/foo/bar/baz';
  var got = _.path.withoutExt( path );
  test.identical( got, expected ) ;

  /* */

  test.case = 'hidden file';
  var path = '/foo/bar/.baz';
  var expected = '/foo/bar/.baz';
  var got = _.path.withoutExt( path );
  test.identical( got, expected );

  /* */

  test.case = 'file with composite file name';
  var path = '/foo.coffee.md';
  var expected = '/foo.coffee';
  var got = _.path.withoutExt( path );
  test.identical( got, expected );

  /* */

  test.case = 'path without extension';
  var path = '/foo/bar/baz';
  var expected = '/foo/bar/baz';
  var got = _.path.withoutExt( path );
  test.identical( got, expected );

  /* */

  test.case = 'relative path #1';
  var got = _.path.withoutExt( './foo/.baz' );
  var expected = './foo/.baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #2';
  var got = _.path.withoutExt( './.baz' );
  var expected = './.baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #3';
  var got = _.path.withoutExt( '.baz.txt' );
  var expected = '.baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #4';
  var got = _.path.withoutExt( './baz.txt' );
  var expected = './baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #5';
  var got = _.path.withoutExt( './foo/baz.txt' );
  var expected = './foo/baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #6';
  var got = _.path.withoutExt( './foo/' );
  var expected = './foo/';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #7';
  var got = _.path.withoutExt( 'baz' );
  var expected = 'baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #8';
  var got = _.path.withoutExt( 'baz.a.b' );
  var expected = 'baz.a';
  test.identical( got, expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.path.withoutExt( null );
  });
};

//

function pathsWithoutExt( test )
{

  var cases =
  [
    {
      description : ' get paths without extension ',
      src :
      [
        '',
        'some.txt',
        '/foo/bar/baz.asdf',
        '/foo/bar/.baz',
        '/foo.coffee.md',
        '/foo/bar/baz',
        './foo/.baz',
        './.baz',
        '.baz.txt',
        './baz.txt',
        './foo/baz.txt',
        './foo/',
        'baz',
        'baz.a.b'
      ],
      expected :
      [
        '',
        'some',
        '/foo/bar/baz',
        '/foo/bar/.baz',
        '/foo.coffee',
        '/foo/bar/baz',
        './foo/.baz',
        './.baz',
        '.baz',
        './baz',
        './foo/baz',
        './foo/',
        'baz',
        'baz.a'
      ]
    },
    {
      description : 'incorrect path type',
      src : [  'aa/bb',  1  ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];

    test.case = c.description;

    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.pathsWithoutExt( c.src ) );
    }
    else
    test.identical( _.path.pathsWithoutExt( c.src ), c.expected );
  }
};

//

function changeExt( test )
{
  test.case = 'empty ext';
  var got = _.path.changeExt( 'some.txt', '' );
  var expected = 'some';
  test.identical( got, expected );

  /* */

  test.case = 'simple change extension';
  var got = _.path.changeExt( 'some.txt', 'json' );
  var expected = 'some.json';
  test.identical( got, expected );

  /* */

  test.case = 'path with non empty dir name';
  var got = _.path.changeExt( '/foo/bar/baz.asdf', 'txt' );
  var expected = '/foo/bar/baz.txt';
  test.identical( got, expected) ;

  /* */

  test.case = 'change extension of hidden file';
  var got = _.path.changeExt( '/foo/bar/.baz', 'sh' );
  var expected = '/foo/bar/.baz.sh';
  test.identical( got, expected );

  /* */

  test.case = 'change extension in composite file name';
  var got = _.path.changeExt( '/foo.coffee.md', 'min' );
  var expected = '/foo.coffee.min';
  test.identical( got, expected );

  /* */

  test.case = 'add extension to file without extension';
  var got = _.path.changeExt( '/foo/bar/baz', 'txt' );
  var expected = '/foo/bar/baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'path folder contains dot, file without extension';
  var got = _.path.changeExt( '/foo/baz.bar/some.md', 'txt' );
  var expected = '/foo/baz.bar/some.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #1';
  var got = _.path.changeExt( './foo/.baz', 'txt' );
  var expected = './foo/.baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #2';
  var got = _.path.changeExt( './.baz', 'txt' );
  var expected = './.baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #3';
  var got = _.path.changeExt( '.baz', 'txt' );
  var expected = '.baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #4';
  var got = _.path.changeExt( './baz', 'txt' );
  var expected = './baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #5';
  var got = _.path.changeExt( './foo/baz', 'txt' );
  var expected = './foo/baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #6';
  var got = _.path.changeExt( './foo/', 'txt' );
  var expected = './foo/.txt';
  test.identical( got, expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.path.changeExt( null, '' );
  });

}

//

function pathsChangeExt( test )
{
  var cases =
  [
    {
      description : 'change paths extension ',
      src :
      [
        [ 'some.txt', '' ],
        [ 'some.txt', 'json' ],
        [ '/foo/bar/baz.asdf', 'txt' ],
        [ '/foo/bar/.baz', 'sh' ],
        [ '/foo.coffee.md', 'min' ],
        [ '/foo/bar/baz', 'txt' ],
        [ '/foo/baz.bar/some.md', 'txt' ],
        [ './foo/.baz', 'txt' ],
        [ './.baz', 'txt' ],
        [ '.baz', 'txt' ],
        [ './baz', 'txt' ],
        [ './foo/baz', 'txt' ],
        [ './foo/', 'txt' ]
      ],
      expected :
      [
        'some',
        'some.json',
        '/foo/bar/baz.txt',
        '/foo/bar/.baz.sh',
        '/foo.coffee.min',
        '/foo/bar/baz.txt',
        '/foo/baz.bar/some.txt',
        './foo/.baz.txt',
        './.baz.txt',
        '.baz.txt',
        './baz.txt',
        './foo/baz.txt',
        './foo/.txt'
      ]
    },
    {
      description : 'element must be array',
      src : [  'aa/bb' ],
      error : true
    },
    {
      description : 'element length must be 2',
      src : [ [ 'abc' ] ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];

    test.case = c.description;

    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.pathsChangeExt( c.src ) );
    }
    else
    test.identical( _.path.pathsChangeExt( c.src ), c.expected );
  }
};

//

function relative( test )
{
  var got;

  test.case = 'same path'; /* */

  var from = '/aa/bb/cc';
  var to = '/aa/bb/cc';
  var expected = '.';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  var from = '/aa/bb/cc';
  var to = '/aa/bb/cc/';
  var expected = '.';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  var from = '/aa/bb/cc/';
  var to = '/aa/bb/cc';
  var expected = '.';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  var from = '/aa//bb/cc/';
  var to = '//xx/yy/zz/';
  var expected = '../../../..//xx/yy/zz';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'down path'; /* */

  var from = '/aa/bb/cc';
  var to = '/aa/bb';
  var expected = '..';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  var from = '/aa/bb/cc/';
  var to = '/aa/bb';
  var expected = '..';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  var from = '/aa/bb/cc';
  var to = '/aa/bb/';
  var expected = '..';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  var from = '/aa//bb/cc/';
  var to = '//xx/yy/';
  var expected = '../../../..//xx/yy';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'relative to same path'; /* */
  var from = '/foo/bar/baz/asdf/quux';
  var to = '/foo/bar/baz/asdf/quux';
  var expected = '.';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'relative to nested'; /* */
  var from = '/foo/bar/baz/asdf/quux';
  var to = '/foo/bar/baz/asdf/quux/new1';
  var expected = 'new1';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'relative to parent directory'; /* */
  var from = '/foo/bar/baz/asdf/quux';
  var to = '/foo/bar/baz/asdf';
  var expected = '..';
  var got = _.path.relative( from, to );
  test.identical( got, expected );


  test.case = 'absolute paths'; /* */
  var from = '/include/dwtools/abase/layer3.test';
  var to = '/include/dwtools/abase/layer3.test/Path.path.test.s';
  var expected = 'Path.path.test.s';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'absolute paths, from === to'; /* */
  var from = '/include/dwtools/abase/layer3.test';
  var to = '/include/dwtools/abase/layer3.test';
  var expected = '.';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'out of relative dir'; /* */
  var from = '/abc';
  var to = '/a/b/z';
  var expected = '../a/b/z';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'out of relative dir'; /* */
  var from = '/abc/def';
  var to = '/a/b/z';
  var expected = '../../a/b/z';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'relative root'; /* */
  var from = '/';
  var to = '/a/b/z';
  var expected = 'a/b/z';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'relative root'; /* */
  var from = '/';
  var to = '/a';
  var expected = 'a';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'relative root'; /* */
  var from = '/';
  var to = '/';
  var expected = '.';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'windows disks'; /* */

  var from = 'd:/';
  var to = 'c:/x/y';
  var expected = '../c/x/y';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'long, not direct'; /* */

  var from = '/a/b/xx/yy/zz';
  var to = '/a/b/files/x/y/z.txt';
  var expected = '../../../files/x/y/z.txt';
  var got = _.path.relative( from, to );
  test.identical( got, expected );

  test.case = 'both relative, long, not direct, resolving : 0'; /* */

  // var from = 'a/b/xx/yy/zz';
  // var to = 'a/b/files/x/y/z.txt';
  // var expected = '../../../files/x/y/z.txt';
  // var got = _.path.relative({ relative : from, path : to, resolving : 0 });
  // test.identical( got, expected );

  // test.case = 'both relative, long, not direct, resolving : 1'; /* */

  // var from = 'a/b/xx/yy/zz';
  // var to = 'a/b/files/x/y/z.txt';
  // var expected = '../../../files/x/y/z.txt';
  // var got = _.path.relative({ relative : from, path : to, resolving : 1 });
  // test.identical( got, expected );

  // test.case = 'one relative, resolving 1'; /* */
  // var current = _.path.current();
  // var upStr = '/';

  // //

  // var from = 'c:/x/y';
  // var to = 'a/b/files/x/y/z.txt';
  // var expected = '../../../a/b/files/x/y/z.txt';
  // if( current !== upStr )
  // expected = '../../..' + _.path.join( current, to );
  // var got = _.path.relative({ relative :  from, path : to, resolving : 1 });
  // test.identical( got, expected );

  // //

  // var from = 'a/b/files/x/y/z.txt';
  // var to = 'c:/x/y';
  // var expected = '../../../../../../c/x/y';
  // if( current !== upStr )
  // {
  //   var outOfCurrent = _.path.relative( current, upStr );
  //   var toNormalized = _.path.normalize( to );

  //   expected = outOfCurrent + '/../../../../../..' + toNormalized;
  // }
  // var got = _.path.relative({ relative :  from, path : to, resolving : 1 });
  // test.identical( got, expected );


  // test.case = 'one relative, resolving 0'; /* */

  // var from = 'c:/x/y';
  // var to = 'a/b/files/x/y/z.txt';
  // var expected = '../../../files/x/y/z.txt';
  // test.shouldThrowErrorSync( function()
  // {
  //   _.path.relative({ relative :  from, path : to, resolving : 0 });
  // })

  //

  if( !Config.debug ) //
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.path.relative( from );
  } );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.path.relative( 'from3', 'to3', 'to4' );
  } );

  test.case = 'second argument is not string or array';
  test.shouldThrowErrorSync( function( )
  {
    _.path.relative( 'from3', null );
  } );

};

//

function pathsRelative( test )
{
  var from =
  [
    '/aa/bb/cc',
    '/aa/bb/cc/',
    '/aa/bb/cc',
    '/aa/bb/cc/',
    '/foo/bar/baz/asdf/quux',
    '/foo/bar/baz/asdf/quux',
    '/foo/bar/baz/asdf/quux',
    '/foo/bar/baz/asdf/quux/dir1/dir2',
    '/abc',
    '/abc/def',
    '/',
    '/',
    '/',
    'd:/',
    '/a/b/xx/yy/zz',
  ];
  var to =
  [
    [ '/aa/bb/cc', '/aa/bb/cc/' ],
    [ '/aa/bb/cc', '//aa/bb/cc/' ],
    [ '/aa/bb', '/aa/bb/' ],
    [ '/aa/bb', '//aa/bb/' ],
    '/foo/bar/baz/asdf/quux',
    '/foo/bar/baz/asdf/quux/new1',
    '/foo/bar/baz/asdf',
    [
      '/foo/bar/baz/asdf/quux/dir1/dir2',
      '/foo/bar/baz/asdf/quux/dir1/',
      '/foo/bar/baz/asdf/quux/',
      '/foo/bar/baz/asdf/quux/dir1/dir2/dir3',
    ],
    '/a/b/z',
    '/a/b/z',
    '/a/b/z',
    '/a',
    '/',
    'c:/x/y',
    '/a/b/files/x/y/z.txt',
  ];

  var expected =
  [
    [ '.', '.' ],
    [ '.', '../../..//aa/bb/cc' ],
    [ '..', '..' ],
    [ '..', '../../..//aa/bb' ],
    '.',
    'new1',
    '..',
    [ '.', '..', '../..', 'dir3' ],
    '../a/b/z',
    '../../a/b/z',
    'a/b/z',
    'a',
    '.',
    '../c/x/y',
    '../../../files/x/y/z.txt',
  ];

  var allArrays = [];
  var allObjects = [];
  var allExpected = [];

  for( var i = 0; i < from.length; i++ )
  {
    var relative = from[ i ];
    var path = to[ i ];
    var exp = expected[ i ];

    test.case = 'single pair inside array'
    var got = _.path.pathsRelative( relative, path );
    test.identical( got, exp );

    // test.case = 'as single object'
    // var o =
    // {
    //   relative : relative,
    //   path : path
    // }
    // allObjects.push( o );
    // var got = _.path.pathsRelative( o );
    // test.identical( got, exp );
  }

  test.case = 'relative to array of paths'; /* */
  var from4 = '/foo/bar/baz/asdf/quux/dir1/dir2';
  var to4 =
  [
    '/foo/bar/baz/asdf/quux/dir1/dir2',
    '/foo/bar/baz/asdf/quux/dir1/',
    '/foo/bar/baz/asdf/quux/',
    '/foo/bar/baz/asdf/quux/dir1/dir2/dir3',
  ];
  var expected4 = [ '.', '..', '../..', 'dir3' ];
  var got = _.path.pathsRelative( from4, to4);
  test.identical( got, expected4 );

  test.case = 'relative to array of paths, one of paths is relative, resolving off'; /* */
  var from4 = '/foo/bar/baz/asdf/quux/dir1/dir2';
  var to4 =
  [
    '/foo/bar/baz/asdf/quux/dir1/dir2',
    '/foo/bar/baz/asdf/quux/dir1/',
    './foo/bar/baz/asdf/quux/',
    '/foo/bar/baz/asdf/quux/dir1/dir2/dir3',
  ];
  test.shouldThrowErrorSync( function()
  {
    _.path.pathsRelative( from4, to4 );
  })

  // test.case = 'both relative, long, not direct,resolving 1'; /* */
  // var from = 'a/b/xx/yy/zz';
  // var to = 'a/b/files/x/y/z.txt';
  // var expected = '../../../files/x/y/z.txt';
  // var o =
  // {
  //   relative :  from,
  //   path : to,
  //   resolving : 1
  // }
  // var got = _.path.pathsRelative( o );
  // test.identical( got, expected );

  //

  test.case = 'works like relative';

  var got = _.path.pathsRelative( '/aa/bb/cc', '/aa/bb/cc' );
  var expected = _.path.relative( '/aa/bb/cc', '/aa/bb/cc' );
  test.identical( got, expected );

  var got = _.path.pathsRelative( '/foo/bar/baz/asdf/quux', '/foo/bar/baz/asdf/quux/new1' );
  var expected = _.path.relative( '/foo/bar/baz/asdf/quux', '/foo/bar/baz/asdf/quux/new1' );
  test.identical( got, expected );

  //

  if( !Config.debug )
  return;

  test.case = 'only relative';
  test.shouldThrowErrorSync( function()
  {
    _.path.pathsRelative( '/foo/bar/baz/asdf/quux' );
  })

  /**/

  test.shouldThrowErrorSync( function()
  {
    _.path.pathsRelative
    ({
      relative : '/foo/bar/baz/asdf/quux'
    });
  })

  // test.case = 'two relative, long, not direct'; /* */
  // var from = 'a/b/xx/yy/zz';
  // var to = 'a/b/files/x/y/z.txt';
  // var o =
  // {
  //   relative :  from,
  //   path : to,
  //   resolving : 0
  // }
  // var expected = '../../../files/x/y/z.txt';
  // var got = _.path.pathsRelative( o );
  // test.identical( got, expected );

  // test.case = 'relative to array of paths, one of paths is relative, resolving off'; /* */
  // var from = '/foo/bar/baz/asdf/quux/dir1/dir2';
  // var to =
  // [
  //   '/foo/bar/baz/asdf/quux/dir1/dir2',
  //   '/foo/bar/baz/asdf/quux/dir1/',
  //   './foo/bar/baz/asdf/quux/',
  //   '/foo/bar/baz/asdf/quux/dir1/dir2/dir3',
  // ];
  // test.shouldThrowErrorSync( function()
  // {
  //   _.path.pathsRelative([ { relative : from, path : to } ]);
  // })

  // test.case = 'one relative, resolving 0'; /* */
  // var from = 'c:/x/y';
  // var to = 'a/b/files/x/y/z.txt';
  // var o =
  // {
  //   relative :  from,
  //   path : to,
  //   resolving : 0
  // }
  // test.shouldThrowErrorSync( function()
  // {
  //   _.path.pathsRelative( o );
  // })

  test.case = 'different length'; /* */
  test.shouldThrowErrorSync( function()
  {
    _.path.pathsRelative( [ '/a1/b' ], [ '/a1','/a2' ] );
  })

}

//

/* example to avoid */

function isSafe( test )
{
  var path1 = '/home/user/dir1/dir2',
    path2 = 'C:/foo/baz/bar',
    path3 = '/foo/bar/.hidden',
    path4 = '/foo/./somedir',
    path5 = 'c:/foo/',
    path6 = 'c:\\foo\\',
    path7 = '/',
    path8 = '/a',
    got;

  test.case = 'safe posix path';
  var got = _.path.isSafe( path1 );
  test.identical( got, true );

  test.case = 'safe windows path';
  var got = _.path.isSafe( path2 );
  test.identical( got, true );

  // test.case = 'unsafe posix path ( hidden )';
  // var got = _.path.isSafe( path3 );
  // test.identical( got, false );

  test.case = 'safe posix path with "." segment';
  var got = _.path.isSafe( path4 );
  test.identical( got, true );

  test.case = 'unsafe windows path';
  var got = _.path.isSafe( path5 );
  test.identical( got, false );

  test.case = 'unsafe windows path';
  var got = _.path.isSafe( path6 );
  test.identical( got, false );

  test.case = 'unsafe short path';
  var got = _.path.isSafe( path7 );
  test.identical( got, false );

  test.case = 'unsafe short path';
  var got = _.path.isSafe( path8 );
  test.identical( got, false );

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.path.isSafe( );
  });

  test.case = 'argument is not string';
  test.shouldThrowErrorSync( function( )
  {
    _.path.isSafe( null );
  });

  test.case = 'too macny arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.path.isSafe( '/a/b','/a/b' );
  });

}

//

function isGlob( test )
{

  test.case = 'this is not glob';

  test.is( !_.path.isGlob( '!a.js' ) );
  test.is( !_.path.isGlob( '^a.js' ) );
  test.is( !_.path.isGlob( '+a.js' ) );
  test.is( !_.path.isGlob( '!' ) );
  test.is( !_.path.isGlob( '^' ) );
  test.is( !_.path.isGlob( '+' ) );

  /**/

  test.case = 'this is glob';

  test.is( _.path.isGlob( '?' ) );
  test.is( _.path.isGlob( '*' ) );
  test.is( _.path.isGlob( '**' ) );

  test.is( _.path.isGlob( '?c.js' ) );
  test.is( _.path.isGlob( '*.js' ) );
  test.is( _.path.isGlob( '**/a.js' ) );

  test.is( _.path.isGlob( 'dir?c/a.js' ) );
  test.is( _.path.isGlob( 'dir/*.js' ) );
  test.is( _.path.isGlob( 'dir/**.js' ) );
  test.is( _.path.isGlob( 'dir/**/a.js' ) );

  test.is( _.path.isGlob( '/dir?c/a.js' ) );
  test.is( _.path.isGlob( '/dir/*.js' ) );
  test.is( _.path.isGlob( '/dir/**.js' ) );
  test.is( _.path.isGlob( '/dir/**/a.js' ) );

  test.is( _.path.isGlob( '[a-c]' ) );
  test.is( _.path.isGlob( '{a,c}' ) );
  test.is( _.path.isGlob( '(a|b)' ) );

  test.is( _.path.isGlob( '(ab)' ) );
  test.is( _.path.isGlob( '@(ab)' ) );
  test.is( _.path.isGlob( '!(ab)' ) );
  test.is( _.path.isGlob( '?(ab)' ) );
  test.is( _.path.isGlob( '*(ab)' ) );
  test.is( _.path.isGlob( '+(ab)' ) );

  test.is( _.path.isGlob( 'dir/[a-c].js' ) );
  test.is( _.path.isGlob( 'dir/{a,c}.js' ) );
  test.is( _.path.isGlob( 'dir/(a|b).js' ) );

  test.is( _.path.isGlob( 'dir/(ab).js' ) );
  test.is( _.path.isGlob( 'dir/@(ab).js' ) );
  test.is( _.path.isGlob( 'dir/!(ab).js' ) );
  test.is( _.path.isGlob( 'dir/?(ab).js' ) );
  test.is( _.path.isGlob( 'dir/*(ab).js' ) );
  test.is( _.path.isGlob( 'dir/+(ab).js' ) );

  test.is( _.path.isGlob( '/index/**' ) );

}

//

function common( test )
{

  test.case = 'absolute-absolute'

  var got = _.path.common( '/a1/b2', '/a1/b' );
  test.identical( got, '/a1/' );

  var got = _.path.common( '/a1/b2', '/a1/b1' );
  test.identical( got, '/a1/' );

  var got = _.path.common( '/a1/x/../b1', '/a1/b1' );
  test.identical( got, '/a1/b1' );

  var got = _.path.common( '/a1/b1/c1', '/a1/b1/c' );
  test.identical( got, '/a1/b1/' );

  var got = _.path.common( '/a1/../../b1/c1', '/a1/b1/c1' );
  test.identical( got, '/' );

  var got = _.path.common( '/abcd', '/ab' );
  test.identical( got, '/' );

  var got = _.path.common( '/.a./.b./.c.', '/.a./.b./.c' );
  test.identical( got, '/.a./.b./' );

  var got = _.path.common( '//a//b//c', '/a/b' );
  test.identical( got, '/' );

  var got = _.path.common( '/a//b', '/a//b' );
  test.identical( got, '/a//b' );

  var got = _.path.common( '/a//', '/a//' );
  test.identical( got, '/a//' );

  var got = _.path.common( '/./a/./b/./c', '/a/b' );
  test.identical( got, '/a/b' );

  var got = _.path.common( '/A/b/c', '/a/b/c' );
  test.identical( got, '/' );

  var got = _.path.common( '/', '/x' );
  test.identical( got, '/' );

  var got = _.path.common( '/a', '/x'  );
  test.identical( got, '/' );

  test.case = 'absolute-relative'

  var got = _.path.common( '/', '..' );
  test.identical( got, '/' );

  var got = _.path.common( '/', '.' );
  test.identical( got, '/' );

  var got = _.path.common( '/', 'x' );
  test.identical( got, '/' );

  var got = _.path.common( '/', '../..' );
  test.identical( got, '/' );

  test.shouldThrowError( () => _.path.common( '/a', '..' ) );

  test.shouldThrowError( () => _.path.common( '/a', '.' ) );

  test.shouldThrowError( () => _.path.common( '/a', 'x' ) );

  test.shouldThrowError( () => _.path.common( '/a', '../..' ) );

  test.case = 'relative-relative'

  var got = _.path.common( 'a1/b2', 'a1/b' );
  test.identical( got, 'a1/' );

  var got = _.path.common( 'a1/b2', 'a1/b1' );
  test.identical( got, 'a1/' );

  var got = _.path.common( 'a1/x/../b1', 'a1/b1' );
  test.identical( got, 'a1/b1' );

  var got = _.path.common( './a1/x/../b1', 'a1/b1' );
  test.identical( got,'a1/b1' );

  var got = _.path.common( './a1/x/../b1', './a1/b1' );
  test.identical( got, 'a1/b1');

  var got = _.path.common( './a1/x/../b1', '../a1/b1' );
  test.identical( got, '..');

  var got = _.path.common( '.', '..' );
  test.identical( got, '..' );

  var got = _.path.common( './b/c', './x' );
  test.identical( got, '.' );

  var got = _.path.common( './././a', './a/b' );
  test.identical( got, 'a' );

  var got = _.path.common( './a/./b', './a/b' );
  test.identical( got, 'a/b' );

  var got = _.path.common( './a/./b', './a/c/../b' );
  test.identical( got, 'a/b' );

  var got = _.path.common( '../b/c', './x' );
  test.identical( got, '..' );

  var got = _.path.common( '../../b/c', '../b' );
  test.identical( got, '../..' );

  var got = _.path.common( '../../b/c', '../../../x' );
  test.identical( got, '../../..' );

  var got = _.path.common( '../../b/c/../../x', '../../../x' );
  test.identical( got, '../../..' );

  var got = _.path.common( './../../b/c/../../x', './../../../x' );
  test.identical( got, '../../..' );

  var got = _.path.common( '../../..', './../../..' );
  test.identical( got, '../../..' );

  var got = _.path.common( './../../..', './../../..' );
  test.identical( got, '../../..' );

  var got = _.path.common( '../../..', '../../..' );
  test.identical( got, '../../..' );

  var got = _.path.common( '../b', '../b' );
  test.identical( got, '../b' );

  var got = _.path.common( '../b', './../b' );
  test.identical( got, '../b' );

  test.case = 'several absolute paths'

  var got = _.path.common( '/a/b/c', '/a/b/c', '/a/b/c' );
  test.identical( got, '/a/b/c' );

  var got = _.path.common( '/a/b/c', '/a/b/c', '/a/b' );
  test.identical( got, '/a/b' );

  var got = _.path.common( '/a/b/c', '/a/b/c', '/a/b1' );
  test.identical( got, '/a' );

  var got = _.path.common( '/a/b/c', '/a/b/c', '/a' );
  test.identical( got, '/a' );

  var got = _.path.common( '/a/b/c', '/a/b/c', '/x' );
  test.identical( got, '/' );

  var got = _.path.common( '/a/b/c', '/a/b/c', '/' );
  test.identical( got, '/' );

  test.shouldThrowError( () => _.path.common( '/a/b/c', '/a/b/c', './' ) );

  test.shouldThrowError( () => _.path.common( '/a/b/c', '/a/b/c', '.' ) );

  test.shouldThrowError( () => _.path.common( 'x', '/a/b/c', '/a' ) );

  test.shouldThrowError( () => _.path.common( '/a/b/c', '..', '/a' ) );

  test.shouldThrowError( () => _.path.common( '../..', '../../b/c', '/a' ) );

  test.case = 'several relative paths';

  var got = _.path.common( 'a/b/c', 'a/b/c', 'a/b/c' );
  test.identical( got, 'a/b/c' );

  var got = _.path.common( 'a/b/c', 'a/b/c', 'a/b' );
  test.identical( got, 'a/b' );

  var got = _.path.common( 'a/b/c', 'a/b/c', 'a/b1' );
  test.identical( got, 'a' );

  var got = _.path.common( 'a/b/c', 'a/b/c', '.' );
  test.identical( got, '.' );

  var got = _.path.common( 'a/b/c', 'a/b/c', 'x' );
  test.identical( got, '.' );

  var got = _.path.common( 'a/b/c', 'a/b/c', './' );
  test.identical( got, '.' );

  var got = _.path.common( '../a/b/c', 'a/../b/c', 'a/b/../c' );
  test.identical( got, '..' );

  var got = _.path.common( './a/b/c', '../../a/b/c', '../../../a/b' );
  test.identical( got, '../../..' );

  var got = _.path.common( '.', './', '..' );
  test.identical( got, '..' );

  var got = _.path.common( '.', './../..', '..' );
  test.identical( got, '../..' );

}

//

function pathsCommon( test )
{
  var cases =
  [
    {
      description : 'simple',
      src : [ '/a1/b2', '/a1/b' , '/a1/b2/c' ],
      expected : '/a1'
    },
    {
      description : 'with array',
      src : [ '/a1/b2', [ '/a1/b' , '/a1/b2/c' ] ],
      expected : [ '/a1/' , '/a1/b2' ]
    },
    {
      description : 'two arrays',
      src : [ [ '/a1/b' , '/a1/b2/c' ], [ '/a1/b' , '/a1/b2/c' ] ],
      expected : [ '/a1/b' , '/a1/b2/c' ]
    },
    {
      description : 'mixed',
      src : [ '/a1', [ '/a1/b' , '/a1/b2/c' ], [ '/a1/b1' , '/a1/b2/c' ], '/a1' ],
      expected : [ '/a1' , '/a1' ]
    },
    {
      description : 'arrays with different length',
      src : [ [ '/a1/b' , '/a1/b2/c' ], [ '/a1/b1'  ] ],
      error : true
    },
    {
      description : 'incorrect argument',
      src : 'abc',
      error : true
    },
    {
      description : 'incorrect arguments length',
      src : [ 'abc', 'x' ],
      error : true
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    test.case = c.description;
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.path.pathsCommon.apply( _.path, c.src ) );
    }
    else
    {
      test.identical( _.path.pathsCommon( c.src ), c.expected );
    }
  }

}

//

function begins( test )
{

  var got = _.path.begins( 'this/is/some/path', 'this/is' );
  test.identical( got, true );

  var got = _.path.begins( 'this/is/some/path', 'this/is/some/path' );
  test.identical( got, true );

  var got = _.path.begins( 'this/is/some/path', '/this/is' );
  test.identical( got, false );

  var got = _.path.begins( 'this/is/some/path', '/this/is/some/path' );
  test.identical( got, false );

  var got = _.path.begins( '/this/is/some/path', 'this/is' );
  test.identical( got, false );

  var got = _.path.begins( '/this/is/some/path', 'this/is/some/path' );
  test.identical( got, false );

  var got = _.path.begins( '/this/is/some/path', '/this/is' );
  test.identical( got, true );

  var got = _.path.begins( '/this/is/some/path', '/this/is/some/path' );
  test.identical( got, true );

  var got = _.path.begins( '/this/is/some/pathpath', '/this/is/some/path' );
  test.identical( got, false );

  var got = _.path.begins( '/this/is/some/path', '/this/is/some/pathpath' );
  test.identical( got, false );

}

//

function ends( test )
{

  var got = _.path.ends( 'this/is/some/path', 'some/path' );
  test.identical( got, true );

  var got = _.path.ends( 'this/is/some/path', 'this/is/some/path' );
  test.identical( got, true );

  var got = _.path.ends( '/this/is/some/path', 'some/path' );
  test.identical( got, true );

  var got = _.path.ends( '/this/is/some/path', 'this/is/some/path' );
  test.identical( got, true );

  var got = _.path.ends( 'this/is/some/path', '/some/path' );
  test.identical( got, false );

  var got = _.path.ends( 'this/is/some/path', '/this/is/some/path' );
  test.identical( got, false );

  var got = _.path.ends( '/this/is/some/path', '/some/path' );
  test.identical( got, false );

  var got = _.path.ends( '/this/is/some/path', '/this/is/some/path' );
  test.identical( got, true );

  var got = _.path.ends( 'this/is/some/pathpath', 'path' );
  test.identical( got, false );

}

// --
// declare
// --

var Self =
{

  name : 'Tools/base/layer3/path/Fundamentals',
  silencing : 1,
  // verbosity : 7,
  // routine : 'relative',

  tests :
  {

    refine : refine,
    pathsRefine : pathsRefine,
    isRefined : isRefined,
    normalize : normalize,
    pathsNormalize : pathsNormalize,
    normalizeTolerant : normalizeTolerant,

    dot : dot,
    pathsDot : pathsDot,

    undot : undot,
    pathsUndot : pathsUndot,

    _pathJoin_body : _pathJoin_body,
    join : join,
    pathsJoin : pathsJoin,
    crossJoin : crossJoin,
    reroot : reroot,
    pathsReroot : pathsReroot,
    resolve : resolve,
    pathsResolve : pathsResolve,

    dir : dir,
    pathsDir : pathsDir,
    ext : ext,
    pathsExt : pathsExt,
    prefixGet : prefixGet,
    pathsPrefixesGet : pathsPrefixesGet,
    name : name,
    pathsName : pathsName,
    /*current : current,*/
    withoutExt : withoutExt,
    pathsWithoutExt : pathsWithoutExt,
    changeExt : changeExt,
    pathsChangeExt : pathsChangeExt,

    relative : relative,
    pathsRelative : pathsRelative,
    isSafe : isSafe,
    isGlob : isGlob,

    common : common,
    pathsCommon : pathsCommon,

    begins : begins,
    ends : ends,

  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

if( 0 )
if( typeof module === 'undefined' )
_.timeReady( function()
{

  _.Tester.verbosity = 99;
  _.Tester.logger = wPrinterToJs({ outputGray : 0, writingToHtml : 1 });
  _.Tester.test( Self.name,'PathUrlTest' )
  .doThen( function()
  {
    var book = _.Tester.loggerToBook();
  });

});

})();
