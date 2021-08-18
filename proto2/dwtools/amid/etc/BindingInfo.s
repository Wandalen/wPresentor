(function _BindingInfo_s_() {

'use strict';

let _ = wTools;

//

let Parent = null;
let Self = function wBindingInfo( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'BindingInfo';

// --
// info
// --

/*

let PlatformInfo =
{
  'NAME' : { id : 'PLATFORM_NAME' , verbal : 1 },
  'VERSION' : { id : 'PLATFORM_VERSION' , verbal : 0 },
}

let info = _.BindingInfo
({
  srcObject : platform,
  infoMap : PlatformInfo,
  getter : _.routineJoin( cl,cl.getPlatformInfo ),
  container : cl,
});

*/

/*

_.BindingInfo
({
  srcObject : platform,
  infoMap : PlatformInfo,
  getter : _.routineJoin( cl,cl.getPlatformInfo ),
  container : cl,
});

*/

//

function init( o )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.instanceInit( self );

  if( self.Self === Self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  self.infoMapRefine();

}

//

function infoMapRefine()
{
  let self = this;
  let map = self.infoMap;

  for( let m in map )
  {
    let field = map[ m ]
    self.infoFieldRefine( field );
  }

}

//

function infoFieldRefine( field )
{
  let self = this;

  let FieldHasOnly =
  {
    name : null,
    verbosity : null,
    format : null,
  }

  let FieldHasAll =
  {
    name : null,
  }

  let FieldSupplement =
  {
    verbosity : self.verbosity,
  }

  if( field.v !== undefined )
  {
    field.verbosity = field.v;
    delete field.v;
  }

  if( field.n !== undefined )
  {
    field.name = field.n;
    delete field.n;
  }

  _.assertMapHasOnly( field, FieldHasOnly );
  _.assertMapHasAll( field, FieldHasAll );
  _.mapSupplement( field, FieldSupplement )

  Object.freeze( field );

  return field;
}

//

function print( srcObject, verbosity )
{
  let self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  let o = Object.create( null );
  o.srcObject = srcObject;
  o.verbosity = verbosity;
  if( o.verbosity === undefined )
  o.verbosity = self.verbosity;

  let info = self.infoGet( o );

  function printInfo( info )
  {

    if( !o.verbosity )
    return;

    logger.topic( self.name );
    // logger.log( self.name );

    for( let i in info )
    {
      let tname;
      let fname = i;
      if( self.withColor )
      fname = _.color.strFormat( fname, { fg : 'bright black' } );
      if( self.withType )
      {
        tname = _.strTypeOf( info[ i ] );
        if( self.withColor )
        tname = _.color.strFormat( tname, { fg : 'dark magenta' } );
      }
      let val = _.toStr( info[ i ] );
      if( self.withType )
      logger.log( '  ' + fname + ' : ' + tname + ' : ' + val );
      else
      logger.log( '  ' + fname + ' : ' + val );
    }

    // logger.log();
  }

  /* */

  if( _.arrayIs( srcObject ) )
  {
    _.assert( _.arrayIs( info ) );
    for( let d = 0 ; d < srcObject.length ; d++ )
    printInfo( info[ d ] );
  }
  else
  {
    _.assert( _.objectIs( info ) );
    printInfo( info );
  }

}

//

function _infoGet( o )
{
  let self = this;

  let infoMap = self.infoMap;
  let getter = self.getter;
  let container = self.container;
  let result = Object.create( null );

  o = _.routineOptions( _infoGet, arguments );
  _.assert( arguments.length === 1, 'expects single argument' );
  _.assert( _.objectIs( o.srcObject ) );

  /* */

  function get( name, field )
  {

    if( field.verbosity > o.verbosity )
    return;

    if( field.name === undefined || container[ field.name ] === undefined )
    {
      result[ name ] = null;
      return;
    }

    result[ name ] = getter( o.srcObject, container[ field.name ] );

    if( field.format )
    result[ name ] = field.format( result[ name ] );

  }

  /* */

  for( let name in infoMap )
  try
  {
    get( name, infoMap[ name ] );
  }
  catch( err )
  {
    debugger;
    try
    {
      get( name, infoMap[ name ] );
    }
    catch( err2 )
    {
    }
    result[ name ] = _.errBriefly( 'Cant get field', name, '\n', err );
  }

  return result;
}

_infoGet.defaults =
{
  srcObject : null,
  verbosity : 2,
}

//

function infoGet( o )
{
  let self = this;

  // _.assert( arguments.length === 1 || arguments.length === 2 );
  //
  // o = o || Object.create( null );
  // o.srcObject = srcObject;
  // o.verbosity = verbosity;
  // if( o.verbosity === undefined )
  // o.verbosity = self.verbosity;

  o = _.routineOptions( _infoGet, arguments );

  try
  {

    if( _.arrayIs( o.srcObject ) )
    {
      let result = [];
      for( let s = 0 ; s < o.srcObject.length ; s++ )
      result[ s ] = self._infoGet( _.mapExtend( null, o, { srcObject : o.srcObject[ s ] } ) );
      return result;
    }
    else
    {
      let result = self._infoGet( o );
      return result;
    }

  }
  catch( err )
  {
    err = _.errLogOnce( err );
    return err.originalMessage;
  }

}

infoGet.defaults = Object.create( _infoGet.defaults );

// --
// relations
// --

let Composes =
{

  name : null,
  getter : null,
  verbosity : 9,
  withType : 1,
  withColor : 1,

}

let Aggregates =
{
  infoMap : null,
}

let Associates =
{
  container : null,
}

let Restricts =
{
}

let Statics =
{
}

let Accessors =
{
}

// --
// declare
// --

let Proto =
{

  // routines

  init : init,

  infoMapRefine : infoMapRefine,
  infoFieldRefine : infoFieldRefine,

  print : print,
  _infoGet : _infoGet,
  infoGet : infoGet,

  // relations

  
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Accessors : Accessors,

}


//

_.classDeclare
({
  cls : Self,
  extend : Proto,
  parent : Parent,
});

wCopyable.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
_global_[ Self.name ] = wTools[ Self.shortName ] = Self;

})();
