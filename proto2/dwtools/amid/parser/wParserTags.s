(function()
{

'use strict'; 

var _ = _global_.wTools;
var Parent = wStream;
var Self = wParser;
var definitions = wParser.prototype.definitions;

/*

  useless consolidations :

  - but + forward
  - containerConstructor + but

  optimize :

  - unwrap + mediator

*/

// --
// common
// --

var MODE_RAW = 0;

var _emptyDestination =
{
  container : null,
  key : null,
  parentDestination : null,
}

Object.freeze( _emptyDestination );

// --
// generator
// --

function generateMediator( definition,key )
{
  var self = this;
  var result = {};
  var dkey = key + '-' + definition._.id;
  var dkey2 = key + '-' + definition._.id + '-2';

  _.assert( arguments.length === 2, 'expects exactly two arguments' );

  if( definition._.id == 65 )
  debugger;

  /**/

  var generateStore = definition._.generateStore;
  result.generateStore = function generateStoreMediator( definitionElement,direction )
  {
    var execStore = generateStore.forDirection( definitionElement,direction );

    if( definition._.id == 65 || definitionElement._.id === 67 )
    debugger;

    return function storeMediator( destination,value )
    {

      if( definition._.id == 65 || definitionElement._.id === 67 )
      debugger;

      destination[ dkey ].push({ execStore : execStore, value : value });
    }

  }

  self.definitionRegisterStore( definition,result.generateStore );

  /**/

  result.readBegin = function readMediatorBegin( destination )
  {

    // if( definition._.id == 65 )
    // debugger;

    _.assert( !destination[ dkey ] );
    if( destination[ dkey2 ] )
    {
      var storingContainer = destination[ dkey ] = destination[ dkey2 ];
      _.assert( storingContainer.length === 0 );
    }
    else
    {
       destination[ dkey2 ] = destination[ dkey ] = [];
    }

  }

  result.readBegin.constant = { dkey : dkey, dkey2 : dkey2 };

  /**/

  result.readEnd = function readMediatorEnd( destination )
  {

    // if( definition._.id == 65 )
    // debugger;

    _.assert( !!destination[ dkey ] );
    destination[ dkey ] = null;

  }

  result.readEnd.constant = { dkey : dkey };

  /**/

  result.readCancel = function readMediatorCancel( destination )
  {

    // if( definition._.id == 65 )
    // debugger;

    var storingContainer = destination[ dkey ];
    if( storingContainer.length )
    {
      storingContainer.splice( 0,storingContainer.length );
    }

  }

  result.readCancel.constant = { dkey : dkey };

  /**/

  result.readAccept = function readMediatorAccept( destination )
  {

    // if( definition._.id == 65 )
    // debugger;

    var storingContainer = destination[ dkey ];
    if( !storingContainer.length )
    return;
    for( var d = 0 ; d < storingContainer.length ; d++ )
    {
      var record = storingContainer[ d ];
      record.execStore.call( this,destination,record.value );
    }
    storingContainer.splice( 0,storingContainer.length );
  }

  result.readAccept.constant = { dkey : dkey };

  /**/

  result.readGetStore = function readMediatorGetStore( destination )
  {
    return destination[ dkey ];
  }

  result.readAccept.constant = { dkey : dkey };

  return result;
}

// --
//  tag drop
// --

var TagDrop =
{
  tagTokens : { drop : 'drop' },
  order : 100,
}

//

TagDrop.tagCompile = function compileTagDrop( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.drop )
  return;

  // store

  var generateStore = function generateStoreDrop( definitionElement,direction )
  {

    return function storeDrop( destination,value )
    {
    }

  }

  self.definitionRegisterStore( definition,generateStore );

  //

  compileNextTag();

  // read

  function generateReadDrop( direction )
  {
    var execRead = definition._.execRead[ direction ];

    return function execReadDrop( destination )
    {

      var dropWas = this.drop;
      this.drop = 1;
      var read = execRead.call( this,destination );
      this.drop = dropWas;

      return read;
    }

  }

  self.definitionRegisterRead( definition,generateReadDrop );

  return definition;
}

// --
//  tag drop
// --

var TagDebug =
{
  tagTokens : { debug : 'debug' },
  order : 50,
}

//

TagDebug.tagNormalize = function normalizeTagDebug( tag,definition,normalizeNextDefinition )
{
  var self = this;

  if( !definition.debug )
  return;

}

//

TagDebug.tagCompile = function compileTagDebug( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.debug )
  return;

  //

  compileNextTag();

  // read

  function generateReadDebug( direction )
  {
    var execRead = definition._.execRead[ direction ];

    return function execReadDebug( destination )
    {

      console.log( 'path :',definition._.path );
      console.log( 'position :',this.position );
      debugger;

      var read = execRead.call( this,destination );
      /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/

      if( read )
      {
        console.log( 'path :',definition._.path );
        console.log( 'position :',this.position );
        debugger;
      }

      return read;
    }

  }

  self.definitionRegisterRead( definition,generateReadDebug );

  return definition;
}

// --
// tag not
// --
/*
var TagNot =
{
  tagTokens : { not : 'not' },
  order : 101,
}

//

TagNot.tagCompile = function compileTagNot( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.not )
  return;

  if( definition.backward )
  throw _.err( 'compileTagNot:','Consolidation of "backward" and "not" tags is not implemented' );

  if( definition.but )
  throw _.err( 'compileTagNot:','Consolidation of "but" and "not" tags probably is not possible' );

  if( definition.drop )
  throw _.err( 'compileTagNot:','Consolidation of "drop" and "not" tags is useless' );

  var name = definition._.name || definition.name;

  //store

  definition._.generateStore = function execStoreNotGenerate( definitionElement )
  {

    return function execStoreNot( destination,value )
    {
      return _emptyDestination;
    }

  }

  self.definitionRegisterStore( definition,definition._.generateStore );

  //

  compileNextTag();

  // read

  definition._.execRead = ( function()
  {

    var execRead = definition._.execRead;

    return function execReadNot( destination )
    {

      var begin = this.position;
      var read = execRead.call( this,destination );
      this.position = begin

      if( read === undefined )
      {
        return true;
      }
      else
      {
        return undefined;
      }

    }

  }).call( self );

  self.definitionRegisterRead( definition,definition._.execRead );

  return definition;
}
*/

// --
// tag new container
// --

var TagUseThisName =
{
  tagTokens :
  {
    /*unwrap : 'unwrap',*/
    useThisName : 'useThisName',
  },
  order : 290,
}

//

