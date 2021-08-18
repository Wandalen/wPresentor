(function _wWriters_s_() {

'use strict';

var _ = _global_.wTools;
var Parent = null;
var Self = function wWriters( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

// --
// inter
// --

function init( o )
{
  var self = this;

  _.mapComplement( self,self.Associates );
  _.instanceInit( self );

  if( o )
  self.copy( o );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.arrayIs( self.schema ) || _.objectIs( self.schema ) );

  if( self.parserOptions.growMode === undefined )
  self.parserOptions.growMode = 'twice';

  _.each( self.schema, function( e,k )
  {
    if( !e )
    return;
    self.writer[ k ] = new wParser( self.parserOptions );
    self.writer[ k ].name = k;
    if( _.objectIs( e ) && _.numberIs( e.size ) )
    self.writer[ k ].size = e.size;
  });

  if( self.constructor === Self )
  Object.preventExtensions( self );

}

// --
// operation
// --

function toBuffers()
{
  var self = this;
  self.buffer = {};
  for( var w in self.writer )
  {
    var type = self.schema[ w ];
    if( _.objectIs( type ) )
    type = type.bufferType;
    _.assert( _.constructorIsBuffer( type ),'schema map should have buffer schema as values to use toBuffers' );
    self.buffer[ w ] = self.writer[ w ].getBuffer[ wParser.definitionNameWithBufferGet( type ) ]();
  }
  return self.buffer;
}

//

function trim( size )
{
  var self = this;

  for( var w in self.writer )
  {
    _.assert( _.routineIs( self.writer[ w ].trim ) );
    self.writer[ w ].trim( size );
  }

  return self;
}

//

function relength( length )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.numberIs( length ) );

  for( var w in self.writer )
  {
    var writer = self.writer[ w ];
    var schema = self.schema[ w ];

    _.assert( writer.position === 0 );
    _.assert( _.objectIs( schema ) );
    _.assert( _.numberIs( schema.atomsPerElement ) );
    _.assert( _.numberIs( schema.bufferType.BYTES_PER_ELEMENT ) );

    self.writer[ w ].size = length * schema.atomsPerElement * schema.bufferType.BYTES_PER_ELEMENT;

  }

  return self;
}

//

function positionStore()
{
  var self = this;
  for( var w in self.writer )
  {
    self.writer[ w ].positionStore();
  }
  return self;
}

//

function positionRestore()
{
  var self = this;
  for( var w in self.writer )
  {
    self.writer[ w ].positionRestore();
  }
  return self;
}

//

function buffersSerialize( options )
{
  var self = this;
  var size = 0;
  var options = options || {};

  _.assertMapHasOnly( options,buffersSerialize.defaults );

  options.onAttributesGet = options.onAttributesGet || function()
  {
    return _.mapPairs( self.buffer );
  }
  options.onBufferGet = options.onBufferGet || function( attribute )
  {
    return attribute;
  }

  return _.buffersSerialize( options ); xxx
}

buffersSerialize.defaults =
{
  store : null,
}

//

function serialize( options )
{
  var self = this;
  var options = options || {};
  var store = options.store = options.store || {};

  self.buffersSerialize( options );

  store.writer = self.cloneData
  ({

    copyingComposes : 3,
    copyingAggregates : 3,
    copyingAssociates : 0,

  });

  return store;
}

//

function buffersDeserialize( store )
{
  var self = this;
  _.assert( arguments.length === 1, 'expects single argument' );

  self.buffer = {};

  var options =
  {

    store : store,
    context : self,
    onAttribute : function( attributeOptions,buffer,name )
    {
      this.buffer[ name ] = buffer;
    },

  }

  return _.buffersDeserialize( options );
}

//

function deserialize( store )
{
  var self = this;

  if( _.strIs( store ) )
  store = JSON.parse( store );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( store ) );

  if( arguments[ 1 ] )
  store[ 'buffer' ] = arguments[ 1 ];

  self.copyCustom
  ({
    src : store.writer,
    dst : self,

    copyingComposes : 3,
    copyingAggregates : 1,
    copyingAssociates : 0,

    technique : 'object',
  });

  self.buffersDeserialize( store );

  return self;
}

// --
// relations
// --

var Composes =
{

  parserOptions : _.define.own
  ({
    growMode : 'twice',
  }),

}

var Aggregates =
{
}

var Associates =
{
  schema : _.define.own({}),
  buffer : _.define.own({}),
  writer : _.define.own({}),
}

var Restricts =
{
}

// --
// declare
// --

var Proto =
{

  // inter

  init : init,

  // operation

  toBuffers : toBuffers,
  trim : trim,
  relength : relength,

  positionStore : positionStore,
  positionRestore : positionRestore,

  //

  buffersSerialize : buffersSerialize,
  serialize : serialize,

  buffersDeserialize : buffersDeserialize,
  deserialize : deserialize,

  //


  Composes : Composes,
  Aggregates : Aggregates,
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

//

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

_global_.wWriters = Self;

return Self;

})();
