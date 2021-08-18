(function() {

'use strict';

var _ = _global_.wTools;
var Parent = wStream;
var Self = wParser;
var definitions = wParser.prototype.definitions;
var DEBUG = Config.debug;

// --
// normalize
// --

function definitionMakePre( definition )
{
  var self = this;

  if( Config.debug )
  if( definition.debugNormalization )
  debugger;

  definition = self.definitionTransformRaw( definition );

  return definition;
}

//

function definitionMakeMid( definition )
{
  var self = this;

  if( Config.debug )
  if( definition.debugNormalization )
  debugger;

  // if( definition.name === 'ExpressionProduct' )
  // debugger;

  definition = self.definitionTransformRaw( definition );

  self.definitionTransformReference( definition );
  self.definitionTransformTerminalSeparation( definition );

  self.definitionTransformSubclass( definition );

  /* */

  self.definitionAdjustPreVerification( definition );

  self.definitionAdjustTerminal( definition );

  self.definitionAdjustCombination( definition );

  self.definitionAdjustCycle( definition );

/*
  if( definition.name === 'TestNewContainerButTerminal' )
  debugger;
  if( definition.name === 'TestNewContainerButTerminal' )
  console.log( self.definitionToStrField( definition ) );
*/

  self.definitionRefineUp( definition );
  self.definitionRefineDown( definition );

  self.definitionFetchAlternativeless( definition );

  self.definitionNormalizeTags( definition );
  self.definitionAdjustPostVerification( definition );

  return definition;
}

//

function definitionTransformRaw( definition,combinator )
{
  var self = this;

  return self._definitionTransformRaw
  ({
    definition : definition,
    combinator : combinator,
    visited : [],
  });

}

//

function _definitionTransformRaw( o )
{
  var self = this;
  var definition = o.definition;
  var combinator = o.combinator;
  var visited = o.visited;

  if( o.definition.debugNormalization )
  debugger;

/*
  if( definition.name === 'TestExpression4' )
  debugger;
*/

  if( definition._doneTransformShortcut )
  return definition;

  // from

  definition = self._definitionTransformRawFormElement( definition );
  /*definition._ = { combinator : combinator || null };*/

  // visited

  var d = _.arrayLeft( visited,{ original : o.definition },function( a,b ){ return a.original === b.original } );
  if( d.element )
  {
    /* debugger; */
    _.assert( d.element.derived !== d.element.original,'not tested' );
    _.assert( !o.sup,'not tested' );
    return d.element.derived;
  }

  visited.push({ original : o.definition, derived : definition });

  // attribute

  definition._doneTransformShortcut = 1;

  if( definition.elements !== undefined )
  throw _.err( 'raw definition should have no "elements" attribute only "type" attribute' );

  if( definition.shortName !== undefined && definition.name === undefined )
  definition.name = definition.shortName;

  if( definition.shortName === undefined && definition.name !== undefined )
  definition.shortName = definition.name;

  // type

  if( _.arrayIs( definition.type ) )
  {

    definition.elements = [];
    for( var t = 0 ; t < definition.type.length ; t++ )
    {
      definition.elements[ t ] = self._definitionTransformRaw
      ({
        definition : definition.type[ t ],
        combinator : definition,
        visited : visited,
      });
    }
    definition.type = null;

  }
  else if( definition.type === undefined || definition.type === null )
  {

    definition.type = null;

  }
  else
  {

    _.assert( _.strIs( definition.type ) || _.objectIs( definition.type ) );

    definition.type = self._definitionTransformRaw /*( definition.type,combinator );*/
    ({
      definition : definition.type,
      combinator : combinator,
      visited : visited,
      sup : definition,
    });

    _.assert( _.objectIs( definition.type ) );

  }

  // visited

  _.assert( visited[ visited.length-1 ].original === o.definition );
  visited.pop();

  //

  return definition;
}

//

function _definitionTransformRawFormElement( definition )
{
  var self = this;

/*
  if( definition.name === 'DropComments' )
  debugger;
*/

  if( _.arrayIs( definition ) )
  {
    definition = { type : definition };
  }
  else if( _.strIs( definition ) )
  {
    definition = self.definitions.TextLiteral( definition );
  }
  else
  {
    if( !_.objectIs( definition ) )
    throw _.err( 'something wrong with definition',definition );

    /*definition = _.mapExtend( null,definition );*/
    definition = self._definitionCloneElement( definition );

  }

  return definition;
}

//

function definitionTransformReference( definition )
{
  var self = this;

  definition = self.definitionEachRaw
  ({
    definition : definition,
    onUp : self._definitionTransformReferenceElement,
    //onDown : self._definitionTransformReferenceElement,
  });

  return definition;
}

//

function _definitionTransformReferenceElement( o )
{
  var self = this;
  var definition = o.definition;

  if( !definition.refer )
  return;

  if( definition.type || definition.elements )
  throw _.err( 'definition should have both "type" and "refer" attributes in the same time' );

  _.assert( definition._original );

  definition.type = self.definitionSelect
  ({
    definitionStack : _.entitySelect( o.visited,'*.derived' ),
    definition : definition,
    query : definition.refer,
  });

  definition.type = self.definitionTransformRaw( definition.type );

  delete definition.refer;
}

//

function definitionTransformTerminalSeparation( definition )
{
  var self = this;
/*
  if( definition.name === 'Expression' )
  debugger;
*/
  self.definitionEachRaw
  ({
    definition : definition,
    onDown : self._definitionTransformTerminalSeparationElement,
  });

  return definition;
}

//

function _definitionTransformTerminalSeparationElement( o )
{
  var self = this;
  var definition = o.definition;

  _.assert( _.objectIs( definition.type ) || definition.type === null );

  if( o.sup !== null )
  return;

  var sup = definition;
/*
  if( sup.name === 'name' )
  debugger; // xxx

  if( sup.name === 'EclipseComment' )
  debugger; // xxx

  if( sup.name === 'EclipseComments' )
  debugger; // xxx
*/
  if( !sup.type )
  return;

  var hasCombinationAttributes = Object.keys( _.mapOnly( sup, self.tokenCombinationMap ) ).length;
  while( sup.type.type )
  {
    sup = sup.type;
    if( !hasCombinationAttributes )
    hasCombinationAttributes = hasCombinationAttributes || Object.keys( _.mapOnly( sup, self.tokenCombinationMap ) ).length;
  }

  if( !sup.type.elements && hasCombinationAttributes )
  {
    //_.assert( sup.unwrap === undefined ); xxx
    _.assert( sup.refer === undefined );
    if( sup.type.combination )
    throw _.err( 'definition without elements should not have combination' );

    /* share natural attributes with terminal */
    sup.type = _.mapExtend( null,sup.type,_.mapOnly( sup, self.tokenAttributeMap ) );
    sup.type.type = null;

    sup.elements = [ sup.type ];
    sup.combination = 'alteration';
    sup.type = null;
    if( sup.unwrap === undefined )
    sup.unwrap = 1;
  }

}

//

function definitionTransformSubclass( definition )
{
  var self = this;
  _.assert( arguments.length === 1, 'expects single argument' );

  self.definitionEachRaw
  ({
    definition : definition,
    onUp : self._definitionTransformSubclassElement,
  });

}

//

function _definitionTransformSubclassElement( o )
{
  var self = this;
  var combinator = o.combinator || null;
  var definition = o.definition;

  if( o.definition.debugNormalization )
  debugger;

/*
  if( definition.name === 'product' || definition.name === 'optional_product' )
  {
    debugger;
    console.log( _.entitySelect( o.visited,'*.derived.name' ) );
    console.log( _.entitySelect( o.visited,'*.derived._.id' ) );
  }
*/

  _.assert( definition._doneTransformShortcut );

  if( o.sup )
  return;

  // reuse

  if( _.objectIs( definition ) && definition._ && definition._.doneTransformSubclass )
  {
    if( definition._.combinator !== combinator )
    {
      definition = self._definitionCloneElement( definition );
      delete definition._;
    }
    else
    {
      debugger;
      _.assert( 0,'not tested' );
      return definition;
    }
  }

  // sub type

  if( _.objectIs( definition.type ) )
  {
    var type = definition.type;
    delete definition.type;
    _.assert( type._doneTransformShortcut );

    _.mapSupplement( definition,type );
    delete definition._;
    if( definition.elements )
    definition.elements = definition.elements.slice();

    var to = _.mapExtend( null,o );
    to.definition = definition;
    definition = self._definitionTransformSubclassElement( to );
  }

  // derived

  definition._ = {};
  definition._.doneTransformSubclass = 1;
  self.DefinitionCounter += 1;
  definition._.id = self.DefinitionCounter;

  return definition;
}

// --
// adjusting
// --

function definitionAdjustTerminal( definition )
{
  var self = this;

  /*

  interact :

  - definition.read
  - definition.get
  - definition.getView

  - definition.writes
  - definition.write
  - definition.set
  - definition.setView

  - definition.bufferType
  - definition.getBuffer

  - definition.size

  influenced by :

  - definition.size

  influance on :

  - definitio._reader
  - definitio._writer

  */

  self.definitionEach
  ({
    definition : definition,
    onUp : _definitionAdjustTerminalElement,
    marker : { doneAdjustTerminal : 'doneAdjustTerminal' },
  });

}

//

function _definitionAdjustTerminalElement( o )
{
  var self = this;
  var definition = o.definition;

  if( definition.elements )
  return;

  // size

  if( definition.size === undefined && ( definition.windSize === undefined || definition.lookSize === undefined ) )
  throw _.err( 'terminal definition should have size attribute' );

  if( definition.size === undefined )
  throw _.err( 'not implemented' );

  if( _.numberIs( definition.size ) )
  definition.size = [ definition.size,definition.size ];

  if( _.numberIs( definition.windSize ) )
  definition.windSize = [ definition.windSize,definition.windSize ];

  if( _.numberIs( definition.lookSize ) )
  definition.lookSize = [ definition.lookSize,definition.lookSize ];

  if( definition.windSize === undefined )
  definition.windSize = definition.size.slice();

  if( definition.lookSize === undefined )
  definition.lookSize = definition.size.slice();

  definition._.windSize = definition.windSize.slice();
  definition._.lookSize = definition.lookSize.slice();

  var size = definition.size;
  if( _.arrayIs( size ) && size[ 0 ] === size[ 1 ] )
  size = size[ 0 ];

  // verification

  if( !_.objectIs( definition ) )
  throw _.err( 'wStream.bindAccessor','expects definition as argument',definition );

  if( !_.numberIs( size ) && !_.arrayIs( size ) )
  throw _.err( 'definition should have size' );

  if( !_.numberIs( definition.alternativity ) )
  throw _.err( 'terminal definition missing alternativity',definition.name );

  _.assertMapHasNoUndefine( definition,definition.name );

  //

  self._definitionAdjustTerminalElementRead( o );
  self._definitionAdjustTerminalElementWrite( o );

  //

  definition._doneAdjustTerminal = 1;
  Object.freeze( definition );

}

//

function _definitionAdjustTerminalElementRead( o )
{
  var self = this;
  var definition = o.definition;
  var critical = false;

  //

  if( definition.generateRead )
  {
    _.assert( !definition.readAhead );
    _.assert( !definition.readBehind );
    _.assert( definition.generateRead.length === 1 );
    definition.readAhead = definition.generateRead( 'ahead' );
    definition.readBehind = definition.generateRead( 'behind' );
    delete definition.generateRead;
  }

  if( definition.generateGet )
  {
    _.assert( !definition.getAhead );
    _.assert( !definition.getBehind );
    _.assert( definition.generateGet.length === 1 );
    definition.getAhead = definition.generateGet( 'ahead' );
    definition.getBehind = definition.generateGet( 'behind' );
    delete definition.generateGet;
  }

  //

  var size = definition.size;
  if( _.arrayIs( size ) && size[ 0 ] === size[ 1 ] )
  size = size[ 0 ];

  var reader = definition._reader = definition._reader || {};
  var hasReader = definition.read || definition.readAhead || definition.readBehind || definition.get || definition.getAhead || definition.getBehind || definition.getView;

  var bufferType = definition.bufferType;
  var getBuffer = definition.getBuffer;
  var getView = definition.getView;

  var get = {};
  get[ 'ahead' ] = definition.getAhead || definition.get;
  get[ 'behind' ] = definition.getBehind;

  var read = {};
  read[ 'ahead' ] = definition.readAhead || definition.read;
  read[ 'behind' ] = definition.readBehind;

  //

  if( definition.elements && hasReader )
  throw _.err( 'definition cant be both combination and terminal' );

  //

  function generateGet( direction,reversion )
  {

    var routine = null;
    var getDirect = get[ direction ];
    var readDirect = read[ direction ];
    var readRevert = read[ reversion ];
    var ahead = direction === 'ahead';

    if( readDirect )
    {
      routine = function getWithRead()
      {

        var position = this._pos;
        var data = readDirect.call( this );

        if( data === undefined )
        {
          _.assert( this._pos === position );
          return;
        }

        debugger;
        var result =
        {
          shift : ahead ? this._pos - position : position - this._pos,
          data : data,
        }

        this._pos = position;

        return result;
      }
    }
    else if( getView && _.numberIs( size ) && direction === 'ahead' )
    routine = function getWithGetView()
    {

      debugger;

      if( this._pos + size > this.buffer.byteLength )
      return;

      var result =
      {
        shift : size,
        data : getView.call( this._view, this._pos, this.littleEndian ),
      }

      return result;
    }
    else if( getView && _.numberIs( size ) && direction === 'behind' )
    routine = function getWithGetView()
    {

      debugger;
      throw _.err( 'not implemented' );

    }
    else if( getDirect && _.numberIs( size ) && direction === 'behind' )
    routine = function getWithGetDirect()
    {

      debugger;
      throw _.err( 'not implemented' );

    }
    else if( !definition.combination && critical && definition.getBehind !== null )
    throw _.err( 'wParser.definitionAdjustTerminal :','definition has no',direction,'"get"',self.definitionToStr( definition ) );

    return routine;
  }

  //

  /*if( !read && get && _.numberIs( size ) ) read = ( function()*/

  function generateRead( direction,reversion )
  {

    var routine = null;
    var getDirect = get[ direction ];
    var getRevert = get[ reversion ];
    var readRevert = read[ reversion ];
    var ahead = direction === 'ahead';

    if( readRevert && _.numberIs( size ) )
    routine = function readWithReadRevert()
    {

      if( ahead )
      {
        if( this._pos + size > this.size )
        {
          debugger;
          return;
        }
      }
      else
      {
        if( this._pos - size < 0 )
        {
          return;
        }
      }

      var position = this._pos;
      this._pos += ahead ? + size : - size;

      var read = readRevert.call( this );

      if( read === undefined )
      {
        this._pos = position;
        return;
      }

      this._pos += ahead ? + size : - size;

      return read;
    }
    else if( getDirect )
    {
      routine = function readWithGet()
      {

        var got = getDirect.call( this );
        if( DEBUG )
        _.assert( got === undefined || ( _.objectIs( got ) && _.numberIs( got.shift ) ), () => 'got ' + _.strTypeOf( got ) );

        if( got === undefined )
        return;

        this._pos += ahead ? +got.shift : -got.shift;

        return got.data;
      }
      routine.inline = { getDirect : getDirect };
      routine.constant = { ahead : ahead };
    }
    else if( getRevert && _.numberIs( size ) && direction === 'ahead' )
    routine = function readWithGetRevert()
    {
      debugger;
      throw _.err( 'not tested' );

      if( this.left() < size )
      return;

      this._pos += size;
      var got = getRevert.call( this );
      if( DEBUG )
      _.assert( got === undefined || ( _.objectIs( got ) && _.numberIs( got.shift ) ) );

      return got.data;

    }
    else if( getRevert && _.numberIs( size ) && direction === 'behind' )
    routine = function readWithGetRevert()
    {
      debugger;

      if( this._pos < size )
      return;

      this._pos -= size;
      var got = getRevert.call( this );
      if( DEBUG )
      _.assert( got === undefined || ( _.objectIs( got ) && _.numberIs( got.shift ) ) );

      if( got === undefined )
      return;

      return got.data;
    }
    else if( !definition.combination && critical && definition.readBehind !== null )
    throw _.err( 'wParser.definitionAdjustTerminal :','definition has no',direction,'"read"',self.definitionToStr( definition ) );

    return routine;
  }

  //

  if( !getBuffer && bufferType )
  getBuffer = function getBuffer()
  {
    var result = new bufferType( this.buffer );
    return result;
  }

  //

  function generateMethods( direction,reversion )
  {

    if( !read[ direction ] )
    read[ direction ] = generateRead( direction,reversion );

    if( !get[ direction ] )
    get[ direction ] = generateGet( direction,reversion );

  }

  //

  function generate()
  {

    var direction = 'ahead';
    var reversion = 'behind';

    generateMethods( direction,reversion );

    var direction = 'behind';
    var reversion = 'ahead';

    generateMethods( direction,reversion );

  }

  //

  critical = false;
  generate();

  critical = true;
  generate();

  // set

  if( hasReader )
  {
    if( getBuffer && !reader.getBuffer )
    reader.getBuffer = getBuffer;
    if( getView && !reader.getView )
    reader.getView = getView;
    if( get && !reader.get )
    reader.get = get;
    if( read && !reader.read )
    reader.read = read;
  }

  //

  Object.freeze( definition._reader );

}

//

function _definitionAdjustTerminalElementWrite( o )
{
  var self = this;
  var definition = o.definition;

  // size

  var size = definition.size;
  if( _.arrayIs( size ) && size[ 0 ] === size[ 1 ] )
  size = size[ 0 ];

  //

  var writer = definition._writer = definition._writer || {};
  var hasWriter = definition.write || definition.set || definition.setView;

  var set = definition.set;
  var setView = definition.setView;
  var write = definition.write;
  var writes = definition.writes;

  //

  if( definition.elements && hasWriter )
  throw _.err( 'definition cant be both combination and terminal' );

  //

  if( !set && setView && _.numberIs( size ) ) set = function setWithSetView( src )
  {

    _.assert( 0 <= this._pos && this._pos + size <= this.size,'wStream:','out of bound' );
    setView.call( this._view, this._pos, src, this.littleEndian );

  }

  //

  if( !write && set && _.numberIs( size ) )
  {
    write = function write( src )
    {

      this.grow( size );
      set.call( this,src );
      this._pos += size;

    }
  }

  //

  if( !writes && set && _.numberIs( size ) )
  {
    writes = function writes()
    {

      for( var a = 0 ; a < arguments.length ; a++ )
      {

        var argument = arguments[ a ];
        argument = _.arrayAs( argument );

        this.grow( size*argument.length );
        for( var s = 0,sl = argument.length ; s < sl ; s++ )
        {
          set.call( this,argument[ s ] );
          this._pos += size;
        }

      }

    }
  }

  //

  if( hasWriter && writer )
  {
    if( setView && !writer.setView )
    writer.setView = setView;
    if( set && !writer.set )
    writer.set = set;
    if( write && !writer.write )
    writer.write = write;
    if( writes && !writer.writes )
    writer.writes = writes;
  }

  //

  Object.freeze( definition._writer );

}

//

function definitionAdjustCombination( definition )
{
  var self = this;

  self.definitionEach
  ({
    definition : definition,
    onUp : _definitionAdjustCombinationElement,
    marker : { doneAdjustCombination : 'doneAdjustCombination' },
  });

}

//

function _definitionAdjustCombinationElement( o )
{
  var self = this;
  var definition = o.definition;

  _.assert( !definition.type );

  if( _.arrayIs( definition.elements ) )
  if( !definition.combination )
  definition.combination = 'composition';

  definition._.doneAdjustCombination = 1;
  definition._.root = o.root;
  definition._.combinator = o.combinator || null;
  definition._.combinators = [ o.combinator || null ];

  definition._.name = definition.name || o.index;
  definition._.path = o.combinator ? o.combinator._.path + '.' + definition._.name : definition._.name;

}

function definitionAdjustCycle( definition )
{
  var self = this;

  /*

  interact :

  influenced by :

  elements

  influance on :

  _.cycleBranching
  _.cyclePath
  _.cycleUnder
  _.cycleAbove

  */

  self.definitionEach
  ({
    definition : definition,
    onCycle : _definitionAdjustCycleElement,
    marker : { doneAdjustCycle : 'doneAdjustCycle' },
  });

}

//

function _definitionAdjustCycleElement( o )
{
  var self = this;
  var definition = o.definition;

  if( Config.debug )
  if( definition.debugNormalization )
  debugger;

  _.assert( definition.elements,'unexpected : cycle definition without elements' );
  _.assert( !definition._.cycleBranching,'not tested' );

  definition._.cycleBranching = 1;

  _.assert( o.visited.length >= 2 );
  _.assert( o.visited[ o.visited.length-2 ].derived );

  definition._.combinators.push( o.visited[ o.visited.length-2 ].derived );

  _.assert( definition._.combinators.length === 2,'not tested' );
  _.assert( definition._.combinators[ 0 ] !== definition._.combinators[ 1 ],'not tested' );

  // cycleAbove

  if( o.definition._.combinator )
  {
    _.assert( !o.definition._.combinator._.cycleAbove,'not tested' );
    o.definition._.combinator._.cycleAbove = [ definition ];
  }
  else
  {
    console.warn( 'cycling of root is not safe',definition._.name );
    /* throw _.err( 'cycling of root is not safe',definition ); */
  }

  // cyclePath

/*
  if( definition.name === 'optional_product' )
  debugger;
*/

  console.warn( 'cyclePath not tested' );
  /*_.assert( !definition._.cyclePath,'not tested' );*/
  definition._.cyclePath = [ definition ];
  for( var v = o.visited.length - 2 ; v >= 0 ; v-- )
  {
    var visited = o.visited[ v ].derived;
    if( visited === definition )
    break;
    _.assert( visited,'not expected : definition not found' );
    _.assert( !visited._.cyclePath,'cycle path crossing is not tested' );
    visited._.cyclePath = [ definition ];
  }

  // cycleUnder

  self.definitionEach
  ({
    definition : definition,
    onDown : function( o )
    {
      if( o.definition._.cycleUnder )
      {
        _.assert( o.definition._.cycleUnder.indexOf( definition ) === -1,'not expected' );
        o.definition._.cycleUnder.push( definition );
      }
      else
      {
        o.definition._.cycleUnder = [ definition ];
      }
    },
    marker : null,
  });

}

//

function definitionRefineUp( definition )
{
  var self = this;

  self.definitionEach
  ({
    definition : definition,
    onUp : _definitionRefineUpElement,
    marker : { doneRefineUp : 'doneRefineUp' },
  });

}

//

function _definitionRefineUpElement( o )
{
  var self = this;
  var definition = o.definition;

  self._definitionRefineUpDestinationsElement( o );

}

//

function _definitionRefineUpDestinationsElement( o )
{
  var self = this;
  var definition = o.definition;

  //

/*
  if( definition.unwrap && definition.array !== undefined )
  {
    var protoUnwrap = _.prototypeHasProperty( definition,{ unwrap : 'unwrap' } );
    var protoArray = _.prototypeHasProperty( definition,{ array : 'array' } );
    if( protoUnwrap === protoArray )
    throw _.err( 'tags "unwrap=1" and "array" are not compatible in same definition:',definition.name );
    if( _.prototypeHasPrototype( protoUnwrap,protoArray ) )
    {
      definition.unwrap = definition.unwrap;
      definition.array = undefined;
    }
    else if( _.prototypeHasPrototype( protoArray,protoUnwrap ) )
    {
      definition.unwrap = undefined;
      definition.array = definition.array;
    }
    else throw _.err( 'unexpected' );
  }
*/

  if( definition.unwrap && definition.containerConstructor !== undefined )
  throw _.err( 'tags "unwrap=1" and "containerConstructor" are not compatible' );

  // unwrap

  /*if( _.mapOwnKey( definition,{ unwrap : 'unwrap' }) )*/

  if( definition.combination )
  if( definition.unwrap !== undefined )
  definition.unwrap = !!definition.unwrap;
  else
  definition.unwrap = !definition.containerConstructor && definition.array === undefined && definition.combination === 'alteration';

  // array

  if( definition.combination )
  if( !definition.unwrap )
  {

    if( definition.array !== undefined )
    definition.array = !!definition.array;
    else if( definition.containerConstructor !== undefined )
    definition.array = !!( definition.containerConstructor === Array || _.constructorIsBuffer( definition.containerConstructor ) );
    else definition.array = true;

  }

  // containerConstructor

  if( definition.combination )
  if( !definition.unwrap )
  {

    if( definition.containerConstructor !== undefined )
    definition.containerConstructor = definition.containerConstructor;
    else
    definition.containerConstructor = definition.array ? Array : Object;

  }
/*
  if( definition.shortName === 'xxx' )
  debugger;
*/
}

//

function definitionRefineDown( definition )
{
  var self = this;

  self.definitionEach
  ({
    definition : definition,
    onDown : _definitionRefineDownElement,
    onCycle : _definitionRefineDownElement,
    marker : { doneRefineDown : 'doneRefineDown' },
  });

}

//

function _definitionRefineDownElement( o )
{
  var self = this;
  var definition = o.definition;

  self._definitionRefineDownSizeElement( o );
  self._definitionRefineDownAlternativityElement( o );

  //

  self.definitionTagsCallForElement
  ({
    definition : definition,
    methodName : { tagRefineDown : 'tagRefineDown' },
  });

  // cycle

  if( definition._.cycleBranching )
  {

    if( definition._.windSize[ 1 ] !== Infinity || definition._.lookSize[ 1 ] !== Infinity )
    {
      debugger;
      throw _.err( 'not expected' )
    }

/*
    if( definition._.windSize[ 0 ] !== 0 )
    definition._.windSize[ 0 ] = Infinity;
*/

    if( definition._.windSize[ 1 ] !== 0 )
    definition._.windSize[ 1 ] = Infinity;

/*
    if( definition._.lookSize[ 0 ] !== 0 )
    definition._.lookSize[ 0 ] = Infinity;
*/

    if( definition._.lookSize[ 1 ] !== 0 )
    definition._.lookSize[ 1 ] = Infinity;

  }

  //

  self.reportDeadLoopIfDefinitionMinimalWindSizeIsIrregular( definition );

}

//

function _definitionRefineDownSizeElement( o )
{
  var self = this;
  var definition = o.definition;

/*
  if( definition._.cycleBranching )
  debugger;
*/

  if( !definition.elements ) // terminal
  {
/*
    _.assert( _.arrayIs( definition.size ) || definition.size === undefined,'size should be array' );
    _.assert( _.arrayIs( definition.windSize ) || definition.windSize === undefined,'windSize should be array' );
    _.assert( _.arrayIs( definition.lookSize ) || definition.lookSize === undefined,'lookSize should be array' );
*/

    _.assert( _.arrayIs( definition.windSize ),'windSize should be array' );
    _.assert( _.arrayIs( definition.lookSize ),'lookSize should be array' );

    return;
  }
  else if( definition._.cycleBranching && !definition._.windSize ) // cycle
  {

    definition._.lookSize = [ 0,Infinity ];
    definition._.windSize = [ 0,Infinity ];

    return;
  }

  // combination

  var elements = definition.elements;
  var combination = definition.combination;
  var e,element;

  var lookSize = [ 0,0 ];
  var windSize = [ 0,0 ];

/*
  if( combination === 'alteration' && elements.length > 0 )
  {
    lookSize[ 0 ] = +Infinity;
    windSize[ 0 ] = +Infinity;
  }
*/

  //

  function considerSize( size,elementSize )
  {

    _.assert( _.arrayIs( elementSize ) );

    if( combination === 'composition' )
    {

      size[ 0 ] += elementSize[ 0 ];
      size[ 1 ] += elementSize[ 1 ];

    }
    else if( combination === 'alteration' )
    {

      if( e === 0 )
      {
        size[ 0 ] = elementSize[ 0 ];
        size[ 1 ] = elementSize[ 1 ];
      }
      else
      {
        size[ 0 ] = Math.min( size[ 0 ],elementSize[ 0 ] );
        size[ 1 ] = Math.max( size[ 1 ],elementSize[ 1 ] );
      }

    }

  }

  //

  function considerCompositionLookSize( windSize,lookSize,elementLookSize )
  {

    var _lookSize = windSize.slice();

    _lookSize[ 0 ] += elementLookSize[ 0 ];
    _lookSize[ 1 ] += elementLookSize[ 1 ];

    if( e === 0 )
    {
      lookSize[ 0 ] = _lookSize[ 0 ];
      lookSize[ 1 ] = _lookSize[ 1 ];
    }
    else
    {
      lookSize[ 0 ] = Math.max( lookSize[ 0 ],_lookSize[ 0 ] );
      lookSize[ 1 ] = Math.max( lookSize[ 1 ],_lookSize[ 1 ] );
    }

  }

  //

  for( e = 0 ; e < elements.length ; e++ )
  {

    element = elements[ e ];

    var elementWindSize = element._.windSize;
    var elementLookSize = element._.lookSize;

    if( element._.cycleBranching )
    {
      if( !elementWindSize )
      elementWindSize = [ 0,0 ];
      if( !elementLookSize )
      elementLookSize = [ 0,0 ];
    }

    if( combination === 'alteration' )
    considerSize( lookSize,elementLookSize );
    else
    considerCompositionLookSize( windSize,lookSize,elementLookSize );

    considerSize( windSize,elementWindSize );

  }

  // look size

  if( windSize[ 0 ] > lookSize[ 0 ] )
  throw _.err( 'unexpected' );
  if( windSize[ 1 ] > lookSize[ 1 ] )
  throw _.err( 'unexpected' );

  lookSize[ 0 ] = Math.max( windSize[ 0 ],lookSize[ 0 ] );
  lookSize[ 1 ] = Math.max( windSize[ 1 ],lookSize[ 1 ] );

  var sameSize = ( lookSize[ 0 ] === windSize[ 0 ] ) && ( lookSize[ 1 ] === windSize[ 1 ] );

  if( isNaN( lookSize[ 0 ] ) || isNaN( lookSize[ 1 ] ) )
  throw _.err( 'wParaser:','cant determine size of combination' );

  if( definition._.lookSize === undefined )
  definition._.lookSize = lookSize;

  // wind size

  if( isNaN( windSize[ 0 ] ) || isNaN( windSize[ 1 ] ) )
  throw _.err( 'wParaser:','cant determine size of combination' );

  if( definition._.windSize === undefined )
  definition._.windSize = windSize;

  //

  /* self.reportDeadLoopIfDefinitionMinimalWindSizeIsIrregular( definition ); */

}

//

function _definitionRefineDownAlternativityElement( o )
{
  var self = this;
  var definition = o.definition;

  //

  if( !definition.elements )
  {
    _.assert( _.numberIs( definition.alternativity ) );
    definition._.alternativity = definition.alternativity;
    definition._.ownAlternativity = definition.alternativity;
  }
  else if( definition._.cycleBranching )
  {
    definition._.alternativity = Infinity;
    definition._.ownAlternativity = Infinity;
  }
  else
  {
    if( definition._.cycleBranching )
    {
      _.assert( definition._.alternativity === Infinity );
    }
    else
    {
      _.assert( definition._.alternativity === undefined );
    }

    definition._.ownAlternativity = 1;

    if( definition.combination === 'composition' )
    {

      definition._.alternativity = 1;
      for( var e = 0 ; e < definition.elements.length ; e++ )
      {
        var element = definition.elements[ e ];

        if( element._.cycleBranching )
        {
          _.assert( element._.alternativity === undefined || element._.alternativity === Infinity );
          element._.alternativity = Infinity;
        }
        _.assert( _.numberIs( element._.alternativity ) );

        if( element._.alternativity === 0 )
        {
          definition._.alternativity = 0;
          break;
        }
        definition._.alternativity *= element._.alternativity;
      }

    }
    else if( definition.combination === 'alteration' )
    {

      definition._.alternativity = 0;
      for( var e = 0 ; e < definition.elements.length ; e++ )
      {
        var element = definition.elements[ e ];
        _.assert( _.numberIs( element._.alternativity ) );
        definition._.alternativity += element._.alternativity;
      }

    }

  }

  _.assert( _.numberIsFinite( definition._.alternativity ) || definition._.alternativity === Infinity );

  //

  self.reportAlternativity( definition );

}

//

function definitionFetchAlternativeless( definition )
{
  var self = this;

  self.definitionEach
  ({
    definition : definition,
    onDown : _definitionFetchAlternativelessElement,
    onCycle : _definitionFetchAlternativelessElement,
    marker : { doneFetchAlternativeless : 'doneFetchAlternativeless' },
  });

}

//

function _definitionFetchAlternativelessElement( o )
{
  var self = this;
  var definition = o.definition;

  if( !definition._.cycleBranching )
  _.assert( definition._.alternativelessList === undefined );

  definition._.alternativelessList = [];

  if( definition._.alternativity === 1 )
  {
    definition._.alternativelessList = [ { definition : definition, ahead : 0, behind : 0 } ];
    return;
  }

  /* ahead and behind should be equal or bigger in fact !!! */

/*
  if( definition._.path === 'EclipseArray' )
  debugger;
*/

  var offset = { behind : 0, ahead : definition._.windSize[ 0 ] };
  if( definition._.ownAlternativity === 1 )
  if( definition.combination === 'composition' || definition.elements.length === 1 )
  for( var e = 0 ; e < definition.elements.length ; e++ )
  {

    var element = definition.elements[ e ];
    offset.ahead -= element._.windSize[ 0 ];

    if( !definition._.cycleBranching )
    for( var i = 0 ; i < element._.alternativelessList.length ; i++ )
    {
      var elementDescriptor = element._.alternativelessList[ i ];
      definition._.alternativelessList.push
      ({
        definition : elementDescriptor.definition,
        behind : elementDescriptor.behind + offset.behind,
        ahead : elementDescriptor.ahead + offset.ahead,
      });
      _.assert( offset.behind >= 0 );
      _.assert( offset.ahead >= 0 );
    }

    offset.behind += element._.windSize[ 0 ];

  }

}

//

function definitionNormalizeTags( definition )
{
  var self = this;

  self.definitionEach
  ({
    definition : definition,
    onUp : _definitionNormalizeTagsElement,
    marker : { doneRefineTags : 'doneRefineTags' },
  });

}

//

function _definitionNormalizeTagsElement( o )
{
  var self = this;
  var definition = o.definition;

  //

  self.definitionTagsCallForElement
  ({
    definition : definition,
    methodName : { tagNormalize : 'tagNormalize' },
  });

}

// --
// verifier
// --

function definitionAdjustPreVerification( definition )
{
  var self = this;

  self.definitionEach
  ({
    definition : definition,
    onUp : _definitionAdjustPreVerificationElement,
    marker : { doneRefinePreVerification : 'doneRefinePreVerification' },
  });

}

//

function _definitionAdjustPreVerificationElement( o )
{
  var self = this;
  var definition = o.definition;

  var ks = Object.keys( _.mapBut( definition,self.tokenMap ) );
  if( ks.length )
  throw _.err( 'definition has redundant fields :\n' + ( definition.name || definition._.name ) + '\n' + ks );

  var ks = Object.keys( _.mapBut( self.tokenMandatory,definition ) );
  if( ks.length )
  throw _.err( 'definition does not have mandatory fields :\n' + ( definition.name || definition._.name ) + '\n' + ks );

  _.assert( definition._.id !== undefined,'definition should have "id" attribute' );

  var elements = definition.elements;
  if( elements !== undefined )
  {
    _.assert( _.arrayIs( elements ) );
  }
  else
  {
    _.assert( !definition.combination,'definition without elements should not have combination' );
  }

  _.assert( !definition.type );

}

//

function definitionAdjustPostVerification( definition )
{
  var self = this;

  self.definitionEach
  ({
    definition : definition,
    onUp : _definitionAdjustPostVerificationElement,
    marker : { doneRefinePostVerification : 'doneRefinePostVerification' },
  });

}

//

function _definitionAdjustPostVerificationElement( o )
{
  var self = this;
  var definition = o.definition;

  _.assertMapHasOnly( definition,self.tokenMap,'definition has redundant fields :' + definition._.name );
  _.assertMapHasAll( definition,self.tokenMandatory,'definition does not have mandatory fields :' + definition._.name );

  if( !definition.elements )
  _.assertMapHasOnly( definition,self.tokenTerminalMap,'terminal definition has combination fields :' + definition._.name );

  //

  if( definition.refer !== undefined )
  throw _.err( 'refer of',definition.name,'is not resolved' );

  if( definition._.name === null || definition._.name === undefined )
  throw _.err( 'definition should have name',definition );

  if( definition._.path === null || definition._.path === undefined )
  throw _.err( 'definition should have path',definition );

  if( definition.times !== undefined )
  if( !_.arrayIs( definition.times ) )
  throw _.err( 'definition.times should be array' );

  //

  if( !definition.combination && definition.elements )
  throw _.err( 'definition haveing elements should have combination attribute' );

  _.assert( definition._.lookSize !== undefined,'definition needs "lookSize"',definition._.name );
  _.assert( definition._.windSize !== undefined,'definition needs "windSize"',definition._.name );
  _.assert( !definition.type );

  if( !_.strIs( definition._.name ) && !_.numberIs( definition._.name ) )
  throw _.err( 'definition should has name' );
  if( _.strIs( definition._.name ) && definition._.name.indexOf( '.' ) !== -1 )
  throw _.err( 'definition name should not has forbidden symbols( . ): ' + definition._.name );

  //

  if( definition.restrictedAlteration )
  if( definition.combination !== 'alteration' )
  throw _.err( '"restrictedAlteration" could be only with "alteration"' );

  //

  if( !definition.combination )
  {

    if( definition.unwrap )
    throw _.err( 'terminal definition should not be unwrapped' );

    if( definition.array )
    throw _.err( 'terminal definition should not be array' );

    if( definition.containerConstructor )
    throw _.err( 'terminal definition should not has containerConstructor' );

  }
  else
  {

  }

}

// --
// iterator
// --

function definitionEachRaw( options )
{
  var self = this;

  _.assert( _.objectIs( options.definition ),'definition expected' );
  _.assertMapHasOnly( options,definitionEach.defaults );
  _.mapSupplement( options,definitionEach.defaults );

  options.marker = null;
  options.raw = 1;

  self._definitionEachPrepare( options );

  return self._definitionEachElement( options );
}

definitionEachRaw.defaults =
{
  definition : null,
  combinator : null,
  onUp : null,
  onDown : null,
  onCycle : null,
}

//

function definitionEach( options )
{
  var self = this;

  _.assert( _.objectIs( options.definition ),'definition expected' );
  _.assertMapHasOnly( options,definitionEach.defaults );
  _.mapSupplement( options,definitionEach.defaults );

  if( options.marker !== null )
  options.marker = _.nameUnfielded( options.marker ).coded;

  options.raw = 0;
  options.index = 0;

  self._definitionEachPrepare( options );

  return self._definitionEachElement( options );
}

definitionEach.defaults =
{
  definition : null,
  combinator : null,
  onUp : null,
  onDown : null,
  onCycle : null,
  marker : null,
}

//

function _definitionEachPrepare( options )
{

  options.index = 0;
  options.sup = null;
  options.visited = [];
  options.root = options.definition;

  options.isVisited = function( definition )
  {
    _.assert( definition._doneTransformShortcut );
    var d = _.arrayLeft( this.visited,{ derived : definition },function( a,b )
    {
      return a.derived === b.derived;
    });
    return d.index !== this.visited.length-1;
  }

}

//

function _definitionEachElement( options )
{
  var self = this;
  var definitionOriginal = options.definition;
  var visited = options.visited;

  // cycle

  function updateVisited()
  {
    _.assert( visited[ visited.length-1 ].original === definitionOriginal );
    visited[ visited.length-1 ].derived = options.definition;
  }

  visited.push({ original : options.definition, derived : options.definition });

  var d = _.arrayLeft( visited,options.definition,function( a,b )
  {
    return a.original === b || a.derived === b;
  });

  if( d.index !== visited.length-1 )
  {
    if( options.onCycle )
    {
      var r = options.onCycle.call( self,options );
      if( r !== undefined )
      {
        _.assert( _.objectIs( r ) );
        options.definition = r;
        updateVisited();
      }
    }
    visited.pop();
    return options.definition;
  }

  // marker

  if( options.marker !== null )
  if( options.definition._[ options.marker ] )
  {
    visited.pop();
    return options.definition;
  }

  // up

  if( options.onUp )
  {
    var r = options.onUp.call( self,options );
    if( r !== undefined )
    {
      _.assert( _.objectIs( r ) );
      options.definition = r;
      updateVisited();
    }
  }

  // mark

  if( options.marker !== null )
  options.definition._[ options.marker ] = 1;

  // super type

  if( options.raw )
  {

    _.assert( _.objectIs( options.definition.type ) || options.definition.type === null );
    if( _.objectIs( options.definition.type ) )
    {
      var o = _.mapExtend( null,options );
      o.definition = options.definition.type;
      o.sup = options.definition;
      options.definition.type = self._definitionEachElement( o );
      _.assert( _.objectIs( options.definition.type ) );
    }

  }

  // elements

  if( _.arrayIs( options.definition.elements ) )
  for( var e = 0 ; e < options.definition.elements.length ; e++ )
  {

    var o = _.mapExtend( null,options );
    o.definition = options.definition.elements[ e ];
    o.combinator = options.definition;
    o.index = e;
    o.sup = null;
    options.definition.elements[ e ] = self._definitionEachElement( o );
    _.assert( _.objectIs( options.definition.elements[ e ] ) );

  }

  // down

  if( options.onDown )
  {
    var r = options.onDown.call( self,options );
    _.assert( r === undefined || options.raw );
    if( r !== undefined )
    {
      _.assert( _.objectIs( r ) );
      options.definition = r;
      updateVisited();
    }
  }

  // cycle

  _.assert( visited[ visited.length-1 ].derived === options.definition );
  visited.pop();

  //

  return options.definition;
}

// --
// etc
// --

function definitionSelect( o )
{

  _.assert( _.objectIs( o ) );
  _.assert( _.strIs( o.query ) );
  _.assert( _.objectIs( o.definition ) );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assertMapHasOnly( definitionSelect.defaults,o );

  var self = this;
  var query = o.query.split( '.' );
  var parent = o.definition;
  var current = self.definitions;
  var stack = o.definitionStack ? o.definitionStack.slice() : null;

  if( stack )
  {
    _.assert( stack[ stack.length-1 ] === parent );
  }

  if( !query[ 0 ] )
  throw _.err( 'Not tested' );

  for( var q = 0 ; q < query.length ; q++ )
  {

    var select = _.strStrip( query[ q ] );

    if( select === '^' )
    {
      current = parent;
      if( stack )
      {
        stack.splice( stack.length-1 )
        parent = stack[ stack.length-1 ];
      }
      else
      {
        parent = parent._.combinator;
      }
      _.assert( current,'cant get parent' );
    }
    else if( current === self.definitions )
    {
      parent = current;
      current = current[ select ];
      if( !current )
      throw _.err( 'cant select',select,'from','global scope' );
    }
    else
    {
      for( var c = 0 ; c < current.elements.length ; c++ )
      if( current.elements[ c ].name === select )
      {
        debugger;
        parent = current;
        current = current.elements[ c ];
        stack.push( current );
        break;
      }
      if( c === current.elements.length )
      throw _.err( 'cant select',select,'from',current._.name );
    }

  }

  return current;
}

definitionSelect.defaults =
{
  definitionStack : null,
  definition : null,
  query : null,
}

//

function _definitionCloneElement( definition )
{
  var self = this;
  var original = definition;

  definition = _.mapExtend( null,definition );
  if( definition.elements )
  definition.elements = definition.elements.slice();
  definition._original = original;
  delete definition._;

  return definition;
}

//

function definitionCombinatorDescriptorGet( definition,combinator )
{
  for( var d = 0 ; d < definition._.combinators ; d++ )
  if( definition._.combinators[ d ].definition === definition )
  {
    return definition._.combinators[ d ];
  }
}

// --
// var
// --

var tokenMandatory =
{

  _ : '_',
  //id : 'id',
  //name : 'name',

}

var tokenDerivativeMap =
{

  /* id : 'id', */

  _ : '_',
  _original : '_original',
  _doneTransformShortcut : '_doneTransformShortcut',
  _doneAdjustTerminal : '_doneAdjustTerminal',

}

var tokenAttributeMap =
{

  name : 'name',
  shortName : 'shortName',

  type : 'type',
  debugNormalization: 'debugNormalization',

  refer : 'refer',

}

var tokenCombinationAttributeMap =
{

  elements: 'elements',

  combination : 'combination',
  restrictedAlteration : 'restrictedAlteration',

  containerConstructor : 'containerConstructor',
  unwrap : 'unwrap',
  array : 'array',

}

var tokenTerminalAttributeMap =
{

  alternativity : 'alternativity',

  size : 'size',
  lookSize: 'lookSize',
  windSize: 'windSize',

  bufferType : 'bufferType',

  _reader : '_reader',
  _writer : '_writer',

}

var tokenTerminalMethodMap =
{

  read : 'read',
  readAhead : 'readAhead',
  readBehind : 'readBehind',
  generateRead : 'generateRead',

  get : 'get',
  getAhead : 'getAhead',
  getBehind : 'getBehind',
  generateGet : 'generateGet',

  getView : 'getView',
  getBuffer : 'getBuffer',

  setView : 'setView',
  set : 'set',
  write : 'write',
  writes : 'writes',

  generate : 'generate',

}

// --
// declare
// --

var Proto =
{

  // raw transformation

  definitionMakePre: definitionMakePre,
  definitionMakeMid: definitionMakeMid,

  definitionTransformRaw: definitionTransformRaw,
  _definitionTransformRaw: _definitionTransformRaw,
  _definitionTransformRawFormElement: _definitionTransformRawFormElement,

  definitionTransformReference: definitionTransformReference,
  _definitionTransformReferenceElement: _definitionTransformReferenceElement,

  definitionTransformTerminalSeparation: definitionTransformTerminalSeparation,
  _definitionTransformTerminalSeparationElement: _definitionTransformTerminalSeparationElement,

  definitionTransformSubclass: definitionTransformSubclass,
  _definitionTransformSubclassElement: _definitionTransformSubclassElement,


  // adjusting

  definitionAdjustTerminal: definitionAdjustTerminal,
  _definitionAdjustTerminalElement: _definitionAdjustTerminalElement,
  _definitionAdjustTerminalElementRead: _definitionAdjustTerminalElementRead,
  _definitionAdjustTerminalElementWrite: _definitionAdjustTerminalElementWrite,

  definitionAdjustCombination: definitionAdjustCombination,
  _definitionAdjustCombinationElement: _definitionAdjustCombinationElement,

  definitionAdjustCycle: definitionAdjustCycle,
  _definitionAdjustCycleElement: _definitionAdjustCycleElement,

  definitionRefineUp: definitionRefineUp,
  _definitionRefineUpElement: _definitionRefineUpElement,
  _definitionRefineUpDestinationsElement: _definitionRefineUpDestinationsElement,

  definitionRefineDown: definitionRefineDown,
  _definitionRefineDownElement: _definitionRefineDownElement,
  _definitionRefineDownSizeElement: _definitionRefineDownSizeElement,
  _definitionRefineDownAlternativityElement: _definitionRefineDownAlternativityElement,

  definitionFetchAlternativeless: definitionFetchAlternativeless,
  _definitionFetchAlternativelessElement: _definitionFetchAlternativelessElement,

  definitionNormalizeTags: definitionNormalizeTags,
  _definitionNormalizeTagsElement: _definitionNormalizeTagsElement,


  // verifier

  definitionAdjustPreVerification: definitionAdjustPreVerification,
  _definitionAdjustPreVerificationElement: _definitionAdjustPreVerificationElement,

  definitionAdjustPostVerification: definitionAdjustPostVerification,
  _definitionAdjustPostVerificationElement: _definitionAdjustPostVerificationElement,


  // iterator

  definitionEachRaw: definitionEachRaw,
  definitionEach: definitionEach,
  _definitionEachPrepare: _definitionEachPrepare,
  _definitionEachElement: _definitionEachElement,


  // etc

  definitionSelect: definitionSelect,
  _definitionCloneElement: _definitionCloneElement,
  definitionCombinatorDescriptorGet: definitionCombinatorDescriptorGet,


  // var

  DefinitionCounter: 0,

  tokenMandatory: tokenMandatory,
  tokenDerivativeMap: tokenDerivativeMap,
  tokenAttributeMap: tokenAttributeMap,

  tokenCombinationAttributeMap: tokenCombinationAttributeMap,
  tokenTerminalAttributeMap: tokenTerminalAttributeMap,
  tokenTerminalMethodMap: tokenTerminalMethodMap,

  tokenTerminalMap: _.mapExtend
  (
    {},
    tokenMandatory,
    tokenDerivativeMap,
    tokenAttributeMap,
    tokenTerminalAttributeMap,
    tokenTerminalMethodMap
  ),

}

//

_.mapExtend( Self.prototype,Proto );
_.mapExtend( Self,Proto );

return Self;

})();
