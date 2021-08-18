(function() {

'use strict'; 

var _ = _global_.wTools;
var Parent = wStream;
var Self = wParser;
var DT = wParser.prototype.definitions;
var definitions = wParser.prototype.definitions;

// --
// const
// --

var _MAP_LETTERS =
[
//  0       1       2       3       4       5       6       7       8       9       A       B       C       D       E       F
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 0
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 1
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 2
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 3
    false,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  // 4
     true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  false,  false,  false,  false,  false,  // 5
    false,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  // 6
     true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  false,  false,  false,  false,  false,  // 7
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 8
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 9
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // A
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // B
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // C
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // D
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // E
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false   // F
];

Object.freeze( _MAP_LETTERS );

//

var _MAP_LETTERS_UNDERSCORE =
[
//  0       1       2       3       4       5       6       7       8       9       A       B       C       D       E       F
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 0
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 1
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 2
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 3
    false,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  // 4
     true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  false,  false,  false,  false,   true,  // 5
    false,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  // 6
     true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  false,  false,  false,  false,  false,  // 7
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 8
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 9
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // A
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // B
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // C
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // D
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // E
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false   // F
];

Object.freeze( _MAP_LETTERS_UNDERSCORE );

//

var _MAP_LETTERS_DIGIT_UNDERSCORE =
[
//  0       1       2       3       4       5       6       7       8       9       A       B       C       D       E       F
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 0
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 1
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 2
     true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  false,  false,  false,  false,  false,  false,  // 3
    false,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  // 4
     true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  false,  false,  false,  false,   true,  // 5
    false,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  // 6
     true,   true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  false,  false,  false,  false,  false,  // 7
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 8
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 9
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // A
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // B
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // C
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // D
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // E
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false   // F
];

Object.freeze( _MAP_LETTERS_DIGIT_UNDERSCORE );

//

var _MAP_NUMBER_ONLY =
[
//  0       1       2       3       4       5       6       7       8       9       A       B       C       D       E       F
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 0
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 1
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 2
     true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  false,  false,  false,  false,  false,  false,  // 3
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 4
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 5
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 6
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 7
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 8
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 9
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // A
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // B
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // C
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // D
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // E
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false   // F
];

Object.freeze( _MAP_NUMBER_ONLY );

//

var _MAP_FLOAT =
[
//  0       1       2       3       4       5       6       7       8       9       A       B       C       D       E       F
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 0
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 1
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  true ,  false,  true ,  true ,  false,  // 2 + / - / .
     true,   true,   true,   true,   true,   true,   true,   true,   true,   true,  false,  false,  false,  false,  false,  false,  // 3
    false,  false,  false,  false,  false,   true,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 4 E
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 5
    false,  false,  false,  false,  false,   true,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 6 e
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 7
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 8
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // 9
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // A
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // B
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // C
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // D
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  // E
    false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false,  false   // F
];

Object.freeze( _MAP_FLOAT );

// --
// generator
// --

var generateBidirection = wParser.generateBidirection;
_.assert( _.routineIs( generateBidirection ) );

function generateTextSeekingTerminalRoutine( o )
{

  _.assertMapHasOnly( o,generateTextSeekingTerminalRoutine.defaults );

  var isGetter = o.isGetter;
  var doesAcceptZero = o.doesAcceptZero;
  var onByte = o.onByte;
  var onEnd = o.onEnd;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.routineIs( onByte ) );
  _.assert( onByte.length === 1 );
  _.assert( _.boolIs( isGetter ) );
  _.assert( _.boolIs( doesAcceptZero ) );

  function generate( direction )
  {

    var ahead = direction === 'ahead';

    var _delta;
    if( direction === 'ahead' )
    _delta = +1;
    else if( direction === 'behind' )
    _delta = -1;
    else
    throw _.err( 'not expected' );

    var onBegin;
    if( o.onBegin_functor )
    onBegin = o.onBegin_functor( direction );

    var _textOfLength = ( isGetter || onEnd ) ? _getTextOfLength[ direction ] : _readTextOfLength[ direction ];
    _.assert( _.routineIs( _textOfLength ) );

    var read = function textSeeking()
    {
      var self = this;
      var bytes = self.bytes;
      var end = ahead ? self._pos + self.left() : -1;
      var position = ahead ? self._pos : self._pos - 1;

      if( doesAcceptZero === false )
      {
        var left = ahead ? self.left() : self._pos;
        if( left === 0 )
        return;
      }

      if( onBegin )
      {
        var result = onBegin.call( this );
        if( result === undefined )
        return;
      }

      for( ; position !== end ; position += _delta )
      {

        if( onByte( bytes[ position ] ) === false )
        break;

      }

      var readLength = ahead ? position-self._pos : self._pos-position-1;

      if( doesAcceptZero === false && readLength === 0 )
      return;

      var text = _textOfLength.call( self,readLength );

      if( onEnd )
      {
        var result = onEnd.call( this,text.data );
        if( result !== undefined )
        self._pos += ahead ? +readLength : -readLength;
        return result;
      }
      else
      {
        return text;
      }
    }

    //

    if( onByte.alternativity !== undefined )
    read.alternativity = onByte.alternativity;

    read.constant =
    {
      isGetter : isGetter,
      doesAcceptZero : doesAcceptZero,
      ahead : ahead,
      _delta : _delta,
    };

    read.external =
    {
      onByte : onByte,
      onBegin : onBegin,
      onEnd : onEnd,
      _textOfLength : _textOfLength,
    }

    read.inline = {};
    if( onByte )
    read.inline.onByte = onByte;
    if( onBegin )
    read.inline.onBegin = onBegin;
    if( onEnd )
    read.inline.onEnd = onEnd;

    read.debugInline = 1;
    read.debugIsolate = 1;

    return read;
  }

  return generate;
}

generateTextSeekingTerminalRoutine.defaults =
{
  isGetter : false,
  doesAcceptZero : true,
  onByte : null,
  onBegin_functor : null,
  onEnd : null,
}

// --
// tester
// --

function charIsNumber( char )
{

  _.assert( _.strIs( char ) && char.length === 1,char,' is not char' );

  return _MAP_NUMBER_ONLY[ char.charCodeAt( 0 ) ];
}

// --
// text
// --
/*
function _readChar()
{
  var def = DT.Char;

  debugger;

  if( this.position + 1 > this.size )
  return;

  var result = def.getView.call( this._view, this.position, this.littleEndian );
  result = String.fromCharCode( result );

  this.position += 1;

  return result;
}
*/
//

function _getCharAhead()
{
  var def = DT.Char;

  if( this._pos + 1 > this.size )
  return;

  var data = def.getView.call( this._view, this._pos, this.littleEndian );
  data = String.fromCharCode( data );

  return { data : data, shift : 1 };
}

//

function _getLetterAhaed()
{
  var self = this;
  var bytes = self.bytes;

  debugger;

  if( self.left() < 1 )
  return;

  if( !_MAP_LETTERS[ self.bytes[ self.position ] ] )
  return;

  return self._getCharAhead();
}

_getLetterAhaed.alternativity = _.arrayCount( _MAP_LETTERS,true );
_getLetterAhaed.external = { _MAP_LETTERS : _MAP_LETTERS };

//

function _readTextLiteralAhead( text )
{
  var self = this;
  var def = DT.Char;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIs( text ) );

  debugger;
  if( self.left() < text.length )
  return;

  for( var t = 0 , position = self._pos ; t < text.length ; t++, position++ )
  {
    var c = def.getView.call( self._view, position, self.littleEndian );
    var chr = String.fromCharCode( c );
    if( text[ t ] !== chr )
    return;
  }

  self.position = position;
  return text;
}

