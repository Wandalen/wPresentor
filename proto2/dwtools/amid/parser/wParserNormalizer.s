// (function()
// {
//
// 'use strict';
//
// var _ = _global_.wTools;
// var Parent = wStream;
// var Self = wParser;
// var definitions = wParser.prototype.definitions;
//
// return;
//
// /*
//
//   - implement run-time detect atLeastOnce of zero size - dead loops
//   - move most of normalization from first and third to second phase
//   - do not index dropped elements of combination
//   - fix losing of name of top structure
//
// */
//
// // --
// // normalize
// // --
//
// function definitionNormalize( definition,definitionDescriber )
// {
//   var self = this;
//   var redefine = false;
//
//   _.assert( 1 <= arguments.length || arguments.length <= 2,'definitionNormalize:','expects 3 arguments' );
//
//   if( definitionDescriber === undefined )
//   definitionDescriber = null;
//
//   // normalize to object
//
//   if( _.arrayIs( definition ) )
//   {
//     definition = { type : definition };
//   }
//   else if( _.strIs( definition ) )
//   {
//     definition = self.definitions.TextLiteral( definition );
//   }
//   else
//   {
//
//     if( !_.objectIs( definition ) )
//     throw _.err( 'something wrong with definition',definition );
//
//   }
//
//   // redefine
//
//   if( definition.instanceIs )
//   throw _.err( 'definition is instance, something wrong' );
//
//   if( _.numberIs( definition.id ) )
//   {
//
//     _.assert( _.mapOwnKey( definition,{ id : 'id' } ) );
//     if( definition.reuse !== undefined )
//     throw _.err( 'redefine+reuse: unexpected' );
//
//     redefine = true;
//     definition = _.prototypeAppend( {},definition );
//
//   }
//
//   // normalize type
//
//   if( !redefine )
//   {
//     self.definitionNormalizeType( definition,definitionDescriber );
//   }
//
//   // common attributes
//
//   definition.describer = definitionDescriber;
//   wParser._idCounter[ 0 ] += 1;
//   definition.id = wParser._idCounter[ 0 ];
//
//   if( definitionDescriber )
//   {
//     definition.indexLocal = definitionDescriber._elementIndex;
//     _.assert( _.numberIs( definition.indexLocal ) );
//   }
//
//   // counter
//
//   self.definitionNormalizeCounters( definition );
//
//   if( !redefine )
//   {
//     self.definitionNormalizeReferenceCounter( definition );
//     if( definition.reuse  )
//     return definition;
//   }
//
//   // relationship
//
//   /*if( !redefine )*/
//   /*self.definitionNormalizeRelationship( definition );*/
//
//   return definition;
// }
//
// //
//
// function definitionNormalizeRedefined( definition,definitionDescriber )
// {
//   var self = this;
//
//   _.assert( arguments.length === 1 || arguments.length === 2 );
//
//   if( definition.instanceIs )
//   definition = definition.__proto__;
//
// /*
//   if( _.mapOwnKey( definition,{ id : 'id' } ) )
//   definition = _.prototypeAppend( {},definition );
// */
//
//   definition = self.definitionNormalize( definition,definitionDescriber );
//
//   _.assert( definition.instanceIs === undefined );
//
//   return definition;
// }
//
// //
//
// function definitionNormalizeType( definition,definitionDescriber )
// {
//   var self = this;
//
//   _.assert( arguments.length === 2,'definitionNormalizeType:','expects 2 arguments' )
//
//   // reference
//
//   if( definition.reuse )
//   {
//
//     if( definition.type || definition.elements )
//     throw _.err( 'definition cant has type/elements with reuse tags',definition.name );
//
//   }
//
//   // type
//
//   if( definition.type || definition.elements )
//   {
//
//     if( _.arrayIs( definition.type ) || _.arrayIs( definition.elements ) )
//     {
//
//       self.definitionNormalizeTypeCombination( definition,definitionDescriber );
//
//     }
//     else
//     {
//
//       self.definitionNormalizeTypePrototype( definition,definitionDescriber );
//
//     }
//
//   }
//
//   return definition;
// }
//
// //
//
// function definitionNormalizeReferenceCounter( definition )
// {
//   var self = this;
//
//   if( definition.hasReferences !== undefined )
//   return;
//
//   _.assert( arguments.length === 1, 'expects single argument' );
//   _.assert( definition.hasReferences === undefined || definition.hasReferences === 0 );
//
//   //
//
//   definition.hasReferences = 0;
//   if( definition.reuse )
//   {
//
//     if( definition.type || definition.elements )
//     throw _.err( 'definition cant has type/elements with reuse tags',definition.name );
//
//     definition.hasReferences += 1;
//
//   }
//
//   //
//
//   if( definition.elementProtos )
//   for( var e = 0 ; e < definition.elementProtos.length ; e++ )
//   {
//     var element = definition.elementProtos[ e ];
//     _.assert( _.numberIs( element.hasReferences ) );
//     definition.hasReferences += element.hasReferences;
//   }
//
//   return definition;
// }
//
// //
//
// function definitionNormalizeTypeCombination( definition,definitionDescriber )
// {
//   var self = this;
//
//   _.assert( 2 === arguments.length,'definitionNormalizeTypeCombination:','expects 2 arguments' )
//   _.assert( _.mapOwnKey( definition,{ type : 'type' } ) || _.mapOwnKey( definition,{ elements : 'elements' } ) );
//   _.assert( !_.numberIs( definition.id ) );
//
//   if( !definition.combination )
//   definition.combination = 'composition';
//
//   var typeElements = definition.type || definition.elements;
//   var elementProtos = definition.elementProtos = new typeElements.constructor( typeElements.length );
//   var e,element;
//
//   //
//
//   for( e = 0 ; e < typeElements.length ; e++ )
//   {
//
//     definition._elementIndex = e;
//     element = typeElements[ e ];
//
//     if( !element )
//     throw _.err( definition.name || definition.id,'missing',e,'element',_.toStr( definitionDescriber ) );
//
//     element = elementProtos[ e ] = self.definitionNormalizeRedefined( element,definition );
//     element.usedAsElement += 1;
//
//   }
//
//   //
//
//   delete definition._elementIndex;
//   delete definition.type;
//
//   _.assert( definition._elementIndex === undefined );
//   _.assert( definition.type === undefined );
//
//   return definition;
// }
//
// //
//
// function definitionNormalizeTypePrototype( definition,definitionDescriber )
// {
//   var self = this;
//
//   _.assert( arguments.length === 2, 'expects exactly two arguments' );
//   _.assert( _.objectIs( definition ) );
//   _.assert( _.mapOwnKey( definition,{ type : 'type' } ) );
//
//   var type = definition.type;
//   delete definition.type;
//   _.assert( definition.type  === undefined );
//
//   type = self.definitionNormalizeRedefined( type,definitionDescriber );
//
//   _.prototypeAppend( definition,type );
//
//   definition = self.definitionNormalizeType( definition,definitionDescriber );
//
//   return definition;
// }
//
// //
//
// function definitionNormalizeCounters( definition )
// {
//   var self = this;
//   var usedByInstances = definition.instanceIs ? 1 : 0;
//   var usedByDefinitions = 0;
//   var written = false;
//
//   _.assert( arguments.length === 1, 'expects single argument' );
//
//   while( definition !== Object.prototype )
//   {
//
//     if( written )
//     {
//
//       _.assert( _.mapOwnKey( definition,{ usedByDefinitions : 'usedByDefinitions' } ) );
//       _.assert( _.mapOwnKey( definition,{ usedByInstances : 'usedByInstances' } ) );
//       _.assert( _.mapOwnKey( definition,{ usedAsElement : 'usedAsElement' } ) );
//       _.assert( definition.usedByDefinitions >= 1 );
//
//     }
//     else if( !definition.instanceIs )
//     {
//
//       if( !_.mapOwnKey( definition,{ usedByDefinitions : 'usedByDefinitions' } ) )
//       definition.usedByDefinitions = 0;
//
//       if( !_.mapOwnKey( definition,{ usedByInstances : 'usedByInstances' } ) )
//       definition.usedByInstances = 0;
//
//       if( !_.mapOwnKey( definition,{ usedAsElement : 'usedAsElement' } ) )
//       definition.usedAsElement = 0;
//
//       definition.usedByDefinitions += usedByDefinitions;
//       definition.usedByInstances += usedByInstances;
//
//       if( usedByDefinitions )
//       written = true;
//
//       usedByDefinitions = 1;
//       usedByInstances = 0;
//
//     }
//
//     definition = definition.__proto__;
//
//   }
//
// }
//
// // --
// // mid
// // --
//
// function definitionSelect( options )
// {
//
//   _.assert( _.objectIs( options ) );
//   _.assert( _.strIs( options.query ) );
//   _.assert( arguments.length === 1, 'expects single argument' );
//
//   var self = this;
//   var query = options.query.split( '.' );
//   var parent = options.current;
//   var current = self.definitions;
//
//   if( !query[ 0 ] )
//   throw _.err( 'Not tested' );
//
//   debugger;
//
//   for( var q = 0 ; q < query.length ; q++ )
//   {
//
//     var select = _.strStrip( query[ q ] );
//
//     if( select === '^' )
//     {
//       current = parent;
//       parent = parent.describer;
//       _.assert( current,'cant get parent' );
//     }
//     else if( current === self.definitions )
//     {
//       parent = current;
//       current = current[ select ];
//       if( !current )
//       throw _.err( 'cant select',select,'from','global scope' );
//     }
//     else
//     {
//       for( var c = 0 ; c < current.elementProtos.length ; c++ )
//       if( current.elementProtos[ c ].name === select )
//       {
//         parent = current;
//         current = current.elementProtos[ c ];
//         break;
//       }
//       if( c === current.elementProtos.length )
//       throw _.err( 'cant select',select,'from',current._.nameCombinator );
//     }
//
//   }
//
//   if( current.instanceIs )
//   current = current.__proto__;
//
//   return current;
// }
//
// //
//
// function definitionResolveReferences( definition )
// {
//   var self = this;
//
//   _.assert( definition.instanceIs === undefined );
//   _.assert( _.numberIs( definition.id ) );
//   _.assert( _.numberIs( definition.hasReferences ) );
//
//   // reuse
//
//   if( definition.hasReferences === 0 )
//   return definition;
//
//   if( definition.reuse )
//   {
//
//     _.assert( _.strIs( definition.reuse ) );
//
//     var reuseDefinition = self.definitionSelect
//     ({
//       current : definition,
//       query : definition.reuse,
//     });
//
// /*
//     if( reuseDefinition.hasReferences !== 0 )
//     throw _.err( 'definitionResolveReferences','cant reference definition with unresolved references' );
// */
//
//     self.definitionEachDescriber( definition,function( d )
//     {
//       d.hasReferences -= 1;
//       _.assert( d.hasReferences >= 0, 'hasReferences must not be less zero' );
//     });
//
//     var proto = _.prototypeHasProperty( definition,{ reuse : 'reuse' } );
//     if( !( proto.hasReferences >= 0 ) )
//     throw _.err( 'something wrong with "hasReferences" of',proto.name )
//     delete proto.reuse;
//     _.assert( definition.reuse === undefined );
//
//     _.prototypeAppend( definition,reuseDefinition );
//     /*self.definitionNormalizeRelationship( definition );*/
//
//   }
//
//   //
//
//   if( definition.hasReferences === 0 )
//   return definition;
//
//   for( var e = 0 ; e < definition.elementProtos.length ; e++ )
//   {
//     var element = definition.elementProtos[ e ];
//     definition.elementProtos[ e ] = self.definitionResolveReferences( element );
//   }
//
//   _.assert( definition.hasReferences >= 0 );
//   _.assert( definition.reuse === undefined );
//
//   /* another instance with this definition as element could make resolution */
//
//   definition.hasReferences = 0;
//
//   return definition;
// }
//
// //
//
// function definitionEachDescriber( definition,onEach )
// {
//   var self = this;
//   _.assert( arguments.length === 2, 'expects exactly two arguments' );
//
//   while( definition )
//   {
//
//     onEach.call( self,definition );
//
//     definition = definition.describer;
//
//     _.assert( _.objectIs( definition ) || ( definition === null ) );
//
//   }
//
//   return self
// }
//
// //
//
// function definitionInstanceMake( definition,parent,index )
// {
//   var self = this;
//
// /*
//   if( definition._instancing )
//   return definition._instancing;
// */
//
//   _.assert( definition.instanceIs === undefined );
//   _.assert( _.numberIs( definition.id ) );
//
//   /*console.log( 'definitionInstanceMake:',definition.id );*/
//
//   var describerId = ( parent ? parent.id : '-root' ) + '-' + index;
//   definition._instances = definition._instances || {};
//
//   //if( describerId === '59-0' )
//   //debugger;
//
// /*
//   if( parent )
//   if( definition._instances[ describerId ] )
//   {
//     debugger;
//     definition._instances[ describerId ].counter += 1;
//     return definition._instances[ describerId ].instance;
//   }
// */
//
//   var definitionInstance = _.prototypeAppend( {},definition );
//   var instanceDescriptor = definition._instances[ describerId ] = {};
//   instanceDescriptor.instance = definitionInstance;
//   instanceDescriptor.counter = 1;
//
//   /*var definitionInstance = definition;*/
//   definitionInstance.instanceIs = true;
//
//   /*definition._instancing = definitionInstance;*/
//
//   if( definition.elementProtos )
//   {
//
//     /*var elements = definitionInstance.elements = new definition.elementProtos.constructor( definition.elementProtos.length );*/
//     var elements = definitionInstance.elements = new Array( definition.elementProtos.length );
//
//     for( var e = 0 ; e < definition.elementProtos.length ; e++ )
//     {
//       var proto = definition.elementProtos[ e ];
//       elements[ e ] = definitionInstanceMake( proto,definition,e );
//     }
//
//   }
//
// /*
//   delete definition._instancing;
// */
//
//   return definitionInstance;
// }
//
// // --
// // refine
// // --
//
// function definitionRefine( definition,definitionCombinator )
// {
//   var self = this;
//
//   _.assert( _.mapOwnKey( definition,{ instanceIs : 'instanceIs' } ) );
//   _.assert( definition.instanceIs );
//   _.assert( _.numberIs( definition.id ) );
//
//   if( definition._ )
//   {
//
//     _.assert( definition._instances[ definition.describer.id ] );
//     _.assert( definition._instances[ definition.describer.id ].counter > 1 );
//     debugger;
//     console.warn( 'reuse not implemented' );
//
//     if( !definition.size )
//     definition.size = [ 1,Infinity ];
//
//   }
//   else
//   {
//     self.definitionRefinePre( definition,definitionCombinator );
//     self.definitionRefineComponents( definition );
//   }
//
//   if( !definition._.windSize )
//   self.definitionRefinePost( definition,definitionCombinator );
//
// }
//
// //
//
// function definitionRefinePre( definition,definitionCombinator )
// {
//   var self = this;
//
//   var definitionCombinator = definitionCombinator || null;
//   var properties = {};
//   var reader = properties._reader = { value : _.mapExtend( null,definition._reader || {} ) };
//   var writer = properties._writer = { value : _.mapExtend( null,definition._writer || {} ) };
//   properties._ = { value : _.mapExtend( null,definition._ || {} ) };
//   Object.defineProperties( definition,properties );
//   definition.combinator = definitionCombinator;
//
//   // xxx
//
//   definition.__proto__.describer = definitionCombinator;
//
//   // relationship
//
//   self.definitionRefineRelationship( definition );
//
//   // name
//
//   _.assert( !_.mapOwnKey( definition._,{ nameCombinator : 'nameCombinator' } ) );
//   if( definition.combinator )
//   definition._.nameCombinator = definition.combinator._.nameCombinator + '.' + definition.name;
//   else
//   definition._.nameCombinator = definition.name;
//
//   /*_.assert( !_.mapOwnKey( definition.__proto__,{ nameDescriber : 'nameDescriber' } ) );*/
//   if( !_.mapOwnKey( definition.__proto__,{ nameDescriber : 'nameDescriber' } ) )
//   {
//     if( definition.__proto__.describer )
//     {
//       _.assert( _.strIs( definition.__proto__.describer.nameDescriber ) || _.numberIs( definition.__proto__.describer.nameDescriber ) );
//       _.assert( _.strIs( definition.__proto__.name ) || _.numberIs( definition.__proto__.name ) );
//       definition.__proto__.nameDescriber = definition.__proto__.describer.nameDescriber + '.' + definition.__proto__.name;
//     }
//     else
//     definition.__proto__.nameDescriber = definition.__proto__.name;
//   }
//
// }
//
// //
//
// function definitionRefinePost( definition,definitionCombinator )
// {
//   var self = this;
//
//   // accessors
//
//   self.definitionRefineAccessors( definition );
//
//   // size / tags
//
//   self.definitionRefineSizes( definition );
//   self.definitionRefineTags( definition );
//
//   // post verification
//
//   self.definitionRefinePostVerification( definition );
//
//   // freeze
//
//   Object.freeze( definition );
//
// }
//
// //
//
// function definitionRefineRelationship( definition )
// {
//   var self = this;
//
//   _.assert( arguments.length === 1, 'expects single argument' );
//   _.assert( definition.instanceIs === true );
//   _.assert( _.mapOwnKey( definition.__proto__,{ id : 'id' } ) );
//
//   // name
//
//   if( self.using.implicitElementNaming )
//   if( definition.__proto__.name === undefined && definition.__proto__.describer )
//   {
//     definition.__proto__.name = definition.__proto__.describer.elementProtos.indexOf( definition.__proto__ );
//     _.assert( definition.name >= 0 );
//   }
//
//   if( definition.unwrap && definition.array !== undefined )
//   {
//     var protoUnwrap = _.prototypeHasProperty( definition,{ unwrap : 'unwrap' } );
//     var protoArray = _.prototypeHasProperty( definition,{ array : 'array' } );
//     if( protoUnwrap === protoArray )
//     throw _.err( 'tags "unwrap=1" and "array" are not compatible in same definition:',definition.name );
//     if( _.prototypeHasPrototype( protoUnwrap,protoArray ) )
//     {
//       definition.unwrap = definition.unwrap;
//       definition.array = undefined;
//     }
//     else if( _.prototypeHasPrototype( protoArray,protoUnwrap ) )
//     {
//       definition.unwrap = undefined;
//       definition.array = definition.array;
//     }
//     else throw _.err( 'unexpected' );
//   }
//
//
//   if( definition.unwrap && definition.containerConstructor !== undefined )
//   throw _.err( 'tags "unwrap=1" and "containerConstructor" are not compatible' );
//
//   // unwrap
//
//   /*if( _.mapOwnKey( definition,{ unwrap : 'unwrap' }) )*/
//   if( definition.unwrap !== undefined )
//   definition.unwrap = !!definition.unwrap;
//   else
//   definition.unwrap = !definition.containerConstructor && definition.array === undefined && definition.combination !== 'composition';
//
//   // array
//
//   if( !definition.unwrap )
//   {
//
//     if( definition.array !== undefined )
//     definition.array = !!definition.array;
//     else if( definition.containerConstructor !== undefined )
//     definition.array = !!( definition.containerConstructor === Array || _.constructorIsBuffer( definition.containerConstructor ) );
//     else definition.array = true;
//
//   }
//
//   // containerConstructor
//
//   if( !definition.unwrap )
//   {
//
//     if( definition.containerConstructor !== undefined )
//     definition.containerConstructor = definition.containerConstructor;
//     else
//     definition.containerConstructor = definition.array ? Array : Object;
//
//   }
//
// }
//
// //
//
// function definitionRefineComponents( definition )
// {
//   var self = this;
//
//   if( !definition.elements ) return;
//
//   _.assert( 1 === arguments.length,'definitionNormalizeTypeCombination:','expects 2 arguments' )
//
//   //
//
//   var elements = definition.elements;
//   var combination = definition.combination;
//   var e,element;
//
//   var lookSize = [ 0,0 ];
//   var windSize = [ 0,0 ];
//
//   if( combination === 'alteration' && elements.length > 0 )
//   {
//     lookSize[ 0 ] = +Infinity;
//     windSize[ 0 ] = +Infinity;
//   }
//
//   //
//
//   function considerSize( size,elementSize )
//   {
//
//     if( combination === 'composition' )
//     {
//       if( _.numberIs( elementSize ) )
//       {
//         size[ 0 ] += elementSize;
//         size[ 1 ] += elementSize;
//       }
//       else
//       {
//         size[ 0 ] += elementSize[ 0 ];
//         size[ 1 ] += elementSize[ 1 ];
//       }
//     }
//     else if( combination === 'alteration' )
//     {
//       if( _.numberIs( elementSize ) )
//       {
//         size[ 0 ] = Math.min( size[ 0 ],elementSize );
//         size[ 1 ] = Math.max( size[ 1 ],elementSize );
//       }
//       else
//       {
//         size[ 0 ] = Math.min( size[ 0 ],elementSize[ 0 ] );
//         size[ 1 ] = Math.max( size[ 1 ],elementSize[ 1 ] );
//       }
//     }
//
//   }
//
//   //
//
//   function considerCompositionLookSize()
//   {
//
//     var size = windSize.slice();
//
//     if( _.numberIs( element._.lookSize ) )
//     {
//       size[ 0 ] += element._.lookSize;
//       size[ 1 ] += element._.lookSize;
//     }
//     else
//     {
//       size[ 0 ] += element._.lookSize[ 0 ];
//       size[ 1 ] += element._.lookSize[ 1 ];
//     }
//
//     if( e === 0 )
//     {
//       lookSize[ 0 ] = size[ 0 ];
//       lookSize[ 1 ] = size[ 1 ];
//     }
//     else
//     {
//       lookSize[ 0 ] = Math.max( lookSize[ 0 ],size[ 0 ] );
//       lookSize[ 1 ] = Math.max( lookSize[ 1 ],size[ 1 ] );
//     }
//
//   }
//
//   //
//
//   for( e = 0 ; e < elements.length ; e++ )
//   {
//
//     element = elements[ e ];
//
//     self.definitionRefine( element,definition );
//
//     if( combination === 'alteration' )
//     considerSize( lookSize,element._.lookSize );
//     else
//     considerCompositionLookSize();
//
//     considerSize( windSize,element._.windSize );
//
//   }
//
//   // look size
//
//   lookSize[ 0 ] = Math.max( windSize[ 0 ],lookSize[ 0 ] );
//   lookSize[ 1 ] = Math.max( windSize[ 1 ],lookSize[ 1 ] );
//
//   var sameSize = ( lookSize[ 0 ] === windSize[ 0 ] ) && ( lookSize[ 1 ] === windSize[ 1 ] );
//
//   if( isNaN( lookSize[ 0 ] ) || isNaN( lookSize[ 1 ] ) )
//   throw _.err( 'wParaser:','cant determine size of combination' );
//
//   if( lookSize[ 0 ] === lookSize[ 1 ] )
//   lookSize = lookSize[ 0 ];
//
//   if( sameSize )
//   {
//     if( definition.__proto__.size === undefined )
//     definition.__proto__.size = lookSize;
//     else if( !_._entityEqual( definition.size, lookSize ) )
//     throw _.err( 'wParser:','recalculated size differ for definition',self.definitionToStr( definition ) );
//   }
//   else
//   {
//     if( definition.__proto__.lookSize === undefined )
//     definition.__proto__.lookSize = lookSize;
//     else if( !_._entityEqual( definition.lookSize, lookSize ) )
//     throw _.err( 'wParser:','recalculated size differ for definition',self.definitionToStr( definition ) );
//   }
//
//   // wind size
//
//   if( !sameSize )
//   {
//
//     if( isNaN( windSize[ 0 ] ) || isNaN( windSize[ 1 ] ) )
//     throw _.err( 'wParaser:','cant determine size of combination' );
//
//     if( windSize[ 0 ] === windSize[ 1 ] )
//     windSize = windSize[ 0 ];
//
//     if( definition.__proto__.windSize === undefined )
//     definition.__proto__.windSize = windSize;
//     else if( !_._entityEqual( definition.windSize, windSize ) )
//     throw _.err( 'wParser:','recalculated size differ for definition',self.definitionToStr( definition ) );
//
//   }
//
// }
//
// //
//
// function definitionRefineAccessors( definition )
// {
//   var self = this;
//
//   if( !_.objectIs( definition ) )
//   throw _.err( 'wStream.bindAccessor','expects definition as argument',definition );
//   if( definition.name === undefined )
//   throw _.err( 'wStream.bindAccessor','definition has no name',definition );
//
//   var name = definition.name;
//   var size = definition.size;
//
//   var reader = definition._reader;
//   var writer = definition._writer;
//
//   var hasReader = definition.read || definition.get || definition.getView;
//   var hasWriter = definition.write || definition.set || definition.setView;
//
//   var bufferType = definition.bufferType /*|| Uint8Array*/; // xxx
//   var getBuffer = definition.getBuffer;
//
//   var get = definition.get;
//   var getView = definition.getView;
//   var read = definition.read;
//
//   var set = definition.set;
//   var setView = definition.setView;
//   var write = definition.write;
//   var writes = definition.writes;
//
//   //
//
//   if( !get ) get = ( function()
//   {
//
//     if( read ) return function getWithRead()
//     {
//
//       var result;
//       var position = this._pos;
//
//       throw _.err( 'Not tested' );
//
//       //if( this._pos + definition.size > this.buffer.byteLength )
//       //return;
//       //throw wParser.err( 'wStream.getWithRead: out of bound' );
//
//       result = read.call( this );
//
//       if( result === undefined )
//       this._pos = position;
//
//       return result;
//     }
//     else if( getView && _.numberIs( size ) ) return function getWithGetView()
//     {
//
//       if( this._pos + size > this.buffer.byteLength )
//       return;
//
//       var result = getView.call( this._view, this._pos, this.littleEndian );
//       return result;
//
//     }
//     else if( !definition.combination )
//     throw _.err( 'wParser.definitionRefineAccessors:','definition has nor "read", neither "type"',self.definitionToStr( definition ) );
//
//   })();
//
//   //
//
//   if( !read && get && _.numberIs( size ) ) read = ( function()
//   {
//
//     if( get ) return function readWithGet()
//     {
//
//       var result = get.call( this );
//       this._pos += size;
//       return result;
//
//     }
//     else if( !definition.combination ) throw _.err( 'wStream.bindAccessor:','definition has nor "get", neither "type"',definition );
//
//   })();
//
//   //
//
//   if( !getBuffer && bufferType ) getBuffer = function getBuffer()
//   {
//     var result = new bufferType( this.buffer );
//     return result;
//   }
//
//   //
//
//   if( !set && setView ) set = function setWithSetView( src )
//   {
//
//     if( this._pos + size > this.size )
//     throw _.err( 'wStream:','out of bound' );
//     setView.call( this._view, this._pos, src, this.littleEndian );
//
//   }
//
//   //
//
//   if( !write && set && _.numberIs( size ) )
//   {
//     write = function write( src )
//     {
//
//       this.grow( size );
//       set.call( this,src );
//       this._pos += size;
//
//     }
//   }
//
//   //
//
//   if( !writes && set && _.numberIs( size ) )
//   {
//     writes = function writes()
//     {
//
//       for( var a = 0 ; a < arguments.length ; a++ )
//       {
//
//         debugger;
//
//         var argument = arguments[ a ];
//         argument = _.arrayAs( argument );
//
//         this.grow( size*argument.length );
//         for( var s = 0,sl = argument.length ; s < sl ; s++ )
//         {
//           set.call( this,argument[ s ] );
//           this._pos += size;
//         }
//
//       }
//
//     }
//   }
//
//   // set
//
//   if( hasReader )
//   {
//     if( getBuffer )
//     definition._reader.getBuffer = getBuffer;
//     if( getView )
//     definition._reader.getView = getView;
//     if( get )
//     definition._reader.get = get;
//     if( read )
//     definition._reader.read = read;
//   }
//
//   if( hasWriter )
//   {
//     if( setView )
//     definition._writer.setView = setView;
//     if( set )
//     definition._writer.set = set;
//     if( write )
//     definition._writer.write = write;
//     if( writes )
//     definition._writer.writes = writes;
//   }
//
// }
//
// //
//
// function definitionRefineSizes( definition )
// {
//   var self = this;
//
//   if( definition.lookSize !== undefined )
//   definition._.lookSize = definition.lookSize;
//   else if( definition.size !== undefined )
//   definition._.lookSize = definition.size;
//
//   if( _.numberIs( definition._.lookSize ) ) definition._.lookSize = [ definition._.lookSize,definition._.lookSize ];
//   else definition._.lookSize = definition._.lookSize.slice();
//
//   if( isNaN( definition._.lookSize[ 0 ] ) || isNaN( definition._.lookSize[ 1 ] ) )
//   throw _.err( 'lookSize of definition',_.toStr( definition ),'is not regular',_.toStr( lookSize ) );
//
//   if( definition.windSize !== undefined )
//   definition._.windSize = definition.windSize;
//   else if( definition.size !== undefined )
//   definition._.windSize = definition.size;
//   if( _.numberIs( definition._.windSize ) ) definition._.windSize = [ definition._.windSize,definition._.windSize ];
//   else definition._.windSize = definition._.windSize.slice();
//
//   if( isNaN( definition._.windSize[ 0 ] ) || isNaN( definition._.windSize[ 1 ] ) )
//   throw _.err( 'windSize of definition',_.toStr( definition ),'is not regular',_.toStr( windSize ) );
//
// }
//
// //
//
// function definitionRefineTags( definition )
// {
//   var self = this;
//
//   if( definition.forward && definition.backward )
//   throw _.err( 'wParser.compileDefinitionTags:','can use only one tag "forward" / "backward"' );
//
//   //
//
//   var t = 0;
//   function normalizeNextDefinition()
//   {
//
//     var tag = self.tagsNormalizeList[ t ];
//     t += 1;
//
//     if( t <= self.tagsNormalizeList.length )
//     tag.tagNormalize.call( self,tag,definition,normalizeNextDefinition );
//
//     if( t <= self.tagsNormalizeList.length )
//     normalizeNextDefinition();
//
//   }
//
//   normalizeNextDefinition();
//
// }
//
// //
//
// function definitionRefinePostVerification( definition )
// {
//   var self = this;
//
//   _.assertMapHasOnly( definition,self.tokenMap,'definition has redundant $fields: ' + definition._.nameCombinator );
//   _.assertMapHasAll( definition,self.tokenMandatory,'definition has redundant $fields: ' + definition._.nameCombinator );
//
//   if( definition.reuse !== undefined )
//   throw _.err( 'reuse of',definition.name,'is not resolved' );
//
//   _.assert( definition._.lookSize !== undefined,'definition needs "lookSize"',definition._.nameCombinator );
//   _.assert( definition._.windSize !== undefined,'definition needs "windSize"',definition._.nameCombinator );
//
//   _.assert( _.strIs( definition.name ) || _.numberIs( definition.name ),'definition should has name' );
//   _.assert( !_.strIs( definition.name ) || definition.name.indexOf( '.' ) === -1,'definition name should not has forbidden symbols( . ): ' + definition._.nameCombinator );
//
// }
//
// // --
// // var
// // --
//
// var tokenMandatory =
// {
//
//   id : 'id',
//   name : 'name',
//
// }
//
// var tokenDerivativeMap =
// {
//
//   id : 'id',
//   nameDescriber : 'nameDescriber',
//   elementProtos : 'elementProtos',
//   elements: 'elements',
//
//   combinator : 'combinator',
//   /*target : 'target',*/
//
//   describer : 'describer',
//
//   indexLocal : 'indexLocal',
//   instanceIs : 'instanceIs',
//   usedByDefinitions : 'usedByDefinitions',
//   usedByInstances : 'usedByInstances',
//   usedAsElement : 'usedAsElement',
//   hasReferences : 'hasReferences',
//
//   _elementIndex : '_elementIndex',
//   _instances : '_instances',
//
//   _ : '_',
//   _reader : '_reader',
//   _writer : '_writer',
//
// }
//
// var tokenAttributeMap =
// {
//
//   name : 'name',
//   shortName : 'shortName',
//   type : 'type',
//   size : 'size',
//   lookSize: 'lookSize',
//   windSize: 'windSize',
//   bufferType : 'bufferType',
//   containerConstructor : 'containerConstructor',
//
//   unwrap : 'unwrap',
//   array : 'array',
//   //combination : 'combination',
//
// }
//
// var tokenTerminalMethodMap =
// {
//
//   read : 'read',
//   getView : 'getView',
//   setView : 'setView',
//   getBuffer : 'getBuffer',
//   get : 'get',
//   set : 'set',
//   write : 'write',
//   writes : 'writes',
//   generate : 'generate',
//
// }
//
// // --
// // declare
// // --
//
// var Proto =
// {
//
//
//   // normalize
//
//   definitionNormalize: definitionNormalize,
//   definitionNormalizeRedefined: definitionNormalizeRedefined,
//
//   definitionNormalizeType: definitionNormalizeType,
//   definitionNormalizeTypeCombination: definitionNormalizeTypeCombination,
//   definitionNormalizeTypePrototype: definitionNormalizeTypePrototype,
//
//   definitionNormalizeReferenceCounter: definitionNormalizeReferenceCounter,
//
//   definitionNormalizeCounters: definitionNormalizeCounters,
//
//
//   // mid
//
//   definitionSelect: definitionSelect,
//
//   definitionResolveReferences: definitionResolveReferences,
//
//   definitionEachDescriber: definitionEachDescriber,
//
//   definitionInstanceMake: definitionInstanceMake,
//
//
//   // refine
//
//   definitionRefine: definitionRefine,
//   definitionRefinePre: definitionRefinePre,
//   definitionRefinePost: definitionRefinePost,
//
//   definitionRefineRelationship: definitionRefineRelationship,
//
//   definitionRefineComponents: definitionRefineComponents,
//   definitionRefineAccessors: definitionRefineAccessors,
//   definitionRefineSizes: definitionRefineSizes,
//   definitionRefineTags: definitionRefineTags,
//
//   definitionRefinePostVerification: definitionRefinePostVerification,
//
//
//   // var
//
//   tokenMandatory: tokenMandatory,
//   tokenDerivativeMap: tokenDerivativeMap,
//   tokenAttributeMap: tokenAttributeMap,
//   tokenTerminalMethodMap: tokenTerminalMethodMap,
//
// }
//
// //
//
// _.mapExtend( Self.prototype,Proto );
// _.mapExtend( Self,Proto );
//
// return Self;
//
// })();
