( function _Presentor_s_()
{

'use strict';

// let $ = jQuery;
let _ = _global_.wTools;
// let Parent = wGhiAbstractModule;
let Parent = null;
let Self = wPresentor;
function wPresentor( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Presentor';

//

function init( o )
{
  let self = this;

  _.workpiece.initFields( self );
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  // _.assert( !!self.renderer );
  // _.assert( self.renderer._formed === 1 );

  if( self.dataStr || self.dataPath )
  self.form();

  return self;
}

// //
//
// function exec( data )
// {
//   let proto = this;
//
//   return _.process.ready( function()
//   {
//     if( !_.strIs( data ) && data !== undefined )
//     {
//       data = _.Consequence.From( data );
//       data.finally( function( err,data )
//       {
//         if( err )
//         throw self.reportError( _.errLogOnce( err ) );
//         return proto._exec( data );
//       });
//       return data;
//     }
//     return proto._exec( data );
//   });
//
// }
//
// //
//
// function _exec( data )
// {
//   let proto = this;
//   let self = new Self({ renderer : _.presentor.Renderer({ structure : data }) });
//
//   if( data !== undefined )
//   self.dataStr = data;
//
//   _.assert( _.strIs( self.dataStr ) );
//
//   self.structure = self.renderer.structure;
//
//   return self.form();
// }

//

function form()
{
  let self = this;
  let ready = _.take( self.dataStr );

  if( self._formed )
  return self.formReady.split();

  self._formed = 1;

  // Parent.prototype._formAct.call( self );

  if( !self.dataStr && self.dataPath )
  ready.then( () => self._fetch( self.dataPath ) );

  ready.then( () =>
  {
    self._formed = 2;

    _.assert( _.strIs( self.dataStr ) );
    self.renderer = _.presentor.Renderer({ structure : self.dataStr });
    self._domForm();

    self._formed = 3;
    self.formReady.take( null );
    return null;
  });

  return ready;
}

//

function _domForm()
{
  let self = this;

  /* form doms */

  self.targetDom = _.dom.findSingle( self.targetDom );
  self.contentDom = self.targetDom;

  // debugger;
  // self._formContentDom();
  // self.contentDom[ 0 ].setAttribute( 'tabindex', '0' );
  // _.domWheelOn( self.contentDom, _.routineJoin( self, _.time.rarely_functor( 1000, self.handleWheel ) ) ); /* !!! add off */

  // self.menuDom = self._formConentElementDom( self.menuDomSelector );
  // self.menuDom.css({ 'display' : 'none' });
  // self.menuDom.html( viewPresentor() );

  self.subContentDom = self._formConentElementDom( self.subContentDomSelector );
  self.pageHeadDom = _.dom.findSingle( _.dom.append( self.subContentDom, self._formConentElementDom( self.pageHeadDomSelector ) ) );
  self.genContentDom = _.dom.findSingle( _.dom.append( self.subContentDom, self._formConentElementDom( self.genContentDomSelector ) ) );
  self.pageNumberDom = _.dom.findSingle( _.dom.append( self.subContentDom, self._formConentElementDom( self.pageNumberDomSelector ) ) );

  // self.ellipsisDom = self.contentDom.find( self.ellipsisDomSelector );
  self.ellipsisDom = _.dom.findAll( self.contentDom, self.ellipsisDomSelector );

  // if( !self.ellipsisDom.length )
  // {
  //   _.assert( false, 'not implemented' );
  //   self.ellipsisDom = $( '<i>' ).appendTo( self.contentDom );
  //   _.dom.ownIdentity( self.ellipsisDom, self.ellipsisDomSelector );
  //   self.ellipsisDom.addClass( 'ellipsis horizontal icon' );
  // }

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

  // self.ellipsisDom
  // .on( _.dom.eventName( 'click' ), function( e )
  // {
  //   self.menuVisible();
  // });

  /* */

  // self.contentDom.find( '.action-theme-dark' )
  // self.contentDom = _.dom.findAll( self.contentDom, '.action-theme-dark' )
  // .on( _.dom.eventName( 'click' ), function( e )
  // {
  //   let menu = self.menuDom.find( '.menu' );
  //   if( menu.hasClass( 'inverted' ) )
  //   {
  //     menu.removeClass( 'inverted' );
  //     self.contentDom.removeClass( 'theme-dark' );
  //   }
  //   else
  //   {
  //     menu.addClass( 'inverted' );
  //     self.contentDom.addClass( 'theme-dark' );
  //   }
  // });
  //
  // /* */
  //
  // self.contentDom.find( '.action-back' )
  // .on( _.dom.eventName( 'click' ), function( e )
  // {
  //   self.menuVisible( 0 );
  // });

  /* */

  _global_.addEventListener( 'hashchange', function( e )
  {
    debugger;
    self.pageShowByCurrentAnchor();
  });

  /* */

  // if( self.usingAnchorOnMake )
  // self.pageShowByCurrentAnchor();
  // else
  self.pageShow();

}

//

async function _fetch( dataPath )
{
  let self = this;
  const response = await fetch( self.dataPath );
  self.dataStr = await response.text();
  // const renderer = _.presentor.Renderer({ structure : dataStr });
  //
  // const page0 = renderer.pageShow( 0 );
  // for( let i = 0 ; i < page0.length ; i++ )
  // page0[ i ] = _.html.exportString( page0[ i ] );
  //
  // const data = page0.join( '\n' );
  //
  // document.body.innerHTML = data;
  // console.log( data );

}

//

function _formConentElementDom( selector )
{
  let self = this;
  // let result = self.contentDom.find( selector );
  let result = _.dom.findAll( self.contentDom, selector )

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( selector ) );
  // _.assert( self.contentDom.length > 0 );

  if( !result.length )
  {
    result = document.createElement( 'div' );
    self.contentDom.appendChild( result );
    // result = $( '<div>' ).appendTo( self.contentDom );
    // debugger;
    _.dom.ownIdentity( result, selector );
    // debugger;
  }

  return result;
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
  else if( pageIndex >= self.structure.nodes.length )
  pageIndex = self.structure.nodes.length-1;

  self.pageShow( pageIndex );

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

  self.pageShow( 0 );

  return self;
}

//

function pageLast()
{
  let self = this;

  self.pageShow( self.structure.nodes.length-1 );

  return self;
}

//

function pageClear()
{
  let self = this;

  // debugger;
  // self.genContentDom.empty();
  self.genContentDom.innerHTML = '';

}

//

function pageShow( pageIndex )
{
  let self = this;

  // debugger;
  if( _.numberIs( pageIndex ) )
  self.pageIndex = pageIndex;

  if( self.pageIndex === self.pageIndexCurrent )
  return;

  self.pageIndexCurrent = self.pageIndex;

  self.pageClear();

  _.assert( pageIndex === undefined || _.numberIs( pageIndex ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  /* */

  let interval = [ 0, self.renderer.structure.document.nodes.length ];
  if( !_.cinterval.has( interval, self.pageIndexCurrent ) )
  return self.errorReport( `Page ${self.pageIndexCurrent} not found. It should be in the interval ${_.cinterval.exportString( interval )}` );

  let page = self.renderer.structure.document.nodes[ self.pageIndexCurrent ];
  let bodyHtml = self.renderer.pageRender( page );

  self.genContentDom.innerHTML = _.html.exportString( bodyHtml );

  // let page = self.data.page[ self.pageIndex ];
  //
  // if( !page )
  // return self.reportError( 'Page', pageIndex, 'not found' );
  //
  // for( let k = 0 ; k < page.elements.length ; k++ )
  // {
  //   let element = page.elements[ k ];
  //   let htmlElement = self._pageElementMake( element,page );
  //   self.genContentDom.append( htmlElement );
  // }

  // self.pageHeadDom.empty();
  // debugger;
  // self.pageHeadDom.innerHTML = '';
  let headHtml = self.renderer._pageElmentExportHtml( page.head );
  self.pageHeadDom.innerHTML = _.html.exportString( headHtml );
  // self.pageHeadDom.attr( 'level', page.level );
  self.pageHeadDom.setAttribute( 'level', page.level );

  self.pageNumberDom.innerHTML = ( self.pageIndexCurrent + 1 ) + ' / ' + self.renderer.structure.document.nodes.length;

  // let a = _.process.anchor();
  //
  // _.process.anchor
  // ({
  //   extend : { page : self.pageIndexCurrent + 1 },
  //   del : { head : 1 },
  //   replacing : a.head ? 1 : 0,
  // });

}

//

function pageShowByCurrentAnchor()
{
  let self = this;

  // logger.log( 'pageShowByCurrentAnchor',window.location.hash );

  let a = _.process.anchor();

  if( a.head )
  {
    let page = self.pagesByHead( a.head )[ 0 ];
    if( page )
    {
      self.pageShow( page.number );
      return
    }
  }

  let page = a.page !== undefined ? a.page-1 : 0;
  self.pageShow( page );

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

  let result = _.entityFilter( self.structure.nodes,function( e )
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

  // parser : null,
  // renderer : null,
  // filePath : null,
  // dataStr : null,

  dynamic : 0,
  targetIdentity : '.wpresentor',

  // terminalCssClass : 'terminal',
  // dataStr : null,
  // structure : null,
  // data : null,

  pageIndex : 0,
  pageIndexCurrent : -1,

  usingAnchorOnMake : 1,

}

let Aggregates =
{

  dataStr : null,
  dataPath : null,

}

let Associates =
{

  targetDom : '.wpresentor',

  contentDomSelector : '.wpresentor',
  contentDom : null,

  menuDomSelector : '.wpresentor > .presentor-menu',
  menuDom : null,

  subContentDomSelector : '.wpresentor > .sub-content',
  subContentDom : null,

  genContentDomSelector : '.wpresentor > .gen-content',
  genContentDom : null,

  pageHeadDomSelector : '.wpresentor > .sub-content > .page-head',
  pageHeadDom : null,

  pageNumberDomSelector : '.wpresentor > .sub-content > .page-number',
  pageNumberDom : null,

  ellipsisDomSelector : '.wpresentor > .sub-content > .presentor-ellipsis',
  ellipsisDom : null,

}

let Restricts =
{
  _formed : 0,
  formReady : _.define.own( new _.Consequence() ),
  parser : null,
  renderer : null,
}

let Statics =
{
  // exec,
  // _exec,
}

// --
// proto
// --

let Proto =
{

  init,

  // exec,
  // _exec,

  form,
  _domForm,
  _fetch,
  _formConentElementDom,

  menuVisible,
  menuIsVisible,

  pageWind,
  pageNext,
  pagePrev,
  pageFirst,
  pageLast,
  pageClear,

  pageShow,
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
};

//

_.classDeclare
({
  cls : Self,
  extend : Proto,
  parent : Parent,
});

_.Copyable.mixin( Self );

// _.Instancing.mixin( Self );
// _.EventHandler.mixin( Self );

//

_.presentor[ Self.shortName ] = Self;

// Self.exec();

})( );