//

function _getTextLiteralAhead( text )
{

  var self = this;
  /*var def = DT.Char;*/
  var view = self._view;

  if( self.left() < text.length )
  return;

  for( var t = 0 , position = self._pos ; t < text.length ; t++, position++ )
  {
    /*var c = def.getView.call( self._view, position, self.littleEndian );*/
    var c = view.getUint8( position, self.littleEndian );
    var chr = String.fromCharCode( c );
    if( text[ t ] !== chr )
    return;
  }

  return text;
}

//

var onByte = function byteLettere( byte ){ return _MAP_LETTERS[ byte ]; };
onByte.external = { _MAP_LETTERS : _MAP_LETTERS };
var getTextLetter_functor = generateTextSeekingTerminalRoutine
({
  isGetter : true,
  doesAcceptZero : false,
  onByte : onByte,
});

var onByte = function byteLetterUnerscore( byte ){ return _MAP_LETTERS_UNDERSCORE[ byte ]; };
onByte.external = { _MAP_LETTERS_UNDERSCORE : _MAP_LETTERS_UNDERSCORE };
var getTextLetterUnerscore_functor = generateTextSeekingTerminalRoutine
({
  isGetter : true,
  doesAcceptZero : false,
  onByte : onByte,
});

var onByte = function byteLetterDigitUnderscore( byte ){ return _MAP_LETTERS_DIGIT_UNDERSCORE[ byte ]; };
onByte.external = { _MAP_LETTERS_DIGIT_UNDERSCORE : _MAP_LETTERS_DIGIT_UNDERSCORE };
var getTextLetterDigitUnderscore_functor = generateTextSeekingTerminalRoutine
({
  isGetter : true,
  doesAcceptZero : false,
  onByte : onByte,
});

