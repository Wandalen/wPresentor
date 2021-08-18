(function _CollectionOfInstances_s_() {

'use strict';

var _ = _global_.wTools;
var Parent = null;
var Self = function wCollectionOfInstances( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'CollectionOfInstances';

// --
// routines
// --

function init( o )
{

  var self = this;

  _.instanceInit( self );

  if( self.Self === Self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

}

//

function append( instance )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.strIsNotEmpty( instance.name ) );
  _.assert( !self._descriptorsMap[ instance.name ],'already has instance with name',instance.name );

  return self.descriptorMake( instance,instance.name );
}

//

function descriptorsMake( instances )
{
  var self = this;
  var result = [];

  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.objectIs( self ) );
  _.assert( _.mapIs( instances ) );

  for( var key in instances )
  {
    var instance = instances[ key ];
    var made = self.descriptorMake( instance,key );
    if( made.new )
    result.push( made.descriptor );
  }

  return result;
}

//

function descriptorMake( instance,name )
{
  var self = this;
  var result = Object.create( null );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( self ) );
  _.assert( _.objectIs( instance ) );

  /* */

  // debugger; // instanceCounter !!!
  var id = self._instancesArray.indexOf( instance );

  if( id === -1 )
  {
    var id = self._instancesArray.length;
  }
  else
  {
    _.assert( self._descriptorsArray[ id ].instance === instance,'instance replacement' );
  }

  /* */

  if( self._descriptorsArray[ id ] )
  {
    var descriptor = self._descriptorsArray[ id ];
    _.assert( descriptor.instance === instance,'instance id',id,'already useв by another instance' );
    result.descriptor = descriptor;
    result.new = false;
    return result
  }

  /* name */

  if( name === undefined )
  name =  self.name + '-' + id;
  _.assert( _.strIsNotEmpty( name ) );

  if( Config.debug )
  for( var d in self._descriptorsArray )
  {
    _.assert( self._descriptorsArray[ d ].name !== name,'descriptorMake:','instance wit name','"'+name+'"','already registered' );
  }

  /* */

  result.descriptor = self._descriptorMakeAct( instance,name,id );
  result.new = true;

  _.assert( !self._descriptorsMap[ name ] );
  _.assert( !self._instancesMap[ name ] );

  self._descriptorsMap[ name ] = result.descriptor;
  self._instancesMap[ name ] = instance;

  return result;
}

//

function _descriptorMakeAct( instance,name,id )
{
  var self = this;

  _.assert( arguments.length === 3, 'expects exactly three argument' );
  _.assert( _.objectIs( self ) );
  _.assert( _.objectIs( instance ) );
  _.assert( _.strIs( name ) );

  /* */

  if( self.instanceMustHave )
  {
    for( var i in self.instanceMustHave )
    {
      _.assert( instance[ i ] === self.instanceMustHave[ i ] || instance[ i ] === null || instance[ i ] === undefined );
      instance[ i ] = self.instanceMustHave[ i ];
    }
  }

  /* */

  var descriptor = Object.create( null );
  descriptor.code = self.codeMake( name,id );
  descriptor.name = name;
  descriptor.id = id;
  descriptor.instance = instance;
  descriptor.sub = name.indexOf( '.' ) !== -1;

  _.accessorForbid( descriptor,
  {
    key : 'key',
  });

  // instance counter !!!

  self._descriptorsArray.push[ id ] = descriptor;
  self._instancesArray[ id ] = instance;

  return descriptor;
}

//

function descriptorWithInstanceGet( instance )
{
  var self = this;
  _.assert( arguments.length === 1, 'expects single argument' );

  var index = self._instancesArray.indexOf( instance );

  if( index === -1 )
  return null;

  var result = self._descriptorsArray[ index ];

  _.assert( !!result );

  return result;
}

//

function descriptorWithCodeGet( code )
{
  var self = this;
  _.assert( arguments.length === 1, 'expects single argument' );

  for( var id = 0 ; id < self._descriptorsArray.length ; id++ )
  {
    var descriptor = self._descriptorsArray[ id ];

    if( descriptor.code === code )
    return descriptor;
  }

  return null;
}

//

function descriptorsFilter( selector )
{
  var self = this;

  _.assert( arguments.length === 1, 'expects single argument' );

  var result = _.entityFilter( self._descriptorsArray,selector );

  if( result.length )
  debugger;

  return result;
}

//

function _descriptorsMapGet()
{
  debugger
  var self = this;
  return _.ifDebugProxyReadOnly( self._descriptorsMap );
}

// --
//
// --

function instanceWithName( name )
{
  var self = this;

  _.assert( _.strIs( name ) );
  _.assert( arguments.length === 1, 'expects single argument' );

  debugger;

  return self._descriptorsMap[ name ].instance;
}

//

function _instancesMapGet()
{
  var self = this;
  return _.ifDebugProxyReadOnly( self._instancesMap );
}

// --
//
// --

function codeMake( name,id )
{
  var self = this;
  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( id !== undefined )
  return '+++' + self.name + '+++' + name + '+' + id + '+++';
  else
  return '+++' + self.name + '+++' + name + '+' + id + '+++';
}

//

function codeIs( question )
{
  var self = this;

  if( !_.strIs( question ) ) return false;
  return _.strBegins( question, '+++' + self.name + '+++' ) && _.strEnds( question, '+++' );
}

// --
// relationship
// --

var Composes =
{
  name : 'instance',
  _instancesArray : _.define.own( [] ),
  _instancesMap : _.define.own( {} ),
  _descriptorsArray : _.define.own( [] ),
  _descriptorsMap : _.define.own( {} ),
  instanceCounter : 0,
  instanceMustHave : null,
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
}

var Forbids =
{
}

var ReadOnly =
{
  descriptorsMap : { readOnlyProduct : 1 },
  instancesMap : { readOnlyProduct : 1 },
}

var Accessors =
{
}

// --
// declare
// --

var Proto =
{

  init : init,

  //

  append : append,

  descriptorsMake : descriptorsMake,
  descriptorMake : descriptorMake,
  _descriptorMakeAct : _descriptorMakeAct,

  descriptorWithInstanceGet : descriptorWithInstanceGet,
  descriptorWithCodeGet : descriptorWithCodeGet,
  descriptorsFilter : descriptorsFilter,
  _descriptorsMapGet : _descriptorsMapGet,

  instanceWithName : instanceWithName,
  _instancesMapGet : _instancesMapGet,

  codeMake : codeMake,
  codeIs : codeIs,

  // relations


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

//

_.Copyable.mixin( Self );

//

_.accessorForbid( Self.prototype,Forbids );
_.accessorReadOnly( Self.prototype,ReadOnly );
_.accessor( Self.prototype,Accessors );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_global_[ Self.name ] = _[ Self.shortName ] = Self;

})();
