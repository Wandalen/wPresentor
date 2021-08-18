( function _TabsGraphical_s_() {

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

/**
 * wGhiTabsManager - graphical human interface class to manage switches between tabs.
 * @class wGhiTabsManager
 */

var $ = typeof jQuery !== 'undefined' ? jQuery : null;
var _ = _global_.wTools;
var Parent = _.hi.TabsManager;
var Self = function wGhiTabsManager( o )
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

/**
 * Initialize object.
 * @param {object} o - options.
 * @method init
 * @memberof wGhiTabsManager#
 */

function init( o )
{
  var group = this;

  Parent.prototype.init.apply( group,arguments );

  _.assert( !Object.isExtensible( group ) );

}

//

function _make( o )
{
  var group;

  // if( o && !_.mapIs( o ) )
  // o = { targetDom : o };

  o = o || {};

  _.mapComplement( o,_make.defaults );
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.strIsNotEmpty( o.name ) );

  if( !Self.instancesMap[ o.name ] )
  {
    group = new Self( o );
    group.form();
  }
  else
  {
    group = Self.instancesMap[ o.name ];
    Self.instancesMap[ o.name ].copy( o );
  }

  return group;
}

_make.defaults =
{
  name : 'global',
  // targetDom : 'body',
  // buttonsSelector : 'a[data-tab]:not( .disabled )',
  // pagesSelector : 'form[data-tab]:not( .disabled )',
}

// _make.defaults.__proto__ = form.defaults;

//

function unform()
{
  var group = this;

  _.assert( group._formed );

  group.buttonDoms.off( _.eventName( 'click' ) + '.' + Self.shortName );
  if( group.moreButtonDom )
  group.moreButtonDom.off( _.eventName( 'click' ) + '.' + Self.shortName );

  group._formed = 0;

  return group;
}

//

function form()
{
  var group = this;

  if( group._formed )
  group.unform();

  _.assert( arguments.length === 0 );
  _.assert( !!group );
  _.assert( group.targetDom.length );
  _.assert( !group._formed );
  // _.routineOptions( form,o );

  group.targetDom = $( group.targetDom );

  var buttonDoms = group.targetDom.find( group.buttonsSelector ).addBack( group.buttonsSelector );
  var pagesDoms = group.targetDom.find( group.pagesSelector ).addBack( group.pagesSelector );

  // if( group.buttonDoms )
  // group.buttonDoms = group.buttonDoms.add( buttonDoms );
  // else
  group.buttonDoms = buttonDoms;

  // if( group.pagesDoms )
  // group.pagesDoms = group.pagesDoms.add( pagesDoms );
  // else
  group.pagesDoms = pagesDoms;

  /* */

  if( group.pagesParentDom )
  {
    group.pagesParentDom = $( group.pagesParentDom );
    _.assert( group.pagesParentDom.length );
    pagesDoms = group.pagesParentDom.find( group.pagesSelector ).addBack( group.pagesSelector );
    group.pagesDoms = group.pagesDoms.add( pagesDoms );
  }

  /* */

  if( Config.debug )
  {
    group._pagesCheck();
  }

  group._pagesFilterOut();

  /* */

  if( group.usingMoreButton )
  {
    group._formMore();
  }
  else
  {
    if( group.moreButtonSelector )
    {
      var moreButton = group.buttonDoms.filter( group.moreButtonSelector );
      moreButton.css( 'display', 'none' );
    }
    // if( group.moreButtonsCssClass && !group.hidingMoreButtonsIfOff )
    // group.buttonDoms.removeClass( group.moreButtonsCssClass );
  }

  // no need
  //group.deactivate();

  group.buttonDoms.on( _.eventName( 'click' ) + '.' + Self.shortName, function( e )
  {
    var button = $( e.currentTarget );
    group.activateWithButton( button );
  });

  group._formed = 1;

  return group;
}

// form.defaults =
// {
//   name : 'global',
//   targetDom : 'body',
// }

// --
// button
// --

function _buttonIsAllowedPageAbsence( button )
{
  var group = this;
  if( _.domIs( button ) )
  button = $( button );
  _.assert( button.length );
  _.assert( _.jqueryIs( button ) );
  return group.allowAbsenceOfPage || button.hasClass( group.allowAbsenceOfPageCssClass )
}

//

/**
 * Get tab buttons for tab name or tab dom.
 * @param {string|DOM} tabName - tab name or tab dom for which tab button is needed.
 * @return {DOM} found tab button in jquery container
 * @method buttonsFor
 * @memberof wGhiTabsManager#
 */

function buttonsFor( tabName )
{
  var group = this;
  tabName = group.tabNameFor( tabName );
  var result = group.buttonDoms.filter( '[' + group.nameAttribute + '=' + tabName + ']' );
  return result;
}

// --
// page
// --

/**
 * Get tab forms for tab name or tab button.
 * @param {string|DOM} tabName - tab name or tab dom for which tab form is needed.
 * @return {DOM} found tab form in jquery container
 * @method pageFor
 * @memberof wGhiTabsManager#
 */

function pageFor( tabName )
{
  var group = this;
  tabName = group.tabNameFor( tabName );
  var result = group.pagesDoms.filter( '[' + group.nameAttribute + '=' + tabName + ']' );
  return result;
}

//

function _pagesCheck()
{
  var group = this;

  _.assert( arguments.length === 0 );

  if( !group.allowAbsenceOfPage )
  group.buttonDoms.each( function( k,buttonDom )
  {

    if( group._buttonIsAllowedPageAbsence( buttonDom ) )
    return;

    var tabName = group.tabNameFor( buttonDom );
    var pageDom = group.pageFor( tabName );

    // if( tabName === 'unified' )
    // return;

    _.assert( pageDom.length,'no form for tab name',_.strQuote( tabName ),'found only button',_.strQuote( _.domNickname( buttonDom ) ) );

  });

  return group;
}

//

function _pagesFilterOut()
{
  var group = this;

  group.pagesDoms = group.pagesDoms.filter( function( k,pageDom )
  {
    var buttonDom = group.buttonsFor( pageDom );

    if( !buttonDom.length )
    {
      return false;
    }

    return true;
  });

}

//

function _pageLoad( o )
{
  var group = this;
  var con = new _.Consequence();

  if( group.caching && o.pageDom.attr( group.loadedAttribute ) )
  {
    group._activate( o );
    return con.give();
  }

  var url = o.buttonDom.attr( group.urlAttribute );

  _.assert( _.strIsNotEmpty( url ),'expects URL in attribute { ' + group.urlAttribute + ' }' );
  _.assert( _.strIsNotEmpty( o.tabName ),'expects tab name' );
  _.assert( arguments.length === 1 );

  url = _.uri.join( url,o.tabName );

  _.domLoad
  ({
    parentDom : o.pageDom,
    // targetClass : group.classContainer,
    url : url,
    // showing : 1,
    replacing : 0,
  })
  // .andThen( about )
  .ready.doThen( function( err,target )
  {

    if( err )
    {
      err = _.errLogOnce( err );
    }
    else
    {
      o.pageDom.attr( group.loadedAttribute,1 );
      group._activate( o );
    }

    con.give( err,target );

    // if( err )
    // throw err;
  });

  return con;
}

_pageLoad.defaults =
{
  tabName : null,
  pageDom : null,
  buttonDom : null,
}

// --
// activator
// --

function deactivate()
{
  var group = this;

  _.assert( arguments.length === 0 );

  group.pagesDoms.css({ 'display' : 'none' });
  group.pagesDoms.removeClass( group.activeCssClass );
  group.buttonDoms.removeClass( group.activeCssClass );

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
  _.assert( o.pageDom.length,'no form for tab',_.strQuote( o.tabName ) );

  group.deactivate();

  o.pageDom.css({ display : '' });
  o.pageDom.addClass( group.activeCssClass );
  o.buttonDom.addClass( group.activeCssClass );

  group.activeTabName = o.tabName;
  group.activeButton = o.buttonDom;
  group.activeForm = o.pageDom;

  var e = _.mapExtend( null,o );
  e.kind = 'tabActivate';
  e.group = group;
  group.eventGive( e );

  // console.log( '_activate',o.tabName );

}

_activate.defaults =
{
  tabName : null,
  buttonDom : null,
  pageDom : null,
}

//

function _activateWithButton( buttonDom )
{
  var group = this;

  var tabName = group.tabNameFor( buttonDom );
  var pageDom = group.pageFor( tabName );

  group._activate
  ({
    tabName : tabName,
    buttonDom : buttonDom,
    pageDom : pageDom,
  });

}

//

function activateWithButton( buttonDom )
{
  var group = this;
  var con = new _.Consequence();

  var o = Object.create( null );
  o.buttonDom = buttonDom;
  o.tabName = buttonDom.attr( group.nameAttribute );
  o.pageDom = group.pageFor( o.tabName );

  if( !o.pageDom.length )
  {
    var allowAbsenceOfPage = group._buttonIsAllowedPageAbsence( o.buttonDom );
    _.assert( allowAbsenceOfPage,'form for tab',_.strQuote( o.tabName ),'was not found' );
    return con.give();
  }

  _.assert( _.strIsNotEmpty( o.tabName ),'expects tab name in attribute { ' + group.urlAttribute + ' }' );

  if( buttonDom.filter( group.dynamicSelector ).length )
  {
    if( !( eRsTab && eRsTab.instancesMap[ o.tabName ] ) )
    return group._pageLoad( o );
  }

  group._activate( o );

  return con.give();
}

//

function activateWithName( tabName )
{
  var group = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( tabName ) );

  var buttonDom = group.buttonsFor( tabName );
  var pageDom = group.pageFor( tabName );

  // var buttonDom = group.buttonDoms.filter( '[' + group.nameAttribute + '=' + tabName + ']' );
  // var pageDom = group.pagesDoms.filter( '[' + group.nameAttribute + '=' + tabName + ']' );

  group._activate
  ({
    tabName : tabName,
    buttonDom : buttonDom,
    pageDom : pageDom,
  });

  return group;
}

