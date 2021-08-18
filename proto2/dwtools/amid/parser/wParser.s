(function wParser() {

'use strict';

if( typeof module !== 'undefined' && module !== null )
{

  require( '../../abase/mixin/Copyable.s' );
  require( './Stream.s' );

}

var _ObjectHasOwnProperty = Object.hasOwnProperty;
var _ = _global_.wTools;
var Parent = wStream;
var Self = function wParser( o )
{
  if( !( this instanceof Self ) )
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

// --
// inter
// --

function init( o )
{

  var self = this;
  Parent.prototype.init.call( self,o );

  if( self.definition )
  throw _.err( 'wParser.init :','definition must be bound by bindDefinition' );

  if( !_.mapOwnKey( self,{ definitions : 'definitions' } ) )
  {
    self.definitions = {};
    self.definitions.__proto__ = Self.prototype.definitions;
  }

  for( var e in self._entry )
  {
    var entry = _entry[ e ];

    entry = Object.create( entry );
    entry._this = self;
    self[ e ] = entry;

  }

  //Object.preventExtensions( self );
  //Object.seal( self );

}

//

function ensureDefinition( definition )
{
  var self = this;
  var name = definition.name;

  if( name === undefined )
  throw _.err( 'wParser.ensureDefinition :','definition has no name',_.toStr( definition ) );

  if( self.definitions[ name ] )
  return self.definitions[ name ];

  self.bindDefinition( definition );

  return definition;
}

// --
// binder
// --

function bindDefinitions( definitions )
{

  var self = this;

  for( var d in definitions )
  {

    var definition = definitions[ d ];

    var isRoutine = _.routineIs( definition );
    if( isRoutine && definition.definition )
    {
      definition.definition.generate = definition;
      definition = definition.definition;
    }

    if( _.arrayIs( definition ) )
    definition = { type : definition };

    if( !_.objectIs( definition ) )
    throw _.err( 'bindDefinitions :','definition should be object' );

    if( definition.name === undefined )
    definition.name = d;

    if( isRoutine )
    {
      if( definition.name !== definition.generate.name )
      throw _.err( 'bindDefinitions','routine dynamic definition should have same name as its descriptor' )
    }

    if( !isRoutine )
    definitions[ d ] = definition;

  }

  // bind definition pre

  for( var d in definitions )
  {

    var definition = definitions[ d ];
    definitions[ d ] = self.bindDefinitionPre( definition );

  }

  // bind definition mid

  for( var d in definitions )
  {

    var definition = definitions[ d ];
    definitions[ d ] = self.bindDefinitionMid( definition );

  }

  // bind definition post

  for( var d in definitions )
  {

    var definition = definitions[ d ];

    var isRoutine = _.routineIs( definition );
    if( isRoutine )
    continue;

    definitions[ d ] = self.bindDefinitionPost( definition );

  }

}

//

function bindDefinition( definition )
{
  var self = this;

  if( !self.tagsNormalizeList || !self.tagsCompileList || !self.tagsMap )
  throw _.err( 'wParser.bindDefinition :','lack of tags, some modules are not included!' );

  _.assert( arguments.length === 1, 'expects single argument' );

  definition = self.bindDefinitionPre( definition );
  definition = self.bindDefinitionMid( definition );
  definition = self.bindDefinitionPost( definition );

  return definition;
}

//

function bindDefinitionPre( definition )
{
  var self = this;
  if( _.constructorIs( self ) )
  self = _.prototypeGet( self );

  _.assert( _.strIs( definition.name ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( self.definitions[ definition.name ] )
  throw _.err( 'wParser.bindDefinition :','definition is overridden',definition.name );

  if( !_.routineIs( definition ) )
  if( self.definitionMakePre )
  {
    definition = self.definitionMakePre( definition );
  }
  else
  {
    debugger;
    definition = self.definitionNormalize( definition );
  }

  var name = definition.name;
  self.definitions[ name ] = definition;

  return definition;
}

//

function bindDefinitionMid( definition )
{
  var self = this;
  var name = definition.name;

  _.assert( _.strIs( definition.name ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  if( !_.routineIs( definition ) )
  definition = self.definitionMakeMid( definition );

  _.assert( name === definition.name );

  return definition;
}

//

function bindDefinitionPost( definition )
{
  var self = this;
  if( _.constructorIs( self ) )
  self = _.prototypeGet( self );

  if( self.definitions[ definition.name ] && self.definitions[ definition.name ] !== definition )
  throw _.err( 'wParser.bindDefinition :','definition is overridden',definition.name );

  _.assert( arguments.length === 1, 'expects single argument' );

  if( definition.hasReferences )
  definition = self.definitionResolveReferences( definition );

  //_.assert( definition.hasReferences === 0 );
/*
  if( definition.name === 'Expression' )
  {
    console.log( wParser.definitionToStr( definition ) );
    console.log( wParser.definitionToStrField( definition,'name' ) );
  }
*/

  if( self.definitionInstanceMake ) // deprecated
  definition = self.definitionInstanceMake( definition );

/*
  if( definition.name === 'Expression' )
  {
    console.log( wParser.definitionToStrField( definition,'name' ) );
    console.log( wParser.definitionToStr( definition ) );
  }
*/

  if( self.definitionRefine )  // deprecated
  self.definitionRefine( definition );

  self.compileDefinition( definition );

  self.bindDefinitionEntries( definition );

  var name = definition.name;
  self.definitions[ name ] = definition;

  return definition;
}

//

function bindDefinitionEntries( definition )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  var name = definition.name;
  var reader = definition._reader;

  {

    if( !definition._.execReadRoot )
    throw _.err( 'not expected' );

    var read = definition._.execReadRoot ? definition._.execReadRoot : ( reader._reader && reader._reader.read );
    _.assert( _.routineIs( read[ 'ahead' ] ) );
    _.assert( _.routineIs( read[ 'behind' ] ) );
    if( read )
    {

      if( self._entry.read[ name ] )
      throw _.err( 'wParser.bindDefinition :','"read" is overridden',name );
      self._entry.read[ name ] = function(){ return read[ 'ahead' ].apply( this._this,arguments ); };

      if( self._entry.readAhead[ name ] )
      throw _.err( 'wParser.bindDefinition :','"readAhead" is overridden',name );
      self._entry.readAhead[ name ] = function(){ return read[ 'ahead' ].apply( this._this,arguments ); };

      if( self._entry.readBehind[ name ] )
      throw _.err( 'wParser.bindDefinition :','"readBehind" is overridden',name );
      self._entry.readBehind[ name ] = function(){ return read[ 'behind' ].apply( this._this,arguments ); };

      self._entry.readAhead[ name ].opposite = self._entry.readBehind[ name ];
      self._entry.readBehind[ name ].opposite = self._entry.readAhead[ name ];

    }

    var get = reader && reader.get;
    if( get )
    {

      _.assert( _.routineIs( get[ 'ahead' ] ) );
      _.assert( _.routineIs( get[ 'behind' ] ) || get[ 'behind' ] === null );

      if( self._entry.get[ name ] )
      throw _.err( 'wParser.bindDefinition :','"get" is overridden',name );
      self._entry.get[ name ] = function(){ return get.apply( this._this,arguments ); };

      if( self._entry.getAhead[ name ] )
      throw _.err( 'wParser.bindDefinition :','"getAhead" is overridden',name );
      self._entry.getAhead[ name ] = function(){ return get[ 'ahead' ].apply( this._this,arguments ); };

      if( self._entry.getBehind[ name ] )
      throw _.err( 'wParser.bindDefinition :','"getBehind" is overridden',name );
      if( !get[ 'behind' ] === null )
      self._entry.getBehind[ name ] = function notImplemented(){ throw _.err( 'not implemented' ) };
      else
      self._entry.getBehind[ name ] = function(){ return get[ 'behind' ].apply( this._this,arguments ); };

      self._entry.getAhead[ name ].opposite = self._entry.getBehind[ name ];
      self._entry.getBehind[ name ].opposite = self._entry.getAhead[ name ];

    }

    var getView = reader && reader.getView;
    if( getView )
    {
      //self[ getViewName ] = getView;
      if( self._entry.getView[ name ] )
      throw _.err( 'wParser.bindDefinition :','"getView" is overridden',name );
      self._entry.getView[ name ] = function(){ return getView.apply( this._this,arguments ); };
    }

    var getBuffer = reader && reader.getBuffer;
    if( getBuffer )
    {
      //self[ getBufferName ] = getBuffer;
      if( self._entry.getBuffer[ name ] )
      throw _.err( 'wParser.bindDefinition :','"getBuffer" is overridden',name );
      self._entry.getBuffer[ name ] = function(){ return getBuffer.apply( this._this,arguments ); };
    }

  }

  //

  //if( hasWriter )
  {

    //if( self[ writeName ] || self[ setName ] )
    //throw _.err( 'wParser.bindDefinition :','definition is overridden',name );

    var writer = definition._writer;

    var write = ( writer && writer.write ) || definition._.execWrite;
    if( write )
    {
      //self[ writeName ] = write;
      if( self._entry.write[ name ] )
      throw _.err( 'wParser.bindDefinition :','"write" is overridden',name );
      self._entry.write[ name ] = function()
      {
        /*console.log( this._this.name,'writes',name,_.toStr( arguments ) );*/
        return write.apply( this._this,arguments );
      };
    }

    var writes = writer && writer.writes;
    if( writes )
    {
      //self[ writesName ] = writes;
      if( self._entry.writes[ name ] )
      throw _.err( 'wParser.bindDefinition :','"writes" is overridden',name );
      self._entry.writes[ name ] = function(){ return writes.apply( this._this,arguments ); };
    }

    var set = writer && writer.set;
    if( set )
    {
      //self[ setName ] = set;
      if( self._entry.set[ name ] )
      throw _.err( 'wParser.bindDefinition :','"set" is overridden',name );
      self._entry.set[ name ] = function(){ return set.apply( this._this,arguments ); };
    }

    var setView = writer && writer.setView;
    if( setView )
    {
      //self[ setViewName ] = setView;
      if( self._entry.setView[ name ] )
      throw _.err( 'wParser.bindDefinition :','"setView" is overridden',name );
      self._entry.setView[ name ] = function(){ return setView.apply( this._this,arguments ); };
    }

  }

  return definition;
}

// --
// report
// --

function reportUselessness( msg,force )
{
  var self = this;
  var msg = 'Using useless consolidation of tags. ' + msg;

  if( self.using.allowUselessConsolidation && !force )
  console.warn( msg );
  else
  throw _.err( msg );

}

//

function reportDeadLoopIfDefinitionMinimalWindSizeIsIrregular( definition,msg )
{
  var self = this;
  var msg = '';

  var minWindSize = _.numberIs( definition._.windSize ) ? definition._.windSize : definition._.windSize[ 0 ];
  if( !_.numberIsFinite( minWindSize ) )
  {

    msg = _.str( 'wParser :','Potential dead loop.\n','Minimal wind size is irregular :',self.definitionToStr( definition ) );

    if( self.using.allowDeadLoops )
    console.warn( msg );
    else
    throw _.err( msg );

  }

}

//

function reportDeadLoopIfDefinitionMinimalWindSizeIsZero( definition,msg )
{
  var self = this;
  var msg = '';

  var minWindSize = _.numberIs( definition._.windSize ) ? definition._.windSize : definition._.windSize[ 0 ];
  if( minWindSize === 0 )
  {

    msg = _.str( 'wParser :','Potential dead loop.\n','Repeat zero length component infinity times : ',self.definitionToStr( definition ) );

    if( self.using.allowDeadLoops )
    console.warn( msg );
    else
    throw _.err( msg );

  }
  else self.reportDeadLoopIfDefinitionMinimalWindSizeIsIrregular( definition,msg );

}

//

function reportAlternativity( definition,msg )
{
  var self = this;
  var msg = '';

  var alternativity = definition._.alternativity;

  if( definition._.alternativity === 0 )
  {

    msg = _.str( 'wParser :','definition has none valid alternatives :',self.definitionToStr( definition ) );

    if( self.using.allowZeroAlternativity )
    console.warn( msg );
    else
    throw _.err( msg );

  }

}

// --
// etc
// --

function _definitionToStr( o )
{
  var self = this;

  o.result = o.result || '';

  if( o.field )
  o.useSelector = o.field.indexOf( '.' ) !== -1;

  self.definitionEach
  ({
    definition : o.definition,
    onUp : _.routineJoin( self,_definitionToStrElement,[ o ] ),
    onCycle : _.routineJoin( self,_definitionToStrElement,[ o ] ),
    marker : null,
  });

  return o.result;
}

//

function _definitionToStrElement( o,place )
{

  var self = this;
  var result = '';
  var definition = place.definition;
  var tab = o.tab;

/*
  if( place.definition.name === 'optional_product' )
  debugger;
*/

  /*var visited = place.visited.indexOf( place.definition ) !== place.visited.length-1;*/
  var visited = place.isVisited( place.definition );

  o.tab = _.strTimes( '-',place.visited.length-1 );

  if( place.visited.length > o.levels )
  return;

  var name = definition._ ? ( definition._.nameCombinator || ( definition._.name !== undefined ? definition._.name : definition.name ) ) : definition.name;

  if( !o.field )
  result += '\n' + o.tab + name + '\n';

  if( o.field )
  {

    var val;
    if( o.useSelector )
    val = _.entitySelect( definition,o.field );
    else
    val = ( definition._ && definition._[ o.field ] !== undefined ) ? definition._[ o.field ] : definition[ o.field ];

    result += o.tab + _.toStr( val,{ tab : o.tab, levels : 2, prependTab : 0 } );

    if( visited )
    {
      result += ' <- ( cycle branching )';
    }

    result += '\n';

  }
  else
  {

    var opt =
    {
      noSubObject : 1,
      noRoutine : 1,
      noArray : 1,
      levels : 2,
      tab : o.tab,
      dtab : '  '
    }
    var info = _.mapExtend( null,definition );
    if( definition._ )
    _.mapSupplement( info,
    {
      name : definition._.name,
      path : definition._.path,
      id : definition._.id,
      ordinal : definition._.ordinal,
    });
    result += _.toStr( info,opt );

  }

  o.level += 1;

  var elements = definition.elements || definition.elementProtos;

  o.result += result;

}

//
/*
function _definitionToStr_( o )
{

  var result = '';
  var definition = o.definition;
  var tab = o.tab;
  var visited = o.visited.indexOf( o.definition ) !== -1;

  if( o.level >= o.levels )
  return result;

  if( !visited )
  o.visited.push( o.definition );

  if( !o.field )
  result += ( definition._ ? ( definition._.nameCombinator || definition._.name ) : definition.name ) + '\n';

  if( o.field )
  {
    var val = ( definition._ && definition._[ o.field ] !== undefined ) ? definition._[ o.field ] : definition[ o.field ];
    result += _.toStr( val );

    if( visited )
    result += ' <- ( cycle branching )';

  }
  else if( !o.compact )
  {

    var o =
    {
      noSubObject : 1,
      noRoutine : 1,
      noArray : 1,
      levels : 2,
      tab : o.tab,
      dtab : '  '
    }
    var info = _.mapExtend( null,definition,definition._ || {} );
    result += _.toStr( info,o );

  }

  o.tab += '--';
  o.level += 1;

  var elements = definition.elements || definition.elementProtos;

  if( !visited )
  if( _.arrayIs( elements ) )
  {
    for( var t = 0 ; t < elements.length ; t++ )
    {
      var o = _.mapExtend( null,o );
      o.definition = elements[ t ];
      var r = _definitionToStr_( o );
      if( r )
      result += '\n' + tab + r;
    }
  }

  if( !visited )
  {
    _.assert( o.visited[ o.visited.length - 1 ] === o.definition );
    o.visited.pop();
  }

  return result;
}
*/
//

function definitionToStr( definition,tab )
{
  var self = this;
  var result = '';
  tab = tab || '--';

  var o =
  {
    //visited : [],
    //compact : 0,
    definition : definition,
    tab : tab,
    //level : 0,
    levels : 8,
  }

  return self._definitionToStr( o );
}

//

function definitionToStrField( definition,field )
{
  var self = this;
  var result = '';
  var tab = '--';
  var field = field || 'path';

  var o =
  {
    //visited : [],
    //compact : 1,
    definition : definition,
    field : field,
    tab : tab,
    //level : 0,
    levels : 5,
  }

  return self._definitionToStr( o );
}

//

function definitionInfo( definition )
{
  var self = this;
  var result = '';

  function info( name )
  {
    result += name + ' :\n';
    result += self.definitionToStrField( definition,name ) + '\n';
  }

  /*info( '_.alternativelessList.*' );*/
  info( '_.alternativelessList.*.definition._.path' );

  info( 'path' );
  info( 'name' );
  info( 'array' );
  info( '_.execReadList.*.ahead.name' );
  info( '_.generateStoreList.*.ahead.name' );
  info( 'id' );

/*
  info( 'cycleBranching' );
  info( '_.cycleAbove.*._.name' );
  info( '_.cycleUnder.*._.name' );
  info( '_.cyclePath.*._.name' );
*/

  console.log( result );

  return result;
}

// --
// etc
// --

function definitionNameWithBufferGet( arrayType )
{
  var def = Self.definitionWithBufferTypGet( arrayType );

  if( !def )
  return def;

  return def.name;
}

//

function definitionWithBufferTypGet( arrayType )
{
  var self = this;
  if( _.constructorIs( self ) )
  self = _.prototypeGet( self );

  var result;
  var DT = self.definitions;
  // var DT = Self.definitions;

  if( _.constructorIsBuffer( arrayType ) )
  {

    if( arrayType === Float32Array ) result = DT.Float4;
    else if( arrayType === Float64Array ) result = DT.Float8;
    else if( arrayType === Uint8Array ) result = DT.Wrd1;
    else if( arrayType === Uint16Array ) result = DT.Wrd2;
    else if( arrayType === Uint32Array ) result = DT.Wrd4;
    else if( arrayType === Int8Array ) result = DT.Int1;
    else if( arrayType === Int16Array ) result = DT.Int2;
    else if( arrayType === Int32Array ) result = DT.Int4;

  }
  else
  {

    if( arrayType instanceof Float32Array ) result = DT.Float4;
    else if( arrayType instanceof Float64Array ) result = DT.Float8;
    else if( arrayType instanceof Uint8Array ) result = DT.Wrd1;
    else if( arrayType instanceof Uint16Array ) result = DT.Wrd2;
    else if( arrayType instanceof Uint32Array ) result = DT.Wrd4;
    else if( arrayType instanceof Int8Array ) result = DT.Int1;
    else if( arrayType instanceof Int16Array ) result = DT.Int2;
    else if( arrayType instanceof Int32Array ) result = DT.Int4;

  }

  if( !result )
  {
    /*throw _.err( 'wStream.definitionWithBufferTypGet :','unknwon arrayType type' );*/
    return null;
  }

  return result;
}

//

function generateBidirection( generateRead )
{
  var self = this;

  _.assert( _.routineIs( generateRead ) );
  _.assert( generateRead.length === 1 );
  _.assert( arguments.length === 1, 'expects single argument' );

  var result = {};
  result[ 'ahead' ] = generateRead( 'ahead' );
  result[ 'behind' ] = generateRead( 'behind' );
  Object.freeze( result );

  return result;
}

// --
//
// --
/*
function generateReadForGetReturningString( get )
{

  function readAhaed( length )
  {

    var result = get.call( this,length )

    if( result === undefined )
    return;

    this._pos += length;
    return result;
  }

}
*/
// --
// var
// --

var infinity = Infinity;
var definitions = {};
var DT = definitions;
var _idCounter = [ 0 ];

//

var _entry =
{

  read : {},
  readAhead : {},
  readBehind : {},

  get : {},
  getAhead : {},
  getBehind : {},

  getView : {},
  getBuffer : {},

  write : {},
  writes : {},
  set : {},
  setView : {},

}

//

var using =
{

  /* name nameless elements of combinations if possible or throw error */
  implicitElementNaming : true,

  /* ignore or throw error on potential dead loops during compilation */
  allowDeadLoops : false,

  /* allow alternativeless definitions */
  allowZeroAlternativity : false,

  /* warn or throw error on useless consolidations of tags */
  allowUselessConsolidation : true,

  /* heavy optimization with inlining */
  heavyOptimization : false,

}

Object.freeze( using );

// --
// relations
// --

var Composes =
{
  name : '',
}

var Restricts =
{
  definitions : null,
  // _pos : null,
  // _view : null,
  // definitions : null,
  // read : null,
  // readAhead : null,
  // readBehind : null,
  // get : null,
  // getAhead : null,
  // getBehind : null,
  // getView : null,
  // getBuffer : null,
  // write : null,
  // writes : null,
  // set : null,
  // setView : null,
}

var Statics =
{

  // binder

  bindDefinitions : bindDefinitions,

  bindDefinition : bindDefinition,

  bindDefinitionPre : bindDefinitionPre,
  bindDefinitionMid : bindDefinitionMid,
  bindDefinitionPost : bindDefinitionPost,

  bindDefinitionEntries : bindDefinitionEntries,


  // report

  reportUselessness : reportUselessness,

  reportDeadLoopIfDefinitionMinimalWindSizeIsIrregular : reportDeadLoopIfDefinitionMinimalWindSizeIsIrregular,
  reportDeadLoopIfDefinitionMinimalWindSizeIsZero : reportDeadLoopIfDefinitionMinimalWindSizeIsZero,

  reportAlternativity : reportAlternativity,


  // etc

  _definitionToStr : _definitionToStr,
  _definitionToStrElement : _definitionToStrElement,

  definitionToStr : definitionToStr,
  definitionToStrField : definitionToStrField,

  definitionInfo : definitionInfo,


  // etc

  definitionNameWithBufferGet : definitionNameWithBufferGet,
  definitionWithBufferTypGet : definitionWithBufferTypGet,

  generateBidirection : generateBidirection,


  // var

  _idCounter : _idCounter,
  infinity : infinity,

  _entry : _entry,
  using : using,

  // definitions : definitions,

}

// _pos,_view,definitions,read,readAhead,readBehind,get,getAhead,getBehind,getView,getBuffer,write,writes,set,setView,name

// --
// declare
// --

var Proto =
{

  // inter

  init : init,
  ensureDefinition : ensureDefinition,

  //

  definitions : definitions,

  //

  
  Composes : Composes,
  Restricts : Restricts,
  Statics : Statics,

}

_.mapExtend( Proto,Statics );

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
  // supplement : { Statics : Proto },
});

// forbid

_.accessorForbid( Self.prototype,
{

  DT : 'DT',
  DefType : 'DefType',
  Definitions : 'Definitions',

});

_.accessorForbid
({
  object : Self,
  prime : 0,
  names :
  {

    DT : 'DT',
    DefType : 'DefType',
    Definitions : 'Definitions',

  },
});

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

_global_.wParser = Self;

})();


//

if( typeof module !== 'undefined' && module !== null )
{

  require( './wParserCompiler.s' );
  require( './wParserNormalizer.s' );
  require( './wParserNormalizer2.s' );
  require( './wParserRoutines.s' );
  require( './wParserTags.s' );
  require( './wParserTerminals.s' );
  require( '../../abase/layer4/Encoder.s' );

}