var onByte = function byteName( byte ){ return _MAP_LETTERS_DIGIT_UNDERSCORE[ byte ]; };
onByte.external = { _MAP_LETTERS_DIGIT_UNDERSCORE : _MAP_LETTERS_DIGIT_UNDERSCORE };
var getTextName_functor = generateTextSeekingTerminalRoutine
({
  isGetter : true,
  doesAcceptZero : false,
  onByte : onByte,
  onBegin_functor : function( direction )
  {
    if( direction === 'ahead' )
    return function onBegin()
    {
      if( _MAP_NUMBER_ONLY[ this.bytes[ this.position ] ] )
      return;
      return true;
    }
    else
    return function onBegin()
    {
      debugger;
      if( _MAP_NUMBER_ONLY[ this.bytes[ this.position-1 ] ] )
      {
        debugger;
        return;
      }
      return true;
    }
  }
});

// --

function getTextOfLength_functor( direction )
{

  /*
  var _asciiDecoder;
  if( typeof module !== 'undefined' && module !== null )
  {
    _asciiDecoder = new ( require( 'string_decoder' ).StringDecoder )( 'ascii' );
  }
  */

  if( direction === 'ahead' )
  return function _getTextOfLengthAhead( length )
  {
    var result = '';
    var bytes = this.bytes;

    _.assert( length >= 0 );

    if( !length )
    return { data : '', shift : length };

    if( this._pos + length > this.buffer.byteLength )
    return;

    for( var t = 0, position = this._pos ; t < length ; t++, position++ )
    {
      result += String.fromCharCode( bytes[ position ] );
    }

    return { data : result, shift : length };
  }

  if( direction === 'behind' )
  return function _getTextOfLengthBehind( length )
  {
    var result = '';
    var bytes = this.bytes;

    _.assert( length >= 0 );

    if( !length )
    return { data : '', shift : length };

    if( this._pos < length )
    return;

    for( var t = 0, position = this._pos-length ; t < length ; t++, position++ )
    {
      result += String.fromCharCode( bytes[ position ] );
    }

    return { data : result, shift : length };
  }

}

//

function readTextOfLength_functor( direction )
{

  var get = _getTextOfLength[ direction ];

  _.assert( _.routineIs( get ) );

  if( direction === 'ahead' )
  return function _readTextOfLengthAhead( length )
  {

    var result = get.call( this,length )

    if( result === undefined )
    return;

    this._pos += length;
    return result.data;
  }

  if( direction === 'behind' )
  return function _readTextOfLengthBehind( length )
  {

    var result = get.call( this,length )

    if( result === undefined )
    return;

    this._pos -= length;
    return result.data;
  }

}

//

var _getTextOfLength = generateBidirection( getTextOfLength_functor );
var _getTextOfLengthAhead = _getTextOfLength[ 'ahead' ];
var _getTextOfLengthBehind = _getTextOfLength[ 'behind' ];
var _readTextOfLength = generateBidirection( readTextOfLength_functor );
var _readTextOfLengthAhead = _readTextOfLength[ 'ahead' ];
var _readTextOfLengthBehind = _readTextOfLength[ 'behind' ];