TagUseThisName.tagCompile = function compileTagUseThisName( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.useThisName )
  return;

  var execStore = definition._.generateStore( definition );
  function generateStoreUseThisName( definitionElement,direction )
  {

    var store = execStore[ direction ];

    return function execStoreUseThisNameAhead( destination,value )
    {
      return store( destination,value );
    }

  }

  self.definitionRegisterStore( definition,generateStoreUseThisName );

}

// --
// tag new container
// --

var TagNewContainer =
{
  tagTokens :
  {
    aggregative : 'aggregative',
    rewritable : 'rewritable',
  },
  order : 300,
}

//

TagNewContainer.tagCompileStoreRaw = function compileTagNewContainerStoreRaw( tag,definition,compileNextTag )
{
  var self = this;

  var name = definition._.name || definition.name;
  var containerConstructor = definition.containerConstructor;
  var rewritable = definition.rewritable;
  var aggregative = definition.aggregative;
  var isArray = definition.array;
  var generateStore = null;

  // store

  if( _.constructorIsBuffer( containerConstructor ) )
  {

    generateStore = function generateStoreToBuffer( definitionElement,direction )
    {

      var dname = self.definitionNameWithBufferGet( containerConstructor );

      return function execStoreToBuffer( destination,value )
      {

        debugger;

        if( direction !== 'ahead' )
        throw _.err( 'not tested' );
        _.assert( _.numberIs( value ) );

        destination.stream.write[ dname ]( value );

      }

    }

  }
  else if( containerConstructor === Array )
  {

    generateStore = function generateStoreToArray( definitionElement,direction )
    {

      return function storeToArray( destination,value )
      {

        debugger;

        if( direction !== 'ahead' )
        throw _.err( 'not tested' );
        _.assert( value !== undefined,'not tested' );

        destination.stream.storeToArray( elementName,value );

      }

    }

  }
  else if( containerConstructor === Object )
  {

    if( aggregative )
    generateStore = function execStoreToObjectGenerateAggregative( definitionElement,direction )
    {
      var elementName = definitionElement._.name || definitionElement.name;

      return function storeToObjectAggregative( destination,value )
      {

        debugger;

        if( direction !== 'ahead' )
        throw _.err( 'not tested' );
        _.assert( value !== undefined,'not tested' );

        destination.stream.storeToObjectAggregative( elementName,value );

      }

    }
    else if( rewritable )
    generateStore = function execStoreToObjectGenerateRewritable( definitionElement,direction )
    {
      var elementName = definitionElement._.name || definitionElement.name;

      return function execStoreToObjectReweritable( destination,value )
      {
        debugger;

        if( direction !== 'ahead' )
        throw _.err( 'not tested' );
        _.assert( value !== undefined,'not tested' );

        destination.stream.storeToObjectRewritable( elementName,value );
      }

    }
    else
    generateStore = function execStoreToObjectGenerate( definitionElement,direction )
    {
      var elementName = definitionElement._.name || definitionElement.name;

      return function execStoreToObject( destination,value )
      {
        debugger;

        if( direction !== 'ahead' )
        throw _.err( 'not tested' );
        _.assert( value !== undefined,'not tested' );

        destination.stream.storeToObject( elementName,value );
      }

    }

  }
  else if( containerConstructor === String ) throw _.err( 'not implemented' );
  else throw _.err( 'wParser:','unknown container constructor',containerConstructor );

  self.definitionRegisterStore( definition,generateStore );

  //

  return definition;
}

//

TagNewContainer.tagCompileStoreNormal = function compileTagNewContainerStoreNormal( tag,definition,compileNextTag )
{
  var self = this;

  var name = definition._.name || definition.name;
  var containerConstructor = definition.containerConstructor;
  var rewritable = definition.rewritable;
  var aggregative = definition.aggregative;
  var isArray = definition.array;
  var generateStore = null;

  // store

  if( _.constructorIsBuffer( containerConstructor ) )
  {

    generateStore = function generateStoreToBuffer( definitionElement,direction )
    {

      return function execStoreToBuffer( destination,value )
      {

        if( direction !== 'ahead' )
        throw _.err( 'not tested' );

        _.assert( _.numberIs( destination.key ),'wParser:','"key" for array destination must be number' );

        if( destination.container.length <= destination.key )
        {
          destination.container = _.bufferRelen( destination.container,( destination.container.length+1 )*2 );
        }

        /**/

        _.assert( destination.container && destination.key !== null );

        destination.container[ destination.key ] = value;

        _.assert( _.numberIs( value ) );

        /**/

        if( value !== undefined && value !== null )
        destination.key += 1;

      }

    }

  }
  else if( containerConstructor === Array )
  {

    generateStore = function generateStoreToArray( definitionElement,direction )
    {

      if( direction === 'ahead' )
      return function storeToArrayAhead( destination,value )
      {

        _.assert( destination.container && _.numberIs( destination.key ) );
        _.assert( value !== undefined,'not tested' );

        /**/

        destination.container[ destination.key ] = value;

        /**/

        /*if( value !== undefined && value !== null )*/
        destination.key += 1;

      }
      else if( direction === 'behind' ) return function storeToArrayBehind( destination,value )
      {

        _.assert( destination.container && _.numberIs( destination.key ) );
        _.assert( value !== undefined,'not tested' );

        /**/

        destination.container.unshift( value );

        /**/

        /*if( value !== undefined && value !== null )*/
        destination.key += 1;

      }
      else throw _.err( 'unexpected' );

    }

  }
  else if( containerConstructor === Object )
  {

    if( aggregative )
    generateStore = function execStoreToObjectGenerateAggregative( definitionElement,direction )
    {
      var elementName = definitionElement._.name || definitionElement.name;

      if( direction === 'ahead' )
      return function storeToObjectAggregativeAhead( destination,value )
      {
        destination.container[ elementName ] = _.arrayAppendElement( destination.container[ elementName ] || [], value );
      }
      else if( direction === 'behind' )
      return function storeToObjectAggregativeBehind( destination,value )
      {
        debugger;
        destination.container[ elementName ] = _.arrayPrependElement( destination.container[ elementName ] || [], value );
      }
      else throw _.err( 'unexpected' );

    }
    else if( rewritable )
    generateStore = function execStoreToObjectGenerateRewritable( definitionElement,direction )
    {
      var elementName = definitionElement._.name || definitionElement.name;

      return function execStoreToObjectReweritable( destination,value )
      {
        destination.container[ elementName ] = value;
      }

    }
    else
    generateStore = function execStoreToObjectGenerate( definitionElement,direction )
    {
      var elementName = definitionElement._.name || definitionElement.name;

      return function execStoreToObject( destination,value )
      {
        if( direction !== 'ahead' )
        throw _.err( 'not tested' );

        if( destination.container[ elementName ] !== undefined )
        throw _.err
        (
          'wParser:',
          'Failed to override',elementName,'of',definition._.nameCombinator + ',',
          'use "rewritable" or "aggregative" tag if you wish to collect it as array'
        );

        destination.container[ elementName ] = value;

      }

    }

  }
  else if( containerConstructor === String ) throw _.err( 'not implemented' );
  else throw _.err( 'wParser:','unknown container constructor',containerConstructor );

  self.definitionRegisterStore( definition,generateStore );

  //

  return definition;
}

