( function _FilesGraph_s_() {

'use strict';

/**
  @module Tools/mid/FilesArchive - Experimental. Several classes to reflect changes of files on dependent files and keep links of hard linked files. FilesArchive provides means to define interdependence between files and to forward changes from dependencies to dependents. Use FilesArchive to avoid unnecessary CPU workload.
*/

/**
 * @file files/FilesGraph.s.
 */

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = null;
let Self = function wFilesGraph( o )
{
  _.assert( arguments.length === 0 || arguments.length === 1, 'expects single argument' );
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'FilesGraph';

//

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.instanceInit( self );
  Object.preventExtensions( self )

  if( o )
  self.copy( o );

}

//

// function contentUpdate( head,data )
// {
//   let self = this;
//
//   _.assert( arguments.length === 2, 'expects exactly two arguments' );
//
//   let head = _.FileRecord.from( head );
//   let dependency = self._headToTailsFor( head );
//
//   dependency.node.hash = self._hashFor( data );
//
//   return dependency;
// }
//
// //
//
// function statUpdate( head,stat )
// {
//   let self = this;
//
//   _.assert( arguments.length === 2, 'expects exactly two arguments' );
//
//   let head = _.FileRecord.from( head );
//   let dependency = self._headToTailsFor( head );
//
//   dependency.node.mtime = stat.mtime.getTime();
//   dependency.node.ctime = stat.ctime.getTime();
//   dependency.node.birthtime = stat.birthtime.getTime();
//   dependency.node.size = stat.size;
//
//   return dependency;
// }

// --
// iterator
// --

function _eachHeadPre( routine,args )
{
  let self = this;
  let result = 0;
  let op;

  if( args.length === 2 )
  op = { path : args[ 0 ], onUp : args[ 1 ] };
  else
  op = args[ 0 ];

  _.routineOptions( routine,op );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( _.path.isAbsolute( op.path ) );
  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  op.visited = op.visited || [];

  let path = op.path;

  delete op.path;

  op.operation = op;

  op.iterationNew = function iterationNew( path )
  {
    let it = Object.create( op.operation );
    it.prevPath = this.path || null;
    it.path = path;
    return it;
  }

  let it = op.iterationNew( path )

  return [ it,op ];
}

//

function _eachHeadBody( it,op )
{
  let self = this;
  let result = 1;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  // _.assert( !!self.nodesMap[ it.path ] );

  if( _.arrayHas( op.visited,it.path ) )
  return;

  op.visited.push( it.path )

  if( op.onUp )
  op.onUp( it,op );

  let dep = self.headsForTailMap[ it.path ];

  if( !dep )
  return result;

  for( let h in dep.heads )
  {
    result += self.eachHead.body.call( self,it.iterationNew( h ),op );
  }

  if( op.onDown )
  op.onDown( it,op );

  return result;
}

_eachHeadBody.defaults =
{
  onUp : null,
  onDown : null,
  visited : null,
}

//

function eachHead( o )
{
  let self = this;
  let args = self.eachHead.preArguments.call( self, self.eachHead, arguments );
  let result = self.eachHead.body.apply( self, args );
  return result;
}

eachHead.preArguments = _eachHeadPre;
eachHead.body = _eachHeadBody;

eachHead.defaults =
{
  path : null,
  onUp : null,
  onDown : null,
}

// --
// file
// --

function fileChange( path )
{
  let self = this;
  let result = 0;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.path.isAbsolute( path ) );

  function onUp( it,op )
  {
    debugger;
    self.changedMap[ it.path ] = true;
    if( self.verbosity >= 3 )
    if( it.prevPath )
    logger.log( '. change',it.path,'by',it.prevPath );
    else
    logger.log( '. change',it.path );
  }

  let result = self.eachHead( path,onUp );
}

//

function filesUpdate( record )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  if( _.arrayIs( record ) )
  {
    for( let r = 0 ; r < record.length ; r++ )
    self.filesUpdate( record[ r ] );
    return self;
  }

  _.assert( record instanceof _.FileRecord );

  debugger;
  // self._nodeForChanging( record );
  if( !self._nodeForUpdating( record ) )
  {
    _.assert( !self.unprocessedMap[ record.absolute ] );
    return self;
  }

  delete self.unprocessedMap[ record.absolute ];

  return self;
}

//

