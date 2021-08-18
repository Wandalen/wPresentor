( function _Tabs_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wLogger' );

}

//

var _ = _global_.wTools;
var Parent = null;
var Self = function wHiTabsManager( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return Self._make( o );
  return Self.prototype.init.apply( this,arguments );
}

Self.shortName = 'TabsManager';

//

function init( o )
{
  var group = this;

  _.instanceInit( group );
  Object.preventExtensions( group );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( !Object.isExtensible( group ) );

  if( o )
  group.copy( o );

}

//

function _make( o )
{
  throw _.err( 'not implemented' );
}

_make.defaults =
{
  name : 'global',
}

//

function deactivate()
{
  var group = this;

  _.assert( arguments.length === 0 );

  group.activeTabName = null;
  group.activeButton = null;
  group.activeForm = null;

  return group;
}

//

function _activate( o )
{
  var group = this;

  _.assert( arguments.length === 1 );
  _.assert( o.formDom.length,'no form for tab',_.strQuote( o.tabName ) );

  throw _.err( 'not implemented' );

}

_activate.defaults =
{
  tabName : null,
  buttonDom : null,
  formDom : null,
}

//

function activateWithName( tabName )
{
  var group = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( tabName ) );

  throw _.err( 'not implemented' );

  group._activate
  ({
    tabName : tabName,
    buttonDom : buttonDom,
    formDom : formDom,
  });

  return group;
}

//

function activate( tab )
{
  var group = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( tab ) );

  // debugger;

  group.activateWithName( tab );

  // debugger;

  return group;
}

// --
// relations
// --

var Composes =
{

  activeTabName : null,

}

var Associates =
{
}

var Restricts =
{
  name : null,
}

var Medials =
{
  name : null,
}

var Statics =
{
  usingUniqueNames : 1,
  _make : _make,
}

var Events =
{
  tabActivate : 'tabActivate',
}

// --
// proto
// --

var Proto =
{

  init : init,
  _make : _make,

  deactivate : deactivate,

  _activate : _activate,

  activateWithName : activateWithName,
  activate : activate,


  // relations

  /* constructor * : * Self, */
  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,
  Medials : Medials,
  Statics : Statics,
  Events : Events,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.EventHandler.mixin( Self );
_.Instancing.mixin( Self );

//

_.hi = _.hi || Object.create( null );
_global_[ Self.name ] = _.hi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
