
HookBuffersAllocation =
(function(){

'use strict';

var _ = _global_.wTools;

//

function hookBuffer( name,originalConstructor )
{
  var self = this;
  var total = 0;

  if( !originalConstructor )
  originalConstructor = _global_[ name ];

  _global_[ name ] = function constructor()
  {

    var length = 0;

    if( _.numberIs( arguments[ 0 ] ) )
    length = arguments[ 0 ];
    else if( _.longIs( arguments[ 0 ] ) )
    length = arguments[ 0 ].length;
    //else if( arguments.length >= 3 && _.numberIs( arguments[ 2 ] ) )
    //length = arguments[ 2 ].length;

    var size = length * ( originalConstructor.BYTES_PER_ELEMENT || 1 );

    total += size;

    _.assert( !isNaN( total ) && !isNaN( size ),'HookBuffersAllocation:','Something wrong' );

    var msg = [ 'Allocated',name,'of size',size,'length',length,'total',total ];

    if( size >= self.logStackMinimalSize )
    {

      var stack = _.diagnosticStack();

      console.log( msg.join( ' ' ),stack );

    }
    else if( size >= self.logMinimalSize )
    {

      console.log( msg.join( ' ' ) );

    }

    if( size >= self.logMinimalSize && self.memoryUsage && typeof process !== 'undefined' )
    {
      var memoryUsage = process.memoryUsage();
      console.log( 'memoryUsageBefore:',_.toStr( memoryUsage ) );
    }

    debugger;
    var result = new( Function.prototype.bind.apply( originalConstructor, _.arrayAppendArrays( [],[ originalConstructor,arguments ] ) ) );

    if( size >= self.logMinimalSize && self.memoryUsage && typeof process !== 'undefined' )
    {
      var memoryUsage = process.memoryUsage();
      console.log( 'memoryUsageAfter:',_.toStr( memoryUsage ) );
    }

    return result;
  }

  _global_[ name ].prototype = originalConstructor.prototype;

}

//

function hookBuffers()
{

  for( var b in bufferMap )
  this.hookBuffer( b,bufferMap[ b ] );

}

// var

var bufferMap =
{

  'ArrayBuffer' : ArrayBuffer,
  'Int8Array' : Int8Array,
  'Uint8Array' : Uint8Array,
  'Uint8ClampedArray' : Uint8ClampedArray,
  'Int16Array' : Int16Array,
  'Uint16Array' : Uint16Array,
  'Int32Array' : Int32Array,
  'Uint32Array' : Uint32Array,
  'Float32Array' : Float32Array,
  'Float64Array' : Float64Array,

}

// -- proto

var Self =
{

  // routine

  hookBuffer: hookBuffer,
  hookBuffers: hookBuffers,

  // var

  bufferMap: bufferMap,
  logMinimalSize: 0,
  logStackMinimalSize: Infinity,
  memoryUsage: 1,

}

return Self;

})();