function fileDeletedUpdate( path )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  /* */

  let dep = self.tailsForHeadMap[ path ]
  if( dep )
  for( let t in dep.tails )
  {
    let tail = self.headsForTailMap[ t ];
    _.assert( tail );
    let head = tail.heads[ path ];
    _.assert( head );
    delete tail.heads[ path ]
  }

  /* */

  let dep = self.headsForTailMap[ path ]
  if( dep )
  for( let h in dep.heads )
  {
    debugger; xxx
    let head = self.tailsForHeadMap[ h ];
    _.assert( head );
    let tail = head.tails[ path ];
    _.assert( tail );
    delete head.tails[ path ]
  }

  /* */

  delete self.tailsForHeadMap[ path ];
  delete self.headsForTailMap[ path ];
  delete self.nodesMap[ path ];

}

//

function fileIsUpToDate( head )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( head instanceof _.FileRecord );

  if( self.changedMap[ head.absolute ] )
  return false;

  return true;
}

//

function unprocessedDelete()
{
  let self = this;
  let fileProvider = self.fileProvider;

  _.assert( arguments.length === 0 );

  if( !self.unporcessedDstUnmapping )
  return;

  for( let n in self.unprocessedMap )
  {
    let node = self.unprocessedMap[ n ];

    if( _.strBegins( n,self.dstPath ) )
    {
      if( !self.unporcessedDstDeleting )
      fileProvider.fileDelete({ filePath : n, verbosity : self.verbosity });
    }

    delete self.unprocessedMap[ n ];
    self.fileDeletedUpdate( n );

  }

}

//

function unprocessedReport()
{
  let self = this;
  let fileProvider = self.fileProvider;

  _.assert( arguments.length === 0 );

  let unprocessedMapKeys = _.mapKeys( self.unprocessedMap );
  if( unprocessedMapKeys.length )
  {

    if( self.verbosity >= 4 )
    for( let n in self.unprocessedMap )
    {

      if( _.strBegins( n,self.dstPath ) )
      {
        logger.log( '? unprocessed dst',n );
      }
      else if( _.strBegins( n,self.srcPath ) )
      {
        logger.log( '? unprocessed src',n );
      }
      else
      {
        logger.log( '? unprocessed unknown',n );
      }

    }

    if( self.verbosity >= 2 )
    logger.log( unprocessedMapKeys.length + ' unprocessed files' );

  }

}

// --
// dependency
// --

function dependencyAdd( head,tails )
{
  let self = this;

  if( tails instanceof _.FileRecord )
  tails = [ tails ];

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( head instanceof _.FileRecord );
  _.assert( _.arrayIs( tails ) );

  if( _.strHas( head.absolute,'backgroundDraw.chunk' ) )
  debugger;

  /* */

  delete self.unprocessedMap[ head.absolute ];
  for( let t = 0 ; t < tails.length ; t++ )
  {
    let tailRecord = tails[ t ];
    delete self.unprocessedMap[ tailRecord.absolute ];
  }

  /* */

  let headToTails = self._headToTailsFor( head );
  for( let t = 0 ; t < tails.length ; t++ )
  {
    let tailRecord = tails[ t ];
    _.assert( tailRecord instanceof _.FileRecord );

    // let tailNode = self.nodesMap[ headToTails.tails[ tailRecord.absolute ] ];
    // if( tailNode )
    // _.assert( self._nodeRecordSame( tailNode, tailRecord ) );

    headToTails.tails[ tailRecord.absolute ] = self._nodeForChanging( tailRecord );
    headToTails.tails[ tailRecord.absolute ] = headToTails.tails[ tailRecord.absolute ].absolute;
  }

  /* */

  for( let t = 0 ; t < tails.length ; t++ )
  {
    let tailRecord = tails[ t ];
    _.assert( tailRecord instanceof _.FileRecord );

    let tailToHeads = self._tailToHeadsFor( tailRecord );

    // let headNode = self.nodesMap[ tailToHeads.heads[ head.absolute ] ];
    // if( headNode )
    // _.assert( self._nodeRecordSame( headNode, head ) );

    tailToHeads.heads[ head.absolute ] = self._nodeForChanging( head );
    tailToHeads.heads[ head.absolute ] = tailToHeads.heads[ head.absolute ].absolute;
  }

  /* */

  return self;
}

//

function _headToTailsFor( headRecord )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( headRecord instanceof _.FileRecord );

  let dependency = self.tailsForHeadMap[ headRecord.absolute ];

  if( !dependency )
  {
    dependency = self.tailsForHeadMap[ headRecord.absolute ] = Object.create( null );
    dependency.tails = Object.create( null );
    dependency.head = self._nodeForChanging( headRecord );
    dependency.head = dependency.head.absolute;
    Object.preventExtensions( dependency );
  }
  else
  {
    self._nodeForChanging( headRecord );
  }

  return dependency;
}

//