// --
// number
// --

var readTextNumberFast_functor = generateTextSeekingTerminalRoutine
({
  isGetter : false,
  doesAcceptZero : false,
  onByte : function( byte ){ return _MAP_FLOAT[ byte ]; },
  onEnd : function( text )
  {

    var result = parseFloat( text );
    if( !isNaN( result ) )
    return result;

  }
});

//

function readTextNumber_functor( direction )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  var ahead = direction === 'ahead';
  var getTextOfLength = _getTextOfLength[ direction ];

  var _delta;
  if( direction === 'ahead' )
  _delta = +1;
  else if( direction === 'behind' )
  _delta = -1;
  else
  throw _.err( 'unexpected' );

  var result = function _readTextNumber()
  {
    var self = this;
    var bytes = self.bytes;
    var begin = ahead ? self._pos : self._pos-1;

    var position = begin;
    var end = ahead ? position + self.left() : -1;

    // + / -

    function seekSign()
    {

      if( position === end )
      return false;

      var byte = bytes[ position ];
      if( byte !== 0x2b && byte !== 0x2d )
      return false;

      position += _delta;

      return true;
    }

    // 0-9

    function seekDigits()
    {

      while( position !== end )
      {

        if( !_MAP_NUMBER_ONLY[ bytes[ position ] ] )
        break;

        position += _delta;
      }

    }

    // .

    function seekPoint()
    {

      if( position === end )
      return false;

      if( bytes[ position ] !== 0x2e )
      return false;

      position += _delta;

      return true;
    }

    // E / e

    function seekExp()
    {

      if( position === end )
      return false;

      var byte = bytes[ position ];
      if( byte !== 0x45 && byte !== 0x65 )
      return false;

      position += _delta;

      return true;
    }

    /* E / e / + / - / 0-9 */

    //

    if( ahead )
    {

      seekSign();
      seekDigits();
      if( seekPoint() === true )
      seekDigits();
      if( seekExp() === true )
      {
        seekSign();
        seekDigits();
      }

    }
    else
    {

      seekDigits();
      var sign = seekSign();
      var exp = seekExp();

      if( exp === true || sign === false )
      {
        seekDigits();
        if( seekPoint() === true )
        seekDigits();
        seekSign();
      }

    }

    //

    var readLength = ahead ? position - begin : begin - position;

    if( !readLength )
    return;

    var text = getTextOfLength.call( self,readLength );
    if( !text )
    return;

    var result = parseFloat( text.data );

    if( !isNaN( result ) )
    {
      self.position += ahead ? +readLength : -readLength;
      return result;
    }

  }

  result.alternativity = Infinity;
  result.external = { _MAP_NUMBER_ONLY : _MAP_NUMBER_ONLY };

  return result;
}

//

function _generateReadTextNumberSlow( direction )
{

  _.assert( arguments.length === 1, 'expects single argument' );
  var ahead = direction === 'ahead';
  var getTextOfLength = _getTextOfLength[ direction ];

  var _delta;
  if( direction === 'ahead' )
  _delta = +1;
  else if( direction === 'behind' )
  _delta = -1;
  else
  throw _.err( 'unexpected' );

  var result = function _readTextNumber()
  {
    var self = this;
    var bytes = self.bytes;
    var begin = ahead ? self._pos : self._pos-1;

    var position = begin;
    var end = ahead ? position + self.left() : -1;

    debugger;

    // + / -

    while( position !== end )
    {

      var byte = bytes[ position ];
      if( byte !== 0x2b && byte !== 0x2d )
      break;

      position += _delta;
    }

    // 0-9

    while( position !== end )
    {

      if( !_MAP_NUMBER_ONLY[ bytes[ position ] ] )
      break;

      position += _delta;
    }

    // . / 0-9

    if( position !== end && bytes[ position ] === 0x2e )
    {
      position += _delta;

      while( position !== end )
      {

        if( !_MAP_NUMBER_ONLY[ bytes[ position ] ] )
        break;

        position += _delta;

      }

    }

    // E / e / + / - / 0-9

    if( position !== end )
    if( bytes[ position ] === 0x45 || bytes[ position ] === 0x65 ) /* E / e */
    {
      position += _delta;

      if( position !== end )
      {

        var byte = bytes[ position ];
        if( byte === 0x2b || byte === 0x2d ) /* + / - */
        position += _delta;

        while( position !== end )
        {

          if( !_MAP_NUMBER_ONLY[ bytes[ position ] ] )
          break;

          position += _delta;
        }

      }

    }

    //

    var readLength = ahead ? position - begin : begin - position;

    if( !readLength )
    return;

    var text = getTextOfLength.call( self,readLength );
    if( !text )
    return;

    var result = parseFloat( text.data );

    if( !isNaN( result ) )
    {
      self.position += ahead ? +readLength : -readLength;
      return result;
    }

  }

  result.alternativity = Infinity;
  result.external = { _MAP_NUMBER_ONLY : _MAP_NUMBER_ONLY };

  return result;
}

