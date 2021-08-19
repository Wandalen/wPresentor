( function _Presentor_s_()
{

'use strict';

let $ = jQuery;
let _ = _global_.wTools;
let Parent = wGhiAbstractModule;
let Self = function wHiPresentor( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'HiPresentor';

//

function init( o )
{
  let self = this;
  Parent.prototype.init.call( self, o );
}

//

function exec( data )
{
  let proto = this;

  return _.process.ready( function()
  {
    if( !_.strIs( data ) && data !== undefined )
    {
      data = _.Consequence.From( data );
      data.finally( function( err,data )
      {
        if( err )
        throw self.reportError( _.errLogOnce( err ) );
        return proto._exec( data );
      });
      return data;
    }
    return proto._exec( data );
  });

}

//

function _exec( data )
{
  let proto = this;
  let self = new Self({ targetDom : _.domTotalPanelMake().targetDom });

  if( data !== undefined )
  self.rawData = data;

  _.assert( _.strIs( self.rawData ) );

  self.data = new _.StxtParser({ dataStr : self.rawData });

  return self.form();
}

//

function _formAct()
{
  let self = this;

  Parent.prototype._formAct.call( self );

  _.assert( self.targetDom.length === 1 );

  /* form doms */

  self._formContentDom();
  self.contentDom[ 0 ].setAttribute( 'tabindex', '0' );

  _.domWheelOn( self.contentDom, _.routineJoin( self, _.time.rarely_functor( 1000, self.handleWheel ) ) ); /* !!! add off */

  self.menuDom = self._formConentElementDom( self.menuDomSelector );
  self.menuDom.css({ 'display' : 'none' });
  self.menuDom.html( viewPresentor() );

  self.subContentDom = self._formConentElementDom( self.subContentDomSelector );
  self.pageHeadDom = self._formConentElementDom( self.pageHeadDomSelector ).appendTo( self.subContentDom );
  self.genContentDom = self._formConentElementDom( self.genContentDomSelector ).appendTo( self.subContentDom );
  self.pageNumberDom = self._formConentElementDom( self.pageNumberDomSelector ).appendTo( self.subContentDom );

  self.ellipsisDom = self.contentDom.find( self.ellipsisDomSelector );
  if( !self.ellipsisDom.length )
  {
    self.ellipsisDom = $( '<i>' ).appendTo( self.contentDom );
    _.domOwnIdentity( self.ellipsisDom,self.ellipsisDomSelector );
    self.ellipsisDom.addClass( 'ellipsis horizontal icon' );
  }

  Mousetrap.bind( [ 'mod+g' ], function()
  {
    debugger;
    return false;
  });

  Mousetrap.bind( [ 'mod+left', 'mod+up' ], function()
  {
    self.pageFirst();
    return false;
  });

  Mousetrap.bind( [ 'mod+right', 'mod+down' ], function()
  {
    self.pageLast();
    return false;
  });

  Mousetrap.bind( [ 'left','up' ], function()
  {
    self.pagePrev();
    return false;
  });

  Mousetrap.bind( [ 'right','down' ], function()
  {
    self.pageNext();
    return false;
  });

  Mousetrap.bind( [ 'esc' ], function()
  {
    self.menuVisible();
    return false;
  });

  self.ellipsisDom
  .on( _.eventName( 'click' ), function( e )
  {
    self.menuVisible();
  });

  /* */

  self.contentDom.find( '.action-theme-dark' )
  .on( _.eventName( 'click' ), function( e )
  {
    let menu = self.menuDom.find( '.menu' );
    if( menu.hasClass( 'inverted' ) )
    {
      menu.removeClass( 'inverted' );
      self.contentDom.removeClass( 'theme-dark' );
    }
    else
    {
      menu.addClass( 'inverted' );
      self.contentDom.addClass( 'theme-dark' );
    }
  });

  /* */

  self.contentDom.find( '.action-back' )
  .on( _.eventName( 'click' ), function( e )
  {
    self.menuVisible( 0 );
  });

  /* */

  _global_.addEventListener( 'hashchange', function( e )
  {
    // debugger;
    self.pageShowByCurrentAnchor();
  });

  /* */

  if( self.usingAnchorOnMake )
  self.pageShowByCurrentAnchor();
  else
  self.pageRender();
}

//

function menuVisible( val )
{
  let self = this;

  if( val === undefined )
  val = !self.menuIsVisible();

  if( val )
  self.menuDom.css({ 'display' : 'flex' });
  else
  self.menuDom.css({ 'display' : 'none' });

  _.time.out( 0, () => val ? self.contentDom.addClass( 'active-menu' ) : self.contentDom.removeClass( 'active-menu' ) );

}

//

function menuIsVisible()
{
  let self = this;

  return self.contentDom.hasClass( 'active-menu' )
}

// --
//
// --

function pageWind( offset )
{
  let self = this;

  let pageIndex = self.pageIndex + offset;

  if( pageIndex < 0 )
  pageIndex = 0;
  else if( pageIndex >= self.data.page.length )
  pageIndex = self.data.page.length-1;

  self.pageRender( pageIndex );

}

//

function pageNext()
{
  let self = this;

  self.pageWind( +1 );

  return self;
}

//

function pagePrev()
{
  let self = this;

  self.pageWind( -1 );

  return self;
}

//

function pageFirst()
{
  let self = this;

  self.pageRender( 0 );

  return self;
}

//

function pageLast()
{
  let self = this;

  self.pageRender( self.data.page.length-1 );

  return self;
}

//

function pageClear()
{
  let self = this;

  self.genContentDom.empty();

}

//

function pageRenderByCurrentAnchor()
{
  let self = this;

  // logger.log( 'pageShowByCurrentAnchor',window.location.hash );

  let a = _.process.anchor();

  if( a.head )
  {
    let page = self.pagesByHead( a.head )[ 0 ];
    if( page )
    {
      self.pageRender( page.number );
      return
    }
  }

  let page = a.page !== undefined ? a.page-1 : 0;
  self.pageRender( page );

}

//

function pageHeadNameChop( head )
{

  if( _.objectIs( head ) )
  head = head.text;

  _.assert( _.strIs( head ) );

  head = head.trim();
  head = head.toLowerCase();
  head = head.replace( /\s+/g,'_' );

  return head;
}

//

function pagesByHead( head )
{
  let self = this;

  head = self.pageHeadNameChop( head );

  let result = _.entityFilter( self.data.page,function( e )
  {
    // console.log( self.pageHeadNameChop( e.head ) );
    if( self.pageHeadNameChop( e.head ) === head )
    return e;
  });

  return result;
}

//

function handleWheel( e, delta )
{
  let self = this;

  _.assert( arguments.length === 2 );

  // console.log( 'handleWheel', delta );

  if( Math.abs( delta[ 0 ] ) > Math.abs( delta[ 1 ] ) )
  {

    if( delta[ 0 ] < 0 )
    self.pageNext();
    else if( delta[ 0 ] > 0 )
    self.pagePrev();

  }
  else
  {

    if( delta[ 1 ] < 0 )
    self.pageNext();
    else if( delta[ 1 ] > 0 )
    self.pagePrev();

  }

}

// --
// let
// --

let symbolForValues = Symbol.for( 'values' );

// --
// relationship
// --

let Composes =
{


  dynamic : 0,
  targetIdentity : '.wpresentor',
  // terminalCssClass : 'terminal',

  rawData : null,
  data : null,

  pageIndex : 0,
  pageIndexCurrent : -1,

  usingAnchorOnMake : 1,

}

let Aggregates =
{

}

let Associates =
{

  targetDom : '.wpresentor',

  // pageDom : null,
  // headDom : null,

  contentDomSelector : '{{targetDom}} > .content',
  contentDom : null,

  menuDomSelector : '{{contentDomSelector}} > .presentor-menu',
  menuDom : null,

  subContentDomSelector : '{{contentDomSelector}} > .sub-content',
  subContentDom : null,

  genContentDomSelector : '{{contentDomSelector}} > .gen-content',
  genContentDom : null,

  pageHeadDomSelector : '{{subContentDomSelector}} > .page-head',
  pageHeadDom : null,

  pageNumberDomSelector : '{{subContentDomSelector}} > .page-number',
  pageNumberDom : null,

  ellipsisDomSelector : '{{subContentDomSelector}} > .presentor-ellipsis',
  ellipsisDom : null,

  // treeDomSelector : '{{targetDom}} > .content > .wtree',
  // pageDomSelector : '{{targetDom}} > .content > .page',
  // headDomSelector : '{{targetDom}} > .content > .head',

}

let Restricts =
{
}

let Statics =
{
  exec,
  _exec,

}

// --
// proto
// --

let Proto =
{

  init,

  exec,
  _exec,

  _formAct,

  menuVisible,
  menuIsVisible,

  pageWind,
  pageNext,
  pagePrev,
  pageFirst,
  pageLast,
  pageClear,
  pageShowByCurrentAnchor,

  pageHeadNameChop,
  pagesByHead,

  handleWheel,

  /* */

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  extend : Proto,
  parent : Parent,
});

_.Instancing.mixin( Self );
_.EventHandler.mixin( Self );

//

_.ghi = _.ghi || Object.create( null );
_global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;

// Self.exec();

})( );
