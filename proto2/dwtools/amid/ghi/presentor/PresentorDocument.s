( function _PresentorDocument_s_( ) {

'use strict';

/*

jmazz.me/slides/2016/10/24/bionode-watermill

*/

let _ = _global_.wTools;
let Parent = null;
let Self = function wPresentorDocument( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'PresentorDocument';

// --
//
// --

function init()
{
  let self = this;

  _.Copyable.prototype.init.apply( self,arguments );

  self.form();
}

//

function form()
{
  let self = this;

  self.linesSplit();
  self.pagesSplit();
  self.pagesParse();

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
  let begin = -1;
  let end = 0;
  let isEmpty = 1;

  self.page = [];

  /* */

  for( end = 0 ; end < self.line.length ; end++ )
  {

    if( self.line[ end ][ 0 ] === '=' )
    {
      if( begin >= 0 )
      writePage();
      begin = end;
      isEmpty = 0;
    }
    else if( self.line[ end ].length )
    {
      isEmpty = 0;
    }

  }

  if( begin >= 0 )
  writePage();

  /* */

  function writePage()
  {
    _.assert( end-begin > 0 );

    let page = Page.constructor();
    page.elements = [];
    page.lines = [ begin,end ];
    page.isEmpty = isEmpty;
    page.number = self.page.length;

    let levelAndElement = self.strLevelAndElementGet( self.line[ begin ], '=' );
    page.level = levelAndElement.level;
    page.head = self.linePrarse( levelAndElement.element, begin );

    self.page.push( page );

  }

}

//

function pagesParse()
{
  let self = this;
  let result = [];
  let list;

  for( let p = 0 ; p < self.page.length ; p++ )
  {
    let page = self.page[ p ];

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

  while( lines[ 0 ] < lines[ 1 ] )
  {

    let list = self.listParseTry( lines );
    if( list )
    {
      page.elements.push( list );
      continue;
    }

    let directive = self.directiveParseTry( lines );
    if( directive )
    {
      page.elements.push( directive );
      continue;
    }

    let lineStr = self.line[ lines[ 0 ] ];
    let elements = self.linePrarse( lineStr, lines[ 0 ] );
    page.elements.push( elements );
    lines[ 0 ] += 1;

  }

  /* */

  let first = page.elements[ 0 ];
  if( first.kind === 'Line' && first.raw.trim() === '' )
  page.elements.splice( 0,1 );

  for( let i = page.elements.length-1 ; i >= 0 ; i-- )
  {
    let element = page.elements[ i ];
    if( _.arrayHas( [ 'Directive', 'List' ], element.kind ) )
    {
      let next = page.elements[ i+1 ];
      if( next )
      {
        if( next.kind === 'Line' && next.raw.trim() === '' )
        page.elements.splice( i+1,1 );
      }
      let prev = page.elements[ i-1 ];
      if( prev )
      {
        if( prev.kind === 'Line' && prev.raw.trim() === '' )
        page.elements.splice( i-1,1 );
        i -= 1;
      }
    }
  }

}

//

function listParseTry( lines )
{
  let self = this;
  let b = -1;
  let list;
  let lists = [];
  let level = -1;

  for( let e = lines[ 0 ] ; e < lines[ 1 ] ; e++ )
  {
    let line = self.line[ e ];

    if( line[ 0 ] === '-' )
    {

      let element = ListElement.constructor();
      let levelAndElement = self.strLevelAndElementGet( line, '-' );
      element.level = levelAndElement.level;
      element.element = self.linePrarse( levelAndElement.element, e );

      if( b !== -1 )
      {
        list.elements.push( element );
      }
      else
      {
        b = e;
        list = List.constructor();
        list.elements = [ element ];
        lists.push( list );
      }

      level = levelAndElement.level;
    }
    else
    {

      if( b !== -1 )
      {
        list.lines = [ b,e ];
        b = -1;
        lines[ 0 ] = e;
      }

      return list;
    }

  }

  if( b !== -1 )
  {
    list.lines = [ b,e ];
    b = -1;
    lines[ 0 ] = e;
  }

  return list;
}

//

function directiveParseTry( lines )
{
  let self = this;
  let line = self.line[ lines[ 0 ] ];

  if( lines[ 0 ] >= lines[ 1 ] )
  return;

  let levelAndElement = self.strLevelAndElementGet( line,'~' );

  if( !levelAndElement )
  return;

  let directive = Directive.constructor();
  directive.level = levelAndElement.level;
  directive.map = _.strParseMap( levelAndElement.element );

  lines[ 0 ] += 1;

  return directive;
}

//

let delimeterLimited = [ '<<~', '<<-' ];
let delimeterEntire = [ '<~', '<-' ];
let delimeterLink = [ '<<-', '<-' ];
let delimeterProperty = [ '<<~', '<~' ];
let delimeterClose = _.arrayAppendArrays( [], [ delimeterProperty, delimeterLink ] );
let delimeterOpen = [ '>>' ];
let delimeter = _.arrayAppendArrays( [], [ delimeterProperty, delimeterLink, delimeterOpen ] );

function linePrarse( lineRaw, lineNumber )
{
  let self = this;
  let wsplits;

  _.assert( arguments.length === 2 );

  let splits = _.strSplit
  ({
    src : lineRaw,
    delimeter : delimeter,
    preservingEmpty : 0,
    preservingDelimeters : 1,
    stripping : 0,
  });

  /* join >> */

  joinCoupled( splits );
  joinEntire( splits );
  refineCoupled( splits );

  /* constructions reduction */

  for( let i = 0 ; i < splits.length ; i++ )
  {
    let split = splits[ i ];

    if( _.strIs( split ) )
    continue;

    _.assert( _.arrayIs( split ) );
    _.assert( split.length === 3 );

    if( _.arrayHas( delimeterLink, split[ 1 ] ) )
    {

      i = linkHandle( split, i );

    }
    else if( _.arrayHas( delimeterProperty, split[ 1 ] ) )
    {

      i = propertyHandle( split, i );

    }
    else _.assert( 0,'not implemented' );

  }

  /* span */

  for( let i = splits.length-1 ; i >= 0 ; i-- )
  {
    let split = splits[ i ];

    if( !_.strIs( split ) )
    continue;

    let span = self.makeSpan( split, [ lineNumber,lineNumber+1 ] );

    splits[ i ] = span;

  }

  /* */

  let l = Line.constructor();

  l.raw = lineRaw;
  l.lines = [ lineNumber,lineNumber+1 ];
  l.elements = splits;
  l.text = self.textFor( l.elements );

  return l;

  /* sentiment */

  function sentimentHandle( i )
  {

    throw _.err( 'not implemented' );

    let prevElement = splits[ i-1 ];
    let sentiment = Sentiment.constructor();
    sentiment.element = prevElement;
    sentiment.sentiment = 'strong';
    splits.splice( i-1, 2, sentiment );
    i -= 1;

    if( !prevElement )
    throw _.err( 'expected element before',element );
    if( delimeter.indexOf( prevElement ) !== -1 )
    throw _.err( 'expected not delimeter, but got',prevElement );

    return i;
  }

  /* link */

  function linkHandle( linkSplits, splitIndex )
  {
    let link = self.Link.constructor();

    _.assert( _.arrayIs( linkSplits ) );
    _.assert( linkSplits.length === 3 );
    _.assert( _.arrayIs( linkSplits[ 0 ] ) );
    _.assert( _.arrayIs( linkSplits[ 2 ] ) );
    _.assert( linkSplits[ 2 ].length === 1 );

    link.elements = _.arrayAppendArrays( [], self.makeSpan( linkSplits[ 0 ], [ lineNumber, lineNumber+1 ] ) );
    link.ref = linkSplits[ 2 ][ 0 ];
    link.text = self.textFor( link.elements );

    splits[ splitIndex ] = link;

    _.sure( _.strIs( link.ref ), 'Expects reference, but got', link.ref );

    return splitIndex;
  }

  /* link */

  function propertyHandle( propertySplits, splitIndex )
  {

    _.assert( _.arrayIs( propertySplits ) );
    _.assert( propertySplits.length === 3 );
    _.assert( _.arrayIs( propertySplits[ 0 ] ) );
    _.assert( propertySplits[ 0 ].length === 1 );
    _.assert( _.arrayIs( propertySplits[ 2 ] ) );
    _.assert( propertySplits[ 2 ].length === 1 );

    let left = self.makeSpan( propertySplits[ 0 ][ 0 ], [ splitIndex, splitIndex+1 ] );
    let right = _.strParseMap( propertySplits[ 2 ][ 0 ] );

    left.properties = right;

    _.sure( _.mapIs( left.properties ) );

    splits[ splitIndex ] = left;

    return splitIndex;
  }

  /* join coupled */

  function joinCoupled( splits )
  {

    _.strSplitsGroupCoupled
    ({
      splits : splits,
      prefix : delimeterOpen,
      postfix : /^<</,
      allowedUncoupledPrefix : 0,
      allowedUncoupledPostfix : 1,
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

      if( _.regexpsTestAny( delimeterEntire, split ) )
      {
        let left = splits.splice( 0, s+1, null );
        splits[ 0 ] = left;
        s = 0;
      }
      else if( s < splits.length-1 && _.regexpsTestAny( delimeterLimited, split ) )
      {
        //debugger;
        let left = splits[ s-1 ];
        _.assert( _.strIs( left ) );
        left = _.strIsolateEndOrAll( left.trimRight(), ' ' );
        if( left[ 2 ] )
        {
          //debugger;
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

      if( _.regexpsTestAny( delimeterClose, del ) )
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

        if( _.regexpsTestAny( delimeterOpen, split ) )
        split.splice( 0,1 );

        _.assert( next === null || _.strIs( next ) );

        let p = split.splice( 0, split.length-1, null );
        split[ 0 ] = p;
        split[ 2 ] = next === null ? [] : [ next ];

      }

    }

  }

}

// function linePrarse( lineRaw, lineNumber )
// {
//   let self = this;
//   // let delimeter = [ '->>>','<<<-','->>','<<-','!>>','<<!','>>','<<',' ' ];
//   let delimeter = [ '<<<-','<<-','!>>','<<!','>>','<<',' ' ];
//
//   _.assert( arguments.length === 2 );
//
//   let result = _.strSplit
//   ({
//     src : lineRaw,
//     delimeter : delimeter,
//     preservingEmpty : 0,
//     preservingDelimeters : 1,
//     stripping : 0,
//   });
//
//   /* spaces reduction */
//
//   debugger;
//
//   let s = '';
//   let prevIndex = -1;
//   for( let i = result.length-1 ; i >= 0 ; i-- )
//   {
//
//     let element = result[ i ];
//     let isEmpty = element.trim() === '';
//     if( isEmpty )
//     {
//       s += element;
//       result.splice( i,1 );
//       prevIndex -= 1;
//       continue;
//     }
//     else if( s )
//     {
//       if( delimeter.indexOf( element ) === -1 )
//       result[ i ] = result[ i ] + s;
//       else if( prevIndex >= 0 )
//       result[ prevIndex ] = s + result[ prevIndex ];
//       s = '';
//     }
//
//     if( !isEmpty )
//     {
//       if( delimeter.indexOf( element ) === -1 )
//       prevIndex = i;
//       else
//       prevIndex = -1;
//     }
//
//   }
//
//   debugger;
//   if( s )
//   debugger;
//
//   if( s )
//   result.unshift( s );
//
//   /* join >> */
//
//   let begin = -1;
//   for( let i = 0 ; i < result.length ; i++ )
//   {
//     let element = result[ i ];
//
//     if( element === '>>' )
//     {
//       if( begin >= 0 )
//       throw _.err( '>> without << in a line :\n' + lineRaw );
//       begin = i;
//     }
//     else if( _.strBegins( element,'<<' ) && begin >= 0 )
//     {
//       let element = result.slice( begin+1,i ).join( '' );
//       result.splice( begin,i-begin,element );
//       begin = -1;
//       i = begin+1;
//     }
//
//   }
//
//   if( begin >= 0 )
//   throw _.err( '>> without << in a line :\n' + lineRaw );
//
//   /* constructions reduction */
//
//   for( let i = 0 ; i < result.length ; i++ )
//   {
//     let element = result[ i ];
//
//     if( delimeter.indexOf( element ) === -1 )
//     {
//     }
//     else if( element === '<<-' || element === '<<<-' )
//     {
//
//       let prevElements = element === '<<-' ? [ result[ i-1 ] ] : result.slice( 0,i );
//
//       prevElements = joinWords( prevElements );
//
//       let link = Link.constructor();
//       link.elements = prevElements;
//       link.ref = result[ i+1 ].trim();
//       link.text = self.textFor( link.elements );
//
//       if( element === '<<-' )
//       {
//         _.arrayCutin( result,[ i-1,i+2 ],[ link ] );
//         i -= 2;
//       }
//       else
//       {
//         _.arrayCutin( result,[ 0,i+2 ],[ link ] );
//         i = 1;
//       }
//
//       if( prevElements.length === 0 )
//       throw _.err( 'expected elements before',element );
//       if( prevElements.length === 1 )
//       if( !prevElements[ 0 ] )
//       throw _.err( 'expected element before',element );
//       if( prevElements.length > 0 )
//       if( delimeter.indexOf( prevElements[ prevElements.length-1 ] ) !== -1 )
//       throw _.err( 'expected not delimeter, but got',prevElements[ prevElements.length-1 ] );
//
//     }
//     else if( element === '<<!' )
//     {
//       let prevElement = result[ i-1 ];
//       let sentiment = Sentiment.constructor();
//       sentiment.element = prevElement;
//       sentiment.sentiment = 'strong';
//       result.splice( i-1,2,sentiment );
//       i -= 1;
//
//       if( !prevElement )
//       throw _.err( 'expected element before',element );
//       if( delimeter.indexOf( prevElement ) !== -1 )
//       throw _.err( 'expected not delimeter, but got',prevElement );
//     }
//     else _.assert( 0,'not implemented' );
//
//   }
//
//   /* join */
//
//   for( let i = result.length-1 ; i >= 0 ; i-- )
//   {
//     let element = result[ i ];
//     let prevElement = result[ i-1 ];
//
//     if( _.strIs( prevElement ) && _.strIs( element ) )
//     {
//       result[ i-1 ] = prevElement + ' ' + element;
//       result.splice( i,1 );
//     }
//
//   }
//
//   /* span */
//
//   for( let i = result.length-1 ; i >= 0 ; i-- )
//   {
//     let element = result[ i ];
//
//     if( !_.strIs( element ) )
//     continue;
//
//     let span = self.makeSpan( element );
//     span.lines = [ lineNumber,lineNumber+1 ];
//
//     result[ i ] = span;
//
//   }
//
//   /* */
//
//   let l = Line.constructor();
//
//   l.raw = lineRaw;
//   l.lines = [ lineNumber,lineNumber+1 ];
//   l.elements = result;
//   l.text = self.textFor( l.elements );
//
//   return l;
//
//   /* join words */
//
//   function joinWords( dst )
//   {
//
//     let s = '';
//     for( let i = dst.length-1 ; i >= 0 ; i-- )
//     {
//
//       let element = dst[ i ];
//       let isOrdinary = _.strIs( element ) && delimeter.indexOf( element ) === -1;
//       if( isOrdinary )
//       {
//         s = element + s;
//         dst.splice( i,1 );
//         continue;
//       }
//       else if( s )
//       {
//         dst.splice( i+1,s );
//         s = '';
//       }
//
//     }
//
//     if( s )
//     {
//       dst.unshift( s );
//       s = '';
//     }
//
//     for( let i = dst.length-1 ; i >= 0 ; i-- )
//     {
//       if( _.strIs( dst[ i ] ) )
//       dst[ i ] = self.makeSpan( dst[ i ] );
//       dst[ i ].lines = [ lineNumber,lineNumber+1 ];
//     }
//
//     return dst;
//   }
//
// }

//

function textFor( elements )
{
  let self = this;
  let result = '';

  _.assert( _.arrayIs( elements ) );

  for( let e = 0 ; e < elements.length ; e++ )
  {
    let element = elements[ e ];

    if( _.objectIs( element ) )
    element = element.text;

    _.assert( _.strIs( element ) );

    result += element;

  }

  return result;
}

//

function strLevelAndElementGet( lineStr, delimeter )
{
  let level = _.strCountLeft( lineStr, delimeter );

  _.assert( arguments.length === 2 );

  if( !level )
  return;

  let result = Object.create( null );
  result.level = level;
  result.element = _.strStrip( lineStr.substring( result.level ) );

  return result;
}

//

function makeSpan( text, lines )
{
  let self = this;
  let span = self.Span.constructor();

  if( _.arrayIs( text ) )
  {
    let result = [];
    for( let i = 0 ; i < text.length ; i++ )
    result[ i ] = self.makeSpan( text[ i ], lines );
    return result;
  }

  _.assert( _.strIs( text ) );
  _.assert( _.arrayIs( lines ) );
  _.assert( arguments.length === 2 );

  span.text = text;
  span.raw = text;
  span.lines = lines;

  return span;
}

// --
// structure
// --

let Page = _.like()
.also
({
  kind : 'Page',
  head : null,
  lines : null,
  elements : null,
  isEmpty : 0,
  level : -1,
  number : -1,
})
.end

let PageElement = _.like()
.also
({
  kind : 'Element',
  text : null,
  raw : null,
  lines : null,
  properties : null,
})
.end

let Span = _.like( PageElement )
.also
({
  kind : 'Span',
})
.end

let Line = _.like( PageElement )
.also
({
  kind : 'Line',
  elements : null,
})
.end

/* */

let List = _.like( PageElement )
.also
({
  kind : 'List',
  elements : null,
  lines : null,
})
.end

let ListElement = _.like( PageElement )
.also
({
  kind : 'ListElement',
  element : null,
  level : -1,
})
.end

let Directive = _.like( PageElement )
.also
({
  kind : 'Directive',
  map : null,
  level : -1,
})
.end

let Link = _.like( PageElement )
.also
({
  kind : 'Link',
  ref : null,
  elements : null,
})
.end

let Sentiment = _.like( PageElement )
.also
({
  kind : 'Sentiment',
  sentiment : null,
  element : null,
})
.end

// --
// relationship
// --

let Composes =
{
  dataStr : null,
  line : null,
  page : null,
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{

  Page : Page,
  PageElement : PageElement,

  Span : Span,
  Line : Line,
  List : List,
  ListElement : ListElement,
  Directive : Directive,
  Link : Link,
  Sentiment : Sentiment,

}

// --
// proto
// --

let Proto =
{

  init : init,
  form : form,

  linesSplit : linesSplit,
  pagesSplit : pagesSplit,

  pagesParse : pagesParse,
  pageParse : pageParse,

  listParseTry : listParseTry,
  directiveParseTry : directiveParseTry,
  linePrarse : linePrarse,

  textFor : textFor,

  strLevelAndElementGet : strLevelAndElementGet,

  makeSpan : makeSpan,

  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

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

_global_[ Self.name ] = _[ Self.shortName ] = Self;

})( );