// --
// space
// --

function _readUntilSpaceAhead()
{

  var self = this;
  var result = '';

  while( self.left() )
  {

    var chr = self.getChar();
    if( chr.charCodeAt( 0 ) <= 32 ) break;
    self.position += 1;
    result += chr;

  }

  return result;
}

//

function _readUntilSpaceBehind()
{

  var self = this;
  var result = '';

  throw _.err( 'not tested' );
  debugger;

  while( self._pos )
  {

    var chr = self.getChar();
    if( chr.charCodeAt( 0 ) <= 32 )
    break;
    self.position -= 1;
    result += chr;

  }

  return result;
}

//

function _getSingleLineSpacesAhead()
{
  var self = this;
  var result = '';

  throw _.err( 'not tested' );

  var bytes = self.bytes;
  for( var position = self.position, len = self.position + self.left() ; position < len ; position++ )
  {

    if( bytes[ position ] > 32 || bytes[ position ] === 10 || bytes[ position ] === 13 )
    break;

  }

  var shift = position-self.position;
  var result = self._getTextOfLengthAhead( shift );
  return result;
}

//

function _getSingleLineSpacesBehind()
{
  var self = this;
  var result = '';

  throw _.err( 'not implemented' );

}

//

var getSpace_functor = generateTextSeekingTerminalRoutine
({
  isGetter : true,
  doesAcceptZero : true,
  onByte : function( byte ){ return byte <= 32; },
});

var getMandatorySpace_functor = generateTextSeekingTerminalRoutine
({
  isGetter : true,
  doesAcceptZero : false,
  onByte : function( byte ){ return byte <= 32; },
});

// --
// conditional
// --

function _isFirstNonBlankOnLineAhead()
{

  if( this.position === 0 )
  return true;

  var pos = this._pos - 1;
  while( pos >= 0 )
  {
    if( this.bytes[ pos ] === 10 )
    return true;
    if( this.bytes[ pos ] > 32 )
    return;
    pos -= 1;
  }

  return true;
}

//

function _isBeginOfLine()
{

  if( this.position === 0 )
  return true;
  if( this.bytes[ this._pos-1 ] === 10 )
  return true;

}

//

function _isEndOfLine()
{

  throw _.err( 'not tested' );

  if( this.position === this.size ) return true;
  if( this.bytes[ this._pos ] === 10 ) return true;
  if( this.bytes[ this._pos ] === 13 ) return true;

}

function _isBeginOfFile()
{

  if( this.position === 0 )
  {
    return true;
  }

}

//

function _isEndOfFile()
{

  throw _.err( 'not tested' );

  if( this.position === this.size ) return true;

}

// --
// sophisticated
// --

function _readNotContainTextAhead( text )
{

  var self = this;
  var found = 0;

  if( text === '' ) return '';
  var firstByte = text.charCodeAt( 0 );

  for( var position = self.position, len = self.position + self.left() ; position < len ; position++ )
  {

    if( self.bytes[ position ] === firstByte )
    {

      self.position = position;
      if( wParser._getTextLiteralAhead.call( self,text ) === undefined )
      continue;

      break;
    }

  }

  self.position = position;
  return self._readTextOfLengthAhead( position-self.position );
}

//

