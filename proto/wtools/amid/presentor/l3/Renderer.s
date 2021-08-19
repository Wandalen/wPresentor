( function _Presentor_s_()
{

'use strict';

let _ = _global_.wTools;
_.include( 'wProto' ); /* qqq : for Dmytro : remove later */
// _.ghi = _.ghi || Object.create( null );

let Parent = null;
let Self = function wRenderer( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Renderer';

//

function init( o )
{
  let self = this;

  _.workpiece.initFields( self );
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( self.structure )
  self.form();
}

//

function form()
{
  let self = this;
  if( self._formed )
  return;
  if( _.strIs( self.structure ) )
  self.structure = _.stxt.Parser({ dataStr : self.structure })
  self.structure.form();
  self._formed = 1;
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
//   let structure =
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
// let structure =
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
// Google Summer of Code: May-August 2016 - >> Bionode workflow engine for streamed structure analysis <<- https://summerofcode.withgoogle.com/projects/=6585953724399616
// 4 weeks "community bonding", 12 weeks coding
// ended up spending first 4 weeks of code time figuring out what to do: my NGS Workflows post
// final 8 weeks to implement MVP of what was described in NGS Workflows post
//
// Mentors:
// Yannick Wurm, wurmlab. @yannick__
// Bruno Vieira, Phd student @ wurmlab, bionode founder. @bmpvieira
// Max Ogden, dat, open structure, Node. @denormalize
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
// - source: raw structure generated by sequencing machines or otherwise - a file, set of files, or streaming output. (e.g. fastq)
// - destination: file(s) describing modeling/computational results (e.g. vcf) transformation from one format to another accomplished with "tools"
// - Tools <<! are usually written in C/C++, available as CLI binaries (maybe wrapped with Python/R)
// - Tools may:
// -- read one or many files, either >>explicitly or implicitly<<!
// -- write one or many files, either >>explicitly or implicitly<<!
// -- consume streaming STDIN and/or produce streaming STDOUT
// -- not give proper non-zero exit codes, change options across versions, log to STDERR, output empty files, etc...
// - Pipeline<<!: series of transformations applied with tools<<! to a source to produce a destination
// `

function pageRender( pageIndex )
{
  let self = this;

  // if( _.numberIs( pageIndex ) )
  // self.pageIndex = pageIndex;
  //
  // if( self.pageIndex === self.pageIndexCurrent )
  // return;
  //
  // self.pageIndexCurrent = self.pageIndex;

  // self.pageClear(); /* qqq : for Dmytro : investigate */

  _.assert( pageIndex === undefined || _.numberIs( pageIndex ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  /* */

  debugger;
  let page = self.structure.document.nodes[ pageIndex ];

  if( !page )
  return self.errorReport( 'Page', pageIndex, 'not found' );

  for( let k = 0 ; k < page.nodes.length ; k++ )
  {
    let element = page.nodes[ k ];
    let htmlElement = self._pageElementRender( element, page );
    self.genContentDom.append( htmlElement );
  }
  // for( let k = 0 ; k < page.elements.length ; k++ )
  // {
  //   let element = page.elements[ k ];
  //   let htmlElement = self._pageElementRender( element, page );
  //   self.genContentDom.append( htmlElement );
  // }

  self.pageHeadDom.empty();
  self.pageHeadDom.append( self._pageElementRender( page.head ) );
  self.pageHeadDom.attr( 'level', page.level );

  self.pageNumberDom.text( ( pageIndex + 1 ) + ' / ' + self.structure.document.nodes.length );

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

  let result = _.entityFilter( self.structure.document.nodes,function( e )
  {
    // console.log( self.pageHeadNameChop( e.head ) );
    if( self.pageHeadNameChop( e.head ) === head )
    return e;
  });

  return result;
}

//

function _pageElementRender( element,page )
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
      let htmlElement = self._pageElementRender( element.nodes, page );
      html.append( htmlElement );
    }
    else if( element.kind === 'Line' || element.kind === 'LineEmpty' )
    {
      html = [ '<p>' ];
      let htmlElement = self._pageElementRender( element.nodes, page );
      html.push( htmlElement );
      html.push( element.text );
      html.push( '</p>' );
    }
    else if( element.kind === 'Sentiment' )
    {
      html = $( '<span>' );
      if( element.sentiment === 'strong' )
      html.addClass( 'strong' );
      let htmlElement = self._pageElementRender( element.nodes, page );
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


    //
    // if( element.kind === 'List' )
    // html = self._pageListMake
    // ({
    //   list : element,
    //   page,
    // });
    // else if( element.kind === 'Link' )
    // {
    //   html = $( '<a>' );
    //   html.attr( 'href',element.ref );
    //   let htmlElement = self._pageElementRender( element.elements,page );
    //   html.append( htmlElement );
    // }
    // else if( element.kind === 'Line' )
    // {
    //   html = $( '<p>' );
    //   let htmlElement = self._pageElementRender( element.elements,page );
    //   html.append( htmlElement );
    // }
    // else if( element.kind === 'Sentiment' )
    // {
    //   html = $( '<span>' );
    //   if( element.sentiment === 'strong' )
    //   html.addClass( 'strong' );
    //   let htmlElement = self._pageElementRender( element.element,page );
    //   html.append( htmlElement );
    // }
    // else if( element.kind === 'Directive' )
    // {
    //   if( element.map.image )
    //   {
    //
    //     if( element.map.size === 'widest' )
    //     {
    //       html = $( '<img>' );
    //       html.attr( 'level', element.level );
    //       html.attr( 'src', element.map.image );
    //       html.attr( 'background-image', 1 );
    //     }
    //     else
    //     {
    //       html = $( '<img>' );
    //       html.attr( 'level', element.level );
    //       html.attr( 'src', element.map.image );
    //     }
    //
    //   }
    //   else debugger;
    //
    //   if( element.map.height )
    //   {
    //     html.css( 'max-height', self.vminFor( element.map.height ) );
    //     html.css( 'width', 'auto' );
    //   }
    //   if( element.map.width )
    //   {
    //     html.css( 'max-width', self.vminFor( element.map.width ) );
    //     html.css( 'height', 'auto' );
    //   }
    //
    //   if( element.map.halign )
    //   html.attr( 'halign',element.map.halign );
    //   if( element.map.valign )
    //   html.attr( 'valign',element.map.valign );
    //
    // }
    // else if( element.kind === 'Span' )
    // {
    //
    //   html = $( '<span>' );
    //   html.text( element.text );
    //
    //   if( element.properties )
    //   {
    //     if( element.properties.size )
    //     {
    //       let em = self.emFor( element.properties.size );
    //       html.css( 'line-height', em );
    //       html.css( 'font-size', em );
    //     }
    //   }
    //
    // }
    // else debugger;
    //
  }
  else if( _.arrayIs( element ) ) /* */
  {
    let result = [];

    for( let i = 0 ; i < element.length ; i++ )
    result.push( self._pageElementRender( element[ i ], page ) );

    return result;
  }
  else throw _.err( '_pageElementRender : unknown type : ' + _.entity.strType( element ) ); /* */

  return html.join( '' );
}

//

function _pageListMake( o )
{
  let self = this;

  _.routine.options( _pageListMake, o );

  /* */

  let list = [ '<ul>' ];
  let level = 1;

  for( let k = 0 ; k < o.list.nodes.length ; k++ )
  {
    let element = o.list.nodes[ k ];

    levelSet( element.level );

    o.element = element;
    o.key = k;
    list.push( self._pageListElementMake( o ) );
  }

  list.push( '</ul>' );
  return list;

  /* */

  function levelSet( newLevel )
  {
    if( level === newLevel )
    return;

    while( level < newLevel )
    {
      list = [ '<ul>' ];
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
}

_pageListMake.defaults =
{
  list : null,
  page : null,
};

// function _pageListMake( o )
// {
//   let self = this;
//
//   _.routineOptions( _pageListMake,o );
//   o = _.mapExtend( null,o );
//
//   /* */
//
//   function levelSet( newLevel )
//   {
//
//     if( level === newLevel )
//     return;
//
//     while( level < newLevel )
//     {
//       list = $( '<ul>' );
//       lists[ lists.length-1 ].append( list );
//       lists.push( list );
//       level += 1;
//     }
//
//     while( level > newLevel )
//     {
//       lists.pop();
//       list = lists[ lists.length-1 ];
//       level -= 1;
//     }
//
//   }
//
//   /* */
//
//   let list = $( '<ul>' );
//   let lists = [ list ];
//   let level = 1;
//
//   for( let k = 0 ; k < o.list.elements.length ; k++ )
//   {
//     let element = o.list.elements[ k ];
//
//     levelSet( element.level );
//
//     o.element = element;
//     o.key = k;
//     list.append( self._pageListElementMake( o ) );
//   }
//
//   return lists[ 0 ];
// }
//
// _pageListMake.defaults =
// {
//   list : null,
//   page : null,
// }

//

function _pageListElementMake( o )
{
  let self = this;

  _.routineOptions( _pageListElementMake,o );

  let html = $( '<li>' );
  let htmlElement = self._pageElementRender( o.element.element,o.page );

  if( _.strIs( htmlElement ) )
  html.text( htmlElement )
  else
  html.append( htmlElement );

  return html;
}

_pageListElementMake.defaults =
{
  element : null,
  key : null,
  list : null,
  page : null,
}

//

function errorReport( err )
{
  let self = this;
  debugger;
  throw err;
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


  // dynamic : 0,
  // targetIdentity : '.wpresentor',
  // terminalCssClass : 'terminal',

  // rawData : null,
  structure : null,

  // pageIndex : 0,
  // pageIndexCurrent : -1,
  //
  // usingAnchorOnMake : 1,

}

let Aggregates =
{

}

let Associates =
{

  // targetDom : '.wpresentor',
  //
  // contentDomSelector : '{{targetDom}} > .content',
  // contentDom : null,
  //
  // menuDomSelector : '{{contentDomSelector}} > .presentor-menu',
  // menuDom : null,
  //
  // subContentDomSelector : '{{contentDomSelector}} > .sub-content',
  // subContentDom : null,
  //
  // genContentDomSelector : '{{contentDomSelector}} > .gen-content',
  // genContentDom : null,
  //
  // pageHeadDomSelector : '{{subContentDomSelector}} > .page-head',
  // pageHeadDom : null,
  //
  // pageNumberDomSelector : '{{subContentDomSelector}} > .page-number',
  // pageNumberDom : null,
  //
  // ellipsisDomSelector : '{{subContentDomSelector}} > .presentor-ellipsis',
  // ellipsisDom : null,

}

let Restricts =
{
  _formed : 0,
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
  form,

  pageRender,

  pageHeadNameChop,
  pagesByHead,

  _pageElementRender,
  _pageListMake,
  _pageListElementMake,

  errorReport,
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

_.Copyable.mixin( Self );

// _.Instancing.mixin( Self );
// _.EventHandler.mixin( Self );

//

// _.ghi = _.ghi || Object.create( null );
// _global_[ Self.name ] = _.ghi[ Self.shortName ] = Self;

_.presentor[ Self.shortName ] = Self;

// Self.exec();

})( );
