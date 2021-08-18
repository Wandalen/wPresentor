( function _StxtParser_s_()
{

'use strict';

let _ = _global_.wTools;
let Parent = null;
let Self = function wStxtParser( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Parser';

// --
//
// --

function init()
{
  let self = this;

  _.Copyable.prototype.init.apply( self, arguments );

  // self.form();
}

//

function form()
{
  let self = this;

  self.linesSplit();
  self.pagesSplit();
  self.pagesParse();
  self.pagesNormalize();

}

//

function linesSplit()
{
  let self = this;

  self.line = _.strSplit
  ({
    src : self.dataStr,
    delimeter : '\n',
    preservingEmpty : 1,
    preservingDelimeters : 0,
    quoting : 0,
  });

}

//

function pagesSplit()
{
  let self = this;
  let begin = 0;
  let end = 0;
  let isEmpty = true;

  _.assert( self.document === null );
  self.document = _.stxt.Collection.construct();
  self.document.nodes = [];
  self.document.lines = [ 0, self.line.length-1 ];
  self._nodeAdd( self.document );

  /* */

  for( end = 0 ; end < self.line.length ; end++ )
  {

    if( self.line[ end ][ 0 ] === '=' )
    {
      if( begin >= 0 && !isEmpty )
      pageMake();
      begin = end;
    }

    if( isEmpty )
    if( self.line[ end ].trim().length )
    isEmpty = false;

  }

  if( end-begin <= 1 )
  _.assert( 0, 'not tested' );

  if( begin >= 0 && !isEmpty )
  if( end-begin > 1 )
  pageMake();

  /* */

  function pageMake()
  {
    _.assert( end-begin > 0 );

    let page = _.stxt.Page.construct();
    page.subPages = [];
    page.supPages = [];
    page.nodes = [];
    page.lines = [ begin, end-1 ];
    page.text = null;
    page.raw = null;
    page.number = self.document.nodes.length;

    let levelAndNode = self.ParseLevelAndNode( self.line[ begin ], '=' );
    if( levelAndNode )
    {
      page.level = levelAndNode.level;
      if( levelAndNode.node.trim().length )
      page.head = self.lineParse( levelAndNode.node, begin );
    }
    else
    {
      page.level = 1;
      page.head = null;
    }

    self.document.nodes.push( page );
    self._nodeAdd( page );
  }

}

//

function pagesParse()
{
  let self = this;
  let result = [];
  let list;

  for( let p = 0 ; p < self.document.nodes.length ; p++ )
  {
    let page = self.document.nodes[ p ];
    self.pageParse( page );
  }

}

//

function pageParse( page )
{
  let self = this;
  let result = [];
  let lines = page.lines.slice();
  lines[ 0 ] += 1;

  _.assert( arguments.length === 1 );

  while( lines[ 0 ] <= lines[ 1 ] )
  {

    let list = self.listParseTry( lines );
    if( list )
    {
      page.nodes.push( list );
      continue;
    }

    let directive = self.directiveParseTry( lines );
    if( directive )
    {
      page.nodes.push( directive );
      continue;
    }

    let label = self.labelParseTry( lines );
    if( label )
    {
      page.nodes.push( label );
      continue;
    }

    let comment = self.commentLineParseTry( lines );
    if( comment )
    {
      page.nodes.push( comment );
      continue;
    }

    let lineStr = self.line[ lines[ 0 ] ];
    let line = self.lineParse( lineStr, lines[ 0 ] );
    if( line.kind !== 'LineEmpty' || !page.nodes.length || page.nodes[ page.nodes.length-1 ].kind !== 'LineEmpty' )
    {
      page.nodes.push( line );
    }
    else
    {
      self._nodeRemove( line );
    }
    lines[ 0 ] += 1;

  }

  /* */

  if( page.nodes.length === 1 )
  if( page.nodes[ 0 ].kind === 'LineEmpty' )
  {
    self._nodeRemove( page.nodes[ 0 ] );
    page.nodes.splice( 0, 1 );
  }

  /* */

  for( let i = page.nodes.length-1 ; i >= 0 ; i-- )
  {
    let node = page.nodes[ i ];
    if( _.longHas( [ 'Directive', 'List' ], node.kind ) )
    {
      let next = page.nodes[ i+1 ];
      if( next )
      {
        if( next.kind === 'Line' && next.raw.trim() === '' )
        page.nodes.splice( i+1, 1 );
      }
      let prev = page.nodes[ i-1 ];
      if( prev )
      {
        if( prev.kind === 'Line' && prev.raw.trim() === '' )
        page.nodes.splice( i-1, 1 );
        i -= 1;
      }
    }
  }

}

//

function pagesNormalize()
{
  let self = this;
  let stack = [];

  for( let p = 0 ; p < self.document.nodes.length ; p++ )
  {
    let page = self.document.nodes[ p ];

    _.assert( page.level >= 1 );

    if( !stack.length )
    {
      stack.push( page );
      continue;
    }

    let last = stack[ stack.length-1 ];
    while( stack.length && last.level <= page.level )
    {
      stack.pop();
      last = stack[ stack.length-1 ];
    }

    if( last )
    {
      last.subPages.push( page );
      // page.supPages.push( last );
    }

    stack.push( page )
  }

  stack = [];
  for( let p = 0 ; p < self.document.nodes.length ; p++ )
  {
    let page = self.document.nodes[ p ];
    stack.push( page );

    do
    {
      let page2 = stack.pop();

      for( let s = 0 ; s < page2.subPages.length ; s++ )
      {
        let sub = page2.subPages[ s ];
        sub.supPages.push( page );
        if( sub.subPages.length )
        stack.push( sub );
      }

    }
    while( stack.length );

  }

}

//

function listParseTry( lines )
{
  let self = this;
  let b = -1;
  let e;
  let list;
  let lists = [];
  let level = -1;
  let comments = [];

  for( e = lines[ 0 ] ; e <= lines[ 1 ] ; e++ )
  {
    let line = self.line[ e ];
    _.assert( _.strIs( line ) );

    if( b !== -1 )
    if( line[ 0 ] === '/' )
    {
      let node = self.commentLineParseTry([ e, e ]);
      if( node )
      {
        comments.push( node );
        continue;
      }
    }

    if( line[ 0 ] === '-' )
    {

      let node = _.stxt.ListNode.construct();
      let levelAndNode = self.ParseLevelAndNode( line, '-' );
      node.level = levelAndNode.level;
      node.nodes = [ self.lineParse( levelAndNode.node, e ) ];
      node.lines = [ e, e ];
      self._nodeAdd( node );

      if( b !== -1 )
      {
        list.nodes.push( node );
      }
      else
      {
        b = e;
        list = _.stxt.List.construct();
        list.nodes = [ node ];
        list.lines = [ b, e ];
        list.comments = comments;
        self._nodeAdd( list );
        lists.push( list );
      }

      level = levelAndNode.level;
    }
    else
    {
      return end();
    }

  }

  return end();

  function end()
  {
    if( b !== -1 )
    {
      list.lines[ 0 ] = b;
      list.lines[ 1 ] = e-1;
      b = -1;
      lines[ 0 ] = e;
    }
    return list;
  }
}

//

function _lineParseTryLabelLike( o )
{
  let self = this;
  let line = self.line[ o.lines[ 0 ] ];

  _.assertRoutineOptions( _lineParseTryLabelLike, o );

  if( o.lines[ 0 ] > o.lines[ 1 ] )
  return;

  let levelAndNode = self.ParseLevelAndNode( line, o.prefix );

  if( !levelAndNode )
  return;

  let node = o.nodeType.construct();
  node.level = levelAndNode.level;
  node.lines = [ o.lines[ 0 ], o.lines[ 0 ] ];
  node.text = self.lineRangeToText( node.lines );
  node.raw = node.text;

  node.properties = _.strStructureParse( levelAndNode.node );
  if( _.strIs( node.properties ) )
  node.properties = { [ node.properties ] : 1 }

  _.assert( _.mapIs( node.properties ), () => `${self.lineRangeToListing( node.lines )}\n\nExpects properties, but it is not map` );
  self._nodeAdd( node );

  o.lines[ 0 ] += 1;

  return node;
}

_lineParseTryLabelLike.defaults =
{
  lines : null,
  prefix : null,
  nodeType : null,
}

//

function directiveParseTry( lines )
{
  let self = this;
  return self._lineParseTryLabelLike
  ({
    lines,
    prefix : '~',
    nodeType : _.stxt.Directive,
  });
}

//

function labelParseTry( lines )
{
  let self = this;
  return self._lineParseTryLabelLike
  ({
    lines,
    prefix : '@',
    nodeType : _.stxt.Label,
  });
}

//

function commentLineParseTry( lines )
{
  let self = this;
  let result = self._lineParseTryLabelLike
  ({
    lines,
    prefix : '/',
    nodeType : _.stxt.CommentLine,
  });
  return result;
}

//

function lineParse( lineRaw, lineNumber )
{
  let self = this;
  let wsplits;

  _.assert( arguments.length === 2 );

  let lines = _.strSplit
  ({
    src : lineRaw,
    delimeter : self.delimeterAny,
    preservingEmpty : 0,
    preservingDelimeters : 1,
    stripping : 0,
  });

  /* adjust lines */

  splitLimited( lines );
  joinCoupled( lines );
  joinEntire( lines );
  refineCoupled( lines );

  /* constructions reduction */

  for( let i = 0 ; i < lines.length ; i++ )
  {
    let line = lines[ i ];

    if( _.strIs( line ) )
    continue;

    let del = line.length === 4 ? line[ 2 ] : line[ 1 ];

    _.strIs( del );
    _.assert( _.arrayIs( line ) );
    _.assert( line.length === 3 || line.length === 4 );

    if( _.longHas( self.delimeterLink, del ) )
    {
      lines[ i ] = self.nodeLinkMakeFromSplits( line, lineNumber );
    }
    else if( _.longHas( self.delimeterProperty, del ) )
    {
      lines[ i ] = self.nodePropertyMakeFromSplits( line, lineNumber );
    }
    else if( _.longHas( self.delimeterLabel, del ) )
    {
      lines[ i ] = self.nodeLabelMakeFromSplits( line, lineNumber );
    }
    else if( _.longHas( self.delimeterComment, del ) )
    {
      lines[ i ] = self.nodeCommentMakeFromSplits( line, lineNumber );
    }
    else _.assert( 0, `Unknown delimeter ${del}` );

  }

  /* span */

  for( let i = lines.length-1 ; i >= 0 ; i-- )
  {
    let line = lines[ i ];

    if( !_.strIs( line ) )
    continue;

    let span = self.nodeSpanMake( line, lineNumber );

    lines[ i ] = span;

  }

  /* */

  let node;

  if( lineRaw.trim() === '' )
  node = _.stxt.LineEmpty.construct();
  else
  node = _.stxt.Line.construct();

  node.lines = [ lineNumber, lineNumber ]; /* xxx : rename */
  node.nodes = lines;
  node.raw = lineRaw ;
  node.text = self.nodesToText( node.nodes );

  self._nodeAdd( node );
  return node;

  /* split limited */

  function splitLimited( splits )
  {

    for( let s = 0 ; s < splits.length-1 ; s++ )
    {
      let split = splits[ s ];
      let splits2 = splits[ s+1 ]

      if( _.longHas( self.delimeterLimited, split ) )
      if( !_.longHas( self.delimeterAny, splits2 ) )
      {
        let ssplit1 = _.strSplitFast
        ({
          src : splits2,
          preservingDelimeters : 0,
          preservingEmpty : 0,
        });
        let ssplit2 = _.strSplitFast
        ({
          src : splits2,
          preservingDelimeters : 1,
          preservingEmpty : 0,
        });
        let first = ssplit2.indexOf( ssplit1[ 0 ] );
        if( ssplit1.length > 1 )
        splits.splice( s+1, 1, ssplit2.slice( 0, first+1 ).join( '' ), ssplit2.slice( first+1 ).join( '' ) );
      }

    }

  }

  /* join coupled */

  function joinCoupled( splits )
  {

    _.strSplitsCoupledGroup
    ({
      splits,
      prefix : self.delimeterOpen,
      postfix : /^<</,
      allowingUncoupledPrefix : 0,
      allowingUncoupledPostfix : 1,
    });

  }

  /* join entire */

  function joinEntire( splits )
  {
    _.assert( wsplits !== splits );
    wsplits = splits;

    for( let s = 0 ; s < splits.length ; s++ )
    {
      let split = splits[ s ];

      if( _.arrayIs( split ) )
      return joinEntire( split );

      _.assert( _.strIs( split ) );

      if( _.regexpsTestAny( self.delimeterEntire, split ) )
      {
        let left = splits.splice( 0, s+1, null );
        splits[ 0 ] = left;
        s = 0;
      }
      else if( s < splits.length-1 && _.regexpsTestAny( self.delimeterLimited, split ) )
      {
        let left = splits[ s-1 ];
        _.assert( _.strIs( left ) );
        left = _.strIsolateRightOrAll( left.trimRight(), ' ' );
        if( left[ 2 ] )
        {
          splits[ s-1 ] = left[ 0 ];
          splits[ s ] = [ left[ 2 ], split ];
        }
        else
        {
          debugger;
          splits[ s ] = [ left[ 2 ], split ];
          splits.splice( s-1, 1 );
        }
      }

    }

    return splits;
  }

  /* refine coupled */

  function refineCoupled( splits )
  {

    for( let s = 0 ; s < splits.length ; s++ )
    {
      let split = splits[ s ];

      if( _.strIs( split ) )
      continue;

      _.assert( _.arrayIs( split ) );

      let del = split[ split.length-1 ];
      let next = splits[ s+1 ];

      if( _.regexpsTestAny( self.delimeterClose, del ) )
      {

        if( s+1 >= splits.length )
        {
          debugger;
          next = null;
        }
        else
        {
          splits.splice( s+1, 1 );
        }

        let first = 0;
        if( _.regexpsTestAny( self.delimeterOpen, split ) )
        first = 1;

        _.assert( next === null || _.strIs( next ) );

        let p = split.splice( first, split.length-1-first, null );
        split[ first ] = p;
        split[ first+2 ] = next === null ? [] : [ next ];

      }

    }

  }

}

//

function lineRangeToText( lines )
{
  let self = this;
  _.assert( _.rangeIs( lines ) );
  return self.line.slice( lines[ 0 ], lines[ 1 ]+1 ).join( '\n' );
}

//

function lineRangeToListing( lines )
{
  let self = this;

  _.assert( _.rangeIs( lines ) );

  let result = _.strLinesSelect
  ({
    src : self.dataStr,
    line : Math.floor( ( lines[ 0 ]+lines[ 1 ] ) / 2 + 1 ),
    numberOfLines : lines[ 1 ] - lines[ 0 ] + 3,
    numbering : 1,
    zeroLine : 1,
  });

  return result;
}

//

function nodesToText( nodes )
{
  let self = this;
  let result = '';

  _.assert( _.arrayIs( nodes ) );

  for( let e = 0 ; e < nodes.length ; e++ )
  {
    let node = nodes[ e ];

    if( _.objectIs( node ) )
    node = node.text;

    _.assert( _.strIs( node ) );

    result += node;

  }

  return result;
}

//

function nodeExportStr( o )
{
  let self = this;
  o.parser = self;
  return _.stxt.nodeExportStr( o );
}

nodeExportStr.defaults =
{
  ... _.mapBut_( null, _.stxt.nodeExportStr.defaults, [ 'parser' ] ),
}

//

function nodeExportHierarchy( o )
{
  let self = this;
  o = _.routineOptions( nodeExportHierarchy, arguments );
  return self.nodeExportStr( o );
}

nodeExportHierarchy.defaults =
{
  ... nodeExportStr.defaults,
  recursive : 2,
  verbosity : 1,
}

//

function nodeExportListing( node )
{
  let self = this;
  _.assert( _.stxt.nodeIs( node ) );
  return self.lineRangeToListing( node.lines );
}

//

function ParseLevelAndNode( lineStr, delimeter )
{
  // if( !_.strBegins( lineStr.trim(), delimeter ) )
  // return;
  //
  // let level = _.strCount( lineStr, delimeter );

  _.assert( arguments.length === 2 );

  lineStr = lineStr.trim();
  let level = 0;
  while( _.strBegins( lineStr, delimeter ) )
  {
    level += 1;
    lineStr = _.strRemoveBegin( lineStr, delimeter );
  }

  if( !level )
  return;

  let result = Object.create( null );
  result.level = level;
  result.node = lineStr.trim();

  return result;
}

//

function nodeLinkMakeFromSplits( lineSplits, lineNumber )
{
  let self = this;
  let link = _.stxt.Link.construct();
  let first = lineSplits.length === 4 ? 1 : 0;

  _.assert( _.arrayIs( lineSplits ) );
  _.assert( lineSplits.length === 3 || lineSplits.length === 4 );
  _.assert( _.arrayIs( lineSplits[ first+0 ] ) );
  _.assert( _.arrayIs( lineSplits[ first+2 ] ) );
  _.assert( lineSplits[ first+2 ].length === 1 );

  link.nodes = _.arrayAppendArrays( [], self.nodeSpanMake( lineSplits[ first+0 ], lineNumber ) );
  link.ref = lineSplits[ first+2 ][ 0 ].trim();
  link.text = self.nodesToText( link.nodes ).trim();
  link.raw = lineSplits.filter( ( e ) => _.strIs( e ) ? e : e.join( ' ' ) ).join( '' );
  link.lines = [ lineNumber, lineNumber ];

  _.sure( _.strIs( link.ref ), 'Expects reference, but got', link.ref );

  self._nodeAdd( link );
  return link;
}

//

function nodePropertyMakeFromSplits( lineSplits, lineNumber )
{
  let self = this;

  let first = lineSplits.length === 4 ? 1 : 0;

  _.assert( _.arrayIs( lineSplits ) );
  _.assert( lineSplits.length === 3 || lineSplits.length === 4 );
  _.assert( _.arrayIs( lineSplits[ first ] ) );
  _.assert( lineSplits[ first ].length === 1 );
  _.assert( _.arrayIs( lineSplits[ first+2 ] ) );
  _.assert( lineSplits[ first+2 ].length === 1 );

  let left = self.nodeSpanMake( lineSplits[ first+0 ][ 0 ], lineNumber );
  let right = _.strStructureParse( lineSplits[ first+2 ][ 0 ] );

  left.properties = right;

  _.sure( _.mapIs( left.properties ) || _.strIs( left.properties ) );

  return left;
}

//

function nodeLabelMakeFromSplits( lineSplits, lineNumber )
{
  let self = this;
  _.assert( 0, 'not implemented' );
}

//

function nodeCommentMakeFromSplits( lineSplits, lineNumber )
{
  let self = this;
  _.assert( 0, 'not implemented' );
}

//

function nodeSpanMake( text, lineIndex )
{
  let self = this;
  let span = _.stxt.Span.construct();

  // if( lineIndex === 0 )
  // debugger;

  if( _.arrayIs( text ) )
  {
    let result = [];
    for( let i = 0 ; i < text.length ; i++ )
    result[ i ] = self.nodeSpanMake( text[ i ], lineIndex );
    return result;
  }

  _.assert( _.strIs( text ) );
  _.assert( _.numberIs( lineIndex ) );
  _.assert( arguments.length === 2 );

  span.text = text;
  span.raw = text;
  span.lines = [ lineIndex, lineIndex ];

  self._nodeAdd( span );
  return span;
}

//

function _nodeAdd( node )
{
  let self = this;

  _.assert( _.stxt.nodeIs( node ) );
  _.assert( _.strIs( node.kind ) );
  _.assert( _.rangeIs( node.lines ) );
  _.assert( node.lines[ 0 ] <= node.lines[ 1 ] );

  self.nodesMap[ node.kind ] = self.nodesMap[ node.kind ] || [];
  _.arrayAppendOnceStrictly( self.nodesMap[ node.kind ], node );

}

//

function _nodeRemove( node )
{
  let self = this;

  _.assert( _.stxt.nodeIs( node ) );

  self.nodesMap[ node.kind ] = self.nodesMap[ node.kind ] || [];
  _.arrayRemoveOnceStrictly( self.nodesMap[ node.kind ], node );

}

// --
// relationship
// --

let delimeterLimited = [ '<<~', '<<-' ];
let delimeterEntire = [ '<~', '<-' ];
let delimeterLink = [ '<<-', '<-' ];
let delimeterProperty = [ '<<~', '<~' ];
let delimeterLabel = [ '<<@', '<@' ];
let delimeterComment = [ '<</', '</' ];
let delimeterClose = _.arrayAppendArrays( [], [ delimeterLink, delimeterProperty, delimeterLabel, delimeterComment ] );
let delimeterOpen = [ '>>' ];
let delimeterAny = _.arrayAppendArrays( [], [ delimeterLink, delimeterProperty, delimeterLabel, delimeterComment, delimeterOpen ] );

let Composes =
{

  dataStr : null,

  delimeterLimited : _.define.own( delimeterLimited ),
  delimeterEntire : _.define.own( delimeterEntire ),
  delimeterLink : _.define.own( delimeterLink ),
  delimeterProperty : _.define.own( delimeterProperty ),
  delimeterLabel : _.define.own( delimeterLabel ),
  delimeterComment : _.define.own( delimeterComment ),
  delimeterClose : _.define.own( delimeterClose ),
  delimeterOpen : _.define.own( delimeterOpen ),
  delimeterAny : _.define.own( delimeterAny ),

}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
  line : null,
  document : null,
  nodesMap : _.define.own({}),
}

let Statics =
{
  ParseLevelAndNode,
}

let Forbids =
{
  page : 'page',
}

// --
// proto
// --

let Proto =
{

  init,
  form,

  linesSplit,
  pagesSplit,

  pagesParse,
  pageParse,

  pagesNormalize,

  listParseTry,

  _lineParseTryLabelLike,
  directiveParseTry,
  labelParseTry,
  commentLineParseTry,
  lineParse,

  lineRangeToText,
  lineRangeToListing,
  nodesToText,
  nodeExportStr,
  nodeExportHierarchy,
  nodeExportListing,

  ParseLevelAndNode,

  nodeLinkMakeFromSplits,
  nodePropertyMakeFromSplits,
  nodeLabelMakeFromSplits,
  nodeCommentMakeFromSplits,
  nodeSpanMake,
  _nodeAdd,
  _nodeRemove,

  //

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

//

_.classDeclare
({
  cls : Self,
  extend : Proto,
  parent : Parent,
});

_.Copyable.mixin( Self );

//

_.stxt[ Self.shortName ] = Self;

})( );