//

function activate( tab )
{
  var group = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( tab ) );

  group.activateWithName( tab );

  return group;
}

// --
// more
// --

/**
 * Additional tabs mechanism.
 * Mechanism allows to hide/show additional tabs in the menu by clicking on 'more' toggle button.
 * To enable that behavior user must enable ( o.usingMoreButton ) option and provide css class name( o.moreButtonsCssClass ).
 *
 * Class ( o.moreButtonsCssClass ) is used to find additional tabs and show/hide them when 'more' button is pressed. Routine expects that additional tabs
 * are already hidden by ( o.moreButtonsCssClass ) class.
 * By default 'more' button is generated automatically as '...' at the end of the menu. User also can use own button by specifying it selector ( o.moreButtonSelector ).
 *
 * Also aditional tabs can be showed without usage of 'more' toggle button. For this purpose ( o.usingMoreButton ) and ( o.hidingMoreButtonsIfOff ) must be set to false,
 * but ( o.moreButtonsCssClass ) css class is still required to find the hidden additional tabs.
 *
 * @param {boolean} [ o.usingMoreButton=0 ] - enables additional tabs showing/hidding by clicking on '...' button in the menu.
 * @param {string} [ o.moreButtonsCssClass=null ] - name of the css class that as selector to find tabs, required only if usingMoreButton is enabled.
 * @param {string} [ o.moreButtonSelector=null ] - selector of 'more' button created by the user.
 * @param {string} [ o.hidingMoreButtonsIfOff=0 ] - controls if additional tabs will be showed when ( o.usingMoreButton ) is disabled.
 *
 */