//

TagNewContainer.tagCompileRead = function compileTagNewContainerRead( tag,definition,compileNextTag,execStore )
{
  var self = this;

  var name = definition._.name || definition.name;
  var containerConstructor = definition.containerConstructor;
  var rewritable = definition.rewritable;
  var aggregative = definition.aggregative;
  var isArray = definition.array;
  var generateStore = null;

  _.assert( arguments.length === 4 );
  _.assert( _.routineIs( execStore[ 'ahead' ] ) );

  // read

  if( !MODE_RAW )
  if( _.constructorIsBuffer( definition.containerConstructor ) )
  {

    function generateAdjustBufferLength( direction )
    {

      var execRead = definition._.execRead[ direction ];

      return function execAdjustBufferLength( destination )
      {

        var read = execRead.call( this,destination );
        /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/

        if( read === undefined )
        return;

        destination.container = _.bufferRelen( destination.container,destination.key );

        return read;
      }

    }

    self.definitionRegisterRead( definition,generateAdjustBufferLength );

  }

  //

  function generatReadNewContainer( direction )
  {
    var execRead = definition._.execRead[ direction ];
    var _execStore = execStore[ direction ];

    if( !MODE_RAW )
    return function execReadNewContainer( destination )
    {

      var newDestination = {};
      newDestination.container = new containerConstructor();
      newDestination.key = isArray ? 0 : null;
      newDestination.parentDestination = destination || null;
      newDestination.rootDestination = destination.rootDestination;

      var read = execRead.call( this,newDestination );
      /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/
      if( read === undefined )
      return;

      _execStore.call( this,destination,newDestination.container );

      return true;
    }
    else
    {
      var ctype = _.typeToCode( containerConstructor );
      return function execReadNewContainerRaw( destination )
      {

        debugger;
        var begin = destination.stream.position;
        destination.stream.write.wrd4( 0 );
        destination.stream.write.wrd2( 1 );
        destination.stream.write.wrd2( ctype );

        var read = execRead.call( this,newDestination );
        /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/
        if( read === undefined )
        {
          destination.stream.position = begin;
          return;
        }

        var size = destination.stream.position + 8 - begin;

        destination.stream.write.wrd2( ctype );
        destination.stream.write.wrd2( 1 );
        destination.stream.write.wrd4( 0 );

        var end = destination.stream.position;
        destination.stream.position = begin;
        destination.stream.write.wrd4( size );
        destination.stream.position = end;

        _execStore.call( this,destination,newDestination.container );

        return true;
      }
    }

  }

  self.definitionRegisterRead( definition,generatReadNewContainer );

  //

  return definition;
}

//

TagNewContainer.tagCompile = function compileTagNewContainer( tag,definition,compileNextTag )
{
  var self = this;

  if( definition.unwrap )
  return;

  if( !definition.combination )
  return;

  var name = definition._.name || definition.name;
  var containerConstructor = definition.containerConstructor;
  var rewritable = definition.rewritable;
  var aggregative = definition.aggregative;
  var isArray = definition.array;
  var execStore = definition._.generateStore( definition );

  // validation

  if( rewritable && aggregative )
  throw _.err( 'wParser:','"aggregative" and "rewritable" are incompatible tags' );

  if( definition.unwrap === undefined )
  throw _.err( 'wParser:','something wrong',_.toStr( definition ) );

  if( !containerConstructor )
  throw _.err( 'wParser:','definition should have defined container type',_.toStr( definition ) );

  // store

  if( MODE_RAW )
  TagNewContainer.tagCompileStoreRaw.call( this,tag,definition,compileNextTag );
  else
  TagNewContainer.tagCompileStoreNormal.call( this,tag,definition,compileNextTag );

  //

  compileNextTag();

  // read

  TagNewContainer.tagCompileRead.call( this,tag,definition,compileNextTag,execStore );

  //

  return definition;
}

// --
//  tag hook
// --

var TagHook =
{
  tagTokens : { onStore : 'onStore', onReadBegin : 'onReadBegin', onReadEnd : 'onReadEnd' },
  order : 400,
}

//

TagHook.tagCompile = function compileTagHook( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.onStore && !definition.onReadBegin && !definition.onReadEnd )
  return;

  var onStore = definition.onStore;
  var onReadBegin = definition.onReadBegin;
  var onReadEnd = definition.onReadEnd;
  var mediator = null;

  //store

  if( onStore )
  {
    var generateStore = definition._.generateStore;
    function generateStoreHook( definitionElement,direction )
    {

      var result = {};
      var execStore = generateStore.forDirection( definitionElement,direction );
      var execSotreJoined = _.routineJoin( this,execStore );

      return function execStoreHookAhead( destination,value )
      {
        return onStore.call( this,execSotreJoined,destination,value );
      }

      return result;
    }

    self.definitionRegisterStore( definition,generateStoreHook );
  }

  // mediator

  if( onReadEnd )
  {
    mediator = generateMediator.call( self,definition,'Hook' );
  }

  // next

  compileNextTag();

  // read

  if( onReadBegin || onReadEnd )
  {

    onReadBegin = onReadBegin || function( destination ){ return true };

    function generateReadHook( direction )
    {

      var execRead = definition._.execRead[ direction ];

      var readHook = null;
      if( onReadEnd )
      {

        var readMediatorBegin = mediator.readBegin;
        var readMediatorEnd = mediator.readEnd;
        var readMediatorCancel = mediator.readCancel;
        var readMediatorAccept = mediator.readAccept;
        var readMediatorGetStore = mediator.readGetStore;

        readHook = function readHook( destination )
        {

          var read = onReadBegin.call( this,destination );
          _.assert( read === undefined || read === true,'read should return true or undefined' );
          if( read === undefined )
          return;

          readMediatorBegin.call( this,destination );

          read = execRead.call( this,destination );
          if( read === undefined )
          {
            readMediatorEnd.call( this,destination );
            return;
          }

          var mstore = readMediatorGetStore.call( this,destination );
          var read = onReadEnd.call( this,destination,mstore );
          _.assert( read === undefined || read === true,'read should return true or undefined' );
          if( read === undefined )
          {
            readMediatorCancel.call( this,destination );
            readMediatorEnd.call( this,destination );
            return;
          }

          readMediatorAccept.call( this,destination );
          readMediatorEnd.call( this,destination );

          return read;
        }
      }
      else readHook = function readHook( destination )
      {

        var read = onReadBegin.call( this,destination );
        _.assert( read === undefined || read === true,'read should return true or undefined' );
        if( read === undefined )
        return;

        read = execRead.call( this,destination );
        if( read === undefined )
        return;

        return read;
      }

      return readHook;
    }
    self.definitionRegisterRead( definition,generateReadHook );

  }

  //

  return definition;
}