function _tailToHeadsFor( tailRecord )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( tailRecord instanceof _.FileRecord );

  let dependency = self.headsForTailMap[ tailRecord.absolute ];

  if( !dependency )
  {
    dependency = self.headsForTailMap[ tailRecord.absolute ] = Object.create( null );
    dependency.heads = Object.create( null );
    dependency.tail = self._nodeForChanging( tailRecord );
    dependency.tail = dependency.tail.absolute;
    Object.preventExtensions( dependency );
  }
  else
  {
    self._nodeForChanging( tailRecord );
  }

  return dependency;
}

// --
// node
// --

function _nodeMake( record )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( !self.nodesMap[ record.absolute ] );

  let node = Object.create( null );
  self._nodeFromRecord( node,record );
  Object.preventExtensions( node );
  self.nodesMap[ record.absolute ] = node;

  return node;
}

//

function _nodeFor( record )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  let node = self.nodesMap[ record.absolute ];

  if( node )
  {
    _.assert( self._nodeRecordSame( node,record ) );
    return node;
  }

  node = self._nodeMake( record );

  return node;
}

//

function _nodeForChanging( record )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  let node = self.nodesMap[ record.absolute ];

  if( !node )
  {

    node = self._nodeMake( record );
    self.fileChange( record.absolute );

  }
  else
  {
    if( !self._nodeRecordSame( node,record ) )
    {
      self._nodeFromRecord( node,record );
      self.fileChange( record.absolute );
    }
  }

  return node;
}

//

function _nodeForUpdating( record )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  let node = self.nodesMap[ record.absolute ];

  if( !node )
  {

    if( !record.isActual )
    {
      debugger;
      self.fileChange( record.absolute );
      debugger;
      return null;
    }

    node = self._nodeMake( record );
    self.fileChange( record.absolute );

  }
  else
  {

    if( !self._nodeRecordSame( node,record ) )
    {
      self._nodeFromRecord( node,record );
      self.fileChange( record.absolute );
    }

  }

  return node;
}

//

function _nodeFromRecord( node,record )
{
  let self = this;
  let provider = self.provider;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( record instanceof _.FileRecord );

  node.absolute = record.absolute;
  node.relative = record.relative;

  if( !record.stat )
  {
    node.hash = null;
    node.hash2 = null;
    node.size = null;
    node.mtime = null;
    node.ctime = null;
    node.birthtime = null;
  }
  else
  {
    node.hash = record.hashGet();
    node.hash2 = _.fileStatHashGet( record.stat );
    node.size = record.stat.size;
    node.mtime = record.stat.mtime.getTime();
    node.ctime = record.stat.ctime.getTime();
    node.birthtime = record.stat.birthtime.getTime();
  }

  return node;
}

//

function _nodeRecordSame( node,record )
{
  let self = this;
  let provider = self.provider;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.mapIs( node ) );
  _.assert( record instanceof _.FileRecord );

  if( !record.stat )
  return false;

  if( node.absolute !== record.absolute )
  return false;

  if( node.relative !== record.relative )
  return false;

  if( node.size !== record.stat.size )
  return false;

  if( node.mtime !== record.stat.mtime.getTime() )
  return false;

  if( node.ctime !== record.stat.ctime.getTime() )
  return false;

  if( node.birthtime !== record.stat.birthtime.getTime() )
  return false;

  // if( node.hash !== record.hashGet() )
  // return false;

  return true;
}

// --
// etc
// --

function _hashFor( src )
{

  let result;
  let crypto = require( 'crypto' );
  let md5sum = crypto.createHash( 'md5' );

  _.assert( arguments.length === 1, 'expects single argument' );

  try
  {
    md5sum.update( src );
    result = md5sum.digest( 'hex' );
  }
  catch( err )
  {
    throw _.err( err );
  }

  return result;
}

//

function storageLoaded( storageFilePath,mapExtend )
{
  let self = this;
  let fileProvider = self.fileProvider;

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  _.mapExtend( self.unprocessedMap,mapExtend.nodesMap );

  let storage = _.mapExtend( self.storageToSave,mapExtend );
  self.storageToSave = storage;

  return true;
}

// --
// actionName
// --

function actionReset()
{
  let self = this;
  self.basePath = null;
}

//

function actionFuture( actionName )
{
  let self = this;

  _.assert( _.strIs( actionName ) || actionName === null );

  self.futureAction = actionName;

}

//

function actionBegin( actionName )
{
  let self = this;

  _.assert( self.currentAction === null );
  _.assert( _.strIs( actionName ) || actionName === null );
  _.assert( arguments.length === 1, 'expects single argument' );

  /* name */

  if( self.futureAction )
  {
    actionName = self.futureAction + actionName;
    self.futureAction = null
  }

  self.currentAction = actionName;

  /* path */

  self.srcPath = _.path.normalize( self.srcPath );
  self.dstPath = _.path.normalize( self.dstPath );
  if( self.basePath === null )
  self.basePath = _.path.common( self.srcPath, self.dstPath );

  /* storage */

  self._storageLoad( self.dstPath );

}

