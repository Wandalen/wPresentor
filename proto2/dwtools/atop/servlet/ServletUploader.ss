( function _ServletUploader_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{

  require( './Servlet.ss' );

  var _ = _global_.wTools;

  _.include( 'wEventHandler' );

  var Path = require( 'path' );
  var File = require( 'fs-extra' );
  var Https = require( 'https' );
  var Http = require( 'http' );
  var Express = require( 'express' );

  var stringify = require( 'json-stringify-safe' );
  var Request = require( 'request' );

  var inspect = require( 'util' ).inspect;
  var Busboy = require( 'busboy' );
  var qs = require( 'qs' )

  var DataBase = null;

}

//

var _ = _global_.wTools;
var Parent = null;
var Self = function wServletUploader( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'ServletUploader';

//

function init( o )
{
  var self = this;

  _.instanceInit( self );

  if( self.Self === Self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( !self.express )
  self.express = Express();
  var express = self.express;

  _.servlet.controlLoggingPre.call( self );

  /* path */

  if( self.filePath === null ) self.filePath = _.path.join( __dirname , '../../../files/' );
  if( self.filePath ) self.filePath = _.path.normalize( self.filePath );
  if( self.forCopy === null ) self.forCopy = '';
  if( self.forCopy ) self.forCopy = _.path.normalize( self.forCopy );

  var filePath = self.filePath;
  if( filePath ) File.mkdirpSync( filePath, function( err )
  {
    if( err )
    throw 'Cant create directory : ' + filePath;
  });

  var forCopy = self.forCopy;
  if( forCopy ) File.mkdirpSync( forCopy, function( err )
  {
    if( err )
    throw 'Cant create directory : ' + forCopy;
  });

  /* url */

  if( self.url === null ) self.url = '/';
  if( self.urlUpload === null ) self.urlUpload = _.uri.join( self.url,'upload' );
  if( self.urlFileGet === null ) self.urlFileGet = _.uri.join( self.url,'file/' );
  if( self.urlDbfileGet === null ) self.urlDbfileGet = _.uri.join( self.url,'dbfile/' );

  /* normalize */

  _.servlet.controlPathesNormalize.call( self );

  /* db */

  if( self.usingDatabase || self.exposeDbfiles )
  DataBase = require( '../amidback/DataBase.ss' );

  if( self.usingDatabase )
  {

    if( self.db === null ) self.db = new DataBase({ address :self.dbAddress });
    self.db.onceConnected( function(){

      var db = self.db;

      db.connectGridfs();
      //db.collection = self.db.connection.collection( self.dbAddress.collection );
      //db.db = self.db.connection.db( self.dbAddress.db );

      db.DbfileSchema = new db.Mongoose.Schema( {},{ strict : false } );
      db.Dbfile = db.ose.model( 'File.files',db.DbfileSchema );

    });

  }

  /* regexp */

  self.regexpUpload = new RegExp( '\/?^' + _.regexpEscape( self.urlUpload )            + '\/?$' );
  self.regexpDbfile = new RegExp( '\/?^' + _.regexpEscape( self.urlDbfileGet )         + '(.+)\/?$' );

  /* bind */

  /*self.express.use( _.routineJoin( self,self.responseHandler ) );*/

  self.express.all( self.regexpUpload, _.routineJoin( self,self.responseUpload ) );

  if( self.exposeDbfiles )
  self.express.all( self.regexpDbfile, _.routineJoin( self,self.responseDbfile ) );

  /* */

  _.servlet.controlLoggingPost.call( self );
  _.servlet.controlExpressStart.call( self );

}

// --
//
// --

function _generateUniqueName( o )
{
  var self = this;

  if( o.attempts === undefined )
  o.attempts = self.attempts;
  if( o.usingOriginalName === undefined )
  o.usingOriginalName = self.usingOriginalName;

  _.assert( _.numberIs( o.attempts ) );
  _.assertMapHasOnly( o,_generateUniqueName.defaults );
  o.result;

  function tryAgain( reason )
  {
    if( o.usingOriginalName )
    return _.err( 'Too many attempts made : cant use original name : ' + o.name );
    delete o.name;
    delete o.absolute;
    self.onGenerateUniqueName( o );
  }

  if( !o.attempts )
  return _.err( 'Too many attempts made : cant generate path for : ' + o.name );

  o.attempts -= 1;

  if( o.name ) o.name = o.name;
  else if( o.usingOriginalName ) o.name = o.fileName;
  else o.name = self.onGenerateId( o.fileName );

  if( o.folder )
  o.name = o.folder + '/' + o.name;

  if( !o.usingDatabase )
  {
    o.absolute = _.path.join( self.filePath,o.name );

    if( !File.existsSync( o.absolute ) )
    return o.name;
    tryAgain( o.absolute );
  }
  else
  {
    throw _.err( 'not tested' );

    var selector = { filename : o.name };
    db.gridfs.exist( selector, function( err, found )
    {
      if( !err && !found )
      return o.name;
      tryAgain( o.name );
    });
  }

  return o.name;
}

_generateUniqueName.defaults =
{
  attempts : 10,
  fileName : '',
  folder : '',
  usingOriginalName : 1,
}

//

function fileSave( o )
{

  //console.log( 'Saving',o.mimetype,o.fileName );
  // file,fileName,mimetype

  var self = this;
  var db = self.db;

  if( o.filePath === undefined ) o.filePath = self.filePath;
  if( _.strIs( o.file ) ) o.file = File.createReadStream( o.file );

  _.assertMapHasOnly( o,fileSave.defaults );
  _.assert( self.attempts > 0 );

  //

/*
  function handleSuccess()
  {
    return self._fileSave( o );
  }

  function handleFailed( reason )
  {
    if( o.onEnd )
    _.timeAfter( 0,_.routineJoin( self,o.onEnd,[ _.err( 'Name conflict :',reason ) ] ) );
  }

  //if( o.findName ) return self._fileSave( o );
  //else
  {

    _generateUniqueName( self.attempts );

  }
*/

  o.name = self.onGenerateUniqueName
  ({
    attempts : self.attempts,
    fileName : o.fileName,
    folder : o.folder,
    usingOriginalName : self.usingOriginalName || self.savingIntoFolders,
  });

  if( _.strIs( o.name ) )
  return self._fileSave( o );
  else
  {
    if( o.onEnd )
    _.timeAfter( 0,_.routineJoin( self,o.onEnd,[ o.name ] ) );
    return _.Consequence().error( o.name );
  }

}

fileSave.defaults =
{
  filePath : '',
  folder : '',
  fileName : '',
  mimetype : '',
  file : null,
  onEnd : null,
}

//

function _fileSave( o )
{

  //console.log( 'Saving',o.mimetype,o.fileName );
  // file,fileName,mimetype

  var self = this;
  var ended = 0;
  var result = o.result = o.result || {};
  var db = self.db;

  // o

  if( !o.name ) throw _.err( 'ServletUploader.fileSave :','name is not defined' );

  if( o.usingDatabase )
  {
    result.name   = o.name;
    result.url  = _.uri.join( self.urlDbfileGet,o.name );
  }
  else
  {
    result.name       = o.name;
    result.url      = _.uri.join( self.urlFileGet,o.name );
    result.path     = _.path.join( o.filePath,o.name );
  }

  // copy path

  if( o.forCopy === undefined ) o.forCopy = self.forCopy;
  if( o.forCopy ) o.forCopy = _.path.join( o.forCopy,o.name );

  // handleEnd

  function handleEnd( err )
  {

    debugger;
    if( !err && ended )
    return;

    ended = 1;

    if( err )
    _.errLog( '_fileSave.err :',err );

    if( Config.debug )
    {
      if( err ) console.error( 'ServletUploader.save :','failed to save :',result.url,'\n',err,o );
      else console.log( 'ServletUploader.save :','saved :',result.path );
    }

    if( !err && !o.usingDatabase )
    {
      if( o.forCopy )
      File.copy( result.path, o.forCopy, function( err )
      {
        if( err ) return _.errLog( err );
      });
    }

    if( o.onEnd )
    o.onEnd( err,result );

  }

  // on data

  /*
  file.on( 'data', function( data ) {
    console.log( 'File [' + fieldName + '] got ' + data.length + ' bytes' );
  });
  */

  // write stream

  var writeStream;

  if( o.usingDatabase )
  {

    var writeStream = db.gridfs.createWriteStream
    ({
      filename : o.name,
      mode : 'w',
      content_type : o.mimetype,
    });
    var id = writeStream.id;
    var ext = _.path.ext( result.name );
    if( ext ) ext = '.' + ext;
    result.url = _.uri.join( self.urlDbfileGet,String( id ) + ext );

  }
  else
  {

    writeStream = File.createWriteStream( result.path );

    writeStream.on( 'error',function( err )
    {

      handleEnd( err || 'cant open ' + result.path );

    })

  }

  // on end

  o.file.on( 'end', function()
  {
  });

  // on error

  o.file.on( 'error', function( err )
  {

    handleEnd( err );

  });

  // on unpipe

  writeStream.on( 'unpipe', function( reader )
  {

    //handleEnd( null );

  });

  // on finish

  writeStream.on( 'finish', function( reader )
  {

    handleEnd( null );

  });

  // launch

  o.file.pipe( writeStream );

  return result;
}

//

function fileExtract( url,o )
{

  var self = this;
  var db = self.db;

  if( _.objectIs( url ) )
  {
    o = url;
    url = o.url;
  }

  // o

  o.url = url;
  if( !_.strIs( o.url ) ) throw _.err( 'ServletUploader.fileExtract :','"url" must be string' );

  if( o.filePath === undefined ) o.filePath = self.filePath;

  if( o.copyAnyway === undefined ) o.copyAnyway = 0;
  o.usingDatabase = o.url.indexOf( self.urlDbfileGet ) !== -1;

  // save o

  var saveOptions = {};
  saveOptions.usingDatabase = 0;
  saveOptions.onEnd = _.routineJoin( self,o.onEnd );

  //

  if( o.usingDatabase )
  {
    debugger;
    o.id = _.strIsolateEndOrNone( o.url,self.urlDbfileGet )[ 2 ];

    if( !o.id ) return _.timeAfter( 0,o.onEnd,_.err( 'ServletUploader.fileExtract :','bad url',o ) );

    if( o.id.indexOf( '.' ) !== -1 ) o.id = o.id.split( '.' )[ 0 ];

    var selector = { _id : o.id };

    saveOptions.file = db.gridfs.createReadStream( selector );

    db.Dbfile.find( selector ).lean().exec( function( err,files )
    {

      if( err || !files.length )
      return _.timeAfter( 0,o.onEnd,_.err( 'ServletUploader.fileExtract :','not found',o ) );

      saveOptions.name = files[ 0 ].filename;
      self.fileSave( saveOptions );

    });

  }
  else
  {
    debugger;
    o.id = _.strIsolateEndOrNone( o.url,self.urlFileGet )[ 2 ];

    if( !o.copyAnyway )
    {
      var result =
      {
        id        : o.id,
        url       : o.url,
        path      : _.path.join( o.filePath,o.id ),
      };
      _.timeAfter( 0,o.onEnd,self,null,result );
      return result;
    }

    if( !o.id ) return _.timeAfter( 0,o.onEnd,_.err( 'ServletUploader.fileExtract :','bad url',o ) );

    saveOptions.file = File.createReadStream( _.path.join( o.filePath,o.id ) );

    throw 'Not tested';

    self.fileSave( saveOptions );

  }

}

// --
// handle
// --

function handleUpload( request, onReady )
{
  var self = this;
  var result = {};
  var fields = {};

  if( request.method !== 'POST' )
  return onReady( _.err( 'ServletUploader.handleUpload :','Only post supported' ) );

  //

  var folder;
  if( self.savingIntoFolders && !self.usingDatabase )
  {
    debugger;
    var o =
    {
      fileName : 'folder',
      usingOriginalName : 0,
    };
    folder = self.onGenerateUniqueName( o );
    if( !_.strIs( folder ) )
    return folder;

    File.mkdirpSync( o.absolute, function( err )
    {
      if( err ) throw 'Cant create directory : ' + folder;
    });

  }

  //

  var errors = [];
  var waiter = new wWaiter({ onEnd : function( err )
  {

    debugger;
    if( !err && errors.length )
    err = _.err( errors.join( '\n' ) );
    return onReady.call( self,err,result,fields );

  }}).enter();

  var busboy = new Busboy
  ({
    headers : request.headers,
    limits :
    {

      fieldSize : self.fileSizeLimit,
      fileSize : self.fileSizeLimit,
      /*files : 1,*/

    }
  });

  //

  busboy
  .on( 'file', function( fieldName, file, fileName, encoding, mimetype )
  {

    waiter.enter();

    self.fileSave
    ({

      file : file,
      fileName : fileName,
      folder : folder,
      mimetype : mimetype,

      onEnd : function( err,r )
      {

        result[ fileName ] = r;
        if( err )
        errors.push( err );
        waiter.leave();

      }

    });

  })
  .on( 'field', function( fieldName, val, fieldNameTruncated, valTruncated )
  {

    fields[ fieldName ] = val;

    console.log( 'Field [ ' + fieldName + ' ]' );
    console.log( 'Field [ ' + fieldName + ' ] : value : ' + inspect( val ) );

  })
  .on( 'finish', function()
  {

    waiter.leave();

    //console.log( 'Done parsing form!' );
    //response.writeHead( 303, { Connection : 'close', Location : '/' });
    //response.writeHead( 200, { 'Content-Type' : 'application/json'});
    //response.write( stringify( result ) );
    //response.end();

  });

  request.pipe( busboy );

  return 1;
}

//

function handleResponseDbfileWithUrl( url, response, onEnd )
{

  var self = this;
  var result = {};
  var db = self.db;

  if( !url )
  return onEnd( _.err( 'ServletUploader.handleResponseDbfileWithUrl :','no url' ) );

  url = self.regexpDbfile.exec( url );

  if( !url )
  return onEnd( _.err( 'ServletUploader.handleResponseDbfileWithUrl :','no url' ) );

  return self.handleResponseDbfileWithId( url[1],response,onEnd );
}

//

function handleResponseDbfileWithId( id, response, onEnd )
{
  var self = this;
  var result = {};
  var db = self.db;
  var idObject;

  if( id.indexOf( '.' ) !== -1 )
  id = id.split( '.' )[ 0 ];

  if( !id )
  return onEnd( _.err( 'ServletUploader.handleResponseDbfileWithId :','no id' ) );

  try
  {
    idObject = db.Mongo.ObjectID( id )
  }
  catch( err )
  {
    return onEnd( err );
  }

  var selector = { _id : idObject };

  db.gridfs.exist( selector, function( err, found )
  {

    if( err || !found ) return onEnd( err );

    var selector = { _id : id };
    db.Dbfile.find( selector ).lean().exec( function( err,records )
    {

      if( err || !records.length ) return onEnd( err );

      var mime = records[ 0 ].contentType || 'application/octet-stream';
      response.writeHead( 200,{ 'Content-Type' : mime });
      var readstream = db.gridfs.createReadStream( selector );
      readstream.pipe( response );

      readstream.on( 'end', function( reader )
      {
        onEnd( null );
      });

    });

  });

}

// --
// response
// --

function responseUpload( request, response, next )
{
  var self = this;

  if( request.method !== 'POST' )
  return _.servlet.errorHandle( request, response, next );

  return self.handleUpload( request,function( err,result )
  {

    _.servlet.controlAllowCrossDomain( request, response );

    if( self.onUploaded )
    self.onUploaded( err,result );

    if( err || !result )
    return _.servlet.errorHandle( request, response, next, err );

    response.writeHead( 200,{ 'Content-Type' : 'application/json' } );
    response.write( stringify( result ) );
    response.end();

  });

}

//

function responseDbfile( request, response, next )
{

  var self = this;
  var db = self.db;
  var result = {};
  //var id;

  if( request.method !== 'GET' ) return _.servlet.errorHandle( request, response, next );
  request.id = request.params[ 0 ];
  //if( request.id.indexOf( '.' ) !== -1 ) request.id = request.id.split( '.' )[ 0 ];
  //if( !request.id ) return _.servlet.errorHandle( request, response, next );

  return self.handleResponseDbfileWithId( request.id,response,function( err ){

    if( err ) return _.servlet.errorHandle( request, response, next );

  });

}

//
//
// function responseHandler( request, response, next )
// {
//
//   var self = this;
//   var result = null;
//
//   /*
//   if( self.reUpload.test( request.u.localPath ) )
//   {
//     result = self.responseUpload( request, response, next );
//   }
//   */
//
//   if( !result ) next();
// }

// --
// relations
// --

var Composes =
{

  name : Self.shortName,
  url : '/',
  path : '.',
  port : null,
  verbosity : 1,
  usingHttps : 0,
  allowCrossDomain : 1,

  attempts : 10,
  savingIntoFolders : 1,
  usingOriginalName : 0,
  usingDatabase : 0,
  exposeDbfiles : 0,
  fileSizeLimit : 0x1000000000,

  filePath : null,
  forCopy : '',

  url : '/',
  urlUpload : null,
  urlFileGet : null,
  urlDbfileGet : null,

  regexpUpload : null,
  regexpDbfile : null,

  onGenerateUniqueName : _generateUniqueName,
  onGenerateId : _.routineJoin( _,_.idWithDate,[ '' ] ),
  onUploaded : null,

}

var Associates =
{
  express : null,
  server : null,
  db : null,
}

var Restricts =
{
}

// --
// declare
// --

var Proto =
{

  init : init,

  _generateUniqueName : _generateUniqueName,

  fileSave : fileSave,
  _fileSave : _fileSave,
  fileExtract : fileExtract,

  // handle

  handleUpload : handleUpload,
  handleResponseDbfileWithId : handleResponseDbfileWithId,
  handleResponseDbfileWithUrl : handleResponseDbfileWithUrl,

  // request

  responseUpload : responseUpload,
  responseDbfile : responseDbfile,
  /*responseHandler : responseHandler,*/

    // ident

  
  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.EventHandler.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( !module.parent )
_global_.server = new Self();

})();