// --
// tag find
// --

var TagFind =
{
  tagTokens : { find : 'find' },
  order : 500,
}

//

TagFind.tagCompile = function compileTagFind( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.find )
  return;

  var mediator = generateMediator.call( self,definition,'Find' );

  compileNextTag(); //

  var execRead = definition._.execRead;
  function generateFind( direction )
  {

    var readMediatorBegin = mediator.readBegin;
    var readMediatorEnd = mediator.readEnd;
    var readMediatorCancel = mediator.readCancel;
    var readMediatorAccept = mediator.readAccept;

    var _execRead = execRead[ direction ];
    var ahead = direction === 'ahead';

    var d;
    if( direction === 'ahead' )
    d = +1;
    else if( direction === 'behind' )
    d = -1;
    else
    throw _.err( 'unexpected' );

    var readFind;
    if( ahead )
    readFind = function readFind( destination )
    {

      var size = this.size;
      var begin = this._pos;
      var end = begin;
      var read,storingContainer;

      readMediatorBegin.call( this,destination );

      var _end = ahead ? size : 0;
      while( end !== _end )
      {
/*
        console.log( 'Find :',this.position );
*/
        read = _execRead.call( this,destination );
        /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/

        if( read === undefined )
        {
          readMediatorCancel.call( this,destination );
          end += d;
          this._pos = end;
        }
        else
        {
          readMediatorAccept.call( this,destination );
          break;
        }

      }

      readMediatorEnd.call( this,destination );

      return read;
    }
    else readFind = function readFindBehind( destination )
    {
      throw _.err( 'Tag find is not revertable :',definition._.path );
    }

    return readFind;
  }

  //

  self.definitionRegisterRead( definition,generateFind );

  return definition;
}

// --
// tag but
// --

var TagBut =
{
  tagTokens : { but : 'but' },
  order : 600,
}

//

TagBut.tagCompile = function compileTagBut( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.but )
  return;

  if( definition.forward )
  {
    throw _.err( 'not tested' );
    /*self.reportUselessness( 'Consolidation of tags "but" and "forward" is useless, always gives nothing' );*/
  }

  if( definition.find )
  self.reportUselessness( '"but" is opposite of "find not", so consolidation of tags "but" and "find" is useless. Single "but" gives same effect.' );

  var execStore = definition._.generateStore( definition );
  var name = definition._.name || definition.name;

  // store

  var generateStore = function execStoreButGenerate( definitionElement,direction )
  {
    return function execStoreBut( destination,value )
    {
    }
  }

  self.definitionRegisterStore( definition,generateStore );

  //

  compileNextTag();

  // read

  function generateReadBut( direction )
  {

    var ahead = direction === 'ahead' ? 1 : 0;
    var execRead = definition._.execRead[ direction ];
    var store = execStore[ direction ];
    var _delta = direction === 'ahead' ? +1 : -1;
    var readTextOfLength = wParser._readTextOfLength[ direction ];

    _.assert( _.routineIs( readTextOfLength ) );

    return function execReadBut( destination )
    {

      var begin = this._pos;
      var end = begin;
      var _end = ahead ? this.size : 0;

      var dropWas = this.drop;
      this.drop = 1;

      while( end !== _end )
      {

        var read = execRead.call( this,destination );
        /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/

        if( read === undefined )
        {
          end += _delta;
          this._pos = end;
        }
        else break;

      }

      this.drop = dropWas;

      this._pos = begin
      var result = readTextOfLength.call( this,ahead ? end-begin : begin-end );
      _.assert( _.strIs( result ) );
      store.call( this,destination,result );

      return true;
    }

  }

  self.definitionRegisterRead( definition,generateReadBut );

  return definition;
}

// --
// tag backward
// --

var TagBackward =
{
  tagTokens : { backward : 'backward' },
  order : 701,
}

//

TagBackward.tagRefineDown = function normalizeSizeBackward( tag,definition,normalizeNextDefinition )
{
  var self = this;

  if( !definition.backward )
  return;

  if( definition.forward && definition.backward )
  throw _.err( 'wParser.compileDefinitionTags:','can use only one tag "forward" / "backward"' );

  debugger;
  throw _.err( 'not tested' );

  definition._.windSize[ 0 ] = 0;
  definition._.windSize[ 1 ] = 0;

  definition._.lookSize[ 1 ] *= -1;

}

//

TagBackward.tagCompile = function compileTagBackward( tag,definition,compileNextTag )
{

  var self = this;

  if( !definition.backward )
  return;

  compileNextTag();

  throw _.err( 'Not tested' );

  if( definition._.windSize[ 0 ] !== definition._.windSize[ 1 ] )
  throw _.err( 'compileTagBackward:','variable size definition with "backward" tag is not supported' );

  function generateBackward( direction )
  {

    var execRead = definition._.execRead[ direction ];
    var size = definition.size;

    throw _.err( 'Not implemented' );

    return function execBackward( destination )
    {

      if( this.position < size )
      return;

      var begin = this.position;
      this.position -= size;

      var read = execRead.call( this,destination );
      /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/

      this.position = begin;

      return read;
    }

  }

  self.definitionRegisterRead( definition,generateBackward );

  return definition;
}

// --
// tag forward
// --

var TagForward =
{
  tagTokens : { forward : 'forward' },
  order : 702,
}

//

TagForward.tagRefineDown = function normalizeSizeForward( tag,definition,normalizeNextDefinition )
{
  var self = this;

  if( !definition.forward )
  return;

  if( definition.forward && definition.backward )
  throw _.err( 'wParser.compileDefinitionTags:','can use only one tag "forward" / "backward"' );

  definition._.windSize[ 0 ] = 0;
  definition._.windSize[ 1 ] = 0;

}

//