function _formMore()
{
  var group = this;

   _.assert( _.strIs( group.moreButtonsCssClass ), 'Please provide tabs hider class name.' );

  var tabsParent = group.buttonDoms.parent();
  var additionalTabsSelector = _.strPrependOnce( group.moreButtonsCssClass, '.' );

  group.moreButtonsDoms = group.buttonDoms.filter( additionalTabsSelector );
  if( !group.moreButtonsDoms.length )
  return;

  /* */

  if( !group.moreButtonSelector )
  {
    var moreButtonName = group.name + '-more';
    var moreButtonHtml = `<a class='item ${ moreButtonName }'>...</a>`;
    tabsParent.append( moreButtonHtml );
    group.moreButtonDom = tabsParent.find( '.' + moreButtonName );
  }
  else
  {
    // _.assert( _.strIs( group.moreHideCssClass ), 'Please provide button hider class name.' );
    group.moreButtonDom = group.buttonDoms.filter( group.moreButtonSelector );
    group.moreButtonDom.css( 'display', 'block' );
  }

  group.moreButtonsDoms.css( 'display','none' );

  /* */

  group.moreButtonDom.on( _.eventName( 'click' ) + '.' + Self.shortName, ( e ) =>
  {
    group.moreButtonsToggle();
  });

}

