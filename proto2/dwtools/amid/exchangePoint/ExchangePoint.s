( function _ExchangePoint_s_() {

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

  _.include( 'wCopyable' );
  _.include( 'wEventHandler' );

}

var Net, Stream;
var _ = _global_.wTools;
var Parent = null;
var Self = function wExchangePoint( o )
{
  if( !( this instanceof Self ) )
  if( _.typeOf( o ) === Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.shortName = 'ExchangePoint';

// --
//
// --

function init( o )
{
  var self = this;

  _.instanceInit( self );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  Object.preventExtensions( self );

  if( _.strIs( o ) )
  o = { path : o }
  if( o )
  self.copy( o );

  if( !Net )
  Net = require( 'net' );
  if( !Stream )
  Stream = require( 'stream' );
  if( !_.fileProvider )
  _.include( 'wFiles' );

  if( !self.path )
  self.path = _.path.dirTempFor();

  if( self.Self === Self )
  self.form();
}

//

function form()
{
  var self = this;

  _.assert( arguments.length === 0 );
  _.assert( _.strIs( self.delimeter ) );

  // if( self.logger === null )
  // self.logger = _global_.logger;

  if( self.isMaster === null )
  if( !_.fileProvider.fileStat( self.path ) )
  self.isMaster = true;
  else
  self.isMaster = false;

  _.assert( _.boolLike( self.isMaster ),self.isMaster );

  if( self.preservingData === null )
  self.preservingData = self.isMaster;

  // if( _.strIs( self.delimeter ) )
  // self.delimeter = Buffer.from( self.delimeter, 'utf8' );

  if( self.verbosity )
  logger.debug( 'exchangePoint',self.isMaster,self.path );

  self.streams = [];

  if( self.isMaster )
  {

    self.inputStream = new Stream.PassThrough();
    self.outputStream = new Stream.PassThrough();

    if( self.preservingData )
    self._data = Buffer.alloc( 0 );

    self.server = Net.createServer( function( stream )
    {
      self._streamMakeAfter( stream );
    });

    self.server.listen( self.path );

  }
  else
  {

    try
    {
      self.outputStream = self.inputStream = Net.connect( self.path );
      self.streams.push( self.inputStream );
    }
    catch( err )
    {
      _.errLogOnce( err );
      if( self.isMaster === null )
      {
        self.isMaster = true;
        return exchangePoint( self );
      }
    }

    self.inputStream.on( 'data', function( data )
    {
      _.assert( !self.preservingData );
      if( self.emittingMessages )
      self._emitMessages( data );
    });

    self.inputStream.on( 'error',function( err )
    {
      logger.log( _.errLog( err ) );
    });

    // self.inputStream.write( 'test' );
    // self.inputStream.end();

    self.ready.give( self );
  }

  return self.ready;
}

//

function close()
{
  var self = this;

  _.timeSoon( function()
  {

    for( var s = 0 ; s < self.streams.length ; s++ )
    try
    {
      var stream = self.streams[ s ];
      if( !stream.destroyed )
      stream.end();
    }
    catch( err )
    {
      logger.log( 'failed to send data to stream',id,'\n',err );
    }

    if( self.server )
    self.server.close();

    Object.freeze( self.streams );
    Object.freeze( self );

  });

  return self;
}

//

function write()
{
  var self = this;
  self._writeTo( self.outputStream,arguments );
  return self;
}

//

function _writeTo( stream,args )
{
  var self = this;
  var arg = args;

  if( _.bufferNodeIs( arg ) )
  arg = arg.toString();
  else if( _.longIs( arg ) )
  arg = _.strConcat( arg );

  _.assert( arguments.length === 2, 'expects exactly two arguments' );
  _.assert( _.longIs( args ) );
  _.assert( _.boolLike( self.isMaster ),self.isMaster );

  arg += self.delimeter;

  // if( self.isMaster )
  // _.timeOut( 100,function()
  // {
  //   xxx
  //   self.eventGive({ kind : 'write', data : arg });
  //   stream.write( arg );
  // });
  // else
  {
    self.eventGive({ kind : 'write', data : arg });
    stream.write( arg );
  }

  return self;
}

//

function _emitMessages( data )
{
  var self = this;
  _.assert( arguments.length === 1, 'expects single argument' );

  var data = data.toString().split( self.delimeter );

  if( data[ data.length-1 ] === '' )
  data.splice( data.length-1,1 );

  for( var i = 0 ; i < data.length ; i++ )
  self.eventGive({ kind : 'message', data : data[ i ] });

  // self.logger.log( data[ i ] );

  return self;
}

//

function _streamMakeAfter( stream )
{
  var self = this;
  var id = self.streams.length;
  var ended = false;

  _.assert( arguments.length === 1, 'expects single argument' );

  function broadcast( data,except )
  {
    for( var s = 0 ; s < self.streams.length ; s++ )
    try
    {
      var stream = self.streams[ s ];
      if( except !== stream )
      if( !stream.destroyed )
      stream.write( data );
      self.inputStream.write( data );
    }
    catch( err )
    {
      logger.log( 'failed to send data to stream',id,'\n',err );
    }
  }

  self.streams.push( stream );

  stream.write( self._data );

  stream.on( 'data', function( data )
  {
    if( self.preservingData )
    self._data = Buffer.concat([ self._data,data ]);
    broadcast( data, stream );
    if( self.emittingMessages )
    self._emitMessages( data );
  });

  stream.on( 'end', function()
  {
    if( self.verbosity )
    logger.log( 'end stream',id );
    // logger.log( stream );
    // self.server.close();
  });

  stream.on( 'close', function()
  {
    // debugger;
    // logger.log( 'close stream',id );
    // logger.log( stream );
    // self.server.close();
  });

  stream.on( 'error', function( err )
  {
    _.errLogOnce( 'network error on server\n',err );
    logger.error( _.mapAllFields( err ) );
  });

  self.outputStream.on( 'data', function( data )
  {
    if( self.preservingData )
    self._data = Buffer.concat([ self._data,data ]);
  });
  self.outputStream.pipe( stream );
  self.ready.give( self );

}

//

// function exchangePoint( o )
// {
//
//   if( _.strIs( o ) )
//   o = { path : o }
//
//   _.routineOptions( exchangePoint,o );
//   _.assert( arguments.length === 1, 'expects single argument' );
//   _.assert( _.strIs( o.delimeter ) || _.bufferNodeIs( o.delimeter ) );
//
//   self.ready = new _.Consequence();
//
//   if( !Net )
//   Net = require( 'net' );
//   if( !Stream )
//   Stream = require( 'stream' );
//   if( !_.fileProvider )
//   _.include( 'wFiles' );
//
//   if( !o.path )
//   o.path = _.path.dirTempFor();
//
//   // debugger;
//
//   if( o.isMaster === null )
//   if( !_.fileProvider.fileStat( o.path ) )
//   o.isMaster = true;
//
//   if( _.strIs( o.delimeter ) )
//   o.delimeter = Buffer.from( o.delimeter, 'utf8' );
//
//   if( o.verbosity )
//   logger.debug( 'exchangePoint',o.isMaster,o.path );
//
//   o.streams = [];
//
//   if( o.isMaster )
//   {
//
//     o.inputStream = new Stream.PassThrough();
//     o.outputStream = new Stream.PassThrough();
//     if( o.preservingData )
//     o.data = '';
//
//     function broadcast( data,except )
//     {
//       for( var s = 0 ; s < o.streams.length ; s++ )
//       if( except !== o.streams[ s ] )
//       o.streams[ s ].write( data );
//       o.inputStream.write( data );
//     }
//
//     o.server = Net.createServer( function( stream )
//     {
//       o.streams.push( stream );
//
//       if( o.preservingData )
//       stream.write( o.data );
//       console.log( 'writing',_.strQuote( o.data.toString() ) );
//
//       stream.on( 'data', function( data )
//       {
//         if( o.preservingData )
//         o.data = Buffer.concat([ o.data,data ]);
//         broadcast( data, stream );
//       });
//       stream.on( 'end', function()
//       {
//         o.server.close();
//       });
//       o.outputStream.on( 'data', function( data )
//       {
//         if( o.preservingData )
//         o.data = Buffer.concat([ o.data,data ]);
//       });
//       // o.outputStream.pipe( stream );
//       self.ready.give( o );
//
//       o.outputStream.on( 'data', function(  )
//
//     });
//
//     o.server.listen( o.path );
//
//   }
//   else
//   {
//
//     try
//     {
//       o.outputStream = o.inputStream = Net.connect( o.path );
//       o.streams.push( o.inputStream );
//     }
//     catch( err )
//     {
//       _.errLogOnce( err );
//       if( o.isMaster === null )
//       {
//         o.isMaster = true;
//         return exchangePoint( o );
//       }
//     }
//
//     o.inputStream.on( 'error',function( err )
//     {
//       logger.log( _.errLog( err ) );
//     });
//
//     // o.inputStream.write( 'test' );
//     // o.inputStream.end();
//
//     self.ready.give( o );
//   }
//
//   // var prepender = new Stream.Transform
//   // ({
//   //   transform(chunk, encoding, done)
//   //   {
//   //     this._rest = this._rest && this._rest.length
//   //       ? Buffer.concat([this._rest, chunk])
//   //       : chunk
//   //
//   //     let index
//   //
//   //     while ((index = this._rest.indexOf('\n')) !== -1)
//   //     {
//   //       const line = this._rest.slice(0, ++index)
//   //       this._rest = this._rest.slice(index)
//   //       this.push(Buffer.concat([prefix, line]))
//   //     }
//   //
//   //     return void done()
//   //   },
//   //   flush( done )
//   //   {
//   //     if( this._rest && this._rest.length )
//   //     return void done( null, Buffer.concat([ prefix, this._rest ]);
//   //   },
//   // })
//
//   return self.ready;
// }
//
// exchangePoint.defaults =
// {
//
//   // delimeter : '\0',
//   delimeter : '\0',
//   preservingData : 1,
//   verbosity : 0,
//   isMaster : null,
//   path : null,
//
// }

// --
// relations
// --

var Composes =
{

  delimeter : '\0\n',
  preservingData : null,
  emittingMessages : 1,
  verbosity : null,
  isMaster : null,
  path : null,

}

var Aggregates =
{
}

var Associates =
{
  // logger : null,
}

var Restricts =
{
  _data : null,
  ready : _.define.ownInstanceOf( _.Consequence ),

  server : null,
  streams : [],
  inputStream : null,
  outputStream : null,
}

var Events =
{
  message : 'message',
  write : 'write',
}

// --
// declare
// --

var Proto =
{

  init : init,
  form : form,

  close : close,

  write : write,
  _writeTo : _writeTo,
  _emitMessages : _emitMessages,
  _streamMakeAfter : _streamMakeAfter,


  // relations


  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Events : Events,

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

_global_[ Self.name ] = _[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