TagForward.tagCompile = function compileTagForward( tag,definition,compileNextTag )
{

  var self = this;

  if( !definition.forward )
  return;

  if( definition.forward && definition.backward )
  throw _.err( 'wParser.compileDefinitionTags:','can use only one tag "forward" / "backward"' );

  compileNextTag();

  function generateForward( direction )
  {

    var execRead = definition._.execRead[ direction ];

    return function execForward( destination )
    {
      var begin = this.position;

      var read = execRead.call( this,destination );
      /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/

      this.position = begin;

      return read;
    }

  }

  self.definitionRegisterRead( definition,generateForward );

  return definition;
}

// --
// tag forward not
// --

var TagForwardNot =
{
  tagTokens : { forwardNot : 'forwardNot' },
  order : 703,
}

//

TagForwardNot.tagRefineDown = function normalizeSizeForwardNot( tag,definition,normalizeNextDefinition )
{
  var self = this;

  if( !definition.forwardNot )
  return;

  debugger;

  definition._.windSize[ 0 ] = 0;
  definition._.windSize[ 1 ] = 0;

}

//

TagForwardNot.tagCompile = function compileTagForwardNot( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.forwardNot )
  return;

  // store

  var execStore = definition._.generateStore( definition );
  var generateStore = function execStoreForwardNotGenerate( definitionElement,direction )
  {

    return function execStoreForwardNot( destination,value )
    {
    }

  }

  self.definitionRegisterStore( definition,generateStore );

  //

  compileNextTag();

  // read

  function generateForwardNot( direction )
  {

    var execRead = definition._.execRead[ direction ];

    return function execForwardNot( destination )
    {

      var dropWas = this.drop;
      this.drop = 1;

      var begin = this.position;
      var read = execRead.call( this,destination );
      /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/

      this.drop = dropWas;

      this.position = begin;

      if( read === undefined )
      {
        execStore[ direction ].call( this,destination,true );
        return true;
      }

      return;
    }

  }

  self.definitionRegisterRead( definition,generateForwardNot );

  return definition;
}

// --
// tag as much as possible
// --

var TagOptional =
{
  tagTokens : { optional : 'optional' },
  order : 799,
}

//

TagOptional.tagRefineDown = function normalizeTagOptional( tag,definition,normalizeNextDefinition )
{
  var self = this;

  if( !definition.optional )
  return;

  if( definition.atLeastOnce )
  {
    definition.atLeastOnce = false;
    definition.optional = false;
    definition.asMuchAsPossible = true;

    normalizeNextDefinition();
    return;
  }

  if( definition.asMuchAsPossible )
  {
    throw _.err( 'not tested' );
    definition.optional = false;
    normalizeNextDefinition();
    return;
  }

  if( definition.times )
  {
    throw _.err( 'not implemented' );
  }

  definition._.windSize[ 0 ] = 0;
  definition._.lookSize[ 0 ] = 0;

  self.reportDeadLoopIfDefinitionMinimalWindSizeIsIrregular( definition );

  //

  definition._.ownAlternativity += 1;
  definition._.alternativity += 1;

}

//

TagOptional.tagCompile = function compileTagOptional( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.optional )
  return;

  compileNextTag();

  function generateOptional( direction )
  {

    var execRead = definition._.execRead[ direction ];

    return function execOptional( destination )
    {

      var position = this._pos;
      var read = execRead.call( this,destination );
      /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/

      if( read === undefined )
      {
        this._pos = position;
      }

      return true;
    }

  }

  self.definitionRegisterRead( definition,generateOptional );

  return definition;
}

// --
// tag time
// --

var TagTimes =
{
  tagTokens : { times : 'times' },
  order : 800,
}

//

TagTimes.tagRefineDown = function normalizeSizeTimes( tag,definition,normalizeNextDefinition )
{
  var self = this;

  if( definition.times === undefined )
  return;

  _.assert( definition.optional === undefined );

  if( !_.numberIs( definition.times ) && !_.arrayIs( definition.times ) )
  throw _.err( 'times should be array :',definition );

  var times = definition.times = _.numberIs( definition.times ) ? [ definition.times,definition.times ] : definition.times;

  if( definition.asMuchAsPossible || definition.atLeastOnce )
  throw _.err( 'wParser:','cant use "times" tag with "atLeastOnce"/"asMuchAsPossbile" tag' );

  if( times[ 0 ] === Infinity || !_.numberIs( times[ 0 ] ) || isNaN( times[ 0 ] ) || !_.numberIs( times[ 1 ] ) || isNaN( times[ 1 ] ) || times[ 0 ] > times[ 1 ] )
  throw _.err( 'wParser:','not regular times cardinator :',_.toStr( times ) );

  if( times[ 1 ] === +Infinity || times[ 1 ] === -Infinity )
  {
    self.reportDeadLoopIfDefinitionMinimalWindSizeIsZero( definition );
  }

  var windSize = definition._.windSize.slice();

  /**/

  definition._.windSize[ 0 ] *= times[ 0 ];
  definition._.windSize[ 1 ] *= times[ 1 ];

  /**/

  definition._.lookSize[ 0 ] *= times[ 0 ];
  definition._.lookSize[ 1 ] *= times[ 1 ];

/*
  for( var i = 0 ; i < 2 ; i++ )
  {

    if( definition._.windSize[ i ] === Infinity )
    definition._.lookSize[ i ] = Infinity
    else if( !definition._.windSize[ i ] )
    definition._.lookSize[ i ] = definition._.lookSize[ i ];
    else
    definition._.lookSize[ i ] = definition._.windSize[ i ] - windSize[ i ] + definition._.lookSize[ i ];

  }

  //definition._.lookSize[ 0 ] *= times[ 0 ]; ???
  //definition._.lookSize[ 1 ] *= times[ 1 ]; ???
*/

  //

  if( times[ 1 ] === Infinity )
  {
    definition._.ownAlternativity = Infinity;
    definition._.alternativity = Infinity;
  }
  else
  {
    definition._.ownAlternativity = Math.pow( definition._.ownAlternativity,times[ 1 ] - times[ 0 ] );
    definition._.alternativity = Math.pow( definition._.alternativity,times[ 1 ] - times[ 0 ] );
  }

  //

  normalizeNextDefinition();

}

//