//

function moreButtonsToggle( value )
{
  var group = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( value !== undefined )
  group.moreButtonVisible = !value;

  if( group.moreButtonVisible )
  {
    group.moreButtonsDoms.css( 'display','none' );
    group.moreButtonVisible = false;
  }
  else
  {
    group.moreButtonsDoms.css( 'display','' );
    group.moreButtonVisible = true;
  }

}

// --
// etc
// --

function tabNameFor( dom )
{
  var group = this;

  if( _.strIs( dom ) )
  return dom;

  if( _.domIs( dom ) )
  dom = $( dom );

  var result = dom.attr( group.nameAttribute );

  _.assert( arguments.length === 1 );
  _.assert( dom.length );
  _.assert( !!result );

  return result;
}

//

function tabIsAdvanced( tabName )
{
  var group = this;

  if( tabName === undefined )
  tabName = group.activeTabName;

  if( group.moreButtonsDoms )
  if( group.moreButtonsDoms.length )
  {
    var button = group.moreButtonsDoms.filter( `[data-tab='${tabName}']` );
    return !!button.length;
  }

  return false;
}

//

function domsReloaded()
{
  var group = this;

  group.buttonDoms = group.targetDom.find( group.buttonsSelector ).addBack( group.buttonsSelector );
  group.pagesDoms = group.targetDom.find( group.pagesSelector ).addBack( group.pagesSelector );

}

// --
// relations
// --

var Composes =
{

  nameAttribute : 'data-tab',
  urlAttribute : 'data-tab-url',
  loadedAttribute : 'data-tab-loaded',

  activeCssClass : 'active',
  allowAbsenceOfPageCssClass : 'allow-absence-of-page',

  dynamicSelector : '.dynamic',

  allowAbsenceOfPage : 0,
  caching : 1,

  activeTabName : null,
  activeForm : null,
  activeButton : null,

  usingMoreButton : 0,
  hidingMoreButtonsIfOff : 0,
  moreButtonsCssClass : null,
  moreButtonSelector : null,
  moreButtonVisible : 0,

  buttonsSelector : 'a[data-tab]:not( .disabled )',
  pagesSelector : 'div[data-tab]:not( .disabled )',

}

var Associates =
{
  targetDom : 'body',
  pagesParentDom : null,
}

var Restricts =
{
  name : null,
  buttonDoms : null,
  moreButtonsDoms : null,
  moreButtonDom : null,
  pagesDoms : null,
  _formed : 0,
}

var Medials =
{
  name : null,
}

var Statics =
{
  _make : _make,
}

var Events =
{
}

// --
// proto
// --

var Proto =
{

  init : init,
  _make : _make,

  unform : unform,
  form : form,


  // button

  _buttonIsAllowedPageAbsence : _buttonIsAllowedPageAbsence,
  buttonsFor : buttonsFor,


  // page

  pageFor : pageFor,
  _pagesCheck : _pagesCheck,
  _pagesFilterOut : _pagesFilterOut,
  _pageLoad : _pageLoad,


  // activator

  deactivate : deactivate,

  _activate : _activate,
  _activateWithButton : _activateWithButton,
  activateWithButton : activateWithButton,

  activateWithName : activateWithName,
  activate : activate,


  // more

  _formMore : _formMore,
  moreButtonsToggle : moreButtonsToggle,


  // etc

  tabNameFor : tabNameFor,
  tabIsAdvanced : tabIsAdvanced,
  domsReloaded : domsReloaded,


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

_.assert( !!Parent );

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