function _readCountText( text )
{
  var self = this;
  var result = 0;
  var firstByte = text.charCodeAt( 0 );
  var bytes = self.bytes;
  var index = -1;

  while( true )
  {
    index = bytes.indexOf( firstByte,self.position );

    if( index !== -1 )
    {
      self.position = index;
      var read = _readTextLiteralAhead.call( this,text );
      if( read === undefined )
      self.position = index+1;
      else
      result += 1;
    }
    else
    {
      self.position = bytes.length;
      break;
    }

  }

  return result;
}

//

function readUntilText_functor_functor( text,skip )
{

  _.assert( _.strIs( text ) );

  return function readUntilText_functor( direction )
  {

    var _delta;
    if( direction === 'ahead' )
    _delta = +1;
    else if( direction === 'behind' )
    _delta = -1;
    else
    throw _.err( 'not expected' );

    var readText = _readTextOfLength[ direction ];

    return function _readUntilText()
    {

      var self = this;
      var result = '';
      var firstByte = text.charCodeAt( 0 );
      var bytes = self.bytes;
      var index = -1;
      var begin = self.position;
      var shift;

      if( direction === 'behind' )
      throw _.err( 'not implemented' );

      while( true )
      {
        index = bytes.indexOf( firstByte,self.position );

        if( index !== -1 )
        {
          self.position = index;
          var data = _getTextLiteralAhead.call( this,text );
          if( data === undefined )
          {
            self.position = index + _delta;
          }
          else
          {
            if( !skip )
            {
              self.position = begin;
              result = readText.call( this,index-begin );
            }
            /*self.position += text.length;*/
            return result;
          }
        }
        else
        {
          if( !skip )
          result = readText.call( this,bytes.length - self._pos );
          break;
        }

      }

      return result;
    }
  }

}

//

function _readRestTextAhead()
{

  debugger;
  var left = this.left();
  var result = _getTextOfLengthAhead.call( this,left );

  this._pos += left;
  return result.data;
}

// --
// service
// --

function _genReadBytes( bytes )
{

  var result;
  _.assert( bytes.length >= 0 );

  if( bytes.length === 0 )
  result = function _readBytesZero(){ return bytes };
  else
  result = function _readBytes()
  {

    var self = this;
    var position = self._pos;
    var sbytes = self.bytes;

    if( self.left() < bytes.length )
    return;

    if( bytes[ 0 ] !== sbytes[ position ] )
    return;

    position += 1;

    for( var t = 1, tl = bytes.length ; t < tl ; t++, position += 1 )
    {
      if( bytes[ t ] !== sbytes[ position ] )
      return;
    }

    self._pos = position;

    return bytes;
  }

  result.external = { bytes : bytes };

  return result;
}

//

function _readUtfWrd2()
{
  var len = this.read.Wrd2();
  return this._readUtfStringOfLength( len );
}

//

function _readUtfStringOfLength( len )
{

  var result = []
  var c = 0;

  while( result.length < len )
  {

    var c1 = this._view.getUint8( this._pos++, this.littleEndian );
    if (c1 < 128)
    {
      result[c++] = String.fromCharCode(c1);
    }
    else if (c1 > 191 && c1 < 224)
    {
      var c2 = this._view.getUint8( this._pos++, this.littleEndian );
      result[c++] = String.fromCharCode((c1 & 31) << 6 | c2 & 63);
    }
    else
    {
      var c2 = this._view.getUint8( this._pos++, this.littleEndian );
      var c3 = this._view.getUint8( this._pos++, this.littleEndian );
      result[c++] = String.fromCharCode( (c1 & 15) << 12 | (c2 & 63) << 6 | c3 & 63 );
    }

  }

  if( this._pos > this.buffer.byteLength )
  throw wParser.err( 'wStream : out of bound' );
  return result.join('');
}

//

function _readMatrix4Stripped()
{

  var mtx = _.Space.makeIdentity4();
  var e = mtx.elements;

  e[0] = this.readFloat4();
  e[1] = this.readFloat4();
  e[2] = this.readFloat4();
  e[3] = 0.0;
  //e[3] = 0.0;

  e[4] = this.readFloat4();
  e[5] = this.readFloat4();
  e[6] = this.readFloat4();
  //e[7] = this.readFloat4();
  e[7] = 0.0;

  e[8] = this.readFloat4();
  e[9] = this.readFloat4();
  e[10] = this.readFloat4();
  //e[11] = this.readFloat4();
  e[11] = 0.0;

  //e[12] = -this.readFloat4();
  e[12] = this.readFloat4();
  e[13] = this.readFloat4();
  e[14] = this.readFloat4();
  //e[15] = this.readFloat4();
  e[15] = 1.0;

  return mtx;
}

