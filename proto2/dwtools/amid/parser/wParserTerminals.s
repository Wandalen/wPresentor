(function()
{

'use strict'; 

var _ = _global_.wTools;
var Parent = wStream;
var Self = wParser;
var DT = wParser.prototype.definitions;
var definitions = wParser.prototype.definitions;

/* old node fix */
var _arrayBuffer = new DataView( new ArrayBuffer( 1 ), 0, 0 );

// --
// fixed
// --

var Wrd1 =
{
  name : 'Wrd1',
  shortName : 'W1',
  size : 1,
  alternativity : 1 << 8,
  bufferType : Uint8Array,
  getView : _arrayBuffer.getUint8,
  setView : _arrayBuffer.setUint8,
}

var Wrd2 =
{
  name : 'Wrd2',
  shortName : 'W2',
  size : 2,
  alternativity : 1 << 16,
  bufferType : Uint16Array,
  getView : _arrayBuffer.getUint16,
  setView : _arrayBuffer.setUint16,
}

var Wrd4 =
{
  name : 'Wrd4',
  shortName : 'W4',
  size : 4,
  alternativity : 1,
  bufferType : Uint32Array,
  getView : _arrayBuffer.getUint32,
  setView : _arrayBuffer.setUint32,
}

//

var Int1 =
{
  name : 'Int1',
  shortName : 'I1',
  size : 1,
  alternativity : 1 << 8,
  bufferType : Int8Array,
  getView : _arrayBuffer.getInt8,
  setView : _arrayBuffer.setInt8,
}

var Int2 =
{
  name : 'Int2',
  shortName : 'I2',
  size : 2,
  alternativity : 1 << 16,
  bufferType : Int16Array,
  getView : _arrayBuffer.getInt16,
  setView : _arrayBuffer.setInt16,
}

var Int4 =
{
  name : 'Int4',
  shortName : 'I4',
  size : 4,
  alternativity : Infinity,
  bufferType : Int32Array,
  getView : _arrayBuffer.getInt32,
  setView : _arrayBuffer.setInt32,
}

//

var Float4 =
{
  name : 'Float4',
  shortName : 'F4',
  size : 4,
  alternativity : Infinity,
  bufferType : Float32Array,
  getView : _arrayBuffer.getFloat32,
  setView : _arrayBuffer.setFloat32,
}

var Float8 =
{
  name : 'Float8',
  shortName : 'F8',
  size : 8,
  alternativity : Infinity,
  bufferType : typeof Float64Array !== 'undefined' ? Float64Array : undefined,
  getView : _arrayBuffer.getFloat64,
  setView : _arrayBuffer.setFloat64,
}

// --
// text
// --

var Char =
{

  name : 'Char',
  size : 1,
  alternativity : 1 << 8,
  bufferType : Uint8Array,
  getView : _arrayBuffer.getUint8,
  setView : _arrayBuffer.setUint8,

  get : wParser._getCharAhead,

}

//

var AnyLetter =
{

  size : 1,
  alternativity : wParser._getLetterAhaed.alternativity,
  get : wParser._getLetterAhaed,

}

//

var Text =
{

  size : [ 1,wParser.infinity ],
  alternativity : Infinity,

  getAhead : wParser.getTextLetter_functor( 'ahead' ),
  getBehind : wParser.getTextLetter_functor( 'behind' ),

}

var DropText =
{
  type : Text,
  drop : 1,
}

// type text : letter underscore

var TextLetterUnerscore =
{

  size : [ 1,Infinity ],
  alternativity : Infinity,

  generateGet : wParser.getTextLetterUnerscore_functor

/*
  readAhead : wParser.readTextLetterUnerscore_functor( 'ahead' ),
  readBehind : null,
  getBehind : null,
*/

}

// type text : letter digit underscore

var TextLetterDigitUnderscore =
{

  size : [ 1,Infinity ],
  alternativity : Infinity,

  generateGet : wParser.getTextLetterDigitUnderscore_functor

}

//

var TextName =
{

  size : [ 1,Infinity ],
  alternativity : Infinity,

  generateGet : wParser.getTextName_functor

}

//

function TextOfLength( length )
{

  if( !_.numberIs( length ) )
  throw _.err( 'DT.TextOfLength : ','expects length' );

  var _getTextOfLengthAhead = wParser._getTextOfLengthAhead;
  var _getTextOfLengthBehind = wParser._getTextOfLengthBehind;

  var definition = _.mapExtend( null,DT.TextOfLength.definition );

  definition.size = length;
  definition._reader = {};
  definition._reader.length = length;

  if( length === 0 )
  definition.alternativity = 1;

  definition.getAhead = function getTextOfLengthAhead()
  {
    var result = _getTextOfLengthAhead.call( this,length );
    return result;
  }
  definition.getBehind = function getTextOfLengthBehind()
  {
    var result = _getTextOfLengthBehind.call( this,length );
    return result;
  }

  return definition;
}

TextOfLength.definition =
{
  type : null,
  alternativity : Infinity,
  size : [ 0,wParser.infinity ],
}

// --
// generated
// --

function TextLiteral( text )
{

  if( !_.strIs( text ) )
  throw _.err( 'DT.TextLiteral','text is needed' );

  var bytes = _.strToBytes( text );
  var readBytes = wParser._genReadBytes( bytes );

  var definition = _.mapExtend( null,DT.TextLiteral.definition );
  definition.size = text.length;
  definition._reader = {};
  definition._reader.text = text;
  definition._reader.bytes = bytes;
  definition.read = readBytes;

  definition.read = function readText()
  {
    var read = readBytes.call( this );
    if( read === undefined ) return;
    return text;
  }

  //definition.read.code = _.routineParse

  definition.read.inline = { readBytes : readBytes };
  //definition.read.external = { readBytes : readBytes };
  definition.read.external = readBytes.external;
  definition.read.constant = { text : text };

  return definition;
}

TextLiteral.definition =
{
  type : null,
  size : [ 0,wParser.infinity ],
  alternativity : 1,
}

//

function DropTextLiteral( text )
{

  var result = _.mapExtend( null,DT.DropTextLiteral.definition );
  result.type = DT.TextLiteral( text );
  return result;

/*
  var definition = DT.TextLiteral( text );
  _.mapExtend( definition,DT.DropTextLiteral.definition );
  return definition;
*/

}

DropTextLiteral.definition =
{
  drop : 1,
}

//

function DropTextLiteralSpaced( text )
{

  if( !_.strIs( text ) )
  throw _.err( 'DT.TextLiteral','text is needed' );

  var definition = _.mapExtend( null,DT.TextLiteral.definition );
  definition._reader = {};
  definition._reader.text = text;
  definition.read = function readDropTextLiteralSpaced()
  {
    return wParser._readSpaces.call( this ) + wParser._readTextLiteral.call( this,text ) + wParser._readSpaces.call( this );
  };

  return definition;
  //return wParser.definitionNormalizeAccessors( definition );
}

DropTextLiteralSpaced.definition =
{
  type : null,
  drop : 1,
}

// --
// number
// --

var TextNumber =
{

  size : [ 1,Infinity ],
  alternativity : Infinity,

  readAhead : wParser.readTextNumber_functor( 'ahead' ),
  readBehind : wParser.readTextNumber_functor( 'behind' ),

}

// --
// space
// --

var SingleLineSpaces =
{

  size : [ 0,wParser.infinity ],
  alternativity : Infinity,
  getAhead : wParser._getSingleLineSpacesAhead,
  getBehind : wParser._getSingleLineSpacesBehind,

}

var DropSingleLineSpaces =
{

  type : SingleLineSpaces,
  drop : 1,

}

//

var Spaces =
{

  alternativity : Infinity,
  size : [ 0,wParser.infinity ],

  generateGet : wParser.getSpace_functor

}

var DropSpaces =
{

  type : Spaces,
  drop : 1,

}

//

var MandatorySpaces =
{

  alternativity : Infinity,
  size : [ 1,wParser.infinity ],

  generateGet : wParser.getMandatorySpace_functor

}

var DropMandatorySpaces =
{

  type : MandatorySpaces,
  drop : 1,

}

//

var UntilEol =
{

  alternativity : Infinity,
  size : [ 0,Infinity ],

  generateRead : wParser.readUntilText_functor_functor( '\n' ),

}

var DropUntilEol =
{

  type : UntilEol,
  drop : 1,

}

//

var UntilSpace =
{

  alternativity : Infinity,
  size : [ 0,wParser.infinity ],
  readAhead : wParser._readUntilSpaceAhead,
  readBehind : wParser._readUntilSpaceBehind,

}

var DropUntilSpace =
{

  type : UntilSpace,
  drop : 1,

}

// --
// sophisticated
// --

var RestText =
{

  size : [ 0,Infinity ],
  alternativity : Infinity,

  readAhead : wParser._readRestTextAhead,
  readBehind : null,
  getBehind : null,

}

//

function NotContainText( text )
{

  if( text === undefined )
  throw _.err( 'DT.NotContainText','text is needed' );

  var definition = _.mapExtend( null,DT.NotContainText.definition );
  definition._reader = {};
  definition._reader.notContainText = text;

  definition.readAhead = function readNotContainText()
  {
    return wParser._readNotContainTextAhead.call( this,text );
  };
  definition.readBehind = null;
  definition.getBehind = null;

  return definition;
  //return wParser.definitionNormalizeAccessors( definition );
}

NotContainText.definition =
{
  type : null,
  alternativity : Infinity,
  size : [ 0,wParser.infinity ],
}

//

function DropNotContainText( text )
{

  var result = _.mapExtend( null,DT.DropNotContainText.definition );
  result.type = DT.NotContainText( text );
  return result;
/*
  var definition = DT.NotContainText( text );
  _.mapExtend( definition,DT.DropNotContainText.definition );
  return definition;
*/
}

DropNotContainText.definition =
{
  drop : 1,
}

//

function CountText( text )
{

  if( text === undefined )
  throw _.err( 'DT.CountText','text is needed' );

  var _readCountText = wParser._readCountText;
  var definition = _.mapExtend( null,DT.CountText.definition );
  definition._reader = {};
  definition._reader.countText = text;
  definition.read = function readCountText()
  {
    return _readCountText.call( this,text );
  };

  return definition;
}

CountText.definition =
{
  type : null,
  size : [ 0,wParser.infinity ],
}

//

function UntilText( text )
{

  if( !_.strIs( text ) )
  throw _.err( 'UntilText : ','expects string' );

  var definition = _.mapExtend( null,DT.UntilText.definition );
  definition.size = text.length;
  definition._reader = {};
  definition._reader.text = text;
  definition.generateRead = wParser.readUntilText_functor_functor( text );

  return definition;
}

UntilText.definition =
{
  type : null,
  alternativity : Infinity,
  size : [ 0,wParser.infinity ],
}

// --
// service
// --

var matrix4Stripped =
{
  size : 12,
  alternativity : Infinity,
  read : wParser._readMatrix4Stripped,
}

// string

var UtfWrd2 =
{
  size : [ 2,65538 ],
  alternativity : Infinity,
  //size : function(){ return this.get.Wrd2() },
  readAhead : wParser._readUtfWrd2,
  readBehind : null,
  getBehind : null,
}

/*
var UtfString =
{

  size : [0,Infinity],
  size : null,
  read : wParser._readUtfStringOfLength,

}
*/
// --
// conditional
// --

var FirstNonBlankOnLine =
{
  type :
  [{
    name : 'FirstNonBlankOnLineTerminal',
    type : null,
    size : [ 0,wParser.infinity ],
    alternativity : Infinity,

    readAhead : wParser._isFirstNonBlankOnLineAhead,
    readBehind : null,
    getBehind : null,

  }],
  drop : 1,
}

var BeginOfLine =
{
  type :
  [{
    name : 'BeginOfLineTerminal',
    type : null,
    read : wParser._isBeginOfLine,
    size : 0,
    alternativity : 1,
  }],
  drop : 1,
}

var EndOfLine =
{
  type :
  [{
    name : 'EndOfLineTerminal',
    type : null,
    read : wParser._isEndOfLine,
    size : 0,
    alternativity : 1,
  }],
  drop : 1,
}

var BeginOfFile =
{
  type :
  [{
    name : 'BeginOfFileTerminal',
    type : null,
    read : wParser._isBeginOfFile,
    size : 0,
    alternativity : 1,
  }],
  drop : 1,
}

var EndOfFile =
{
  type :
  [{
    name : 'EndOfFileTerminal',
    type : null,
    read : wParser._isEndOfFile,
    size : 0,
    alternativity : 1,
  }],
  drop : 1,
}

// --
// unconditional
// --

var Null =
{
  type : null,
  size : 0,
  alternativity : 1,
  generateGet : function( direction ) { return function( direction ){ return { data : null, shift : 0 } } },
}

//

var Void =
{
  type : [ Null ],
  drop : 1,
  unwrap : 1,
}

//

var Debug =
{
  type : [ Null ],
  drop : 1,
  unwrap : 1,
  debug : 1,
}

//

function RecordData( data )
{

  if( data === undefined )
  throw _.err( 'DT.CountText','data is needed' );

  var definition = _.mapExtend( null,DT.RecordData.definition );
  definition._reader = {};
  definition._reader.data = data;
  definition.read = function writeText()
  {

    if( data === 'deprecated' )
    console.log( 'RecordData : ',data );
    if( data === 'exp' )
    console.log( 'RecordData : ',data );

    return data;
  }

  return definition;
}

RecordData.definition =
{
  type : null,
  size : 0,
  alternativity : 1,
}

//

var RecordPosition =
{

  type : null,
  size : 0,
  alternativity : 1,

  generateGet : function( direction ){ return function getStorePosition(){ return { data : this._pos, shift : 0 }; } },

}

//

var RecordOptions =
{

  type : null,
  size : 0,
  alternativity : 1,

  generateGet : wParser.getRecordOptions_functor

}

//

var Proto =
{

  // fixed

  Wrd1 : Wrd1,
  Wrd2 : Wrd2,
  Wrd4 : Wrd4,

  Int1 : Int1,
  Int2 : Int2,
  Int4 : Int4,

  Float4 : Float4,
  Float8 : Float8,


  // text

  Char : Char,
  AnyLetter : AnyLetter,

  Text : Text,
  DropText : DropText,

  TextLetterUnerscore : TextLetterUnerscore,
  TextLetterDigitUnderscore : TextLetterDigitUnderscore,
  TextName : TextName,

  TextOfLength : TextOfLength,

  TextLiteral : TextLiteral,
  DropTextLiteral : DropTextLiteral,
  DropTextLiteralSpaced : DropTextLiteralSpaced,


  // number

  TextNumber : TextNumber,


  // space

  SingleLineSpaces : SingleLineSpaces,
  DropSingleLineSpaces : DropSingleLineSpaces,

  Spaces : Spaces,
  DropSpaces : DropSpaces,
  MandatorySpaces : MandatorySpaces,
  DropMandatorySpaces : DropMandatorySpaces,

  UntilEol : UntilEol,
  DropUntilEol : DropUntilEol,

  UntilSpace : UntilSpace,
  DropUntilSpace : DropUntilSpace,


  // sophisticated

  RestText : RestText,

  NotContainText : NotContainText,
  DropNotContainText : DropNotContainText,

  CountText : CountText,

  UntilText : UntilText,


  // service

  matrix4Stripped : matrix4Stripped,
  UtfWrd2 : UtfWrd2,


  // conditional

  FirstNonBlankOnLine : FirstNonBlankOnLine,
  BeginOfLine : BeginOfLine,
  EndOfLine : EndOfLine,
  BeginOfFile : BeginOfFile,
  EndOfFile : EndOfFile,


  // unconditional

  Null : Null,
  Void : Void,
  Debug : Debug,

  RecordData : RecordData,
  RecordPosition : RecordPosition,
  RecordOptions : RecordOptions,

}

wParser.prototype.bindDefinitions( Proto );

})();