TagTimes.tagCompile = function compileTagTimes( tag,definition,compileNextTag )
{
  var self = this;

  if( definition.times === undefined )
  return;

  _.assert( _.arrayIs( definition.times ) )

  var times = definition.times;
  var t0 = times[ 0 ];
  var t1 = times[ 1 ];

/*
  var lookForward = true;
  var execStore = definition._.generateStore( definition );
  var generateStore = function generateStoreTimes( definitionElement,direction )
  {
    var result = {};
    var store = execStore[ direction ];

    return function execStoreTimes( destination,value )
    {
      if( lookForward )
      return;
      store.call( this,destination,value );
    }

  }

  self.definitionRegisterStore( definition,generateStore );
*/

  var mediator = generateMediator.call( self,definition,'Times' );

  compileNextTag();

  function generateReadTimes( direction )
  {

    var readMediatorBegin = mediator.readBegin;
    var readMediatorEnd = mediator.readEnd;
    var readMediatorCancel = mediator.readCancel;
    var readMediatorAccept = mediator.readAccept;

    var execRead = definition._.execRead[ direction ];
    if( t1 > 1 )
    throw _.err( 'not tested' );

    return function readTimes( destination )
    {

      var read;
      var position = this._pos;
      /*lookForward = true;*/
      readMediatorBegin.call( this,destination );

      for( var t = 0 ; t < t0 ; t++ )
      {
        debugger;
        throw _.err( 'not tested' );
        read = execRead.call( this,destination );
        /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/
        if( read === undefined )
        {
          debugger;
          throw _.err( 'not tested' );
          this._pos = position;
          readMediatorCancel.call( this,destination );
          readMediatorEnd.call( this,destination );
          return;
        }
      }

      readMediatorAccept.call( this,destination );

      var c = t0;
      for( var t = t0 ; t < t1 ; t++ )
      {
        read = execRead.call( this,destination );
        if( read === undefined )
        {
          readMediatorCancel.call( this,destination );
          break;
        }
        /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/
        c += 1;
        readMediatorAccept.call( this,destination );
      }

      // this._pos = position;
      // /*lookForward = false;*/
      //
      // for( var t = 0 ; t < c ; t++ )
      // {
      //   execRead.call( this,destination );
      // }

      readMediatorEnd.call( this,destination );

      return true;
    }

  }

  self.definitionRegisterRead( definition,generateReadTimes );

  return definition;
}

// --
// tag as much as possible
// --

var TagAsMuchAsPossible =
{
  tagTokens : { asMuchAsPossible : 'asMuchAsPossible' },
  order : 801,
}

//

TagAsMuchAsPossible.tagRefineDown = function normalizeSizeAsMuchAsPossible( tag,definition,normalizeNextDefinition )
{
  var self = this;

  if( !definition.asMuchAsPossible )
  return;

  _.assert( definition.optional === undefined );
  _.assert( definition.times === undefined );

  if( definition.atLeastOnce )
  definition.atLeastOnce = false;

  if( _.numberIs( definition.times ) || _.arrayIs( definition.times ) )
  throw _.err( 'wParser:','can use only one tag "times" or "asMuchAsPossible"' );

  self.reportDeadLoopIfDefinitionMinimalWindSizeIsZero( definition );

  definition._.windSize[ 0 ] = 0;
  definition._.windSize[ 1 ] = +Infinity;

  definition._.lookSize[ 0 ] = 0;
  definition._.lookSize[ 1 ] = +Infinity;

  //

  definition._.ownAlternativity = Infinity;
  definition._.alternativity = Infinity;

}

//

TagAsMuchAsPossible.tagCompile = function compileTagAsMuchAsPossible( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.asMuchAsPossible )
  return;

  var mediator = generateMediator.call( self,definition,'TagAsMuchAsPossible' );

  compileNextTag();

  function generateAsMuchAsPossible( direction )
  {

    var execRead = definition._.execRead[ direction ];
    var readMediatorBegin = mediator.readBegin;
    var readMediatorEnd = mediator.readEnd;
    var readMediatorCancel = mediator.readCancel;
    var readMediatorAccept = mediator.readAccept;

    return function execAsMuchAsPossible( destination )
    {

      readMediatorBegin.call( this,destination );

      var position;
      while( true )
      {

        position = this._pos;
        var read = execRead.call( this,destination );
        /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/
        if( read === undefined )
        {
          readMediatorCancel.call( this,destination );
          this._pos = position;
          break;
        }

        readMediatorAccept.call( this,destination );
        _.assert( position !== this._pos,'dead lock' );

      }

      readMediatorEnd.call( this,destination );

      return true;
    }

  }

  self.definitionRegisterRead( definition,generateAsMuchAsPossible );

  return definition;
}

// --
// tag at least once
// --

var TagAtLeastOnce =
{
  tagTokens : { atLeastOnce : 'atLeastOnce' },
  order : 802,
}

//

TagAtLeastOnce.tagRefineDown = function normalizeSizeAtLeastOnce( tag,definition,normalizeNextDefinition )
{
  var self = this;

  if( !definition.atLeastOnce )
  return;

  _.assert( definition.optional === undefined );
  _.assert( definition.times === undefined );
  _.assert( definition.asMuchAsPossible === undefined );

  self.reportDeadLoopIfDefinitionMinimalWindSizeIsZero( definition );

  definition._.windSize[ 1 ] = +Infinity;
  definition._.lookSize[ 1 ] = +Infinity;

  //

  definition._.ownAlternativity = Infinity;
  definition._.alternativity = Infinity;

}

//

TagAtLeastOnce.tagCompile = function compileTagAtLestOnce( tag,definition,compileNextTag )
{
  var self = this;

  if( !definition.atLeastOnce )
  return;

  compileNextTag();

  function generateAtLeastOnce( direction )
  {
    var execRead = definition._.execRead[ direction ];

    return function execAtLeastOnce( destination )
    {

      if( !destination.container )
      throw _.err( 'wParser:','no container to include',wParser.prototype.definitionToStr( definition ) );

      var t = 0;
      var position;
      while( true )
      {

        position = this._pos;
        var read = execRead.call( this,destination );
        /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/

        if( read === undefined )
        {
          this.position = position;
          if( t < 1 )
          return;
          break;
        }

        _.assert( position !== this._pos,'dead lock' );

        t += 1;

      }

      return true;
    }

  }

  self.definitionRegisterRead( definition,generateAtLeastOnce );

  return definition;
}

// --
// tag combination
// --

var TagCombination =
{
  tagTokens :
  {
    combination : 'combination',
    restrictedAlteration : 'restrictedAlteration'
  },
  order : 999,
}

//

TagCombination.tagCompile = function compileTagCombination( tag,definition,compileNextTag )
{
  var self = this;
  /*var lookForward = false;*/
  var elements = definition.elements;

  if( !definition.combination )
  return;

  if( !definition.elements.length )
  throw _.err( 'definition.elements is empty, something wrong!' );

  // validation

  if( arguments.length !== 3 )
  throw _.err( 'compileDefinitionCombination:','accept only 3 argument' );

  if( !_.arrayIs( elements ) )
  throw _.err( 'compileDefinitionCombination:','combination argument is not array',elements );

  if( !_.objectIs( definition ) )
  throw _.err( 'compileDefinitionCombination:','definition is needed',definition );

  if( !definition.combination )
  throw _.err( 'compileDefinitionCombination:','"combination" type is not defined' );

  //

  if( definition.combination === 'composition' )
  tag.tagCompileComposition.call( self,tag,definition,compileNextTag );
  else if( definition.combination === 'alteration' )
  tag.tagCompileAlteration.call( self,tag,definition,compileNextTag );
  else throw _.err( 'wParser.compileDefinitionCombination:','unknown combination:',toStr( definition.combination ) );

}

