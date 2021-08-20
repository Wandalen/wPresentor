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

/*

jmazz.me/slides/2016/10/24/bionode-watermill

*/

//

function init( o )
{
  let self = this;
  Parent.prototype.init.call( self,o );
}

  // debugger; //
  //
  // let src = 'HarvardX <<- https://harvardx.harvard.edu/';
  // let result = _.strSplit
  // ({
  //   src,
  //   // delimeter : [ '->>','<<-','!>>','<<!','>>','<<',' ' ],
  //   delimeter : [ ' ' ],
  //   preservingEmpty : 0,
  //   preservingDelimeters : 1,
  //   stripping : 0,
  // });
  //
  // console.log( src );
  // console.log( result );
  // debugger
  //
  // return; //
//
//   let data =
// `
// = reputation
//
// == links
// ==- github
//
// == feedbacks
// ==- public
// ==- private
// ==- stats
// ==- success rate
// ==- top rated
//
// == tests
// ==- time it take
// ==- several attempts
// `;
//
// let data =
// `
// = bionode-watermill <<- https://github.com/bionode/bionode-watermill
//
// ~~~ image:/amid_viewer/image/instrument.jpg
//
// is a workflow<<! engine for orchestrating complex and dynamic pipelines. The tool automatically resolves input and output filenames, while also maintaining a directed acyclic graph (DAG) of task dependencies. This enables the developer to isolate individual tasks and compose them with operators such as join, junction, and fork. Tasks can be child processes or JavaScript functions; of note is the ability to use Node streams which can be used to transform STDIN and STDOUT. Integration with Docker and clustering tools like qsub are some immediate<<! objectives of the <<- https://github.com/bionode/bionode-watermill project.
//
// aaa @thejmazz <<! <<- https://twitter.com/thejmazz bbb
//
// jmazz.me/slides/2016/10/24/bionode-watermill <<- http://jmazz.me/slides/2016/10/24/bionode-watermill
//
// = Agenda
//
// ~ list:ordered
//
// - Project history
// - What is a pipeline?
// - Example VCF Pipeline
// - What makes pipelines complex or dynamic?
// - Existing tools
// -- bash, makefile, python scripts
// -- snakemake <<- https://bitbucket.org/snakemake/snakemake/wiki/Home
// -- nextflow <<- https://www.nextflow.io/
// - bionode-watermill overall goals
// - Define a task
// - The task lifecycle
// - The DAG, input resolution, and operators
// - NGS Pipeline with watermill
// - Node streams
// - Node streams & child processes
// - Next Steps
//
// = Project History
//
// Google Summer of Code: May-August 2016 - >> Bionode workflow engine for streamed data analysis <<- https://summerofcode.withgoogle.com/projects/=6585953724399616
// 4 weeks "community bonding", 12 weeks coding
// ended up spending first 4 weeks of code time figuring out what to do: my NGS Workflows post
// final 8 weeks to implement MVP of what was described in NGS Workflows post
//
// Mentors:
// Yannick Wurm, wurmlab. @yannick__
// Bruno Vieira, Phd student @ wurmlab, bionode founder. @bmpvieira
// Max Ogden, dat, open data, Node. @denormalize
// Mathias Buus, dat, p2p, Node streams. @mafintosh
//
// = What is a pipeline?
//
// ~~ image:/amid_viewer/image/instrument.jpg
//
// == What is a pipeline?
//
// ~~~ halign:right image:/amid_viewer/image/instrument.jpg
//
// - Takes a source to a destination
// - source: raw data generated by sequencing machines or otherwise - a file, set of files, or streaming output. (e.g. fastq)
// - destination: file(s) describing modeling/computational results (e.g. vcf) transformation from one format to another accomplished with "tools"
// - Tools <<! are usually written in C/C++, available as CLI binaries (maybe wrapped with Python/R)
// - Tools may:
// -- read one or many files, either >>explicitly or implicitly<<!
// -- write one or many files, either >>explicitly or implicitly<<!
// -- consume streaming STDIN and/or produce streaming STDOUT
// -- not give proper non-zero exit codes, change options across versions, log to STDERR, output empty files, etc...
// - Pipeline<<!: series of transformations applied with tools<<! to a source to produce a destination
// `

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

