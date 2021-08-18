( function _FileProvider_Hub_test_ss_( ) {

'use strict';

// !!! disabled because Provider.Hub is in implementation phase

if( typeof module !== 'undefined' )
{

  require( './aFileProvider.test.s' );

}

//

var _ = _global_.wTools;
var Parent = wTests[ 'Tools/mid/files/fileProvider/Abstract' ];

_.assert( !!Parent );

//

function makePath( filePath )
{
  filePath =  _.path.join( this.testRootDirectory,  filePath );
  filePath = _.path.normalize( filePath );
  return filePath;
}

//

function pathsAreLinked( paths )
{
  var statsFirst = this.provider.fileStat( paths[ 0 ] );
  for( var i = 1; i < paths.length; i++ )
  {
    var statCurrent = this.provider.fileStat( paths[ i ] );
    if( !_.fileStatsCouldBeLinked( statsFirst, statCurrent ) )
    return false
  }

  return true;
}

//

function linkGroups( paths, groups )
{
  groups.forEach( ( g ) =>
  {
    if( g.length >= 2 )
    {
      var filePathes = g.map( ( i ) => paths[ i ] );
      this.provider.linkHard({ filePaths : filePathes });
    }
  })
}

//

function makeFiles( names, dirPath, data )
{
  var self = this;

  if( !_.arrayIs( data ) )
  data = _.arrayFillTimes( [], names.length, data );

  _.assert( data.length === names.length );

  var paths = names.map( ( p )  => self.makePath( _.path.join( dirPath, p ) ) );
  paths.forEach( ( p, i )  =>
  {
    if( self.provider.fileStat( p ) )
    self.provider.fileTouch({ filePath : p, purging : 1 });

    self.provider.fileWrite( p, data[ i ] )
  });

  return paths;
}

//

function testDirMake( test )
{
  var self = this;
  self.testRootDirectory = _.path.dirTempOpen( _.path.join( __dirname, '../..'  ) );
}

//

function testDirClean()
{
  var self = this;
  debugger
  self.provider.filesDelete({ filePath : self.testRootDirectory });
}

// --
// declare
// --

var Proto =
{

  name : 'Tools/mid/files/fileProvider/Hub/other',
  abstract : 0,
  silencing : 1,
  enabled : 0,

  onSuiteBegin : testDirMake,
  onSuiteEnd : testDirClean,

  context :
  {
    provider : _.FileProvider.Hub({ defaultProvider : _.fileProvider }),
    makePath : makePath,
    makeFiles : makeFiles,
    pathsAreLinked : pathsAreLinked,
    linkGroups : linkGroups,
    testDirMake : testDirMake,
    testRootDirectory : null,
    testFile : null,
    // testRootDirectory : __dirname + '/../../../../tmp.tmp/hard-drive',
    // testFile : __dirname + '/../../../../tmp.tmp/hard-drive/test.txt',
  },

  tests :
  {
    // fileRenameSync : null,
  },

}

//

// var Self = new wTestSuite( Parent ).extendBy( Proto );
var Self = new wTestSuite( Proto ).inherit( Parent );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