//

function _readBase64OfSize( size )
{
  var self = this;
  var bytes = self.bytes;

  if( self.left() < size ) return;

  var result = _.base64FromBuffer( bytes.subarray( self._pos,self._pos+size ) );

  self.position += size;

  return result;
}

// --
// record
// --

function getRecordOptions_functor( direction )
{
  return function getRecordOptions()
  {
    var result = ( this.options === undefined ? { shift : 0, data : null } : { shift : 0, data : this.options } );
    return result;
  }
}

// --
// declare
// --

var Proto =
{

  // generator

  generateTextSeekingTerminalRoutine : generateTextSeekingTerminalRoutine,


  // tster

  charIsNumber : charIsNumber,


  // text

  _getCharAhead : _getCharAhead,
  _getLetterAhaed : _getLetterAhaed,

  _readTextLiteralAhead : _readTextLiteralAhead,
  _getTextLiteralAhead : _getTextLiteralAhead,

  getTextLetter_functor : getTextLetter_functor,
  getTextLetterUnerscore_functor : getTextLetterUnerscore_functor,
  getTextLetterDigitUnderscore_functor : getTextLetterDigitUnderscore_functor,
  getTextName_functor : getTextName_functor,

  /**/

  getTextOfLength_functor : getTextOfLength_functor,
  readTextOfLength_functor : readTextOfLength_functor,
  _getTextOfLength : _getTextOfLength,
  _getTextOfLengthAhead : _getTextOfLengthAhead,
  _getTextOfLengthBehind : _getTextOfLengthBehind,
  _readTextOfLength : _readTextOfLength,
  _readTextOfLengthAhead : _readTextOfLengthAhead,
  _readTextOfLengthBehind : _readTextOfLengthBehind,


  // number

  readTextNumberFast_functor : readTextNumberFast_functor,
  readTextNumber_functor : readTextNumber_functor,
  _generateReadTextNumberSlow : _generateReadTextNumberSlow,


  // space

  _readUntilSpaceAhead : _readUntilSpaceAhead,
  _readUntilSpaceBehind : _readUntilSpaceBehind,

  _getSingleLineSpacesAhead : _getSingleLineSpacesAhead,
  _getSingleLineSpacesBehind : _getSingleLineSpacesBehind,

  getSpace_functor : getSpace_functor,
  getMandatorySpace_functor : getMandatorySpace_functor,


  // conditional

  _isFirstNonBlankOnLineAhead : _isFirstNonBlankOnLineAhead,
  _isBeginOfLine : _isBeginOfLine,
  _isEndOfLine : _isEndOfLine,
  _isBeginOfFile : _isBeginOfFile,
  _isEndOfFile : _isEndOfFile,


  // sophisticated

  _readNotContainTextAhead : _readNotContainTextAhead,
  _readCountText : _readCountText,
  readUntilText_functor_functor : readUntilText_functor_functor,
  _readRestTextAhead : _readRestTextAhead,


  // service

  _genReadBytes : _genReadBytes,
  _readUtfWrd2 : _readUtfWrd2,
  _readUtfStringOfLength : _readUtfStringOfLength,
  _readMatrix4Stripped : _readMatrix4Stripped,
  _readBase64OfSize : _readBase64OfSize,


  // record

  getRecordOptions_functor : getRecordOptions_functor,


  // const

  _MAP_LETTERS : _MAP_LETTERS,
  _MAP_LETTERS_UNDERSCORE : _MAP_LETTERS_UNDERSCORE,
  _MAP_LETTERS_DIGIT_UNDERSCORE : _MAP_LETTERS_DIGIT_UNDERSCORE,
  _MAP_NUMBER_ONLY : _MAP_NUMBER_ONLY,

};

_.mapExtend( wParser.prototype,Proto );
_.mapExtend( wParser,Proto );

})();