function pageRender( pageIndex )
{
  let self = this;

  if( _.numberIs( pageIndex ) )
  self.pageIndex = pageIndex;

  if( self.pageIndex === self.pageIndexCurrent )
  return;

  self.pageIndexCurrent = self.pageIndex;

  self.pageClear();

  _.assert( pageIndex === undefined || _.numberIs( pageIndex ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  /* */

  let page = self.data.page[ self.pageIndex ];

  if( !page )
  return self.reportError( 'Page',pageIndex,'not found' );

  for( let k = 0 ; k < page.elements.length ; k++ )
  {
    let element = page.elements[ k ];
    let htmlElement = self._pageElmentExportHtml( element,page );
    self.genContentDom.append( htmlElement );
  }

  self.pageHeadDom.empty();
  self.pageHeadDom.append( self._pageElmentExportHtml( page.head ) );
  self.pageHeadDom.attr( 'level',page.level );

  self.pageNumberDom.text( ( self.pageIndexCurrent + 1 ) + ' / ' + self.data.page.length );

  let a = _.process.anchor();

  _.process.anchor
  ({
    extend : { page : self.pageIndexCurrent + 1 },
    del : { head : 1 },
    replacing : a.head ? 1 : 0,
  });

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

function _pageElmentExportHtml( element,page )
{
  let self = this;
  let html;

  if( _.objectIs( element ) ) /* */
  {

    if( element.kind === 'List' )
    html = self._pageListMake
    ({
      list : element,
      page,
    });
    else if( element.kind === 'Link' )
    {
      html = $( '<a>' );
      html.attr( 'href',element.ref );
      let htmlElement = self._pageElmentExportHtml( element.elements,page );
      html.append( htmlElement );
    }
    else if( element.kind === 'Line' )
    {
      html = $( '<p>' );
      let htmlElement = self._pageElmentExportHtml( element.elements,page );
      html.append( htmlElement );
    }
    else if( element.kind === 'Sentiment' )
    {
      html = $( '<span>' );
      if( element.sentiment === 'strong' )
      html.addClass( 'strong' );
      let htmlElement = self._pageElmentExportHtml( element.element,page );
      html.append( htmlElement );
    }
    else if( element.kind === 'Directive' )
    {
      if( element.map.image )
      {

        if( element.map.size === 'widest' )
        {
          html = $( '<img>' );
          html.attr( 'level', element.level );
          html.attr( 'src', element.map.image );
          html.attr( 'background-image', 1 );
        }
        else
        {
          html = $( '<img>' );
          html.attr( 'level', element.level );
          html.attr( 'src', element.map.image );
        }

      }
      else debugger;

      if( element.map.height )
      {
        html.css( 'max-height', self.vminFor( element.map.height ) );
        html.css( 'width', 'auto' );
      }
      if( element.map.width )
      {
        html.css( 'max-width', self.vminFor( element.map.width ) );
        html.css( 'height', 'auto' );
      }

      if( element.map.halign )
      html.attr( 'halign',element.map.halign );
      if( element.map.valign )
      html.attr( 'valign',element.map.valign );

    }
    else if( element.kind === 'Span' )
    {

      html = $( '<span>' );
      html.text( element.text );

      if( element.properties )
      {
        if( element.properties.size )
        {
          let em = self.emFor( element.properties.size );
          html.css( 'line-height', em );
          html.css( 'font-size', em );
        }
      }

    }
    else debugger;

  }
  else if( _.arrayIs( element ) ) /* */
  {
    let result = [];

    for( let i = 0 ; i < element.length ; i++ )
    {
      result.push( self._pageElmentExportHtml( element[ i ],page ) );
    }

    return result;
  }
  else throw _.err( '_pageElmentExportHtml : unknown type : ' + _.entity.strType( element ) ); /* */

  return html;
}

//

function _pageListMake( o )
{
  let self = this;

  _.routineOptions( _pageListMake,o );
  o = _.mapExtend( null,o );

  /* */

  function levelSet( newLevel )
  {

    if( level === newLevel )
    return;

    while( level < newLevel )
    {
      list = $( '<ul>' );
      lists[ lists.length-1 ].append( list );
      lists.push( list );
      level += 1;
    }

    while( level > newLevel )
    {
      lists.pop();
      list = lists[ lists.length-1 ];
      level -= 1;
    }

  }

  /* */

  let list = $( '<ul>' );
  let lists = [ list ];
  let level = 1;

  for( let k = 0 ; k < o.list.elements.length ; k++ )
  {
    let element = o.list.elements[ k ];

    levelSet( element.level );

    o.element = element;
    o.key = k;
    list.append( self._pageListElementExportString( o ) );
  }

  return lists[ 0 ];
}

_pageListMake.defaults =
{
  list : null,
  page : null,
}

//

function _pageListElementExportString( o )
{
  let self = this;

  _.routineOptions( _pageListElementExportString,o );

  let html = $( '<li>' );
  let htmlElement = self._pageElmentExportHtml( o.element.element,o.page );

  if( _.strIs( htmlElement ) )
  html.text( htmlElement )
  else
  html.append( htmlElement );

  return html;
}

_pageListElementExportString.defaults =
{
  element : null,
  key : null,
  list : null,
  page : null,
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

//

function reportError( err )
{
  let self = this;

  debugger;

  return err;
}

//

function vminFor( vmin )
{
  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( vmin ) );
  _.assert( 0 <= vmin && vmin <= 10, 'vmin should be in range 0..10', vmin );
  return ( vmin * 100 ) + 'vmin';
}

//

function emFor( em )
{
  _.assert( arguments.length === 1 );
  _.assert( _.numberIs( em ) );
  _.assert( 0 <= em && em <= 1000, 'em should be in range 0..100', em );
  return ( em * 1 ) + 'em';
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
  pageRender,
  pageShowByCurrentAnchor,

  pageHeadNameChop,
  pagesByHead,

  _pageElmentExportHtml,
  _pageListMake,
  _pageListElementExportString,

  reportError,
  handleWheel,
  vminFor,
  emFor,

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
