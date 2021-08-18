( function(){

'use strict';

require( './Servlet.ss' );

xxx

var os = require( 'os' );
var sys = require( 'sys' );
var http = require( 'http' );
var url = require( 'url' );
var path = require( 'path' );
var fs = require( 'fs-extra' );
//var walker = require( 'filewalker' );
var exec = require( 'child_process' ).exec;

var stringify = require( 'json-stringify-safe' );
var Request = require( 'request' );
var Jade = require( 'jade' );

var Express = require( 'express' );
Express.Params = require( 'express-params' );

var assert = require( 'assert' );
//var Mongo = require( 'mongodb' );
var inspect = require( 'util' ).inspect;
var Busboy = require( 'busboy' );
var qs = require( 'qs' )

var Stools = require( './Stools.ss' );
var DataBase = require( './DataBase.ss' );
var Uploader = require( './Uploader.ss' );

// var Waiter = require( './Waiter.js' );

//

var _ = _global_.wTools;
var Parent = null;
var Self = function wServerLogService( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'ServerLogService';

// --
//
// --

function init( o )
{

  var self = _.mapExtend( this,o );

  // o

  if( self.name === undefined ) self.name = 'Dbform';
  if( self.attempts === undefined ) self.attempts = 10;
  if( self.definition === undefined ) self.definition = {};

  //

  _.servlet.controlLoggingPre.call( self );

  // jade

  if( self.ht === undefined ) self.ht = '../raw/';
  if( self.htForm === undefined ) self.htForm = self.ht + 'include/dwtools/dbform.jade';

  // path

  if( self.upload === undefined ) self.upload = '../files/';
  if( self.uploadImage === undefined ) self.uploadImage = './';

  // url

  if( self.urlForm === undefined ) self.urlForm = "/form";
  if( self.urlFormUpdate === undefined ) self.urlFormUpdate = self.urlForm + "/update/";

  // normalize

  _.servlet.controlPathesNormalize.call( self );

  // bind

  if( self.app === undefined ) self.app = Express();
  if( self.db === undefined ) self.db = new DataBase({ address :self.dbAddress });
  self.db.onceConnected( function(){
    self.collection = self.db.connection.collection( self.dbAddress.collection );
    self.normalizeDefinition();
  });

  self.app.use( _.routineJoin( self,self.responseHandler ) );
  self.app.all( new RegExp( _.regexpEscape( self.urlForm )               + '' ),                       _.routineJoin( self,self.responseForm ) );
  self.app.all( new RegExp( _.regexpEscape( self.urlFormUpdate )         + '' ),                       _.routineJoin( self,self.responseFormUpdate ) );

  //

  if( self.uploader === undefined ) self.uploader = new Uploader
  ({

    app : self.app,
    context : self.context,
    upload : self.uploadImage,
    //onGetUrl : self.onGetUploadImageUrl,

    db : self.db,
    dbAddress : self.dbAddress,

  });

  if( Config.debug )
  console.log( self.name,'bound.' );

}

//

function normalizeDefinition() {

  var self = this;
  var result = {};

  //console.log( 'self.definition-a',self.definition );

  /*
  self.collection.findOne(
    {},
    {},
    function( err,data ){

      assert.equal( null, err );

      //console.log( 'self.definition-b',self.definition );

      for( var d in data ){
        result[ d ] = {};
        result[ d ].format = 'text';
      }

      //console.log( 'self.definition-c',self.definition );

      for( var d in self.definition ){
        if( !result[ d ] ) result[ d ] = self.definition[ d ];
        else
        {
          _.mapExtend( result[ d ],self.definition[ d ] );
          //console.log( '_.mapExtend( ' + result[ d ] + ' , ' + self.definition[ d ] + ' );' );
        }
      }

      self.definition = result;
      if( Config.debug )
      {
        console.log( 'Definition of',self.name );
        console.log( self.definition );
      }

    }
  );
  */

  _.each( self.definition,function( e,k )
  {
  });

  _.servlet.controlLoggingPost.call( self );
}

// --
// request
// --

function responseForm( request, response, next ) {

  var self = this;
  //next();
  //return;

  response.render( self.htForm, {

    _ : self,
    //db : db,

  });

}
//

function responseFormUpdate( request, response, next ) {

  var self = this;
  next();
  return;

  //qs.parse( request.u.query );

  self.getPostData( request, response, function( data ){

    var row = qs.parse( request.data );
    var id = row._id;
    delete row._id;
    //console.log( 'data',data );
    //console.log( 'row',row );

    self.collection.update( { _id : Mongo.ObjectID( id ) },row,{ upsert : true },function( err,result ){

      //console.log( 'err',err );
      //console.log( 'result',result );

      if( err )
      {
        _.servlet.errorHandle( err );
      }
      else
      {
        response.writeHead( 200,{"Content-Type" : "text/html"} );
        //response.write( '' );
        response.end();
        //next();
      }

    });


  });

}

//

function responseHandler( request, response, next ) {

  var self = this;
  var result = null;

  if( response.finished ) return;
  if( !result ) next();
};

//

var Proto =
{

  init : init,

  // tool

  normalizeDefinition : normalizeDefinition,

  // request

  responseForm : responseForm,
  responseFormUpdate : responseFormUpdate,
  responseHandler : responseHandler,

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
