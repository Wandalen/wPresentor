( function _Stream_s_() {

'use strict';

var _ = _global_.wTools;
var Parent = null;
var Self = function wStream( o )
{
  if( !( this instanceof Self ) )
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

// --
//
// --

function init( o )
{
  var self = this;

  _.instanceInit( self );

  this._view = null;
  this._pos = 0;

  if( _.objectIs( o ) )
  {

    self.copy( o );

  }
  else if( _.bufferTypedIs( o ) || _.strIs( o ) )
  self.buffer = o;
  else if( o !== undefined )
  throw _.err( 'Stream :','unknown constructor o',o );

  if( !self.buffer ) self.buffer = null;

  //if( _.objectIs( o ) ) _.mapExtend( self,o );

  //this._view = null;
  //this._pos = 0;
  //if( !this.growMode ) this.growMode = this.GrowMode[0];

  //if( o && o.buffer ) self.buffer = o.buffer;
  //else if( _.bufferTypedIs( o ) ) self.buffer = o;
  //else self.buffer = null;

}

//

function finit()
{
  var self = this;
  _.instanceFinit( self );
}

// --
// property
// --

var _bufferSetAct = ( function( buffer )
{

  var bufferSymbol = Symbol.for( 'buffer' );
  var bytesSymbol = Symbol.for( 'bytes' );
  var sizeSymbol = Symbol.for( 'size' );

  return function( buffer )
  {
    var self = this;

    self[ bufferSymbol ] = buffer;
    self[ bytesSymbol ] = new Uint8Array( buffer );
    self[ sizeSymbol ] = buffer.byteLength;

    self._view = new DataView( buffer );
  }

})();

//

function _bufferSet( buffer )
{
  var self = this;

  if( buffer === null || buffer === undefined )
  buffer = new ArrayBuffer( self.defaultSize );

  buffer = _.bufferRawFrom( buffer );

/*
  delete self._nodeBuffer;

  if( !( buffer instanceof ArrayBuffer ) )
  {

    if( typeof Buffer !== 'undefined' && buffer instanceof Buffer )
    {

      self._nodeBuffer = buffer;
      buffer = new Uint8Array( buffer ).buffer;

    }
    else if( _.bufferTypedIs( buffer ) )
    {

      buffer = buffer.buffer;

    }
    else if( _.strIs( buffer ) )
    {

      buffer = _.utf8ToBuffer( buffer );
      return self._bufferSet( buffer );

    }
    else if( _global_.File && buffer instanceof File )
    {
      if( !self.fileReader ) self.fileReader = new FileReaderSync();
      buffer = self.fileReader.readAsArrayBuffer( buffer );
      throw _.err( 'not tested' );
    }

  }
*/

  //console.log( 'buffer :',buffer );
  //return;

  if( !( buffer instanceof ArrayBuffer ) )
  throw _.err( 'wStream.bufferSet :','expects ArrayBuffer but got ' + _.strTypeOf( buffer ) );

  this._pos = 0;
  this._bufferSetAct( buffer );

}

//

function _bufferGet( buffer )
{
  var fieldSymbol = Symbol.for( 'buffer' );
  return this[ fieldSymbol ];
}

//

function trim( size )
{

  if( size === undefined ) size = this._pos;

  this.size = size;

  return this;
}

//

function skip( size )
{

  this._pos += size;
  if( this._pos > this.size )
  throw _.err( 'wStream : out of bound' );

  return this;
}

//

function grow( size )
{
  var self = this;

  if( self._pos + size > self.size )
  {
    if( self.growMode === 'fixed' )
    {
      throw _.err( 'wStream :','"growMode" is "fixed"' );
    }
    else if( self.growMode === 'exact' )
    {
      self.size = self.size + size;
      throw _.err( 'not tested' );
    }
    else if( self.growMode === 'twice' )
    {
      self.size = ( self.size + size ) * 2;
      /*console.log( 'stream',self.nickName,'is growing, new size :',self.size );*/
    }
    else
    {
      throw _.str( 'wStream.set :', 'not implemented grow mode :',self.growMode );
    }
  }

  return self;
}

//

function left()
{

  return this.size - this._pos;

}

//

var sizeGet = (function()
{
  var symbol = Symbol.for( 'size' );
  return function sizeGet()
  {
    return this[ symbol ];
  }
})();

//

function sizeSet( src )
{

  this._bufferSetAct( _.bufferResize( this.buffer,src ) );

}

//

function positionGet()
{

  return this._pos;

}

//

function positionSet( src )
{

  this._pos = src;

  _.assert( 0 <= this._pos && this._pos <= this.size,'position out of bounds' );

}

//

function positionStore( src )
{

  var self = this;

  if( !self._positionStore ) self._positionStore = [];

  self._positionStore.push( self.positionGet() );

  if( src !== undefined ) self.positionSet( src );

  return self;
}

//

function positionRestore()
{

  var self = this;

  self.positionSet( self._positionStore[ self._positionStore.length-1 ] );
  self._positionStore.pop();

  return self;
}

// --

function _bytesSet( byte )
{

  throw 'Not implemented';

}

//

var _bytesGet = ( function()
{
  var bytesSymbol = Symbol.for( 'bytes' );

  return function _bytesGet()
  {
    return this[ bytesSymbol ];
  }

})();

// --

function _byteSet( byte )
{

  if( this._pos >= this.size )
  throw _.err( 'wStream : out of bound' );

  return this.bytes[ this._pos ] = byte;
}

//

function _byteGet()
{

  if( this._pos >= this.size )
  throw _.err( 'wStream : out of bound' );

  return this.bytes[ this._pos ];
}

// --

function _charSet( char )
{

  if( this._pos >= this.size )
  throw _.err( 'wStream : out of bound' );
  return this.bytes[ this._pos ] = char.charCodeAt( 0 );

}

//

function _charGet()
{

  if( this._pos >= this.size )
  throw _.err( 'wStream : out of bound' );

  return String.fromCharCode( this.bytes[ this._pos ] );
}

// --
// writer
// --

function writeIntArrayString( src,type )
{

  var self = this;
  if( !type ) type = type.Int4;
  var parse = parseInt;

  return this._writeArrayString( src,type,parse );

}

//

function writeFloatArrayString( src,type )
{

  var self = this;
  if( !type ) type = type.Float4;
  var parse = parseFloat;

  return this._writeArrayString( src,type,parse );

}

//

function _writeArrayString( src,type,parse )
{

  var self = this;
  //if( !type ) type = type.Wrd1;
  //if( !parse ) parse = parseFloat;
  var digits = [ '0','1','2','3','4','5','6','7','8','9','.','+','-','e' ];

  var s = 0;
  var begin = -1;
  var end = -1;

  //console.log( 'writeFloatArrayString',src );

  while( s < src.length )
  {

    begin = -1;
    while( s < src.length )
    {

      if( digits.indexOf( src[s] ) !== -1 )
      {
        begin = s;
        s++;
        break;
      }

      s++;
    }

    if( begin === -1 ) break;

    end = src.length;
    while( s < src.length )
    {

      if( digits.indexOf( src[s] ) === -1 )
      {
        end = s;
        s++;
        break;
      }

      s++;
    }

    var num = src.substring( begin,end );
    num = parse( num );
    type.write.call( self,num );

  }

}

//

function readNumberUtfEncoded()
{

  var r, result = 0, shift = 0;
  do
  {
    r = this.readWrd1();
    result |= (r & 127) << shift;
    shift += 7;
  }
  while( (r & 128) === 128 );

  return result;
}

//

function readBuffer( len,type )
{

  var result;
  var read = null;

  if( !type ) type = Uint8Array;

  throw _.err( 'Not tested' );

  var sizeOfAtom = type.BYTES_PER_ELEMENT;
  _.assert( _.numberIs( sizeOfAtom ),'readBuffer :','type should be typed ArrayBuffer' );
  //var def = this.definitionWithBufferTypGet( type );
  //if( !def ) throw _.err( 'readBuffer : unknown type :', type );

  var read = def.read;

  if( this._pos % sizeOfAtom === 0 && 1 )
  {

    result = new type( this.buffer, this._pos, len );
    this._pos += len * sizeOfAtom;

  }
  else
  {

    console.warn( 'wStream.prototype.readBuffer : is not aligned' );
    result = new type( len );
    for( var i = 0 ; i < len ; i++ )
    result[i] = read.call( this );

  }

  if( this._pos > this.size )
  throw _.err( 'wStream : out of bound' );

  //if( this._pos > this.length ) console.warn( 'wStream : out of bound' );

  return result;
}

//

function readStringAscii( size )
{

  var result = '';

  if( !_.numberIs( size ) )
  throw _.err( 'wStream.readStringAscii :','size is not defined' );

/*
  try
  {
    result = String.fromCharCode.apply( null, new Uint8Array( this.buffer,this._pos,size ) );
  }
  catch( e )
  {
    for( var i = 0 ; i < size ; i++ )
    {
      result += String.fromCharCode( this.bytes[ this._pos+i ] );
    }
  }
*/

  var bytes = this.bytes;
  var p = this._pos;
  for( var i = 0 ; i < size ; i++ )
  {
    result += String.fromCharCode( bytes[ p+i ] );
  }

  this.position += size;

  return result;
}

//

function getStringAscii( size )
{
  var self = this;
  var result = '';
  var pos = self._pos;

  if( size === undefined )
  size = self.left();

  var bytes = this.bytes;
  var p = this._pos;
  for( var i = 0 ; i < size ; i++ )
  {
    result += String.fromCharCode( bytes[ p+i ] );
  }

  /*result = self.readStringAscii( size );*/
  /*self._pos = pos;*/

  return result;
}

//

function readDataUrl( size,type )
{

  var base64 = this._readBase64OfSize( size );
  var durl = _.uri.dataGetWithBase64( base64,type );

  //uri.dataShow( durl );

  return durl;
}

//

function readImage( size,type )
{

  var self = this;
  var image = new Image();

/*
  texture = new w4d.Texture();
  texture.name = sea.name;
  texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
  texture.flippingAxis2Unpacking = false;
*/

  image.onload = function()
{

    /*
    if (!self.isPowerOfTwo(image.width) ||
      !self.isPowerOfTwo(image.height))
    {
      var width = self.nearestPowerOfTwo( image.width ),
        height = self.nearestPowerOfTwo( image.height );

      var canvas = document.createElement( "canvas" );

      //console.log( 'image',width,height );

      canvas.width = width;
      canvas.height = height;

      var ctx = canvas.getContext( "2d" );

      ctx.drawImage( image, 0, 0, width, height );

      image = canvas;
    }
    */

    //texture.image = image;
    //texture.needsUpdate = true;

  }

  var durl = this.readDataUrl( size,type );
  //uri.dataShow( durl );

  image.src = durl;

  //this.textures = this.textures || [];
  //this.textures.push( this.objects["tex/" + sea.name] = sea.tag = texture );

  return image;
}

// -- utils
/*
function base64ToBuffer( base64, chunkSize )
{

  function base64ToWrdBits6( chr )
{

    return chr > 64 && chr < 91 ?
        chr - 65
      : chr > 96 && chr < 123 ?
        chr - 71
      : chr > 47 && chr < 58 ?
        chr + 4
      : chr === 43 ?
        62
      : chr === 47 ?
        63
      :
        0;

  }

  //var base64 = base64.replace( /[^0-9A-Za-z\+\/]/g, "" );
  var srcSize = base64.length;
  var dstSize = chunkSize ? Math.ceil( ( srcSize * 3 + 1 >> 2 ) / chunkSize ) * chunkSize : srcSize * 3 + 1 >> 2
  var bytes = new Uint8Array( dstSize );

  var factor3, factor4, wrd3 = 0, outIndex = 0;
  for( var inIndex = 0; inIndex < srcSize; inIndex++ )
{

    factor4 = inIndex & 3;
    wrd3 |= base64ToWrdBits6( base64.charCodeAt( inIndex ) ) << 18 - 6 * factor4;
    if ( factor4 === 3 || srcSize - inIndex === 1 )
{
      for ( factor3 = 0; factor3 < 3 && outIndex < dstSize; factor3++, outIndex++ )
{
        bytes[outIndex] = wrd3 >>> ( 16 >>> factor3 & 24 ) & 255;
      }
      wrd3 = 0;
    }

  }

  return bytes;
}
*/

// --
// var
// --

var littleEndian = true;
var defaultSize = 16;
var GrowMode = [ 'fixed','exact','twice' ];

// --
// relations
// --

var Composes =
{

  buffer : null,
  growMode : GrowMode[ 0 ],
  littleEndian : true,
  defaultSize : 16,

}

var Restricts =
{

  _nodeBuffer : null,

}

// --
// declare
// --

var Proto =
{

  init : init,
  finit : finit,

  // property

  _bufferSetAct : _bufferSetAct,
  '_bufferSet' : _bufferSet,
  '_bufferGet' : _bufferGet,

  trim : trim,
  skip : skip,
  grow : grow,
  left : left,

  'sizeGet' : sizeGet,
  'sizeSet' : sizeSet,

  'positionGet' : positionGet,
  'positionSet' : positionSet,

  positionStore : positionStore,
  positionRestore : positionRestore,

  '_bytesSet' : _bytesSet,
  '_bytesGet' : _bytesGet,

  '_byteSet' : _byteSet,
  '_byteGet' : _byteGet,

  '_charSet' : _charSet,
  '_charGet' : _charGet,

  // writer

  /*writeArray : writeArray,*/

  writeFloatArrayString : writeFloatArrayString,
  writeIntArrayString : writeIntArrayString,
  _writeArrayString : _writeArrayString,


  // reader

  readNumberUtfEncoded : readNumberUtfEncoded,

  readBuffer : readBuffer,

  getStringAscii : getStringAscii,
  readStringAscii : readStringAscii,

  getString : getStringAscii,
  readString : readStringAscii,

  readDataUrl : readDataUrl,
  readImage : readImage,


  // utils
/*
  //base64ToBuffer : base64ToBuffer,
  //readAsBase64 : readAsBase64,
  //bufferToUtf8 : bufferToUtf8,
  //utf8ToBuffer : utf8ToBuffer,
*/

  // var

  GrowMode : GrowMode,


  // relations

  
  Composes : Composes,
  Restricts : Restricts,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
})

_.Copyable.mixin( Self );

//

_.accessor( Self.prototype,
{

  buffer : 'buffer',
  size : 'size',
  position : 'position',
  bytes : 'bytes',
  byte : 'byte',
  char : 'char',

});

//

_.accessorForbid( Self.prototype,
{

  undefined : 'undefined',

});

//

_.mapExtendConditional( _.field.mapper.primitive,Self.prototype,Composes );

//

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

//console.log( 'Loaded :','wStream.s' );

_global_.wStream = Self;

})();