//

function actionEnd( actionName )
{
  let self = this;

  _.assert( self.currentAction === actionName || actionName === undefined );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  self.unprocessedReport();
  self.unprocessedDelete();

  self.storageSave( self.dstPath );

  self.currentAction = null;
}

// --
//
// --

// function _verbositySet( val )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1, 'expects single argument' );
//
//   if( !_.numberIs( val ) )
//   val = val ? 1 : 0;
//   if( val < 0 )
//   val = 0;
//
//   self[ verbositySymbol ] = val;
// }

//

function _storageToSaveSet( storage )
{
  let self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  // self.changedMap = storage.changedMap;
  self.nodesMap = storage.nodesMap;
  self.headsForTailMap = storage.headsForTailMap;
  self.tailsForHeadMap = storage.tailsForHeadMap;

}

//

function _storageToSaveGet()
{
  let self = this;
  let storage = Object.create( null );

  // storage.changedMap = self.changedMap;
  storage.nodesMap = self.nodesMap;
  storage.headsForTailMap = self.headsForTailMap;
  storage.tailsForHeadMap = self.tailsForHeadMap;

  return storage;
}

// --
//
// --

/*
  - changedMap could have path without nodes
  - unprocessedMap could not have path without nodes
*/

let verbositySymbol = Symbol.for( 'verbosity' );

let Composes =
{

  verbosity : 5,

  currentAction : null,
  futureAction : null,

  storageFileName : '.wfilesgraph',
  basePath : null,
  dstPath : '/',
  srcPath : '/',
  unporcessedDstUnmapping : 1,
  unporcessedDstDeleting : 1,

  changedMap : _.define.own( {} ),
  unprocessedMap : _.define.own( {} ),

  nodesMap : _.define.own( {} ),
  headsForTailMap : _.define.own( {} ),
  tailsForHeadMap : _.define.own( {} ),

}

let Aggregates =
{
}

let Associates =
{
  fileProvider : null,
}

let Restricts =
{
}

let Statics =
{
}

let Forbids =
{

  comparingRelyOnHardLinks : 'comparingRelyOnHardLinks',
  replacingByNewest : 'replacingByNewest',
  maxSize : 'maxSize',

  fileByHashMap : 'fileByHashMap',

  fileMap : 'fileMap',
  fileAddedMap : 'fileAddedMap',
  fileRemovedMap : 'fileRemovedMap',
  fileModifiedMap : 'fileModifiedMap',

  fileHashMap : 'fileHashMap',

  fileMapAutosaving : 'fileMapAutosaving',
  fileMapAutoLoading : 'fileMapAutoLoading',

  mask : 'mask',
  dependencyMap : 'dependencyMap',

}

let Accessors =
{
  // verbosity : 'verbosity',
  storageToSave : 'storageToSave',
}

// --
// declare
// --

let Proto =
{

  init : init,

  // contentUpdate : contentUpdate,
  // statUpdate : statUpdate,

  // iterator

  _eachHeadPre : _eachHeadPre,
  _eachHeadBody : _eachHeadBody,
  eachHead : eachHead,

  // file

  fileChange : fileChange,
  filesUpdate : filesUpdate,
  fileDeletedUpdate : fileDeletedUpdate,
  fileIsUpToDate : fileIsUpToDate,

  unprocessedDelete : unprocessedDelete,
  unprocessedReport : unprocessedReport,

  // dependency

  dependencyAdd : dependencyAdd,
  _headToTailsFor : _headToTailsFor,
  _tailToHeadsFor : _tailToHeadsFor,

  // node

  _nodeMake : _nodeMake,
  _nodeFor : _nodeFor,
  _nodeForChanging : _nodeForChanging,
  _nodeForUpdating : _nodeForUpdating,

  _nodeFromRecord : _nodeFromRecord,
  _nodeRecordSame : _nodeRecordSame,

  // etc

  _hashFor : _hashFor,
  storageLoaded : storageLoaded,

  // action

  actionReset : actionReset,
  actionFuture : actionFuture,
  actionBegin : actionBegin,
  actionEnd : actionEnd,

  //

  // _verbositySet : _verbositySet,
  _storageToSaveSet : _storageToSaveSet,
  _storageToSaveGet : _storageToSaveGet,

  //


  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Forbids : Forbids,
  Accessors : Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

//

_.Copyable.mixin( Self );
_.StateStorage.mixin( Self );
_.Verbal.mixin( Self );
_global_[ Self.name ] = _[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