//

TagCombination.tagCompileComposition = function compileTagComposition( tag,definition,compileNextTag )
{
  var self = this;
  var elements = definition.elements;
  var l = elements.length;
  var cycleBranching = definition._.cycleBranching;
  var path = definition._.path;
  var dkey = 'composition-branching-position-' + definition._.id;
  var execReadsAhead = [];
  var execReadsBehind = [];

  function compileElements()
  {

    tag.tagCompileElements.call( self,tag,definition );

    var _execReadsAhead = _.entitySelect( definition._.execReads,'*.' + 'ahead' );
    _.arrayAppendArray( execReadsAhead,_execReadsAhead );
    _.assert( execReadsAhead.length === l );

    var _execReadsBehind = _.entitySelect( definition._.execReads,'*.' + 'behind' );
    _.arrayAppendArray( execReadsBehind,_execReadsBehind );
    _.assert( execReadsBehind.length === l );

  }

  // other definitions

  compileNextTag();

  if( !cycleBranching )
  {
    compileElements();
  }
  else
  {
    definition._.compileAfter = definition._.compileAfter || [];
    definition._.compileAfter.push( compileElements );
  }

  // combination

  if( l === 0 )
  throw _.err( 'not tested' );

  function generateComposition( direction )
  {

    var random = Math.random();
    var readComposition = null;
    var execReads = direction === 'ahead' ? execReadsAhead : execReadsBehind;

    var _first,_last,_delta;
    if( direction === 'ahead' )
    {
      _first = 0;
      _last = l;
      _delta = +1;
    }
    else if( direction === 'behind' )
    {
      _first = l-1;
      _last = -1;
      _delta = -1;
    }
    else throw _.err( 'unexpected' );

    if( l === 1 && !cycleBranching )
    {
      readComposition = execReads[ 0 ];
    }
    else readComposition = function readComposition( destination )
    {

      if( cycleBranching )
      {
        if( destination.rootDestination[ dkey ] === this._pos )
        throw _.err( 'Deadlock at',path );
        destination.rootDestination[ dkey ] = this._pos;
      }

      for( var e = _first ; e != _last ; e += _delta )
      {

        var read = execReads[ e ].call( this,destination );
        /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/
        if( read === undefined )
        {
          if( cycleBranching )
          destination.rootDestination[ dkey ] = null
          return;
        }

      }

      if( cycleBranching )
      destination.rootDestination[ dkey ] = null
      return true;
    }

/*
    if( elements.length > 1 )
    if( self.using.heavyOptimization && definition._.root !== definition )
    {

      readComposition.external =
      {
        _ : _,
        execReads : execReads,
      };
      readComposition.constant =
      {
        cycleBranching : cycleBranching,
        l : elements.length,
        _first : _first,
        _last : _last,
        _delta : _delta,
        direction : direction,
      };
      readComposition.inline =
      {
      };
      readComposition = _.routineIsolate
      ({
        routine : readComposition,
        debug : 0,
      });

    }
*/

    return readComposition;
  }

  if( !definition._.cycleBranching )
  _.assert( !definition._.execRead );

  if( !definition._.execRead )
  {
    self.definitionRegisterRead( definition,generateComposition );
  }

}

//

TagCombination.tagCompileAlteration = function compileTagAlteration( tag,definition,compileNextTag )
{
  var self = this;
  var elements = definition.elements;
  var restrictedAlteration = definition.restrictedAlteration;
  var cycleBranching = definition._.cycleBranching;
  var dkeyPosition = 'composition-branching-position-' + definition._.id;
  var path = definition._.path;
  var execReadsAhead = [];
  var execReadsBehind = [];
  var l = elements.length;

  if( l === 0 )
  throw _.err( 'not tested' );

  // mediator

  var mediator = null;
  if( l > 1 )
  mediator = generateMediator.call( self,definition,'Alteration' );

  //

  compileNextTag();

  // elements

  function compileElements()
  {

    tag.tagCompileElements.call( self,tag,definition );

    var _execReadsAhead = _.entitySelect( definition._.execReads,'*.' + 'ahead' );
    _.arrayAppendArray( execReadsAhead,_execReadsAhead );
    _.assert( execReadsAhead.length === l );

    var _execReadsBehind = _.entitySelect( definition._.execReads,'*.' + 'behind' );
    _.arrayAppendArray( execReadsBehind,_execReadsBehind );
    _.assert( execReadsBehind.length === l );

  }

  if( !cycleBranching )
  {
    compileElements();
  }
  else
  {
    //debugger;
    //throw _.err( 'not tested' );
    console.warn( 'cycleBranching not tested' );
    definition._.compileAfter = definition._.compileAfter || [];
    definition._.compileAfter.push( compileElements );
  }

  // read

  var execReads = definition._.execReads;
  function generateReadAlteration( direction )
  {

    var readAlteration = null;
    var execReads = direction === 'ahead' ? execReadsAhead : execReadsBehind;

    var readMediatorBegin = l > 1 ? mediator.readBegin : null;
    var readMediatorEnd = l > 1 ? mediator.readEnd : null;
    var readMediatorCancel = l > 1 ? mediator.readCancel : null;
    var readMediatorAccept = l > 1 ? mediator.readAccept : null;

    //

    var _first,_last,_delta;
    if( direction === 'ahead' )
    {
      _first = 0;
      _last = l;
      _delta = +1;
    }
    else if( direction === 'behind' )
    {
      _first = l-1;
      _last = -1;
      _delta = -1;
    }
    else throw _.err( 'unexpected' );

    //

    if( l === 0 )
    throw _.err( 'not implemented' );

    if( l === 1 )
    {
      readAlteration = execReads[ 0 ];
    }
    else readAlteration = function readAlteration( destination )
    {

      /*if( direction === 'behind' ) debugger;*/

      if( cycleBranching )
      {
        if( destination.rootDestination[ dkeyPosition ] === this._pos )
        throw _.err( 'Deadlock at',path );
        destination.rootDestination[ dkeyPosition ] = this._pos;
      }

      var counter = 0;
      var begin = this._pos;
      var end = begin;
      var e = _first;
      var read,storingContainer;

      readMediatorBegin.call( this, destination );

      //

      for( ; e !== _last ; e += _delta )
      {

        read = execReads[ e ].call( this,destination );
        /** _.assert( read === undefined || read === true,'read should return true or undefined' ); **/

        if( read === undefined )
        {
          readMediatorCancel.call( this, destination );
          this._pos = begin;
          continue;
        }

        readMediatorAccept.call( this, destination );

        if( counter !== 0 )
        if( this._pos !== end )
        throw _.err
        (
          'wParser:',
          'alteration of alternatives of different size is not supported',
          'such alternatives should not overlap each other',
          'or should use "restrictedAlteration" tag',
          path
        );

        end = this._pos;
        counter += 1;

        if( restrictedAlteration )
        break;

        this._pos = begin;
      }

      readMediatorEnd.call( this,destination );

      if( cycleBranching )
      destination.rootDestination[ dkeyPosition ] = null;

      if( !counter )
      return;

      this._pos = end;

      return true;
    }
    /*else throw _.err( 'unexpected' );*/

    if( elements.length > 1 )
    if( self.using.heavyOptimization && definition._.root !== definition )
    {
      readAlteration.external =
      {
        _ : _,
        execReads : execReads,
      };
      readAlteration.constant =
      {
        restrictedAlteration : restrictedAlteration,
        cycleBranching : cycleBranching,
        l : elements.length,
        _first : _first,
        _last : _last,
        _delta : _delta,
        direction : direction,
        path : path,
      };
      readAlteration.inline =
      {
        readMediatorBegin : readMediatorBegin,
        readMediatorEnd : readMediatorEnd,
        readMediatorCancel : readMediatorCancel,
        readMediatorAccept : readMediatorAccept,
      };
      readAlteration = _.routineIsolate
      ({
        routine : readAlteration,
        debug : 0,
      });
    }

    return readAlteration;
  }

  //

  self.definitionRegisterRead( definition,generateReadAlteration );

}

