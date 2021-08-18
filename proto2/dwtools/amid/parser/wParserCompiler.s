(function()
{

'use strict';

var _ = _global_.wTools;
var Parent = wStream;
var Self = wParser;
var definitions = wParser.prototype.definitions;

// --
// compile
// --

function tagsPrepare( tagsMap )
{

  _.assert( !wParser._tagsCompiled );
  wParser._tagsCompiled = 1;

  var tagsMap = wParser.tagsMap = wParser.prototype.tagsMap = _.mapExtend( wParser.tagsMap || {},tagsMap );
/*
  var tagsCompileList = wParser.tagsCompileList = wParser.prototype.tagsCompileList = [];
  var tagsNormalizeList = wParser.tagsNormalizeList = wParser.prototype.tagsNormalizeList = [];
*/
  var tagsList = wParser.tagsList = wParser.prototype.tagsList = [];
  function comparator( a,b ){ return a.order - b.order; };

  //

  if( tagsMap.Terminal.tagTokens )
  throw _.err( 'Dont expet terminal having special tokens' )

  // token map

  var tokenTagsMap = wParser.tokenTagsMap = wParser.prototype.tokenTagsMap = {};
  for( var t in tagsMap )
  {

    var tag = tagsMap[ t ];

    if( tag.tagTokens === undefined )
    continue;

    var tagTokens = _.arrayAs( tag.tagTokens );

    for( var o = 0 ; o < tagTokens.length ; o++ )
    _.mapExtend( tokenTagsMap, _.nameFielded( tagTokens[ o ] ) );

  }

  var tokenMap = wParser.tokenMap = wParser.prototype.tokenMap =
  _.mapExtend
  (
    {},
    wParser.tokenMandatory,
    wParser.tokenDerivativeMap,
    wParser.tokenAttributeMap,
    wParser.tokenCombinationAttributeMap || {},
    wParser.tokenTerminalAttributeMap || {},
    wParser.tokenTerminalMethodMap,
    tokenTagsMap
  );

  wParser.tokenCombinationMap = wParser.prototype.tokenCombinationMap =
  _.mapExtend
  (
    {},
    wParser.tokenCombinationAttributeMap || {},
    tokenTagsMap
  );

  // compile/normalize list

  for( var t in tagsMap )
  {
    var tag = tagsMap[ t ];

    if( !_.numberIs( tag.order ) )
    throw _.err( 'wParser:','tag does not have order:\n',_.toStr( tag ) );

    tag.name = t;

    var added = _.sorted.addOnce( tagsList,tag,comparator );

    if( !added )
    throw _.err( 'wParser:','some tag has same order as:',_.toStr( tag ),_.toStr( _.sorted.lookUp( tagsList,tag,comparator ).value ) );

/*
    // compile list

    if( tag.tagCompile )
    {

      var added = _.sorted.addOnce( tagsCompileList,tag,comparator );

      if( !added )
      throw _.err( 'wParser:','some tag has same order as:',_.toStr( tag ),_.toStr( _.sorted.lookUp( tagsCompileList,tag,comparator ).value ) );

    }

    // normalize list

    if( tag.tagNormalize )
    {

      var added = _.sorted.addOnce( tagsNormalizeList,tag,comparator );

      if( !added )
      throw _.err( 'wParser:','some tag has same order as:',_.toStr( tag ),_.toStr( _.sorted.lookUp( tagsCompileList,tag,comparator ).value ) );

    }
*/

  }

  //

  for( var t = 0 ; t < tagsList.length ; t++ )
  tagsList[ t ].index = t;

}

//

function compileDefinition( definition )
{
  var self = this;

  if( arguments.length !== 1 )
  throw _.err( 'compileDefinition:','accept only 1 argument' );

  return self.compileDefinitionRoot( definition );
}

//

function compileDefinitionRoot( definition )
{

  var self = this;

  if( arguments.length !== 1 )
  throw _.err( 'compileDefinition:','accept only 1 argument' );

  // store

  var generateStore = function execStoreRootGenerate( definitionElement,direction )
  {

    if( direction === 'ahead' )
    return function execStoreRoot( destination,value )
    {
      destination.container.push( value );
    }
    else if( direction === 'behind' )
    return function execStoreRoot( destination,value )
    {
      destination.container.unshift( value );
    }
    else throw _.err( 'unexpected' );

  }
  self.definitionRegisterStore( definition,generateStore );

  // compilation

  self.compileDefinitionPreceding( definition );

  // read

  function generateReadRoot( direction )
  {
    var execRead = definition._.execRead[ direction ];

    return function execReadRoot( options )
    {

      _.assert( arguments.length === 0 || arguments.length === 1 );

      var destination = {};
      destination.container = [];
      destination.key = null;
      destination.parentDestination = null;
      destination.rootDestination = destination;

      this.options = options;

      var read = execRead.call( this,destination );

      if( destination.container.length > 1 )
      throw _.err( 'wPraser','some results of parsing was lost, probably because of unwrap',self.definitionToStr( definition ) );

      return destination.container[ 0 ];
    }

  }

  definition._.execReadRoot = {};
  definition._.execReadRoot[ 'ahead' ] = generateReadRoot( 'ahead' );
  definition._.execReadRoot[ 'behind' ] = generateReadRoot( 'behind' );

  return definition;
}

//

function compileDefinitionPreceding( definition )
{
  var self = this;

  if( arguments.length !== 1 )
  throw _.err( 'compileDefinitionPreceding:','accept only 2 argument' );

  // parent store

  var combinator = definition._.combinator || definition.combinator;

  if( !definition._.generateStore )
  definition._.generateStore = combinator._.generateStore;

/*
  if( !definition._.generateStore )
  throw _.err( 'wParser:','lack of generateStore\n',_.toStr( definition ) );
*/

  //

  self.compileDefinitionValidate( definition );

  if( definition._.compiled )
  return;

  self.compileDefinitionTags( definition );

  definition._.compiled = true;

}

//

function compileDefinitionValidate( definition )
{
  var self = this;

  _.assert( _.objectIs( definition ),'compileDefinitionValidate:','definition is not normalized',definition );
  _.assert( !definition.type,'compileDefinitionValidate:','definition is not normalized',definition );

  //

  var readers = 0;
  if( definition._reader )
  if( definition._reader.read ) readers += 1;
  if( definition.elements ) readers += 1;

  if( readers > 1 )
  throw _.err( 'compileDefinitionValidate:','supplied both "read" and "elements", should be only one' );

  //

  if( definition.combination )
  if( definition.unwrap )
  {
    /*if( definition.array !== undefined || definition.containerConstructor !== undefined )*/
    if( definition.containerConstructor !== undefined )
    throw _.err( 'wParser.compileDefinitionValidate:','"unwrap" definition cant have "array" or "container" field',definition );
    if( definition.newContainerActual )
    throw _.err( 'wParser.compileDefinitionValidate:','"newContainerActual" is deprecated',definition );
  }
  else
  {
    if( !definition.containerConstructor )
    throw _.err( 'wParser.compileDefinitionValidate:','definition should have containerConstructor if not included',definition );
  }

  //

  if( definition.elements && !definition.combination )
  throw _.err( 'wParser.compileDefinitionValidate:','lack of combination type',definition );

  if( !definition.elements && !definition._reader.read )
  throw _.err( 'compileDefinitionValidate: must "type" or "read" must be defined, but not both',definition._.name );

  if( definition.elements && definition._reader && definition._reader.read )
  throw _.err( 'compileDefinitionValidate: must "type" or "read" must be defined, but not both',definition._.name );

}

//

function compileDefinitionTags( definition )
{
  var self = this;

  if( !definition._.cycleBranching )
  _.assert( !definition._.execRead );

  if( definition._.execRead )
  {
    _.assert( definition._.cycleBranching );
    return;
  }

  if( definition._.doneTagsBase )
  {
    debugger;
    //return;
  }

  self.definitionTagsCallForElement
  ({
    definition : definition,
    methodName : { tagCompile : 'tagCompile' },
    onEnd : function(){ definition._.doneTagsBase = 1; }
  });

/*
  var t = 0;
  function compileNextTag()
  {

    var tag = self.tagsCompileList[ t ];
    t += 1;

    if( t <= self.tagsCompileList.length )
    {
      tag.tagCompile.call( self,tag,definition,compileNextTag );
    }
    else
    {
      //_.assert( !definition._.doneTagsBase );
      definition._.doneTagsBase = 1;
    }

    if( t <= self.tagsCompileList.length )
    compileNextTag();

  }

  compileNextTag();
*/

  if( definition._.compileAfter )
  {

    _.assert( definition._.compileAfter.length === 1,'not tested' );

    for( var c = 0 ; c < definition._.compileAfter.length ; c++ )
    definition._.compileAfter[ c ].call( self );

    delete definition._.compileAfter;

  }

}

//

function definitionRegisterStore( definition,generateStore )
{
  var self = this;

  _.assert( _.routineIs( generateStore ) );
  _.assert( definition._.generateStore !== generateStore );
  _.assert( !definition._.generateStore || definition._.generateStore.original !== generateStore );
  _.assert( _.strIs( generateStore.name ) &&  _.strIs( generateStore.name ), 'generateStore function should have name' );

  function _generateStore( definitionElement )
  {
    _.assert( arguments.length === 1, 'expects single argument' );
    _.assert( generateStore.length === 2 );
    var result = {};
    result[ 'ahead' ] = generateStore.call( this,definitionElement,'ahead' );
    result[ 'behind' ] = generateStore.call( this,definitionElement,'behind' );
    Object.freeze( result );
    _.assert( _.objectIs( result ) );
    _.assert( _.routineIs( result[ 'ahead' ] ) );
    _.assert( _.routineIs( result[ 'behind' ] ) );
    return result;
  }

  _generateStore.original = generateStore;
  _generateStore.forDirection = generateStore;

  definition._.generateStoreList = definition._.generateStoreList || [];
  definition._.generateStoreList.unshift( _generateStore );
  definition._.generateStore = _generateStore;

}

//

function definitionRegisterRead( definition,generateRead )
{
  var self = this;

  _.assert( _.routineIs( generateRead ) );

  var execRead = {};
  execRead[ 'ahead' ] = generateRead( 'ahead' );
  execRead[ 'behind' ] = generateRead( 'behind' );
  Object.freeze( execRead );

  _.assert( _.routineHasName( execRead[ 'ahead' ] ) );
  _.assert( _.routineHasName( execRead[ 'behind' ] ) );

  definition._.execReadList = definition._.execReadList || [];
  definition._.execReadList.unshift( execRead );
  definition._.execRead = execRead;

}

//

function definitionTagsCallForElement( o )
{
  var self = this;
  var definition = o.definition;
  var methodName = _.nameUnfielded( o.methodName ).coded;

  _.assertMapHasOnly( o,definitionTagsCallForElement.defaults );

  //

  var called = 0;
  var t = 0;
  function callNext()
  {

    var tag = self.tagsList[ t ];
    t += 1;

    if( t <= self.tagsList.length )
    if( tag[ methodName ] )
    {
      tag[ methodName ].call( self,tag,definition,callNext );
      called += 1;
    }

    if( t <= self.tagsList.length )
    callNext();
    else if( o.onEnd )
    o.onEnd();

  }

  //

  callNext();
  _.assert( called > 0,methodName,'was not called' );

}

definitionTagsCallForElement.defaults =
{
  definition : null,
  methodName : null,
  onEnd : null,
}

// --
// declare
// --

var Proto =
{

  tagsPrepare: tagsPrepare,

  compileDefinition: compileDefinition,

  compileDefinitionRoot: compileDefinitionRoot,
  compileDefinitionPreceding: compileDefinitionPreceding,
  compileDefinitionValidate: compileDefinitionValidate,
  compileDefinitionTags: compileDefinitionTags,

  definitionRegisterRead: definitionRegisterRead,
  definitionRegisterStore: definitionRegisterStore,

  definitionTagsCallForElement: definitionTagsCallForElement,

}

//

_.mapExtend( Self.prototype,Proto );
_.mapExtend( Self,Proto );

return Self;

})();