//

TagCombination.tagCompileElements = function tagCompileCombinationElements( tag,definition )
{
  var self = this;
  var elements = definition.elements;

  // validation

  if( !_.arrayIs( elements ) )
  throw _.err( 'compileDefinitionCombination:','elements argument is not array',elements );

  if( !_.objectIs( definition ) )
  throw _.err( 'compileDefinitionCombination:','definition is needed',definition );

  if( !definition.combination )
  throw _.err( 'compileDefinitionCombination:','"combination" type is not defined' );

  if( definition._.execReads && definition._.cycleBranching )
  {
    debugger;
    throw _.err( 'not expected' );
    return;
  }

  if( definition._.execReads )
  throw _.err( 'compileDefinitionCombination:','execReads present, should not' );

  // compile elements

  definition._.execReads = [];

  for( var e = 0, l = elements.length ; e < l ; e++ )
  {

    var definitionElement = elements[ e ];

    if( !definitionElement )
    throw _.err( 'wParser:',definition._.name || definition.name,'does not has component','#'+e,_.toStrFine( elements ) );

    self.compileDefinitionPreceding( definitionElement );
    definition._.execReads[ e ] = definitionElement._.execRead;
    _.assert( _.objectIs( definitionElement._.execRead ) );

  }

  Object.freeze( definition._.execReads );

}

// --
// tag terminal
// --

var TagTerminal =
{
  order : 1000,
}

//

TagTerminal.tagCompile = function compileTagTerminal( tag,definition,compileNextTag )
{
  var self = this;

  if( definition.combination )
  return;

  var execStore = definition._.generateStore( definition );
  var name = definition._.name || definition.name;

  // validation

  if( !execStore )
  throw _.err( 'compileTerminal:','terminal definition has no store' );
  if( name === undefined )
  throw _.err( 'compileTerminal:','terminal definition has no name' );

  // next definition

  compileNextTag();

  // read
/*
  function generateReadTerminal( direction )
  {
    var execRead = definition._reader.read[ direction ];

    if( execRead === null )
    execRead = function terminalNotProvided()
    {
      throw _.err( direction,definition._.name,'terminal was not provided' );
    }

    if( !_.routineIs( execRead ) )
    throw _.err( 'compileTerminal:','terminal definition has no read' );
    if( execRead.length )
    throw _.err( 'compileTerminal:','terminal definition expects arguments' );

    return execRead;
  }

  self.definitionRegisterRead( definition,generateReadTerminal );
*/

  function generateReadTerminal( direction )
  {

    var readTerminal = null;
    var store = execStore[ direction ];
    /*var execRead = definition._.execRead[ direction ];*/
    var execRead = definition._reader.read[ direction ];

    if( !_.routineIs( execRead ) && execRead !== null )
    throw _.err( 'compileTerminal:','terminal definition has no read' );
    if( execRead !== null && execRead.length )
    throw _.err( 'compileTerminal:','terminal definition should not expect arguments' );

    if( execRead === null )
    readTerminal = function terminalNotProvided()
    {
      throw _.err( direction,name,'terminal was not provided' );
    }
    else
    readTerminal = function readTerminal( destination )
    {

      var result = execRead.call( this );

      if( result === undefined )
      return;

      store.call( this,destination,result );

      return true;
    }

    //
/*
    if( self.using.heavyOptimization && definition._.root !== definition && execRead )
    {

      readTerminal.external =
      {
        _ : _,
        store : store,
      };
      readTerminal.constant =
      {
      };
      readTerminal.inline =
      {
        execRead : execRead,
      };
      readTerminal = _.routineIsolate
      ({
        routine : readTerminal,
        debug : 0,
      });

    }
*/
    return readTerminal;
  }

  //

  self.definitionRegisterRead( definition,generateReadTerminal );

  return definition;
}

// --
// tags map
// --

var tagsMap =
{

  //

  Debug: TagDebug,

  // storing

  Drop: TagDrop,
  TagUseThisName: TagUseThisName,
  NewContainer: TagNewContainer,

  //

  Hook: TagHook,
  Find: TagFind,
  But: TagBut,

  //

  Backward: TagBackward,
  Forward: TagForward,
  ForwardNot: TagForwardNot,

  // cardinality

  Optional: TagOptional,
  Times: TagTimes,
  AsMuchAsPossible: TagAsMuchAsPossible,
  AtLeastOnce: TagAtLeastOnce,

  // terminal

  Combination: TagCombination,
  Terminal: TagTerminal,

}

// --
// declare
// --

var Proto =
{

  // generator

  generateMediator: generateMediator,

  // var

  _emptyDestination: _emptyDestination,

}

//

_.mapExtend( Self.prototype,Proto );
_.mapExtend( Self,Proto );

Self.tagsPrepare( tagsMap );

return Self;

})();
